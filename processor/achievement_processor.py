from processor.base_processor import BaseProcessor


class AchievementProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Achievement"

    def process_item(self, achievement_data, language):
        processed = {
            "id": achievement_data.get("AchievementId", 0),
            "名称": achievement_data.get("AchievementName", ""),
            "分类": self.data_loader.get_achievement_type_name(
                achievement_data.get("AchievementType", 0)
            ),
            "描述": self._process_description(achievement_data),
            "版本": "1.0",
            "奖励": self._process_reward(achievement_data, language),
        }
        return processed

    def _process_description(self, achievement_data):
        describe = achievement_data.get("AchievementDescribe", "")

        # 优先使用CompletionValue，如果不存在则使用TargetProgress，再不存在则使用1
        completion_value = achievement_data.get("CompletionValue")
        if completion_value is None:
            completion_value = achievement_data.get("TargetProgress", 1)

        # Replace <highlight>#1</> with the determined value
        processed = describe.replace("<highlight>#1</>", str(completion_value))
        processed = describe.replace("#1", str(completion_value))

        # 去除所有<highlight>标签
        processed = processed.replace("<highlight>", "").replace("</>", "")

        return processed

    def _process_reward(self, achievement_data, language):
        reward_id = achievement_data.get("AchievementReward", 0)

        if not reward_id:
            return {}

        # Get reward info from Reward.json
        reward = self.data_loader.load_json("Reward.json")

        # Check if reward_id exists in reward data
        if str(reward_id) not in reward:
            return {}

        reward_info = reward[str(reward_id)]

        # Initialize reward dictionary
        rewards = {}

        # Get all reward items from Id array
        reward_ids = reward_info.get("Id", [])
        reward_types = reward_info.get("Type", [])
        reward_counts = reward_info.get("Count", [])

        # Iterate through all reward items (using index)
        for i in range(len(reward_ids)):
            # Check if index is valid for all arrays
            if i >= len(reward_types) or i >= len(reward_counts):
                continue

            # Get item values using index
            item_id = reward_ids[i]
            item_type = reward_types[i]
            # 从二维数组中提取实际数量值
            item_count = reward_counts[i]
            if isinstance(item_count, list):
                # 如果是嵌套数组，获取第一个元素
                if item_count and isinstance(item_count[0], list):
                    # 如果是二维数组，获取第一个元素的第一个值
                    item_count = item_count[0][0] if item_count[0] else 1
                else:
                    # 如果是一维数组，获取第一个值
                    item_count = item_count[0] if item_count else 1
            # 确保数量是数值类型
            item_count = (
                int(item_count)
                if isinstance(item_count, (int, float, str)) and item_count
                else 1
            )

            # Skip if item_id or item_type is empty
            if not item_id or not item_type:
                continue

            # Process based on item type
            if item_type == "Resource":
                # Get resource name
                resource_name = self.data_loader.get_resource_name(item_id)
                if resource_name:
                    rewards[resource_name] = item_count
                else:
                    rewards[str(item_id)] = item_count
            elif item_type == "Draft":
                # Get draft info
                draft_info = self.data_loader.get_draft_info(item_id)
                product_type = draft_info.get("ProductType", "")
                product_id = draft_info.get("ProductId", 0)

                # 根据不同语言使用不同的图纸格式
                if language in ["cn", "tc"]:
                    # 中文/繁体中文：图纸: [名称]
                    if product_type == "Mod":
                        mod_name = self.data_loader.get_mod_name(product_id)
                        if mod_name:
                            rewards[f"图纸: {mod_name}"] = item_count
                    elif product_type == "Char":
                        char_name = self.data_loader.get_char_name(product_id)
                        if char_name:
                            rewards[f"图纸: {char_name}"] = item_count
                    elif product_type == "Weapon":
                        weapon_name = self.data_loader.get_weapon_name(product_id)
                        if weapon_name:
                            rewards[f"图纸: {weapon_name}"] = item_count
                    else:
                        rewards[f"图纸: {product_type}{product_id}"] = item_count
                else:
                    # 其他语言：Draft: [名称]
                    if product_type == "Mod":
                        mod_name = self.data_loader.get_mod_name(product_id)
                        if mod_name:
                            rewards[f"Draft: {mod_name}"] = item_count
                    elif product_type == "Char":
                        char_name = self.data_loader.get_char_name(product_id)
                        if char_name:
                            rewards[f"Draft: {char_name}"] = item_count
                    elif product_type == "Weapon":
                        weapon_name = self.data_loader.get_weapon_name(product_id)
                        if weapon_name:
                            rewards[f"Draft: {weapon_name}"] = item_count
                    else:
                        rewards[f"Draft: {product_type}{product_id}"] = item_count
            elif item_type == "Title":
                # Get title name
                title_name = self.data_loader.get_title_name(item_id)
                if title_name:
                    # 根据不同语言使用不同的称号格式
                    if language in ["cn", "tc"]:
                        # 中文/繁体中文：“称号名”称号
                        rewards[f"“{title_name}”称号"] = item_count
                    elif language == "jp":
                        # 日文：「称号名」称号
                        rewards[f"「{title_name}」称号"] = item_count
                    elif language == "kr":
                        # 韩文：[称号名] 칭호
                        rewards[f"{title_name} 칭호"] = item_count
                    else:
                        # 英文、德文、西班牙文、法文：Title: [称号名]
                        rewards[f"Title: {title_name}"] = item_count
                else:
                    # 称号名不存在时的默认格式
                    if language in ["cn", "tc", "jp", "kr"]:
                        rewards[f"称号-{item_id}"] = item_count
                    else:
                        rewards[f"Title-{item_id}"] = item_count
            elif item_type == "TitleFrame":
                # Get titleframe name
                titleframe_name = self.data_loader.get_titleframe_name(item_id)
                if titleframe_name:
                    # 根据不同语言使用不同的称号框格式
                    if language in ["cn", "tc"]:
                        # 中文/繁体中文："称号框名"样式
                        rewards[f"“{titleframe_name}”样式"] = item_count
                    elif language == "jp":
                        # 日文：「称号框名」スタイル
                        rewards[f"「{titleframe_name}」スタイル"] = item_count
                    elif language == "kr":
                        # 韩文：[称号框名] 스타일
                        rewards[f"{titleframe_name} 스타일"] = item_count
                    else:
                        # 英文、德文、西班牙文、法文：Title Frame: [称号框名] Style
                        rewards[f"Title Frame: {titleframe_name} Style"] = item_count
                else:
                    # 称号框名不存在时的默认格式
                    if language in ["cn", "tc", "jp", "kr"]:
                        rewards[f"样式-{item_id}"] = item_count
                    else:
                        rewards[f"Style-{item_id}"] = item_count
            elif item_type == "Reward":
                # Recursive processing for Reward type
                sub_rewards = self._process_reward(
                    {"AchievementReward": item_id}, language
                )
                rewards.update(sub_rewards)
            else:
                # 其他类型奖励的默认格式
                rewards[f"{item_type}-{item_id}"] = item_count

        return rewards
