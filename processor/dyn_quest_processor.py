from processor.base_processor import BaseProcessor


class DynQuestProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "DynQuest"

    def process_item(self, quest_data, language):
        """处理单个动态任务数据

        Args:
            quest_data: 原始动态任务数据
            language: 语言类型

        Returns:
            处理后的动态任务数据
        """
        quest_id = quest_data.get("DynQuestId")
        
        dyn_name_key = quest_data.get("DynName")
        quest_name = ""
        if dyn_name_key:
            quest_name = self.get_translated_text(dyn_name_key, language)
        
        player_level = quest_data.get("PlayerLevel", [])
        
        processed_quest = {
            "id": quest_id,
            "name": quest_name,
            "level": player_level,
            "regionId": quest_data.get("RegionId"),
            "subRegionId": quest_data.get("SubRegionId"),
            "chance": quest_data.get("Chance"),
            "completeNum": quest_data.get("CompleteNum"),
            "dayLimit": quest_data.get("DayLimit"),
            "reward": quest_data.get("Reward", []),
        }
        
        return processed_quest
