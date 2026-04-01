import json
import os
import re
import threading
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple
from processor.base_processor import BaseProcessor


class BookSeriesArchiveProcessor(BaseProcessor):
    """处理 BookSeriesArchive，输出书系与资源投放位置的聚合关系。"""

    _unit_to_sub_region_cache_by_base: Dict[str, Dict[int, Tuple[int, ...]]] = {}
    _design_map_index_cache_by_base: Dict[str, List[Path]] = {}
    _design_map_json_cache: Dict[str, List[dict]] = {}
    _treasure_map_positions_cache_by_base: Dict[str, Dict[int, Dict[str, List[float]]]] = {}
    _independent_sub_region_tp_cache_by_base: Dict[str, Dict[int, List[float]]] = {}
    _cache_lock = threading.Lock()

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "BookSeriesArchive"
        self.book_series_to_resource_ids = data_loader.load_json(
            "BookSeriesId2ResourceId.json"
        )
        self.resource_data = data_loader.load_json("Resource.json")
        self.drop_data = data_loader.load_json("Drop.json")
        self.reward_data = data_loader.load_json("Reward.json")
        self.mechanism_data = data_loader.load_json("Mechanism.json")
        self.sub_region_data = data_loader.load_json("SubRegion.json")
        self.region_point_data = data_loader.load_json("RegionPoint.json")
        self.teleport_point_data = data_loader.load_json("TeleportPoint.json")

        self.resource_ids_by_series = self._build_resource_ids_by_series_from_resource()
        self.resource_to_drop_ids = self._build_resource_to_drop_ids()
        self.resource_to_reward_ids = self._build_resource_to_reward_ids()
        self.reward_to_mechanism_units = self._build_reward_to_mechanism_units()
        self.level_to_sub_region_id = self._build_level_to_sub_region_index()
        self.unit_to_sub_region_ids = self._get_or_build_unit_to_sub_region_index()
        self.exports_root = self._resolve_exports_root()
        self.design_map_paths = self._get_or_build_design_map_paths()
        self.independent_sub_region_tp_positions = self._get_or_build_independent_sub_region_tp_positions()
        self.treasure_map_positions = self._get_or_build_treasure_map_positions()

    def process_item(self, item_data, language):
        """处理单个书系条目。"""
        book_series_id = self._to_int(item_data.get("BookSeriesId"))
        if book_series_id is None:
            return None

        name_key = item_data.get("BookSeriesName", "")
        desc_key = item_data.get("DetailDes", "")

        series_name = self.get_translated_text(name_key, language) if name_key else ""
        series_desc = self.get_translated_text(desc_key, language) if desc_key else ""

        resource_ids = self._get_resource_ids_for_series(book_series_id)
        res_entries = self._build_res_entries(resource_ids, language, series_name, series_desc)
        series_icon = self._get_series_icon(resource_ids)

        processed = {
            "id": book_series_id,
            "name": series_name,
            "desc": series_desc,
            "icon": series_icon,
            "res": res_entries,
        }
        if not series_icon:
            del processed["icon"]
        return processed

    def _get_resource_ids_for_series(self, book_series_id: int) -> List[int]:
        """优先使用 BookSeriesId2ResourceId，缺失时回退 Resource.BookSeriesId。"""
        raw_ids = self.book_series_to_resource_ids.get(str(book_series_id))
        if raw_ids is None:
            raw_ids = self.book_series_to_resource_ids.get(book_series_id, [])

        resource_ids: List[int] = []
        for raw_id in self._normalize_list_field(raw_ids):
            resource_id = self._to_int(raw_id)
            if resource_id is not None:
                resource_ids.append(resource_id)

        if not resource_ids:
            resource_ids = self.resource_ids_by_series.get(book_series_id, [])

        # 去重并保持稳定顺序
        seen = set()
        deduped = []
        for resource_id in resource_ids:
            if resource_id in seen:
                continue
            seen.add(resource_id)
            deduped.append(resource_id)
        return deduped

    def _build_res_entries(
        self,
        resource_ids: List[int],
        language: str,
        series_name: str,
        series_desc: str,
    ) -> List[Dict[str, Any]]:
        """构造输出的 res 列表。"""
        entries: List[Dict[str, Any]] = []
        seen: Set[Tuple[Optional[int], str, Optional[int], Optional[int]]] = set()

        for resource_id in resource_ids:
            resource_meta = self._get_resource_meta(resource_id, language)
            position_info = self._get_resource_position_info(resource_id)
            entry_count_before = len(entries)
            # 资源 -> Drop（不经过 Mechanism）
            for drop_id in self.resource_to_drop_ids.get(resource_id, []):
                sub_region_ids = self.unit_to_sub_region_ids.get(drop_id, ())
                if sub_region_ids:
                    for sub_region_id in sub_region_ids:
                        self._append_res_entry(
                            entries,
                            seen,
                            resource_id=resource_id,
                            resource_meta=resource_meta,
                            series_name=series_name,
                            series_desc=series_desc,
                            res_type="Drop",
                            m_id=None,
                            sr_id=sub_region_id,
                            pos=self._resolve_independent_sub_region_tp_pos(
                                position_info.get("pos") if position_info else None,
                                sub_region_id,
                            ),
                            treasure_pos=position_info.get("treasurePos") if position_info else None,
                        )

            # 资源 -> Reward -> Mechanism
            for reward_id in self.resource_to_reward_ids.get(resource_id, []):
                for mechanism_unit in self.reward_to_mechanism_units.get(reward_id, []):
                    mechanism_id = mechanism_unit.get("mId")
                    mechanism_type = mechanism_unit.get("type", "")
                    if mechanism_id is None or not mechanism_type:
                        continue

                    sub_region_ids = self.unit_to_sub_region_ids.get(mechanism_id, ())
                    if sub_region_ids:
                        for sub_region_id in sub_region_ids:
                            self._append_res_entry(
                                entries,
                                seen,
                                resource_id=resource_id,
                                resource_meta=resource_meta,
                                series_name=series_name,
                                series_desc=series_desc,
                                res_type=mechanism_type,
                                m_id=mechanism_id,
                                sr_id=sub_region_id,
                                pos=self._resolve_independent_sub_region_tp_pos(
                                    position_info.get("pos") if position_info else None,
                                    sub_region_id,
                                ),
                                treasure_pos=position_info.get("treasurePos") if position_info else None,
                            )

            if len(entries) == entry_count_before:
                self._append_resource_fallback_entry(
                    entries,
                    seen,
                    resource_id=resource_id,
                    resource_meta=resource_meta,
                    series_name=series_name,
                    series_desc=series_desc,
                )

        entries.sort(
            key=lambda x: (
                x.get("id", 0),
                x.get("type", ""),
                x.get("mId", 0),
                x.get("srId", 0),
            )
        )
        return entries

    def _append_res_entry(
        self,
        entries: List[Dict[str, Any]],
        seen: Set[Tuple[Optional[int], str, Optional[int], Optional[int]]],
        resource_id: Optional[int],
        resource_meta: Dict[str, str],
        series_name: str,
        series_desc: str,
        res_type: str,
        m_id: Optional[int],
        sr_id: Optional[int],
        pos: Optional[List[float]] = None,
        treasure_pos: Optional[List[float]] = None,
    ) -> None:
        """向 res 列表追加条目并去重。"""
        if sr_id is None:
            return
        key = (resource_id, res_type, m_id, sr_id)
        if key in seen:
            return
        seen.add(key)

        item: Dict[str, Any] = {
            "id": resource_id,
            "type": res_type,
        }
        resource_name = resource_meta.get("name", "")
        if resource_name and resource_name != series_name:
            item["name"] = resource_name
        resource_desc = resource_meta.get("desc", "")
        if resource_desc and resource_desc != series_desc:
            item["desc"] = resource_desc
        resource_text = resource_meta.get("text", "")
        if resource_text:
            item["text"] = resource_text
        if m_id is not None:
            item["mId"] = m_id
        item["srId"] = sr_id
        if pos:
            item["pos"] = pos
        if treasure_pos:
            item["treasurePos"] = treasure_pos
        entries.append(item)

    def _append_resource_fallback_entry(
        self,
        entries: List[Dict[str, Any]],
        seen: Set[Tuple[Optional[int], str, Optional[int], Optional[int]]],
        resource_id: Optional[int],
        resource_meta: Dict[str, str],
        series_name: str,
        series_desc: str,
    ) -> None:
        """当资源没有可解析点位时，至少输出资源本体信息。"""
        key = (resource_id, "Resource", None, None)
        if key in seen:
            return
        seen.add(key)

        item: Dict[str, Any] = {
            "id": resource_id,
            "type": self._get_resource_type(resource_id) or "Resource",
        }
        resource_name = resource_meta.get("name", "")
        if resource_name and resource_name != series_name:
            item["name"] = resource_name
        resource_desc = resource_meta.get("desc", "")
        if resource_desc and resource_desc != series_desc:
            item["desc"] = resource_desc
        resource_text = resource_meta.get("text", "")
        if resource_text:
            item["text"] = resource_text
        entries.append(item)

    def _get_resource_meta(self, resource_id: int, language: str) -> Dict[str, str]:
        """获取资源翻译字段：name/desc/text。"""
        resource = self.resource_data.get(str(resource_id), {})
        name_key = resource.get("ResourceName", "")
        desc_key = resource.get("DetailDes", "")
        text_key = resource.get("IpDes", "")
        return {
            "name": self.get_translated_text(name_key, language) if name_key else "",
            "desc": self.get_translated_text(desc_key, language) if desc_key else "",
            "text": self.get_translated_text(text_key, language) if text_key else "",
        }

    def _get_resource_type(self, resource_id: int) -> str:
        """获取资源类型，用于没有点位时的兜底输出。"""
        resource = self.resource_data.get(str(resource_id), {})
        if not isinstance(resource, dict):
            return ""
        resource_type = resource.get("ResourceSType") or resource.get("Type") or ""
        return resource_type if isinstance(resource_type, str) else ""

    def _get_series_icon(self, resource_ids: List[int]) -> str:
        """取第一个资源的 Icon 并提取资源名片段（如 T_TreasureMap_East）。"""
        if not resource_ids:
            return ""
        first_resource = self.resource_data.get(str(resource_ids[0]), {})
        icon_path = first_resource.get("Icon", "")
        if not isinstance(icon_path, str) or not icon_path:
            return ""

        icon_name = icon_path.replace("\\", "/").rsplit("/", 1)[-1]
        if "." in icon_name:
            icon_name = icon_name.split(".", 1)[0]
        return icon_name.strip().strip("'")

    def _resolve_exports_root(self) -> Optional[Path]:
        """解析 FModel Exports 根目录。"""
        candidates: List[Path] = []
        exports_root_env = os.getenv("DNA_EXPORTS_ROOT")
        if exports_root_env:
            candidates.append(Path(exports_root_env))
        candidates.append(Path("..") / "dna-unpack" / "Fmodel" / "Output" / "Exports")

        for candidate in candidates:
            if candidate.is_dir():
                return candidate
        return None

    def _get_exports_root_cache_key(self) -> str:
        """获取当前 Exports 根目录对应的缓存键。"""
        if self.exports_root is None:
            return "__none__"
        try:
            return str(self.exports_root.resolve())
        except Exception:
            return str(self.exports_root)

    def _get_or_build_design_map_paths(self) -> List[Path]:
        """缓存所有 Design.json 路径。"""
        cache_key = self._get_exports_root_cache_key()
        cached = self._design_map_index_cache_by_base.get(cache_key)
        if cached is not None:
            return cached

        with self._cache_lock:
            cached = self._design_map_index_cache_by_base.get(cache_key)
            if cached is not None:
                return cached

            design_map_paths: List[Path] = []
            if self.exports_root is not None:
                maps_root = self.exports_root / "EM" / "Content" / "Maps" / "Levels"
                if maps_root.is_dir():
                    for json_path in maps_root.rglob("*_Design.json"):
                        if json_path.is_file():
                            design_map_paths.append(json_path)

            design_map_paths.sort()
            self._design_map_index_cache_by_base[cache_key] = design_map_paths
            return design_map_paths

    def _load_design_map_json(self, design_map_path: Path) -> List[dict]:
        """加载 Design.json 文件并缓存。"""
        cache_key = str(design_map_path)
        cached = self._design_map_json_cache.get(cache_key)
        if cached is not None:
            return cached

        try:
            data = json.loads(design_map_path.read_text(encoding="utf-8"))
        except Exception:
            self._design_map_json_cache[cache_key] = []
            return []

        if not isinstance(data, list):
            data = []

        self._design_map_json_cache[cache_key] = data
        return data

    @staticmethod
    def _ref_outer_and_name(object_name: Optional[str]) -> Tuple[Optional[str], Optional[str]]:
        """从 ObjectName 中解析 outer 和 name。"""
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

    @staticmethod
    def _build_object_maps(
        arr: List[dict],
    ) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
        """构建对象索引，便于从 ObjectRef 快速反查对象。"""
        by_outer_name: Dict[Tuple[str, str], dict] = {}
        by_name: Dict[str, List[dict]] = {}
        by_path: Dict[str, dict] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            name = obj.get("Name")
            outer = obj.get("Outer")
            outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
            outer_short_name = None
            if isinstance(outer_name, str):
                _, outer_short_name = BookSeriesArchiveProcessor._ref_outer_and_name(
                    outer_name
                )
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

    def _resolve_ref_object(
        self,
        ref_obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[dict]:
        """从引用对象中反查真实对象。"""
        if not isinstance(ref_obj, dict):
            return None
        outer, name = self._ref_outer_and_name(ref_obj.get("ObjectName"))
        if not name:
            return None
        if outer:
            direct = by_outer_name.get((outer, name))
            if direct is not None:
                return direct
        object_path = ref_obj.get("ObjectPath")
        if by_path is not None and isinstance(object_path, str):
            direct = by_path.get(object_path)
            if direct is not None:
                return direct
        candidates = by_name.get(name, [])
        if len(candidates) == 1:
            return candidates[0]
        if outer and candidates:
            for candidate in candidates:
                candidate_outer = candidate.get("Outer")
                candidate_outer_name = (
                    candidate_outer.get("ObjectName")
                    if isinstance(candidate_outer, dict)
                    else candidate_outer
                )
                _, candidate_outer_short = self._ref_outer_and_name(candidate_outer_name)
                if candidate_outer_name == outer or candidate_outer_short == outer:
                    return candidate
        return None

    @staticmethod
    def _to_vector3(value) -> Optional[List[float]]:
        """将包含 X/Y/Z 的字典转为三维向量。"""
        if not isinstance(value, dict):
            return None
        if "X" not in value or "Y" not in value or "Z" not in value:
            return None
        try:
            return [float(value["X"]), float(value["Y"]), float(value["Z"])]
        except Exception:
            return None

    @staticmethod
    def _format_num(value: float):
        rounded = round(float(value), 6)
        if abs(rounded - round(rounded)) < 1e-6:
            return int(round(rounded))
        return rounded

    def _to_vec2(self, vec: List[float]) -> Optional[List[float]]:
        """将三维向量裁剪为二维坐标。"""
        if not isinstance(vec, list) or len(vec) < 2:
            return None
        try:
            return [self._format_num(float(vec[0])), self._format_num(float(vec[1]))]
        except Exception:
            return None

    def _extract_object_location(
        self,
        obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[List[float]]:
        """提取对象自身或其根组件的位置。"""
        if not isinstance(obj, dict):
            return None

        props = obj.get("Properties", {})
        if not isinstance(props, dict):
            return None

        for key in ("RelativeLocation", "Location"):
            loc = self._to_vector3(props.get(key))
            if loc is not None:
                return loc

        transform = props.get("RelativeTransform")
        if isinstance(transform, dict):
            loc = self._to_vector3(transform.get("Translation"))
            if loc is not None:
                return loc

        root_ref = props.get("RootComponent") or props.get("DefaultSceneRoot")
        if root_ref is not None:
            loc = self._extract_ref_location(root_ref, by_outer_name, by_name, by_path)
            if loc is not None:
                return loc

        for component_key in ("Sphere", "SceneComponent", "CollisionComponent"):
            component_ref = props.get(component_key)
            if component_ref is None:
                continue
            loc = self._extract_ref_location(component_ref, by_outer_name, by_name, by_path)
            if loc is not None:
                return loc

        blueprint_components = props.get("BlueprintCreatedComponents")
        if isinstance(blueprint_components, list):
            for component_ref in blueprint_components:
                loc = self._extract_ref_location(component_ref, by_outer_name, by_name, by_path)
                if loc is not None:
                    return loc

        return None

    def _extract_ref_location(
        self,
        ref_obj: Optional[dict],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[List[float]]:
        """从引用对象中直接解析坐标。"""
        resolved_obj = self._resolve_ref_object(ref_obj, by_outer_name, by_name, by_path)
        if not isinstance(resolved_obj, dict):
            return None

        props = resolved_obj.get("Properties", {})
        if not isinstance(props, dict):
            return None

        for key in ("RelativeLocation", "Location"):
            loc = self._to_vector3(props.get(key))
            if loc is not None:
                return loc

        transform = props.get("RelativeTransform")
        if isinstance(transform, dict):
            loc = self._to_vector3(transform.get("Translation"))
            if loc is not None:
                return loc

        attach_parent = props.get("AttachParent")
        if isinstance(attach_parent, dict):
            loc = self._extract_ref_location(
                attach_parent, by_outer_name, by_name, by_path
            )
            if loc is not None:
                return loc

        return None

    def _extract_resource_position_from_arr(
        self, arr: List[dict], resource_id: int
    ) -> Optional[Dict[str, List[float]]]:
        """从 Design.json 中提取指定资源对应的拾取点和藏宝点。"""
        if not isinstance(arr, list):
            return None

        by_outer_name, by_name, by_path = self._build_object_maps(arr)
        result: Dict[str, List[float]] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            obj_type = obj.get("Type")
            if obj_type not in {"Explore_Drop_C", "Explore_Treasure_C"}:
                continue
            props = obj.get("Properties", {})
            if not isinstance(props, dict):
                continue
            if self._to_int(props.get("ResourceId")) != resource_id:
                continue

            if obj_type == "Explore_Treasure_C":
                drop_loc = self._extract_ref_location(
                    props.get("Drop"), by_outer_name, by_name, by_path
                )
                chest_loc = self._extract_ref_location(
                    props.get("Chest"), by_outer_name, by_name, by_path
                )
                if drop_loc is not None and "pos" not in result:
                    result["pos"] = self._to_vec2(drop_loc)
                elif "pos" not in result:
                    print(
                        f"BookSeriesArchive 导出错误: 资源 {resource_id} 的 Drop 坐标缺失，已跳过 pos 导出",
                        flush=True,
                    )
                if chest_loc is not None and "treasurePos" not in result:
                    result["treasurePos"] = self._to_vec2(chest_loc)
                continue

            drop_loc = self._extract_drop_component_location(obj, by_outer_name, by_name, by_path)
            if drop_loc is not None and "pos" not in result:
                result["pos"] = self._to_vec2(drop_loc)
            elif "pos" not in result:
                print(
                    f"BookSeriesArchive 导出错误: 资源 {resource_id} 的 Drop 坐标缺失，已跳过 pos 导出",
                    flush=True,
                )

        return {k: v for k, v in result.items() if v is not None} or None

    def _extract_drop_component_location(
        self,
        obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[List[float]]:
        """优先解析 Explore_Drop_C 的 Drop 组件坐标。"""
        props = obj.get("Properties", {})
        if not isinstance(props, dict):
            return None

        drop_ref = props.get("Drop")
        if isinstance(drop_ref, dict):
            resolved_obj = self._resolve_ref_object(drop_ref, by_outer_name, by_name, by_path)
            if isinstance(resolved_obj, dict):
                resolved_props = resolved_obj.get("Properties", {})
                if isinstance(resolved_props, dict):
                    for key in ("RelativeLocation", "Location"):
                        loc = self._to_vector3(resolved_props.get(key))
                        if loc is not None:
                            return loc
                    transform = resolved_props.get("RelativeTransform")
                    if isinstance(transform, dict):
                        loc = self._to_vector3(transform.get("Translation"))
                        if loc is not None:
                            return loc
                    attach_parent = resolved_props.get("AttachParent")
                    if isinstance(attach_parent, dict):
                        loc = self._extract_ref_location(
                            attach_parent, by_outer_name, by_name, by_path
                        )
                        if loc is not None:
                            return loc

        return None

    def _get_or_build_treasure_map_positions(self) -> Dict[int, Dict[str, List[float]]]:
        """缓存全部资源的拾取坐标。"""
        cache_key = self._get_exports_root_cache_key()
        cached = self._treasure_map_positions_cache_by_base.get(cache_key)
        if cached is not None:
            return cached

        with self._cache_lock:
            cached = self._treasure_map_positions_cache_by_base.get(cache_key)
            if cached is not None:
                return cached

            positions: Dict[int, Dict[str, List[float]]] = {}
            for design_map_path in self.design_map_paths:
                arr = self._load_design_map_json(design_map_path)
                if not arr:
                    continue
                for obj in arr:
                    if not isinstance(obj, dict):
                        continue
                    obj_type = obj.get("Type")
                    if obj_type not in {"Explore_Drop_C", "Explore_Treasure_C"}:
                        continue
                    props = obj.get("Properties", {})
                    if not isinstance(props, dict):
                        continue
                    resource_id = self._to_int(props.get("ResourceId"))
                    if resource_id is None:
                        continue
                    extracted = self._extract_resource_position_from_arr(arr, resource_id)
                    if extracted:
                        current = positions.setdefault(resource_id, {})
                        for key, value in extracted.items():
                            if key not in current and value is not None:
                                current[key] = value

            self._treasure_map_positions_cache_by_base[cache_key] = positions
            return positions

    def _get_resource_position_info(self, resource_id: int) -> Optional[Dict[str, List[float]]]:
        """取资源对应的拾取坐标与藏宝坐标。"""
        return self.treasure_map_positions.get(resource_id)

    @staticmethod
    def _normalize_target_sub_region_ids(value: Any) -> List[int]:
        """将 TargetSubRegion 统一成子区域 ID 列表。"""
        if isinstance(value, list):
            result: List[int] = []
            for item in value:
                try:
                    result.append(int(item))
                except Exception:
                    continue
            return result
        try:
            if value is None or value == "":
                return []
            return [int(value)]
        except Exception:
            return []

    def _iter_region_points(self) -> List[dict]:
        """统一遍历 RegionPoint 源数据。"""
        if isinstance(self.region_point_data, dict):
            return [item for item in self.region_point_data.values() if isinstance(item, dict)]
        if isinstance(self.region_point_data, list):
            return [item for item in self.region_point_data if isinstance(item, dict)]
        return []

    def _iter_teleport_points(self) -> List[dict]:
        """统一遍历 TeleportPoint 源数据。"""
        if isinstance(self.teleport_point_data, dict):
            return [item for item in self.teleport_point_data.values() if isinstance(item, dict)]
        if isinstance(self.teleport_point_data, list):
            return [item for item in self.teleport_point_data if isinstance(item, dict)]
        return []

    def _is_independent_sub_region(self, sub_region_id: int) -> bool:
        """判断子区域是否属于独立小地图。"""
        sub_region = self.sub_region_data.get(str(sub_region_id))
        if not isinstance(sub_region, dict):
            sub_region = self.sub_region_data.get(sub_region_id)
        if not isinstance(sub_region, dict):
            return False
        return bool(sub_region.get("NotShowInRegionMap"))

    def _get_or_build_independent_sub_region_tp_positions(self) -> Dict[int, List[float]]:
        """构建独立小地图子区域 -> TP 坐标索引。"""
        cache_key = self._get_exports_root_cache_key()
        cached = self._independent_sub_region_tp_cache_by_base.get(cache_key)
        if cached is not None:
            return cached

        with self._cache_lock:
            cached = self._independent_sub_region_tp_cache_by_base.get(cache_key)
            if cached is not None:
                return cached

            teleport_points_by_id: Dict[int, dict] = {}
            for point in self._iter_teleport_points():
                point_id = self._to_int(point.get("Id"))
                if point_id is None:
                    continue
                teleport_points_by_id[point_id] = point

            mapping: Dict[int, List[float]] = {}
            for point in self._iter_region_points():
                telepoint_id = self._to_int(point.get("TelepointId"))
                if telepoint_id is None:
                    continue
                teleport_point = teleport_points_by_id.get(telepoint_id)
                if not isinstance(teleport_point, dict):
                    continue
                mechanism_pos = teleport_point.get("MechanismPos")
                tp_pos = None
                if isinstance(mechanism_pos, list) and len(mechanism_pos) >= 2:
                    tp_pos = self._to_vec2([mechanism_pos[0], mechanism_pos[1], 0])
                else:
                    tp_pos = self._to_vec2(self._to_vector3(mechanism_pos) or [])
                if tp_pos is None:
                    continue
                for sub_region_id in self._normalize_target_sub_region_ids(point.get("TargetSubRegion")):
                    if not self._is_independent_sub_region(sub_region_id):
                        continue
                    mapping[sub_region_id] = tp_pos

            self._independent_sub_region_tp_cache_by_base[cache_key] = mapping
            return mapping

    def _resolve_independent_sub_region_tp_pos(
        self, fallback_pos: Optional[List[float]], sub_region_id: Optional[int]
    ) -> Optional[List[float]]:
        """独立小地图资源优先使用对应 TP 坐标。"""
        if not isinstance(fallback_pos, list) or len(fallback_pos) < 2:
            fallback_pos = None

        if sub_region_id is None:
            return fallback_pos

        tp_pos = self.independent_sub_region_tp_positions.get(self._to_int(sub_region_id))
        if isinstance(tp_pos, list) and len(tp_pos) >= 2:
            return tp_pos
        return fallback_pos

    def _build_resource_ids_by_series_from_resource(self) -> Dict[int, List[int]]:
        """从 Resource 表反建 BookSeriesId -> ResourceId 列表。"""
        mapping: Dict[int, List[int]] = {}
        for resource in self.resource_data.values():
            if not isinstance(resource, dict):
                continue
            book_series_id = self._to_int(resource.get("BookSeriesId"))
            resource_id = self._to_int(resource.get("ResourceId"))
            if book_series_id is None or resource_id is None:
                continue
            mapping.setdefault(book_series_id, []).append(resource_id)
        return mapping

    def _build_resource_to_drop_ids(self) -> Dict[int, List[int]]:
        """构建 ResourceId -> DropId 映射。"""
        mapping: Dict[int, List[int]] = {}
        for drop in self.drop_data.values():
            if not isinstance(drop, dict):
                continue
            if drop.get("UseEffectType") != "GetResource":
                continue

            resource_id = self._to_int(drop.get("UseParam"))
            drop_id = self._to_int(drop.get("DropId"))
            if resource_id is None or drop_id is None:
                continue
            mapping.setdefault(resource_id, []).append(drop_id)
        return mapping

    def _build_resource_to_reward_ids(self) -> Dict[int, List[int]]:
        """构建 ResourceId -> RewardId 映射。"""
        mapping: Dict[int, List[int]] = {}
        for reward in self.reward_data.values():
            if not isinstance(reward, dict):
                continue

            reward_id = self._to_int(reward.get("RewardId"))
            if reward_id is None:
                continue

            ids = self._normalize_list_field(reward.get("Id", []))
            types = self._normalize_list_field(reward.get("Type", []))
            for index, reward_item_type in enumerate(types):
                if reward_item_type != "Resource" or index >= len(ids):
                    continue
                resource_id = self._to_int(ids[index])
                if resource_id is None:
                    continue
                mapping.setdefault(resource_id, []).append(reward_id)
        return mapping

    def _build_reward_to_mechanism_units(self) -> Dict[int, List[Dict[str, Any]]]:
        """构建 RewardId -> Mechanism(UnitId, UnitRealType) 映射。"""
        mapping: Dict[int, List[Dict[str, Any]]] = {}
        for mechanism in self.mechanism_data.values():
            if not isinstance(mechanism, dict):
                continue
            reward_id = self._to_int(mechanism.get("RewardId"))
            mechanism_id = self._to_int(mechanism.get("UnitId"))
            mechanism_type = mechanism.get("UnitRealType", "")
            if reward_id is None or mechanism_id is None or not mechanism_type:
                continue
            mapping.setdefault(reward_id, []).append(
                {"mId": mechanism_id, "type": mechanism_type}
            )
        return mapping

    def _build_level_to_sub_region_index(self) -> Dict[str, int]:
        """构建地图名到 SubRegionId 的映射。"""
        mapping: Dict[str, int] = {}
        for sub_region in self.sub_region_data.values():
            if not isinstance(sub_region, dict):
                continue
            level_name = sub_region.get("SubRegionLevel")
            sub_region_id = self._to_int(sub_region.get("SubRegionId"))
            if not level_name or sub_region_id is None:
                continue
            mapping[level_name] = sub_region_id
        return mapping
    def _get_or_build_unit_to_sub_region_index(self) -> Dict[int, Tuple[int, ...]]:
        """缓存并返回 UnitId -> SubRegionId 列表索引。"""
        base_dir = os.path.abspath(self.data_loader.base_dir)
        cached = self._unit_to_sub_region_cache_by_base.get(base_dir)
        if cached is not None:
            return cached

        with self._cache_lock:
            cached = self._unit_to_sub_region_cache_by_base.get(base_dir)
            if cached is not None:
                return cached

            built = self._build_unit_to_sub_region_index()
            self._unit_to_sub_region_cache_by_base[base_dir] = built
            return built

    def _build_unit_to_sub_region_index(self) -> Dict[int, Tuple[int, ...]]:
        """通过 DesignLevel_data 的 Explore 区域构建 UnitId -> SubRegionId 索引。"""
        design_level_dir = os.path.join(self.data_loader.base_dir, "DesignLevel_data")
        if not os.path.isdir(design_level_dir):
            return {}

        unit_to_sub_regions: Dict[int, Set[int]] = {}

        for file_name in os.listdir(design_level_dir):
            if not file_name.endswith(".json"):
                continue
            level_name = file_name[:-5]
            sub_region_id = self.level_to_sub_region_id.get(level_name)
            if sub_region_id is None:
                continue

            file_path = os.path.join(design_level_dir, file_name)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    level_data = json.load(f)
            except Exception:
                continue

            explore_data = level_data.get("Explore", {})
            self._collect_unit_ids_from_explore(
                explore_data, sub_region_id, unit_to_sub_regions
            )

        normalized: Dict[int, Tuple[int, ...]] = {}
        for unit_id, sub_region_ids in unit_to_sub_regions.items():
            normalized[unit_id] = tuple(sorted(sub_region_ids))
        return normalized

    def _collect_unit_ids_from_explore(
        self,
        node: Any,
        sub_region_id: int,
        unit_to_sub_regions: Dict[int, Set[int]],
    ) -> None:
        """递归提取 Explore 中的 UnitId。"""
        if isinstance(node, dict):
            unit_id = self._to_int(node.get("UnitId"))
            if unit_id is not None:
                unit_to_sub_regions.setdefault(unit_id, set()).add(sub_region_id)
            for value in node.values():
                self._collect_unit_ids_from_explore(
                    value, sub_region_id, unit_to_sub_regions
                )
        elif isinstance(node, list):
            for value in node:
                self._collect_unit_ids_from_explore(
                    value, sub_region_id, unit_to_sub_regions
                )

    def _normalize_list_field(self, value: Any) -> List[Any]:
        """兼容 list/dict/scalar 的字段，统一返回 list。"""
        if isinstance(value, list):
            return value
        if isinstance(value, dict):
            max_index = 0
            index_map: Dict[int, Any] = {}
            for key, item in value.items():
                try:
                    index = int(key)
                except (TypeError, ValueError):
                    continue
                if index <= 0:
                    continue
                index_map[index] = item
                if index > max_index:
                    max_index = index
            result = []
            for index in range(1, max_index + 1):
                result.append(index_map.get(index))
            return result
        if value is None:
            return []
        return [value]

    def _to_int(self, value: Any) -> Optional[int]:
        """将值转为 int，失败返回 None。"""
        if isinstance(value, int):
            return value
        if isinstance(value, str):
            if value.isdigit():
                return int(value)
            return None
        return None
