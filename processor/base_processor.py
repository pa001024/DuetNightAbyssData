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

    def get_translated_text(self, text_key):
        """从i18n数据中获取翻译文本"""
        if not text_key or not isinstance(text_key, str):
            return ""

        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return text_key

        # 获取当前语言
        language = self.data_loader.language if self.data_loader.language else "cn"

        # 根据当前语言获取对应字段
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

        return content
