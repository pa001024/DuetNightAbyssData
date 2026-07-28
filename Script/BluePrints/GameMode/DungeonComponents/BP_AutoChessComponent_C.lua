require("UnLua")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.Common.TimerMgr"
})
M._components = {
  "BluePrints.GameMode.AutoChessComponents.AutoChessBuffManager"
}

function M:InitAutoChessComponent()
  self.GameMode = self:GetOwner()
  if self.GameMode and self.GameMode.PreInitInfo then
    local PreInitInfo = self.GameMode.PreInitInfo
    self.MissionId = PreInitInfo.MissionId
    self.ShareOwnerName = PreInitInfo.ShareOwnerName
    self.ShareCode = PreInitInfo.ShareCode
    self.IsShareChallenge = PreInitInfo.IsShareChallenge
    self.EnemySquad = PreInitInfo.EnemySquad
    self.EnemyEquips = PreInitInfo.EnemyEquips
    self.EnemyBuffs = PreInitInfo.EnemyBuffs
    self.EnemyCost = PreInitInfo.EnemyCost
  end
  DebugPrint("AutoChessComponent:Init!", self.GameMode.DungeonId)
  EventManager:AddEvent(EventID.OnAutoChessBattleStart, self, self.OnAutoChessBattleStart)
  EventManager:AddEvent(EventID.OnAutoChessMotivateStart, self, self.OnAutoChessMotivateStart)
  EventManager:AddEvent(EventID.OnCheckIsGameOver, self, self.OnCheckIsGameOver)
  EventManager:AddEvent(EventID.OnAutoChessChallengeBuffChanged, self, self.OnAutoChessChallengeBuffChanged)
  self.AutoChessBattleInfo = {}
  self:RecordPass(self.MissionId)
  self:BindAutoChessEvent()
  self.PrevWindSetting = UE4.UKismetSystemLibrary.GetConsoleVariableIntValue("foliage.WindEnable")
  GWorld.GameInstance:SetGameScalabilityLevelByName("foliage.WindEnable", 0)
  self:SetEditingSquadIndex(AutoChessDataModel:GetEditingSuqadIndex() or 1)
end

function M:RecordPass(MissionId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local DungeonId = DataMgr.AutoChessMission[MissionId].DungeonId
  if Avatar.Dungeons[DungeonId] then
    if Avatar.Dungeons[DungeonId].IsPass then
      GWorld.GameInstance.IsDungeonPass = true
    else
      GWorld.GameInstance.IsDungeonPass = false
    end
  end
end

function M:GetAutoChessBattleInfo()
  return self.AutoChessBattleInfo
end

function M:ReceiveEndPlay(EndPlayReason)
  self:UnBindAutoChessEvent()
  if self.PrevWindSetting then
    GWorld.GameInstance:SetGameScalabilityLevelByName("foliage.WindEnable", self.PrevWindSetting)
  end
  self.Overridden.ReceiveEndPlay(self, EndPlayReason)
end

function M:UnBindAutoChessEvent()
  EventManager:RemoveEvent(EventID.OnCheckIsGameOver, self)
  EventManager:RemoveEvent(EventID.OnBattleChessFight, self)
  EventManager:RemoveEvent(EventID.OnAutoChessChallengeBuffChanged, self)
end

function M:BindAutoChessEvent()
  EventManager:AddEvent(EventID.OnCheckIsGameOver, self, self.OnCheckIsGameOver)
  EventManager:AddEvent(EventID.OnBattleChessFight, self, self.OnBattleChessFight)
end

function M:RefreshBattleRoleInfo(Camp, Eid, UnitId)
  if not self.AutoChessBattleInfo[Camp] then
    self.AutoChessBattleInfo[Camp] = {}
  end
  if not self.AutoChessBattleInfo[Camp][Eid] then
    self.AutoChessBattleInfo[Camp][Eid] = {UnitId = UnitId}
  end
  if not self.AutoChessBattleInfo[Camp][Eid].Damage then
    self.AutoChessBattleInfo[Camp][Eid].Damage = 0
  end
  if not self.AutoChessBattleInfo[Camp][Eid].Damaged then
    self.AutoChessBattleInfo[Camp][Eid].Damaged = 0
  end
  if not self.AutoChessBattleInfo[Camp][Eid].Heal then
    self.AutoChessBattleInfo[Camp][Eid].Heal = 0
  end
end

function M:InitRoleBattleInfo()
  self.AutoChessBattleInfo = {}
  local RoleInfo = self:GetCurrentChessMonsterInfo(true)
  for _, Info in pairs(RoleInfo) do
    self:RefreshBattleRoleInfo("Enemy", Info.Eid, Info.UnitId)
  end
  RoleInfo = self:GetCurrentChessMonsterInfo(false)
  for _, Info in pairs(RoleInfo) do
    self:RefreshBattleRoleInfo("Ally", Info.Eid, Info.UnitId)
  end
  EventManager:FireEvent(EventID.OnInitRoleBattleInfo, self.AutoChessBattleInfo)
end

function M:OnBattleChessFight(SourceEid, Value, FightType)
  if not self.Player then
    return
  end
  local Source = Battle(self):GetEntity(SourceEid)
  Source = Source:GetRootSource()
  if not Source then
    return
  end
  SourceEid = Source.Eid
  local Camp
  if self.Player:IsEnemy(Source) then
    Camp = "Enemy"
  else
    Camp = "Ally"
  end
  if not self.AutoChessBattleInfo[Camp] then
    self.AutoChessBattleInfo[Camp] = {}
  end
  if not self.AutoChessBattleInfo[Camp][SourceEid] then
    self.AutoChessBattleInfo[Camp][SourceEid] = {
      UnitId = Source.UnitId
    }
  end
  if not self.AutoChessBattleInfo[Camp][SourceEid][FightType] then
    self.AutoChessBattleInfo[Camp][SourceEid][FightType] = 0
  end
  self.AutoChessBattleInfo[Camp][SourceEid][FightType] = self.AutoChessBattleInfo[Camp][SourceEid][FightType] + Value
  if "Damage" == FightType then
    EventManager:FireEvent(EventID.OnBattleChessFightDamage, SourceEid, Value)
  end
end

function M:InitInGameUI()
  self.UIManager = UIManager(self)
  if not self.UIManager then
    DebugPrint("UIManager无效")
  end
  self.InGameUI = self.UIManager:LoadUINew("AutoChessBattlePage")
  if not self.InGameUI then
    DebugPrint("AutoChess 布阵UI创建失败")
  end
  if self:IsPvPMode() or self:IsShareEditMode() then
    self.UIManager:LoadUINew("AutoChessMatchStatus", self)
  end
end

function M:InitAutoChessBaseInfo()
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not self.Player then
    DebugPrint("@zyh 当前还没有PlayerCharacter")
    return
  end
  local Rotation = FRotator(0, 0, 0):ToQuat()
  local Location = self.Player:K2_GetActorLocation()
  local SpawnTransform = FTransform(Rotation, Location)
  self.CameraPawn = self:GetWorld():SpawnActor(LoadClass("/Game/BluePrints/Char/BP_PlayerCameraPawn.BP_PlayerCameraPawn_C"), SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  self.CameraPawnOriginalLocation = self.CameraPawn:K2_GetActorLocation()
  self.PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local FormationClass = UE4.UClass.Load("/Game/AssetDesign/GameMode/AutoChess/AutoChess_Formation.AutoChess_Formation")
  local Transform = self.GameMode:GetLevelLoader():GetLevelTransformById("0")
  local FormationLocation = FVector(-60512.0, 5537.0, -4076.0)
  local NewLoc = UKismetMathLibrary.TransformLocation(Transform, FormationLocation)
  DebugPrint("autochess Newloc 555:", NewLoc)
  local FormationRotation = FRotator(0.0, -23.0, 0.0):ToQuat()
  local SpawnTransform = UE4.FTransform(FormationRotation, NewLoc)
  local AutoChessFormation = GWorld.GameInstance:GetWorld():SpawnActor(FormationClass, SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn, nil, self, nil)
  self:SwitchToCameraPawn()
  self:InitInGameUI()
  self:GetAutoChessFormation()
  self.InGameUI.AutoChessFormation = self.AutoChessFormation
  self.AutoChessFormation:BindCubeEvent("Click", self.InGameUI, self.InGameUI.ClickChess)
  self.InGameUI.Index2CubeInfo = self:GetCurrentChessMonsterInfo(false)
  self.InGameUI.Index2EnemyCubeInfo = self:GetCurrentChessMonsterInfo(true)
  self.InGameUI.CameraPawn = self.CameraPawn
  self.CameraPawn:SwitchInputState(false)
  self:DeployEnemyMonster()
  self:DeploySelfFromSharedSquad()
  self:DeploySelfFromMemorySquad()
  self:InitBuffFX()
end

function M:DeploySelfFromSharedSquad()
  if not self:IsShareEditMode() or not self.InGameUI then
    return
  end
  local SquadIdx = self:GetEditingSquadIndex() or AutoChessDataModel:GetEditingSuqadIndex() or 1
  self.InGameUI:InitSharedSquadLayout(SquadIdx)
  self.InGameUI.Index2CubeInfo = self:GetCurrentChessMonsterInfo(false)
end

function M:DeployEnemyMonster()
  if not self.MissionId then
    DebugPrint("DeployEnemyMonster: MissionId is nil!")
    return
  end
  if self.IsShareChallenge and self.EnemySquad then
    self:DeployEnemyFromSquad(self.EnemySquad, self.EnemyEquips)
    return
  end
  self.ACFormationId = DataMgr.AutoChessMission[self.MissionId] and DataMgr.AutoChessMission[self.MissionId].ACFormationId
  if not self.ACFormationId then
    DebugPrint("DeployEnemyMonster: ACFormationId is nil! self.MissionId: ", self.MissionId)
    return
  end
  local ACFormations = DataMgr.AutoChessFormat[self.ACFormationId]
  self:DeployEnemyFromFormation(ACFormations)
end

function M:DeployEnemyFromFormation(ACFormations)
  if not ACFormations then
    return
  end
  
  local function get_last_number(s)
    if type(s) ~= "string" then
      return nil
    end
    local num = s:match("^ACLocation(%d+)$")
    return num and tonumber(num) or nil
  end
  
  local EnemyChessEquips = {}
  for Location, Info in pairs(ACFormations) do
    local CubeIndex = get_last_number(Location)
    if CubeIndex then
      CubeIndex = CubeIndex - 1
      for CombatChessId, Equipments in pairs(Info) do
        if type(CombatChessId) == "number" then
          EnemyChessEquips[CombatChessId] = Equipments
          EventManager:FireEvent(EventID.OnAutoChessCreateMonster, CombatChessId, CubeIndex, true, Equipments)
          break
        end
      end
    end
  end
  if self.InGameUI then
    self.InGameUI.EnemyChessEquips = EnemyChessEquips
  end
end

function M:DeployEnemyFromSquad(EnemySquad, EnemyEquips)
  if not EnemySquad then
    DebugPrint("DeployEnemyMonster: EnemySquad is nil")
    return
  end
  
  local function ParseEnemySquadEntry(SlotIndex, Entry)
    if type(Entry) == "number" then
      return tonumber(SlotIndex), Entry
    end
    if type(Entry) == "table" then
      local ParsedSlotIndex = tonumber(Entry[1] or Entry.SlotIndex or Entry.CubeIndex)
      local CombatChessId = tonumber(Entry[2] or Entry.CombatChessId)
      if ParsedSlotIndex and CombatChessId then
        return ParsedSlotIndex, CombatChessId
      end
    end
    return nil, nil
  end
  
  local EnemyChessEquips = {}
  for SlotIndex, Entry in pairs(EnemySquad) do
    local ParsedSlotIndex, CombatChessId = ParseEnemySquadEntry(SlotIndex, Entry)
    if ParsedSlotIndex and CombatChessId then
      local CubeIndex = ParsedSlotIndex - 1
      local EquipList = EnemyEquips and EnemyEquips[CombatChessId]
      if self.IsShareChallenge and EnemyEquips then
        EquipList = nil
        for _, Data in pairs(EnemyEquips) do
          if type(Data) == "table" and Data[1] == CombatChessId then
            EquipList = Data[2]
            break
          end
        end
      end
      EnemyChessEquips[CombatChessId] = EquipList
      EventManager:FireEvent(EventID.OnAutoChessCreateMonster, CombatChessId, CubeIndex, true, EquipList)
    end
  end
  if self.InGameUI then
    self.InGameUI.EnemyChessEquips = EnemyChessEquips
    self.InGameUI.Index2EnemyCubeInfo = self:GetCurrentChessMonsterInfo(true)
  end
end

function M:DeploySelfFromMemorySquad()
  local MissionData = DataMgr.AutoChessMission[self.MissionId]
  if not MissionData then
    return
  end
  if 1 ~= MissionData.MissionType and 2 ~= MissionData.MissionType then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local LastWinSquad = Avatar.AutoChess.LastWinSquad
  if not LastWinSquad or not self.InGameUI then
    return
  end
  self.InGameUI.Index2CubeInfo = self:GetCurrentChessMonsterInfo(false)
  self.InGameUI:SetLineup(LastWinSquad)
end

function M:SwitchToCameraPawn()
  if not self.CameraPawn then
    DebugPrint("@zyh 当前还没有CameraPawn")
    return
  end
  self.PlayerController:SetLastPawn(self.Player)
  self.PlayerController:Possess(self.CameraPawn)
  local PCC = self.CameraPawn:GetComponentByClass(UPlayerCameraComponent)
  if PCC then
    self.PlayerController:SetAudioListenerOverride(PCC, Const.ZeroVector, Const.ZeroRotator)
  else
    DebugPrint("@zyh 自走棋关卡拿不到相机组件")
  end
  self.CameraPawn.RealPlayer = self.Player
  self.CameraPawn:SetCameraPitch(-65, -15)
  self.CameraPawn:CleanTouchInput()
end

function M:ResetDeployCamera()
  self.CameraPawn:K2_SetActorLocation(self.CameraPawnOriginalLocation, false, nil, false)
  self.CameraPawn.CharSpringArmComponent.IsCameraLengthChanged = false
  self.CameraPawn.SpringArmRate = self.CameraPawn.DefaultSpringArmRate
  self.CameraPawn.CharSpringArmComponent.MouseWheelTargetArmLength = 0.0
  self.CameraPawn.CharSpringArmComponent.TargetArmLength = 1370
  self.CameraPawn:SetBaseCameraSpringArm(1370)
  self.PlayerController:SetControlRotation(FRotator(-58.000782, 156.959473, 0))
  self.CameraPawn:SwitchInputState(false)
  self.CameraPawn:CleanTouchInput()
end

function M:SwitchToPlayer()
  self.PlayerController:Possess(self.Player)
  if self.Player.AudioListener then
    self.PlayerController:SetAudioListenerOverride(self.Player.AudioListener, Const.ZeroVector, Const.ZeroRotator)
  end
  local CameraControlComponent = self.Player.CameraControlComponent
  self.PlayerController.PlayerCameraManager.ViewPitchMin = CameraControlComponent.CameraPitchLimitMin
  self.PlayerController.PlayerCameraManager.ViewPitchMax = CameraControlComponent.CameraPitchLimitMax
end

function M:TriggerAutoChessOnEnd()
  self:SwitchToPlayer()
  self.InGameUI:SetInputModeCustom(false)
end

function M:GetAutoChessFormation()
  if self.AutoChessFormation and UE4.UKismetSystemLibrary.IsValid(self.AutoChessFormation) then
    return self.AutoChessFormation
  end
  local FormationClass = LoadClass("/Game/AssetDesign/GameMode/AutoChess/AutoChess_Formation.AutoChess_Formation")
  if not FormationClass then
    DebugPrint("AutoChessComponent: FormationClass nil")
    return nil
  end
  local Arr = TArray(AActor)
  UE4.UGameplayStatics.GetAllActorsOfClass(self, FormationClass, Arr)
  if Arr:Length() > 0 then
    self.AutoChessFormation = Arr[1]
    return self.AutoChessFormation
  end
  return nil
end

function M:GetCurrentChessMonsterInfo(IsEnemy)
  local Formation = self:GetAutoChessFormation()
  if not Formation then
    return nil
  end
  if Formation.GetCurrentChessMonsterInfo then
    return Formation:GetCurrentChessMonsterInfo(IsEnemy)
  end
  return nil
end

function M:GetCurrentChessMonsterEid()
  local MonsterEids = {}
  local Monsters = self:GetCurrentChessMonsterInfo(false)
  local EnemyMonsters = self:GetCurrentChessMonsterInfo(true)
  for Index, Info in pairs(Monsters) do
    table.insert(MonsterEids, Info.Eid)
  end
  for Index, Info in pairs(EnemyMonsters) do
    table.insert(MonsterEids, Info.Eid)
  end
  return MonsterEids
end

function M:OnAutoChessBattleStart()
  self:OnBattleStartInitItemBuff()
  self:OnBattleStartInitEquipBuff()
  self:RecordPlayerCurRankInfo()
  self:InitRoleBattleInfo()
  self.GameMode:EventOnBattleStart()
end

function M:RecordPlayerCurRankInfo()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  GWorld.GameInstance.PreRankLevel = Avatar.AutoChess.RankLevel
  GWorld.GameInstance.PreRankScore = Avatar.AutoChess.RankScore
end

function M:OnAutoChessMotivateStart()
  self:OnStartMotivateBuff()
end

function M:OnCheckIsGameOver(Unit)
  local BattlePage = self.InGameUI
  if BattlePage and BattlePage.bReturningToDeploy then
    return
  end
  local Monsters = self:GetCurrentChessMonsterInfo(false)
  local EnemyMonsters = self:GetCurrentChessMonsterInfo(true)
  local FriendAliveMonsters = 0
  local EnemyAliveMonsters = 0
  for Index, Info in pairs(Monsters) do
    if Battle(self):GetEntity(Info.Eid) and Unit.Eid ~= Info.Eid then
      FriendAliveMonsters = FriendAliveMonsters + 1
    end
  end
  for Index, Info in pairs(EnemyMonsters) do
    if Battle(self):GetEntity(Info.Eid) and Unit.Eid ~= Info.Eid then
      EnemyAliveMonsters = EnemyAliveMonsters + 1
    end
  end
  if 0 == EnemyAliveMonsters * FriendAliveMonsters then
    local IsWin = FriendAliveMonsters >= EnemyAliveMonsters
    self:TriggerRealGameEnd(IsWin)
  end
end

function M:TriggerRealGameEnd(IsWin)
  local Params = {}
  Params.BlackScreenHandle = "AutoChessEnd"
  Params.InAnimationPlayTime = 0.5
  Params.InAnimationObj = self
  
  function Params.InAnimationCallback()
    if IsWin then
      self.GameMode:TriggerDungeonWin()
    else
      self.GameMode:TriggerDungeonFailed()
    end
  end
  
  UIManager(self):ShowCommonBlackScreen(Params)
end

function M:DisableCubeInteraction()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  PlayerController.bEnableMouseOverEvents = false
  PlayerController.bEnableClickEvents = false
  EventManager:FireEvent(EventID.OnAutoChessDisableCubeInteraction)
end

function M:EnableCubeInteraction()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if PlayerController then
    PlayerController.bEnableMouseOverEvents = true
    PlayerController.bEnableClickEvents = true
  end
  EventManager:FireEvent(EventID.OnAutoChessEnableCubeInteraction)
end

function M:IsMonsterCreating()
  if not self.AutoChessFormation then
    self:GetAutoChessFormation()
  end
  if self.AutoChessFormation.IsMonsterCreating then
    return self.AutoChessFormation:IsMonsterCreating()
  end
  return false
end

function M:IsPvPMode()
  if self.bIsPvP == nil then
    local DungeonInfo = DataMgr.AutoChessMission[self.MissionId]
    if DungeonInfo then
      self.bIsPvP = 3 == DungeonInfo.MissionType
    end
  end
  return self.bIsPvP
end

function M:IsShareEditMode()
  if self.bIsShareEdit == nil then
    local DungeonInfo = DataMgr.AutoChessMission[self.MissionId]
    if DungeonInfo then
      self.bIsShareEdit = 4 == DungeonInfo.MissionType
    end
  end
  return self.bIsShareEdit
end

function M:GetIsShareChallenge()
  return self.IsShareChallenge == true
end

function M:SetEditingSquadIndex(Index)
  DebugPrint("AutoChessComponent: SetEditingSquadIndex ", Index)
  self.EditingSquadIndex = Index
  AutoChessDataModel:SetEditingSquadIndex(Index)
  EventManager:FireEvent(EventID.OnAutoChessSquadChanged)
  if self.AutoChessFormation and UE4.UKismetSystemLibrary.IsValid(self.AutoChessFormation) then
    self:ResetBuffFX()
  end
end

function M:GetEditingSquadIndex()
  return self.EditingSquadIndex
end

function M:OnAutoChessChallengeBuffChanged()
  self:ResetBuffFX()
end

function M:GetShareModeTotalCost()
  if self.IsShareChallenge then
    return self.EnemyCost
  elseif self:IsShareEditMode() then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return 0
    end
    local RankLevel = Avatar.AutoChess.RankLevel
    local BattleCost = DataMgr.AutoChessPoint[RankLevel] and DataMgr.AutoChessPoint[RankLevel].BattleCost or 0
    return BattleCost
  end
  return 0
end

AssembleComponents(M)
return M
