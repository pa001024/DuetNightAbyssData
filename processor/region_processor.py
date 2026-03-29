import json
import os
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from processor.base_processor import BaseProcessor


class RegionProcessor(BaseProcessor):
    REGION_MAP_MARKER = "/Game/UI/WBP/Map/Widget/RegionMap/"
    DEFAULT_REGIONMAP_DIR = Path(
        r"D:\dev\dna-unpack\Fmodel\Output\Exports\EM\Content\UI\WBP\Map\Widget\RegionMap"
    )

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Region"
        self.regionmap_dir = self._resolve_regionmap_dir()
        self.exports_root = self._resolve_exports_root(self.regionmap_dir)
        self.splice_grid_name = os.getenv("DNA_MAP_SPLICE_GRID_NAME", "Main")
        self.widget_size_cache: Dict[str, Tuple[int, int]] = {}
        self.splice_slot_cache: Dict[str, Optional[dict]] = {}

    def _resolve_regionmap_dir(self) -> Optional[Path]:
        """解析 RegionMap Widget JSON 根目录。"""
        candidates: List[Path] = []

        regionmap_env = os.getenv("DNA_REGIONMAP_DIR")
        if regionmap_env:
            candidates.append(Path(regionmap_env))

        exports_root_env = os.getenv("DNA_EXPORTS_ROOT")
        if exports_root_env:
            candidates.append(
                Path(exports_root_env)
                / "EM"
                / "Content"
                / "UI"
                / "WBP"
                / "Map"
                / "Widget"
                / "RegionMap"
            )

        candidates.append(self.DEFAULT_REGIONMAP_DIR)

        for candidate in candidates:
            if candidate.is_dir():
                return candidate
        return None

    @staticmethod
    def _resolve_exports_root(regionmap_dir: Optional[Path]) -> Optional[Path]:
        """由 RegionMap 目录反推 Exports 根目录。"""
        if regionmap_dir is None:
            return None
        try:
            return regionmap_dir.parents[6]
        except Exception:
            return None

    @staticmethod
    def _is_empty_value(value) -> bool:
        """判断字段值是否为空。"""
        return value is None or value == "" or value == [] or value == {}

    def _drop_empty_fields(self, item: Dict) -> Dict:
        """移除空值字段（None/空串/空数组/空对象）。"""
        return {k: v for k, v in item.items() if not self._is_empty_value(v)}

    def _extract_region_map_rel(self, map_image_path: str) -> Optional[Path]:
        """提取 RegionMapImage 对应的相对路径（不含后缀）。"""
        if not isinstance(map_image_path, str) or not map_image_path:
            return None

        normalized = map_image_path.strip().strip("'")
        if self.REGION_MAP_MARKER not in normalized:
            return None

        rel = normalized.split(self.REGION_MAP_MARKER, 1)[1]
        rel = rel.split(".", 1)[0]
        if not rel:
            return None
        return Path(rel)

    @staticmethod
    def _class_path_from_class_field(class_field: str) -> Optional[str]:
        match = re.search(r"WidgetBlueprintGeneratedClass'([^']+)'", class_field or "")
        if not match:
            return None
        return match.group(1)

    @staticmethod
    def _slot_geometry(
        parent_rect: Tuple[int, int, int, int],
        slot_props: dict,
        fallback_size: Tuple[int, int],
    ) -> Tuple[int, int, int, int]:
        """解析 CanvasPanelSlot 几何信息，返回 x/y/w/h。"""
        layout = slot_props.get("LayoutData", {}) if isinstance(slot_props, dict) else {}
        offsets = layout.get("Offsets", {}) if isinstance(layout.get("Offsets", {}), dict) else {}
        anchors = layout.get("Anchors", {}) if isinstance(layout.get("Anchors", {}), dict) else {}
        alignment = (
            layout.get("Alignment", {}) if isinstance(layout.get("Alignment", {}), dict) else {}
        )
        auto_size = bool(slot_props.get("bAutoSize", False))

        left = float(offsets.get("Left", 0.0))
        top = float(offsets.get("Top", 0.0))
        right = float(offsets.get("Right", 0.0))
        bottom = float(offsets.get("Bottom", 0.0))

        ax = float(alignment.get("X", 0.0))
        ay = float(alignment.get("Y", 0.0))

        min_anchor = (
            anchors.get("Minimum", {}) if isinstance(anchors.get("Minimum", {}), dict) else {}
        )
        max_anchor = (
            anchors.get("Maximum", {}) if isinstance(anchors.get("Maximum", {}), dict) else {}
        )
        min_x = float(min_anchor.get("X", 0.0))
        min_y = float(min_anchor.get("Y", 0.0))
        max_x = float(max_anchor.get("X", min_x))
        max_y = float(max_anchor.get("Y", min_y))

        px, py, pw, ph = parent_rect
        is_fixed_anchor = abs(min_x - max_x) < 1e-6 and abs(min_y - max_y) < 1e-6

        if is_fixed_anchor:
            if auto_size:
                width = int(fallback_size[0])
                height = int(fallback_size[1])
            else:
                width = max(0, int(round(right)))
                height = max(0, int(round(bottom)))
            anchor_x = px + pw * min_x
            anchor_y = py + ph * min_y
            x = int(round(anchor_x + left - ax * width))
            y = int(round(anchor_y + top - ay * height))
            return x, y, width, height

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

        return int(round(x)), int(round(y)), stretch_w, stretch_h

    @staticmethod
    def _widget_render_opacity(widget_obj: Optional[dict]) -> float:
        """读取 Widget 的 RenderOpacity，缺省为 1.0。"""
        if not isinstance(widget_obj, dict):
            return 1.0
        value = widget_obj.get("Properties", {}).get("RenderOpacity")
        if not isinstance(value, (int, float)):
            return 1.0
        opacity = float(value)
        if opacity < 0.0:
            return 0.0
        if opacity > 1.0:
            return 1.0
        return opacity

    @staticmethod
    def _is_widget_visible(widget_obj: Optional[dict]) -> bool:
        """判断 Widget 是否可见。"""
        if not isinstance(widget_obj, dict):
            return False
        visibility = widget_obj.get("Properties", {}).get("Visibility")
        if isinstance(visibility, str) and ("Hidden" in visibility or "Collapsed" in visibility):
            return False
        return True

    @staticmethod
    def _ref_outer_and_name(object_name: Optional[str]) -> Tuple[Optional[str], Optional[str]]:
        """从 ObjectName 解析 (outer, name)。"""
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
        self,
        ref_obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[dict]:
        if not isinstance(ref_obj, dict):
            return None
        object_path = ref_obj.get("ObjectPath")
        if by_path is not None and isinstance(object_path, str):
            direct = by_path.get(object_path)
            if direct is not None:
                return direct
        outer, name = self._ref_outer_and_name(ref_obj.get("ObjectName"))
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

    @staticmethod
    def _build_object_maps(arr: List[dict]) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
        by_outer_name: Dict[Tuple[str, str], dict] = {}
        by_name: Dict[str, List[dict]] = {}
        by_path: Dict[str, dict] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            name = obj.get("Name")
            outer = obj.get("Outer")
            outer_name = None
            if isinstance(outer, dict):
                outer_name = outer.get("ObjectName")
            elif isinstance(outer, str):
                outer_name = outer
            outer_short_name = None
            if isinstance(outer_name, str):
                _, outer_short_name = RegionProcessor._ref_outer_and_name(outer_name)
            object_path = obj.get("ObjectPath")
            if isinstance(name, str):
                by_name.setdefault(name, []).append(obj)
                if isinstance(outer_name, str):
                    by_outer_name[(outer_name, name)] = obj
                if isinstance(outer_short_name, str):
                    by_outer_name[(outer_short_name, name)] = obj
            if isinstance(object_path, str):
                by_path[object_path] = obj
        return by_outer_name, by_name, by_path

    def _extract_splice_grid_slot_props(self, widget_json_path: Path, grid_name: str) -> Optional[dict]:
        """
        提取 Map_Splice 中承载 UniformGridPanel 的 CanvasPanelSlot 属性。
        这一步与 export_region_maps.py 一致，用于修正子图在外层槽位中的真实区域。
        """
        cache_key = str(widget_json_path.resolve())
        if cache_key in self.splice_slot_cache:
            return self.splice_slot_cache[cache_key]

        try:
            arr = json.loads(widget_json_path.read_text(encoding="utf-8"))
        except Exception:
            self.splice_slot_cache[cache_key] = None
            return None
        if not isinstance(arr, list):
            self.splice_slot_cache[cache_key] = None
            return None

        by_outer_name, by_name, by_path = self._build_object_maps(arr)

        root_panel = None
        widget_tree = None
        for obj in arr:
            if isinstance(obj, dict) and obj.get("Type") == "WidgetTree":
                widget_tree = obj
                break
        if widget_tree is not None:
            root_ref = widget_tree.get("Properties", {}).get("RootWidget", {})
            root_obj = self._resolve_ref_object(root_ref, by_outer_name, by_name, by_path)
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
            self.splice_slot_cache[cache_key] = None
            return None

        first_props: Optional[dict] = None
        slots = root_panel.get("Properties", {}).get("Slots", [])
        if isinstance(slots, list):
            for slot_ref in slots:
                slot_obj = self._resolve_ref_object(slot_ref, by_outer_name, by_name, by_path)
                if not slot_obj or slot_obj.get("Type") != "CanvasPanelSlot":
                    continue
                slot_props = slot_obj.get("Properties", {})
                content_obj = self._resolve_ref_object(
                    slot_props.get("Content", {}),
                    by_outer_name,
                    by_name,
                    by_path,
                )
                if not content_obj or content_obj.get("Type") != "UniformGridPanel":
                    continue
                if first_props is None:
                    first_props = slot_props
                if content_obj.get("Name") == grid_name:
                    self.splice_slot_cache[cache_key] = slot_props
                    return slot_props

        if first_props is not None:
            self.splice_slot_cache[cache_key] = first_props
            return first_props

        for obj in arr:
            if not isinstance(obj, dict) or obj.get("Type") != "UniformGridPanel":
                continue
            if obj.get("Name") != grid_name:
                continue
            slot_obj = self._resolve_ref_object(
                obj.get("Properties", {}).get("Slot", {}),
                by_outer_name,
                by_name,
                by_path,
            )
            if slot_obj and slot_obj.get("Type") == "CanvasPanelSlot":
                slot_props = slot_obj.get("Properties", {})
                self.splice_slot_cache[cache_key] = slot_props
                return slot_props

        self.splice_slot_cache[cache_key] = None
        return None

    @staticmethod
    def _infer_base_canvas_size(arr: List[dict]) -> Tuple[int, int]:
        """根据所有 CanvasPanelSlot 的 Offsets 推导基础画布尺寸。"""
        max_w = 0.0
        max_h = 0.0
        for obj in arr:
            if not isinstance(obj, dict) or obj.get("Type") != "CanvasPanelSlot":
                continue
            offsets = obj.get("Properties", {}).get("LayoutData", {}).get("Offsets", {})
            if isinstance(offsets, dict):
                max_w = max(max_w, float(offsets.get("Right", 0.0)))
                max_h = max(max_h, float(offsets.get("Bottom", 0.0)))
        width = int(round(max_w)) if max_w > 0 else 4096
        height = int(round(max_h)) if max_h > 0 else 4096
        return width, height

    def _estimate_widget_canvas_size(self, widget_json_path: Path) -> Tuple[int, int]:
        """估算子 Widget 画布尺寸，用于 AutoSize 场景。"""
        cache_key = str(widget_json_path.resolve())
        cached = self.widget_size_cache.get(cache_key)
        if cached is not None:
            return cached

        try:
            arr = json.loads(widget_json_path.read_text(encoding="utf-8"))
        except Exception:
            self.widget_size_cache[cache_key] = (0, 0)
            return 0, 0
        if not isinstance(arr, list):
            self.widget_size_cache[cache_key] = (0, 0)
            return 0, 0

        size = self._infer_base_canvas_size(arr)
        self.widget_size_cache[cache_key] = size
        return size

    def _is_map_splice_widget(self, content_obj: dict) -> bool:
        ctype = content_obj.get("Type", "")
        if not (isinstance(ctype, str) and ctype.startswith("WBP_Map_") and ctype.endswith("_C")):
            return False
        if "Reg_" in ctype and not ctype.endswith("_BG_C"):
            return False
        class_path = self._class_path_from_class_field(content_obj.get("Class", ""))
        if not class_path or "/Map_Splice/" not in class_path:
            return False
        return True

    @staticmethod
    def _object_identity_key(obj: dict) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        """生成对象去重键。"""
        if not isinstance(obj, dict):
            return None, None, None
        obj_type = obj.get("Type")
        outer = obj.get("Outer")
        outer_name = None
        if isinstance(outer, dict):
            outer_name = outer.get("ObjectName")
        elif isinstance(outer, str):
            outer_name = outer
        return obj_type, outer_name, obj.get("Name")

    def _resolve_canvas_panel_rect(
        self,
        panel_obj: dict,
        base_rect: Tuple[int, int, int, int],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Dict[str, dict],
        panel_rect_cache: Dict[int, Tuple[int, int, int, int]],
        panel_visiting: set,
    ) -> Optional[Tuple[int, int, int, int]]:
        """递归解析 CanvasPanel 的绝对矩形。"""
        if not isinstance(panel_obj, dict) or panel_obj.get("Type") != "CanvasPanel":
            return None

        panel_id = id(panel_obj)
        if panel_id in panel_rect_cache:
            return panel_rect_cache[panel_id]
        if panel_id in panel_visiting:
            return None

        panel_visiting.add(panel_id)
        try:
            slot_ref = panel_obj.get("Properties", {}).get("Slot")
            if not isinstance(slot_ref, dict):
                rect = base_rect if panel_obj.get("Name") == "Main" else None
                if rect is not None:
                    panel_rect_cache[panel_id] = rect
                return rect

            slot_obj = self._resolve_ref_object(slot_ref, by_outer_name, by_name, by_path)
            if not isinstance(slot_obj, dict) or slot_obj.get("Type") != "CanvasPanelSlot":
                return None

            outer_ref = slot_obj.get("Outer")
            outer_name = None
            if isinstance(outer_ref, dict):
                outer_name = outer_ref.get("ObjectName")
            elif isinstance(outer_ref, str):
                outer_name = outer_ref

            parent_panel = None
            if isinstance(outer_name, str):
                _, parent_name = self._ref_outer_and_name(outer_name)
                if parent_name:
                    candidates = by_name.get(parent_name, [])
                    if len(candidates) == 1:
                        parent_panel = candidates[0]
                    else:
                        for candidate in candidates:
                            if candidate.get("Type") == "CanvasPanel":
                                parent_panel = candidate
                                break

            parent_rect = base_rect
            if isinstance(parent_panel, dict):
                resolved_parent = self._resolve_canvas_panel_rect(
                    parent_panel,
                    base_rect,
                    by_outer_name,
                    by_name,
                    by_path,
                    panel_rect_cache,
                    panel_visiting,
                )
                if resolved_parent is not None:
                    parent_rect = resolved_parent

            rect = self._slot_geometry(
                parent_rect=parent_rect,
                slot_props=slot_obj.get("Properties", {}),
                fallback_size=(parent_rect[2], parent_rect[3]),
            )
            panel_rect_cache[panel_id] = rect
            return rect
        finally:
            panel_visiting.discard(panel_id)

    def _collect_map_splice_widget(
        self,
        content_obj: dict,
        slot_props: dict,
        parent_rect: Tuple[int, int, int, int],
        layer_opacity: float,
        slot_z_order: int,
        inherited_z_order: int,
        sub_maps: List[Dict],
        collected_keys: set,
    ) -> None:
        """收集一个 Map_Splice 子图。"""
        if not self._is_map_splice_widget(content_obj):
            return

        object_key = self._object_identity_key(content_obj)
        if object_key in collected_keys:
            return
        collected_keys.add(object_key)

        class_path = self._class_path_from_class_field(content_obj.get("Class", ""))
        if not class_path:
            return

        widget_rel = class_path.split(".")[0]
        widget_name = Path(widget_rel).name

        widget_json_path = None
        fallback_size = (0, 0)
        if self.exports_root is not None:
            candidate = (self.exports_root / widget_rel).with_suffix(".json")
            if candidate.is_file():
                widget_json_path = candidate
                fallback_size = self._estimate_widget_canvas_size(candidate)

        x, y, w, h = self._slot_geometry(
            parent_rect=parent_rect,
            slot_props=slot_props,
            fallback_size=fallback_size,
        )

        if widget_json_path is not None:
            inner_slot_props = self._extract_splice_grid_slot_props(
                widget_json_path,
                self.splice_grid_name,
            )
            if inner_slot_props is not None:
                inner_x, inner_y, inner_w, inner_h = self._slot_geometry(
                    parent_rect=(0, 0, w, h),
                    slot_props=inner_slot_props,
                    fallback_size=fallback_size,
                )
                x += inner_x
                y += inner_y
                w = inner_w
                h = inner_h

        sub_maps.append(
            {
                "name": widget_name,
                "pos": [x, y, w, h],
                "opacity": self._format_opacity(layer_opacity),
                "zOrder": inherited_z_order + slot_z_order,
            }
        )

    @staticmethod
    def _format_opacity(opacity: float):
        """格式化透明度，整数返回 int。"""
        rounded = round(opacity, 6)
        if abs(rounded - round(rounded)) < 1e-6:
            return int(round(rounded))
        return rounded

    def _walk_panel_collect_sub_maps(
        self,
        panel_obj: dict,
        parent_rect: Tuple[int, int, int, int],
        parent_opacity: float,
        parent_z_order: int,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Dict[str, dict],
        sub_maps: List[Dict],
        collected_keys: Optional[set] = None,
        panel_stack: Optional[set] = None,
    ) -> None:
        if collected_keys is None:
            collected_keys = set()
        if panel_stack is None:
            panel_stack = set()

        panel_key = id(panel_obj)
        if panel_key in panel_stack:
            return

        panel_stack.add(panel_key)
        try:
            slots = panel_obj.get("Properties", {}).get("Slots", [])
            if not isinstance(slots, list):
                return

            resolved_slots: List[Tuple[int, dict]] = []
            for idx, slot_ref in enumerate(slots):
                slot_obj = self._resolve_ref_object(slot_ref, by_outer_name, by_name, by_path)
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
                content_obj = self._resolve_ref_object(
                    slot_props.get("Content", {}),
                    by_outer_name,
                    by_name,
                    by_path,
                )
                if not content_obj:
                    continue
                if not self._is_widget_visible(content_obj):
                    continue

                layer_opacity = parent_opacity * self._widget_render_opacity(content_obj)
                if layer_opacity <= 0.0:
                    continue

                if content_obj.get("Type") == "CanvasPanel":
                    child_rect = self._slot_geometry(
                        parent_rect=parent_rect,
                        slot_props=slot_props,
                        fallback_size=(parent_rect[2], parent_rect[3]),
                    )
                    self._walk_panel_collect_sub_maps(
                        panel_obj=content_obj,
                        parent_rect=child_rect,
                        parent_opacity=layer_opacity,
                        parent_z_order=parent_z_order + slot_z_order,
                        by_outer_name=by_outer_name,
                        by_name=by_name,
                        by_path=by_path,
                        sub_maps=sub_maps,
                        collected_keys=collected_keys,
                        panel_stack=panel_stack,
                    )
                    continue

                self._collect_map_splice_widget(
                    content_obj=content_obj,
                    slot_props=slot_props,
                    parent_rect=parent_rect,
                    layer_opacity=layer_opacity,
                    slot_z_order=slot_z_order,
                    inherited_z_order=parent_z_order,
                    sub_maps=sub_maps,
                    collected_keys=collected_keys,
                )
        finally:
            panel_stack.discard(panel_key)

    def _collect_region_sub_maps(self, region_widget_json_path: Path) -> List[Dict]:
        """解析 RegionMap Widget，提取所有 Map_Splice 子图布局。"""
        try:
            arr = json.loads(region_widget_json_path.read_text(encoding="utf-8"))
        except Exception:
            return []
        if not isinstance(arr, list):
            return []

        by_outer_name, by_name, by_path = self._build_object_maps(arr)

        root_panel = None
        widget_tree = None
        for obj in arr:
            if isinstance(obj, dict) and obj.get("Type") == "WidgetTree":
                widget_tree = obj
                break
        if widget_tree is not None:
            root_ref = widget_tree.get("Properties", {}).get("RootWidget", {})
            root_obj = self._resolve_ref_object(root_ref, by_outer_name, by_name, by_path)
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

        base_w, base_h = self._infer_base_canvas_size(arr)
        sub_maps: List[Dict] = []
        collected_keys: set = set()
        self._walk_panel_collect_sub_maps(
            panel_obj=root_panel,
            parent_rect=(0, 0, base_w, base_h),
            parent_opacity=1.0,
            parent_z_order=0,
            by_outer_name=by_outer_name,
            by_name=by_name,
            by_path=by_path,
            sub_maps=sub_maps,
            collected_keys=collected_keys,
            panel_stack=set(),
        )

        panel_rect_cache: Dict[int, Tuple[int, int, int, int]] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if not self._is_map_splice_widget(obj):
                continue
            slot_ref = obj.get("Properties", {}).get("Slot")
            if not isinstance(slot_ref, dict):
                continue
            slot_obj = self._resolve_ref_object(slot_ref, by_outer_name, by_name, by_path)
            if not isinstance(slot_obj, dict) or slot_obj.get("Type") != "CanvasPanelSlot":
                continue

            outer_ref = slot_obj.get("Outer")
            outer_name = None
            if isinstance(outer_ref, dict):
                outer_name = outer_ref.get("ObjectName")
            elif isinstance(outer_ref, str):
                outer_name = outer_ref
            if not isinstance(outer_name, str):
                continue
            _, parent_name = self._ref_outer_and_name(outer_name)
            if not parent_name:
                continue
            parent_candidates = by_name.get(parent_name, [])
            parent_panel = next(
                (
                    candidate
                    for candidate in parent_candidates
                    if candidate.get("Type") == "CanvasPanel"
                ),
                None,
            )
            if not isinstance(parent_panel, dict):
                continue

            parent_rect = self._resolve_canvas_panel_rect(
                parent_panel,
                (0, 0, base_w, base_h),
                by_outer_name,
                by_name,
                by_path,
                panel_rect_cache,
                set(),
            )
            if parent_rect is None:
                continue

            self._collect_map_splice_widget(
                content_obj=obj,
                slot_props=slot_obj.get("Properties", {}),
                parent_rect=parent_rect,
                layer_opacity=1.0,
                slot_z_order=int(slot_obj.get("Properties", {}).get("ZOrder", 0) or 0),
                inherited_z_order=0,
                sub_maps=sub_maps,
                collected_keys=collected_keys,
            )
        return self._normalize_full_frame_pair_offsets(sub_maps)

    @staticmethod
    def _normalize_full_frame_pair_offsets(sub_maps: List[Dict]) -> List[Dict]:
        """整幅 BG + 主图叠层时，对齐主图到 BG 原点。"""
        if len(sub_maps) != 2:
            return sub_maps

        bg_layers = [
            item for item in sub_maps if isinstance(item.get("name"), str) and item["name"].endswith("_BG")
        ]
        fg_layers = [
            item for item in sub_maps if not (isinstance(item.get("name"), str) and item["name"].endswith("_BG"))
        ]
        if len(bg_layers) != 1 or len(fg_layers) != 1:
            return sub_maps

        bg = bg_layers[0]
        fg = fg_layers[0]
        bg_pos = bg.get("pos")
        fg_pos = fg.get("pos")
        if not (
            isinstance(bg_pos, list)
            and isinstance(fg_pos, list)
            and len(bg_pos) == 4
            and len(fg_pos) == 4
            and bg_pos[2] == fg_pos[2]
            and bg_pos[3] == fg_pos[3]
            and fg.get("zOrder", 0) >= bg.get("zOrder", 0)
        ):
            return sub_maps

        fg["pos"] = [bg_pos[0], bg_pos[1], fg_pos[2], fg_pos[3]]
        return sub_maps

    def _build_map_mapping(self, map_image_path: str) -> List[Dict]:
        """构建 RegionMap 子图映射列表。"""
        region_map_rel = self._extract_region_map_rel(map_image_path)
        if region_map_rel is None:
            return []

        if self.regionmap_dir is None:
            return []

        region_widget_json = (self.regionmap_dir / region_map_rel).with_suffix(".json")
        if not region_widget_json.is_file():
            return []

        sub_maps = self._collect_region_sub_maps(region_widget_json)
        return sub_maps or []

    def _extract_region_map_name(self, map_image_path: str) -> str:
        """提取 RegionMap 的 WBP 名称。"""
        region_map_rel = self._extract_region_map_rel(map_image_path)
        if region_map_rel is None:
            return ""
        return region_map_rel.stem

    def process_item(self, region_data, language):
        """处理单个区域数据。"""
        region_id = region_data.get("RegionId")

        region_name_key = region_data.get("RegionName")
        region_name = ""
        if region_name_key:
            region_name = self.get_translated_text(region_name_key, language)

        map_image_raw = region_data.get("RegionMapImage")
        map_image_name = self._extract_region_map_name(map_image_raw) if map_image_raw else ""
        map_mapping = self._build_map_mapping(map_image_raw) if map_image_raw else []
        processed_region = {
            "id": region_id,
            "name": region_name,
            "type": region_data.get("RegionType"),
            "mapId": region_data.get("RegionMapId"),
            "mapImage": map_image_name,
            "mapCenter": region_data.get("RegionMapImageCenter"),
            "mapScale": region_data.get("RegionMapWheelScale"),
            "mapRotation": region_data.get("RegionRotation"),
            "isRandom": region_data.get("IsRandom"),
            "alertDisable": region_data.get("AlertDisable"),
            "mapMapping": map_mapping,
        }

        cleaned = self._drop_empty_fields(processed_region)
        if map_image_name and "mapMapping" not in cleaned:
            cleaned["mapMapping"] = []
        return cleaned
