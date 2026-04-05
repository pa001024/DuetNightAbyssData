import re
from processor.base_processor import BaseProcessor


class BackpackPuzzleItemProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "BackpackPuzzleItem"
        self.puzzle_item_template_data = data_loader.load_json("PuzzleItemTemplate.json")
        self.puzzle_item_template_map = {}
        for _, item_info in self.puzzle_item_template_data.items():
            self.puzzle_item_template_map[item_info.get("ItemId")] = item_info

    def process_item(self, item_data, language):
        """处理单个拼图道具数据。"""
        item_id = item_data.get("ItemId", 0)
        if not item_id:
            return None

        processed = {
            "id": item_id,
            "name": self.get_translated_text(item_data.get("ItemName", ""), language),
            "type": item_data.get("ItemType", ""),
            "itemGrid": self.parse_grid_distribute(item_data.get("ItemGrid")),
        }

        icon = self._extract_icon_name(item_data.get("GUIPath", ""))
        if icon:
            processed["icon"] = icon

        basic_point = item_data.get("BasicPoint")
        if basic_point is not None:
            processed["basicPoint"] = basic_point

        max_ammo = item_data.get("MaxAmmo")
        if max_ammo is not None:
            processed["maxAmmo"] = max_ammo

        max_stack = item_data.get("MaxStack")
        if max_stack is not None:
            processed["maxStack"] = max_stack

        if item_data.get("IsMirror"):
            processed["isMirror"] = True

        template_info = self.puzzle_item_template_map.get(item_id, {})
        current_ammo = template_info.get("CurrentAmmo")
        if current_ammo is not None:
            processed["currentAmmo"] = current_ammo

        template_id = template_info.get("TemplateId")
        if template_id is not None:
            processed["templateId"] = template_id

        if not processed["name"]:
            del processed["name"]
        if not processed["type"]:
            del processed["type"]
        if not processed["itemGrid"]:
            del processed["itemGrid"]

        return processed

    def parse_grid_distribute(self, grid_distribute):
        """把字符串形式的格子定义解析成二维数组。"""
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
        result = []
        for row in grid_matrix:
            if not isinstance(row, list):
                continue
            result.append([int(value) if value is not None else 0 for value in row])
        return result

    def _extract_icon_name(self, gui_path):
        """从资源路径中提取图标名。"""
        if not gui_path:
            return ""

        match = re.search(r"(T_[^./']+)", gui_path)
        if match:
            return match.group(1)

        return ""
