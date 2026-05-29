import json
import os
from collections import OrderedDict
from threading import Lock
from processor.char_processor import CharProcessor
from processor.char_data_target_processor import CharDataTargetProcessor
from processor.char_voice_processor import CharVoiceProcessor
from processor.weapon_processor import WeaponProcessor
from processor.mod_processor import ModProcessor
from processor.achievement_processor import AchievementProcessor
from processor.monster_processor import MonsterProcessor
from processor.draft_processor import DraftProcessor
from processor.dungeon_processor import DungeonProcessor
from processor.reward_processor import RewardProcessor
from processor.opt_reward_processor import OptRewardProcessor
from processor.pet_processor import PetProcessor
from processor.abyss_buff_processor import AbyssBuffProcessor
from processor.abyss_dungeon_processor import AbyssDungeonProcessor
from processor.walnut_processor import WalnutProcessor
from processor.fish_processor import FishProcessor
from processor.fishing_spot_processor import FishingSpotProcessor
from processor.resource_processor import ResourceProcessor
from processor.book_series_archive_processor import BookSeriesArchiveProcessor
from processor.dispatch_processor import DispatchProcessor
from processor.dyn_quest_processor import DynQuestProcessor
from processor.quest_chain_processor import QuestChainProcessor
from processor.quest_story_processor import QuestStoryProcessor
from processor.forge_level_quest_processor import ForgeLevelQuestProcessor
from processor.party_topic_processor import PartyTopicProcessor
from processor.region_processor import RegionProcessor
from processor.sub_region_processor import SubRegionProcessor
from processor.region_point_processor import RegionPointProcessor
from processor.region_reputation_processor import RegionReputationProcessor
from processor.shop_item_processor import ShopItemProcessor
from processor.cutoff_processor import CutoffProcessor
from processor.raid_buff_processor import RaidBuffProcessor
from processor.pet_entry_processor import PetEntryProcessor
from processor.hard_boss_processor import HardBossProcessor
from processor.reward_view_processor import RewardViewProcessor
from processor.robot_equip_processor import RobotEquipProcessor
from processor.mount_processor import MountProcessor
from processor.title_processor import TitleProcessor
from processor.npc_processor import NpcProcessor
from processor.char_accessory_processor import CharAccessoryProcessor
from processor.weapon_accessory_processor import WeaponAccessoryProcessor
from processor.weapon_skin_processor import WeaponSkinProcessor
from processor.head_sculpture_processor import HeadSculptureProcessor
from processor.head_frame_processor import HeadFrameProcessor
from processor.hair_processor import HairProcessor
from processor.backpack_puzzle_item_processor import BackpackPuzzleItemProcessor
from processor.impression_shop_processor import ImpressionShopProcessor
from processor.backpack_puzzle_level_processor import BackpackPuzzleLevelProcessor
from processor.event_processor import EventProcessor
from processor.monster_strong_affixes_processor import MonsterStrongAffixesProcessor
from processor.skin_processor import SkinProcessor
from processor.solo_treasure_processor import SoloTreasureProcessor
from processor.solo_treasure_gameplay_processor import SoloTreasureGamePlayProcessor
from processor.iron_ticket_processor import IronTicketProcessor
from processor.iron_survival_monster_spawn_processor import (
    IronSurvivalMonsterSpawnProcessor,
)
from processor.extraction_treasure_bag_processor import (
    ExtractionTreasureBagProcessor,
)
from processor.extraction_treasure_processor import (
    ExtractionTreasureProcessor,
)
from processor.extraction_treasure_mechanism_processor import (
    ExtractionTreasureMechanismProcessor,
)
from processor.treasure_hunt_progress_processor import (
    TreasureHuntProgressProcessor,
)
from processor.treasure_hunt_repeat_dungeon_processor import (
    TreasureHuntRepeatDungeonProcessor,
)
from processor.treasure_hunt_story_dungeon_processor import (
    TreasureHuntStoryDungeonProcessor,
)
from processor.rouge_processor import (
    RougeLikeBlessingProcessor,
    RougeLikeContractProcessor,
    RougeLikeRoomProcessor,
    RougeLikeStoryEventProcessor,
    RougeLikeTalentProcessor,
    RougeLikeTreasureProcessor,
)


class DataLoader:
    _shared_data_cache = {}
    _shared_index_cache = {}
    _shared_cache_lock = Lock()

    def __init__(self, base_dir):
        self.base_dir = base_dir
        self.data_cache = {}
        self.indexes = {}
        self.language = None
        self.i18n_data = self.load_json("TextMap_I18n.json")
        self.i18n_data_cn_alt = {}
        for item in self.load_json("TextMap_TextMapContent.json"):
            self.i18n_data_cn_alt.update(item.get("Loader"))

    def set_language(self, language):
        self.language = language

    def load_json(self, file_name, use_i18n=False):
        cache_key = f"{file_name}_{self.language if use_i18n else 'base'}"
        if cache_key in self.data_cache:
            return self.data_cache[cache_key]
        shared_cache_key = (self.base_dir, cache_key)
        with self._shared_cache_lock:
            if shared_cache_key in self._shared_data_cache:
                data = self._shared_data_cache[shared_cache_key]
                self.data_cache[cache_key] = data
                return data

        if use_i18n and self.language:
            file_path = os.path.join(self.base_dir, "i18n", self.language, file_name)
        else:
            file_path = os.path.join(self.base_dir, file_name)

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        self.data_cache[cache_key] = data
        with self._shared_cache_lock:
            existing = self._shared_data_cache.get(shared_cache_key)
            if existing is not None:
                self.data_cache[cache_key] = existing
                return existing
            self._shared_data_cache[shared_cache_key] = data
        return data

    def build_index(self, file_name, key_field, use_i18n=False):
        cache_key = f"{file_name}_{key_field}_{self.language if use_i18n else 'base'}"
        if cache_key in self.indexes:
            return self.indexes[cache_key]
        shared_cache_key = (self.base_dir, cache_key)
        with self._shared_cache_lock:
            if shared_cache_key in self._shared_index_cache:
                index = self._shared_index_cache[shared_cache_key]
                self.indexes[cache_key] = index
                return index

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
        with self._shared_cache_lock:
            existing = self._shared_index_cache.get(shared_cache_key)
            if existing is not None:
                self.indexes[cache_key] = existing
                return existing
            self._shared_index_cache[shared_cache_key] = index
        return index

    def translate(self, text_key, language=""):
        """从i18n数据中获取翻译文本"""
        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return self.i18n_data_cn_alt.get(text_key, {}).get(
                "TextMapContent", text_key
            )

        # 获取当前语言
        language = language if language else self.language
        if not isinstance(language, str):
            language = "cn"

        if language == "cn":
            cn_alt = self.i18n_data_cn_alt.get(text_key, {}).get("TextMapContent", "")
            if cn_alt:
                return cn_alt

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
        return f"{self.translate(mod.get('Name', ''))}".strip()

    def get_char_name(self, char_id):
        char_index = self.build_index("Char.json", "Id")
        return self.translate(char_index.get(char_id, {}).get("Name", ""))

    def get_weapon_name(self, weapon_id):
        # Weapon.json 是字典形式，直接使用武器ID作为键
        weapon_data = self.load_json("Weapon.json")
        # 尝试将weapon_id转换为字符串，因为Weapon.json的键是字符串形式
        weapon_info = weapon_data.get(str(weapon_id), {})
        # Weapon.json中武器名称的字段名是WeaponName，不是Name
        return self.translate(weapon_info.get("WeaponName", ""))

    def get_accessory_name(self, accessory_id):
        # CharAccessory.json 是字典形式，直接使用配件ID作为键
        accessory_data = self.load_json("CharAccessory.json")
        # 尝试将accessory_id转换为字符串，因为CharAccessory.json的键是字符串形式
        accessory_info = accessory_data.get(str(accessory_id), {})
        # CharAccessory.json中配件名称的字段名是Name
        return self.translate(accessory_info.get("Name", ""))

    def get_title_name(self, title_id):
        # 回退到 Title.json 的通用翻译
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
        self.input_file_alias = {
            "HardBoss": "HardBossMain",
            "CharDataTarget": "CharacterDataTarget",
            "Event": "EventMain",
            "BackpackPuzzleItem": "PuzzleItemAttr",
            "IronSurvivalMonsterSpawn": "MonsterSpawn",
        }

        # 不在这里创建共享的DataLoader实例，改为每个任务创建独立实例

        # Initialize processors dictionary (延迟创建处理器实例)
        self.processor_classes = {
            "Achievement": AchievementProcessor,
            "Mod": ModProcessor,
            "Weapon": WeaponProcessor,
            "Char": CharProcessor,
            "CharDataTarget": CharDataTargetProcessor,
            "CharVoice": CharVoiceProcessor,
            "Monster": MonsterProcessor,
            "Draft": DraftProcessor,
            "Dungeon": DungeonProcessor,
            "Reward": RewardProcessor,
            "OptReward": OptRewardProcessor,
            "Pet": PetProcessor,
            "AbyssBuff": AbyssBuffProcessor,
            "AbyssDungeon": AbyssDungeonProcessor,
            "Walnut": WalnutProcessor,
            "Fish": FishProcessor,
            "FishingSpot": FishingSpotProcessor,
            "Resource": ResourceProcessor,
            "BookSeriesArchive": BookSeriesArchiveProcessor,
            "Dispatch": DispatchProcessor,
            "DynQuest": DynQuestProcessor,
            "QuestChain": QuestChainProcessor,
            "QuestStory": QuestStoryProcessor,
            "ForgeLevelQuest": ForgeLevelQuestProcessor,
            "PartyTopic": PartyTopicProcessor,
            "Region": RegionProcessor,
            "SubRegion": SubRegionProcessor,
            "RegionPoint": RegionPointProcessor,
            "RegionReputation": RegionReputationProcessor,
            "ShopItem": ShopItemProcessor,
            "Cutoff": CutoffProcessor,
            "RaidBuff": RaidBuffProcessor,
            "PetEntry": PetEntryProcessor,
            "RewardView": RewardViewProcessor,
            "HardBoss": HardBossProcessor,
            "RobotEquip": RobotEquipProcessor,
            "Mount": MountProcessor,
            "Title": TitleProcessor,
            "Npc": NpcProcessor,
            "CharAccessory": CharAccessoryProcessor,
            "WeaponAccessory": WeaponAccessoryProcessor,
            "WeaponSkin": WeaponSkinProcessor,
            "Skin": SkinProcessor,
            "HeadSculpture": HeadSculptureProcessor,
            "HeadFrame": HeadFrameProcessor,
            "Hair": HairProcessor,
            "BackpackPuzzleItem": BackpackPuzzleItemProcessor,
            "BackpackPuzzleLevel": BackpackPuzzleLevelProcessor,
            "ImpressionShop": ImpressionShopProcessor,
            "Event": EventProcessor,
            "MonsterStrongAffixes": MonsterStrongAffixesProcessor,
            "RougeLikeBlessing": RougeLikeBlessingProcessor,
            "RougeLikeContract": RougeLikeContractProcessor,
            "RougeLikeRoom": RougeLikeRoomProcessor,
            "RougeLikeStoryEvent": RougeLikeStoryEventProcessor,
            "RougeLikeTalent": RougeLikeTalentProcessor,
            "RougeLikeTreasure": RougeLikeTreasureProcessor,
            "SoloTreasure": SoloTreasureProcessor,
            "SoloTreasureGamePlay": SoloTreasureGamePlayProcessor,
            "IronTicket": IronTicketProcessor,
            "IronSurvivalMonsterSpawn": IronSurvivalMonsterSpawnProcessor,
            "ExtractionTreasure": ExtractionTreasureProcessor,
            "ExtractionTreasureBag": ExtractionTreasureBagProcessor,
            "ExtractionTreasureMechanism": ExtractionTreasureMechanismProcessor,
            "TreasureHuntProgress": TreasureHuntProgressProcessor,
            "TreasureHuntRepeatDungeon": TreasureHuntRepeatDungeonProcessor,
            "TreasureHuntStoryDungeon": TreasureHuntStoryDungeonProcessor,
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
        source_type = self.input_file_alias.get(file_type, file_type)
        file_path = os.path.join(self.base_dir, f"{source_type}.json")
        if not os.path.exists(file_path) and source_type != "QuestStory":
            print(f"Skip {file_type} for {language}: {source_type}.json not found")
            return

        # Load and process items
        items = processor.load_items(file_path)
        processed_items = processor.process_all_items(items, language)

        # Sort by id if applicable
        if isinstance(processed_items, list) and processed_items:
            processed_items.sort(key=lambda x: x.get("id", 0))

        # Create output directory path
        output_path = os.path.join(self.output_dir, "i18n", language)

        # Save processed items
        output_file = processor.save_processed_items(
            processed_items, output_path, f"{file_type}.json"
        )

        print(f"Processed {file_type} for {language} written to {output_file}")


if __name__ == "__main__":
    import argparse

    # 解析命令行参数
    parser = argparse.ArgumentParser(
        description="处理游戏数据文件，支持多语言和自定义文件类型"
    )
    parser.add_argument(
        "--file-types",
        "-f",
        nargs="+",
        help="要处理的文件类型列表，例如: -f Achievement Weapon Mod",
    )
    args = parser.parse_args()

    # Define base directory for input files
    BASE_DIR = os.path.join(os.getcwd(), "out")

    # Define output directory
    OUTPUT_DIR = os.path.join(os.getcwd(), "final")

    # Define languages to process
    LANGUAGES = ["cn", "en", "jp", "kr", "tc", "fr"]

    # Define default file types to process
    default_file_types = [
        "Achievement",
        "Mod",
        "Char",
        "CharDataTarget",
        "CharVoice",
        "Monster",
        "Weapon",
        "Dungeon",
        "Draft",
        "Reward",
        "OptReward",
        "Pet",
        "AbyssBuff",
        "AbyssDungeon",
        "Walnut",
        "Fish",
        "FishingSpot",
        "Dispatch",
        "DynQuest",
        "Resource",
        "BookSeriesArchive",
        "ForgeLevelQuest",
        "QuestChain",
        "QuestStory",
        "PartyTopic",
        "Region",
        "SubRegion",
        "RegionPoint",
        "RegionReputation",
        "ShopItem",
        "Cutoff",
        "RaidBuff",
        "PetEntry",
        "RewardView",
        "HardBoss",
        "RobotEquip",
        "Mount",
        "Title",
        "Npc",
        "CharAccessory",
        "WeaponAccessory",
        "WeaponSkin",
        "HyperWeaponCardLevel",
        "Skin",
        "HeadSculpture",
        "HeadFrame",
        "Hair",
        "BackpackPuzzleItem",
        "BackpackPuzzleLevel",
        "ImpressionShop",
        "Event",
        "MonsterStrongAffixes",
        "RougeLikeBlessing",
        "RougeLikeContract",
        "RougeLikeRoom",
        "RougeLikeStoryEvent",
        "RougeLikeTalent",
        "RougeLikeTreasure",
        "SoloTreasure",
        "SoloTreasureGamePlay",
        "IronTicket",
        "IronSurvivalMonsterSpawn",
        "ExtractionTreasure",
        "ExtractionTreasureBag",
        "ExtractionTreasureMechanism",
        "TreasureHuntProgress",
        "TreasureHuntRepeatDungeon",
        "TreasureHuntStoryDungeon",
    ]

    # 使用命令行参数指定的文件类型，如果没有则使用默认列表
    FILE_TYPES = args.file_types if args.file_types else default_file_types

    # Create processor and process all specified file types for all languages
    processor = FinalProcessor(BASE_DIR, OUTPUT_DIR)
    processor.process_all_languages(FILE_TYPES, LANGUAGES)
