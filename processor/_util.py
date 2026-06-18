P_MAP = {
    "最大神智": "神智",
    "造成的伤害": "增伤",
    "造成技能伤害": "技能伤害",
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
    "全属性穿透": "属性穿透",
    "普通攻击伤害": "普攻增伤",
    "蓄力攻击伤害": "蓄力增伤",
    "下落攻击伤害": "下落增伤",
}


def get_attr_config_key_from_attr_data(attr_data, attr_config=None, unique_name=""):
    """按客户端 AvatarUtils 规则拼接属性键。"""
    if not isinstance(attr_data, dict):
        return ""

    attr_name = attr_data.get("AttrName", "")
    if not attr_name:
        return ""

    attr_config = attr_config or {}

    if attr_name in ("DamageRate", "DamagedRate"):
        if attr_data.get("IndividualRateZone"):
            key = f"{attr_name}_NoTag_{unique_name}"
            if key in attr_config:
                return key
        tag = attr_data.get("DamageTag") or attr_data.get("Tag")
        rate_zone = attr_data.get("RateZone")
        if tag or rate_zone:
            tag = tag or "NoTag"
            rate_zone = rate_zone or "Normal"
            client_key = f"{attr_name}_{tag}_{rate_zone}"
            if client_key in attr_config:
                return client_key
            zone_key = f"{attr_name}_{rate_zone}"
            if zone_key in attr_config:
                return zone_key
        if attr_name in attr_config:
            return attr_name
        if tag or rate_zone:
            return client_key
        return attr_name

    if attr_name in attr_config:
        return attr_name

    normal_key = f"{attr_name}_Normal"
    if normal_key in attr_config:
        return normal_key

    return attr_name
