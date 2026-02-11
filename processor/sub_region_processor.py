from processor.base_processor import BaseProcessor


class SubRegionProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SubRegion"

    def process_item(self, item_data, language):
        """处理单个子区域数据

        Args:
            sub_region_data: 原始子区域数据
            language: 语言类型

        Returns:
            处理后的子区域数据
        """
        sub_region_data = item_data
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
            "rid": sub_region_data.get("RegionId"),
            "name": sub_region_name,
            "desc": sub_region_des,
            "map": sub_region_data.get("SubRegionLevel"),
            "pos": sub_region_data.get("SubRegionCenter", []),
        }
        if not processed_sub_region["rid"] or not processed_sub_region["map"]:
            return None
        if not processed_sub_region["pos"]:
            del processed_sub_region["pos"]

        return processed_sub_region
