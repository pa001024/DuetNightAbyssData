from processor.base_processor import BaseProcessor


class RaidBuffProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RaidBuff"
        # 加载 GlobalPassiveData 数据，用于解析表达式
        self.global_passive_data = self.data_loader.load_json("GlobalPassiveData.json")

    def process_item(self, raid_buff_data, language):
        """处理单个 RaidBuff 项目"""
        # 获取基本信息
        buff_id = raid_buff_data.get("RaidBuffID", 0)
        buff_des = raid_buff_data.get("RaidBuffDes", "")
        
        # 处理 RaidBuffParameter 中的表达式
        buff_parameters = raid_buff_data.get("RaidBuffParameter", [])
        processed_parameters = []
        
        for param in buff_parameters:
            if isinstance(param, str):
                # 解析表达式并计算值
                processed_value = self._parse_parameter_expression(param)
                processed_parameters.append(processed_value)
            else:
                processed_parameters.append(param)
        
        # 获取 RaidBuffDes 的翻译
        translated_des = self.get_translated_text(buff_des, language)
        
        # 替换翻译文本中的占位符
        import re
        for i, param_value in enumerate(processed_parameters):
            placeholder = f"#{i+1}"
            translated_des = translated_des.replace(placeholder, str(param_value))
        
        # 构建处理后的数据
        processed = {
            "RaidBuffID": buff_id,
            "RaidBuffDes": translated_des,
            "RaidBuffParameter": processed_parameters
        }
        
        return processed
    
    def _parse_parameter_expression(self, expression):
        """解析参数表达式，计算实际值"""
        import re
        
        # 匹配 $...$ 格式的表达式
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", expression)
        if expr_match:
            # 提取负号标志、表达式内容和后缀
            has_neg = expr_match.group(1)  # 负号标志，可能为 None
            expr = expr_match.group(2)  # 表达式内容
            suffix = expr_match.group(3)  # 包括 % 在内的所有后缀
            
            # 计算表达式值
            try:
                expr_value = self._calculate_expr_value(expr, None, 1, "GlobalPassiveData")
                
                # 根据是否有负号处理值
                if has_neg:
                    expr_value = -expr_value
                
                # 格式化结果，根据值的大小自动调整小数位数
                if expr_value == int(expr_value):
                    # 如果值是整数，显示为整数形式
                    formatted_value = f"{int(expr_value)}{suffix}"
                else:
                    # 如果值是小数，显示为一位小数形式
                    formatted_value = f"{expr_value:.1f}{suffix}"
                return formatted_value
            except Exception as e:
                print(f"计算表达式 '{expr}' 失败: {e}")
                return expression
        
        return expression
    
    def process_all_items(self, items, language):
        """处理所有项目，添加过滤和排序"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)
        
        # 按 RaidBuffID 排序
        processed_items.sort(key=lambda x: x.get("RaidBuffID", 0))
        
        return processed_items