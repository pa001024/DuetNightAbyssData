import json
from pathlib import Path


def parse_reward(reward_id, reward_data, processed_ids=None):
    """
    递归解析奖励数据
    :param reward_id: 奖励ID（字符串形式）
    :param reward_data: 完整的奖励数据字典
    :param processed_ids: 已处理的奖励ID集合，用于避免循环引用
    :return: 解析后的奖励结构
    """
    # 初始化已处理ID集合
    if processed_ids is None:
        processed_ids = set()

    # 获取当前奖励条目
    reward_entry = reward_data.get(reward_id)
    if not reward_entry:
        return {"Id": int(reward_id), "列表": []}

    # 检查是否已经处理过该奖励ID，避免循环引用
    current_reward_id = str(reward_entry.get("RewardId", int(reward_id)))
    if current_reward_id in processed_ids:
        return {"Id": int(current_reward_id), "列表": []}

    # 将当前奖励ID添加到已处理集合中
    processed_ids.add(current_reward_id)

    result = {"Id": int(current_reward_id), "列表": []}

    # 遍历Id列表，每个Id对应一个奖励项
    ids = reward_entry.get("Id", [])
    types = reward_entry.get("Type", [])
    params = reward_entry.get("Param", [])

    # 确保三个列表长度一致
    max_len = min(len(ids), len(types), len(params))

    for i in range(max_len):
        item_id = ids[i]
        item_type = types[i]
        item_param = params[i]

        # 构建当前奖励项
        item = {"id": item_id, "权重": item_param, "类型": item_type, "列表": []}

        # 如果类型是Reward或Drop，递归解析
        if item_type in ["Reward", "Drop"]:
            # 递归调用，将item_id作为新的reward_id，并传递已处理集合的副本
            nested_result = parse_reward(
                str(item_id), reward_data, processed_ids.copy()
            )
            # 将嵌套结果添加到当前项的列表中
            item["列表"].append(nested_result)

        # 将当前项添加到结果列表中
        result["列表"].append(item)

    return result


def main():
    # 读取Reward.json文件（使用相对路径）
    reward_file_path = Path("./out/Reward.json")
    with open(reward_file_path, "r", encoding="utf-8") as f:
        reward_data = json.load(f)

    # 解析所有奖励条目
    all_parsed_rewards = {}
    for reward_id in reward_data.keys():
        parsed = parse_reward(reward_id, reward_data)
        all_parsed_rewards[reward_id] = parsed

    # 确保输出目录存在
    output_dir = Path("./final")
    output_dir.mkdir(exist_ok=True)

    # 输出结果到文件（保存到./final/目录）
    output_path = output_dir / "ParsedReward.json"
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(all_parsed_rewards, f, ensure_ascii=False, indent=2)

    print(f"解析完成，结果保存到 {output_path}")


if __name__ == "__main__":
    main()
