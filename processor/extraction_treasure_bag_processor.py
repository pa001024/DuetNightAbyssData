from processor.base_processor import BaseProcessor


class ExtractionTreasureBagProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ExtractionTreasureBag"

    def process_item(self, item_data, language):
        """处理单个秘宝背包配置。"""
        bag_id = item_data.get("BagID", 0)
        if not bag_id:
            return None

        processed = {
            "id": bag_id,
            "name": self.get_translated_text(item_data.get("Name", ""), language),
            "desc": item_data.get("Desc", ""),
            "price": item_data.get("Price", 0),
            "shape": self._normalize_shape(item_data.get("Shape", [])),
            "shapeType": item_data.get("ShapeType", 0),
        }

        event_unlock_condition = item_data.get("EventUnlockCondition")
        if event_unlock_condition is not None:
            processed["eventUnlockCondition"] = event_unlock_condition

        shop_item_id = item_data.get("ShopItemId")
        if shop_item_id is not None:
            processed["shopItemId"] = shop_item_id

        return processed

    def _normalize_shape(self, shape):
        """把 Shape 规范成纯二维数值数组。"""
        if not isinstance(shape, list):
            return []

        result = []
        for row in shape:
            if not isinstance(row, list) or len(row) < 2:
                continue
            x, y = row[0], row[1]
            try:
                result.append([int(x), int(y)])
            except (TypeError, ValueError):
                continue
        return result
