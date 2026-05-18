from processor.base_processor import BaseProcessor


class IronTicketProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "IronTicket"

    def process_item(self, item_data, language):
        """处理单个铁券数据。"""
        ticket_id = item_data.get("TicketId", 0)
        if not ticket_id:
            return None

        processed = {
            "id": ticket_id,
            "name": self.get_translated_text(item_data.get("Name", ""), language),
            "desc": self.get_translated_text(item_data.get("DetailDes", ""), language),
            "func": self.get_translated_text(
                item_data.get("FunctionDes", ""), language
            ),
            "icon": self._simplify_icon(item_data.get("Icon", "")),
            "level": item_data.get("Level", 0),
            "rarity": item_data.get("Rarity", 0),
        }

        access_key = item_data.get("AccessKey", [])
        if access_key:
            processed["accessKey"] = access_key

        return processed

    def _simplify_icon(self, icon):
        """把资源路径压成短名。"""
        if not isinstance(icon, str) or not icon:
            return ""

        icon = icon.rsplit("/", 1)[-1]
        if "." in icon:
            icon = icon.split(".", 1)[0]
        return icon
