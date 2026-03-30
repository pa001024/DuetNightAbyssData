import argparse
import json
import re
import shutil
from pathlib import Path
from typing import List, Optional

from stitch_map_tiles import _collect_tiles, _parse_layout_placements, stitch_tiles_by_positions


def extract_texture_input_dir(layout_json_path: Path, texture_root: Path) -> Optional[Path]:
    """
    从布局 JSON 中提取第一张 Image 的贴图目录。
    期望 ObjectPath 格式:
    EM/Content/UI/Texture/Static/Image/Map/<Region>/<Name>/<Level>/<Texture>.0
    """
    try:
        data = json.loads(layout_json_path.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"[SKIP] JSON 解析失败: {layout_json_path} / {exc}", flush=True)
        return None

    if not isinstance(data, list):
        print(f"[SKIP] JSON 顶层不是数组: {layout_json_path}", flush=True)
        return None

    object_path = None
    for obj in data:
        if not isinstance(obj, dict):
            continue
        if obj.get("Type") != "Image":
            continue
        props = obj.get("Properties", {})
        brush = props.get("Brush", {})
        res_obj = brush.get("ResourceObject", {})
        if isinstance(res_obj, dict):
            object_path = res_obj.get("ObjectPath")
        if object_path:
            break

    if not object_path:
        print(f"[SKIP] 未找到 Image.ResourceObject.ObjectPath: {layout_json_path}", flush=True)
        return None

    object_path = re.sub(r"\.[0-9]+$", "", object_path)
    match = re.match(r"^(EM/Content/UI/Texture/Static/Image/Map/.+)$", object_path)
    if not match:
        print(f"[SKIP] 非地图贴图路径: {layout_json_path} / {object_path}", flush=True)
        return None

    texture_rel = Path(match.group(1))
    input_dir = texture_root / texture_rel.parent
    if not input_dir.is_dir():
        print(f"[SKIP] 贴图目录不存在: {input_dir}", flush=True)
        return None
    return input_dir


def extract_image_resource_stems(layout_json_path: Path) -> List[str]:
    """提取 JSON 中所有 Image 引用的 Texture 资源名（不含 Texture2D' 包裹）。"""
    try:
        data = json.loads(layout_json_path.read_text(encoding="utf-8"))
    except Exception:
        return []
    if not isinstance(data, list):
        return []

    stems: List[str] = []
    seen = set()
    for obj in data:
        if not isinstance(obj, dict):
            continue
        if obj.get("Type") != "Image":
            continue
        res_obj = (
            obj.get("Properties", {})
            .get("Brush", {})
            .get("ResourceObject", {})
        )
        object_name = res_obj.get("ObjectName") if isinstance(res_obj, dict) else None
        match = re.search(r"'([^']+)'", object_name or "")
        if not match:
            continue
        stem = match.group(1)
        if stem in seen:
            continue
        seen.add(stem)
        stems.append(stem)
    return stems


def main() -> None:
    parser = argparse.ArgumentParser(description="批量导出 Map_Splice 目录中的所有地图")
    parser.add_argument(
        "--splice-dir",
        default=r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\WBP\Map\Widget\Map_Splice",
        help="Map_Splice 根目录",
    )
    parser.add_argument(
        "--texture-root",
        default=r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\Texture\Static\Image\Map",
        help="地图贴图根目录",
    )
    parser.add_argument(
        "--output-root",
        default="out/map_splice",
        help="输出目录（会保留 Map_Splice 下的相对目录结构）",
    )
    parser.add_argument("--grid-name", default="Main", help="UniformGridPanel 名称，默认 Main")

    args = parser.parse_args()

    splice_dir = Path(args.splice_dir)
    texture_root = Path(args.texture_root)
    output_root = Path(args.output_root)
    output_root.mkdir(parents=True, exist_ok=True)

    if not splice_dir.is_dir():
        raise SystemExit(f"Map_Splice 目录不存在: {splice_dir}")
    if not texture_root.is_dir():
        raise SystemExit(f"贴图根目录不存在: {texture_root}")

    json_files = sorted(splice_dir.rglob("*.json"))
    total = len(json_files)
    ok = 0
    skip = 0
    fail = 0

    print(f"[INFO] 扫描目录: {splice_dir}", flush=True)
    print(f"[INFO] 输出目录: {output_root.resolve()}", flush=True)

    for layout_json in json_files:
        rel_json = layout_json.relative_to(splice_dir)
        print(f"[RUN ] {rel_json}", flush=True)

        input_dir = extract_texture_input_dir(layout_json, texture_root)
        if input_dir is None:
            skip += 1
            continue

        indexed_tiles = _collect_tiles(input_dir, "*.png")
        if not indexed_tiles:
            print(f"[SKIP] 未找到 png 贴图: {input_dir}", flush=True)
            skip += 1
            continue

        tile_paths = [path for _, path in indexed_tiles]
        tile_path_by_stem = {path.stem: path for path in tile_paths}

        try:
            placements, slot_count, grid_bounds = _parse_layout_placements(
                layout_json_path=layout_json,
                grid_name=args.grid_name,
                tile_path_by_stem=tile_path_by_stem,
            )
            if not placements:
                print(f"[SKIP] 布局中没有可用贴图: {layout_json}", flush=True)
                skip += 1
                continue

            out_file = (output_root / rel_json).with_suffix(".png")
            out_file.parent.mkdir(parents=True, exist_ok=True)

            width, height = stitch_tiles_by_positions(
                placements=placements,
                output_path=out_file,
                trim_transparent=False,
                keep_grid_origin=True,
                forced_grid_bounds=grid_bounds,
            )
            print(
                f"[ OK ] {rel_json}  slots={slot_count}  used={len(placements)}  size={width}x{height}",
                flush=True,
            )
            ok += 1
        except SystemExit as exc:
            message = str(exc)
            if "未找到 UniformGridPanel" in message:
                stems = extract_image_resource_stems(layout_json)
                matched_paths = []
                for stem in stems:
                    path = tile_path_by_stem.get(stem)
                    if path is not None:
                        matched_paths.append(path)

                if not matched_paths:
                    print(f"[SKIP] {rel_json} / 无 UniformGridPanel 且无可复制图片", flush=True)
                    skip += 1
                    continue

                out_file = (output_root / rel_json).with_suffix(".png")
                out_file.parent.mkdir(parents=True, exist_ok=True)

                if len(matched_paths) == 1:
                    shutil.copy2(matched_paths[0], out_file)
                    print(f"[ OK ] {rel_json}  fallback=copy  file=1", flush=True)
                else:
                    shutil.copy2(matched_paths[0], out_file)
                    for idx, src in enumerate(matched_paths[1:], start=2):
                        extra_out = out_file.with_name(f"{out_file.stem}_{idx}{out_file.suffix}")
                        shutil.copy2(src, extra_out)
                    print(
                        f"[ OK ] {rel_json}  fallback=copy  file={len(matched_paths)}",
                        flush=True,
                    )
                ok += 1
            else:
                print(f"[SKIP] {rel_json} / {exc}", flush=True)
                skip += 1
        except Exception as exc:
            print(f"[FAIL] {rel_json} / {exc}", flush=True)
            fail += 1

    print("===== 完成 =====", flush=True)
    print(f"TOTAL={total}  OK={ok}  SKIP={skip}  FAIL={fail}", flush=True)
    print(f"输出目录: {output_root.resolve()}", flush=True)

    if fail > 0:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
