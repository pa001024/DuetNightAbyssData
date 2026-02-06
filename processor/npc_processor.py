import os
import json
from collections import OrderedDict
from processor.base_processor import BaseProcessor


class NpcProcessor(BaseProcessor):
    """NPC数据处理器"""

    def __init__(self, data_loader):
        """初始化NPC处理器

        Args:
            data_loader: 数据加载器实例
        """
        super().__init__(data_loader)
        self.file_type = "Npc"
        self.story_files_base_path = os.path.join("out", "StoryCreator", "StoryFiles")
        # 加载必要的数据文件
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.camp_data = data_loader.load_json("CharCamp.json")
        self.talk_trigger_data = data_loader.load_json("TalkTrigger.json")

    def process_item(self, npc_data, language):
        """处理单个NPC数据

        Args:
            npc_data: NPC原始数据
            language: 语言代码

        Returns:
            dict: 处理后的NPC数据
        """
        unit_id = npc_data.get("UnitId", 0)
        if not unit_id:
            return {}

        # 构建处理后的NPC数据
        processed = {
            "id": unit_id,
            "name": self.get_translated_text(npc_data.get("UnitName", "")),
            "camp": self._process_camp(npc_data.get("Camp", "")),
            "charId": npc_data.get("CharId", 0),
            # "模型ID": npc_data.get("ModelId", 0),
            # "碰撞等级": npc_data.get("CollisionLevel", 0),
            # "单位蓝图路径": npc_data.get("UnitBPPath", ""),
            "type": npc_data.get("NpcType", ""),
        }

        # 处理可选字段
        # if "MouthProfile" in npc_data:
        #     processed["口型配置"] = npc_data.get("MouthProfile")

        # if "PlayerInfo" in npc_data:
        #     processed["玩家信息"] = npc_data.get("PlayerInfo")

        if "MailHead" in npc_data:
            processed["icon"] = (
                npc_data.get("MailHead")
                .split(".")[-1]
                .replace("T_Head_", "")
                .replace("'", "")
            )

        # if "MailSender" in npc_data:
        #     processed["邮件发送者"] = npc_data.get("MailSender")

        if "RelatedTalks" in npc_data:
            talks = npc_data.get("RelatedTalks")
            dialogue_chains = []
            for talk in talks:
                chain = self._process_talk_trigger(talk, language)
                if chain:
                    dialogue_chains.extend(chain)
            if dialogue_chains:
                processed["talks"] = dialogue_chains

        # if "ShowAnimationId" in npc_data:
        #     processed["展示动画ID"] = npc_data.get("ShowAnimationId")

        # if "SpecialSit" in npc_data:
        #     processed["特殊坐姿"] = npc_data.get("SpecialSit")

        # if "Gender" in npc_data:
        #     processed["性别"] = npc_data.get("Gender")

        # if "BT" in npc_data:
        #     processed["行为树"] = npc_data.get("BT")

        # if "GuideHeadId" in npc_data:
        #     processed["引导头像ID"] = npc_data.get("GuideHeadId")

        # if "IsEmptyNpc" in npc_data:
        #     processed["是否空NPC"] = npc_data.get("IsEmptyNpc")

        # if "RelateNpcId" in npc_data:
        #     processed["关联NPC ID"] = npc_data.get("RelateNpcId")

        # if "SwitchPlayer" in npc_data:
        #     processed["切换玩家"] = npc_data.get("SwitchPlayer")

        # if "DefaultAction" in npc_data:
        #     processed["默认动作"] = npc_data.get("DefaultAction")

        # if "GlobalGameUITagList" in npc_data:
        #     processed["全局游戏UI标签"] = npc_data.get("GlobalGameUITagList")

        # if "GuideCanMove" in npc_data:
        #     processed["引导可移动"] = npc_data.get("GuideCanMove")

        # if "IsRepeatable" in npc_data:
        #     processed["是否可重复"] = npc_data.get("IsRepeatable")

        # if "DefaultExpression" in npc_data:
        #     processed["默认表情"] = npc_data.get("DefaultExpression")

        # 移除值为空的字段
        return {k: v for k, v in processed.items() if v}

    def _process_talk_trigger(self, trigger, language=""):
        """处理对话触发数据

        Args:
            trigger: 对话触发代码
            language: 语言代码

        Returns:
            list: 对话链列表
        """
        if not trigger:
            return []

        # 获取对话触发数据
        trdata = self.talk_trigger_data.get(str(trigger), {})
        if not trdata:
            print(f"未找到对话触发ID: {trigger}")
            return []

        # 获取故事文件路径
        story_path = trdata.get("StoryLinePath", "")
        if not story_path:
            # print(f"对话触发ID {trigger} 没有故事路径")
            return []

        # 加载故事文件
        story_data = self.load_story_file(story_path)
        if not story_data:
            print(f"无法加载故事文件: {story_path}", flush=True)
            return []

        # 查找对话节点
        talk_nodes = self._find_talk_nodes_in_story(story_data)
        if not talk_nodes:
            print(f"故事文件 {story_path} 中未找到对话节点")
            return []

        # 构建对话链
        dialogue_chain = []
        for talk_node in talk_nodes:
            first_dialogue_id = talk_node.get("first_dialogue_id")
            if first_dialogue_id:
                chain = self.get_dialogue_chain(first_dialogue_id, language)
                if chain:
                    dialogue_chain.extend(chain)

        return dialogue_chain

    def _find_talk_nodes_in_story(self, story_data):
        """在故事数据中查找所有对话节点

        Args:
            story_data: 故事数据

        Returns:
            list: 对话节点列表
        """
        talk_nodes = []
        if not story_data or "storyNodeData" not in story_data:
            return talk_nodes

        story_node_data = story_data["storyNodeData"]

        # 遍历所有故事节点
        for node_key, node_data in story_node_data.items():
            # 检查该节点是否是对话节点
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

            # 检查 questNodeData 中的对话节点
            quest_node_data = node_data.get("questNodeData", {})
            if quest_node_data:
                node_data_dict = quest_node_data.get("nodeData", {})
                for sub_node_key, sub_node in node_data_dict.items():
                    if sub_node.get("type") == "TalkNode":
                        sub_props_data = sub_node.get("propsData", {})
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

        return talk_nodes

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
            if not json_path.endswith(".json"):
                json_path += ".json"
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

    def _process_camp(self, camp):
        """处理阵营数据

        Args:
            camp: 阵营代码

        Returns:
            str: 阵营名称
        """
        if not camp:
            return ""
        camp_name = self.camp_data.get(camp, {}).get("CampName", "")
        return self.get_translated_text(camp_name) or camp
