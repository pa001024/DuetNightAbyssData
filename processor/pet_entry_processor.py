from processor.base_processor import BaseProcessor

class PetEntryProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "PetEntry"
        # 稀有度名称映射
        self.rarity_names = ["", "白", "绿", "蓝", "紫", "金"]

    def process_item(self, pet_entry_data, language):
        """处理单个 PetEntry 项目"""
        # 获取基本信息
        pet_entry_id = pet_entry_data.get("PetEntryID", 0)
        battle_pet_id = pet_entry_data.get("BattlePetID", 0)
        battle_pet_level = pet_entry_data.get("BattlePetLevel", 1)
        rarity = pet_entry_data.get("Rarity", 1)
        
        # 处理图标路径，提取图标名称
        icon = pet_entry_data.get("Icon", "")
        icon_name = self._extract_icon_name(icon)
        
        icon_s = pet_entry_data.get("IconS", "")
        icon_s_name = self._extract_icon_name(icon_s)
        
        # 获取翻译后的名称
        pet_entry_name = pet_entry_data.get("PetEntryName", "")
        translated_name = self.get_translated_text(pet_entry_name, language)
        
        # 处理稀有度，转换为中文名称
        rarity_level = min(rarity, len(self.rarity_names) - 1)
        rarity_name = self.rarity_names[rarity_level]
        
        # 处理升级相关信息
        pet_entry_up_count = pet_entry_data.get("PetEntryUPCount", 0)
        pet_entry_up_id = pet_entry_data.get("PetEntryUPID", 0)
        
        # 处理特定宠物ID列表
        specific_pet_ids = pet_entry_data.get("SpecificPetIds", [])
        
        # 构建处理后的数据
        processed = {
            "PetEntryID": pet_entry_id,
            "BattlePetID": battle_pet_id,
            "BattlePetLevel": battle_pet_level,
            "Icon": icon_name,
            "IconS": icon_s_name,
            "Name": translated_name,
            "Rarity": rarity_name,
            "PetEntryUPCount": pet_entry_up_count,
            "PetEntryUPID": pet_entry_up_id,
            "SpecificPetIds": specific_pet_ids
        }
        
        return processed
    
    def _extract_icon_name(self, icon_path):
        """从图标路径中提取图标名称"""
        if not icon_path:
            return ""
        
        # 提取图标名称，例如从 "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Pet_Attr_World.T_Armory_Pet_Attr_World" 中提取 "T_Armory_Pet_Attr_World"
        import os
        base_name = os.path.basename(icon_path)
        icon_name = base_name.split(".")[0]
        return icon_name
    
    def process_all_items(self, items, language):
        """处理所有项目，添加过滤和排序"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)
        
        # 按 PetEntryID 排序
        processed_items.sort(key=lambda x: x.get("PetEntryID", 0))
        
        return processed_items