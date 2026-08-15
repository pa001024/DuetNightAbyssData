from processor.base_processor import BaseProcessor


class MusicScoreProcessor(BaseProcessor):
    """处理 MusicScore。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "MusicScore"

    def process_item(self, item_data, language):
        """处理单个乐谱条目。"""
        icon_path = item_data.get("MusicScorePic", "")
        icon = icon_path.split(".", 1)[-1].rstrip("'")

        name_key = item_data.get("MusicScoreName", "")
        return {
            "id": item_data.get("MusicScoreId"),
            "name": self.get_translated_text(name_key, language) if name_key else "",
            "icon": icon,
        }
