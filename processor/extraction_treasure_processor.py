from processor.base_processor import BaseProcessor


class ExtractionTreasureProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ExtractionTreasure"

    def process_item(self, item_data, language):
        """处理单个秘宝数据。"""
        treasure_id = item_data.get("TreasureId", 0)
        if not treasure_id:
            return None

        processed = {
            "id": treasure_id,
            "name": self.get_translated_text(item_data.get("Name", ""), language),
            "icon": self._simplify_icon(item_data.get("Icon", "")),
            "shape": self._normalize_shape(item_data.get("Shape", [])),
            "type": item_data.get("TreasureType", 0),
            "rarity": item_data.get("TreasureRarity", 0),
            "value": item_data.get("TreasureValue", 0),
        }

        return processed

    def _normalize_shape(self, shape):
        """把 Shape 规范成纯数值数组。"""
        if not isinstance(shape, list):
            return []

        result = []
        for value in shape:
            try:
                result.append(int(value))
            except (TypeError, ValueError):
                continue
        return result

    def _simplify_icon(self, icon):
        """把资源路径压成短名。"""
        if not isinstance(icon, str) or not icon:
            return ""

        icon = icon.rsplit("/", 1)[-1]
        if "." in icon:
            icon = icon.split(".", 1)[0]
        return icon
