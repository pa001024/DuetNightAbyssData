from processor.base_processor import BaseProcessor


class SubRegionProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SubRegion"

    def process_item(self, sub_region_data, language):
        """处理单个子区域数据

        Args:
            sub_region_data: 原始子区域数据
            language: 语言类型

        Returns:
            处理后的子区域数据
        """
        sub_region_id = sub_region_data.get("SubRegionId")
        
        sub_region_name_key = sub_region_data.get("SubRegionName")
        sub_region_name = ""
        if sub_region_name_key:
            sub_region_name = self.get_translated_text(sub_region_name_key, language)
        
        sub_region_des_key = sub_region_data.get("SubRegionDes")
        sub_region_des = ""
        if sub_region_des_key:
            sub_region_des = self.get_translated_text(sub_region_des_key, language)
        
        processed_sub_region = {
            "id": sub_region_id,
            "regionId": sub_region_data.get("RegionId"),
            "name": sub_region_name,
            "description": sub_region_des,
            "level": sub_region_data.get("SubRegionLevel"),
            "type": sub_region_data.get("SubRegionType"),
            "center": sub_region_data.get("SubRegionCenter", []),
            "switchPlayer": sub_region_data.get("SwitchPlayer"),
            "syncPlayerInfo": sub_region_data.get("SyncPlayerInfo", 0),
            "notShowInMap": sub_region_data.get("NotShowInRegionMap", False),
            "defaultQuestPoint": sub_region_data.get("DefaultQuestPoint"),
        }
        
        return processed_sub_region
