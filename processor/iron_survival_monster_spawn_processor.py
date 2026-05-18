from collections import OrderedDict

from processor.base_processor import BaseProcessor


class IronSurvivalMonsterSpawnProcessor(BaseProcessor):
    GROUP_SPAWN_FIELD_MAP = {
        "GroupUnitSpawnCenterRange": "gr",
        "GroupThreshold": "gth",
        "GroupReplenishInterval": "gri",
        "GroupInitUnitSpawnCenterRange": "gir",
        "GroupDetectDelayTime": "gdt",
        "GroupDetectTime": "gt",
        "GroupLimit": "gl",
        "GroupRadius": "gar",
        "GroupRangeZ": "gz",
    }

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "IronSurvivalMonsterSpawn"
        self.iron_survival_data = data_loader.load_json("IronSurvival.json")
        self.monster_spawn_data = data_loader.load_json("MonsterSpawn.json")
        self.monster_group_data = data_loader.load_json("MonsterGroup.json")
        self.monster_group_spawn_data = data_loader.load_json("MonsterGroupSpawn.json")
        self.relation_spawn_data = data_loader.load_json("RelationSpawn.json")
        self.valid_spawn_ids = self._collect_valid_spawn_ids()

    def _collect_valid_spawn_ids(self):
        """收集 IronSurvival 实际引用到的 MonsterSpawnId。"""
        valid_spawn_ids = set()
        for dungeon_info in self.iron_survival_data.values():
            if not isinstance(dungeon_info, dict):
                continue
            self._collect_spawn_ids(valid_spawn_ids, dungeon_info.get("MonsterSpawnId"))
            self._collect_spawn_ids(valid_spawn_ids, dungeon_info.get("StrongLoopSpawnId"))
        return valid_spawn_ids

    def _collect_spawn_ids(self, target_ids, value):
        """递归展开列表形式的刷怪 id。"""
        if value is None:
            return

        if isinstance(value, dict):
            for item in value.values():
                self._collect_spawn_ids(target_ids, item)
            return

        if isinstance(value, list):
            for item in value:
                self._collect_spawn_ids(target_ids, item)
            return

        try:
            target_ids.add(int(value))
        except (TypeError, ValueError):
            pass

    def process_item(self, item_data, language):
        """仅保留 IronSurvival 引用的 MonsterSpawn 条目。"""
        if not isinstance(item_data, dict):
            return None

        spawn_id = item_data.get("UnitSpawnId")
        if spawn_id is None:
            return None

        try:
            spawn_id = int(spawn_id)
        except (TypeError, ValueError):
            return None

        if spawn_id not in self.valid_spawn_ids:
            return None

        return self._build_spawn_node(item_data, spawn_id)

    def process_all_items(self, items, language):
        """按 id 排序输出过滤后的 MonsterSpawn 条目。"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        processed_items.sort(key=lambda x: x.get("id", 0))
        return processed_items

    def _build_spawn_node(self, spawn_config, fallback_spawn_id):
        """按 Dungeon 口径构造刷怪节点。"""
        spawn_node = OrderedDict()
        spawn_node["id"] = spawn_config.get("UnitSpawnId", fallback_spawn_id)

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
            relation_spawn = self.relation_spawn_data.get(str(relation_id)) or self.relation_spawn_data.get(relation_id)
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

        if spawn_config.get("OpenGroupSpawn"):
            self._append_group_spawn_info(spawn_node, spawn_config)

        return spawn_node

    def _append_group_spawn_info(self, spawn_node, spawn_config):
        """补充组刷怪信息，保持与 Dungeon 口径一致。"""
        group_spawn_id = spawn_config.get("GroupSpawnId") or spawn_config.get("UnitSpawnId")
        if not group_spawn_id:
            return

        group_spawn = self.monster_group_spawn_data.get(str(group_spawn_id)) or self.monster_group_spawn_data.get(group_spawn_id)
        if not group_spawn:
            return

        group_ids = group_spawn.get("MonsterGroupIds", [])
        group_numbers = group_spawn.get("GroupNumber", [])
        group_weights = group_spawn.get("GroupWeight", [])
        group_levels = group_spawn.get("GroupLevel", [])

        group_spawn_infos = []
        for index, group_id in enumerate(group_ids):
            group_info = OrderedDict()
            group_info["id"] = group_id
            if index < len(group_numbers):
                group_info["num"] = group_numbers[index]
            if index < len(group_weights):
                group_info["w"] = group_weights[index]
            if index < len(group_levels):
                group_info["lv"] = group_levels[index]
            group_info["m"] = self._get_monster_group_members(group_id)
            for field_name, short_name in self.GROUP_SPAWN_FIELD_MAP.items():
                if field_name in group_spawn:
                    group_info[short_name] = group_spawn.get(field_name)
            group_spawn_infos.append(group_info)

        if group_spawn_infos:
            spawn_node["mg"] = group_spawn_infos

    def _get_monster_group_members(self, group_id):
        """展开 MonsterGroup 为真实怪物成员列表。"""
        group_data = self.monster_group_data.get(str(group_id)) or self.monster_group_data.get(group_id)
        if not group_data:
            return []

        members = []
        for member in group_data.get("MemberSpawnProb", []):
            if not isinstance(member, dict):
                continue
            member_info = OrderedDict()
            member_info["id"] = member.get("UnitId", 0)
            unit_prob = member.get("UnitProb", 0)
            if unit_prob and unit_prob != 1:
                member_info["p"] = unit_prob
            members.append(member_info)
        return members
