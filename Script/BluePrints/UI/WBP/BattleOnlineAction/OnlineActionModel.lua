local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")
local M = Class("BluePrints.Common.MVC.Model")
local EMLuaConst = require("EMLuaConst")

function M:Init()
  DebugPrint("OnlineActionModel Init")
  M.Super.Init(self)
  self._Avatar = nil
  self:GetAvatar()
  self.ActionResourceId = 0
  self.ActionUniqueId = 0
  self.MaxPlayerNum = 0
  self.NearbyPlayerInfos = {}
  self.ApplyInfos = {}
  self.InvitationInfos = {}
  self.NameTemp = {}
  ReddotManager.AddNodeEx("OnlineActionBtn")
  self:InitConst()
  self.LastNearbyQueryTime = 0
end

function M:InitConst()
  DebugPrint("OnlineActionModel InitConst RegionOnlineNearbyMaxCount " .. EMLuaConst.RegionOnlineNearbyMaxCount .. " RegionOnlineNearbyMaxDist " .. EMLuaConst.RegionOnlineNearbyMaxDist)
  EMLuaConst.RegionOnlineNearbyMaxCount = OnlineActionCommon.MaxNearbyPlayers
  EMLuaConst.RegionOnlineNearbyMaxDist = OnlineActionCommon.NearbtPlayDistance
  DebugPrint("AfterOnlineActionModel InitConst RegionOnlineNearbyMaxCount " .. EMLuaConst.RegionOnlineNearbyMaxCount .. " RegionOnlineNearbyMaxDist " .. EMLuaConst.RegionOnlineNearbyMaxDist)
end

function M:CreatFakeInvitationInfo()
  self.InvitationInfos = {}
  self.ApplyInfos = {}
  for i = 1, 20 do
    local FakeInvitationInfo = {
      Uid = "FakeUid" .. i,
      NickName = "FakePlayer" .. i,
      Actor = nil,
      Eid = "FakeEid" .. i,
      Level = 10,
      HeadIconId = 10001,
      HeadFrameId = -1,
      TitleBefore = 10001,
      TitleAfter = 0,
      TitleFrame = 10001,
      bNew = true,
      RecivedTime = os.clock(),
      RemainTime = OnlineActionCommon.AutoRejectTime
    }
    table.insert(self.InvitationInfos, FakeInvitationInfo)
    local FakeApplyInfo = {
      Uid = "FakeUid" .. i,
      NickName = "FakePlayer" .. i,
      Actor = nil,
      Eid = "FakeEid" .. i,
      Level = 10,
      InteractiveId = 1,
      HeadIconId = 10001,
      HeadFrameId = -1,
      TitleBefore = 10001,
      TitleAfter = 0,
      TitleFrame = 10001,
      bNew = true,
      RecivedTime = os.clock(),
      RemainTime = OnlineActionCommon.AutoRejectTime
    }
    table.insert(self.ApplyInfos, FakeApplyInfo)
    local FakeNearbyPlayerInfo = {
      Uid = "FakeUid" .. i,
      NickName = "FakePlayer" .. i,
      ObjId = "FakeObjId" .. i,
      Actor = nil,
      Level = 10,
      HeadIconId = 10001,
      HeadFrameId = -1,
      TitleBefore = 10001,
      TitleAfter = 0,
      TitleFrame = 10001
    }
    table.insert(self.NearbyPlayerInfos, FakeNearbyPlayerInfo)
  end
  ReddotManager.IncreaseLeafNodeCount("OnlineActionBtn", 1)
end

function M:GetActionUniqueId()
  if 0 ~= self.ActionUniqueId then
    return self.ActionUniqueId
  end
  return nil
end

function M:GetResourceIdByUniqueId(UniqueId)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
  if not Mechanism then
    return 0
  end
  return Mechanism.ResourceId
end

function M:GetActionNameByUniqueId(UniqueId)
  local ResourceId = self:GetResourceIdByUniqueId(UniqueId)
  if 0 == ResourceId then
    return ""
  end
  if DataMgr.Resource[ResourceId] and DataMgr.Resource[ResourceId].ResourceName then
    return DataMgr.Resource[ResourceId].ResourceName
  end
  return ""
end

function M:GetMaxInteractiveNum(UniqueId)
  local ResourceId = self:GetResourceIdByUniqueId(UniqueId)
  if 0 == ResourceId then
    return 1
  end
  if DataMgr.Resource[ResourceId] and DataMgr.Resource[ResourceId].InteractPlayerNum then
    return DataMgr.Resource[ResourceId].InteractPlayerNum
  end
  return 1
end

function M:GetMaxPlayerNum()
  self.ActionResourceId = self:GetResourceIdByUniqueId(self.ActionUniqueId)
  if not self.ActionResourceId or 0 == self.ActionResourceId then
    if not self.ActionUniqueId then
      ScreenPrint("获得当前动作的可容纳人数失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
      return 1
    end
    self.ActionResourceId = self:GetResourceIdByUniqueId(self.ActionUniqueId)
  end
  if not self.ActionResourceId or 0 == self.ActionResourceId then
    ScreenPrint("获得当前动作的可容纳人数仍然失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
    return 1
  end
  if DataMgr.Resource[self.ActionResourceId] and DataMgr.Resource[self.ActionResourceId].InteractPlayerNum then
    self.MaxPlayerNum = DataMgr.Resource[self.ActionResourceId].InteractPlayerNum
  else
    if not DataMgr.Resource[self.ActionResourceId] then
      ScreenPrint("获得当前动作的可容纳人数仍然失败，没找到对应的Resource self.ActionResourceId=" .. tostring(self.ActionResourceId))
      return 1
    end
    DebugPrintTable(DataMgr.Resource[self.ActionResourceId])
    ScreenPrint("！！！！请检查资源表的InteractPlayerNum获得当前动作的可容纳人数失败，没找到对应的InteractPlayer self.ActionResourceId=" .. tostring(self.ActionResourceId))
    self.MaxPlayerNum = 1
  end
  DebugPrint("联机动作获取人数 GetMaxPlayerNum: MaxPlayerNum=" .. tostring(self.MaxPlayerNum))
  return self.MaxPlayerNum or 1
end

function M:HaveOtherInvitation()
  if not self.InvitationInfos or next(self.InvitationInfos) == nil then
    return false
  end
  return true
end

function M:HaveOtherApply()
  if not self.ApplyInfos or next(self.ApplyInfos) == nil then
    return false
  end
  return true
end

function M:GetNearbyPlayerInfos()
  return self.NearbyPlayerInfos
end

function M:GetApplyInfos()
  return self.ApplyInfos
end

function M:GetInvitationInfos()
  return self.InvitationInfos
end

function M:RemoveInvitationInfo(Info)
  for index, InvitationInfo in pairs(self.InvitationInfos or {}) do
    if InvitationInfo == Info then
      table.remove(self.InvitationInfos, index)
      DebugPrint("RemoveInvitationInfo: Removed invitation for Uid: " .. (Info.Uid or ""))
      self:CheckIsNeedHideBtn()
      return
    end
  end
  DebugPrint("RemoveInvitationInfo: Info not found in invitations: " .. (Info.Uid or ""))
end

function M:CheckIsNeedHideBtn()
  local Controller = self:GetController()
  if Controller and 1 ~= Controller.OpenReason then
    local hasInvitation = self.InvitationInfos and next(self.InvitationInfos) ~= nil
    local hasApply = self.ApplyInfos and nil ~= next(self.ApplyInfos)
    if not hasInvitation and not hasApply then
      Controller:HideBtn()
    end
  end
  if Controller and 2 == Controller.OpenReason then
    local invs = self.InvitationInfos
    if not invs or next(invs) == nil then
      Controller:HideBtn()
    end
  end
end

function M:RemoveApplyInfo(Info)
  for index, ApplyInfo in pairs(self.ApplyInfos) do
    if ApplyInfo == Info then
      table.remove(self.ApplyInfos, index)
      DebugPrint("RemoveApplyInfo: Removed apply for Uid: " .. tostring(Info and Info.Uid or ""))
      self:CheckIsNeedHideBtn()
      return
    end
  end
  DebugPrint("RemoveApplyInfo: Info not found in applys: " .. tostring(Info and Info.Uid or ""))
end

function M:SetAllInfoRead()
  for _, InvitationInfo in pairs(self.InvitationInfos) do
    InvitationInfo.bNew = false
  end
  for _, ApplyInfo in pairs(self.ApplyInfos) do
    ApplyInfo.bNew = false
  end
  ReddotManager.ClearLeafNodeCount("OnlineActionBtn")
end

function M:ChangeAction(UniqueId)
  if UniqueId then
    self.ActionUniqueId = UniqueId
  else
    self.MaxPlayerNum = 1
  end
end

function M:FindPlayerAround()
  self._Avatar = GWorld:GetAvatar()
  if -1 == self._Avatar.CurrentOnlineType then
    return
  end
  self.NearbyPlayerInfos = {}
  if OnlineActionCommon.UseSyncNearbyPlayers then
    local Sync = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if not Sync or Sync:IsNearbyResultUninitialized() then
      ScreenPrint("::意外错误，多线程查找附近玩家失败,多线程数据没有准备好")
      return
    end
    local NearbyIds = Sync:GetNearbyPlayersIDs()
    if not NearbyIds then
      return
    end
    DebugPrint("开始使用多线程查找结果生成待邀请列表")
    local added = 0
    for i = 1, NearbyIds:Length() do
      local eidstr = NearbyIds:GetRef(i)
      local eid = CommonUtils.Str2ObjId(eidstr)
      local OtherPlayer = self._Avatar:GetBornedChar(eid)
      local AvatarData = self._Avatar.RegionAvatars[eid]
      if OtherPlayer and AvatarData and AvatarData.AvatarInfo and not OtherPlayer:CharacterInTag("Seating") then
        table.insert(self.NearbyPlayerInfos, {
          Uid = AvatarData.AvatarInfo.Uid,
          NickName = AvatarData.AvatarInfo.Nickname,
          Eid = eid,
          Actor = OtherPlayer,
          Level = AvatarData.AvatarInfo.Level or 1,
          TitleBefore = AvatarData.AvatarInfo.TitleBefore,
          TitleAfter = AvatarData.AvatarInfo.TitleAfter,
          TitleFrame = AvatarData.AvatarInfo.TitleFrame or 10001,
          HeadIconId = AvatarData.AvatarInfo.HeadIconId,
          HeadFrameId = AvatarData.AvatarInfo.HeadFrameId
        })
        added = added + 1
        if added >= EMLuaConst.RegionOnlineNearbyMaxCount then
          break
        end
      end
    end
    return
  else
    DebugPrint("关闭多线程查找附近玩家，在Lua层寻找")
  end
end

function M:CheckNearbyInfoVaild(NearbyInfo, Index)
  local Eid = NearbyInfo.Eid
  local Char = self._Avatar:GetBornedChar(Eid)
  if not Char then
    ScreenPrint("CheckNearbyInfoVaild: 玩家" .. CommonUtils.ObjId2Str(Eid) .. "不存在")
    return -1
  end
  local MainPlayer = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not MainPlayer then
    DebugPrint("CheckNearbyInfoVaild: MainPlayer is nil")
    return -1
  end
  local MainPlayerLocation = MainPlayer:K2_GetActorLocation()
  local OtherPlayerLocation = Char:K2_GetActorLocation()
  local CalDistanceFunc = UE4.UKismetMathLibrary.Vector_Distance
  local Distance = CalDistanceFunc(MainPlayerLocation, OtherPlayerLocation)
  if Distance >= OnlineActionCommon.NearbtPlayDistance then
    return -1
  end
  if Char:CharacterInTag("Seating") then
    return -2
  end
  if self.ActionUniqueId and nil ~= Index then
    local Mechanism = self:GetMechanism()
    if Mechanism then
      local interactiveId0 = math.max(0, (Index or 1) - 1)
      local ok = self:IsSeatValid(Mechanism, interactiveId0)
      if not ok then
        return -3
      end
    end
  end
  return true
end

function M:AddInvitationInfo(RequestEid, UniqueId, InteractiveId)
  self._Avatar = GWorld:GetAvatar()
  local AvatarData = self._Avatar.RegionAvatars[RequestEid]
  if not AvatarData then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local InvitationInfo = {
    Uid = AvatarData.AvatarInfo.Uid,
    NickName = AvatarData.AvatarInfo.Nickname,
    Actor = self._Avatar:GetBornedChar(AvatarData.AvatarInfo.ObjId),
    Eid = RequestEid,
    UniqueId = UniqueId,
    Level = AvatarData.AvatarInfo.Level or 1,
    InteractiveId = InteractiveId,
    HeadIconId = AvatarData.AvatarInfo.HeadIconId,
    HeadFrameId = AvatarData.AvatarInfo.HeadFrameId,
    TitleBefore = AvatarData.AvatarInfo.TitleBefore,
    TitleAfter = AvatarData.AvatarInfo.TitleAfter,
    TitleFrame = AvatarData.AvatarInfo.TitleFrame,
    bNew = true,
    RecivedTime = GameState and GameState.ReplicatedRealTimeSeconds or 0.0,
    RemainTime = OnlineActionCommon.AutoRejectTime
  }
  table.insert(self.InvitationInfos, InvitationInfo)
  return InvitationInfo
end

function M:AddApplyInfo(OwnerEid, UniqueId, InteractiveId)
  self._Avatar = GWorld:GetAvatar()
  local AvatarData = self._Avatar.RegionAvatars[OwnerEid]
  if not AvatarData then
    ScreenPrint("OnlineAction 收到了申请，但是玩家" .. CommonUtils.ObjId2Str(OwnerEid) .. "不存在")
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local NewApplication = {
    Uid = AvatarData.AvatarInfo.Uid,
    NickName = AvatarData.AvatarInfo.Nickname,
    Actor = self._Avatar:GetBornedChar(AvatarData.AvatarInfo.ObjId),
    Eid = OwnerEid,
    Level = AvatarData.AvatarInfo.Level or 1,
    UniqueId = UniqueId,
    InteractiveId = InteractiveId,
    HeadIconId = AvatarData.AvatarInfo.HeadIconId,
    HeadFrameId = AvatarData.AvatarInfo.HeadFrameId,
    TitleBefore = AvatarData.AvatarInfo.TitleBefore,
    TitleAfter = AvatarData.AvatarInfo.TitleAfter,
    TitleFrame = AvatarData.AvatarInfo.TitleFrame,
    bNew = true,
    RecivedTime = GameState and GameState.ReplicatedRealTimeSeconds or 0.0,
    RemainTime = OnlineActionCommon.AutoRejectTime
  }
  table.insert(self.ApplyInfos, NewApplication)
  return NewApplication
end

function M:NotifyTick(InDeltaTime)
  local Controller = self:GetController()
  local bHasChanged = false
  if not self.UGameplayStatics then
    self.UGameplayStatics = UE4.UGameplayStatics
  end
  if not self.GameInstance then
    self.GameInstance = GWorld.GameInstance
  end
  local nowSeconds = self.UGameplayStatics and self.UGameplayStatics.GetRealTimeSeconds(self.GameInstance) or 0.0
  if not self.ActionUniqueId then
    return
  end
  for i = #self.InvitationInfos, 1, -1 do
    local InvitationInfo = self.InvitationInfos[i]
    local expire = OnlineActionCommon.AutoRejectTime
    local start = InvitationInfo.RecivedTime or nowSeconds
    InvitationInfo.RemainTime = expire - (nowSeconds - start)
    if InvitationInfo.RemainTime <= 0 then
      Controller:SendRejectInvitation(InvitationInfo)
      self:RemoveInvitationInfo(InvitationInfo)
      bHasChanged = true
    end
  end
  for i = #self.ApplyInfos, 1, -1 do
    local ApplyInfo = self.ApplyInfos[i]
    local expire = OnlineActionCommon.AutoRejectTime
    local start = ApplyInfo.RecivedTime or nowSeconds
    ApplyInfo.RemainTime = expire - (nowSeconds - start)
    if ApplyInfo.RemainTime <= 0 then
      Controller:SendRejectApplication(ApplyInfo)
      self:RemoveApplyInfo(ApplyInfo)
      bHasChanged = true
    end
  end
  if bHasChanged then
    self:CheckbHasAnyNewInfo()
  end
end

function M:ClearAllApply()
  self.ApplyInfos = {}
end

function M:CheckbHasAnyNewInfo()
  for _, InvitationInfo in pairs(self.InvitationInfos) do
    if InvitationInfo.bNew then
      return true
    end
  end
  for _, ApplyInfo in pairs(self.ApplyInfos) do
    if ApplyInfo.bNew then
      return true
    end
  end
  return false
end

function M:GetPlayerName(Eid)
  local AvatarData = self._Avatar.RegionAvatars[Eid]
  if AvatarData then
    return AvatarData.AvatarInfo.Nickname
  else
    ScreenPrint("OnlineAction 收到了申请，但是玩家" .. tostring(Eid) .. "不存在")
  end
  return ""
end

function M:GetPlayerActor(Eid)
  if Eid == self._Avatar.Eid then
    return UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  end
  local AvatarData = self._Avatar.RegionAvatars[Eid]
  if not AvatarData then
    return false
  end
  local Actor = self._Avatar:GetBornedChar(Eid)
  if not Actor then
    return false
  end
  return Actor
end

function M:GetPlayerName(Eid)
  local AvatarData = self._Avatar.RegionAvatars[Eid]
  if AvatarData then
    return AvatarData.AvatarInfo.Nickname
  end
  return ""
end

function M:IsInRegionOnline()
  return self._Avatar and self._Avatar.IsInRegionOnline
end

function M:GetController()
  if self.Controller then
    return self.Controller
  else
    self.Controller = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  end
  return self.Controller
end

function M:Destory()
  DebugPrint("OnlineActionModel Destory")
  self.NearbyPlayerInfos = nil
  self.ApplyInfos = nil
  self.InvitationInfos = nil
  self.Controller = nil
  self.UGameplayStatics = nil
  self.GameInstance = nil
  M.Super.Destory(self)
end

function M:SortByRemainTime(kind, desc)
  local list
  if 1 == kind then
    list = self.ApplyInfos
  elseif 3 == kind then
    list = self.InvitationInfos
  else
    return
  end
  if not list or next(list) == nil then
    return
  end
  local descending = false ~= desc
  table.sort(list, function(a, b)
    local ra = a and a.RemainTime or 0
    local rb = b and b.RemainTime or 0
    if ra ~= rb then
      if descending then
        return ra > rb
      else
        return ra < rb
      end
    end
    local ta = a and a.RecivedTime or 0
    local tb = b and b.RecivedTime or 0
    if ta ~= tb then
      if descending then
        return ta < tb
      else
        return ta > tb
      end
    end
    return false
  end)
end

function M:GetMechanism()
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(self.ActionUniqueId)
  if not Mechanism then
    DebugPrint("寻找机关失败，机关不存在  " .. self.ActionUniqueId)
    return false
  end
  return Mechanism
end

function M:GetSeatVaildInfo()
  local Mechanism = self:GetMechanism()
  if not Mechanism then
    return false
  end
  local ValidPoint = Mechanism:GetValidPoint()
  DebugPrintTable(ValidPoint)
  return ValidPoint
end

function M:IfHaveSeatValid()
  local SeatVaildInfo = self:GetSeatVaildInfo()
  if not SeatVaildInfo then
    return false
  end
  for index, Info in pairs(SeatVaildInfo) do
    if Info.Valid and index + 1 <= self.MaxPlayerNum then
      return true
    end
  end
  return false
end

function M:GetMechanismByUniqueId(UniqueId)
  if not UniqueId then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if not GameState then
    return false
  end
  return GameState.RegionOnlineMechanismMap:Find(UniqueId)
end

function M:IsSeatValid(Mechanism, InteractiveId)
  if not Mechanism then
    return false
  end
  if nil == InteractiveId then
    return false
  end
  return Mechanism:CheckInteractiveIdValid(InteractiveId)
end

function M:CheckJoinValid(Eid, UniqueId, InteractiveId)
  local Actor = self:GetPlayerActor(Eid)
  if not Actor then
    return -1
  end
  if Actor:CharacterInTag("Seating") then
    return -3
  end
  local Mechanism = self:GetMechanismByUniqueId(UniqueId)
  if not Mechanism then
    return -2
  end
  local actorLoc = Actor:K2_GetActorLocation()
  local mechLoc = Mechanism:K2_GetActorLocation()
  local dist = UE4.UKismetMathLibrary.Vector_Distance(actorLoc, mechLoc)
  if dist > OnlineActionCommon.NearbtPlayDistance then
    return -2
  end
  if nil ~= InteractiveId then
    local ok = self:IsSeatValid(Mechanism, InteractiveId)
    if not ok then
      return -4
    end
  elseif not self:IfHaveSeatValid() then
    return -4
  end
  return 0
end

function M:GetAutoAcceptOnlineAction()
  local AutoAcceptOnlineAction = EMCache:Get("AutoAcceptOnlineAction")
  DebugPrint("AutoAcceptOnlineAction", AutoAcceptOnlineAction)
  return AutoAcceptOnlineAction
end

return M
