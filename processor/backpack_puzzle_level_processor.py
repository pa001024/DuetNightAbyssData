import re
from processor.base_processor import BaseProcessor


class BackpackPuzzleLevelProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "BackpackPuzzleLevel"

    def process_item(self, item_data, language):
        """处理单个背包拼图关卡数据。"""
        level_id = item_data.get("LevelId", 0)
        if not level_id:
            return None

        processed = {
            "id": level_id,
            "eventId": item_data.get("EventId", 0),
            "name": self.get_translated_text(item_data.get("LevelName", ""), language),
            "desc": self.get_translated_text(item_data.get("LevelDes", ""), language),
            "gridDistribute": self.parse_grid_distribute(item_data.get("GridDistribute")),
            "levelInitialItem": item_data.get("LevelInitialItem", []),
            "targetReward": item_data.get("TargetReward", []),
            "targetScore": item_data.get("TargetScore", []),
        }

        unlock_date = item_data.get("UnlockDate")
        if unlock_date is not None:
            processed["unlockDate"] = self._normalize_time(unlock_date)

        if not processed["eventId"]:
            del processed["eventId"]
        if not processed["name"]:
            del processed["name"]
        if not processed["desc"]:
            del processed["desc"]
        if "unlockDate" in processed and not processed["unlockDate"]:
            del processed["unlockDate"]

        return processed

    def parse_grid_distribute(self, grid_distribute):
        """把字符串形式的 GridDistribute 解析成二维数组。"""
        if isinstance(grid_distribute, list):
            return self._normalize_grid_matrix(grid_distribute)
        if not isinstance(grid_distribute, str):
            return []

        clean_value = grid_distribute.replace("\\n", "").replace("/n", "")
        clean_value = clean_value.replace("\r", "").replace("\n", "")
        rows = []
        for row_str in re.findall(r"\[([^\]]+)\]", clean_value):
            row = []
            for value in re.findall(r"([\-]?\d+)", row_str):
                row.append(int(value))
            if row:
                rows.append(row)
        return rows

    def _normalize_grid_matrix(self, grid_matrix):
        """把已存在的矩阵规范成纯二维数字数组。"""
        result = []
        for row in grid_matrix:
            if not isinstance(row, list):
                continue
            result.append([int(value) if value is not None else 0 for value in row])
        return result

    def _normalize_time(self, value):
        if hasattr(value, "GetTime"):
            try:
                return value.GetTime()
            except Exception:
                return value
        return value
