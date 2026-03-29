from processor.base_processor import BaseProcessor


class HardBossProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "HardBossMain"

        # 加载相关数据表
        self.hard_boss_difficulty_data = data_loader.load_json(
            "HardBossDifficulty.json"
        )

    def process_item(self, hard_boss_data, language):
        """处理单个 HardBoss 数据

        Args:
            hard_boss_data: 原始 HardBoss 数据
            language: 语言类型

        Returns:
            处理后的 HardBoss 数据
        """
        hard_boss_id = hard_boss_data.get("HardBossId")
        name_key = hard_boss_data.get("HardBossName")
        desc_key = hard_boss_data.get("HardBossDes")
        main_icon = hard_boss_data.get("MainIcon")
        monster_icon = hard_boss_data.get("MonsterIcon")
        boss_icon = hard_boss_data.get("BossIcon")
        monster_id = hard_boss_data.get("MonsterId")
        difficulty_ids = hard_boss_data.get("DifficultyId", [])

        # 获取翻译
        name = self.get_translated_text(name_key, language) if name_key else ""
        desc = self.get_translated_text(desc_key, language) if desc_key else ""

        # 提取图标名称，优先使用永久封面图，其次使用 Boss 图标
        icon = self._extract_icon_name(monster_icon, boss_icon, main_icon)

        # 处理难度数据
        diffs = []
        for difficulty_id in difficulty_ids:
            difficulty_data = self.hard_boss_difficulty_data.get(str(difficulty_id))
            if difficulty_data:
                diff_info = {
                    "id": difficulty_id,
                    "lv": difficulty_data.get("DifficultyLevel", 0),
                    "r": difficulty_data.get("DifficultyReward", 0),
                }
                diffs.append(diff_info)

        processed_hard_boss = {
            "id": hard_boss_id,
            "name": name,
            "icon": icon,
            "desc": desc,
            "diff": diffs,
            "mid": monster_id,
        }

        return processed_hard_boss

    def _extract_icon_name(self, *icon_values):
        """提取图标路径中的资源名

        Args:
            icon_values: 候选图标路径

        Returns:
            提取后的图标名称
        """
        import re

        for icon_value in icon_values:
            if not icon_value:
                continue
            match = re.search(r"(T_[^./']+)", icon_value)
            if match:
                return match.group(1)
        return ""

    def process_all_items(self, items, language):
        """处理所有 HardBoss 数据

        Args:
            items: HardBoss 数据列表
            language: 语言类型

        Returns:
            处理后的 HardBoss 数据列表
        """
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        # 按 DisplayPriority 排序
        processed_items.sort(key=lambda x: x.get("id", 0))

        return processed_items
