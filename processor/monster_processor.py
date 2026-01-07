from processor.base_processor import BaseProcessor


class MonsterProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Monster"
        self.battle_monster_data = data_loader.load_json("BattleMonster.json")
        self.tab_data = data_loader.load_json("ArchiveTab.json", use_i18n=True)
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

        # 加载Dungeon.json数据并提取符合条件的怪物ID集合
        self.valid_monster_ids = set()
        ga = data_loader.load_json("GalleryRule.json")
        for gallery_id, gallery_info in ga.items():
            self.valid_monster_ids.add(int(gallery_id))
        dungeon_data = data_loader.load_json("Dungeon.json")

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
                # 提取DungeonInitGuideUnitId字段中的怪物ID
                dungeon_init_guide_unit_id = dungeon_info.get(
                    "DungeonInitGuideUnitId", []
                )
                for monster_id in dungeon_init_guide_unit_id:
                    self.valid_monster_ids.add(monster_id)
        abyss_dungeon_data = data_loader.load_json("AbyssDungeon.json")
        for abyss_dungeon_id, abyss_dungeon_info in abyss_dungeon_data.items():
            # 检查AbyssDungeonID是否大于20000
            if abyss_dungeon_info.get("DungeonMonsters", []):
                for monster_id in abyss_dungeon_info.get("DungeonMonsters", []):
                    self.valid_monster_ids.add(monster_id)

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
        if not processed["t"]:
            del processed["t"]
        if processed["f"] == "":
            del processed["f"]
        if processed["es"] == 0:
            del processed["es"]

        return processed

    def process_all_items(self, items, language):
        self.processed_keys = set()
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed is not None:
                processed_items.append(processed)
        return processed_items
