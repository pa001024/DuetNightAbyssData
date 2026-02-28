import argparse
import json
import re
import shutil
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image

from export_all_maps import extract_image_resource_stems, extract_texture_input_dir
from stitch_map_tiles import _collect_tiles, _parse_layout_placements, stitch_tiles_by_positions


@dataclass
class Layer:
    source_png: Path
    x: int
    y: int
    w: int
    h: int
    opacity: float = 1.0
    z_order: int = 0
    order_index: int = 0


def _tail_object_name(object_name: Optional[str]) -> Optional[str]:
    if not object_name:
        return None
    return object_name.split(".")[-1].strip("'")


def _class_path_from_class_field(class_field: str) -> Optional[str]:
    match = re.search(r"WidgetBlueprintGeneratedClass'([^']+)'", class_field or "")
    if not match:
        return None
    return match.group(1)


def _slot_geometry(
    parent_rect: Tuple[int, int, int, int],
    slot_props: dict,
    fallback_size: Tuple[int, int],
) -> Tuple[int, int, int, int]:
    """解析 CanvasPanelSlot 的几何信息，返回 x/y/w/h（以 RegionMap 主坐标系为基准）。"""
    layout = slot_props.get("LayoutData", {}) if isinstance(slot_props, dict) else {}
    offsets = layout.get("Offsets", {}) if isinstance(layout.get("Offsets", {}), dict) else {}
    anchors = layout.get("Anchors", {}) if isinstance(layout.get("Anchors", {}), dict) else {}
    alignment = layout.get("Alignment", {}) if isinstance(layout.get("Alignment", {}), dict) else {}
    auto_size = bool(slot_props.get("bAutoSize", False))

    left = float(offsets.get("Left", 0.0))
    top = float(offsets.get("Top", 0.0))
    right = float(offsets.get("Right", 0.0))
    bottom = float(offsets.get("Bottom", 0.0))

    ax = float(alignment.get("X", 0.0))
    ay = float(alignment.get("Y", 0.0))

    min_anchor = anchors.get("Minimum", {}) if isinstance(anchors.get("Minimum", {}), dict) else {}
    max_anchor = anchors.get("Maximum", {}) if isinstance(anchors.get("Maximum", {}), dict) else {}
    min_x = float(min_anchor.get("X", 0.0))
    min_y = float(min_anchor.get("Y", 0.0))
    max_x = float(max_anchor.get("X", min_x))
    max_y = float(max_anchor.get("Y", min_y))

    px, py, pw, ph = parent_rect

    is_fixed_anchor = abs(min_x - max_x) < 1e-6 and abs(min_y - max_y) < 1e-6

    # 固定锚点: Offsets.Right/Bottom 是 Size；AutoSize 才使用内容尺寸。
    if is_fixed_anchor:
        if auto_size:
            width = int(fallback_size[0])
            height = int(fallback_size[1])
        else:
            width = int(round(right))
            height = int(round(bottom))
            if width < 0:
                width = 0
            if height < 0:
                height = 0
        anchor_x = px + pw * min_x
        anchor_y = py + ph * min_y
        x = int(round(anchor_x + left - ax * width))
        y = int(round(anchor_y + top - ay * height))
        return x, y, width, height

    # 拉伸锚点
    x = px + pw * min_x + left
    y = py + ph * min_y + top
    right_abs = px + pw * max_x - right
    bottom_abs = py + ph * max_y - bottom

    stretch_w = int(round(right_abs - x))
    stretch_h = int(round(bottom_abs - y))
    if stretch_w <= 0:
        stretch_w = int(fallback_size[0])
    if stretch_h <= 0:
        stretch_h = int(fallback_size[1])

    x = int(round(x))
    y = int(round(y))
    return x, y, stretch_w, stretch_h


def _widget_render_opacity(widget_obj: Optional[dict]) -> float:
    """读取 Widget 的 RenderOpacity，缺省为 1.0。"""
    if not isinstance(widget_obj, dict):
        return 1.0
    props = widget_obj.get("Properties", {})
    value = props.get("RenderOpacity")
    if isinstance(value, (int, float)):
        opacity = float(value)
        if opacity < 0.0:
            return 0.0
        if opacity > 1.0:
            return 1.0
        return opacity
    return 1.0


def _is_widget_visible(widget_obj: Optional[dict]) -> bool:
    """判断 Widget 是否可见（Hidden/Collapsed 视为不可见）。"""
    if not isinstance(widget_obj, dict):
        return False
    visibility = widget_obj.get("Properties", {}).get("Visibility")
    if isinstance(visibility, str) and ("Hidden" in visibility or "Collapsed" in visibility):
        return False
    return True


def _ref_outer_and_name(object_name: Optional[str]) -> Tuple[Optional[str], Optional[str]]:
    """
    从 ObjectName 中解析 (outer, name)。
    例:
    CanvasPanelSlot'...:WidgetTree.Main.CanvasPanelSlot_1' -> (Main, CanvasPanelSlot_1)
    """
    if not object_name:
        return None, None
    raw = object_name.strip("'")
    if ":" in raw:
        raw = raw.split(":", 1)[1]
    parts = raw.split(".")
    if len(parts) >= 2:
        return parts[-2], parts[-1]
    if len(parts) == 1:
        return None, parts[0]
    return None, None


def _resolve_ref_object(
    ref_obj: dict,
    by_outer_name: Dict[Tuple[str, str], dict],
    by_name: Dict[str, List[dict]],
) -> Optional[dict]:
    if not isinstance(ref_obj, dict):
        return None
    outer, name = _ref_outer_and_name(ref_obj.get("ObjectName"))
    if not name:
        return None

    if outer:
        direct = by_outer_name.get((outer, name))
        if direct is not None:
            return direct

    candidates = by_name.get(name, [])
    if len(candidates) == 1:
        return candidates[0]
    if outer and candidates:
        for candidate in candidates:
            if candidate.get("Outer") == outer:
                return candidate
    return candidates[0] if candidates else None


def _extract_splice_grid_slot_props(
    widget_json_path: Path,
    grid_name: str,
) -> Optional[dict]:
    """
    提取 Map_Splice Widget 中承载 UniformGridPanel 的 CanvasPanelSlot 属性。
    用于把已拼接的小图按“子 Widget 内部布局”再放入外层槽位，避免直接缩放导致错位。
    """
    try:
        arr = json.loads(widget_json_path.read_text(encoding="utf-8"))
    except Exception:
        return None
    if not isinstance(arr, list):
        return None

    by_outer_name: Dict[Tuple[str, str], dict] = {}
    by_name: Dict[str, List[dict]] = {}
    for obj in arr:
        if not isinstance(obj, dict):
            continue
        name = obj.get("Name")
        outer = obj.get("Outer")
        if isinstance(name, str):
            by_name.setdefault(name, []).append(obj)
            if isinstance(outer, str):
                by_outer_name[(outer, name)] = obj

    root_panel = None
    widget_tree = None
    for obj in arr:
        if isinstance(obj, dict) and obj.get("Type") == "WidgetTree":
            widget_tree = obj
            break
    if widget_tree is not None:
        root_ref = widget_tree.get("Properties", {}).get("RootWidget", {})
        root_obj = _resolve_ref_object(root_ref, by_outer_name, by_name)
        if isinstance(root_obj, dict) and root_obj.get("Type") == "CanvasPanel":
            root_panel = root_obj

    if root_panel is None:
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if obj.get("Type") == "CanvasPanel" and obj.get("Name") == "Main":
                root_panel = obj
                break
    if root_panel is None:
        return None

    first_props: Optional[dict] = None
    slots = root_panel.get("Properties", {}).get("Slots", [])
    if isinstance(slots, list):
        for slot_ref in slots:
            slot_obj = _resolve_ref_object(slot_ref, by_outer_name, by_name)
            if not slot_obj or slot_obj.get("Type") != "CanvasPanelSlot":
                continue
            slot_props = slot_obj.get("Properties", {})
            content_obj = _resolve_ref_object(slot_props.get("Content", {}), by_outer_name, by_name)
            if not content_obj or content_obj.get("Type") != "UniformGridPanel":
                continue
            if first_props is None:
                first_props = slot_props
            if content_obj.get("Name") == grid_name:
                return slot_props

    if first_props is not None:
        return first_props

    for obj in arr:
        if not isinstance(obj, dict) or obj.get("Type") != "UniformGridPanel":
            continue
        if obj.get("Name") != grid_name:
            continue
        slot_obj = _resolve_ref_object(
            obj.get("Properties", {}).get("Slot", {}),
            by_outer_name,
            by_name,
        )
        if slot_obj and slot_obj.get("Type") == "CanvasPanelSlot":
            return slot_obj.get("Properties", {})
    return None


def _infer_base_canvas_size(arr: List[dict]) -> Tuple[int, int]:
    """为 RegionMap 合成提供一个稳定的基础画布尺寸（主要影响整体平移，不影响相对布局）。"""
    max_w = 0.0
    max_h = 0.0
    for obj in arr:
        if not isinstance(obj, dict) or obj.get("Type") != "CanvasPanelSlot":
            continue
        offsets = (
            obj.get("Properties", {})
            .get("LayoutData", {})
            .get("Offsets", {})
        )
        if isinstance(offsets, dict):
            r = float(offsets.get("Right", 0.0))
            b = float(offsets.get("Bottom", 0.0))
            if r > max_w:
                max_w = r
            if b > max_h:
                max_h = b

    width = int(round(max_w)) if max_w > 0 else 4096
    height = int(round(max_h)) if max_h > 0 else 4096
    return width, height


def _is_map_splice_widget(content_obj: dict) -> bool:
    ctype = content_obj.get("Type", "")
    if not (isinstance(ctype, str) and ctype.startswith("WBP_Map_") and ctype.endswith("_C")):
        return False
    if "Reg_" in ctype:
        return False
    class_path = _class_path_from_class_field(content_obj.get("Class", ""))
    if not class_path or "/Map_Splice/" not in class_path:
        return False
    return True


def _walk_panel_collect_layers(
    panel_obj: dict,
    parent_rect: Tuple[int, int, int, int],
    parent_opacity: float,
    by_outer_name: Dict[Tuple[str, str], dict],
    by_name: Dict[str, List[dict]],
    exports_root: Path,
    splice_dir: Path,
    texture_root: Path,
    splice_cache_root: Path,
    grid_name: str,
    force_splice_rebuild: bool,
    layers: List[Layer],
    order_seed: List[int],
) -> None:
    slots = panel_obj.get("Properties", {}).get("Slots", [])
    if not isinstance(slots, list):
        return

    resolved_slots: List[Tuple[int, dict]] = []
    for idx, slot_ref in enumerate(slots):
        slot_obj = _resolve_ref_object(slot_ref, by_outer_name, by_name)
        if not slot_obj or slot_obj.get("Type") != "CanvasPanelSlot":
            continue
        resolved_slots.append((idx, slot_obj))

    resolved_slots.sort(
        key=lambda item: (
            int(item[1].get("Properties", {}).get("ZOrder", 0) or 0),
            item[0],
        )
    )

    for _, slot_obj in resolved_slots:
        slot_props = slot_obj.get("Properties", {})
        slot_z_order = int(slot_props.get("ZOrder", 0) or 0)
        content_obj = _resolve_ref_object(slot_props.get("Content", {}), by_outer_name, by_name)
        if not content_obj:
            continue
        if not _is_widget_visible(content_obj):
            continue

        layer_opacity = parent_opacity * _widget_render_opacity(content_obj)
        if layer_opacity <= 0.0:
            continue

        if content_obj.get("Type") == "CanvasPanel":
            child_rect = _slot_geometry(parent_rect, slot_props, fallback_size=(parent_rect[2], parent_rect[3]))
            _walk_panel_collect_layers(
                panel_obj=content_obj,
                parent_rect=child_rect,
                parent_opacity=layer_opacity,
                by_outer_name=by_outer_name,
                by_name=by_name,
                exports_root=exports_root,
                splice_dir=splice_dir,
                texture_root=texture_root,
                splice_cache_root=splice_cache_root,
                grid_name=grid_name,
                force_splice_rebuild=force_splice_rebuild,
                layers=layers,
                order_seed=order_seed,
            )
            continue

        if not _is_map_splice_widget(content_obj):
            continue

        class_path = _class_path_from_class_field(content_obj.get("Class", ""))
        if not class_path:
            continue
        widget_rel = class_path.split(".")[0]
        widget_json = (exports_root / widget_rel).with_suffix(".json")
        child_png = _render_map_splice_widget(
            class_path=class_path,
            exports_root=exports_root,
            splice_dir=splice_dir,
            texture_root=texture_root,
            cache_root=splice_cache_root,
            grid_name=grid_name,
            force_rebuild=force_splice_rebuild,
        )
        if child_png is None:
            continue

        with Image.open(child_png) as child_im:
            fallback_size = child_im.size
        x, y, w, h = _slot_geometry(parent_rect, slot_props, fallback_size=fallback_size)

        inner_slot_props = None
        if widget_json.is_file():
            inner_slot_props = _extract_splice_grid_slot_props(widget_json, grid_name)
        if inner_slot_props is not None:
            inner_x, inner_y, inner_w, inner_h = _slot_geometry(
                parent_rect=(0, 0, w, h),
                slot_props=inner_slot_props,
                fallback_size=fallback_size,
            )
            x += inner_x
            y += inner_y
            w = inner_w
            h = inner_h

        layers.append(
            Layer(
                source_png=child_png,
                x=x,
                y=y,
                w=w,
                h=h,
                opacity=layer_opacity,
                z_order=slot_z_order,
                order_index=order_seed[0],
            )
        )
        order_seed[0] += 1


def _render_map_splice_widget(
    class_path: str,
    exports_root: Path,
    splice_dir: Path,
    texture_root: Path,
    cache_root: Path,
    grid_name: str,
    force_rebuild: bool,
) -> Optional[Path]:
    """
    将 Map_Splice 小图 Widget 渲染为 PNG（有缓存）。
    class_path 例:
    EM/Content/UI/WBP/Map/Widget/Map_Splice/Prologue/WBP_Map_Prologue_100101.WBP_Map_Prologue_100101_C
    """
    widget_rel = class_path.split(".")[0]
    widget_json = (exports_root / widget_rel).with_suffix(".json")
    if not widget_json.is_file():
        return None

    rel_json = widget_json.relative_to(splice_dir)
    out_png = (cache_root / rel_json).with_suffix(".png")
    out_png.parent.mkdir(parents=True, exist_ok=True)
    if (
        out_png.is_file()
        and not force_rebuild
        and out_png.stat().st_mtime >= widget_json.stat().st_mtime
    ):
        return out_png

    input_dir = extract_texture_input_dir(widget_json, texture_root)
    if input_dir is None:
        return None

    indexed_tiles = _collect_tiles(input_dir, "*.png")
    if not indexed_tiles:
        return None
    tile_paths = [p for _, p in indexed_tiles]
    tile_path_by_stem = {p.stem: p for p in tile_paths}

    try:
        placements, _slot_count, grid_bounds = _parse_layout_placements(
            layout_json_path=widget_json,
            grid_name=grid_name,
            tile_path_by_stem=tile_path_by_stem,
        )
        if placements:
            stitch_tiles_by_positions(
                placements=placements,
                output_path=out_png,
                trim_transparent=False,
                keep_grid_origin=True,
                forced_grid_bounds=grid_bounds,
            )
            return out_png
    except SystemExit:
        pass

    # fallback: 无 UniformGridPanel，复制首张 Image 对应贴图
    stems = extract_image_resource_stems(widget_json)
    for stem in stems:
        src = tile_path_by_stem.get(stem)
        if src is not None and src.is_file():
            shutil.copy2(src, out_png)
            return out_png
    return None


def _collect_region_layers(
    region_json_path: Path,
    exports_root: Path,
    splice_dir: Path,
    texture_root: Path,
    splice_cache_root: Path,
    grid_name: str,
    force_splice_rebuild: bool,
) -> List[Layer]:
    arr = json.loads(region_json_path.read_text(encoding="utf-8"))
    if not isinstance(arr, list):
        return []

    by_outer_name: Dict[Tuple[str, str], dict] = {}
    by_name: Dict[str, List[dict]] = {}
    for obj in arr:
        if not isinstance(obj, dict):
            continue
        name = obj.get("Name")
        outer = obj.get("Outer")
        if isinstance(name, str):
            by_name.setdefault(name, []).append(obj)
            if isinstance(outer, str):
                by_outer_name[(outer, name)] = obj

    root_panel = None
    widget_tree = None
    for obj in arr:
        if isinstance(obj, dict) and obj.get("Type") == "WidgetTree":
            widget_tree = obj
            break
    if widget_tree is not None:
        root_ref = widget_tree.get("Properties", {}).get("RootWidget", {})
        root_obj = _resolve_ref_object(root_ref, by_outer_name, by_name)
        if isinstance(root_obj, dict) and root_obj.get("Type") == "CanvasPanel":
            root_panel = root_obj

    if root_panel is None:
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if obj.get("Type") == "CanvasPanel" and obj.get("Name") == "Main":
                root_panel = obj
                break
    if root_panel is None:
        for obj in arr:
            if isinstance(obj, dict) and obj.get("Type") == "CanvasPanel":
                root_panel = obj
                break
    if root_panel is None:
        return []

    base_w, base_h = _infer_base_canvas_size(arr)
    layers: List[Layer] = []
    order_seed = [0]
    _walk_panel_collect_layers(
        panel_obj=root_panel,
        parent_rect=(0, 0, base_w, base_h),
        parent_opacity=1.0,
        by_outer_name=by_outer_name,
        by_name=by_name,
        exports_root=exports_root,
        splice_dir=splice_dir,
        texture_root=texture_root,
        splice_cache_root=splice_cache_root,
        grid_name=grid_name,
        force_splice_rebuild=force_splice_rebuild,
        layers=layers,
        order_seed=order_seed,
    )
    return layers


def _compose_layers(layers: List[Layer], output_path: Path) -> Optional[Tuple[int, int]]:
    if not layers:
        return None

    min_x = min(layer.x for layer in layers)
    min_y = min(layer.y for layer in layers)
    max_x = max(layer.x + layer.w for layer in layers)
    max_y = max(layer.y + layer.h for layer in layers)

    width = int(max_x - min_x)
    height = int(max_y - min_y)
    if width <= 0 or height <= 0:
        return None

    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    sorted_layers = sorted(layers, key=lambda layer: (layer.z_order, layer.order_index))
    for layer in sorted_layers:
        with Image.open(layer.source_png).convert("RGBA") as source:
            if (layer.w, layer.h) != source.size:
                source = source.resize((layer.w, layer.h), Image.Resampling.BILINEAR)
            if layer.opacity < 1.0:
                alpha = source.getchannel("A")
                alpha = alpha.point(lambda v: int(v * layer.opacity))
                source.putalpha(alpha)
            canvas.alpha_composite(source, (layer.x - min_x, layer.y - min_y))

    output_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(output_path)
    return width, height


def main() -> None:
    parser = argparse.ArgumentParser(description="把 RegionMap JSON 引用的子图合成为全图")
    parser.add_argument(
        "--regionmap-dir",
        default=r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\WBP\Map\Widget\RegionMap",
        help="RegionMap 目录",
    )
    parser.add_argument(
        "--splice-dir",
        default=r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\WBP\Map\Widget\Map_Splice",
        help="Map_Splice 目录",
    )
    parser.add_argument(
        "--texture-root",
        default=r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\Texture\Static\Image\Map",
        help="地图贴图根目录",
    )
    parser.add_argument(
        "--output-root",
        default="out/region_map_merged",
        help="输出目录（保留 RegionMap 相对目录）",
    )
    parser.add_argument(
        "--splice-cache-root",
        default="out/map_splice",
        help="Map_Splice 子图缓存目录（不存在会自动渲染）",
    )
    parser.add_argument("--grid-name", default="Main", help="Map_Splice 中 UniformGridPanel 名称")
    parser.add_argument(
        "--force-splice-rebuild",
        action="store_true",
        help="忽略 out/map_splice 缓存，强制重建 Map_Splice 子图",
    )

    args = parser.parse_args()

    regionmap_dir = Path(args.regionmap_dir)
    splice_dir = Path(args.splice_dir)
    texture_root = Path(args.texture_root)
    output_root = Path(args.output_root)
    splice_cache_root = Path(args.splice_cache_root)

    if not regionmap_dir.is_dir():
        raise SystemExit(f"RegionMap 目录不存在: {regionmap_dir}")
    if not splice_dir.is_dir():
        raise SystemExit(f"Map_Splice 目录不存在: {splice_dir}")
    if not texture_root.is_dir():
        raise SystemExit(f"贴图根目录不存在: {texture_root}")

    exports_root = splice_dir.parents[6]

    region_files = sorted(regionmap_dir.rglob("WBP_Map_Reg*.json"))
    total = len(region_files)
    ok = 0
    skip = 0
    fail = 0

    print(f"[INFO] RegionMap: {regionmap_dir}", flush=True)
    print(f"[INFO] Output: {output_root.resolve()}", flush=True)

    for region_json in region_files:
        rel = region_json.relative_to(regionmap_dir)
        out_png = (output_root / rel).with_suffix(".png")
        print(f"[RUN ] {rel}", flush=True)
        try:
            layers = _collect_region_layers(
                region_json_path=region_json,
                exports_root=exports_root,
                splice_dir=splice_dir,
                texture_root=texture_root,
                splice_cache_root=splice_cache_root,
                grid_name=args.grid_name,
                force_splice_rebuild=args.force_splice_rebuild,
            )
            if not layers:
                print(f"[SKIP] {rel} / 未找到可合成子层", flush=True)
                skip += 1
                continue
            size = _compose_layers(layers, out_png)
            if size is None:
                print(f"[SKIP] {rel} / 合成尺寸无效", flush=True)
                skip += 1
                continue
            print(f"[ OK ] {rel}  layers={len(layers)}  size={size[0]}x{size[1]}", flush=True)
            ok += 1
        except Exception as exc:
            print(f"[FAIL] {rel} / {exc}", flush=True)
            fail += 1

    print("===== 完成 =====", flush=True)
    print(f"TOTAL={total}  OK={ok}  SKIP={skip}  FAIL={fail}", flush=True)
    print(f"输出目录: {output_root.resolve()}", flush=True)

    if fail > 0:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
