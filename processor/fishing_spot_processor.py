from processor.base_processor import BaseProcessor


class FishingSpotProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "FishingSpot"
        # 加载鱼类数据，用于关联鱼池和鱼类
        self.fish_data = data_loader.load_json("Fish.json")
        # 创建鱼类ID到鱼类信息的映射
        self.fish_id_to_info = {}
        for fish_info in self.fish_data.values():
            fish_id = fish_info.get("FishId")
            if fish_id:
                self.fish_id_to_info[fish_id] = fish_info

    def process_item(self, spot_data, language):
        """处理单个鱼池数据

        Args:
            spot_data: 原始鱼池数据
            language: 语言类型

        Returns:
            处理后的鱼池数据
        """
        # 提取基础信息
        spot_id = spot_data.get("FishingSpotId")

        # 处理鱼池名称
        spot_name = spot_data.get("FishingSpotName", "")
        # 如果名称是类似"FishingSpot_Name_10010101"的格式，尝试翻译
        if spot_name.startswith("FishingSpot_Name_"):
            spot_name = self.get_translated_text(spot_name, language)

        # 提取图标路径中的图标名称
        icon_path = spot_data.get("IconPath", "")
        icon = ""
        if icon_path:
            # 从路径中提取文件名，如T_Tab_Angling01.T_Tab_Angling01中的T_Tab_Angling01
            # 找到最后一个斜杠
            last_slash_pos = icon_path.rfind("/")
            if last_slash_pos != -1:
                # 提取文件名部分
                file_name = icon_path[last_slash_pos + 1 :]
                # 提取点之前的部分
                if "." in file_name:
                    icon = file_name.split(".")[0]
                else:
                    icon = file_name

        # 提取包含的鱼类ID列表
        fish_ids = spot_data.get("FishId", [])
        show_fish_ids = spot_data.get("ShowFishId", [])

        # 提取其他相关信息
        water_type = spot_data.get("WaterType")
        fish_count_limit = spot_data.get("FishCountLimit")
        replenish_day = spot_data.get("ReplenishDay")
        show_in_fish_map = spot_data.get("ShowInFishMap", False)
        if fish_count_limit != 100:
            return None

        # 构建处理后的鱼池数据
        processed_spot = {
            "id": spot_id,
            "name": spot_name,
            "icon": icon,
            "waterType": water_type,
            "fishCountLimit": fish_count_limit,
            "replenishDay": replenish_day,
            # "showInFishMap": show_in_fish_map,
            "fishIds": fish_ids,
            "showFishIds": show_fish_ids,
            "weights": spot_data.get("FishWeight", []),
        }

        return processed_spot
