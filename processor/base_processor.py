import json
from collections import OrderedDict


class BaseProcessor:
    def __init__(self, data_loader):
        self.data_loader = data_loader
        self.file_type = "Base"
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")

    def get_file_type(self):
        return self.file_type

    def process_item(self, item_data, language):
        """处理单个项目，子类必须实现"""
        raise NotImplementedError("Subclasses must implement process_item method")

    def load_items(self, file_path):
        """加载项目数据"""
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        # Convert map to array if needed
        if isinstance(data, dict):
            return list(data.values())
        else:
            return data

    def process_all_items(self, items, language):
        """处理所有项目"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            processed_items.append(processed)
        return processed_items

    def save_processed_items(self, processed_items, output_path, file_name):
        """保存处理后的项目"""
        import os
        from pathlib import Path

        # Create output directory if it doesn't exist
        Path(output_path).mkdir(parents=True, exist_ok=True)

        # Write processed data to file
        output_file = os.path.join(output_path, file_name)
        with open(output_file, "w", encoding="utf-8") as f:
            import json

            json.dump(processed_items, f, ensure_ascii=False, indent=2, sort_keys=False)

        return output_file

    def process_tags(self, tags):
        """处理武器标签"""
        if not tags or not isinstance(tags, list):
            return ""
        rst = []
        tag_map = {
            "Ultra": "同律",
            "Melee": "近战",
            "Ranged": "远程",
            "Bow": self.get_translated_text("WeaponType_Bow", "cn"),
            "Bow01": self.get_translated_text("WeaponType_Bow01", "cn"),
            "Bow02": self.get_translated_text("WeaponType_Bow02", "cn"),
            "Cannon": self.get_translated_text("WeaponType_Cannon", "cn"),
            "Claymore": self.get_translated_text("WeaponType_Claymore", "cn"),
            "Crossbow": self.get_translated_text("WeaponType_Crossbow", "cn"),
            "Dualblade": self.get_translated_text("WeaponType_Dualblade", "cn"),
            "Katana": self.get_translated_text("WeaponType_Katana", "cn"),
            "Machinegun": self.get_translated_text("WeaponType_Machinegun", "cn"),
            "Pistol": self.get_translated_text("WeaponType_Pistol", "cn"),
            "Polearm": self.get_translated_text("WeaponType_Polearm", "cn"),
            "Shotgun": self.get_translated_text("WeaponType_Shotgun", "cn"),
            "Sword": self.get_translated_text("WeaponType_Sword", "cn"),
            "Swordwhip": self.get_translated_text("WeaponType_Swordwhip", "cn"),
        }
        for tag in tags:
            t = tag_map.get(tag, "")
            if t:
                rst.append(t)
        return rst

    def get_translated_text(self, text_key, language=""):
        """从i18n数据中获取翻译文本"""
        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return text_key

        # 获取当前语言
        language = language if language else self.data_loader.language

        # 根据当前语言获取对应字段
        # 语言映射：cn->TextMapContent, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, tc->ContentTC
        language_field_map = {
            "cn": "TextMapContent",
            "en": "ContentEN",
            "jp": "ContentJP",
            "kr": "ContentKR",
            "fr": "ContentFR",
            "es": "ContentES",
            "tc": "ContentTC",
        }

        # 获取对应语言字段
        field = language_field_map.get(language, "TextMapContent")
        content = text_entry.get(field, "")

        # 如果对应语言字段为空，尝试使用其他可用字段
        if not content:
            # 优先顺序：TextMapContent > ContentEN > ContentJP > ContentKR > ContentFR > ContentTC
            for fallback_field in [
                "TextMapContent",
                "ContentEN",
                "ContentJP",
                "ContentKR",
                "ContentFR",
                "ContentES",
                "ContentTC",
            ]:
                if fallback_field in text_entry and text_entry[fallback_field]:
                    content = text_entry[fallback_field]
                    break

        return content or text_key
