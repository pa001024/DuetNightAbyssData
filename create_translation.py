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
# 支持两种字段类型:
# 1. 普通字段: 直接提取字段的值
#    例如: ("名称", "translation.json")
#    结果: {"转动命运螺旋Ⅴ": "Fate's Spiral Ⅴ"}
#
# 2. 嵌套对象字段: 提取对象内所有键的翻译
#    例如: ("奖励", "translation_reward.json")
#    结果: {"委托密函线索": "Secret Letter Clue", ""勤奋的"称号": ""Diligent" Title"}
#    注意: 嵌套字段通过值匹配来找到对应的翻译键
#
# 示例配置:
# FIELD_CONFIG = [
#     ("名称", "translation.json"),           # 普通字段
#     ("奖励", "translation_reward.json"),    # 嵌套对象字段
#     ("描述", "translation_description.json"), # 普通字段
# ]
#
# 当前配置: 只提取"名称"字段
FIELD_CONFIG = [
    ("别名", "translation.json"),
    # ("分类", "translation_category.json"),
    # ("描述", "translation.json"),
    # ("奖励", "translation_reward.json"),  # 嵌套对象 - 提取奖励中所有键的翻译
    # ("效果", "translation_effect.json"),
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
    支持嵌套对象字段 (如 "奖励" 字段)

    Args:
        cn_data: 中文数据列表
        target_data: 目标语言数据列表
        field_name: 要提取的字段名

    Returns:
        字段值的映射字典
    """
    mapping = {}

    # 收集所有可能的翻译映射
    # 对于嵌套对象,需要收集对象内的键值对
    cn_items = []  # [(id, field_value, is_dict), ...]

    for item in cn_data:
        if "id" in item and field_name in item:
            value = item[field_name]

            # 跳过空值
            if SKIP_EMPTY_VALUES and not value:
                continue

            # 检查是否是字典对象(嵌套字段如"奖励")
            is_dict = isinstance(value, dict)
            cn_items.append((item["id"], value, is_dict))

    target_items = []  # [(id, field_value, is_dict), ...]

    for item in target_data:
        if "id" in item and field_name in item:
            value = item[field_name]

            # 跳过空值
            if SKIP_EMPTY_VALUES and not value:
                continue

            # 检查是否是字典对象(嵌套字段如"奖励")
            is_dict = isinstance(value, dict)
            target_items.append((item["id"], value, is_dict))

    # 创建ID到目标值的映射
    target_dict_by_id = {
        item_id: (value, is_dict) for item_id, value, is_dict in target_items
    }

    matched_count = 0

    # 处理每个中文条目
    for item_id, cn_value, cn_is_dict in cn_items:
        if item_id not in target_dict_by_id:
            continue

        target_value, target_is_dict = target_dict_by_id[item_id]

        # 处理嵌套对象字段 (如 "奖励")
        if cn_is_dict and target_is_dict:
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

        # 处理普通字段
        elif cn_value and target_value and not cn_is_dict and not target_is_dict:
            # 如果不是字典类型,按原来的逻辑处理
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

    # 对每个语言文件夹处理每个JSON文件
    for lang_dir in lang_dirs:
        lang_code = lang_dir.name
        print(f"\n{'='*60}")
        print(f"处理语言: {lang_code}")
        print(f"{'='*60}")

        for json_file in json_files:
            process_file_type(base_path, json_file.name, lang_code)

    print(f"\n{'='*60}")
    print("完成!")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
