import re

from processor.base_processor import BaseProcessor


class HeadFrameProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "HeadFrame"

    def process_item(self, item_data, language):
        """处理单个头像框数据"""
        frame_id = item_data.get("FrameID", 0)
        if not frame_id:
            return None

        processed = {
            "id": frame_id,
            "name": self.get_translated_text(item_data.get("Name", ""), language),
            "desc": self.get_translated_text(item_data.get("Des", ""), language),
            "icon": self._extract_icon_name(item_data.get("Icon", "")),
            "access": self.get_translated_text(item_data.get("AccessText", ""), language),
        }

        if not processed["access"]:
            del processed["access"]

        return processed

    def _extract_icon_name(self, icon_value):
        """从Icon字段中提取图标名，兼容纯路径和Texture2D格式"""
        if not icon_value:
            return ""

        match = re.search(r"(T_[^./']+)", icon_value)
        if match:
            return match.group(1)

        return ""
