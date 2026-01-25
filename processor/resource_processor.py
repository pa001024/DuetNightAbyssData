from processor.base_processor import BaseProcessor


class ResourceProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Resource"
        self.resource_data = data_loader.load_json("Resource.json")
        self.draft_data = data_loader.load_json("Draft.json")
        self.char_break_data = data_loader.load_json("CharBreak.json")
        self.skill_level_up_data = data_loader.load_json("SkillLevelUp.json")
        self.weapon_break_data = data_loader.load_json("WeaponBreak.json")
        self.shop_item_data = data_loader.load_json("ShopItem.json")
        self.resource_map = {}
        for resource_id, resource_info in self.resource_data.items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

        self.draft_resource_ids = self.get_draft_resource_ids()

    def process_item(self, resource_data, language):
        """处理单个资源数据

        Args:
            resource_data: 原始资源数据
            language: 语言类型

        Returns:
            处理后的资源数据，如果资源不在Draft中则返回None
        """
        resource_id = resource_data.get("ResourceId")

        if resource_id not in self.draft_resource_ids:
            return None

        resource_name_key = resource_data.get("ResourceName")
        resource_name = ""
        if resource_name_key:
            resource_name = self.get_translated_text(resource_name_key, language)

        icon_path = resource_data.get("Icon", "")
        icon = ""
        if "T_" in icon_path:
            t_pos = icon_path.rfind("T_")
            if t_pos != -1:
                icon_part = icon_path[t_pos:]
                if "." in icon_part:
                    icon = icon_part.split(".")[0]
                else:
                    icon = icon_part
                icon = icon.rstrip("'")

        processed_resource = {
            "id": resource_id,
            "name": resource_name,
            "icon": icon,
        }

        return processed_resource

    def get_draft_resource_ids(self):
        """获取所有需要导出的资源ID

        Returns:
            需要导出的资源ID集合
        """
        resource_ids = set()

        # 从 Draft 中收集资源
        for draft_id, draft_info in self.draft_data.items():
            product_id = draft_info.get("ProductId")
            product_type = draft_info.get("ProductType")

            if product_type == "Resource" and product_id:
                resource_ids.add(product_id)

            resources = draft_info.get("Resource", [])
            for resource in resources:
                resource_type = resource.get("Type")
                if resource_type == "Resource":
                    resource_ids.add(resource.get("Id"))

        # 从 CharBreak 中收集资源
        for char_id, break_list in self.char_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 SkillLevelUp 中收集资源
        for skill_id, level_list in self.skill_level_up_data.items():
            if isinstance(level_list, list):
                for level_stage in level_list:
                    item_ids = level_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 WeaponBreak 中收集资源
        for weapon_id, break_list in self.weapon_break_data.items():
            if isinstance(break_list, list):
                for break_stage in break_list:
                    item_ids = break_stage.get("ItemId", [])
                    for item_id in item_ids:
                        resource_ids.add(item_id)

        # 从 ShopItem 中收集资源
        for shop_item_id, shop_item_info in self.shop_item_data.items():
            # 收集商品类型为Resource的TypeId
            item_type = shop_item_info.get("ItemType")
            type_id = shop_item_info.get("TypeId")
            if item_type == "Resource" and type_id:
                resource_ids.add(type_id)

            # 收集PriceType（消耗的资源类型）
            price_type = shop_item_info.get("PriceType")
            if price_type:
                resource_ids.add(price_type)

        return resource_ids

    def process_draft_resources(self, language):
        """处理Draft中出现的资源

        Args:
            language: 语言类型

        Returns:
            处理后的资源列表
        """
        draft_resource_ids = self.get_draft_resource_ids()

        processed_resources = []
        for resource_id in sorted(draft_resource_ids):
            if resource_id in self.resource_map:
                resource_data = self.resource_map[resource_id]
                processed = self.process_item(resource_data, language)
                if processed:
                    processed_resources.append(processed)

        return processed_resources
