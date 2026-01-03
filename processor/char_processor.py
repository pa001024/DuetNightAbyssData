from processor.base_processor import BaseProcessor
from ast_parser import NodeType


class CharProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Char"
        # 加载必要的配置数据
        self.attr_config = data_loader.load_json("AttrConfig.json")
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.skill_grow_data = data_loader.load_json("SkillGrow.json")
        self.battle_char_data = data_loader.load_json("BattleChar.json")
        self.level_up_data = data_loader.load_json("LevelUp.json")
        self.char_break_data = data_loader.load_json("CharBreak.json")
        self.skill_data = data_loader.load_json("Skill.json")
        self.combat_term_data = data_loader.load_json("CombatTerm.json")
        self.character_data_target = data_loader.load_json("CharacterDataTarget.json")
        self.attribute_data = data_loader.load_json("Attribute.json")
        self.battle_weapon_data = data_loader.load_json("BattleWeapon.json")
        self.u_weapon_data = data_loader.load_json("UWeapon.json")

        # 加载技能相关的数据表
        self.skill_node_data = data_loader.load_json("SkillNode.json")
        self.skill_effects_data = data_loader.load_json("SkillEffects.json")
        self.buff_data = data_loader.load_json("Buff.json")
        self.target_filter_data = data_loader.load_json("TargetFilter.json")
        self.skill_creature_data = data_loader.load_json("SkillCreature.json")
        self.passive_effect_data = data_loader.load_json("PassiveEffect.json")
        self.ray_creature_data = data_loader.load_json("RayCreature.json")
        self.camp_data = data_loader.load_json("CharCamp.json")
        self.weapon_tag_data = data_loader.load_json("WeaponTag.json")
        self.char_addon_attr_data = data_loader.load_json("CharAddonAttr.json")

        # 等级列表，用于显示属性
        self.levels = [1]

        # SkillDescHints 映射表
        self.skill_desc_hints_map = {
            "SkillEfficiency": "效益",
            "SkillIntensity": "威力",
            "SkillRange": "范围",
            "SkillSustain": "持续",
        }

    def process_item(self, char_data, language):
        char_id = char_data.get("CharId", 0)
        if char_id > 100000:
            return {}
        # 获取BattleChar数据
        battle_char = self.battle_char_data.get(str(char_id), {})
        if not battle_char:
            battle_char = self.battle_char_data.get(char_id, {})

        base_attr = self._process_attributes(battle_char, char_id)
        name = self.get_translated_text(char_data.get("CharName", ""))
        elm = self._process_element(char_id)
        if name == "{nickname}":
            name = f"主角({elm})"
        # 构建基础处理后的Char数据
        processed = {
            "id": char_id,
            "名称": name,
            "版本": self._process_release(char_data.get("ReleaseVersion", 100)),
            "别名": self.get_translated_text(char_data.get("CharSubtitle", "")),
            "阵营": self._process_camp(char_data.get("Camp", "None")),
            "属性": elm,
            "精通": self._process_mastery(battle_char.get("ExcelWeaponTags", [])),
            "基础攻击": base_attr.get("攻击", 0),
            "基础生命": base_attr.get("生命", 0),
            "基础防御": base_attr.get("防御", 0),
            "基础护盾": base_attr.get("护盾", 0),
            "加成": self._process_addon(battle_char.get("CharAddonAttr", [])),
            "突破": self._process_break(char_id, language),
            "技能": self._process_skills(battle_char, language),
            "溯源": self._process_traces(battle_char, char_id),
            # "档案": self._process_character_data(char_id),
            "同律武器": self._process_u_weapon(char_data.get("UWeapon", [])),
        }
        if not processed.get("同律武器"):
            del processed["同律武器"]

        return processed

    def _process_u_weapon(self, u_weapon):
        """处理角色同律武器数据"""
        if not u_weapon:
            return None
        rst = []
        for weapon_id in u_weapon:
            weapon = self.u_weapon_data.get(str(weapon_id), {})
            battle_weapon = self.battle_weapon_data.get(str(weapon_id), {})
            if not weapon:
                continue
            tags = battle_weapon.get("WeaponTag", [])
            if "Abstract" in tags:
                continue
            item = {
                "名称": self.get_translated_text(weapon.get("WeaponName", "")),
                "类型": self.process_tags(tags),
            }
            for attr_name in ["Spike", "Smash", "Slash"]:
                attr_key = f"ATK_{attr_name}"
                if attr_key in battle_weapon:
                    attr_config = self.attr_config.get(attr_key, {})
                    atk_type = self.get_translated_text(
                        attr_config.get("Name", ""), "cn"
                    )
                    item["伤害类型"] = atk_type[:2]
                    item[atk_type[2:]] = battle_weapon[attr_key]
            if battle_weapon.get("CRI", 0) > 0:
                item["暴击"] = battle_weapon.get("CRI", 0)
            if battle_weapon.get("CRD", 0) > 0:
                item["暴伤"] = battle_weapon.get("CRD", 0)
            if battle_weapon.get("TriggerProbability", 0) > 0:
                item["触发"] = battle_weapon.get("TriggerProbability", 0)
            rst.append(item)
        return rst

    def _process_addon(self, addon_attr):
        """处理角色加成数据"""
        if not addon_attr:
            return {}
        rst = {}
        for attr in [
            self.char_addon_attr_data.get(str(attr_id), {}).get("AddAttrs", {})
            for attr_id in addon_attr
        ]:
            if not attr:
                continue
            attr_name = attr.get("AttrName", "")
            attr_config = self.attr_config.get(attr_name, {})
            attr_name_key = attr_config.get("Name", "")
            if rst.get(self.get_translated_text(attr_name_key)):
                rst[self.get_translated_text(attr_name_key)] += self.round_value(
                    attr.get("Rate") or attr.get("Value", 0)
                )
                continue
            rst[self.get_translated_text(attr_name_key)] = self.round_value(
                attr.get("Rate") or attr.get("Value", 0)
            )
        return rst

    def _process_mastery(self, weapon_tags):
        """处理角色精通数据"""
        if not weapon_tags:
            return ""

        def get_mastery_name(tag):
            return self.get_translated_text(
                self.weapon_tag_data.get(tag, {}).get("WeaponTagTextmap", "")
            )

        # 取4位id的第2位
        return [get_mastery_name(mastery_id) for mastery_id in weapon_tags]

    def _process_camp(self, camp):
        """处理角色阵营数据"""
        if not camp:
            return ""
        camp_name = self.camp_data.get(camp, {}).get("CampName", "")
        return self.get_translated_text(camp_name)

    def _process_element(self, char_id):
        """处理角色元素数据"""
        if not char_id:
            return ""
        # 取4位id的第1位
        elm_id = char_id // 1000
        colormap = {
            2: "水",
            3: "火",
            4: "雷",
            5: "风",
        }
        return colormap.get(elm_id, "暗" if char_id < 1500 else "光")

    def _process_release(self, release_version):
        """处理角色版本数据 100->1.3"""
        if not release_version:
            return ""
        return (
            f"{release_version // 100}.{release_version % 100//10}"
            if release_version
            else "1.0"
        )

    def _process_attributes(self, battle_char, char_id):
        """处理角色属性，计算各个等级的属性值"""
        if not battle_char:
            return {}

        attributes = {}

        # 获取基础ATK
        base_atk = battle_char.get("ATK", 0)
        atk_level_grow = battle_char.get("ATKLevelGrow", "")

        # 获取属性类型
        attribute = battle_char.get("Attribute", "")

        # 计算所有属性加成（ATK_Dark, ATK_Fire等）
        if attribute:
            attr_key = f"ATK_{attribute}"
            if attr_key in battle_char:
                base_atk += battle_char[attr_key]

        # 为每个等级计算属性值
        for level in self.levels:
            # 获取对应的LevelUp数据
            level_data = None
            for item in self.level_up_data:
                if item.get("Level") == level:
                    level_data = item
                    break

            if not level_data:
                continue

            level_attrs = {}

            # 计算ATK
            if base_atk and atk_level_grow:
                grow_factor = level_data.get(atk_level_grow, 1.0)
                if isinstance(grow_factor, str):
                    try:
                        grow_factor = float(grow_factor)
                    except:
                        grow_factor = 1.0
                final_atk = int(base_atk * grow_factor)
                level_attrs["攻击"] = final_atk

            # 计算其他属性：MaxHp, DEF, MaxES
            attr_names = ["MaxHp", "DEF", "MaxES"]
            for attr_name in attr_names:
                base_value = battle_char.get(attr_name, 0)
                value_level_grow = battle_char.get(f"{attr_name}LevelGrow", "")

                if base_value and value_level_grow:
                    grow_factor = level_data.get(value_level_grow, 1.0)
                    if isinstance(grow_factor, str):
                        try:
                            grow_factor = float(grow_factor)
                        except:
                            grow_factor = 1.0
                    value = base_value * grow_factor

                    # 获取属性中文名
                    attr_config = self.attr_config.get(attr_name, {})
                    attr_name_key = attr_config.get("Name", "")
                    attr_chinese_name = self.get_translated_text(attr_name_key, "cn")

                    level_attrs[attr_chinese_name] = int(value)

            if level_attrs:
                attributes[f"Lv.{level}"] = level_attrs

        return attributes["Lv.1"]

    def _process_break(self, char_id, language):
        """处理角色突破数据"""
        break_list = self.char_break_data.get(str(char_id), [])
        if not break_list:
            break_list = self.char_break_data.get(char_id, [])

        if not break_list:
            return []

        break_info = []

        for break_stage in break_list:
            stage_num = break_stage.get("CharBreakNum", 0)
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

    def _process_skills(self, battle_char, language):
        """处理角色技能数据"""
        if not battle_char:
            return []

        skill_list = battle_char.get("SkillList", [])
        if not skill_list:
            return []

        skills = []

        for skill_id in skill_list:
            skill_info = self._process_single_skill(skill_id, language)
            if skill_info:
                skills.append(skill_info)

        return skills

    def _process_single_skill(self, skill_id, language):
        """处理单个技能"""
        # 获取Skill数据
        skill = self.skill_data.get(str(skill_id), {})
        if not skill:
            skill = self.skill_data.get(skill_id, {})

        if not skill:
            return {}

        # 获取技能基本信息
        if not isinstance(skill, list) or len(skill) == 0 or len(skill[0]) == 0:
            return {}

        skill_info = skill[0][0]

        # 获取技能名称和描述
        skill_name_key = skill_info.get("SkillName", "")
        skill_desc_key = skill_info.get("SkillDesc", "")

        skill_name = self.get_translated_text(skill_name_key)
        skill_desc = self.get_translated_text(skill_desc_key)

        # 获取技能最大等级
        max_level = min(
            self._get_skill_max_level(skill_id),
            12,
        )

        result = {
            "id": skill_id,
            "名称": skill_name,
            "类型": self.get_translated_text(skill_info.get("SkillBtnDesc", "")),
            "描述": skill_desc,
        }

        # 使用新的紧凑格式处理技能等级描述
        level_desc = self.process_skill_desc(skill_info, skill_id, max_level)
        if level_desc:
            result["字段"] = level_desc

        # 处理战斗术语解释
        explanation_ids = skill_info.get("ExplanationId", [])
        if explanation_ids:
            explanations = []
            for term_id in explanation_ids:
                term_data = self.combat_term_data.get(str(term_id), {})
                if term_data:
                    term_key = term_data.get("CombatTerm", "")
                    term_explain_key = term_data.get("CombatTermExplaination", "")

                    term_name = self.get_translated_text(term_key)
                    term_desc = self.get_translated_text(term_explain_key)

                    explanations.append(
                        {
                            "术语": term_name,
                            "解释": term_desc,
                        }
                    )
            if explanations:
                result["术语解释"] = explanations

        return result

    def _get_skill_max_level(self, skill_id):
        """获取技能最大等级"""
        skill = self.skill_data.get(str(skill_id), {})
        if not skill:
            skill = self.skill_data.get(skill_id, {})

        if not skill or not isinstance(skill, list):
            return 1

        # skill 是一个列表，长度就是最大等级
        return len(skill)

    def _extract_format_from_expr(self, desc_value):
        """从表达式中提取格式信息

        注意：desc_value 应该已经经过预处理，$GText("...")$ 已被替换为翻译文本
        例如从 $...$*100$%攻击+$...$ 中提取 "{%}%攻击+{}"

        规则：
        - 如果 $...$ 内部包含 *100，用 {%} 占位符（百分比）
        - 否则用 {} 占位符（普通数值）
        - $...$ 外部的 % 直接保留为 % 字符
        """
        import re

        if not isinstance(desc_value, str):
            return None

        # 只有没有额外文本的单一表达式才返回 None
        # 如：$...$ 或 $...$% (其中 % 是后缀)
        single_expr = re.match(r"^\$([^$]+)\$%?$", desc_value)
        if single_expr:
            return None

        result = desc_value
        placeholder_count = 0

        # 处理所有 $...$ 表达式
        def replace_expr(match):
            nonlocal placeholder_count
            expr = match.group(1)
            placeholder_count += 1

            # 检查表达式内部是否包含 *100
            if "*100" in expr:
                return "{%}"  # 百分比占位符
            else:
                return "{}"  # 普通数值占位符

        # 替换所有 $...$ 为占位符
        result = re.sub(r"\$([^$]+)\$", replace_expr, result)

        # 如果没有占位符或只有一个占位符且没有其他文本，返回 None
        if placeholder_count == 0:
            return None
        if placeholder_count == 1 and result in ("{}", "{%}"):
            return None

        return result

    def _is_value_percentage(self, desc_value):
        """检查数值是否为百分比格式"""
        if not isinstance(desc_value, str):
            return False
        # 检查是否包含 "*100"
        if "*100" in desc_value:
            return True
        return False

    def process_skill_desc(self, skill_info, skill_id, max_level):
        """处理技能等级描述为紧凑格式"""
        desc_keys = skill_info.get("SkillDescKeys", [])
        desc_values = skill_info.get("SkillDescValues", [])
        desc_hints = skill_info.get("SkillDescHints", [])

        if not desc_keys or not desc_values:
            return {}

        result = {}

        for i, desc_key in enumerate(desc_keys):
            if i >= len(desc_values):
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)

            # 获取影响类型 (从 SkillDescHints)
            impact_type = None
            # desc_hints 可能是列表或字典
            if desc_hints:
                hint_items = None
                if isinstance(desc_hints, list) and i < len(desc_hints):
                    # 列表格式: [["SkillEfficiency"], ["SkillIntensity"], ...]
                    hint_items = desc_hints[i]
                elif isinstance(desc_hints, dict) and str(i + 1) in desc_hints:
                    # 字典格式: {"1": ["SkillEfficiency"], "2": ["SkillEfficiency", "SkillSustain"], ...}
                    # 注意：字典的键是从1开始的字符串
                    hint_items = desc_hints[str(i + 1)]

                if hint_items and isinstance(hint_items, list) and len(hint_items) > 0:
                    # 将所有的 hint key 转换为中文并连接
                    impact_parts = []
                    for hint_key in hint_items:
                        mapped = self.skill_desc_hints_map.get(hint_key, hint_key)
                        impact_parts.append(mapped)
                    impact_type = ",".join(impact_parts)

            # 预处理表达式，将 $GText("...")$ 替换为翻译后的文本
            preprocessed_desc_value = self.preprocess_expression(desc_values[i])

            # 检查是否有格式
            format_template = self._extract_format_from_expr(preprocessed_desc_value)

            # 分割表达式部分（处理复合表达式）
            import re

            # 提取所有 $...$ 表达式，排除GText等特殊格式
            # 只保留包含#的表达式（这些是数值计算表达式）
            all_matches = re.findall(r"\$([^$]+)\$", preprocessed_desc_value)
            expr_matches = [m for m in all_matches if "#" in m]
            if not expr_matches:
                continue

            # 复合表达式，需要计算多个值
            item = {}

            if impact_type:
                item["影响"] = impact_type

            # 计算第一个值
            first_expr = expr_matches[0]
            # 移除可能存在的%后缀
            if first_expr.endswith("%"):
                first_expr = first_expr[:-1]
            is_first_percentage = self._is_value_percentage("$" + first_expr + "$")
            values1 = []
            for level in range(1, max_level + 1):
                raw_value = self._calc_skill_desc_value_raw(
                    "$" + first_expr + "$", skill_id, level
                )
                values1.append(raw_value)

            is_constant1 = all(abs(v - values1[0]) < 0.0001 for v in values1)
            if is_constant1:
                final_value = values1[0]
                if is_first_percentage:
                    # 对于百分比，保持原始值（已经乘以100了）
                    # 但要转换为小数形式（如17 -> 0.17）
                    final_value = final_value / 100.0
                item["值"] = self.round_value(final_value)
            else:
                final_values = []
                for v in values1:
                    if is_first_percentage:
                        v = v / 100.0
                    final_values.append(self.round_value(v))
                item["值"] = final_values

            # 计算第二个值（如果存在）
            if len(expr_matches) > 1:
                second_expr = expr_matches[1]
                # 移除可能存在的%后缀
                if second_expr.endswith("%"):
                    second_expr = second_expr[:-1]
                is_second_percentage = self._is_value_percentage(
                    "$" + second_expr + "$"
                )
                values2 = []
                for level in range(1, max_level + 1):
                    raw_value = self._calc_skill_desc_value_raw(
                        "$" + second_expr + "$", skill_id, level
                    )
                    values2.append(raw_value)

                is_constant2 = all(abs(v - values2[0]) < 0.0001 for v in values2)
                if is_constant2:
                    final_value = values2[0]
                    if is_second_percentage:
                        final_value = final_value / 100.0
                    item["值2"] = self.round_value(final_value)
                else:
                    final_values = []
                    for v in values2:
                        if is_second_percentage:
                            v = v / 100.0
                        final_values.append(self.round_value(v))
                    item["值2"] = final_values

            if format_template:
                item["格式"] = format_template

            result[desc_text] = item

        return result

    def _calc_skill_desc_value_raw(self, desc_value, skill_id, level):
        """计算技能描述数值（原始数值，不格式化）"""
        import re

        # 处理简单的数值表达式
        if isinstance(desc_value, (int, float)):
            return float(desc_value)

        if isinstance(desc_value, str):
            # 处理$...$格式的表达式
            expr_match = re.search(r"\$(-)?(.*?)\$(.*)", desc_value)
            if expr_match:
                has_neg = expr_match.group(1)
                expr = expr_match.group(2)
                suffix = expr_match.group(3)

                try:
                    # 使用_calculate_expr_value计算表达式
                    expr_value = self._calculate_expr_value(
                        expr, skill_id, level, "Skill"
                    )

                    if has_neg:
                        expr_value = -expr_value

                    # 检查 suffix 是否包含 *100
                    # 注意：这里不乘以100，因为原始值已经是正确的了
                    # *100% 只是显示格式，我们会在 _is_value_percentage 中处理

                    result = float(expr_value)
                    return result
                except Exception as e:
                    print(f"计算表达式失败: {expr}, error: {e}")
                    return 0.0

        return 0.0

    def _process_skill_level_desc(self, skill_info, skill_id, level, language):
        """处理技能等级描述"""
        desc_keys = skill_info.get("SkillDescKeys", [])
        desc_values = skill_info.get("SkillDescValues", [])

        if not desc_keys or not desc_values:
            return {}

        result = {}

        for i, desc_key in enumerate(desc_keys):
            if i >= len(desc_values):
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)

            # 计算数值
            value = self._calc_skill_desc_value(desc_values[i], skill_id, level)

            result[desc_text] = value

        return result

    def _calc_skill_desc_value(self, desc_value, skill_id, level):
        """计算技能描述数值，支持复杂表达式"""
        import re

        # 处理简单的数值表达式
        if isinstance(desc_value, (int, float)):
            return desc_value

        if isinstance(desc_value, str):
            # 处理$...$格式的表达式
            expr_match = re.search(r"\$(-)?(.*?)\$(.*)", desc_value)
            if expr_match:
                has_neg = expr_match.group(1)
                expr = expr_match.group(2)
                suffix = expr_match.group(3)

                try:
                    # 使用_calculate_expr_value计算表达式
                    expr_value = self._calculate_expr_value(
                        expr, skill_id, level, "Skill"
                    )

                    if has_neg:
                        expr_value = -expr_value

                    formatted_value = self.round_value(expr_value)

                    # 格式化结果
                    if suffix == "%":
                        return f"{formatted_value}%"
                    return formatted_value
                except Exception as e:
                    print(f"计算表达式失败: {expr}, error: {e}")
                    return desc_value

        return str(desc_value)

    def _get_table_data(self, table_name):
        """根据表名获取对应的数据表"""
        if table_name == "Skill":
            if hasattr(self, "_skill_table_cache"):
                return self._skill_table_cache
            skill_table = {}
            skill_data = self.skill_data
            for skill_id, skill_list in skill_data.items():
                if isinstance(skill_list, list) and len(skill_list) > 0:
                    skill_table[skill_id] = skill_list
            self._skill_table_cache = skill_table
            return skill_table

        if table_name == "RayCreature":
            return self.ray_creature_data

        table_map = {
            "SkillNode": self.skill_node_data,
            "SkillEffects": self.skill_effects_data,
            "Buff": self.buff_data,
            "TargetFilter": self.target_filter_data,
            "SkillCreature": self.skill_creature_data,
            "SkillGrow": self.skill_grow_data,
            "PassiveEffect": self.passive_effect_data,
        }
        return table_map.get(table_name)

    def _process_traces(self, battle_char, char_id):
        """处理角色溯源数据"""
        if not battle_char:
            return {}

        char_grade_description = battle_char.get("CharGradeDescription")
        if not char_grade_description:
            char_grade_description = [
                f"GRADEUP_{char_id}_01",
                f"GRADEUP_{char_id}_02",
                f"GRADEUP_{char_id}_03",
                f"GRADEUP_{char_id}_04",
                f"GRADEUP_{char_id}_05",
                f"GRADEUP_{char_id}_06",
            ]
        char_grade_parameter = battle_char.get("CharGradeParameter", [])

        traces = []

        for i, grade_desc_key in enumerate(char_grade_description):
            grade_desc = self.get_translated_text(grade_desc_key)
            if grade_desc == f"GRADEUP_{char_id}_01":
                return {}
            # 替换参数占位符 - 每个溯源描述可能有多个参数
            # 按照顺序替换 #1, #2, #3... 等占位符
            for param_idx, parameter in enumerate(char_grade_parameter):
                placeholder = f"#{param_idx + 1}"

                # 计算参数值
                if isinstance(parameter, (int, float)):
                    param_value = parameter
                elif isinstance(parameter, str):
                    # 处理 $...$ 格式的表达式
                    import re

                    expr_match = re.search(r"\$(-)?(.*?)\$(.*)", parameter)
                    if expr_match:
                        has_neg = expr_match.group(1)
                        expr = expr_match.group(2)
                        suffix = expr_match.group(3)

                        try:
                            # 使用 _calculate_expr_value 计算表达式
                            expr_value = self._calculate_expr_value(
                                expr, char_id, 1, "BattleChar"
                            )

                            if has_neg:
                                expr_value = -expr_value

                            # 格式化结果 - 整数不显示小数点
                            if suffix == "%":
                                if expr_value == int(expr_value):
                                    param_value = f"{int(expr_value)}%"
                                else:
                                    param_value = f"{expr_value}%"
                            elif suffix == "*100%":
                                if expr_value == int(expr_value):
                                    param_value = f"{int(expr_value)}%"
                                else:
                                    param_value = f"{expr_value}%"
                            elif suffix == "*100":
                                if expr_value == int(expr_value):
                                    param_value = f"{int(expr_value)}"
                                else:
                                    param_value = f"{expr_value}"
                            else:
                                if expr_value == int(expr_value):
                                    param_value = str(int(expr_value))
                                else:
                                    param_value = str(expr_value)
                        except Exception as e:
                            print(f"计算溯源表达式失败: {expr}, error: {e}")
                            param_value = parameter
                    else:
                        param_value = parameter
                else:
                    param_value = str(parameter)

                grade_desc = grade_desc.replace(placeholder, str(param_value))

            traces.append(grade_desc)

        return traces

    def _process_character_data(self, char_id):
        """处理角色档案数据"""
        char_data_dict = self.character_data_target.get(str(char_id), {})
        if not char_data_dict:
            char_data_dict = self.character_data_target.get(char_id, {})

        if not char_data_dict:
            return {}

        character_data = {}

        # character_data_dict is a dict with keys like "1001", "1002", etc.
        for target_key, data in char_data_dict.items():
            target_id = data.get("CharDataTarget", 0)
            char_data_names = data.get("CharDataName", [])
            char_text_key = data.get("CharText", "")

            # 拼接名称
            name = ""
            for name_key in char_data_names:
                name += self.get_translated_text(name_key)

            # 获取文本
            text = self.get_translated_text(char_text_key)

            character_data[f"档案{target_id}"] = {
                "名称": name,
                "内容": text,
            }

        return character_data
