from processor.base_processor import BaseProcessor
from processor.skill_creature_utils import extract_skill_creatures
import re
import os
import json
import glob


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
        self.hyper_weapon_card_level_data = data_loader.load_json(
            "HyperWeaponCardLevel.json"
        )
        self.hyper_weapon_skill_tree_data = data_loader.load_json(
            "HyperWeaponSkillTree.json"
        )
        self.attribute_data = data_loader.load_json("Attribute.json")
        self.skill_effects_data = data_loader.load_json("SkillEffects.json")
        self.skill_node_data = data_loader.load_json("SkillNode.json")
        self.skill_creature_data = data_loader.load_json("SkillCreature.json")
        self._project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self._asset_root = os.path.join(self._project_root, "out", "Asset")
        self._anim_path_cache = {}
        self._anim_meta_cache = {}

    def process_item(self, item_data, language):
        weapon_data = item_data
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

        processed.update(self._process_attributes(battle_weapon, weapon_id))
        processed.update(
            {
                "加成": self._process_add_attr(battle_weapon, weapon_id),
                "突破": self._process_break(weapon_id, language),
                "熔炼": self._process_smelting(battle_weapon, weapon_id),
            }
        )
        furnace = self._process_furnace(weapon_id, battle_weapon)
        if furnace:
            processed["熔炉"] = furnace
        try:
            skills, reload_value, shooting_interval = self._process_skills(
                battle_weapon, weapon_id
            )
            processed.update(
                {
                    "技能": skills,
                }
            )
            if reload_value:
                processed["装填"] = reload_value
            if shooting_interval:
                processed["射击间隔"] = shooting_interval
        except Exception as e:
            print(f"处理武器 {weapon_id} 技能时出错: {e}")
            import traceback

            traceback.print_exc()

        return processed

    def _process_skills(self, battle_weapon, weapon_id):
        """处理武器技能"""
        if not battle_weapon:
            return [], 0.0, 0.0

        # 获取武器技能列表
        weapon_skill_list = battle_weapon.get("WeaponSkillList", [])
        if not weapon_skill_list:
            return [], 0.0, 0.0

        skills = []
        reload_value = 0.0
        shooting_interval = 0.0
        is_ranged_weapon = self._is_ranged_weapon(battle_weapon)

        loop_interval_map = self._collect_loop_interval_map(
            weapon_skill_list, weapon_id
        )

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

            if not isinstance(skill_entry, dict):
                continue

            # 获取技能名称和描述
            # skill_name = self.get_translated_text(skill_entry.get("SkillName", ""))
            # skill_desc_key = skill_entry.get("SkillDesc", "")
            # skill_desc = self.get_translated_text(skill_desc_key)

            # 获取技能描述参数
            skill_desc_keys = skill_entry.get("SkillDescKeys", [])
            skill_desc_values = skill_entry.get("SkillDescValues", [])

            # 构建技能信息
            skill_type = skill_entry.get("SkillType", "")
            skill_info_dict = {
                "id": skill_id,
                "名称": skill_type,
                # "weapon": skill_entry.get("SkillWeaponType", ""),
            }

            if skill_type == "Reload":
                reload_candidate = self._extract_reload_from_skill(skill_entry)
                if reload_candidate:
                    reload_value = max(reload_value, reload_candidate)
            if is_ranged_weapon and skill_type == "Shooting":
                shooting_candidate = loop_interval_map.get(weapon_id, 0.0)
                if not shooting_candidate:
                    shooting_candidate = loop_interval_map.get(skill_id, 0.0)
                if not shooting_candidate:
                    shooting_candidate = self._extract_shooting_interval_from_skill(
                        skill_entry
                    )
                if shooting_candidate:
                    if shooting_interval:
                        shooting_interval = min(shooting_interval, shooting_candidate)
                    else:
                        shooting_interval = shooting_candidate

            # 如果有描述，处理描述中的占位符
            if skill_desc_keys:
                # 计算技能描述（默认使用武器等级1）
                processed_desc = self._process_weapon_skill_desc(
                    skill_entry, weapon_id, skill_desc_keys, skill_desc_values
                )
                if processed_desc:
                    skill_info_dict["字段"] = processed_desc

            creatures = extract_skill_creatures(
                skill_id,
                self.skill_data,
                self.skill_node_data,
                self.skill_effects_data,
                self.skill_creature_data,
            )
            if creatures:
                skill_info_dict["实体"] = creatures

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
            skill_item = {}
            if "id" in skill:
                skill_item["id"] = skill["id"]
            skill_item["名称"] = typeMap.get(skill["名称"], skill["名称"])
            skill_item["类型"] = "武器伤害"
            if "字段" in skill:
                skill_item["字段"] = skill["字段"]
            if "实体" in skill:
                skill_item["实体"] = skill["实体"]
            if "字段" in skill or "实体" in skill:
                rst.append(skill_item)
        return rst, self.round_value(reload_value), self.round_value(shooting_interval)

    def _collect_loop_interval_map(self, weapon_skill_list, weapon_id):
        """优先收集显式 LoopInterval，用于覆盖动画时长兜底。"""
        loop_interval_map = {}
        if not weapon_skill_list:
            return loop_interval_map

        target_skill_ids = {str(skill_id) for skill_id in weapon_skill_list}
        target_skill_ids.add(str(weapon_id))
        for effect in self.skill_effects_data.values():
            if not isinstance(effect, dict):
                continue
            task_effects = effect.get("TaskEffects", [])
            if not isinstance(task_effects, list):
                continue
            for task_effect in task_effects:
                if not isinstance(task_effect, dict):
                    continue
                if task_effect.get("Function") not in (
                    "StartLoopShoot",
                    "UpdateLoopShoot",
                ):
                    continue
                loop_shoot_id = task_effect.get("LoopShootId")
                if str(loop_shoot_id) not in target_skill_ids:
                    continue
                loop_interval = task_effect.get("LoopInterval")
                if isinstance(loop_interval, (int, float)):
                    loop_interval = self.round_value(loop_interval)
                    current = loop_interval_map.get(loop_shoot_id)
                    if current is None:
                        loop_interval_map[loop_shoot_id] = loop_interval
                    else:
                        loop_interval_map[loop_shoot_id] = min(current, loop_interval)
        return loop_interval_map

    def _is_ranged_weapon(self, battle_weapon):
        """根据武器数据判断是否为远程武器"""
        if not isinstance(battle_weapon, dict):
            return False

        # 远程武器通常具备弹药相关字段。
        for key in ("MagazineCapacity", "BulletMax", "BulletConver"):
            if battle_weapon.get(key) is not None:
                return True

        tags = battle_weapon.get("WeaponTag", [])
        for tag in tags if isinstance(tags, list) else []:
            if not isinstance(tag, str):
                continue
            lower_tag = tag.lower()
            if "range" in lower_tag or "shoot" in lower_tag or "gun" in lower_tag:
                return True

        return False

    def _extract_reload_from_skill(self, skill_entry):
        """从Reload技能对应动画里提取BP_SkillEffect_C的LinkValue作为装填时间"""
        begin_node_id = skill_entry.get("BeginNodeId")
        if not begin_node_id:
            return 0.0

        node_chain = self._collect_skill_node_chain(begin_node_id, 8)
        reload_value = 0.0
        for node in node_chain:
            anim_path = self._resolve_anim_json_path(node)
            cancel, combo, skill_effect_link, shooting_interval = (
                self._read_anim_cancel_and_links(anim_path)
            )
            del cancel, combo, shooting_interval
            if skill_effect_link:
                reload_value = max(reload_value, skill_effect_link)

        return self.round_value(reload_value)

    def _extract_shooting_interval_from_skill(self, skill_entry):
        """从Shooting技能动画的最后一个AnimSegment提取射击间隔"""
        begin_node_id = skill_entry.get("BeginNodeId")
        if not begin_node_id:
            return 0.0

        node_chain = self._collect_skill_node_chain(begin_node_id, 8)
        intervals = []
        for node in node_chain:
            anim_path = self._resolve_anim_json_path(node)
            cancel, combo, skill_effect_link, shooting_interval = (
                self._read_anim_cancel_and_links(anim_path)
            )
            del cancel, combo, skill_effect_link
            if shooting_interval:
                intervals.append(shooting_interval)

        if not intervals:
            return 0.0

        return self.round_value(min(intervals))

    def _process_weapon_skill_desc(
        self, _skill_entry, weapon_id, desc_keys, desc_values
    ):
        """处理武器技能描述，替换占位符"""
        if not desc_keys or not desc_values:
            return []

        rst = []

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
                continue

            # 获取描述文本
            desc_text = self.get_translated_text(desc_key)
            # 预处理表达式，将 $GText("...")$ 替换为翻译后的文本
            preprocessed_desc_value = self.preprocess_expression(desc_value)

            # 计算值（使用武器等级1）
            calculated_value = self._parse_single_desc_value(
                preprocessed_desc_value, weapon_id, 1, "BattleWeapon", True
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

            # 为每个技能字段解析对应的SkillEffects，提取HitStop和CutToughness信息
            skill_effects_info = self._parse_skill_effects(desc_value, weapon_id)
            is_damage_field = bool(skill_effects_info.get("is_damage"))
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

            item["_is_damage"] = is_damage_field

            rst.append(item)

        cancels, combos = self._process_skill_timing(_skill_entry, len(rst))
        for i, item in enumerate(rst):
            if not item.pop("_is_damage", False):
                continue
            cancel = cancels[i] if i < len(cancels) else 0
            combo = combos[i] if i < len(combos) else 0
            if cancel:
                item["取消"] = cancel
            if combo:
                item["连段"] = combo

        return rst

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

            # xN 连击次数属于常量，应保留在格式里，不作为值占位。
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
            cancel, combo, _, shooting_interval = self._read_anim_cancel_and_links(
                anim_path
            )
            del shooting_interval
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

    def _read_anim_cancel_and_links(self, anim_path):
        """读取动画JSON中的取消窗口、连段及技能效果触发点"""
        if not anim_path:
            return 0, 0, 0, 0

        if anim_path in self._anim_meta_cache:
            return self._anim_meta_cache[anim_path]

        cancel = 0.0
        combo = 0.0
        skill_effect_link = 0.0
        shooting_interval = 0.0

        try:
            with open(anim_path, "r", encoding="utf-8") as f:
                data = json.load(f)

            montage = data[0] if isinstance(data, list) and data else {}
            properties = montage.get("Properties", {})

            for slot in properties.get("SlotAnimTracks", []):
                segments = slot.get("AnimTrack", {}).get("AnimSegments", [])
                if not segments:
                    continue

                # 尾段可能切到End/Idle，优先取与首段同AnimReference的最后一段（如Shooting_Loop）。
                segment = segments[-1]
                first_ref = segments[0].get("AnimReference")
                if isinstance(first_ref, dict):
                    first_ref_key = first_ref.get("ObjectPath") or first_ref.get(
                        "ObjectName"
                    )
                    for candidate in reversed(segments):
                        candidate_ref = candidate.get("AnimReference")
                        if not isinstance(candidate_ref, dict):
                            continue
                        candidate_ref_key = candidate_ref.get(
                            "ObjectPath"
                        ) or candidate_ref.get("ObjectName")
                        if first_ref_key and candidate_ref_key == first_ref_key:
                            segment = candidate
                            break

                start = float(segment.get("AnimStartTime", 0) or 0)
                end = float(segment.get("AnimEndTime", 0) or 0)
                play_rate = float(segment.get("AnimPlayRate", 1) or 1)
                if (end - start) < 0.1:
                    shooting_interval = play_rate
                else:
                    interval = max(0.0, (end - start) * play_rate)
                    if interval:
                        shooting_interval = max(shooting_interval, interval)

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
                if notify.get("NotifyName") == "BP_SkillEffect_C":
                    link_value = notify.get("LinkValue")
                    if isinstance(link_value, (int, float)):
                        skill_effect_link = max(skill_effect_link, float(link_value))
                    elif isinstance(link_value, str):
                        stripped = link_value.strip()
                        if stripped:
                            try:
                                skill_effect_link = max(
                                    skill_effect_link, float(stripped)
                                )
                            except ValueError:
                                pass

        except Exception as e:
            print(f"读取动画文件错误: {e}", flush=True)

        result = (
            self.round_value(cancel),
            self.round_value(combo),
            self.round_value(skill_effect_link),
            self.round_value(shooting_interval),
        )
        self._anim_meta_cache[anim_path] = result
        return result

    def _process_add_attr(self, battle_weapon, weapon_id):
        """处理武器属性加成"""
        if not battle_weapon:
            return {}

        # AddAttrs[0]通常包含ATK属性，Rate字段是"#1"，需要从SkillGrow获取
        add_attrs = battle_weapon.get("AddAttrs", [])
        attributes = {}
        # 尝试从AddAttrs中找到ATK属性
        anmap = {
            "最大神智": "神智",
            "暴击率": "暴击",
            "暴击伤害": "暴伤",
            "触发概率": "触发",
            "切割攻击": "物理",
            "贯穿攻击": "物理",
            "震荡攻击": "物理",
            "攻击速度": "攻速",
            "远程武器": "远程",
            "近战武器": "近战",
            "近战同律武器": "同律近战",
            "远程同律武器": "同律远程",
            "角色": "角色",
            "暗属性攻击": "属性伤",
            "水属性攻击": "属性伤",
            "火属性攻击": "属性伤",
            "雷属性攻击": "属性伤",
            "风属性攻击": "属性伤",
            "光属性攻击": "属性伤",
            "ExtraComboProb": "额外连击",
            "多重射击": "多重",
            "最大弹药": "弹药",
            "弹匣容量": "弹匣",
            "子弹装填速度": "装填",
            "GrRate": "歧视",
            "JtRate": "歧视",
            "JhRate": "歧视",
            "SqRate": "歧视",
            "触发贯穿额外效果时对生命伤害": "触发倍率",
            "触发切割额外效果时对护盾伤害": "触发倍率",
            "ExplodeBulletRate": "爆炸伤害",
            "RayCreatureRate": "射线伤害",
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
                if attr_name == "Psionic":
                    attributes["伤害类型"] = "灵能"
                    attributes["攻击"] = battle_weapon[attr_key]
                    continue
                attr_config = self.attr_config.get(attr_key, {})
                atk_type = self.get_translated_text(attr_config.get("Name", ""), "cn")
                if not atk_type:
                    continue
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

    def _process_furnace(self, weapon_id, battle_weapon=None):
        """处理武器熔炉数据。"""
        card_level_rows = self.hyper_weapon_card_level_data.get(str(weapon_id), [])
        if not card_level_rows:
            card_level_rows = self.hyper_weapon_card_level_data.get(weapon_id, [])
        if not isinstance(card_level_rows, list):
            card_level_rows = []

        if not card_level_rows:
            return []

        skill_tree_rows = []
        for skill_id, skill_tree in self.hyper_weapon_skill_tree_data.items():
            if not isinstance(skill_tree, dict):
                continue
            if skill_tree.get("WeaponId") != weapon_id:
                continue
            if skill_tree.get("WeaponCardLevel", 0) <= 0:
                continue
            skill_tree_rows.append((skill_id, skill_tree))

        skill_tree_rows.sort(
            key=lambda item: (
                item[1].get("WeaponCardLevel", 0),
                item[1].get("SkillIndex", 0),
                item[1].get("WeaponSkillId", 0),
            )
        )

        furnace_rows = []
        for card_level_row in card_level_rows:
            if not isinstance(card_level_row, dict):
                continue

            level = card_level_row.get("WeaponCardLevel", 0)
            if level <= 0:
                continue

            row = {
                "lv": level,
                "解锁": self._build_resource_map(
                    card_level_row.get("ResourceId", []),
                    card_level_row.get("ResourceNum", []),
                ),
            }

            level_skills = []
            for skill_id, skill_tree in skill_tree_rows:
                if skill_tree.get("WeaponCardLevel", 0) != level:
                    continue

                skill_row = {
                    "id": skill_tree.get("WeaponSkillId", skill_id),
                    "名称": self.get_translated_text(
                        skill_tree.get("WeaponSkillName", "")
                    ),
                    "icon": self._extract_icon_name(skill_tree.get("SkillIcon", "")),
                }
                skill_desc = self._build_hyper_weapon_skill_desc(skill_tree, weapon_id)
                if skill_desc:
                    skill_row["描述"] = skill_desc

                skill_addon = self._build_hyper_weapon_skill_addon(
                    battle_weapon, skill_tree.get("WeaponSkillId", 0)
                )
                if skill_addon:
                    skill_row["加成"] = skill_addon

                unlock_map = self._build_resource_map(
                    skill_tree.get("ResourceId", []),
                    skill_tree.get("ResourceNum", []),
                )
                if unlock_map:
                    skill_row["解锁"] = unlock_map

                level_skills.append(skill_row)

            if level_skills:
                row["技能"] = level_skills

            furnace_rows.append(row)

        return furnace_rows

    def _build_resource_map(self, resource_ids, resource_nums):
        """将资源 id/num 列表转换成突破同款字典。"""
        if not isinstance(resource_ids, list) or not isinstance(resource_nums, list):
            return {}

        resource_map = {}
        for idx, resource_id in enumerate(resource_ids):
            if idx >= len(resource_nums):
                continue
            resource_name = self.data_loader.get_resource_name(resource_id)
            if not resource_name:
                resource_name = str(resource_id)
            resource_map[resource_name] = resource_nums[idx]
        return resource_map

    def _build_hyper_weapon_skill_desc(self, skill_tree, weapon_id):
        """按 SkillDescParameter 计算灾厄熔炉技能描述。"""
        if not isinstance(skill_tree, dict):
            return ""

        desc_key = skill_tree.get("SkillDescription", "")
        if not desc_key:
            return ""

        desc = self.get_translated_text(desc_key) or desc_key
        params = skill_tree.get("SkillDescParameter", [])
        if not isinstance(params, list) or not params:
            return desc.replace("<H>", "").replace("</>", "")

        for idx, desc_value in enumerate(params, start=1):
            if desc_value is None:
                continue
            preprocessed_desc_value = self.preprocess_expression(desc_value)
            calculated_value = self._parse_single_desc_value(
                preprocessed_desc_value, weapon_id, 1, "BattleWeapon", True
            )
            desc = desc.replace(f"#{idx}", str(calculated_value))

        return self._format_float_templates(desc).replace("<H>", "").replace(
            "</>", ""
        )

    def _build_hyper_weapon_skill_addon(self, battle_weapon, skill_tree_id):
        """按 HyperWeaponSkillTreeID 反查技能加成。"""
        if not isinstance(battle_weapon, dict) or not skill_tree_id:
            return {}

        add_attrs = battle_weapon.get("AddAttrs", [])
        if not isinstance(add_attrs, list) or not add_attrs:
            return {}

        rst = {}
        for attr in add_attrs:
            if not isinstance(attr, dict):
                continue
            if attr.get("HyperWeaponSkillTreeID") != skill_tree_id:
                continue

            attr_name = attr.get("AttrName", "")
            attr_config = self.attr_config.get(attr_name, {})
            attr_name_key = attr_config.get("Name", "")
            if not attr_name_key:
                continue
            fkey = self.get_translated_text(attr_name_key)
            fkeymap = {
                "武器暴击率": "暴击",
                "武器多重射击": "多重",
            }
            fkey = fkeymap.get(fkey, fkey)
            rst[fkey] = self.round_value(attr.get("Rate") or attr.get("Value", 0))
        return rst

    def _extract_icon_name(self, icon_value):
        """从图标路径中提取短名，和其他技能图标保持一致。"""
        if not icon_value:
            return ""

        match = re.search(r"(T_[^./']+)", icon_value)
        if match:
            return match.group(1)

        return ""

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
        float_precision_map = {}
        for match in re.finditer(r"\{float(\d+)\}.*?(#\d+)", translated_desc):
            try:
                float_precision_map[int(match.group(2)[1:])] = int(match.group(1))
            except (TypeError, ValueError):
                continue

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
                keep_precision = (i + 1) in float_precision_map
                val_str = self._parse_single_desc_value(
                    desc_value,
                    weapon_id,
                    grade_level,
                    "BattleWeapon",
                    keep_precision,
                )

                # 如果需要取整
                if cast_to:
                    try:
                        number_match = re.search(r"([\d.]+)", val_str)
                        if number_match:
                            val = float(number_match.group(1))
                            val_str = f"{int(val)}{percent}"
                    except:
                        pass

                # 替换占位符
                result_desc = result_desc.replace(placeholder, val_str)

        result_desc = self._format_float_templates(result_desc)

        # 移除<H></>标签（高亮标签）
        result_desc = result_desc.replace("<H>", "").replace("</>", "")

        return result_desc

    def _format_float_templates(self, text):
        """展开文本中的 {floatN} 模板，保留指定小数位格式。"""
        if not isinstance(text, str) or "{float" not in text:
            return text

        def _replace(match):
            digits = int(match.group(1))
            number = match.group(2)
            suffix = match.group(3) or ""
            decimals = max(digits - 1, 0)
            try:
                formatted = f"{float(number):.{decimals}f}"
            except (TypeError, ValueError):
                return match.group(0)
            return f"{formatted}{suffix}"

        return re.sub(r"\{float(\d+)\}(-?\d+(?:\.\d+)?)(%)?", _replace, text)

    def _format_desc_numeric(self, value, keep_precision=True):
        """格式化描述中的数值。

        keep_precision=True: 保留有效精度（用于技能字段）。
        keep_precision=False: 固定1位小数（用于熔炼描述，保持历史展示）。
        """
        if not isinstance(value, (int, float)):
            return "0.0"

        numeric = float(value)
        if not keep_precision:
            return f"{numeric:.1f}"

        rounded = self.round_value(numeric)
        if isinstance(rounded, int):
            return f"{rounded:.1f}"

        text = f"{rounded:.4f}".rstrip("0").rstrip(".")
        if "." not in text:
            text = f"{text}.0"
        return text

    def _parse_single_desc_value(
        self, desc_value, weapon_id, grade_level, table_type, keep_precision=True
    ):
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

                        formatted_value = self._format_desc_numeric(
                            processed_value, keep_precision
                        )
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

                    formatted_value = self._format_desc_numeric(
                        final_value, keep_precision
                    )

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

        result = {"is_damage": False}
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
                    result["is_damage"] = True
                    # 解析CutToughness的Value字段
                    value = task_effect.get("Value")
                    if value is not None:
                        result["削韧"] = value
                if task_effect.get("Function") == "Damage":
                    result["is_damage"] = True

        return result
