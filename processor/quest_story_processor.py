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
        """在故事数据中查找指定任务的所有对话节点和推理节点

        Args:
            story_data: 故事数据
            quest_id: 任务ID

        Returns:
            list: 节点列表，包含对话节点和推理节点
        """
        nodes = []
        if not story_data or "storyNodeData" not in story_data:
            return nodes

        story_node_data = story_data["storyNodeData"]

        # 遍历所有故事节点
        for node_key, node_data in story_node_data.items():
            # 检查该故事节点是否包含指定的 QuestId
            props_data = node_data.get("propsData", {})
            if props_data.get("QuestId") != quest_id:
                continue

            # 优先检查 questNodeData.nodeData 中的节点
            quest_node_data = node_data.get("questNodeData", {})
            if quest_node_data:
                node_data_dict = quest_node_data.get("nodeData", {})
                for sub_node_key, sub_node in node_data_dict.items():
                    node_type = sub_node.get("type")
                    sub_props_data = sub_node.get("propsData", {})

                    # 检查是否是对话节点
                    if node_type == "TalkNode":
                        # 检查是否有 FirstDialogueId
                        if "FirstDialogueId" in sub_props_data:
                            nodes.append(
                                {
                                    "node_key": sub_node_key,
                                    "type": node_type,
                                    "name": sub_node.get("name", ""),
                                    "first_dialogue_id": sub_props_data.get(
                                        "FirstDialogueId"
                                    ),
                                    "props_data": sub_props_data,
                                }
                            )
                    # 检查是否是推理问题节点
                    elif node_type == "UnlockDetectiveQuestionNode":
                        nodes.append(
                            {
                                "node_key": sub_node_key,
                                "type": node_type,
                                "name": sub_node.get("name", ""),
                                "props_data": sub_props_data,
                                "question_ids": sub_props_data.get("QuestionIds", []),
                            }
                        )
                    # 检查是否是推理答案节点
                    elif node_type == "UnlockDetectiveAnswerNode":
                        nodes.append(
                            {
                                "node_key": sub_node_key,
                                "type": node_type,
                                "name": sub_node.get("name", ""),
                                "props_data": sub_props_data,
                                "answer_ids": sub_props_data.get("AnswerIds", []),
                            }
                        )

            # 检查该节点本身是否是对话节点
            node_type = node_data.get("type")
            if node_type == "TalkNode":
                node_props_data = node_data.get("propsData", {})
                # 检查是否有 FirstDialogueId
                if "FirstDialogueId" in node_props_data:
                    nodes.append(
                        {
                            "node_key": node_key,
                            "type": node_type,
                            "name": node_data.get("name", ""),
                            "first_dialogue_id": node_props_data.get("FirstDialogueId"),
                            "props_data": node_props_data,
                        }
                    )

        return nodes

    def get_node_has_dialogue(self, node_data_dict, node_key):
        """检查节点是否包含对话

        Args:
            node_data_dict: 节点数据字典
            node_key: 节点键

        Returns:
            bool: 是否包含对话
        """
        if node_key in node_data_dict:
            node = node_data_dict[node_key]
            node_type = node.get("type")
            props_data = node.get("propsData", {})
            # 检查是否是对话节点且有 FirstDialogueId
            if node_type == "TalkNode" and "FirstDialogueId" in props_data:
                return True
        return False

    def dfs_find_dialogue_branch(self, node_data_dict, start_node, end_node, visited):
        """DFS查找从start_node到end_node的路径是否包含对话

        Args:
            node_data_dict: 节点数据字典
            start_node: 起始节点
            end_node: 结束节点
            visited: 已访问节点集合

        Returns:
            bool: 是否包含对话
        """
        if start_node == end_node:
            return self.get_node_has_dialogue(node_data_dict, end_node)

        visited.add(start_node)

        # 查找所有从start_node出发的边
        for edge in self.quest_line_data:
            if edge["startQuest"] == start_node and edge["endQuest"] not in visited:
                # 检查目标节点是否包含对话
                if self.get_node_has_dialogue(node_data_dict, edge["endQuest"]):
                    return True
                # 递归查找
                if self.dfs_find_dialogue_branch(
                    node_data_dict, edge["endQuest"], end_node, visited.copy()
                ):
                    return True

        return False

    def process_quest_nodes_order(self, story_data, quest_id):
        """处理任务节点的顺序

        Args:
            story_data: 故事数据
            quest_id: 任务ID

        Returns:
            list: 按顺序排列的节点列表
        """
        nodes = []
        if not story_data or "storyNodeData" not in story_data:
            return nodes

        story_node_data = story_data["storyNodeData"]

        # 遍历所有故事节点
        for node_key, node_data in story_node_data.items():
            # 检查该故事节点是否包含指定的 QuestId
            props_data = node_data.get("propsData", {})
            if props_data.get("QuestId") != quest_id:
                continue

            # 优先检查 questNodeData.nodeData 中的节点
            quest_node_data = node_data.get("questNodeData", {})
            if quest_node_data:
                node_data_dict = quest_node_data.get("nodeData", {})
                self.quest_line_data = quest_node_data.get("lineData", [])

                # 构建节点映射关系
                node_map = {}
                for sub_node_key, sub_node in node_data_dict.items():
                    node_map[sub_node_key] = sub_node

                # 查找起始节点（QuestStart 边的终点才是首个可执行节点）
                start_nodes = []
                for edge in self.quest_line_data:
                    if edge["startPort"] == "QuestStart":
                        start_nodes.append(str(edge["endQuest"]))

                if not start_nodes:
                    continue

                # 从起始节点开始，按顺序查找节点
                current_nodes = start_nodes
                visited = set()
                ordered_nodes = []
                quest_next_map = {}

                while current_nodes:
                    next_nodes = []
                    next_nodes_seen = set()
                    for current_node in current_nodes:
                        if current_node in visited:
                            continue

                        visited.add(current_node)

                        # 收集当前节点的所有后继（Out/PC），并去重
                        edges_from_current = []
                        for edge in self.quest_line_data:
                            if edge["startQuest"] == current_node and edge[
                                "startPort"
                            ] in ["Out", "PC"]:
                                edges_from_current.append(edge)

                        next_node_ids = []
                        next_seen = set()
                        for edge in edges_from_current:
                            end_quest = edge.get("endQuest")
                            if end_quest is None:
                                continue
                            end_quest = str(end_quest)
                            if end_quest not in next_seen:
                                next_seen.add(end_quest)
                                next_node_ids.append(end_quest)

                        # 记录完整后继关系，用于 next 跨非输出节点解析
                        quest_next_map[str(current_node)] = next_node_ids

                        # 检查当前节点是否是对话节点
                        if current_node in node_map:
                            node_type = node_map[current_node].get("type")
                            sub_props_data = node_map[current_node].get("propsData", {})

                            # 检查是否是对话节点
                            if node_type == "TalkNode":
                                # 检查是否有 FirstDialogueId
                                if "FirstDialogueId" in sub_props_data:
                                    node_item = {
                                        "node_key": current_node,
                                        "type": node_type,
                                        "name": node_map[current_node].get("name", ""),
                                        "first_dialogue_id": sub_props_data.get(
                                            "FirstDialogueId"
                                        ),
                                        "props_data": sub_props_data,
                                    }
                                    if next_node_ids:
                                        node_item["next"] = next_node_ids
                                    ordered_nodes.append(node_item)
                            # 检查是否是推理问题节点
                            elif node_type == "UnlockDetectiveQuestionNode":
                                node_item = {
                                    "node_key": current_node,
                                    "type": node_type,
                                    "name": node_map[current_node].get("name", ""),
                                    "props_data": sub_props_data,
                                    "question_ids": sub_props_data.get(
                                        "QuestionIds", []
                                    ),
                                }
                                if next_node_ids:
                                    node_item["next"] = next_node_ids
                                ordered_nodes.append(node_item)
                            # 检查是否是推理答案节点
                            elif node_type == "UnlockDetectiveAnswerNode":
                                node_item = {
                                    "node_key": current_node,
                                    "type": node_type,
                                    "name": node_map[current_node].get("name", ""),
                                    "props_data": sub_props_data,
                                    "answer_ids": sub_props_data.get("AnswerIds", []),
                                }
                                if next_node_ids:
                                    node_item["next"] = next_node_ids
                                ordered_nodes.append(node_item)

                        # 多分支全部入队，避免重复入队
                        for next_node in next_node_ids:
                            if (
                                next_node not in visited
                                and next_node not in next_nodes_seen
                            ):
                                next_nodes.append(next_node)
                                next_nodes_seen.add(next_node)

                    current_nodes = next_nodes

                if ordered_nodes:
                    self.quest_next_map = quest_next_map
                    return ordered_nodes

        return nodes

    def _resolve_next_output_nodes(self, next_ids, output_node_ids):
        """将 next 解析到最终输出节点，允许跨越被过滤节点。"""
        if not next_ids:
            return []

        next_map = getattr(self, "quest_next_map", {})
        queue = [str(next_id) for next_id in next_ids]
        visited = set()
        resolved = []
        resolved_seen = set()

        while queue:
            current = queue.pop(0)
            if current in visited:
                continue
            visited.add(current)

            if current in output_node_ids:
                if current not in resolved_seen:
                    resolved.append(current)
                    resolved_seen.add(current)
                continue

            for child in next_map.get(current, []):
                child_id = str(child)
                if child_id not in visited:
                    queue.append(child_id)

        return resolved

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

        # 加载推理相关数据
        detective_answer_data = self.data_loader.load_json("DetectiveAnswer.json")
        detective_question_data = self.data_loader.load_json("DetectiveQuestion.json")

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

            # 查找该任务的所有节点（按顺序）
            nodes = self.process_quest_nodes_order(story_data, quest_id)

            # 如果没有按顺序的节点，使用原来的方法
            if not nodes:
                nodes = self.find_talk_nodes_for_quest(story_data, quest_id)

            if not nodes:
                continue

            quest_name = ""
            quest_desc = ""
            for story_node in story_data.get("storyNodeData", {}).values():
                props_data = story_node.get("propsData", {})
                if props_data.get("QuestId") == quest_id:
                    quest_name = self.data_loader.translate(
                        props_data.get("QuestDescription", "")
                    )
                    quest_desc = self.data_loader.translate(
                        props_data.get("QuestDeatil", "")
                    )
                    break

            # 处理每个节点
            processed_nodes = []
            for node in nodes:
                node_info = {
                    "id": node["node_key"],
                    "type": node["type"],
                    "name": node.get("name", ""),
                }

                if "next" in node:
                    node_info["next"] = node["next"]

                # 如果是对话节点，获取对话链
                if node["type"] == "TalkNode" and "first_dialogue_id" in node:
                    first_dialogue_id = node["first_dialogue_id"]
                    dialogue_chain = self.get_dialogue_chain(
                        first_dialogue_id, language
                    )
                    if dialogue_chain:
                        node_info["dialogues"] = dialogue_chain

                # 处理推理问题节点
                if node["type"] == "UnlockDetectiveQuestionNode":
                    question_ids = node.get("question_ids", [])
                    if question_ids and detective_question_data:
                        questions = []
                        for qid in question_ids:
                            qid_str = str(qid)
                            if qid_str in detective_question_data:
                                q_data = detective_question_data[qid_str]
                                # 处理问题数据
                                question_item = {
                                    "id": q_data.get("QuestionID"),
                                    "name": self.data_loader.translate(
                                        q_data.get("QuestName", "")
                                    ),
                                    "answers": q_data.get("ProbablyNeededAnswers", []),
                                    "tips": self.data_loader.translate(
                                        q_data.get("Tips", "")
                                    ),
                                }
                                questions.append(question_item)
                        if questions:
                            node_info["questions"] = questions

                # 处理推理答案节点
                if node["type"] == "UnlockDetectiveAnswerNode":
                    answer_ids = node.get("answer_ids", [])
                    if answer_ids and detective_answer_data:
                        answers = []
                        for aid in answer_ids:
                            aid_str = str(aid)
                            if aid_str in detective_answer_data:
                                a_data = detective_answer_data[aid_str]
                                # 处理答案数据
                                answer_item = {
                                    "id": a_data.get("AnswerID"),
                                    "qid": a_data.get("QuestionID"),
                                    "name": self.data_loader.translate(
                                        a_data.get("Name", "")
                                    ),
                                    "desc": self.data_loader.translate(
                                        a_data.get("Detail", "")
                                    ),
                                }
                                # 处理icon
                                if "Icon" in a_data:
                                    icon = a_data["Icon"]
                                    # 截断icon路径，获取最后一部分
                                    icon_parts = icon.split("_")
                                    if icon_parts:
                                        answer_item["icon"] = icon_parts[-1].replace(
                                            ".", ""
                                        )
                                answers.append(answer_item)
                        if answers:
                            node_info["answers"] = answers

                processed_nodes.append(node_info)

            # next 只保留最终输出中存在的节点 id，并支持跨越非输出节点
            output_node_ids = {str(node.get("id")) for node in processed_nodes}
            for node_info in processed_nodes:
                next_ids = node_info.get("next")
                if not next_ids:
                    continue

                filtered_next = self._resolve_next_output_nodes(
                    next_ids, output_node_ids
                )

                if filtered_next:
                    node_info["next"] = filtered_next
                else:
                    node_info.pop("next", None)

            if processed_nodes:
                s = {
                    "id": quest_id,
                    "name": quest_name,
                    "desc": quest_desc,
                    "nodes": processed_nodes,
                }
                if s["desc"] == s["name"]:
                    del s["desc"]
                quest_stories.append(s)

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
