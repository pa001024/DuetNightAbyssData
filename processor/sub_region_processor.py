import json
import math
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from processor.base_processor import BaseProcessor


class SubRegionProcessor(BaseProcessor):
    DEFAULT_EXPORTS_ROOT = Path(r"D:\dev\dna-unpack\Fmodel\Output\Exports")

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SubRegion"
        self.random_creator_data = data_loader.load_json("RandomCreator.json")
        self.region_data = data_loader.load_json("Region.json")
        self.design_level_cache = {}
        self.missing_design_level = set()
        self.exports_root = self._resolve_exports_root()
        self.map_units_per_pixel = self._resolve_map_units_per_pixel()
        self.design_map_index: Optional[Dict[str, List[Path]]] = None
        self.design_map_path_cache: Dict[str, Optional[Path]] = {}
        self.design_map_json_cache: Dict[str, List[dict]] = {}
        self.random_actor_points_cache: Dict[str, Dict[str, List[List]]] = {}
        self.region_map_transform_cache: Dict[str, dict] = {}

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
            "pos": sub_region_data.get("SubRegionCenter", []),
        }
        if not processed_sub_region["rid"] or not processed_sub_region["map"]:
            return None
        if not processed_sub_region["pos"]:
            del processed_sub_region["pos"]
        rc = self._get_pet_random_creators(
            processed_sub_region["map"], processed_sub_region["rid"]
        )
        if rc:
            processed_sub_region["rc"] = rc
        sub_region_range = self._get_sub_region_range(
            processed_sub_region["map"], sub_region_id
        )
        if sub_region_range:
            processed_sub_region["range"] = sub_region_range

        return processed_sub_region

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

    def _build_design_map_index(self) -> Dict[str, List[Path]]:
        """构建 SubRegionLevel -> *_Design.json 的索引。"""
        if self.design_map_index is not None:
            return self.design_map_index

        index: Dict[str, List[Path]] = {}
        if self.exports_root is None:
            self.design_map_index = index
            return index

        maps_root = self.exports_root / "EM" / "Content" / "Maps" / "Levels"
        if not maps_root.is_dir():
            self.design_map_index = index
            return index

        for json_path in maps_root.rglob("*_Design.json"):
            if not json_path.is_file():
                continue
            if not json_path.name.endswith("_Design.json"):
                continue
            level_name = json_path.name[: -len("_Design.json")]
            key = level_name.lower()
            index.setdefault(key, []).append(json_path)

        for key, path_list in index.items():
            path_list.sort(key=lambda p: (len(str(p)), str(p)))
            index[key] = path_list

        self.design_map_index = index
        return index

    def _resolve_design_map_path(self, sub_region_level: str) -> Optional[Path]:
        """根据 SubRegionLevel 解析关卡 Design JSON 路径。"""
        if not isinstance(sub_region_level, str) or not sub_region_level:
            return None
        if sub_region_level in self.design_map_path_cache:
            return self.design_map_path_cache[sub_region_level]

        index = self._build_design_map_index()
        candidates = index.get(sub_region_level.lower(), [])
        result = candidates[0] if candidates else None
        self.design_map_path_cache[sub_region_level] = result
        return result

    def _load_design_map_json(self, design_map_path: Path) -> List[dict]:
        """读取关卡 Design JSON（带缓存）。"""
        cache_key = str(design_map_path)
        if cache_key in self.design_map_json_cache:
            return self.design_map_json_cache[cache_key]

        try:
            arr = json.loads(design_map_path.read_text(encoding="utf-8"))
        except Exception:
            self.design_map_json_cache[cache_key] = []
            return []

        if not isinstance(arr, list):
            self.design_map_json_cache[cache_key] = []
            return []

        self.design_map_json_cache[cache_key] = arr
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
    ) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]]]:
        """构建对象索引，便于从 ObjectRef 快速反查对象。"""
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
        return by_outer_name, by_name

    def _resolve_ref_object(
        self,
        ref_obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
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
        candidates = by_name.get(name, [])
        if len(candidates) == 1:
            return candidates[0]
        if outer and candidates:
            for candidate in candidates:
                if candidate.get("Outer") == outer:
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
            if obj.get("Outer") != actor_name or obj.get("Name") != "DefaultSceneRoot":
                continue
            props = obj.get("Properties", {})
            anchor = self._to_vector3(props.get("RelativeLocation"))
            if anchor is not None:
                return anchor
        return None

    def _extract_level_volume_range(self, arr: List[dict]) -> Optional[dict]:
        """提取关卡 LevelVolume 的 Box0 范围。"""
        by_outer_name, by_name = self._build_object_maps(arr)

        for obj in arr:
            if not isinstance(obj, dict):
                continue
            if obj.get("Type") != "BP_LevelVolume_C":
                continue

            props = obj.get("Properties", {})
            box0 = self._resolve_ref_object(props.get("Box0"), by_outer_name, by_name)
            if not isinstance(box0, dict):
                outer_name = obj.get("Name")
                for candidate in by_name.get("Box0", []):
                    if candidate.get("Outer") == outer_name:
                        box0 = candidate
                        break
            if not isinstance(box0, dict):
                continue

            box_props = box0.get("Properties", {})
            extent = self._to_vector3(box_props.get("BoxExtent"))
            if extent is None:
                continue

            box_offset = self._to_vector3(box_props.get("RelativeLocation")) or [0.0, 0.0, 0.0]
            root_loc = [0.0, 0.0, 0.0]
            root_ref = props.get("DefaultSceneRoot") or props.get("RootComponent")
            root_obj = self._resolve_ref_object(root_ref, by_outer_name, by_name)
            if isinstance(root_obj, dict):
                root_props = root_obj.get("Properties", {})
                root_loc = self._to_vector3(root_props.get("RelativeLocation")) or root_loc

            center = self._vec_add(root_loc, box_offset)
            return self._build_range(center, extent)

        return None

    def _get_sub_region_range(self, sub_region_level: str, sub_region_id: int) -> Optional[dict]:
        """按子区域地图解析范围。"""
        design_map_path = self._resolve_design_map_path(sub_region_level)
        if design_map_path is None:
            return None
        arr = self._load_design_map_json(design_map_path)
        if not arr:
            return None

        anchor = self._extract_sub_region_anchor(arr, sub_region_id)
        range_data = self._extract_level_volume_range(arr)
        if range_data is not None:
            if anchor is not None:
                range_data["anchor"] = self._format_vec2(anchor)
            return range_data
        if anchor is not None:
            return self._build_range(anchor, [0.0, 0.0, 0.0])
        return None

    def _get_random_actor_points_by_rule(
        self, sub_region_level: str
    ) -> Dict[str, List[List]]:
        """提取关卡随机点位：RandomRuleId -> [[x,y,z], ...]。"""
        if not isinstance(sub_region_level, str) or not sub_region_level:
            return {}
        if sub_region_level in self.random_actor_points_cache:
            return self.random_actor_points_cache[sub_region_level]

        design_map_path = self._resolve_design_map_path(sub_region_level)
        if design_map_path is None:
            self.random_actor_points_cache[sub_region_level] = {}
            return {}

        arr = self._load_design_map_json(design_map_path)
        if not arr:
            self.random_actor_points_cache[sub_region_level] = {}
            return {}

        by_outer_name, by_name = self._build_object_maps(arr)
        rule_points: Dict[str, List[List]] = {}
        rule_point_set: Dict[str, set] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            props = obj.get("Properties")
            if not isinstance(props, dict):
                continue
            random_actor_infos = props.get("RandomActorInfos")
            if not isinstance(random_actor_infos, list):
                continue
            root_loc = [0.0, 0.0, 0.0]
            root_ref = props.get("DefaultSceneRoot") or props.get("RootComponent")
            root_obj = self._resolve_ref_object(root_ref, by_outer_name, by_name)
            if isinstance(root_obj, dict):
                root_props = root_obj.get("Properties", {})
                root_loc = self._to_vector3(root_props.get("RelativeLocation")) or root_loc
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
                points = rule_points.setdefault(rule_id_str, [])
                point_set = rule_point_set.setdefault(rule_id_str, set())
                for param in params:
                    if not isinstance(param, dict):
                        continue
                    loc = self._to_vector3(param.get("ActorLoc"))
                    if loc is None:
                        continue
                    loc = self._vec_add(loc, root_loc)
                    pos = self._format_vec3(loc)
                    pos_tuple = (pos[0], pos[1], pos[2])
                    if pos_tuple in point_set:
                        continue
                    point_set.add(pos_tuple)
                    points.append(pos)

        self.random_actor_points_cache[sub_region_level] = rule_points
        return rule_points

    def _load_design_level_data(self, sub_region_level):
        """按子区域地图名加载 DesignLevel 数据（带缓存）"""
        if sub_region_level in self.design_level_cache:
            return self.design_level_cache[sub_region_level]
        if sub_region_level in self.missing_design_level:
            return {}

        file_name = f"DesignLevel_data/{sub_region_level}.json"
        try:
            design_level_data = self.data_loader.load_json(file_name)
        except FileNotFoundError:
            self.missing_design_level.add(sub_region_level)
            return {}
        except Exception:
            self.missing_design_level.add(sub_region_level)
            return {}

        if not isinstance(design_level_data, dict):
            self.design_level_cache[sub_region_level] = {}
            return {}

        self.design_level_cache[sub_region_level] = design_level_data
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

    def _get_pet_random_creators(self, sub_region_level, region_id):
        """根据地图配置提取 Pet 类型随机生成器信息"""
        design_level_data = self._load_design_level_data(sub_region_level)
        if not design_level_data:
            return []

        random_rule_ids = self._extract_random_rule_ids(design_level_data)
        if not random_rule_ids:
            return []
        random_actor_points = self._get_random_actor_points_by_rule(sub_region_level)

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

        return rc
