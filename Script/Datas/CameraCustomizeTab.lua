local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CameraCustomizeTab", {
  [1] = {
    SortId = 10,
    TabId = 1,
    TabKey = "Basic",
    TextKey = "UI_CameraSystem_Basic"
  },
  [2] = {
    SortId = 20,
    TabId = 2,
    TabKey = "Action",
    TextKey = "UI_CameraSystem_Pose"
  },
  [3] = {
    SortId = 30,
    TabId = 3,
    TabKey = "Selection",
    TextKey = "UI_CameraSystem_ShowHide"
  }
})
