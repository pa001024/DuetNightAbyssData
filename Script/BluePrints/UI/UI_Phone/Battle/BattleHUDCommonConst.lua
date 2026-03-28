local BattleHUDCommonConst = {}
BattleHUDCommonConst.DesignBaseConfigInHUD = {
  SkillPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_CharSkill_M.WBP_Battle_CharSkill_M_C'",
    WidgetName = "Skill",
    TextMapContent = "UI_CustomLayout_WidgetName30",
    InnerActiveSlateName = {
      {
        "CharSkill_1",
        "Button_Area"
      },
      {
        "CharSkill_2",
        "Button_Area"
      }
    },
    MaskNodeName = "Image_SkillPos"
  },
  AtkMeleePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkMelee_M.WBP_Battle_AtkMelee_M_C'",
    WidgetName = "AtkMelee",
    TextMapContent = "UI_CustomLayout_WidgetName27",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_AtkMeleePos"
  },
  AtkRangedPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRanged_M.WBP_Battle_AtkRanged_M_C'",
    WidgetName = "AtkRanged",
    TextMapContent = "UI_CustomLayout_WidgetName24",
    InnerActiveSlateName = "Image_Main",
    MaskNodeName = "Image_AtkRangedPos"
  },
  AtkRangedPosLeft = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRangedLeft_M.WBP_Battle_AtkRangedLeft_M_C'",
    WidgetName = "AtkRangedLeft",
    TextMapContent = "UI_CustomLayout_WidgetName19",
    InnerActiveSlateName = {
      "Btn_AtkRange",
      "Image_Main"
    },
    MaskNodeName = "Image_AtkRangedPosLeft"
  },
  JumpPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Jump_M.WBP_Battle_Jump_M_C'",
    WidgetName = "Jump",
    TextMapContent = "UI_CustomLayout_WidgetName31",
    InnerActiveSlateName = "Image_Main",
    MaskNodeName = "Image_JumpPos"
  },
  BulletJumpPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
    WidgetName = "BulletJump01",
    TextMapContent = "UI_CustomLayout_WidgetName23",
    InnerActiveSlateName = "Btn_BulletJump",
    MaskNodeName = "Image_BulletJumpPos"
  },
  BulletJumpPosLeft = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
    WidgetName = "BulletJump02",
    TextMapContent = "UI_CustomLayout_WidgetName18",
    InnerActiveSlateName = "Btn_BulletJump",
    MaskNodeName = "Image_BulletJumpPosLeft"
  },
  DodgePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Dodge_M.WBP_Battle_Dodge_M_C'",
    WidgetName = "Dodge",
    TextMapContent = "UI_CustomLayout_WidgetName26",
    InnerActiveSlateName = {
      "Button_Area",
      "Button_Area_1"
    },
    MaskNodeName = {
      "Image_DodgeType01",
      "Image_Dodgetype02"
    }
  },
  BulletPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Bullet_M.WBP_Battle_Bullet_M_C'",
    WidgetName = "Bullet",
    TextMapContent = "UI_CustomLayout_WidgetName25",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_BulletPos"
  },
  BattleMenuPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_BattleMenuBtn_M.WBP_BattleMenuBtn_M_C'",
    WidgetName = "Battle_Menu",
    TextMapContent = "UI_CustomLayout_WidgetName22",
    InnerActiveSlateName = {
      "Image_Menu",
      "Image_Close"
    },
    MaskNodeName = "Image_BattleMenuPos"
  },
  SupportSkillPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SupportSkill_M.WBP_Battle_SupportSkill_M_C'",
    WidgetName = "SupportSkill",
    TextMapContent = "UI_CustomLayout_WidgetName28",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_SupportSkillPos"
  },
  ExecutePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Execute_M.WBP_Battle_Execute_M_C'",
    WidgetName = "Execute",
    TextMapContent = "UI_CustomLayout_WidgetName21",
    InnerActiveSlateName = "Btn_Execute",
    MaskNodeName = "Image_ExecutePos"
  },
  AimLockedPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AimLocked_M.WBP_Battle_AimLocked_M_C'",
    WidgetName = "AimLocked",
    TextMapContent = "UI_CustomLayout_WidgetName29",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_AimLockedPos"
  },
  SquatPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Squat_M.WBP_Battle_Squat_M_C'",
    WidgetName = "Squat",
    TextMapContent = "UI_CustomLayout_WidgetName17",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_SquatPos"
  },
  WalkPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Walk_M.WBP_Battle_Walk_M_C'",
    WidgetName = "Walk",
    TextMapContent = "UI_CustomLayout_WidgetName16",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_WalkPos"
  },
  BattleCancelLeftPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletCancel_M.WBP_Battle_BulletCancel_M_C'",
    WidgetName = "CancelLeft",
    TextMapContent = "UI_CustomLayout_WidgetName14",
    InnerActiveSlateName = "Btn_Cancel",
    MaskNodeName = "Image_CancelPosLeft"
  },
  BattleCancelRightPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletCancel_M.WBP_Battle_BulletCancel_M_C'",
    WidgetName = "CancelRight",
    TextMapContent = "UI_CustomLayout_WidgetName15",
    InnerActiveSlateName = "Btn_Cancel",
    MaskNodeName = "Image_CancelPosRight"
  },
  SlideTacklePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SlideTackle_M.WBP_Battle_SlideTackle_M_C'",
    WidgetName = "SlideTackle",
    TextMapContent = "UI_CustomLayout_WidgetName32",
    InnerActiveSlateName = {
      "Image_Hotspot",
      "Button_Area"
    },
    MaskNodeName = "Image_SlideTackle",
    bIsNeedManualAdd = true
  },
  SlidingSlashPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SlidingSlash_M.WBP_Battle_SlidingSlash_M_C'",
    WidgetName = "SlidingSlash",
    TextMapContent = "UI_CustomLayout_WidgetName33",
    InnerActiveSlateName = {
      "Image_Hotspot",
      "Button_Area"
    },
    MaskNodeName = "Image_SlidingSlash",
    bIsNeedManualAdd = true
  },
  MapPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMap_M.WBP_SettingCustomMap_M_C'",
    WidgetName = "Map",
    TextMapContent = "UI_CustomLayout_WidgetName03",
    InnerActiveSlateName = "BtnMap",
    MaskNodeName = "Img_MapPos"
  },
  TaskPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomTask_M.WBP_SettingCustomTask_M_C'",
    WidgetName = "Task",
    TextMapContent = "UI_CustomLayout_WidgetName05",
    InnerActiveSlateName = "BtnChTask",
    MaskNodeName = "Img_TaskPos"
  },
  DropPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomDrop_M.WBP_SettingCustomDrop_M_C'",
    WidgetName = "Drop",
    TextMapContent = "UI_CustomLayout_WidgetName06",
    InnerActiveSlateName = "BtnChDrop",
    MaskNodeName = "Img_DropPos"
  },
  SystemPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomSystem_M.WBP_SettingCustomSystem_M'",
    WidgetName = "System",
    TextMapContent = "UI_CustomLayout_WidgetName08",
    InnerActiveSlateName = "BtnSystem",
    MaskNodeName = "Img_SystemPos"
  },
  TeamPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomTeam_M.WBP_SettingCustomTeam_M_C'",
    WidgetName = "Team",
    TextMapContent = "UI_CustomLayout_WidgetName09",
    InnerActiveSlateName = "BtnChTeam",
    MaskNodeName = "Img_TeamPos"
  },
  SpSkillPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomSpSkill_M.WBP_SettingCustomSpSkill_M_C'",
    WidgetName = "SpSkill",
    TextMapContent = "UI_CustomLayout_WidgetName10",
    InnerActiveSlateName = "BtnSpSkill",
    MaskNodeName = "Img_SpSkillPos",
    bNeedAddWorldPos = true
  },
  BloodPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomBlood_M.WBP_SettingCustomBlood_M_C'",
    WidgetName = "Blood",
    TextMapContent = "UI_CustomLayout_WidgetName07",
    InnerActiveSlateName = "BtnBlood",
    MaskNodeName = "Img_BloodPos"
  },
  MoveAutoPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMoveAuto_M.WBP_SettingCustomMoveAuto_M_C'",
    WidgetName = "MoveAuto",
    TextMapContent = "UI_CustomLayout_WidgetName13",
    InnerActiveSlateName = "BtnMoveAuto",
    MaskNodeName = "Image_MoveAutoPos",
    bNeedAddWorldPos = true
  },
  MovePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_SettingCustomMove_M.WBP_SettingCustomMove_M_C'",
    WidgetName = "Move",
    TextMapContent = "UI_CustomLayout_WidgetName20",
    InnerActiveSlateName = "Btn_Move",
    MaskNodeName = "Image_MovePos",
    bHasExtraLimitArea = true,
    bNeedAddWorldPos = true,
    RelativeNodeName = "MoveRangePos"
  }
}
BattleHUDCommonConst.ExtraNodeConfigInHUD = {
  Group_Map = {SettingNodeName = "MapPos", DefaultLayoutIndex = 1},
  Group_Task = {SettingNodeName = "TaskPos", DefaultLayoutIndex = 2},
  Group_Drop = {SettingNodeName = "DropPos", DefaultLayoutIndex = 3},
  Pos_Entry = {
    SettingNodeName = "SystemPos",
    bUseParentSlot = true,
    DefaultLayoutIndex = 4
  },
  Team = {SettingNodeName = "TeamPos", DefaultLayoutIndex = 5},
  HUD_Bar = {SettingNodeName = "BloodPos", DefaultLayoutIndex = 6}
}
BattleHUDCommonConst.AllHasRelativeNodeWidgetList = {"MovePos"}
BattleHUDCommonConst.ManualAdditionConfigInHUD = {
  SlideTackle = {
    NodeIdx = 1,
    LayoutInHUDPosName = "SlideTacklePos",
    EffectWidgetName = "Jump",
    ShowText = GText("UI_CustomLayout_WidgetName32"),
    DefaultDesignPosition = {X = -610.0, Y = -180.0},
    DefaultDesignScale = 1.0
  },
  SlidingSlash = {
    NodeIdx = 2,
    LayoutInHUDPosName = "SlidingSlashPos",
    EffectWidgetName = "Jump",
    ShowText = GText("UI_CustomLayout_WidgetName33"),
    DefaultDesignPosition = {X = -534.0, Y = -315.0},
    DefaultDesignScale = 1.0
  }
}
BattleHUDCommonConst.LayOutSettingConfig = {
  bIsSupportLongPress = false,
  MoveOffsetStep = 1,
  DefaultScaleValue = 1.0,
  MaxScaleValue = 2,
  MinScaleValue = 0.2,
  EdgeLimitThreshold = 0,
  MaxOperationHistoryCount = 1
}
BattleHUDCommonConst.VisualJoystickConfig = {
  AreaRangeYPercentMin = 0.5,
  AreaRangeYPercentMax = 0.8,
  DefaultAreaRangeXPercent = 0.5,
  DefaultAreaRangeYPercent = 0.6
}
BattleHUDCommonConst.MoveOffsetStep = 5
BattleHUDCommonConst.SettingPageNpcId = 900003
return BattleHUDCommonConst
