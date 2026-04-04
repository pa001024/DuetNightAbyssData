"""技能创造物提取工具。"""


def extract_skill_creatures(
    skill_id,
    skill_data,
    skill_node_data,
    skill_effects_data,
    skill_creature_data,
    limit=8,
    keep_hidden=False,
):
    """从技能链中提取 CreateSkillCreature 对应的创造物数据。"""
    skill_info = skill_data.get(str(skill_id), {})
    if not skill_info:
        skill_info = skill_data.get(skill_id, {})
    if not isinstance(skill_info, list) or not skill_info:
        return []

    skill_entry = skill_info[0]
    if isinstance(skill_entry, list) and skill_entry:
        skill_entry = skill_entry[0]
    if not isinstance(skill_entry, dict):
        return []
    root_skill_type = skill_entry.get("SkillType")

    begin_node_id = skill_entry.get("BeginNodeId")
    if not begin_node_id:
        return []

    creatures = []
    seen_creature_keys = set()
    visited_nodes = set()
    visited_effects = set()
    visited_skills = set()

    def collect_from_effect(
        effect_id,
        inherited_interval=None,
        source_loop_shoot_id=None,
    ):
        effect_key = str(effect_id)
        effect_visit_key = (effect_key, source_loop_shoot_id)
        if effect_visit_key in visited_effects:
            return
        visited_effects.add(effect_visit_key)

        effect = skill_effects_data.get(effect_key, {})
        if not effect:
            effect = skill_effects_data.get(effect_id, {})
        if not isinstance(effect, dict):
            return

        task_effects = effect.get("TaskEffects", [])
        if not isinstance(task_effects, list):
            return

        for task_effect in task_effects:
            if not isinstance(task_effect, dict):
                continue

            function_name = task_effect.get("Function")
            if function_name == "CreateSkillCreature":
                creature_id = task_effect.get("CreatureId")
                creature_key = (creature_id, source_loop_shoot_id)
                if creature_id in (None, "") or creature_key in seen_creature_keys:
                    continue
                seen_creature_keys.add(creature_key)
                creature = _simplify_skill_creature(
                    creature_id,
                    skill_creature_data.get(str(creature_id)),
                    keep_hidden=keep_hidden,
                )
                if creature and inherited_interval is not None:
                    creature["射击间隔"] = inherited_interval
                if creature:
                    creatures.append(creature)
                continue

            next_interval = inherited_interval
            next_source_loop_shoot_id = source_loop_shoot_id
            if function_name == "StartLoopShoot":
                loop_interval = task_effect.get("LoopInterval")
                if isinstance(loop_interval, (int, float)):
                    next_interval = loop_interval
                loop_shoot_id = task_effect.get("LoopShootId")
                if loop_shoot_id not in (None, ""):
                    next_source_loop_shoot_id = loop_shoot_id

            if function_name == "Executeskilleffect":
                continue

            for child_key in ("SkillEffect", "EffectIds"):
                child_effect_ids = task_effect.get(child_key, [])
                if not isinstance(child_effect_ids, list):
                    child_effect_ids = [child_effect_ids]
                for child_effect_id in child_effect_ids:
                    if child_effect_id in (None, ""):
                        continue
                    collect_from_effect(
                        child_effect_id,
                        next_interval,
                        next_source_loop_shoot_id,
                    )

    def collect_from_skill(
        inner_skill_id,
        inherited_interval=None,
        source_loop_shoot_id=None,
    ):
        skill_key = str(inner_skill_id)
        skill_visit_key = (skill_key, source_loop_shoot_id)
        if skill_visit_key in visited_skills:
            return
        visited_skills.add(skill_visit_key)

        skill_info = skill_data.get(str(inner_skill_id), {})
        if not skill_info:
            skill_info = skill_data.get(inner_skill_id, {})
        if not isinstance(skill_info, list) or not skill_info:
            return

        skill_entry = skill_info[0]
        if isinstance(skill_entry, list) and skill_entry:
            skill_entry = skill_entry[0]
        if not isinstance(skill_entry, dict):
            return

        begin_node_id = skill_entry.get("BeginNodeId")
        if not begin_node_id:
            return

        current = begin_node_id
        steps = 0
        while current and current not in visited_nodes and steps < max(limit, 1):
            visited_nodes.add(current)
            steps += 1

            node = skill_node_data.get(str(current), {})
            if not node:
                node = skill_node_data.get(current, {})
            if not isinstance(node, dict):
                break

            effect_ids = node.get("SkillNodeEffects", [])
            if not isinstance(effect_ids, list):
                effect_ids = [effect_ids]

            for effect_id in effect_ids:
                collect_from_effect(
                    effect_id,
                    inherited_interval,
                    source_loop_shoot_id,
                )

            current = node.get("NextNodeId")

    collect_from_skill(skill_id, None, skill_id)

    skill_info = skill_data.get(str(skill_id), {})
    if not skill_info:
        skill_info = skill_data.get(skill_id, {})
    if isinstance(skill_info, list) and skill_info:
        skill_entry = skill_info[0]
        if isinstance(skill_entry, list) and skill_entry:
            skill_entry = skill_entry[0]
        if isinstance(skill_entry, dict):
            for sub_skill_id in skill_entry.get("SubSkills", []) or []:
                if sub_skill_id == skill_id:
                    continue
                collect_from_skill(sub_skill_id, None, skill_id)

    if root_skill_type == "Skill2":
        for related_skill_id, related_entries in skill_data.items():
            if str(related_skill_id) == str(skill_id):
                continue
            if not isinstance(related_entries, list) or not related_entries:
                continue
            related_entry = related_entries[0]
            if isinstance(related_entry, list) and related_entry:
                related_entry = related_entry[0]
            if not isinstance(related_entry, dict):
                continue
            if related_entry.get("ClientSkillLogicId") != skill_id:
                continue
            collect_from_skill(related_skill_id, None, skill_id)

        for effect_id, effect in skill_effects_data.items():
            if not isinstance(effect, dict):
                continue
            task_effects = effect.get("TaskEffects", [])
            if not isinstance(task_effects, list):
                continue
            for task_effect in task_effects:
                if not isinstance(task_effect, dict):
                    continue
                if task_effect.get("Function") != "StartLoopShoot":
                    continue
                if task_effect.get("LoopShootId") != skill_id:
                    continue
                loop_interval = task_effect.get("LoopInterval")
                if not isinstance(loop_interval, (int, float)):
                    loop_interval = None
                child_effect_ids = task_effect.get("SkillEffect", [])
                if not isinstance(child_effect_ids, list):
                    child_effect_ids = [child_effect_ids]
                for child_effect_id in child_effect_ids:
                    if child_effect_id in (None, ""):
                        continue
                    collect_from_effect(
                        child_effect_id,
                        loop_interval,
                        skill_id,
                    )

    return creatures


def _simplify_skill_creature(creature_id, creature_data, keep_hidden=False):
    """精简 SkillCreature 输出，只保留最必要的信息。"""
    if not isinstance(creature_data, dict):
        return {"id": creature_id}

    skip_time_life = False
    if creature_data.get("TimeLife") == -1:
        if keep_hidden:
            skip_time_life = True
        else:
            return None

    result = {"id": creature_id}

    shape_info = creature_data.get("ShapeInfo")
    if isinstance(shape_info, dict) and shape_info:
        simplified_shape = {}
        shape_type = shape_info.get("ShapeType")
        if shape_type:
            simplified_shape["类型"] = shape_type
        for key, value in shape_info.items():
            if key == "ShapeType":
                continue
            if value in (None, ""):
                continue
            simplified_shape[key] = value
        if simplified_shape:
            result["形状"] = simplified_shape

    for source_key, target_key in (
        ("TimeLife", "时长"),
        ("Speed", "速度"),
        ("Tags", "标签"),
    ):
        if skip_time_life and source_key == "TimeLife":
            continue
        value = creature_data.get(source_key)
        if value in (None, "", []):
            continue
        if source_key == "Speed" and value == 0:
            continue
        if source_key == "Tags" and isinstance(value, list):
            value = [item for item in value if item != "PauseInvisible"]
            if not value:
                continue
        result[target_key] = value

    vars_data = creature_data.get("Vars")
    if isinstance(vars_data, dict) and vars_data:
        result["Vars"] = vars_data

    loop_effects = creature_data.get("LoopExecuteSkillEffects")
    if isinstance(loop_effects, dict):
        interval = loop_effects.get("Interval")
        if isinstance(interval, (int, float)):
            result["特效循环间隔"] = interval

    return result
