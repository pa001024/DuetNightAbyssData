local BP_RougePro_C = Class("BluePrints.DungeonObject.BP_DungeonObject_C")
local RougeProPlayerUtils = require("BluePrints.DungeonObject.RougePro.RougeProPlayerUtils")

local function ResolveAvatarEid(AvatarEid)
  if nil ~= AvatarEid then
    return AvatarEid
  end
  local Avatar = GWorld:GetAvatar()
  return Avatar and Avatar.Eid
end

local function IsSameAvatarEid(AvatarEidStr, AvatarEid)
  if not AvatarEidStr or nil == AvatarEid then
    return false
  end
  local EidStr = CommonUtils.ObjId2Str(AvatarEid) or tostring(AvatarEid)
  return AvatarEidStr == EidStr or AvatarEidStr == tostring(AvatarEid)
end

local function IsTeamEffectTreasureGroup(GroupConfig)
  if not GroupConfig or not GroupConfig.ActivateNeed then
    return false
  end
  for _, TreasureId in ipairs(GroupConfig.ActivateNeed) do
    local TreasureData = DataMgr.RougeProTreasure and DataMgr.RougeProTreasure[TreasureId]
    if TreasureData and TreasureData.Unique then
      return true
    end
  end
  return false
end

local function HasBriefTreasure(Brief, TreasureId)
  if not Brief or not Brief.RougeProTreasureList then
    return false
  end
  for i = 1, Brief.RougeProTreasureList:Num() do
    if Brief.RougeProTreasureList[i] == TreasureId then
      return true
    end
  end
  return false
end

function BP_RougePro_C:GetLocalPlayerBrief(AvatarEid)
  if not self.PlayerBriefList then
    return nil
  end
  AvatarEid = ResolveAvatarEid(AvatarEid)
  if nil == AvatarEid then
    return nil
  end
  for i = 1, self.PlayerBriefList:Num() do
    local Brief = self.PlayerBriefList[i]
    if Brief and IsSameAvatarEid(Brief.AvatarEidStr, AvatarEid) then
      return Brief
    end
  end
  return nil
end

function BP_RougePro_C:ReceiveBeginPlay()
  BP_RougePro_C.Super.ReceiveBeginPlay(self)
  print("BP_RougePro_C BeginPlay")
end

function BP_RougePro_C:OnRep_PlayerBriefList()
  for i = 1, self.PlayerBriefList:Num() do
    print(string.format("BP_RougePro_C:OnRep_PlayerBriefList RougeProProfession = %d", self.PlayerBriefList[i].RougeProProfession))
  end
end

function BP_RougePro_C:OnRep_EventList()
  for i = 1, self.EventList:Num() do
    print(string.format("BP_RougePro_C:OnRep_EventList EventID=[%d]", self.EventList[i].EventId))
  end
end

function BP_RougePro_C:OnRep_RoomList()
  for i = 1, self.RoomList:Num() do
    print(string.format("BP_RougePro_C:OnRep_RoomList [%d] [%d]", i, self.RoomList[i]))
  end
end

function BP_RougePro_C:OnRep_Round()
  print("BP_RougePro_C:OnRep_Round = " .. tostring(self.Round))
  local LevelLoader = GWorld.RougelikeLevelLoader
  if LevelLoader then
    LevelLoader:TryRougeLikeEnterRoom(self.Round)
  end
end

function BP_RougePro_C:OnRep_GetTreasureNotify()
  print("JLY BP_RougePro_C:OnRep_GetTreasureNotify")
  local Notify = self.GetTreasureNotify
  if not Notify or 0 == Notify.TreasureId then
    return
  end
  RougeProPlayerUtils.ShowGetTreasureTips({
    Notify.TreasureId
  })
end

function BP_RougePro_C:GetLocalPlayerDeadNum()
  local Brief = self:GetLocalPlayerBrief()
  if Brief then
    return Brief.PlayerDeadNum or 0
  end
  return 0
end

function BP_RougePro_C:GetLocalTreasureCount()
  local Brief = self:GetLocalPlayerBrief()
  if Brief and Brief.RougeProTreasureList then
    return Brief.RougeProTreasureList:Num()
  end
  return 0
end

function BP_RougePro_C:GetLocalTokenCount()
  local Brief = self:GetLocalPlayerBrief()
  if Brief then
    return Brief.Token or 0
  end
  return 0
end

function BP_RougePro_C:HasLocalRougeProTreasure(TreasureId)
  return HasBriefTreasure(self:GetLocalPlayerBrief(), TreasureId)
end

function BP_RougePro_C:HasTeamRougeProTreasure(TreasureId)
  if not self.PlayerBriefList then
    return false
  end
  for i = 1, self.PlayerBriefList:Num() do
    if HasBriefTreasure(self.PlayerBriefList[i], TreasureId) then
      return true
    end
  end
  return false
end

function BP_RougePro_C:IsTreasureGroupFullyCollected(TreasureGroupId)
  local GroupConfig = DataMgr.RougeProTreasureGroup and DataMgr.RougeProTreasureGroup[TreasureGroupId]
  if not GroupConfig or not GroupConfig.ActivateNeed then
    return false
  end
  if not self:GetLocalPlayerBrief() then
    return false
  end
  local bTeamGroup = IsTeamEffectTreasureGroup(GroupConfig)
  for _, NeedTreasureId in ipairs(GroupConfig.ActivateNeed) do
    local bHasTreasure
    if bTeamGroup then
      bHasTreasure = self:HasTeamRougeProTreasure(NeedTreasureId)
    else
      bHasTreasure = self:HasLocalRougeProTreasure(NeedTreasureId)
    end
    if not bHasTreasure then
      return false
    end
  end
  return true
end

function BP_RougePro_C:HasAnyActivatedTreasureGroup()
  if not self:GetLocalPlayerBrief() then
    return false
  end
  for _, GroupConfig in pairs(DataMgr.RougeProTreasureGroup or {}) do
    local GroupId = GroupConfig.GroupId
    if GroupId and self:IsTreasureGroupFullyCollected(GroupId) then
      return true
    end
  end
  return false
end

function BP_RougePro_C:HasAnyActivatedTeamTreasureGroup()
  if not self:GetLocalPlayerBrief() then
    return false
  end
  for _, GroupConfig in pairs(DataMgr.RougeProTreasureGroup or {}) do
    if IsTeamEffectTreasureGroup(GroupConfig) then
      local GroupId = GroupConfig.GroupId
      if GroupId and self:IsTreasureGroupFullyCollected(GroupId) then
        return true
      end
    end
  end
  return false
end

function BP_RougePro_C:IsTeamMutualDistanceWithin(MaxDistance)
  if not GWorld or not GWorld.GameInstance then
    return true
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState or not GameState.GetAllPlayer then
    return true
  end
  local Locations = {}
  for _, PlayerCharacter in pairs(GameState:GetAllPlayer()) do
    local Location = PlayerCharacter.CurrentLocation
    if not Location and PlayerCharacter.K2_GetActorLocation then
      Location = PlayerCharacter:K2_GetActorLocation()
    end
    if Location then
      Locations[#Locations + 1] = Location
    end
  end
  if #Locations < 2 then
    return true
  end
  for i = 1, #Locations do
    for j = i + 1, #Locations do
      if MaxDistance < UE4.UKismetMathLibrary.Vector_Distance(Locations[i], Locations[j]) then
        return false
      end
    end
  end
  return true
end

function BP_RougePro_C:OnRep_ChestInfoList()
  self.LocalChestInfoIndex = {}
  local LocalAvatarEidStr = self:GetLocalAvatarEidStr()
  for i, ChestInfo in pairs(self.ChestInfoList) do
    if ChestInfo.OwnerAvatarEidStr == LocalAvatarEidStr then
      table.insert(self.LocalChestInfoIndex, i)
    end
  end
end

function BP_RougePro_C:GetLocalAvatarEidStr()
  if self.LocalAvatarEidStr == nil then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.LocalAvatarEidStr = Player.PlayerState.AvatarEidStr
  end
  return self.LocalAvatarEidStr
end

return BP_RougePro_C
