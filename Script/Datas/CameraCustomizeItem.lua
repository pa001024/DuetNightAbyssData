local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CameraCustomizeItem", {
  [101] = {
    AllowAll = false,
    ControlSelectionItemId = 0,
    DefaultBool = false,
    Handler = "OnLookAtCameraChanged",
    ItemId = 101,
    ItemKey = "LookAtCamera",
    NewKey = "LookAtCamera",
    SortId = 10,
    TabId = 1,
    TextKey = "UI_CameraSystem_Basic_LookCamera",
    Type = "Switch"
  },
  [102] = {
    AllowAll = false,
    ControlSelectionItemId = 0,
    DefaultNumber = 180,
    Handler = "OnRoleRotationChanged",
    ItemId = 102,
    ItemKey = "RoleRotation",
    MaxValue = 360,
    MinValue = 0,
    NewKey = "RoleRotation",
    SortId = 20,
    Step = 1,
    TabId = 1,
    TextKey = "UI_CameraSystem_Basic_CharRotation",
    Type = "Slide"
  },
  [201] = {
    AllowAll = false,
    ControlSelectionItemId = 0,
    Handler = "OnActionPlay",
    ItemId = 201,
    ItemKey = "WheelAction",
    NewKey = "WheelAction",
    SortId = 10,
    TabId = 2,
    TextKey = "UI_CameraSystem_Pose",
    Type = "Action"
  },
  [301] = {
    AllowAll = false,
    ControlSelectionItemId = 302,
    DefaultBool = false,
    ItemId = 301,
    ItemKey = "TargetSelectionAll",
    NewKey = "TargetSelectionAll",
    SortId = 10,
    TabId = 3,
    TextKey = "UI_CameraSystem_HideModelAll",
    Type = "Switch"
  },
  [302] = {
    AllowAll = false,
    ControlSelectionItemId = 0,
    Handler = "OnSelectionChanged",
    ItemId = 302,
    ItemKey = "TargetSelection",
    NewKey = "TargetSelection",
    SortId = 20,
    TabId = 3,
    TextKey = "显示对象",
    Type = "Selection"
  }
})
