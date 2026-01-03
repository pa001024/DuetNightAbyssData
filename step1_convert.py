import os
import json
from collections import OrderedDict
from lupa import LuaRuntime

# 定义Datas文件夹路径和输出文件夹路径
datas_dir = ".\\Datas"
out_dir = ".\\out"


def deep_sort_json(data):
    """递归排序JSON数据中的所有字典"""
    if isinstance(data, (str, int, float, bool, type(None))):
        return data
    elif isinstance(data, list):
        return [deep_sort_json(item) for item in data]
    elif isinstance(data, (dict, OrderedDict)):
        # 对字典键进行排序，然后递归排序值
        # 自定义排序键：处理混合类型的键
        def sort_key(item):
            key = item[0]
            if isinstance(key, (int, float)):
                return (0, key)  # 数字键排在前面，按数值排序
            elif isinstance(key, str):
                if key.isdigit():
                    return (1, int(key), key)  # 数字字符串排在数字键之后，按数值排序
                return (2, key)  # 其他字符串键按字典序排序
            else:
                return (3, str(key))  # 其他类型转为字符串排序

        sorted_items = sorted(data.items(), key=sort_key)
        sorted_dict = OrderedDict()
        for key, value in sorted_items:
            sorted_dict[key] = deep_sort_json(value)
        return sorted_dict
    return data


def convert_lua_data(lua_data, seen=None):
    """将Lua数据转换为Python数据，添加循环引用检测"""
    if seen is None:
        seen = set()

    if lua_data is None:
        return None

    # 基本类型直接返回，无循环引用问题
    if isinstance(lua_data, (str, int, float, bool)):
        return lua_data

    # 检查是否为循环引用
    lua_id = id(lua_data)
    if lua_id in seen:
        return f"[循环引用: {type(lua_data).__name__}]"
    seen.add(lua_id)

    try:
        # 检查是否为Lua表（具有items方法）
        if hasattr(lua_data, "items"):
            # 获取所有键值对
            items = list(lua_data.items())

            # 仅将特定文件类型的特定表转换为列表
            # 我们只转换明显是数组的表，即键从1开始连续的整数键表
            # 但排除一些不应转换为列表的文件类型
            file_path = getattr(lua_data, "__file_path", "")

            is_array = True
            max_key = 0
            all_keys = []

            # 检查是否所有键都是整数（包括浮点数形式的整数，如1.0）
            for key, _ in items:
                if not (isinstance(key, (int, float)) and key.is_integer()):
                    is_array = False
                    break
                all_keys.append(int(key))  # 转换为整数存储
                int_key = int(key)
                if int_key > max_key:
                    max_key = int_key

            # 检查键是否从1到max_key连续
            if is_array and max_key > 0:
                for i in range(1, max_key + 1):
                    if i not in all_keys:
                        is_array = False
                        break

            # 只转换明显是数组的表，即键从1开始连续的整数键表
            # 但排除奖励表等不应转换为列表的表
            should_convert_to_array = False

            # 检查是否应该转换为列表
            if max_key > 0 and is_array:
                # 默认转换为列表
                should_convert_to_array = True

                # 排除奖励表等不应转换为列表的表
                # 奖励表通常包含Id、Type、Count等字段
                is_reward_table = False
                for _, value in items:
                    if isinstance(value, dict):
                        # 检查是否包含奖励表的典型字段
                        reward_fields = ["Id", "Type", "Count"]
                        for field in reward_fields:
                            if field in value:
                                is_reward_table = True
                                break
                    if is_reward_table:
                        break

                if is_reward_table:
                    should_convert_to_array = False

            if should_convert_to_array:
                try:
                    # 转换为列表，保持顺序
                    python_list = [None] * max_key
                    for key, value in items:
                        python_value = convert_lua_data(value, seen.copy())
                        python_list[key - 1] = python_value
                    return python_list
                except IndexError:
                    # 如果发生索引错误，回退到字典转换
                    should_convert_to_array = False

            # 转换为普通字典
            python_dict = {}
            for key, value in items:
                python_key = key
                python_value = convert_lua_data(value, seen.copy())
                python_dict[python_key] = python_value

            # 对字典按键进行排序，处理混合类型的键
            sorted_python_dict = OrderedDict()

            # 自定义排序函数，将字符串键和整数键分开处理
            def custom_sort_key(key):
                if isinstance(key, (int, float)):
                    return (0, key)  # 数字键排在前面，按数值排序
                elif isinstance(key, str):
                    return (1, key)  # 字符串键排在后面，按字典序排序
                else:
                    return (2, str(key))  # 其他类型转为字符串排序

            # 使用自定义排序函数排序键
            for key in sorted(python_dict.keys(), key=custom_sort_key):
                sorted_python_dict[key] = python_dict[key]

            return sorted_python_dict

        # 检查是否为可调用对象且不是表
        if callable(lua_data) and not hasattr(lua_data, "items"):
            # 这是一个函数，我们需要执行它来获取返回值
            try:
                result = lua_data()
                return convert_lua_data(result, seen.copy())
            except Exception as e:
                print(f"执行函数时出错: {e}")
                return None

        # 检查是否为Lua列表（具有len和getitem方法）
        if hasattr(lua_data, "__len__") and hasattr(lua_data, "__getitem__"):
            # 转换列表为Python列表
            python_list = []
            for i in range(len(lua_data)):
                try:
                    item = lua_data[i]
                    python_value = convert_lua_data(item, seen.copy())
                    python_list.append(python_value)
                except Exception as e:
                    print(f"获取列表元素 {i} 时出错: {e}")
                    continue
            return python_list

        # 其他类型直接返回
        return lua_data
    finally:
        seen.remove(lua_id)


def parse_lua_file(file_path):
    """解析Lua文件并返回数据，优先处理return值"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            lua_code = f.read()

        # 创建Lua运行时实例
        lua_instance = LuaRuntime(unpack_returned_tuples=True)

        # 1. 优先尝试获取返回值
        print(f"在文件 {file_path} 中优先尝试获取返回值")

        # 尝试1: 使用pcall执行整个文件，捕获返回值
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)

            # 定义ReadOnly函数，使其在全局环境中可用
            new_lua.execute("ReadOnly = function(name, data) return data end")

            # 执行代码并捕获返回值
            execute_func = new_lua.eval(
                """
                function(code)
                    local chunk, err = load(code)
                    if not chunk then
                        return nil, err
                    end
                    return pcall(chunk)
                end
                """
            )
            success, result = execute_func(lua_code)
            if success and result is not None:
                print(f"在文件 {file_path} 中通过pcall执行获取到返回值")
                return convert_lua_data(result)
        except Exception as e:
            print(f"通过pcall执行文件 {file_path} 时出错: {e}")

        # 尝试2: 提取并执行return语句
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)

            # 定义ReadOnly函数
            new_lua.execute("ReadOnly = function(name, data) return data end")

            # 首先执行代码，让所有局部变量（如T）被定义
            new_lua.execute(lua_code)

            # 现在提取return语句并执行
            import re

            # 使用正则表达式查找完整的return ReadOnly语句
            return_pattern = (
                r'return\s+ReadOnly\s*\(\s*(["\'])Buff["\']\s*,\s*({.*?})\s*\)\s*$'
            )
            return_match = re.search(return_pattern, lua_code, re.DOTALL)

            if return_match:
                # 提取表定义部分
                table_def = return_match.group(2)
                # 构建完整的return语句
                return_statement = f"return ReadOnly('Buff', {table_def})"
                # 执行return语句，获取返回值
                result = new_lua.eval(return_statement)
                if result is not None:
                    print(f"在文件 {file_path} 中通过直接执行return语句获取到返回值")
                    return convert_lua_data(result)
        except Exception as e:
            print(f"通过直接执行return语句获取文件 {file_path} 数据时出错: {e}")

        # 尝试3: 修改代码，将return语句替换为赋值给全局变量
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)
            # 定义ReadOnly函数
            new_lua.execute("ReadOnly = function(name, data) return data end")
            # 将return语句替换为赋值给全局变量
            modified_code = lua_code.replace(
                "return ReadOnly(", "_G.__lua_result = ReadOnly("
            )
            # 执行修改后的代码
            new_lua.execute(modified_code)
            # 获取结果
            result = new_lua.globals().__lua_result
            if result is not None:
                print(f"在文件 {file_path} 中通过修改return语句获取到返回值")
                return convert_lua_data(result)
        except Exception as e:
            print(f"通过修改return语句执行文件 {file_path} 时出错: {e}")

        # 2. 尝试获取Data变量
        print(f"在文件 {file_path} 中尝试获取Data变量")
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)
            # 定义ReadOnly函数
            new_lua.execute("local ReadOnly = function(name, data) return data end")
            # 执行Lua代码
            new_lua.execute(lua_code)
            data = new_lua.globals().Data
            if data is not None:
                print(f"在文件 {file_path} 中找到Data变量")
                return convert_lua_data(data)
        except Exception as e:
            print(f"访问文件 {file_path} 中的Data变量时出错: {e}")

        # 3. 尝试直接执行整个文件，检查全局变量
        print(f"在文件 {file_path} 中尝试直接执行并检查全局变量")
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)
            # 定义ReadOnly函数
            new_lua.execute("local ReadOnly = function(name, data) return data end")
            # 直接执行文件
            new_lua.execute(lua_code)
            # 尝试获取一些可能的全局变量
            for global_name in ["Data", "__result", "return_value"]:
                data = new_lua.globals().get(global_name)
                if data is not None:
                    print(f"在文件 {file_path} 中找到全局变量 {global_name}")
                    return convert_lua_data(data)
        except Exception as e:
            print(f"直接执行文件 {file_path} 时出错: {e}")

        # 4. 尝试处理局部变量T（如Reward.lua中的格式）
        print(f"在文件 {file_path} 中尝试处理局部变量T")
        try:
            # 创建一个新的Lua运行时实例
            new_lua = LuaRuntime(unpack_returned_tuples=True)
            # 定义ReadOnly函数
            new_lua.execute("local ReadOnly = function(name, data) return data end")
            # 修改代码，将局部变量T转换为全局变量以便访问
            modified_code = lua_code.replace("local T = {}", "T = {}")
            # 执行修改后的Lua代码
            new_lua.execute(modified_code)
            # 获取全局变量T
            data = new_lua.globals().T
            if data is not None:
                print(f"在文件 {file_path} 中找到全局变量T")
                return convert_lua_data(data)
        except Exception as e:
            print(f"处理文件 {file_path} 中的局部变量T时出错: {e}")

        # 如果所有方法都失败
        print(f"在文件 {file_path} 中未找到可解析的数据")
        return None
    except Exception as e:
        print(f"解析文件 {file_path} 时出错: {e}")
        return None


def main():
    """主函数"""
    # 遍历Datas文件夹下的所有Lua文件
    for root, dirs, files in os.walk(datas_dir):
        for file in files:
            if file.endswith(".lua"):
                file_path = os.path.join(root, file)
                print(f"\n正在处理文件: {file_path}")

                # 解析Lua文件
                data = parse_lua_file(file_path)

                if data:
                    # 生成输出文件路径，保持原始目录结构，添加i18n文件夹
                    relative_path = os.path.relpath(file_path, datas_dir)
                    output_file = os.path.join(
                        out_dir, relative_path.replace(".lua", ".json")
                    )
                    # 创建输出目录
                    output_dir = os.path.dirname(output_file)
                    os.makedirs(output_dir, exist_ok=True)
                    try:
                        # 对数据进行深层排序
                        sorted_data = deep_sort_json(data)
                        # 将数据写入JSON文件，确保输出的JSON是排序的
                        with open(output_file, "w", encoding="utf-8") as f:
                            json.dump(
                                sorted_data,
                                f,
                                ensure_ascii=False,
                                indent=2,
                            )
                        print(f"文件 {file} 已转换为JSON格式并保存到 {output_file}")
                    except Exception as e:
                        print(f"将文件 {file} 写入JSON时出错: {e}")
                else:
                    print(f"文件 {file} 解析失败")


if __name__ == "__main__":
    main()
