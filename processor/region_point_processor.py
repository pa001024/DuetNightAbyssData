from processor.base_processor import BaseProcessor


class RegionPointProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RegionPoint"

    def process_item(self, point_data, language):
        """处理单个区域点数据

        Args:
            point_data: 原始区域点数据
            language: 语言类型

        Returns:
            处理后的区域点数据
        """
        point_id = point_data.get("Id")
        
        name_key = point_data.get("Name")
        point_name = ""
        if name_key:
            point_name = self.get_translated_text(name_key, language)
        
        icon_path = point_data.get("Icon", "")
        icon = ""
        if "T_Gp_" in icon_path:
            t_pos = icon_path.rfind("T_Gp_")
            if t_pos != -1:
                icon_part = icon_path[t_pos:]
                if "." in icon_part:
                    icon = icon_part.split(".")[0]
                else:
                    icon = icon_part
                icon = icon.rstrip("'")
        
        processed_point = {
            "id": point_id,
            "name": point_name,
            "icon": icon,
            "pos": point_data.get("Pos", []),
            "subRegion": point_data.get("SubRegion"),
            "targetSubRegion": point_data.get("TargetSubRegion", []),
            "telepointId": point_data.get("TelepointId"),
            "teleportPointPos": point_data.get("TeleportPointPos"),
            "teleportSubRegion": point_data.get("TeleportSubRegion"),
            "unlockConditionId": point_data.get("UnlockConditionId"),
            "manualItemId": point_data.get("ManualItemId"),
            "staticId": point_data.get("StaticId"),
            "singleCreate": point_data.get("SingleCreate", False),
        }
        
        return processed_point
