#!/usr/bin/env python3
"""
创建翻译映射文件
从final/i18n文件夹读取各个语言的JSON文件,提取指定字段的翻译
"""

import json
import os
from pathlib import Path
from typing import Dict, List

# ============================================================================
# 配置区域 - 在这里配置需要提取的字段
# ============================================================================
# 字段配置列表: 每个配置包含字段名和输出文件名
# 格式: (字段名, 输出文件名)
#
# 支持四种字段类型:
# 1. 普通字符串字段: 直接提取字段的值
#    例如: ("名称", "translation.json")
#    结果: {"转动命运螺旋Ⅴ": "Fate's Spiral Ⅴ"}
#
# 2. 嵌套对象字段: 提取对象内所有键的翻译
#    例如: ("奖励", "translation.json")
#    结果: {"委托密函线索": "Secret Letter Clue", "勤奋的"称号": "Diligent" Title"}
#    注意: 嵌套字段通过值匹配来找到对应的翻译键
#
# 3. 列表字段: 提取列表内所有字符串元素的翻译
#    例如: ("溯源", "translation.json")
#    结果: {"溯源1": "Origin 1", "溯源2": "Origin 2"}
#    注意: 列表字段按顺序匹配元素
#
# 4. 嵌套列表字段: 提取列表内字典的指定字段值的翻译
#    例如: ("技能.名称", "translation.json")
#    结果: {"残光": "Residual Light", "暗蚀": "Dark Erosion"}
#    注意: 嵌套列表字段通过.分隔，格式为"父字段.子字段"
#
# 示例配置:
# FIELD_CONFIG = [
#     ("名称", "translation.json"),           # 普通字符串字段
#     ("奖励", "translation_reward.json"),    # 嵌套对象字段
#     ("溯源", "translation_origin.json"),     # 列表字段
#     ("技能.名称", "translation_skill_name.json"), # 嵌套列表字段
#     ("技能.描述", "translation_skill_desc.json"), # 嵌套列表字段
# ]
#
# 当前配置: 提取多种字段

allow_types = [
    "Mod",
    "Weapon",
    "Char",
    "Achievement",
    "Monster",
    "Pet",
    "Dungeon",
    "Resource",
    "Npc",
    "QuestChain",
    "SubRegion",
]

FIELD_CONFIG = [
    ("name", "translation.json"),
    ("n", "translation.json"),
    ("chapterName", "translation.json"),
    ("chapterNumber", "translation.json"),
    ("episode", "translation.json"),
    ("名称", "translation.json"),
    ("别名", "translation.json"),
    ("势力", "translation.json"),
    ("分类", "translation.json"),
    ("描述", "translation.json"),
    ("溯源", "translation.json"),
    ("技能.名称", "translation.json"),
    ("技能.描述", "translation.json"),
    ("技能.类型", "translation.json"),
    ("技能.字段.名称", "translation.json"),
    ("技能.字段.格式", "translation.json"),
    ("技能.术语解释", "translation.json"),
    ("同律武器.名称", "translation.json"),
    ("奖励", "translation.json"),  # 嵌套对象 - 提取奖励中所有键的翻译
    # ("效果", "translation_effect.json"),
]

EX_FIELDS = [
    "第一根源",
    "第二根源",
    "第三根源",
    "第四根源",
    "第五根源",
    "第六根源",
    "第七根源",
    "技能",
    "溯源",
    "下落攻击",
    "普通攻击",
    "蓄力攻击",
    "角色",
    "武器",
    "魔之楔",
    "探险/无尽",
    "驱离",
    "拆解",
    "驱逐",
    "避险",
    "扼守/无尽",
    "护送",
    "勘察/无尽",
    "追缉",
    "调停",
    "迁移",
    "经典剧目",
    "热映剧目",
    "不朽剧目",
    "魔灵",
    "夜航手册",
    "委托密函",
    "活力魔灵",
    "失活魔灵",
    "魔灵潜质",
    "海伯利亚",
    "华胥",
    "全部",
    "任意",
    "共情",
    "混沌",
    "才智",
    "道德",
    "功利",
    "头像框",
    "头像",
    "魔之楔",
    "载具",
    "称号",
    "称号框",
    "密函",
    "武器",
    "武器饰品",
    "武器皮肤",
    "出生地",
    "生日",
    "档案",
    "语音",
    "势力",
    "全部类型",
    "单手剑",
    "长柄",
    "重剑",
    "双刀",
    "鞭刃",
    "太刀",
    "手枪",
    "双枪",
    "榴炮",
    "霰弹枪",
    "突击枪",
    "弓",
    "防御",
    "技能穿透",
    "受到的伤害",
    "灾厄熔炉",
    "灾厄熔炼",
    "烛芯",
    "遗物",
    "烛芯类别",
    "提灯",
    "深潜",
    "深潜深度",
    "海伯利亚帝国",
    "无阵营",
    "卢卡共和国",
]

EX_T = {
    # 额外翻译表
    "属性穿透": "全属性穿透",
    "技能伤害": "造成技能伤害",
    "增伤": "造成的伤害",
    "普攻增伤": "普通攻击伤害",
    "蓄力增伤": "蓄力攻击伤害",
    "下落增伤": "下落攻击伤害",
}

CHAR_TAG_LOCATIONS = {}


def load_char_tags_into_ex_t(base_path: Path):
    """从中文角色数据中收集标签，并一次性加入EX_T。"""
    global CHAR_TAG_LOCATIONS

    char_file = base_path / "cn" / "Char.json"
    char_data = load_json_data(char_file)
    if not char_data:
        return

    char_tag_mapping = {}
    CHAR_TAG_LOCATIONS = {}
    for char in char_data:
        tags = char.get("标签", [])
        if not isinstance(tags, list):
            continue

        for index, tag in enumerate(tags):
            if isinstance(tag, str) and tag:
                char_tag_mapping[tag] = f"tag.{tag}"
                CHAR_TAG_LOCATIONS.setdefault(tag, (char.get("id"), index))

    EX_T.update(char_tag_mapping)


def load_char_tag_translations(base_path: Path, lang_code: str) -> Dict[str, str]:
    """读取目标语言角色标签翻译。"""
    if not CHAR_TAG_LOCATIONS:
        return {}

    target_data = load_json_data(base_path / lang_code / "Char.json")
    target_by_id = {item.get("id"): item for item in target_data}
    translations = {}

    for tag, (char_id, index) in CHAR_TAG_LOCATIONS.items():
        target_tags = target_by_id.get(char_id, {}).get("标签", [])
        if isinstance(target_tags, list) and index < len(target_tags):
            target_value = target_tags[index]
            if isinstance(target_value, str):
                translations[tag] = target_value

    return translations


# 是否在输出时添加字段前缀 (例如: "效果:xxx" -> "Effect:xxx")
# 对于嵌套对象,前缀格式为 "字段名:键名" (如 "奖励:委托密函线索")
ADD_FIELD_PREFIX = False

# 是否跳过空值或None值
SKIP_EMPTY_VALUES = False
# ============================================================================


def load_json_data(file_path: Path) -> List[Dict]:
    """加载JSON文件数据"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        print(f"错误: 无法读取文件 {file_path}: {e}")
        return []


def remove_untranslated_entries(mapping: Dict) -> Dict:
    """递归移除键和值相同的未翻译条目。"""
    cleaned_mapping = {}
    for key, value in mapping.items():
        if isinstance(value, dict):
            cleaned_value = remove_untranslated_entries(value)
            if cleaned_value:
                cleaned_mapping[key] = cleaned_value
        elif isinstance(key, str) and isinstance(value, str) and key == value:
            continue
        else:
            cleaned_mapping[key] = value
    return cleaned_mapping


def extract_field_mapping(
    cn_data: List[Dict], target_data: List[Dict], field_name: str
) -> Dict[str, str]:
    """
    提取指定字段的映射
    以中文为键,目标语言为值
    支持四种字段类型:
    1. 普通字符串字段 (如 "名称" 字段)
    2. 嵌套对象字段 (如 "奖励" 字段)
    3. 列表字段 (如 "溯源" 字段)
    4. 嵌套列表字段 (如 "技能.名称" 字段)

    Args:
        cn_data: 中文数据列表
        target_data: 目标语言数据列表
        field_name: 要提取的字段名

    Returns:
        字段值的映射字典
    """
    mapping = {}

    # 检查是否是嵌套列表字段（包含.分隔符）
    is_nested_list_field = "." in field_name

    if is_nested_list_field:
        # 解析嵌套字段
        parent_field, child_field = field_name.split(".", 1)
        matched_count = 0

        # 直接遍历所有中文数据项，确保处理所有角色的技能
        for cn_data_item in cn_data:
            item_id = cn_data_item.get("id")
            if not item_id or parent_field not in cn_data_item:
                continue

            cn_skill_list = cn_data_item[parent_field]
            if not isinstance(cn_skill_list, list):
                continue

            # 找到对应的目标语言数据项
            target_data_item = None
            for td_item in target_data:
                if td_item.get("id") == item_id:
                    target_data_item = td_item
                    break

            if not target_data_item or parent_field not in target_data_item:
                continue

            target_skill_list = target_data_item[parent_field]
            if not isinstance(target_skill_list, list):
                continue

            # 确保技能列表长度匹配
            if len(cn_skill_list) != len(target_skill_list):
                continue

            # 按顺序匹配每个技能
            for cn_skill, target_skill in zip(cn_skill_list, target_skill_list):
                if not isinstance(cn_skill, dict) or not isinstance(target_skill, dict):
                    continue

                # 处理多层嵌套字段：技能.字段.格式
                is_multi_level = child_field.count(".") > 0

                if is_multi_level:
                    # 解析多层嵌套字段，如 "字段.格式" -> ["字段", "格式"]
                    nested_fields = child_field.split(".")

                    # 处理 "技能.字段.名称" 和 "技能.字段.格式" 这种情况
                    # 获取 "技能.字段" 列表
                    cn_field_list = cn_skill.get(nested_fields[0], [])
                    target_field_list = target_skill.get(nested_fields[0], [])

                    if isinstance(cn_field_list, list) and isinstance(
                        target_field_list, list
                    ):
                        # 确保字段列表长度匹配
                        if len(cn_field_list) != len(target_field_list):
                            continue

                        # 遍历中文技能字段列表中的每个子字段
                        for cn_field_item, target_field_item in zip(
                            cn_field_list, target_field_list
                        ):
                            if not isinstance(cn_field_item, dict) or not isinstance(
                                target_field_item, dict
                            ):
                                continue

                            # 获取深层字段名，如 "名称" 或 "格式"
                            deep_field = nested_fields[1]

                            # 获取中文和目标语言的深层字段值
                            cn_deep_value = cn_field_item.get(deep_field)
                            target_deep_value = target_field_item.get(deep_field)

                            # 跳过空值
                            if SKIP_EMPTY_VALUES and (
                                not cn_deep_value or not target_deep_value
                            ):
                                continue

                            # 只添加不同的翻译
                            if cn_deep_value != target_deep_value:
                                key = (
                                    f"{field_name}:{cn_deep_value}"
                                    if ADD_FIELD_PREFIX
                                    else cn_deep_value
                                )
                                if key not in mapping:
                                    mapping[key] = target_deep_value
                                    matched_count += 1
                else:
                    # 处理普通嵌套字段，如 "名称"、"描述"、"类型"、"术语解释"、"字段"
                    cn_skill_value = cn_skill.get(child_field)
                    target_skill_value = target_skill.get(child_field)

                    # 跳过空值
                    if SKIP_EMPTY_VALUES and (
                        not cn_skill_value or not target_skill_value
                    ):
                        continue

                    # 处理字典类型的子字段值（如"术语解释"、"字段"）
                    if isinstance(cn_skill_value, dict) and isinstance(
                        target_skill_value, dict
                    ):
                        # 处理技能字段的键翻译（如"神智消耗" -> "Sanity Cost"）
                        # 按照中文版本键值的索引，用同样的索引查找英文版本的对应字段
                        cn_items = list(cn_skill_value.items())
                        target_items = list(target_skill_value.items())

                        # 确保至少有一个对应字段可以匹配
                        max_match_count = min(len(cn_items), len(target_items))
                        if max_match_count > 0:
                            # 按顺序匹配每个技能字段，中文的第i个字段对应英文的第i个字段
                            for i in range(max_match_count):
                                cn_key, cn_val = cn_items[i]
                                target_key, target_val = target_items[i]

                                # 翻译字段键
                                if cn_key != target_key:
                                    key = (
                                        f"{field_name}:{cn_key}"
                                        if ADD_FIELD_PREFIX
                                        else cn_key
                                    )
                                    if key not in mapping:
                                        mapping[key] = target_key
                                        matched_count += 1

                                # 如果是术语解释，还需要翻译值
                                if child_field == "术语解释":
                                    if cn_val != target_val:
                                        key = (
                                            f"{field_name}:{cn_val}"
                                            if ADD_FIELD_PREFIX
                                            else cn_val
                                        )
                                        if key not in mapping:
                                            mapping[key] = target_val
                                            matched_count += 1
                    else:
                        # 处理非字典类型的子字段值（如"名称"、"描述"、"类型"）
                        # 只添加不同的翻译
                        if cn_skill_value != target_skill_value:
                            key = (
                                f"{field_name}:{cn_skill_value}"
                                if ADD_FIELD_PREFIX
                                else cn_skill_value
                            )
                            if key not in mapping:
                                mapping[key] = target_skill_value
                                matched_count += 1

        print(f"    匹配 {field_name}: {matched_count} 个条目")
        return mapping

    # 收集所有可能的翻译映射
    # 对于嵌套对象,需要收集对象内的键值对
    # 对于列表,需要收集列表内的所有元素
    cn_items = []  # [(id, field_value, value_type), ...]
    # value_type: "string", "dict", "list"

    for item in cn_data:
        if "id" in item and field_name in item:
            value = item[field_name]

            # 跳过空值
            if SKIP_EMPTY_VALUES and not value:
                continue

            # 检查值类型
            if isinstance(value, dict):
                value_type = "dict"
            elif isinstance(value, list):
                value_type = "list"
            else:
                value_type = "string"
            cn_items.append((item["id"], value, value_type))

    target_items = []  # [(id, field_value, value_type), ...]

    for item in target_data:
        if "id" in item and field_name in item:
            value = item[field_name]

            # 跳过空值
            if SKIP_EMPTY_VALUES and not value:
                continue

            # 检查值类型
            if isinstance(value, dict):
                value_type = "dict"
            elif isinstance(value, list):
                value_type = "list"
            else:
                value_type = "string"
            target_items.append((item["id"], value, value_type))

    # 创建ID到目标值的映射
    target_dict_by_id = {
        item_id: (value, value_type) for item_id, value, value_type in target_items
    }

    matched_count = 0

    # 处理每个中文条目
    for item_id, cn_value, cn_value_type in cn_items:
        if item_id not in target_dict_by_id:
            continue

        target_value, target_value_type = target_dict_by_id[item_id]

        # 处理嵌套对象字段 (如 "奖励")
        if cn_value_type == "dict" and target_value_type == "dict":
            # 通过值来匹配对应的键
            # 创建中文值到键的映射
            cn_value_to_keys = {}
            for k, v in cn_value.items():
                if v not in cn_value_to_keys:
                    cn_value_to_keys[v] = []
                cn_value_to_keys[v].append(k)

            # 创建英文值到键的映射
            target_value_to_keys = {}
            for k, v in target_value.items():
                if v not in target_value_to_keys:
                    target_value_to_keys[v] = []
                target_value_to_keys[v].append(k)

            # 通过值匹配,找到对应的键
            for value, cn_keys in cn_value_to_keys.items():
                if value in target_value_to_keys:
                    target_keys = target_value_to_keys[value]

                    # 一对一匹配
                    if len(cn_keys) == 1 and len(target_keys) == 1:
                        cn_key = cn_keys[0]
                        target_key = target_keys[0]

                        if cn_key != target_key:
                            key = (
                                f"{field_name}:{cn_key}" if ADD_FIELD_PREFIX else cn_key
                            )
                            if key not in mapping:
                                mapping[key] = target_key
                                matched_count += 1

                    # 多对多匹配(按顺序)
                    elif len(cn_keys) == len(target_keys):
                        for i in range(len(cn_keys)):
                            cn_key = cn_keys[i]
                            target_key = target_keys[i]

                            if cn_key != target_key:
                                key = (
                                    f"{field_name}:{cn_key}"
                                    if ADD_FIELD_PREFIX
                                    else cn_key
                                )
                                if key not in mapping:
                                    mapping[key] = target_key
                                    matched_count += 1

        # 处理列表字段 (如 "溯源")
        elif cn_value_type == "list" and target_value_type == "list":
            # 确保列表长度匹配
            if len(cn_value) != len(target_value):
                continue

            # 按顺序处理每个列表元素
            for i in range(len(cn_value)):
                cn_list_item = cn_value[i]
                target_list_item = target_value[i]

                # 跳过空值
                if SKIP_EMPTY_VALUES and (not cn_list_item or not target_list_item):
                    continue

                # 只处理字符串类型的列表元素
                if isinstance(cn_list_item, str) and isinstance(target_list_item, str):
                    if cn_list_item != target_list_item:
                        key = (
                            f"{field_name}:{cn_list_item}"
                            if ADD_FIELD_PREFIX
                            else cn_list_item
                        )
                        if key not in mapping:
                            mapping[key] = target_list_item
                            matched_count += 1

        # 处理普通字符串字段
        elif cn_value_type == "string" and target_value_type == "string":
            # 如果不是字典或列表类型,按原来的逻辑处理
            if cn_value != target_value:
                key = f"{field_name}:{cn_value}" if ADD_FIELD_PREFIX else cn_value
                mapping[key] = target_value
                matched_count += 1

    print(f"    匹配 {field_name}: {matched_count} 个条目")
    return mapping


def process_file_type(base_path: Path, file_name: str, lang_code: str):
    """
    处理特定类型的JSON文件
    根据FIELD_CONFIG配置提取所有字段
    """
    print(f"\n处理 {file_name}...")

    # 加载中文数据
    cn_file = base_path / "cn" / file_name
    cn_data = load_json_data(cn_file)
    if not cn_data:
        print(f"  跳过 {file_name}: 中文数据为空")
        return

    # 加载目标语言数据
    target_file = base_path / lang_code / file_name
    target_data = load_json_data(target_file)
    if not target_data:
        print(f"  跳过 {file_name}: {lang_code} 数据为空")
        return

    # 处理每个配置的字段
    for field_name, output_filename in FIELD_CONFIG:
        print(f"  提取字段: {field_name} -> {output_filename}")

        # 提取字段映射
        field_mapping = extract_field_mapping(cn_data, target_data, field_name)

        if not field_mapping:
            print(f"    跳过: 没有找到 {field_name} 字段的数据")
            continue

        # 保存到目标语言文件夹
        output_file = base_path / lang_code / output_filename

        # 如果文件已存在,读取并合并
        if output_file.exists():
            try:
                with open(output_file, "r", encoding="utf-8") as f:
                    existing_data = json.load(f)
                existing_data = remove_untranslated_entries(existing_data)
                existing_data.update(field_mapping)
                field_mapping = existing_data
                print(f"    合并到现有文件: 共 {len(field_mapping)} 个条目")
            except Exception as e:
                print(f"    警告: 无法读取现有文件,将创建新文件: {e}")

        # 保存文件
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(field_mapping, f, ensure_ascii=False, indent=2)

        print(f"    已保存: {output_file.name} ({len(field_mapping)} 个条目)")


def print_config_summary():
    """打印配置摘要"""
    print("\n" + "=" * 60)
    print("当前配置:")
    print("=" * 60)
    print(f"字段数量: {len(FIELD_CONFIG)}")
    print("提取的字段:")
    for i, (field_name, output_file) in enumerate(FIELD_CONFIG, 1):
        print(f"  {i}. 字段名: '{field_name}' -> 输出文件: '{output_file}'")
    print(f"添加字段前缀: {ADD_FIELD_PREFIX}")
    print(f"跳过空值: {SKIP_EMPTY_VALUES}")
    print("=" * 60 + "\n")


def process_ex_fields(base_path: Path, lang_code: str):
    """
    处理扩展字段，从TextMap_I18n.json中获取翻译

    Args:
        base_path: 基础路径
        lang_code: 语言代码
    """
    if not EX_FIELDS:
        return

    print(f"\n处理扩展字段: 语言: {lang_code}")

    # 加载TextMap_I18n.json文件
    textmap_file = Path("./out/TextMap_I18n.json")
    if not textmap_file.exists():
        print(f"  跳过: TextMap_I18n.json 文件不存在")
        return

    with open(textmap_file, "r", encoding="utf-8") as f:
        textmap_data = json.load(f)

    # 合并所有扩展字段到一个映射字典
    ex_mapping = {}

    # 遍历所有扩展字段
    for ex_field in EX_FIELDS:
        # 从TextMap_I18n.json中查找翻译
        for text_key, text_entry in textmap_data.items():
            # 查找中文值为扩展字段的条目
            if text_entry.get("TextMapContent") == ex_field:
                # 根据语言代码获取对应翻译
                lang_field_map = {
                    "cn": "TextMapContent",
                    "en": "ContentEN",
                    "jp": "ContentJP",
                    "kr": "ContentKR",
                    "tc": "ContentTC",
                    "fr": "ContentFR",
                }

                target_field = lang_field_map.get(lang_code, "TextMapContent")
                target_value = text_entry.get(target_field, ex_field)

                if ex_field != target_value:
                    ex_mapping[ex_field] = target_value
                    print(f"  找到扩展字段翻译: {ex_field} -> {target_value}")
                    break

    # 保存扩展字段映射到默认的translation.json文件
    output_file = base_path / lang_code / "translation.json"
    if ex_mapping:
        # 如果文件已存在,读取并合并
        if output_file.exists():
            try:
                with open(output_file, "r", encoding="utf-8") as f:
                    existing_data = json.load(f)
                existing_data = remove_untranslated_entries(existing_data)
                existing_data.update(ex_mapping)
                ex_mapping = existing_data
                print(f"  合并扩展字段到现有文件: 共 {len(ex_mapping)} 个条目")
            except Exception as e:
                print(f"  警告: 无法读取现有文件,将创建新文件: {e}")

        # 保存文件
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(ex_mapping, f, ensure_ascii=False, indent=2)

        print(f"  已保存扩展字段: {output_file.name} ({len(ex_mapping)} 个条目)")
    else:
        print("  跳过: 没有找到扩展字段的翻译")


def process_ex_t(base_path: Path, lang_code: str):
    """
    处理EX_T映射，按key导出到zh-CN，并为其他语言导出对应翻译

    Args:
        base_path: 基础路径
        lang_code: 语言代码
    """
    if not EX_T:
        return

    print(f"\n处理EX_T映射: 语言: {lang_code}")

    output_file = base_path / lang_code / "translation.json"
    ex_t_mapping = {}

    if lang_code == "cn":
        for key, output_path in EX_T.items():
            if "." in output_path:
                set_nested_mapping(ex_t_mapping, output_path, key)
            else:
                ex_t_mapping[key] = output_path
    else:
        textmap_data = {}
        textmap_file = Path(__file__).resolve().parent / "out" / "TextMap_I18n.json"
        if textmap_file.exists():
            with open(textmap_file, "r", encoding="utf-8") as f:
                textmap_data = json.load(f)
        else:
            print("  TextMap_I18n.json 不存在，仅使用角色标签数据")

        char_tag_translations = load_char_tag_translations(base_path, lang_code)
        for key, output_path in EX_T.items():
            cn_value = key if "." in output_path else output_path
            target_value = char_tag_translations.get(key)
            if not target_value and textmap_data:
                target_value = find_translation_by_cn_value(
                    textmap_data, cn_value, lang_code
                )
            if target_value and ("." in output_path or target_value != key):
                if "." in output_path:
                    set_nested_mapping(
                        ex_t_mapping,
                        output_path,
                        target_value.replace("{空格}", " "),
                    )
                else:
                    ex_t_mapping[key] = target_value.replace("{空格}", " ")
                print(f"  找到EX_T翻译: {key} -> {target_value}")

    if not ex_t_mapping:
        print("  跳过: 没有找到EX_T的翻译")
        return

    if output_file.exists():
        try:
            with open(output_file, "r", encoding="utf-8") as f:
                existing_data = json.load(f)
            existing_data = remove_untranslated_entries(existing_data)
            merge_translation_mapping(existing_data, ex_t_mapping)
            ex_t_mapping = existing_data
            print(f"  合并EX_T到现有文件: 共 {len(ex_t_mapping)} 个条目")
        except Exception as e:
            print(f"  警告: 无法读取现有文件,将创建新文件: {e}")

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(ex_t_mapping, f, ensure_ascii=False, indent=2)

    print(f"  已保存EX_T映射: {output_file.name} ({len(ex_t_mapping)} 个条目)")


def set_nested_mapping(mapping: Dict, path: str, value: str):
    """按点号路径设置嵌套翻译值。"""
    parts = path.split(".")
    current = mapping
    for part in parts[:-1]:
        child = current.get(part)
        if not isinstance(child, dict):
            child = {}
            current[part] = child
        current = child
    current[parts[-1]] = value


def merge_translation_mapping(target: Dict, source: Dict):
    """递归合并翻译映射，保留已有嵌套条目。"""
    for key, value in source.items():
        if isinstance(value, dict) and isinstance(target.get(key), dict):
            merge_translation_mapping(target[key], value)
        else:
            target[key] = value


def find_translation_by_cn_value(textmap_data: Dict, cn_value: str, lang_code: str):
    """按中文内容查找对应语言翻译"""
    lang_field_map = {
        "cn": "TextMapContent",
        "en": "ContentEN",
        "jp": "ContentJP",
        "kr": "ContentKR",
        "tc": "ContentTC",
        "fr": "ContentFR",
    }

    target_field = lang_field_map.get(lang_code, "TextMapContent")
    for _, text_entry in textmap_data.items():
        if text_entry.get("TextMapContent") == cn_value:
            return text_entry.get(target_field, cn_value)

    return ""


def extract_root_keys_and_values(base_path: Path) -> Dict[str, str]:
    """
    从zh-CN文件中提取最外层的键值对
    例如: {"暴击":"暴击率", "昂扬":"昂扬"} -> {"暴击":"暴击率", "昂扬":"昂扬"}

    Args:
        base_path: 基础路径

    Returns:
        提取的键值对字典
    """
    root_key_values = {}
    cn_dir = base_path / "cn"

    # 只读取translation.json文件
    translation_file = cn_dir / "translation.json"

    if translation_file.exists():
        try:
            with open(translation_file, "r", encoding="utf-8") as f:
                data = json.load(f)

            # 检查是否是字典类型（最外层是键值对）
            if isinstance(data, dict):
                # 添加所有键值对到字典
                root_key_values.update(data)
            print(
                f"  成功读取文件: {translation_file.name} ({len(root_key_values)} 个键值对)"
            )
        except Exception as e:
            print(f"  警告: 无法读取文件 {translation_file.name}: {e}")
    else:
        print(f"  警告: 文件不存在 {translation_file.name}")

    return root_key_values


def process_root_keys(base_path: Path, lang_code: str, root_key_values: Dict[str, str]):
    """
    处理从zh-CN文件提取的最外层键值对，从TextMap_I18n.json中获取翻译

    Args:
        base_path: 基础路径
        lang_code: 语言代码
        root_key_values: 提取的键值对字典
    """
    if not root_key_values:
        return

    print(f"\n处理最外层键值对: 语言: {lang_code}")

    # 加载TextMap_I18n.json文件
    textmap_file = Path("./out/TextMap_I18n.json")
    if not textmap_file.exists():
        print(f"  跳过: TextMap_I18n.json 文件不存在")
        return

    with open(textmap_file, "r", encoding="utf-8") as f:
        textmap_data = json.load(f)

    # 合并所有键到一个映射字典
    root_mapping = {}

    # 遍历所有提取的键值对
    matched_count = 0
    for root_key, root_value in root_key_values.items():
        # 从TextMap_I18n.json中查找翻译
        found = False
        # 先尝试根据值查找翻译
        for text_key, text_entry in textmap_data.items():
            # 查找中文值为键值的条目
            if text_entry.get("TextMapContent") == root_value:
                # 根据语言代码获取对应翻译
                lang_field_map = {
                    "cn": "TextMapContent",
                    "en": "ContentEN",
                    "jp": "ContentJP",
                    "kr": "ContentKR",
                    "tc": "ContentTC",
                    "fr": "ContentFR",
                }

                target_field = lang_field_map.get(lang_code, "TextMapContent")
                target_value = text_entry.get(target_field, root_key)

                if root_key != target_value:
                    root_mapping[root_key] = target_value.replace("{空格}", " ")
                    matched_count += 1
                    found = True
                    break

        # 如果根据值没有找到翻译，尝试根据键查找翻译
        if not found:
            for text_key, text_entry in textmap_data.items():
                # 查找中文值为键的条目
                if text_entry.get("TextMapContent") == root_key:
                    # 根据语言代码获取对应翻译
                    lang_field_map = {
                        "cn": "TextMapContent",
                        "en": "ContentEN",
                        "jp": "ContentJP",
                        "kr": "ContentKR",
                        "tc": "ContentTC",
                        "fr": "ContentFR",
                    }

                    target_field = lang_field_map.get(lang_code, "TextMapContent")
                    target_value = text_entry.get(target_field, root_key)

                    if root_key != target_value:
                        root_mapping[root_key] = target_value.replace("{空格}", " ")
                        matched_count += 1
                        found = True
                        break

    # 保存键映射到默认的translation.json文件
    output_file = base_path / lang_code / "translation.json"
    if root_mapping:
        # 如果文件已存在,读取并合并
        if output_file.exists():
            try:
                with open(output_file, "r", encoding="utf-8") as f:
                    existing_data = json.load(f)
                existing_data = remove_untranslated_entries(existing_data)
                existing_data.update(root_mapping)
                root_mapping = existing_data
                print(f"  合并键值对到现有文件: 共 {len(root_mapping)} 个条目")
            except Exception as e:
                print(f"  警告: 无法读取现有文件,将创建新文件: {e}")

        # 保存文件
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(root_mapping, f, ensure_ascii=False, indent=2)

        print(f"  已保存键值对翻译: {output_file.name} ({len(root_mapping)} 个条目)")
    else:
        print("  跳过: 没有找到键值对的翻译")


def main():
    """主函数"""
    # 打印配置摘要
    print_config_summary()

    # 验证配置
    if not FIELD_CONFIG:
        print("错误: FIELD_CONFIG 为空,请在文件顶部配置需要提取的字段")
        return

    # 设置基础路径
    script_dir = Path(__file__).parent
    base_path = script_dir / "final" / "i18n"

    if not base_path.exists():
        print(f"错误: 路径不存在 {base_path}")
        return

    # 获取所有语言文件夹
    lang_dirs = [d for d in base_path.iterdir() if d.is_dir() and d.name != "cn"]

    if not lang_dirs:
        print("错误: 未找到语言文件夹")
        return

    print(f"找到语言文件夹: {[d.name for d in lang_dirs]}")

    # 获取中文文件夹中的所有JSON文件
    cn_dir = base_path / "cn"
    if not cn_dir.exists():
        print("错误: 中文文件夹不存在")
        return

    json_files = list(cn_dir.glob("*.json"))

    if not json_files:
        print("错误: 中文文件夹中没有JSON文件")
        return

    print(f"找到JSON文件: {[f.name for f in json_files]}")

    # 只扫描一次中文角色标签，并将其加入EX_T
    load_char_tags_into_ex_t(base_path)

    # 提取最外层的键值对
    root_key_values = extract_root_keys_and_values(base_path)
    print(f"\n提取到最外层键值对: {len(root_key_values)} 个")

    # cn 需要单独写入 EX_T，主循环只处理非 cn 语言
    process_ex_t(base_path, "cn")

    # 对每个语言文件夹处理每个JSON文件
    for lang_dir in lang_dirs:
        lang_code = lang_dir.name
        print(f"\n{'='*60}")
        print(f"处理语言: {lang_code}")
        print(f"{'='*60}")

        for json_file in json_files:
            if json_file.name.split(".")[0] in allow_types:
                process_file_type(base_path, json_file.name, lang_code)

        # 处理扩展字段
        process_ex_fields(base_path, lang_code)

        # 处理最外层键值对
        process_root_keys(base_path, lang_code, root_key_values)

        # 处理EX_T映射，放在最后，确保手工覆盖优先生效
        process_ex_t(base_path, lang_code)

    print(f"\n{'='*60}")
    print("完成!")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
