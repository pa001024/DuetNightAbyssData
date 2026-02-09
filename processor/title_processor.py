from processor.base_processor import BaseProcessor


class TitleProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Title"
        self._build_title_access()

    def _build_title_access(self):
        """构建Title获取方式映射"""
        self.title_access = {}
        self.theater_task_map = {}

        reward_data = self.data_loader.load_json("Reward.json")
        achievement_data = self.data_loader.load_json("Achievement.json")
        quest_chain_data = self.data_loader.load_json("QuestChain.json")
        theater_task_data = self.data_loader.load_json("TheaterTask.json")

        for achievement_id, achievement in achievement_data.items():
            reward_id = achievement.get("AchievementReward", 0)
            reward_info = reward_data.get(str(reward_id), {})
            ids = reward_info.get("Id", [])
            reward_types = reward_info.get("Type", [])

            for i, item_id in enumerate(ids):
                item_type = reward_types[i] if i < len(reward_types) else ""
                if item_type == "Title":
                    self.title_access[str(item_id)] = ["Achievement", achievement_id]

        for quest_chain_id, quest_chain in quest_chain_data.items():
            reward_list = quest_chain.get("QuestChainReward", [])
            for reward_id in reward_list:
                reward_info = reward_data.get(str(reward_id), {})
                ids = reward_info.get("Id", [])
                reward_types = reward_info.get("Type", [])

                for i, item_id in enumerate(ids):
                    item_type = reward_types[i] if i < len(reward_types) else ""
                    if item_type == "Title":
                        self.title_access[str(item_id)] = ["Quest", quest_chain_id]

        for theater_task in theater_task_data:
            theater_task_id = theater_task.get("TheaterTaskID", 0)
            reward_id = theater_task.get("RewardId", 0)
            self.theater_task_map[str(theater_task_id)] = theater_task

            reward_info = reward_data.get(str(reward_id), {})
            ids = reward_info.get("Id", [])
            reward_types = reward_info.get("Type", [])

            for i, item_id in enumerate(ids):
                item_type = reward_types[i] if i < len(reward_types) else ""
                if item_type == "Title":
                    self.title_access[str(item_id)] = ["TheaterTask", theater_task_id]

    def process_item(self, title_data, language):
        """处理单个Title项目"""
        title_id = title_data.get("TitleID", 0)
        name_key = title_data.get("Name", "")
        des_key = title_data.get("Des", "")
        icon = title_data.get("Icon", "")
        if_suffix = title_data.get("IfSuffix", False)

        icon_name = self._extract_icon_name(icon)

        translated_name = self.get_translated_text(name_key, language)
        translated_des = self.get_translated_text(des_key, language)
        access_text = self._get_access_text(title_id, language)

        processed = {
            "id": title_id,
            "name": translated_name,
            # "Des": translated_des,
            # "Icon": icon_name,
            "suf": if_suffix,
            "src": access_text,
        }
        if not processed["src"]:
            del processed["src"]

        return processed

    def _get_access_text(self, title_id, language):
        """获取称号获取方式文本"""
        title_id_str = str(title_id)

        if title_id_str not in self.title_access:
            return ""

        access_data = self.title_access[title_id_str]

        if isinstance(access_data, str):
            return access_data

        if isinstance(access_data, list) and len(access_data) >= 2:
            access_type = access_data[0]
            access_id = access_data[1]

            if access_type == "Achievement":
                achievement_data = self.data_loader.load_json("Achievement.json")
                achievement = achievement_data.get(str(access_id), {})
                achievement_name_key = achievement.get("AchievementName", "")
                achievement_name = self.get_translated_text(
                    achievement_name_key, language
                )
                return f"成就「{achievement_name}」"

            elif access_type == "Quest":
                quest_chain_data = self.data_loader.load_json("QuestChain.json")
                quest_chain = quest_chain_data.get(str(access_id), {})
                quest_type_key = quest_chain.get("QuestChainType", "")
                quest_name_key = quest_chain.get("QuestChainName", "")

                quest_type_name = self._get_quest_type_name(quest_type_key, language)
                quest_name = self.get_translated_text(quest_name_key, language)
                return f"{quest_type_name}「{quest_name}」"

            elif access_type == "Event":
                event_main_data = self.data_loader.load_json("EventMain.json")
                event = event_main_data.get(str(access_id), {})
                event_name_key = event.get("EventName", "")
                event_name = self.get_translated_text(event_name_key, language)
                return f"活动「{event_name}」"

            elif access_type == "Skin":
                skin_data = self.data_loader.load_json("Skin.json")
                skin = skin_data.get(str(access_id), {})
                skin_name_key = skin.get("SkinName", "")
                skin_name = self.get_translated_text(skin_name_key, language)
                return f"角色皮肤「{skin_name}」"

            elif access_type == "TheaterTask":
                theater_task = self.theater_task_map.get(str(access_id), {})
                des_key = theater_task.get("Des", "")
                target = theater_task.get("Target", "")
                des_text = self.get_translated_text(des_key, language)
                return self._fill_template_placeholder(des_text, target)

            else:
                return f"{access_type}「{access_id}」"

        return ""

    def _get_quest_type_name(self, quest_type_key, language):
        """获取任务类型名称"""
        quest_type_map = {
            1: "UI_QUEST_SUBTAB_NAME_MAIN",
            3: "UI_QUEST_SUBTAB_NAME_SIDE",
            4: "UI_QUEST_SUBTAB_NAME_SpecialSlide",
            5: "UI_QUEST_SUBTAB_NAME_LimitedtimeActivity",
            6: "UI_QUEST_SUBTAB_NAME_Activity",
        }
        quest_type_name_key = quest_type_map.get(quest_type_key, "")
        return self.get_translated_text(quest_type_name_key, language)

    def _extract_icon_name(self, icon_path):
        """从图标路径中提取图标名称"""
        if not icon_path:
            return ""

        import os

        base_name = os.path.basename(icon_path)
        icon_name = base_name.split(".")[0]
        return icon_name

    def _fill_template_placeholder(self, text, value):
        """填充文本中的占位符（如%s、%d、{0}）"""
        if not text:
            return ""
        if value in (None, ""):
            return text

        value_str = str(value)
        if "{0}" in text:
            return text.replace("{0}", value_str)

        try:
            return text % value
        except Exception:
            return text.replace("%s", value_str).replace("%d", value_str)

    def process_all_items(self, items, language):
        """处理所有项目，添加排序"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        processed_items.sort(key=lambda x: x.get("TitleID", 0))

        return processed_items
