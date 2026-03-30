import json
import math
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from processor.base_processor import BaseProcessor


class SubRegionProcessor(BaseProcessor):
    DEFAULT_EXPORTS_ROOT = Path(r"D:\dev\dna-unpack\Fmodel\Output\Exports")
    _shared_base_json_cache: Dict[Tuple[str, str], object] = {}
    _shared_design_level_cache: Dict[Tuple[str, str], dict] = {}
    _shared_missing_design_level: set[Tuple[str, str]] = set()
    _shared_design_map_index_cache: Dict[str, Dict[str, List[Path]]] = {}
    _shared_design_map_json_cache: Dict[str, List[dict]] = {}
    _shared_random_actor_points_cache: Dict[str, Dict[str, Dict[str, List[List]]]] = {}
    _shared_sub_region_core_cache: Dict[str, dict] = {}
    _shared_sub_region_core_locks: Dict[str, object] = {}
    _shared_sub_region_core_cache_lock = __import__("threading").Lock()

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SubRegion"
        self.base_cache_key = self._resolve_base_cache_key()
        self.random_creator_data = self._load_shared_base_json(data_loader, "RandomCreator.json")
        self.region_data = self._load_shared_base_json(data_loader, "Region.json")
        self.region_point_data = self._load_shared_base_json(data_loader, "RegionPoint.json")
        self.teleport_point_data = self._load_shared_base_json(data_loader, "TeleportPoint.json")
        self.design_level_cache = {}
        self.missing_design_level = set()
        self.exports_root = self._resolve_exports_root()
        self.map_units_per_pixel = self._resolve_map_units_per_pixel()
        self.design_map_index: Optional[Dict[str, List[Path]]] = None
        self.design_map_path_cache: Dict[str, Optional[Path]] = {}
        self.design_map_json_cache: Dict[str, List[dict]] = {}
        self.random_actor_points_cache: Dict[str, Dict[str, List[List]]] = {}
        self.region_map_transform_cache: Dict[str, dict] = {}
        self.teleport_points_cache: Dict[int, List[dict]] = {}

    @staticmethod
    def _resolve_base_cache_key() -> str:
        """生成基础数据缓存键。"""
        return "base"

    @classmethod
    def _load_shared_base_json(cls, data_loader, file_name: str):
        """共享加载基础 JSON。"""
        cache_key = (cls._resolve_base_cache_key(), file_name)
        if cache_key in cls._shared_base_json_cache:
            return cls._shared_base_json_cache[cache_key]
        data = data_loader.load_json(file_name)
        cls._shared_base_json_cache[cache_key] = data
        return data

    def process_item(self, item_data, language):
        """处理单个子区域数据

        Args:
            sub_region_data: 原始子区域数据
            language: 语言类型

        Returns:
            处理后的子区域数据
        """
        sub_region_data = item_data
        sub_region_id = sub_region_data.get("SubRegionId")

        sub_region_name_key = sub_region_data.get("SubRegionName")
        sub_region_name = ""
        if sub_region_name_key:
            sub_region_name = self.get_translated_text(sub_region_name_key, language)

        sub_region_des_key = sub_region_data.get("SubRegionDes")
        sub_region_des = ""
        if sub_region_des_key:
            sub_region_des = self.get_translated_text(sub_region_des_key, language)

        processed_sub_region = {
            "id": sub_region_id,
            "rid": sub_region_data.get("RegionId"),
            "name": sub_region_name,
            "desc": sub_region_des,
            "map": sub_region_data.get("SubRegionLevel"),
            "pos": self._to_vec2(sub_region_data.get("SubRegionCenter", [])) or [],
        }
        if not processed_sub_region["rid"] or not processed_sub_region["map"]:
            return None

        core = self._get_sub_region_core(
            processed_sub_region["map"],
            sub_region_id,
            processed_sub_region["rid"],
            processed_sub_region.get("pos"),
        )
        if not processed_sub_region.get("pos") and core.get("pos"):
            processed_sub_region["pos"] = core["pos"]
        elif not processed_sub_region.get("pos"):
            del processed_sub_region["pos"]
        if core.get("range"):
            processed_sub_region["range"] = core["range"]
        if core.get("rc"):
            processed_sub_region["rc"] = core["rc"]
        tp = core.get("tp")
        if tp:
            processed_sub_region["tp"] = [
                {
                    "id": tp_item["id"],
                    "pos": tp_item["pos"],
                    "name": self.get_translated_text(tp_item["nameKey"], language) if tp_item.get("nameKey") else "",
                    "icon": tp_item["icon"],
                }
                for tp_item in tp
            ]

        return processed_sub_region

    def _get_sub_region_core(
        self,
        sub_region_level: str,
        sub_region_id: int,
        region_id: int,
        reference_center: Optional[List[float]],
    ) -> dict:
        """缓存子区域的语言无关核心结果。"""
        cache_key = f"{self._get_exports_root_cache_key()}|{sub_region_level}|{sub_region_id}|{region_id}|{reference_center}"
        cached = self._shared_sub_region_core_cache.get(cache_key)
        if cached is not None:
            return cached

        with self._shared_sub_region_core_cache_lock:
            key_lock = self._shared_sub_region_core_locks.get(cache_key)
            if key_lock is None:
                from threading import Lock

                key_lock = Lock()
                self._shared_sub_region_core_locks[cache_key] = key_lock

        with key_lock:
            cached = self._shared_sub_region_core_cache.get(cache_key)
            if cached is not None:
                return cached

            derived_pos = self._derive_sub_region_pos(sub_region_level, sub_region_id)
            if derived_pos is not None:
                derived_pos = self._to_vec2(derived_pos) or derived_pos[:2]

            pos = self._to_vec2(reference_center) if isinstance(reference_center, list) else None
            if not pos and derived_pos is not None:
                pos = derived_pos
            sub_region_range = self._get_sub_region_range(sub_region_level, sub_region_id)
            if not reference_center:
                reference_center = pos if pos else (sub_region_range.get("center") if sub_region_range else None)

            rc = self._get_pet_random_creators(sub_region_level, region_id, reference_center)
            tp = self._get_teleport_points_raw(sub_region_id, region_id)

            core = {}
            if pos:
                core["pos"] = pos
            if sub_region_range:
                core["range"] = sub_region_range
            if rc:
                core["rc"] = rc
            if tp:
                core["tp"] = tp

            with self._shared_sub_region_core_cache_lock:
                self._shared_sub_region_core_cache[cache_key] = core
                self._shared_sub_region_core_locks.pop(cache_key, None)
            return core

    def _resolve_exports_root(self) -> Optional[Path]:
        """解析 FModel Exports 根目录。"""
        candidates: List[Path] = []
        exports_root_env = os.getenv("DNA_EXPORTS_ROOT")
        if exports_root_env:
            candidates.append(Path(exports_root_env))
        candidates.append(self.DEFAULT_EXPORTS_ROOT)

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

    @staticmethod
    def _resolve_map_units_per_pixel() -> float:
        """解析地图坐标比例（世界单位/小地图单位）。默认 30。"""
        raw = os.getenv("DNA_MAP_UNITS_PER_PIXEL", "30")
        try:
            value = float(raw)
            if value > 0:
                return value
        except Exception:
            pass
        return 30.0

    def _normalize_level_map_key(self, json_path: Path) -> Optional[str]:
        """从地图 JSON 路径提取用于匹配 SubRegionLevel 的键。"""
        if not isinstance(json_path, Path):
            return None

        stem = json_path.stem
        if not stem:
            return None

        if stem.endswith("_Design"):
            return stem[: -len("_Design")].lower()
        if stem.endswith("_BuiltData"):
            stem = stem[: -len("_BuiltData")]
        if "_Art_" in stem:
            stem = stem.split("_Art_", 1)[0]
        elif stem.endswith("_Art"):
            stem = stem[: -len("_Art")]
        return stem.lower() if stem else None

    def _build_design_map_index(self) -> Dict[str, List[Path]]:
        """构建 SubRegionLevel -> 地图 JSON 文件索引。"""
        if self.design_map_index is not None:
            return self.design_map_index
        exports_root_cache_key = self._get_exports_root_cache_key()
        shared_index = self._shared_design_map_index_cache.get(exports_root_cache_key)
        if shared_index is not None:
            self.design_map_index = shared_index
            return shared_index

        index: Dict[str, List[Path]] = {}
        if self.exports_root is None:
            self.design_map_index = index
            return index

        maps_root = self.exports_root / "EM" / "Content" / "Maps" / "Levels"
        if not maps_root.is_dir():
            self.design_map_index = index
            return index

        for json_path in maps_root.rglob("*.json"):
            if not json_path.is_file():
                continue
            if not (
                json_path.name.endswith("_Design.json")
                or json_path.name.endswith("_BuiltData.json")
            ):
                continue
            key = self._normalize_level_map_key(json_path)
            if not key:
                continue
            index.setdefault(key, []).append(json_path)

        for key, path_list in index.items():
            path_list.sort(
                key=lambda p: (
                    0 if p.name.endswith("_Design.json") else 1,
                    len(str(p)),
                    str(p),
                )
            )
            index[key] = path_list

        self.design_map_index = index
        self._shared_design_map_index_cache[exports_root_cache_key] = index
        return index

    def _resolve_design_map_paths(self, sub_region_level: str) -> List[Path]:
        """根据 SubRegionLevel 解析关卡地图 JSON 路径。"""
        if not isinstance(sub_region_level, str) or not sub_region_level:
            return []
        if sub_region_level in self.design_map_path_cache:
            cached = self.design_map_path_cache[sub_region_level]
            return [cached] if cached is not None else []

        index = self._build_design_map_index()
        candidates = index.get(sub_region_level.lower(), [])
        result = candidates[0] if candidates else None
        self.design_map_path_cache[sub_region_level] = result
        return candidates

    def _resolve_design_map_path(self, sub_region_level: str) -> Optional[Path]:
        """兼容旧调用：返回第一个匹配的地图 JSON 路径。"""
        paths = self._resolve_design_map_paths(sub_region_level)
        return paths[0] if paths else None

    def _load_design_map_json(self, design_map_path: Path) -> List[dict]:
        """读取关卡 Design JSON（带缓存）。"""
        cache_key = str(design_map_path)
        if cache_key in self.design_map_json_cache:
            return self.design_map_json_cache[cache_key]
        shared = self._shared_design_map_json_cache.get(cache_key)
        if shared is not None:
            self.design_map_json_cache[cache_key] = shared
            return shared

        try:
            arr = json.loads(design_map_path.read_text(encoding="utf-8"))
        except Exception:
            self.design_map_json_cache[cache_key] = []
            return []

        if not isinstance(arr, list):
            self.design_map_json_cache[cache_key] = []
            return []

        self.design_map_json_cache[cache_key] = arr
        self._shared_design_map_json_cache[cache_key] = arr
        return arr

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
                _, outer_short_name = SubRegionProcessor._ref_outer_and_name(outer_name)
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
                candidate_outer = candidate.get("Outer")
                candidate_outer_name = (
                    candidate_outer.get("ObjectName")
                    if isinstance(candidate_outer, dict)
                    else candidate_outer
                )
                _, candidate_outer_short = self._ref_outer_and_name(candidate_outer_name)
                if candidate_outer_name == outer or candidate_outer_short == outer:
                    return candidate
        return candidates[0] if candidates else None

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
    def _vec_add(left: List[float], right: List[float]) -> List[float]:
        return [left[0] + right[0], left[1] + right[1], left[2] + right[2]]

    @staticmethod
    def _vec_sub(left: List[float], right: List[float]) -> List[float]:
        return [left[0] - right[0], left[1] - right[1], left[2] - right[2]]

    @staticmethod
    def _format_num(value: float):
        rounded = round(float(value), 6)
        if abs(rounded - round(rounded)) < 1e-6:
            return int(round(rounded))
        return rounded

    def _format_vec3(self, vec: List[float]) -> List:
        return [self._format_num(vec[0]), self._format_num(vec[1]), self._format_num(vec[2])]

    def _format_vec2(self, vec: List[float]) -> List:
        return [self._format_num(vec[0]), self._format_num(vec[1])]

    def _to_vec2(self, vec: List[float]) -> Optional[List[float]]:
        """将二维或三维向量收敛成二维坐标。"""
        if not isinstance(vec, list) or len(vec) < 2:
            return None
        try:
            return [self._format_num(float(vec[0])), self._format_num(float(vec[1]))]
        except Exception:
            return None

    @staticmethod
    def _rotate_xy(x: float, y: float, deg: float) -> Tuple[float, float]:
        rad = math.radians(float(deg))
        cos_v = math.cos(rad)
        sin_v = math.sin(rad)
        return cos_v * x - sin_v * y, sin_v * x + cos_v * y

    def _resolve_region_item(self, region_id) -> Optional[dict]:
        """按 RegionId 读取区域配置。"""
        if not isinstance(self.region_data, dict) or region_id is None:
            return None
        candidates = [region_id]
        if isinstance(region_id, int):
            candidates.append(str(region_id))
        elif isinstance(region_id, str) and region_id.isdigit():
            candidates.append(int(region_id))
        for key in candidates:
            item = self.region_data.get(key)
            if isinstance(item, dict):
                return item
        return None

    def _get_region_map_transform(self, region_id) -> dict:
        """获取世界坐标到小地图坐标转换参数。"""
        cache_key = str(region_id)
        if cache_key in self.region_map_transform_cache:
            return self.region_map_transform_cache[cache_key]

        center_x = 0.0
        center_y = 0.0
        rotation = 0.0
        region_item = self._resolve_region_item(region_id)
        if isinstance(region_item, dict):
            center = region_item.get("RegionMapImageCenter")
            if isinstance(center, list) and len(center) >= 2:
                try:
                    center_x = float(center[0])
                    center_y = float(center[1])
                except Exception:
                    center_x = 0.0
                    center_y = 0.0
            try:
                rotation = float(region_item.get("RegionRotation", 0.0) or 0.0)
            except Exception:
                rotation = 0.0

        transform = {
            "center_x": center_x,
            "center_y": center_y,
            "rotation": rotation,
            "units_per_pixel": self.map_units_per_pixel,
        }
        self.region_map_transform_cache[cache_key] = transform
        return transform

    def _world_to_map_pos(self, world_pos: List, region_id) -> Optional[List]:
        """将世界坐标转换为小地图坐标。"""
        if not isinstance(world_pos, list) or len(world_pos) < 2:
            return None
        try:
            world_x = float(world_pos[0])
            world_y = float(world_pos[1])
        except Exception:
            return None

        transform = self._get_region_map_transform(region_id)
        dx = world_x - transform["center_x"]
        dy = world_y - transform["center_y"]
        rx, ry = self._rotate_xy(dx, dy, transform["rotation"])
        scale = max(float(transform["units_per_pixel"]), 1e-6)
        return [
            self._format_num(rx / scale),
            self._format_num(ry / scale),
        ]

    def _project_world_points_to_map(
        self, world_points: List[List], region_id
    ) -> List[List]:
        """批量转换随机生成点位到小地图坐标。"""
        if not isinstance(world_points, list):
            return []
        projected: List[List] = []
        for world_pos in world_points:
            map_pos = self._world_to_map_pos(world_pos, region_id)
            if map_pos is None:
                continue
            projected.append(map_pos)
        return projected

    def _to_vec2_list(self, points: List[List]) -> List[List]:
        """将三维点列表裁剪为二维坐标列表。"""
        if not isinstance(points, list):
            return []
        result: List[List] = []
        for point in points:
            if not isinstance(point, list) or len(point) < 2:
                continue
            result.append([point[0], point[1]])
        return result

    def _build_range(
        self, center: List[float], extent: List[float], anchor: Optional[List[float]] = None
    ) -> dict:
        """根据 center/extent 生成范围数据。"""
        result = {
            "center": self._format_vec2(center),
            "extent": self._format_vec2(extent),
        }
        if anchor is not None:
            result["anchor"] = self._format_vec2(anchor)
        return result

    def _extract_sub_region_anchor(
        self, arr: List[dict], sub_region_id: int
    ) -> Optional[List[float]]:
        """提取带 SubRegionId Actor 的 DefaultSceneRoot 位置。"""
        if sub_region_id is None:
            return None
        actor_name = None
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            props = obj.get("Properties")
            if not isinstance(props, dict):
                continue
            if str(props.get("SubRegionId")) != str(sub_region_id):
                continue
            name = obj.get("Name")
            if isinstance(name, str) and name:
                actor_name = name
                break
        if not actor_name:
            return None

        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if obj.get("Type") != "SceneComponent":
                continue
            outer = obj.get("Outer")
            outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
            _, outer_short_name = self._ref_outer_and_name(outer_name)
            if outer_short_name != actor_name or obj.get("Name") != "DefaultSceneRoot":
                continue
            props = obj.get("Properties", {})
            anchor = self._to_vec2(self._to_vector3(props.get("RelativeLocation")) or [])
            if anchor is not None:
                return anchor
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

    def _extract_sub_region_pos(self, sub_region_level: str, sub_region_id: int) -> Optional[List[float]]:
        """提取子区域展示坐标。"""
        design_map_paths = self._resolve_design_map_paths(sub_region_level)
        if not design_map_paths:
            return None

        for design_map_path in design_map_paths:
            arr = self._load_design_map_json(design_map_path)
            if not arr:
                continue

            by_outer_name, by_name, by_path = self._build_object_maps(arr)
            for obj in arr:
                if not isinstance(obj, dict):
                    continue
                props = obj.get("Properties")
                if not isinstance(props, dict):
                    continue
                if str(props.get("SubRegionId")) != str(sub_region_id) and str(props.get("Id")) != str(sub_region_id):
                    continue

                loc = self._extract_object_location(obj, by_outer_name, by_name, by_path)
                if loc is not None:
                    return loc

            anchor = self._extract_sub_region_anchor(arr, sub_region_id)
            if anchor is not None:
                return anchor
        return None

    def _collect_sub_region_point_positions(self, sub_region_id: int) -> List[List[float]]:
        """收集与子区域绑定的 RegionPoint / TeleportPoint 坐标。"""
        if sub_region_id is None:
            return []

        positions: List[List[float]] = []
        seen = set()

        for point in self._iter_region_points():
            if self._to_int(point.get("SubRegion")) != self._to_int(sub_region_id):
                continue
            pos = point.get("Pos")
            if not isinstance(pos, list) or len(pos) < 2:
                continue
            try:
                pos2 = [self._format_num(float(pos[0])), self._format_num(float(pos[1]))]
            except Exception:
                continue
            key = (pos2[0], pos2[1])
            if key in seen:
                continue
            seen.add(key)
            positions.append(pos2)

        teleport_points = (
            self.teleport_point_data.values()
            if isinstance(self.teleport_point_data, dict)
            else self.teleport_point_data
            if isinstance(self.teleport_point_data, list)
            else []
        )
        for point in teleport_points:
            if not isinstance(point, dict):
                continue
            if self._to_int(point.get("TeleportPointSubRegion")) != self._to_int(sub_region_id):
                continue
            pos = point.get("MechanismPos")
            if not isinstance(pos, list) or len(pos) < 2:
                pos = point.get("Pos")
            if not isinstance(pos, list) or len(pos) < 2:
                continue
            try:
                pos2 = [self._format_num(float(pos[0])), self._format_num(float(pos[1]))]
            except Exception:
                continue
            key = (pos2[0], pos2[1])
            if key in seen:
                continue
            seen.add(key)
            positions.append(pos2)

        return positions

    def _derive_sub_region_pos(self, sub_region_level: str, sub_region_id: int) -> Optional[List[float]]:
        """根据上游点位合成子区域中心。"""
        center = self._extract_sub_region_pos(sub_region_level, sub_region_id)
        if center is not None:
            return center

        points = self._collect_sub_region_point_positions(sub_region_id)
        if not points:
            return None

        total_x = 0.0
        total_y = 0.0
        for point in points:
            total_x += float(point[0])
            total_y += float(point[1])

        count = len(points)
        if count <= 0:
            return None
        return self._format_vec2([total_x / count, total_y / count])

    def _extract_level_volume_range(self, arr: List[dict]) -> Optional[dict]:
        """提取关卡 LevelVolume 的 Box0 范围。"""
        by_outer_name, by_name, by_path = self._build_object_maps(arr)

        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if obj.get("Type") != "BP_LevelVolume_C":
                continue

            props = obj.get("Properties", {})
            box0 = self._resolve_ref_object(props.get("Box0"), by_outer_name, by_name, by_path)
            if not isinstance(box0, dict):
                outer_name = obj.get("Name")
                for candidate in by_name.get("Box0", []):
                    outer = candidate.get("Outer")
                    candidate_outer = outer.get("ObjectName") if isinstance(outer, dict) else outer
                    _, candidate_outer_short = self._ref_outer_and_name(candidate_outer)
                    if candidate_outer_short == outer_name:
                        box0 = candidate
                        break
            if not isinstance(box0, dict):
                continue

            box_props = box0.get("Properties", {})
            extent = self._to_vector3(box_props.get("BoxExtent"))
            if extent is None:
                continue

            # FModel 导出的组件 RelativeLocation 在这里已经是世界参考坐标；
            # 再叠加 DefaultSceneRoot 会把 LevelVolume 整体偏移一份 Actor 位移。
            center = self._to_vector3(box_props.get("RelativeLocation")) or [0.0, 0.0, 0.0]
            return self._build_range(center, extent)

        return None

    def _get_sub_region_range(self, sub_region_level: str, sub_region_id: int) -> Optional[dict]:
        """按子区域地图解析范围。"""
        design_map_paths = self._resolve_design_map_paths(sub_region_level)
        if not design_map_paths:
            return None

        for design_map_path in design_map_paths:
            arr = self._load_design_map_json(design_map_path)
            if not arr:
                continue

            anchor = self._extract_sub_region_anchor(arr, sub_region_id)
            range_data = self._extract_level_volume_range(arr)
            if range_data is not None:
                if anchor is not None:
                    range_data["anchor"] = self._format_vec2(anchor)
                return range_data
            if anchor is not None:
                return self._build_range(anchor, [0.0, 0.0, 0.0])
        return None

    def _estimate_point_distance_score(
        self, points: List[List], reference_center: Optional[List[float]]
    ) -> Optional[float]:
        """估算点位集合到参考中心的平均距离，越小越可信。"""
        if reference_center is None or not isinstance(points, list) or not points:
            return None
        try:
            ref_x = float(reference_center[0])
            ref_y = float(reference_center[1])
        except Exception:
            return None

        total = 0.0
        count = 0
        for point in points:
            if not isinstance(point, list) or len(point) < 2:
                continue
            try:
                dx = float(point[0]) - ref_x
                dy = float(point[1]) - ref_y
            except Exception:
                continue
            total += math.hypot(dx, dy)
            count += 1
        if count <= 0:
            return None
        return total / count

    def _get_random_actor_points_by_rule(
        self, sub_region_level: str, reference_center: Optional[List[float]] = None
    ) -> Dict[str, List[List]]:
        """提取关卡随机点位：RandomRuleId -> [[x,y,z], ...]。"""
        if not isinstance(sub_region_level, str) or not sub_region_level:
            return {}
        cache_key = f"{sub_region_level}|{reference_center}"
        if cache_key in self.random_actor_points_cache:
            return self.random_actor_points_cache[cache_key]
        exports_root_cache_key = self._get_exports_root_cache_key()
        shared_rules = self._shared_random_actor_points_cache.get(exports_root_cache_key)
        if shared_rules is not None and cache_key in shared_rules:
            self.random_actor_points_cache[cache_key] = shared_rules[cache_key]
            return shared_rules[cache_key]

        design_map_paths = self._resolve_design_map_paths(sub_region_level)
        if not design_map_paths:
            self.random_actor_points_cache[cache_key] = {}
            return {}

        rule_points: Dict[str, List[List]] = {}
        rule_point_set: Dict[str, set] = {}
        design_paths = [path for path in design_map_paths if path.name.endswith("_Design.json")]
        built_paths = [path for path in design_map_paths if path.name.endswith("_BuiltData.json")]

        def collect_random_actor_points(design_map_path: Path, skip_existing_rules: bool = False) -> None:
            arr = self._load_design_map_json(design_map_path)
            if not arr:
                return

            for obj in arr:
                if not isinstance(obj, dict):
                    continue
                props = obj.get("Properties")
                if not isinstance(props, dict):
                    continue
                random_actor_infos = props.get("RandomActorInfos")
                if not isinstance(random_actor_infos, list):
                    continue
                for item in random_actor_infos:
                    if not isinstance(item, dict):
                        continue
                    rule_key = item.get("Key")
                    if rule_key is None:
                        continue
                    value = item.get("Value")
                    if not isinstance(value, dict):
                        continue
                    params = value.get("Params")
                    if not isinstance(params, list):
                        continue
                    rule_id_str = str(rule_key)
                    if skip_existing_rules and rule_id_str in rule_points:
                        continue
                    points = rule_points.setdefault(rule_id_str, [])
                    point_set = rule_point_set.setdefault(rule_id_str, set())
                    for param in params:
                        if not isinstance(param, dict):
                            continue
                        loc = self._to_vector3(param.get("ActorLoc"))
                        if loc is None:
                            continue
                        root_loc = self._resolve_random_actor_root_location(design_map_path)
                        if root_loc is not None:
                            loc = self._vec_add(loc, root_loc)
                        pos = self._format_vec3(loc)
                        pos_tuple = (pos[0], pos[1], pos[2])
                        if pos_tuple in point_set:
                            continue
                        point_set.add(pos_tuple)
                        points.append(pos)

        for design_map_path in design_paths:
            collect_random_actor_points(design_map_path)

        for built_map_path in built_paths:
            collect_random_actor_points(built_map_path, skip_existing_rules=True)

        self.random_actor_points_cache[cache_key] = rule_points
        shared_rules = self._shared_random_actor_points_cache.setdefault(exports_root_cache_key, {})
        shared_rules[cache_key] = rule_points
        return rule_points

    def _resolve_random_actor_root_location(self, design_map_path: Path) -> Optional[List[float]]:
        """读取随机生成器根节点偏移。"""
        try:
            arr = self._load_design_map_json(design_map_path)
        except Exception:
            return None
        if not arr:
            return None
        by_outer_name, by_name, by_path = self._build_object_maps(arr)
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            props = obj.get("Properties", {})
            if not isinstance(props, dict):
                continue
            if obj.get("Type") != "BP_RandomActorDataManager_C":
                continue
            root_ref = props.get("DefaultSceneRoot")
            root_obj = self._resolve_ref_object(root_ref, by_outer_name, by_name, by_path)
            if not isinstance(root_obj, dict):
                continue
            root_props = root_obj.get("Properties", {})
            if not isinstance(root_props, dict):
                continue
            root = self._to_vector3(root_props.get("RelativeLocation"))
            if root is not None:
                return root
        return None

    @staticmethod
    def _merge_unique_rule_ids(*rule_groups) -> List:
        """按首次出现顺序合并规则 ID。"""
        merged = []
        seen = set()
        for group in rule_groups:
            if not isinstance(group, list):
                continue
            for rule_id in group:
                key = str(rule_id)
                if key in seen:
                    continue
                seen.add(key)
                merged.append(rule_id)
        return merged

    def _load_design_level_data(self, sub_region_level):
        """按子区域地图名加载 DesignLevel 数据（带缓存）"""
        if sub_region_level in self.design_level_cache:
            return self.design_level_cache[sub_region_level]
        shared_key = (self.base_cache_key, sub_region_level)
        if shared_key in self._shared_design_level_cache:
            self.design_level_cache[sub_region_level] = self._shared_design_level_cache[shared_key]
            return self.design_level_cache[sub_region_level]
        if shared_key in self._shared_missing_design_level:
            return {}

        file_name = f"DesignLevel_data/{sub_region_level}.json"
        try:
            design_level_data = self.data_loader.load_json(file_name)
        except FileNotFoundError:
            self._shared_missing_design_level.add(shared_key)
            return {}
        except Exception:
            self._shared_missing_design_level.add(shared_key)
            return {}

        if not isinstance(design_level_data, dict):
            self.design_level_cache[sub_region_level] = {}
            return {}

        self.design_level_cache[sub_region_level] = design_level_data
        self._shared_design_level_cache[shared_key] = design_level_data
        return design_level_data

    def _extract_random_rule_ids(self, design_level_data):
        """提取地图中的 RandomRuleId 列表"""
        random_rule_data = design_level_data.get("RandomRule", {})
        if not random_rule_data:
            return []

        random_rule_ids = []
        seen = set()

        if isinstance(random_rule_data, dict):
            for key, value in random_rule_data.items():
                rule_id = None
                if isinstance(value, dict):
                    rule_id = value.get("RandomRuleId")
                if not rule_id:
                    rule_id = key
                if rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)
        elif isinstance(random_rule_data, list):
            for value in random_rule_data:
                if not isinstance(value, dict):
                    continue
                rule_id = value.get("RandomRuleId")
                if not rule_id or rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)

        return random_rule_ids

    def _normalize_rule_id(self, rule_id):
        """将规则 ID 统一为数字优先"""
        if isinstance(rule_id, int):
            return rule_id
        if isinstance(rule_id, str) and rule_id.isdigit():
            return int(rule_id)
        return rule_id

    @staticmethod
    def _to_int(value) -> Optional[int]:
        """将值转换为 int，失败返回 None。"""
        try:
            if value is None or value == "":
                return None
            return int(value)
        except Exception:
            return None

    def _resolve_display_pos(self, point: dict, sub_region_id: int, raw_pos: List[float]) -> List[float]:
        """根据点位类型解析地图展示坐标。"""
        return self._format_vec2(raw_pos)

    def _iter_region_points(self) -> List[dict]:
        """统一遍历 RegionPoint 源数据。"""
        if isinstance(self.region_point_data, dict):
            return [item for item in self.region_point_data.values() if isinstance(item, dict)]
        if isinstance(self.region_point_data, list):
            return [item for item in self.region_point_data if isinstance(item, dict)]
        return []

    def _build_teleport_points_index(self) -> Dict[int, List[dict]]:
        """构建 SubRegionId -> 传送点列表索引。"""
        if self.teleport_points_cache:
            return self.teleport_points_cache

        point_map: Dict[int, Dict[str, dict]] = {}
        for point in self._iter_region_points():
            if self._to_int(point.get("TelepointId")) is None:
                continue

            # 对齐 RegionPointComponent.lua：
            # 地图点挂载到哪个子区域，取的是 RegionPoint.SubRegion；
            # TeleportSubRegion 只是点击后要传送去的目的子区域。
            target_sub_region = self._to_int(point.get("SubRegion"))
            if target_sub_region is None:
                target_sub_region = self._to_int(point.get("TeleportSubRegion"))
            if target_sub_region is None:
                continue

            point_id = self._to_int(point.get("Id"))
            if point_id is None:
                continue

            dedupe_key = f"region_point:{point_id}"
            point_map.setdefault(target_sub_region, {})[dedupe_key] = point

        teleport_points = (
            self.teleport_point_data.values()
            if isinstance(self.teleport_point_data, dict)
            else self.teleport_point_data
            if isinstance(self.teleport_point_data, list)
            else []
        )
        for point in teleport_points:
            if not isinstance(point, dict):
                continue

            target_sub_region = self._to_int(point.get("TeleportPointSubRegion"))
            point_id = self._to_int(point.get("Id"))
            if target_sub_region is None or point_id is None:
                continue

            dedupe_key = f"teleport_point:{point_id}"
            point_map.setdefault(target_sub_region, {})[dedupe_key] = point

        self.teleport_points_cache = {
            sub_region_id: list(items.values()) for sub_region_id, items in point_map.items()
        }
        return self.teleport_points_cache

    @staticmethod
    def _extract_region_point_icon(icon_path: str) -> str:
        """从 RegionPoint Icon 路径中提取 T_Gp_* 图标名。"""
        if not isinstance(icon_path, str) or "T_Gp_" not in icon_path:
            return ""

        t_pos = icon_path.rfind("T_Gp_")
        if t_pos == -1:
            return ""

        icon_part = icon_path[t_pos:]
        if "." in icon_part:
            icon = icon_part.split(".")[0]
        else:
            icon = icon_part
        return icon.rstrip("'")

    def _extract_teleport_icon(self, point: dict) -> str:
        """提取传送点图标，按地图蓝图中的传送点三态图标规则输出。"""
        icon = self._extract_region_point_icon(point.get("Icon", ""))
        if icon:
            return icon

        icon = self._extract_region_point_icon(point.get("TeleportPointIcon", ""))
        if icon:
            return icon

        # LevelMap_Point_Widget_C.lua:
        # 未解锁 -> T_Gp_Trans01
        # 已解锁未完成 -> T_Gp_Trans02
        # 已解锁且关联 Temples/Parties 完成 -> T_Gp_Trans03
        #
        # 当前导出是静态地图数据，不带玩家存档里的实时解锁/完成态，
        # 因此普通传送点默认导出为“已解锁”图标；
        # 仅当该点本身挂了 Temples/Parties 时，使用完成态图标。
        if point.get("Temples") is not None or point.get("Parties") is not None:
            return "T_Gp_Trans03"

        return "T_Gp_Trans02"

    def _get_teleport_points_raw(self, sub_region_id: int, region_id: int) -> List[dict]:
        """提取当前子区域的传送点原始数据。"""
        point_index = self._build_teleport_points_index()
        points = point_index.get(self._to_int(sub_region_id), [])
        if not points:
            return []

        result = []
        dedupe_keys = set()
        for point in points:
            point_id = self._to_int(point.get("Id"))
            if point_id is None:
                continue

            pos = point.get("Pos")
            if not isinstance(pos, list) or len(pos) < 2:
                mechanism_pos = point.get("MechanismPos")
                if isinstance(mechanism_pos, list) and len(mechanism_pos) >= 2:
                    pos = self._resolve_display_pos(point, sub_region_id, mechanism_pos[:2])
                else:
                    pos = None
            else:
                pos = self._format_vec2(pos[:2])
            if not isinstance(pos, list) or len(pos) < 2:
                continue

            name_key = point.get("Name")
            if not name_key:
                name_key = point.get("TeleportPointName")
            icon = self._extract_teleport_icon(point)
            sort_pos = (
                self._to_int(point.get("TeleportPointPos"))
                or self._to_int(point.get("teleportPointPos"))
                or 0
            )
            dedupe_key = (sort_pos, name_key, pos[0], pos[1])
            if dedupe_key in dedupe_keys:
                continue
            dedupe_keys.add(dedupe_key)
            result.append(
                {
                    "id": point_id,
                    "pos": pos[:2],
                    "nameKey": name_key or "",
                    "icon": icon,
                    "_sort": (
                        sort_pos,
                        point_id,
                    ),
                }
            )

        result.sort(key=lambda item: item["_sort"])
        for item in result:
            del item["_sort"]
        return result

    def _get_teleport_points(self, sub_region_id: int, region_id: int, language: str) -> List[dict]:
        """提取当前子区域的传送点。"""
        raw_points = self._get_teleport_points_raw(sub_region_id, region_id)
        if not raw_points:
            return []
        return [
            {
                "id": point["id"],
                "pos": point["pos"],
                "name": self.get_translated_text(point["nameKey"], language) if point.get("nameKey") else "",
                "icon": point["icon"],
            }
            for point in raw_points
        ]

    def _get_pet_random_creators(
        self, sub_region_level, region_id, reference_center: Optional[List[float]] = None
    ):
        """根据地图配置提取 Pet 类型随机生成器信息"""
        design_level_data = self._load_design_level_data(sub_region_level)
        random_actor_points = self._get_random_actor_points_by_rule(
            sub_region_level, reference_center
        )
        random_rule_ids = self._merge_unique_rule_ids(
            self._extract_random_rule_ids(design_level_data) if design_level_data else [],
            list(random_actor_points.keys()),
        )
        if not random_rule_ids:
            return []

        rc = []
        for random_rule_id in random_rule_ids:
            random_creator = self.random_creator_data.get(str(random_rule_id))
            if not random_creator:
                random_creator = self.random_creator_data.get(random_rule_id)
            if not random_creator or random_creator.get("UnitType") != "Pet":
                continue

            info = []
            for unit_info in random_creator.get("RandomInfos", []):
                if not isinstance(unit_info, dict):
                    continue
                unit_id = unit_info.get("UnitId")
                if unit_id is None:
                    continue
                info.append(
                    {
                        "id": unit_id,
                        "w": unit_info.get("Weight", 0),
                    }
                )

            rc_item = {
                "id": self._normalize_rule_id(random_rule_id),
                "info": info,
            }
            count = random_creator.get("Count")
            if isinstance(count, int):
                rc_item["count"] = count
            pos = random_actor_points.get(str(random_rule_id), [])
            if pos:
                rc_item["pos"] = self._to_vec2_list(pos)
            rc.append(rc_item)

        if len(rc) == 1 and "pos" not in rc[0] and isinstance(reference_center, list) and len(reference_center) >= 2:
            fallback_pos = self._to_vec2(reference_center[:2])
            if fallback_pos:
                rc[0]["pos"] = [fallback_pos]

        return rc
