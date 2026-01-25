from processor.base_processor import BaseProcessor
from ast_parser import NodeType
import re


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
        # 加载技能升级所需材料数据
        self.skill_level_up_data = data_loader.load_json("SkillLevelUp.json")

        # 等级列表，用于显示属性
        self.levels = [1]

        # SkillDescHints 映射表
        self.skill_desc_hints_map = {
            "SkillEfficiency": "技能效益",
            "SkillIntensity": "技能威力",
            "SkillRange": "技能范围",
            "SkillSustain": "技能耐久",
        }

        # SkillEffects TaskEffects 字段名缩写映射
        # "" 表示排除该字段
        self.skill_effect_field_abbr = {
            # 排除的字段（内部使用或不必要）
            "Function": "fn",
            "TargetFilter": "",
            "DamageTag": "",
            "SEId": "",
            "CauseHit": "",
            "BossValue": "",
            "TaskId": "",
            "PassiveEffectId": "",
            # 需要缩写的字段
            "BaseAttr": "ba",
            "DamageType": "dt",
            "BaseChar": "bc",
            "FXId": "fx",
            "BuffId": "id",
            "LastTime": "lt",
            "SpChange": "sp",
            "Rate": "r",
            "Value": "v",
            "Condition": "co",
            "FunctionName": "fa",
            "TriggerProbability": "tp",
            "AllowSkillIntensity": "ai",
            "AllowSkillSustain": "as",
            "IsOverShield": "os",
        }

        # SkillEffects TaskEffects Function 黑名单
        self.skill_effect_function_blacklist = {
            "PlayFX",
            "PlaySE",
            "MakeSound",
            "CameraShake",
            "AdditionalHitFX",
            "GatherTargets",
            "PlayForceFeedback",
            "PlayUIAnim",
            "SetFloat",
            # 以下这些都是需要保留处理的
            # "ExecutePassiveFunctio",
            # "CutToughness",
            # "Damage",
            # "Heal",
            # "AddEnergyShield",
            # "AddSp",
            # "AddBuff",
            # "RemoveBuff",
            # "CreateSkillCreature",
            # "CreateDanmaku",
        }

        # PassiveEffect 字段名缩写映射
        # "" 表示排除该字段
        self.passive_effect_field_abbr = {
            "ID": "id",
            "UniquePassive": "up",
            "BPPath": "",
            "Vars": "v",
            "VarSkillLevelSource": "",  # 排除 VarSkillLevelSource（内部使用）
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
            name = f"主角-{elm}"
        # 构建基础处理后的Char数据
        processed = {
            "id": char_id,
            "icon": char_data.get("Icon", "").replace(
                "/Game/UI/Texture/Dynamic/Image/Head/Avatar/T_Head_", ""
            ),
            "名称": name,
            "版本": self.process_release(char_data.get("ReleaseVersion", 100)),
            "别名": self.get_translated_text(char_data.get("CharSubtitle", "")),
            "阵营": self._process_camp(char_data.get("Camp", "None")),
            "属性": elm,
            "精通": self._process_mastery(battle_char.get("ExcelWeaponTags", [])),
            "标签": self.process_tags(battle_char.get("Positioning", [])),
            "基础攻击": base_attr.get("攻击", 0),
            "基础生命": base_attr.get("生命", 0),
            "基础防御": base_attr.get("防御", 0),
            "基础护盾": base_attr.get("护盾", 0),
            "基础神智": base_attr.get("神智", 0),
            "加成": self._process_addon(battle_char.get("CharAddonAttr", [])),
            "突破": self._process_break(char_id, language),
            "技能": self._process_skills(battle_char, language),
            "溯源": self._process_traces(battle_char, char_id),
            # "档案": self._process_character_data(char_id),
            "同律武器": self._process_u_weapon(char_data.get("UWeapon", [])),
        }
        if not processed["加成"]:
            del processed["加成"]
        if not processed["标签"]:
            del processed["标签"]
        if not processed.get("同律武器"):
            del processed["同律武器"]
        # if not processed.get("突破"):
        #     del processed["突破"]
        if not processed.get("溯源"):
            del processed["溯源"]
            return None

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

            # 处理图标，从Icon路径中提取图标名称
            icon_path = weapon.get("Icon", "")
            icon = ""
            if icon_path:
                # 提取T_Head_后面的值
                if "T_Head_" in icon_path:
                    icon_part = icon_path.split("T_Head_")[-1]
                    if "." in icon_part:
                        icon = icon_part.split(".")[0]
                    else:
                        icon = icon_part

            item = {
                "id": weapon_id,
                "名称": self.get_translated_text(weapon.get("WeaponName", "")),
                "类型": self.process_tags(tags),
                "icon": icon,
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
            fkey = self.get_translated_text(attr_name_key)
            fkeymap = {
                "武器暴击率": "暴击",
                "武器多重射击": "多重",
            }
            fkey = fkeymap.get(fkey, fkey)
            if rst.get(fkey):
                rst[fkey] += self.round_value(attr.get("Rate") or attr.get("Value", 0))
                continue
            rst[fkey] = self.round_value(attr.get("Rate") or attr.get("Value", 0))
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
            MaxSp = battle_char.get("MaxSp", 0)
            if MaxSp:
                level_attrs["神智"] = int(MaxSp)
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
            skill_info = self._process_single_skill(skill_id)
            if skill_info:
                skills.append(skill_info)

        return skills

    def _process_skill_level_up(self, skill_id):
        """处理技能升级所需材料"""
        # 从SkillLevelUp.json获取技能升级数据
        skill_level_up = self.skill_level_up_data.get(str(skill_id), [])
        if not skill_level_up:
            return []

        level_up_materials = []

        for level_data in skill_level_up:
            skill_level = level_data.get("SkillLevel", 0)
            item_ids = level_data.get("ItemId", [])
            item_nums = level_data.get("ItemNum", [])

            if not item_ids or not item_nums:
                continue

            level_materials = {}

            for i, item_id in enumerate(item_ids):
                if i >= len(item_nums):
                    continue

                # 获取材料名称
                resource_name = self.data_loader.get_resource_name(item_id)
                if not resource_name:
                    resource_name = str(item_id)

                level_materials[resource_name] = item_nums[i]

            if level_materials:
                level_up_materials.append(level_materials)

        return level_up_materials

    def _process_single_skill(self, skill_id):
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
        skill_desc = (
            self.get_translated_text(skill_desc_key)
            .replace("<H>", "")
            .replace("</>", "")
        )

        # 获取技能最大等级
        max_level = min(
            self._get_skill_max_level(skill_id),
            12,
        )

        # 从SkillBtnIcon获取技能图标，提取Skill_后面的值
        skill_icon = skill_info.get("SkillBtnIcon", "")
        if skill_icon and "Skill_" in skill_icon:
            skill_icon = skill_icon.split("Skill_")[-1]

        result = {
            "id": skill_id,
            "名称": skill_name,
            "类型": self.get_translated_text(skill_info.get("SkillBtnDesc", "")),
            "描述": skill_desc,
            "icon": skill_icon,
        }

        if not result.get("名称"):
            del result["名称"]
        if not result.get("描述"):
            del result["描述"]

        if skill_info.get("CD"):
            result["cd"] = skill_info.get("CD")

        # 处理技能特效解析
        skill_effects = self._process_skill_effects(skill_info, skill_id, max_level)
        if skill_effects:
            # 处理返回值结构，可能包含 e 和 b 两个字段
            if isinstance(skill_effects, dict):
                if skill_effects.get("e"):
                    result["e"] = skill_effects["e"]
                if skill_effects.get("b"):
                    result["b"] = skill_effects["b"]
            else:
                # 兼容旧格式（直接返回列表）
                result["e"] = skill_effects

        # 处理被动技能特效解析
        passive_effects = self._process_passive_effects(skill_info, skill_id, max_level)
        if passive_effects:
            result["p"] = passive_effects

        # 使用新的紧凑格式处理技能等级描述
        level_desc = self.process_skill_desc(skill_info, skill_id, max_level)
        if level_desc:
            result["字段"] = level_desc

        # 处理技能升级材料
        skill_level_up = self._process_skill_level_up(skill_id)
        if skill_level_up:
            result["升级"] = skill_level_up

        # 处理战斗术语解释
        explanation_ids = skill_info.get("ExplanationId", [])
        if explanation_ids:
            explanations = {}
            for term_id in explanation_ids:
                term_data = self.combat_term_data.get(str(term_id), {})
                if term_data:
                    term_key = term_data.get("CombatTerm", "")
                    term_explain_key = term_data.get("CombatTermExplaination", "")

                    term_name = self.get_translated_text(term_key)
                    term_desc = self.get_translated_text(term_explain_key)

                    explanations[term_name] = term_desc
            if explanations:
                result["术语解释"] = explanations

        # 处理子技能
        sub_skills = skill_info.get("SubSkills", [])
        if sub_skills:
            processed_sub_skills = []
            for sub_skill_id in sub_skills:
                sub_skill_data = self._process_single_skill(sub_skill_id)
                if sub_skill_data:
                    # 过滤条件：去除属性与父技能相同或为空的子技能
                    # 当子技能的某个属性为空时，视为与父技能相同
                    is_different = False
                    for key, sub_value in sub_skill_data.items():
                        # 跳过id和子技能字段
                        if key in ["id", "子技能"]:
                            continue
                        # 获取父技能对应属性值
                        parent_value = result.get(key)
                        # 比较规则：
                        # 1. 如果父技能没有该属性，且子技能属性值不为空，则视为不同
                        # 2. 如果父技能有该属性，且子技能属性值与父技能不同（空值视为相同），则视为不同
                        if key not in result:
                            # 父技能没有该属性，子技能有该属性且不为空，则不同
                            if sub_value:
                                is_different = True
                                break
                        else:
                            # 父技能有该属性，比较值
                            # 子技能空值视为与父技能相同
                            if sub_value and parent_value != sub_value:
                                is_different = True
                                break

                    # 只有当子技能与父技能存在差异时，才添加到结果中
                    if is_different:
                        processed_sub_skills.append(sub_skill_data)
            if processed_sub_skills:
                result["子技能"] = processed_sub_skills

        return result

    def _parse_buff_detail(
        self,
        buff_id,
        buff_detail,
        function_name,
        grow_source,
        max_level,
        source_id=None,
    ):
        """解析buff详细信息

        统一解析buff的AddAttrs、HaloDatas、DotDatas、LastTime等字段

        Args:
            buff_id: buff ID
            buff_detail: buff详细数据（从Buff.json获取）
            function_name: 函数名（AddBuff或RemoveBuff）
            grow_source: 增长数据源（"SkillEffects" 或 "Buff"）
            max_level: 最大等级
            source_id: 源ID（用于查找增长数据，默认为None时使用buff_id）

        Returns:
            dict: 解析后的buff数据
        """
        if not buff_detail:
            return None

        buff_data = {"fn": function_name}

        # 确定用于查找增长数据的ID
        lookup_id = source_id if source_id is not None else buff_id

        # 解析 AddAttrs
        add_attrs = buff_detail.get("AddAttrs", [])
        attrs_list = []
        if add_attrs:
            for attr in add_attrs:
                attr_name = attr.get("AttrName", "")
                attr_value = attr.get("Rate") or attr.get("Value", 0)
                attr_value = self._process_placeholder(
                    attr_value,
                    lookup_id,
                    max_level,
                    grow_source,
                )
                if attr_value is not None:
                    val = {"k": attr_name, "v": attr_value}
                    if attr.get("RateZone"):
                        val["z"] = attr["RateZone"]
                    if attr.get("Type"):
                        val["t"] = attr["Type"]
                    attrs_list.append(val)

        if attrs_list:
            buff_data["t"] = attrs_list

        # 解析 HaloDatas
        halo_datas = buff_detail.get("HaloDatas", [])
        if halo_datas:
            aura_list = []
            for halo in halo_datas:
                halo_item = {}
                if "BuffId" in halo:
                    bid = halo["BuffId"]
                    halo_item["id"] = bid
                    # For nested buffs in HaloDatas, use the buff's own ID to look up SkillGrow data
                    # not the parent's task_id (lookup_id)
                    halo_item["t"] = self._parse_buff_detail(
                        bid,
                        self.buff_data.get(str(bid), {}),
                        function_name,
                        "Buff",  # Nested buffs always use Buff source
                        max_level,
                        bid,  # Use the nested buff's ID for SkillGrow lookup
                    )
                if "AuraRange" in halo:
                    halo_item["range"] = halo["AuraRange"]
                if "Camp" in halo:
                    halo_item["camp"] = halo["Camp"]
                if halo_item:
                    aura_list.append(halo_item)
            if aura_list:
                buff_data["aura"] = aura_list

        # 解析 DotDatas
        dot_list = []
        dot_datas = buff_detail.get("DotDatas", [])
        if dot_datas:
            for dot in dot_datas:
                dot_item = {}
                for key, value in dot.items():
                    key_abbr = {
                        "Type": "t",
                        "AllowSkillIntensity": "asi",
                        "Interval": "it",
                        "Rate": "r",
                        "Value": "v",
                        "DamageType": "dt",
                        "DamageTag": "dg",
                        "EnableIcon": "ei",
                        "Immediately": "im",
                        "DefaultHealFX": "h",
                        "Condition": "c",
                        "DotDelay": "d",
                    }.get(key, key)
                    # 处理占位符
                    values = self._process_placeholder(
                        value,
                        lookup_id,
                        max_level,
                        "Buff",
                    )

                    dot_item[key_abbr] = values
                    # Only add dot entry if it has meaningful damage data (Rate or Value)
                    # Skip dot entries that only have EffectId, Interval, Type, etc. (these are just references)
                    if dot_item and ("r" in dot_item or "v" in dot_item):
                        dot_list.append(dot_item)
        if dot_list:
            # Dot 数据添加到 t 字段
            if "dot" not in buff_data:
                buff_data["dot"] = dot_list

        # 解析 LastTime
        last_time = buff_detail.get("LastTime")
        if last_time is not None:
            buff_data["lt"] = last_time

        return buff_data

    def _process_skill_effects(self, skill_info, skill_id, max_level):
        """处理技能特效解析

        从技能的SkillEffectsList字段解析SkillEffects引用，
        使用黑名单模式过滤Function，只保留需要的类型
        解析Buff/RemoveBuff到buff字段，CreateSkillCreature和CreateDanmaku

        返回格式: [{id: task_id, t: [{ba: "ATK_Char", rate: [1,2,3,...]}, {buff: [...]}, {cid: ...}, {dm: [...}] }]

        Args:
            skill_info: 单个技能数据
            skill_id: 技能ID
            max_level: 最大等级

        Returns:
            list: 解析后的技能特效数组
        """
        desc_values = skill_info.get("SkillDescValues", [])
        if not desc_values:
            return None

        # 收集所有引用的SkillEffects ID和Buff ID
        effect_ids = set()
        buff_ids = set()
        # 收集 e 字段中已处理的 Buff ID（用于去重）
        buff_ids_in_e = set()
        import re

        for desc_value in desc_values:
            if isinstance(desc_value, str):
                # 查找所有 SkillEffects[id] 模式
                matches = re.findall(r"SkillEffects\[(\d+)\]", desc_value)
                effect_ids.update([int(m) for m in matches])

                # 查找所有 Buff[id] 模式
                buff_matches = re.findall(r"Buff\[(\d+)\]", desc_value)
                buff_ids.update([int(m) for m in buff_matches])

        if not effect_ids and not buff_ids:
            return None

        # 构建结果数组
        effects_result = []

        # 首先处理 SkillEffects，收集其中 AddBuff/RemoveBuff 的 buff_id
        for task_id in effect_ids:
            # 获取 SkillEffects 数据
            effect_data = self.skill_effects_data.get(str(task_id))
            if not effect_data:
                continue

            # 解析 TaskEffects
            task_effects = effect_data.get("TaskEffects", [])
            if not task_effects:
                continue

            # 为每个 task_effect 收集所有等级的数据
            task_effects_result = []

            for task_effect in task_effects:
                # 检查 Function 是否在黑名单中
                function_name = task_effect.get("Function", "")
                if (
                    not function_name
                    or function_name in self.skill_effect_function_blacklist
                ):
                    continue

                # 处理 AddBuff/RemoveBuff - 解析到 {fn,bid,t:[{k,v}]} 格式
                if function_name in ["AddBuff", "RemoveBuff"]:
                    buff_id = task_effect.get("BuffId", None)
                    if buff_id is not None:
                        # 解析 buff 详细数据
                        buff_data = {}
                        buff_id_value = (
                            buff_id[0] if isinstance(buff_id, list) else buff_id
                        )

                        # 查找 buff 详情
                        buff_id_value = (
                            buff_id[0] if isinstance(buff_id, list) else buff_id
                        )
                        buff_detail = self.buff_data.get(str(buff_id_value))

                        # 使用统一的函数解析 buff
                        buff_data = self._parse_buff_detail(
                            buff_id=buff_id,
                            buff_detail=buff_detail,
                            function_name=function_name,
                            grow_source="SkillEffects",
                            max_level=max_level,
                            source_id=task_id,
                        )

                        if buff_data:
                            task_effects_result.append(buff_data)
                    continue

                # 处理 CreateSkillCreature - 解析 CreatureId 并获取详细数据
                if function_name == "CreateSkillCreature":
                    creature_id = task_effect.get("CreatureId")
                    if creature_id is not None:
                        creature_data = {"fn": function_name, "cid": creature_id}

                        # 从 SkillCreature.json 获取详细数据
                        sc_data = self.skill_creature_data.get(str(creature_id))
                        if sc_data:
                            # 解析相关字段（跳过 BPPath 和其他内部字段）
                            sc_field_abbr = {
                                "Type": "tp",
                                "LifeTime": "lt",
                                "Radius": "r",
                                "Height": "h",
                                "AttackRange": "ar",
                                "Speed": "sp",
                                "Tags": "tg",
                            }
                            for field_name, field_value in sc_data.items():
                                # 处理 ShapeInfo（重要数据）
                                if field_name == "ShapeInfo" and isinstance(
                                    field_value, dict
                                ):
                                    shape_info = {}
                                    # ShapeInfo 包含 ShapeType 和具体尺寸数据
                                    shape_type = field_value.get("ShapeType")
                                    if shape_type:
                                        shape_info["st"] = shape_type

                                    # Sphere 类型
                                    if "Radius" in field_value:
                                        shape_info["r"] = field_value["Radius"]

                                    # Box 类型
                                    if "BoxHeight" in field_value:
                                        shape_info["h"] = field_value["BoxHeight"]
                                    if "BoxLength" in field_value:
                                        shape_info["l"] = field_value["BoxLength"]
                                    if "BoxWidth" in field_value:
                                        shape_info["w"] = field_value["BoxWidth"]

                                    # Capsule 类型
                                    if "CapsuleRadius" in field_value:
                                        shape_info["cr"] = field_value["CapsuleRadius"]
                                    if "CapsuleHalfHeight" in field_value:
                                        shape_info["ch"] = field_value[
                                            "CapsuleHalfHeight"
                                        ]

                                    if shape_info:
                                        creature_data["si"] = shape_info
                                    continue

                                # 处理其他字段
                                if field_name in sc_field_abbr:
                                    field_abbr = sc_field_abbr[field_name]
                                    if field_value is not None and field_value != "":
                                        if isinstance(field_value, (int, float)):
                                            creature_data[field_abbr] = field_value
                                        elif isinstance(field_value, list):
                                            creature_data[field_abbr] = field_value
                                        else:
                                            creature_data[field_abbr] = str(field_value)

                        # 处理 TaskEffects 中的其他字段
                        for field_name, field_value in task_effect.items():
                            if field_name == "Function":
                                continue
                            if field_name == "CreatureId":
                                continue
                            # 处理其他字段（BaseChar, Direction, Distance, Location, Rotation, UseBattlePointId）
                            field_abbr = field_name[
                                :2
                            ].lower()  # 简单缩写：BaseChar->bc, Direction->dr, etc.
                            if field_value is not None and field_value != "":
                                if isinstance(field_value, (int, float)):
                                    creature_data[field_abbr] = field_value
                                elif isinstance(field_value, list):
                                    creature_data[field_abbr] = field_value
                                else:
                                    creature_data[field_abbr] = str(field_value)

                        if creature_data:
                            task_effects_result.append(creature_data)
                    continue

                # 处理 CreateDanmaku - 解析 DanmakuTemplateId 并获取详细数据
                if function_name == "CreateDanmaku":
                    danmaku_data = {"fn": function_name}

                    # 处理 TaskEffects 中的字段
                    for field_name, field_value in task_effect.items():
                        if field_name == "Function":
                            continue
                        if (
                            field_name == "DanmakuTemplateId"
                            and field_value is not None
                        ):
                            danmaku_data["dm"] = field_value
                        elif field_name == "Duration" and field_value is not None:
                            danmaku_data["lt"] = field_value
                        elif field_value is not None and field_value != "":
                            # 处理其他字段
                            field_abbr = field_name[:2].lower()
                            if isinstance(field_value, (int, float)):
                                danmaku_data[field_abbr] = field_value
                            else:
                                danmaku_data[field_abbr] = str(field_value)

                    if danmaku_data:
                        task_effects_result.append(danmaku_data)
                    continue

                # 处理 ExecutePassiveFunction - inline 解析 PassiveEffect
                if function_name == "ExecutePassiveFunction":
                    passive_effect_id = task_effect.get("PassiveEffectId")
                    if passive_effect_id is not None:
                        # 获取 PassiveEffect 数据
                        pe_data = self.passive_effect_data.get(str(passive_effect_id))
                        if pe_data:
                            pe_result = {}
                            # 处理 Vars 字段
                            vars_data = pe_data.get("Vars", {})
                            if vars_data:
                                vars_result = {}
                                for var_name, var_value in vars_data.items():
                                    # Use PassiveEffect table type for growth data
                                    val = self._process_placeholder(
                                        var_value,
                                        passive_effect_id,
                                        max_level,
                                        "PassiveEffect",
                                    )
                                    if val is not None:
                                        vars_result[var_name] = val

                                pe_result["pe"] = vars_result

                            if pe_result:
                                task_effects_result.append(pe_result)
                    continue

                # 其他Function类型：正常处理字段
                effect_data_by_level = {}

                for field_name, field_value in task_effect.items():
                    # 获取字段缩写
                    field_abbr = self.skill_effect_field_abbr.get(
                        field_name, field_name
                    )

                    # 如果缩写为空字符串，跳过该字段
                    if not field_abbr:
                        continue
                    # 处理占位符 #1, #2 等 - 收集所有等级的值
                    val = self._process_placeholder(
                        field_value, task_id, max_level, "SkillEffects"
                    )
                    if val is not None:
                        if (
                            val
                            == "$Source:GetRootSource():GetFloat('Skill04TriggerRate')$"
                        ):
                            val = 0.5
                        if (
                            val
                            == "$Source:GetRootSource():GetFloat('Xibi_Skill04_Rate')$"
                        ):
                            val = "近战触发"
                        if (
                            val
                            == "$Source:GetFloat('LinenSkill02ShootRate')*Source:GetCurrentWeaponAttr('MultiShoot', 1)$"
                        ):
                            val = [
                                1.27,
                                1.41,
                                1.55,
                                1.69,
                                1.83,
                                1.97,
                                2.11,
                                2.25,
                                2.39,
                                2.53,
                                2.67,
                                2.81,
                            ]
                        effect_data_by_level[field_abbr] = val

                if effect_data_by_level:
                    task_effects_result.append(effect_data_by_level)

            if task_effects_result:
                effects_result.append({"id": task_id, "t": task_effects_result})

        # 构建buff引用数组（存储在新的b字段中）
        buffs_result = []

        # 处理从 SkillDescValues 中收集的 Buff 引用
        for buff_id in buff_ids:
            # 跳过已在 e 字段中处理的 Buff ID（去重）
            if buff_id in buff_ids_in_e:
                continue

            # 获取 Buff 数据
            buff_detail = self.buff_data.get(str(buff_id))
            if not buff_detail:
                continue

            # 使用统一的函数解析 buff
            buff_data = self._parse_buff_detail(
                buff_id=buff_id,
                buff_detail=buff_detail,
                function_name="AddBuff",
                grow_source="Buff",
                max_level=max_level,
                source_id=None,
            )

            if buff_data:
                buffs_result.append({"id": buff_id, "t": [buff_data]})

        return {"e": effects_result, "b": buffs_result}

    def _process_placeholder(self, field_value, passive_id, max_level, table):
        """处理占位符替换

        替换字段值中的占位符（如 #1, #2 等）为实际值

        Args:
            field_value: 包含占位符的字段值

        Returns:
            int|int[]: 替换占位符后的字段值
        """
        # 处理占位符 #1, #2 等
        if isinstance(field_value, str) and field_value.startswith("#"):
            placeholder = field_value
            placeholder_match = re.match(r"#(\d+)", placeholder)
            if placeholder_match:
                param_index = int(placeholder_match.group(1))

                # 收集所有等级的值
                values = []
                grow_data = self.skill_grow_data.get(table, {})
                grow_entry = grow_data.get(str(passive_id))

                if grow_entry and isinstance(grow_entry, list):
                    for level in range(1, max_level + 1):
                        level_index = level - 1
                        if level_index < len(grow_entry):
                            level_data = grow_entry[level_index]
                            # Handle both list and dict formats for level_data
                            if isinstance(level_data, list) and len(level_data) > 0:
                                # level_data is a list of dicts: [{"ID":..., "Index": N, "Value":...}, ...]
                                # Need to find the dict where Index matches param_index
                                found = False
                                for item in level_data:
                                    if (
                                        isinstance(item, dict)
                                        and item.get("Index") == param_index
                                    ):
                                        values.append(item.get("Value", field_value))
                                        found = True
                                        break
                                if not found:
                                    values.append(field_value)
                            elif isinstance(level_data, dict):
                                # Dict format: {"index": {"ID":..., "Value":...}}
                                param_key = str(param_index)
                                if param_key in level_data:
                                    param_data = level_data[param_key]
                                    if isinstance(param_data, dict):
                                        values.append(
                                            param_data.get("Value", field_value)
                                        )
                                    else:
                                        values.append(field_value)
                                else:
                                    values.append(field_value)
                            else:
                                values.append(field_value)
                        else:
                            values.append(field_value)

                # 判断值是否全相同
                if values:
                    numeric_values = []
                    for v in values:
                        try:
                            numeric_values.append(float(v))
                        except (ValueError, TypeError):
                            numeric_values.append(v)

                    if all(isinstance(v, (int, float)) for v in numeric_values):
                        all_same = all(
                            abs(v - numeric_values[0]) < 0.0001 for v in numeric_values
                        )
                    else:
                        all_same = all(v == numeric_values[0] for v in numeric_values)

                    if all_same:
                        return values[0]
                    else:
                        return values
        else:
            # 非占位符值，直接保存
            if field_value is not None and field_value != "":
                return field_value

    def _process_passive_effects(self, skill_info, skill_id, max_level):
        """处理被动技能特效解析

        从技能的PassiveEffects字段解析PassiveEffect引用，
        提取字段名并简化缩写后存储
        处理占位符 #1, #2 等，使用技能成长数据填入

        返回格式: [{id: passive_id, v: [{k,v}]}]

        Args:
            skill_info: 单个技能数据
            skill_id: 技能ID
            max_level: 最大等级

        Returns:
            list: 解析后的被动技能特效数组
        """
        passive_effects_list = skill_info.get("PassiveEffects")
        if not passive_effects_list:
            return None

        # 构建结果数组
        effects_result = []

        for passive_id in passive_effects_list:
            # 获取 PassiveEffect 数据
            effect_data = self.passive_effect_data.get(str(passive_id))
            if not effect_data:
                continue

            effect_data_by_level = {}

            # 遍历所有字段并简化缩写
            for field_name, field_value in effect_data.items():
                # 获取字段缩写
                field_abbr = self.passive_effect_field_abbr.get(field_name, field_name)

                # 如果缩写为空，跳过
                if not field_abbr:
                    continue

                # 处理 Vars 字段
                if isinstance(field_value, dict) and field_name == "Vars":
                    vars_result = {}
                    for var_name, var_value in field_value.items():
                        vars_result[var_name] = self._process_placeholder(
                            var_value, passive_id, max_level, "PassiveEffect"
                        )

                    if vars_result:
                        effect_data_by_level[field_abbr] = vars_result
                    continue

                # 处理普通字段
                processed_value = self._process_placeholder(
                    field_value, passive_id, max_level, "PassiveEffect"
                )
                if processed_value is not None:
                    effect_data_by_level[field_abbr] = processed_value
            if effect_data_by_level:
                effects_result.append(effect_data_by_level)

        return effects_result if effects_result else None

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
        result = result.replace("{%}%", "{%}")

        # 如果没有占位符或只有一个占位符且没有其他文本，返回 None
        if placeholder_count == 0:
            return None
        if placeholder_count == 1 and result in ("{%}"):
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
        skill_desc_groups = skill_info.get("SkillDescGroups", [])

        if not desc_keys or not desc_values:
            return []

        # 处理SkillDescGroups，获取每个组的翻译名称和对应的项目索引
        group_mapping = {}
        if skill_desc_groups:
            # 遍历每个技能描述组
            for group_data in skill_desc_groups:
                if isinstance(group_data, dict):
                    # 获取字典中的唯一键作为GroupNameKey
                    for group_name_key, item_indices in group_data.items():
                        # 获取组名称的翻译
                        group_name = self.get_translated_text(group_name_key)
                        if not group_name:
                            continue

                        # 将每个项目索引映射到对应的组名称
                        for idx in item_indices:
                            # 注意：索引从1开始，需要转换为从0开始
                            group_mapping[idx - 1] = group_name

                else:
                    # 如果不是字典，跳过
                    continue

        result = []

        for i, desc_key in enumerate(desc_keys):
            if i >= len(desc_values):
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)

            # 如果该项目属于某个组，添加组名称前缀
            if i in group_mapping:
                desc_text = f"[{group_mapping[i]}]{desc_text}"
                desc_text = re.sub(r"\[.*?\]\[", "[", desc_text)

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

            result.append({"名称": desc_text, **item})

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
            expr_match = re.search(
                re.escape("$")
                + "(-)?([^"
                + re.escape("$")
                + "]+)"
                + re.escape("$")
                + "(.*)",
                desc_value,
            )
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
            return []

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

                    expr_match = re.search(
                        re.escape("$")
                        + "(-)?([^"
                        + re.escape("$")
                        + "]+)"
                        + re.escape("$")
                        + "(.*)",
                        parameter,
                    )
                    if expr_match:
                        has_neg = expr_match.group(1)
                        expr = expr_match.group(2)
                        suffix = expr_match.group(3)

                        try:
                            # 使用 _calculate_expr_value 计算表达式
                            expr_value = self._calculate_expr_value(
                                expr, char_id, 1, "BattleChar"
                            )
                            expr_value = self.round_value(expr_value)
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
