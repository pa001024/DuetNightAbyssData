from processor.base_processor import BaseProcessor
from ast_parser import parse_ast, NodeType


class WeaponProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Weapon"
        # 加载必要的配置数据
        self.attr_config = data_loader.load_json("AttrConfig.json")
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.skill_grow_data = data_loader.load_json("SkillGrow.json")
        self.weapon_level_up_data = data_loader.load_json("WeaponLevelUp.json")
        self.weapon_break_data = data_loader.load_json("WeaponBreak.json")
        self.battle_weapon_data = data_loader.load_json("BattleWeapon.json")
        self.weapon_card_level_data = data_loader.load_json("WeaponCardLevel.json")
        self.attribute_data = data_loader.load_json("Attribute.json")

    def process_item(self, weapon_data, language):
        weapon_id = weapon_data.get("WeaponId", 0)

        # 获取BattleWeapon数据
        battle_weapon = self.battle_weapon_data.get(str(weapon_id), {})
        if not battle_weapon:
            battle_weapon = self.battle_weapon_data.get(weapon_id, {})

        # 构建基础处理后的Weapon数据
        processed = {
            "id": weapon_id,
            "名称": self.get_translated_text(weapon_data.get("WeaponName", "")),
            "描述": self.get_translated_text(weapon_data.get("WeaponDescribe", "")),
            "类型": self.process_tags(battle_weapon.get("WeaponTag", [])),
        }
        processed.update(self._process_attributes(battle_weapon, weapon_id))
        processed.update(
            {
                "加成": self._process_add_attr(battle_weapon, weapon_id),
                "突破": self._process_break(weapon_id, language),
                "熔炼": self._process_smelting(battle_weapon, weapon_id),
            }
        )

        return processed

    def _process_add_attr(self, battle_weapon, weapon_id):
        """处理武器属性加成"""
        if not battle_weapon:
            return {}

        # AddAttrs[0]通常包含ATK属性，Rate字段是"#1"，需要从SkillGrow获取
        add_attrs = battle_weapon.get("AddAttrs", [])
        attributes = {}
        # 尝试从AddAttrs中找到ATK属性
        for attr in add_attrs:
            if attr.get("AttrName") == "ATK":
                # 从SkillGrow获取等级1的ATK值作为基础值
                attr_rate = attr.get("Rate", "")
                if attr_rate and attr_rate.startswith("#"):
                    # 使用_calc_weapon_attr_by_level获取等级1的值
                    base_atk = self._calc_weapon_attr_by_level(attr, weapon_id, 1)
                else:
                    base_atk = float(attr_rate) if attr_rate else 0
                attributes["攻击"] = base_atk
            else:
                attr_name = attr.get("AttrName", "")
                if (
                    attr_name in self.attr_config
                    or attr_name + "_Normal" in self.attr_config
                ):
                    cfg = self.attr_config.get(attr_name) or self.attr_config.get(
                        attr_name + "_Normal", {}
                    )
                    an = self.get_translated_text(cfg.get("Name", ""), "cn")
                    attributes[an] = self._calc_weapon_attr_by_level(attr, weapon_id, 1)
                else:
                    attributes[attr_name] = attr_name
        return attributes

    def _process_attributes(self, battle_weapon, weapon_id):
        """处理武器属性，计算各个等级的ATK值"""
        if not battle_weapon:
            return {}

        attributes = {}

        # 计算所有属性加成（ATK_Dark, ATK_Fire等）
        for attr_name in self.attribute_data.keys():
            attr_key = f"ATK_{attr_name}"
            if attr_key in battle_weapon:
                attr_config = self.attr_config.get(attr_key, {})
                atk_type = self.get_translated_text(attr_config.get("Name", ""), "cn")
                attributes["伤害类型"] = atk_type[:2]
                attributes[atk_type[2:]] = battle_weapon[attr_key]
        attributes["暴击"] = battle_weapon.get("CRI", 0)
        attributes["暴伤"] = battle_weapon.get("CRD", 0)
        attributes["触发"] = battle_weapon.get("TriggerProbability", 0)
        if "MagazineCapacity" in battle_weapon:
            attributes["弹匣"] = battle_weapon["MagazineCapacity"]
        if "BulletMax" in battle_weapon:
            attributes["最大弹药"] = battle_weapon["BulletMax"]
        if "BulletConver" in battle_weapon:
            attributes["弹药转化率"] = battle_weapon["BulletConver"]
        if "MaxDistance" in battle_weapon:
            attributes["最大射程"] = battle_weapon["MaxDistance"]

        return attributes

    def _process_break(self, weapon_id, language):
        """处理武器突破数据"""
        break_list = self.weapon_break_data.get(str(weapon_id), [])
        if not break_list:
            break_list = self.weapon_break_data.get(weapon_id, [])

        if not break_list:
            return []

        break_info = []

        for break_stage in break_list:
            item_ids = break_stage.get("ItemId", [])
            item_nums = break_stage.get("ItemNum", [])

            stage_materials = {}

            for i, item_id in enumerate(item_ids):
                if i >= len(item_nums):
                    continue

                # 获取材料名称
                resource_name = self.data_loader.get_resource_name(item_id)
                if not resource_name:
                    resource_name = str(item_id)

                stage_materials[resource_name] = item_nums[i]

            break_info.append(stage_materials)

        return break_info

    def _process_smelting(self, battle_weapon, weapon_id):
        """处理武器熔炼数据，计算各等级的技能描述"""
        if not battle_weapon:
            return {}

        # 获取WeaponCardLevel数据
        card_level_data = self.weapon_card_level_data.get(str(weapon_id), {})
        if not card_level_data:
            card_level_data = self.weapon_card_level_data.get(weapon_id, {})

        smelting_info = []

        # 处理PassiveEffectsDesc和PassiveEffectsDescValues
        passive_desc = battle_weapon.get("PassiveEffectsDesc", "")
        desc_values = battle_weapon.get("PassiveEffectsDescValues", [])

        if not passive_desc:
            return smelting_info

        # 为每个熔炼等级计算技能描述
        for grade_level in range(1, 7):
            # 计算该等级的技能描述
            skill_desc = self._calc_weapon_passive_effects_desc(
                battle_weapon, grade_level, passive_desc, desc_values
            )
            smelting_info.append(skill_desc)

        return smelting_info

    def _calc_weapon_passive_effects_desc(
        self, battle_weapon, grade_level, passive_desc, desc_values
    ):
        """计算武器指定熔炼等级的被动效果描述"""
        import re

        if not passive_desc:
            return ""

        # passive_desc 可能是文本key（如 SKILL_10101_DESC），需要从i18n获取翻译
        # 先从i18n_data中查找翻译
        translated_desc = self.get_translated_text(passive_desc)
        if not translated_desc:
            translated_desc = passive_desc

        # 复制描述，用于替换占位符
        result_desc = translated_desc

        # 替换DescValues中的值
        if desc_values:
            for i, desc_value in enumerate(desc_values):
                placeholder = f"#{i+1}"

                # 检查desc_value中是否包含math.floor或math.ceil
                cast_to = "math.floor" in desc_value or "math.ceil" in desc_value

                # 提取百分号后缀（如果有）
                percent = "" if "%" not in desc_value else "%"

                # 解析desc_value，获取实际值
                # weapon_id用于SkillGrow查找
                weapon_id = battle_weapon.get("WeaponId", None)
                val_str = self._parse_single_desc_value(
                    desc_value, weapon_id, grade_level, "BattleWeapon"
                )

                # 如果需要取整
                if cast_to:
                    try:
                        val = float(re.search(r"([\d.]+)", val_str).group(1))
                        val_str = f"{int(val)}{percent}"
                    except:
                        pass

                # 替换占位符
                result_desc = result_desc.replace(placeholder, val_str)

        # 移除<H></>标签（高亮标签）
        result_desc = result_desc.replace("<H>", "").replace("</>", "")

        return result_desc

    def _parse_single_desc_value(self, desc_value, weapon_id, grade_level, table_type):
        """解析单个DescValue，获取实际值"""
        import re
        import math

        # 处理$...$格式的表达式
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", desc_value)
        if expr_match:
            has_neg = expr_match.group(1)
            expr = expr_match.group(2)
            suffix = expr_match.group(3)

            # 检查是否是math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr)
            if math_match:
                math_func = math_match.group(1)
                inner_expr = math_match.group(2)

                try:
                    expr_value = self._calculate_expr_value(
                        inner_expr, weapon_id, grade_level, table_type
                    )

                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:
                            processed_value = math.floor(expr_value)

                        if has_neg:
                            processed_value = -processed_value

                        formatted_value = f"{processed_value:.1f}"
                        result = desc_value.replace(
                            expr_match.group(0), f"{formatted_value}{suffix}"
                        )
                        return result.strip("$")
                except ValueError as e:
                    return desc_value.replace(expr_match.group(0), f"0{suffix}")

            # 普通表达式
            try:
                expr_value = self._calculate_expr_value(
                    expr, weapon_id, grade_level, table_type
                )

                if has_neg:
                    final_value = -expr_value
                else:
                    final_value = expr_value

                formatted_value = f"{final_value:.1f}"
                result = desc_value.replace(
                    expr_match.group(0), f"{formatted_value}{suffix}"
                )
                return result.strip("$")
            except ValueError as e:
                return desc_value.replace(expr_match.group(0), f"0{suffix}").strip("$")

        return "{ERROR}"

    def _calculate_expr_value(self, expr, weapon_id, grade_level, table_type):
        """计算表达式值，使用AST解析和上下文跟踪

        Args:
            expr: 表达式字符串
            weapon_id: 当前武器的ID
            grade_level: 当前等级
            table_type: 表类型（用于SkillGrow查找）

        Returns:
            计算后的数值
        """
        try:
            ast = parse_ast(expr)
            # 初始化上下文
            context = {}
            if table_type:
                context["table_type"] = table_type
            if weapon_id:
                context["table_id"] = weapon_id

            result = self._evaluate_ast_node_with_context(
                ast, weapon_id, grade_level, context
            )
            return float(result)
        except Exception as e:
            print(f"计算表达式 '{expr}' 失败: {e}")
            return 0.0

    def _evaluate_ast_node_with_context(
        self, node, weapon_id=None, grade_level=1, context=None
    ):
        """使用上下文信息评估AST节点

        Args:
            node: AST节点
            weapon_id: 当前武器的ID
            grade_level: 当前等级
            context: 上下文信息字典，包含 table_type 和 table_id

        Returns:
            评估后的值
        """
        if context is None:
            context = {}

        if node.type == NodeType.LITERAL:
            # 字面量直接返回值
            return node.value

        elif node.type == NodeType.IDENTIFIER:
            # 标识符，返回其值
            return node.value

        elif node.type == NodeType.BINARY_EXPR:
            # 二元表达式
            # 评估左侧表达式（保留上下文）
            left_value = self._evaluate_ast_node_with_context(
                node.left, weapon_id, grade_level, context
            )
            # 评估右侧表达式（同样使用相同上下文）
            right_value = self._evaluate_ast_node_with_context(
                node.right, weapon_id, grade_level, context
            )

            # 如果左侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(left_value, str) and left_value.startswith("#"):
                table_type = context.get("table_type", "BattleWeapon")
                table_id = context.get("table_id", weapon_id)

                attr = {
                    "Type": table_type,
                    "Value": left_value,
                }

                left_value = self._calc_weapon_attr_by_level(
                    attr, table_id, grade_level
                )

            op = node.value
            if op == "+":
                return left_value + right_value
            elif op == "-":
                return left_value - right_value
            elif op == "*":
                return left_value * right_value
            elif op == "/":
                return left_value / right_value if right_value != 0 else 0.0
            elif op == "%":
                return left_value % right_value
            else:
                raise ValueError(f"未知的运算符: {op}")

        elif node.type == NodeType.MEMBER_ACCESS:
            # 成员访问: object.property
            object_value = self._evaluate_ast_node_with_context(
                node.object, weapon_id, grade_level, context
            )
            property_name = node.property.value

            # 如果object_value是字典，访问属性
            if isinstance(object_value, dict):
                if property_name in object_value:
                    value = object_value[property_name]

                    # 如果值是字符串且以#开头，使用SkillGrow查找
                    if isinstance(value, str) and value.startswith("#"):
                        # 使用上下文信息进行SkillGrow查找
                        table_type = context.get("table_type", "BattleWeapon")
                        table_id = context.get("table_id", weapon_id)

                        # 构建attr对象用于SkillGrow查找
                        attr_key = "Rate" if "Rate" in property_name else "Value"
                        attr = {
                            "Type": table_type,
                            attr_key: value,
                        }

                        # 调用_calc_weapon_attr_by_level获取实际值
                        return self._calc_weapon_attr_by_level(
                            attr, table_id, grade_level
                        )
                    else:
                        return value
                else:
                    # 尝试使用原有的属性路径解析逻辑
                    return self._get_attr_value_from_dict(
                        object_value,
                        property_name,
                        weapon_id,
                        grade_level,
                        context.get("table_type", "BattleWeapon"),
                    )
            else:
                raise ValueError(f"无法对非字典类型进行成员访问")

        elif node.type == NodeType.INDEX_ACCESS:
            # 索引访问: object[index]
            object_value = self._evaluate_ast_node_with_context(
                node.object, weapon_id, grade_level, context
            )
            index_value = self._evaluate_ast_node_with_context(
                node.index, weapon_id, grade_level, context
            )

            # 如果object_value是字符串，可能是表名
            if isinstance(object_value, str):
                # 移除#前缀（如果有）
                table_name = object_value.lstrip("#")
                table_data = self.data_loader.load_json(f"{table_name}.json")
                if not table_data:
                    raise ValueError(f"无法找到表 '{table_name}'")

                # 使用index_value作为ID获取数据
                item_id = str(index_value)
                if item_id in table_data:
                    item_data = table_data[item_id]
                    # 更新上下文，记录表类型和ID
                    context["table_type"] = table_name
                    context["table_id"] = index_value
                    return item_data
                else:
                    # 尝试使用整数ID
                    int_id = int(index_value)
                    if str(int_id) in table_data:
                        item_data = table_data[str(int_id)]
                        context["table_type"] = table_name
                        context["table_id"] = int_id
                        return item_data
                    else:
                        raise ValueError(f"表 '{table_name}' 中找不到ID '{item_id}'")

            # 如果object_value是字典，可能是访问嵌套字段
            elif isinstance(object_value, dict):
                # 尝试作为数组索引（转换为0-based）
                if isinstance(index_value, int):
                    adjusted_index = index_value - 1
                    keys = list(object_value.keys())
                    if 0 <= adjusted_index < len(keys):
                        key = keys[adjusted_index]
                        return object_value[key]
                    else:
                        raise ValueError(f"数组索引超出范围: {index_value}")
                else:
                    # 尝试作为键直接访问
                    index_str = str(index_value)
                    if index_str in object_value:
                        return object_value[index_str]
                    else:
                        raise ValueError(f"字典中找不到键: {index_str}")

            elif isinstance(object_value, list):
                # 列表索引（转换为0-based）
                if isinstance(index_value, int):
                    adjusted_index = index_value - 1
                    if 0 <= adjusted_index < len(object_value):
                        return object_value[adjusted_index]
                    else:
                        raise ValueError(f"列表索引超出范围: {index_value}")
                else:
                    raise ValueError(f"列表索引必须是整数: {index_value}")

            else:
                raise ValueError(f"无法对类型 {type(object_value)} 进行索引访问")

        elif node.type == NodeType.FUNCTION_CALL:
            # 函数调用: func(args)
            func_name = None

            # 获取函数名
            if node.object.type == NodeType.IDENTIFIER:
                func_name = node.object.value
            elif node.object.type == NodeType.MEMBER_ACCESS:
                # 处理 math.abs 这样的函数调用
                module_obj = self._evaluate_ast_node_with_context(
                    node.object.object, weapon_id, grade_level, context
                )
                func_name = node.object.property.value
                # 如果是 math 模块
                if isinstance(module_obj, str) and module_obj == "math":
                    func_name = f"math.{func_name}"
                else:
                    func_name = node.object.property.value

            # 计算所有参数的值
            args = []
            if node.arguments:
                for arg_node in node.arguments:
                    arg_value = self._evaluate_ast_node_with_context(
                        arg_node, weapon_id, grade_level, context
                    )
                    args.append(arg_value)

            # 执行函数调用
            return self._execute_function(func_name, args)

        else:
            raise ValueError(f"未知的节点类型: {node.type}")

    def _execute_function(self, func_name, args):
        """执行函数调用"""
        import math

        try:
            # 数学函数
            if func_name == "math.abs":
                if len(args) >= 1:
                    return abs(float(args[0]))
            elif func_name == "math.floor":
                if len(args) >= 1:
                    return math.floor(float(args[0]))
            elif func_name == "math.ceil":
                if len(args) >= 1:
                    return math.ceil(float(args[0]))
            elif func_name == "math.sqrt":
                if len(args) >= 1:
                    return math.sqrt(float(args[0]))
            elif func_name == "math.max":
                if len(args) >= 2:
                    return max(float(args[0]), float(args[1]))
            elif func_name == "math.min":
                if len(args) >= 2:
                    return min(float(args[0]), float(args[1]))
            elif func_name == "max":
                if len(args) >= 2:
                    return max(float(args[0]), float(args[1]))
            elif func_name == "min":
                if len(args) >= 2:
                    return min(float(args[0]), float(args[1]))
            elif func_name == "abs":
                if len(args) >= 1:
                    return abs(float(args[0]))
        except (ValueError, TypeError):
            return 0.0

        return 0.0

    def _get_attr_value_from_dict(
        self, data, attr_path, weapon_id, grade_level, table_type
    ):
        """从字典中根据属性路径获取值"""
        import re

        # 处理计算部分
        calc_value = 1.0
        calc_operation = None

        # 检查是否包含乘法或除法
        if "*" in attr_path:
            attr_part, calc_part = attr_path.split("*", 1)
            calc_part = calc_part.replace("%", "")
            try:
                calc_value = float(calc_part)
                calc_operation = "*"
            except ValueError:
                return "0.0"
        elif "/" in attr_path:
            attr_part, calc_part = attr_path.split("/", 1)
            calc_part = calc_part.replace("%", "")
            try:
                calc_value = float(calc_part)
                calc_operation = "/"
            except ValueError:
                return "0.0"
        else:
            attr_part = attr_path

        # 解析属性路径
        parts = attr_part.split(".")
        value = data

        for part in parts:
            if value is None:
                return "0.0"

            # 检查是否包含数组索引
            array_match = re.match(r"(\w+)\[(.*?)\]", part)
            if array_match:
                array_name = array_match.group(1)
                array_content = array_match.group(2)

                # 获取数组
                if isinstance(value, dict) and array_name in value:
                    array = value[array_name]
                    if isinstance(array, list):
                        # 计算索引
                        try:
                            # 尝试解析索引
                            if array_content.isdigit():
                                array_index = int(array_content) - 1
                            else:
                                # 可能是表达式，递归计算
                                array_index = int(
                                    self._calculate_expr_value(
                                        array_content,
                                        weapon_id,
                                        grade_level,
                                        table_type,
                                    )
                                )

                            if 0 <= array_index < len(array):
                                value = array[array_index]
                            else:
                                return "0.0"
                        except (ValueError, TypeError):
                            return "0.0"
                    else:
                        return "0.0"
                else:
                    return "0.0"
            else:
                # 普通属性访问
                if isinstance(value, dict) and part in value:
                    value = value[part]
                elif isinstance(value, list):
                    # 尝试在列表中查找
                    found = False
                    for item in value:
                        if isinstance(item, dict) and part in item:
                            value = item[part]
                            found = True
                            break
                    if not found:
                        return "0.0"
                else:
                    return "0.0"

        # 应用计算操作
        if calc_operation and value is not None:
            try:
                value_val = float(value)
                if calc_operation == "*":
                    value = value_val * calc_value
                elif calc_operation == "/":
                    value = value_val / calc_value if calc_value != 0 else 0.0
            except ValueError:
                return "0.0"

        return value

    def _calc_weapon_attr_by_level(self, attr, weapon_id, grade_level):
        """根据等级计算武器属性值"""
        # 检查是否是Rate属性
        is_rate = "Rate" in attr
        base = attr.get("Rate" if is_rate else "Value")

        # 处理LevelGrow
        level_grow = attr.get("LevelGrow")
        if level_grow is None:
            level_grow = 0

        try:
            # 尝试将base转换为数值
            if isinstance(base, str):
                if base.startswith("#"):
                    # 对于字符串类型的数值，如"#1"，使用SkillGrow配置来计算
                    grow_index = int(base.strip("#"))
                    grow_type = attr.get("Type", "BattleWeapon")

                    # 检查grow_type是否存在于skill_grow_data中
                    if grow_type not in self.skill_grow_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (grade_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_type_data = self.skill_grow_data[grow_type]
                    id_key = str(weapon_id)

                    # 检查id_key是否存在于skill_grow_type_data中
                    if id_key not in skill_grow_type_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (grade_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    id_data = skill_grow_type_data[id_key]
                    level_index = grade_level - 1

                    if level_index < 0 or level_index >= len(id_data):
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

                    # 查找匹配的Index
                    found_value = None

                    if isinstance(level_data, list):
                        for attr_entry in level_data:
                            if isinstance(attr_entry, dict):
                                if attr_entry["Index"] == grow_index:
                                    found_value = attr_entry["Value"]
                                    break
                    elif isinstance(level_data, dict):
                        if level_data["Index"] == grow_index:
                            found_value = level_data["Value"]

                    if found_value is not None:
                        return found_value
                    else:
                        return 0.0
                else:
                    # 对于其他字符串类型的数值，直接转换为float
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    value = base_num + level_grow_num * (grade_level - 1)
                    return value

            # 处理数值类型的base
            base_num = float(base)
            level_grow_num = float(level_grow)
            value = base_num + level_grow_num * (grade_level - 1)

            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            return 0.0
