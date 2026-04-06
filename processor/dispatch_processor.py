import json
import os
import re
from collections import OrderedDict

from processor.base_processor import BaseProcessor


class DispatchProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Dispatch"
        self.dispatch_ui_data = data_loader.load_json("DispatchUI.json")
        self.dyn_quest_data = data_loader.load_json("DynQuest.json")
        self.story_dialogue_cache = {}

    def load_items(self, file_path):
        """按常规文件读取 Dispatch.json。"""
        return BaseProcessor.load_items(self, file_path)

    def process_all_items(self, items, language=""):
        """按 condition 聚合派遣任务。"""
        self.data_loader.set_language(language)
        grouped_items = {}
        group_order = []

        for item in items:
            processed = self.process_item(item, language)
            if not processed:
                continue

            condition = processed.get("condition")
            if condition not in grouped_items:
                group_item = dict(processed)
                group_item["id"] = condition
                group_item.pop("condition", None)
                group_item.pop("level", None)
                group_item.pop("reward", None)
                group_item.pop("demand", None)
                grouped_items[condition] = group_item
                grouped_items[condition]["levels"] = []
                group_order.append(condition)

            level_item = {
                "id": processed.get("id"),
                "reward": processed.get("reward", []),
                "demand": processed.get("demand"),
                "level": processed.get("level", []),
            }
            grouped_items[condition]["levels"].append(level_item)

            if "nodes" in processed and "nodes" not in grouped_items[condition]:
                grouped_items[condition]["nodes"] = processed["nodes"]
            if "startIds" in processed and "startIds" not in grouped_items[condition]:
                grouped_items[condition]["startIds"] = processed["startIds"]

        return [grouped_items[condition] for condition in group_order]

    def process_item(self, dispatch_data, language):
        """处理单个派遣任务数据。"""
        if not isinstance(dispatch_data, dict):
            return None

        dispatch_id = dispatch_data.get("DispatchId")
        if not dispatch_id:
            return None

        dispatch_key = str(dispatch_id)
        dyn_data = self.dyn_quest_data.get(dispatch_key, {})
        if not isinstance(dyn_data, dict):
            dyn_data = {}

        ui_data = self.dispatch_ui_data.get(dispatch_key, {})
        if not isinstance(ui_data, dict):
            ui_data = {}

        processed_quest = {
            "id": dispatch_id,
            "name": self._get_dispatch_name(ui_data, dyn_data, language),
            "desc": self._get_dispatch_desc(ui_data, language),
            "level": dispatch_data.get("PlayerLevel", []),
            "regionId": dispatch_data.get("RegionId"),
            "subRegionId": ui_data.get("DispatchSubRegionId"),
            "cd": dispatch_data.get("DispatchCD"),
            "condition": dispatch_data.get("DispatchCondition"),
            "demand": dispatch_data.get("DispatchDemand"),
            "person": dispatch_data.get("DispatchPerson"),
            "type": dispatch_data.get("DispatchType"),
            "rarity": dispatch_data.get("Rarity"),
            "ttk": dispatch_data.get("Ttk"),
            "weight": dispatch_data.get("Weight"),
            "pos": ui_data.get("UIPos"),
            "reward": dispatch_data.get("RewardId", []),
        }

        story_path = dyn_data.get("StoryPath", "")
        nodes = self._get_story_nodes(story_path, language)
        dialogues = self._flatten_node_dialogues(nodes)
        self._apply_story_graph_next(dialogues, story_path, language)
        self._apply_dyn_impression(dialogues, dyn_data.get("DynImpression", {}))
        if nodes:
            processed_quest["nodes"] = nodes
            incoming_map = self._build_dyn_node_incoming_map(story_path, nodes)
            start_ids = self._collect_node_start_ids(nodes, incoming_map or None)
            if len(start_ids) > 1:
                processed_quest["startIds"] = start_ids

        return processed_quest

    def _get_dispatch_name(self, ui_data, dyn_data, language):
        name_key = ui_data.get("DispatchName") or dyn_data.get("DynName") or ""
        if not name_key:
            return ""
        return self.get_translated_text(name_key, language)

    def _get_dispatch_desc(self, ui_data, language):
        desc_key = ui_data.get("DispatchDes") or ""
        if not desc_key:
            return ""
        return self.get_translated_text(desc_key, language)

    def _flatten_node_dialogues(self, nodes):
        flat_dialogues = []
        for node in nodes:
            if not isinstance(node, dict):
                continue
            for dialogue_item in node.get("dialogues", []):
                if isinstance(dialogue_item, dict):
                    flat_dialogues.append(dialogue_item)
        return flat_dialogues

    def _get_story_nodes(self, story_path, language=""):
        if not story_path:
            return []

        story_data = self.load_story_file(story_path)
        if not isinstance(story_data, dict):
            return []

        result_nodes = []
        story_node_data = story_data.get("storyNodeData", {})
        if not isinstance(story_node_data, dict):
            return result_nodes

        seen_node_ids = set()

        def resolve_talk_targets(start_node_ids, node_data_dict, adjacency):
            queue = list(start_node_ids)
            visited = set()
            targets = []
            target_seen = set()

            while queue:
                node_id = queue.pop(0)
                if node_id in visited:
                    continue
                visited.add(node_id)

                node_data = node_data_dict.get(node_id, {})
                if not isinstance(node_data, dict):
                    continue

                if node_data.get("type") == "TalkNode":
                    props_data = node_data.get("propsData", {})
                    if props_data.get("FirstDialogueId") or props_data.get(
                        "FlowAssetPath"
                    ):
                        if node_id not in target_seen:
                            target_seen.add(node_id)
                            targets.append(node_id)
                    continue

                for next_node_id in adjacency.get(node_id, []):
                    if next_node_id not in visited:
                        queue.append(next_node_id)

            return targets

        for story_node in story_node_data.values():
            if not isinstance(story_node, dict):
                continue

            quest_node_data = story_node.get("questNodeData", {})
            node_data_dict = quest_node_data.get("nodeData", {})
            line_data = quest_node_data.get("lineData", [])
            if not isinstance(node_data_dict, dict) or not isinstance(line_data, list):
                continue

            ordered_node_ids = self._collect_ordered_quest_node_ids(quest_node_data)
            if not ordered_node_ids:
                ordered_node_ids = list(node_data_dict.keys())

            edge_map = {}
            adjacency = {}
            incoming_map = {}
            for edge in line_data:
                if not isinstance(edge, dict):
                    continue

                start_quest = edge.get("startQuest")
                end_quest = edge.get("endQuest")
                if start_quest is None or end_quest is None:
                    continue

                start_key = str(start_quest)
                end_key = str(end_quest)
                start_port = edge.get("startPort", "")

                edge_map.setdefault((start_key, start_port), [])
                if end_key not in edge_map[(start_key, start_port)]:
                    edge_map[(start_key, start_port)].append(end_key)

                adjacency.setdefault(start_key, [])
                if end_key not in adjacency[start_key]:
                    adjacency[start_key].append(end_key)

                incoming_map.setdefault(end_key, [])
                incoming_map[end_key].append((start_key, start_port))

            for node_id in ordered_node_ids:
                node_key = str(node_id)
                if node_key in seen_node_ids:
                    continue

                node_data = node_data_dict.get(node_key, {})
                if not isinstance(node_data, dict):
                    continue
                if node_data.get("type") != "TalkNode":
                    continue

                props_data = node_data.get("propsData", {})
                first_dialogue_id = props_data.get("FirstDialogueId", 0)
                flow_asset_path = props_data.get("FlowAssetPath", "")
                if not first_dialogue_id and not flow_asset_path:
                    continue

                node_item = {
                    "id": node_key,
                    "type": "TalkNode",
                    "name": node_data.get("name", ""),
                }

                candidate_nodes = adjacency.get(node_key, [])
                node_next = resolve_talk_targets(
                    candidate_nodes, node_data_dict, adjacency
                )

                if not node_next and props_data.get("TalkType") == "UnimportGuide":
                    guide_targets = []
                    for parent_node_id, parent_port in incoming_map.get(node_key, []):
                        sibling_nodes = edge_map.get((parent_node_id, parent_port), [])
                        sibling_nodes = [
                            sibling for sibling in sibling_nodes if sibling != node_key
                        ]
                        for target in resolve_talk_targets(
                            sibling_nodes, node_data_dict, adjacency
                        ):
                            if target not in guide_targets:
                                guide_targets.append(target)
                    node_next = guide_targets

                if node_next:
                    node_item["next"] = node_next

                dialogues = []
                if first_dialogue_id:
                    dialogues = self.get_dialogue_chain(first_dialogue_id, language)
                if not dialogues and flow_asset_path:
                    dialogues = self._get_dialogue_chain_from_flow_asset(
                        flow_asset_path, language
                    )
                if dialogues:
                    node_item["dialogues"] = dialogues

                result_nodes.append(node_item)
                seen_node_ids.add(node_key)

        return result_nodes

    def _collect_node_start_ids(self, nodes, incoming_map=None):
        if not nodes:
            return []

        node_ids = []
        node_seen = set()
        incoming_ids = set()

        for node_item in nodes:
            if not isinstance(node_item, dict):
                continue
            node_id = node_item.get("id")
            if node_id is None:
                continue
            node_key = str(node_id)
            if node_key in node_seen:
                continue
            node_seen.add(node_key)
            node_ids.append(node_id)

        if incoming_map:
            for incoming_id in incoming_map:
                incoming_ids.add(str(incoming_id))

        start_ids = [
            node_id for node_id in node_ids if str(node_id) not in incoming_ids
        ]
        if not start_ids and node_ids:
            return [node_ids[0]]
        return start_ids

    def _apply_story_graph_next(self, dialogues, story_path, language=""):
        if not dialogues or not story_path:
            return

        story_data = self.load_story_file(story_path)
        if not story_data:
            return

        dialogue_map = {}
        option_map = {}
        for dialogue_item in dialogues:
            if not isinstance(dialogue_item, dict):
                continue

            dialogue_id = dialogue_item.get("id")
            if dialogue_id is not None:
                dialogue_map[str(dialogue_id)] = dialogue_item

            for option_item in dialogue_item.get("options", []):
                if not isinstance(option_item, dict):
                    continue
                option_id = option_item.get("id")
                if option_id is not None:
                    option_map[str(option_id)] = option_item

        terminal_cache = {}
        option_order_cache = {}
        story_node_data = story_data.get("storyNodeData", {})
        if not isinstance(story_node_data, dict):
            return

        def collect_terminals(start_dialogue_id):
            key = str(start_dialogue_id)
            if key in terminal_cache:
                return terminal_cache[key]

            queue = [key]
            visited = set()
            terminals = []
            terminal_seen = set()

            while queue:
                current_id = queue.pop(0)
                if current_id in visited:
                    continue
                visited.add(current_id)

                dialogue_data = self.get_dialogue_data(current_id, language)
                if not dialogue_data:
                    if current_id not in terminal_seen:
                        terminal_seen.add(current_id)
                        terminals.append(current_id)
                    continue

                next_options = dialogue_data.get("NextOptions") or []
                if next_options:
                    for option_id in next_options:
                        option_key = str(option_id)
                        if option_key not in visited:
                            queue.append(option_key)
                    continue

                next_dialogue_id = dialogue_data.get("NextDialogue")
                if next_dialogue_id:
                    next_key = str(next_dialogue_id)
                    if next_key not in visited:
                        queue.append(next_key)
                else:
                    if current_id not in terminal_seen:
                        terminal_seen.add(current_id)
                        terminals.append(current_id)

            terminal_cache[key] = terminals
            return terminals

        def collect_ordered_option_ids(start_dialogue_id):
            key = str(start_dialogue_id)
            if key in option_order_cache:
                return option_order_cache[key]

            queue = [key]
            visited = set()
            option_ids = []
            option_seen = set()

            while queue:
                current_id = queue.pop(0)
                if current_id in visited:
                    continue
                visited.add(current_id)

                dialogue_data = self.get_dialogue_data(current_id, language)
                if not dialogue_data:
                    continue

                next_options = dialogue_data.get("NextOptions") or []
                if next_options:
                    for option_id in next_options:
                        option_key = str(option_id)
                        if option_key not in option_seen:
                            option_seen.add(option_key)
                            option_ids.append(option_key)
                        if option_key not in visited:
                            queue.append(option_key)
                    continue

                next_dialogue_id = dialogue_data.get("NextDialogue")
                if next_dialogue_id:
                    next_key = str(next_dialogue_id)
                    if next_key not in visited:
                        queue.append(next_key)

            option_order_cache[key] = option_ids
            return option_ids

        def resolve_talk_targets(start_node_ids, node_data_dict, adjacency):
            queue = list(start_node_ids)
            visited = set()
            targets = []
            target_seen = set()

            while queue:
                node_id = queue.pop(0)
                if node_id in visited:
                    continue
                visited.add(node_id)

                node_data = node_data_dict.get(node_id, {})
                if not isinstance(node_data, dict):
                    continue

                if node_data.get("type") == "TalkNode":
                    first_dialogue_id = node_data.get("propsData", {}).get(
                        "FirstDialogueId", 0
                    )
                    if first_dialogue_id:
                        target_id = str(first_dialogue_id)
                        if target_id not in target_seen:
                            target_seen.add(target_id)
                            targets.append(target_id)
                    continue

                for next_node_id in adjacency.get(node_id, []):
                    if next_node_id not in visited:
                        queue.append(next_node_id)

            return targets

        def merge_next(item, targets):
            if not isinstance(item, dict) or not targets:
                return
            if item.get("next") is not None:
                return

            for target in targets:
                try:
                    item["next"] = int(target)
                    return
                except (TypeError, ValueError):
                    continue

        for story_node in story_node_data.values():
            if not isinstance(story_node, dict):
                continue

            quest_node_data = story_node.get("questNodeData", {})
            if not isinstance(quest_node_data, dict):
                continue

            node_data_dict = quest_node_data.get("nodeData", {})
            line_data = quest_node_data.get("lineData", [])
            if not isinstance(node_data_dict, dict) or not isinstance(line_data, list):
                continue

            edge_map = {}
            adjacency = {}
            incoming_map = {}
            for edge in line_data:
                if not isinstance(edge, dict):
                    continue
                start_quest = edge.get("startQuest")
                end_quest = edge.get("endQuest")
                if start_quest is None or end_quest is None:
                    continue

                start_key = str(start_quest)
                end_key = str(end_quest)
                start_port = edge.get("startPort", "")

                edge_map.setdefault((start_key, start_port), [])
                if end_key not in edge_map[(start_key, start_port)]:
                    edge_map[(start_key, start_port)].append(end_key)

                adjacency.setdefault(start_key, [])
                if end_key not in adjacency[start_key]:
                    adjacency[start_key].append(end_key)

                incoming_map.setdefault(end_key, [])
                incoming_map[end_key].append((start_key, start_port))

            for node_id, node_data in node_data_dict.items():
                if (
                    not isinstance(node_data, dict)
                    or node_data.get("type") != "TalkNode"
                ):
                    continue

                source_node_id = str(node_id)
                first_dialogue_id = node_data.get("propsData", {}).get(
                    "FirstDialogueId", 0
                )
                if not first_dialogue_id:
                    continue

                ordered_option_ids = collect_ordered_option_ids(first_dialogue_id)

                for index, option_id in enumerate(ordered_option_ids, 1):
                    option_port = f"Option_{index}"
                    candidate_nodes = edge_map.get((source_node_id, option_port), [])
                    if not candidate_nodes:
                        continue

                    target_dialogues = resolve_talk_targets(
                        candidate_nodes, node_data_dict, adjacency
                    )
                    if not target_dialogues:
                        continue

                    terminal_ids = collect_terminals(option_id)
                    for terminal_id in terminal_ids:
                        target_item = option_map.get(terminal_id) or dialogue_map.get(
                            terminal_id
                        )
                        merge_next(target_item, target_dialogues)

                out_targets = []
                all_ports = []
                for edge_key in edge_map.keys():
                    start_key, port = edge_key
                    if start_key != source_node_id:
                        continue
                    if port == "QuestStart":
                        continue
                    if isinstance(port, str) and port.startswith("Option_"):
                        continue
                    if port not in all_ports:
                        all_ports.append(port)

                for port in all_ports:
                    candidate_nodes = edge_map.get((source_node_id, port), [])
                    resolved = resolve_talk_targets(
                        candidate_nodes, node_data_dict, adjacency
                    )
                    for target in resolved:
                        if target not in out_targets:
                            out_targets.append(target)

                if out_targets:
                    terminal_ids = collect_terminals(first_dialogue_id)
                    for terminal_id in terminal_ids:
                        target_item = option_map.get(terminal_id) or dialogue_map.get(
                            terminal_id
                        )
                        merge_next(target_item, out_targets)

                # 选项节点不覆盖已有 next，复用对白链自身的退出逻辑

    def _apply_dyn_impression(self, dialogues, dyn_impression):
        if not dialogues or not isinstance(dyn_impression, dict):
            return

        impression_plus_data = self.data_loader.load_json("ImpressionPlus.json")
        if not isinstance(impression_plus_data, dict):
            return

        dialogue_map = {}
        option_map = {}
        option_next_map = {}

        for dialogue_item in dialogues:
            if not isinstance(dialogue_item, dict):
                continue
            dialogue_id = dialogue_item.get("id")
            if dialogue_id is not None:
                dialogue_map[str(dialogue_id)] = dialogue_item

            for option_item in dialogue_item.get("options", []):
                if not isinstance(option_item, dict):
                    continue
                option_id = option_item.get("id")
                if option_id is not None:
                    option_map[str(option_id)] = option_item

                next_id = option_item.get("next")
                if next_id is not None:
                    next_key = str(next_id)
                    option_next_map.setdefault(next_key, []).append(option_item)

        def patch_impr(target_item, impr_plus_id):
            if not isinstance(target_item, dict):
                return
            if target_item.get("impr"):
                return
            impr_data = impression_plus_data.get(str(impr_plus_id))
            if not impr_data:
                return
            impr = self._inline_impr_plus(impr_data)
            if impr:
                target_item["impr"] = impr

        for dialogue_id, impr_plus_id in dyn_impression.items():
            key = str(dialogue_id)
            if not impr_plus_id:
                continue

            if key in option_map:
                patch_impr(option_map[key], impr_plus_id)
                continue

            dialogue_item = dialogue_map.get(key)
            if dialogue_item:
                patch_impr(dialogue_item, impr_plus_id)
                continue

            for option_item in option_next_map.get(key, []):
                patch_impr(option_item, impr_plus_id)

    def _build_dyn_node_incoming_map(self, story_path, nodes):
        incoming_map = {}
        if not nodes or not story_path:
            return incoming_map

        node_ids = {str(node.get("id")) for node in nodes if isinstance(node, dict)}
        if not node_ids:
            return incoming_map

        story_data = self.load_story_file(story_path)
        if not isinstance(story_data, dict):
            return incoming_map

        story_node_data = story_data.get("storyNodeData", {})
        if not isinstance(story_node_data, dict):
            return incoming_map

        for story_node in story_node_data.values():
            if not isinstance(story_node, dict):
                continue

            quest_node_data = story_node.get("questNodeData", {})
            line_data = quest_node_data.get("lineData", [])
            if not isinstance(line_data, list):
                continue

            for edge in line_data:
                if not isinstance(edge, dict):
                    continue
                if edge.get("startPort") == "QuestStart":
                    continue

                start_quest = edge.get("startQuest")
                end_quest = edge.get("endQuest")
                if start_quest is None or end_quest is None:
                    continue

                start_key = str(start_quest)
                end_key = str(end_quest)
                if end_key not in node_ids:
                    continue

                incoming_map.setdefault(end_key, [])
                if start_key not in incoming_map[end_key]:
                    incoming_map[end_key].append(start_key)

        return incoming_map

    def _collect_ordered_quest_node_ids(self, quest_node_data):
        node_data_dict = (
            quest_node_data.get("nodeData", {})
            if isinstance(quest_node_data, dict)
            else {}
        )
        line_data = (
            quest_node_data.get("lineData", [])
            if isinstance(quest_node_data, dict)
            else []
        )
        if not isinstance(node_data_dict, dict) or not isinstance(line_data, list):
            return []

        ordered_ids = []
        seen = set()
        for edge in line_data:
            if not isinstance(edge, dict):
                continue
            if edge.get("startPort") == "QuestStart":
                end_quest = edge.get("endQuest")
                if end_quest is not None:
                    key = str(end_quest)
                    if key not in seen:
                        seen.add(key)
                        ordered_ids.append(key)

        for node_id in node_data_dict.keys():
            node_key = str(node_id)
            if node_key not in seen:
                seen.add(node_key)
                ordered_ids.append(node_key)
        return ordered_ids

    def _inline_impr_check(self, condition_id):
        return BaseProcessor._inline_impr_check(self, condition_id)

    def _inline_impr_plus(self, impr_data):
        return BaseProcessor._inline_impr_plus(self, impr_data)

    def load_story_file(self, story_path):
        if not story_path:
            return None

        json_path = story_path.replace(".story", ".json")
        json_path = json_path.replace("\\", os.sep).replace("/", os.sep)
        full_path = os.path.join("out", "StoryCreator", "StoryFiles", json_path)
        if not os.path.exists(full_path):
            return None

        try:
            with open(full_path, "r", encoding="utf-8") as f:
                return json.load(f, object_pairs_hook=OrderedDict)
        except Exception:
            return None

    def load_dialogue_flow_file(self, flow_asset_path):
        if not flow_asset_path or not isinstance(flow_asset_path, str):
            return None

        match = re.search(r"/Game/Dialogue/([^']+)", flow_asset_path)
        if not match:
            return None

        asset_part = match.group(1).split(".")[0]
        asset_part = asset_part.replace("/", os.sep).replace("\\", os.sep)
        file_path = os.path.join("out", "Dialogue", f"{asset_part}.json")
        if not os.path.exists(file_path):
            return None

        try:
            with open(file_path, "r", encoding="utf-8") as f:
                return json.load(f, object_pairs_hook=OrderedDict)
        except Exception:
            return None

    def _extract_flow_dialogue_ids(self, node):
        if not isinstance(node, dict):
            return []

        props = node.get("Properties", {})
        dialogue_data = props.get("DialogueData", [])
        if not isinstance(dialogue_data, list):
            return []

        dialogue_ids = []
        for item in dialogue_data:
            if not isinstance(item, dict):
                continue
            dialogue_id = item.get("DialogueId")
            if dialogue_id:
                dialogue_ids.append(dialogue_id)
        return dialogue_ids

    def _extract_flow_option_dialogue_ids(self, node):
        if not isinstance(node, dict):
            return []

        props = node.get("Properties", {})
        option_data = props.get("OptionData", [])
        if not isinstance(option_data, list):
            return []

        option_ids = []
        for item in option_data:
            if not isinstance(item, dict):
                continue
            dialogue_id = item.get("DialogueId")
            if dialogue_id:
                option_ids.append(dialogue_id)
        return option_ids

    def _resolve_upstream_dialogue_tail_id(self, node_guid, guid_to_node, incoming_map):
        queue = list(incoming_map.get(str(node_guid), []))
        visited = set()

        while queue:
            current_guid = queue.pop(0)
            if current_guid in visited:
                continue
            visited.add(current_guid)

            node = guid_to_node.get(current_guid)
            if not isinstance(node, dict):
                continue

            dialogue_ids = self._extract_flow_dialogue_ids(node)
            if dialogue_ids:
                return dialogue_ids[-1]

            for parent_guid in incoming_map.get(current_guid, []):
                if parent_guid not in visited:
                    queue.append(parent_guid)

        return None

    def _resolve_downstream_first_dialogue_id(self, start_guid, guid_to_node):
        if not start_guid:
            return None

        queue = [str(start_guid)]
        visited = set()

        while queue:
            current_guid = queue.pop(0)
            if current_guid in visited:
                continue
            visited.add(current_guid)

            node = guid_to_node.get(current_guid)
            if not isinstance(node, dict):
                continue

            dialogue_ids = self._extract_flow_dialogue_ids(node)
            if dialogue_ids:
                return dialogue_ids[0]

            props = node.get("Properties", {})
            for conn in props.get("Connections", []) or []:
                if not isinstance(conn, dict):
                    continue
                target = conn.get("Value", {})
                if not isinstance(target, dict):
                    continue
                next_guid = target.get("NodeGuid")
                if next_guid:
                    next_guid = str(next_guid)
                    if next_guid not in visited:
                        queue.append(next_guid)

        return None

    def _get_dialogue_chain_from_flow_asset(self, flow_asset_path, language=""):
        flow_data = self.load_dialogue_flow_file(flow_asset_path)
        if not flow_data or not isinstance(flow_data, list):
            return []

        guid_to_node = {}
        incoming_map = {}
        start_guids = []

        for item in flow_data:
            if not isinstance(item, dict):
                continue
            props = item.get("Properties", {})
            node_guid = props.get("NodeGuid")
            if node_guid:
                guid_to_node[str(node_guid)] = item
            if item.get("Type") == "FlowNode_Start" and node_guid:
                start_guids.append(str(node_guid))

            if not node_guid:
                continue

            for conn in props.get("Connections", []) or []:
                if not isinstance(conn, dict):
                    continue
                target = conn.get("Value", {})
                if not isinstance(target, dict):
                    continue
                target_guid = target.get("NodeGuid")
                if not target_guid:
                    continue

                source_key = str(node_guid)
                target_key = str(target_guid)
                incoming_map.setdefault(target_key, [])
                if source_key not in incoming_map[target_key]:
                    incoming_map[target_key].append(source_key)

        if not start_guids:
            return []

        queue = list(start_guids)
        visited_guids = set()
        dialogue_ids = []
        dialogue_seen = set()
        option_node_guids = []

        while queue:
            current_guid = queue.pop(0)
            if current_guid in visited_guids:
                continue
            visited_guids.add(current_guid)

            node = guid_to_node.get(current_guid)
            if not node:
                continue

            node_type = node.get("Type", "")
            props = node.get("Properties", {})

            if node_type == "FlowNode_Dialogue":
                for dialogue_id in self._extract_flow_dialogue_ids(node):
                    if dialogue_id not in dialogue_seen:
                        dialogue_seen.add(dialogue_id)
                        dialogue_ids.append(dialogue_id)
            elif self._extract_flow_option_dialogue_ids(node):
                option_node_guids.append(current_guid)

            for conn in props.get("Connections", []) or []:
                if not isinstance(conn, dict):
                    continue
                target = conn.get("Value", {})
                if not isinstance(target, dict):
                    continue
                next_guid = target.get("NodeGuid")
                if next_guid:
                    next_guid = str(next_guid)
                    if next_guid not in visited_guids:
                        queue.append(next_guid)

        dialogue_chain = []
        emitted_ids = set()
        emitted_option_ids = set()
        dialogue_item_map = {}

        for dialogue_id in dialogue_ids:
            dialogue_id_str = str(dialogue_id)
            if dialogue_id_str in emitted_ids or dialogue_id_str in emitted_option_ids:
                continue

            sub_chain = self.get_dialogue_chain(dialogue_id, language)
            if not sub_chain:
                continue

            for item in sub_chain:
                item_id_str = str(item.get("id"))
                if item_id_str in emitted_ids or item_id_str in emitted_option_ids:
                    continue

                dialogue_chain.append(item)
                emitted_ids.add(item_id_str)
                dialogue_item_map[item_id_str] = item

                for option in item.get("options", []):
                    option_id = option.get("id")
                    if option_id is not None:
                        emitted_option_ids.add(str(option_id))

        if option_node_guids:
            option_dialogue_ids = set()
            for option_node_guid in option_node_guids:
                option_node = guid_to_node.get(option_node_guid)
                if not isinstance(option_node, dict):
                    continue

                parent_dialogue_id = self._resolve_upstream_dialogue_tail_id(
                    option_node_guid, guid_to_node, incoming_map
                )
                if not parent_dialogue_id:
                    continue

                parent_item = dialogue_item_map.get(str(parent_dialogue_id))
                if not isinstance(parent_item, dict):
                    continue

                option_ids = self._extract_flow_option_dialogue_ids(option_node)
                if not option_ids:
                    continue

                props = option_node.get("Properties", {})

                option_pin_map = {}
                for item in props.get("OptionPinName", []) or []:
                    if not isinstance(item, dict):
                        continue
                    key = item.get("Key")
                    value = item.get("Value")
                    if key and value:
                        option_pin_map[str(key)] = str(value)

                output_pin_tooltips = {}
                for item in props.get("OutputPins", []) or []:
                    if not isinstance(item, dict):
                        continue
                    pin_name = item.get("PinName")
                    pin_tip = item.get("PinToolTip")
                    if pin_name and pin_tip:
                        output_pin_tooltips[str(pin_name)] = pin_tip

                connection_target_map = {}
                fallback_option_pins = []
                for conn in props.get("Connections", []) or []:
                    if not isinstance(conn, dict):
                        continue
                    key = conn.get("Key")
                    target = conn.get("Value", {})
                    if not key or not isinstance(target, dict):
                        continue
                    target_guid = target.get("NodeGuid")
                    if not target_guid:
                        continue
                    key_str = str(key)
                    connection_target_map[key_str] = str(target_guid)
                    if key_str.startswith("Option_"):
                        fallback_option_pins.append(key_str)

                existing_options = parent_item.get("options", [])
                option_map = {}
                for option in existing_options:
                    if not isinstance(option, dict):
                        continue
                    option_id = option.get("id")
                    if option_id is None:
                        continue
                    option_map[str(option_id)] = option

                for index, option_id in enumerate(option_ids):
                    option_key = str(option_id)
                    option_item = None

                    option_chain = self.get_dialogue_chain(option_id, language)
                    if option_chain:
                        option_item = dict(option_chain[0])
                    else:
                        option_content = self.get_dialogue_content(option_id, language)
                        if option_content:
                            option_item = {
                                "id": int(option_id),
                                "content": option_content,
                            }
                            option_voice = self.get_dialogue_voice_name(
                                option_id, language
                            )
                            if option_voice:
                                option_item["voice"] = option_voice

                    pin_name = option_pin_map.get(option_key)
                    if not pin_name and index < len(fallback_option_pins):
                        pin_name = fallback_option_pins[index]

                    if not option_item and pin_name:
                        pin_tip = output_pin_tooltips.get(pin_name, "")
                        if pin_tip:
                            option_item = {"id": int(option_id), "content": pin_tip}
                            option_voice = self.get_dialogue_voice_name(
                                option_id, language
                            )
                            if option_voice:
                                option_item["voice"] = option_voice

                    if not option_item:
                        continue

                    if option_item.get("next") is None and pin_name:
                        next_guid = connection_target_map.get(pin_name)
                        next_dialogue_id = self._resolve_downstream_first_dialogue_id(
                            next_guid, guid_to_node
                        )
                        if next_dialogue_id:
                            option_item["next"] = int(next_dialogue_id)

                    existing_item = option_map.get(option_key)
                    if existing_item:
                        if (
                            existing_item.get("next") is None
                            and option_item.get("next") is not None
                        ):
                            existing_item["next"] = option_item["next"]
                        if (
                            existing_item.get("impr") is None
                            and option_item.get("impr") is not None
                        ):
                            existing_item["impr"] = option_item["impr"]
                        if (
                            existing_item.get("imprCheck") is None
                            and option_item.get("imprCheck") is not None
                        ):
                            existing_item["imprCheck"] = option_item["imprCheck"]
                        if (
                            existing_item.get("voice") is None
                            and option_item.get("voice") is not None
                        ):
                            existing_item["voice"] = option_item["voice"]
                        if not existing_item.get("content") and option_item.get(
                            "content"
                        ):
                            existing_item["content"] = option_item["content"]
                    else:
                        existing_options.append(option_item)
                        option_map[option_key] = option_item

                    option_dialogue_ids.add(option_key)

                if existing_options:
                    parent_item["options"] = existing_options
                    parent_item.pop("next", None)

            if option_dialogue_ids:
                filtered_chain = []
                for item in dialogue_chain:
                    item_id = item.get("id")
                    if item_id is None:
                        filtered_chain.append(item)
                        continue
                    if str(item_id) in option_dialogue_ids:
                        continue
                    filtered_chain.append(item)
                dialogue_chain = filtered_chain

        return dialogue_chain
