from processor.base_processor import BaseProcessor
from ast_parser import parse_ast, NodeType


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
                rst[self.get_translated_text(attr_name_key)] += self._round_value(
                    attr.get("Rate") or attr.get("Value", 0)
                )
                continue
            rst[self.get_translated_text(attr_name_key)] = self._round_value(
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
        level_desc = self._process_skill_desc_compact(
            skill_info, skill_id, max_level, language
        )
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

    def _split_compound_expression(self, desc_value):
        """拆分复合表达式，返回表达式列表

        注意：desc_value 应该已经经过预处理，$GText("...")$ 已被替换为翻译文本
        所以这里只需要查找 $...$ 表达式即可
        """
        import re

        if not isinstance(desc_value, str):
            return [desc_value]

        # 使用正则表达式查找所有 $...$ 表达式
        expr_pattern = r"\$[^$]+\$"
        matches = re.findall(expr_pattern, desc_value)

        # 如果没有找到多个表达式，返回原始表达式
        if len(matches) <= 1:
            return [desc_value]

        return matches

    def _is_value_percentage(self, desc_value):
        """检查数值是否为百分比格式"""
        if not isinstance(desc_value, str):
            return False
        # 检查是否包含 "*100%" 或 "*100"
        if "*100%" in desc_value or "*100" in desc_value:
            return True
        return False

    def _round_value(self, value):
        """四舍五入到最多3位小数，等效于JS的 +num.toFixed(3)"""
        # 先四舍五入到3位小数
        rounded = round(value * 10000) / 10000
        # 如果结果是整数（如 3.0），返回整数
        if abs(rounded - round(rounded)) < 0.00001:
            return int(round(rounded))
        # 否则返回浮点数（自动去除末尾的0）
        return rounded

    def _preprocess_expression(self, desc_value):
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

    def _process_skill_desc_compact(self, skill_info, skill_id, max_level, language):
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
            preprocessed_desc_value = self._preprocess_expression(desc_values[i])

            # 检查是否有格式
            format_template = self._extract_format_from_expr(preprocessed_desc_value)

            # 检查是否为复合表达式（有多个 $...$ 部分）
            expr_parts = self._split_compound_expression(preprocessed_desc_value)

            if len(expr_parts) > 1:
                # 复合表达式，需要计算多个值
                item = {}

                if impact_type:
                    item["影响"] = impact_type

                # 计算第一个值
                is_first_percentage = self._is_value_percentage(expr_parts[0])
                values1 = []
                for level in range(1, max_level + 1):
                    raw_value = self._calc_skill_desc_value_raw(
                        expr_parts[0], skill_id, level
                    )
                    values1.append(raw_value)

                is_constant1 = all(abs(v - values1[0]) < 0.0001 for v in values1)
                if is_constant1:
                    final_value = values1[0]
                    if is_first_percentage:
                        final_value = final_value / 100.0
                    item["值"] = self._round_value(final_value)
                else:
                    final_values = []
                    for v in values1:
                        if is_first_percentage:
                            v = v / 100.0
                        final_values.append(self._round_value(v))
                    item["值"] = final_values

                # 计算第二个值（如果存在）
                if len(expr_parts) > 1:
                    is_second_percentage = self._is_value_percentage(expr_parts[1])
                    values2 = []
                    for level in range(1, max_level + 1):
                        raw_value = self._calc_skill_desc_value_raw(
                            expr_parts[1], skill_id, level
                        )
                        values2.append(raw_value)

                    is_constant2 = all(abs(v - values2[0]) < 0.0001 for v in values2)
                    if is_constant2:
                        final_value = values2[0]
                        if is_second_percentage:
                            final_value = final_value / 100.0
                        item["值2"] = self._round_value(final_value)
                    else:
                        final_values = []
                        for v in values2:
                            if is_second_percentage:
                                v = v / 100.0
                            final_values.append(self._round_value(v))
                        item["值2"] = final_values

                if format_template:
                    item["格式"] = format_template

                result[desc_text] = item
            else:
                # 单个表达式，使用原有逻辑
                # 检查是否为百分比
                is_percentage = self._is_value_percentage(preprocessed_desc_value)

                # 收集所有等级的数值
                values = []
                for level in range(1, max_level + 1):
                    # 计算数值
                    raw_value = self._calc_skill_desc_value_raw(
                        preprocessed_desc_value, skill_id, level
                    )
                    values.append(raw_value)

                # 判断数值是否随等级变化
                is_constant = all(abs(v - values[0]) < 0.0001 for v in values)

                # 构建结果
                item = {}

                if impact_type:
                    item["影响"] = impact_type

                if is_constant:
                    # 所有等级相同，使用单个数值
                    # 如果是百分比，需要除以100
                    final_value = values[0]
                    if is_percentage:
                        final_value = final_value / 100.0
                    item["值"] = self._round_value(final_value)
                else:
                    # 数值随等级变化，使用数组
                    # 如果是百分比，需要除以100
                    final_values = []
                    for v in values:
                        if is_percentage:
                            v = v / 100.0
                        final_values.append(self._round_value(v))
                    item["值"] = final_values

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

                    return float(expr_value)
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

                    formatted_value = self._round_value(expr_value)

                    # 格式化结果
                    if suffix == "%":
                        return f"{formatted_value}%"
                    return formatted_value
                except Exception as e:
                    print(f"计算表达式失败: {expr}, error: {e}")
                    return desc_value

        return str(desc_value)

    def _calculate_expr_value(self, expr, skill_id, skill_level, table_type):
        """计算表达式值，使用AST解析和上下文跟踪"""
        try:
            # 解析表达式为AST
            ast = parse_ast(expr)

            # 递归计算AST节点的值，使用上下文
            context = {"table_type": table_type, "table_id": skill_id}
            result = self._evaluate_ast_node_with_context(
                ast, skill_id, skill_level, context
            )

            # 确保返回数值类型
            if isinstance(result, (int, float)):
                return float(result)
            else:
                return 0.0
        except Exception as e:
            print(f"计算表达式 '{expr}' 失败: {e}")
            return 0.0

    def _evaluate_ast_node_with_context(
        self, node, skill_id=None, skill_level=1, context=None
    ):
        """使用上下文信息评估AST节点

        Args:
            node: AST节点
            skill_id: 当前技能的ID
            skill_level: 当前技能的等级
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
            # 标识符，可能在上下文中查找
            value = node.value
            # 如果标识符包含#，去掉#号
            if value.startswith("#"):
                value = value[1:]
            # 查找表数据
            table_data = self._get_table_data(value)
            if table_data:
                return table_data
            return value

        elif node.type == NodeType.UNARY_EXPR:
            # 一元表达式
            operand_value = self._evaluate_ast_node_with_context(
                node.operand, skill_id, skill_level, context
            )

            # 如果操作数是字符串且以#开头，使用SkillGrow查找
            if isinstance(operand_value, str) and operand_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                table_id = context.get("table_id", skill_id)

                attr = {
                    "Type": table_type,
                    "Value": operand_value,
                }

                operand_value = self._calc_char_attr_by_level(
                    attr, table_id, skill_level
                )

            # 应用一元运算符
            if node.value == "-":
                return -operand_value
            else:
                return operand_value

        elif node.type == NodeType.BINARY_EXPR:
            # 二元表达式
            # 评估左侧表达式（保留上下文）
            left_value = self._evaluate_ast_node_with_context(
                node.left, skill_id, skill_level, context
            )
            # 评估右侧表达式（同样使用相同上下文）
            right_value = self._evaluate_ast_node_with_context(
                node.right, skill_id, skill_level, context
            )

            # 如果左侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(left_value, str) and left_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                table_id = context.get("table_id", skill_id)

                attr = {
                    "Type": table_type,
                    "Value": left_value,
                }

                left_value = self._calc_char_attr_by_level(attr, table_id, skill_level)

            # 如果右侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(right_value, str) and right_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                table_id = context.get("table_id", skill_id)

                attr = {
                    "Type": table_type,
                    "Value": right_value,
                }

                right_value = self._calc_char_attr_by_level(attr, table_id, skill_level)

            # 特殊处理: (-#Table[id].prop) 应该是 -(Table[id].prop)
            # 当左侧是0，操作符是减号，且右侧是BINARY_EXPR(#Buff)时
            if (
                isinstance(left_value, (int, float))
                and left_value == 0
                and node.value == "-"
                and node.right.type == NodeType.BINARY_EXPR
            ):

                right_binary = node.right
                right_right = right_binary.right

                if (
                    right_binary.left.type == NodeType.LITERAL
                    and right_binary.left.value == 0
                    and right_right.type == NodeType.IDENTIFIER
                    and isinstance(right_right.value, str)
                    and right_right.value.startswith("#")
                ):

                    table_name = right_right.value.lstrip("#")
                    table_data = self._get_table_data(table_name)

                    if table_data:
                        # 获取索引值
                        if isinstance(right_binary.index, NodeType):
                            index_val = self._evaluate_ast_node_with_context(
                                right_binary.index, skill_id, skill_level, context
                            )
                        else:
                            index_val = right_binary.index

                        if isinstance(index_val, (int, float)):
                            item_id = str(int(index_val))
                        else:
                            item_id = str(index_val)

                        if item_id in table_data:
                            item_data = table_data[item_id]

                            # 现在处理剩余的成员访问
                            # 构建一个虚拟的节点来处理后续访问
                            remaining = node.right
                            while remaining.type == NodeType.INDEX_ACCESS:
                                index_node = remaining.index
                                if isinstance(index_node, NodeType):
                                    idx = self._evaluate_ast_node_with_context(
                                        index_node, skill_id, skill_level, context
                                    )
                                else:
                                    idx = index_node

                                if isinstance(idx, (int, float)):
                                    item_id = str(int(idx))
                                else:
                                    item_id = str(idx)

                                if item_id in item_data:
                                    item_data = item_data[item_id]
                                else:
                                    break

                                remaining = remaining.object

                            if remaining.type == NodeType.MEMBER_ACCESS:
                                result = self._evaluate_ast_node_with_context(
                                    remaining, skill_id, skill_level, context
                                )
                                if isinstance(result, (int, float)):
                                    return -result
                                return result
                            elif isinstance(item_data, (int, float)):
                                return -item_data

            op = node.value
            if op == "+":
                return left_value + right_value
            elif op == "-":
                return left_value - right_value
            elif op == "*":
                return left_value * right_value
            elif op == "/":
                if right_value != 0:
                    return left_value / right_value
                else:
                    return 0.0
            elif op == "%":
                return left_value % right_value
            else:
                raise ValueError(f"未知的运算符: {op}")

        elif node.type == NodeType.INDEX_ACCESS:
            # 索引访问: object[index]
            object_value = self._evaluate_ast_node_with_context(
                node.object, skill_id, skill_level, context
            )
            index_value = self._evaluate_ast_node_with_context(
                node.index, skill_id, skill_level, context
            )

            # 如果object是BINARY_EXPR，需要特殊处理
            # 例如: (-#Buff[530141]) 应该是 -(Buff[530141])
            if node.object.type == NodeType.BINARY_EXPR:
                left_node = node.object.left
                right_node = node.object.right
                op = node.object.value

                if (
                    left_node.type == NodeType.LITERAL
                    and left_node.value == 0
                    and op == "-"
                    and right_node.type == NodeType.IDENTIFIER
                ):

                    right_value = right_node.value
                    if isinstance(right_value, str) and right_value.startswith("#"):
                        table_name = right_value.lstrip("#")
                        table_data = self._get_table_data(table_name)

                        if table_data:
                            if isinstance(index_value, (int, float)):
                                item_id = str(int(index_value))
                            else:
                                item_id = str(index_value)

                            if item_id in table_data:
                                item_data = table_data[item_id]
                                # 继续处理后续的成员访问
                                current = node
                                while current.type == NodeType.INDEX_ACCESS:
                                    if isinstance(current.index, (int, float)):
                                        idx = int(current.index)
                                    else:
                                        idx = current.index

                                    if isinstance(current.object, dict):
                                        break

                                    if current.object.type == NodeType.BINARY_EXPR:
                                        break

                                    if current.object.type == NodeType.INDEX_ACCESS:
                                        if isinstance(
                                            current.object.index, (int, float)
                                        ):
                                            idx = int(current.object.index)
                                        else:
                                            idx = current.object.index

                                        if isinstance(current.object.object, dict):
                                            break

                                        if (
                                            current.object.object.type
                                            == NodeType.IDENTIFIER
                                        ):
                                            obj_val = current.object.object.value
                                            if isinstance(
                                                obj_val, str
                                            ) and obj_val.startswith("#"):
                                                table = obj_val.lstrip("#")
                                                data = self._get_table_data(table)
                                                if data and str(idx) in data:
                                                    item_data = data[str(idx)]
                                        break

                                    current = current.object

                                if current.object.type == NodeType.MEMBER_ACCESS:
                                    result = self._evaluate_ast_node_with_context(
                                        current.object, skill_id, skill_level, context
                                    )
                                    if isinstance(result, (int, float)):
                                        return -result
                                    return result
                                elif isinstance(item_data, (int, float)):
                                    return -item_data
                                return item_data

            # 如果object_value是字符串，可能是表名
            if isinstance(object_value, str):
                # 移除#前缀（如果有）
                table_name = object_value.lstrip("#")
                table_data = self._get_table_data(table_name)
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
                    # 尝试使用数字ID
                    if isinstance(index_value, (int, float)):
                        item_id = str(int(index_value))
                        if item_id in table_data:
                            item_data = table_data[item_id]
                            # 更新上下文，记录表类型和ID
                            context["table_type"] = table_name
                            context["table_id"] = index_value
                            return item_data
                    raise ValueError(f"表 '{table_name}' 中找不到ID '{index_value}'")

            # 如果object_value是字典，可能是访问嵌套字段或表数据
            elif isinstance(object_value, dict):
                index_str = str(index_value)
                # 首先检查是否是直接键（数字或字符串键）
                if index_str in object_value:
                    result = object_value[index_str]

                    # 如果索引值不是小整数（1-10），并且结果是字典/列表
                    # 可能是表访问，需要检测并更新上下文
                    if (
                        index_value not in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        and isinstance(index_value, (int, float))
                        and isinstance(result, (dict, list))
                    ):

                        # 检测 object_value 是否像是一个表（有多个数字键）
                        numeric_keys = [
                            k for k in object_value.keys() if str(k).isdigit()
                        ]
                        if len(numeric_keys) > 1:
                            # 这是一个表访问，尝试推断表名
                            # 遍历所有已知的表名，查找匹配的表
                            for table_name in [
                                "SkillEffects",
                                "Buff",
                                "TargetFilter",
                                "SkillCreature",
                            ]:
                                table_data = self._get_table_data(table_name)
                                if table_data and table_data is object_value:
                                    context["table_type"] = table_name
                                    context["table_id"] = index_value
                                    break

                    return result
                # 如果索引是小整数，尝试作为列表索引访问（1-based转0-based）
                if index_value in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
                    adjusted_index = index_value - 1
                    keys = list(object_value.keys())
                    if 0 <= adjusted_index < len(keys):
                        result = object_value[keys[adjusted_index]]
                        return result
                # 尝试使用数字ID（用于像 110114 这样的ID）
                if isinstance(index_value, (int, float)):
                    int_id = str(int(index_value))
                    if int_id in object_value:
                        result = object_value[int_id]
                        return result
                raise ValueError(f"字典中找不到键: {index_value}")

            elif isinstance(object_value, list):
                # 列表索引
                if isinstance(index_value, int):
                    # 索引 0 是直接的 0-based，不进行转换
                    if index_value == 0:
                        if 0 < len(object_value):
                            result = object_value[0]
                            return result
                        else:
                            raise ValueError(f"列表索引超出范围: {index_value}")
                    # 其他索引（1-10）是 1-based，转换为 0-based
                    elif index_value in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
                        adjusted_index = index_value - 1
                        if 0 <= adjusted_index < len(object_value):
                            result = object_value[adjusted_index]
                            return result
                        else:
                            raise ValueError(f"列表索引超出范围: {index_value}")
                    else:
                        # 其他数字索引作为直接索引
                        if 0 <= index_value < len(object_value):
                            result = object_value[index_value]
                            return result
                        else:
                            raise ValueError(f"列表索引超出范围: {index_value}")
                else:
                    raise ValueError(f"列表索引必须是整数: {index_value}")

            else:
                raise ValueError(f"无法对类型 {type(object_value)} 进行索引访问")

        elif node.type == NodeType.MEMBER_ACCESS:
            # 成员访问: object.property
            object_value = self._evaluate_ast_node_with_context(
                node.object, skill_id, skill_level, context
            )
            property_name = node.property.value

            # 如果object_value是字符串且以#开头，尝试作为SkillGrow引用处理
            if isinstance(object_value, str) and object_value.startswith("#"):
                # 这是需要通过 SkillGrow 查找的值
                table_type = context.get("table_type", "Skill")
                table_id = context.get("table_id", skill_id)

                attr = {
                    "Type": table_type,
                    "Value": object_value,
                }

                # 通过 SkillGrow 查找值
                result = self._calc_char_attr_by_level(attr, table_id, skill_level)

                # 如果结果是数值，直接返回
                if isinstance(result, (int, float)):
                    return result

                # 如果结果是字符串，尝试继续查找
                if isinstance(result, str):
                    return result

                return result

            # 如果object_value是字典，访问属性
            if isinstance(object_value, dict):
                if property_name in object_value:
                    value = object_value[property_name]

                    # 如果值是字典且包含 Value 属性，直接返回 Value
                    if isinstance(value, dict) and "Value" in value:
                        return value["Value"]

                    # 如果值是字符串且以#开头，使用SkillGrow查找
                    if isinstance(value, str) and value.startswith("#"):
                        # 使用上下文信息进行SkillGrow查找
                        table_type = context.get("table_type", "Skill")
                        table_id = context.get("table_id", skill_id)

                        # 构建attr对象用于SkillGrow查找
                        attr_key = "Rate" if "Rate" in property_name else "Value"
                        attr = {
                            "Type": table_type,
                            attr_key: value,
                        }

                        # 调用_calc_char_attr_by_level获取实际值
                        return self._calc_char_attr_by_level(
                            attr, table_id, skill_level
                        )

                    return value

                # 如果值不在直接属性中，检查是否是嵌套属性
                # 尝试将属性名中的下划线替换为驼峰式
                camel_property = self._to_camel_case(property_name)
                if camel_property in object_value:
                    value = object_value[camel_property]

                    # 如果值是字典且包含 Value 属性，直接返回 Value
                    if isinstance(value, dict) and "Value" in value:
                        return value["Value"]

                    # 如果值是字符串且以#开头，使用SkillGrow查找
                    if isinstance(value, str) and value.startswith("#"):
                        table_type = context.get("table_type", "Skill")
                        table_id = context.get("table_id", skill_id)

                        attr_key = "Rate" if "Rate" in property_name else "Value"
                        attr = {
                            "Type": table_type,
                            attr_key: value,
                        }

                        return self._calc_char_attr_by_level(
                            attr, table_id, skill_level
                        )

                    return value

                raise ValueError(
                    f"在字典中找不到属性 '{property_name}' 或 '{camel_property}'"
                )

            else:
                # 如果object_value不是字典，可能是数值类型（如 BuffDamagedRate 是一个数值）
                if isinstance(object_value, (int, float)):
                    return object_value
                raise ValueError(
                    f"无法访问类型为 {type(object_value)} 的对象的属性 '{property_name}'"
                )

        elif node.type == NodeType.FUNCTION_CALL:
            # 函数调用: func(args)
            func_name = None

            # 获取函数名
            if node.object.type == NodeType.IDENTIFIER:
                func_name = node.object.value
            elif node.object.type == NodeType.MEMBER_ACCESS:
                # 处理 math.abs 这样的函数调用
                module_obj = self._evaluate_ast_node_with_context(
                    node.object.object, skill_id, skill_level, context
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
                        arg_node, skill_id, skill_level, context
                    )
                    # 如果参数是字典但包含 Value 属性，提取出来
                    if isinstance(arg_value, dict) and "Value" in arg_value:
                        arg_value = arg_value["Value"]
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

    def _calc_char_attr_by_level(self, attr, skill_id, skill_level):
        """根据等级计算角色/技能属性值"""
        import re

        is_rate = "Rate" in attr
        base = attr.get("Rate" if is_rate else "Value")
        level_grow = attr.get("LevelGrow", 0)

        try:
            if isinstance(base, str):
                if base.startswith("#"):
                    grow_index = int(base.strip("#"))
                    grow_type = attr.get("Type", "Skill")

                    if grow_type not in self.skill_grow_data:
                        return float(grow_index)

                    skill_grow_type_data = self.skill_grow_data[grow_type]
                    id_key = str(skill_id)

                    if id_key not in skill_grow_type_data:
                        return float(grow_index)

                    id_data = skill_grow_type_data[id_key]
                    level_index = skill_level - 1

                    if level_index < 0 or level_index >= len(id_data):
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

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
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    value = base_num + level_grow_num * (skill_level - 1)
                    return value

            base_num = float(base)
            level_grow_num = float(level_grow)
            value = base_num + level_grow_num * (skill_level - 1)
            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            return 0.0

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
