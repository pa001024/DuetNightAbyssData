from processor.base_processor import BaseProcessor


class SoloTreasureProcessor(BaseProcessor):
    """秘宝玩法导出器"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SoloTreasure"
        self.random_creator_data = data_loader.load_json("RandomCreator.json")

    def process_item(self, item, language):
        """处理单个秘宝副本数据"""
        dungeon_id = item.get("DungeonId", 0)
        if not dungeon_id:
            return None

        rainy_ids = item.get("RainyRandomId", [])
        if isinstance(rainy_ids, dict):
            rainy_ids = list(rainy_ids.values())
        elif not isinstance(rainy_ids, list):
            rainy_ids = [rainy_ids] if rainy_ids else []

        return {
            "id": dungeon_id,
            "desc": self.get_translated_text(item.get("DifficultyDesc", "")),
            "etime": item.get("EvacuationTime", 0),
            "gtime": item.get("GameTotalTime", 0),
            "rtime": item.get("TurnRainyTime", 0),
            "wtime": item.get("WarningTime", 0),
            "gamePlayId": item.get("GamePlayId", []),
            "rainy": self._build_rainy_list(rainy_ids),
        }

    def _build_rainy_list(self, rainy_ids):
        """将 RainyRandomId 展开为内联随机表。"""
        rainy_list = []
        for rainy_id in rainy_ids:
            rainy_item = self.random_creator_data.get(rainy_id)
            if not rainy_item and isinstance(rainy_id, int):
                rainy_item = self.random_creator_data.get(str(rainy_id))
            if not isinstance(rainy_item, dict):
                continue

            random_infos = rainy_item.get("RandomInfos", [])
            if isinstance(random_infos, dict):
                random_infos = list(random_infos.values())
            elif not isinstance(random_infos, list):
                random_infos = [random_infos] if random_infos else []

            rainy_list.append(
                {
                    "id": rainy_item.get("RandomId", rainy_id),
                    "type": rainy_item.get("UnitType", ""),
                    "count": rainy_item.get("Count", 0),
                    "rc": self._build_random_creator_items(random_infos),
                }
            )
        return rainy_list

    def _build_random_creator_items(self, random_infos):
        """将 RandomInfos 压平为 id/w 结构。"""
        result = []
        for info in random_infos:
            if not isinstance(info, dict):
                continue
            unit_id = info.get("UnitId", 0)
            if not unit_id:
                continue
            result.append(
                {
                    "id": unit_id,
                    "w": info.get("Weight", 0),
                }
            )
        return result
