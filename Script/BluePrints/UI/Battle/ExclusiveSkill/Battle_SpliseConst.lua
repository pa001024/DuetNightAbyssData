local M = {}
M.Visibility = {
  ScopeInactiveTag = "SpliseScopeInactive"
}
M.Spectrum = {
  BuffId = 410311,
  ActiveOpacity = 1,
  InactiveOpacity = 0.5,
  ActiveTextOpacity = 1,
  InactiveTextOpacity = 0,
  FadeDuration = 0.2,
  FadeInterval = 0.016,
  UpdateInterval = 0.2
}
M.Charge = {
  DataSetKey = "SpLiseSkill02Percent",
  RadiusMax = 0.5,
  RadiusMin = 0.05,
  Width = 0.001,
  Smooth = 0.25,
  ResetSmooth = 0.85,
  ProgressTolerance = 1.0E-4,
  ScaleMin = 0.24,
  OutsideParameter = "Circle_Outside",
  InsideParameter = "Circle_InSide",
  UltBuffId = 410321,
  ScopeBuffId = 410322,
  UpdateInterval = 0.016
}
M.Multiplier = {
  DataSetKey = "SpLiseSkill02FovMulti",
  Tiers = {
    1,
    1.5,
    2,
    2.5,
    3,
    3.5,
    4
  },
  DialConfig = {
    PC = {
      StartAngle = 265,
      SpacingAngle = 9,
      SelectAngle = 360,
      SectorCentralAngle = 63,
      ReverseSlots = false
    },
    Mobile = {
      StartAngle = 95,
      SpacingAngle = 9,
      SelectAngle = 180,
      SectorCentralAngle = 63,
      ReverseSlots = true
    }
  },
  Smooth = 0.2,
  AngleTolerance = 0.01,
  UpdateInterval = 0.016,
  UIName = "UISkillSpliseMultiplier",
  SliderDragStep = 0.16666666666666666
}
M.Kill = {
  DataSetKey = "SpLiseSkill02KillCount",
  UpdateInterval = 0.2,
  LabelKey = "SKILL_DESC_KillEnemy",
  LabelFallback = "SKILL_DESC_KillEnemy",
  Points = {
    "Ponit_1",
    "Ponit_2",
    "Ponit_3",
    "Ponit_4",
    "Ponit_5",
    "Ponit_6"
  }
}
M.Feedback = {
  ResetTailOffset = 0.01,
  Type = {Hit = "Hit", Kill = "Kill"}
}
M.Skin = {
  DefaultProfile = "Default",
  ProfileByCharUIId = {
    [47] = "SpLise01",
    [48] = "SpLise01"
  },
  ProfileBySkinId = {
    [410301] = "SpLise01"
  },
  Profiles = {
    Default = {
      EnableKillFeedback = false,
      MultiplierUIName = M.Multiplier.UIName,
      LeafSoundEvent = "event:/sfx/player/SpLise/skill02_kill"
    },
    SpLise01 = {
      EnableKillFeedback = true,
      MultiplierUIName = "UISkillSpliseMultiplier01",
      LeafSoundEvent = "event:/sfx/player/SpLise01/skill02_kill"
    }
  }
}
M.Reload = {
  AmmoWidgetName = "BattleAmmoBar",
  Duration = 0.9,
  UpdateInterval = 0.016,
  HidePercent = 0.95
}
M.Input = {
  Actions = {
    Up = "ZoomInputUp",
    ShootKey = "Attack",
    ExitKey = "Fire"
  },
  MobileScopeFireIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Battle/Weapon/T_SPLise_ScopeFire.T_SPLise_ScopeFire'",
  Descriptions = {
    Shoot = "SKILL_DESC_4103Skill02_Button01",
    Exit = "SKILL_DESC_4103Skill02_Button02"
  },
  WeaponShootHintSource = "SpliseUltiScope",
  Pages = {Keyboard = 0, Gamepad = 1},
  MouseIcon = "MouseScroll",
  GamepadDirectionIcon = "Vertical",
  MobileGuideRefreshDelay = 0.016
}
return M
