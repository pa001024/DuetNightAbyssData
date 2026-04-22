from collections import OrderedDict
from processor.base_processor import BaseProcessor


class TreasureHuntStoryDungeonProcessor(BaseProcessor):
    """秘宝剧情副本导出器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "TreasureHuntStoryDungeon"

    def process_item(self, item, language):
        """处理单个秘宝剧情副本数据"""
        event_dungeon_id = item.get("EventDugeonId", 0)
        if not event_dungeon_id:
            return None

        processed = OrderedDict()
        processed["id"] = event_dungeon_id

        dungeon_id = item.get("DungeonId", 0)
        if dungeon_id:
            processed["did"] = dungeon_id

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

        fee = item.get("Fee")
        if fee is not None:
            processed["fee"] = fee

        fee_resource = item.get("FeeResource")
        if fee_resource is not None:
            processed["feeResource"] = fee_resource

        processed["banPhantom"] = bool(item.get("IsBanPhantom", False))

        level_backpack = item.get("LevelBackPack", [])
        if isinstance(level_backpack, list) and level_backpack:
            processed["levelBackPack"] = level_backpack

        limit_character = item.get("LimitCharacter", [])
        if isinstance(limit_character, list) and limit_character:
            processed["limitCharacter"] = limit_character

        trial_character = item.get("TrialCharacter", [])
        if isinstance(trial_character, list) and trial_character:
            processed["trialCharacter"] = trial_character

        trial_pet = item.get("TrialPet", [])
        if isinstance(trial_pet, list) and trial_pet:
            processed["trialPet"] = trial_pet

        trial_weapon = item.get("TrialWeapon", [])
        if isinstance(trial_weapon, list) and trial_weapon:
            processed["trialWeapon"] = trial_weapon

        unlock_condition = item.get("UnlockCondition")
        if unlock_condition is not None:
            processed["unlockCondition"] = unlock_condition

        return processed
