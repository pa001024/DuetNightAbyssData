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

    def process_item(self, monster_data, language):
        id = monster_data.get("UnitId", 0)
        if id < 6000000 or id > 20000000:
            return None
        name = self.get_translated_text(monster_data.get("UnitName", ""))
        if "待包装" in name or "召唤物" in name or "Mon_Name_" in name:
            return None
        lastname = name.split(" ")[-1]
        bt = monster_data.get("BT", "")
        if "_SP_" in bt or "_AChess01" in bt or "_Tem" in bt or "_DYN" in bt:
            return None
        if "_St" in bt:
            name += "(剧情)"

        battle_role_id = monster_data.get("BattleRoleId", 0)

        battle_monster = self.battle_monster_data.get(str(battle_role_id), {})
        if not battle_monster:
            battle_monster = self.battle_monster_data.get(battle_role_id, {})
        def_value = battle_monster.get("DEF", 0)
        hp_value = battle_monster.get("MaxHp", 0)
        atk_value = battle_monster.get("ATK", 0)

        if def_value == 0 or def_value > 1000:
            return None

        unique_key = f"{lastname}_{def_value}_{hp_value}"
        if unique_key in self.processed_keys:
            return None
        self.processed_keys.add(unique_key)

        tags = monster_data.get("GamePlayTags", [])
        fact = [tag for tag in tags if tag in self.tab_trans]
        # fact = [self.get_translated_text(fact) for fact in facts]
        if len(fact) == 0:
            fact = [""]

        processed = {
            "id": id,
            "名称": name.replace("凛霜 ", "[号令者]"),
            "阵营": self.tab_final.get(fact[0], ""),
            "攻击": atk_value,
            "防御": def_value,
            "护盾": battle_monster.get("MaxES", 0),
            "生命": hp_value,
            "战姿": battle_monster.get("MaxTN", 0),
        }
        if processed["阵营"] == "":
            del processed["阵营"]
        if processed["护盾"] == 0:
            del processed["护盾"]

        return processed

    def process_all_items(self, items, language):
        self.processed_keys = set()
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed is not None:
                processed_items.append(processed)
        return processed_items
