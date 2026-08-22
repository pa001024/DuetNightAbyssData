import re
from processor.base_processor import BaseProcessor


class HairProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Hair"
        self._hair_skin_map = None

    def process_item(self, item_data, language):
        """处理单个发型数据。"""
        hair_id = item_data.get("HairId", 0)
        if not hair_id:
            return None

        name = self.get_translated_text(item_data.get("Name", ""), language)
        if not name:
            # 发型缺少名字时，回退使用引用它的皮肤名称（如 210292 -> 皮肤 210201）
            name = self._get_fallback_name_from_skin(hair_id, language)
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

    def _get_fallback_name_from_skin(self, hair_id, language):
        """查找引用该发型的皮肤，用皮肤名称作为发型名称。"""
        skin_info = self._get_hair_skin_map().get(str(hair_id))
        if not isinstance(skin_info, dict):
            return ""
        return self.get_translated_text(skin_info.get("SkinName", ""), language)

    def _get_hair_skin_map(self):
        """构建发型ID到引用它的皮肤的映射（AutoHair 或 DefaultItem.Hair）。"""
        if self._hair_skin_map is None:
            mapping = {}
            skin_data = self.data_loader.load_json("Skin.json")
            for skin_info in skin_data.values():
                if not isinstance(skin_info, dict):
                    continue
                hair_ids = set()
                auto_hair = skin_info.get("AutoHair")
                if auto_hair:
                    hair_ids.add(str(auto_hair))
                default_item = skin_info.get("DefaultItem")
                if isinstance(default_item, dict) and isinstance(
                    default_item.get("Hair"), dict
                ):
                    hair_ids.update(
                        str(hair_id) for hair_id in default_item["Hair"].keys()
                    )
                for hair_id in hair_ids:
                    mapping[hair_id] = skin_info
            self._hair_skin_map = mapping
        return self._hair_skin_map

    def _extract_icon_name(self, icon_value):
        """从资源路径中提取图标名。"""
        if not icon_value:
            return ""

        match = re.search(r"(T_[^./']+)", icon_value)
        if match:
            return match.group(1)

        return ""
