from processor.base_processor import BaseProcessor


class RegionProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Region"

    def process_item(self, region_data, language):
        """处理单个区域数据

        Args:
            region_data: 原始区域数据
            language: 语言类型

        Returns:
            处理后的区域数据
        """
        region_id = region_data.get("RegionId")
        
        region_name_key = region_data.get("RegionName")
        region_name = ""
        if region_name_key:
            region_name = self.get_translated_text(region_name_key, language)
        
        processed_region = {
            "id": region_id,
            "name": region_name,
            "type": region_data.get("RegionType"),
            "mapId": region_data.get("RegionMapId"),
            "mapImage": region_data.get("RegionMapImage", ""),
            "mapCenter": region_data.get("RegionMapImageCenter", []),
            "mapScale": region_data.get("RegionMapWheelScale", []),
            "isRandom": region_data.get("IsRandom", []),
            "alertDisable": region_data.get("AlertDisable", False),
        }
        
        return processed_region
