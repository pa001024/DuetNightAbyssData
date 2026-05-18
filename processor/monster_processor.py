from processor.base_processor import BaseProcessor


class MonsterProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Monster"
        self.battle_monster_data = data_loader.load_json("BattleMonster.json")
        self.tab_data = data_loader.load_json("ArchiveTab.json")
        self.tab_trans = dict()
        for tab in self.tab_data:
            tab_id = tab.get("TabPara", 0)
            tab_name = tab.get("TabName", "")
            self.tab_trans[tab_id] = tab_name
        self.tab_final = {
            "Mon.Gr": 1,  # "秽兽",
            "Mon.Jt": 2,  # "海伯利亚帝国",
            "Mon.Sq": 3,  # "神弃者同盟",
            "Mon.Jh": 4,  # "艾利西安传颂会",
            "Mon.Hx": 5,  # "华胥",
        }
        self.processed_keys = set()

        # 加载GalleryRule.json数据并提取符合条件的怪物ID集合
        self.valid_monster_ids = set()
        self.gallery_rule_data = data_loader.load_json("GalleryRule.json")
        for gallery_id, gallery_info in self.gallery_rule_data.items():
            self.valid_monster_ids.add(int(gallery_id))
        dungeon_data = data_loader.load_json("Dungeon.json")

        # 加载Monster.json数据并创建UnitId到ModelId的映射
        self.unit_id_to_model_id = {}
        monster_data = data_loader.load_json("Monster.json")
        for monster_id, monster_info in monster_data.items():
            unit_id = monster_info.get("UnitId")
            model_id = monster_info.get("ModelId")
            if unit_id and model_id:
                self.unit_id_to_model_id[unit_id] = model_id

        # 创建ModelId到图标的映射
        self.model_id_to_icon = {}
        for gallery_id, gallery_info in self.gallery_rule_data.items():
            # 获取PreferredMonsterId，它应该对应怪物的UnitId
            preferred_monster_id = gallery_info.get("PreferredMonsterId")
            if preferred_monster_id:
                # 根据PreferredMonsterId获取对应的ModelId
                model_id = self.unit_id_to_model_id.get(preferred_monster_id)
                if model_id:
                    # 提取图标名称
                    if "MonsterIcon" in gallery_info:
                        monster_icon = gallery_info["MonsterIcon"]
                        if "T_Head_" in monster_icon:
                            icon_part = monster_icon.split("T_Head_")[-1]
                            if "." in icon_part:
                                icon = icon_part.split(".")[0]
                            else:
                                icon = icon_part
                            # 建立ModelId到图标的映射
                            self.model_id_to_icon[model_id] = icon

        for dungeon_id, dungeon_info in dungeon_data.items():
            # 检查DungeonID是否大于20000
            if isinstance(dungeon_id, str):
                dungeon_id_num = int(dungeon_id)
            else:
                dungeon_id_num = dungeon_id

            if dungeon_id_num > 20000:
                # 提取DungeonMonsters字段中的怪物ID
                dungeon_monsters = dungeon_info.get("DungeonMonsters", [])
                for monster_id in dungeon_monsters:
                    self.valid_monster_ids.add(monster_id)
                bp_override_vars = dungeon_info.get("BPOverrideVars", {})
                for key in ("BossID", "Elite1", "Elite2"):
                    monster_id = bp_override_vars.get(key)
                    if monster_id:
                        self.valid_monster_ids.add(monster_id)
                # 提取DungeonInitGuideUnitId字段中的怪物ID
                dungeon_init_guide_unit_id = dungeon_info.get(
                    "DungeonInitGuideUnitId", []
                )
                for monster_id in dungeon_init_guide_unit_id:
                    self.valid_monster_ids.add(monster_id)
        self._add_solo_treasure_monster_ids(data_loader)
        self._add_solo_treasure_gameplay_monster_ids(data_loader)
        self._add_solo_treasure_gameplay_spawn_monster_ids(data_loader)
        abyss_dungeon_data = data_loader.load_json("AbyssDungeon.json")
        for abyss_dungeon_id, abyss_dungeon_info in abyss_dungeon_data.items():
            # 检查AbyssDungeonID是否大于20000
            if abyss_dungeon_info.get("DungeonMonsters", []):
                for monster_id in abyss_dungeon_info.get("DungeonMonsters", []):
                    self.valid_monster_ids.add(monster_id)
        # 加载HardBossMain.json并提取MonsterId
        hard_boss_main_data = data_loader.load_json("HardBossMain.json")
        for hard_boss_info in hard_boss_main_data:
            monster_id = hard_boss_info.get("MonsterId")
            if monster_id:
                if isinstance(monster_id, list):
                    for monster_id_item in monster_id:
                        if monster_id_item:
                            self.valid_monster_ids.add(monster_id_item)
                else:
                    self.valid_monster_ids.add(monster_id)

        # 仅补充Dungeon.spawn.m/sm中会用到的怪物ID
        self._add_dungeon_spawn_monster_ids(data_loader, dungeon_data)

    def process_item(self, monster_data, language):
        id = monster_data.get("UnitId", 0)
        # 只处理在valid_monster_ids集合中的怪物ID
        if id not in self.valid_monster_ids:
            return None
        name = self.get_translated_text(monster_data.get("UnitName", ""))
        # lastname = name.split(" ")[-1]

        battle_role_id = monster_data.get("BattleRoleId", 0)

        battle_monster = self.battle_monster_data.get(str(battle_role_id), {})
        if not battle_monster:
            battle_monster = self.battle_monster_data.get(battle_role_id, {})
        def_value = battle_monster.get("DEF", 0)
        hp_value = battle_monster.get("MaxHp", 0)
        atk_value = battle_monster.get("ATK", 0)

        # unique_key = f"{lastname}_{def_value}_{hp_value}"
        # if unique_key in self.processed_keys:
        #     return None
        # self.processed_keys.add(unique_key)

        tags = monster_data.get("GamePlayTags", [])
        fact = [tag for tag in tags if tag in self.tab_trans]
        # fact = [self.get_translated_text(fact) for fact in facts]
        if len(fact) == 0:
            fact = [""]

        # 从怪物数据中获取ModelId
        icon = ""
        # 直接从当前怪物数据中获取ModelId
        model_id = monster_data.get("ModelId")

        if model_id:
            # 使用ModelId到图标的映射获取图标
            icon = self.model_id_to_icon.get(model_id, "")

        # 如果通过ModelId没有获取到图标，优先按GalleryRuleId回退
        if not icon:
            gallery_rule_id = monster_data.get("GalleryRuleId", id)
            gallery_info = self.gallery_rule_data.get(str(gallery_rule_id), {})
            if gallery_info and "MonsterIcon" in gallery_info:
                monster_icon = gallery_info["MonsterIcon"]
                # 提取T_Head_后面的值
                if "T_Head_" in monster_icon:
                    # 分割字符串，获取T_Head_后面的部分，再去掉后面的扩展名
                    icon_part = monster_icon.split("T_Head_")[-1]
                    if "." in icon_part:
                        icon = icon_part.split(".")[0]
                    else:
                        icon = icon_part

        processed = {
            "id": id,
            "n": name,
            "t": monster_data.get("BloodUIParmas", {}).get("UIStyleNodeName", ""),
            "f": self.tab_final.get(fact[0], ""),
            "atk": atk_value,
            "def": def_value,
            "es": battle_monster.get("MaxES", 0),
            "hp": hp_value,
            "tn": battle_monster.get("TN", 0),
        }

        # 如果图标不为空，添加到processed字典
        if icon:
            processed["icon"] = icon

        if not processed["t"]:
            del processed["t"]
        if processed["f"] == "":
            del processed["f"]
        if processed["es"] == 0:
            del processed["es"]
        if tags:
            processed["tags"] = tags

        return processed

    def process_all_items(self, items, language):
        self.processed_keys = set()
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed is not None:
                processed_items.append(processed)
        return processed_items

    def _add_dungeon_spawn_monster_ids(self, data_loader, dungeon_data):
        """补充Dungeon.spawn中的m/sm怪物ID"""
        monster_spawn_data = data_loader.load_json("MonsterSpawn.json")
        relation_spawn_data = data_loader.load_json("RelationSpawn.json")

        spawn_source_file_names = [
            "DefencePro.json",
            "Defence.json",
            "DefenceMove.json",
            "Survival.json",
            "SurvivalMini.json",
            "SurvivalMiniPro.json",
            "SurvivalPro.json",
            "IronSurvival.json",
            "Excavation.json",
            "ExtermPro.json",
            "Exterminate.json",
            "SabotagePro.json",
        ]

        dungeon_spawn_source_map = {}
        for file_name in spawn_source_file_names:
            file_data = data_loader.load_json(file_name)
            for item in file_data.values():
                dungeon_id = item.get("DungeonId")
                if dungeon_id:
                    dungeon_spawn_source_map[dungeon_id] = item

        for dungeon_id, dungeon_info in dungeon_data.items():
            if isinstance(dungeon_id, str):
                dungeon_id_num = int(dungeon_id)
            else:
                dungeon_id_num = dungeon_id
            if dungeon_id_num <= 20000:
                continue

            spawn_source = dungeon_spawn_source_map.get(dungeon_id_num)
            if not spawn_source:
                continue

            spawn_rule_waves = []
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("WaveSpawnRule"), split_list_items=True
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("MonsterFirstSpawnId")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("MonsterSpawnId")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("MonsterSpawnIds")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("StrongLoopSpawnId")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("OnInitSpawnRule")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("NormalSpawnRule")
            )
            self._append_spawn_rule_waves(
                spawn_rule_waves, spawn_source.get("EliteSpawnRule")
            )
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

            for spawn_rule_wave in spawn_rule_waves:
                for spawn_id in spawn_rule_wave:
                    spawn_config = monster_spawn_data.get(str(spawn_id)) or monster_spawn_data.get(spawn_id)
                    if not spawn_config:
                        continue

                    for spawn_monster in spawn_config.get("MonsterSpawnInfos", []):
                        monster_id = spawn_monster.get("UnitId")
                        if monster_id:
                            self.valid_monster_ids.add(monster_id)

                    relation_id = spawn_config.get("RelationId")
                    if relation_id is None:
                        continue
                    relation_info = relation_spawn_data.get(str(relation_id)) or relation_spawn_data.get(relation_id)
                    if not relation_info:
                        continue

                    for monster_id in relation_info.get("UnitId", []):
                        if monster_id:
                            self.valid_monster_ids.add(monster_id)

    def _add_solo_treasure_gameplay_monster_ids(self, data_loader):
        """补充SoloTreasureGamePlay中的Monster1..4怪物ID"""
        solo_treasure_gameplay_data = data_loader.load_json("SoloTreasureGamePlay.json")
        for game_play_info in solo_treasure_gameplay_data.values():
            if not isinstance(game_play_info, dict):
                continue
            for idx in range(1, 5):
                monster_id = game_play_info.get(f"Monster{idx}")
                if monster_id:
                    self.valid_monster_ids.add(monster_id)

    def _add_solo_treasure_monster_ids(self, data_loader):
        """补充SoloTreasure中RandomCreator关联的怪物ID"""
        solo_treasure_data = data_loader.load_json("SoloTreasure.json")
        random_creator_data = data_loader.load_json("RandomCreator.json")
        for solo_treasure_info in solo_treasure_data.values():
            if not isinstance(solo_treasure_info, dict):
                continue
            rainy_ids = solo_treasure_info.get("RainyRandomId", [])
            if isinstance(rainy_ids, dict):
                rainy_ids = list(rainy_ids.values())
            elif not isinstance(rainy_ids, list):
                rainy_ids = [rainy_ids] if rainy_ids else []

            for rainy_id in rainy_ids:
                rainy_info = random_creator_data.get(str(rainy_id)) or random_creator_data.get(rainy_id)
                if not isinstance(rainy_info, dict):
                    continue
                random_infos = rainy_info.get("RandomInfos", [])
                if isinstance(random_infos, dict):
                    random_infos = list(random_infos.values())
                elif not isinstance(random_infos, list):
                    random_infos = [random_infos] if random_infos else []

                for random_info in random_infos:
                    if not isinstance(random_info, dict):
                        continue
                    monster_id = random_info.get("UnitId")
                    if monster_id:
                        self.valid_monster_ids.add(monster_id)

    def _add_solo_treasure_gameplay_spawn_monster_ids(self, data_loader):
        """补充SoloTreasureGamePlay中的MonsterSpawn关联怪物ID"""
        solo_treasure_gameplay_data = data_loader.load_json("SoloTreasureGamePlay.json")
        monster_spawn_data = data_loader.load_json("MonsterSpawn.json")
        relation_spawn_data = data_loader.load_json("RelationSpawn.json")

        for game_play_info in solo_treasure_gameplay_data.values():
            if not isinstance(game_play_info, dict):
                continue

            spawn_id = game_play_info.get("MonsterSpawn")
            if not spawn_id:
                continue

            spawn_config = monster_spawn_data.get(str(spawn_id)) or monster_spawn_data.get(spawn_id)
            if not isinstance(spawn_config, dict):
                continue

            for spawn_monster in spawn_config.get("MonsterSpawnInfos", []):
                if not isinstance(spawn_monster, dict):
                    continue
                monster_id = spawn_monster.get("UnitId")
                if monster_id:
                    self.valid_monster_ids.add(monster_id)

            relation_id = spawn_config.get("RelationId")
            if relation_id is None:
                continue
            relation_info = relation_spawn_data.get(str(relation_id)) or relation_spawn_data.get(relation_id)
            if not isinstance(relation_info, dict):
                continue
            for monster_id in relation_info.get("UnitId", []):
                if monster_id:
                    self.valid_monster_ids.add(monster_id)

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
