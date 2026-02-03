from processor.base_processor import BaseProcessor


class RobotEquipProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RobotEquip"

        # 加载相关数据表
        self.robot_equip_data = data_loader.load_json("RobotEquip.json")

    def process_item(self, robot_equip_data, language):
        """处理单个 RobotEquip 数据

        Args:
            robot_equip_data: 原始 RobotEquip 数据
            language: 语言类型

        Returns:
            处理后的 RobotEquip 数据
        """
        equip_id = robot_equip_data.get("EquipId")
        name_key = robot_equip_data.get("EquipName")
        equip_icon = robot_equip_data.get("EquipIcon")
        equip_rarity = robot_equip_data.get("EquipRarity")
        deploy_cost = robot_equip_data.get("DeployCost")
        attr_buff_id = robot_equip_data.get("AttrBuffId")
        extra_buff_desc_key = robot_equip_data.get("ExtraBuffDesc")
        extra_buff_id = robot_equip_data.get("ExtraBuffId")
        unlock_quest_id = robot_equip_data.get("UnlockQuestId")

        # 获取翻译
        name = self.get_translated_text(name_key, language) if name_key else ""
        extra_buff_desc = self.get_translated_text(extra_buff_desc_key, language) if extra_buff_desc_key else ""
        
        # 去除 extraBuffDesc 中的标签
        import re
        extra_buff_desc = re.sub(r'<[^>]+>', '', extra_buff_desc)

        # 提取图标名称
        icon = self._extract_icon_name(equip_icon)

        # 处理属性值（这些是表达式，需要解析并转换为数值）
        atk_value = self._parse_expression_to_number(robot_equip_data.get("ATKValue"), equip_id)
        def_value = self._parse_expression_to_number(robot_equip_data.get("DEFValue"), equip_id)
        hp_value = self._parse_expression_to_number(robot_equip_data.get("HPValue"), equip_id)
        shield_value = self._parse_expression_to_number(robot_equip_data.get("ShieldValue"), equip_id)

        # 处理描述值并替换到 extraBuffDesc 中
        desc_value = robot_equip_data.get("DescValue", [])
        if desc_value and extra_buff_desc:
            for i, desc in enumerate(desc_value):
                parsed_value = self._parse_expression(desc, equip_id)
                # 替换 extraBuffDesc 中的 #1, #2 等占位符
                placeholder = f"#{i+1}"
                extra_buff_desc = extra_buff_desc.replace(placeholder, parsed_value)

        # 构建处理后的 RobotEquip 数据，去除 null 值
        processed_robot_equip = {
            "id": equip_id,
            "name": name,
            "icon": icon,
            "rarity": equip_rarity,
            "cost": deploy_cost,
            "buffId": attr_buff_id,
            "extraBuffDesc": extra_buff_desc
        }
        
        # 只添加非 null 值的字段
        if extra_buff_id is not None:
            processed_robot_equip["extraBuffId"] = extra_buff_id
        if unlock_quest_id is not None:
            processed_robot_equip["unlockQuestId"] = unlock_quest_id

        # 添加属性值（如果存在）
        if atk_value != 0:
            processed_robot_equip["atk"] = atk_value
        if def_value != 0:
            processed_robot_equip["def"] = def_value
        if hp_value != 0:
            processed_robot_equip["hp"] = hp_value
        if shield_value != 0:
            processed_robot_equip["shield"] = shield_value

        return processed_robot_equip

    def _parse_expression_to_number(self, expr, equip_id):
        """解析表达式，获取数值

        Args:
            expr: 表达式字符串，如 "$#Buff[4020101].AddAttrs[1].Rate*100$%"
            equip_id: 装备ID

        Returns:
            解析后的表达式值（数值）
        """
        if not expr:
            return 0

        import re

        # 统一处理所有$...$格式的表达式，包括带负号的表达式
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", expr)
        if expr_match:
            # 提取负号标志、表达式内容和后缀
            has_neg = expr_match.group(1)  # 负号标志，可能为None
            inner_expr = expr_match.group(2)  # 表达式内容
            suffix = expr_match.group(3)  # 包括%在内的所有后缀

            # 检查inner_expr是否为math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", inner_expr)
            if math_match:
                math_func = math_match.group(1)
                inner_inner_expr = math_match.group(2)

                # 计算表达式值
                try:
                    expr_value = self._calculate_expr_value(
                        inner_inner_expr, equip_id, 1, "RobotEquip"
                    )

                    # 对结果进行相应的函数计算
                    import math
                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:  # floor
                            processed_value = math.floor(expr_value)

                        # 根据是否有负号处理值
                        if has_neg:
                            processed_value = -processed_value

                        # 如果后缀包含%，转换为小数
                        if "%" in suffix:
                            return processed_value / 100
                        return processed_value
                except ValueError as e:
                    print(f"计算math表达式失败: {e}")
                    # 如果计算失败，返回默认值
                    return 0

            # 计算普通表达式值
            try:
                # 计算表达式值
                expr_value = self._calculate_expr_value(
                    inner_expr, equip_id, 1, "RobotEquip"
                )

                # 根据是否有负号处理值
                if has_neg:
                    # 对于带负号的表达式，如 `$-#...$`，对值取负
                    final_value = -expr_value
                else:
                    # 对于普通表达式，直接使用值
                    final_value = expr_value

                # 如果后缀包含%，转换为小数
                if "%" in suffix:
                    return final_value / 100
                return final_value
            except ValueError as e:
                print(f"计算表达式失败: {e}")
                # 如果计算失败，返回默认值，不终止程序
                return 0

        # 处理普通表达式
        return 0

    def _parse_expression(self, expr, equip_id):
        """解析表达式，获取实际值

        Args:
            expr: 表达式字符串，如 "$#Buff[4020101].AddAttrs[1].Rate*100$%"
            equip_id: 装备ID

        Returns:
            解析后的表达式值（格式化字符串）
        """
        if not expr:
            return "0"

        import re

        # 统一处理所有$...$格式的表达式，包括带负号的表达式
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", expr)
        if expr_match:
            # 提取负号标志、表达式内容和后缀
            has_neg = expr_match.group(1)  # 负号标志，可能为None
            inner_expr = expr_match.group(2)  # 表达式内容
            suffix = expr_match.group(3)  # 包括%在内的所有后缀

            # 检查inner_expr是否为math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", inner_expr)
            if math_match:
                math_func = math_match.group(1)
                inner_inner_expr = math_match.group(2)

                # 计算表达式值
                try:
                    expr_value = self._calculate_expr_value(
                        inner_inner_expr, equip_id, 1, "RobotEquip"
                    )

                    # 对结果进行相应的函数计算
                    import math
                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:  # floor
                            processed_value = math.floor(expr_value)

                        # 根据是否有负号处理值
                        if has_neg:
                            processed_value = -processed_value

                        # 格式化结果，保留一位小数
                        formatted_value = f"{processed_value:.1f}"

                        # 将计算结果替换到原始格式化串中
                        result = expr.replace(
                            expr_match.group(0), f"{formatted_value}{suffix}"
                        )
                        # 移除首尾可能的$符号
                        return result.strip("$")
                except ValueError as e:
                    print(f"计算math表达式失败: {e}")
                    # 如果计算失败，返回默认值
                    return expr.replace(
                        expr_match.group(0), f"0{suffix}"
                    )

            # 计算普通表达式值
            try:
                # 计算表达式值
                expr_value = self._calculate_expr_value(
                    inner_expr, equip_id, 1, "RobotEquip"
                )

                # 根据是否有负号处理值
                if has_neg:
                    # 对于带负号的表达式，如 `$-#...$`，对值取负
                    final_value = -expr_value
                else:
                    # 对于普通表达式，直接使用值
                    final_value = expr_value

                # 格式化结果，保留一位小数
                formatted_value = f"{final_value:.1f}"

                # 将计算结果替换到原始格式化串中
                result = expr.replace(
                    expr_match.group(0), f"{formatted_value}{suffix}"
                )
                # 移除首尾可能的$符号
                return result.strip("$")
            except ValueError as e:
                print(f"计算表达式失败: {e}")
                # 如果计算失败，返回默认值，不终止程序
                return expr.replace(
                    expr_match.group(0), f"0{suffix}"
                ).strip("$")

        # 处理普通表达式
        return expr

    def _extract_icon_name(self, equip_icon):
        """提取 EquipIcon 中的图标名称

        Args:
            equip_icon: EquipIcon 路径

        Returns:
            提取后的图标名称
        """
        if not equip_icon:
            return ""

        # 提取图标名称
        import re
        match = re.search(r'T_Activity_Autochess_Item(\d+)\.', equip_icon)
        if match:
            return f"Item{match.group(1)}"
        return ""

    def process_all_items(self, items, language):
        """处理所有 RobotEquip 数据

        Args:
            items: RobotEquip 数据列表
            language: 语言类型

        Returns:
            处理后的 RobotEquip 数据列表
        """
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        # 按 id 排序
        processed_items.sort(key=lambda x: x.get("id", 0))

        return processed_items