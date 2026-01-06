from processor.base_processor import BaseProcessor


class AbyssBuffProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "AbyssBuff"
        self.skill_grow_data = self.data_loader.load_json("SkillGrow.json")
        self.buff_data = self.data_loader.load_json("Buff.json")
        self.global_passive_data = self.data_loader.load_json("GlobalPassiveData.json")

    def process_item(self, buff_data, language):
        abyss_buff_id = buff_data.get("AbyssBuffID", 0)
        if abyss_buff_id == 0:
            return {}

        abyss_buff_name_key = buff_data.get("AbyssBuffName", "")
        abyss_buff_des_key = buff_data.get("AbyssBuffDes", "")
        buff_lock_toast_key = buff_data.get("BuffLockToast", "")
        abyss_buff_type = buff_data.get("AbyssBuffType", 0)
        icon = buff_data.get("Icon", "")
        abyss_buff_parameter = buff_data.get("AbyssBuffParameter", [])
        global_passive_id = buff_data.get("GlobalPassiveId", 0)
        global_passive_lv = buff_data.get("GlobalPassiveLv", 1)

        buff_name = self.get_translated_text(abyss_buff_name_key)
        buff_des = self.get_translated_text(abyss_buff_des_key)
        buff_lock_toast = self.get_translated_text(buff_lock_toast_key)

        buff_des_with_params = buff_des
        if abyss_buff_parameter:
            for i, param in enumerate(abyss_buff_parameter):
                param_value = self._calculate_abyss_param(
                    param, global_passive_id, global_passive_lv
                )
                if param_value is not None:
                    placeholder = f"#{i + 1}"
                    buff_des_with_params = buff_des_with_params.replace(
                        placeholder, str(param_value)
                    )

        processed = {
            "id": abyss_buff_id,
            "icon": (
                icon.replace(
                    "/Game/UI/Texture/Dynamic/Atlas/Abyss/T_Abyss_Buff_", ""
                ).split(".")[0]
                if icon
                else ""
            ),
            "n": buff_name,
            "d": self._remove_html_tags(buff_des_with_params),
            "t": abyss_buff_type,
        }

        if buff_lock_toast:
            processed["tip"] = self._remove_html_tags(buff_lock_toast)

        return processed

    def _remove_html_tags(self, text):
        """移除HTML标签"""
        import re

        return re.sub(r"<.*?>", "", text)

    def _calculate_abyss_param(self, param_expr, global_passive_id, global_passive_lv):
        """计算深渊增益参数"""
        import re

        if not isinstance(param_expr, str):
            return param_expr

        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", param_expr)
        if not expr_match:
            return param_expr

        has_neg = expr_match.group(1)
        expr = expr_match.group(2)
        suffix = expr_match.group(3)

        try:
            expr_value = self._calculate_expr_value(
                expr, global_passive_id, global_passive_lv, "AbyssBuff"
            )

            if has_neg:
                expr_value = -expr_value

            formatted_value = self._format_value(expr_value, suffix)
            return formatted_value
        except Exception as e:
            print(f"计算深渊参数失败: {expr}, error: {e}", flush=True)
            return param_expr

    def _format_value(self, value, suffix):
        """格式化数值"""
        if suffix == "%":
            if isinstance(value, float) and value.is_integer():
                return f"{int(value)}%"
            return f"{value:.1f}%"
        else:
            if isinstance(value, float) and value.is_integer():
                return int(value)
            return self.round_value(value)

    def _get_table_data(self, table_name):
        """获取表数据"""
        if table_name == "Buff":
            return self.buff_data
        elif table_name == "GlobalPassiveData":
            return self.global_passive_data
        return super()._get_table_data(table_name)
