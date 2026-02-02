local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CommonQuestReward", {
  [1001] = {
    EventId = 103018,
    Icon = "/Game/UI/Texture/Dynamic/Image/Prop/Activity/T_Icon_ActivityFool_03.T_Icon_ActivityFool_03",
    Id = 1001,
    Name = "UI_Accessory_Name_10088",
    QuestId = {
      10301801,
      10301802,
      10301803,
      10301804,
      10301805,
      10301806
    },
    Reward = 110907
  }
})
