import os
import json
from collections import OrderedDict
from processor.base_processor import BaseProcessor


class NpcProcessor(BaseProcessor):
    """NPC数据处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Npc"
        self.story_files_base_path = os.path.join("out", "StoryCreator", "StoryFiles")
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.camp_data = data_loader.load_json("CharCamp.json")
        self.talk_trigger_data = data_loader.load_json("TalkTrigger.json")
        self.story_file_cache = {}

    def process_item(self, npc_data, language):
        """处理单个NPC数据。"""
        unit_id = npc_data.get("UnitId", 0)
        if not unit_id:
            return {}

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

        if "MailHead" in npc_data:
            processed["icon"] = (
                npc_data.get("MailHead")
                .split(".")[-1]
                .replace("T_Head_", "")
                .replace("'", "")
            )

        if not processed["charId"]:
            del processed["charId"]

        sr_id, pos = self._resolve_npc_context(npc_data)
        if sr_id:
            processed["srId"] = sr_id
        if sr_id and pos is not None:
            processed["pos"] = pos

        if "RelatedTalks" in npc_data:
            talks = npc_data.get("RelatedTalks")
            dialogue_chains = []
            seen_dialogue_ids = set()
            dialogue_index = {}
            for talk in talks:
                chain = self._process_talk_trigger(talk, language)
                if chain:
                    for dialogue in chain:
                        dialogue_id = dialogue.get("id")
                        if dialogue_id not in seen_dialogue_ids:
                            seen_dialogue_ids.add(dialogue_id)
                            dialogue_chains.append(dialogue)
                            dialogue_index[dialogue_id] = dialogue
                        else:
                            existing_dialogue = dialogue_index.get(dialogue_id)
                            if not isinstance(existing_dialogue, dict):
                                continue
                            if (
                                existing_dialogue.get("voice") is None
                                and dialogue.get("voice") is not None
                            ):
                                existing_dialogue["voice"] = dialogue.get("voice")
            if dialogue_chains:
                processed["talks"] = dialogue_chains

        return {k: v for k, v in processed.items() if v is not None and v != ""}

    @staticmethod
    def _to_int(value):
        """尽量把值收敛为整数。"""
        try:
            return int(value)
        except Exception:
            return None

    @staticmethod
    def _format_num(value):
        return int(round(float(value)))

    def _format_vec2(self, vec):
        """将二维坐标取整并保留为数组。"""
        if not isinstance(vec, list) or len(vec) < 2:
            return None
        try:
            return [self._format_num(vec[0]), self._format_num(vec[1])]
        except Exception:
            return None

    def _load_story_data_cached(self, story_path):
        """加载并缓存故事文件。"""
        cache_key = str(story_path)
        if cache_key in self.story_file_cache:
            return self.story_file_cache[cache_key]

        story_data = self.load_story_file(story_path)
        self.story_file_cache[cache_key] = story_data
        return story_data

    def _resolve_npc_sr_id(self, npc_data):
        """从关联对话故事中提取 NPC 子区域 ID。"""
        sr_id, _ = self._resolve_npc_context(npc_data)
        return sr_id

    def _resolve_npc_pos(self, npc_data):
        """从关联对话故事中提取 NPC 的编辑器坐标。"""
        _, pos = self._resolve_npc_context(npc_data)
        return pos

    def _resolve_npc_context(self, npc_data):
        """从真实导引点中提取 NPC 的子区域与坐标。"""
        unit_id = self._to_int(npc_data.get("UnitId"))
        if unit_id is None:
            return 0, None

        story_candidates = []
        for talk_key in ("RelatedTalks", "RelatedBubble"):
            talks = npc_data.get(talk_key)
            if not isinstance(talks, list):
                continue
            for talk in talks:
                trdata = self.talk_trigger_data.get(str(talk), {})
                story_path = trdata.get("StoryLinePath", "")
                if story_path:
                    story_candidates.append(story_path)

        seen_candidates = set()
        for story_path in story_candidates:
            if story_path in seen_candidates:
                continue
            seen_candidates.add(story_path)

            story_data = self._load_story_data_cached(story_path)
            if not story_data:
                continue

            sr_id, pos = self._find_story_npc_context(story_data, npc_data, unit_id)
            if sr_id and pos is not None:
                return sr_id, pos

        return 0, None

    def _find_story_npc_context(self, story_data, npc_data, unit_id):
        """从故事节点中提取与指定 NPC 相关的 srId 与真实 pos。"""
        unit_token = self._extract_path_token(npc_data.get("UnitBPPath") or npc_data.get("UnitName"))
        guide_point_name = self._find_guide_point_name_by_token(unit_token)
        if not guide_point_name:
            guide_point_name = self._find_guide_point_name_by_token(
                self._extract_path_token(npc_data.get("UnitName"))
            )
        if guide_point_name:
            sr_id, pos = self._resolve_guide_point_pos(guide_point_name)
            if sr_id and pos is not None:
                return sr_id, pos

        return 0, None

    def _process_talk_trigger(self, trigger, language=""):
        """处理对话触发数据。"""
        if not trigger:
            return []

        trdata = self.talk_trigger_data.get(str(trigger), {})
        if not trdata:
            print(f"未找到对话触发ID: {trigger}")
            return []

        story_path = trdata.get("StoryLinePath", "")
        if not story_path:
            return []

        story_data = self.load_story_file(story_path)
        if not story_data:
            print(f"无法加载故事文件: {story_path}", flush=True)
            return []

        talk_nodes = self._find_talk_nodes_in_story(story_data)
        if not talk_nodes:
            print(f"故事文件 {story_path} 中未找到对话节点")
            return []

        dialogue_chain = []
        for talk_node in talk_nodes:
            first_dialogue_id = talk_node.get("first_dialogue_id")
            if first_dialogue_id:
                chain = self.get_dialogue_chain(first_dialogue_id, language)
                if chain:
                    dialogue_chain.extend(chain)

        return dialogue_chain

    def _find_talk_nodes_in_story(self, story_data):
        """在故事数据中查找所有对话节点。"""
        talk_nodes = []
        if not story_data or "storyNodeData" not in story_data:
            return talk_nodes

        story_node_data = story_data["storyNodeData"]
        for node_key, node_data in story_node_data.items():
            if node_data.get("type") == "TalkNode":
                node_props_data = node_data.get("propsData", {})
                if "FirstDialogueId" in node_props_data:
                    talk_nodes.append(
                        {
                            "node_key": node_key,
                            "first_dialogue_id": node_props_data.get("FirstDialogueId"),
                            "props_data": node_props_data,
                        }
                    )

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
        """加载故事文件。"""
        try:
            json_path = story_path.replace(".story", ".json")
            json_path = json_path.replace("\\", os.sep).replace("/", os.sep)
            if not json_path.endswith(".json"):
                json_path += ".json"
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
        """处理阵营数据。"""
        if not camp:
            return ""
        camp_name = self.camp_data.get(camp, {}).get("CampName", "")
        return self.get_translated_text(camp_name) or camp
