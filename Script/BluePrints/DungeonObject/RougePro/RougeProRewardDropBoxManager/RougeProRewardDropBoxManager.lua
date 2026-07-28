local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougeProRewardDropBoxManager = DungeonClass.Class()

function RougeProRewardDropBoxManager:BeginPlay()
  self:InitReplicatedProperties(self, "RewardDropBoxList", {}, "OnRep_RewardDropBoxList")
end

function RougeProRewardDropBoxManager:OnRoundFinish()
  for UniqueId, RougeProRewardDropBox in pairs(self.RewardDropBoxList) do
    local OwnerAvatarEid = RougeProRewardDropBox.OwnerAvatarEids[1]
    self:__GetRewardDropBox(OwnerAvatarEid, UniqueId, true)
  end
end

function RougeProRewardDropBoxManager:OnChangeRound()
end

function RougeProRewardDropBoxManager:RandomRewardDropBoxInfo(RewardDropBoxId)
  local tabRewardDropBox = DataMgr.RougePro_RewardDropBox[RewardDropBoxId]
  assert(tabRewardDropBox)
  local DropIndex = -1
  local RandomValue = math.random()
  for i = 1, #tabRewardDropBox.RewardBoxRate do
    if RandomValue - tabRewardDropBox.RewardBoxRate[i] <= 0 and tabRewardDropBox.RewardBoxMechanismID[i] then
      DropIndex = i
      break
    end
    RandomValue = RandomValue - tabRewardDropBox.RewardBoxRate[i]
  end
  return DropIndex, tabRewardDropBox.RewardBoxMechanismID[DropIndex]
end

function RougeProRewardDropBoxManager:CreateRewardDropBox_StaticPoint(RewardDropBoxId, RewardInfo, StaticPoint)
  local DropIndex, MechanismUnitId = self:RandomRewardDropBoxInfo(RewardDropBoxId)
  print(string.format("RougeProRewardDropBoxManager:CreateRewardDropBox_StaticPoint(RewardDropBoxId=%s) DropIndex=%s MechanismId=%s", tostring(RewardDropBoxId), tostring(DropIndex), tostring(MechanismUnitId)))
  if -1 == DropIndex or nil == MechanismUnitId then
    return
  end
  RewardInfo.DropIndex = DropIndex
  RewardInfo.MechanismUnitId = MechanismUnitId
  local RewardDropBoxAttr = RougeProSceneObjAttr()
  RewardDropBoxAttr:SetRewardDropBoxInfo(RewardInfo)
  self:SceneObjManagerStaticCreatorActive({StaticPoint}, RewardDropBoxAttr, MechanismUnitId)
end

function RougeProRewardDropBoxManager:CreateRewardDropBox_MonsterDrop(RewardDropBoxId, RewardInfo, MonsterInfo)
  local DropIndex, MechanismUnitId = self:RandomRewardDropBoxInfo(RewardDropBoxId)
  print(string.format("RougeProRewardDropBoxManager:CreateRewardDropBox_MonsterDrop(RewardDropBoxId=%s) DropIndex=%s MechanismId=%s", tostring(RewardDropBoxId), tostring(DropIndex), tostring(MechanismUnitId)))
  if -1 == DropIndex or nil == MechanismUnitId then
    return
  end
  RewardInfo.DropIndex = DropIndex
  RewardInfo.MechanismUnitId = MechanismUnitId
  local RewardDropBoxAttr = RougeProSceneObjAttr()
  RewardDropBoxAttr:SetRewardDropBoxInfo(RewardInfo)
  local MechanismInfo = self:CreateMechanism(MechanismUnitId, {bDropMechanism = true})
  assert(MechanismInfo)
  self:RegisterMechanismSceneObjAttr(MechanismInfo.UniqueId, RewardDropBoxAttr)
  self:OnCreateRougeProEventRewardDropBox(MechanismInfo.UniqueId, RewardDropBoxAttr)
  local DropMechanismInfo = {
    UnitId = MechanismInfo.UnitId,
    UniqueId = MechanismInfo.UniqueId,
    Transform = MonsterInfo.Transform,
    DropReason = "MonsterDrop",
    MonsterUnitId = MonsterInfo.UnitId
  }
  self:NotifyGameModeDungeonEvent("ServerCreateDropMechanism", DropMechanismInfo)
end

function RougeProRewardDropBoxManager:OnCreateRougeProEventRewardDropBox(UniqueId, RewardDropBoxAttr)
  local RewardDropBoxInfo = RewardDropBoxAttr:GetRewardDropBoxInfo()
  local RougeProRewardDropBoxClass = require("BluePrints.DungeonObject.RougePro.RougeProRewardDropBoxManager.RougeProRewardDropBox")
  local RewardDropBox = RougeProRewardDropBoxClass(self, UniqueId)
  RewardDropBox.OwnerAvatarEids = RewardDropBoxInfo.OwnerAvatarEids
  RewardDropBox:FillRewardDropBox(RewardDropBoxInfo.RewardDropBoxId, RewardDropBoxInfo.DropIndex)
  self.RewardDropBoxList[UniqueId] = RewardDropBox
  self.RewardDropBoxList = self.RewardDropBoxList
  self:NotifyGameModeDungeonEvent("OnCreateRougeProEventRewardDropBox", UniqueId)
end

function RougeProRewardDropBoxManager:__GetRewardDropBox(AvatarEid, UniqueId, RandomChoice)
  print(string.format("__GetRewardDropBox(AvatarEid=%s, UniqueId=%s, RandomChoice=%s)", tostring(AvatarEid), tostring(UniqueId), tostring(RandomChoice)))
  local Mechanism = self:GetMechanism(UniqueId)
  if nil == Mechanism then
    print(string.format("OnNotifyServerDungeonEvent_OpenRougeProRewardDropBox(%s %s) Mechanism ==nil", tostring(UniqueId), tostring(AvatarEid)))
    return
  end
  local Player = self:GetPlayer(AvatarEid)
  if nil == Player then
    return
  end
  local RewardDropBox = self.RewardDropBoxList[UniqueId]
  if nil == RewardDropBox then
    print(string.format("OnNotifyServerDungeonEvent_OpenRougeProRewardDropBox(%s %s) RewardDropBox ==nil", tostring(UniqueId), tostring(AvatarEid)))
    return
  end
  if CommonUtils.HasValue(RewardDropBox.OwnerAvatarEids, AvatarEid) == false then
    print(string.format("OnNotifyServerDungeonEvent_OpenRougeProRewardDropBox(%s %s) OwnerAvatarEids check fail ", tostring(UniqueId), tostring(AvatarEid)))
    return
  end
  if RewardDropBox.IsOpend == true then
    print(string.format("OnNotifyServerDungeonEvent_OpenRougeProRewardDropBox(%s %s) IsOpend=true ", tostring(UniqueId), tostring(AvatarEid)))
    return
  end
  if RewardDropBox.TreasureList then
    for i = 1, #RewardDropBox.TreasureList do
      self:AddTreasureForPlayer(Player, RewardDropBox.TreasureList[i])
    end
  end
  if RewardDropBox.Token then
    Player:AddToken(RewardDropBox.Token)
  end
  self.RewardDropBoxList[UniqueId] = nil
  self.RewardDropBoxList = self.RewardDropBoxList
end

function RougeProRewardDropBoxManager:RougePro_OpenRougeProRewardDropBox(EventInfo)
  print("RougePro_OpenRougeProRewardDropBox")
  local UniqueId = EventInfo.UniqueId
  local AvatarEid = EventInfo.PlayerEid
  self:__GetRewardDropBox(AvatarEid, UniqueId, false)
  self:NotifyGameModeMechanismState(EventInfo)
end

function RougeProRewardDropBoxManager:OnNotifyServerDungeonEvent_MechanismGiveReward(EventInfo)
  print(string.format("RougeProRewardDropBoxManager:OnNotifyServerDungeonEvent_MechanismGiveReward EventInfo = %s", CommonUtils.TableToString3(EventInfo)))
  local UniqueId = EventInfo.UniqueId
  local AvatarEid = EventInfo.PlayerEid
  if self.RewardDropBoxList[UniqueId] then
    self:NotifyGameModeDungeonEvent("ServerDestroyDropMechanism", EventInfo)
    self.RewardDropBoxList[UniqueId] = nil
    self.RewardDropBoxList = self.RewardDropBoxList
  end
end

return RougeProRewardDropBoxManager
