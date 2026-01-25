#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
使用unluac.jar反编译bin/Script目录下的所有Lua文件到根目录Script目录
"""

import os
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed

def decompile_file(unluac_path, input_file, output_file, relative_path):
    """
    反编译单个Lua文件
    
    Args:
        unluac_path: unluac.jar的路径
        input_file: 输入Lua文件路径
        output_file: 输出Lua文件路径
        relative_path: 相对路径，用于显示进度
    """
    try:
        # 执行反编译命令，添加--rawstring参数处理转义字符串
        cmd = [
            "java", "-jar", unluac_path,
            "--rawstring",
            "--output", output_file,
            input_file
        ]
        subprocess.run(cmd, check=True, shell=True, capture_output=True, text=True)
        print(f"✅ 反编译成功: {relative_path}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ 反编译失败: {relative_path}, 错误: {e.stderr}")
        return False
    except Exception as e:
        print(f"❌ 处理文件时出错: {relative_path}, 错误: {e}")
        return False

def decompile_lua_files(threads=6):
    """
    反编译所有Lua文件（多线程并行）
    
    Args:
        threads: 并行线程数，默认6
    """
    # 使用相对路径，基于当前工作目录
    unluac_path = os.path.join("bin", "unluac.jar")
    input_dir = os.path.join("bin", "Script")
    output_dir = os.path.join("Script")
    
    # 验证路径存在
    if not os.path.exists(unluac_path):
        print(f"错误：unluac.jar不存在于 {unluac_path}")
        return
    if not os.path.exists(input_dir):
        print(f"错误：输入目录不存在于 {input_dir}")
        return
    
    # 创建输出目录
    os.makedirs(output_dir, exist_ok=True)
    
    # 收集所有需要反编译的文件
    tasks = []
    for root, dirs, files in os.walk(input_dir):
        for file in files:
            if file.endswith(".lua"):
                # 构建输入输出路径
                input_file = os.path.join(root, file)
                # 计算相对路径，保持目录结构
                relative_path = os.path.relpath(root, input_dir)
                output_subdir = os.path.join(output_dir, relative_path)
                output_file = os.path.join(output_subdir, file)
                
                # 创建输出子目录
                os.makedirs(output_subdir, exist_ok=True)
                
                # 保存任务信息
                tasks.append({
                    "unluac_path": unluac_path,
                    "input_file": input_file,
                    "output_file": output_file,
                    "relative_path": os.path.join(relative_path, file)
                })
    
    print(f"共发现 {len(tasks)} 个Lua文件需要反编译")
    print(f"使用 {threads} 个线程并行处理...\n")
    
    # 使用线程池执行反编译任务
    success_count = 0
    with ThreadPoolExecutor(max_workers=threads) as executor:
        # 提交所有任务
        future_to_task = {
            executor.submit(
                decompile_file,
                task["unluac_path"],
                task["input_file"],
                task["output_file"],
                task["relative_path"]
            ): task for task in tasks
        }
        
        # 处理完成的任务
        for future in as_completed(future_to_task):
            if future.result():
                success_count += 1
    
    print(f"\n反编译完成！成功: {success_count}, 失败: {len(tasks) - success_count}")

if __name__ == "__main__":
    decompile_lua_files()
