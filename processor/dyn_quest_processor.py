from processor.base_processor import BaseProcessor
from processor.quest_story_processor import QuestStoryProcessor


class DynQuestProcessor(QuestStoryProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "DynQuest"
        self.story_dialogue_cache = {}

    def load_items(self, file_path):
        """按常规文件读取 DynQuest.json。"""
        return BaseProcessor.load_items(self, file_path)

    def process_all_items(self, items, language=""):
        """按基础处理流程遍历条目。"""
        self.data_loader.set_language(language)
        return BaseProcessor.process_all_items(self, items, language)

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

        story_path = quest_data.get("StoryPath", "")
        nodes = self._get_story_nodes(story_path, language)
        dialogues = self._flatten_node_dialogues(nodes)
        self._apply_story_graph_next(dialogues, story_path, language)
        dyn_impression = quest_data.get("DynImpression", {})
        self._apply_dyn_impression(dialogues, dyn_impression)
        if nodes:
            processed_quest["nodes"] = nodes
            incoming_map = self._build_dyn_node_incoming_map(story_path, nodes)
            start_ids = self._collect_node_start_ids(nodes, incoming_map or None)
            if len(start_ids) > 1:
                processed_quest["startIds"] = start_ids

        return processed_quest

    def _flatten_node_dialogues(self, nodes):
        """将节点中的 dialogues 展平，便于复用对白级增强逻辑。"""
        flat_dialogues = []
        for node in nodes:
            if not isinstance(node, dict):
                continue
            for dialogue_item in node.get("dialogues", []):
                if isinstance(dialogue_item, dict):
                    flat_dialogues.append(dialogue_item)
        return flat_dialogues

    def _get_story_nodes(self, story_path, language=""):
        """按 QuestStory 风格输出动态任务节点（nodes 下挂 dialogues）。"""
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
                    if props_data.get("FirstDialogueId") or props_data.get("FlowAssetPath"):
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
                node_next = resolve_talk_targets(candidate_nodes, node_data_dict, adjacency)

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
                    # 对齐 QuestStory: next 字段在 dialogues 之前输出
                    node_item["next"] = node_next

                dialogues = self._get_talk_node_dialogue_chain(
                    first_dialogue_id, flow_asset_path, language
                )
                if dialogues:
                    node_item["dialogues"] = dialogues

                result_nodes.append(node_item)
                seen_node_ids.add(node_key)

        if not result_nodes:
            return result_nodes

        output_node_ids = {str(node_item.get("id")) for node_item in result_nodes}
        for node_item in result_nodes:
            next_ids = node_item.get("next")
            if not next_ids:
                continue

            if isinstance(next_ids, list):
                next_candidates = next_ids
            else:
                next_candidates = [next_ids]

            filtered = []
            seen_filtered = set()
            for next_id in next_candidates:
                next_key = str(next_id)
                if next_key not in output_node_ids:
                    continue
                if next_key == str(node_item.get("id")):
                    continue
                if next_key in seen_filtered:
                    continue
                seen_filtered.add(next_key)
                filtered.append(next_key)

            if filtered:
                node_item["next"] = filtered
            else:
                node_item.pop("next", None)

        # 对齐历史规则：next 仅用于表示“非连续跳转”
        for index, node_item in enumerate(result_nodes):
            next_ids = node_item.get("next")
            if not isinstance(next_ids, list) or not next_ids:
                continue

            sequential_next = None
            if index + 1 < len(result_nodes):
                sequential_next = str(result_nodes[index + 1].get("id"))

            pruned = []
            for next_id in next_ids:
                if sequential_next and str(next_id) == sequential_next:
                    continue
                pruned.append(next_id)

            if pruned:
                node_item["next"] = pruned
            else:
                node_item.pop("next", None)

        return result_nodes

    def _build_dyn_node_incoming_map(self, story_path, nodes):
        """根据动态任务 story 的 lineData 构建节点入边映射（排除 QuestStart）。"""
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

    def _collect_dialogue_start_ids(self, dialogues):
        """根据 dialogues 内部 next 引用计算链路起点。"""
        if not dialogues:
            return []

        ordered_ids = []
        dialogue_ids = set()
        incoming_ids = set()

        for dialogue_item in dialogues:
            if not isinstance(dialogue_item, dict):
                continue
            dialogue_id = dialogue_item.get("id")
            if dialogue_id is None:
                continue
            dialogue_key = str(dialogue_id)
            if dialogue_key in dialogue_ids:
                continue
            dialogue_ids.add(dialogue_key)
            ordered_ids.append(dialogue_id)

        def collect_incoming(next_value):
            if next_value is None:
                return
            if isinstance(next_value, list):
                for item in next_value:
                    item_key = str(item)
                    if item_key in dialogue_ids:
                        incoming_ids.add(item_key)
                return
            next_key = str(next_value)
            if next_key in dialogue_ids:
                incoming_ids.add(next_key)

        for dialogue_item in dialogues:
            if not isinstance(dialogue_item, dict):
                continue
            collect_incoming(dialogue_item.get("next"))
            for option_item in dialogue_item.get("options", []):
                if isinstance(option_item, dict):
                    collect_incoming(option_item.get("next"))

        start_ids = []
        for dialogue_id in ordered_ids:
            if str(dialogue_id) not in incoming_ids:
                start_ids.append(dialogue_id)

        # 兜底：若图结构异常导致无法识别起点，至少保留首条对白
        if not start_ids and ordered_ids:
            return [ordered_ids[0]]

        return start_ids

    def _apply_dyn_impression(self, dialogues, dyn_impression):
        """根据 DynImpression 补充对白或选项的 impr。"""
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

            # 命中选项ID：直接赋值
            if key in option_map:
                patch_impr(option_map[key], impr_plus_id)
                continue

            dialogue_item = dialogue_map.get(key)
            if dialogue_item:
                patch_impr(dialogue_item, impr_plus_id)
                continue

            # 兜底：对白ID无选项时，尝试命中指向该对白的上游选项
            for option_item in option_next_map.get(key, []):
                patch_impr(option_item, impr_plus_id)

    def _get_story_dialogues(self, story_path, language=""):
        """从动态任务 story 中提取对话链。"""
        if not story_path:
            return []

        cache_key = f"{language}:{story_path}"
        if cache_key in self.story_dialogue_cache:
            return self.story_dialogue_cache[cache_key]

        story_data = self.load_story_file(story_path)
        if not story_data:
            self.story_dialogue_cache[cache_key] = []
            return []

        talk_nodes = self._collect_talk_nodes(story_data)
        if not talk_nodes:
            self.story_dialogue_cache[cache_key] = []
            return []

        dialogue_chain = []
        emitted_ids = set()
        emitted_option_ids = set()

        for talk_node in talk_nodes:
            first_dialogue_id = talk_node.get("first_dialogue_id", 0)
            flow_asset_path = talk_node.get("flow_asset_path", "")

            chain = self._get_talk_node_dialogue_chain(
                first_dialogue_id, flow_asset_path, language
            )

            for item in chain:
                item_id = str(item.get("id"))
                if item_id in emitted_ids or item_id in emitted_option_ids:
                    continue

                dialogue_chain.append(item)
                emitted_ids.add(item_id)

                for option in item.get("options", []):
                    option_id = option.get("id")
                    if option_id is not None:
                        emitted_option_ids.add(str(option_id))

        self.story_dialogue_cache[cache_key] = dialogue_chain
        return dialogue_chain

    def _apply_story_graph_next(self, dialogues, story_path, language=""):
        """按 story lineData 回填跨节点 next 关系。"""
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
            """从某对白ID出发，收集链路终点对白/选项ID。"""
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
            """从对白链中按出现顺序收集所有选项ID（不限于首句）。"""
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
            """从节点集合向后解析，直到命中 TalkNode 的首对白。"""
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
            """将目标 next 回填到对白/选项（仅单值）。"""
            if not isinstance(item, dict) or not targets:
                return

            # 对齐 QuestStory/Dialogue 的语义：next 为单个节点，不输出数组
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
                if not isinstance(node_data, dict) or node_data.get("type") != "TalkNode":
                    continue

                source_node_id = str(node_id)
                first_dialogue_id = node_data.get("propsData", {}).get(
                    "FirstDialogueId", 0
                )
                if not first_dialogue_id:
                    continue

                ordered_option_ids = collect_ordered_option_ids(first_dialogue_id)

                # Option_1 / Option_2 ...：将跨节点跳转补到对应分支终点
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

                # 非 Option 端口：用于补齐未命中的终点 next（不覆盖已有 next）
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

                # UnimportGuide（NPC头顶非交互提示）：
                # 若自身无后继，尝试接到同父同端口的兄弟 TalkNode，避免悬空。
                talk_type = node_data.get("propsData", {}).get("TalkType", "")
                if talk_type == "UnimportGuide":
                    guide_targets = []
                    for parent_node_id, parent_port in incoming_map.get(source_node_id, []):
                        sibling_nodes = edge_map.get((parent_node_id, parent_port), [])
                        sibling_nodes = [
                            sibling
                            for sibling in sibling_nodes
                            if sibling != source_node_id
                        ]
                        resolved = resolve_talk_targets(
                            sibling_nodes, node_data_dict, adjacency
                        )
                        for target in resolved:
                            if target not in guide_targets:
                                guide_targets.append(target)

                    if guide_targets:
                        terminal_ids = collect_terminals(first_dialogue_id)
                        for terminal_id in terminal_ids:
                            target_item = option_map.get(terminal_id) or dialogue_map.get(
                                terminal_id
                            )
                            merge_next(target_item, guide_targets)

    def _collect_talk_nodes(self, story_data):
        """收集剧情中的 TalkNode 信息（优先按 lineData 顺序）。"""
        story_node_data = story_data.get("storyNodeData", {})
        if not isinstance(story_node_data, dict):
            return []

        talk_nodes = []
        seen = set()

        def append_talk_node(node_data, node_key_hint=""):
            if not isinstance(node_data, dict):
                return
            if node_data.get("type") != "TalkNode":
                return

            props_data = node_data.get("propsData", {})
            first_dialogue_id = props_data.get("FirstDialogueId", 0)
            flow_asset_path = props_data.get("FlowAssetPath", "")

            if not first_dialogue_id and not flow_asset_path:
                return

            node_key = str(node_data.get("key") or node_key_hint or node_data.get("name") or "")
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
            quest_node_data = node_data.get("questNodeData", {})
            node_data_dict = quest_node_data.get("nodeData", {})
            if isinstance(node_data_dict, dict):
                ordered_node_ids = self._collect_ordered_quest_node_ids(quest_node_data)
                if ordered_node_ids:
                    for node_id in ordered_node_ids:
                        append_talk_node(node_data_dict.get(node_id), node_id)
                else:
                    for sub_node_key, sub_node in node_data_dict.items():
                        append_talk_node(sub_node, sub_node_key)

            # 兜底处理顶层 TalkNode（通常动态任务不使用）
            append_talk_node(node_data)

        return talk_nodes

    def _collect_ordered_quest_node_ids(self, quest_node_data):
        """根据 questNodeData.lineData 生成节点遍历顺序。"""
        if not isinstance(quest_node_data, dict):
            return []

        line_data = quest_node_data.get("lineData", [])
        if not isinstance(line_data, list):
            return []

        adjacency = {}
        node_data_dict = quest_node_data.get("nodeData", {})
        ordered_nodes = []
        ordered_seen = set()
        start_nodes = []
        start_seen = set()

        def add_ordered_node(node_id):
            if node_id in ordered_seen:
                return
            ordered_seen.add(node_id)
            ordered_nodes.append(node_id)

        for edge in line_data:
            if not isinstance(edge, dict):
                continue

            start_port = edge.get("startPort")
            start_quest = edge.get("startQuest")
            end_quest = edge.get("endQuest")

            if end_quest is not None:
                add_ordered_node(str(end_quest))
            if start_quest is not None:
                add_ordered_node(str(start_quest))

            # QuestStart 只用于确定起点，不作为普通边处理
            if start_port == "QuestStart":
                if end_quest is not None:
                    end_key = str(end_quest)
                    if end_key not in start_seen:
                        start_seen.add(end_key)
                        start_nodes.append(end_key)
                continue

            if start_quest is None or end_quest is None:
                continue

            start_key = str(start_quest)
            end_key = str(end_quest)
            adjacency.setdefault(start_key, [])
            if end_key not in adjacency[start_key]:
                adjacency[start_key].append(end_key)

        if not ordered_nodes:
            return []

        # 没有 QuestStart 的异常配置，回退到 lineData 首节点
        if not start_nodes:
            start_nodes = [ordered_nodes[0]]

        result = []
        visited = set()
        queue = list(start_nodes)

        def get_node_priority(node_id):
            if not isinstance(node_data_dict, dict):
                return 1
            node_data = node_data_dict.get(node_id, {})
            if not isinstance(node_data, dict):
                return 1
            if node_data.get("type") != "TalkNode":
                return 1
            talk_type = node_data.get("propsData", {}).get("TalkType", "")
            return 0 if talk_type == "UnimportGuide" else 1

        def bfs():
            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue
                visited.add(current)
                result.append(current)

                next_nodes = adjacency.get(current, [])
                # 保持 lineData 原顺序的同时，让 UnimportGuide 对话节点优先进入队列
                next_nodes = sorted(next_nodes, key=get_node_priority)
                for next_node in next_nodes:
                    if next_node not in visited and next_node not in queue:
                        queue.append(next_node)

        bfs()

        # 兼容非连通子图：按 lineData 出现顺序继续遍历
        for node_id in ordered_nodes:
            if node_id in visited:
                continue
            queue.append(node_id)
            bfs()

        return result
