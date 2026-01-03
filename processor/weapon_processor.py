from processor.base_processor import BaseProcessor


class WeaponProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Weapon"
        # 加载必要的配置数据
        self.attr_config = data_loader.load_json("AttrConfig.json")
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.skill_data = data_loader.load_json("Skill.json")
        self.skill_grow_data = data_loader.load_json("SkillGrow.json")
        self.weapon_level_up_data = data_loader.load_json("WeaponLevelUp.json")
        self.weapon_break_data = data_loader.load_json("WeaponBreak.json")
        self.battle_weapon_data = data_loader.load_json("BattleWeapon.json")
        self.weapon_card_level_data = data_loader.load_json("WeaponCardLevel.json")
        self.attribute_data = data_loader.load_json("Attribute.json")

    def process_item(self, weapon_data, language):
        weapon_id = weapon_data.get("WeaponId", 0)

        # 获取BattleWeapon数据
        battle_weapon = self.battle_weapon_data.get(str(weapon_id), {})
        if not battle_weapon:
            battle_weapon = self.battle_weapon_data.get(weapon_id, {})

        # 构建基础处理后的Weapon数据
        processed = {
            "id": weapon_id,
            "名称": self.get_translated_text(weapon_data.get("WeaponName", "")),
            "描述": self.get_translated_text(weapon_data.get("WeaponDescribe", "")),
            "类型": self.process_tags(battle_weapon.get("WeaponTag", [])),
        }
        processed.update(self._process_attributes(battle_weapon, weapon_id))
        processed.update(
            {
                "加成": self._process_add_attr(battle_weapon, weapon_id),
                "突破": self._process_break(weapon_id, language),
                "熔炼": self._process_smelting(battle_weapon, weapon_id),
                "技能": self._process_skills(battle_weapon, weapon_id),
            }
        )

        return processed

    def _process_skills(self, battle_weapon, weapon_id):
        """处理武器技能"""
        if not battle_weapon:
            return []

        # 获取武器技能列表
        weapon_skill_list = battle_weapon.get("WeaponSkillList", [])
        if not weapon_skill_list:
            return []

        skills = []

        # 处理每个技能
        for skill_id in weapon_skill_list:
            skill_info = self.skill_data.get(str(skill_id), {})
            if not skill_info:
                skill_info = self.skill_data.get(skill_id, {})

            if not skill_info or not isinstance(skill_info, list) or len(skill_info) == 0:
                continue

            # 获取技能信息（取第一个元素，通常技能只有一个等级）
            skill_data = skill_info[0]
            if isinstance(skill_data, list) and len(skill_data) > 0:
                skill_entry = skill_data[0]
            else:
                skill_entry = skill_data

            # 获取技能名称和描述
            skill_name = self.get_translated_text(skill_entry.get("SkillName", ""))
            skill_desc_key = skill_entry.get("SkillDesc", "")
            skill_desc = self.get_translated_text(skill_desc_key)

            # 获取技能描述参数
            skill_desc_keys = skill_entry.get("SkillDescKeys", [])
            skill_desc_values = skill_entry.get("SkillDescValues", [])

            # 构建技能信息
            skill_info_dict = {
                "名称": skill_name,
            }

            # 如果有描述，处理描述中的占位符
            if skill_desc:
                # 计算技能描述（默认使用武器等级1）
                processed_desc = self._process_weapon_skill_desc(
                    skill_entry, weapon_id, skill_desc_keys, skill_desc_values
                )
                if processed_desc:
                    skill_info_dict["描述"] = processed_desc
                else:
                    skill_info_dict["描述"] = skill_desc

                # 如果有参数字段，添加参数信息
                if skill_desc_keys and skill_desc_values:
                    fields = self._process_weapon_skill_fields(
                        skill_entry, weapon_id, skill_desc_keys, skill_desc_values
                    )
                    if fields:
                        skill_info_dict["字段"] = fields

            skills.append(skill_info_dict)

        return skills

    def _process_weapon_skill_desc(self, _skill_entry, weapon_id, desc_keys, desc_values):
        """处理武器技能描述，替换占位符"""
        if not desc_keys or not desc_values:
            return ""

        # 获取第一个描述key
        desc_key = desc_keys[0] if desc_keys else ""
        if not desc_key:
            return ""

        # 获取翻译文本
        desc_text = self.get_translated_text(desc_key)

        # 替换占位符
        result_desc = desc_text
        for i, desc_value in enumerate(desc_values):
            placeholder = f"#{i+1}"

            # 计算值（使用武器等级1）
            calculated_value = self._parse_single_desc_value(
                desc_value, weapon_id, 1, "BattleWeapon"
            )

            # 替换占位符
            result_desc = result_desc.replace(placeholder, str(calculated_value))

        # 移除高亮标签
        result_desc = result_desc.replace("<H>", "").replace("</>", "")

        return result_desc

    def _process_weapon_skill_fields(self, _skill_entry, weapon_id, desc_keys, desc_values):
        """处理武器技能字段，返回类似角色的技能字段格式"""
        if not desc_keys or not desc_values:
            return {}

        fields = {}

        for i, desc_key in enumerate(desc_keys):
            if i >= len(desc_values):
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)
            desc_value = desc_values[i]

            # 计算各个等级的值（假设武器最多5个等级）
            values = []
            for level in range(1, 6):
                calculated_value = self._parse_single_desc_value(
                    desc_value, weapon_id, level, "BattleWeapon"
                )
                values.append(calculated_value)

            # 检查是否所有值都相同
            if all(abs(v - values[0]) < 0.0001 for v in values):
                # 如果值相同，只显示单个值
                final_value = values[0]
                # 尝试转换为整数
                if final_value == int(final_value):
                    final_value = int(final_value)
                fields[desc_text] = {"值": final_value}
            else:
                # 如果值不同，显示所有等级的值
                final_values = []
                for v in values:
                    if v == int(v):
                        final_values.append(int(v))
                    else:
                        final_values.append(v)
                fields[desc_text] = {"值": final_values}

        return fields

    def _process_add_attr(self, battle_weapon, weapon_id):
        """处理武器属性加成"""
        if not battle_weapon:
            return {}

        # AddAttrs[0]通常包含ATK属性，Rate字段是"#1"，需要从SkillGrow获取
        add_attrs = battle_weapon.get("AddAttrs", [])
        attributes = {}
        # 尝试从AddAttrs中找到ATK属性
        for attr in add_attrs:
            if attr.get("AttrName") == "ATK":
                # 从SkillGrow获取等级1的ATK值作为基础值
                attr_rate = attr.get("Rate", "")
                if attr_rate and attr_rate.startswith("#"):
                    # 确保attr对象有正确的Type字段
                    if "Type" not in attr:
                        attr = dict(attr)  # 创建副本避免修改原始数据
                        attr["Type"] = "BattleWeapon"
                    # 使用_calc_attr_by_level获取等级1的值
                    base_atk = self._calc_attr_by_level(attr, weapon_id, 1)
                else:
                    base_atk = float(attr_rate) if attr_rate else 0
                attributes["攻击"] = base_atk
            else:
                attr_name = attr.get("AttrName", "")
                if (
                    attr_name in self.attr_config
                    or attr_name + "_Normal" in self.attr_config
                ):
                    cfg = self.attr_config.get(attr_name) or self.attr_config.get(
                        attr_name + "_Normal", {}
                    )
                    an = self.get_translated_text(cfg.get("Name", ""), "cn")
                    # 确保attr对象有正确的Type字段
                    if "Type" not in attr:
                        attr = dict(attr)  # 创建副本避免修改原始数据
                        attr["Type"] = "BattleWeapon"
                    attributes[an] = self._calc_attr_by_level(attr, weapon_id, 1)
                else:
                    attributes[attr_name] = attr_name
        return attributes

    def _process_attributes(self, battle_weapon, weapon_id):
        """处理武器属性，计算各个等级的ATK值"""
        if not battle_weapon:
            return {}

        attributes = {}

        # 计算所有属性加成（ATK_Dark, ATK_Fire等）
        for attr_name in self.attribute_data.keys():
            attr_key = f"ATK_{attr_name}"
            if attr_key in battle_weapon:
                attr_config = self.attr_config.get(attr_key, {})
                atk_type = self.get_translated_text(attr_config.get("Name", ""), "cn")
                attributes["伤害类型"] = atk_type[:2]
                attributes[atk_type[2:]] = battle_weapon[attr_key]
        attributes["暴击"] = battle_weapon.get("CRI", 0)
        attributes["暴伤"] = battle_weapon.get("CRD", 0)
        attributes["触发"] = battle_weapon.get("TriggerProbability", 0)
        if "MagazineCapacity" in battle_weapon:
            attributes["弹匣"] = battle_weapon["MagazineCapacity"]
        if "BulletMax" in battle_weapon:
            attributes["最大弹药"] = battle_weapon["BulletMax"]
        if "BulletConver" in battle_weapon:
            attributes["弹药转化率"] = battle_weapon["BulletConver"]
        if "MaxDistance" in battle_weapon:
            attributes["最大射程"] = battle_weapon["MaxDistance"]

        return attributes

    def _process_break(self, weapon_id, language):
        """处理武器突破数据"""
        break_list = self.weapon_break_data.get(str(weapon_id), [])
        if not break_list:
            break_list = self.weapon_break_data.get(weapon_id, [])

        if not break_list:
            return []

        break_info = []

        for break_stage in break_list:
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

    def _process_smelting(self, battle_weapon, weapon_id):
        """处理武器熔炼数据，计算各等级的技能描述"""
        if not battle_weapon:
            return {}

        # 获取WeaponCardLevel数据
        card_level_data = self.weapon_card_level_data.get(str(weapon_id), {})
        if not card_level_data:
            card_level_data = self.weapon_card_level_data.get(weapon_id, {})

        smelting_info = []

        # 处理PassiveEffectsDesc和PassiveEffectsDescValues
        passive_desc = battle_weapon.get("PassiveEffectsDesc", "")
        desc_values = battle_weapon.get("PassiveEffectsDescValues", [])

        if not passive_desc:
            return smelting_info

        # 为每个熔炼等级计算技能描述
        for grade_level in range(1, 7):
            # 计算该等级的技能描述
            skill_desc = self._calc_weapon_passive_effects_desc(
                battle_weapon, grade_level, passive_desc, desc_values
            )
            smelting_info.append(skill_desc)

        return smelting_info

    def _calc_weapon_passive_effects_desc(
        self, battle_weapon, grade_level, passive_desc, desc_values
    ):
        """计算武器指定熔炼等级的被动效果描述"""
        import re

        if not passive_desc:
            return ""

        # passive_desc 可能是文本key（如 SKILL_10101_DESC），需要从i18n获取翻译
        # 先从i18n_data中查找翻译
        translated_desc = self.get_translated_text(passive_desc)
        if not translated_desc:
            translated_desc = passive_desc

        # 复制描述，用于替换占位符
        result_desc = translated_desc

        # 替换DescValues中的值
        if desc_values:
            for i, desc_value in enumerate(desc_values):
                placeholder = f"#{i+1}"

                # 检查desc_value中是否包含math.floor或math.ceil
                cast_to = "math.floor" in desc_value or "math.ceil" in desc_value

                # 提取百分号后缀（如果有）
                percent = "" if "%" not in desc_value else "%"

                # 解析desc_value，获取实际值
                # weapon_id用于SkillGrow查找
                weapon_id = battle_weapon.get("WeaponId", None)
                val_str = self._parse_single_desc_value(
                    desc_value, weapon_id, grade_level, "BattleWeapon"
                )

                # 如果需要取整
                if cast_to:
                    try:
                        val = float(re.search(r"([\d.]+)", val_str).group(1))
                        val_str = f"{int(val)}{percent}"
                    except:
                        pass

                # 替换占位符
                result_desc = result_desc.replace(placeholder, val_str)

        # 移除<H></>标签（高亮标签）
        result_desc = result_desc.replace("<H>", "").replace("</>", "")

        return result_desc

    def _parse_single_desc_value(self, desc_value, weapon_id, grade_level, table_type):
        """解析单个DescValue，获取实际值"""
        import re
        import math

        # 处理$...$格式的表达式
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", desc_value)
        if expr_match:
            has_neg = expr_match.group(1)
            expr = expr_match.group(2)
            suffix = expr_match.group(3)

            # 检查是否是math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr)
            if math_match:
                math_func = math_match.group(1)
                inner_expr = math_match.group(2)

                try:
                    expr_value = self._calculate_expr_value(
                        inner_expr, weapon_id, grade_level, table_type
                    )

                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:
                            processed_value = math.floor(expr_value)

                        if has_neg:
                            processed_value = -processed_value

                        formatted_value = f"{processed_value:.1f}"
                        result = desc_value.replace(
                            expr_match.group(0), f"{formatted_value}{suffix}"
                        )
                        return result.strip("$")
                except ValueError as e:
                    return desc_value.replace(expr_match.group(0), f"0{suffix}")

            # 普通表达式
            try:
                expr_value = self._calculate_expr_value(
                    expr, weapon_id, grade_level, table_type
                )

                if has_neg:
                    final_value = -expr_value
                else:
                    final_value = expr_value

                formatted_value = f"{final_value:.1f}"
                result = desc_value.replace(
                    expr_match.group(0), f"{formatted_value}{suffix}"
                )
                return result.strip("$")
            except ValueError as e:
                return desc_value.replace(expr_match.group(0), f"0{suffix}").strip("$")

        return "{ERROR}"
