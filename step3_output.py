import json
import os
from collections import OrderedDict
from processor.char_processor import CharProcessor
from processor.weapon_processor import WeaponProcessor
from processor.mod_processor import ModProcessor
from processor.achievement_processor import AchievementProcessor
from processor.monster_processor import MonsterProcessor


class DataLoader:
    def __init__(self, base_dir):
        self.base_dir = base_dir
        self.data_cache = {}
        self.indexes = {}
        self.language = None
        self.i18n_data = self.load_json("TextMap_I18n.json")

    def set_language(self, language):
        self.language = language

    def load_json(self, file_name, use_i18n=False):
        cache_key = f"{file_name}_{self.language if use_i18n else 'base'}"
        if cache_key in self.data_cache:
            return self.data_cache[cache_key]

        if use_i18n and self.language:
            file_path = os.path.join(self.base_dir, "i18n", self.language, file_name)
        else:
            file_path = os.path.join(self.base_dir, file_name)

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        self.data_cache[cache_key] = data
        return data

    def build_index(self, file_name, key_field, use_i18n=False):
        cache_key = f"{file_name}_{key_field}_{self.language if use_i18n else 'base'}"
        if cache_key in self.indexes:
            return self.indexes[cache_key]

        data = self.load_json(file_name, use_i18n)
        index = {}

        # Handle both map and array formats
        if isinstance(data, dict):
            for id_str, item in data.items():
                id_val = item.get(key_field)
                # Ensure id_val is hashable
                if id_val is not None and not isinstance(id_val, (dict, list)):
                    index[id_val] = item
        elif isinstance(data, list):
            for item in data:
                id_val = item.get(key_field)
                # Ensure id_val is hashable
                if id_val is not None and not isinstance(id_val, (dict, list)):
                    index[id_val] = item

        self.indexes[cache_key] = index
        return index

    def translate(self, text_key, language=""):
        """从i18n数据中获取翻译文本"""
        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return text_key

        # 获取当前语言
        language = language if language else self.language

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

    def get_achievement_type_name(self, type_id):
        # Use translated AchievementType from i18n directory
        type_index = self.build_index("AchievementType.json", "Id")
        return self.translate(
            type_index.get(type_id, {}).get("AchievementTypeName", "")
        )

    def get_resource_name(self, resource_id):
        # Resource.json uses ResourceId as the primary key
        resource_index = self.build_index("Resource.json", "ResourceId")
        return self.translate(
            resource_index.get(resource_id, {}).get("ResourceName", "")
        )

    def get_draft_info(self, draft_id):
        draft_index = self.build_index("Draft.json", "Id")
        return draft_index.get(draft_id, {})

    def get_mod_info(self, mod_id):
        mod_index = self.build_index("Mod.json", "Id")
        return mod_index.get(mod_id, {})

    def get_mod_name(self, mod_id):
        mod_index = self.build_index("Mod.json", "Id")
        mod = mod_index.get(mod_id, {})
        return f"{mod.get('TypeName', '')}{mod.get('Name', '')}".strip()

    def get_char_name(self, char_id):
        char_index = self.build_index("Char.json", "Id")
        return self.translate(char_index.get(char_id, {}).get("Name", ""))

    def get_weapon_name(self, weapon_id):
        weapon_index = self.build_index("Weapon.json", "Id")
        return self.translate(weapon_index.get(weapon_id, {}).get("Name", ""))

    def get_title_name(self, title_id):
        # Use translated Title from i18n directory
        title_index = self.build_index("Title.json", "TitleID")
        return self.translate(title_index.get(title_id, {}).get("Name", ""))

    def get_titleframe_name(self, titleframe_id):
        # Use translated TitleFrame from i18n directory
        titleframe_index = self.build_index("TitleFrame.json", "TitleFrameID")
        return self.translate(titleframe_index.get(titleframe_id, {}).get("Name", ""))

    def get_mod_tag_info(self, application_type):
        # Use translated ModTag from i18n directory
        mod_tag_index = self.build_index("ModTag.json", "ApplicationType")
        return mod_tag_index.get(application_type, {})

    def get_tab_name(self, tab_id):
        tab_index = self.build_index("ArchiveTab.json", "TabPara")
        return self.translate(tab_index.get(tab_id, {}).get("TabName", ""))


class FinalProcessor:
    def __init__(self, base_dir, output_dir):
        self.base_dir = base_dir
        self.output_dir = output_dir

        # 不在这里创建共享的DataLoader实例，改为每个任务创建独立实例

        # Initialize processors dictionary (延迟创建处理器实例)
        self.processor_classes = {
            "Achievement": AchievementProcessor,
            "Mod": ModProcessor,
            "Weapon": WeaponProcessor,
            "Char": CharProcessor,
            "Monster": MonsterProcessor,
            # Add other processor classes here as they are implemented
        }

    def get_processor(self, file_type):
        """获取指定文件类型的处理器实例，每个调用创建新实例"""
        processor_class = self.processor_classes.get(file_type)
        if not processor_class:
            return None

        # 为每个处理器创建独立的DataLoader实例，确保线程安全
        data_loader = DataLoader(self.base_dir)
        return processor_class(data_loader)

    def process_all_languages(self, file_types, languages):
        """处理所有语言的指定文件类型，使用多线程提高性能"""
        import concurrent.futures

        # 创建线程池，线程数可以根据实际情况调整
        max_workers = min(10, len(languages) * len(file_types))

        # 使用线程池并行处理
        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # 提交所有任务
            future_to_task = {}
            for file_type in file_types:
                for lang in languages:
                    # 每个语言+文件类型组合作为一个独立任务
                    future = executor.submit(
                        self.process_file_type_for_language, file_type, lang
                    )
                    future_to_task[future] = (file_type, lang)

            # 获取任务结果
            for future in concurrent.futures.as_completed(future_to_task):
                file_type, lang = future_to_task[future]
                try:
                    future.result()  # 获取任务结果，捕获异常
                except Exception as e:
                    print(f"Error processing {file_type} for {lang}: {e}")

    def process_file_type_for_language(self, file_type, language):
        """处理指定语言的指定文件类型"""
        # Get processor for the file type (每个调用创建新实例，确保线程安全)
        processor = self.get_processor(file_type)
        if not processor:
            print(f"Processor not found for file type: {file_type}")
            return

        # Set language for data loader (每个处理器实例有自己的DataLoader，线程安全)
        processor.data_loader.set_language(language)

        # Load data for the file type and language
        file_path = os.path.join(self.base_dir, f"{file_type}.json")
        if not os.path.exists(file_path):
            print(f"{file_type} data not found for language: {language}")
            return

        # Load and process items
        items = processor.load_items(file_path)
        processed_items = processor.process_all_items(items, language)

        # Sort by id if applicable
        if processed_items:
            processed_items.sort(key=lambda x: x.get("id", 0))

        # Create output directory path
        output_path = os.path.join(self.output_dir, "i18n", language)

        # Save processed items
        output_file = processor.save_processed_items(
            processed_items, output_path, f"{file_type}.json"
        )

        print(f"Processed {file_type} for {language} written to {output_file}")


if __name__ == "__main__":
    # Define base directory for input files
    BASE_DIR = os.path.join(os.getcwd(), "out")

    # Define output directory
    OUTPUT_DIR = os.path.join(os.getcwd(), "final")

    # Define languages to process
    LANGUAGES = ["cn", "en", "jp", "kr", "tc"]

    # Define file types to process (controlled by switch)
    # Example: process only Achievement files
    # FILE_TYPES = ["Achievement"]
    # Example: process multiple file types (when other processors are implemented)
    FILE_TYPES = [
        #  11
        "Achievement",
        "Mod",
        "Weapon",
        "Char",
        "Monster",
    ]

    # Create processor and process all specified file types for all languages
    processor = FinalProcessor(BASE_DIR, OUTPUT_DIR)
    processor.process_all_languages(FILE_TYPES, LANGUAGES)
