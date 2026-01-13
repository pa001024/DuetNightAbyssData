from processor.base_processor import BaseProcessor


class FishProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Fish"
        self.resource_data = data_loader.load_json("Resource.json")
        # 创建ResourceId到资源信息的映射，方便快速查找
        self.resource_map = {}
        for resource_id, resource_info in self.resource_data.items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

    def process_item(self, fish_data, language):
        """处理单个鱼类数据

        Args:
            fish_data: 原始鱼类数据
            language: 语言类型

        Returns:
            处理后的鱼类数据
        """
        # 提取基础信息
        fish_id = fish_data.get("FishId")
        fish_level = fish_data.get("FishLevel")
        fish_type = fish_data.get("FishType")
        fish_length = fish_data.get("FishLength", [0, 0])

        # 通过ResourceId获取鱼类名称
        resource_id = fish_data.get("ResourceId")
        fish_name = ""
        if resource_id in self.resource_map:
            resource_info = self.resource_map[resource_id]
            resource_name_key = resource_info.get("ResourceName")
            if resource_name_key:
                fish_name = self.get_translated_text(resource_name_key, language)

        # 提取图标路径中的T_Fish_后面的部分
        icon_path = fish_data.get("IconPath", "")
        icon = ""
        if "T_Fish_" in icon_path:
            # 找到T_Fish_的位置，然后提取后面的值
            t_fish_pos = icon_path.find("T_Fish_")
            if t_fish_pos != -1:
                # 提取从T_Fish_开始到下一个点之前的部分
                icon_part = icon_path[t_fish_pos:]
                if "." in icon_part:
                    icon = icon_part.split(".")[0]
                else:
                    icon = icon_part.replace("T_Fish_", "")

        # 构建处理后的鱼类数据
        processed_fish = {
            "id": fish_id,
            "name": fish_name,
            "level": fish_level,
            "type": fish_type,
            "length": fish_length,
            "icon": icon,
            "price": fish_data.get("PriceOnWeight", []),
            "appear": fish_data.get("FishAppearPeriod", []),
            "s2b": fish_data.get("Small2BigFishId", 0),
            "var": fish_data.get("VariationFishId", []),
            "varProb": fish_data.get("VariationProb", 0),
        }
        if not processed_fish["var"]:
            del processed_fish["var"]
        if not processed_fish["varProb"]:
            del processed_fish["varProb"]
        if not processed_fish["s2b"]:
            del processed_fish["s2b"]

        return processed_fish
