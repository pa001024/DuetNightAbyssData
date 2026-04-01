import re
from processor.base_processor import BaseProcessor


class HairProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Hair"

    def process_item(self, item_data, language):
        """处理单个发型数据。"""
        hair_id = item_data.get("HairId", 0)
        if not hair_id:
            return None

        name = self.get_translated_text(item_data.get("Name", ""), language)
        if not name:
            return None

        icon = self._extract_icon_name(item_data.get("Icon", ""))
        if not icon:
            return None

        desc = self.get_translated_text(item_data.get("HairDescribe", ""), language)
        char_id = item_data.get("CharId")
        processed = {
            "id": hair_id,
            "name": name,
            "desc": desc,
            "icon": icon,
            "rarity": item_data.get("Rarity", 0),
            "charId": char_id if char_id not in (None, "") else None,
        }

        if not processed["desc"]:
            del processed["desc"]
        if processed["charId"] is None:
            del processed["charId"]

        return processed

    def _extract_icon_name(self, icon_value):
        """从资源路径中提取图标名。"""
        if not icon_value:
            return ""

        match = re.search(r"(T_[^./']+)", icon_value)
        if match:
            return match.group(1)

        return ""
