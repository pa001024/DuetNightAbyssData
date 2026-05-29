import json
import os
import threading
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple
from processor.base_processor import BaseProcessor


class ResourceProcessor(BaseProcessor):
    _shared_build_locks: Dict[Tuple[str, str, str], threading.Lock] = {}
    _shared_build_locks_lock = threading.Lock()
    _shared_resource_sources_cache: Dict[str, Dict[int, List[Dict[str, Any]]]] = {}
    _shared_design_map_paths_cache: Dict[Tuple[str, str], List[Path]] = {}
    _shared_design_level_json_cache: Dict[str, list] = {}
    _shared_design_map_json_cache: Dict[str, list] = {}
    _shared_level_to_sub_region_id_cache: Dict[str, Dict[str, int]] = {}
    _shared_design_data_dirs_cache: Dict[str, List[Path]] = {}
    _shared_design_dir_files_cache: Dict[str, List[Path]] = {}
    _shared_random_rule_to_resource_ids_cache: Dict[
        str, Dict[int, List[Tuple[int, Optional[int]]]]
    ] = {}
    _shared_design_level_unit_id_cache: Dict[str, Dict[int, int]] = {}

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Resource"
        self.resource_data = data_loader.load_json("Resource.json")
        self.drop_data = data_loader.load_json("Drop.json")
        self.reward_data = data_loader.load_json("Reward.json")
        self.mechanism_data = data_loader.load_json("Mechanism.json")
        self.random_creator_data = data_loader.load_json("RandomCreator.json")
        self.resource_map = {
            resource_info.get("ResourceId"): resource_info
            for resource_info in self.resource_data.values()
            if isinstance(resource_info, dict)
        }

        self.exports_root = self._resolve_exports_root()
        self.sub_region_data = data_loader.load_json("SubRegion.json")
        self.resource_sources = None
        self.rarely_to_drop_ids = None
        self.drop_to_resource_ids = None
        self.mechanism_to_reward_ids = None
        self.reward_to_resource_ids = None
        self.mechanism_to_resource_ids = None
        self.random_rule_to_resource_ids = None
        self.draft_resource_ids = None
        self.design_level_unit_ids = None

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
        if resource_desc:
            processed_resource["desc"] = resource_desc
        if resource_desc2:
            processed_resource["desc2"] = resource_desc2
        if resource_data.get("UseEffectType") == "RandomSelectPack":
            pack = self._to_int(resource_data.get("UseParam"))
            if pack is not None:
                processed_resource["pack"] = pack
        if resource_data.get("UseEffectType") == "SelectResource":
            select = self._to_int(resource_data.get("UseParam"))
            if select is not None:
                processed_resource["select"] = select
        source = self._get_resource_sources().get(resource_id)
        if source:
            filtered_source = [item for item in source if item.get("srId") != 210101]
            if filtered_source:
                filtered_source.sort(key=self._sort_source_items_key)
                processed_resource["source"] = filtered_source

        return processed_resource

    def _get_resource_sources(self) -> Dict[int, List[Dict[str, Any]]]:
        """按需获取资源来源索引。"""
        if self.resource_sources is None:
            self.resource_sources = self._get_or_build_resource_sources()
        return self.resource_sources

    def _ensure_resource_link_maps(self) -> None:
        """按需构建资源链路映射。"""
        if (
            self.rarely_to_drop_ids is not None
            and self.drop_to_resource_ids is not None
            and self.mechanism_to_reward_ids is not None
            and self.reward_to_resource_ids is not None
            and self.mechanism_to_resource_ids is not None
            and self.random_rule_to_resource_ids is not None
            and self.design_level_unit_ids is not None
        ):
            return
        self.rarely_to_drop_ids = self._build_rarely_to_drop_ids()
        self.drop_to_resource_ids = self._build_drop_to_resource_ids()
        self.mechanism_to_reward_ids = self._build_mechanism_to_reward_ids()
        self.reward_to_resource_ids = self._build_reward_to_resource_ids()
        self.mechanism_to_resource_ids = self._build_mechanism_to_resource_ids()
        self.random_rule_to_resource_ids = self._build_random_rule_to_resource_ids()
        self.design_level_unit_ids = self._build_design_level_unit_ids()

    def _get_draft_resource_ids(self):
        """按需获取 Draft 资源集合。"""
        if self.draft_resource_ids is None:
            self.draft_resource_ids = self.get_draft_resource_ids()
        return self.draft_resource_ids

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
        with self._shared_build_locks_lock:
            cached = self._shared_resource_sources_cache.get(cache_key)
            if cached is not None:
                return cached

        build_lock = self._get_shared_build_lock(
            ("resource_processor", cache_key, "resource_sources")
        )
        with build_lock:
            with self._shared_build_locks_lock:
                cached = self._shared_resource_sources_cache.get(cache_key)
                if cached is not None:
                    return cached

            sources: Dict[int, List[Dict[str, Any]]] = {}
            self._collect_resource_sources_from_design_levels(sources)

            with self._shared_build_locks_lock:
                cached = self._shared_resource_sources_cache.get(cache_key)
                if cached is not None:
                    return cached
                self._shared_resource_sources_cache[cache_key] = sources
            with BaseProcessor._shared_items_cache_lock:
                BaseProcessor._shared_items_cache[
                    self._shared_cache_key("resource_sources")
                ] = sources
            return sources

    def _get_shared_build_lock(self, cache_key: Tuple[str, str, str]) -> threading.Lock:
        """获取共享构建锁，避免并发重复构建同一缓存。"""
        with self._shared_build_locks_lock:
            lock = self._shared_build_locks.get(cache_key)
            if lock is None:
                lock = threading.Lock()
                self._shared_build_locks[cache_key] = lock
            return lock

    def _shared_cache_key(self, suffix: str) -> Tuple[str, str, str]:
        """生成进程共享缓存键。"""
        return ("resource_processor", self._get_exports_root_cache_key(), suffix)

    def _load_design_level_json(self, json_path: Path) -> list:
        """加载设计层 JSON。"""
        resolved_path = json_path.resolve()
        cache_key = str(resolved_path)
        with self._shared_build_locks_lock:
            cached = self._shared_design_level_json_cache.get(cache_key)
            if cached is not None:
                return cached
        build_lock = self._get_shared_build_lock(cache_key)
        with build_lock:
            with self._shared_build_locks_lock:
                cached = self._shared_design_level_json_cache.get(cache_key)
                if cached is not None:
                    return cached
        try:
            data = json.loads(resolved_path.read_text(encoding="utf-8"))
        except Exception:
            data = {}
        if not isinstance(data, (list, dict)):
            data = []
        with self._shared_build_locks_lock:
            cached = self._shared_design_level_json_cache.get(cache_key)
            if cached is not None:
                return cached
            self._shared_design_level_json_cache[cache_key] = data
        return data

    def _collect_resource_sources_from_design_levels(
        self, sources: Dict[int, List[Dict[str, Any]]]
    ) -> None:
        """从设计层数据收集资源实例坐标。"""
        level_to_sub_region_id = self._get_shared_level_to_sub_region_id_map()
        if level_to_sub_region_id is None:
            level_to_sub_region_id = {}
            for _, info in self.sub_region_data.items():
                if not isinstance(info, dict):
                    continue
                level_name = info.get("SubRegionLevel")
                sub_region_id = self._to_int(info.get("SubRegionId"))
                if (
                    isinstance(level_name, str)
                    and level_name
                    and sub_region_id is not None
                ):
                    level_to_sub_region_id[level_name.lower()] = sub_region_id
            with self._shared_build_locks_lock:
                self._shared_level_to_sub_region_id_cache[
                    self._get_exports_root_cache_key()
                ] = level_to_sub_region_id

        level_order = self._build_sub_region_level_order()
        if not level_order:
            return

        design_map_paths: List[Path] = []
        for level_name in level_order:
            design_map_paths.extend(
                self._resolve_design_map_paths_for_level(level_name)
            )

        design_map_paths.sort(key=lambda p: str(p))
        for json_path in design_map_paths:
            sub_region_id = level_to_sub_region_id.get(
                self._normalize_level_map_key(json_path)
            )
            if sub_region_id is None:
                continue
            self._collect_resource_sources_for_design_job(
                json_path, sub_region_id, sources
            )

    def _get_shared_level_to_sub_region_id_map(self) -> Optional[Dict[str, int]]:
        """读取共享的 SubRegionLevel -> SubRegionId 索引。"""
        cache_key = self._get_exports_root_cache_key()
        with self._shared_build_locks_lock:
            cached = self._shared_level_to_sub_region_id_cache.get(cache_key)
            if isinstance(cached, dict):
                return cached
        return None

    def _collect_resource_sources_for_design_job(
        self,
        json_path: Path,
        sub_region_id: int,
        sources: Optional[Dict[int, List[Dict[str, Any]]]] = None,
    ) -> Dict[int, List[Dict[str, Any]]]:
        """处理单个设计层并返回该层的资源来源结果。"""
        self._ensure_resource_link_maps()
        level_data = self._load_design_level_json(json_path)
        combined_level_data = self._build_design_level_scope(json_path, level_data)
        by_outer_name, by_name, by_path = self._build_object_maps(combined_level_data)
        local_sources: Dict[int, List[Dict[str, Any]]] = {}
        self._collect_resource_sources_from_design_level(
            combined_level_data,
            sub_region_id,
            local_sources,
            by_outer_name,
            by_name,
            by_path,
        )
        self._collect_resource_sources_from_random_rule_points(
            json_path,
            level_data,
            sub_region_id,
            local_sources,
        )
        if sources is not None:
            self._merge_resource_sources(sources, local_sources)
        return local_sources

    def _merge_resource_sources(
        self,
        target: Dict[int, List[Dict[str, Any]]],
        source: Dict[int, List[Dict[str, Any]]],
    ) -> None:
        """合并单个设计层的资源来源结果。"""
        for resource_id, source_items in source.items():
            target_items = target.setdefault(resource_id, [])
            for source_item in source_items:
                if not isinstance(source_item, dict):
                    continue
                target_item = self._get_or_create_source_item(
                    target_items,
                    source_item.get("srId"),
                    source_item.get("rewardId"),
                )
                if not target_item:
                    continue
                for pos in source_item.get("pos", []):
                    self._append_source_pos(target_item, pos)

    def _build_design_level_scope(
        self, design_json_path: Path, level_data: Any
    ) -> List[Any]:
        """构建设计层可用的数据范围，只加载当前设计层。"""
        combined_level_data: List[Any] = []
        self._append_level_data(combined_level_data, level_data)
        return combined_level_data

    @staticmethod
    def _append_level_data(target: List[Any], level_data: Any) -> None:
        """把单个 JSON 数据追加到合并列表。"""
        if isinstance(level_data, list):
            target.extend(level_data)
        elif isinstance(level_data, dict):
            target.append(level_data)

    def _resolve_design_map_paths_for_level(self, level_name: str) -> List[Path]:
        """按 SubRegionLevel 懒加载对应的设计层 JSON。"""
        maps_root = self._resolve_maps_root()
        if maps_root is None or not level_name:
            return []

        cache_key = (self._get_exports_root_cache_key(), level_name)
        with self._shared_build_locks_lock:
            cached = self._shared_design_map_paths_cache.get(cache_key)
            if cached is not None:
                return cached

        build_lock = self._get_shared_build_lock(
            ("resource_processor", cache_key[0], f"design_paths:{level_name}")
        )
        with build_lock:
            with self._shared_build_locks_lock:
                cached = self._shared_design_map_paths_cache.get(cache_key)
                if cached is not None:
                    return cached

            matched_paths: List[Path] = []
            for design_dir in self._iter_design_data_dirs(maps_root):
                for json_path in self._iter_design_dir_design_files(design_dir):
                    if self._normalize_level_map_key(json_path) != level_name:
                        continue
                    matched_paths.append(json_path)

            matched_paths.sort(key=lambda p: (len(str(p)), str(p)))
            with self._shared_build_locks_lock:
                cached = self._shared_design_map_paths_cache.get(cache_key)
                if cached is not None:
                    return cached
                self._shared_design_map_paths_cache[cache_key] = matched_paths
            return matched_paths

    def _resolve_maps_root(self) -> Optional[Path]:
        """解析 Maps/Levels 根目录。"""
        exports_root_env = os.getenv("DNA_EXPORTS_ROOT")
        if exports_root_env:
            env_root = Path(exports_root_env)
            if env_root.name == "Levels":
                return env_root
            candidate = env_root / "EM" / "Content" / "Maps" / "Levels"
            if candidate.is_dir():
                return candidate

        default_root = (
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
        if default_root.is_dir():
            return default_root
        return None

    def _build_sub_region_level_order(self) -> List[str]:
        """按 SubRegion 数据中的顺序返回需要处理的地图名。"""
        level_order: List[str] = []
        for _, info in self.sub_region_data.items():
            if not isinstance(info, dict):
                continue
            level_name = info.get("SubRegionLevel")
            if (
                isinstance(level_name, str)
                and level_name
                and level_name not in level_order
            ):
                level_order.append(level_name.lower())
        return level_order

    def _iter_design_data_dirs(self, maps_root: Path):
        """递归枚举所有 Design_Data 目录，只扫目录不扫内容。"""
        cache_key = str(maps_root.resolve())
        with self._shared_build_locks_lock:
            cached = self._shared_design_data_dirs_cache.get(cache_key)
            if cached is not None:
                return cached

        stack = [maps_root]
        design_dirs: List[Path] = []
        while stack:
            current = stack.pop()
            try:
                entries = list(current.iterdir())
            except Exception:
                continue
            for entry in entries:
                if not entry.is_dir():
                    continue
                if entry.name == "Design_Data":
                    design_dirs.append(entry)
                else:
                    stack.append(entry)

        design_dirs.sort(key=lambda p: str(p))
        with self._shared_build_locks_lock:
            cached = self._shared_design_data_dirs_cache.get(cache_key)
            if cached is not None:
                return cached
            self._shared_design_data_dirs_cache[cache_key] = design_dirs
        return design_dirs

    def _iter_design_dir_design_files(self, design_dir: Path) -> List[Path]:
        """读取单个 Design_Data 目录中的设计层文件列表。"""
        cache_key = str(design_dir.resolve())
        with self._shared_build_locks_lock:
            cached = self._shared_design_dir_files_cache.get(cache_key)
            if cached is not None:
                return cached

        design_files: List[Path] = []
        try:
            for json_path in design_dir.iterdir():
                if json_path.is_file() and json_path.name.endswith("_Design.json"):
                    design_files.append(json_path)
        except Exception:
            design_files = []

        design_files.sort(key=lambda p: (len(str(p)), str(p)))
        with self._shared_build_locks_lock:
            cached = self._shared_design_dir_files_cache.get(cache_key)
            if cached is not None:
                return cached
            self._shared_design_dir_files_cache[cache_key] = design_files
        return design_files

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
        treasure_actor_names = self._collect_treasure_actor_names(level_data)
        candidate_nodes: List[
            Tuple[dict, List[Tuple[int, Optional[int]]], Optional[int], Optional[int]]
        ] = []
        unit_based_resource_ids = set()
        for node in self._iter_design_level_nodes(level_data):
            if not isinstance(node, dict):
                continue
            props = node.get("Properties", {})
            if not isinstance(props, dict):
                continue
            if (
                node.get("Type") == "BP_StaticCreatorComponent_C"
                and node.get("Name") == "Drop"
                and self._is_treasure_drop_component(node, treasure_actor_names)
            ):
                continue
            if (
                node.get("Type") == "BP_StaticCreatorComponent_C"
                and node.get("Name") == "Drop"
                and self._is_explore_drop_component(node)
            ):
                continue
            resource_ids = self._extract_resource_ids_from_node(node, props)
            if not resource_ids:
                continue
            unit_id = self._to_int(props.get("UnitId"))
            static_creator_id = self._to_int(props.get("StaticCreatorId"))
            if unit_id is not None or static_creator_id is not None:
                for resource_id, _ in resource_ids:
                    unit_based_resource_ids.add(resource_id)
            candidate_nodes.append((node, resource_ids, unit_id, static_creator_id))

        for node, resource_ids, unit_id, static_creator_id in candidate_nodes:
            if (
                unit_id is None
                and static_creator_id is None
                and len(resource_ids) == 1
                and resource_ids[0][1] is None
                and resource_ids[0][0] in unit_based_resource_ids
                and node.get("Type") != "Explore_Treasure_C"
            ):
                continue
            pos = self._extract_design_level_pos(node, by_outer_name, by_name, by_path)
            if pos is None:
                continue
            for resource_id, reward_id in resource_ids:
                resource_sources = sources.setdefault(resource_id, [])
                source_item = self._get_or_create_source_item(
                    resource_sources, sub_region_id, reward_id
                )
                if not source_item:
                    continue
                self._append_source_pos(source_item, pos)

    @staticmethod
    def _collect_treasure_actor_names(level_data: Any) -> Set[str]:
        """收集当前设计层中的 Explore_Treasure_C actor 名称。"""
        treasure_actor_names: Set[str] = set()
        if isinstance(level_data, list):
            iterable = level_data
        elif isinstance(level_data, dict):
            iterable = []
            for group_data in level_data.values():
                if isinstance(group_data, dict):
                    iterable.extend(group_data.values())
                elif isinstance(group_data, list):
                    iterable.extend(group_data)
        else:
            iterable = []
        for node in iterable:
            if not isinstance(node, dict):
                continue
            if node.get("Type") != "Explore_Treasure_C":
                continue
            name = node.get("Name")
            if isinstance(name, str) and name:
                treasure_actor_names.add(name)
        return treasure_actor_names

    def _is_treasure_drop_component(
        self, node: dict, treasure_actor_names: Set[str]
    ) -> bool:
        """判断 Drop 组件是否属于 Explore_Treasure_C。"""
        outer = node.get("Outer")
        outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
        if not isinstance(outer_name, str):
            return False
        _, outer_short_name = self._ref_outer_and_name(outer_name)
        if outer_short_name and outer_short_name in treasure_actor_names:
            return True
        return "Explore_Treasure_C'" in outer_name

    def _is_explore_drop_component(self, node: dict) -> bool:
        """判断 Drop 组件是否属于 Explore_Drop_C。"""
        outer = node.get("Outer")
        outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
        if not isinstance(outer_name, str):
            return False
        _, outer_short_name = self._ref_outer_and_name(outer_name)
        if outer_short_name and outer_short_name.startswith("Explore_Drop"):
            return True
        return "Explore_Drop_C'" in outer_name

    def _collect_resource_sources_from_random_rule_points(
        self,
        json_path: Path,
        level_data: Any,
        sub_region_id: int,
        sources: Dict[int, List[Dict[str, Any]]],
    ) -> None:
        """从随机规则点位补充资源来源。"""
        if not isinstance(json_path, Path):
            return
        random_rule_points = self._get_random_actor_points_by_rule(json_path)
        if not random_rule_points:
            return

        for random_rule_id, points in random_rule_points.items():
            resource_ids = self._get_resource_ids_by_random_rule(random_rule_id)
            if not resource_ids:
                continue
            for resource_id, reward_id in resource_ids:
                resource_sources = sources.setdefault(resource_id, [])
                source_item = self._get_or_create_source_item(
                    resource_sources, sub_region_id, reward_id
                )
                if not source_item:
                    continue
                for pos in points:
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
        self._ensure_resource_link_maps()
        resource_ids: List[Tuple[int, Optional[int]]] = []

        def has_resource_pair(
            candidate_id: Optional[int], candidate_reward_id: Optional[int]
        ) -> bool:
            return any(
                item_id == candidate_id and reward_id == candidate_reward_id
                for item_id, reward_id in resource_ids
            )

        resource_id = self._to_int(props.get("ResourceId"))
        if (
            resource_id is not None
            and resource_id in self.resource_map
            and not has_resource_pair(resource_id, None)
        ):
            resource_ids.append((resource_id, None))

        unit_id = self._to_int(props.get("UnitId"))
        static_creator_id = self._to_int(props.get("StaticCreatorId"))
        rarely_id = self._to_int(props.get("RarelyId"))
        resolved_unit_id = unit_id
        if resolved_unit_id is None and static_creator_id is not None:
            resolved_unit_id = self._get_unit_id_by_static_creator_id(static_creator_id)

        if resolved_unit_id is not None:
            for resource_id in self.drop_to_resource_ids.get(resolved_unit_id, []):
                if resource_id in self.resource_map and not has_resource_pair(
                    resource_id, None
                ):
                    resource_ids.append((resource_id, None))

        if (
            unit_id is not None or static_creator_id is not None
        ) and rarely_id is not None:
            for drop_id in self.rarely_to_drop_ids.get(rarely_id, []):
                for resource_id in self.drop_to_resource_ids.get(drop_id, []):
                    if resource_id in self.resource_map and not has_resource_pair(
                        resource_id, None
                    ):
                        resource_ids.append((resource_id, None))

        mechanism_id = resolved_unit_id
        if mechanism_id is not None:
            for resource_id, reward_id in self.mechanism_to_resource_ids.get(
                mechanism_id, []
            ):
                if resource_id in self.resource_map and not has_resource_pair(
                    resource_id, reward_id
                ):
                    resource_ids.append((resource_id, reward_id))

        return resource_ids

    def _get_unit_id_by_static_creator_id(
        self, static_creator_id: int
    ) -> Optional[int]:
        """通过 StaticCreatorId 反查对应的 UnitId。"""
        self._ensure_resource_link_maps()
        if self.design_level_unit_ids is None:
            return None
        return self.design_level_unit_ids.get(static_creator_id)

    def _build_design_level_unit_ids(self) -> Dict[int, int]:
        """从 DesignLevel_data 反查 StaticCreatorId -> UnitId。"""
        cache_key = self._get_exports_root_cache_key()
        with self._shared_build_locks_lock:
            cached = self._shared_design_level_unit_id_cache.get(cache_key)
            if cached is not None:
                return cached

        build_lock = self._get_shared_build_lock(
            ("resource_processor", cache_key, "design_level_unit_ids")
        )
        with build_lock:
            with self._shared_build_locks_lock:
                cached = self._shared_design_level_unit_id_cache.get(cache_key)
                if cached is not None:
                    return cached

            mapping: Dict[int, int] = {}
            design_level_dir = Path("Script") / "Datas" / "DesignLevel_data"
            if design_level_dir.is_dir():
                try:
                    from step1_convert import parse_lua_file
                except Exception:
                    parse_lua_file = None
                if parse_lua_file is not None:
                    for lua_path in sorted(design_level_dir.glob("*.lua")):
                        try:
                            design_level_data = parse_lua_file(str(lua_path))
                        except Exception:
                            continue
                        self._collect_design_level_unit_ids(design_level_data, mapping)

            with self._shared_build_locks_lock:
                cached = self._shared_design_level_unit_id_cache.get(cache_key)
                if cached is not None:
                    return cached
                self._shared_design_level_unit_id_cache[cache_key] = mapping
            with BaseProcessor._shared_items_cache_lock:
                BaseProcessor._shared_items_cache[
                    self._shared_cache_key("design_level_unit_ids")
                ] = mapping
            return mapping

    def _collect_design_level_unit_ids(
        self, design_level_data: Any, mapping: Dict[int, int]
    ) -> None:
        """递归收集 DesignLevel_data 中的 CreatorId -> UnitId。"""
        if isinstance(design_level_data, dict):
            creator_id = self._to_int(design_level_data.get("CreatorId"))
            unit_id = self._to_int(design_level_data.get("UnitId"))
            if (
                creator_id is not None
                and unit_id is not None
                and creator_id not in mapping
            ):
                mapping[creator_id] = unit_id
            for value in design_level_data.values():
                self._collect_design_level_unit_ids(value, mapping)
        elif isinstance(design_level_data, list):
            for value in design_level_data:
                self._collect_design_level_unit_ids(value, mapping)

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

    def _build_random_rule_to_resource_ids(
        self,
    ) -> Dict[int, List[Tuple[int, Optional[int]]]]:
        """构建 RandomRuleId -> ResourceId/RewardId 列表映射。"""
        cache_key = self._shared_cache_key("random_rule_to_resource_ids")
        with BaseProcessor._shared_items_cache_lock:
            cached = BaseProcessor._shared_items_cache.get(cache_key)
            if isinstance(cached, dict):
                return cached

        shared_cache_key = self._get_exports_root_cache_key()
        with self._shared_build_locks_lock:
            cached = self._shared_random_rule_to_resource_ids_cache.get(
                shared_cache_key
            )
            if cached is not None:
                return cached

        mapping: Dict[int, List[Tuple[int, Optional[int]]]] = {}
        for random_rule_id, creator in self.random_creator_data.items():
            if not isinstance(creator, dict):
                continue
            if creator.get("UnitType") != "Mechanism":
                continue
            rule_id = self._to_int(random_rule_id)
            if rule_id is None:
                continue
            resource_ids: List[Tuple[int, Optional[int]]] = []
            for unit_info in self._normalize_list_field(creator.get("RandomInfos", [])):
                if not isinstance(unit_info, dict):
                    continue
                unit_id = self._to_int(unit_info.get("UnitId"))
                if unit_id is None:
                    continue
                for resource_id, reward_id in self.mechanism_to_resource_ids.get(
                    unit_id, []
                ):
                    if (
                        resource_id in self.resource_map
                        and (resource_id, reward_id) not in resource_ids
                    ):
                        resource_ids.append((resource_id, reward_id))
            if resource_ids:
                mapping[rule_id] = resource_ids

        with self._shared_build_locks_lock:
            cached = self._shared_random_rule_to_resource_ids_cache.get(
                shared_cache_key
            )
            if cached is not None:
                return cached
            self._shared_random_rule_to_resource_ids_cache[shared_cache_key] = mapping
        with BaseProcessor._shared_items_cache_lock:
            BaseProcessor._shared_items_cache[cache_key] = mapping
        return mapping

    def _get_resource_ids_by_random_rule(
        self, random_rule_id: Any
    ) -> List[Tuple[int, Optional[int]]]:
        """根据 RandomRuleId 读取资源 ID 和 RewardId。"""
        self._ensure_resource_link_maps()
        rule_id = self._to_int(random_rule_id)
        if rule_id is None:
            return []
        return self.random_rule_to_resource_ids.get(rule_id, [])

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

    def _extract_random_rule_ids(self, design_level_data: Any) -> List[int]:
        """提取地图中的 RandomRuleId 列表。"""
        random_rule_data = {}
        if isinstance(design_level_data, dict):
            random_rule_data = design_level_data.get("RandomRule", {})
        if not random_rule_data:
            return []

        random_rule_ids: List[int] = []
        seen = set()

        if isinstance(random_rule_data, dict):
            for key, value in random_rule_data.items():
                rule_id = None
                if isinstance(value, dict):
                    rule_id = value.get("RandomRuleId")
                if not rule_id:
                    rule_id = key
                rule_id = self._to_int(rule_id)
                if rule_id is None or rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)
        elif isinstance(random_rule_data, list):
            for value in random_rule_data:
                if not isinstance(value, dict):
                    continue
                rule_id = self._to_int(value.get("RandomRuleId"))
                if rule_id is None or rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)

        return random_rule_ids

    def _load_design_map_json(self, json_path: Path) -> list:
        """加载地图 JSON。"""
        resolved_path = json_path.resolve()
        cache_key = str(resolved_path)
        with self._shared_build_locks_lock:
            cached = self._shared_design_map_json_cache.get(cache_key)
            if cached is not None:
                return cached
        build_lock = self._get_shared_build_lock(
            ("resource_processor", cache_key, "design_map_json")
        )
        with build_lock:
            with self._shared_build_locks_lock:
                cached = self._shared_design_map_json_cache.get(cache_key)
                if cached is not None:
                    return cached
        try:
            data = json.loads(resolved_path.read_text(encoding="utf-8"))
        except Exception:
            data = []
        if not isinstance(data, list):
            data = []
        with self._shared_build_locks_lock:
            cached = self._shared_design_map_json_cache.get(cache_key)
            if cached is not None:
                return cached
            self._shared_design_map_json_cache[cache_key] = data
        return data

    def _get_random_actor_points_by_rule(
        self, json_path: Path
    ) -> Dict[str, List[List]]:
        """提取关卡随机点位：RandomRuleId -> [[x,y,z], ...]。"""
        if not isinstance(json_path, Path):
            return {}
        cache_key = str(json_path.resolve())
        shared_key = self._get_exports_root_cache_key()
        cache_name = f"{shared_key}|{cache_key}"
        with self._shared_build_locks_lock:
            cached = self._shared_design_map_json_cache.get(cache_name)
            if isinstance(cached, dict):
                return cached

        arr = self._load_design_map_json(json_path)
        if not arr:
            return {}

        rule_points: Dict[str, List[List]] = {}
        rule_point_set: Dict[str, set] = {}
        root_loc = self._resolve_random_actor_root_location(arr)
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
                points = rule_points.setdefault(rule_id_str, [])
                point_set = rule_point_set.setdefault(rule_id_str, set())
                for param in params:
                    if not isinstance(param, dict):
                        continue
                    loc = self._to_vector3(param.get("ActorLoc"))
                    if loc is None:
                        continue
                    if root_loc is not None:
                        loc = self._vec_add(loc, root_loc)
                    pos = self._format_vec3(loc)
                    pos_tuple = (pos[0], pos[1], pos[2])
                    if pos_tuple in point_set:
                        continue
                    point_set.add(pos_tuple)
                    points.append(pos)

        with self._shared_build_locks_lock:
            self._shared_design_map_json_cache[cache_name] = rule_points
        return rule_points

    def _resolve_random_actor_root_location(
        self, arr: List[dict]
    ) -> Optional[List[float]]:
        """读取随机生成器根节点偏移。"""
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
            root_obj = BaseProcessor._resolve_ref_object(
                root_ref, by_outer_name, by_name, by_path
            )
            if not isinstance(root_obj, dict):
                continue
            root_props = root_obj.get("Properties", {})
            if not isinstance(root_props, dict):
                continue
            root = BaseProcessor._to_vector3(root_props.get("RelativeLocation"))
            if root is not None:
                return root
        return None

    @staticmethod
    def _build_object_maps(
        arr: List[dict],
    ) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
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
    def _ref_outer_and_name(
        object_name: Optional[str],
    ) -> Tuple[Optional[str], Optional[str]]:
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
    def _resolve_ref_object(
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
        outer_name, short_name = ResourceProcessor._ref_outer_and_name(object_name)
        if (
            by_path is not None
            and isinstance(object_path, str)
            and object_path in by_path
        ):
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

    @staticmethod
    def _vec_add(left: List[float], right: List[float]) -> List[float]:
        return [left[0] + right[0], left[1] + right[1], left[2] + right[2]]

    @staticmethod
    def _format_num(value: float):
        rounded = round(float(value), 6)
        if abs(rounded - round(rounded)) < 1e-6:
            return int(round(rounded))
        return rounded

    def _format_vec3(self, vec: List[float]) -> List:
        return [
            self._format_num(vec[0]),
            self._format_num(vec[1]),
            self._format_num(vec[2]),
        ]

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

        if (
            node.get("Type") == "BP_StaticCreatorComponent_C"
            and node.get("Name") == "FinishMechanism"
        ):
            attach_parent_ref = props.get("AttachParent")
            if (
                attach_parent_ref is not None
                and by_outer_name is not None
                and by_name is not None
            ):
                pos = self._extract_ref_location(
                    attach_parent_ref, by_outer_name, by_name, by_path
                )
                if pos is not None:
                    return [pos[0], pos[1]]

        if node.get("Type") == "Explore_Treasure_C":
            pos = self._extract_object_location(
                node, by_outer_name, by_name, by_path, prefer_root_first=True
            )
            if pos is not None:
                return [pos[0], pos[1]]
        if node.get("Type") == "Explore_Drop_C":
            pos = self._extract_object_location(
                node, by_outer_name, by_name, by_path, prefer_root_first=True
            )
            if pos is not None:
                return [pos[0], pos[1]]

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
        if (
            attach_parent_ref is not None
            and by_outer_name is not None
            and by_name is not None
        ):
            pos = self._extract_ref_location(
                attach_parent_ref, by_outer_name, by_name, by_path
            )
            if pos is not None:
                return [pos[0], pos[1]]

        for component_key in ("Sphere", "SceneComponent", "CollisionComponent"):
            component_ref = props.get(component_key)
            if component_ref is None:
                continue
            if by_outer_name is None or by_name is None:
                continue
            pos = self._extract_ref_location(
                component_ref, by_outer_name, by_name, by_path
            )
            if pos is not None:
                return [pos[0], pos[1]]

        blueprint_components = props.get("BlueprintCreatedComponents")
        if (
            isinstance(blueprint_components, list)
            and by_outer_name is not None
            and by_name is not None
        ):
            for component_ref in blueprint_components:
                pos = self._extract_ref_location(
                    component_ref, by_outer_name, by_name, by_path
                )
                if pos is not None:
                    return [pos[0], pos[1]]

        return None

    @staticmethod
    def _ref_outer_and_name(
        object_name: Optional[str],
    ) -> Tuple[Optional[str], Optional[str]]:
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
    def _build_object_maps(
        arr: List[dict],
    ) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
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
        if (
            by_path is not None
            and isinstance(object_path, str)
            and object_path in by_path
        ):
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
        resolved_obj = self._resolve_ref_object(
            ref_obj, by_outer_name, by_name, by_path
        )
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
        resource_sources: List[Dict[str, Any]],
        sub_region_id: int,
        reward_id: Optional[int] = None,
    ) -> Optional[Dict[str, Any]]:
        """获取同 srId 的 source 项，必要时新建。"""
        if sub_region_id == 210101:
            return None
        for source_item in resource_sources:
            if (
                source_item.get("srId") == sub_region_id
                and source_item.get("rewardId") == reward_id
            ):
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
    def _sort_source_items_key(
        source_item: Dict[str, Any],
    ) -> Tuple[bool, int, int, float, float]:
        """固定 source 输出顺序，避免缓存改变插入顺序。"""
        reward_id = source_item.get("rewardId")
        sr_id = source_item.get("srId")
        pos = source_item.get("pos", [])
        first_pos = pos[0] if isinstance(pos, list) and pos else []
        x = (
            float(first_pos[0])
            if isinstance(first_pos, list)
            and len(first_pos) >= 1
            and first_pos[0] is not None
            else 0.0
        )
        y = (
            float(first_pos[1])
            if isinstance(first_pos, list)
            and len(first_pos) >= 2
            and first_pos[1] is not None
            else 0.0
        )
        return (
            reward_id is None,
            sr_id if isinstance(sr_id, int) else 0,
            reward_id if isinstance(reward_id, int) else 0,
            x,
            y,
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
        cache_key = self._shared_cache_key("draft_resource_ids")
        with BaseProcessor._shared_items_cache_lock:
            cached = BaseProcessor._shared_items_cache.get(cache_key)
            if cached is not None:
                return cached

        draft_data = self.data_loader.load_json("Draft.json")
        char_break_data = self.data_loader.load_json("CharBreak.json")
        skill_level_up_data = self.data_loader.load_json("SkillLevelUp.json")
        weapon_break_data = self.data_loader.load_json("WeaponBreak.json")
        shop_item_data = self.data_loader.load_json("ShopItem.json")

        resource_ids = set()

        # 从 Draft 中收集资源
        for draft_id, draft_info in draft_data.items():
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
        for char_id, break_list in char_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 SkillLevelUp 中收集资源
        for skill_id, level_list in skill_level_up_data.items():
            if isinstance(level_list, list):
                for level_stage in level_list:
                    item_ids = level_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 WeaponBreak 中收集资源
        for weapon_id, break_list in weapon_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 ShopItem 中收集资源
        for shop_item_id, shop_item_info in shop_item_data.items():
            # 收集商品类型为Resource的TypeId
            item_type = shop_item_info.get("ItemType")
            type_id = shop_item_info.get("TypeId")
            if item_type == "Resource" and type_id:
                resource_ids.add(type_id)

            # 收集PriceType（消耗的资源类型）
            price_type = shop_item_info.get("PriceType")
            if price_type:
                resource_ids.add(price_type)

        with BaseProcessor._shared_items_cache_lock:
            cached = BaseProcessor._shared_items_cache.get(cache_key)
            if cached is not None:
                return cached
            BaseProcessor._shared_items_cache[cache_key] = resource_ids
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
