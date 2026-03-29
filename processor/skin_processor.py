from processor.base_processor import BaseProcessor


class SkinProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Skin"
        self.skin_upgrade_data = data_loader.load_json("SkinUpgrade.json")
        self.hair_data = data_loader.load_json("Hair.json")
        self.head_sculpture_data = data_loader.load_json("HeadSculpture.json")
        self.resource_data = data_loader.load_json("Resource.json")
        self.char_data = data_loader.load_json("Char.json")

        self.resource_map = {}
        for resource_id, resource_info in self.resource_data.items():
            self.resource_map[resource_info.get("ResourceId")] = resource_info

    def process_item(self, skin_data, language):
        """处理单个皮肤数据。"""
        skin_id = skin_data.get("SkinId", 0)
        if not skin_id:
            return None

        processed = {
            "id": skin_id,
            "name": self.get_translated_text(skin_data.get("SkinName", ""), language),
            "desc": self.get_translated_text(skin_data.get("SkinDescribe", ""), language),
            "icon": self._extract_icon_name(skin_data.get("Icon", "")),
            "rarity": skin_data.get("Rarity", 0),
        }

        for key, target_key in [
            ("CharId", "charId"),
            ("SkinTag", "tag"),
        ]:
            value = skin_data.get(key)
            if value not in (None, ""):
                processed[target_key] = value

        release_version = skin_data.get("ReleaseVersion")
        if release_version:
            processed["release"] = self.process_release(release_version)

        default_item = self._process_default_item(
            skin_data.get("DefaultItem", {}), language
        )
        if default_item:
            processed["defaultItem"] = default_item

        level_up = self._process_level_up(skin_id, language)
        if level_up:
            processed["upgrade"] = level_up

        return processed

    def _process_default_item(self, default_item, language):
        """把默认解锁道具转成可读结构。"""
        if not isinstance(default_item, dict) or not default_item:
            return {}

        result = {}
        for item_type, items in default_item.items():
            if not isinstance(items, dict):
                continue

            converted = []
            for item_id, amount in items.items():
                name = self._get_item_name(item_type, item_id, language)
                converted.append(
                    {
                        "id": int(item_id) if str(item_id).isdigit() else item_id,
                        "name": name,
                        "num": amount,
                    }
                )

            if converted:
                result[item_type] = converted

        return result

    def _get_item_name(self, item_type, item_id, language):
        """按类型获取默认道具名称。"""
        try:
            normalized_id = int(item_id)
        except (TypeError, ValueError):
            normalized_id = item_id

        if item_type == "Hair":
            hair = self.hair_data.get(str(normalized_id), {})
            return self.get_translated_text(hair.get("Name", ""))

        if item_type == "HeadSculpture":
            head = self.head_sculpture_data.get(str(normalized_id), {})
            return self.get_translated_text(head.get("Name", ""))

        if item_type == "Resource":
            resource = self.resource_map.get(normalized_id, {})
            return self.get_translated_text(resource.get("ResourceName", ""))

        if item_type == "Title":
            title_data = self.data_loader.load_json("Title.json")
            title = title_data.get(str(normalized_id), {})
            return self.get_translated_text(title.get("Name", ""), language)

        if item_type == "Char":
            char = self.char_data.get(str(normalized_id), {})
            return self.get_translated_text(char.get("Name", ""), language)

        return str(item_id)

    def _process_level_up(self, skin_id, language):
        """处理皮肤升级消耗。"""
        upgrade_info = self.skin_upgrade_data.get(str(skin_id), {})
        if not isinstance(upgrade_info, dict) or not upgrade_info:
            return []

        processed = []
        for step_key in sorted(upgrade_info.keys(), key=lambda x: int(x) if str(x).isdigit() else x):
            step_info = upgrade_info.get(step_key, {})
            if not isinstance(step_info, dict):
                continue

            currency_id = step_info.get("UnlockCurrency")
            resource = self.resource_map.get(currency_id, {})
            processed.append(
                {
                    "step": step_info.get("Step", step_key),
                    "amount": step_info.get("UnlockAmount", 0),
                    "currencyId": currency_id,
                    "currency": self.get_translated_text(
                        resource.get("ResourceName", ""), language
                    ),
                }
            )

        return processed

    def _extract_icon_name(self, icon_value):
        """从资源路径中提取图标名。"""
        if not icon_value:
            return ""

        if isinstance(icon_value, str) and "T_" in icon_value:
            icon_part = icon_value.split("T_", 1)[1]
            icon_part = icon_part.split(".")[0]
            return f"T_{icon_part}".rstrip("'")

        return icon_value
