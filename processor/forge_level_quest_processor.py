from collections import OrderedDict

from processor.base_processor import BaseProcessor


class ForgeLevelQuestProcessor(BaseProcessor):
    """锻造等级任务导出器。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ForgeLevelQuest"

    def load_items(self, file_path):
        """按常规方式读取 ForgeLevelQuest.json。"""
        return BaseProcessor.load_items(self, file_path)

    def process_all_items(self, items, language=""):
        """按基础流程处理所有锻造等级任务。"""
        self.data_loader.set_language(language)
        return BaseProcessor.process_all_items(self, items, language)

    def _normalize_array_field(self, value):
        """兼容列表和 1-based map。"""
        if isinstance(value, list):
            return value
        if isinstance(value, dict):
            result = []
            for key, item in value.items():
                try:
                    index = int(key) - 1
                except (TypeError, ValueError):
                    continue
                if index < 0:
                    continue
                while len(result) <= index:
                    result.append(None)
                result[index] = item
            return result
        return []

    def process_item(self, item_data, language):
        """处理单个锻造等级任务数据。"""
        forge_quest_id = item_data.get("ForgeQuestId", 0)
        if not forge_quest_id:
            return None

        processed = OrderedDict()
        processed["id"] = forge_quest_id

        task_name = self.get_translated_text(item_data.get("DailyTasktDes", ""), language)
        if task_name:
            processed["desc"] = task_name

        target = item_data.get("Target")
        if target is not None:
            processed["target"] = target

        target_ids = self._normalize_array_field(item_data.get("TargetId", []))
        target_ids = [target_id for target_id in target_ids if target_id is not None]
        if target_ids:
            processed["targetId"] = target_ids

        quest_reward = self._normalize_array_field(item_data.get("QuestReward", []))
        quest_reward = [reward_id for reward_id in quest_reward if reward_id is not None]
        if quest_reward:
            processed["reward"] = quest_reward

        return processed
