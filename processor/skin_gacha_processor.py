from typing import Dict, List, Optional, Any

from processor.base_processor import BaseProcessor


def _pick(arr: Any, idx: int) -> Optional[Any]:
    """从并行数组中取第 idx 项，兼容二维 Count（取首元素），越界返回 None。"""
    if not isinstance(arr, list) or idx >= len(arr):
        return None
    v = arr[idx]
    if isinstance(v, list):
        return v[0] if v else None
    return v


def _map_type_str(type_int) -> Optional[str]:
    """将 SkinGachaItem 的整型 Type 映射为类别字符串。"""
    return {2: "Skin", 4: "CharAccessory", 6: "Resource"}.get(type_int)


def _build_reward_entry(
    raw_id: Any,
    category: Optional[str],
    name: Optional[str],
    probability: Optional[Any] = None,
    count: Optional[Any] = None,
) -> Dict[str, Any]:
    """构建与 Reward 导出器一致的掉落物条目：id / t / p / c / n。

    - id: 物品 id
    - t:  解析后的类别字符串（Skin / CharAccessory / Resource），未解析则省略
    - p:  权重/概率，仅当 != 0 时保留（与 Reward 导出器一致）
    - c:  数量，仅当 > 0 时保留（与 Reward 导出器一致）
    - n:  名称，仅当可解析时保留
    原始 type（整型枚举）与 category 字段已移除。
    """
    entry: Dict[str, Any] = {"id": raw_id}
    if category:
        entry["t"] = category
    if probability is not None and probability != 0:
        entry["p"] = probability
    if count is not None and count > 0:
        entry["c"] = count
    if name:
        entry["n"] = name
    return entry


class SkinGachaProcessor(BaseProcessor):
    """处理皮肤卡池（SkinGacha）主数据。

    仅保留卡池自身字段与必要的标量引用（tabId），跨表信息（分页明细、累计奖励）
    交由独立的 SkinGachaTab / SkinGachaCumulative 导出，避免重复内联。
    """

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SkinGacha"

        # 关联表（仅用于补全类型名称等标量信息）
        self.skin_gacha_type_data = data_loader.load_json("SkinGachaType.json")

    def process_item(self, pool_data, language):
        """处理单个皮肤卡池。"""
        gacha_id = pool_data.get("GachaId")
        if gacha_id in (None, ""):
            return None

        gacha_type = pool_data.get("GachaType", "")
        type_info = self.skin_gacha_type_data.get(gacha_type, {}) if isinstance(
            self.skin_gacha_type_data, dict
        ) else {}

        processed = {
            "id": gacha_id,
            "name": self.get_translated_text(pool_data.get("GachaName", ""), language),
            "desc": self.get_translated_text(pool_data.get("GachaDes", ""), language),
            "warning": self.get_translated_text(pool_data.get("GachaWarning", ""), language),
            "coreDes": self.get_translated_text(pool_data.get("GachaCoreDes", ""), language),
            "coreDesColor": pool_data.get("GachaCoreDesColor"),
            # 类型名称（翻译后），不再保留原始枚举
            "type": self.get_translated_text(type_info.get("GachaTypeName", ""), language),
            "subTabId": type_info.get("SubTabId"),
            # 分页仅保留标量引用，明细见 SkinGachaTab 导出
            "tabId": pool_data.get("TabId"),
            "sequence": pool_data.get("Sequence"),
            "gachaTimes": pool_data.get("GachaTimes"),
            "displayType": pool_data.get("GachaDisplayType"),
            "historyType": pool_data.get("GachaHistoryType"),
            "hideCountdown": pool_data.get("IsHIdeCountdown"),
        }

        # 可选的时间字段
        for src_key, target_key in [
            ("GachaStartTime", "startTime"),
            ("GachaEndTime", "endTime"),
        ]:
            value = pool_data.get(src_key)
            if value is not None:
                processed[target_key] = value

        # 抽奖消耗（卡池自身字段）
        processed["cost"] = {
            "res": pool_data.get("GachaCostRes"),
            "num10": pool_data.get("GachaCostNum10"),
            "displayRes": pool_data.get("DisplayCostRes"),
        }

        processed["probabilityId"] = pool_data.get("ProbabilityId")
        processed["conditionId"] = pool_data.get("ConditionId")

        # 星级掉落池仅保留标量引用（GachaItemId），掉落明细见 SkinGachaItem 导出
        processed["star3ItemId"] = pool_data.get("Star3ItemId")
        processed["star4ItemId"] = pool_data.get("Star4ItemId")
        processed["star5ItemId"] = pool_data.get("Star5ItemId")

        return processed


class SkinGachaTabProcessor(BaseProcessor):
    """处理皮肤卡池分页（SkinGachaTab）。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SkinGachaTab"

    def process_item(self, tab_data, language):
        tab_id = tab_data.get("TabId")
        if tab_id in (None, ""):
            return None
        return {
            "tabId": tab_id,
            "name": self.get_translated_text(tab_data.get("TabName", ""), language),
            "icon": self._extract_asset_name(tab_data.get("Icon", "")),
            "reddotNode": tab_data.get("ReddotNode"),
            "sequence": tab_data.get("Sequence"),
            "gachaIds": tab_data.get("GachaId", []),
        }

    def _extract_asset_name(self, path_value) -> str:
        if not path_value:
            return ""
        text = str(path_value).strip().rstrip("'")
        text = text.split("/")[-1]
        return text.split(".")[0]


class SkinGachaTypeProcessor(BaseProcessor):
    """处理皮肤卡池类型（SkinGachaType）。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SkinGachaType"

    def process_item(self, type_data, language):
        gacha_type = type_data.get("GachaType", "")
        if not gacha_type:
            return None
        return {
            "type": gacha_type,
            "name": self.get_translated_text(type_data.get("GachaTypeName", ""), language),
            "subTabId": type_data.get("SubTabId"),
        }


class SkinGachaItemProcessor(BaseProcessor):
    """处理皮肤卡池掉落物定义（SkinGachaItem）。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SkinGachaItem"
        self.skin_data = data_loader.load_json("Skin.json")
        self.char_accessory_data = data_loader.load_json("CharAccessory.json")
        self.resource_data = data_loader.load_json("Resource.json")

    def process_item(self, item_data, language):
        gacha_item_id = item_data.get("GachaItemId")
        if gacha_item_id in (None, ""):
            return None

        ids = item_data.get("Id", [])
        types = item_data.get("Type", [])
        probs = item_data.get("Probability", [])
        counts = item_data.get("Count", [])

        rewards = []
        for idx, raw_id in enumerate(ids):
            name, category = self._resolve_item_name(raw_id, language)
            if not category and idx < len(types):
                category = _map_type_str(types[idx])
            prob = _pick(probs, idx)
            cnt = _pick(counts, idx)
            rewards.append(_build_reward_entry(raw_id, category, name, prob, cnt))

        return {"id": gacha_item_id, "rewards": rewards}

    def _resolve_item_name(self, item_id, language):
        key = str(item_id)
        skin = self.skin_data.get(key)
        if isinstance(skin, dict) and skin:
            return self.get_translated_text(skin.get("SkinName", ""), language), "Skin"
        accessory = self.char_accessory_data.get(key)
        if isinstance(accessory, dict) and accessory:
            return self.get_translated_text(accessory.get("Name", ""), language), "CharAccessory"
        resource = self.resource_data.get(key)
        if isinstance(resource, dict) and resource:
            return (
                self.get_translated_text(resource.get("ResourceName", ""), language),
                "Resource",
            )
        return None, None


class SkinGachaCumulativeProcessor(BaseProcessor):
    """处理皮肤卡池累计奖励（SkinGachaCumulative）。"""

    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "SkinGachaCumulative"
        self.reward_data = data_loader.load_json("Reward.json")
        self.skin_data = data_loader.load_json("Skin.json")
        self.char_accessory_data = data_loader.load_json("CharAccessory.json")
        self.resource_data = data_loader.load_json("Resource.json")

    def process_item(self, cumulative_data, language):
        gacha_id = cumulative_data.get("GachaId")
        if gacha_id in (None, ""):
            return None

        reward_ids = cumulative_data.get("RewardId", [])
        targets = cumulative_data.get("RewardTarget", [])
        rewards = []
        for idx, reward_id in enumerate(reward_ids):
            entry = {
                "rewardId": reward_id,
                "target": targets[idx] if idx < len(targets) else None,
            }
            reward_def = self._resolve_reward_def(reward_id, language)
            if reward_def is not None:
                entry["items"] = reward_def.get("items", [])
                entry["mode"] = reward_def.get("mode")
            rewards.append(entry)

        return {"gachaId": gacha_id, "rewards": rewards}

    def _resolve_reward_def(self, reward_id, language) -> Optional[Dict[str, Any]]:
        reward = self.reward_data.get(str(reward_id), {})
        if not isinstance(reward, dict) or not reward:
            return None

        ids = reward.get("Id", [])
        types = reward.get("Type", [])
        counts = reward.get("Count", [])

        items = []
        for idx, raw_id in enumerate(ids):
            name, category = self._resolve_item_name(raw_id, language)
            # 类别回退到 Reward 原始类型字符串，保证 t 始终存在（与 Reward 导出器一致）
            if not category and idx < len(types):
                category = types[idx]
            cnt = _pick(counts, idx)
            items.append(_build_reward_entry(raw_id, category, name, None, cnt))
        return {"id": reward_id, "mode": reward.get("Mode"), "items": items}

    def _resolve_item_name(self, item_id, language):
        key = str(item_id)
        skin = self.skin_data.get(key)
        if isinstance(skin, dict) and skin:
            return self.get_translated_text(skin.get("SkinName", ""), language), "Skin"
        accessory = self.char_accessory_data.get(key)
        if isinstance(accessory, dict) and accessory:
            return self.get_translated_text(accessory.get("Name", ""), language), "CharAccessory"
        resource = self.resource_data.get(key)
        if isinstance(resource, dict) and resource:
            return (
                self.get_translated_text(resource.get("ResourceName", ""), language),
                "Resource",
            )
        return None, None


# 供 step3_output.py 批量注册
SKIN_GACHA_PROCESSOR_CLASSES = {
    "SkinGacha": SkinGachaProcessor,
    "SkinGachaTab": SkinGachaTabProcessor,
    "SkinGachaType": SkinGachaTypeProcessor,
    "SkinGachaItem": SkinGachaItemProcessor,
    "SkinGachaCumulative": SkinGachaCumulativeProcessor,
}
