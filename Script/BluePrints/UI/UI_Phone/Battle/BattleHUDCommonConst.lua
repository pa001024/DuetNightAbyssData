local BattleHUDCommonConst = {}
BattleHUDCommonConst.DesignBaseConfigInHUD = {
  SkillPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_CharSkill_M.WBP_Battle_CharSkill_M_C'",
    WidgetName = "Skill",
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
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_AtkMeleePos"
  },
  AtkRangedPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRanged_M.WBP_Battle_AtkRanged_M_C'",
    WidgetName = "AtkRanged",
    InnerActiveSlateName = "Image_Main",
    MaskNodeName = "Image_AtkRangedPos"
  },
  AtkRangedPosLeft = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AtkRangedLeft_M.WBP_Battle_AtkRangedLeft_M_C'",
    WidgetName = "AtkRanged_1",
    InnerActiveSlateName = {
      "Btn_AtkRange",
      "Image_Main"
    },
    MaskNodeName = "Image_AtkRangedPosLeft"
  },
  JumpPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Jump_M.WBP_Battle_Jump_M_C'",
    WidgetName = "Jump",
    InnerActiveSlateName = "Image_Main",
    MaskNodeName = "Image_JumpPos"
  },
  BulletJumpPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
    WidgetName = "BulletJump01",
    InnerActiveSlateName = "Btn_BulletJump",
    MaskNodeName = "Image_BulletJumpPos"
  },
  BulletJumpPos_Left = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_BulletJump_M.WBP_Battle_BulletJump_M_C'",
    WidgetName = "BulletJump02",
    InnerActiveSlateName = "Btn_BulletJump",
    MaskNodeName = "Image_BulletJumpPos_Left"
  },
  DodgePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Dodge_M.WBP_Battle_Dodge_M_C'",
    WidgetName = "Dodge",
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
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_BulletPos"
  },
  BattleMenuPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_BattleMenuBtn_M.WBP_BattleMenuBtn_M_C'",
    WidgetName = "Battle_Menu",
    InnerActiveSlateName = {
      "Image_Menu",
      "Image_Close"
    },
    MaskNodeName = "Image_BattleMenuPos"
  },
  SupportSkillPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_SupportSkill_M.WBP_Battle_SupportSkill_M_C'",
    WidgetName = "SupportSkill",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_SupportSkillPos"
  },
  ExecutePos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Execute_M.WBP_Battle_Execute_M_C'",
    WidgetName = "Execute",
    InnerActiveSlateName = "Btn_Execute",
    MaskNodeName = "Image_ExecutePos"
  },
  AimLockedPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_AimLocked_M.WBP_Battle_AimLocked_M_C'",
    WidgetName = "AimLocked",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_AimLockedPos"
  },
  SquatPos = {
    WidgetClass = "WidgetBlueprint'/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_Squat_M.WBP_Battle_Squat_M_C'",
    WidgetName = "Squat",
    InnerActiveSlateName = "Button_Area",
    MaskNodeName = "Image_SquatPos"
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
BattleHUDCommonConst.MoveOffsetStep = 5
return BattleHUDCommonConst
