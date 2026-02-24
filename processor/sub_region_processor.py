from processor.base_processor import BaseProcessor


class SubRegionProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SubRegion"
        self.random_creator_data = data_loader.load_json("RandomCreator.json")
        self.design_level_cache = {}
        self.missing_design_level = set()

    def process_item(self, item_data, language):
        """处理单个子区域数据

        Args:
            sub_region_data: 原始子区域数据
            language: 语言类型

        Returns:
            处理后的子区域数据
        """
        sub_region_data = item_data
        sub_region_id = sub_region_data.get("SubRegionId")

        sub_region_name_key = sub_region_data.get("SubRegionName")
        sub_region_name = ""
        if sub_region_name_key:
            sub_region_name = self.get_translated_text(sub_region_name_key, language)

        sub_region_des_key = sub_region_data.get("SubRegionDes")
        sub_region_des = ""
        if sub_region_des_key:
            sub_region_des = self.get_translated_text(sub_region_des_key, language)

        processed_sub_region = {
            "id": sub_region_id,
            "rid": sub_region_data.get("RegionId"),
            "name": sub_region_name,
            "desc": sub_region_des,
            "map": sub_region_data.get("SubRegionLevel"),
            "pos": sub_region_data.get("SubRegionCenter", []),
        }
        if not processed_sub_region["rid"] or not processed_sub_region["map"]:
            return None
        if not processed_sub_region["pos"]:
            del processed_sub_region["pos"]
        rc = self._get_pet_random_creators(processed_sub_region["map"])
        if rc:
            processed_sub_region["rc"] = rc

        return processed_sub_region

    def _load_design_level_data(self, sub_region_level):
        """按子区域地图名加载 DesignLevel 数据（带缓存）"""
        if sub_region_level in self.design_level_cache:
            return self.design_level_cache[sub_region_level]
        if sub_region_level in self.missing_design_level:
            return {}

        file_name = f"DesignLevel_data/{sub_region_level}.json"
        try:
            design_level_data = self.data_loader.load_json(file_name)
        except FileNotFoundError:
            self.missing_design_level.add(sub_region_level)
            return {}
        except Exception:
            self.missing_design_level.add(sub_region_level)
            return {}

        if not isinstance(design_level_data, dict):
            self.design_level_cache[sub_region_level] = {}
            return {}

        self.design_level_cache[sub_region_level] = design_level_data
        return design_level_data

    def _extract_random_rule_ids(self, design_level_data):
        """提取地图中的 RandomRuleId 列表"""
        random_rule_data = design_level_data.get("RandomRule", {})
        if not random_rule_data:
            return []

        random_rule_ids = []
        seen = set()

        if isinstance(random_rule_data, dict):
            for key, value in random_rule_data.items():
                rule_id = None
                if isinstance(value, dict):
                    rule_id = value.get("RandomRuleId")
                if not rule_id:
                    rule_id = key
                if rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)
        elif isinstance(random_rule_data, list):
            for value in random_rule_data:
                if not isinstance(value, dict):
                    continue
                rule_id = value.get("RandomRuleId")
                if not rule_id or rule_id in seen:
                    continue
                seen.add(rule_id)
                random_rule_ids.append(rule_id)

        return random_rule_ids

    def _normalize_rule_id(self, rule_id):
        """将规则 ID 统一为数字优先"""
        if isinstance(rule_id, int):
            return rule_id
        if isinstance(rule_id, str) and rule_id.isdigit():
            return int(rule_id)
        return rule_id

    def _get_pet_random_creators(self, sub_region_level):
        """根据地图配置提取 Pet 类型随机生成器信息"""
        design_level_data = self._load_design_level_data(sub_region_level)
        if not design_level_data:
            return []

        random_rule_ids = self._extract_random_rule_ids(design_level_data)
        if not random_rule_ids:
            return []

        rc = []
        for random_rule_id in random_rule_ids:
            random_creator = self.random_creator_data.get(str(random_rule_id))
            if not random_creator:
                random_creator = self.random_creator_data.get(random_rule_id)
            if not random_creator or random_creator.get("UnitType") != "Pet":
                continue

            info = []
            for unit_info in random_creator.get("RandomInfos", []):
                if not isinstance(unit_info, dict):
                    continue
                unit_id = unit_info.get("UnitId")
                if unit_id is None:
                    continue
                info.append(
                    {
                        "id": unit_id,
                        "w": unit_info.get("Weight", 0),
                    }
                )

            rc.append(
                {
                    "id": self._normalize_rule_id(random_rule_id),
                    "info": info,
                }
            )

        return rc
