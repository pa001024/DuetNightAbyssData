local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CameraCustomizeSubItem", {
  [30201] = {
    DefaultSelected = false,
    NewKey = "Selection_Role",
    ParentItemId = 302,
    SortId = 10,
    SubItemId = 30201,
    SubKey = "Role",
    TextKey = "UI_CameraSystem_HideModel_Character"
  },
  [30202] = {
    DefaultSelected = false,
    NewKey = "Selection_Player",
    ParentItemId = 302,
    SortId = 20,
    SubItemId = 30202,
    SubKey = "Player",
    TextKey = "UI_CameraSystem_HideModel_OtherPlayer"
  },
  [30203] = {
    DefaultSelected = false,
    NewKey = "Selection_NPC",
    ParentItemId = 302,
    SortId = 30,
    SubItemId = 30203,
    SubKey = "NPC",
    TextKey = "UI_CameraSystem_HideModel_NPC"
  },
  [30204] = {
    DefaultSelected = false,
    NewKey = "Selection_Monster",
    ParentItemId = 302,
    SortId = 40,
    SubItemId = 30204,
    SubKey = "Monster",
    TextKey = "UI_CameraSystem_HideModel_Monster"
  },
  [30205] = {
    DefaultSelected = false,
    NewKey = "Selection_Pet",
    ParentItemId = 302,
    SortId = 50,
    SubItemId = 30205,
    SubKey = "Pet",
    TextKey = "UI_CameraSystem_HideModel_Pet"
  }
})
