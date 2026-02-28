import json
import os
import threading
from typing import Any, Dict, List, Optional, Set, Tuple
from processor.base_processor import BaseProcessor


class BookSeriesArchiveProcessor(BaseProcessor):
    """处理 BookSeriesArchive，输出书系与资源投放位置的聚合关系。"""

    _unit_to_sub_region_cache_by_base: Dict[str, Dict[int, Tuple[int, ...]]] = {}
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

        self.resource_ids_by_series = self._build_resource_ids_by_series_from_resource()
        self.resource_to_drop_ids = self._build_resource_to_drop_ids()
        self.resource_to_reward_ids = self._build_resource_to_reward_ids()
        self.reward_to_mechanism_units = self._build_reward_to_mechanism_units()
        self.level_to_sub_region_id = self._build_level_to_sub_region_index()
        self.unit_to_sub_region_ids = self._get_or_build_unit_to_sub_region_index()

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
        res_entries = self._build_res_entries(
            resource_ids, language, series_name, series_desc
        )
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
