from processor.base_processor import BaseProcessor
import re


class PetEntryProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "PetEntry"
        self.rarity_names = ["", "白", "绿", "蓝", "紫", "金"]
        self.battle_pet_data = data_loader.load_json("BattlePet.json")
        self.skill_grow_data = data_loader.load_json("SkillGrow.json")

    def process_item(self, pet_entry_data, language):
        """处理单个 PetEntry 项目"""
        pet_entry_id = pet_entry_data.get("PetEntryID", 0)
        battle_pet_id = pet_entry_data.get("BattlePetID", 0)
        battle_pet_level = pet_entry_data.get("BattlePetLevel", 1)
        rarity = pet_entry_data.get("Rarity", 1)

        icon = pet_entry_data.get("Icon", "")
        icon_name = self._extract_icon_name(icon)

        pet_entry_name = pet_entry_data.get("PetEntryName", "")
        translated_name = self.get_translated_text(pet_entry_name, language)

        pet_entry_up_id = pet_entry_data.get("PetEntryUPID", 0)

        processed = {
            "id": pet_entry_id,
            "bid": battle_pet_id,
            "icon": icon_name,
            "name": translated_name,
            "r": rarity,
            "upid": pet_entry_up_id,
        }

        desc = self._process_battle_pet_desc(battle_pet_id, battle_pet_level, language)
        if desc:
            processed["desc"] = desc

        processed = {k: v for k, v in processed.items() if v not in [0, "", None, []]}

        return processed

    def _extract_icon_name(self, icon_path):
        """从图标路径中提取图标名称"""
        if not icon_path:
            return ""

        import os

        base_name = os.path.basename(icon_path)
        icon_name = base_name.split(".")[0]
        return icon_name

    def _process_battle_pet_desc(self, battle_pet_id, battle_pet_level, language):
        """处理 BattlePet 的被动技能描述"""
        if not battle_pet_id:
            return None

        battle_pet = self.battle_pet_data.get(str(battle_pet_id))
        if not battle_pet:
            battle_pet = self.battle_pet_data.get(battle_pet_id)
        if not battle_pet:
            return None

        passive_desc_key = battle_pet.get("PassiveEffectDesc", "")
        if not passive_desc_key:
            return None

        passive_effect_params = battle_pet.get("PassiveEffectDescParameter", [])

        skill_desc = self.get_translated_text(passive_desc_key, language)

        if not passive_effect_params:
            return skill_desc

        for i, value in enumerate(passive_effect_params):
            placeholder = f"#{i + 1}"
            param_value = None
            is_percent = False

            if isinstance(value, str) and "$" in value:
                expr_match = re.search(r"\$([^$]+)\$%?", value)
                if expr_match:
                    expr = expr_match.group(1)
                    is_percent = value.endswith("%")
                    param_value = self._calculate_expr_value(
                        expr, battle_pet_id, battle_pet_level, "BattlePet"
                    )

            if param_value is not None:
                rounded_value = self.round_value(param_value)
                value_str = str(rounded_value)
                if is_percent:
                    value_str += "%"
                skill_desc = skill_desc.replace(placeholder, value_str)

        return skill_desc

    def process_all_items(self, items, language):
        """处理所有项目，添加过滤和排序"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        processed_items.sort(key=lambda x: x.get("id", 0))

        return processed_items
