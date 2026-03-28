require("UnLua")
local BP_SynthesisComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_SynthesisComponent_C:InitSynthesisComponent()
  self.GameMode = self:GetOwner()
  self.IconPathYellow = "MainMission"
  self.IconPathRed = "DefeatMission"
  self.IconPathSpecialEnemy = "SpecialEnemy"
  self.TextTitle = "DUNGEON_SYNTHESIS_100"
  local SynthesisInfo = DataMgr.Synthesis[self.GameMode.DungeonId]
  if not SynthesisInfo then
    GameState(self):ShowDungeonError("SynthesisComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.MonAddRage = SynthesisInfo.MonAddRage or 1
  self.BreakableAddRage = SynthesisInfo.BreakableAddRage or 0.1
  self.MechanismAddRageMap = SynthesisInfo.MechanismAddRageMap or {}
  self.RageValueStages = SynthesisInfo.RageValueStages or {100}
  self.MaxRageValue = self.RageValueStages[#self.RageValueStages]
  self.SupervisorCreatorIds = SynthesisInfo.SupervisorCreatorIds or {}
  self.OccupationTargetNum = SynthesisInfo.OccupationTargetNum or 7
  self.BlastMonInterval = SynthesisInfo.BlastMonInterval or 60
  self.KeyNeedNum = SynthesisInfo.KeyNeedNum or 6
  self.CurMission = ""
  self.OccupateGuide = {}
  DebugPrint("SynthesisComponent: InitSynthesisComponent")
  GWorld:DSBLog("Info", "SynthesisComponent: InitSynthesisComponent", "GameMode")
end

function BP_SynthesisComponent_C:InitSynthesisBaseInfo()
  self.GameMode:AddDungeonEvent("SynthesisBuffList")
end

function BP_SynthesisComponent_C:TriggerSynthesisOnEnd()
  self.GameMode:RemoveDungeonEvent("SynthesisBuffList")
end

function BP_SynthesisComponent_C:OnUnitDeadEvent(MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
  local OnDeadfuncName = "OnUnitDeadEvent_" .. self.CurMission
  if self[OnDeadfuncName] then
    self[OnDeadfuncName](self, MonsterC, KillMineRoleEid, KillMineSkillId, DeathReason)
  end
end

function BP_SynthesisComponent_C:OnCombatPropDeadEvent(CombatProp)
  local OnSpawnfuncName = "OnCombatPropDeadEvent_" .. self.CurMission
  if self[OnSpawnfuncName] then
    self[OnSpawnfuncName](self, CombatProp)
  end
end

function BP_SynthesisComponent_C:OnStaticCreatorEvent(EventName, Eid, UnitId, UnitType, CreatorId)
  local OnStaticCreatorfuncName = "OnStaticCreatorEvent_" .. self.CurMission
  if self[OnStaticCreatorfuncName] then
    self[OnStaticCreatorfuncName](self, EventName, Eid, UnitId, UnitType, CreatorId)
  end
end

function BP_SynthesisComponent_C:OnMonsterGuideAdded(Eid)
  local OnGuidefuncName = "OnMonsterGuideAdded_" .. self.CurMission
  if self[OnGuidefuncName] then
    self[OnGuidefuncName](self, Eid)
  end
end

function BP_SynthesisComponent_C:OnDefenceCoreActive(DefenceCore)
  local OnDefenceCoreActivefuncName = "OnDefenceCoreActive_" .. self.CurMission
  if self[OnDefenceCoreActivefuncName] then
    self[OnDefenceCoreActivefuncName](self, DefenceCore)
  end
end

function BP_SynthesisComponent_C:SetMission(NewMission)
  if self.CurMission == NewMission then
    return
  end
  local InitfuncName = "Init" .. NewMission .. "Mission"
  if not self[InitfuncName] then
    GameState(self):ShowDungeonError("SynthesisComponent:SetMission 传入不存在的任务名！请检查 " .. self.GameMode.DungeonId .. " 传入任务名: " .. NewMission, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.CurMission = NewMission
  self[InitfuncName](self)
  DebugPrint("SynthesisComponent: SetMission", self.CurMission)
  GWorld:DSBLog("Info", "SynthesisComponent: SetMission  " .. self.CurMission, "GameMode")
end

function BP_SynthesisComponent_C:GetDungeonJsonAttr()
  local LevelLoader = self.GameMode:GetLevelLoader()
  if not LevelLoader then
    return {}
  end
  return LevelLoader.attr or {}
end

function BP_SynthesisComponent_C:InitDestructionMission()
  self:SetRageValue(0)
  self.CurRageStage = 0
  self.SupervisorInfo = {}
  self.SupervisorDeadCount = 0
  self.SupervisorGuideNum = 0
  self.IsDestructionFinishEventTriggered = false
  self:InitCreatorIdToLevelNameMap()
  for _, CreatorId in pairs(self.SupervisorCreatorIds) do
    local LevelName = self.CreatorIdToLevelName[CreatorId]
    local SubGameMode = self.GameMode.SubGameModeInfo:FindRef(LevelName)
    if IsValid(SubGameMode) then
      local CreatorIdArray = TArray(0)
      CreatorIdArray:Add(CreatorId)
      SubGameMode:TriggerActiveStaticCreator(CreatorIdArray, "DestructionSupervisor", true)
    else
      GameState(self):ShowDungeonError("SynthesisComponent:刷新主管失败，请检查配置  CreatorId: " .. tostring(CreatorId) .. "LevelName: " .. tostring(LevelName), Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    end
  end
  self.GameMode:NotifyClientShowDungeonTaskNew("", self.TextTitle, "DUNGEON_SYNTHESIS_113")
  self.GameMode:AddDungeonEvent("SynthesisDestruction")
end

function BP_SynthesisComponent_C:InitCreatorIdToLevelNameMap()
  local DungeonJsonAttr = self:GetDungeonJsonAttr()
  self.CreatorIdToLevelName = {}
  for _, Info in pairs(DungeonJsonAttr) do
    for k, _ in pairs(Info) do
      local CreatorIdStr = string.split(k, "_")[1]
      self.CreatorIdToLevelName[tonumber(CreatorIdStr)] = tostring(Info[CreatorIdStr .. "_id"])
      break
    end
  end
end

function BP_SynthesisComponent_C:OnUnitDeadEvent_Destruction(MonsterCharacter, KillMineRoleEid, KillMineSkillId, DeathReason)
  if not IsValid(MonsterCharacter) then
    return
  end
  DebugPrint("SynthesisComponent: MonsterDeadAddRage", self.MonAddRage)
  self:AddRageValue(self.MonAddRage)
  if self.SupervisorInfo[MonsterCharacter.Eid] and self.SupervisorInfo[MonsterCharacter.Eid].IsAlive then
    DebugPrint("SynthesisComponent: SupervisorDead", MonsterCharacter.Eid)
    GWorld:DSBLog("Info", "SynthesisComponent: SupervisorDead Eid " .. MonsterCharacter.Eid, "GameMode")
    self.SupervisorInfo[MonsterCharacter.Eid].IsAlive = false
    self.SupervisorDeadCount = self.SupervisorDeadCount + 1
    self.GameMode.EMGameState.DeadSupervisorEids:Add(MonsterCharacter.Eid)
    self.GameMode.EMGameState:MarkDeadSupervisorEidsAsDirtyData()
    if self.IsDestructionFinishEventTriggered then
      return
    end
    if self.SupervisorDeadCount >= #self.SupervisorCreatorIds then
      DebugPrint("SynthesisComponent: 所有主管死亡")
      GWorld:DSBLog("Info", "SynthesisComponent: All Supervisor Dead. Send Event!  ", "GameMode")
      self.IsDestructionFinishEventTriggered = true
      self.GameMode:RemoveDungeonEvent("SynthesisDestruction")
      self.GameMode:TriggerGameModeEvent("Event_OnAllSupervisorDead")
      self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS_103", 2, EToastType.Success)
    end
  end
end

function BP_SynthesisComponent_C:OnCombatPropDeadEvent_Destruction(CombatProp)
  if not IsValid(CombatProp) then
    return
  end
  local AddValue = 0
  if CombatProp:Cast(ABreakableItem) then
    AddValue = self.BreakableAddRage
  elseif self.MechanismAddRageMap[CombatProp.UnitId] then
    AddValue = self.MechanismAddRageMap[CombatProp.UnitId]
  end
  if 0 == AddValue then
    return
  end
  DebugPrint("SynthesisComponent: CombatPropDeadAddRage", AddValue)
  self:AddRageValue(AddValue)
end

function BP_SynthesisComponent_C:OnStaticCreatorEvent_Destruction(EventName, Eid, UnitId, UnitType, CreatorId)
  if "DestructionSupervisor" == EventName then
    GWorld:DSBLog("Info", "SynthesisComponent: SupervisorCreated Eid " .. Eid .. " UnitId " .. UnitId, "GameMode")
    self.SupervisorInfo[Eid] = {}
    self.SupervisorInfo[Eid].IsAlive = true
  end
end

function BP_SynthesisComponent_C:OnMonsterGuideAdded_Destruction(Eid)
  if self.SupervisorInfo[Eid] == nil then
    return
  end
  if self.SupervisorInfo[Eid].IsGuide then
    return
  end
  self.CurRageStage = self.CurRageStage + 1
  local RageValuePerStage = math.ceil(self.MaxRageValue / #self.RageValueStages)
  self:AddRageValue(RageValuePerStage)
  self.GameMode.EMGameState:MulticastShowDiscoverSupervisorToast(math.floor(100 / #self.RageValueStages))
  self:OnSupervisorGuideAdded(Eid)
end

function BP_SynthesisComponent_C:OnSupervisorGuideAdded(Eid)
  DebugPrint("SynthesisComponent: 主管添加指引", Eid)
  self.GameMode.EMGameState.GuideSupervisorEids:Add(Eid)
  self.GameMode.EMGameState:MarkGuideSupervisorEidsAsDirtyData()
  self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS_102", 2, EToastType.Warning)
  self.SupervisorInfo[Eid].IsGuide = true
  self.SupervisorGuideNum = self.SupervisorGuideNum + 1
  if self.SupervisorGuideNum == #self.SupervisorCreatorIds then
    DebugPrint("SynthesisComponent: 所有主管添加指引完成")
    self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathSpecialEnemy, self.TextTitle, "DUNGEON_SYNTHESIS_114")
  end
end

function BP_SynthesisComponent_C:SetRageValue(RageValue)
  if RageValue > self.MaxRageValue then
    RageValue = self.MaxRageValue
  end
  self.GameMode.EMGameState:SetRageValue(RageValue)
end

function BP_SynthesisComponent_C:GetRageValue()
  return self.GameMode.EMGameState.RageValue
end

function BP_SynthesisComponent_C:AddRageValue(AddValue)
  self.GameMode.EMGameState:SetRageValue(self.GameMode.EMGameState.RageValue + AddValue)
  if self.CurRageStage >= #self.RageValueStages then
    return
  end
  if self.GameMode.EMGameState.RageValue >= self.RageValueStages[self.CurRageStage + 1] then
    self.CurRageStage = self.CurRageStage + 1
    DebugPrint("SynthesisComponent: OnRageStage", self.CurRageStage)
    if self.SupervisorGuideNum < #self.SupervisorCreatorIds then
      self.GameMode:TriggerGameModeEvent("Event_OnRageStage", self.CurRageStage)
    end
    self:TryAddGuideForSupervisor()
  end
end

function BP_SynthesisComponent_C:TryAddGuideForSupervisor()
  for _, CreatorId in pairs(self.SupervisorCreatorIds) do
    local LevelName = self.CreatorIdToLevelName[CreatorId]
    local Creator = self.GameMode.EMGameState:GetStaticCreatorInfo(CreatorId, true, LevelName)
    if IsValid(Creator) and Creator.ChildEids:Length() > 0 then
      for i = 1, Creator.ChildEids:Length() do
        local Eid = Creator.ChildEids:GetRef(i)
        if self.SupervisorInfo[Eid] and not self.SupervisorInfo[Eid].IsGuide then
          self:OnSupervisorGuideAdded(Eid)
          DebugPrint("SynthesisComponent: TryAddGuideForSupervisor", Eid)
          self.GameMode.EMGameState:AddGuideEid(Eid)
          return
        end
      end
    end
  end
  DebugPrint("SynthesisComponent: TryAddGuideForSupervisor 不存在活着的主管")
end

function BP_SynthesisComponent_C:InitOccupationMission()
  self.IsOccupationFinishEventTriggered = false
  self.FinishedOccupationMechanism = {}
  self:SetOccupationFinishNum(0)
  self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS_115")
  self.GameMode:AddDungeonEvent("SynthesisOccupation")
end

function BP_SynthesisComponent_C:OnOccupationInit(OccupationMechanismEid)
  for _, Player in pairs(self.GameMode:GetAllPlayer()) do
    if not self.OccupateGuide[Player.Eid] then
      self.OccupateGuide[Player.Eid] = {
        List = {}
      }
    end
    if not self.OccupateGuide[Player.Eid].List[OccupationMechanismEid] then
      self.OccupateGuide[Player.Eid].List[OccupationMechanismEid] = 0
    end
    print(_G.LogTag, "LXZ Occup OnOccupationInit", OccupationMechanismEid, Player.Eid, self.OccupateGuide[Player.Eid].CurrentOccupationEid)
    if not self.OccupateGuide[Player.Eid].CurrentOccupationEid or 0 == self.OccupateGuide[Player.Eid].CurrentOccupationEid then
      print(_G.LogTag, "LXZ Occup AddGuideEid", OccupationMechanismEid, Player.Eid, self.OccupateGuide[Player.Eid].CurrentOccupationEid)
      self.GameMode.EMGameState:AddGuideEid(OccupationMechanismEid, Player.Eid)
    end
  end
end

function BP_SynthesisComponent_C:OnPlayerEnterOccupation(Player, OccupationMechanism)
  if not self.OccupateGuide[Player.Eid] then
    self.OccupateGuide[Player.Eid] = {
      List = {}
    }
  end
  print(_G.LogTag, "LXZ Occup OnPlayerEnterOccupation", Player.Eid, OccupationMechanism.Eid)
  self.OccupateGuide[Player.Eid].CurrentOccupationEid = OccupationMechanism.Eid
  for i, v in pairs(self.OccupateGuide[Player.Eid].List) do
    if i ~= OccupationMechanism.Eid then
      v = 1
      print(_G.LogTag, "LXZ Occup RemoveGuideEid", i, Player.Eid, self.OccupateGuide[Player.Eid].CurrentOccupationEid)
      self.GameMode.EMGameState:RemoveGuideEid(i, Player.Eid)
    else
      v = 2
      self.GameMode.EMGameState:AddGuideEid(i, Player.Eid)
    end
  end
end

function BP_SynthesisComponent_C:OnPlayerLeaveOccupation(Player, OccupationMechanism)
  if not self.OccupateGuide[Player.Eid] then
    self.OccupateGuide[Player.Eid] = {
      List = {}
    }
  end
  print(_G.LogTag, "LXZ Occup OnPlayerLeaveOccupation", Player.Eid, OccupationMechanism.Eid)
  self.OccupateGuide[Player.Eid].CurrentOccupationEid = 0
  for i, v in pairs(self.OccupateGuide[Player.Eid].List) do
    if 2 ~= v then
      v = 2
      self.GameMode.EMGameState:AddGuideEid(i, Player.Eid)
    end
  end
end

function BP_SynthesisComponent_C:OnOneOccupationSucceed(OccupationMechanism)
  if not IsValid(OccupationMechanism) then
    return
  end
  if self.FinishedOccupationMechanism[OccupationMechanism.Eid] then
    return
  end
  self.FinishedOccupationMechanism[OccupationMechanism.Eid] = true
  self:SetOccupationFinishNum(self:GetOccupationFinishNum() + 1)
  DebugPrint("SynthesisComponent: OnOneOccupationSucceed ", self:GetOccupationFinishNum())
  GWorld:DSBLog("Info", "SynthesisComponent: OnOneOccupationSucceed Num:" .. self:GetOccupationFinishNum(), "GameMode")
  self.GameMode:TriggerGameModeEvent("Event_OnOneOccupationSucceed")
  for _, Player in pairs(self.GameMode:GetAllPlayer()) do
    local OccupateGuideTable = self.OccupateGuide[Player.Eid]
    if OccupateGuideTable and OccupateGuideTable.CurrentOccupationEid == OccupationMechanism.Eid then
      OccupateGuideTable.CurrentOccupationEid = 0
      for Eid, State in pairs(OccupateGuideTable.List) do
        if Eid ~= OccupationMechanism.Eid then
          self.GameMode.EMGameState:AddGuideEid(Eid, Player.Eid)
        end
      end
    end
    self.GameMode.EMGameState:RemoveGuideEid(OccupationMechanism.Eid, Player.Eid)
    if OccupateGuideTable then
      OccupateGuideTable[OccupationMechanism.Eid] = nil
    end
  end
  if self.IsOccupationFinishEventTriggered then
    return
  end
  if self:GetOccupationFinishNum() >= self.OccupationTargetNum then
    DebugPrint("SynthesisComponent: OnOccupationFinished")
    GWorld:DSBLog("Info", "SynthesisComponent: OccupationFinished. Send Event!", "GameMode")
    self.IsOccupationFinishEventTriggered = true
    self.GameMode:RemoveDungeonEvent("SynthesisOccupation")
    self.GameMode:TriggerGameModeEvent("Event_OnOccupationFinished")
    self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS_111", 2, EToastType.Success)
  end
end

function BP_SynthesisComponent_C:SetOccupationFinishNum(Num)
  self.GameMode.EMGameState:SetOccupationFinishNum(Num)
end

function BP_SynthesisComponent_C:GetOccupationFinishNum()
  return self.GameMode.EMGameState.OccupationFinishNum
end

function BP_SynthesisComponent_C:InitCrackMission()
  self.IsCrackFinishEventTriggered = false
  self:SetKeySubmitNum(0)
  self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS_116")
end

function BP_SynthesisComponent_C:OnExplosionMonTimer()
  if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
    DebugPrint("SynthesisComponent: ExplosionMonTimerEnd DungeonEndEnd")
    self:RemoveTimer("ExplosionMonTimer")
    return
  end
  DebugPrint("SynthesisComponent: OnExplosionMonTimer")
  self.GameMode:TriggerGameModeEvent("Event_OnExplosionMonsterTimerCountdown")
end

function BP_SynthesisComponent_C:OnKeyDelivered(CrackMechanism)
  self:SetKeySubmitNum(self:GetKeySubmitNum() + 1)
  DebugPrint("SynthesisComponent: OnKeyDelivered", self:GetKeySubmitNum())
  GWorld:DSBLog("Info", "SynthesisComponent: OnKeyDelivered " .. self:GetKeySubmitNum(), "GameMode")
  self.GameMode:TriggerGameModeEvent("Event_OnKeyDelivered", self:GetKeySubmitNum())
  if self.IsCrackFinishEventTriggered then
    return
  end
  if self:GetKeySubmitNum() >= self.KeyNeedNum then
    DebugPrint("SynthesisComponent: CrackMissionFinish")
    GWorld:DSBLog("Info", "SynthesisComponent: CrackMissionFinish. Send Event!", "GameMode")
    self.IsCrackFinishEventTriggered = true
    self.GameMode:RemoveDungeonEvent("SynthesisCrack")
    self.GameMode:TriggerGameModeEvent("Event_OnCrackFinished")
    self.GameMode:NotifyClientShowDungeonTaskNew("", self.TextTitle, "DUNGEON_SYNTHESIS_118")
    self.GameMode:NotifyClientShowDungeonToast("DUNGEON_SYNTHESIS_110", 2, EToastType.Success)
    self:RemoveTimer("ExplosionMonTimer")
  end
end

function BP_SynthesisComponent_C:OnDefenceCoreActive_Crack(DefenceCore)
  self:AddTimer(self.BlastMonInterval, self.OnExplosionMonTimer, true, 0, "ExplosionMonTimer")
  self.GameMode:AddDungeonEvent("SynthesisCrack")
  self.GameMode:NotifyClientShowDungeonTaskNew(self.IconPathYellow, self.TextTitle, "DUNGEON_SYNTHESIS_117")
  self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

function BP_SynthesisComponent_C:OnStaticCreatorEvent_Crack(EventName, Eid, UnitId, UnitType, CreatorId)
  if "CrackChest" == EventName then
    DebugPrint("SynthesisComponent: CrackChestCreated", Eid, UnitId)
    GWorld:DSBLog("Info", "SynthesisComponent: CrackChestCreated Eid " .. Eid .. " UnitId " .. UnitId, "GameMode")
  end
end

function BP_SynthesisComponent_C:SetKeySubmitNum(Num)
  self.GameMode.EMGameState:SetKeySubmitNum(Num)
end

function BP_SynthesisComponent_C:GetKeySubmitNum()
  return self.GameMode.EMGameState.KeySubmitNum
end

return BP_SynthesisComponent_C
