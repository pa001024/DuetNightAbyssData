local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildEntranceSettings", {
  [1] = {
    GroupID = "DisplaySettings",
    GroupTitle = "显示设置",
    ID = 1,
    ItemType = "CheckBox",
    Option = {
      ID = "GridShow",
      Label = "网格显示",
      State = true
    },
    Sorted = 1
  },
  [2] = {
    GroupID = "DisplaySettings",
    GroupTitle = "显示设置",
    ID = 2,
    ItemType = "CheckBox",
    Option = {
      ID = "EffectShow",
      Label = "特效显示",
      State = true
    },
    Sorted = 1
  },
  [3] = {
    GroupID = "CameraAngle",
    GroupTitle = "镜头视角",
    ID = 3,
    ItemType = "Switch",
    Option = {
      GroupID = "CamOption",
      ID = "FreeCam",
      Label = "自由视角",
      State = true
    },
    Sorted = 2
  },
  [4] = {
    GroupID = "CameraAngle",
    GroupTitle = "镜头视角",
    ID = 4,
    ItemType = "Switch",
    Option = {
      GroupID = "CamOption",
      ID = "TopCam",
      Label = "俯视角",
      State = false
    },
    Sorted = 2
  },
  [5] = {
    GroupID = "ComponentMove",
    GroupTitle = "组件移动",
    ID = 5,
    ItemType = "Switch",
    Option = {
      GroupID = "MoveWay",
      ID = "GridMove",
      Label = "网格移动",
      State = true
    },
    Sorted = 3
  },
  [6] = {
    GroupID = "ComponentMove",
    GroupTitle = "组件移动",
    ID = 6,
    ItemType = "Switch",
    Option = {
      GroupID = "MoveWay",
      ID = "PixelMove",
      Label = "像素移动",
      State = false
    },
    Sorted = 3
  },
  [7] = {
    GroupID = "QuickDemolish",
    GroupTitle = "一键拆除",
    ID = 7,
    ItemType = "Button",
    Option = {
      ID = "DemolishBuilding",
      Label = "建筑"
    },
    Sorted = 4
  },
  [8] = {
    GroupID = "QuickDemolish",
    GroupTitle = "一键拆除",
    ID = 8,
    ItemType = "Button",
    Option = {
      ID = "DemolishDeco",
      Label = "装饰"
    },
    Sorted = 4
  },
  [9] = {
    GroupID = "QuickDemolish",
    GroupTitle = "一键拆除",
    ID = 9,
    ItemType = "Button",
    Option = {
      ID = "DemolishBlock",
      Label = "基本石块"
    },
    Sorted = 4
  }
})
