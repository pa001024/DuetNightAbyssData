from processor.base_processor import BaseProcessor


class RewardProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Reward"
        self.reward_data = data_loader.load_json("Reward.json")
        self.drop_data = data_loader.load_json("Drop.json")
        self.mod_data = data_loader.load_json("Mod.json")
        self.resource_data = data_loader.load_json("Resource.json")

    def process_item(self, item_data, language, processed_ids=None):
        """
        处理单个奖励项目
        :param item_data: 奖励数据
        :param language: 目标语言
        :param processed_ids: 已处理的奖励ID集合，用于避免循环引用
        :return: 处理后的奖励数据
        """
        # 初始化已处理ID集合
        if processed_ids is None:
            processed_ids = set()

        # 获取奖励ID
        reward_id = item_data.get("RewardId", 0)
        if not reward_id:
            return None

        # 检查是否已经处理过该奖励ID，避免循环引用
        current_reward_id = str(reward_id)
        if current_reward_id in processed_ids:
            return {"id": reward_id, "child": []}

        # 将当前奖励ID添加到已处理集合中
        processed_ids.add(current_reward_id)

        # 构建处理结果，先添加Id，再添加Mode，最后添加列表
        processed = {"id": reward_id}

        # 添加Mode字段，放在列表前面
        mode = item_data.get("Mode", "")
        if mode:
            processed["m"] = mode

        # 初始化列表字段
        processed["child"] = []

        # 遍历Id列表，每个Id对应一个奖励项
        ids = item_data.get("Id", [])
        types = item_data.get("Type", [])
        params = item_data.get("Param", [])
        counts = item_data.get("Count", [])

        # 确保列表长度一致，使用默认值0
        max_len = min(len(ids), len(types))
        # 确保params和counts列表长度至少与max_len一致
        while len(params) < max_len:
            params.append(0)
        while len(counts) < max_len:
            counts.append(0)

        for i in range(max_len):
            item_id = ids[i]
            item_type = types[i]

            # 处理权重参数，确保使用正确的索引值
            item_param = params[i]
            # 如果权重是列表，根据当前索引i获取对应的值，超出范围则使用默认值0
            if isinstance(item_param, list):
                item_param = item_param[i] if i < len(item_param) else 0

            # 处理数量参数，确保使用正确的索引值
            # 原始Count字段是二维数组 [[1], [1], [1]]，每个元素对应一个奖励项
            item_count = counts[i] if i < len(counts) else 0

            # 处理嵌套列表情况，如 [1] 或 []
            if isinstance(item_count, list):
                # 如果是列表，取第一个元素或默认0
                item_count = item_count[0] if item_count else 0

            # 构建当前奖励项
            item = {"id": item_id, "t": item_type}

            # 添加数量字段，放在权重前面，使用中文名称
            try:
                item_count = int(item_count)
                if item_count > 0:
                    item["c"] = item_count
            except (ValueError, TypeError):
                # 如果转换失败，跳过该字段
                pass

            # 只有当权重不为0时，才添加权重字段
            if item_param != 0:
                item["p"] = item_param

            # 根据类型查询不同的表
            item_name = self._get_item_name(item_id, item_type)
            if item_name:
                item["n"] = item_name

            # 不再为子项添加child字段
            # 只在顶级处理结果中添加child字段，子项中不再包含child
            pass

            # 将当前项添加到结果列表中
            processed["child"].append(item)

        return processed

    def _get_item_name(self, item_id, item_type):
        """
        根据类型和ID获取项目名称
        :param item_id: 项目ID
        :param item_type: 项目类型
        :return: 项目名称，如果不需要返回名称则返回None
        """
        # 根据类型查询不同的表
        if item_type == "Drop":
            # 查询Drop.json
            drop_item = self.drop_data.get(str(item_id), {})
            drop_name = drop_item.get("DropName", "")
            if drop_name:
                return self.get_translated_text(drop_name)
            # 如果DropName字段不存在，尝试直接翻译item_id
            return self.get_translated_text(str(item_id))
        elif item_type == "Mod":
            # 查询Mod.json
            mod_item = self.mod_data.get(str(item_id), {})
            return f"{self.get_translated_text(mod_item.get('TypeName', ''))}{self.get_translated_text(mod_item.get('Name', ''))}".strip()
        elif item_type == "Resource":
            # 查询Resource.json
            resource_item = self.resource_data.get(str(item_id), {})
            return self.get_translated_text(resource_item.get("ResourceName", ""))
        elif item_type == "Reward":
            # Reward类型不需要添加名称，返回None
            return None
        elif item_type in [
            "Walnut",
            "Item",
            "Char",
            "Weapon",
            "Draft",
            "Monster",
            "Title",
        ]:
            # 这些类型可能有对应的json文件，尝试加载并获取名称
            try:
                # 首字母大写的类型名转换为对应的json文件名
                file_name = f"{item_type}.json"
                item_data = self.data_loader.load_json(file_name)
                # 尝试获取名称字段，不同类型可能有不同的字段名
                item_info = item_data.get(str(item_id), {})

                # 根据类型获取对应的名称字段
                name_field = ""
                if item_type == "Walnut":
                    name_field = "Name"  # 假设Walnut.json中的名称字段是Name
                elif item_type == "Item":
                    name_field = "Name"  # 假设Item.json中的名称字段是Name
                elif item_type == "Char":
                    name_field = "Name"  # 参考之前的代码，Char.json中的名称字段是Name
                elif item_type == "Weapon":
                    name_field = "WeaponName"  # 参考之前的代码，Weapon.json中的名称字段是WeaponName
                elif item_type == "Draft":
                    name_field = "Name"  # 假设Draft.json中的名称字段是Name
                elif item_type == "Monster":
                    name_field = "Name"  # 假设Monster.json中的名称字段是Name
                elif item_type == "Title":
                    name_field = "Name"  # 假设Title.json中的名称字段是Name

                if name_field:
                    return self.data_loader.translate(item_info.get(name_field, ""))
            except Exception as e:
                # 加载失败时，尝试直接翻译item_id
                translated = self.get_translated_text(str(item_id))
                # 如果翻译后的结果仍然是原始ID，返回类型和ID
                return (
                    translated
                    if translated != str(item_id)
                    else f"{item_type}_{item_id}"
                )
        else:
            # 其他类型，尝试直接翻译item_id
            translated = self.get_translated_text(str(item_id))
            # 如果翻译后的结果仍然是原始ID，返回类型和ID
            return (
                translated if translated != str(item_id) else f"{item_type}_{item_id}"
            )

    def process_all_items(self, items, language):
        """
        处理所有奖励项目
        :param items: 奖励项目列表
        :param language: 目标语言
        :return: 处理后的奖励项目列表
        """
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)
        return processed_items
