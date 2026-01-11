import os
import json
from collections import OrderedDict

# 定义文件路径
i18n_file = ".\\out\\TextMap_I18n.json"
out_base_dir = ".\\out\\i18n"

# 定义需要翻译的文件类型
file_types = [
    "Achievement",
    "Char",
    "Weapon",
    "Monster",
    "Mod",
    "Skill",
    "AchievementType",
    "Reward",
    "Resource",
    "Draft",
    "Title",
    "TitleFrame",
    "AttrConfig",  # 属性
    "ModTag",  # MOD适用类型
    "Monster",
    "ArchiveTab",
]


# 读取TextMap_I18n.json到字典
def load_i18n_data():
    with open(i18n_file, "r", encoding="utf-8") as f:
        return json.load(f, object_pairs_hook=OrderedDict)


# 读取指定类型的JSON文件到字典
def load_data(file_type):
    file_path = f".\out\{file_type}.json"
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f, object_pairs_hook=OrderedDict)


# 获取所有支持的语言
def get_supported_languages(i18n_data):
    languages = set()
    # 将dict_values转换为列表后再切片
    for text_data in list(i18n_data.values())[1:3]:
        for key in text_data.keys():
            if key.startswith("Content"):
                languages.add(key)
    # 添加cn语言，使用TextMapContent
    languages.add("TextMapContent")
    return languages


# 翻译数据


def translate_value(value, i18n_data, language_key):
    """翻译单个值，支持字符串、字典、列表等嵌套结构"""
    if isinstance(value, str) and value in i18n_data:
        if language_key == "TextMapContent":
            # 使用TextMapContent作为cn翻译
            translated_value = i18n_data[value].get("TextMapContent", value)
        else:
            # 使用对应语言的翻译，如果没有则使用TextMapContent
            translated_value = i18n_data[value].get(
                language_key, i18n_data[value].get("TextMapContent", value)
            )
        # 去除翻译文本中的{空格}占位符
        translated_value = translated_value.replace("{空格}", " ")
        return translated_value
    elif isinstance(value, list):
        # 处理数组类型，递归翻译数组中的每个元素
        translated_list = []
        for item in value:
            translated_list.append(translate_value(item, i18n_data, language_key))
        return translated_list
    elif isinstance(value, dict):
        # 处理字典类型，递归翻译字典中的每个值
        translated_dict = {}
        for key, val in value.items():
            translated_dict[key] = translate_value(val, i18n_data, language_key)
        return translated_dict
    else:
        return value


def translate_data(data, i18n_data, language_key):
    translated_data = {}

    # 处理字典格式数据
    if isinstance(data, dict):
        for item_id, item in data.items():
            # 翻译值，支持字符串、字典、列表等嵌套结构
            translated_item = translate_value(item, i18n_data, language_key)
            translated_data[item_id] = translated_item
    # 处理列表格式数据
    elif isinstance(data, list):
        # 保持列表结构，不将其转换为字典
        translated_data = []
        for item in data:
            # 翻译值，支持字符串、字典、列表等嵌套结构
            translated_item = translate_value(item, i18n_data, language_key)
            translated_data.append(translated_item)

    return translated_data


# 翻译并保存单个文件类型+语言组合
def translate_and_save(file_type, data, i18n_data, lang_key, out_base_dir):
    """翻译并保存单个文件类型+语言组合"""
    try:
        # 生成语言文件夹名
        if lang_key == "TextMapContent":
            # 使用cn作为简体中文的文件夹名
            lang_folder = "cn"
        else:
            lang_folder = lang_key.replace("Content", "").lower()
        lang_dir = os.path.join(out_base_dir, lang_folder)
        os.makedirs(lang_dir, exist_ok=True)

        # 翻译数据
        translated_data = translate_data(data, i18n_data, lang_key)

        # 保存翻译后的数据，使用原文件名
        output_file = os.path.join(lang_dir, f"{file_type}.json")
        with open(output_file, "w", encoding="utf-8") as f:
            json.dump(translated_data, f, ensure_ascii=False, indent=2, sort_keys=False)

        if lang_key == "TextMapContent":
            print(f"已生成cn(简体中文)语言的{file_type}翻译，保存在{output_file}")
        else:
            print(f"已生成{lang_key}语言的{file_type}翻译，保存在{output_file}")
        return True
    except Exception as e:
        print(f"处理{file_type}数据时出错: {e}")
        return False


# 主函数
def main():
    import concurrent.futures

    # 加载i18n数据
    i18n_data = load_i18n_data()

    # 获取支持的语言
    languages = get_supported_languages(i18n_data)

    # 创建输出目录
    os.makedirs(out_base_dir, exist_ok=True)

    # 创建线程池，线程数可以根据实际情况调整
    max_workers = min(10, len(file_types) * len(languages))

    # 准备所有任务
    tasks = []
    for file_type in file_types:
        try:
            # 加载数据（每个文件类型只加载一次）
            data = load_data(file_type)
            print(f"\n正在处理{file_type}数据...")

            # 为每种语言创建一个任务
            for lang_key in languages:
                tasks.append((file_type, data, i18n_data, lang_key, out_base_dir))
        except Exception as e:
            print(f"加载{file_type}数据时出错: {e}")

    # 使用线程池并行处理所有任务
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        # 提交所有任务
        future_to_task = {}
        for task in tasks:
            future = executor.submit(translate_and_save, *task)
            future_to_task[future] = task

        # 获取任务结果
        completed_count = 0
        for future in concurrent.futures.as_completed(future_to_task):
            task = future_to_task[future]
            try:
                if future.result():
                    completed_count += 1
            except Exception as e:
                print(f"执行任务时出错: {e}")

    print(f"\n所有文件的翻译已生成完成！共完成{completed_count}个任务")


if __name__ == "__main__":
    main()
