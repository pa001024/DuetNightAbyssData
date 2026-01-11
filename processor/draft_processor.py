from processor.base_processor import BaseProcessor


class DraftProcessor(BaseProcessor):
    """
    图纸(Draft)数据处理器
    处理游戏中的图纸数据，包括资源、模组、角色、武器等图纸
    """

    def __init__(self, data_loader):
        """初始化 Draft 处理器"""
        super().__init__(data_loader)
        self.file_type = "Draft"

    def process_item(self, draft_data, language):
        """
        处理单个图纸数据

        Args:
            draft_data: 图纸原始数据
            language: 语言代码

        Returns:
            处理后的图纸数据
        """
        draft_id = draft_data.get("DraftId", 0)

        # 构建基础处理后的图纸数据
        processed = {
            "id": draft_id,
            "名称": self._get_product_name(draft_data),
            # "图标": draft_data.get("Icon", "")
            # .replace("/Game/UI/Texture/Dynamic/Atlas/Prop/Item/", "")
            # .replace(".T_", ""),
            "品质": draft_data.get("Rarity", 0),
            "版本": self.process_release(draft_data.get("ReleaseVersion", 100)),
            "产物类型": self._get_product_type_name(draft_data.get("ProductType", "")),
            "产物数量": draft_data.get("ProductNum", 1),
            "产物ID": draft_data.get("ProductId", 0),
            "锻造时间": draft_data.get("Time", 0),
            "批量生产": draft_data.get("Batch", False),
            "无限生产": draft_data.get("IsInfinity", False),
            "显示在图纸图鉴": draft_data.get("ShowInDraftArchive", False),
            "消耗资源": self._process_resources(draft_data.get("Resource", [])),
            "锻造成本": self._process_foundry_cost(draft_data.get("FoundryCost", {})),
        }
        processed["消耗资源"].update(
            {processed["锻造成本"][0]["名称"]: processed["锻造成本"][0]["数量"]}
        )
        del processed["锻造成本"]

        return processed

    def _get_product_name(self, draft_data):
        """
        获取产物名称

        Args:
            draft_data: 图纸数据

        Returns:
            产物名称
        """
        product_type = draft_data.get("ProductType", "")
        product_id = draft_data.get("ProductId", 0)

        if product_type == "Resource":
            # 获取资源名称
            resource_name = self.data_loader.get_resource_name(product_id)
            if resource_name:
                return resource_name
        elif product_type == "Mod":
            # 获取模组名称
            mod_name = self.data_loader.get_mod_name(product_id)
            if mod_name:
                return mod_name
        elif product_type == "Char":
            # 获取角色名称
            char_name = self.data_loader.get_char_name(product_id)
            if char_name:
                return char_name
        elif product_type == "Weapon":
            # 获取武器名称
            weapon_name = self.data_loader.get_weapon_name(product_id)
            if weapon_name:
                return weapon_name
        elif product_type == "CharAccessory":
            # 获取角色配件名称
            accessory_name = self.data_loader.get_accessory_name(product_id)
            if accessory_name:
                return accessory_name

        # 如果无法获取名称，返回默认格式
        return f"{product_type}_{product_id}"

    def _get_product_type_name(self, product_type):
        """
        获取产物类型的中文名称

        Args:
            product_type: 产物类型代码

        Returns:
            产物类型中文名称
        """
        type_map = {
            "Resource": "资源",
            "Mod": "模组",
            "Char": "角色",
            "Weapon": "武器",
            "CharAccessory": "角色配件",
        }
        return type_map.get(product_type, product_type)

    def _process_resources(self, resources):
        """
        处理所需资源列表

        Args:
            resources: 资源列表

        Returns:
            处理后的资源列表
        """
        if not resources:
            return []

        processed_resources = {}
        for resource in resources:
            if not isinstance(resource, dict):
                continue

            resource_id = resource.get("Id", 0)
            resource_num = resource.get("Num", 0)
            resource_type = resource.get("Type", "")

            # 获取资源名称
            resource_name = ""
            if resource_type == "Resource":
                resource_name = self.data_loader.get_resource_name(resource_id)
            elif resource_type == "Mod":
                resource_name = self.data_loader.get_mod_name(resource_id)
            elif resource_type == "Char":
                resource_name = self.data_loader.get_char_name(resource_id)
            elif resource_type == "Weapon":
                resource_name = self.data_loader.get_weapon_name(resource_id)

            # 如果无法获取名称，使用默认格式
            if not resource_name:
                resource_name = f"{resource_type}_{resource_id}"

            processed_resources.update(
                {
                    resource_name: resource_num,
                }
            )
            # processed_resources.append(
            #     {
            #         "id": resource_id,
            #         "名称": resource_name,
            #         "数量": resource_num,
            #         "类型": resource_type,
            #     }
            # )

        return processed_resources

    def _process_foundry_cost(self, foundry_cost):
        """
        处理锻造成本

        Args:
            foundry_cost: 锻造成本数据

        Returns:
            处理后的锻造成本列表
        """
        if not foundry_cost or not isinstance(foundry_cost, dict):
            return []

        processed_cost = []
        for resource_id, cost in foundry_cost.items():
            # 获取资源名称
            resource_name = self.data_loader.get_resource_name(int(resource_id))
            if not resource_name:
                resource_name = f"Resource_{resource_id}"

            processed_cost.append(
                {"名称": resource_name, "数量": cost, "ID": int(resource_id)}
            )

        return processed_cost
