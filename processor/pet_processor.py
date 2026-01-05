from processor.base_processor import BaseProcessor
import re


class PetProcessor(BaseProcessor):
    """
    魔灵(Pet)数据处理器
    处理游戏中的魔灵数据，包括基本信息、属性和技能等
    """

    def __init__(self, data_loader):
        """初始化 Pet 处理器"""
        super().__init__(data_loader)
        self.file_type = "Pet"
        self.battle_pet_data = data_loader.load_json("BattlePet.json")
        self.skill_data = data_loader.load_json("Skill.json")
        self.skill_grow_data = data_loader.load_json("SkillGrow.json")

    def process_item(self, pet_data, language):
        """
        处理单个魔灵数据

        Args:
            pet_data: 魔灵原始数据
            language: 语言代码

        Returns:
            处理后的魔灵数据
        """
        pet_id = pet_data.get("UnitId", 0)

        # 构建基础处理后的魔灵数据
        processed = {
            "id": pet_id,
            "uid": pet_data.get("GUID", 0),
            "名称": self.get_translated_text(pet_data.get("Name", "")),
            "icon": pet_data.get("Icon", "")
            .replace("/Game/UI/Texture/Dynamic/Image/Head/Pet/T_Head_Pet_", "")
            .split(".")[0],
            "品质": pet_data.get("Rarity", 0),
            "类型": pet_data.get("PetType", 0),
            "最大等级": pet_data.get("PetMaxLevel", 0),
            "捕获经验": pet_data.get("CollectRewardExp", 0),
            "经验": pet_data.get("PetExp", 0),
        }
        if not processed["uid"]:
            del processed["uid"]
        battle_pet = self._process_battle_pet(pet_data.get("BattlePetId", 0))
        if battle_pet:
            processed.update(battle_pet)

        return processed

    def _process_battle_pet(self, battle_pet_id):
        """处理战斗魔灵数据"""
        rst = {}  # 战斗魔灵数据
        data = self.battle_pet_data.get(str(battle_pet_id), {})
        if not data:
            data = self.battle_pet_data.get(battle_pet_id, {})

        if not data:
            return rst

        # 处理属性数据
        attributes = self._process_pet_attributes(data)
        if attributes:
            rst.update(attributes)

        # 处理技能数据
        skills = self._process_pet_skills(data, battle_pet_id)
        if skills:
            rst.update(skills)

        return rst

    def _process_pet_attributes(self, battle_pet_data):
        """处理魔灵属性数据"""
        if not battle_pet_data:
            return {}

        attributes = {
            "基础攻击": battle_pet_data.get("ATK", 0),
            "基础生命": battle_pet_data.get("MaxHp", 0),
            "基础防御": battle_pet_data.get("DEF", 0),
        }

        # 移除值为0的属性
        return {k: v for k, v in attributes.items() if v > 0}

    def _process_pet_skills(self, battle_pet_data, battle_pet_id):
        """处理魔灵技能数据"""
        if not battle_pet_data:
            return {}

        skills = {}

        # 处理主动技能
        skill_id = battle_pet_data.get("SupportSkillId", 0)
        if skill_id:
            active_skill = self._process_single_pet_skill(skill_id)
            if active_skill:
                skills["主动"] = active_skill

        # 处理被动技能
        passive_effect_desc = battle_pet_data.get("PassiveEffectDesc", "")
        passive_effect_params = battle_pet_data.get("PassiveEffectDescParameter", [])
        if passive_effect_desc:
            passive_skill = self._process_passive_skill(
                passive_effect_desc, passive_effect_params, battle_pet_id
            )
            if passive_skill:
                skills["被动"] = passive_skill

        return skills

    def _process_single_pet_skill(self, skill_id):
        """处理单个魔灵技能"""
        # 获取Skill数据
        skill = self.skill_data.get(str(skill_id), {})
        if not skill or not isinstance(skill, list) or len(skill) == 0:
            return {}

        # 取技能等级1的数据
        skill_info = (
            skill[0][0]
            if isinstance(skill[0], list) and len(skill[0]) > 0
            else skill[0]
        )

        # 获取技能描述
        skill_desc = self.get_translated_text(skill_info.get("SkillDesc", ""))
        if not skill_desc:
            return {}

        # 处理技能描述中的特殊标记
        skill_desc = skill_desc.replace("<H>", "").replace("</>", "")

        # 获取技能描述参数
        desc_values = skill_info.get("SkillDescValues", [])

        # 计算技能参数值并替换占位符
        values = []
        if desc_values:
            for i, value in enumerate(desc_values):
                placeholder = f"#{i + 1}"
                param_value = None
                is_percent = False

                if isinstance(value, str):
                    if "$" in value:
                        # 处理 $...$%? 格式
                        expr_match = re.search(r"\$([^$]+)\$%?", value)
                        if expr_match:
                            expr = expr_match.group(1)
                            is_percent = value.endswith("%")
                            param_value = self._calculate_expr_value(
                                expr, skill_id, 1, "Skill"
                            )
                            if is_percent:
                                param_value = param_value / 100
                    else:
                        # 直接计算表达式
                        param_value = self._calculate_expr_value(
                            value, skill_id, 1, "Skill"
                        )
                elif isinstance(value, (int, float)):
                    param_value = value

                if param_value is not None:
                    values.append(self.round_value(param_value))
                    # 替换占位符
                    if is_percent:
                        skill_desc = skill_desc.replace(placeholder, "{%}")
                    else:
                        skill_desc = skill_desc.replace(placeholder, "{}")

        return {"描述": skill_desc, "值": values}

    def _process_passive_skill(
        self, passive_desc, passive_effect_params, battle_pet_id
    ):
        """处理被动技能"""
        if not passive_desc:
            return {}

        # 获取翻译后的技能描述
        skill_desc = self.get_translated_text(passive_desc)

        # 计算技能参数值并替换占位符
        values = []
        if passive_effect_params:
            for i, value in enumerate(passive_effect_params):
                placeholder = f"#{i + 1}"
                param_value = None
                is_percent = False

                if isinstance(value, str) and "$" in value:
                    # 处理 $...$%? 格式
                    expr_match = re.search(r"\$([^$]+)\$%?", value)
                    if expr_match:
                        expr = expr_match.group(1)
                        is_percent = value.endswith("%")
                        param_value = self._calculate_expr_value(
                            expr, battle_pet_id, 1, "BattlePet"
                        )
                        if is_percent:
                            param_value = param_value / 100

                if param_value is not None:
                    values.append(self.round_value(param_value))
                    # 替换占位符
                    if is_percent:
                        skill_desc = skill_desc.replace(placeholder, "{%}")
                    else:
                        skill_desc = skill_desc.replace(placeholder, "{}")

        return {"描述": skill_desc, "值": values}

    def _parse_template_string(
        self, template_str, table_id, level, table_type, desc_values=None
    ):
        """解析模板字符串，替换其中的表达式"""
        import re

        if not isinstance(template_str, str):
            return {"描述": template_str}

        # 预处理表达式
        processed_str = self.preprocess_expression(template_str)

        # 替换 #1, #2, #3... 等占位符
        if desc_values:
            for i, value in enumerate(desc_values):
                placeholder = f"#{i + 1}"
                if placeholder in processed_str:
                    if isinstance(value, str) and "$" in value:
                        # 处理 $...$ 格式
                        def replace_expr(match):
                            expr = match.group(1)
                            param_value = self._calculate_expr_value(
                                expr, table_id, level, table_type
                            )
                            return str(self.round_value(param_value))

                        # 替换 $...$ 中的表达式，保留 $ 后面的内容
                        result = re.sub(r"\$([^$]+)\$", replace_expr, value)
                        processed_str = processed_str.replace(placeholder, result)
                    elif isinstance(value, str):
                        param_value = self._calculate_expr_value(
                            value, table_id, level, table_type
                        )
                        processed_str = processed_str.replace(
                            placeholder, str(self.round_value(param_value))
                        )
                    else:
                        processed_str = processed_str.replace(
                            placeholder, str(self.round_value(value))
                        )

        # 替换 $...$ 格式的表达式
        def replace_expr(match):
            expr = match.group(1)
            value = self._calculate_expr_value(expr, table_id, level, table_type)
            return str(self.round_value(value))

        result = re.sub(r"\$([^$]+)\$", replace_expr, processed_str)

        return {"描述": result}
