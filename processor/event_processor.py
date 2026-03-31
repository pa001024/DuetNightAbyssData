from processor.base_processor import BaseProcessor


class EventProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Event"
        self.box_drop_data = data_loader.load_json("BoxDrop.json")
        self.box_drop_index = {}

        if isinstance(self.box_drop_data, dict):
            box_drop_items = self.box_drop_data.values()
        else:
            box_drop_items = self.box_drop_data

        for item in box_drop_items:
            event_id = item.get("EventId", 0)
            if event_id:
                self.box_drop_index[str(event_id)] = item

    def process_all_items(self, items, language):
        """按 EventId 排序输出活动数据。"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        processed_items.sort(key=lambda x: x.get("id", 0))
        return processed_items

    def process_item(self, item_data, language):
        event_id = item_data.get("EventId", 0)
        if not event_id:
            return None

        processed = {
            "id": event_id,
            "name": self.get_translated_text(item_data.get("EventName", ""), language),
            "desc": self.get_translated_text(item_data.get("EventDes", ""), language),
            "startTime": self._normalize_time(item_data.get("EventStartTime")),
            "endTime": self._normalize_time(item_data.get("EventEndTime")),
        }
        rule = self.get_translated_text(item_data.get("EventRule", ""), language)
        if rule:
            processed["rule"] = rule

        box_drop = self.box_drop_index.get(str(event_id))
        if box_drop:
            processed["boxDrop"] = self._lower_first_keys(box_drop)

        return processed

    def _normalize_time(self, value):
        if hasattr(value, "GetTime"):
            try:
                return value.GetTime()
            except Exception:
                return value
        return value

    def _lower_first_keys(self, data):
        if not isinstance(data, dict):
            return data

        result = {}
        for key, value in data.items():
            if isinstance(key, str) and key:
                new_key = key[0].lower() + key[1:]
            else:
                new_key = key
            result[new_key] = value
        return result
