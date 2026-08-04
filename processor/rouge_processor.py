import json
import os
import re

from processor._util import get_attr_config_key_from_attr_data
from processor.base_processor import BaseProcessor
from processor.mod_processor import ModProcessor

ROUGE_PRO_PROCESSOR_CLASSES = {}


class RougeProcessor(BaseProcessor):
    """迷津处理器基类"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Rouge"
        self._mod_processor = None
        self.story_files_base_path = os.path.join("out", "StoryCreator", "StoryFiles")
        self._lua_grow_base_cache = {}

    def _get_mod_processor(self):
        if self._mod_processor is None:
            self._mod_processor = ModProcessor(self.data_loader)
        return self._mod_processor

    def _load_lua_grow_base(self, grow_type, grow_id):
        """从原始 SkillGrow.lua 中读取指定成长数据的 [0] 基础值。

        out/SkillGrow.json 在转换时丢失了 [0] 基础项（等级0），
        导致深潜契约等级1的数值整体错位。这里直接解析 lua 恢复基础值。
        """
        cache_key = (grow_type, str(grow_id))
        if cache_key in self._lua_grow_base_cache:
            return self._lua_grow_base_cache[cache_key]

        base_value = None
        lua_path = os.path.join("Script", "Datas", "SkillGrow.lua")
        if os.path.exists(lua_path):
            try:
                with open(lua_path, "r", encoding="utf-8") as f:
                    lua_code = f.read()
                pattern = (
                    r"\[{id}\] = \{{\s*\[0\] = \{{\s*\[1\] = \{{"
                    r"\s*ID = {id},\s*Index = \d+,\s*Level = 0,"
                    r'\s*Type = "{grow_type}",\s*Value = ([\d.\-]+)'
                ).format(id=re.escape(str(grow_id)), grow_type=re.escape(grow_type))
                match = re.search(pattern, lua_code)
                if match:
                    base_value = float(match.group(1))
            except Exception:
                base_value = None

        self._lua_grow_base_cache[cache_key] = base_value
        return base_value

    def _ensure_grow_base_injected(self):
        """将 lua 中缺失的 [0] 基础成长项合并进 skill_grow_data。

        游戏契约等级 N 对应 SkillGrow[N-1]（含基础值 [0]）。
        out/SkillGrow.json 丢失了基础项，这里补回，使
        _calc_attr_by_level 对 Buff/GlobalPassiveData 的等级映射恢复正确。
        """
        mod_processor = self._get_mod_processor()
        skill_grow = mod_processor.skill_grow_data

        for grow_type in ("Buff", "GlobalPassiveData"):
            type_data = skill_grow.get(grow_type)
            if not type_data:
                continue
            for grow_id in list(type_data.keys()):
                base_value = self._load_lua_grow_base(grow_type, grow_id)
                if base_value is None:
                    continue
                id_data = type_data[grow_id]
                # 若已含 Level=0 的基础项则跳过
                if isinstance(id_data, list) and id_data:
                    first_entry = id_data[0]
                    if isinstance(first_entry, list) and first_entry:
                        first = first_entry[0]
                        if isinstance(first, dict) and first.get("Level") == 0:
                            continue
                base_entry = [
                    {
                        "ID": int(grow_id),
                        "Index": 1,
                        "Level": 0,
                        "Type": grow_type,
                        "Value": base_value,
                    }
                ]
                if isinstance(id_data, list):
                    type_data[grow_id] = [base_entry] + list(id_data)

    @staticmethod
    def _to_camel_case(key):
        """将字段名转换为 camelCase。"""
        if not isinstance(key, str) or not key:
            return key

        words = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", key)
        words = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", words)
        words = re.split(r"[_-]+", words)
        words = [word for word in words if word]
        if not words:
            return key
        return words[0].lower() + "".join(word.capitalize() for word in words[1:])

    def _camelize_value(self, value):
        """递归转换嵌套对象中的字段名。"""
        if isinstance(value, dict):
            return {
                self._to_camel_case(key): self._camelize_value(item)
                for key, item in value.items()
            }
        if isinstance(value, list):
            return [self._camelize_value(item) for item in value]
        return value

    @staticmethod
    def _shorten_icon(icon):
        """提取 Unreal 图标资源名并移除路径、扩展名和包装类型。"""
        if not isinstance(icon, str) or not icon:
            return icon or ""

        icon = icon.strip()
        if icon.startswith("Texture2D'"):
            icon = icon[len("Texture2D'") :]
        icon = icon.strip("'").replace("\\", "/")
        icon_name = icon.rsplit("/", 1)[-1]
        return icon_name.split(".", 1)[0].strip("'")

    def _format_mod_attr_value(self, attr, mod_id, mod_level):
        """按游戏端属性显示规则格式化 Mod 属性值。"""
        mod_processor = self._get_mod_processor()
        value = self._calc_mod_attr_value(attr, mod_id, mod_level)
        attr_key = get_attr_config_key_from_attr_data(attr, mod_processor.attr_config)
        attr_config = mod_processor.attr_config.get(attr_key, {})

        is_rate = "Rate" in attr
        if attr_config.get("NumCorrect") and not is_rate:
            value *= attr_config["NumCorrect"]

        suffix = ""
        if attr_config.get("IsPercent") or is_rate:
            value *= 100
            suffix = "%"
        return f"{mod_processor._format_desc_numeric(value)}{suffix}"

    def _calc_mod_attr_value(self, attr, mod_id, mod_level):
        """计算 Mod 属性，兼容 SkillGrow 的按等级字典结构。"""
        mod_processor = self._get_mod_processor()
        base = attr.get("Rate" if "Rate" in attr else "Value")
        if not isinstance(base, str) or not base.startswith("#"):
            return mod_processor._calc_mod_attr_by_level(attr, mod_id, mod_level)

        try:
            grow_index = int(base[1:])
        except ValueError:
            return mod_processor._calc_mod_attr_by_level(attr, mod_id, mod_level)

        grow_type = attr.get("Type", "Mod")
        grow_data = mod_processor.skill_grow_data.get(grow_type, {}).get(str(mod_id))
        if not grow_data:
            return mod_processor._calc_mod_attr_by_level(attr, mod_id, mod_level)

        if isinstance(grow_data, dict):
            level_data = grow_data.get(str(max(mod_level - 1, 0)))
            if level_data is None:
                level_data = list(grow_data.values())[-1]
        else:
            level_index = max(0, min(mod_level - 1, len(grow_data) - 1))
            level_data = grow_data[level_index]

        entries = level_data if isinstance(level_data, list) else [level_data]
        for entry in entries:
            if isinstance(entry, dict) and entry.get("Index") == grow_index:
                return entry.get("Value", 0.0)

        return mod_processor._calc_mod_attr_by_level(attr, mod_id, mod_level)

    def _parse_desc_value(self, desc_value, mod_id=None, mod_level=1):
        """使用 Mod 的表达式解析逻辑计算单个描述值。"""
        if not isinstance(desc_value, str):
            return desc_value

        # 源数据使用该拼写，导出表名为 RougeLikeServerBuild。
        desc_value = desc_value.replace(
            "#RougelikeServerBuild", "#RougeLikeServerBuild"
        )
        return self._get_mod_processor()._parse_single_desc_value(
            desc_value, mod_id, mod_level
        )

    def _replace_desc_values(
        self, text, values, placeholder_prefix, mod_id=None, mod_level=1
    ):
        """将表达式值替换到文本占位符中。"""
        if not isinstance(text, str) or not values:
            return text

        if isinstance(values, dict):
            values = values.items()
        else:
            values = enumerate(values, start=1)

        for index, value in values:
            try:
                index = int(index)
            except (TypeError, ValueError):
                continue
            value = self._parse_desc_value(value, mod_id, mod_level)
            text = text.replace(f"{placeholder_prefix}{index}", str(value))
        return text

    def _replace_mod_desc(self, text, mod_id, mod_level):
        """按 Mod 描述规则替换属性和被动效果占位符。"""
        if not isinstance(text, str) or not mod_id:
            return text

        mod_data = self.data_loader.get_mod_info(mod_id)
        if not mod_data:
            return text

        for index, attr in enumerate(mod_data.get("AddAttrs", []), start=1):
            if isinstance(attr, dict):
                value = self._format_mod_attr_value(attr, mod_id, mod_level)
                text = text.replace(f"#{index}", value)

        return self._replace_desc_values(
            text,
            mod_data.get("DescValues", []),
            "$",
            mod_id,
            mod_level,
        )

    def _get_mod_level(self, mod_id):
        mod_data = self.data_loader.get_mod_info(mod_id)
        if not mod_data:
            return 1
        return mod_data.get("MaxLevel", 1) + mod_data.get("ModCardLevelMax", 0)

    def _process_linked_desc(self, item, desc, mod_field):
        mod_id = item.get(mod_field, 0)
        if not mod_id:
            return desc
        return self._replace_mod_desc(desc, mod_id, self._get_mod_level(mod_id))

    def _compute_contract_desc_levels(self, desc, desc_values, max_level):
        """计算契约各等级的 <Highlight> 数值数组。

        对可升级契约（maxLevel > 1），按 1..maxLevel 逐级计算描述值，
        返回每个等级的高亮数值（保留原始格式化，如 "20.0%"）。
        无法计算时返回空数组。
        """
        if not desc_values or not isinstance(desc_values, list) or max_level <= 1:
            return []
        # 补回 out/SkillGrow.json 丢失的 [0] 基础项，保证等级1取到基础值
        self._ensure_grow_base_injected()
        levels = []
        for level in range(1, max_level + 1):
            level_desc = self._replace_desc_values(desc, desc_values, "#", None, level)
            highlight_value = self._extract_highlight_value(level_desc)
            levels.append(highlight_value)
        return levels

    @staticmethod
    def _extract_highlight_value(desc):
        """提取描述中第一个 <Highlight>...</> 标签内的数值文本。"""
        if not isinstance(desc, str):
            return ""
        import re

        match = re.search(r"<Highlight>(.*?)</>", desc)
        return match.group(1) if match else ""

    def _normalize_story_path(self, story_path):
        """将 story 路径规范化为可相对拼接的文件路径。"""
        if not isinstance(story_path, str) or not story_path:
            return ""
        json_path = story_path.replace(".story", ".json")
        if not json_path.endswith(".json"):
            json_path += ".json"
        json_path = json_path.replace("\\", "/").replace("/", os.sep)
        return json_path.lstrip(os.sep)

    def load_event_story_file(self, story_path):
        """加载迷津事件剧情文件。"""
        json_path = self._normalize_story_path(story_path)
        if not json_path:
            return None
        full_path = os.path.join(self.story_files_base_path, json_path)
        if not os.path.exists(full_path):
            return None
        try:
            with open(full_path, "r", encoding="utf-8") as f:
                return json.load(f, object_pairs_hook=dict)
        except Exception:
            return None

    def _is_quest_flow_edge(self, edge):
        """判断任务节点边是否参与顺序遍历。"""
        start_port_key = str(edge.get("startPort", "")).lower()
        if start_port_key == "queststart":
            return False
        if start_port_key in ("fail", "passivefail", "false"):
            return False
        return True

    def _parse_event_storyline(self, story_path, language=""):
        """解析迷津事件剧情文件，返回可展示的对话节点链。

        剧情文件为 StoryNode 嵌套图结构：顶层 lineData 串联 StoryNode，
        每个 StoryNode 内的 questNodeData 又包含子节点图。对话节点（TalkNode）
        通过 FirstDialogueId 关联标准 Dialogue 数据，使用与任务剧情一致的
        对话链解析逻辑展开为可交互对话。
        """
        story_data = self.load_event_story_file(story_path)
        if not story_data or "storyNodeData" not in story_data:
            return []

        nodes = []
        story_node_data = story_data["storyNodeData"]

        # 顶层 StoryNode 顺序遍历（类似 quest 的 questNodeData 处理）
        for node_key, node_data in story_node_data.items():
            quest_node_data = node_data.get("questNodeData", {})
            if not quest_node_data:
                continue
            node_data_dict = quest_node_data.get("nodeData", {})
            quest_line_data = quest_node_data.get("lineData", [])

            node_map = {str(k): v for k, v in node_data_dict.items()}

            # 起始节点：QuestStart 边的终点
            start_nodes = []
            for edge in quest_line_data:
                if edge.get("startPort") == "QuestStart":
                    start_nodes.append(str(edge.get("endQuest")))

            if not start_nodes:
                continue

            # 构建后继映射
            next_map = {}
            for edge in quest_line_data:
                if not isinstance(edge, dict) or not self._is_quest_flow_edge(edge):
                    continue
                start_quest = str(edge.get("startQuest", ""))
                end_quest = str(edge.get("endQuest", ""))
                if start_quest and end_quest:
                    next_map.setdefault(start_quest, [])
                    if end_quest not in next_map[start_quest]:
                        next_map[start_quest].append(end_quest)

            visited = set()
            queue = list(start_nodes)
            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue
                visited.add(current)

                node = node_map.get(current)
                if node and node.get("type") == "TalkNode":
                    props_data = node.get("propsData", {})
                    first_dialogue_id = props_data.get("FirstDialogueId", 0)
                    flow_asset_path = props_data.get("FlowAssetPath", "")
                    dialogue_chain = self._get_talk_node_dialogue_chain(
                        first_dialogue_id, flow_asset_path, language
                    )
                    node_item = {
                        "id": current,
                        "type": node.get("type", ""),
                        "name": node.get("name", ""),
                    }
                    if next_map.get(current):
                        node_item["next"] = next_map[current]
                    if dialogue_chain:
                        node_item["dialogues"] = dialogue_chain
                    nodes.append(node_item)

                for nxt in next_map.get(current, []):
                    if nxt not in visited:
                        queue.append(nxt)

        return nodes

    def _get_talk_node_dialogue_chain(
        self, first_dialogue_id, flow_asset_path, language=""
    ):
        """解析对话节点对应的对话链，复用任务剧情逻辑。"""
        if flow_asset_path:
            chain = self.get_dialogue_chain_from_flow_asset(flow_asset_path, language)
            if chain:
                return chain
        if first_dialogue_id:
            return self.get_dialogue_chain(first_dialogue_id, language)
        return []

    def get_dialogue_chain_from_flow_asset(self, flow_asset_path, language=""):
        """从 FlowAssetPath 解析对话链（迷津事件使用场景，可返回空）。"""
        return []


class RougeLikeBlessingGroupProcessor(RougeProcessor):
    """迷津烛芯分类（祝福组）处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeBlessingGroup"

    def process_item(self, item, language):
        """处理单个烛芯分类数据"""
        return {
            "id": item.get("GroupId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "bigIcon": self._shorten_icon(item.get("BigIcon", "")),
            "activateNeed": self._camelize_value(item.get("ActivateNeed", [])),
            "groupEffectDesc": self.get_translated_text(
                item.get("GroupEffectDesc", ""), language
            ),
        }


class RougeLikeTreasureGroupProcessor(RougeProcessor):
    """迷津遗物套装（TreasureGroup）处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTreasureGroup"

    def process_item(self, item, language):
        """处理单个遗物套装数据"""
        return {
            "id": item.get("GroupId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "bigIcon": self._shorten_icon(item.get("BigIcon", "")),
            "activateNeed": self._camelize_value(item.get("ActivateNeed", [])),
            "groupEffectDesc": self.get_translated_text(
                item.get("GroupEffectDesc", ""), language
            ),
        }


class RougeLikeTalentBranchProcessor(RougeProcessor):
    """迷津提灯分支处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTalentBranch"

    def process_item(self, item, language):
        """处理单个提灯分支数据"""
        return {
            "id": item.get("BranchId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "subTitle": self.get_translated_text(item.get("SubTitle", ""), language),
            "icon": self._shorten_icon(item.get("Icon", "")),
        }


class RougeLikeBlessingProcessor(RougeProcessor):
    """迷津祝福处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeBlessing"

    def process_item(self, item, language):
        """处理单个祝福数据"""
        desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._process_linked_desc(item, desc, "BlessingMod")
        return {
            "id": item.get("BlessingId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "simpleDesc": self.get_translated_text(
                item.get("SimpleDesc", ""), language
            ),
            "blessingGroup": item.get("BlessingGroup", 0),
            "rarity": item.get("BlessingRarity", 0),
            "weight": item.get("BlessingWeight", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "modEquip": item.get("ModEquip", ""),
            "roomCondition": self._camelize_value(item.get("Condition", [])),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "typeIcon": self._shorten_icon(item.get("TypeIcon", "")),
            "endPoints": self._camelize_value(item.get("EndPoints", [])),
            "shopPrices": item.get("ShopPrices", 0),
            "rlArchiveId": item.get("RLArchiveId", 0),
            "canSell": item.get("CanSell", 0),
        }


class RougeLikeContractProcessor(RougeProcessor):
    """迷津契约处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeContract"

    def process_item(self, item, language):
        """处理单个契约数据"""
        # 补回 out/SkillGrow.json 丢失的 [0] 基础项，保证等级1取到基础值
        self._ensure_grow_base_injected()
        desc_values = item.get("DescValues", [])
        raw_desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._replace_desc_values(raw_desc, desc_values, "#")
        max_level = item.get("MaxLevel", 0)
        desc_levels = self._compute_contract_desc_levels(
            raw_desc, desc_values, max_level
        )
        return {
            "id": item.get("Id", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "descLevels": desc_levels,
            "globalPassiveId": item.get("GlobalPassiveId", 0),
            "heatValue": item.get("HeatValue", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "maxLevel": max_level,
        }


class RougeLikeRoomProcessor(RougeProcessor):
    """迷津房间处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeRoom"

    def process_item(self, item, language):
        """处理单个房间数据"""
        result = {
            "id": item.get("RoomId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "roomType": item.get("RoomType", 0),
            "weight": item.get("RoomWeight", 0),
            "roomCondition": self._camelize_value(item.get("RoomCondition", [])),
            "blessingAward": item.get("BlessingAward", 0),
            "tokenAward": item.get("TokenAward", 0),
            "endPointsBase": item.get("EndPointsBase", 0),
            "endPointsExtras": item.get("EndPointsExtras", 0),
            "eventMainIcon": self._shorten_icon(item.get("EventMainIcon", "")),
        }
        storyline_path = item.get("EventStoryline", "")
        if storyline_path:
            storyline = self._parse_event_storyline(storyline_path, language)
            if storyline:
                result["eventStoryline"] = storyline
        return result


class RougeLikeStoryEventProcessor(RougeProcessor):
    """迷津故事事件处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeStoryEvent"

    def process_item(self, item, language):
        """处理单个故事事件数据"""
        storyline_path = item.get("EventStoryline", "")
        storyline = self._parse_event_storyline(storyline_path, language)
        result = {
            "id": item.get("Id", 0),
            "name": self.get_translated_text(item.get("StoryEventName", ""), language),
            "type": self.get_translated_text(item.get("StoryEventType", ""), language),
            "icon": self._shorten_icon(item.get("EventMainIcon", "")),
            "condition": self._camelize_value(item.get("EventCondition", [])),
            "moment": item.get("EventMoment", 0),
            "minRoom": item.get("EventMinRoom", 0),
            "probability": self._camelize_value(item.get("EventProbability", [])),
            "rlArchiveSubId": item.get("RLArchiveSubId", 0),
            "cutOffEvent": item.get("CutOffEvent", False),
        }
        if storyline:
            result["eventStoryline"] = storyline
        return result


class RougeLikeTalentProcessor(RougeProcessor):
    """迷津天赋处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTalent"

    def process_item(self, item, language):
        """处理单个天赋数据"""
        desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._process_linked_desc(item, desc, "TalentMod")
        desc = self._replace_desc_values(desc, item.get("ServerBuildValue", []), "@")
        return {
            "id": item.get("TalentId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "branch": item.get("Branch", 0),
            "type": item.get("Type", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "point": item.get("LevelUpPoint", 0),
            "modEquip": item.get("ModEquip", ""),
            "mod": item.get("TalentMod", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "unlock": self._camelize_value(item.get("UnLock", [])),
        }


class RougeLikeTreasureProcessor(RougeProcessor):
    """迷津宝藏处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTreasure"

    def process_item(self, item, language):
        """处理单个宝藏数据"""
        desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._process_linked_desc(item, desc, "TreasureMod")
        desc = self._replace_desc_values(desc, item.get("ServerBuildValue", []), "@")
        return {
            "id": item.get("TreasureId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "simpleDesc": self.get_translated_text(
                item.get("SimpleDesc", ""), language
            ),
            "ipDesc": self.get_translated_text(item.get("IPDesc", ""), language),
            "treasureGroup": item.get("TreasureGroup", 0),
            "rarity": item.get("TreasureRarity", 0),
            "weight": item.get("TreasureWeight", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "modEquip": item.get("ModEquip", ""),
            "mod": item.get("TreasureMod", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "endPoints": self._camelize_value(item.get("EndPoints", [])),
            "shopPrices": item.get("ShopPrices", 0),
            "roomCondition": self._camelize_value(item.get("Condition", [])),
            "rlArchiveId": item.get("RLArchiveId", 0),
            "canSell": item.get("CanSell", 0),
        }


class RougeProProcessor(RougeProcessor):
    """RougePro 系列处理器基类。"""

    file_type = "RougePro"

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = getattr(type(self), "file_type", "RougePro")


class _RougeProTableProcessor(RougeProProcessor):
    """RougePro 表格导出基类，保留源字段并统一导出字段格式。"""

    id_field = ""
    translated_fields = ()
    dropped_fields = ()

    def process_item(self, item, language):
        """处理单条 RougePro 配置。"""
        if not isinstance(item, dict):
            return None

        processed = {}
        item_id = item.get(self.id_field) if self.id_field else None
        if item_id is not None:
            processed["id"] = item_id

        # id_field 已作为 "id" 导出，跳过其 camelCase 变体，避免重复（如 RoomId→roomId）
        id_field_camel = self._to_camel_case(self.id_field) if self.id_field else ""

        for source_key, value in item.items():
            target_key = self._to_camel_case(source_key)
            if source_key == "UnLock":
                target_key = "unlock"
            if target_key == "id":
                continue
            if id_field_camel and target_key == id_field_camel:
                continue
            if source_key in self.dropped_fields:
                continue
            if source_key in self.translated_fields and isinstance(value, str):
                value = self.get_translated_text(value, language)
            elif source_key in ("Icon", "BigIcon"):
                value = self._shorten_icon(value)
            else:
                value = self._camelize_value(value)
            processed[target_key] = value

        return processed


class RougeProClassProcessor(_RougeProTableProcessor):
    file_type = "RougeProClass"
    id_field = "Id"
    translated_fields = ("Name", "Desc")


class RougeProContractProcessor(_RougeProTableProcessor):
    file_type = "RougeProContract"
    id_field = "Id"
    translated_fields = ("Name", "Desc")
    dropped_fields = ("DescValues",)

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if processed and processed.get("desc"):
            processed["desc"] = self._replace_desc_values(
                processed["desc"], item.get("DescValues", []), "#"
            )
        return processed


class RougeProConvertProcessor(RougeProProcessor):
    file_type = "RougeProConvert"

    def process_item(self, item, language):
        """保留 TreasureMap 的嵌套分组结构。"""
        if not isinstance(item, dict):
            return None
        treasure_map = item.get("TreasureMap", item)
        return {"treasureMap": self._camelize_value(treasure_map)}


class RougeProDifficultyProcessor(_RougeProTableProcessor):
    file_type = "RougeProDifficulty"
    id_field = "ID"
    dropped_fields = ()

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if not processed:
            return processed
        if "roomLevel" in processed:
            processed["level"] = processed.pop("roomLevel")
        return processed


class RougeProEffectProcessor(_RougeProTableProcessor):
    file_type = "RougeProEffect"
    id_field = "Id"
    dropped_fields = ("BuffType", "Param")


class RougeProSeasonProcessor(_RougeProTableProcessor):
    file_type = "RougeProSeason"
    id_field = "SeasonId"
    dropped_fields = (
        "AutoNextRoundTime",
        "BossRandomRule",
        "BossShowTime",
        "ClassChooseTime",
        "ClassLockTime",
        "CollectRegionRefreshCD",
        "CowEventTime",
        "DeadDeductScore",
        "DeadDeductScoreDeadTimes",
        "MaxEventNum",
        "MRTCost",
        "MRTLimitTimes",
        "RegionUnlockTime",
        "RewardCollectTime",
        "RewardMonsterSpawnRule",
        "RewardStageTime",
        "RoundMainTime",
        "ShopRandom",
    )


class RougeProShopRandomProcessor(_RougeProTableProcessor):
    file_type = "RougeProShopRandom"
    id_field = "ShopRandom"


class RougeProTalentProcessor(_RougeProTableProcessor):
    file_type = "RougeProTalent"
    id_field = "TalentId"
    translated_fields = ("Name", "Desc")
    dropped_fields = ("IconLoc", "UnLock")

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if not processed:
            return processed
        if "levelUpPoint" in processed:
            processed["point"] = processed.pop("levelUpPoint")
        if "talentMod" in processed:
            processed["mod"] = processed.pop("talentMod")
        if processed.get("desc"):
            desc = self._process_linked_desc(item, processed["desc"], "TalentMod")
            processed["desc"] = self._replace_desc_values(
                desc, item.get("ServerBuildValue", []), "@"
            )
        return processed


class RougeProTreasureProcessor(_RougeProTableProcessor):
    file_type = "RougeProTreasure"
    id_field = "TreasureId"
    translated_fields = (
        "Name",
        "Desc",
        "SimpleDesc",
        "IPDesc",
    )
    dropped_fields = (
        "CanSell",
        "Effect",
        "ShopPrices",
        "ShopWeight",
        "TreasureMod",
        "UnlockConditionText",
    )

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self._like_treasures = None

    def _get_like_treasures(self):
        """懒加载其一遗物表（按 TreasureId 索引）。"""
        if self._like_treasures is None:
            raw = self.data_loader.load_json("RougeLikeTreasure.json")
            items = raw.values() if isinstance(raw, dict) else raw
            self._like_treasures = {
                item.get("TreasureId"): item for item in items if item
            }
        return self._like_treasures

    def _get_like_treasure(self, item, language):
        """定位描述数值来源的其一遗物。

        合作遗物（RougeProTreasure）行不携带 ServerBuildValue/DescValues，
        其 Desc 文本与同名其一遗物共用占位符模板（RLPTreasure_Desc_N 与
        RLTreasure_Desc_M 一一对应，但 N ≠ 行自身的 TreasureId）。

        游戏端按 TreasureId 查 DataMgr.RougeLikeTreasure 生成描述，此处
        优先按译后 Name 匹配同名其一遗物，其次回退到相同 TreasureId，
        二者都能给出正确占位符来源。
        """
        by_id = self._get_like_treasures()
        same_id = by_id.get(item.get("TreasureId"))
        name = self.get_translated_text(item.get("Name", ""), language)
        if not name:
            return same_id
        for like in by_id.values():
            if self.get_translated_text(like.get("Name", ""), language) == name:
                return like
        return same_id

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if not processed:
            return processed
        if "treasureRarity" in processed:
            processed["rarity"] = processed.pop("treasureRarity")
        if "treasureWeight" in processed:
            processed["weight"] = processed.pop("treasureWeight")
        if processed.get("desc"):
            desc = processed["desc"]
            like = self._get_like_treasure(item, language)
            if like:
                desc = self._process_linked_desc(like, desc, "TreasureMod")
                desc = self._replace_desc_values(
                    desc, like.get("ServerBuildValue", []), "@"
                )
            # 少数合作遗物无任何数值来源（Mod 无 DescValues/AddAttrs），
            # 其 Desc 占位符无法解析，此时回退到无占位符的 SimpleDesc。
            if re.search(r"[@$#]\d", desc):
                simple = processed.get("simpleDesc")
                if simple and not re.search(r"[@$#]\d", simple):
                    desc = simple
            processed["desc"] = desc
        return processed


class RougeProTreasureGroupProcessor(_RougeProTableProcessor):
    file_type = "RougeProTreasureGroup"
    id_field = "GroupId"
    translated_fields = ("Name", "GroupEffectDesc")


class RougeProTreasureRandomProcessor(_RougeProTableProcessor):
    file_type = "RougeProTreasureRandom"
    id_field = "TreasureRandom"


class RougeProDefenceProcessor(_RougeProTableProcessor):
    file_type = "RougePro_Defence"
    id_field = "ID"


class RougeProEventProcessor(_RougeProTableProcessor):
    file_type = "RougePro_Event"
    id_field = "ID"


class RougeProEventAreaProcessor(_RougeProTableProcessor):
    file_type = "RougePro_EventArea"
    id_field = "ID"


class RougeProExterminateProcessor(_RougeProTableProcessor):
    file_type = "RougePro_Exterminate"
    id_field = "ID"


class RougeProKillEliteMobProcessor(_RougeProTableProcessor):
    file_type = "RougePro_KillEliteMob"
    id_field = "ID"


class RougeProMSRoundProcessor(_RougeProTableProcessor):
    file_type = "RougePro_MSRound"
    id_field = "ID"


class RougeProMonsterSPProcessor(_RougeProTableProcessor):
    file_type = "RougePro_MonsterSP"
    id_field = "ID"


class RougeProOccupationProcessor(_RougeProTableProcessor):
    file_type = "RougePro_Occupation"
    id_field = "ID"


class RougeProRewardDropBoxProcessor(_RougeProTableProcessor):
    file_type = "RougePro_RewardDropBox"
    id_field = "ID"


class RougeProRoomProcessor(_RougeProTableProcessor):
    file_type = "RougePro_Room"
    id_field = "RoomId"
    dropped_fields = (
        "ArtDataPath",
        "DesignDataPath",
        "BossDeliveryDis",
        "BossDeliveryPointId",
    )

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if not processed:
            return processed
        if "roomWeight" in processed:
            processed["weight"] = processed.pop("roomWeight")
        return processed


class RougeProSabotageProProcessor(_RougeProTableProcessor):
    file_type = "RougePro_SabotagePro"
    id_field = "ID"


class RougeProSurvivalProProcessor(_RougeProTableProcessor):
    file_type = "RougePro_SurvivalPro"
    id_field = "ID"


ROUGE_PRO_PROCESSOR_CLASSES.update(
    {
        "RougeProClass": RougeProClassProcessor,
        "RougeProContract": RougeProContractProcessor,
        "RougeProConvert": RougeProConvertProcessor,
        "RougeProDifficulty": RougeProDifficultyProcessor,
        "RougeProEffect": RougeProEffectProcessor,
        "RougeProSeason": RougeProSeasonProcessor,
        "RougeProShopRandom": RougeProShopRandomProcessor,
        "RougeProTalent": RougeProTalentProcessor,
        "RougeProTreasure": RougeProTreasureProcessor,
        "RougeProTreasureGroup": RougeProTreasureGroupProcessor,
        "RougeProTreasureRandom": RougeProTreasureRandomProcessor,
        "RougePro_Defence": RougeProDefenceProcessor,
        "RougePro_Event": RougeProEventProcessor,
        "RougePro_EventArea": RougeProEventAreaProcessor,
        "RougePro_Exterminate": RougeProExterminateProcessor,
        "RougePro_KillEliteMob": RougeProKillEliteMobProcessor,
        "RougePro_MSRound": RougeProMSRoundProcessor,
        "RougePro_MonsterSP": RougeProMonsterSPProcessor,
        "RougePro_Occupation": RougeProOccupationProcessor,
        "RougePro_RewardDropBox": RougeProRewardDropBoxProcessor,
        "RougePro_Room": RougeProRoomProcessor,
        "RougePro_SabotagePro": RougeProSabotageProProcessor,
        "RougePro_SurvivalPro": RougeProSurvivalProProcessor,
    }
)
