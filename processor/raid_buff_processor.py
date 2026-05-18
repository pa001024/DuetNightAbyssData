from processor.base_processor import BaseProcessor


class RaidBuffProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "RaidBuff"
        # 加载 GlobalPassiveData 数据，用于解析表达式
        self.global_passive_data = self.data_loader.load_json("GlobalPassiveData.json")

    def _format_param_numeric(self, value):
        """格式化参数数值，避免固定1位小数导致精度丢失"""
        if not isinstance(value, (int, float)):
            return "0"

        rounded = self.round_value(float(value))
        if isinstance(rounded, int):
            return str(rounded)

        return f"{rounded:.4f}".rstrip("0").rstrip(".")

    def _normalize_raid_buff_parameters(self, buff_parameters):
        """兼容 RaidBuffParameter 的列表和 1-based map 形态。"""
        if isinstance(buff_parameters, list):
            return buff_parameters

        if isinstance(buff_parameters, dict):
            if not buff_parameters:
                return []

            normalized_items = []
            max_index = 0
            for key, value in buff_parameters.items():
                try:
                    index = int(key)
                except (TypeError, ValueError):
                    continue
                if index <= 0:
                    continue
                normalized_items.append((index, value))
                max_index = max(max_index, index)

            if not normalized_items:
                return []

            result = [None] * max_index
            for index, value in normalized_items:
                result[index - 1] = value
            return result

        return []

    def process_item(self, raid_buff_data, language):
        """处理单个 RaidBuff 项目"""
        # 获取基本信息
        buff_id = raid_buff_data.get("RaidBuffID", 0)
        buff_des = raid_buff_data.get("RaidBuffDes", "")
        
        # 处理 RaidBuffParameter 中的表达式
        buff_parameters = self._normalize_raid_buff_parameters(
            raid_buff_data.get("RaidBuffParameter", [])
        )
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
                
                formatted_value = f"{self._format_param_numeric(expr_value)}{suffix}"
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
