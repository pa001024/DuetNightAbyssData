local hotfix_data = "-- 请在此处编写HotFix代码,请组长编写\n\n"
return {
  index = 0,
  script = hotfix_data,
  client_version = {ForceUpdateCheck = "6"},
  force_update_version = "6",
  patch_version = {
    ["1"] = "0"
  }
}
