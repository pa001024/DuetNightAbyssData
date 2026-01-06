from processor.base_processor import BaseProcessor


class AbyssDungeonProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "AbyssDungeon"
        # 加载Dungeon数据用于关联查询
        self.dungeon_data = data_loader.load_json("Dungeon.json")
        # 加载AbyssBuff数据用于关联查询
        self.abyss_buff_data = data_loader.load_json("AbyssBuff.json")
        # 加载Buff数据用于处理MonsterBuff
        self.buff_data = data_loader.load_json("Buff.json")
        # 加载AbyssSeason数据用于关联查询
        self.abyss_season_data = data_loader.load_json("AbyssSeason.json")
        # 加载AbyssSeasonList数据用于关联查询
        self.abyss_season_list_data = data_loader.load_json("AbyssSeasonList.json")
        # 加载AbyssLevel数据用于关联查询
        self.abyss_level_data = data_loader.load_json("AbyssLevel.json")
        # 加载AbyssRewardList数据用于关联查询
        self.abyss_reward_list_data = data_loader.load_json("AbyssRewardList.json")
        # 元素类型映射
        self.element_map = {
            "FireDamagedRate": "火",
            "WaterDamagedRate": "水",
            "WindDamagedRate": "风",
            "ThunderDamagedRate": "雷",
            "DarkDamagedRate": "暗",
            "LightDamagedRate": "光",
        }
        # 英文属性名到中文的映射（用于AttributeType字段）
        self.attribute_name_map = {
            "Fire": "火",
            "Water": "水",
            "Wind": "风",
            "Thunder": "雷",
            "Dark": "暗",
            "Light": "光",
        }

    def _find_season_by_abyss_dungeon_id(self, abyss_dungeon_id):
        """通过AbyssDungeonId查找对应的赛季信息

        Args:
            abyss_dungeon_id: AbyssDungeon ID

        Returns:
            (AbyssSeason, AbyssSeasonList, AbyssLevel) 元组，找不到返回 (None, None, None)
        """
        # 通过AbyssDungeonId找到对应的AbyssLevel
        abyss_level = None
        for level_data in self.abyss_level_data.values():
            if (
                level_data.get("AbyssDungeon1") == abyss_dungeon_id
                or level_data.get("AbyssDungeon2") == abyss_dungeon_id
            ):
                abyss_level = level_data
                break

        if not abyss_level:
            return None, None, None

        # 通过AbyssLevel找到对应的AbyssSeason
        level_id = abyss_level.get("LevelId")
        for season_data in self.abyss_season_data.values():
            if level_id in season_data.get("AbyssLevelId", []):
                abyss_season_id = season_data.get("AbyssSeasonId")
                # 通过AbyssSeasonId找到AbyssSeasonList
                if str(abyss_season_id) in self.abyss_season_list_data:
                    return (
                        season_data,
                        self.abyss_season_list_data[str(abyss_season_id)],
                        abyss_level,
                    )
                break

        return None, None, None

    def process_item(self, item_data, language):
        """处理单个AbyssDungeon数据

        Args:
            item_data: AbyssDungeon数据
            language: 语言代码

        Returns:
            处理后的AbyssDungeon数据
        """
        abyss_dungeon_id = item_data.get("AbyssDungeonId", 0)
        if not abyss_dungeon_id:
            return None

        dungeon_id = item_data.get("DungeonId", 0)
        if not dungeon_id:
            return None

        # 构建基础处理后的AbyssDungeon数据
        processed = {
            "id": abyss_dungeon_id,
            "did": dungeon_id,
            "b": item_data.get("AbyssBuffID", []),
            "m": item_data.get("DungeonMonsters", []),
            # "r": item_data.get("RoomId", []), 用不到
        }

        # 处理MonsterBuff
        if "MonsterBuff" in item_data:
            monster_buff = item_data.get("MonsterBuff", {})
            buff_list = monster_buff.get("BuffList", [])
            if buff_list:
                # 处理Buff列表，查询Buff表并转换为字典格式
                mb_dict = self._process_buff_list(buff_list)
                if mb_dict:
                    processed["mb"] = mb_dict

        # 查找赛季信息
        abyss_season, abyss_season_list, abyss_level = (
            self._find_season_by_abyss_dungeon_id(abyss_dungeon_id)
        )
        if abyss_season:
            # 添加赛季ID
            processed["sid"] = abyss_season.get("AbyssSeasonId")
            # 添加开始时间
            processed["st"] = abyss_season.get("AbyssStartTime")
            # 添加结束时间
            processed["et"] = abyss_season.get("AbyssEndTime")
            # 添加奖励列表
            reward_list = abyss_season.get("AbyssRewardList", [])
            if reward_list:
                processed["arl"] = self._process_reward_list(reward_list)
            # 添加奖励标题翻译
            reward_title_key = abyss_season.get("AbyssRewardListTitle", "")
            if reward_title_key:
                reward_title = self.get_translated_text(reward_title_key, language)
                if reward_title and not reward_title.startswith("Abyss_"):
                    processed["art"] = reward_title

        if abyss_season_list:
            # 添加赛季名称翻译
            season_name_key = abyss_season_list.get("AbyssSeasonName", "")
            if season_name_key:
                season_name = self.get_translated_text(season_name_key, language)
                if season_name and not season_name.startswith("Event_"):
                    processed["sn"] = season_name
            # 添加角色ID
            char_id = abyss_season_list.get("CharId")
            if char_id:
                processed["cid"] = char_id

        # 处理AttributeType1字段
        if abyss_level:
            attribute_type1 = abyss_level.get("AttributeType1")
            if attribute_type1:
                # 初始化mb字典（如果还没有）
                if "mb" not in processed:
                    processed["mb"] = {}
                # 解析属性类型（可能是单个或多个，用逗号分隔）
                for attr in attribute_type1.split(","):
                    attr = attr.strip()
                    if attr:
                        # 将英文属性名映射为中文
                        chinese_attr = self.attribute_name_map.get(attr, attr)
                        processed["mb"][chinese_attr] = 4

        # 尝试获取关联的Dungeon名称
        # if str(dungeon_id) in self.dungeon_data:
        #     dungeon_name_key = self.dungeon_data[str(dungeon_id)].get("DungeonName", "")
        #     dungeon_name = self.get_translated_text(dungeon_name_key)
        #     if dungeon_name and not dungeon_name.startswith("DUNGEON_NAME_"):
        #         processed["n"] = dungeon_name

        return processed

    def _process_buff_list(self, buff_list):
        """处理Buff列表，查询Buff表并转换为字典格式

        Args:
            buff_list: Buff ID列表

        Returns:
            处理后的Buff字典，相同字段的值会相加
        """
        result = {}

        for buff_id in buff_list:
            # 查询Buff表
            buff_info = self.buff_data.get(str(buff_id), {})
            if not buff_info:
                continue

            # 处理AddAttrs字段
            add_attrs = buff_info.get("AddAttrs", [])
            for attr in add_attrs:
                attr_name = attr.get("AttrName", "")
                attr_value = attr.get("Value", 0)

                field_name = self.element_map.get(attr_name, attr_name)
                if field_name in result:
                    result[field_name] += attr_value
                else:
                    result[field_name] = attr_value

        return result

    def _process_reward_list(self, reward_list):
        """处理奖励列表，查询AbyssRewardList表并转换为{lv,r,a,w}格式

        Args:
            reward_list: AbyssRewardList ID列表

        Returns:
            处理后的奖励列表数组，每个元素为{lv,r,a,w}格式
        """
        result = []

        for reward_id in reward_list:
            # 查询AbyssRewardList表
            reward_info = self.abyss_reward_list_data.get(str(reward_id), {})
            if not reward_info:
                continue

            # 构建奖励项
            reward_item = {
                "lv": reward_info.get("Level", 0),
                "r": reward_info.get("Reward", 0),
            }

            # 添加可选字段
            reward_add_on = reward_info.get("RewardAddOn")
            if reward_add_on is not None:
                reward_item["a"] = reward_add_on

            walnut_reward = reward_info.get("WalnutReward", False)
            if walnut_reward:
                reward_item["w"] = 1

            result.append(reward_item)

        return result
