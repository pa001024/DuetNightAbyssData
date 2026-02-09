from processor.base_processor import BaseProcessor


class RegionReputationProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RegionReputation"
        self.reputation_entrust_data = data_loader.load_json("ReputationEntrust.json")
        self.reputation_level_data = data_loader.load_json("ReputationLevel.json")
        self.resource_data = data_loader.load_json("Resource.json")

    def process_all_items(self, items, language):
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)
        processed_items.sort(key=lambda x: x.get("id", 0))
        return processed_items

    def process_item(self, item_data, language):
        reputation_id = item_data.get("ReputationID")
        if not reputation_id:
            return None

        name = self.get_translated_text(item_data.get("RegionName", ""), language)
        icon = self._extract_icon(item_data.get("RegionIconPath", ""))

        refresh_cost = {}
        refresh_type = item_data.get("ManualRefreshType")
        refresh_id = item_data.get("ManualRefreshId")
        refresh_count = item_data.get("ManualRefreshCount")
        if refresh_type == "Resource" and refresh_id and refresh_count:
            resource_name = self._get_resource_name(refresh_id, language)
            refresh_cost[resource_name] = refresh_count

        levels = []
        for level_data in self.reputation_level_data.get(str(reputation_id), []):
            levels.append(
                {
                    "lv": level_data.get("ReputationLevel", 0),
                    "exp": level_data.get("ReputationLevelMaxExp", 0),
                    "reward": level_data.get("Reward", 0),
                }
            )
        levels.sort(key=lambda x: x.get("lv", 0))

        entrusts = []
        for entrust_data in self.reputation_entrust_data.values():
            if entrust_data.get("ReputationID") != reputation_id:
                continue

            item_types = entrust_data.get("Type", [])
            item_ids = entrust_data.get("Id", [])
            item_counts = entrust_data.get("Count", [])
            item_len = min(len(item_types), len(item_ids), len(item_counts))

            items = []
            for index in range(item_len):
                items.append([item_types[index], item_ids[index], item_counts[index]])

            entrusts.append(
                {
                    "id": entrust_data.get("Key", 0),
                    "name": self.get_translated_text(
                        entrust_data.get("EntrustTitle", ""), language
                    ),
                    "desc": self.get_translated_text(
                        entrust_data.get("EntrustContent", ""), language
                    ),
                    "icon": self._extract_icon(entrust_data.get("Icon", "")),
                    "exp": entrust_data.get("ExpCount", 0),
                    "weight": entrust_data.get("Weight", 0),
                    "items": items,
                }
            )

        entrusts.sort(key=lambda x: x.get("id", 0))

        return {
            "id": reputation_id,
            "name": name,
            "icon": icon,
            "refreshCost": refresh_cost,
            "weekLimit": item_data.get("WeekLimit", 0),
            "levels": levels,
            "entrusts": entrusts,
        }

    def _extract_icon(self, icon_path):
        if not icon_path:
            return ""
        return icon_path.split("/")[-1].split(".")[0].replace("'", "")

    def _get_resource_name(self, resource_id, language):
        resource_item = self.resource_data.get(str(resource_id), {})
        resource_name_key = resource_item.get("ResourceName", "")
        translated = self.get_translated_text(resource_name_key, language)
        return translated if translated else str(resource_id)
