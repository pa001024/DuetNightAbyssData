from processor.base_processor import BaseProcessor


class ImpressionShopProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ImpressionShop"

        self.table_data = {
            "Resource": data_loader.load_json("Resource.json"),
            "HeadSculpture": data_loader.load_json("HeadSculpture.json"),
            "Title": data_loader.load_json("Title.json"),
            "Draft": data_loader.load_json("Draft.json"),
            "Weapon": data_loader.load_json("Weapon.json"),
            "Mod": data_loader.load_json("Mod.json"),
            "CharAccessory": data_loader.load_json("CharAccessory.json"),
        }

        self.impression_shop_info = data_loader.load_json("ImpressionShopInfo.json")
        self.impression_main_tab = data_loader.load_json("ImpressionShopMainTab.json")
        self.impression_sub_tab = data_loader.load_json("ImpressionShopSubTab.json")
        self.region_to_main_tab = data_loader.load_json(
            "RegionId2ImpressionMainTab.json"
        )
        self.impression_resource = data_loader.load_json("ImpressionResource.json")
        self.condition_data = data_loader.load_json("Condition.json")

        self.resource_map = {}
        for _, resource_info in self.table_data["Resource"].items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

    def _get_item_name(self, item_type, item_id, language):
        if item_type == "Resource":
            item = self.resource_map.get(item_id, {})
            return self.get_translated_text(item.get("ResourceName", ""), language)

        if item_type == "HeadSculpture":
            item = self.table_data["HeadSculpture"].get(str(item_id), {})
            return self.get_translated_text(item.get("Name", ""), language)

        if item_type == "Title":
            item = self.table_data["Title"].get(str(item_id), {})
            return self.get_translated_text(item.get("Name", ""), language)

        if item_type == "Draft":
            draft = self.table_data["Draft"].get(str(item_id), {})
            product_type = draft.get("ProductType")
            product_id = draft.get("ProductId")

            if product_type == "Resource":
                item = self.resource_map.get(product_id, {})
                return self.get_translated_text(item.get("ResourceName", ""), language)
            if product_type == "Weapon":
                item = self.table_data["Weapon"].get(str(product_id), {})
                return self.get_translated_text(item.get("WeaponName", ""), language)
            if product_type == "Mod":
                item = self.table_data["Mod"].get(str(product_id), {})
                type_name = self.get_translated_text(item.get("TypeName", ""), language)
                mod_name = self.get_translated_text(item.get("Name", ""), language)
                return f"{type_name}{mod_name}".strip()
            if product_type == "CharAccessory":
                item = self.table_data["CharAccessory"].get(str(product_id), {})
                return self.get_translated_text(item.get("Name", ""), language)

        return ""

    def _inline_impr_shop_condition(self, condition_id):
        """将ConditionId内联为ImprShopUnlock数组：[regionId, status, value]"""
        condition = self.condition_data.get(str(condition_id), {})
        condition_map = condition.get("ConditionMap", {})
        unlock_list = condition_map.get("ImprShopUnlock", [])
        if not unlock_list or not isinstance(unlock_list[0], list):
            return None

        unlock = unlock_list[0]
        if (
            len(unlock) == 3
            and isinstance(unlock[0], int)
            and isinstance(unlock[1], str)
            and isinstance(unlock[2], int)
        ):
            return unlock
        return None

    def process_item(self, item_data, language):
        """处理单个印象商店物品"""
        region_id = item_data.get("RegionId")
        cost_info = self.impression_resource.get(str(region_id), {})
        price_type = cost_info.get("ResourceId", 0)
        price_count = cost_info.get("Count", 0)
        price_name = ""

        if price_type:
            price_res = self.resource_map.get(price_type, {})
            price_name = self.get_translated_text(
                price_res.get("ResourceName", ""), language
            )

        item_type = item_data.get("ItemType", "")
        item_id = item_data.get("ItemId", 0)

        unlock = self._inline_impr_shop_condition(item_data.get("UnlockCondition", 0))
        impr_check = self._inline_impr_shop_condition(item_data.get("ImprCheckId", 0))

        processed = {
            "id": item_data.get("ImpressionShopId", 0),
            "itemType": item_type,
            "typeId": item_id,
            "typeName": self._get_item_name(item_type, item_id, language),
            "price": price_count,
            "priceType": price_type,
            "priceName": price_name,
            "num": item_data.get("TypeNum", 0),
            "limit": item_data.get("PurchaseLimit", 0),
            "subTabId": item_data.get("SubTabId", 0),
            "sequence": item_data.get("ItemSeq", 0),
        }

        if unlock is not None:
            processed["unlock"] = unlock
        if impr_check is not None:
            processed["imprCheck"] = impr_check

        if not processed["limit"]:
            del processed["limit"]

        return processed

    def process_all_items(self, items, language):
        """按印象商店主/子页签结构输出"""
        items_by_region_subtab = {}
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                key = (item.get("RegionId", 0), processed.get("subTabId", 0))
                if key not in items_by_region_subtab:
                    items_by_region_subtab[key] = []
                items_by_region_subtab[key].append(processed)

        region_tabs = []

        for region_id, shop_info in self.impression_shop_info.items():
            region_int = int(region_id)
            main_tab_id = self.region_to_main_tab.get(region_id)

            region_tab = {
                "id": region_int,
                "name": self.get_translated_text(
                    shop_info.get("ShopName", ""), language
                ),
                "subTabs": [],
            }

            for main_tab in self.impression_main_tab:
                if main_tab.get("RegionId") != region_int:
                    continue
                if main_tab_id and main_tab.get("MainTabId") != main_tab_id:
                    continue

                # 区域节点名称使用主页签名称（如“印象商店·海伯利亚”）
                region_tab["name"] = self.get_translated_text(
                    main_tab.get("MainName", ""), language
                )

                for sub_tab_id, sub_tab in self.impression_sub_tab.items():
                    if sub_tab.get("MainTabId") != main_tab.get("MainTabId"):
                        continue

                    sub_items = items_by_region_subtab.get(
                        (region_int, int(sub_tab_id)), []
                    )
                    if not sub_items:
                        continue

                    sub_items.sort(key=lambda x: x.get("sequence", 0), reverse=True)
                    region_tab["subTabs"].append(
                        {
                            "id": int(sub_tab_id),
                            "name": self.get_translated_text(
                                sub_tab.get("SubName", ""), language
                            ),
                            "items": sub_items,
                        }
                    )

            if region_tab["subTabs"]:
                region_tab["subTabs"].sort(key=lambda x: x["id"])
                region_tabs.append(region_tab)

        region_tabs.sort(key=lambda x: x["id"])

        root_name = self.get_translated_text("UI_ImpressionShop_ShopName", language)
        if not root_name and region_tabs:
            root_name = region_tabs[0].get("name", "")

        return [{"id": "ImpressionShop", "name": root_name, "mainTabs": region_tabs}]
