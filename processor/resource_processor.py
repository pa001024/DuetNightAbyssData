import json
import os
import threading
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple
from processor.base_processor import BaseProcessor


class ResourceProcessor(BaseProcessor):
    _design_level_json_cache: Dict[str, list] = {}
    _resource_source_cache_by_base: Dict[str, Dict[int, List[Dict[str, Any]]]] = {}
    _cache_lock = threading.Lock()

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Resource"
        self.resource_data = data_loader.load_json("Resource.json")
        self.drop_data = data_loader.load_json("Drop.json")
        self.reward_data = data_loader.load_json("Reward.json")
        self.mechanism_data = data_loader.load_json("Mechanism.json")
        self.draft_data = data_loader.load_json("Draft.json")
        self.char_break_data = data_loader.load_json("CharBreak.json")
        self.skill_level_up_data = data_loader.load_json("SkillLevelUp.json")
        self.weapon_break_data = data_loader.load_json("WeaponBreak.json")
        self.shop_item_data = data_loader.load_json("ShopItem.json")
        self.shop_tab_sub_data = data_loader.load_json("ShopTabSub.json")
        self.resource_map = {}
        for resource_id, resource_info in self.resource_data.items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

        self.rarely_to_drop_ids = self._build_rarely_to_drop_ids()
        self.drop_to_resource_ids = self._build_drop_to_resource_ids()
        self.mechanism_to_reward_ids = self._build_mechanism_to_reward_ids()
        self.reward_to_resource_ids = self._build_reward_to_resource_ids()
        self.mechanism_to_resource_ids = self._build_mechanism_to_resource_ids()
        self.draft_resource_ids = self.get_draft_resource_ids()
        self.exports_root = self._resolve_exports_root()
        self.sub_region_data = data_loader.load_json("SubRegion.json")
        self.resource_sources = self._get_or_build_resource_sources()

    def process_item(self, resource_data, language):
        """处理单个资源数据

        Args:
            resource_data: 原始资源数据
            language: 语言类型

        Returns:
            处理后的资源数据，如果资源不在Draft中则返回None
        """
        resource_id = resource_data.get("ResourceId")

        # if resource_id not in self.draft_resource_ids:
        #     return None

        resource_name_key = resource_data.get("ResourceName")
        resource_desc_key = resource_data.get("DetailDes")
        resource_desc2_key = resource_data.get("IpDes")
        resource_name = ""
        resource_desc = ""
        resource_desc2 = ""
        if resource_name_key:
            resource_name = self.get_translated_text(resource_name_key, language)
        if resource_desc_key:
            resource_desc = self.get_translated_text(resource_desc_key, language)
        if resource_desc2_key:
            resource_desc2 = self.get_translated_text(resource_desc2_key, language)

        icon_path = resource_data.get("Icon", "")
        icon = ""
        if "T_" in icon_path:
            t_pos = icon_path.rfind("T_")
            if t_pos != -1:
                icon_part = icon_path[t_pos:]
                if "." in icon_part:
                    icon = icon_part.split(".")[0]
                else:
                    icon = icon_part
                icon = icon.rstrip("'")

        processed_resource = {
            "id": resource_id,
            "name": resource_name,
            "icon": icon,
            "rarity": resource_data.get("Rarity", 1),
        }
        source = self.resource_sources.get(resource_id)
        if source:
            filtered_source = [
                item for item in source if item.get("srId") != 210101
            ]
            if filtered_source:
                processed_resource["source"] = filtered_source
        if resource_desc:
            processed_resource["desc"] = resource_desc
        if resource_desc2:
            processed_resource["desc2"] = resource_desc2

        return processed_resource

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
        """获取缓存键。"""
        if self.exports_root is None:
            return "__none__"
        try:
            return str(self.exports_root.resolve())
        except Exception:
            return str(self.exports_root)

    def _get_or_build_resource_sources(self) -> Dict[int, List[Dict[str, Any]]]:
        """构建资源来源坐标索引。"""
        cache_key = self._get_exports_root_cache_key()
        cached = self._resource_source_cache_by_base.get(cache_key)
        if cached is not None:
            return cached

        with self._cache_lock:
            cached = self._resource_source_cache_by_base.get(cache_key)
            if cached is not None:
                return cached

            sources: Dict[int, List[Dict[str, Any]]] = {}
            self._collect_resource_sources_from_design_levels(sources)

            self._resource_source_cache_by_base[cache_key] = sources
            return sources

    def _load_design_level_json(self, json_path: Path) -> list:
        """加载设计层 JSON。"""
        cache_key = str(json_path)
        cached = self._design_level_json_cache.get(cache_key)
        if cached is not None:
            return cached
        try:
            data = json.loads(json_path.read_text(encoding="utf-8"))
        except Exception:
            data = {}
        if not isinstance(data, (list, dict)):
            data = []
        self._design_level_json_cache[cache_key] = data
        return data

    def _collect_resource_sources_from_design_levels(
        self, sources: Dict[int, List[Dict[str, Any]]]
    ) -> None:
        """从设计层数据收集资源实例坐标。"""
        design_map_paths = self._resolve_design_map_paths()
        if not design_map_paths:
            return

        level_to_sub_region_id: Dict[str, int] = {}
        for _, info in self.sub_region_data.items():
            if not isinstance(info, dict):
                continue
            level_name = info.get("SubRegionLevel")
            sub_region_id = self._to_int(info.get("SubRegionId"))
            if isinstance(level_name, str) and level_name and sub_region_id is not None:
                level_to_sub_region_id[level_name.lower()] = sub_region_id

        for json_path in design_map_paths:
            sub_region_id = level_to_sub_region_id.get(self._normalize_level_map_key(json_path))
            if sub_region_id is None:
                continue
            level_data = self._load_design_level_json(json_path)
            by_outer_name, by_name, by_path = self._build_object_maps(level_data)
            self._collect_resource_sources_from_design_level(
                level_data, sub_region_id, sources, by_outer_name, by_name, by_path
            )

    def _resolve_design_map_paths(self) -> List[Path]:
        """解析设计层地图 JSON 列表。"""
        candidates: List[Path] = []
        exports_root_env = os.getenv("DNA_EXPORTS_ROOT")
        if exports_root_env:
            candidates.append(Path(exports_root_env))
        candidates.append(
            Path("..")
            / "dna-unpack"
            / "Fmodel"
            / "Output"
            / "Exports"
            / "EM"
            / "Content"
            / "Maps"
            / "Levels"
        )

        for base in candidates:
            if base is None:
                continue
            maps_root = base if base.name == "Levels" else base / "EM" / "Content" / "Maps" / "Levels"
            if not maps_root.is_dir():
                continue
            return sorted(
                [
                    json_path
                    for json_path in maps_root.rglob("*.json")
                    if json_path.name.endswith("_Design.json")
                ],
                key=lambda p: str(p),
            )
        return []

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

    @staticmethod
    def _normalize_source_pos(pos: List[Any]) -> Optional[List[float]]:
        """将 source 坐标归一化为二维列表。"""
        if not isinstance(pos, list) or len(pos) < 2:
            return None
        try:
            x = float(pos[0])
            y = float(pos[1])
        except Exception:
            return None
        if abs(x - round(x)) < 1e-6:
            x = int(round(x))
        if abs(y - round(y)) < 1e-6:
            y = int(round(y))
        return [x, y]

    @staticmethod
    def _to_int(value: Any) -> Optional[int]:
        """将值转为 int，失败返回 None。"""
        if isinstance(value, int):
            return value
        if isinstance(value, str) and value.isdigit():
            return int(value)
        return None

    def _collect_resource_sources_from_design_level(
        self,
        level_data: Any,
        sub_region_id: int,
        sources: Dict[int, List[Dict[str, Any]]],
        by_outer_name: Optional[Dict[Tuple[str, str], dict]] = None,
        by_name: Optional[Dict[str, List[dict]]] = None,
        by_path: Optional[Dict[str, dict]] = None,
    ) -> None:
        """从设计层数据提取资源来源。"""
        unit_based_resource_ids = set()
        for node in self._iter_design_level_nodes(level_data):
            if not isinstance(node, dict):
                continue
            props = node.get("Properties", {})
            if not isinstance(props, dict):
                continue
            resource_ids = self._extract_resource_ids_from_node(node, props)
            if not resource_ids:
                continue
            unit_id = self._to_int(props.get("UnitId"))
            static_creator_id = self._to_int(props.get("StaticCreatorId"))
            if unit_id is not None or static_creator_id is not None:
                for resource_id, _ in resource_ids:
                    unit_based_resource_ids.add(resource_id)

        for node in self._iter_design_level_nodes(level_data):
            if not isinstance(node, dict):
                continue
            props = node.get("Properties", {})
            if not isinstance(props, dict):
                continue
            resource_ids = self._extract_resource_ids_from_node(node, props)
            if not resource_ids:
                continue
            unit_id = self._to_int(props.get("UnitId"))
            static_creator_id = self._to_int(props.get("StaticCreatorId"))
            if (
                unit_id is None
                and static_creator_id is None
                and len(resource_ids) == 1
                and resource_ids[0][0] in unit_based_resource_ids
            ):
                continue
            pos = self._extract_design_level_pos(node, by_outer_name, by_name, by_path)
            if pos is None:
                continue
            for resource_id, reward_id in resource_ids:
                resource_sources = sources.setdefault(resource_id, [])
                source_item = self._get_or_create_source_item(resource_sources, sub_region_id, reward_id)
                if not source_item:
                    continue
                self._append_source_pos(source_item, pos)

    @staticmethod
    def _iter_design_level_nodes(level_data: Any):
        """遍历设计层可扫描节点。"""
        if isinstance(level_data, list):
            for node in level_data:
                yield node
            return
        if isinstance(level_data, dict):
            for group_data in level_data.values():
                if isinstance(group_data, dict):
                    for node in group_data.values():
                        if isinstance(node, dict):
                            yield node
                elif isinstance(group_data, list):
                    for node in group_data:
                        if isinstance(node, dict):
                            yield node

    def _extract_resource_ids_from_node(
        self, node: dict, props: Dict[str, Any]
    ) -> List[Tuple[int, Optional[int]]]:
        """从设计层节点提取资源 ID 和可选 RewardId。"""
        resource_ids: List[Tuple[int, Optional[int]]] = []

        def has_resource_id(candidate_id: Optional[int]) -> bool:
            return any(item_id == candidate_id for item_id, _ in resource_ids)

        resource_id = self._to_int(props.get("ResourceId"))
        if resource_id is not None and resource_id in self.resource_map:
            resource_ids.append((resource_id, None))

        unit_id = self._to_int(props.get("UnitId"))
        static_creator_id = self._to_int(props.get("StaticCreatorId"))
        rarely_id = self._to_int(props.get("RarelyId"))

        if unit_id is not None:
            for resource_id in self.drop_to_resource_ids.get(unit_id, []):
                if resource_id in self.resource_map and not has_resource_id(resource_id):
                    resource_ids.append((resource_id, None))

        if (unit_id is not None or static_creator_id is not None) and rarely_id is not None:
            for drop_id in self.rarely_to_drop_ids.get(rarely_id, []):
                for resource_id in self.drop_to_resource_ids.get(drop_id, []):
                    if resource_id in self.resource_map and not has_resource_id(resource_id):
                        resource_ids.append((resource_id, None))

        mechanism_id = unit_id if unit_id is not None else static_creator_id
        if mechanism_id is not None:
            for resource_id, reward_id in self.mechanism_to_resource_ids.get(mechanism_id, []):
                if resource_id in self.resource_map and not has_resource_id(resource_id):
                    resource_ids.append((resource_id, reward_id))

        return resource_ids

    def _build_rarely_to_drop_ids(self) -> Dict[int, List[int]]:
        """构建 RarelyId -> DropId 映射。"""
        mapping: Dict[int, List[int]] = {}
        for drop in self.drop_data.values():
            if not isinstance(drop, dict):
                continue
            rarely_id = self._to_int(drop.get("RarelyId"))
            drop_id = self._to_int(drop.get("DropId"))
            if rarely_id is None or drop_id is None:
                continue
            mapping.setdefault(rarely_id, [])
            if drop_id not in mapping[rarely_id]:
                mapping[rarely_id].append(drop_id)
        return mapping

    def _build_drop_to_resource_ids(self) -> Dict[int, List[int]]:
        """构建 DropId -> ResourceId 列表映射。"""
        mapping: Dict[int, List[int]] = {}
        for drop in self.drop_data.values():
            if not isinstance(drop, dict):
                continue
            if drop.get("UseEffectType") != "GetResource":
                continue

            drop_id = self._to_int(drop.get("DropId"))
            resource_id = self._to_int(drop.get("UseParam"))
            if drop_id is None or resource_id is None:
                continue
            mapping.setdefault(drop_id, [])
            if resource_id not in mapping[drop_id]:
                mapping[drop_id].append(resource_id)
        return mapping

    def _build_mechanism_to_reward_ids(self) -> Dict[int, List[int]]:
        """构建 Mechanism(UnitId) -> RewardId 列表映射。"""
        mapping: Dict[int, List[int]] = {}
        for mechanism in self.mechanism_data.values():
            if not isinstance(mechanism, dict):
                continue
            unit_id = self._to_int(mechanism.get("UnitId"))
            reward_id = self._to_int(mechanism.get("RewardId"))
            if unit_id is None or reward_id is None:
                continue
            mapping.setdefault(unit_id, [])
            if reward_id not in mapping[unit_id]:
                mapping[unit_id].append(reward_id)
        return mapping

    def _build_reward_to_resource_ids(self) -> Dict[int, List[int]]:
        """构建 RewardId -> ResourceId 列表映射。"""
        mapping: Dict[int, List[int]] = {}
        for reward in self.reward_data.values():
            if not isinstance(reward, dict):
                continue
            reward_id = self._to_int(reward.get("RewardId"))
            if reward_id is None:
                continue

            reward_ids = self._normalize_list_field(reward.get("Id", []))
            reward_types = self._normalize_list_field(reward.get("Type", []))
            for index, reward_type in enumerate(reward_types):
                if reward_type != "Resource" or index >= len(reward_ids):
                    continue
                resource_id = self._to_int(reward_ids[index])
                if resource_id is None:
                    continue
                mapping.setdefault(reward_id, [])
                if resource_id not in mapping[reward_id]:
                    mapping[reward_id].append(resource_id)
        return mapping

    def _build_mechanism_to_resource_ids(self) -> Dict[int, List[Tuple[int, int]]]:
        """构建 Mechanism(UnitId) -> ResourceId/RewardId 列表映射。"""
        mapping: Dict[int, List[Tuple[int, int]]] = {}
        for unit_id, reward_ids in self.mechanism_to_reward_ids.items():
            for reward_id in reward_ids:
                for resource_id in self.reward_to_resource_ids.get(reward_id, []):
                    mapping.setdefault(unit_id, [])
                    pair = (resource_id, reward_id)
                    if pair not in mapping[unit_id]:
                        mapping[unit_id].append(pair)
        return mapping

    @staticmethod
    def _normalize_list_field(value: Any) -> List[Any]:
        """兼容 list/dict/scalar 的字段，统一返回 list。"""
        if isinstance(value, list):
            return value
        if isinstance(value, dict):
            max_index = 0
            index_map: Dict[int, Any] = {}
            for key, item in value.items():
                try:
                    index = int(key)
                except Exception:
                    continue
                index_map[index] = item
                if index > max_index:
                    max_index = index
            return [index_map.get(i) for i in range(max_index + 1)]
        if value is None:
            return []
        return [value]

    def _extract_design_level_pos(
        self,
        node: dict,
        by_outer_name: Optional[Dict[Tuple[str, str], dict]] = None,
        by_name: Optional[Dict[str, List[dict]]] = None,
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[List[float]]:
        """从设计层节点提取坐标。"""
        if not isinstance(node, dict):
            return None
        props = node.get("Properties", {})
        if not isinstance(props, dict):
            return None

        for key in ("RelativeLocation", "Location"):
            pos = self._to_vector3(props.get(key))
            if pos is not None:
                return [pos[0], pos[1]]

        transform = props.get("RelativeTransform")
        if isinstance(transform, dict):
            pos = self._to_vector3(transform.get("Translation"))
            if pos is not None:
                return [pos[0], pos[1]]

        root_ref = props.get("RootComponent") or props.get("DefaultSceneRoot")
        if root_ref is not None and by_outer_name is not None and by_name is not None:
            pos = self._extract_ref_location(root_ref, by_outer_name, by_name, by_path)
            if pos is not None:
                return [pos[0], pos[1]]

        attach_parent_ref = props.get("AttachParent")
        if attach_parent_ref is not None and by_outer_name is not None and by_name is not None:
            pos = self._extract_ref_location(attach_parent_ref, by_outer_name, by_name, by_path)
            if pos is not None:
                return [pos[0], pos[1]]

        for component_key in ("Sphere", "SceneComponent", "CollisionComponent"):
            component_ref = props.get(component_key)
            if component_ref is None:
                continue
            if by_outer_name is None or by_name is None:
                continue
            pos = self._extract_ref_location(component_ref, by_outer_name, by_name, by_path)
            if pos is not None:
                return [pos[0], pos[1]]

        blueprint_components = props.get("BlueprintCreatedComponents")
        if isinstance(blueprint_components, list) and by_outer_name is not None and by_name is not None:
            for component_ref in blueprint_components:
                pos = self._extract_ref_location(component_ref, by_outer_name, by_name, by_path)
                if pos is not None:
                    return [pos[0], pos[1]]

        return None

    @staticmethod
    def _ref_outer_and_name(object_name: Optional[str]) -> Tuple[Optional[str], Optional[str]]:
        """解析对象引用的 Outer 与短名。"""
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
    def _build_object_maps(arr: List[dict]) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
        """构建对象查找索引。"""
        by_outer_name: Dict[Tuple[str, str], dict] = {}
        by_name: Dict[str, List[dict]] = {}
        by_path: Dict[str, dict] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            name = obj.get("Name")
            if isinstance(name, str) and name:
                by_name.setdefault(name, []).append(obj)
            outer = obj.get("Outer")
            outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
            outer_short_name = None
            if isinstance(outer_name, str):
                _, outer_short_name = ResourceProcessor._ref_outer_and_name(outer_name)
            if isinstance(outer_name, str) and isinstance(name, str):
                by_outer_name[(outer_name, name)] = obj
            if isinstance(outer_short_name, str) and isinstance(name, str):
                by_outer_name[(outer_short_name, name)] = obj
            object_path = obj.get("ObjectPath")
            if isinstance(object_path, str) and object_path:
                by_path[object_path] = obj
        return by_outer_name, by_name, by_path

    @staticmethod
    def _to_vector3(value) -> Optional[List[float]]:
        """将向量数据转为三元坐标。"""
        if not isinstance(value, dict):
            return None
        x = value.get("X")
        y = value.get("Y")
        z = value.get("Z")
        if x is None or y is None:
            return None
        try:
            return [float(x), float(y), float(z if z is not None else 0.0)]
        except Exception:
            return None

    def _resolve_ref_object(
        self,
        ref_obj: Optional[dict],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[dict]:
        """解析对象引用。"""
        if not isinstance(ref_obj, dict):
            return None
        object_name = ref_obj.get("ObjectName")
        object_path = ref_obj.get("ObjectPath")
        outer_name, short_name = self._ref_outer_and_name(object_name)
        if by_path is not None and isinstance(object_path, str) and object_path in by_path:
            return by_path[object_path]
        if outer_name and short_name:
            found = by_outer_name.get((outer_name, short_name))
            if found is not None:
                return found
        if short_name:
            candidates = by_name.get(short_name, [])
            if len(candidates) == 1:
                return candidates[0]
        return None

    def _extract_ref_location(
        self,
        ref_obj: Optional[dict],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[List[float]]:
        """从引用对象中提取位置。"""
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

    @staticmethod
    def _get_or_create_source_item(
        resource_sources: List[Dict[str, Any]], sub_region_id: int, reward_id: Optional[int] = None
    ) -> Optional[Dict[str, Any]]:
        """获取同 srId 的 source 项，必要时新建。"""
        if sub_region_id == 210101:
            return None
        for source_item in resource_sources:
            if source_item.get("srId") == sub_region_id and source_item.get("rewardId") == reward_id:
                return source_item
        source_item = {"srId": sub_region_id}
        if reward_id is not None:
            source_item["rewardId"] = reward_id
        source_item["pos"] = []
        resource_sources.append(source_item)
        return source_item

    @staticmethod
    def _append_source_pos(source_item: Dict[str, Any], pos: List[float]) -> None:
        """向 source 项追加坐标并避免重复。"""
        if not isinstance(source_item, dict):
            return
        source_pos = source_item.setdefault("pos", [])
        if not isinstance(source_pos, list):
            source_item["pos"] = []
            source_pos = source_item["pos"]
        normalized_pos = [float(pos[0]), float(pos[1])]
        for existing_pos in source_pos:
            if (
                isinstance(existing_pos, list)
                and len(existing_pos) >= 2
                and abs(float(existing_pos[0]) - normalized_pos[0]) < 1e-6
                and abs(float(existing_pos[1]) - normalized_pos[1]) < 1e-6
            ):
                return
        source_pos.append(
            [
                ResourceProcessor._format_source_pos_value(normalized_pos[0]),
                ResourceProcessor._format_source_pos_value(normalized_pos[1]),
            ]
        )

    @staticmethod
    def _format_source_pos_value(value: float) -> float:
        """保留 source 坐标的整数外观。"""
        if abs(value - round(value)) < 1e-6:
            return int(round(value))
        return round(value, 6)

    def get_draft_resource_ids(self):
        """获取所有需要导出的资源ID

        Returns:
            需要导出的资源ID集合
        """
        resource_ids = set()

        # 从 Draft 中收集资源
        for draft_id, draft_info in self.draft_data.items():
            product_id = draft_info.get("ProductId")
            product_type = draft_info.get("ProductType")

            if product_type == "Resource" and product_id:
                resource_ids.add(product_id)

            resources = draft_info.get("Resource", [])
            for resource in resources:
                resource_type = resource.get("Type")
                if resource_type == "Resource":
                    resource_ids.add(resource.get("Id"))

        # 从 CharBreak 中收集资源
        for char_id, break_list in self.char_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 SkillLevelUp 中收集资源
        for skill_id, level_list in self.skill_level_up_data.items():
            if isinstance(level_list, list):
                for level_stage in level_list:
                    item_ids = level_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 WeaponBreak 中收集资源
        for weapon_id, break_list in self.weapon_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 ShopItem 中收集资源
        for shop_item_id, shop_item_info in self.shop_item_data.items():
            # 收集商品类型为Resource的TypeId
            item_type = shop_item_info.get("ItemType")
            type_id = shop_item_info.get("TypeId")
            if item_type == "Resource" and type_id:
                resource_ids.add(type_id)

            # 收集PriceType（消耗的资源类型）
            price_type = shop_item_info.get("PriceType")
            if price_type:
                resource_ids.add(price_type)

        return resource_ids

    def process_draft_resources(self, language):
        """处理Draft中出现的资源

        Args:
            language: 语言类型

        Returns:
            处理后的资源列表
        """
        draft_resource_ids = self.get_draft_resource_ids()

        processed_resources = []
        for resource_id in sorted(draft_resource_ids):
            if resource_id in self.resource_map:
                resource_data = self.resource_map[resource_id]
                processed = self.process_item(resource_data, language)
                if processed:
                    processed_resources.append(processed)

        return processed_resources
