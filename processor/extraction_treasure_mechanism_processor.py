from processor.base_processor import BaseProcessor


class ExtractionTreasureMechanismProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "ExtractionTreasureMechanism"

    def process_item(self, item_data, language):
        """处理单个秘宝机关配置。"""
        mechanism_id = item_data.get("MechanismID", 0)
        if not mechanism_id:
            return None

        processed = {
            "id": mechanism_id,
            "name": self.get_translated_text(item_data.get("MechanismName", ""), language),
            "itemLevelLimit": self._normalize_number_map(item_data.get("ItemLevelLimit", {})),
            "itemLevelWeight": self._normalize_number_map(item_data.get("ItemLevelWeight", {})),
            "itemNumRange": self._normalize_number_list(item_data.get("ItemNumRange", [])),
            "shape": self._normalize_shape(item_data.get("Shape", [])),
        }

        return processed

    def _normalize_number_map(self, value):
        """把键值表转换成稳定的字典结构。"""
        if not isinstance(value, dict):
            return {}

        result = {}
        for key, item in value.items():
            try:
                normalized_key = int(key)
            except (TypeError, ValueError):
                normalized_key = key
            result[normalized_key] = item
        return result

    def _normalize_number_list(self, value):
        """把列表值规范成纯数值数组。"""
        if not isinstance(value, list):
            return []

        result = []
        for item in value:
            try:
                result.append(int(item))
            except (TypeError, ValueError):
                continue
        return result

    def _normalize_shape(self, shape):
        """把 Shape 规范成纯二维数值数组。"""
        if not isinstance(shape, list):
            return []

        result = []
        for row in shape:
            try:
                result.append(int(row))
            except (TypeError, ValueError):
                continue
        return result
