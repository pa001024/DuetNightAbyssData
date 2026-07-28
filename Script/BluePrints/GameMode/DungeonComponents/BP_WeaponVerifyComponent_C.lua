require("UnLua")
local BP_WeaponVerifyComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_WeaponVerifyComponent_C:InitWeaponVerifyComponent()
  self.GameMode = self:GetOwner()
  local PreInitInfo = self.GameMode.PreInitInfo
  local WeaponVerifyAffixId = PreInitInfo and PreInitInfo.WeaponVerifyAffixId
  if type(WeaponVerifyAffixId) == "table" then
    self.SelectedEntryIds = WeaponVerifyAffixId
  elseif WeaponVerifyAffixId then
    self.SelectedEntryIds = {WeaponVerifyAffixId}
  else
    self.SelectedEntryIds = {}
  end
  local WeaponVerifyInfo = DataMgr.WeaponVerify[self.GameMode.DungeonId]
  if not WeaponVerifyInfo then
    GameState(self):ShowDungeonError("WeaponVerifyComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.GlobalPassiveIds = WeaponVerifyInfo.GlobalPassiveId or {}
  self.IsForbidBattleWheel = WeaponVerifyInfo.IsForbidPhantomAndBattleWheel
end

function BP_WeaponVerifyComponent_C:InitWeaponVerifyBaseInfo()
  for _, GpId in pairs(self.GlobalPassiveIds) do
    Battle(self):AddGlobalPassive(GpId, nil, 0)
  end
  self:ActivateEntries(self.SelectedEntryIds)
  if self.IsForbidBattleWheel then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
      Player:DisableBattleWheel()
    end
  end
end

function BP_WeaponVerifyComponent_C:TriggerWeaponVerifyOnEnd()
  for _, GpId in pairs(self.GlobalPassiveIds) do
    Battle(self):RemoveGlobalPassive(GpId, nil)
  end
  self:DeactivateEntries(self.SelectedEntryIds)
end

function BP_WeaponVerifyComponent_C:OnTriggerWinTarget(RemainTime)
  DebugPrint("WeaponVerify: OnTriggerWinTarget, RemainTime=" .. tostring(RemainTime))
  self.GameMode:TriggerGameModeEvent("Event_OnTriggerWinTarget", RemainTime)
  EventManager:FireEvent(EventID.OnUpdateWeaponVerifyKillCount, 0, true)
end

function BP_WeaponVerifyComponent_C:ActivateEntries(EntryIds)
  if not EntryIds then
    return
  end
  local Battle = Battle(self)
  if not IsValid(Battle) then
    DebugPrint("WeaponVerify: ActivateEntries failed, Battle is invalid")
    return
  end
  for _, EntryId in ipairs(EntryIds) do
    local EntryData = DataMgr.WeaponVerifyEntry[EntryId]
    if not EntryData then
      DebugPrint("WeaponVerify: entry not found, id=" .. tostring(EntryId))
    else
      local GlobalPassives = EntryData.GlobalPassives
      if not GlobalPassives then
        DebugPrint("WeaponVerify: entry has no GlobalPassives, id=" .. tostring(EntryId))
      else
        for _, GpId in ipairs(GlobalPassives) do
          Battle:AddGlobalPassive(GpId, nil)
          DebugPrint("WeaponVerify: AddGlobalPassive, entry=" .. EntryId .. " gp=" .. GpId)
        end
      end
    end
  end
end

function BP_WeaponVerifyComponent_C:DeactivateEntries(EntryIds)
  if not EntryIds then
    return
  end
  local Battle = Battle(self)
  if not IsValid(Battle) then
    DebugPrint("WeaponVerify: DeactivateEntries failed, Battle is invalid")
    return
  end
  for _, EntryId in ipairs(EntryIds) do
    local EntryData = DataMgr.WeaponVerifyEntry[EntryId]
    if not EntryData then
    else
      local GlobalPassives = EntryData.GlobalPassives
      if not GlobalPassives then
      else
        for _, GpId in ipairs(GlobalPassives) do
          Battle:RemoveGlobalPassive(GpId, nil)
          DebugPrint("WeaponVerify: RemoveGlobalPassive, entry=" .. EntryId .. " gp=" .. GpId)
        end
      end
    end
  end
end

function BP_WeaponVerifyComponent_C:OnSyncTimerTick(GameRemainTime, TimerHandle)
  self:OnUpdateCountDown(GameRemainTime)
end

function BP_WeaponVerifyComponent_C:OnUpdateCountDown(GameRemainTime)
  EventManager:FireEvent(EventID.OnUpdateWeaponVerifyTime, GameRemainTime)
end

function BP_WeaponVerifyComponent_C:OnRep_KillCount(KillCount)
  EventManager:FireEvent(EventID.OnUpdateWeaponVerifyKillCount, KillCount, false)
end

function BP_WeaponVerifyComponent_C:GetBeginDelay()
  local WeaponVerifyInfo = DataMgr.WeaponVerify[self.GameMode.DungeonId]
  if not WeaponVerifyInfo then
    return 0
  end
  return WeaponVerifyInfo.BeginDelay
end

return BP_WeaponVerifyComponent_C
