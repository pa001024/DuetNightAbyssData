import re
from processor.base_processor import BaseProcessor


class WeaponAccessoryProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "WeaponAccessory"

    def process_item(self, item_data, language):
        """处理单个武器配件数据"""
        if item_data.get("IsHide", False):
            return None

        accessory_id = item_data.get("WeaponAccessoryId", 0)
        if not accessory_id:
            return None

        processed = {
            "id": accessory_id,
            "name": self.get_translated_text(item_data.get("Name", ""), language),
            "desc": self.get_translated_text(item_data.get("Des", ""), language),
            "icon": self._extract_icon_name(item_data.get("Icon", "")),
            "rarity": item_data.get("Rarity", 0),
            "unlock": self.get_translated_text(
                item_data.get("UnlockOption", ""), language
            ),
        }

        return processed

    def _extract_icon_name(self, icon_value):
        """从Icon字段中提取图标名，兼容纯路径和Texture2D格式"""
        if not icon_value:
            return ""

        match = re.search(r"(T_[^./']+)", icon_value)
        if match:
            return match.group(1)

        return ""
