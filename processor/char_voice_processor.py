import json
from collections import OrderedDict
from processor.base_processor import BaseProcessor


class CharVoiceProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "CharVoice"

    def load_items(self, file_path):
        """加载并扁平化角色语音数据。"""
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        if not isinstance(data, dict):
            return []

        items = []
        for char_voice_map in data.values():
            if not isinstance(char_voice_map, dict):
                continue
            for voice_data in char_voice_map.values():
                if isinstance(voice_data, dict):
                    items.append(voice_data)
        return items

    def process_item(self, item_data, language):
        """处理单个角色语音数据。"""
        voice_id = item_data.get("VoiceId", 0)
        char_id = item_data.get("CharId", 0)
        if not voice_id or not char_id:
            return None

        voice_desc = item_data.get("VoiceDes", [])
        if isinstance(voice_desc, str):
            voice_desc = [voice_desc]
        elif not isinstance(voice_desc, list):
            voice_desc = []

        voice_res = item_data.get("VoiceRes", [])
        if not isinstance(voice_res, list):
            voice_res = []

        voice_text = item_data.get("VoiceText", [])
        if not isinstance(voice_text, list):
            voice_text = []

        text_key = voice_text[0] if voice_text else ""

        return {
            "id": voice_id,
            "charId": char_id,
            "name": "".join(
                self.get_translated_text(name_key, language)
                for name_key in voice_desc
                if name_key
            ),
            "res": voice_res[0] if voice_res else "",
            "text": self.get_translated_text(text_key, language),
        }
