from collections import OrderedDict
from processor.base_processor import BaseProcessor


class TreasureHuntRepeatDungeonProcessor(BaseProcessor):
    """秘宝重复副本导出器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "TreasureHuntRepeatDungeon"

    def process_item(self, item, language):
        """处理单个秘宝重复副本数据"""
        event_dungeon_id = item.get("EventDugeonId", 0)
        if not event_dungeon_id:
            return None

        processed = OrderedDict()
        processed["id"] = event_dungeon_id

        dungeon_name = self.get_translated_text(item.get("DungeonName", ""), language)
        if dungeon_name:
            processed["name"] = dungeon_name

        dungeon_desc = self.get_translated_text(item.get("DungeonDes", ""), language)
        if dungeon_desc:
            processed["desc"] = dungeon_desc

        dungeon_image = item.get("DungeonImage", "")
        if dungeon_image:
            image_name = dungeon_image.split("/")[-1].split(".")[0]
            if image_name:
                processed["image"] = image_name

        easy_dungeon_id = item.get("EasyDungeonId")
        if easy_dungeon_id is not None:
            processed["easyDungeonId"] = easy_dungeon_id

        easy_mode_fee = item.get("EasyModeFee")
        if easy_mode_fee is not None:
            processed["easyModeFee"] = easy_mode_fee

        hard_dungeon_id = item.get("HardDungeonId")
        if hard_dungeon_id is not None:
            processed["hardDungeonId"] = hard_dungeon_id

        hard_mode_fee = item.get("HardModeFee")
        if hard_mode_fee is not None:
            processed["hardModeFee"] = hard_mode_fee

        if "EasyMaxConvertResource" in item:
            processed["easyMaxConvertResource"] = item.get("EasyMaxConvertResource")

        if "EasyScoreToResource" in item:
            processed["easyScoreToResource"] = item.get("EasyScoreToResource")

        if "HardMaxConvertResource" in item:
            processed["hardMaxConvertResource"] = item.get("HardMaxConvertResource")

        if "HardScoreToResource" in item:
            processed["hardScoreToResource"] = item.get("HardScoreToResource")

        processed["banEasyPhantom"] = bool(item.get("IsBanEasyPhantom", False))
        processed["banHardPhantom"] = bool(item.get("IsBanHardPhantom", False))

        level_backpack = item.get("LevelBackPack", [])
        if isinstance(level_backpack, list) and level_backpack:
            processed["levelBackPack"] = level_backpack

        trial_character = item.get("TrialCharacter", [])
        if isinstance(trial_character, list) and trial_character:
            processed["trialCharacter"] = trial_character

        trial_weapon = item.get("TrialWeapon", [])
        if isinstance(trial_weapon, list) and trial_weapon:
            processed["trialWeapon"] = trial_weapon

        unlock_condition = item.get("UnlockCondition")
        if unlock_condition is not None:
            processed["unlockCondition"] = unlock_condition

        return processed
