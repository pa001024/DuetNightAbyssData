local hotfix_data = "-- 请在此处编写HotFix代码,请组长编写\n\tConst.ProgressRecoverDungeonType.Survival = false\n\tConst.ProgressRecoverDungeonType.SurvivalPro = false\n\tConst.ProgressRecoverDungeonType.SurvivalMini = false\n\tConst.ProgressRecoverDungeonType.Defence = false\n\tConst.ProgressRecoverDungeonType.Excavation = false\n\n"
return {
  index = 1,
  script = hotfix_data,
  client_version = {ForceUpdateCheck = "3"},
  force_update_version = "3",
  patch_version = {
    ["1"] = "0"
  }
}
