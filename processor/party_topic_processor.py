from processor.quest_story_processor import QuestStoryProcessor
from processor.base_processor import BaseProcessor


class PartyTopicProcessor(QuestStoryProcessor):
    """派对话题处理器，补充剧情文本解析。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "PartyTopic"
        self.party_topic_char_map = self._build_party_topic_char_map()

    def _build_party_topic_char_map(self):
        """从 PartyNpc.json 构建 PartyTopicId 到 CharId 的映射。"""
        mapping = {}
        party_npc_data = self.data_loader.load_json("PartyNpc.json")
        if not isinstance(party_npc_data, dict):
            return mapping

        for npc_data in party_npc_data.values():
            if not isinstance(npc_data, dict):
                continue

            char_id = npc_data.get("CharId")
            topic_list = npc_data.get("PartyTopicList", [])
            if not char_id or not isinstance(topic_list, list):
                continue

            for topic_id in topic_list:
                try:
                    mapping[int(topic_id)] = int(char_id)
                except (TypeError, ValueError):
                    continue

        return mapping

    def load_items(self, file_path):
        """按常规文件读取 PartyTopic.json。"""
        return BaseProcessor.load_items(self, file_path)

    def process_all_items(self, items, language=""):
        """按基础处理流程遍历条目。"""
        self.data_loader.set_language(language)
        return BaseProcessor.process_all_items(self, items, language)

    def process_item(self, item_data, language):
        """处理单个派对话题数据。"""
        topic_id = item_data.get("PartyTopicId", 0)
        if not topic_id:
            return None
        talk_id = item_data.get("PartyTopicTalkId", "")
        processed = {
            "id": topic_id,
            "charId": self.party_topic_char_map.get(topic_id, 0),
            "name": self.get_translated_text(
                item_data.get("PartyTopicName", ""), language
            ),
            "desc": self.get_translated_text(
                item_data.get("PartyTopicDescription", ""), language
            ),
            "memoryName": self.get_translated_text(
                item_data.get("MemoryName", ""), language
            ),
            "memoryDesc": self.get_translated_text(
                item_data.get("MemoryDescription", ""), language
            ),
            "reward": item_data.get("PartyTopicReward", 0),
            "consume": item_data.get("PartyTopicConsume", {}),
            # "talkId": item_data.get("PartyTopicTalkId", ""),
        }

        condition_id = item_data.get("ConditionId", 0)
        if condition_id:
            processed["conditionId"] = condition_id

        dialogues = self._get_story_dialogues(talk_id, language)
        if dialogues:
            processed["dialogues"] = dialogues

        if not processed.get("desc"):
            processed.pop("desc", None)
        if not processed.get("memoryName"):
            processed.pop("memoryName", None)
        if not processed.get("memoryDesc"):
            processed.pop("memoryDesc", None)
        if not processed.get("reward"):
            processed.pop("reward", None)
        if not processed.get("consume"):
            processed.pop("consume", None)
        if not processed.get("charId"):
            processed.pop("charId", None)
        # if not processed.get("talkId"):
        #     processed.pop("talkId", None)

        return processed

    def _get_story_dialogues(self, story_path, language=""):
        """从 .story 资源中提取对话链。"""
        if not story_path:
            return []

        story_data = self.load_story_file(story_path)
        if not story_data:
            return []

        talk_nodes = self._collect_talk_nodes(story_data)
        if not talk_nodes:
            return []

        dialogue_chain = []
        emitted_ids = set()
        emitted_option_ids = set()
        dialogue_index = {}

        for talk_node in talk_nodes:
            first_dialogue_id = talk_node.get("first_dialogue_id", 0)
            flow_asset_path = talk_node.get("flow_asset_path", "")

            chain = []
            if first_dialogue_id:
                chain = self.get_dialogue_chain(first_dialogue_id, language)

            if not chain and flow_asset_path:
                chain = self.get_dialogue_chain_from_flow_asset(
                    flow_asset_path, language
                )

            for item in chain:
                item_id = str(item.get("id"))
                if item_id in emitted_ids or item_id in emitted_option_ids:
                    existing_item = dialogue_index.get(item_id)
                    if (
                        isinstance(existing_item, dict)
                        and existing_item.get("voice") is None
                        and item.get("voice") is not None
                    ):
                        existing_item["voice"] = item.get("voice")
                    continue

                dialogue_chain.append(item)
                emitted_ids.add(item_id)
                dialogue_index[item_id] = item

                for option in item.get("options", []):
                    option_id = option.get("id")
                    if option_id is not None:
                        emitted_option_ids.add(str(option_id))

        return dialogue_chain

    def _collect_talk_nodes(self, story_data):
        """收集剧情中的 TalkNode 信息。"""
        story_node_data = story_data.get("storyNodeData", {})
        if not isinstance(story_node_data, dict):
            return []

        talk_nodes = []
        seen = set()

        def append_talk_node(node_data):
            if not isinstance(node_data, dict):
                return
            if node_data.get("type") != "TalkNode":
                return

            props_data = node_data.get("propsData", {})
            first_dialogue_id = props_data.get("FirstDialogueId", 0)
            flow_asset_path = props_data.get("FlowAssetPath", "")

            if not first_dialogue_id and not flow_asset_path:
                return

            node_key = str(node_data.get("key") or node_data.get("name") or "")
            uniq_key = (node_key, str(first_dialogue_id), flow_asset_path)
            if uniq_key in seen:
                return
            seen.add(uniq_key)

            talk_nodes.append(
                {
                    "first_dialogue_id": first_dialogue_id,
                    "flow_asset_path": flow_asset_path,
                }
            )

        for node_data in story_node_data.values():
            append_talk_node(node_data)

            quest_node_data = node_data.get("questNodeData", {})
            node_data_dict = quest_node_data.get("nodeData", {})
            if isinstance(node_data_dict, dict):
                for sub_node in node_data_dict.values():
                    append_talk_node(sub_node)

        return talk_nodes
