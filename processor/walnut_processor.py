from processor.base_processor import BaseProcessor


class WalnutProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Walnut"
        # 加载Resource数据用于查询资源名称
        self.resource_data = data_loader.load_json("Resource.json")
        self.weapon_data = data_loader.load_json("Weapon.json")
        self.mod_data = data_loader.load_json("Mod.json")
        # AccessKey映射表，将英文获取途径映射为中文
        self.access_key_map = {
            "Dungeon": "副本",
            "Shop_Main": "委托密函商店",
            "Shop_Abyss": "观剧纪念",
            "HardBoss": "梦魇残声",
            "Abyss": "沉浸式戏剧",
        }

    def process_item(self, walnut_data, language):
        """处理单个Walnut条目

        Args:
            walnut_data: 单个Walnut数据
            language: 语言

        Returns:
            dict: 处理后的Walnut数据
        """
        # 获取基本信息
        walnut_id = walnut_data.get("WalnutId", 0)
        if not walnut_id:
            return None

        # 处理获取途径
        access_keys = walnut_data.get("AccessKey", [])
        access_ways = []
        for key in access_keys:
            # 使用映射表转换为中文
            access_way = self.access_key_map.get(key, key)
            access_ways.append(access_way)

        # 处理名称
        name_key = walnut_data.get("Name", "")
        name = self.get_translated_text(name_key, language)

        # 处理奖励列表
        reward_ids = walnut_data.get("Id", [])
        counts = walnut_data.get("Count", [])
        types = walnut_data.get("Type", [])

        rewards = []
        for i, reward_id in enumerate(reward_ids):
            # 获取数量
            count = counts[i][0] if i < len(counts) else 1
            # 获取类型
            reward_type = types[i] if i < len(types) else "Resource"

            # 查询资源名称
            resource = self._get_resource(reward_id, reward_type, count)
            if resource:
                rewards.append(resource)

        # 构建处理后的Walnut数据
        processed = {
            "id": walnut_id,
            "名称": name,
            "获取途径": access_ways,
            "奖励": rewards,
            "稀有度": walnut_data.get("Rarity", 0),
            "模式": walnut_data.get("Mode", ""),
            "参数": walnut_data.get("Param", []),
            # "图标": walnut_data.get("Icon", ""),
            "类型": walnut_data.get("WalnutType", 0),
            # "核桃索引": walnut_data.get("WalnutIndex", ""),
            # "核桃编号": walnut_data.get("WalnutNumber", 0)
        }

        return processed

    def _get_resource(self, resource_id, resource_type, count):
        """根据资源ID和类型获取资源名称

        Args:
            resource_id: 资源ID
            resource_type: 资源类型

        Returns:
            str: 资源名称
        """
        resource = {"id": resource_id, "type": resource_type, "count": count}
        # 根据不同类型查找不同的表
        if resource_type == "Resource":
            # 从Resource.json中查找资源
            resource_str_id = str(resource_id)
            resource_info = self.resource_data.get(resource_str_id, {})

            # 获取资源名称
            resource_name_key = resource_info.get("ResourceName", "")
            if resource_name_key:
                resource["name"] = self.get_translated_text(resource_name_key)
        elif resource_type == "Draft":
            # 从Draft.json中查找图纸
            draft_data = self.data_loader.load_json("Draft.json")
            draft_info = draft_data.get(str(resource_id), {})

            # 获取ProductType
            product_type = draft_info.get("ProductType", "")
            product_id = draft_info.get("ProductId", 0)

            if product_type and product_id:
                # 根据ProductType查找对应表
                if product_type == "Weapon":
                    # 从Weapon.json中查找武器
                    weapon_info = self.weapon_data.get(str(product_id), {})
                    weapon_name_key = weapon_info.get("WeaponName", "")
                    if weapon_name_key:
                        weapon_name = self.get_translated_text(weapon_name_key)
                        resource["id"] = weapon_info.get("WeaponId", 0)
                        resource["name"] = weapon_name
                        resource["type"] = "Weapon"
                        resource["d"] = 1
                elif product_type == "Mod":
                    # 从Char.json中查找角色
                    mod_info = self.mod_data.get(str(product_id), {})
                    mod_name_key = mod_info.get("Name", "")
                    if mod_name_key:
                        mod_name = self.get_translated_text(mod_name_key)
                        resource["id"] = mod_info.get("Id", 0)
                        resource["name"] = mod_name
                        resource["type"] = "Mod"
                        resource["d"] = 1

        # 如果找不到，返回资源ID
        return resource
