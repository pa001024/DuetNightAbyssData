from dataclasses import dataclass
from typing import Union, List, Optional
from enum import Enum


class NodeType(Enum):
    """AST节点类型"""

    IDENTIFIER = "Identifier"
    MEMBER_ACCESS = "MemberAccess"
    INDEX_ACCESS = "IndexAccess"
    BINARY_EXPR = "BinaryExpression"
    UNARY_EXPR = "UnaryExpression"
    LITERAL = "Literal"
    ARRAY_ACCESS = "ArrayAccess"
    FUNCTION_CALL = "FunctionCall"  # 函数调用


@dataclass
class ASTNode:
    """AST节点基类"""

    type: NodeType
    value: Optional[Union[str, int, float]] = None
    left: Optional["ASTNode"] = None
    right: Optional["ASTNode"] = None
    operand: Optional["ASTNode"] = None
    object: Optional["ASTNode"] = None
    property: Optional["ASTNode"] = None
    index: Optional["ASTNode"] = None
    arguments: Optional[List["ASTNode"]] = None

    def __repr__(self):
        return self._to_str()

    def _to_str(self, indent: int = 0) -> str:
        """格式化输出AST树结构"""
        prefix = "  " * indent
        lines = [f"{prefix}{self.type.value}"]

        if self.value is not None:
            lines.append(f"{prefix}  value: {self.value}")

        if self.left:
            lines.append(f"{prefix}  left:")
            lines.append(self.left._to_str(indent + 2))

        if self.right:
            lines.append(f"{prefix}  right:")
            lines.append(self.right._to_str(indent + 2))

        if self.operand:
            lines.append(f"{prefix}  operand:")
            lines.append(self.operand._to_str(indent + 2))

        if self.object:
            lines.append(f"{prefix}  object:")
            lines.append(self.object._to_str(indent + 2))

        if self.property:
            lines.append(f"{prefix}  property:")
            lines.append(self.property._to_str(indent + 2))

        if self.index:
            lines.append(f"{prefix}  index:")
            lines.append(self.index._to_str(indent + 2))

        if self.arguments:
            lines.append(f"{prefix}  arguments:")
            for arg in self.arguments:
                lines.append(arg._to_str(indent + 2))

        return "\n".join(lines)


class ExpressionParser:
    """表达式解析器"""

    def __init__(self, expression: str):
        self.expression = expression.strip()
        self.pos = 0
        self.length = len(self.expression)

    def parse(self) -> ASTNode:
        """解析表达式并返回AST"""
        node = self._parse_expression()
        return node

    def _current_char(self) -> Optional[str]:
        """获取当前字符"""
        if self.pos < self.length:
            return self.expression[self.pos]
        return None

    def _peek(self, offset: int = 0) -> Optional[str]:
        """查看指定偏移位置的字符"""
        pos = self.pos + offset
        if pos < self.length:
            return self.expression[pos]
        return None

    def _advance(self, count: int = 1) -> None:
        """前进指定位置"""
        self.pos += count

    def _skip_whitespace(self) -> None:
        """跳过空白字符"""
        while self.pos < self.length and self.expression[self.pos].isspace():
            self.pos += 1

    def _parse_expression(self) -> ASTNode:
        """解析表达式"""
        return self._parse_binary_op()

    def _parse_binary_op(self, min_precedence: int = 0) -> ASTNode:
        """解析二元运算(处理运算符优先级)"""
        left = self._parse_member_access()

        while True:
            self._skip_whitespace()
            op = self._current_char()

            # 支持的运算符及其优先级
            # * 和 / 的优先级为 2
            # + 和 - 的优先级为 1
            # % 的优先级为 2
            op_precedence = None
            if op in ("*", "/", "%"):
                op_precedence = 2
            elif op in ("+", "-"):
                op_precedence = 1

            if op_precedence is not None:
                if op_precedence < min_precedence:
                    break

                self._advance()
                self._skip_whitespace()
                # 对于左结合的运算符，传入 op_precedence + 1
                right = self._parse_binary_op(op_precedence + 1)

                left = ASTNode(
                    type=NodeType.BINARY_EXPR, value=op, left=left, right=right
                )
            else:
                break

        return left

    def _parse_member_access(self) -> ASTNode:
        """解析成员访问表达式"""
        node = self._parse_primary()

        while True:
            self._skip_whitespace()
            char = self._current_char()

            if char == ".":
                # 成员访问: object.property
                self._advance()
                self._skip_whitespace()
                identifier = self._parse_identifier()

                node = ASTNode(
                    type=NodeType.MEMBER_ACCESS, object=node, property=identifier
                )
            elif char == "[":
                # 索引访问: object[index] 或 object[#inner]
                self._advance()
                self._skip_whitespace()

                index_node = self._parse_expression()

                self._skip_whitespace()
                if self._current_char() != "]":
                    raise ValueError(f"Expected ']' at position {self.pos}")

                self._advance()
                node = ASTNode(
                    type=NodeType.INDEX_ACCESS, object=node, index=index_node
                )
            elif char == "(":
                # 函数调用: func(args)
                self._advance()
                self._skip_whitespace()

                # 解析参数列表
                args = []
                if self._current_char() != ")":
                    # 解析第一个参数
                    args.append(self._parse_expression())

                    # 解析后续参数
                    while self._current_char() == ",":
                        self._advance()
                        self._skip_whitespace()
                        args.append(self._parse_expression())

                self._skip_whitespace()
                if self._current_char() != ")":
                    raise ValueError(f"Expected ')' at position {self.pos}")

                self._advance()
                node = ASTNode(type=NodeType.FUNCTION_CALL, object=node, arguments=args)
            else:
                break

        return node

    def _parse_trailing_ops(self, node: ASTNode) -> ASTNode:
        """解析成员访问、索引访问和函数调用（用于一元表达式后）"""
        while True:
            self._skip_whitespace()
            char = self._current_char()

            if char == ".":
                # 成员访问: object.property
                self._advance()
                self._skip_whitespace()
                identifier = self._parse_identifier()

                node = ASTNode(
                    type=NodeType.MEMBER_ACCESS, object=node, property=identifier
                )
            elif char == "[":
                # 索引访问: object[index] 或 object[#inner]
                self._advance()
                self._skip_whitespace()

                index_node = self._parse_expression()

                self._skip_whitespace()
                if self._current_char() != "]":
                    raise ValueError(f"Expected ']' at position {self.pos}")

                self._advance()
                node = ASTNode(
                    type=NodeType.INDEX_ACCESS, object=node, index=index_node
                )
            elif char == "(":
                # 函数调用: func(args)
                self._advance()
                self._skip_whitespace()

                # 解析参数列表
                args = []
                if self._current_char() != ")":
                    # 解析第一个参数
                    args.append(self._parse_expression())

                    # 解析后续参数
                    while self._current_char() == ",":
                        self._advance()
                        self._skip_whitespace()
                        args.append(self._parse_expression())

                self._skip_whitespace()
                if self._current_char() != ")":
                    raise ValueError(f"Expected ')' at position {self.pos}")

                self._advance()
                node = ASTNode(type=NodeType.FUNCTION_CALL, object=node, arguments=args)
            else:
                break

        return node

    def _parse_primary(self) -> ASTNode:
        """解析基础表达式"""
        self._skip_whitespace()
        char = self._current_char()

        if char is None:
            raise ValueError("Unexpected end of expression")

        if char == "(":
            # 括号表达式: (expr)
            self._advance()
            self._skip_whitespace()

            # 解析括号内的表达式
            expr_node = self._parse_expression()

            self._skip_whitespace()
            if self._current_char() != ")":
                raise ValueError(f"Expected ')' at position {self.pos}")

            self._advance()
            return expr_node

        elif char in ("+", "-"):
            # 一元运算符: +expr 或 -expr
            op = char
            self._advance()
            self._skip_whitespace()

            # 解析操作数
            operand = self._parse_primary()

            # 对于一元减号，如果是数字字面量，直接返回负数
            if operand.type == NodeType.LITERAL and op == "-":
                return ASTNode(type=NodeType.LITERAL, value=-operand.value)

            # 继续解析可能的成员访问、索引访问或函数调用
            operand = self._parse_trailing_ops(operand)

            # 构造一元表达式
            if op == "-":
                return ASTNode(type=NodeType.UNARY_EXPR, value=op, operand=operand)
            else:
                # 一元加号直接返回操作数
                return operand

        elif char in ('"', "'"):
            # 字符串字面量
            return self._parse_string()

        elif char.isalpha() or char == "_" or char == "#":
            # 标识符
            return self._parse_identifier()
        elif char.isdigit():
            # 数字字面量
            return self._parse_number()

        raise ValueError(f"Unexpected character '{char}' at position {self.pos}")

    def _parse_identifier(self) -> ASTNode:
        """解析标识符"""
        start = self.pos

        # 标识符以 # 或字母或下划线开头
        if (
            self._current_char() not in ("#", "_")
            and not self._current_char().isalpha()
        ):
            raise ValueError(f"Expected identifier at position {self.pos}")

        self._advance()

        # 继续读取字母、数字或下划线
        while self._current_char() and (
            self._current_char().isalnum() or self._current_char() == "_"
        ):
            self._advance()

        value = self.expression[start : self.pos]
        return ASTNode(type=NodeType.IDENTIFIER, value=value)

    def _parse_number(self) -> ASTNode:
        """解析数字"""
        start = self.pos

        # 读取整数部分
        while self._current_char() and self._current_char().isdigit():
            self._advance()

        # 读取小数部分
        if self._current_char() == ".":
            self._advance()
            while self._current_char() and self._current_char().isdigit():
                self._advance()

        value_str = self.expression[start : self.pos]

        # 尝试转换为整数或浮点数
        try:
            if "." in value_str:
                value = float(value_str)
            else:
                value = int(value_str)
        except ValueError:
            raise ValueError(f"Invalid number '{value_str}' at position {start}")

        return ASTNode(type=NodeType.LITERAL, value=value)

    def _parse_string(self) -> ASTNode:
        """解析字符串字面量"""
        quote = self._current_char()
        self._advance()  # 跳过开始的引号

        start = self.pos
        value_chars = []

        # 读取字符串内容直到遇到结束引号
        while self._current_char() and self._current_char() != quote:
            # 支持转义字符
            if self._current_char() == "\\":
                self._advance()
                if self._current_char():
                    value_chars.append(self._current_char())
                    self._advance()
            else:
                value_chars.append(self._current_char())
                self._advance()

        if self._current_char() != quote:
            raise ValueError(f"Unterminated string literal at position {start}")

        self._advance()  # 跳过结束引号

        value = "".join(value_chars)
        return ASTNode(type=NodeType.LITERAL, value=value)


def parse_ast(p: str) -> ASTNode:
    """解析表达式字符串并返回AST"""
    parser = ExpressionParser(p)
    return parser.parse()


def test_parser():
    """测试解析器"""
    test_cases = [
        "TargetFilter[#SkillEffects[310313].TargetFilter].LuaFilterParaments.CrossWidth/50",
        "#TargetFilter[#SkillEffects[310313].TargetFilter].LuaFilterParaments.CrossWidth/50",
        "SkillEffects[310313].TargetFilter",
        "LuaFilterParaments.CrossWidth",
        "TargetFilter.LuaFilterParaments",
        "100/50",
        "PropertyName",
        "Array[0]",
        "#Nested[Outer[Inner]]",
        "math.abs(#Buff[410111].DotDatas[1].Value)",
        "max(100, 200)",
        "min(Value1, Value2)",
    ]

    for expr in test_cases:
        print(f"\n{'=' * 60}")
        print(f"表达式: {expr}")
        print("=" * 60)
        try:
            ast = parse_ast(expr)
            print(ast)
        except Exception as e:
            print(f"错误: {e}")


if __name__ == "__main__":
    test_parser()
