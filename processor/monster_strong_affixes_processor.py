import json
import copy
import re
from typing import Any, Dict, List, Optional, Tuple

from processor.base_processor import BaseProcessor


class MonsterStrongAffixesProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "MonsterStrongAffixes"
        self.buff_data = data_loader.load_json("Buff.json")
        self.passive_effect_data = data_loader.load_json("PassiveEffect.json")
        self.skill_effects_data = data_loader.load_json("SkillEffects.json")
        self.skill_creature_data = data_loader.load_json("SkillCreature.json")
        self.mechanism_summon_data = data_loader.load_json("MechanismSummon.json")
        self.danmaku_template_data = data_loader.load_json("DanmakuTemplate.json")
        self.danmaku_creature_data = data_loader.load_json("DanmakuCreature.json")
        self.ui_guide_data = data_loader.load_json("UIGuide.json")
        self.ui_child_guide_data = data_loader.load_json("UIChildGuide.json")
        self.strong_title_to_child_ids = self._build_strong_title_to_child_ids()

    def process_item(self, item_data, language):
        """处理单个怪物强词条数据"""
        game_play_tag = item_data.get("GamePlayTag", "")
        if not game_play_tag:
            return None

        guide_info = self._build_guide_info(game_play_tag, language)
        affix_buff_ids = item_data.get("AffixesBuffIds", [])
        buff_id = affix_buff_ids[0] if affix_buff_ids else 0
        buff_info = self._build_buff_info(buff_id)

        result = {
            "id": game_play_tag,
            "name": guide_info.get("name", ""),
            "desc": guide_info.get("desc", ""),
            # "buff": buff_info,
        }
        vars = self._build_semantic_vars(buff_info)
        if vars:
            result["vars"] = vars[0]

        return result

    def _build_semantic_vars(self, buff_info: Dict[str, Any]) -> List[Dict[str, Any]]:
        """从内联buff结构提取语义化参数"""
        if not isinstance(buff_info, dict):
            return []

        vars_list = []
        pe_vars = (buff_info.get("pe") or {}).get("vars", {})
        if isinstance(pe_vars, dict):
            pe_var_item = self._extract_pe_vars_semantics(pe_vars)
            if pe_var_item:
                vars_list.append(pe_var_item)
            for _, se_entry in self._iter_se_entries(pe_vars):
                if isinstance(se_entry, dict):
                    vars_list.extend(
                        self._extract_semantic_vars_from_skill_effect(se_entry)
                    )

        primary_se = buff_info.get("se")
        if isinstance(primary_se, dict):
            vars_list.extend(self._extract_semantic_vars_from_skill_effect(primary_se))

        deduplicated = self._deduplicate_vars(vars_list)
        merged = self._merge_vars_to_single_item(deduplicated)
        if not merged:
            return []
        return [merged]

    def _extract_pe_vars_semantics(self, pe_vars: Dict[str, Any]) -> Dict[str, Any]:
        """提取PE Vars中的语义化参数"""
        key_map = {
            "HealRate": "吸血比例",
            "Time": "间隔时间",
            "WarningDelay": "预警延迟",
            "UseSkillDis": "技能作用距离",
            "AddDamageRate": "伤害加成倍率",
        }
        result = {}
        for key, value in pe_vars.items():
            if re.match(r"^se(\d*)$", str(key)):
                continue
            if value in (None, "", [], {}):
                continue
            semantic_key = key_map.get(str(key))
            if not semantic_key:
                continue
            result[semantic_key] = value
        return result

    def _extract_semantic_vars_from_skill_effect(
        self, se_entry: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """从单个SkillEffect结构提取语义化参数"""
        effects = se_entry.get("effects", [])
        if not isinstance(effects, list):
            return []

        vars_list = []
        for effect in effects:
            if not isinstance(effect, dict):
                continue

            var_item = {}
            function_name = effect.get("Function")

            if function_name == "CreateDanmaku":
                # self._set_var_if_not_none(
                #     var_item, "弹幕模板ID", effect.get("DanmakuTemplateId")
                # )
                self._set_var_if_not_none(var_item, "持续时间", effect.get("Duration"))
                self._extract_danmaku_semantics(
                    var_item, self._to_int(effect.get("DanmakuTemplateId"))
                )

            if function_name == "Damage":
                self._set_var_if_not_none(var_item, "伤害倍率", effect.get("Rate"))
                # self._set_var_if_not_none(
                #     var_item, "伤害基于属性", effect.get("BaseAttr")
                # )
                damage_tag = effect.get("DamageTag")
                if isinstance(damage_tag, list) and damage_tag:
                    var_item["伤害类型"] = damage_tag
                sphere_radius = self._parse_sphere_radius(se_entry.get("filter"))
                if sphere_radius and "半径" not in var_item:
                    var_item["半径"] = sphere_radius

            if function_name == "CutToughness":
                self._set_var_if_not_none(var_item, "削韧值", effect.get("Value"))
                self._set_var_if_not_none(var_item, "受击类型", effect.get("CauseHit"))

            if function_name == "CreateSkillCreature":
                self._extract_skill_creature_semantics(var_item, effect)

            if (
                function_name == "CreateUnit"
                and effect.get("UnitType") == "MechanismSummon"
            ):
                self._set_var_if_not_none(var_item, "持续时间", effect.get("LifeTime"))
                self._set_var_if_not_none(
                    var_item, "最大召唤数量", effect.get("MaxSummonCount")
                )
                self._set_var_if_not_none(
                    var_item, "每次召唤数量", effect.get("SingleSummonCount")
                )
                self._set_var_if_not_none(
                    var_item, "召唤延迟", effect.get("CreateDelay")
                )
                self._extract_add_buff_semantics(
                    var_item,
                    (effect.get("mechanismSummon") or {}).get("BluePrintParams"),
                )

            if function_name == "AddBuff":
                self._set_var_if_not_none(var_item, "BUFF持续", effect.get("LastTime"))
                self._extract_dot_semantics_from_buff(var_item, effect.get("buff"))

            if var_item:
                vars_list.append(var_item)

        return vars_list

    def _extract_skill_creature_semantics(
        self, var_item: Dict[str, Any], effect: Dict[str, Any]
    ) -> None:
        """提取CreateSkillCreature语义参数"""
        skill_creature = effect.get("skillCreature", {})
        if not isinstance(skill_creature, dict):
            return

        self._set_var_if_not_none(var_item, "飞行速度", skill_creature.get("Speed"))
        self._set_var_if_not_none(var_item, "持续时间", skill_creature.get("TimeLife"))
        self._set_var_if_not_none(var_item, "命中延迟", skill_creature.get("TimeToHit"))
        self._set_var_if_not_none(
            var_item, "追踪速度", skill_creature.get("TraceSpeed")
        )

        trace_range = skill_creature.get("TraceRange", {})
        if isinstance(trace_range, dict):
            self._set_var_if_not_none(var_item, "追踪范围", trace_range.get("Range"))

        vars_data = skill_creature.get("Vars", {})
        if isinstance(vars_data, dict):
            self._set_var_if_not_none(var_item, "生效延迟", vars_data.get("Delay"))
            for _, se_entry in self._iter_se_entries(vars_data):
                if isinstance(se_entry, dict):
                    sphere_radius = self._parse_sphere_radius(se_entry.get("filter"))
                    if sphere_radius and "半径" not in var_item:
                        var_item["半径"] = sphere_radius
                    nested_vars = self._extract_semantic_vars_from_skill_effect(
                        se_entry
                    )
                    self._merge_var_items(var_item, nested_vars)

        for hit_key in ("HitEnemy", "HitScene"):
            hit_effect_ids = skill_creature.get(hit_key, [])
            if not isinstance(hit_effect_ids, list):
                continue
            for effect_id in hit_effect_ids:
                effect_id_int = self._to_int(effect_id)
                if not effect_id_int:
                    continue
                hit_se = self._build_skill_effect_entry(effect_id_int, set(), set())
                nested_vars = self._extract_semantic_vars_from_skill_effect(hit_se)
                self._merge_var_items(var_item, nested_vars)

    def _extract_danmaku_semantics(
        self, var_item: Dict[str, Any], danmaku_template_id: int
    ) -> None:
        """从DanmakuTemplate和DanmakuCreature提取语义参数"""
        if not danmaku_template_id:
            return

        template_data = self.danmaku_template_data.get(str(danmaku_template_id), {})
        if not isinstance(template_data, dict):
            template_data = {}

        creature_id = self._to_int(template_data.get("Type"))
        if not creature_id and str(danmaku_template_id) in self.danmaku_creature_data:
            creature_id = danmaku_template_id
        if not creature_id:
            return

        creature_data = self.danmaku_creature_data.get(str(creature_id), {})
        if not isinstance(creature_data, dict):
            return

        if "持续时间" not in var_item:
            self._set_var_if_not_none(
                var_item, "持续时间", creature_data.get("TimeLife")
            )

        vars_data = creature_data.get("Vars", {})
        if isinstance(vars_data, dict):
            self._extract_danmaku_vars_semantics(var_item, vars_data)

        for hit_key in ("HitEnemy", "HitScene"):
            hit_effect_ids = creature_data.get(hit_key, [])
            if not isinstance(hit_effect_ids, list):
                continue
            for effect_id in hit_effect_ids:
                effect_id_int = self._to_int(effect_id)
                if not effect_id_int:
                    continue
                hit_se = self._build_skill_effect_entry(effect_id_int, set(), set())
                nested_vars = self._extract_semantic_vars_from_skill_effect(hit_se)
                self._merge_var_items(var_item, nested_vars)

    def _extract_danmaku_vars_semantics(
        self, var_item: Dict[str, Any], vars_data: Dict[str, Any]
    ) -> None:
        """提取DanmakuCreature Vars中的语义参数"""
        inlined_vars = self._inline_skill_effect_refs(vars_data, set(), set())
        self._set_var_if_not_none(
            var_item, "伤害间隔", inlined_vars.get("DamageInterval")
        )

        for _, se_entry in self._iter_se_entries(inlined_vars):
            if not isinstance(se_entry, dict):
                continue
            nested_vars = self._extract_semantic_vars_from_skill_effect(se_entry)
            self._merge_var_items(var_item, nested_vars)

    def _merge_var_items(
        self, target: Dict[str, Any], source_items: List[Dict[str, Any]]
    ) -> None:
        """将多个语义变量项合并到目标字典（保留先出现值）"""
        for source in source_items:
            if not isinstance(source, dict):
                continue
            for key, value in source.items():
                if key in target:
                    if isinstance(target[key], list) and isinstance(value, list):
                        merged = []
                        for item in target[key] + value:
                            if item not in merged:
                                merged.append(item)
                        target[key] = merged
                    continue
                target[key] = value

    def _merge_vars_to_single_item(
        self, vars_list: List[Dict[str, Any]]
    ) -> Dict[str, Any]:
        """将多个vars项合并为单个语义对象"""
        merged = {}
        for item in vars_list:
            if not isinstance(item, dict):
                continue
            for key, value in item.items():
                if key in merged:
                    if isinstance(merged[key], list) and isinstance(value, list):
                        dedup_list = []
                        for entry in merged[key] + value:
                            if entry not in dedup_list:
                                dedup_list.append(entry)
                        merged[key] = dedup_list
                    continue
                merged[key] = value
        return merged

    def _extract_add_buff_semantics(
        self, var_item: Dict[str, Any], blue_print_params: Any
    ) -> None:
        """从BluePrintParams中提取语义参数"""
        if not isinstance(blue_print_params, dict):
            return

        for _, se_entry in self._iter_se_entries(blue_print_params):
            if not isinstance(se_entry, dict):
                continue
            nested_vars = self._extract_semantic_vars_from_skill_effect(se_entry)
            self._merge_var_items(var_item, nested_vars)

    def _extract_dot_semantics_from_buff(
        self, var_item: Dict[str, Any], buff_entry: Any
    ) -> None:
        """从buff.raw中提取语义参数"""
        if not isinstance(buff_entry, dict):
            return

        raw_data = buff_entry.get("raw", {})
        if not isinstance(raw_data, dict):
            return

        self._set_var_if_not_none(
            var_item, "时间膨胀倍率", raw_data.get("TimeDilation")
        )
        self._set_var_if_not_none(var_item, "最大层数", raw_data.get("MaxLayer"))
        add_attrs = raw_data.get("AddAttrs")
        translated_attrs = self._translate_add_attrs(add_attrs)
        if translated_attrs:
            field_name = "加成"
            if field_name not in var_item:
                var_item[field_name] = translated_attrs

        dot_datas = raw_data.get("DotDatas", [])
        if not isinstance(dot_datas, list) or not dot_datas:
            return

        dot_entry = None
        for item in dot_datas:
            if isinstance(item, dict) and item.get("Type") == "Dot":
                dot_entry = item
                break
        if dot_entry is None:
            dot_entry = dot_datas[0] if isinstance(dot_datas[0], dict) else None
        if not isinstance(dot_entry, dict):
            return

        dot_type = dot_entry.get("Type")
        if dot_type == "Hot":
            if "HOT回复" not in var_item:
                self._set_var_if_not_none(var_item, "HOT回复", dot_entry.get("Rate"))
            if "HOT间隔" not in var_item:
                self._set_var_if_not_none(
                    var_item, "HOT间隔", dot_entry.get("Interval")
                )
            # self._set_var_if_not_none(
            #     var_item, "HOT基于属性", dot_entry.get("BaseAttr")
            # )
            return

        if "DOT伤害" not in var_item:
            self._set_var_if_not_none(var_item, "DOT伤害", dot_entry.get("Rate"))
        if "DOT间隔" not in var_item:
            self._set_var_if_not_none(var_item, "DOT间隔", dot_entry.get("Interval"))
        if "伤害类型" not in var_item:
            damage_tag = dot_entry.get("DamageTag")
            if isinstance(damage_tag, list) and damage_tag:
                var_item["伤害类型"] = damage_tag

    def _iter_se_entries(self, data_dict: Dict[str, Any]) -> List[Tuple[int, Any]]:
        """按序返回se/se2/se3...字段"""
        pairs = []
        for key, value in data_dict.items():
            match = re.match(r"^se(\d*)$", str(key))
            if not match:
                continue
            order = int(match.group(1)) if match.group(1) else 1
            pairs.append((order, value))
        pairs.sort(key=lambda item: item[0])
        return pairs

    def _parse_sphere_radius(self, filter_text: Any) -> int:
        """从Mon_Sphere_xxx过滤器解析球形半径"""
        if not isinstance(filter_text, str):
            return 0
        match = re.search(r"Mon_Sphere_(\d+)_", filter_text)
        if not match:
            return 0
        return self._to_int(match.group(1))

    def _translate_add_attrs(self, add_attrs: Any) -> Dict[str, Any]:
        """将AddAttrs翻译为中文属性字典"""
        if not isinstance(add_attrs, list):
            return {}

        attr_name_map = {
            "DEF": "防御",
            "ATK": "攻击",
            "SkillSpeed": "技能速度",
            "MoveSpeedAddRate": "移动速度",
            "AtkSpeed": "攻击速度",
        }
        result = {}
        for item in add_attrs:
            if not isinstance(item, dict):
                continue
            attr_name = attr_name_map.get(
                str(item.get("AttrName")), str(item.get("AttrName"))
            )
            if not attr_name:
                continue
            value = item.get("Rate")
            if value is None:
                value = item.get("Value")
            if value is None:
                continue
            result[attr_name] = value
        return result

    def _deduplicate_vars(
        self, vars_list: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """对vars进行去重并清理空项"""
        deduplicated = []
        seen = set()
        for item in vars_list:
            if not isinstance(item, dict):
                continue
            cleaned = {
                key: value
                for key, value in item.items()
                if value not in (None, "", [], {})
            }
            if not cleaned:
                continue
            marker = json.dumps(cleaned, ensure_ascii=False, sort_keys=True)
            if marker in seen:
                continue
            seen.add(marker)
            deduplicated.append(cleaned)
        return deduplicated

    def _set_var_if_not_none(self, data: Dict[str, Any], key: str, value: Any) -> None:
        """设置非空语义参数"""
        if value is None:
            return
        data[key] = value

    def process_all_items(self, items, language):
        """处理并去重怪物强词条数据"""
        processed_items = super().process_all_items(items, language)
        return self._deduplicate_variant_items(processed_items)

    def _deduplicate_variant_items(
        self, processed_items: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """若后缀词条与基础词条内容一致（忽略id字段），移除后缀词条"""
        base_id_to_item: Dict[str, Dict[str, Any]] = {}
        for item in processed_items:
            item_id = item.get("id")
            if not isinstance(item_id, str):
                continue
            if self._get_base_affix_id(item_id) == item_id:
                base_id_to_item[item_id] = item

        deduplicated: List[Dict[str, Any]] = []
        for item in processed_items:
            item_id = item.get("id")
            if not isinstance(item_id, str):
                deduplicated.append(item)
                continue

            base_id = self._get_base_affix_id(item_id)
            if base_id == item_id:
                deduplicated.append(item)
                continue

            base_item = base_id_to_item.get(base_id)
            if not base_item:
                deduplicated.append(item)
                continue

            if self._strip_ids(item) == self._strip_ids(base_item):
                continue

            deduplicated.append(item)

        return deduplicated

    def _get_base_affix_id(self, affix_id: str) -> str:
        """获取基础词条ID（移除.Double/.Triple后缀）"""
        if affix_id.endswith(".Double"):
            return affix_id[: -len(".Double")]
        if affix_id.endswith(".Triple"):
            return affix_id[: -len(".Triple")]
        return affix_id

    def _strip_ids(self, value: Any) -> Any:
        """递归移除所有id字段用于比较"""
        if isinstance(value, dict):
            result = {}
            for key, item in value.items():
                if key == "id":
                    continue
                result[key] = self._strip_ids(item)
            return result

        if isinstance(value, list):
            return [self._strip_ids(item) for item in value]

        return value

    def _build_strong_title_to_child_ids(self) -> Dict[str, List[int]]:
        """构建强词条标题到子引导ID列表的映射"""
        mapping = {}
        for guide in self.ui_guide_data.values():
            title = guide.get("MainGuideTitle", "")
            if not isinstance(title, str) or not title.startswith(
                "Mon_Guide_Title_Strong_"
            ):
                continue

            child_ids = guide.get("ChildGuideId", [])
            if not isinstance(child_ids, list):
                child_ids = [child_ids]
            mapping[title] = [child_id for child_id in child_ids if child_id]
        return mapping

    def _build_guide_info(self, game_play_tag: str, language: str) -> Dict[str, str]:
        """根据强词条Tag获取标题与描述"""
        strong_name, _ = self._parse_strong_tag(game_play_tag)
        if not strong_name:
            return {"name": "", "desc": ""}

        title_key = f"Mon_Guide_Title_Strong_{strong_name}"
        child_ids = self.strong_title_to_child_ids.get(title_key, [])

        guide_name = self.get_translated_text(title_key, language)
        desc_parts = []
        seen_desc = set()
        for child_id in child_ids:
            child_guide = self.ui_child_guide_data.get(str(child_id), {})
            if not guide_name:
                guide_title_key = child_guide.get("GuideTitle", title_key)
                guide_name = self.get_translated_text(guide_title_key, language)

            desc_text = self._build_child_guide_desc(child_guide, language)
            if not desc_text or desc_text in seen_desc:
                continue
            seen_desc.add(desc_text)
            desc_parts.append(desc_text)

        return {
            "name": self._remove_html_tags(guide_name),
            "desc": self._remove_html_tags("\n".join(desc_parts)),
        }

    def _build_child_guide_desc(
        self, child_guide: Dict[str, Any], language: str
    ) -> str:
        """构建单个子引导描述文本"""
        guide_info1 = child_guide.get("GuideInfo1", {})
        guide_content = guide_info1.get("GuideContent", {})
        desc_key = (
            guide_content.get("PC")
            or guide_content.get("Phone")
            or guide_content.get("GamePad")
            or ""
        )
        desc_text = self.get_translated_text(desc_key, language) if desc_key else ""
        desc_values = guide_info1.get("GuideDescValues", [])
        if isinstance(desc_values, list) and desc_text:
            for i, expr in enumerate(desc_values):
                desc_text = desc_text.replace(
                    f"#{i + 1}", str(self._parse_desc_expression(expr))
                )
        return desc_text

    def _parse_strong_tag(self, game_play_tag: str) -> Tuple[str, int]:
        """解析强词条Tag并返回(词条名, 变体索引)"""
        # 例: Mon.Strong.Blood / Mon.Strong.Blood.Double / Mon.Strong.Blood.Triple
        parts = game_play_tag.split(".")
        if len(parts) < 3:
            return "", 0

        strong_name = parts[2]
        variant_index = 0
        if len(parts) >= 4:
            variant = parts[3]
            if variant == "Double":
                variant_index = 1
            elif variant == "Triple":
                variant_index = 2

        return strong_name, variant_index

    def _build_buff_info(self, buff_id: int) -> Dict[str, Any]:
        """构建buff结构：id + pe + se"""
        return self._build_buff_entry(buff_id, set(), set())

    def _build_buff_entry(
        self, buff_id: int, seen_effect_ids: Optional[set], seen_buff_ids: Optional[set]
    ) -> Dict[str, Any]:
        """构建递归buff结构，含循环保护"""
        buff_result = {"id": buff_id}
        if not buff_id:
            return buff_result

        if seen_effect_ids is None:
            seen_effect_ids = set()
        if seen_buff_ids is None:
            seen_buff_ids = set()
        if buff_id in seen_buff_ids:
            return buff_result

        next_seen_buff = set(seen_buff_ids)
        next_seen_buff.add(buff_id)

        buff_data = self.buff_data.get(str(buff_id), {})
        passive_effect = self._build_passive_effect_info(
            buff_data, seen_effect_ids, next_seen_buff
        )
        if passive_effect:
            buff_result["pe"] = passive_effect

        skill_effect = self._build_skill_effect_info(
            buff_data, passive_effect, seen_effect_ids, next_seen_buff
        )
        if skill_effect:
            buff_result["se"] = skill_effect

        if not passive_effect and not skill_effect:
            raw_data = self._build_buff_raw_data(
                buff_data, seen_effect_ids, next_seen_buff
            )
            if raw_data:
                buff_result["raw"] = raw_data

        return buff_result

    def _build_buff_raw_data(
        self,
        buff_data: Dict[str, Any],
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Dict[str, Any]:
        """提取Buff原始关键字段（用于无pe/se时的递归展示）"""
        ignored_keys = {
            "BuffId",
            "AddPassiveEffect",
            "PassiveEffectVars",
            "AddSkillEffect",
            "SkillEffectFilter",
        }
        result = {}

        for key, value in buff_data.items():
            if key in ignored_keys:
                continue

            copied_value = copy.deepcopy(value)
            if isinstance(copied_value, dict):
                copied_value = self._inline_skill_effect_refs(
                    copied_value, seen_effect_ids, seen_buff_ids
                )

            if copied_value in (None, "", [], {}):
                continue
            result[key] = copied_value

        return result

    def _build_passive_effect_info(
        self,
        buff_data: Dict[str, Any],
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Optional[Dict[str, Any]]:
        """构建被动效果信息"""
        passive_effect_ids = buff_data.get("AddPassiveEffect", [])
        if not passive_effect_ids:
            return None

        passive_effect_id = passive_effect_ids[0]
        passive_effect_data = self.passive_effect_data.get(str(passive_effect_id), {})
        vars_data = copy.deepcopy(passive_effect_data.get("Vars", {}))

        buff_vars = buff_data.get("PassiveEffectVars")
        if isinstance(vars_data, dict) and isinstance(buff_vars, dict):
            vars_data.update(buff_vars)
        elif buff_vars and not vars_data:
            vars_data = copy.deepcopy(buff_vars)
        if isinstance(vars_data, dict):
            vars_data = self._inline_skill_effect_refs(
                vars_data, seen_effect_ids, seen_buff_ids
            )

        result = {"id": passive_effect_id}
        if vars_data:
            result["vars"] = vars_data
        return result

    def _build_skill_effect_info(
        self,
        buff_data: Dict[str, Any],
        passive_effect: Optional[Dict[str, Any]],
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Optional[Dict[str, Any]]:
        """构建技能效果信息"""
        skill_effect_ids = self._extract_skill_effect_ids(buff_data, passive_effect)
        if not skill_effect_ids:
            return None

        skill_effect_id = skill_effect_ids[0]
        result = self._build_skill_effect_entry(
            skill_effect_id, seen_effect_ids, seen_buff_ids
        )
        target_filter = buff_data.get("SkillEffectFilter")
        if target_filter:
            result["filter"] = target_filter
        return result

    def _inline_effect_data(
        self,
        effect: Any,
        seen_effect_ids: Optional[set] = None,
        seen_buff_ids: Optional[set] = None,
    ) -> Any:
        """内联TaskEffect中引用的外部配置"""
        inlined = self._inline_mechanism_summon(effect, seen_effect_ids, seen_buff_ids)
        inlined = self._inline_skill_creature(inlined, seen_effect_ids, seen_buff_ids)
        inlined = self._inline_add_buff(inlined, seen_effect_ids, seen_buff_ids)
        return inlined

    def _build_skill_effect_entry(
        self,
        skill_effect_id: int,
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Dict[str, Any]:
        """构建单个SkillEffect内联结构"""
        result = {"id": skill_effect_id}
        if not skill_effect_id:
            return result

        if seen_effect_ids is None:
            seen_effect_ids = set()
        if skill_effect_id in seen_effect_ids:
            return result

        next_seen = set(seen_effect_ids)
        next_seen.add(skill_effect_id)

        skill_effect_data = self.skill_effects_data.get(str(skill_effect_id), {})
        target_filter = skill_effect_data.get("TargetFilter")
        if target_filter:
            result["filter"] = target_filter

        task_effects = skill_effect_data.get("TaskEffects", [])
        result["effects"] = [
            self._inline_effect_data(effect, next_seen, seen_buff_ids)
            for effect in task_effects
        ]
        return result

    def _extract_skill_effect_ids(
        self, buff_data: Dict[str, Any], passive_effect: Optional[Dict[str, Any]]
    ) -> List[int]:
        """从Buff和被动效果中提取技能效果ID"""
        skill_effect_ids = []
        add_skill_effect = buff_data.get("AddSkillEffect", [])
        if isinstance(add_skill_effect, list):
            for value in add_skill_effect:
                effect_id = self._to_int(value)
                if effect_id:
                    skill_effect_ids.append(effect_id)

        if skill_effect_ids:
            return skill_effect_ids

        vars_data = (passive_effect or {}).get("vars", {})
        if not isinstance(vars_data, dict):
            return []

        id_pairs = []
        for key, value in vars_data.items():
            match = re.match(r"^SkillEffectId(\d*)$", str(key))
            if match:
                order = int(match.group(1)) if match.group(1) else 1
                effect_id = self._to_int(value)
                if effect_id:
                    id_pairs.append((order, effect_id))
                continue

            # 兼容已内联后的字段: se/se2/se3...
            se_match = re.match(r"^se(\d*)$", str(key))
            if se_match:
                order = int(se_match.group(1)) if se_match.group(1) else 1
                effect_id = 0
                if isinstance(value, dict):
                    effect_id = self._to_int(value.get("id"))
                else:
                    effect_id = self._to_int(value)
                if effect_id:
                    id_pairs.append((order, effect_id))

        id_pairs.sort(key=lambda x: x[0])
        return [effect_id for _, effect_id in id_pairs]

    def _inline_mechanism_summon(
        self,
        effect: Any,
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Any:
        """当技能效果中创建机制召唤物时，内联MechanismSummon配置"""
        if not isinstance(effect, dict):
            return effect

        inlined_effect = copy.deepcopy(effect)
        if (
            inlined_effect.get("Function") == "CreateUnit"
            and inlined_effect.get("UnitType") == "MechanismSummon"
            and inlined_effect.get("UnitId")
        ):
            unit_id = inlined_effect.get("UnitId")
            summon_data = self.mechanism_summon_data.get(str(unit_id))
            if summon_data:
                summon_data = copy.deepcopy(summon_data)
                blue_print_params = summon_data.get("BluePrintParams")
                if isinstance(blue_print_params, dict):
                    summon_data["BluePrintParams"] = self._inline_skill_effect_refs(
                        blue_print_params, seen_effect_ids, seen_buff_ids
                    )
                inlined_effect["mechanismSummon"] = summon_data

        return inlined_effect

    def _inline_skill_creature(
        self,
        effect: Any,
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Any:
        """当技能效果创建SkillCreature时，内联SkillCreature配置"""
        if not isinstance(effect, dict):
            return effect

        inlined_effect = copy.deepcopy(effect)
        if inlined_effect.get(
            "Function"
        ) == "CreateSkillCreature" and inlined_effect.get("CreatureId"):
            creature_id = inlined_effect.get("CreatureId")
            creature_data = self.skill_creature_data.get(str(creature_id))
            if creature_data:
                creature_data = copy.deepcopy(creature_data)
                vars_data = creature_data.get("Vars")
                if isinstance(vars_data, dict):
                    creature_data["Vars"] = self._inline_skill_effect_refs(
                        vars_data, seen_effect_ids, seen_buff_ids
                    )
                inlined_effect["skillCreature"] = creature_data

        return inlined_effect

    def _inline_skill_effect_refs(
        self,
        value_dict: Dict[str, Any],
        seen_effect_ids: Optional[set],
        seen_buff_ids: Optional[set],
    ) -> Dict[str, Any]:
        """将 SkillEffectId/SkillEffectId2/SkillEffectId3... 转换为 se/se2/se3..."""
        result = copy.deepcopy(value_dict)
        key_pairs = []

        for key, value in value_dict.items():
            match = re.match(r"^SkillEffectId(\d*)$", str(key))
            if not match:
                continue
            order = int(match.group(1)) if match.group(1) else 1
            effect_id = self._to_int(value)
            key_pairs.append((order, key, effect_id))

        key_pairs.sort(key=lambda x: x[0])

        for order, old_key, effect_id in key_pairs:
            if old_key in result:
                del result[old_key]
            if not effect_id:
                continue
            new_key = "se" if order == 1 else f"se{order}"
            result[new_key] = self._build_skill_effect_entry(
                effect_id, seen_effect_ids, seen_buff_ids
            )

        return result

    def _inline_add_buff(
        self, effect: Any, seen_effect_ids: Optional[set], seen_buff_ids: Optional[set]
    ) -> Any:
        """当TaskEffect是AddBuff时，递归内联对应Buff结构"""
        if not isinstance(effect, dict):
            return effect

        inlined_effect = copy.deepcopy(effect)
        if inlined_effect.get("Function") != "AddBuff":
            return inlined_effect

        buff_id = self._to_int(inlined_effect.get("BuffId"))
        if not buff_id:
            return inlined_effect

        inlined_effect["buff"] = self._build_buff_entry(
            buff_id, seen_effect_ids, seen_buff_ids
        )
        return inlined_effect

    def _parse_desc_expression(self, expr: Any) -> Any:
        """解析描述表达式并返回可替换的值"""
        if not isinstance(expr, str):
            return expr

        match = re.search(r"\$(-)?(.*?)\$(.*)", expr)
        if not match:
            return expr

        has_neg = bool(match.group(1))
        inner_expr = match.group(2)
        suffix = match.group(3)

        try:
            value = self._calculate_expr_value(inner_expr, None, 1, "UIChildGuide")
            if has_neg:
                value = -value

            formatted = self._format_expr_number(value)
            if suffix:
                return f"{formatted}{suffix}"
            return formatted
        except Exception as e:
            print(f"解析GuideDescValues失败: {expr}, error: {e}", flush=True)
            return expr

    def _format_expr_number(self, value: Any) -> Any:
        """格式化表达式结果，整数不带小数点"""
        if not isinstance(value, (int, float)):
            return value

        rounded = self.round_value(float(value))
        if isinstance(rounded, float) and rounded.is_integer():
            return int(rounded)
        return rounded

    def _to_int(self, value: Any) -> int:
        """安全转换为int，失败时返回0"""
        try:
            return int(value)
        except (TypeError, ValueError):
            return 0

    def _remove_html_tags(self, text: str) -> str:
        """移除文本中的HTML标签"""
        if not isinstance(text, str):
            return ""
        return re.sub(r"<[^>]+>", "", text)
