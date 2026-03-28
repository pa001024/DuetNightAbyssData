local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AttrLimit", {
  ATKRange = {
    AttachAttrName = "ATK",
    AttrName = "ATKRange",
    MinLimitValue = 0
  },
  ATK_CharRange = {
    AttachAttrName = "ATK_Char",
    AttrName = "ATK_CharRange",
    MinLimitValue = 0
  },
  DEFRange = {
    AttachAttrName = "DEF",
    AttrName = "DEFRange",
    MinLimitValue = 0
  },
  DefaultMaxAttackSpeed = {
    AttachAttrName = "MaxAttackSpeed",
    AttrName = "DefaultMaxAttackSpeed",
    LimitValue = 3
  },
  Equip_ATKRange = {
    AttachAttrName = "Equip_ATK",
    AttrName = "Equip_ATKRange",
    MinLimitValue = 0
  },
  MaxBulletJumpVelocityModifier = {
    AttachAttrName = "BulletJumpVelocityModifier",
    AttrName = "MaxBulletJumpVelocityModifier",
    LimitValue = 3
  },
  MaxHpRange = {
    AttachAttrName = "MaxHp",
    AttrName = "MaxHpRange",
    MinLimitValue = 1
  },
  MaxJumpVelocityModifier = {
    AttachAttrName = "JumpVelocityModifier",
    AttrName = "MaxJumpVelocityModifier",
    LimitValue = 3
  },
  MaxSkillEfficiency = {
    AttachAttrName = "SkillEfficiency",
    AttrName = "MaxSkillEfficiency",
    LimitValue = 1.75
  },
  MaxSkillRange = {
    AttachAttrName = "SkillRange",
    AttrName = "MaxSkillRange",
    LimitValue = 2.8
  },
  MaxSkillSustain = {
    AttachAttrName = "SkillSustain",
    AttrName = "MaxSkillSustain",
    LimitValue = 4
  },
  MaxSlideVelocityModifier = {
    AttachAttrName = "SlideVelocityModifier",
    AttrName = "MaxSlideVelocityModifier",
    LimitValue = 3
  },
  MaxTriggerProbability = {
    AttachAttrName = "TriggerProbability",
    AttrName = "MaxTriggerProbability",
    LimitValue = 1
  },
  MaxWalkSpeedModifier = {
    AttachAttrName = "WalkSpeedModifier",
    AttrName = "MaxWalkSpeedModifier",
    LimitValue = 0.6
  },
  SpChangeLimitPercent = {
    AttrName = "SpChangeLimitPercent",
    LimitValue = 0.25
  }
})
