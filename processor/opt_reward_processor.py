from processor.base_processor import BaseProcessor


class OptRewardProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "OptReward"
        self.opt_reward_data = data_loader.load_json("OptReward.json")
        self.drop_data = data_loader.load_json("Drop.json")
        self.mod_data = data_loader.load_json("Mod.json")
        self.resource_data = data_loader.load_json("Resource.json")
        self.draft_data = data_loader.load_json("Draft.json")
        self.mount_data = data_loader.load_json("Mount.json")

    def process_item(self, item_data, language, processed_ids=None):
        """
        处理单个自选奖励项目
        :param item_data: 自选奖励数据
        :param language: 目标语言
        :param processed_ids: 已处理的奖励ID集合，用于避免循环引用
        :return: 处理后的自选奖励数据
        """
        if processed_ids is None:
            processed_ids = set()

        reward_id = item_data.get("OptRewardId", 0)
        if not reward_id:
            return None

        current_reward_id = str(reward_id)
        if current_reward_id in processed_ids:
            return {"id": reward_id, "child": []}

        processed_ids.add(current_reward_id)

        processed = {"id": reward_id}

        mode = item_data.get("Mode", "")
        if mode:
            processed["m"] = mode

        reward_icon = self._extract_icon_name(item_data.get("Icon", ""))
        if reward_icon:
            processed["icon"] = reward_icon

        processed["child"] = []

        ids = item_data.get("Id", [])
        types = item_data.get("Type", [])
        params = item_data.get("Param", [])
        counts = item_data.get("Count", [])

        max_len = min(len(ids), len(types))
        while len(params) < max_len:
            params.append(0)
        while len(counts) < max_len:
            counts.append(0)

        for i in range(max_len):
            item_id = ids[i]
            item_type = types[i]

            item_param = params[i]
            if isinstance(item_param, list):
                item_param = item_param[i] if i < len(item_param) else 0

            item_count = counts[i] if i < len(counts) else 0
            if isinstance(item_count, list):
                item_count = item_count[0] if item_count else 0

            item = {"id": item_id, "t": item_type}

            try:
                item_count = int(item_count)
                if item_count > 0:
                    item["c"] = item_count
            except (ValueError, TypeError):
                pass

            if item_param != 0:
                item["p"] = item_param

            original_type = item_type

            if item_type == "Draft":
                draft_item = self.draft_data.get(str(item_id), {})
                product_type = draft_item.get("ProductType", "Draft")
                item["t"] = product_type
                item["d"] = 1

            if item_type == "Drop":
                drop_item = self.drop_data.get(str(item_id), {})
                use_effect_type = drop_item.get("UseEffectType", "")
                use_param = drop_item.get("UseParam", 0)
                if use_effect_type == "GetMod":
                    item["id"] = use_param
                    item["t"] = "Mod"
                    item["dp"] = 1

            item_name = self._get_item_name(item_id, original_type)
            if item_name:
                item["n"] = item_name
                if original_type == "Draft":
                    draft_item = self.draft_data.get(str(item_id), {})
                    item["id"] = draft_item.get("ProductId", 0)

            processed["child"].append(item)

        return processed

    def _get_item_name(self, item_id, item_type):
        """
        根据类型和ID获取项目名称
        :param item_id: 项目ID
        :param item_type: 项目类型
        :return: 项目名称，如果不需要返回名称则返回None
        """
        if item_type == "Drop":
            drop_item = self.drop_data.get(str(item_id), {})
            drop_name = drop_item.get("DropName", "")
            if drop_name:
                return self.get_translated_text(drop_name)
            return self.get_translated_text(str(item_id))
        elif item_type == "Mod":
            mod_item = self.mod_data.get(str(item_id), {})
            return f"{self.get_translated_text(mod_item.get('Name', ''))}".strip()
        elif item_type == "Resource":
            resource_item = self.resource_data.get(str(item_id), {})
            return self.get_translated_text(resource_item.get("ResourceName", ""))
        elif item_type == "Reward":
            return None
        elif item_type == "IronTicket":
            return self.get_translated_text("UI_IronTicket_Survival_Name")
        elif item_type == "Mount":
            mount_item = self.mount_data.get(str(item_id), {})
            return self.get_translated_text(mount_item.get("MountName", ""))
        elif item_type == "Draft":
            draft_item = self.draft_data.get(str(item_id), {})
            product_type = draft_item.get("ProductType", "")
            product_id = draft_item.get("ProductId", 0)

            product_name = ""
            if product_type == "Resource":
                resource_item = self.resource_data.get(str(product_id), {})
                product_name = self.get_translated_text(
                    resource_item.get("ResourceName", "")
                )
            elif product_type == "Mod":
                mod_item = self.mod_data.get(str(product_id), {})
                product_name = f"{self.get_translated_text(mod_item.get('Name', ''))}".strip()
            elif product_type == "Char":
                product_name = self.get_translated_text(f"UI_CHAR_NAME_{product_id}")
            elif product_type == "Weapon":
                product_name = self.get_translated_text(f"UI_WEAPON_NAME_{product_id}")
            elif product_type == "CharAccessory":
                product_name = self.get_translated_text(
                    f"UI_Accessory_Name_{product_id}"
                )
            elif product_type == "IronTicket":
                product_name = self.get_translated_text(
                    "UI_IronTicket_Survival_Name"
                )

            if not product_name:
                product_name = f"{item_type}_{item_id}"

            return product_name
        elif item_type in [
            "Walnut",
            "Item",
            "Char",
            "Weapon",
            "Monster",
            "Title",
            "TitleFrame",
            "CharAccessory",
            "Pet",
            "HeadSculpture",
            "HeadFrame",
            "Skin",
            "WeaponSkin",
            "WeaponAccessory",
        ]:
            try:
                file_name = f"{item_type}.json"
                item_data = self.data_loader.load_json(file_name)
                item_info = item_data.get(str(item_id), {})

                name_field = "Name"
                if item_type == "Weapon":
                    name_field = "WeaponName"
                if item_type == "Skin":
                    name_field = "SkinName"

                if name_field:
                    return self.get_translated_text(item_info.get(name_field, ""))
            except Exception:
                translated = self.get_translated_text(str(item_id))
                return (
                    translated
                    if translated != str(item_id)
                    else f"{item_type}_{item_id}"
                )
        else:
            translated = self.get_translated_text(str(item_id))
            return (
                translated if translated != str(item_id) else f"{item_type}_{item_id}"
            )

    def _extract_icon_name(self, icon_value):
        """截取图标路径中的图标名称。"""
        if not isinstance(icon_value, str) or not icon_value:
            return ""

        normalized = icon_value.replace("\\", "/").strip().strip("'")
        t_pos = normalized.rfind("T_")
        if t_pos != -1:
            icon_name = normalized[t_pos:]
            if "." in icon_name:
                icon_name = icon_name.split(".", 1)[0]
            return icon_name.rstrip("'")

        icon_name = normalized.rsplit("/", 1)[-1]
        if "." in icon_name:
            icon_name = icon_name.split(".", 1)[0]
        return icon_name.rstrip("'")

    def process_all_items(self, items, language):
        """
        处理所有自选奖励项目
        :param items: 自选奖励项目列表
        :param language: 目标语言
        :return: 处理后的自选奖励项目列表
        """
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)
        return processed_items
