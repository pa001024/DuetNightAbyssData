import json
from collections import OrderedDict


class BaseProcessor:
    def __init__(self, data_loader):
        self.data_loader = data_loader
        self.file_type = "Base"
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")

    def get_file_type(self):
        return self.file_type

    def process_item(self, item_data, language):
        """处理单个项目，子类必须实现"""
        raise NotImplementedError("Subclasses must implement process_item method")

    def load_items(self, file_path):
        """加载项目数据"""
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        # Convert map to array if needed
        if isinstance(data, dict):
            return list(data.values())
        else:
            return data

    def process_all_items(self, items, language):
        """处理所有项目"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if not processed:
                continue
            processed_items.append(processed)
        return processed_items

    def save_processed_items(self, processed_items, output_path, file_name):
        """保存处理后的项目"""
        import os
        from pathlib import Path

        # Create output directory if it doesn't exist
        Path(output_path).mkdir(parents=True, exist_ok=True)

        # Write processed data to file
        output_file = os.path.join(output_path, file_name)
        with open(output_file, "w", encoding="utf-8") as f:
            import json

            json.dump(processed_items, f, ensure_ascii=False, indent=2, sort_keys=False)

        return output_file

    def process_release(self, release_version):
        """处理角色版本数据 100->1.3"""
        if not release_version:
            return ""
        return (
            f"{release_version // 100}.{release_version % 100 // 10}"
            if release_version
            else "1.0"
        )

    def process_tags(self, tags):
        """处理武器标签"""
        if not tags or not isinstance(tags, list):
            return []
        Positioning = self.data_loader.load_json("Positioning.json")
        rst = []
        tag_map = {
            "Ultra": "同律",
            "Melee": "近战",
            "Ranged": "远程",
            "Bow": self.get_translated_text("WeaponType_Bow", "cn"),
            "Bow01": self.get_translated_text("WeaponType_Bow01", "cn"),
            "Bow02": self.get_translated_text("WeaponType_Bow02", "cn"),
            "Cannon": self.get_translated_text("WeaponType_Cannon", "cn"),
            "Claymore": self.get_translated_text("WeaponType_Claymore", "cn"),
            "Crossbow": self.get_translated_text("WeaponType_Crossbow", "cn"),
            "Dualblade": self.get_translated_text("WeaponType_Dualblade", "cn"),
            "Katana": self.get_translated_text("WeaponType_Katana", "cn"),
            "Machinegun": self.get_translated_text("WeaponType_Machinegun", "cn"),
            "Pistol": self.get_translated_text("WeaponType_Pistol", "cn"),
            "Polearm": self.get_translated_text("WeaponType_Polearm", "cn"),
            "Shotgun": self.get_translated_text("WeaponType_Shotgun", "cn"),
            "Sword": self.get_translated_text("WeaponType_Sword", "cn"),
            "Swordwhip": self.get_translated_text("WeaponType_Swordwhip", "cn"),
        }
        for tag in tags:
            t = tag_map.get(tag, "")
            if t:
                rst.append(t)
            elif tag in Positioning:
                t = Positioning[tag]
                rst.append(self.get_translated_text(t["Name"]))
        return rst

    def get_translated_text(self, text_key, language=""):
        """从i18n数据中获取翻译文本"""
        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return text_key

        # 获取当前语言
        language = language if language else self.data_loader.language

        # 根据当前语言获取对应字段
        # 语言映射：cn->TextMapContent, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, tc->ContentTC
        language_field_map = {
            "cn": "TextMapContent",
            "en": "ContentEN",
            "jp": "ContentJP",
            "kr": "ContentKR",
            "fr": "ContentFR",
            "es": "ContentES",
            "tc": "ContentTC",
        }

        # 获取对应语言字段
        field = language_field_map.get(language, "TextMapContent")
        content = text_entry.get(field, "")

        # 如果对应语言字段为空，尝试使用其他可用字段
        if not content:
            # 优先顺序：TextMapContent > ContentEN > ContentJP > ContentKR > ContentFR > ContentTC
            for fallback_field in [
                "TextMapContent",
                "ContentEN",
                "ContentJP",
                "ContentKR",
                "ContentFR",
                "ContentES",
                "ContentTC",
            ]:
                if fallback_field in text_entry and text_entry[fallback_field]:
                    content = text_entry[fallback_field]
                    break
        if content[:-4] == "{空格}":
            content = content.replace("{空格}", " ")
        return content or text_key

    def get_translated_dialogue(self, dialogue_key, language=""):
        """获取翻译后的对话文本

        Args:
            dialogue_key: 对话键
            language: 语言类型

        Returns:
            str: 翻译后的对话文本
        """
        # 获取当前语言
        language = language if language else self.data_loader.language

        # 语言映射：cn->TextMapContent, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, tc->ContentTC
        language_field_map = {
            "cn": "TextMapContent",
            "en": "ContentEN",
            "jp": "ContentJP",
            "kr": "ContentKR",
            "fr": "ContentFR",
            "es": "ContentES",
            "tc": "ContentTC",
        }

        # 获取对应语言字段
        field = language_field_map.get(language, "TextMapContent")

        # 构建文件名
        filename = f"Dialogue_{field}.json"

        try:
            # 加载对话数据
            dialogue_data = self.data_loader.load_json(filename)
            # 查找对话键
            if dialogue_key in dialogue_data:
                return dialogue_data[dialogue_key]
            else:
                return dialogue_key
        except Exception as e:
            print(f"加载对话数据失败: {e}")
            return dialogue_key

    def round_value(self, value):
        """四舍五入到最多3位小数，等效于JS的 +num.toFixed(3)"""
        # 先四舍五入到3位小数
        rounded = round(value * 10000) / 10000
        # 如果结果是整数（如 3.0），返回整数
        if abs(rounded - round(rounded)) < 0.00001:
            return int(round(rounded))
        # 否则返回浮点数（自动去除末尾的0）
        return rounded

    def preprocess_expression(self, desc_value):
        """预处理表达式，将 $GText("...")$ 替换为翻译后的文本"""
        import re

        if not isinstance(desc_value, str):
            return desc_value

        result = desc_value

        # 替换所有 $GText("...")$ 为翻译后的文本
        def replace_gtext(match):
            text_key = match.group(1)
            translated = self.get_translated_text(text_key)
            return translated if translated else text_key

        result = re.sub(r'\$GText\("([^"]+)"\)\$', replace_gtext, result)

        return result

    def _calculate_expr_value(self, expr, table_id, level, table_type):
        """计算表达式值，使用AST解析和上下文跟踪

        Args:
            expr: 表达式字符串
            table_id: 当前项目ID（技能ID/武器ID/角色ID）
            level: 当前等级
            table_type: 表类型（用于SkillGrow查找）

        Returns:
            计算后的数值
        """
        from ast_parser import parse_ast

        try:
            ast = parse_ast(expr)
            # 初始化上下文
            context = {}
            if table_type:
                context["table_type"] = table_type
            if table_id:
                context["table_id"] = table_id

            result = self._evaluate_ast_node_with_context(ast, table_id, level, context)

            return float(result)
        except Exception as e:
            print(f"计算表达式 '{expr}' 失败: {e}", flush=True)
            import traceback

            traceback.print_exc()
            return 0.0

    def _evaluate_ast_node_with_context(
        self, node, table_id=None, level=1, context=None
    ):
        """使用上下文信息评估AST节点

        Args:
            node: AST节点
            table_id: 当前项目的ID
            level: 当前等级
            context: 上下文信息字典，包含 table_type 和 table_id

        Returns:
            评估后的值
        """
        from ast_parser import NodeType

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
                node.left, table_id, level, context
            )

            # 评估右侧表达式（同样使用相同上下文）
            right_value = self._evaluate_ast_node_with_context(
                node.right, table_id, level, context
            )

            # 如果左侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(left_value, str) and left_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": left_value,
                }

                left_value = self._calc_attr_by_level(attr, context_table_id, level)

            # 如果右侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(right_value, str) and right_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": right_value,
                }

                right_value = self._calc_attr_by_level(attr, context_table_id, level)

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

        elif node.type == NodeType.UNARY_EXPR:
            # 一元表达式：如 -x
            operand_value = self._evaluate_ast_node_with_context(
                node.operand, table_id, level, context
            )

            # 如果操作数是字符串且以#开头，使用SkillGrow查找
            if isinstance(operand_value, str) and operand_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": operand_value,
                }

                operand_value = self._calc_attr_by_level(attr, context_table_id, level)

            op = node.value
            if op == "-":
                # 一元减号
                return -operand_value
            elif op == "+":
                # 一元加号，直接返回操作数
                return operand_value
            else:
                raise ValueError(f"未知的一元运算符: {op}")

        elif node.type == NodeType.MEMBER_ACCESS:
            # 成员访问: object.property

            try:
                object_value = self._evaluate_ast_node_with_context(
                    node.object, table_id, level, context
                )
            except Exception as e:
                print(f"DEBUG MEMBER_ACCESS: Exception evaluating object: {e}")
                raise e

            property_name = node.property.value

            # 如果object_value是字典，访问属性
            if isinstance(object_value, dict):
                if property_name in object_value:
                    value = object_value[property_name]

                    # 如果值是字符串且以#开头，使用SkillGrow查找
                    if isinstance(value, str) and value.startswith("#"):
                        # 使用上下文信息进行SkillGrow查找
                        table_type = context.get("table_type", "Skill")
                        context_table_id = context.get("table_id", table_id)

                        # 构建attr对象用于SkillGrow查找
                        # 检查attr中是否有Rate字段，如果有则使用Rate，否则使用Value
                        attr_key = None
                        if hasattr(object_value, "get"):
                            # 检查object的父级是否有Rate或Value字段
                            for key in object_value.keys():
                                if key == "Rate":
                                    attr_key = "Rate"
                                    break
                                elif key == "Value" and attr_key != "Rate":
                                    attr_key = "Value"
                        if not attr_key:
                            attr_key = "Rate" if "Rate" in property_name else "Value"

                        attr = {
                            "Type": table_type,
                            attr_key: value,
                        }
                        # 调用_calc_attr_by_level获取实际值
                        result = self._calc_attr_by_level(attr, context_table_id, level)
                        return result
                    else:
                        return value
                else:
                    # 属性不存在时返回 0
                    return 0.0
            else:
                return 0.0

        elif node.type == NodeType.INDEX_ACCESS:
            # 索引访问: object[index]
            object_value = self._evaluate_ast_node_with_context(
                node.object, table_id, level, context
            )
            index_value = self._evaluate_ast_node_with_context(
                node.index, table_id, level, context
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
                    # else:
                    #     raise ValueError(f"数组索引超出范围: {index_value}")
                # 尝试作为键直接访问
                index_str = str(index_value)
                if index_str in object_value:
                    return object_value[index_str]
                else:
                    raise ValueError(f"字典中找不到键: {index_str}")

            elif isinstance(object_value, list):
                # 列表索引（转换为0-based）
                if isinstance(index_value, int):
                    adjusted_index = max(0, index_value - 1)
                    if 0 <= adjusted_index < len(object_value):
                        return object_value[adjusted_index]
                    else:
                        raise ValueError(f"列表索引超出范围: {index_value}")
                else:
                    raise ValueError(f"列表索引必须是整数: {index_value}")

            else:
                raise ValueError(f"无法对类型 {type(object_value)} 进行索引访问")

        elif node.type == NodeType.UNARY_EXPR:
            # 一元表达式：如 -x
            operand_value = self._evaluate_ast_node_with_context(
                node.operand, table_id, level, context
            )

            # 如果操作数是字符串且以#开头，使用SkillGrow查找
            if isinstance(operand_value, str) and operand_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": operand_value,
                }

                operand_value = self._calc_attr_by_level(attr, context_table_id, level)

            op = node.value
            if op == "-":
                # 一元减号
                return -operand_value
            elif op == "+":
                # 一元加号，直接返回操作数
                return operand_value
            else:
                raise ValueError(f"未知的一元运算符: {op}")

        elif node.type == NodeType.FUNCTION_CALL:
            # 函数调用: func(args)
            func_name = None

            # 获取函数名
            if node.object.type == NodeType.IDENTIFIER:
                func_name = node.object.value
            elif node.object.type == NodeType.MEMBER_ACCESS:
                # 处理 math.abs 这样的函数调用
                module_obj = self._evaluate_ast_node_with_context(
                    node.object.object, table_id, level, context
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
                        arg_node, table_id, level, context
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

    def _get_attr_value_from_dict(self, data, attr_path, table_id, level, table_type):
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
                                        table_id,
                                        level,
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

    def get_translated_dialogue(self, dialogue_key, language=""):
        """获取翻译后的对话文本

        Args:
            dialogue_key: 对话键值
            language: 语言代码，如 "cn", "en", "jp", "kr", "fr", "es", "tc"

        Returns:
            翻译后的对话文本，如果未找到则返回原键值
        """
        # 获取当前语言
        language = language if language else self.data_loader.language

        # 语言映射：cn->Dialogue_TextMapContent, en->Dialogue_ContentEN, jp->Dialogue_ContentJP, kr->Dialogue_ContentKR, fr->Dialogue_ContentFR, tc->Dialogue_ContentTC
        language_file_map = {
            "cn": "Dialogue_TextMapContent",
            "en": "Dialogue_ContentEN",
            "jp": "Dialogue_ContentJP",
            "kr": "Dialogue_ContentKR",
            "fr": "Dialogue_ContentFR",
            "es": "Dialogue_ContentES",
            "tc": "Dialogue_ContentTC",
        }

        # 获取对应语言文件
        file_name = language_file_map.get(language, "Dialogue_TextMapContent")

        try:
            # 加载对话文件
            dialogue_data = self.data_loader.load_json(f"{file_name}.json")

            # 查找对话键值
            if dialogue_key in dialogue_data:
                # 对于Dialogue_TextMapContent.json，直接返回对应值
                if file_name == "Dialogue_TextMapContent":
                    return dialogue_data[dialogue_key]
                # 对于其他语言文件，返回对应值
                else:
                    return dialogue_data.get(dialogue_key, dialogue_key)
            else:
                # 如果当前语言未找到，尝试使用中文作为 fallback
                if language != "cn":
                    try:
                        cn_dialogue_data = self.data_loader.load_json(
                            "Dialogue_TextMapContent.json"
                        )
                        if dialogue_key in cn_dialogue_data:
                            return cn_dialogue_data[dialogue_key]
                    except Exception:
                        pass
                return dialogue_key
        except Exception as e:
            # 如果加载文件失败，返回原键值
            print(f"加载对话文件失败: {e}", flush=True)
            return dialogue_key

    def _calc_attr_by_level(self, attr, table_id, level):
        """根据等级计算属性值（基类方法，子类可以覆盖）"""
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
                    grow_type = attr.get("Type", "Skill")

                    # 获取skill_grow_data - 子类需要提供此属性
                    if not hasattr(self, "skill_grow_data"):
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_data = self.skill_grow_data

                    # 检查grow_type是否存在于skill_grow_data中
                    if grow_type not in skill_grow_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_type_data = skill_grow_data[grow_type]
                    id_key = str(table_id)

                    # 检查id_key是否存在于skill_grow_type_data中
                    if id_key not in skill_grow_type_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    id_data = skill_grow_type_data[id_key]
                    level_index = level - 1

                    if level_index < 0 or level_index >= len(id_data):
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

                    # 查找匹配的Index
                    found_value = None

                    if isinstance(level_data, list):
                        for attr_entry in level_data:
                            if isinstance(attr_entry, dict):
                                # Check if grow_index (as string) is a key in dict (actual format)
                                # or if Index property equals grow_index (old format)
                                if str(grow_index) in attr_entry:
                                    found_value = attr_entry[str(grow_index)].get(
                                        "Value"
                                    )
                                    break
                                elif (
                                    "Index" in attr_entry
                                    and attr_entry["Index"] == grow_index
                                ):
                                    found_value = attr_entry["Value"]
                                    break
                                # Also check if grow_index (as string) is a key in the dict
                                elif str(grow_index) in attr_entry:
                                    found_value = attr_entry[str(grow_index)].get(
                                        "Value"
                                    )
                                    break
                    elif isinstance(level_data, dict):
                        if "Index" in level_data and level_data["Index"] == grow_index:
                            found_value = level_data["Value"]
                        elif str(grow_index) in level_data:
                            found_value = level_data[str(grow_index)].get("Value")

                    if found_value is not None:
                        return found_value
                    else:
                        return 0.0
                else:
                    # 对于其他字符串类型的数值，直接转换为float
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    value = base_num + level_grow_num * (level - 1)
                    return value

            # 处理数值类型的base
            base_num = float(base)
            level_grow_num = float(level_grow)
            value = base_num + level_grow_num * (level - 1)

            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            return 0.0
