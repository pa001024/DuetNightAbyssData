from processor.base_processor import BaseProcessor


class QuestChainProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "QuestChain"
        # 加载 STLExportQuestChain.json 文件
        self.stl_export_quest_chain_data = data_loader.load_json(
            "STLExportQuestChain.json"
        )

    def get_quests_for_chain(self, quest_chain_id):
        """获取指定任务链的 Quests 数据

        Args:
            quest_chain_id: 任务链 ID

        Returns:
            dict: Quests 数据
        """
        # 将 quest_chain_id 转换为字符串以便在字典中查找
        quest_chain_id_str = str(quest_chain_id)
        if quest_chain_id_str in self.stl_export_quest_chain_data:
            return self.stl_export_quest_chain_data[quest_chain_id_str].get(
                "Quests", {}
            )
        return {}

    def process_item(self, quest_chain_data, language):
        """处理单个任务链数据

        Args:
            quest_chain_data: 原始任务链数据
            language: 语言类型

        Returns:
            处理后的任务链数据
        """
        quest_chain_id = quest_chain_data.get("QuestChainId")

        # 处理翻译文本
        chapter_name_key = quest_chain_data.get("ChapterName")
        chapter_name = ""
        if chapter_name_key:
            chapter_name = self.get_translated_text(chapter_name_key, language)

        chapter_number_key = quest_chain_data.get("ChapterNumber")
        chapter_number = ""
        if chapter_number_key:
            chapter_number = self.get_translated_text(chapter_number_key, language)

        episode_key = quest_chain_data.get("Episode")
        episode = ""
        if episode_key:
            episode = self.get_translated_text(episode_key, language)

        episode_name_key = quest_chain_data.get("EpisodeName")
        episode_name = ""
        if episode_name_key:
            episode_name = self.get_translated_text(episode_name_key, language)

        quest_chain_name_key = quest_chain_data.get("QuestChainName")
        quest_chain_name = ""
        if quest_chain_name_key:
            quest_chain_name = self.get_translated_text(quest_chain_name_key, language)

        main_story_unlock_message_key = quest_chain_data.get("MainStoryUnlockMessage")
        main_story_unlock_message = ""
        if main_story_unlock_message_key:
            main_story_unlock_message = self.get_translated_text(
                main_story_unlock_message_key, language
            )

        # 处理其他可选字段
        quest_description_key = quest_chain_data.get("QuestDescription")
        quest_description = ""
        if quest_description_key:
            quest_description = self.get_translated_text(
                quest_description_key, language
            )

        quest_detail_key = quest_chain_data.get("QuestDetail")
        quest_detail = ""
        if quest_detail_key:
            quest_detail = self.get_translated_text(quest_detail_key, language)

        unlock_title_key = quest_chain_data.get("UnlockTitle")
        unlock_title = ""
        if unlock_title_key:
            unlock_title = self.get_translated_text(unlock_title_key, language)

        unlock_content_key = quest_chain_data.get("UnlockContent")
        unlock_content = ""
        if unlock_content_key:
            unlock_content = self.get_translated_text(unlock_content_key, language)

        # 构建处理后的任务链数据（临时字典）
        temp_data = {
            "id": quest_chain_id,
            "name": quest_chain_name,
            "chapterName": chapter_name,
            "chapterNumber": chapter_number,
            "episode": episode,
            # "episodeName": episode_name,
            "ifAutoStart": quest_chain_data.get("IfAutoStart"),
            "isDefaultTrack": quest_chain_data.get("IsDefaultTrack"),
            "isOpenReasoning": quest_chain_data.get("IsOpenReasoning"),
            "isShowWindow": quest_chain_data.get("IsShowWindow"),
            # 是否是主线
            "isMainStory": quest_chain_data.get("MainStoryType"),
            # "mainStoryUnlockMessage": main_story_unlock_message,
            "questChainType": quest_chain_data.get("QuestChainType"),
            "reward": quest_chain_data.get("QuestChainReward"),
            "questReward": quest_chain_data.get("QuestReward"),
            "desc": quest_description,
            "detail": quest_detail,
            "showCondition": quest_chain_data.get("ShowCondition"),
            "unlockCondition": quest_chain_data.get("UnlockCondition"),
            # "storyPath": quest_chain_data.get("StoryPath"),
            "icon": quest_chain_data.get("ChapterBeginEndIconPath", "")
            .split(".")[-1]
            .replace("'", ""),
            "loginPlayerTransform": quest_chain_data.get("LoginPlayerTransform"),
            "lockShowSubRegionId": quest_chain_data.get("LockShowSubRegionId"),
            "lockShowTeleportPointName": quest_chain_data.get(
                "LockShowTeleportPointName"
            ),
            "questNpcId": quest_chain_data.get("QuestNpcId"),
            # "unlockTitle": unlock_title,
            # "unlockContent": unlock_content,
            # "specialQuestDisplayName": quest_chain_data.get("SpecialQuestDisplayName"),
            "startTime": quest_chain_data.get("StartTime"),
            "endTime": quest_chain_data.get("EndTime"),
        }
        quests = self.get_quests_for_chain(quest_chain_id)
        if quests:
            temp_data["quests"] = quests

        # 处理数据：去除空字段，bool值转为1|undefined
        processed_quest_chain = {}
        for key, value in temp_data.items():
            # 处理bool值
            if isinstance(value, bool):
                if value:
                    processed_quest_chain[key] = 1
                # 否则不添加该字段（undefined）
            # 处理空字符串
            elif isinstance(value, str) and value:
                processed_quest_chain[key] = value
            # 处理数字
            elif isinstance(value, (int, float)):
                processed_quest_chain[key] = value
            # 处理列表
            elif isinstance(value, list) and value:
                processed_quest_chain[key] = value
            # 处理字典
            elif isinstance(value, dict) and value:
                processed_quest_chain[key] = value
            # 处理其他非空值
            elif value is not None and value:
                processed_quest_chain[key] = value

        return processed_quest_chain
