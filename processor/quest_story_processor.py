import json
import os
from pathlib import Path
from collections import OrderedDict
from processor.base_processor import BaseProcessor


class QuestStoryProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "QuestStory"
        self.story_files_base_path = os.path.join("out", "StoryCreator", "StoryFiles")

    def load_items(self, file_path):
        """加载任务链数据（兼容接口）

        Args:
            file_path: 文件路径（不使用，此方法总是加载 QuestChain.json）

        Returns:
            list: 任务链数据列表
        """
        # 加载任务链数据
        quest_chain_data = self.data_loader.load_json("QuestChain.json")

        if not quest_chain_data:
            return []

        # 转换为列表格式
        if isinstance(quest_chain_data, dict):
            return list(quest_chain_data.values())
        else:
            return quest_chain_data

    def process_all_items(self, items, language=""):
        """处理所有任务链（兼容接口）

        Args:
            items: 任务链数据列表
            language: 语言类型

        Returns:
            list: 处理后的任务故事数据
        """
        # 设置语言
        self.data_loader.set_language(language)

        # 加载 STLExportQuestChain.json
        stl_quest_chain_data = self.data_loader.load_json("STLExportQuestChain.json")

        all_quest_stories = []

        # 遍历所有任务链
        for quest_chain_info in items:
            quest_story = self.process_quest_chain(
                quest_chain_info, stl_quest_chain_data, language
            )
            if quest_story:
                all_quest_stories.append(quest_story)

        return all_quest_stories

    def save_processed_items(self, items, output_path, file_name):
        """保存处理后的任务故事数据（兼容接口）

        Args:
            items: 任务故事数据列表
            output_path: 输出路径
            file_name: 输出文件名

        Returns:
            str: 输出文件路径
        """
        # 创建输出目录
        os.makedirs(output_path, exist_ok=True)

        # 保存结果
        output_file = os.path.join(output_path, file_name)
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(items, f, ensure_ascii=False, indent=2, sort_keys=False)

        return output_file

    def load_story_file(self, story_path):
        """加载故事文件

        Args:
            story_path: 故事路径，如 "MainStory/1001/100101.story"

        Returns:
            dict: 故事文件数据，如果加载失败返回 None
        """
        try:
            # 将 .story 替换为 .json
            json_path = story_path.replace(".story", ".json")
            # 替换路径分隔符
            json_path = json_path.replace("\\", os.sep).replace("/", os.sep)
            # 构建完整路径
            full_path = os.path.join(self.story_files_base_path, json_path)

            if not os.path.exists(full_path):
                print(f"故事文件不存在: {full_path}", flush=True)
                return None

            with open(full_path, "r", encoding="utf-8") as f:
                return json.load(f, object_pairs_hook=OrderedDict)
        except Exception as e:
            print(f"加载故事文件失败 {story_path}: {e}", flush=True)
            return None

    def find_talk_nodes_for_quest(self, story_data, quest_id):
        """在故事数据中查找指定任务的所有对话节点

        Args:
            story_data: 故事数据
            quest_id: 任务ID

        Returns:
            list: 对话节点列表
        """
        talk_nodes = []
        if not story_data or "storyNodeData" not in story_data:
            return talk_nodes

        story_node_data = story_data["storyNodeData"]

        # 遍历所有故事节点
        for node_key, node_data in story_node_data.items():
            # 检查该故事节点是否包含指定的 QuestId
            props_data = node_data.get("propsData", {})
            if props_data.get("QuestId") != quest_id:
                continue

            # 优先检查 questNodeData.nodeData 中的对话节点
            quest_node_data = node_data.get("questNodeData", {})
            if quest_node_data:
                node_data_dict = quest_node_data.get("nodeData", {})
                for sub_node_key, sub_node in node_data_dict.items():
                    # 检查是否是对话节点
                    if sub_node.get("type") == "TalkNode":
                        sub_props_data = sub_node.get("propsData", {})
                        # 检查是否有 FirstDialogueId
                        if "FirstDialogueId" in sub_props_data:
                            talk_nodes.append(
                                {
                                    "node_key": sub_node_key,
                                    "first_dialogue_id": sub_props_data.get(
                                        "FirstDialogueId"
                                    ),
                                    "props_data": sub_props_data,
                                }
                            )

            # 检查该节点本身是否是对话节点
            if node_data.get("type") == "TalkNode":
                node_props_data = node_data.get("propsData", {})
                # 检查是否有 FirstDialogueId
                if "FirstDialogueId" in node_props_data:
                    talk_nodes.append(
                        {
                            "node_key": node_key,
                            "first_dialogue_id": node_props_data.get("FirstDialogueId"),
                            "props_data": node_props_data,
                        }
                    )

        return talk_nodes

    def process_quest_chain(self, quest_chain_data, stl_quest_chain_data, language=""):
        """处理单个任务链

        Args:
            quest_chain_data: 任务链基本信息（来自 QuestChain.json）
            stl_quest_chain_data: 任务链详细数据（来自 STLExportQuestChain.json）
            language: 语言类型

        Returns:
            dict: 处理后的任务链数据
        """
        quest_chain_id = quest_chain_data.get("QuestChainId")
        story_path = quest_chain_data.get("StoryPath", "")

        if not story_path:
            print(f"任务链 {quest_chain_id} 没有 StoryPath", flush=True)
            return None

        # 加载故事文件
        story_data = self.load_story_file(story_path)
        if not story_data:
            print(f"无法加载故事文件: {story_path}", flush=True)
            return None

        # 从 STLExportQuestChain.json 获取任务链中的所有任务
        quest_chain_id_str = str(quest_chain_id)
        if quest_chain_id_str not in stl_quest_chain_data:
            return None

        stl_quest_chain = stl_quest_chain_data[quest_chain_id_str]
        quests = stl_quest_chain.get("Quests", {})
        quest_stories = []

        # 遍历每个任务
        for quest_key, quest_info in quests.items():
            # 任务ID就是键本身
            try:
                quest_id = int(quest_key)
            except ValueError:
                continue

            # 查找该任务的所有对话节点
            talk_nodes = self.find_talk_nodes_for_quest(story_data, quest_id)

            if not talk_nodes:
                continue

            # 处理每个对话节点
            dialogues = []
            for talk_node in talk_nodes:
                first_dialogue_id = talk_node["first_dialogue_id"]
                dialogue_chain = self.get_dialogue_chain(first_dialogue_id, language)

                if dialogue_chain:
                    dialogues.extend(dialogue_chain)

            if dialogues:
                quest_stories.append({"id": quest_id, "dialogues": dialogues})

        if not quest_stories:
            return None

        return {"id": quest_chain_id, "quests": quest_stories}

    def process_all_quest_chains(self, language=""):
        """处理所有任务链

        Args:
            language: 语言类型

        Returns:
            list: 所有任务链的故事数据
        """
        # 加载任务链数据
        quest_chain_data = self.data_loader.load_json("QuestChain.json")
        stl_quest_chain_data = self.data_loader.load_json("STLExportQuestChain.json")

        if not quest_chain_data:
            print("未找到任务链数据", flush=True)
            return []

        all_quest_stories = []

        # 遍历所有任务链（可能是字典或数组）
        if isinstance(quest_chain_data, dict):
            quest_chain_list = list(quest_chain_data.values())
        else:
            quest_chain_list = quest_chain_data

        for quest_chain_info in quest_chain_list:
            quest_story = self.process_quest_chain(
                quest_chain_info, stl_quest_chain_data, language
            )
            if quest_story:
                all_quest_stories.append(quest_story)

        return all_quest_stories

    def process_and_save(self, output_path="out", language=""):
        """处理并保存任务故事数据

        Args:
            output_path: 输出路径
            language: 语言类型

        Returns:
            str: 输出文件路径
        """
        print("开始处理任务故事数据...", flush=True)

        # 处理所有任务链
        quest_stories = self.process_all_quest_chains(language)

        print(f"共处理 {len(quest_stories)} 个任务链", flush=True)

        # 保存结果
        output_file = os.path.join(output_path, "QuestStory.json")
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(quest_stories, f, ensure_ascii=False, indent=2, sort_keys=False)

        print(f"任务故事数据已保存到: {output_file}", flush=True)

        return output_file
