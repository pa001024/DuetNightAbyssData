from processor.base_processor import BaseProcessor
import re
import os
from dotenv import load_dotenv

# 加载.env文件
load_dotenv()


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
        self.skill_effects_data = data_loader.load_json("SkillEffects.json")

    def process_item(self, weapon_data, language):
        weapon_id = weapon_data.get("WeaponId", 0)

        # 获取BattleWeapon数据
        battle_weapon = self.battle_weapon_data.get(str(weapon_id), {})
        if not battle_weapon:
            battle_weapon = self.battle_weapon_data.get(weapon_id, {})

        # 构建基础处理后的Weapon数据
        processed = {
            "id": weapon_id,
            "icon": weapon_data.get("Icon", "").replace(
                "/Game/UI/Texture/Dynamic/Image/Head/Weapon/T_Head_", ""
            ),
            "名称": self.get_translated_text(weapon_data.get("WeaponName", "")),
            "版本": self.process_release(weapon_data.get("ReleaseVersion", 100)),
            "描述": self.get_translated_text(weapon_data.get("WeaponDescribe", "")),
            "类型": self.process_tags(battle_weapon.get("WeaponTag", [])),
        }

        # 处理WeaponBlueprint，提取武器模型名称
        processed.update(self._process_weapon_blueprint(battle_weapon))
        processed.update(self._process_attributes(battle_weapon, weapon_id))
        processed.update(
            {
                "加成": self._process_add_attr(battle_weapon, weapon_id),
                "突破": self._process_break(weapon_id, language),
                "熔炼": self._process_smelting(battle_weapon, weapon_id),
            }
        )
        try:
            processed.update(
                {
                    "技能": self._process_skills(battle_weapon, weapon_id),
                }
            )
        except Exception as e:
            print(f"处理武器 {weapon_id} 技能时出错: {e}")
            import traceback

            traceback.print_exc()

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

            if (
                not skill_info
                or not isinstance(skill_info, list)
                or len(skill_info) == 0
            ):
                continue

            # 获取技能信息（取第一个元素，通常技能只有一个等级）
            skill_data = skill_info[0]
            if isinstance(skill_data, list) and len(skill_data) > 0:
                skill_entry = skill_data[0]
            else:
                skill_entry = skill_data

            # 获取技能名称和描述
            # skill_name = self.get_translated_text(skill_entry.get("SkillName", ""))
            # skill_desc_key = skill_entry.get("SkillDesc", "")
            # skill_desc = self.get_translated_text(skill_desc_key)

            # 获取技能描述参数
            skill_desc_keys = skill_entry.get("SkillDescKeys", [])
            skill_desc_values = skill_entry.get("SkillDescValues", [])

            # 构建技能信息
            skill_info_dict = {
                "id": skill_id,
                "名称": skill_entry.get("SkillType", ""),
                # "weapon": skill_entry.get("SkillWeaponType", ""),
            }

            # 如果有描述，处理描述中的占位符
            if skill_desc_keys:
                # 计算技能描述（默认使用武器等级1）
                processed_desc, cut_toughness, delay, hit_stop = (
                    self._process_weapon_skill_desc(
                        skill_entry, weapon_id, skill_desc_keys, skill_desc_values
                    )
                )
                if processed_desc:
                    skill_info_dict["字段"] = processed_desc
                # 添加削韧、延迟、卡肉数据
                if cut_toughness:
                    skill_info_dict["削韧"] = cut_toughness
                if delay:
                    skill_info_dict["延迟"] = delay
                if hit_stop:
                    skill_info_dict["卡肉"] = hit_stop

            skills.append(skill_info_dict)

        rst = []
        typeMap = {
            "Shooting": "射击",
            "Attack": "普通攻击",
            "HeavyAttack": "蓄力攻击",
            "FallAttack": "下落攻击",
            "SlideAttack": "滑行攻击",
        }
        for skill in skills:
            if "字段" in skill:
                skill_item = {
                    "名称": typeMap.get(skill["名称"], skill["名称"]),
                    "类型": "武器伤害",
                    "字段": skill["字段"],
                }
                # 添加id、削韧、延迟、卡肉数据
                if "id" in skill:
                    skill_item["id"] = skill["id"]
                if "削韧" in skill:
                    skill_item["削韧"] = skill["削韧"]
                if "延迟" in skill:
                    skill_item["延迟"] = skill["延迟"]
                if "卡肉" in skill:
                    skill_item["卡肉"] = skill["卡肉"]
                rst.append(skill_item)
        return rst

    def _trim_trailing_zeros(self, arr):
        """去掉数组尾部的0，如果全为0则返回空数组"""
        if not arr:
            return []

        # 创建数组副本以避免修改原始数据
        trimmed = arr.copy()

        # 从尾部开始去掉0
        while trimmed and trimmed[-1] == 0:
            trimmed.pop()

        return trimmed

    def _process_weapon_skill_desc(
        self, _skill_entry, weapon_id, desc_keys, desc_values
    ):
        """处理武器技能描述，替换占位符"""
        if not desc_keys or not desc_values:
            return {}, [], [], []

        rst = {}
        cut_toughness = []
        delay = []
        hit_stop = []

        # desc_keys 和 desc_values 可能是列表或字典
        if isinstance(desc_keys, dict):
            # 字典格式：{'1': key1, '2': key2, ...}
            items = desc_keys.items()
        else:
            # 列表格式：[key1, key2, ...]
            items = enumerate(desc_keys)

        for key_or_index, desc_key in items:
            # 获取对应的 desc_value
            if isinstance(desc_values, dict):
                # 字格格式，使用相同的键
                desc_value = desc_values.get(
                    str(
                        key_or_index + 1
                        if isinstance(key_or_index, int)
                        else key_or_index
                    )
                )
            else:
                # 列表格式，使用索引
                if key_or_index >= len(desc_values):
                    continue
                desc_value = desc_values[key_or_index]

            if desc_value is None:
                # 当desc_value为None时，使用0作为默认值
                cut_toughness.append(0)
                delay.append(0)
                hit_stop.append(0)
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)
            # 预处理表达式，将 $GText("...")$ 替换为翻译后的文本
            preprocessed_desc_value = self.preprocess_expression(desc_value)

            # 计算值（使用武器等级1）
            calculated_value = self._parse_single_desc_value(
                preprocessed_desc_value, weapon_id, 1, "BattleWeapon"
            )
            rst[desc_text] = calculated_value

            # 为每个技能字段解析对应的SkillEffects，提取HitStop和CutToughness信息
            skill_effects_info = self._parse_skill_effects(desc_value, weapon_id)
            if skill_effects_info:
                cut_toughness.append(skill_effects_info.get("削韧", 0))
                delay.append(skill_effects_info.get("延迟", 0))
                hit_stop.append(skill_effects_info.get("卡肉", 0))
            else:
                # 当没有技能效果信息时，使用0作为默认值
                cut_toughness.append(0)
                delay.append(0)
                hit_stop.append(0)

        # 处理数组，去掉尾部的0
        cut_toughness = self._trim_trailing_zeros(cut_toughness)
        delay = self._trim_trailing_zeros(delay)
        hit_stop = self._trim_trailing_zeros(hit_stop)

        return rst, cut_toughness, delay, hit_stop

    def _process_add_attr(self, battle_weapon, weapon_id):
        """处理武器属性加成"""
        if not battle_weapon:
            return {}

        # AddAttrs[0]通常包含ATK属性，Rate字段是"#1"，需要从SkillGrow获取
        add_attrs = battle_weapon.get("AddAttrs", [])
        attributes = {}
        # 尝试从AddAttrs中找到ATK属性
        anmap = {
            "暴击率": "暴击",
            "暴击伤害": "暴伤",
            "攻击速度": "攻速",
            "触发概率": "触发",
            "多重射击": "多重",
            "弹匣容量": "弹匣",
        }
        for attr in add_attrs:
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
                if an in anmap:
                    an = anmap[an]
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
                placeholder = f"#{i + 1}"

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
        """解析单个DescValue，获取实际值，支持多个$...$表达式"""
        import re
        import math

        # 处理所有$...$格式的表达式
        result = desc_value
        pattern = r"\$(-)?(.*?)\$"

        # 查找所有匹配的表达式（从右到左替换，避免位置偏移问题）
        matches = list(re.finditer(pattern, desc_value))

        for match in reversed(matches):
            expr_content = match.group(2)
            has_neg = match.group(1)

            # 提取表达式后面的后缀（如 %）
            # 从匹配结束位置到下一个$或字符串结尾
            after_match = result[match.end() :]
            suffix = ""
            for c in after_match:
                if c == "$":
                    break
                suffix += c

            # 检查是否是math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr_content)
            try:
                if math_match:
                    math_func = math_match.group(1)
                    inner_expr = math_match.group(2)

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
                    else:
                        formatted_value = "0.0"
                else:
                    # 普通表达式
                    expr_value = self._calculate_expr_value(
                        expr_content, weapon_id, grade_level, table_type
                    )

                    if has_neg:
                        final_value = -expr_value
                    else:
                        final_value = expr_value

                    formatted_value = f"{final_value:.1f}"

                # 替换匹配的表达式（包括后缀）
                result = (
                    result[: match.start()]
                    + f"{formatted_value}{suffix}"
                    + result[match.end() + len(suffix) :]
                )

            except Exception as e:
                # 表达式计算失败时，使用默认值 0
                print(f"表达式解析错误: {e}")
                formatted_value = "0.0"
                result = (
                    result[: match.start()]
                    + f"{formatted_value}{suffix}"
                    + result[match.end() + len(suffix) :]
                )

        return result

    def _parse_skill_effects(self, desc_value, weapon_id):
        """解析单个desc_value中的SkillEffects引用，提取HitStop和CutToughness信息"""
        if not isinstance(desc_value, str):
            return {}

        result = {}
        visited_effect_ids = set()

        # 查找所有SkillEffects引用模式: $#SkillEffects[id]...
        # 模式需要匹配 $#SkillEffects[id].TaskEffects[index].field...$
        import re

        pattern = r"\$#SkillEffects\[(\d+)\]"
        matches = re.findall(pattern, desc_value)

        for effect_id_str in matches:
            effect_id = int(effect_id_str)

            # 避免重复处理同一个SkillEffects
            if effect_id in visited_effect_ids:
                continue
            visited_effect_ids.add(effect_id)

            # 获取SkillEffects数据
            skill_effect = self.skill_effects_data.get(str(effect_id))
            if not skill_effect:
                skill_effect = self.skill_effects_data.get(effect_id)

            if not skill_effect:
                continue

            # 遍历所有TaskEffects，查找HitStop和CutToughness
            task_effects = skill_effect.get("TaskEffects", [])
            for task_effect in task_effects:
                # 检查是否是HitStop函数
                if task_effect.get("Function") == "HitStop":
                    # 解析HitStop字段
                    delay = task_effect.get("Delay")
                    duration = task_effect.get("Duration")

                    if delay is not None:
                        result["延迟"] = delay
                    if duration is not None:
                        result["卡肉"] = duration

                # 检查是否是CutToughness函数
                if task_effect.get("Function") == "CutToughness":
                    # 解析CutToughness的Value字段
                    value = task_effect.get("Value")
                    if value is not None:
                        result["削韧"] = value

        return result

    def _process_weapon_blueprint(self, battle_weapon):
        """处理WeaponBlueprint，提取武器模型名称并读取外部动画文件"""

        result = {}

        # 从环境变量获取导出路径，不设置默认值
        export_path = os.getenv("EXPORT_PATH")
        # 如果没有配置环境变量，直接返回空值
        if not export_path:
            return result

        # 获取WeaponBlueprint
        weapon_blueprint = battle_weapon.get("WeaponBlueprint", "")
        if not weapon_blueprint:
            return result

        # 提取BP_后面的部分，如Shotgun_Banzi
        match = re.search(r"BP_([^.]+)", weapon_blueprint)
        if not match:
            return result

        weapon_model = match.group(1)

        # 从WeaponBlueprint路径中提取武器类型
        weapon_type_match = re.search(r"/([^/]+)/BP_" + weapon_model, weapon_blueprint)
        if not weapon_type_match:
            return result

        weapon_type = weapon_type_match.group(1)

        # 构建基础路径
        base_path = f"{export_path}/Asset/Char/Player/Common/Weapon/{weapon_type}/{weapon_model}/Animation"

        # 读取射击间隔 (Shooting)
        shooting_file = os.path.join(base_path, f"{weapon_model}_Shooting.props.txt")
        if os.path.exists(shooting_file):
            try:
                with open(shooting_file, "r", encoding="utf-8") as f:
                    content = f.read()
                    seq_match = re.search(r"SequenceLength\s*=\s*([\d.]+)", content)
                    if seq_match:
                        result["射速"] = (
                            round((1 / float(seq_match.group(1))) * 1000) / 1000
                        )
            except Exception as e:
                print(f"读取射击文件错误: {e}")

        # 读取装填时间 (Reload)
        reload_file = os.path.join(base_path, f"{weapon_model}_Reload.props.txt")
        if os.path.exists(reload_file):
            try:
                with open(reload_file, "r", encoding="utf-8") as f:
                    content = f.read()
                    seq_match = re.search(r"SequenceLength\s*=\s*([\d.]+)", content)
                    if seq_match:
                        result["装填"] = float(seq_match.group(1))
            except Exception as e:
                print(f"读取装填文件错误: {e}")

        return result
