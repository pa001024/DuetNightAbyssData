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
FIELD_CONFIG = [
    ("名称", "translation.json"),
    ("别名", "translation.json"),
    ("分类", "translation.json"),
    ("描述", "translation.json"),
    ("溯源", "translation.json"),
    ("技能.名称", "translation.json"),
    ("技能.描述", "translation.json"),
    ("技能.类型", "translation.json"),
    ("技能.字段.名称", "translation.json"),
    ("技能.字段.格式", "translation.json"),
    ("技能.术语解释", "translation.json"),
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
]

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

    allow_types = ["Mod", "Weapon", "Char", "Achievement", "Monster"]
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

    print(f"\n{'='*60}")
    print("完成!")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
