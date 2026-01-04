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

        # 构建基础处理后的Dungeon数据
        processed = {
            "id": dungeon_id,
            "n": dungeon_name,
            "t": dungeon_data.get("DungeonType", ""),
            "ts": self.get_translated_text(dungeon_data.get("DungeonTypeShow", "")),
            "lv": dungeon_data.get("DungeonLevel", 0),
            # "地图文件": dungeon_data.get("DungeonMapFile", ""),
            "rd": dungeon_data.get("IsRandom", 0),
        }

        if processed["ts"].startswith("DUNGEON_NAME_"):
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
        # 处理DungeonReward
        if "DungeonReward" in dungeon_data:
            processed["r"] = dungeon_data.get("DungeonReward", [])

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
