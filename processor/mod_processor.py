from processor.base_processor import BaseProcessor
from processor._util import P_MAP, get_attr_config_key_from_attr_data
import re
import os
import json
import glob
import math


class ModProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Mod"
        # 加载AttrConfig数据，用于获取中文属性名称
        self.attr_config = self.data_loader.load_json("AttrConfig.json")
        # 加载i18n数据，用于翻译属性名称
        self.i18n_data = self.data_loader.load_json("TextMap_I18n.json")
        # 加载SkillGrow配置，用于计算字符串类型的属性值
        self.skill_grow_data = self.data_loader.load_json("SkillGrow.json")
        self.skill_data = self.data_loader.load_json("Skill.json")
        self.skill_effects_data = self.data_loader.load_json("SkillEffects.json")
        self.skill_node_data = self.data_loader.load_json("SkillNode.json")
        self._project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self._asset_root = os.path.join(self._project_root, "out", "Asset")
        self._anim_path_cache = {}
        self._anim_meta_cache = {}

        # 品质名称映射
        self.quality_names = ["白", "绿", "蓝", "紫", "金"]
        # 极性值映射
        self.polarity_values = ["", "A", "D", "V", "O"]
        self.p_map = P_MAP

    def _format_desc_numeric(self, value):
        """格式化描述数值，避免固定1位小数导致精度丢失"""
        if not isinstance(value, (int, float)):
            return "0.0"

        rounded = self.round_value(float(value))
        if isinstance(rounded, int):
            return f"{rounded:.1f}"

        text = f"{rounded:.4f}".rstrip("0").rstrip(".")
        if "." not in text:
            text = f"{text}.0"
        return text

    def process_item(self, item_data, language):
        mod_data = item_data
        # 获取ModTag信息
        mod_tag_info = self.data_loader.get_mod_tag_info(
            mod_data.get("ApplicationType", 0)
        )
        mod_tag_text = [
            self.get_translated_text(tag) for tag in mod_tag_info.get("ModTagText", [])
        ]

        # 计算耐受值
        cost = mod_data.get("Cost", 0)
        max_level = mod_data.get("MaxLevel", 0)
        max_level += mod_data.get("ModCardLevelMax", 0)
        cost_change = mod_data.get("CostChange", 1)
        tolerance = cost + max_level * cost_change

        # 处理类型名称，提取系列
        type_name = self.get_translated_text(mod_data.get("TypeName", ""))
        # 处理品质和极性
        rarity = mod_data.get("Rarity", 1)
        # 使用品质名称映射
        quality_level = min(rarity - 1, len(self.quality_names) - 1)  # 确保在有效范围内
        quality = self.quality_names[quality_level]

        # 使用极性值映射
        polarity_value = mod_data.get("Polarity", -1)
        polarity_level = max(
            0, min(len(self.polarity_values) - 1, polarity_value)
        )  # 确保在有效范围内
        polarity = self.polarity_values[polarity_level]

        # 处理属性
        attribute = ""
        if len(mod_tag_text) >= 2:
            attribute = mod_tag_text[1].replace("属性", "").strip()

        # 处理类型
        mod_type = mod_tag_text[0] if mod_tag_text else ""
        if mod_type in self.p_map:
            mod_type = self.p_map[mod_type]

        # 构建基础处理后的Mod数据
        processed = {
            "id": mod_data.get("Id", 0),
            "icon": mod_data.get("Icon", "")
            .replace("/Game/UI/Texture/Dynamic/Atlas/Prop/Mod/T_Mod_", "")
            .split(".")[0],
            "名称": self.get_translated_text(mod_data.get("Name", "")).replace(
                "【待包装】", ""
            ),
            "版本": self.process_release(mod_data.get("ReleaseVersion", 100)),
            "系列": type_name.replace("之", ""),
            "品质": quality,
        }

        # 只有当属性不为空时才添加属性字段
        if polarity:
            processed["极性"] = polarity
        if attribute:
            processed["属性"] = attribute

        processed["耐受"] = tolerance
        processed["类型"] = mod_type

        if mod_data.get("CardLevelNeedModId"):
            processed["消耗"] = mod_data.get("CardLevelNeedModId")

        # 处理AddAttrs，根据CalcModAttrByLevel逻辑计算属性值
        add_attrs = mod_data.get("AddAttrs", [])
        for attr in add_attrs:
            attr_name = attr.get("AttrName", "")
            if not attr_name:
                continue

            # 获取中文属性名称
            attr_key = get_attr_config_key_from_attr_data(attr, self.attr_config)
            attr_config = self.attr_config.get(attr_key, {})
            attr_name_key = attr_config.get("Name", "")
            attr_chinese_name = self._translate_attribute_name(attr_name_key, language)

            # 处理BonusDamage_xxx转换为属性伤
            if attr_name.startswith("BonusDamage_"):
                attr_chinese_name = "追加伤害"
            elif not attr_chinese_name:
                attr_chinese_name = attr_name
            if attr_chinese_name in ["切割攻击", "贯穿攻击", "震荡攻击"]:
                processed["限定"] = attr_chinese_name[:2]
            attr_chinese_name = self.p_map.get(attr_chinese_name, attr_chinese_name)

            # 计算属性值（根据CalcModAttrByLevel逻辑）
            attr_value = self._calc_mod_attr_by_level(
                attr, mod_data.get("Id", 0), max_level
            )

            if attr_chinese_name == "攻击范围":
                attr_value /= 100
                if isinstance(attr_value, float) and attr_value.is_integer():
                    attr_value = int(attr_value)

            # 添加到processed中
            if attr_chinese_name == "受到的伤害":
                attr_chinese_name = "减伤"
                processed[attr_chinese_name] = -attr_value
            else:
                processed[attr_chinese_name] = attr_value

        # 处理PassiveEffectsDesc，解析DescValues并填入占位符
        self._process_passive_effects_desc(mod_data, processed)

        # 处理技能替换（ModActivateSkills）
        skill_replacements = self._process_mod_activate_skills(mod_data, language)
        if skill_replacements:
            processed["技能替换"] = skill_replacements

        return processed

    def _process_mod_activate_skills(self, mod_data, language):
        """处理ModActivateSkills，输出技能替换映射"""
        activate_skills = mod_data.get("ModActivateSkills")
        if not isinstance(activate_skills, dict) or not activate_skills:
            return {}

        replacements = {}
        for old_skill_id, new_skill_id in activate_skills.items():
            try:
                normalized_old_id = int(old_skill_id)
            except (TypeError, ValueError):
                normalized_old_id = old_skill_id

            try:
                normalized_new_id = int(new_skill_id)
            except (TypeError, ValueError):
                normalized_new_id = new_skill_id

            replacements[str(old_skill_id)] = self._build_skill_replace_info(
                normalized_old_id, normalized_new_id, language
            )

        return replacements

    def _build_skill_replace_info(self, old_skill_id, new_skill_id, language):
        """构建单个替换技能信息，结构与武器技能一致"""
        old_skill_entry = self._get_skill_entry(old_skill_id)
        new_skill_entry = self._get_skill_entry(new_skill_id)

        replace_name = self._get_skill_display_name(
            old_skill_entry, old_skill_id, language
        )
        fields = self._process_weapon_like_skill_fields(new_skill_entry, new_skill_id)

        result = {
            "id": new_skill_id,
            "名称": replace_name,
            "类型": "武器伤害",
        }
        if fields:
            result["字段"] = fields

        return result

    def _get_skill_entry(self, skill_id):
        """获取Skill表中的标准技能条目"""
        skill_info = self.skill_data.get(str(skill_id), {})
        if not skill_info:
            skill_info = self.skill_data.get(skill_id, {})

        if not isinstance(skill_info, list) or not skill_info:
            return {}

        entry = skill_info[0]
        if isinstance(entry, list) and entry:
            entry = entry[0]

        return entry if isinstance(entry, dict) else {}

    def _get_skill_display_name(self, skill_entry, skill_id, language):
        """获取技能显示名（名称前置技能ID）"""
        type_map = {
            "Shooting": "射击",
            "Attack": "普通攻击",
            "HeavyAttack": "蓄力攻击",
            "FallAttack": "下落攻击",
            "SlideAttack": "滑行攻击",
        }

        if not isinstance(skill_entry, dict):
            return str(skill_id)

        skill_name_key = skill_entry.get("SkillName", "")
        translated = (
            self.get_translated_text(skill_name_key, language) if skill_name_key else ""
        )
        if translated:
            return translated

        skill_type = skill_entry.get("SkillType", "")
        if skill_type:
            return type_map.get(skill_type, skill_type)

        return str(skill_id)

    def _process_weapon_like_skill_fields(self, skill_entry, table_id):
        """按武器技能逻辑解析字段"""
        if not isinstance(skill_entry, dict):
            return []

        desc_keys = skill_entry.get("SkillDescKeys", [])
        desc_values = skill_entry.get("SkillDescValues", [])
        if not desc_keys or not desc_values:
            return []

        if isinstance(desc_keys, dict):
            items = desc_keys.items()
        else:
            items = enumerate(desc_keys)

        result = []
        for key_or_index, desc_key in items:
            if isinstance(desc_values, dict):
                lookup_key = (
                    str(key_or_index + 1)
                    if isinstance(key_or_index, int)
                    else key_or_index
                )
                desc_value = desc_values.get(lookup_key)
            else:
                if key_or_index >= len(desc_values):
                    continue
                desc_value = desc_values[key_or_index]

            if desc_value is None:
                continue

            desc_text = self.get_translated_text(desc_key)
            preprocessed_desc_value = self.preprocess_expression(desc_value)
            calculated_value = self._parse_weapon_like_desc_value(
                preprocessed_desc_value, table_id, 1
            )

            value, value2, value_format = self._extract_field_value_and_format(
                calculated_value
            )
            item = {
                "名称": desc_text,
                "值": value,
            }
            if value2 is not None:
                item["值2"] = value2
            if value_format and value_format != "{%}":
                item["格式"] = value_format

            skill_effects_info = self._parse_skill_effects(desc_value)
            if skill_effects_info:
                cut_toughness = skill_effects_info.get("削韧", 0)
                delay = skill_effects_info.get("延迟", 0)
                hit_stop = skill_effects_info.get("卡肉", 0)
                if cut_toughness:
                    item["削韧"] = cut_toughness
                if delay:
                    item["延迟"] = delay
                if hit_stop:
                    item["卡肉"] = hit_stop

            result.append(item)

        cancels, combos = self._process_skill_timing(skill_entry, len(result))
        for i, item in enumerate(result):
            cancel = cancels[i] if i < len(cancels) else 0
            combo = combos[i] if i < len(combos) else 0
            if cancel:
                item["取消"] = cancel
            if combo:
                item["连段"] = combo

        return result

    def _parse_weapon_like_desc_value(self, desc_value, table_id, level):
        """按武器技能规则解析DescValue，支持多个$...$表达式"""
        result = desc_value
        pattern = r"\$(-)?(.*?)\$"
        matches = list(re.finditer(pattern, desc_value))

        for match in reversed(matches):
            expr_content = match.group(2)
            has_neg = match.group(1)

            after_match = result[match.end() :]
            suffix = ""
            for c in after_match:
                if c == "$":
                    break
                suffix += c

            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr_content)
            try:
                if math_match:
                    math_func = math_match.group(1)
                    inner_expr = math_match.group(2)

                    expr_value = self._calculate_expr_value(
                        inner_expr, table_id, level, "BattleWeapon"
                    )

                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:
                            processed_value = math.floor(expr_value)

                        if has_neg:
                            processed_value = -processed_value

                        formatted_value = self._format_desc_numeric(processed_value)
                    else:
                        formatted_value = "0.0"
                else:
                    expr_value = self._calculate_expr_value(
                        expr_content, table_id, level, "BattleWeapon"
                    )

                    if has_neg:
                        final_value = -expr_value
                    else:
                        final_value = expr_value

                    formatted_value = self._format_desc_numeric(final_value)

                result = (
                    result[: match.start()]
                    + f"{formatted_value}{suffix}"
                    + result[match.end() + len(suffix) :]
                )
            except Exception as e:
                print(f"表达式解析错误: {e}", flush=True)
                formatted_value = "0.0"
                result = (
                    result[: match.start()]
                    + f"{formatted_value}{suffix}"
                    + result[match.end() + len(suffix) :]
                )

        return result

    def _extract_field_value_and_format(self, calculated_value):
        """从格式化后的描述值中提取数值和格式模板"""
        if calculated_value is None:
            return 0, None, None

        text = str(calculated_value)
        matches = list(re.finditer(r"-?\d+(?:\.\d+)?", text))
        if not matches:
            return text, None, None

        def _prev_significant_char(source, index):
            i = index - 1
            while i >= 0 and source[i].isspace():
                i -= 1
            return source[i] if i >= 0 else ""

        values = []
        fmt_parts = []
        cursor = 0

        for match in matches:
            start, end = match.span()
            fmt_parts.append(text[cursor:start])

            raw_number = match.group(0)
            percent = end < len(text) and text[end] == "%"
            prev_char = _prev_significant_char(text, start)

            is_multiplier_constant = (
                prev_char in ("×", "x", "X", "*")
                and not percent
                and re.fullmatch(r"\d+", raw_number) is not None
                and len(values) >= 1
            )

            if is_multiplier_constant:
                fmt_parts.append(raw_number)
                cursor = end
                continue

            number_value = float(raw_number)
            if percent:
                values.append(self.round_value(number_value / 100.0))
                fmt_parts.append("{%}")
                cursor = end + 1
            else:
                values.append(self.round_value(number_value))
                fmt_parts.append("{}")
                cursor = end

        fmt_parts.append(text[cursor:])

        if not values:
            return text, None, None

        value = values[0]
        value2 = values[1] if len(values) > 1 else None
        value_format = "".join(fmt_parts) if fmt_parts else None
        return value, value2, value_format

    def _parse_skill_effects(self, desc_value):
        """解析desc_value中的SkillEffects引用，提取削韧/延迟/卡肉"""
        if not isinstance(desc_value, str):
            return {}

        result = {}
        visited_effect_ids = set()
        pattern = r"\$#SkillEffects\[(\d+)\]"
        matches = re.findall(pattern, desc_value)

        for effect_id_str in matches:
            effect_id = int(effect_id_str)
            if effect_id in visited_effect_ids:
                continue
            visited_effect_ids.add(effect_id)

            skill_effect = self.skill_effects_data.get(str(effect_id))
            if not skill_effect:
                skill_effect = self.skill_effects_data.get(effect_id)
            if not skill_effect:
                continue

            task_effects = skill_effect.get("TaskEffects", [])
            for task_effect in task_effects:
                func = task_effect.get("Function")
                if func == "HitStop":
                    delay = task_effect.get("Delay")
                    duration = task_effect.get("Duration")
                    if delay is not None:
                        result["延迟"] = delay
                    if duration is not None:
                        result["卡肉"] = duration
                if func == "CutToughness":
                    value = task_effect.get("Value")
                    if value is not None:
                        result["削韧"] = value

        return result

    def _process_skill_timing(self, skill_entry, field_count):
        """根据技能节点链表解析每段技能的取消窗口和连段"""
        if field_count <= 0:
            return [], []

        begin_node_id = skill_entry.get("BeginNodeId")
        if not begin_node_id:
            return [0] * field_count, [0] * field_count

        node_chain = self._collect_skill_node_chain(begin_node_id, field_count)
        if not node_chain:
            return [0] * field_count, [0] * field_count

        cancels = []
        combos = []
        for node in node_chain:
            anim_path = self._resolve_anim_json_path(node)
            cancel, combo = self._read_anim_duration_and_cancel(anim_path)
            cancels.append(cancel)
            combos.append(combo)

        while len(cancels) < field_count:
            cancels.append(cancels[-1] if cancels else 0)
            combos.append(combos[-1] if combos else 0)

        return cancels[:field_count], combos[:field_count]

    def _collect_skill_node_chain(self, begin_node_id, limit):
        """按NextNodeId遍历SkillNode链表，遇到环时停止"""
        nodes = []
        visited = set()
        current = begin_node_id

        while current and current not in visited and len(nodes) < max(limit, 1):
            node = self.skill_node_data.get(str(current), {})
            if not node:
                node = self.skill_node_data.get(current, {})
            if not node:
                break

            nodes.append(node)
            visited.add(current)
            current = node.get("NextNodeId")

        return nodes

    def _resolve_anim_json_path(self, node):
        """根据SkillNode中的动画信息定位动画JSON文件"""
        anim_resource = node.get("AnimResource") or node.get("AnimName")
        if not anim_resource:
            return None

        anim_path = node.get("AnimPath", "")
        anim_sub_path = node.get("AnimSubPath", "")
        cache_key = (anim_resource, anim_path, anim_sub_path)
        if cache_key in self._anim_path_cache:
            return self._anim_path_cache[cache_key]

        candidate = None

        if anim_path:
            normalized_path = anim_path.replace("\\", "/")
            marker = "/Game/Asset/"
            if marker in normalized_path:
                rel = normalized_path.split(marker, 1)[1].strip("/")
                direct_path = os.path.join(
                    self._asset_root,
                    *[p for p in rel.split("/") if p],
                    f"{anim_resource}.json",
                )
                if os.path.exists(direct_path):
                    candidate = direct_path

        if not candidate:
            sub_dir = [p for p in anim_sub_path.replace("\\", "/").split("/") if p]
            base_dir = os.path.join(
                self._asset_root,
                "Char",
                "Player",
                "*",
                "Animation",
                "Montage",
                *sub_dir,
            )

            patterns = [
                os.path.join(base_dir, f"{anim_resource}.json"),
                os.path.join(base_dir, f"*_{anim_resource}.json"),
            ]
            matches = []
            for pattern in patterns:
                matches.extend(glob.glob(pattern))

            if matches:
                matches = sorted(set(matches))
                candidate = matches[0]

        self._anim_path_cache[cache_key] = candidate
        return candidate

    def _read_anim_duration_and_cancel(self, anim_path):
        """读取动画JSON中的取消窗口和连段"""
        if not anim_path:
            return 0, 0

        if anim_path in self._anim_meta_cache:
            return self._anim_meta_cache[anim_path]

        cancel = 0.0
        combo = 0.0

        try:
            with open(anim_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            montage = data[0] if isinstance(data, list) and data else {}
            properties = montage.get("Properties", {})

            for notify in properties.get("Notifies", []):
                if notify.get("NotifyName") == "BP_SkillCancel_C":
                    link_value = notify.get("LinkValue")
                    if isinstance(link_value, (int, float)):
                        cancel = max(cancel, float(link_value))
                    elif isinstance(link_value, str):
                        stripped = link_value.strip()
                        if stripped:
                            try:
                                cancel = max(cancel, float(stripped))
                            except ValueError:
                                pass
                if notify.get("NotifyName") == "BP_NextCombo_C":
                    link_value = notify.get("LinkValue")
                    if link_value in (None, ""):
                        end_link = notify.get("EndLink")
                        if isinstance(end_link, dict):
                            link_value = end_link.get("LinkValue")
                    if isinstance(link_value, (int, float)):
                        combo = max(combo, float(link_value))
                    elif isinstance(link_value, str):
                        stripped = link_value.strip()
                        if stripped:
                            try:
                                combo = max(combo, float(stripped))
                            except ValueError:
                                pass

        except Exception as e:
            print(f"读取动画文件错误: {e}", flush=True)

        result = (self.round_value(cancel), self.round_value(combo))
        self._anim_meta_cache[anim_path] = result
        return result

    def _process_passive_effects_desc(self, mod_data, processed):
        """处理PassiveEffectsDesc，解析DescValues并填入占位符"""
        passive_effects_desc = self.get_translated_text(
            mod_data.get("PassiveEffectsDesc", "")
        )
        desc_values = mod_data.get("DescValues", [])

        if passive_effects_desc:
            # 解析PassiveEffectsDesc，将DescValues中的值填入占位符
            effect_desc = self._parse_passive_desc(
                passive_effects_desc, desc_values, mod_data
            )

            # 将结果填入"效果"字段
            processed["效果"] = effect_desc.replace("<Polarity>", "").replace("</>", "")

    def _parse_passive_desc(self, passive_desc, desc_values, mod_data):
        """解析PassiveEffectsDesc，将DescValues中的值填入占位符
        翻译自Lua函数GenModPassiveEffectDesc的实现"""
        import re

        # 替换DescValues中的值
        if desc_values:
            # 从mod_data获取mod_id和mod_level
            mod_id = mod_data.get("Id", None)

            # 使用MOD的MaxLevel + ModCardLevelMax来计算效果
            max_level = mod_data.get("MaxLevel", 1)
            mod_card_level_max = mod_data.get("ModCardLevelMax", 0)
            mod_level = max_level + mod_card_level_max

            for i, desc_value in enumerate(desc_values):
                # 检查desc_value中是否包含math.floor或math.ceil（用于确定是否需要取整）
                # 注意：Lua代码第16行会覆盖CastTo值，所以我们先检查ReplaceDescValueTypeCast，再检查math.floor
                # 但实际上第16行的赋值会覆盖第15行的结果，所以最终CastTo只取决于math.floor

                # 步骤1: 调用ReplaceDescValueTypeCast（但实际上结果会被步骤2覆盖）
                placeholder = f"#{i + 1}"
                has_int_prefix = (
                    f"{{[Ii][Nn][Tt]}}{placeholder}" in passive_desc
                    or f"{{[Ii][Nn][Tt]}}{placeholder}" in passive_desc
                )
                if has_int_prefix:
                    # 移除{int}前缀
                    passive_desc = re.sub(
                        r"\{[Ii][Nn][Tt]\}" + re.escape(placeholder),
                        placeholder,
                        passive_desc,
                    )
                    cast_to = True
                else:
                    cast_to = False

                # 步骤2: 检查desc_value中是否包含math.floor或math.ceil（这会覆盖步骤1的cast_to值）
                if "math.floor" in desc_value or "math.ceil" in desc_value:
                    cast_to = True

                # 步骤4: 先尝试_ModAttrGrowDesc2，如果返回空字符串则尝试_SkillGrowDesc
                # 注意：传入base_level和expect_level都为mod_level，这样会显示单一值而不是范围
                # 移除percent参数，因为_desc_value中已经包含了百分号信息
                val_str = self._mod_attr_grow_desc2(
                    desc_value, mod_level, mod_level, "", cast_to
                )
                if val_str == "":
                    val_str = self._skill_grow_desc(
                        desc_value, mod_level, mod_level, "", cast_to, mod_id
                    )

                # 步骤5: 替换占位符 #1, #2, ...
                passive_desc = passive_desc.replace(placeholder, val_str)

        return passive_desc

    def _mod_attr_grow_desc2(
        self,
        desc_value,
        base_level,
        expect_level,
        percent,
        cast_to,
        forbid_format=False,
    ):
        """处理GetModValue和GetModPolarity类型的表达式
        翻译自Lua函数_ModAttrGrowDesc2的实现"""
        import re

        if "GetModValue" in desc_value:
            # 处理GetModValue类型的表达式
            # 只处理纯GetModValue表达式，对于包含其他操作的表达式，返回空字符串，让_skill_grow_desc处理
            # 检查desc_value是否只包含GetModValue函数和可选的$前缀后缀
            get_mod_value_full_match = re.fullmatch(
                r"\$?GetModValue\((\d+),\s*(\d+)(?:,\s*(\d+))?\)\$?", desc_value
            )
            if not get_mod_value_full_match:
                # 不是纯GetModValue表达式，返回空字符串，让_skill_grow_desc处理
                return ""

            # 提取ModId, AttrIdx, ValueType
            mod_id = int(get_mod_value_full_match.group(1))
            attr_idx = int(get_mod_value_full_match.group(2))
            value_type = (
                int(get_mod_value_full_match.group(3))
                if get_mod_value_full_match.group(3)
                else None
            )

            # 获取MOD信息
            mod_data = self.data_loader.get_mod_info(mod_id)
            if (
                mod_data
                and "AddAttrs" in mod_data
                and attr_idx <= len(mod_data["AddAttrs"])
            ):
                mod_attr_conf = mod_data["AddAttrs"][attr_idx - 1]

                # 从MOD数据中获取正确的base_level和expect_level
                # 使用MOD的MaxLevel + ModCardLevelMax来计算效果
                max_level = mod_data.get("MaxLevel", 1)
                mod_card_level_max = mod_data.get("ModCardLevelMax", 0)
                correct_level = max_level + mod_card_level_max

                # 计算基础值和期望的值，使用正确的level
                old_val = self._calc_mod_attr_by_level(
                    mod_attr_conf, mod_id, correct_level, value_type
                )
                new_val = self._calc_mod_attr_by_level(
                    mod_attr_conf, mod_id, correct_level, value_type
                )

                # 格式化值
                old_val_str = f"{self._format_desc_numeric(old_val)}{percent}"
                new_val_str = f"{self._format_desc_numeric(new_val)}{percent}"

                # 根据cast_to格式化
                if not forbid_format:
                    if cast_to:
                        old_val_str = f"{int(old_val)}{percent}"
                        new_val_str = f"{int(new_val)}{percent}"

                # 返回结果，不同则显示范围，相同则显示单个值
                return (
                    f"{old_val_str} -> <H>{new_val_str}</>"
                    if old_val_str != new_val_str
                    else old_val_str
                )
        elif "GetModPolarity" in desc_value:
            # 处理GetModPolarity类型的表达式
            get_mod_polarity_match = re.search(r"GetModPolarity\((\d+)\)", desc_value)
            if get_mod_polarity_match:
                target_mod_id = int(get_mod_polarity_match.group(1))

                # 获取MOD信息
                target_mod_data = self.data_loader.get_mod_info(target_mod_id)
                if target_mod_data:
                    # 根据转换规则获取极性
                    polarity_value = target_mod_data.get("Polarity", -1)
                    polarity_level = max(
                        0, min(len(self.polarity_values) - 1, polarity_value)
                    )
                    polarity = self.polarity_values[polarity_level]
                    return polarity
                else:
                    return ""

        return ""

    def _skill_grow_desc(
        self,
        desc_value,
        base_level,
        expect_level,
        percent,
        cast_to,
        mod_id=None,
        forbid_format=False,
    ):
        """处理技能成长描述
        翻译自Lua函数_SkillGrowDesc的实现"""
        # 完整实现需要SkillUtils.CalcSkillDesc的功能
        # 这里使用_parse_single_desc_value获取值，它会处理所有表达式
        old_val_str = self._parse_single_desc_value(desc_value, mod_id, base_level)
        new_val_str = self._parse_single_desc_value(desc_value, mod_id, expect_level)

        # 检查是否包含RepeatModLevel
        b_repeat_mod_level = "RepeatModLevel" in desc_value

        # 根据cast_to格式化
        if not forbid_format and not b_repeat_mod_level:
            if cast_to:
                try:
                    # 提取数值部分和后缀，转换为整数
                    import re

                    # 匹配数值和后缀（包括%）
                    old_match = re.search(r"([\d.]+)(.*)", old_val_str)
                    new_match = re.search(r"([\d.]+)(.*)", new_val_str)
                    if old_match and new_match:
                        old_val = float(old_match.group(1))
                        new_val = float(new_match.group(1))
                        old_suffix = old_match.group(2)
                        new_suffix = new_match.group(2)

                        # 转换为整数，但如果原值有小数部分且为0，保留.0格式
                        if old_val == int(old_val):
                            old_val_str = f"{int(old_val)}.0{old_suffix}"
                            new_val_str = f"{int(new_val)}.0{new_suffix}"
                        else:
                            old_val_str = f"{int(old_val)}{old_suffix}"
                            new_val_str = f"{int(new_val)}{new_suffix}"
                except:
                    pass

        # 返回结果，不同则显示范围，相同则显示单个值
        return (
            f"{old_val_str} -> <H>{new_val_str}</>"
            if old_val_str != new_val_str
            else old_val_str
        )

    def _calc_mod_attr_by_level(self, attr, mod_id, mod_level, value_type=None):
        """根据CalcModAttrByLevel逻辑计算属性值
        扩展支持value_type参数，翻译自Lua函数CalcModAttrByLevel的实现"""
        # 检查是否是Rate属性
        is_rate = "Rate" in attr
        base = attr.get("Rate" if is_rate else "Value")

        # 根据value_type调整is_rate和base
        if value_type:
            if str(value_type).lower() == "rate":
                base = attr.get("Rate")
                is_rate = True
            elif str(value_type).lower() == "value":
                base = attr.get("Value")
                is_rate = False

        # 处理LevelGrow，确保其存在且不为None
        level_grow = attr.get("LevelGrow")
        if level_grow is None:
            level_grow = 0

        # 转换为数值类型
        try:
            # 尝试将base转换为数值
            if isinstance(base, str):
                if base.startswith("#"):
                    # 对于字符串类型的数值，如"#1"，使用SkillGrow配置来计算
                    # 提取数字部分作为SkillGrow Index
                    grow_index = int(base.strip("#"))

                    # 根据Type获取对应的SkillGrow数据类型，如果没有Type，默认为Mod
                    grow_type = attr.get("Type", "Mod")

                    # 检查grow_type是否存在于skill_grow_data中
                    if grow_type not in self.skill_grow_data:
                        # 如果没有对应的SkillGrow数据，尝试使用直接计算的方式
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (mod_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_type_data = self.skill_grow_data[grow_type]

                    # 构造id_key，对于某些类型可能需要特殊处理
                    id_key = str(mod_id)

                    # 检查id_key是否存在于skill_grow_type_data中
                    if id_key not in skill_grow_type_data:
                        # 如果没有对应的ID数据，尝试使用直接计算的方式
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (mod_level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    id_data = skill_grow_type_data[id_key]

                    # 根据mod_level获取对应的等级数据
                    # 对于PassiveEffect类型，我们需要使用正确的level_index来获取对应的等级数据
                    # 确保level_index在有效范围内
                    level_index = mod_level - 1

                    # 对于不同类型的数据，处理方式不同：
                    # - 对于PassiveEffect类型，id_data包含多个等级的数据，索引从0开始
                    # - 确保level_index不超出范围
                    if level_index < 0 or level_index >= len(id_data):
                        # 如果level_index超出范围，使用最大等级
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

                    # 遍历等级数据中的所有属性条目，查找匹配的Index
                    # SkillGrow数据结构：level_data是一个字典列表，每个字典包含Index和Value
                    found_value = None

                    if isinstance(level_data, list):
                        # 对于PassiveEffect类型，level_data是一个列表，包含多个属性条目
                        for attr_entry in level_data:
                            # 确保attr_entry是字典
                            if isinstance(attr_entry, dict):
                                if attr_entry["Index"] == grow_index:
                                    found_value = attr_entry["Value"]
                                    break
                    elif isinstance(level_data, dict):
                        # 对于单个属性条目的情况
                        if level_data["Index"] == grow_index:
                            found_value = level_data["Value"]
                    elif (
                        isinstance(level_data, list)
                        and level_data
                        and isinstance(level_data[0], list)
                    ):
                        # 处理level_data是一个包含列表的列表的情况
                        for inner_list in level_data:
                            if isinstance(inner_list, list):
                                for attr_entry in inner_list:
                                    if (
                                        isinstance(attr_entry, dict)
                                        and attr_entry["Index"] == grow_index
                                    ):
                                        found_value = attr_entry["Value"]
                                        break
                                if found_value is not None:
                                    break

                    # 如果找到匹配的Index，返回其Value
                    if found_value is not None:
                        return found_value
                    else:
                        # 如果找不到匹配的Index，返回0.0
                        return 0.0
                else:
                    # 对于其他字符串类型的数值，直接转换为float
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    # 计算最终值：Base + LevelGrow * (ModLevel - 1)
                    # 因为基础值已经是1级的值，每增加一级才需要加上level_grow值
                    value = base_num + level_grow_num * (mod_level - 1)
                    return value

            # 处理数值类型的base
            base_num = float(base)
            level_grow_num = float(level_grow)

            # 计算最终值：Base + LevelGrow * (ModLevel - 1)
            # 因为基础值已经是1级的值，每增加一级才需要加上level_grow值
            value = base_num + level_grow_num * (mod_level - 1)

            # 直接返回数值，不检查是否为0
            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            # 如果转换失败，返回0.0作为默认值，避免中断程序执行
            return 0.0

    def _parse_single_desc_value(self, desc_value, mod_id=None, mod_level=1):
        """解析单个DescValue，获取实际值 - 只负责正则提取和替换"""
        import re
        import math

        # 保存原始值用于调试
        original_desc_value = desc_value

        # 统一处理所有$...$格式的表达式，包括带负号的表达式
        # 使用r"\$(-)?(.*?)\$(.*)"匹配带负号、表达式内容和后缀
        expr_match = re.search(r"\$(-)?(.*?)\$(.*)", original_desc_value)
        if expr_match:
            # 提取负号标志、表达式内容和后缀
            has_neg = expr_match.group(1)  # 负号标志，可能为None
            expr = expr_match.group(2)  # 表达式内容
            suffix = expr_match.group(3)  # 包括%在内的所有后缀

            # 检查expr是否为math.floor或math.ceil表达式
            math_match = re.match(r"math\.(ceil|floor)\((.*)\)", expr)
            if math_match:
                math_func = math_match.group(1)
                inner_expr = math_match.group(2)

                # 使用新的函数计算表达式值，确保使用正确的mod_level
                try:
                    expr_value = self._calculate_expr_value(
                        inner_expr, mod_id, mod_level, "Mod"
                    )

                    # 对结果进行相应的函数计算
                    if isinstance(expr_value, (int, float)):
                        if math_func == "ceil":
                            processed_value = math.ceil(expr_value)
                        else:  # floor
                            processed_value = math.floor(expr_value)

                        # 根据是否有负号处理值
                        if has_neg:
                            processed_value = -processed_value

                        # 格式化结果，保留一位小数
                        formatted_value = self._format_desc_numeric(processed_value)

                        # 将计算结果替换到原始格式化串中
                        result = original_desc_value.replace(
                            expr_match.group(0), f"{formatted_value}{suffix}"
                        )
                        # 移除首尾可能的$符号
                        return result.strip("$")
                except ValueError as e:
                    print(f"计算math表达式失败: {e}")
                    # 如果计算失败，返回默认值
                    return original_desc_value.replace(
                        expr_match.group(0), f"0{suffix}"
                    )

            # 使用新的函数计算普通表达式值，捕获可能的异常，确保使用正确的mod_level
            try:
                # 检查表达式是否包含*100等乘法操作
                if "*" in expr:
                    # 对于包含乘法操作的表达式，我们需要特殊处理
                    # 例如：GetModValue(41413,4)*100
                    import re

                    # 提取函数调用部分和乘数
                    func_match = re.match(r"(GetModValue\([^)]+\))\s*\*(\d+)", expr)
                    if func_match:
                        func_call = func_match.group(1)
                        multiplier = float(func_match.group(2))

                        # 计算函数调用的值
                        func_value = self._calculate_expr_value(
                            func_call, mod_id, mod_level, "Mod"
                        )

                        # 应用乘法
                        expr_value = func_value * multiplier
                    else:
                        # 如果无法解析，使用默认计算方式
                        expr_value = self._calculate_expr_value(
                            expr, mod_id, mod_level, "Mod"
                        )
                else:
                    # 普通表达式，直接计算
                    expr_value = self._calculate_expr_value(
                        expr, mod_id, mod_level, "Mod"
                    )

                # 根据是否有负号处理值
                if has_neg:
                    # 对于带负号的表达式，如 `$-#...$`，对值取负
                    final_value = -expr_value
                else:
                    # 对于普通表达式，直接使用值
                    final_value = expr_value

                # 格式化结果，保留一位小数
                formatted_value = self._format_desc_numeric(final_value)

                # 将计算结果替换到原始格式化串中
                result = original_desc_value.replace(
                    expr_match.group(0), f"{formatted_value}{suffix}"
                )
                # 移除首尾可能的$符号
                return result.strip("$")
            except ValueError as e:
                print(f"计算表达式失败: {e}")
                # 如果计算失败，返回默认值，不终止程序
                return original_desc_value.replace(
                    expr_match.group(0), f"0{suffix}"
                ).strip("$")

        # 处理普通表达式
        return "{ERROR}"

    def _calculate_expr_value(self, expr, mod_id=None, mod_level=1, table_type="Mod"):
        """计算表达式值，使用AST解析和上下文跟踪

        Args:
            expr: 表达式字符串，如 "#Buff[1311001].BuffDamagedRate.Value*100"
            mod_id: 当前MOD的ID
            mod_level: 当前MOD的等级
            table_type: 表类型

        Returns:
            计算后的数值
        """
        import re

        # 处理GetModPolarity函数调用
        get_mod_polarity_match = re.match(r"GetModPolarity\((\d+)\)", expr)
        if get_mod_polarity_match:
            target_mod_id = int(get_mod_polarity_match.group(1))
            target_mod_data = self.data_loader.get_mod_info(target_mod_id)
            if target_mod_data:
                polarity_value = target_mod_data.get("Polarity", -1)
                polarity = ["", "A", "D", "V", "O"][max(0, min(4, polarity_value))]
                return polarity
            else:
                raise ValueError(f"无法找到MOD ID '{target_mod_id}'")

        # 处理GetModValue函数调用
        get_mod_value_match = re.match(
            r"GetModValue\((\d+),\s*(\d+)(?:,\s*(\d+))?\)", expr
        )
        if get_mod_value_match:
            target_mod_id = int(get_mod_value_match.group(1))
            attr_idx = int(get_mod_value_match.group(2))
            value_type = (
                int(get_mod_value_match.group(3)) if get_mod_value_match.group(3) else 1
            )

            target_mod_data = self.data_loader.get_mod_info(target_mod_id)
            if not target_mod_data:
                raise ValueError(f"无法找到MOD ID '{target_mod_id}'")

            add_attrs = target_mod_data.get("AddAttrs", [])
            if attr_idx < 1 or attr_idx > len(add_attrs):
                raise ValueError(f"属性索引超出范围: {attr_idx}")

            attr_config = add_attrs[attr_idx - 1]
            max_level = target_mod_data.get("MaxLevel", 1)
            mod_card_level_max = target_mod_data.get("ModCardLevelMax", 0)
            correct_mod_level = max_level + mod_card_level_max

            attr_value = self._calc_mod_attr_by_level(
                attr_config, target_mod_id, correct_mod_level, value_type
            )
            return float(attr_value)

        # 使用基类的AST解析
        return super()._calculate_expr_value(expr, mod_id, mod_level, table_type)

    def _translate_attribute_name(self, attr_name_key, language):
        """翻译属性名称为中文"""
        if not attr_name_key:
            return ""

        # 获取i18n数据
        i18n_entry = self.i18n_data.get(attr_name_key, {})
        # if language == "cn":
        return i18n_entry.get("TextMapContent", "")
        # else:
        #     return i18n_entry.get(
        #         f"Content{language.upper()}", i18n_entry.get("TextMapContent", "")
        #     )

    def process_all_items(self, items, language):
        """处理所有项目，添加过滤和排序"""
        processed_items = []
        for item in items:
            # 过滤掉id > 200000的mod
            mod_id = item.get("Id", 0)
            if mod_id < 100 or mod_id > 300000:
                continue

            processed = self.process_item(item, language)
            processed_items.append(processed)

        # 按id排序
        processed_items.sort(key=lambda x: x.get("id", 0))

        return processed_items
