import json
import os
from processor.quest_chain_processor import QuestChainProcessor
from data_loader import DataLoader


def process_quest_chain():
    """处理 QuestChain.json 文件"""
    # 创建 DataLoader 实例
    data_loader = DataLoader()
    
    # 创建 QuestChainProcessor 实例
    processor = QuestChainProcessor(data_loader)
    
    # 加载 QuestChain.json 文件
    quest_chain_file = "out/QuestChain.json"
    if not os.path.exists(quest_chain_file):
        print(f"文件不存在: {quest_chain_file}")
        return
    
    # 读取文件数据
    with open(quest_chain_file, "r", encoding="utf-8") as f:
        quest_chain_data = json.load(f)
    
    # 转换为列表格式
    quest_chain_list = list(quest_chain_data.values())
    
    # 处理所有任务链数据（中文）
    processed_quest_chains_cn = processor.process_all_items(quest_chain_list, "cn")
    
    # 保存处理后的中文数据
    output_dir = "processed"
    os.makedirs(output_dir, exist_ok=True)
    output_file_cn = os.path.join(output_dir, "QuestChain_cn.json")
    processor.save_processed_items(processed_quest_chains_cn, output_dir, "QuestChain_cn.json")
    print(f"中文任务链数据已保存到: {output_file_cn}")
    
    # 处理所有任务链数据（英文）