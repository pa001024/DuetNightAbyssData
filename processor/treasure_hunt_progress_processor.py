from collections import OrderedDict
from processor.base_processor import BaseProcessor


class TreasureHuntProgressProcessor(BaseProcessor):
    """秘宝进度导出器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "TreasureHuntProgress"

    def process_item(self, item, language):
        """处理单个秘宝进度数据"""
        event_progress_id = item.get("EventProgressId", 0)
        if not event_progress_id:
            return None

        processed = OrderedDict()
        processed["id"] = event_progress_id

        event_dungeon_id = item.get("EventDugeonId", 0)
        if event_dungeon_id:
            processed["did"] = event_dungeon_id

        progress_text = self.get_translated_text(item.get("EventProgressText", ""), language)
        if progress_text:
            processed["name"] = progress_text

        next_progress_score = item.get("NextProgressScore")
        if next_progress_score is not None:
            processed["score"] = next_progress_score

        pet_con_bp = self._extract_icon_name(item.get("PetConBP", ""))
        if pet_con_bp:
            processed["icon"] = pet_con_bp

        pet_con_text = self.get_translated_text(item.get("PetConText", ""), language)
        if pet_con_text:
            processed["petConText"] = pet_con_text

        progress_condition = item.get("ProgressCondition")
        if progress_condition is not None:
            processed["condition"] = progress_condition

        return processed

    def _extract_icon_name(self, icon_value):
        """从资源路径中提取资源名。"""
        if not isinstance(icon_value, str) or not icon_value:
            return ""

        normalized = icon_value.replace("\\", "/").strip().strip("'")
        base_name = normalized.rsplit("/", 1)[-1]
        if "." in base_name:
            base_name = base_name.split(".", 1)[0]
        return base_name.strip().strip("'")
