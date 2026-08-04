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

    def _get_mod_processor(self):
        if self._mod_processor is None:
            self._mod_processor = ModProcessor(self.data_loader)
        return self._mod_processor

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
            "blessingRarity": item.get("BlessingRarity", 0),
            "blessingWeight": item.get("BlessingWeight", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "modEquip": item.get("ModEquip", ""),
            "roomCondition": self._camelize_value(item.get("Condition", [])),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "typeIcon": self._shorten_icon(item.get("TypeIcon", "")),
            "endPoints": self._camelize_value(item.get("EndPoints", [])),
            "shopPrices": item.get("ShopPrices", 0),
            "rlArchiveId": item.get("RLArchiveId", 0),
            "unlockConditionText": self.get_translated_text(
                item.get("UnlockConditionText", ""), language
            ),
            "canSell": item.get("CanSell", 0),
        }


class RougeLikeContractProcessor(RougeProcessor):
    """迷津契约处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeContract"

    def process_item(self, item, language):
        """处理单个契约数据"""
        desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._replace_desc_values(desc, item.get("DescValues", []), "#")
        return {
            "id": item.get("Id", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "descValues": self._camelize_value(item.get("DescValues", [])),
            "globalPassiveId": item.get("GlobalPassiveId", 0),
            "heatValue": item.get("HeatValue", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "maxLevel": item.get("MaxLevel", 0),
        }


class RougeLikeRoomProcessor(RougeProcessor):
    """迷津房间处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeRoom"

    def process_item(self, item, language):
        """处理单个房间数据"""
        return {
            "id": item.get("RoomId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "roomType": item.get("RoomType", 0),
            "roomSubType": item.get("RoomSubType", 0),
            "roomWeight": item.get("RoomWeight", 0),
            "roomCondition": self._camelize_value(item.get("RoomCondition", [])),
            "blessingAward": item.get("BlessingAward", 0),
            "tokenAward": item.get("TokenAward", 0),
            "endPointsBase": item.get("EndPointsBase", 0),
            "endPointsExtras": item.get("EndPointsExtras", 0),
            "eventMainIcon": item.get("EventMainIcon", ""),
            "settlementEventMainIcon": item.get("SettlementEventMainIcon", ""),
            "eventSelect": self._camelize_value(item.get("EventSelect", [])),
            "eventStoryline": item.get("EventStoryline", ""),
            "rlArchiveSubId": item.get("RLArchiveSubId", 0),
        }


class RougeLikeStoryEventProcessor(RougeProcessor):
    """迷津故事事件处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeStoryEvent"

    def process_item(self, item, language):
        """处理单个故事事件数据"""
        return {
            "id": item.get("Id", 0),
            "storyEventName": self.get_translated_text(
                item.get("StoryEventName", ""), language
            ),
            "storyEventType": self.get_translated_text(
                item.get("StoryEventType", ""), language
            ),
            "eventCondition": self._camelize_value(item.get("EventCondition", [])),
            "eventMainIcon": item.get("EventMainIcon", ""),
            "eventMoment": item.get("EventMoment", 0),
            "eventMinRoom": item.get("EventMinRoom", 0),
            "eventProbability": self._camelize_value(
                item.get("EventProbability", [])
            ),
            "eventStoryline": item.get("EventStoryline", ""),
            "rlArchiveSubId": item.get("RLArchiveSubId", 0),
            "cutOffEvent": item.get("CutOffEvent", False),
        }


class RougeLikeTalentProcessor(RougeProcessor):
    """迷津天赋处理器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTalent"

    def process_item(self, item, language):
        """处理单个天赋数据"""
        desc = self.get_translated_text(item.get("Desc", ""), language)
        desc = self._process_linked_desc(item, desc, "TalentMod")
        desc = self._replace_desc_values(
            desc, item.get("ServerBuildValue", []), "@"
        )
        return {
            "id": item.get("TalentId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "branch": item.get("Branch", 0),
            "type": item.get("Type", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "levelUpPoint": item.get("LevelUpPoint", 0),
            "modEquip": item.get("ModEquip", ""),
            "talentMod": item.get("TalentMod", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "iconLoc": self._camelize_value(item.get("IconLoc", [])),
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
        desc = self._replace_desc_values(
            desc, item.get("ServerBuildValue", []), "@"
        )
        return {
            "id": item.get("TreasureId", 0),
            "name": self.get_translated_text(item.get("Name", ""), language),
            "desc": desc,
            "simpleDesc": self.get_translated_text(
                item.get("SimpleDesc", ""), language
            ),
            "ipDesc": self.get_translated_text(item.get("IPDesc", ""), language),
            "treasureGroup": item.get("TreasureGroup", 0),
            "treasureRarity": item.get("TreasureRarity", 0),
            "treasureWeight": item.get("TreasureWeight", 0),
            "maxLevel": item.get("MaxLevel", 0),
            "modEquip": item.get("ModEquip", ""),
            "treasureMod": item.get("TreasureMod", 0),
            "icon": self._shorten_icon(item.get("Icon", "")),
            "endPoints": self._camelize_value(item.get("EndPoints", [])),
            "shopPrices": item.get("ShopPrices", 0),
            "roomCondition": self._camelize_value(item.get("Condition", [])),
            "rlArchiveId": item.get("RLArchiveId", 0),
            "unlockConditionText": self.get_translated_text(
                item.get("UnlockConditionText", ""), language
            ),
            "canSell": item.get("CanSell", 0),
            "clientBuild": self._camelize_value(item.get("ClientBuild", {})),
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

        for source_key, value in item.items():
            target_key = self._to_camel_case(source_key)
            if source_key == "UnLock":
                target_key = "unlock"
            if target_key == "id":
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


class RougeProEffectProcessor(_RougeProTableProcessor):
    file_type = "RougeProEffect"
    id_field = "Id"


class RougeProSeasonProcessor(_RougeProTableProcessor):
    file_type = "RougeProSeason"
    id_field = "SeasonId"
    dropped_fields = (
        "AutoNextRoundTime",
        "CollectRegionRefreshCD",
        "CowEventTime",
        "DeadDeductScore",
        "DeadDeductScoreDeadTimes",
        "MRTCost",
        "MRTLimitTimes",
        "RegionUnlockTime",
        "RewardCollectTime",
        "RewardMonsterSpawnRule",
        "RewardStageTime",
        "ShopRandom",
    )


class RougeProShopRandomProcessor(_RougeProTableProcessor):
    file_type = "RougeProShopRandom"
    id_field = "ShopRandom"


class RougeProTalentProcessor(_RougeProTableProcessor):
    file_type = "RougeProTalent"
    id_field = "TalentId"
    translated_fields = ("Name", "Desc")

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if processed and processed.get("desc"):
            desc = self._process_linked_desc(
                item, processed["desc"], "TalentMod"
            )
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
        "UnlockConditionText",
    )

    def process_item(self, item, language):
        processed = super().process_item(item, language)
        if processed and processed.get("desc"):
            desc = self._process_linked_desc(
                item, processed["desc"], "TreasureMod"
            )
            processed["desc"] = self._replace_desc_values(
                desc, item.get("ServerBuildValue", []), "@"
            )
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
    dropped_fields = ("ArtDataPath", "DesignDataPath")


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
