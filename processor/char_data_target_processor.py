import json
from collections import OrderedDict
from processor.base_processor import BaseProcessor


class CharDataTargetProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "CharDataTarget"

    def load_items(self, file_path):
        """加载并扁平化角色档案目标数据。"""
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        if not isinstance(data, dict):
            return []

        items = []
        for char_targets in data.values():
            if not isinstance(char_targets, dict):
                continue
            for target_data in char_targets.values():
                if isinstance(target_data, dict):
                    items.append(target_data)
        return items

    def process_item(self, item_data, language):
        """处理单个角色档案目标数据。"""
        target_id = item_data.get("CharDataTarget", 0)
        char_id = item_data.get("CharId", 0)
        if not target_id or not char_id:
            return None

        name_keys = item_data.get("CharDataName", [])
        if isinstance(name_keys, str):
            name_keys = [name_keys]
        elif not isinstance(name_keys, list):
            name_keys = []

        translated_name_parts = [
            self.get_translated_text(name_key, language)
            for name_key in name_keys
            if name_key
        ]

        processed = {
            "id": target_id,
            "charId": char_id,
            "name": "".join(translated_name_parts),
            "unlock": self.get_translated_text(
                item_data.get("CharDataTargetDescribe", ""), language
            ),
            "text": self.get_translated_text(item_data.get("CharText", ""), language),
        }

        return processed
