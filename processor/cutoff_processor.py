from processor.base_processor import BaseProcessor


class CutoffProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Cutoff"
        self.shop_item_data = data_loader.load_json("ShopItem.json")
        self.resource_data = data_loader.load_json("Resource.json")

        self.resource_map = {}
        for _, resource_info in self.resource_data.items():
            resource_id = resource_info.get("ResourceId")
            if resource_id is not None:
                self.resource_map[resource_id] = resource_info

    def _get_shop_item(self, item_id):
        if item_id is None:
            return {}
        return self.shop_item_data.get(str(item_id), {}) or self.shop_item_data.get(item_id, {}) or {}

    def _get_price_name(self, price_type_id, language):
        if not price_type_id:
            return ""
        price_resource = self.resource_map.get(price_type_id, {})
        if not price_resource:
            return ""
        return self.get_translated_text(price_resource.get("ResourceName", ""), language)

    def process_item(self, item_data, language):
        """处理单个限时折扣配置。"""
        cutoff_id = item_data.get("CutoffId")
        item_id = item_data.get("ItemId")
        if cutoff_id is None or item_id is None:
            return None

        shop_item = self._get_shop_item(item_id)
        processed = {
            "id": cutoff_id,
            "itemId": item_id,
            "price": item_data.get("CutoffPrice"),
            "discount": item_data.get("CutoffShow"),
            "startTime": item_data.get("CutoffStartTime"),
        }

        end_time = item_data.get("CutoffEndTime")
        if end_time is not None:
            processed["endTime"] = end_time

        if shop_item:
            processed["originalPrice"] = shop_item.get("Price")
            processed["itemType"] = shop_item.get("ItemType")
            processed["typeId"] = shop_item.get("TypeId")
            processed["subTabId"] = shop_item.get("SubTabId")

            price_type_id = shop_item.get("PriceType")
            if price_type_id is not None:
                processed["priceType"] = price_type_id
                price_name = self._get_price_name(price_type_id, language)
                if price_name:
                    processed["priceName"] = price_name

        return processed
