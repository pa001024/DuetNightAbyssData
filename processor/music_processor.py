from processor.base_processor import BaseProcessor


class MusicProcessor(BaseProcessor):
    """处理 Music，并复用书系解析器的资源坐标索引。"""

    def __init__(self, data_loader):
        BaseProcessor.__init__(self, data_loader)
        self.file_type = "Music"

    def process_item(self, item_data, language):
        """处理单个音乐条目。"""
        music_id = item_data.get("MusicId")
        name_key = item_data.get("MusicName", "")
        desc_key = item_data.get("MusicDes", "")

        processed = {
            "id": music_id,
            "name": self.get_translated_text(name_key, language) if name_key else "",
            "desc": self.get_translated_text(desc_key, language) if desc_key else "",
            "scoreId": item_data.get("MusicScoreId"),
            "rId": item_data.get("Resource"),
            "music": item_data.get("Event", "").replace("event:", "", 1),
        }

        return processed
