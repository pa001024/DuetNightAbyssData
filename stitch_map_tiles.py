import argparse
import json
import math
import re
from pathlib import Path
from typing import List, Optional, Sequence, Tuple

try:
    from PIL import Image
except ImportError as exc:
    raise SystemExit(
        "缺少依赖 Pillow。请先执行: python -m pip install pillow"
    ) from exc


IndexAndPath = Tuple[int, Path]
EdgePixels = List[Tuple[int, int, int, int]]
Placement = Tuple[int, int, Path]
GridBounds = Tuple[int, int, int, int]


def _extract_index(path: Path) -> Optional[int]:
    """从文件名末尾提取数字序号（如 *_123.png -> 123）。"""
    match = re.search(r"_(\d+)\.[^.]+$", path.name)
    if not match:
        return None
    return int(match.group(1))


def _collect_tiles(input_dir: Path, pattern: str) -> List[IndexAndPath]:
    """收集并按序号升序排序切图文件。"""
    result: List[IndexAndPath] = []
    for file_path in input_dir.glob(pattern):
        index = _extract_index(file_path)
        if index is None:
            continue
        result.append((index, file_path))
    result.sort(key=lambda item: item[0])
    return result


def _tail_object_name(object_name: Optional[str]) -> Optional[str]:
    """把 UE ObjectName 转成末尾 Name（如 Main.UniformGridSlot_0 -> UniformGridSlot_0）。"""
    if not object_name:
        return None
    return object_name.split(".")[-1].strip("'")


def _extract_quoted_name(raw: Optional[str]) -> Optional[str]:
    """从 Texture2D'Xxx' 里取 Xxx。"""
    if not raw:
        return None
    match = re.search(r"'([^']+)'", raw)
    if not match:
        return None
    return match.group(1)


def _extract_alpha(value) -> Optional[float]:
    """从 UE 颜色字段中提取 Alpha。"""
    if value is None:
        return None
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, dict):
        if "A" in value and isinstance(value["A"], (int, float)):
            return float(value["A"])
        specified = value.get("SpecifiedColor")
        if isinstance(specified, dict) and "A" in specified and isinstance(specified["A"], (int, float)):
            return float(specified["A"])
    return None


def _is_image_hidden(image_obj: dict) -> bool:
    """
    判断一个 Image 是否在 UI 中被隐藏（透明）。
    命中任一规则即视为隐藏:
    - RenderOpacity <= 0
    - ColorAndOpacity.A <= 0
    - Brush.TintColor.A <= 0
    """
    props = image_obj.get("Properties", {})

    render_opacity = props.get("RenderOpacity")
    if isinstance(render_opacity, (int, float)) and float(render_opacity) <= 0.0:
        return True

    color_alpha = _extract_alpha(props.get("ColorAndOpacity"))
    if color_alpha is not None and color_alpha <= 0.0:
        return True

    brush_tint_alpha = _extract_alpha(props.get("Brush", {}).get("TintColor"))
    if brush_tint_alpha is not None and brush_tint_alpha <= 0.0:
        return True

    return False


def _parse_layout_placements(
    layout_json_path: Path,
    grid_name: str,
    tile_path_by_stem: dict,
) -> Tuple[List[Placement], int, Optional[GridBounds]]:
    """
    从 UMG JSON 中读取 UniformGridPanel 的 Slots 顺序与 Row/Column，构造拼接坐标。

    返回:
    - placements: [(row, col, tile_path), ...]，顺序与 Slots 一致
    - slot_count: UniformGridPanel 的槽位总数
    """
    try:
        raw = json.loads(layout_json_path.read_text(encoding="utf-8"))
    except Exception as exc:
        raise SystemExit(f"读取布局 JSON 失败: {layout_json_path} / {exc}") from exc

    if not isinstance(raw, list):
        raise SystemExit(f"布局 JSON 顶层不是数组: {layout_json_path}")

    name_map = {}
    for obj in raw:
        if isinstance(obj, dict) and "Name" in obj:
            name_map[obj["Name"]] = obj

    grid_obj = None
    for obj in raw:
        if not isinstance(obj, dict):
            continue
        if obj.get("Type") == "UniformGridPanel" and obj.get("Name") == grid_name:
            grid_obj = obj
            break
    if grid_obj is None:
        for obj in raw:
            if isinstance(obj, dict) and obj.get("Type") == "UniformGridPanel":
                grid_obj = obj
                break
    if grid_obj is None:
        raise SystemExit(f"布局 JSON 中未找到 UniformGridPanel: {layout_json_path}")

    slots = grid_obj.get("Properties", {}).get("Slots", [])
    if not isinstance(slots, list):
        raise SystemExit(f"UniformGridPanel Slots 不是数组: {layout_json_path}")

    placements: List[Placement] = []
    missing_tiles: List[str] = []
    slot_rows: List[int] = []
    slot_cols: List[int] = []

    for slot_ref in slots:
        if not isinstance(slot_ref, dict):
            continue
        slot_name = _tail_object_name(slot_ref.get("ObjectName"))
        if not slot_name:
            continue
        slot_obj = name_map.get(slot_name)
        if not slot_obj:
            continue
        slot_props = slot_obj.get("Properties", {})

        row = slot_props.get("Row", 0)
        col = slot_props.get("Column", 0)
        if row is None:
            row = 0
        if col is None:
            col = 0
        try:
            row = int(row)
            col = int(col)
        except Exception:
            continue
        slot_rows.append(row)
        slot_cols.append(col)

        content_ref = slot_props.get("Content", {})
        if not isinstance(content_ref, dict):
            continue
        content_name = _tail_object_name(content_ref.get("ObjectName"))
        if not content_name:
            continue
        content_obj = name_map.get(content_name)
        if not content_obj or content_obj.get("Type") != "Image":
            continue
        if _is_image_hidden(content_obj):
            continue

        brush = content_obj.get("Properties", {}).get("Brush", {})
        resource_object = brush.get("ResourceObject", {})
        resource_name = None
        if isinstance(resource_object, dict):
            resource_name = _extract_quoted_name(resource_object.get("ObjectName"))
        if not resource_name:
            continue

        tile_path = tile_path_by_stem.get(resource_name)
        if tile_path is None:
            missing_tiles.append(resource_name)
            continue
        placements.append((row, col, tile_path))

    if missing_tiles:
        # 仅提示前若干个，避免刷屏
        preview = ", ".join(sorted(set(missing_tiles))[:8])
        print(f"警告: 布局中有 {len(missing_tiles)} 个贴图在输入目录找不到，示例: {preview}", flush=True)

    grid_bounds: Optional[GridBounds] = None
    if slot_rows and slot_cols:
        grid_bounds = (min(slot_rows), max(slot_rows), min(slot_cols), max(slot_cols))
    return placements, len(slots), grid_bounds


def _extract_edges(image: Image.Image, sample_step: int = 2) -> Tuple[EdgePixels, EdgePixels, EdgePixels, EdgePixels]:
    """提取四条边像素，用于估算相邻切图是否平滑衔接。"""
    rgba = image.convert("RGBA")
    width, height = rgba.size

    left: EdgePixels = []
    right: EdgePixels = []
    for y in range(0, height, sample_step):
        left.append(rgba.getpixel((0, y)))
        right.append(rgba.getpixel((width - 1, y)))

    top: EdgePixels = []
    bottom: EdgePixels = []
    for x in range(0, width, sample_step):
        top.append(rgba.getpixel((x, 0)))
        bottom.append(rgba.getpixel((x, height - 1)))

    return left, right, top, bottom


def _edge_diff(edge_a: Sequence[Tuple[int, int, int, int]], edge_b: Sequence[Tuple[int, int, int, int]]) -> float:
    """计算两条边的加权差值（越小越可能是正确相邻）。"""
    total = 0.0
    weight_sum = 0.0
    for pixel_a, pixel_b in zip(edge_a, edge_b):
        alpha_weight = pixel_a[3] + pixel_b[3]
        if alpha_weight == 0:
            continue
        rgb_diff = (
            abs(pixel_a[0] - pixel_b[0])
            + abs(pixel_a[1] - pixel_b[1])
            + abs(pixel_a[2] - pixel_b[2])
        )
        alpha_diff = abs(pixel_a[3] - pixel_b[3]) * 0.125
        total += (rgb_diff + alpha_diff) * alpha_weight
        weight_sum += alpha_weight
    if weight_sum == 0:
        return 0.0
    return total / weight_sum


def _score_column_count(tile_paths: Sequence[Path], columns: int, sample_step: int = 2) -> float:
    """在“按序号行优先排布”的前提下，计算给定列数的拼接平滑度分数。"""
    rows = math.ceil(len(tile_paths) / columns)
    if rows <= 0:
        return float("inf")

    # 预提取边像素，避免重复读图
    edges: List[Tuple[EdgePixels, EdgePixels, EdgePixels, EdgePixels]] = []
    for tile_path in tile_paths:
        with Image.open(tile_path) as image:
            edges.append(_extract_edges(image, sample_step=sample_step))

    score_sum = 0.0
    score_count = 0

    for idx in range(len(tile_paths)):
        # 横向相邻
        if (idx + 1) % columns != 0 and idx + 1 < len(tile_paths):
            _, right_a, _, _ = edges[idx]
            left_b, _, _, _ = edges[idx + 1]
            score_sum += _edge_diff(right_a, left_b)
            score_count += 1

        # 纵向相邻
        down_idx = idx + columns
        if down_idx < len(tile_paths):
            _, _, _, bottom_a = edges[idx]
            _, _, top_b, _ = edges[down_idx]
            score_sum += _edge_diff(bottom_a, top_b)
            score_count += 1

    if score_count == 0:
        return float("inf")
    return score_sum / score_count


def _auto_detect_columns(tile_paths: Sequence[Path], min_cols: int, max_cols: int) -> int:
    """自动推断最可能的列数。"""
    count = len(tile_paths)
    if count <= 1:
        return 1

    min_cols = max(1, min_cols)
    max_cols = max(min_cols, min(max_cols, count))

    best_cols = min_cols
    best_score = float("inf")

    for cols in range(min_cols, max_cols + 1):
        score = _score_column_count(tile_paths, cols)
        if score < best_score:
            best_score = score
            best_cols = cols

    return best_cols


def stitch_tiles(
    tile_paths: Sequence[Path],
    output_path: Path,
    columns: int,
    trim_transparent: bool = False,
) -> Tuple[int, int]:
    """按给定列数行优先拼接切图。"""
    if not tile_paths:
        raise ValueError("没有可拼接的图片文件。")

    with Image.open(tile_paths[0]) as first_tile:
        tile_width, tile_height = first_tile.size

    rows = math.ceil(len(tile_paths) / columns)
    canvas = Image.new("RGBA", (columns * tile_width, rows * tile_height), (0, 0, 0, 0))

    for idx, tile_path in enumerate(tile_paths):
        col = idx % columns
        row = idx // columns
        with Image.open(tile_path) as tile:
            rgba_tile = tile.convert("RGBA")
            canvas.paste(rgba_tile, (col * tile_width, row * tile_height), rgba_tile)

    if trim_transparent:
        bbox = canvas.getbbox()
        if bbox is not None:
            canvas = canvas.crop(bbox)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(output_path)
    return canvas.size


def stitch_tiles_by_positions(
    placements: Sequence[Placement],
    output_path: Path,
    trim_transparent: bool = False,
    keep_grid_origin: bool = False,
    forced_grid_bounds: Optional[GridBounds] = None,
) -> Tuple[int, int]:
    """按显式网格坐标拼接切图。"""
    if not placements:
        raise ValueError("布局模式下没有可拼接的贴图。")

    with Image.open(placements[0][2]) as first_tile:
        tile_width, tile_height = first_tile.size

    if forced_grid_bounds is not None:
        min_row, max_row, min_col, max_col = forced_grid_bounds
    else:
        rows = [row for row, _, _ in placements]
        cols = [col for _, col, _ in placements]
        min_row, max_row = min(rows), max(rows)
        min_col, max_col = min(cols), max(cols)

    base_row = 0 if keep_grid_origin else min_row
    base_col = 0 if keep_grid_origin else min_col

    canvas = Image.new(
        "RGBA",
        ((max_col - base_col + 1) * tile_width, (max_row - base_row + 1) * tile_height),
        (0, 0, 0, 0),
    )

    for row, col, tile_path in placements:
        x = (col - base_col) * tile_width
        y = (row - base_row) * tile_height
        with Image.open(tile_path) as tile:
            rgba_tile = tile.convert("RGBA")
            canvas.paste(rgba_tile, (x, y), rgba_tile)

    if trim_transparent:
        bbox = canvas.getbbox()
        if bbox is not None:
            canvas = canvas.crop(bbox)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(output_path)
    return canvas.size


def main() -> None:
    parser = argparse.ArgumentParser(
        description="拼接地图切图（支持按文件名排序，或按 UMG UniformGridPanel Slots 布局）"
    )
    parser.add_argument("input_dir", help="切图目录，例如: D:/.../Map/East/Yanjindu/L0")
    parser.add_argument(
        "-o",
        "--output",
        default="stitched_map.png",
        help="输出文件路径（默认: 当前目录 stitched_map.png）",
    )
    parser.add_argument("--pattern", default="*.png", help="切图匹配模式（默认: *.png）")
    parser.add_argument(
        "--layout-json",
        default="",
        help="UMG 导出的布局 JSON；传入后优先按 UniformGridPanel Slots + Row/Column 拼接",
    )
    parser.add_argument(
        "--grid-name",
        default="Main",
        help="布局 JSON 里 UniformGridPanel 名称（默认: Main）",
    )
    parser.add_argument(
        "--cols",
        type=int,
        default=0,
        help="指定列数；不传则自动估算",
    )
    parser.add_argument(
        "--min-cols",
        type=int,
        default=2,
        help="自动估算列数时的最小列数（默认: 2）",
    )
    parser.add_argument(
        "--max-cols",
        type=int,
        default=24,
        help="自动估算列数时的最大列数（默认: 24）",
    )
    parser.add_argument(
        "--trim",
        action="store_true",
        help="裁掉外围全透明边缘",
    )
    parser.add_argument(
        "--keep-grid-origin",
        action="store_true",
        help="布局模式下保留 UniformGrid 的绝对 Row/Column 原点，不做最小行列平移",
    )

    args = parser.parse_args()

    input_dir = Path(args.input_dir)
    if not input_dir.is_dir():
        raise SystemExit(f"输入目录不存在: {input_dir}")

    indexed_tiles = _collect_tiles(input_dir, args.pattern)
    if not indexed_tiles:
        raise SystemExit(f"目录下未找到符合规则的图片: {input_dir} / {args.pattern}")

    tile_paths = [path for _, path in indexed_tiles]
    tile_path_by_stem = {path.stem: path for path in tile_paths}

    output_path = Path(args.output)
    if args.layout_json:
        layout_json_path = Path(args.layout_json)
        if not layout_json_path.is_file():
            raise SystemExit(f"布局 JSON 不存在: {layout_json_path}")
        placements, slot_count, grid_bounds = _parse_layout_placements(
            layout_json_path=layout_json_path,
            grid_name=args.grid_name,
            tile_path_by_stem=tile_path_by_stem,
        )
        print(
            f"布局模式: {layout_json_path.name} / Grid={args.grid_name} / Slots={slot_count} / 可用图片={len(placements)}",
            flush=True,
        )
        width, height = stitch_tiles_by_positions(
            placements=placements,
            output_path=output_path,
            trim_transparent=args.trim,
            keep_grid_origin=args.keep_grid_origin,
            forced_grid_bounds=grid_bounds,
        )
    else:
        if args.cols and args.cols > 0:
            columns = args.cols
            print(f"使用手动列数: {columns}", flush=True)
        else:
            columns = _auto_detect_columns(tile_paths, args.min_cols, args.max_cols)
            print(
                f"自动估算列数: {columns}（搜索范围 {args.min_cols}~{args.max_cols}）",
                flush=True,
            )
        width, height = stitch_tiles(
            tile_paths=tile_paths,
            output_path=output_path,
            columns=columns,
            trim_transparent=args.trim,
        )

    print(f"切图数量: {len(tile_paths)}", flush=True)
    print(f"输出文件: {output_path.resolve()}", flush=True)
    print(f"输出尺寸: {width} x {height}", flush=True)


if __name__ == "__main__":
    main()
