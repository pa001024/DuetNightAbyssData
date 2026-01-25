from processor.base_processor import BaseProcessor


class ShopItemProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ShopItem"

        # 加载所有相关数据表
        self.table_data = {
            "DailyPack": data_loader.load_json("DailyPack.json"),
            "Resource": data_loader.load_json("Resource.json"),
            "WeaponSkin": data_loader.load_json("WeaponSkin.json"),
            "CharAccessory": data_loader.load_json("CharAccessory.json"),
            "WeaponAccessory": data_loader.load_json("WeaponAccessory.json"),
            "Skin": data_loader.load_json("Skin.json"),
            "HeadSculpture": data_loader.load_json("HeadSculpture.json"),
            "Walnut": data_loader.load_json("Walnut.json"),
            "Weapon": data_loader.load_json("Weapon.json"),
            "Reward": data_loader.load_json("Reward.json"),
            "Mod": data_loader.load_json("Mod.json"),
            "Pet": data_loader.load_json("Pet.json"),
            "Title": data_loader.load_json("Title.json"),
            "Draft": data_loader.load_json("Draft.json"),
        }

        # 加载商店相关数据
        self.shop_data = data_loader.load_json("Shop.json")
        self.shop_tab_main_data = data_loader.load_json("ShopTabMain.json")
        self.shop_tab_sub_data = data_loader.load_json("ShopTabSub.json")

        # 为 Resource 表创建 ResourceId 到资源信息的映射
        self.resource_map = {}
        for resource_id, resource_info in self.table_data["Resource"].items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

    def process_item(self, shop_item_data, language):
        """处理单个商店物品数据

        Args:
            shop_item_data: 原始商店物品数据
            language: 语言类型

        Returns:
            处理后的商店物品数据
        """
        item_id = shop_item_data.get("ItemId")
        type_id = shop_item_data.get("TypeId")
        price_type_id = shop_item_data.get("PriceType")
        item_type = shop_item_data.get("ItemType")

        type_name = ""
        if type_id:
            # 根据 ItemType 确定要查找的表
            if item_type in self.table_data:
                table = self.table_data[item_type]
                type_item = None

                # 根据不同表的结构查找 TypeId
                if item_type == "Resource":
                    # Resource 表使用 ResourceId 作为键
                    type_item = self.resource_map.get(type_id)
                elif item_type in [
                    "Weapon",
                    "Mod",
                    "Skin",
                    "Title",
                    "Draft",
                    "DailyPack",
                    "WeaponSkin",
                    "CharAccessory",
                    "WeaponAccessory",
                    "HeadSculpture",
                    "Walnut",
                    "Reward",
                    "Pet",
                ]:
                    # 这些表直接使用 ID 作为键
                    type_item = table.get(str(type_id))
                    # 尝试不同的 ID 格式
                    if not type_item:
                        type_item = table.get(type_id)
                        if not type_item and isinstance(type_id, int):
                            type_item = table.get(str(type_id))

                # 获取名称并翻译
                if type_item:
                    # 根据不同表获取对应的名称字段
                    name_key = None
                    if item_type == "Resource":
                        name_key = type_item.get("ResourceName")
                    elif item_type == "Weapon":
                        name_key = type_item.get("WeaponName")
                    elif item_type == "Mod":
                        # Mod 表需要组合 TypeName 和 Name
                        type_name_part = self.get_translated_text(
                            type_item.get("TypeName", ""), language
                        )
                        name_part = self.get_translated_text(
                            type_item.get("Name", ""), language
                        )
                        type_name = f"{type_name_part}{name_part}".strip()
                    elif item_type == "Draft":
                        # Draft 表没有直接的 Name 字段，需要通过 ProductType 和 ProductId 获取产物名称
                        product_type = type_item.get("ProductType")
                        product_id = type_item.get("ProductId")
                        if product_type and product_id:
                            # 参考 DraftProcessor 的实现，根据 ProductType 获取产物名称
                            if product_type == "Resource":
                                resource_item = self.resource_map.get(product_id)
                                if resource_item:
                                    resource_name_key = resource_item.get(
                                        "ResourceName"
                                    )
                                    if resource_name_key:
                                        type_name = self.get_translated_text(
                                            resource_name_key, language
                                        )
                            elif product_type == "Mod":
                                # 从 Mod 表获取名称
                                mod_table = self.table_data.get("Mod")
                                if mod_table:
                                    mod_item = mod_table.get(str(product_id))
                                    if mod_item:
                                        mod_type_name = self.get_translated_text(
                                            mod_item.get("TypeName", ""), language
                                        )
                                        mod_name = self.get_translated_text(
                                            mod_item.get("Name", ""), language
                                        )
                                        type_name = f"{mod_type_name}{mod_name}".strip()
                            elif product_type == "Char":
                                # 从 Char 表获取名称
                                char_table = self.table_data.get("Char")
                                if char_table:
                                    char_item = char_table.get(str(product_id))
                                    if char_item:
                                        char_name_key = char_item.get("Name")
                                        if char_name_key:
                                            type_name = self.get_translated_text(
                                                char_name_key, language
                                            )
                            elif product_type == "Weapon":
                                # 从 Weapon 表获取名称
                                weapon_item = self.table_data["Weapon"].get(
                                    str(product_id)
                                )
                                if weapon_item:
                                    weapon_name_key = weapon_item.get("WeaponName")
                                    if weapon_name_key:
                                        type_name = self.get_translated_text(
                                            weapon_name_key, language
                                        )
                            elif product_type == "CharAccessory":
                                # 从 CharAccessory 表获取名称
                                accessory_table = self.table_data.get("CharAccessory")
                                if accessory_table:
                                    accessory_item = accessory_table.get(
                                        str(product_id)
                                    )
                                    if accessory_item:
                                        accessory_name_key = accessory_item.get("Name")
                                        if accessory_name_key:
                                            type_name = self.get_translated_text(
                                                accessory_name_key, language
                                            )
                    elif item_type in [
                        "Skin",
                        "WeaponSkin",
                        "CharAccessory",
                        "WeaponAccessory",
                        "HeadSculpture",
                        "Title",
                    ]:
                        name_key = type_item.get("Name")
                    elif item_type in ["DailyPack", "Walnut", "Reward", "Pet"]:
                        name_key = type_item.get("Name")

                    if name_key and item_type not in ["Mod", "Draft"]:
                        type_name = self.get_translated_text(name_key, language)

        price_name = ""
        if price_type_id:
            price_resource = self.resource_map.get(price_type_id)
            if price_resource:
                price_name_key = price_resource.get("ResourceName")
                if price_name_key:
                    price_name = self.get_translated_text(price_name_key, language)

        processed_shop_item = {
            "id": item_id,
            "itemType": shop_item_data.get("ItemType"),
            "typeId": type_id,
            "typeName": type_name,
            "price": shop_item_data.get("Price"),
            "priceType": price_type_id,
            "priceName": price_name,
            "num": shop_item_data.get("TypeNum"),
            "limit": shop_item_data.get("PurchaseLimit"),
            "subTabId": shop_item_data.get("SubTabId"),
            "sequence": shop_item_data.get("Sequence"),
            "startTime": shop_item_data.get("StartTime"),
            "endTime": shop_item_data.get("EndTime"),
        }
        if not processed_shop_item.get("limit"):
            del processed_shop_item["limit"]
        if not processed_shop_item.get("endTime"):
            del processed_shop_item["endTime"]
        if shop_item_data.get("Require"):
            processed_shop_item["require"] = shop_item_data.get("Require")
        if shop_item_data.get("UnlockRaidPoint"):
            processed_shop_item["unlockRaidPoint"] = shop_item_data.get(
                "UnlockRaidPoint"
            )
        if shop_item_data.get("IsSpPopup"):
            processed_shop_item["isSpPopup"] = 1
        return processed_shop_item

    def process_all_items(self, items, language):
        """重写父类方法，以ShopTab为分组处理所有商店物品

        Args:
            items: 商店物品列表
            language: 语言类型

        Returns:
            按照ShopTab分组的处理后数据
        """
        # 首先处理所有物品
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        # 将物品按subTabId分组
        items_by_subtab = {}
        for item in processed_items:
            sub_tab_id = item.get("subTabId")
            if sub_tab_id not in items_by_subtab:
                items_by_subtab[sub_tab_id] = []
            items_by_subtab[sub_tab_id].append(item)

        # 构建完整的商店结构
        shops_result = []

        for shop_id, shop_info in self.shop_data.items():
            # 创建商店基本信息
            shop = {
                "id": shop_id,
                "name": self.get_translated_text(
                    shop_info.get("ShopName", ""), language
                ),
                "mainTabs": [],
            }

            # 获取商店的主标签ID列表
            main_tab_ids = shop_info.get("MainTabId", [])

            # 处理每个主标签
            for main_tab_id in main_tab_ids:
                main_tab_info = self.shop_tab_main_data.get(str(main_tab_id))
                if not main_tab_info:
                    continue

                main_tab = {
                    "id": main_tab_id,
                    "name": self.get_translated_text(
                        main_tab_info.get("MainName", ""), language
                    ),
                    "subTabs": [],
                }

                # 查找所有属于当前主标签的子标签
                for sub_tab_id, sub_tab_info in self.shop_tab_sub_data.items():
                    if sub_tab_info.get("MainTabId") == main_tab_id:
                        # 查找当前子标签下的所有物品
                        sub_tab_items = items_by_subtab.get(int(sub_tab_id), [])

                        # 只有当子标签下有物品时才添加该子标签
                        if sub_tab_items:
                            sub_tab = {
                                "id": int(sub_tab_id),
                                "name": self.get_translated_text(
                                    sub_tab_info.get("SubName", ""), language
                                ),
                                "items": sub_tab_items,
                            }
                            main_tab["subTabs"].append(sub_tab)

                # 只有当主标签下有子标签时才添加该主标签
                if main_tab["subTabs"]:
                    shop["mainTabs"].append(main_tab)

            # 只有当商店下有主标签时才添加该商店
            if shop["mainTabs"]:
                shops_result.append(shop)

        # 按商店ID排序
        shops_result.sort(key=lambda x: x["id"])

        return shops_result
