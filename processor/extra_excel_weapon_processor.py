from typing import Dict, List, Optional

from processor.base_processor import BaseProcessor


class ExtraExcelWeaponProcessor(BaseProcessor):
    """处理 ExtraExcelWeapon（溢渗武器）解锁消耗材料导出表。

    数据源 ExcelWeaponExpandItem.json 以武器标签(WeaponTag)为键，
    每个条目包含解锁所需材料的 ItemId/ItemNum 列表。导出结果按
    武器类型名展示消耗材料映射（资源名 -> 数量），与 Weapon 突破格式保持一致。
    """

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ExtraExcelWeapon"
        self.expand_item_data = data_loader.load_json("ExcelWeaponExpandItem.json")

    def process_item(self, item_data, language):
        """处理单个武器标签的消耗材料数据。"""
        if not isinstance(item_data, dict):
            return None

        weapon_tag = item_data.get("WeaponTag", "")
        if not weapon_tag:
            return None

        item_ids = item_data.get("ItemId", [])
        item_nums = item_data.get("ItemNum", [])
        if not isinstance(item_ids, list) or not isinstance(item_nums, list):
            return None

        # 构建消耗材料映射（资源名 -> 数量），复用 DataLoader.get_resource_name 翻译
        consume_map = self._build_resource_map(item_ids, item_nums)
        if not consume_map:
            return None

        # 武器类型名（复用 BaseProcessor.process_tags 的标签翻译映射）
        type_names = self.process_tags([weapon_tag])

        return {
            "id": weapon_tag,
            "名称": type_names[0] if type_names else weapon_tag,
            "消耗": consume_map,
        }

    def _build_resource_map(
        self, resource_ids: List[int], resource_nums: List[int]
    ) -> Dict[str, int]:
        """将资源 id/num 列表转换成消耗材料字典。"""
        resource_map = {}
        for idx, resource_id in enumerate(resource_ids):
            if idx >= len(resource_nums):
                continue
            # resource_name = self.data_loader.get_resource_name(resource_id)
            # if not resource_name:
            #     resource_name = str(resource_id)
            resource_map[resource_id] = resource_nums[idx]
        return resource_map
