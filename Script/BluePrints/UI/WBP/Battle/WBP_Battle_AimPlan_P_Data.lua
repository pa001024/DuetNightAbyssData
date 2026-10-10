return {
  TitleKey = "UI_AimPlan_Title",
  SettingsTipKey = "UI_AimPlan_SettingsTip",
  ApplyKey = "UI_AimPlan_Apply",
  RecommendKey = "UI_Server_Recommend",
  Plans = {
    [1] = {
      TitleKey = "UI_AimPlan_NormalPlan_Title",
      DescKey = "UI_AimPlan_NormalPlan_Desc1",
      ActionKeyMappings = {},
      KeyRows = {
        {
          TagKey = "UI_AimPlan_TagNew",
          KeyTextKey = "UI_AimPlan_KeyAim",
          ActionName = "PreAim"
        },
        {
          KeyTextKey = "UI_AimPlan_KeyFire",
          ActionName = "Fire"
        },
        {
          KeyTextKey = "UI_AimPlan_KeyMelee",
          ActionName = "Attack"
        }
      }
    },
    [2] = {
      TitleKey = "UI_AimPlan_FocusFirePlan_Title",
      DescKey = "UI_AimPlan_NormalPlan_Desc2",
      ActionKeyMappings = {
        PreAim = "RightMouseButton",
        Fire = "LeftMouseButton",
        Attack = "E",
        Skill1 = "One",
        Skill2 = "Two"
      },
      KeyRows = {
        {
          TagKey = "UI_AimPlan_TagNew",
          KeyTextKey = "UI_AimPlan_KeyAim",
          ActionName = "PreAim"
        },
        {
          TagKey = "UI_AimPlan_TagChanged",
          KeyTextKey = "UI_AimPlan_KeyFireChanged",
          ActionName = "Fire"
        },
        {
          TagKey = "UI_AimPlan_TagChanged",
          KeyTextKey = "UI_AimPlan_KeyMeleeChanged",
          ActionName = "Attack"
        },
        {
          TagKey = "UI_AimPlan_TagChanged",
          KeyTextKey = "UI_AimPlan_KeyCombatSkill",
          ActionName = "Skill1"
        },
        {
          TagKey = "UI_AimPlan_TagChanged",
          KeyTextKey = "UI_AimPlan_KeyUltimateSkill",
          ActionName = "Skill2"
        }
      }
    }
  }
}
