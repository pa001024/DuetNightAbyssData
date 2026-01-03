from processor.base_processor import BaseProcessor


class ModProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Mod"
        # 加载AttrConfig数据，用于获取中文属性名称
        self.attr_config = self.data_loader.load_json("AttrConfig.json")
        # 加载i18n数据，用于翻译属性名称
        self.i18n_data = self.data_loader.load_json("TextMap_I18n.json")
        # 加载SkillGrow配置，用于计算字符串类型的属性值
        self.skill_grow_data = self.data_loader.load_json("SkillGrow.json")

        # 品质名称映射
        self.quality_names = ["白", "绿", "蓝", "紫", "金"]
        # 极性值映射
        self.polarity_values = ["", "A", "D", "V", "O"]

    def process_item(self, mod_data, language):
        # 获取ModTag信息
        mod_tag_info = self.data_loader.get_mod_tag_info(
            mod_data.get("ApplicationType", 0)
        )
        mod_tag_text = [
            self.get_translated_text(tag) for tag in mod_tag_info.get("ModTagText", [])
        ]

        # 计算耐受值
        cost = mod_data.get("Cost", 0)
        max_level = mod_data.get("MaxLevel", 0)
        cost_change = mod_data.get("CostChange", 1)
        tolerance = cost + max_level * cost_change

        # 处理类型名称，提取系列
        type_name = self.get_translated_text(mod_data.get("TypeName", ""))
        # 处理品质和极性
        rarity = mod_data.get("Rarity", 1)
        # 使用品质名称映射
        quality_level = min(rarity - 1, len(self.quality_names) - 1)  # 确保在有效范围内
        quality = self.quality_names[quality_level]

        # 使用极性值映射
        polarity_value = mod_data.get("Polarity", -1)
        polarity_level = max(
            0, min(len(self.polarity_values) - 1, polarity_value)
        )  # 确保在有效范围内
        polarity = self.polarity_values[polarity_level]

        # 处理属性
        attribute = ""
        if len(mod_tag_text) >= 2:
            attribute = mod_tag_text[1].replace("属性", "").strip()

        # 处理类型
        mod_type = mod_tag_text[0] if mod_tag_text else ""

        # 构建基础处理后的Mod数据
        processed = {
            "id": mod_data.get("Id", 0),
            "icon": mod_data.get("Icon", "")
            .replace("/Game/UI/Texture/Dynamic/Atlas/Prop/Mod/T_Mod_", "")
            .split(".")[0],
            "名称": self.get_translated_text(mod_data.get("Name", "")),
            "版本": self.process_release(mod_data.get("ReleaseVersion", 100)),
            "系列": type_name.replace("之", ""),
            "品质": quality,
        }

        # 只有当属性不为空时才添加属性字段
        if polarity:
            processed["极性"] = polarity
        if attribute:
            processed["属性"] = attribute

        processed["耐受"] = tolerance
        processed["类型"] = mod_type

        # 处理AddAttrs，根据CalcModAttrByLevel逻辑计算属性值
        add_attrs = mod_data.get("AddAttrs", [])
        for attr in add_attrs:
            attr_name = attr.get("AttrName", "")
            if not attr_name:
                continue

            # 获取中文属性名称
            attr_config = self.attr_config.get(attr_name, {})
            attr_name_key = attr_config.get("Name", "")
            attr_chinese_name = self._translate_attribute_name(attr_name_key, language)

            # 处理BonusDamage_xxx转换为属性伤
            if attr_name.startswith("BonusDamage_"):
                attr_chinese_name = "属性伤"
            elif not attr_chinese_name:
                attr_chinese_name = attr_name

            # 计算属性值（根据CalcModAttrByLevel逻辑）
            attr_value = self._calc_mod_attr_by_level(
                attr, mod_data.get("Id", 0), max_level
            )

            # 添加到processed中
            processed[attr_chinese_name] = attr_value

        # 处理PassiveEffectsDesc，解析DescValues并填入占位符
        self._process_passive_effects_desc(mod_data, processed)

        return processed

    def _process_passive_effects_desc(self, mod_data, processed):
        """处理PassiveEffectsDesc，解析DescValues并填入占位符"""
        passive_effects_desc = self.get_translated_text(
            mod_data.get("PassiveEffectsDesc", "")
        )
        desc_values = mod_data.get("DescValues", [])

        if passive_effects_desc:
            # 解析PassiveEffectsDesc，将DescValues中的值填入占位符
            effect_desc = self._parse_passive_desc(
                passive_effects_desc, desc_values, mod_data
            )

            # 将结果填入"效果"字段
            processed["效果"] = effect_desc

    def _parse_passive_desc(self, passive_desc, desc_values, mod_data):
        """解析PassiveEffectsDesc，将DescValues中的值填入占位符
        翻译自Lua函数GenModPassiveEffectDesc的实现"""
        import re

        # 替换DescValues中的值
        if desc_values:
            # 从mod_data获取mod_id和mod_level
            mod_id = mod_data.get("Id", None)

            # 使用MOD的MaxLevel + ModCardLevelMax来计算效果
            max_level = mod_data.get("MaxLevel", 1)
            mod_card_level_max = mod_data.get("ModCardLevelMax", 0)
            mod_level = max_level + mod_card_level_max

            for i, desc_value in enumerate(desc_values):
                # 检查desc_value中是否包含math.floor或math.ceil（用于确定是否需要取整）
                # 注意：Lua代码第16行会覆盖CastTo值，所以我们先检查ReplaceDescValueTypeCast，再检查math.floor
                # 但实际上第16行的赋值会覆盖第15行的结果，所以最终CastTo只取决于math.floor

                # 步骤1: 调用ReplaceDescValueTypeCast（但实际上结果会被步骤2覆盖）
                placeholder = f"#{i+1}"
                has_int_prefix = (
                    f"{{[Ii][Nn][Tt]}}{placeholder}" in passive_desc
                    or f"{{[Ii][Nn][Tt]}}{placeholder}" in passive_desc
                )
                if has_int_prefix:
                    # 移除{int}前缀
                    passive_desc = re.sub(
                        r"\{[Ii][Nn][Tt]\}" + re.escape(placeholder),
                        placeholder,
                        passive_desc,
                    )
                    cast_to = True
                else:
                    cast_to = False

                # 步骤2: 检查desc_value中是否包含math.floor或math.ceil（这会覆盖步骤1的cast_to值）
                if "math.floor" in desc_value or "math.ceil" in desc_value:
                    cast_to = True

                # 步骤3: 从desc_value中提取百分号后缀（如果有）
                percent = "" if "%" not in desc_value else "%"

                # 步骤4: 先尝试_ModAttrGrowDesc2，如果返回空字符串则尝试_SkillGrowDesc
                # 注意：传入base_level和expect_level都为mod_level，这样会显示单一值而不是范围
                val_str = self._mod_attr_grow_desc2(
                    desc_value, mod_level, mod_level, percent, cast_to
                )
                if val_str == "":
                    val_str = self._skill_grow_desc(
                        desc_value, mod_level, mod_level, percent, cast_to, mod_id
                    )

                # 步骤5: 替换占位符 #1, #2, ...
                passive_desc = passive_desc.replace(placeholder, val_str)

        return passive_desc

    def _mod_attr_grow_desc2(
        self,
        desc_value,
        base_level,
        expect_level,
        percent,
        cast_to,
        forbid_format=False,
    ):
        """处理GetModValue和GetModPolarity类型的表达式
        翻译自Lua函数_ModAttrGrowDesc2的实现"""
        import re

        if "GetModValue" in desc_value:
            # 处理GetModValue类型的表达式
            # 提取ModId, AttrIdx, ValueType
            get_mod_value_match = re.search(
                r"GetModValue\((\d+),\s*(\d+)(?:,\s*(\d+))?\)", desc_value
            )
            if get_mod_value_match:
                mod_id = int(get_mod_value_match.group(1))
                attr_idx = int(get_mod_value_match.group(2))
                value_type = (
                    int(get_mod_value_match.group(3))
                    if get_mod_value_match.group(3)
                    else None
                )

                # 获取MOD信息
                mod_data = self.data_loader.get_mod_info(mod_id)
                if (
                    mod_data
                    and "AddAttrs" in mod_data
                    and attr_idx <= len(mod_data["AddAttrs"])
                ):
                    mod_attr_conf = mod_data["AddAttrs"][attr_idx - 1]

                    # 从MOD数据中获取正确的base_level和expect_level
                    # 使用MOD的MaxLevel + ModCardLevelMax来计算效果
                    max_level = mod_data.get("MaxLevel", 1)
                    mod_card_level_max = mod_data.get("ModCardLevelMax", 0)
                    correct_level = max_level + mod_card_level_max

                    # 计算基础值和期望的值，使用正确的level
                    old_val = self._calc_mod_attr_by_level(
                        mod_attr_conf, mod_id, correct_level, value_type
                    )
                    new_val = self._calc_mod_attr_by_level(
                        mod_attr_conf, mod_id, correct_level, value_type
                    )

                    # 格式化值
                    old_val_str = f"{old_val:.1f}{percent}"
                    new_val_str = f"{new_val:.1f}{percent}"

                    # 根据cast_to格式化
                    if not forbid_format:
                        if cast_to:
                            old_val_str = f"{int(old_val)}{percent}"
                            new_val_str = f"{int(new_val)}{percent}"

                    # 返回结果，不同则显示范围，相同则显示单个值
                    return (
                        f"{old_val_str} -> <H>{new_val_str}</>"
                        if old_val_str != new_val_str
                        else old_val_str
                    )
        elif "GetModPolarity" in desc_value:
            # 处理GetModPolarity类型的表达式
            get_mod_polarity_match = re.search(r"GetModPolarity\((\d+)\)", desc_value)
            if get_mod_polarity_match:
                target_mod_id = int(get_mod_polarity_match.group(1))

                # 获取MOD信息
                target_mod_data = self.data_loader.get_mod_info(target_mod_id)
                if target_mod_data:
                    # 根据转换规则获取极性
                    polarity_value = target_mod_data.get("Polarity", -1)
                    polarity_level = max(
                        0, min(len(self.polarity_values) - 1, polarity_value)
                    )
                    polarity = self.polarity_values[polarity_level]
                    return polarity
                else:
                    return ""

        return ""

    def _skill_grow_desc(
        self,
        desc_value,
        base_level,
        expect_level,
        percent,
        cast_to,
        mod_id=None,
        forbid_format=False,
    ):
        """处理技能成长描述
        翻译自Lua函数_SkillGrowDesc的实现"""
        # 完整实现需要SkillUtils.CalcSkillDesc的功能
        # 这里使用_parse_single_desc_value获取值，它会处理所有表达式
        old_val_str = self._parse_single_desc_value(desc_value, mod_id, base_level)
        new_val_str = self._parse_single_desc_value(desc_value, mod_id, expect_level)

        # 检查是否包含RepeatModLevel
        b_repeat_mod_level = "RepeatModLevel" in desc_value

        # 根据cast_to格式化
        if not forbid_format and not b_repeat_mod_level:
            if cast_to:
                try:
                    # 提取数值部分，转换为整数
                    import re

                    old_val = float(re.search(r"([\d.]+)", old_val_str).group(1))
                    new_val = float(re.search(r"([\d.]+)", new_val_str).group(1))
                    # 转换为整数，但如果原值有小数部分且为0，保留.0格式
                    if old_val == int(old_val):
                        old_val_str = f"{int(old_val)}.0{percent}"
                    else:
                        old_val_str = f"{int(old_val)}{percent}"
                    if new_val == int(new_val):
                        new_val_str = f"{int(new_val)}.0{percent}"
                    else:
                        new_val_str = f"{int(new_val)}{percent}"
                except:
                    pass

        # 返回结果，不同则显示范围，相同则显示单个值
        return (
            f"{old_val_str} -> <H>{new_val_str}</>"
            if old_val_str != new_val_str
            else old_val_str
        )

    def _calc_mod_attr_by_level(self, attr, mod_id, mod_level, value_type=None):
        """根据CalcModAttrByLevel逻辑计算属性值
        扩展支持value_type参数，翻译自Lua函数CalcModAttrByLevel的实现"""
        # 检查是否是Rate属性
        is_rate = "Rate" in attr
        base = attr.get("Rate" if is_rate else "Value")

        # 根据value_type调整is_rate和base
        if value_type:
            if str(value_type).lower() == "rate":
                base = attr.get("Rate")
                is_rate = True
            elif str(value_type).lower() == "value":
                base = attr.get("Value")
                is_rate = False

        # 处理LevelGrow，确保其存在且不为None
        level_grow = attr.get("LevelGrow")
        if level_grow is None:
            level_grow = 0

        # 转换为数值类型
        try:
            # 尝试将base转换为数值
            if isinstance(base, str):
                if base.startswith("#"):
                    # 对于字符串类型的数值，如"#1"，使用SkillGrow配置来计算
                    # 提取数字部分作为SkillGrow Index
                    grow_index = int(base.strip("#"))

                    # 根据Type获取对应的SkillGrow数据类型，如果没有Type，默认为Mod
                    grow_type = attr.get("Type", "Mod")

                    # 检查grow_type是否存在于skill_grow_data中
                    if grow_type not in self.skill_grow_data:
                        # 如果没有对应的SkillGrow数据，尝试使用直接计算的方式
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (mod_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_type_data = self.skill_grow_data[grow_type]

                    # 构造id_key，对于某些类型可能需要特殊处理
                    id_key = str(mod_id)

                    # 检查id_key是否存在于skill_grow_type_data中
                    if id_key not in skill_grow_type_data:
                        # 如果没有对应的ID数据，尝试使用直接计算的方式
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (mod_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    id_data = skill_grow_type_data[id_key]

                    # 根据mod_level获取对应的等级数据
                    # 对于PassiveEffect类型，我们需要使用正确的level_index来获取对应的等级数据
                    # 确保level_index在有效范围内
                    level_index = mod_level - 1

                    # 对于不同类型的数据，处理方式不同：
                    # - 对于PassiveEffect类型，id_data包含多个等级的数据，索引从0开始
                    # - 确保level_index不超出范围
                    if level_index < 0 or level_index >= len(id_data):
                        # 如果level_index超出范围，使用最大等级
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

                    # 遍历等级数据中的所有属性条目，查找匹配的Index
                    # SkillGrow数据结构：level_data是一个字典列表，每个字典包含Index和Value
                    found_value = None

                    if isinstance(level_data, list):
                        # 对于PassiveEffect类型，level_data是一个列表，包含多个属性条目
                        for attr_entry in level_data:
                            # 确保attr_entry是字典
                            if isinstance(attr_entry, dict):
                                if attr_entry["Index"] == grow_index:
                                    found_value = attr_entry["Value"]
                                    break
                    elif isinstance(level_data, dict):
                        # 对于单个属性条目的情况
                        if level_data["Index"] == grow_index:
                            found_value = level_data["Value"]
                    elif (
                        isinstance(level_data, list)
                        and level_data
                        and isinstance(level_data[0], list)
                    ):
                        # 处理level_data是一个包含列表的列表的情况
                        for inner_list in level_data:
                            if isinstance(inner_list, list):
                                for attr_entry in inner_list:
                                    if (
                                        isinstance(attr_entry, dict)
                                        and attr_entry["Index"] == grow_index
                                    ):
                                        found_value = attr_entry["Value"]
                                        break
                                if found_value is not None:
                                    break

                    # 如果找到匹配的Index，返回其Value
                    if found_value is not None:
                        return found_value
                    else:
                        # 如果找不到匹配的Index，返回0.0
                        return 0.0
                else:
                    # 对于其他字符串类型的数值，直接转换为float
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    # 计算最终值：Base + LevelGrow * (ModLevel - 1)
                    # 因为基础值已经是1级的值，每增加一级才需要加上level_grow值
                    value = base_num + level_grow_num * (mod_level - 1)
                    return value

            # 处理数值类型的base
            base_num = float(base)
            level_grow_num = float(level_grow)

            # 计算最终值：Base + LevelGrow * (ModLevel - 1)
            # 因为基础值已经是1级的值，每增加一级才需要加上level_grow值
            value = base_num + level_grow_num * (mod_level - 1)

            # 直接返回数值，不检查是否为0
            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            # 如果转换失败，返回0.0作为默认值，避免中断程序执行
            return 0.0

    def _parse_single_desc_value(self, desc_value, mod_id=None, mod_level=1):
        """解析单个DescValue，获取实际值 - 只负责正则提取和替换"""
        import re
        import math

        # 保存原始值用于调试
        original_desc_value = desc_value

        # 统一处理所有$...$格式的表达式，包括带负号的表达式
        # 使用r"\$(-)?(.*?)\$(.*)"匹配带负号、表达式内容和后缀
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", original_desc_value)
        if expr_match:
            # 提取负号标志、表达式内容和后缀
            has_neg = expr_match.group(1)  # 负号标志，可能为None
            expr = expr_match.group(2)  # 表达式内容
            suffix = expr_match.group(3)  # 包括%在内的所有后缀

            # 检查expr是否为math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr)
            if math_match:
                math_func = math_match.group(1)
                inner_expr = math_match.group(2)

                # 使用新的函数计算表达式值，确保使用正确的mod_level
                try:
                    expr_value = self._calculate_expr_value(
                        inner_expr, mod_id, mod_level, "Mod"
                    )

                    # 对结果进行相应的函数计算
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
                        result = original_desc_value.replace(
                            expr_match.group(0), f"{formatted_value}{suffix}"
                        )
                        # 移除首尾可能的$符号
                        return result.strip("$")
                except ValueError as e:
                    print(f"计算math表达式失败: {e}")
                    # 如果计算失败，返回默认值
                    return original_desc_value.replace(
                        expr_match.group(0), f"0{suffix}"
                    )

            # 使用新的函数计算普通表达式值，捕获可能的异常，确保使用正确的mod_level
            try:
                expr_value = self._calculate_expr_value(expr, mod_id, mod_level, "Mod")

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
                result = original_desc_value.replace(
                    expr_match.group(0), f"{formatted_value}{suffix}"
                )
                # 移除首尾可能的$符号
                return result.strip("$")
            except ValueError as e:
                print(f"计算表达式失败: {e}")
                # 如果计算失败，返回默认值，不终止程序
                return original_desc_value.replace(
                    expr_match.group(0), f"0{suffix}"
                ).strip("$")

        # 处理普通表达式
        return "{ERROR}"

    def _calculate_expr_value(self, expr, mod_id=None, mod_level=1, table_type="Mod"):
        """计算表达式值，使用AST解析和上下文跟踪

        Args:
            expr: 表达式字符串，如 "#Buff[1311001].BuffDamagedRate.Value*100"
            mod_id: 当前MOD的ID
            mod_level: 当前MOD的等级
            table_type: 表类型

        Returns:
            计算后的数值
        """
        import re

        # 处理GetModPolarity函数调用
        get_mod_polarity_match = re.match(r"GetModPolarity\((\d+)\)", expr)
        if get_mod_polarity_match:
            target_mod_id = int(get_mod_polarity_match.group(1))
            target_mod_data = self.data_loader.get_mod_info(target_mod_id)
            if target_mod_data:
                polarity_value = target_mod_data.get("Polarity", -1)
                polarity = ["", "A", "D", "V", "O"][max(0, min(4, polarity_value))]
                return polarity
            else:
                raise ValueError(f"无法找到MOD ID '{target_mod_id}'")

        # 处理GetModValue函数调用
        get_mod_value_match = re.match(
            r"GetModValue\((\d+),\s*(\d+)(?:,\s*(\d+))?\)", expr
        )
        if get_mod_value_match:
            target_mod_id = int(get_mod_value_match.group(1))
            attr_idx = int(get_mod_value_match.group(2))
            value_type = (
                int(get_mod_value_match.group(3)) if get_mod_value_match.group(3) else 1
            )

            target_mod_data = self.data_loader.get_mod_info(target_mod_id)
            if not target_mod_data:
                raise ValueError(f"无法找到MOD ID '{target_mod_id}'")

            add_attrs = target_mod_data.get("AddAttrs", [])
            if attr_idx < 1 or attr_idx > len(add_attrs):
                raise ValueError(f"属性索引超出范围: {attr_idx}")

            attr_config = add_attrs[attr_idx - 1]
            max_level = target_mod_data.get("MaxLevel", 1)
            mod_card_level_max = target_mod_data.get("ModCardLevelMax", 0)
            correct_mod_level = max_level + mod_card_level_max

            attr_value = self._calc_mod_attr_by_level(
                attr_config, target_mod_id, correct_mod_level, value_type
            )
            return float(attr_value)

        # 使用基类的AST解析
        return super()._calculate_expr_value(expr, mod_id, mod_level, table_type)

    def _translate_attribute_name(self, attr_name_key, language):
        """翻译属性名称为中文"""
        if not attr_name_key:
            return ""

        # 获取i18n数据
        i18n_entry = self.i18n_data.get(attr_name_key, {})
        # if language == "cn":
        return i18n_entry.get("TextMapContent", "")
        # else:
        #     return i18n_entry.get(
        #         f"Content{language.upper()}", i18n_entry.get("TextMapContent", "")
        #     )

    def process_all_items(self, items, language):
        """处理所有项目，添加过滤和排序"""
        processed_items = []
        for item in items:
            # 过滤掉id > 200000的mod
            mod_id = item.get("Id", 0)
            if mod_id < 100 or mod_id > 200000:
                continue

            processed = self.process_item(item, language)
            processed_items.append(processed)

        # 按id排序
        processed_items.sort(key=lambda x: x.get("id", 0))

        return processed_items
