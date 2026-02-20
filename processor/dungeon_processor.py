from processor.base_processor import BaseProcessor


class DungeonProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Dungeon"
        # 加载必要的配置数据
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        # 加载BattleMonster数据用于处理怪物列表
        self.battle_monster_data = data_loader.load_json("BattleMonster.json")
        self.monster_data = data_loader.load_json("Monster.json")
        # 加载ModDungeonMonReward数据用于处理奖励
        self.mod_dungeon_mon_reward_data = data_loader.load_json(
            "ModDungeonMonReward.json"
        )
        self.monster_spawn_data = data_loader.load_json("MonsterSpawn.json")
        self.relation_spawn_data = data_loader.load_json("RelationSpawn.json")
        self.spawn_source_file_names = [
            "DefencePro.json",
            "Defence.json",
            "DefenceMove.json",
            "Survival.json",
            "SurvivalMini.json",
            "SurvivalMiniPro.json",
            "SurvivalPro.json",
            "Excavation.json",
            "ExtermPro.json",
            "Exterminate.json",
            "SabotagePro.json",
        ]
        self.dungeon_spawn_source_map = {}
        for file_name in self.spawn_source_file_names:
            file_data = data_loader.load_json(file_name)
            for item in file_data.values():
                dungeon_id = item.get("DungeonId")
                if dungeon_id and dungeon_id not in self.dungeon_spawn_source_map:
                    self.dungeon_spawn_source_map[dungeon_id] = item

        self.e_map = {
            "Dark": "暗",
            "Light": "光",
            "Water": "水",
            "Fire": "火",
            "Thunder": "雷",
            "Wind": "风",
        }

    def process_item(self, dungeon_data, language):
        """处理单个Dungeon数据

        Args:
            dungeon_data: Dungeon数据
            language: 语言代码

        Returns:
            处理后的Dungeon数据
        """
        dungeon_id = dungeon_data.get("DungeonID", 0)
        if not dungeon_id or dungeon_id < 20000:
            return None

        # 获取翻译后的Dungeon名称
        dungeon_name_key = dungeon_data.get("DungeonName", "")
        dungeon_name = self.get_translated_text(dungeon_name_key)
        if dungeon_name.startswith("DUNGEON_NAME_"):
            return None

        # 构建基础处理后的Dungeon数据
        processed = {
            "id": dungeon_id,
            "n": dungeon_name,
            "t": dungeon_data.get("DungeonType", ""),
            "e": self.e_map.get(dungeon_data.get("AttributeType", ""), ""),
            "ts": self.get_translated_text(dungeon_data.get("DungeonTypeShow", "")),
            "lv": dungeon_data.get("DungeonLevel", 0),
            # "地图文件": dungeon_data.get("DungeonMapFile", ""),
            "rd": dungeon_data.get("IsRandom", 0),
        }
        if not processed["e"]:
            del processed["e"]

        if processed["ts"].startswith("DUNGEON_NAME_") or processed["ts"] == "":
            del processed["ts"]

        # 处理Dungeon描述
        if "DungeonDes" in dungeon_data:
            processed["desc"] = self.get_translated_text(dungeon_data.get("DungeonDes"))

        # 处理DungeonBGM
        # if "DungeonBGM" in dungeon_data:
        #     processed["背景音乐"] = dungeon_data.get("DungeonBGM")

        if "DungeonInitGuideUnitId" in dungeon_data:
            dungeon_monsters = dungeon_data.get("DungeonInitGuideUnitId", [])
            if dungeon_monsters:
                processed["sm"] = dungeon_monsters

                # 处理sr字段：收集符合条件的DungeonDropReward
                sr = []
                for monster_id in dungeon_monsters:
                    # 遍历ModDungeonMonReward中的所有条目
                    for reward_entry in self.mod_dungeon_mon_reward_data.values():
                        # 检查MonsterUnitId是否匹配，并且当前DungeonID在DungeonList中
                        if reward_entry.get(
                            "MonsterUnitId"
                        ) == monster_id and dungeon_id in reward_entry.get(
                            "DungeonList", []
                        ):
                            # 添加DungeonDropReward到sr列表
                            sr.append(reward_entry.get("DungeonDropReward"))

                # 如果sr列表不为空，添加到处理结果中
                if sr:
                    processed["sr"] = sr

        # 处理DungeonMonsters
        if "DungeonMonsters" in dungeon_data:
            dungeon_monsters = dungeon_data.get("DungeonMonsters", [])

            processed["m"] = dungeon_monsters
        else:
            return None

        # 处理副本怪物刷新波次
        spawn_data = self._get_dungeon_spawn(dungeon_id)
        if spawn_data:
            processed["spawn"] = spawn_data

        # 处理DungeonReward
        if "DungeonReward" in dungeon_data:
            processed["r"] = dungeon_data.get("DungeonReward", [])
            if len(processed["r"]) == 1 and processed["r"][0] == 50100:
                return None

        # 处理DungeonUIBG
        # if "DungeonUIBG" in dungeon_data:
        #     processed["UI背景"] = dungeon_data.get("DungeonUIBG")

        # 处理DungeonWinMode
        if "DungeonWinMode" in dungeon_data:
            processed["win"] = dungeon_data.get("DungeonWinMode")

        # 处理EnableTacmap
        # if "EnableTacmap" in dungeon_data:
        #     processed["启用战术地图"] = dungeon_data.get("EnableTacmap")

        return processed

    def _get_dungeon_spawn(self, dungeon_id):
        """根据副本配置获取怪物刷新波次"""
        spawn_source = self.dungeon_spawn_source_map.get(dungeon_id)
        if not spawn_source:
            return []

        spawn_rule_waves = []
        self._append_spawn_rule_waves(
            spawn_rule_waves, spawn_source.get("WaveSpawnRule"), split_list_items=True
        )
        self._append_spawn_rule_waves(
            spawn_rule_waves, spawn_source.get("MonsterFirstSpawnId")
        )
        self._append_spawn_rule_waves(spawn_rule_waves, spawn_source.get("MonsterSpawnId"))
        self._append_spawn_rule_waves(spawn_rule_waves, spawn_source.get("MonsterSpawnIds"))
        self._append_spawn_rule_waves(spawn_rule_waves, spawn_source.get("OnInitSpawnRule"))
        self._append_spawn_rule_waves(spawn_rule_waves, spawn_source.get("NormalSpawnRule"))
        self._append_spawn_rule_waves(spawn_rule_waves, spawn_source.get("EliteSpawnRule"))
        self._append_spawn_rule_waves(
            spawn_rule_waves, spawn_source.get("SpMonsterSpawnId")
        )
        for sp_monster_info in spawn_source.get("SpMonster", []):
            self._append_spawn_rule_waves(
                spawn_rule_waves, sp_monster_info.get("SpMonsterSpawnId")
            )
        for excavation_info in spawn_source.get("Excavation", []):
            self._append_spawn_rule_waves(
                spawn_rule_waves, excavation_info.get("MonsterSpawnId")
            )

        spawn_waves = []
        for spawn_rule_wave in spawn_rule_waves:
            spawn_nodes = self._convert_spawn_ids_to_nodes(spawn_rule_wave)
            if spawn_nodes:
                spawn_waves.append(spawn_nodes)
        return spawn_waves

    def _append_spawn_rule_waves(
        self, target_waves, raw_spawn_rule, split_list_items=False
    ):
        """将不同格式的刷怪规则统一追加到波次列表"""
        if raw_spawn_rule is None:
            return

        if isinstance(raw_spawn_rule, list):
            if not raw_spawn_rule:
                return
            if isinstance(raw_spawn_rule[0], list):
                for wave in raw_spawn_rule:
                    if wave:
                        target_waves.append(wave)
                return
            if split_list_items:
                for spawn_id in raw_spawn_rule:
                    target_waves.append([spawn_id])
                return
            target_waves.append(raw_spawn_rule)
            return

        target_waves.append([raw_spawn_rule])

    def _convert_spawn_ids_to_nodes(self, spawn_ids):
        """将一波中的MonsterSpawnId列表转换为刷怪点配置列表"""
        spawn_nodes = []
        for spawn_id in spawn_ids:
            spawn_config = self.monster_spawn_data.get(
                str(spawn_id)
            ) or self.monster_spawn_data.get(spawn_id)
            if not spawn_config:
                continue

            spawn_node = {
                "id": spawn_config.get("UnitSpawnId", spawn_id),
                "time": spawn_config.get("DetectTime", 0),
                "th": spawn_config.get("Threshold", 0),
                "radius": [
                    spawn_config.get("UnitSpawnRadiusMin", 0),
                    spawn_config.get("UnitSpawnRadiusMax", 0),
                    spawn_config.get("PhoneUnitSpawnRadiusMin", 0),
                    spawn_config.get("PhoneUnitSpawnRadiusMax", 0),
                ],
                "m": [],
            }

            for monster_spawn_info in spawn_config.get("MonsterSpawnInfos", []):
                unit_num = monster_spawn_info.get("UnitNum", 0)
                unit_num_fix = monster_spawn_info.get("UnitNumFix", 0)
                monster_info = {
                    "id": monster_spawn_info.get("UnitId", 0),
                    "num": unit_num,
                }
                if unit_num_fix != unit_num:
                    monster_info["numf"] = unit_num_fix
                unit_level = monster_spawn_info.get("UnitLevel", 0)
                if unit_level:
                    monster_info["lv"] = unit_level
                spawn_node["m"].append(monster_info)

            relation_id = spawn_config.get("RelationId")
            if relation_id is not None:
                relation_spawn = self.relation_spawn_data.get(
                    str(relation_id)
                ) or self.relation_spawn_data.get(relation_id)
                if relation_spawn:
                    relation_unit_ids = relation_spawn.get("UnitId", [])
                    relation_weights = relation_spawn.get("UnitWeight", [])
                    relation_level = relation_spawn.get("UnitLevel", 0)

                    sm = []
                    for index, unit_id in enumerate(relation_unit_ids):
                        sm_item = {"id": unit_id}
                        if index < len(relation_weights):
                            sm_item["w"] = relation_weights[index]
                        else:
                            sm_item["w"] = 0
                        if relation_level:
                            sm_item["lv"] = relation_level
                        sm.append(sm_item)

                    if sm:
                        spawn_node["sm"] = sm

                    relation_spawn_total_num = relation_spawn.get(
                        "RelationSpawnTotalNum", []
                    )
                    if relation_spawn_total_num:
                        spawn_node["smnum"] = relation_spawn_total_num

            spawn_nodes.append(spawn_node)
        return spawn_nodes
