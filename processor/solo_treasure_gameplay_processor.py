from collections import OrderedDict
from processor.base_processor import BaseProcessor


class SoloTreasureGamePlayProcessor(BaseProcessor):
    """秘宝玩法配置导出器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SoloTreasureGamePlay"
        self.monster_spawn_data = data_loader.load_json("MonsterSpawn.json")
        self.title_data = data_loader.load_json("Title.json")
        self.mechanism_data = data_loader.load_json("Mechanism.json")
        self.server_dom_static_creator_data = data_loader.load_json(
            "ServerDomLevel_data/ServerDomStaticCreator.json"
        )

    def process_item(self, item, language):
        """处理单个秘宝玩法配置"""
        game_play_id = item.get("GamePlayId", 0)
        if not game_play_id:
            return None

        processed = OrderedDict()
        processed["id"] = game_play_id

        title = item.get("Title", "")
        title_name = self.get_translated_text(title)
        if title_name and not title_name.startswith("UI_"):
            processed["name"] = title_name

        game_play_type = item.get("type", 0)
        processed["type"] = game_play_type

        countdown = item.get("CountDown")
        if countdown is not None:
            processed["cd"] = countdown

        task_gains = item.get("TaskGains")
        if task_gains is not None:
            processed["gain"] = task_gains

        spawn = self._build_spawn(item.get("MonsterSpawn"))
        if spawn:
            processed["spawn"] = spawn

        dom = self._build_dom(item)
        if dom:
            processed["dom"] = dom

        for idx in range(1, 5):
            gear_id = item.get(f"Gear{idx}")
            if gear_id:
                processed[f"g{idx}"] = gear_id

        for idx in range(1, 5):
            monster_id = item.get(f"Monster{idx}")
            if monster_id:
                processed[f"m{idx}"] = monster_id

        return processed

    def _build_spawn(self, spawn_id):
        """按 Dungeon 口径内联 MonsterSpawn。"""
        if not spawn_id:
            return None

        spawn_config = self.monster_spawn_data.get(str(spawn_id))
        if not spawn_config:
            spawn_config = self.monster_spawn_data.get(spawn_id)
        if not isinstance(spawn_config, dict):
            return None

        spawn_node = OrderedDict()
        spawn_node["id"] = spawn_config.get("UnitSpawnId", spawn_id)

        detect_time = spawn_config.get("DetectTime", 0)
        if detect_time:
            spawn_node["time"] = detect_time

        threshold = spawn_config.get("Threshold", 0)
        if threshold:
            spawn_node["th"] = threshold

        radius = [
            spawn_config.get("UnitSpawnRadiusMin", 0),
            spawn_config.get("UnitSpawnRadiusMax", 0),
            spawn_config.get("PhoneUnitSpawnRadiusMin", 0),
            spawn_config.get("PhoneUnitSpawnRadiusMax", 0),
        ]
        if any(radius):
            spawn_node["radius"] = radius

        monster_infos = []
        for monster_spawn_info in spawn_config.get("MonsterSpawnInfos", []):
            if not isinstance(monster_spawn_info, dict):
                continue
            unit_id = monster_spawn_info.get("UnitId", 0)
            if not unit_id:
                continue
            monster_info = OrderedDict()
            monster_info["id"] = unit_id
            unit_num = monster_spawn_info.get("UnitNum", 0)
            monster_info["num"] = unit_num
            unit_num_fix = monster_spawn_info.get("UnitNumFix", 0)
            if unit_num_fix != unit_num:
                monster_info["numf"] = unit_num_fix
            unit_level = monster_spawn_info.get("UnitLevel", 0)
            if unit_level:
                monster_info["lv"] = unit_level
            monster_infos.append(monster_info)

        if monster_infos:
            spawn_node["m"] = monster_infos

        relation_id = spawn_config.get("RelationId")
        if relation_id is not None:
            relation_spawn_data = self.data_loader.load_json("RelationSpawn.json")
            relation_spawn = relation_spawn_data.get(str(relation_id)) or relation_spawn_data.get(relation_id)
            if isinstance(relation_spawn, dict):
                relation_unit_ids = relation_spawn.get("UnitId", [])
                relation_weights = relation_spawn.get("UnitWeight", [])
                relation_level = relation_spawn.get("UnitLevel", 0)
                sm = []
                for index, unit_id in enumerate(relation_unit_ids):
                    sm_item = OrderedDict()
                    sm_item["id"] = unit_id
                    sm_item["w"] = relation_weights[index] if index < len(relation_weights) else 0
                    if relation_level:
                        sm_item["lv"] = relation_level
                    sm.append(sm_item)
                if sm:
                    spawn_node["sm"] = sm
                relation_spawn_total_num = relation_spawn.get("RelationSpawnTotalNum", [])
                if relation_spawn_total_num:
                    spawn_node["smnum"] = relation_spawn_total_num

        return spawn_node

    def _build_dom(self, item):
        """按 ServerDomStaticCreator + Mechanism 展开 Container。"""
        container_ids = item.get("Container", [])
        if not isinstance(container_ids, list) or not container_ids:
            return []

        dom_list = []
        for container_id in container_ids:
            creator = self._find_static_creator(container_id)
            if not isinstance(creator, dict):
                continue

            mechanism = self._get_mechanism_by_unit_id(creator.get("UnitId"))
            dom_item = OrderedDict()
            dom_item["id"] = container_id
            dom_item["type"] = creator.get("UnitType", "")
            dom_item["uid"] = creator.get("UnitId", 0)

            guide_icon = mechanism.get("GuideIconBPPath", "") if isinstance(mechanism, dict) else ""
            if guide_icon and "T_Gp_" in guide_icon:
                dom_item["icon"] = guide_icon.split("/")[-1].split(".")[0]

            tribute_id = None
            if isinstance(mechanism, dict):
                tribute_raw = mechanism.get("UnitParams", {}).get("TributeId")
                try:
                    tribute_id = int(tribute_raw) if tribute_raw is not None else None
                except (TypeError, ValueError):
                    tribute_id = None
            if tribute_id not in (None, 0):
                dom_item["tributeId"] = tribute_id

            actor_loc = creator.get("ActorLoc", {})
            if isinstance(actor_loc, dict):
                pos = [actor_loc.get("x", 0), actor_loc.get("y", 0)]
                dom_item["pos"] = pos

            dom_list.append(dom_item)
        return dom_list

    def _find_static_creator(self, container_id):
        """在 ServerDomStaticCreator 中按 StaticCreatorId 查找条目。"""
        for level_data in self.server_dom_static_creator_data.values():
            if not isinstance(level_data, dict):
                continue
            creator = level_data.get(str(container_id)) or level_data.get(container_id)
            if not isinstance(creator, dict):
                continue
            return creator
        return None

    def _get_mechanism_by_unit_id(self, unit_id):
        """按 UnitId 查找 Mechanism 配置。"""
        if unit_id is None:
            return {}
        return self.mechanism_data.get(str(unit_id)) or self.mechanism_data.get(unit_id) or {}
