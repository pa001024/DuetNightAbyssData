from processor.base_processor import BaseProcessor


class RougeProcessor(BaseProcessor):
    """迷津处理器基类"""
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Rouge"


class RougeLikeBlessingProcessor(RougeProcessor):
    """迷津祝福处理器"""
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeBlessing"

    def process_item(self, item, language):
        """处理单个祝福数据"""
        return {
            "id": item.get("BlessingId", 0),
            "name": self.get_translated_text(item.get("Name", "")),
            "desc": self.get_translated_text(item.get("Desc", "")),
            "simple_desc": self.get_translated_text(item.get("SimpleDesc", "")),
            "blessing_group": item.get("BlessingGroup", 0),
            "blessing_rarity": item.get("BlessingRarity", 0),
            "blessing_weight": item.get("BlessingWeight", 0),
            "max_level": item.get("MaxLevel", 0),
            "mod_equip": item.get("ModEquip", ""),
            "room_condition": item.get("Condition", []),
            "icon": item.get("Icon", ""),
            "type_icon": item.get("TypeIcon", ""),
            "end_points": item.get("EndPoints", []),
            "level_up_prices": item.get("LevelUpPrices", []),
            "shop_prices": item.get("ShopPrices", 0),
            "shop_weight": item.get("ShopWeight", 0),
            "refresh_weight_add": item.get("RefreshWeightAdd", 0),
            "weight_add": item.get("WeightAdd", 0),
            "group_priority": item.get("GroupPriority", 0),
            "explanation_id": item.get("ExplanationId", []),
            "rl_archive_id": item.get("RLArchiveId", 0),
            "unlock_condition_text": self.get_translated_text(item.get("UnlockConditionText", "")),
            "can_sell": item.get("CanSell", 0)
        }


class RougeLikeContractProcessor(RougeProcessor):
    """迷津契约处理器"""
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeContract"

    def process_item(self, item, language):
        """处理单个契约数据"""
        return {
            "id": item.get("Id", 0),
            "name": self.get_translated_text(item.get("Name", "")),
            "desc": self.get_translated_text(item.get("Desc", "")),
            "desc_values": item.get("DescValues", []),
            "global_passive_id": item.get("GlobalPassiveId", 0),
            "heat_value": item.get("HeatValue", 0),
            "icon": item.get("Icon", ""),
            "max_level": item.get("MaxLevel", 0),
            "room_type": item.get("RoomType", []),
            "unit_id": item.get("UnitId", []),
            "unit_num": item.get("UnitNum", []),
            "unit_type": item.get("UnitType", ""),
            "explanation_id": item.get("ExplanationId", []),
            "server_build": item.get("ServerBuild", [])
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
            "name": self.get_translated_text(item.get("Name", "")),
            "room_type": item.get("RoomType", 0),
            "room_sub_type": item.get("RoomSubType", 0),
            "room_weight": item.get("RoomWeight", 0),
            "room_condition": item.get("RoomCondition", []),
            "blessing_award": item.get("BlessingAward", 0),
            "token_award": item.get("TokenAward", 0),
            "end_points_base": item.get("EndPointsBase", 0),
            "end_points_extras": item.get("EndPointsExtras", 0),
            "art_data_path": item.get("ArtDataPath", ""),
            "design_data_path": item.get("DesignDataPath", ""),
            "game_mode_path": item.get("GameModePath", ""),
            "event_main_icon": item.get("EventMainIcon", ""),
            "settlement_event_main_icon": item.get("SettlementEventMainIcon", ""),
            "event_select": item.get("EventSelect", []),
            "event_storyline": item.get("EventStoryline", ""),
            "rl_archive_sub_id": item.get("RLArchiveSubId", 0)
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
            "story_event_name": self.get_translated_text(item.get("StoryEventName", "")),
            "story_event_type": self.get_translated_text(item.get("StoryEventType", "")),
            "event_condition": item.get("EventCondition", []),
            "event_main_icon": item.get("EventMainIcon", ""),
            "event_moment": item.get("EventMoment", 0),
            "event_min_room": item.get("EventMinRoom", 0),
            "event_probability": item.get("EventProbability", []),
            "event_storyline": item.get("EventStoryline", ""),
            "rl_archive_sub_id": item.get("RLArchiveSubId", 0),
            "cut_off_event": item.get("CutOffEvent", False)
        }


class RougeLikeTalentProcessor(RougeProcessor):
    """迷津天赋处理器"""
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTalent"

    def process_item(self, item, language):
        """处理单个天赋数据"""
        return {
            "id": item.get("TalentId", 0),
            "name": self.get_translated_text(item.get("Name", "")),
            "desc": self.get_translated_text(item.get("Desc", "")),
            "branch": item.get("Branch", 0),
            "type": item.get("Type", 0),
            "max_level": item.get("MaxLevel", 0),
            "level_up_point": item.get("LevelUpPoint", 0),
            "mod_equip": item.get("ModEquip", ""),
            "talent_mod": item.get("TalentMod", 0),
            "icon": item.get("Icon", ""),
            "icon_loc": item.get("IconLoc", []),
            "unlock": item.get("UnLock", []),
            "server_build": item.get("ServerBuild", []),
            "server_build_value": item.get("ServerBuildValue", [])
        }


class RougeLikeTreasureProcessor(RougeProcessor):
    """迷津宝藏处理器"""
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RougeLikeTreasure"

    def process_item(self, item, language):
        """处理单个宝藏数据"""
        return {
            "id": item.get("TreasureId", 0),
            "name": self.get_translated_text(item.get("Name", "")),
            "desc": self.get_translated_text(item.get("Desc", "")),
            "simple_desc": self.get_translated_text(item.get("SimpleDesc", "")),
            "ip_desc": self.get_translated_text(item.get("IPDesc", "")),
            "treasure_group": item.get("TreasureGroup", 0),
            "treasure_rarity": item.get("TreasureRarity", 0),
            "treasure_weight": item.get("TreasureWeight", 0),
            "max_level": item.get("MaxLevel", 0),
            "mod_equip": item.get("ModEquip", ""),
            "treasure_mod": item.get("TreasureMod", 0),
            "icon": item.get("Icon", ""),
            "end_points": item.get("EndPoints", []),
            "shop_prices": item.get("ShopPrices", 0),
            "shop_weight": item.get("ShopWeight", 0),
            "room_condition": item.get("Condition", []),
            "server_build": item.get("ServerBuild", []),
            "server_build_value": item.get("ServerBuildValue", []),
            "rl_archive_id": item.get("RLArchiveId", 0),
            "unlock_condition_text": self.get_translated_text(item.get("UnlockConditionText", "")),
            "can_sell": item.get("CanSell", 0),
            "client_build": item.get("ClientBuild", {})
        }
