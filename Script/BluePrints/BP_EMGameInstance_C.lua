require("UnLua")
require("DataMgr")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local ReddotManager = require("BluePrints.UI.Reddot.ReddotManager")
local CdnTool = require("BluePrints.UI.GameLogin.CdnTool")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local MiscUtils = require("Utils.MiscUtils")
local SettingUtils = require("Utils.SettingUtils")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local Language2ESystemLanguage = {
  TextMapContent = ESystemLanguage.TextMapContent,
  ContentEN = ESystemLanguage.ContentEN,
  ContentJP = ESystemLanguage.ContentJP,
  ContentKR = ESystemLanguage.ContentKR,
  ContentTC = ESystemLanguage.ContentTC,
  ContentDE = ESystemLanguage.ContentDE,
  ContentFR = ESystemLanguage.ContentFR,
  ContentES = ESystemLanguage.ContentES
}
local BP_EMGameInstance_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function BP_EMGameInstance_C:Initialize(Initializer)
  print(_G.LogTag, "BP_EMGameInstance_C:Initialize")
  GWorld.GameInstance = self
end

function BP_EMGameInstance_C:OnLoginSuccess()
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  StorySubsystem:TryInitVars()
  if Const.OpenVerifyArray then
    self:InitVerifyArray()
  end
  self.KeyListRecord = {}
end

function BP_EMGameInstance_C:GetInt(TableName, VarName)
  local TableObj = require(string.format("%s", TableName))
  local VarValue = TableObj[VarName]
  if nil == VarValue then
    return 0
  end
  return VarValue
end

function BP_EMGameInstance_C:IsBanSmallLevelScalability(Value)
  if CommonUtils.HasValue(Const.BanSmallLevelScalabilityLevel, Value) then
    return true
  end
  return false
end

function BP_EMGameInstance_C:GetSerializeDistanceRatio(ScalabilityLevel, PlatformName)
  local Ratio = 1.0
  Ratio = ("IOS" == PlatformName or self:GetUseMapPhoneInPC()) and Const.IOSSerializeDistanceRatio[ScalabilityLevel] or Ratio
  return Ratio
end

function BP_EMGameInstance_C:_FontOptimizeSetting()
  UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.MaxFontAtlasPagesBeforeFlush 2")
  UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.MaxFontNonAtlasTexturesBeforeFlush 4")
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "Android" == PlatformName then
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.AsyncLazyLoad 1")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.RemoveLastNoUseFontFace 1")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.ForcePreserveFontFaceCount 6")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.GrowFontAtlasFrameWindow 10")
  elseif "IOS" == PlatformName then
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.AsyncLazyLoad 1")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.RemoveLastNoUseFontFace 1")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.Font.ForcePreserveFontFaceCount 4")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "Slate.GrowFontAtlasFrameWindow 5")
  end
end

function BP_EMGameInstance_C:InitReady()
  if IsDedicatedServer(self) then
    GWorld.bDebugServer = self.bDebugServer
    print(_G.LogTag, "DebugServer", GWorld.bDebugServer)
  else
    self:_FontOptimizeSetting()
  end
  if URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    DebugPrint("Check Open FX Budget in Editor ", Const.bEditorOpenFXBudget)
    if Const.bEditorOpenFXBudget then
      UKismetSystemLibrary.ExecuteConsoleCommand(self, "fx.Niagara.ForceAutoPooling 1", nil)
    else
      UKismetSystemLibrary.ExecuteConsoleCommand(self, "fx.Niagara.ForceAutoPooling 0", nil)
    end
  end
  self:CreateAvatar()
  GWorld.GameInstance = self
  if not URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    function _G.Battle(Context)
      return GWorld.Battle
    end
  end
  self:InitGameSystemVoice()
  GWorld.NetworkMgr = self:GetNetworkManager()
  GWorld.NetworkMgr:GetTcpInstance():InitSuccessLua()
  GWorld.BP_Avatar = self:GetAvatar()
end

function BP_EMGameInstance_C:OnPostWorldCleanup(World, bSessionEnded, bCleanupResources)
  if World:GetName() == self:GetWorld():GetName() and not GWorld:GetAvatar() then
    EventManager:CheckIsLeak()
  end
end

function BP_EMGameInstance_C:NowTime()
  return TimeUtils.NowTime()
end

function BP_EMGameInstance_C:SetWorldStandardTime_Lua()
  if IsStandAlone(self) or IsClient(self) then
    TimeUtils.RequestSetNowTime()
  end
end

function BP_EMGameInstance_C:OnStart_Lua(GroupId)
  if IsDedicatedServer(self) and not GWorld.bDebugServer then
    self:HandleDSConnect(GroupId)
  end
end

function BP_EMGameInstance_C:OnUpdateNetDriverInfo(ip, port)
  DebugPrint(ip, port)
  if IsDedicatedServer(self) and not GWorld.bDebugServer then
    local DSEntity = GWorld:GetDSEntity()
    if DSEntity then
      DSEntity:UpdateNetDriverInfo(ip, port)
    end
  elseif MiscUtils.IsListenServer(self) then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:UpdateNetDriverInfo(ip, port)
    end
  end
end

function BP_EMGameInstance_C:SetInstance2GWorld()
  GWorld.GameInstance = self
  GWorld.IsDev = self:GetIsDev()
  GWorld:IsDedicatedServer()
  _G.EMUIAnimationSubsystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UEMUIAnimationSubsystem)
end

function BP_EMGameInstance_C:HandleDSConnect(GroupId)
  if -1 == GroupId then
    GroupId = Const.DS_Default_GroupId
  end
  self.DSConnectHostnum = GroupId
  local Host = GroupId
  local BattleServerList = require("BluePrints/UI/GameLogin/BattleServerList")
  local ServerInfo = BattleServerList[Host]
  if not ServerInfo then
    DebugNetPrint("HandleDSConnect error with no BattleServerInfo", GroupId)
    return
  end
  local TargetIp, TargetPort
  local Ip = ServerInfo.ip
  if type(Ip) == "string" then
    TargetIp = Ip
  else
    TargetIp = Ip[math.random(1, #Ip)]
  end
  local Port = ServerInfo.port
  if type(Port) == "number" then
    TargetPort = Port
  else
    TargetPort = Port[math.random(1, #Port)]
  end
  DebugNetPrint("HandleDSConnect", Host, TargetIp, TargetPort)
  GWorld.NetworkMgr:ConnectServer(Host, TargetIp, TargetPort)
end

function BP_EMGameInstance_C:IsNullDungeonId(DungeonId)
  return -1 == DungeonId
end

function BP_EMGameInstance_C:GetDataInt(TableName, TableId, PropertyName)
  local Data = DataMgr[TableName]
  if nil ~= Data then
    local Row = Data[TableId]
    if nil ~= Row then
      local Value = Row[PropertyName]
      if nil ~= Value then
        return Value
      end
    end
  end
  return 0
end

function BP_EMGameInstance_C:HandleNetworkError(FailureType, bIsServer)
  print(_G.LogTag, "HandleNetworkError", FailureType, bIsServer)
  if not bIsServer and not self.bHandleNetError then
    self.bHandleNetError = true
    GWorld.NetworkMgr:DisconnectAndReturnLogin()
  elseif bIsServer then
    ServerPrint("HandleNetworkError", FailureType, bIsServer)
  end
end

function BP_EMGameInstance_C:GetDsType()
  if self.DSType == CommonConst.DSType.Leaf then
    return "Leaf"
  elseif self.DSType == CommonConst.DSType.Child then
    return "Child"
  elseif self.DSType == CommonConst.DSType.Root then
    return "Root"
  end
  return "None"
end

function BP_EMGameInstance_C:OnSubProcessInit(RandomSeed)
  math.randomseed(RandomSeed)
  if self.DSType == CommonConst.DSType.Leaf then
    self:AddTimer(2, function()
      self:GetDSAssetsManager():TryCheckPreLoadAssets()
    end)
  end
end

function BP_EMGameInstance_C:SetFixedStartPoint(Location, Rotation, ControllerRotation, bDead)
  print(_G.LogTag, "SetFixedStartPoint", Location, Rotation)
  self.UseFixedStartPoint = true
  self.StartLocation = Location
  self.StartRotation = Rotation
  self.StartControllerRotation = ControllerRotation
  self.bCharacterDead = bDead
end

function BP_EMGameInstance_C:ResetFixedStartPoint()
  print(_G.LogTag, "ResetFixedStartPoint")
  self.UseFixedStartPoint = false
  self.bCharacterDead = nil
end

function BP_EMGameInstance_C:IsUseFixedStartPoint()
  return self.UseFixedStartPoint or false
end

function BP_EMGameInstance_C:SetStartSpotWithFixedTransform(StartSpot)
  if not self.UseFixedStartPoint then
    return false
  end
  StartSpot:K2_SetActorTransform(UE4.FTransform(self.StartRotation:ToQuat(), self.StartLocation), false, nil, false)
  StartSpot:K2_SetActorLocation(self.StartLocation, false, nil, false)
  StartSpot:K2_SetActorRotation(self.StartRotation, false, nil, false)
  return true
end

function BP_EMGameInstance_C:CachePlayerCharacterInfo(...)
  self.PlayerCharacterInfo = table.pack(...)
end

function BP_EMGameInstance_C:ConsumePlayerCharacterInfo(PlayerCharacter)
  if not self.PlayerCharacterInfo then
    return
  end
  local EndPointSeqEnable, EndPointLocation, EndPointRotation = table.unpack(self.PlayerCharacterInfo)
  PlayerCharacter:SetEndPointInfo(EndPointSeqEnable, EndPointLocation, EndPointRotation)
  self.PlayerCharacterInfo = nil
end

function BP_EMGameInstance_C:PreInitGameMode(CustomPreInitInfo)
  self.CustomPreInitInfo = CustomPreInitInfo
end

function BP_EMGameInstance_C:ConsumeGameModePreInitInfo()
  local Info = self.CustomPreInitInfo
  self.CustomPreInitInfo = nil
  return Info
end

function BP_EMGameInstance_C:OnPlayerControllerGameEnd(IsWin, BattleInfo, ScenePlayers)
  self.DungeonIdCache = self:GetCurrentDungeonId()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local SceneManager = self:GetSceneManager()
  if nil ~= SceneManager then
    SceneManager:OnDungeonEnd_ToSceneManager(IsWin, BattleInfo, GameState.GameModeType)
  end
  if GameState.GameModeType == "Training" or GameState.GameModeType == "Trial" then
    DebugPrint("DungeonSettlement: 训练场或角色试玩玩法，直接退出副本")
    local Avatar = GWorld:GetAvatar()
    Avatar:ExitDungeonSettlement()
    return
  end
  GameState:TriggerClientEvent("OnDungeonSettlement")
  self.IsInSettlementScene = true
  local WalnutChoiceUI = UIManager(self):GetUIObj("WalnutChoice")
  if WalnutChoiceUI then
    WalnutChoiceUI:Close()
  end
  self:OnPlayerControllerGameEnd_Internal(IsWin, BattleInfo, ScenePlayers)
end

function BP_EMGameInstance_C:CalculatePhantom()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PhantomTeammates = Player:GetPhantomTeammates()
  local Num = 0
  for _, Target in pairs(PhantomTeammates) do
    if Target ~= Player and not Target:IsDead() then
      Num = Num + 1
    end
  end
  self.PhantomTeammatesNum = Num
  self.InitPhantomTeammates = 0
  DebugPrint("CalculatePhantom PhantomTeammatesNum", self.PhantomTeammatesNum)
end

function BP_EMGameInstance_C:AddOnPhantomInitReadyEvent()
  if self.PhantomTeammatesNum > 0 then
    EventManager:AddEvent(EventID.OnPhantomInitReady, self, self.OnSettlementPhantomInitReady)
  end
end

function BP_EMGameInstance_C:OnPlayerControllerGameEnd_Internal(IsWin, BattleInfo, ScenePlayers)
  self:PushGameEndInfo(IsWin, BattleInfo)
  local Avatar = GWorld:GetAvatar()
  local IsHardBoss = Avatar and Avatar:IsInHardBoss()
  local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
  local AvatarStatusEnable = Avatar and not WorldCompositionSubSystem and not Avatar:IsInRougeLike()
  if AvatarStatusEnable and not Avatar:IsInNarrowDungeon() then
    GWorld.DungeonSettlementAgainInVisible = true
  end
  self.IsMoveToTempScene = false
  local OnBlackInFinished
  local DungeonId = self:GetCurrentDungeonId()
  self.ScenePlayers = ScenePlayers
  
  function OnBlackInFinished()
    local Avatar = GWorld:GetAvatar()
    if AvatarStatusEnable and Avatar:CheckMoveToTempScene(DungeonId, IsWin) then
      EventManager:AddEvent(EventID.OnMainCharacterBeginPlay, self, self.OnSettlementPlayerCharacterBeginPlay)
      EventManager:AddEvent(EventID.OnNotifyClientToCloseLoading, self, self.OnSettlementPlayerCharacterInitReady)
      self.IsMoveToTempScene = true
      self.NeedPlayTempSceneMonstage = true
    else
      self:CalculatePhantom()
      self:OnBlackScreenSyncFinished(IsHardBoss)
    end
  end
  
  self:RecordCombatData()
  local BlackUI = self:CreateDungeonBlackScreen(true, OnBlackInFinished, IsWin)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local PlayerCharacter = PlayerController:GetMyPawn()
  PlayerCharacter:ResetIdle()
end

function BP_EMGameInstance_C:RecordCombatData()
  self.CombatData = {}
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player then
    self.CombatData.TakeDamagePercentage = Player.PlayerState.TakeDamagePercentage
    self.CombatData.TakedDamage = Player:GetTakedDamage()
    self.CombatData.TakedShieldDamage = Player:GetShieldTakedDamage()
    self.CombatData.TakedHeal = Player:GetTakedHeal()
    self.CombatData.DeadCount = Player:GetRecoveryCount()
    if Player:IsDead() then
      self.CombatData.DeadCount = self.CombatData.DeadCount + 1
    end
    self.CombatData.DamagePercentage = Player.PlayerState.DamagePercentage or 0
    self.CombatData.TotalDamage = Player:GetFinalDamage() or 0
    self.CombatData.MeleeDamage = Player:GetMeleeDamage() or 0
    self.CombatData.RangedDamage = Player:GetRangedDamage() or 0
    self.CombatData.SkillDamage = (Player:GetSkillDamage() or 0) + (Player:GetSummonDamage() or 0)
    self.CombatData.SupportDamage = Player:GetSupportDamage() or 0
    self.CombatData.GiveHealing = Player:GetGiveHealing() or 0
    self.CombatData.TotalKill = Player:GetTotalKillCount() or 0
    self.CombatData.MeleeKill = Player:GetMeleeKillCount() or 0
    self.CombatData.RangedKill = Player:GetRangedKillCount() or 0
    self.CombatData.SkillKill = (Player:GetSkillKillCount() or 0) + (Player:GetSummonKillCount() or 0)
    self.CombatData.SupportKill = Player:GetSupportKillCount() or 0
    self.CombatData.SpConsume = Player:GetSpConsume() or 0
    self.CombatData.BulletConsume = Player:GetBulletConsume() or 0
    self.CombatData.ChestOpenedCount = Player:GetChestOpenedCount() or 0
    self.CombatData.BreakableItemCount = Player:GetBreakableItemCount() or 0
    self.CombatData.MaxComboCount = Player:GetMaxComboCount() or 0
    self.CombatData.MaxDamage = Player:GetMaxDamage() or 0
    self.CombatData.OldBattleInfo = {
      Char_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("Char"),
      MeleeWeapon_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("MeleeWeapon"),
      RangedWeapon_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("RangedWeapon"),
      Player_OldBattleInfo = Player.PlayerState:GetOldBattleInfo("Player")
    }
    self.CombatData.CurBattleInfo = {}
    self.CombatData.CurBattleInfo.Char_CurBattleInfo = {
      Exp = Player:GetAttr("Exp"),
      Level = Player:GetAttr("Level")
    }
    if Player.MeleeWeapon then
      self.CombatData.CurBattleInfo.MeleeWeapon_CurBattleInfo = {
        Exp = Player.MeleeWeapon:GetAttr("Exp"),
        Level = Player.MeleeWeapon:GetAttr("Level")
      }
    end
    if Player.RangedWeapon then
      self.CombatData.CurBattleInfo.RangedWeapon_CurBattleInfo = {
        Exp = Player.RangedWeapon:GetAttr("Exp"),
        Level = Player.RangedWeapon:GetAttr("Level")
      }
    end
    local Weapon = Player:GetCurrentWeapon()
    if Weapon then
      self.CombatData.CurrentWeaponType = Weapon:GetWeaponType()
      self.CombatData.CurrentWeaponMeleeOrRanged = Weapon:GetWeaponMeleeOrRanged()
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameMode and GameState and GameState.GameModeType == "Temple" then
      self.CombatData.StarLevel = GameMode:TriggerDungeonComponentFun("GetStarLevel")
      self.CombatData.FailReason = GameMode:TriggerDungeonComponentFun("GetPlayerFailReason")
      self.CombatData.Score = GameMode:TriggerDungeonComponentFun("GetScore")
      self.CombatData.Collection = GameMode:TriggerDungeonComponentFun("GetCollection")
      self.CombatData.RemainTempleTime = GameMode:TriggerDungeonComponentFun("GetRemainTempleTime")
      self.CombatData.TempleTime = GameState.TempleTime
      self.CombatData.MaxTempleStar = GameState.MaxTempleStar
    end
    if GameState and GameState.GameModeType == "Party" then
      self.CombatData.StarLevel = GameState.CurPartyStar
      self.CombatData.NumOfPlayers = GameState.PartyPlayerDisPercent.Items:Num()
      self.CombatData.PartyPlayerCompleteTime = {}
      for i = 1, GameState.PartyPlayerCompleteTime:Num() do
        self.CombatData.PartyPlayerCompleteTime[i] = GameState.PartyPlayerCompleteTime:GetRef(i)
      end
    end
    if GameMode and GameState and GameState.GameModeType == "FeinaEvent" then
      self.CombatData.CurScore = GameMode:TriggerDungeonComponentFun("GetStar")
      local Avatar = GWorld:GetAvatar()
      local DungeonId = self:GetCurrentDungeonId()
      if Avatar and Avatar.FeiNaDungeonData and Avatar.FeiNaDungeonData[DungeonId] and Avatar.FeiNaDungeonData[DungeonId].MaxProgress then
        self.CombatData.MaxScore = Avatar.FeiNaDungeonData[DungeonId].MaxProgress
      end
      if Avatar and Avatar.Dungeons[DungeonId] and not Avatar.Dungeons[DungeonId].IsPass then
        self.CombatData.NotPass = true
      end
    end
    if GameMode and GameState and GameState.GameModeType == "Paotai" then
      self.CombatData.CurScore = GameMode:TriggerDungeonComponentFun("GetScore")
      self.CombatData.CurStar = GameMode:TriggerDungeonComponentFun("GetStar")
      local EventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
      local Avatar = GWorld:GetAvatar()
      local DungeonId = self:GetCurrentDungeonId()
      if Avatar and Avatar.PaotaiGame and Avatar.PaotaiGame[EventId] and Avatar.PaotaiGame[EventId][DungeonId] and Avatar.PaotaiGame[EventId][DungeonId].MaxScore then
        self.CombatData.MaxScore = Avatar.PaotaiGame[EventId][DungeonId].MaxScore
      end
    end
    if GameMode and GameState and GameState.GameModeType == "SoloRaid" then
      self.CombatData.MaxScore = GameMode:TriggerDungeonComponentFun("GetHistoryMaxScore") or 0
    end
    local Avatar = GWorld:GetAvatar()
    self.CombatData.IsInOnlineDungeon = Avatar:IsInMultiDungeon()
    self.CombatData.TeammateDamageInfos = Player:GetTeammateDamageInfos():ToTable()
    for _, value in ipairs(self.CombatData.TeammateDamageInfos) do
      if value.TeammateEid and TeamController:GetModel() and TeamController:GetModel():GetTeamMember(value.TeammateEid) then
        value.Index = TeamController:GetModel():GetTeamMember(value.TeammateEid).Index
      end
    end
    self.CombatData.TeammateNum = Player:GetTeammateDamageInfos() and Player:GetTeammateDamageInfos():Num() or 0
    self.CombatData.PhantomAttrInfos = Player:GetPhantomAttrInfos():ToTable()
    self.CombatData.PhantomNum = Player:GetPhantomAttrInfos() and Player:GetPhantomAttrInfos():Num() or 0
    self.GameEndTime = TimeUtils.NowTime()
    self:FillTempTeamInfo(GameState, Player)
  end
  PrintTable(self.CombatData, 5)
end

function BP_EMGameInstance_C:FillTempTeamInfo(GameState, Player)
  self.CombatData.TempTeamInfo = {}
  if not GameState or not Player then
    return
  end
  for _, PlayerState in pairs(GameState.PlayerArray) do
    if PlayerState then
      local Info = {}
      Info.IsMainPlayer = PlayerState.Eid == Player.Eid
      Info.Eid = PlayerState.Eid
      Info.Uid = PlayerState.Uid
      Info.PlayerLevel = PlayerState.PlayerLevel
      Info.PlayerName = PlayerState.PlayerName
      Info.HeadIconId = PlayerState.HeadIconId
      self.CombatData.TempTeamInfo[PlayerState.Uid] = Info
      DebugPrint("ljl@FillTempTeamInfo Uid", Info.Uid)
    end
  end
end

function BP_EMGameInstance_C:PushGameEndInfo(...)
  self.GameEndInfo = table.pack(...)
end

function BP_EMGameInstance_C:EnablePlayerCharacterInput()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local PlayerCharacter = PlayerController:GetMyPawn()
  PlayerCharacter:EnableInput(PlayerController)
end

function BP_EMGameInstance_C:CreateDungeonBlackScreen(ShowFade, Callback, IsWin)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  DebugPrint("DungeonSettlement: CreateDungeonBlackScreen")
  return UIManager:LoadUINew("DungeonBlackScreen", ShowFade, Callback, IsWin)
end

function BP_EMGameInstance_C:OnBlackScreenSyncFinished(IsHardBoss)
  DebugPrint("OnBlackScreenSyncFinished")
  self:OnSettlementPlayerCharacterBeginPlay()
  if not IsHardBoss or 0 == self.PhantomTeammatesNum then
    self:OnCharaterReset()
    self:OnSettlementPlayerCharacterInitReady()
  end
end

function BP_EMGameInstance_C:OnSettlementPlayerCharacterBeginPlay()
  EventManager:RemoveEvent(EventID.OnMainCharacterBeginPlay, self)
  DebugPrint("DungeonSettlement: OnSettlementPlayerCharacterBeginPlay")
  local BlackUI = self:CreateDungeonBlackScreen(false)
  self.GameEndInfo = nil
end

function BP_EMGameInstance_C:OnSettlementPhantomInitReady()
  DebugPrint("OnSettlementPhantomInitReady")
  self.InitPhantomTeammates = self.InitPhantomTeammates + 1
  if self.InitPhantomTeammates >= self.PhantomTeammatesNum then
    EventManager:RemoveEvent(EventID.OnPhantomInitReady, self)
    self:OnCharaterReset()
    self:OnSettlementPlayerCharacterInitReady()
  end
end

function BP_EMGameInstance_C:OnCharaterReset()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  PlayerCharacter:InitCharacterInfo(PlayerCharacter.InfoForInit)
  PlayerCharacter:ResetIdle()
  USkillFeatureFunctionLibrary.SKillFeatureForceStop()
end

function BP_EMGameInstance_C:OnSettlementPlayerCharacterInitReady()
  EventManager:RemoveEvent(EventID.OnNotifyClientToCloseLoading, self)
  self.bPlayerCharacterInitReady = true
  self:TryDungeonSettlement()
end

function BP_EMGameInstance_C:PushLogicServerCallbackInfo(...)
  if WorldTravelSubsystem() and 0 == WorldTravelSubsystem():GetCurrentSceneId() then
    DebugPrint("TryDungeonSettlement SceneId为0，丢弃此次逻辑服结算数据！")
    return
  end
  self.LogicServerCallbackInfo = table.pack(...)
  self:TryDungeonSettlement()
end

function BP_EMGameInstance_C:SetExitLevelEndPointInfo(Transformation)
  print(_G.LogTag, "SetExitLevelEndPointInfo", Transformation.Translation, Transformation.Rotation)
  self.UseExitLevel = true
  self.ExitLevelEndPointTransformation = Transformation
end

function BP_EMGameInstance_C:TryDungeonSettlement()
  DebugPrint("DungeonSettlement: TryDungeonSettlement", self.bPlayerCharacterInitReady, self.LogicServerCallbackInfo)
  if self.bPlayerCharacterInitReady and self.LogicServerCallbackInfo then
    if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
      local PostProcessVolumeActor = UGameplayStatics.GetActorOfClass(self, APostProcessVolume:StaticClass())
      local RVTVolumeActor = UGameplayStatics.GetActorOfClass(self, ARuntimeVirtualTextureVolume:StaticClass())
      if PostProcessVolumeActor and not RVTVolumeActor then
        local PPVTrans = PostProcessVolumeActor:GetTransform()
        local RVTTrans = UKismetMathLibrary.MakeTransform(PPVTrans.Translation - PPVTrans.Scale3D * 200, FRotator(), PPVTrans.Scale3D * 400.0 * 2)
        local RVTVolume1 = self:GetWorld():SpawnActor(ARuntimeVirtualTextureVolume:StaticClass(), RVTTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        local RVTVolume2 = self:GetWorld():SpawnActor(ARuntimeVirtualTextureVolume:StaticClass(), RVTTrans, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        RVTVolume1.VirtualTextureComponent.VirtualTexture = LoadObject("/Game/Asset/Scene/common/3Texture/RVT/RVT_DefaultColor.RVT_DefaultColor")
        RVTVolume1.VirtualTextureComponent.StreamingTexture = LoadObject("/Game/Asset/Scene/common/3Texture/RVT/RVT_Color_SVT.RVT_Color_SVT")
        RVTVolume2.VirtualTextureComponent.VirtualTexture = LoadObject("/Game/Asset/Scene/common/3Texture/RVT/RVT_DefaultHeight.RVT_DefaultHeight")
        RVTVolume2.VirtualTextureComponent.StreamingTexture = LoadObject("/Game/Asset/Scene/common/3Texture/RVT/RVT_Height_SVT.RVT_Height_SVT")
        URuntimeCommonFunctionLibrary.MarkRVTVolumeDirty(RVTVolume1)
        URuntimeCommonFunctionLibrary.MarkRVTVolumeDirty(RVTVolume2)
      elseif not PostProcessVolumeActor then
        DebugPrint("DungeonSettlement:No PostProcessVolume So No RuntimeVirtualVolume")
      end
    end
    local CurrentDungeonId = self:GetCurrentDungeonId()
    if 0 ~= CurrentDungeonId then
      EventManager:FireEvent(EventID.SystemGuideExitDungeon, self:GetCurrentDungeonId())
    end
    PrintTable(self.LogicServerCallbackInfo, 5)
    self.bPlayerCharacterInitReady = nil
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      DebugPrint("Error: DungeonSettlement: 找不到Avatar!")
    end
    local CurDungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
    local LogicServerInfo = CommonUtils.DeepCopy(self.LogicServerCallbackInfo)
    self.LogicServerCallbackInfo = nil
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    
    local function OnBlackOutFinished()
      self.IsInSettlementScene = nil
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      if GameState then
        GameState.IsInSettlementScene = true
      end
      if Avatar and Avatar:IsInRougeLike() then
        UIManager:LoadUINew("RougeSettlement", LogicServerInfo)
      elseif CurDungeonType and CurDungeonType == CommonConst.DungeonType.Abyss then
        UIManager:LoadUINew("AbyssSettlement", LogicServerInfo)
      elseif DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon then
        self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
      elseif 80401 == CurrentDungeonId then
        self:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
      else
        UIManager:LoadUINew("DungeonSettlement", LogicServerInfo, self.DungeonIdCache, self.CombatData)
      end
    end
    
    local bSkipOutAnim = false
    if DataMgr.Dungeon[CurrentDungeonId] and DataMgr.Dungeon[CurrentDungeonId].IsGameEventDungeon then
      bSkipOutAnim = true
    end
    local BlackUI = UIManager:GetUI("DungeonBlackScreen")
    BlackUI:FadeOut(OnBlackOutFinished, bSkipOutAnim)
    if Avatar and Avatar:IsInRougeLike() then
      return
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local PlayerCharacter = PlayerController:GetMyPawn()
    if self.UseExitLevel then
      local CurrentLevelEndPointTransform = self.ExitLevelEndPointTransformation
      local CurrentLevelEndPointLocation = CurrentLevelEndPointTransform.Translation
      local CurrentLevelEndPointRotation = CurrentLevelEndPointTransform.Rotation:ToRotator()
      PlayerCharacter:SetEndPointInfo(true, CurrentLevelEndPointLocation, CurrentLevelEndPointRotation)
      self.UseExitLevel = false
    end
    PlayerCharacter:SetCanInteractiveTrigger(false)
    local IsWin = table.unpack(LogicServerInfo)
    if IsWin then
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      if GameState then
        GameState:OnWCDungeonSettlement()
      end
    end
    self:PlayerDungeonSettlement(IsWin)
  end
end

function BP_EMGameInstance_C:IsInTempScene()
  if self.IsInSettlementScene then
    return true
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState.IsInSettlementScene then
    return true
  end
  return false
end

function BP_EMGameInstance_C:PlayerDungeonSettlement(IsWin)
  local EMGameState = UE4.UGameplayStatics.GetGameState(self)
  if EMGameState then
    EMGameState.SettlementCharacters:Clear()
  end
  local IsInDungeon = EMGameState and EMGameState:IsInDungeon()
  if self.ScenePlayers ~= nil then
    local SettlementData
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      if Avatar:IsInHardBoss() and not IsInDungeon then
        local HardBossId = Avatar.HardBossInfo.HardBossId
        DebugPrint("BP_EMGameInstance_C:PlayerDungeonSettlement HardBossId:", HardBossId)
        SettlementData = DataMgr.HardBossMain[HardBossId]
        if nil == SettlementData then
          EMGameState:ShowDungeonError("PlayerDungeonSettlement 梦魇SettlementData为空，请检查配表数据 HardBossId: " .. HardBossId, Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.Config)
        end
      else
        local DungeonId = self:GetCurrentDungeonId()
        DebugPrint("BP_EMGameInstance_C:PlayerDungeonSettlement DungeonId:", DungeonId)
        SettlementData = DataMgr.Dungeon[DungeonId]
        if nil == SettlementData then
          EMGameState:ShowDungeonError("PlayerDungeonSettlement 副本SettlementData为空，请检查配表数据 DungeonId: " .. DungeonId, Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.Config)
        end
      end
    end
    if nil == SettlementData then
      DebugPrint("error: BP_EMGameInstance_C:PlayerDungeonSettlement SettlementData is nil!")
    end
    local OriginLoc, OriginRot = self:CalculateSettlementOriginLoc(self.IsMoveToTempScene)
    local OriginTransform = FTransform(OriginRot:ToQuat(), OriginLoc)
    for i = 1, #self.ScenePlayers do
      if self.ScenePlayers[i].IsMainPlayer then
        local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        MainPlayer:InitCharacterInfo(self.ScenePlayers[i])
        MainPlayer:ResetOnSetEndPoint()
        MainPlayer:SetMainPlayerDungeonSettlementTransform(self.IsMoveToTempScene, OriginLoc, OriginRot)
        if SettlementData then
          MainPlayer:OnDungeonSettlement(IsWin, i, SettlementData)
        end
        local Teammates = MainPlayer:GetAllTeammates()
        for _, Target in pairs(Teammates) do
          if Target ~= MainPlayer then
            Target:SetActorHideTag("DungeonSettlement", true, false, true)
          end
        end
        if self.ScenePlayers[i].IsDead and TeamController then
          TeamController:SendTeamLeave()
          TeamController:GetModel():SetTeam(nil)
        end
      elseif not IsWin or SettlementData and SettlementData.NotShowTeammate then
      else
        local CurrentCharacter = self:GetWorld():SpawnActor(LoadClass("/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C"), OriginTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
        CurrentCharacter:InitCharacterInfo(self.ScenePlayers[i])
        CurrentCharacter:ResetOnSetEndPoint()
        CurrentCharacter:SetOtherPlayerDungeonSettlementTransform()
        if SettlementData then
          CurrentCharacter:OnDungeonSettlementByIndex(i, self.ScenePlayers[i].CurrentWeaponType, self.ScenePlayers[i].CurrentWeaponMeleeOrRanged, SettlementData)
        end
        CurrentCharacter:SetActorHideTag("InGame", false)
        if EMGameState then
          EMGameState.SettlementCharacters:Add(CurrentCharacter)
        end
      end
    end
  elseif EMGameState then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      if Avatar:IsInHardBoss() and not IsInDungeon then
        local HardBossId = Avatar.HardBossInfo.HardBossId
        EMGameState:ShowDungeonError("PlayerDungeonSettlement ScenePlayers为空，无法正常做结算表现 HardBossId: " .. HardBossId, Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.DataNil)
      else
        local DungeonId = self:GetCurrentDungeonId()
        EMGameState:ShowDungeonError("PlayerDungeonSettlement ScenePlayers为空，无法正常做结算表现 DungeonId: " .. DungeonId, Const.DungeonErrorType.Settlement, Const.DungeonErrorTitle.DataNil)
      end
    end
  end
end

function BP_EMGameInstance_C:CalculateSettlementOriginLoc(IsMoveToTempScene)
  local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsMoveToTempScene then
    local EndPointSeqEnable, EndPointLocation, EndPointRotation = MainPlayer:GetEndPointInfo()
    if EndPointSeqEnable then
      return EndPointLocation, EndPointRotation
    end
  else
    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar:IsInHardBoss() then
      if Avatar.HardBossInfo then
        local HardBossId = Avatar.HardBossInfo.HardBossId
        if DataMgr.HardBossMain[HardBossId] then
          local PosDisplayName = DataMgr.HardBossMain[HardBossId].PosDisplayName
          local PlayerPoint = EMGameState:GetTargetPoint(PosDisplayName)
          local PlayerPointLoc = PlayerPoint:K2_GetActorLocation()
          local PlayerPointRot = PlayerPoint:K2_GetActorRotation()
          return PlayerPointLoc, PlayerPointRot
        end
      else
        local EndPointSeqEnable, EndPointLocation, EndPointRotation = MainPlayer:GetEndPointInfo()
        if EndPointSeqEnable then
          return EndPointLocation, EndPointRotation
        end
      end
    else
      local WorldCompositionSubSystem = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self, UE4.UWorldCompositionSubSystem)
      local WCIsInDungeon = WorldCompositionSubSystem and WorldCompositionSubSystem:WCIsInDungeon()
      if WCIsInDungeon then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        if GameState then
          local SettlementPoint = GameState:GetNearestSettlementPoint(MainPlayer:K2_GetActorLocation())
          if SettlementPoint then
            local SettlementPointLoc = SettlementPoint:K2_GetActorLocation()
            local SettlementPointRot = SettlementPoint:K2_GetActorRotation()
            DebugPrint("CalculateSettlementOriginLoc Find Nearest Settlement Point:", SettlementPointLoc, SettlementPointRot)
            return SettlementPointLoc, SettlementPointRot
          end
        end
      end
    end
  end
  return FVector(0, 0, 0), FRotator(0, 0, 0)
end

function BP_EMGameInstance_C:ProcessSettlementCharacter()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  Player:SetActorEnableCollision(true)
  local EMGameState = UE4.UGameplayStatics.GetGameState(self)
  if EMGameState then
    for i = 1, EMGameState.SettlementCharacters:Length() do
      local CurrentCharacter = EMGameState.SettlementCharacters:GetRef(i)
      if IsValid(CurrentCharacter) then
        CurrentCharacter:K2_DestroyActor()
      end
    end
    EMGameState.SettlementCharacters:Clear()
  end
  local PhantomTeammates = Player:GetPhantomTeammates()
  for _, Target in pairs(PhantomTeammates) do
    if Target ~= Player then
      Target:SetActorHideTag("DungeonSettlement", false, false, true)
    end
  end
end

function BP_EMGameInstance_C:LoadGameEventSettlementUI(CurrentDungeonId, CurDungeonType, LogicServerInfo)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("Error: DungeonSettlement: 找不到Avatar!")
    return
  end
  local IsWin, BattleInfo, Rewards, DungeonRewards, PlayerTime, GameTime, ClientRes = table.unpack(LogicServerInfo)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if CurDungeonType and "FeinaEvent" == CurDungeonType then
    local DungeonInfo = DataMgr.FeinaEventDungeon[CurrentDungeonId]
    local CurScore = 0
    local MaxScore = 0
    if self.CombatData and self.CombatData.CurScore then
      CurScore = self.CombatData.CurScore
    end
    if self.CombatData and self.CombatData.MaxScore then
      MaxScore = self.CombatData.MaxScore
    end
    local Params = {
      LevelScore = CurScore,
      IsWin = IsWin,
      Text_Title = "FeinaEvent_DungeonFinish_Title",
      Text_GetReward = "UI_Dungeon_First_Reward",
      ActivityId = DungeonInfo.SettlementId,
      IsNewRecord = CurScore > MaxScore,
      DungeonId = CurrentDungeonId
    }
    Params.ScoreInfo = {
      {
        text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[1]),
        isFinish = CurScore >= DungeonInfo.Level[1]
      },
      {
        text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[2]),
        isFinish = CurScore >= DungeonInfo.Level[2]
      },
      {
        text = string.format(GText("FeinaEvent_DungeonTask_1"), DungeonInfo.Level[3]),
        isFinish = CurScore >= DungeonInfo.Level[3]
      }
    }
    local ShouldShowReward = false
    if IsWin and Avatar.Dungeons[CurrentDungeonId] and Avatar.Dungeons[CurrentDungeonId].IsPass and self.CombatData and self.CombatData.NotPass then
      Params.RewardIds = {
        DungeonInfo.PassReward
      }
      ShouldShowReward = true
    end
    
    function Params.ContinueCallback()
      Avatar:EnterDungeon(CurrentDungeonId)
    end
    
    local SettlementUI = ActivityUtils.OpenActivitySettlement(DungeonInfo.SettlementId, CurrentDungeonId, Params)
    if SettlementUI and not ShouldShowReward then
      SettlementUI.Settlement_RewardItem:SetVisibility(ESlateVisibility.Collapsed)
    end
  elseif CurDungeonType and "Paotai" == CurDungeonType then
    local CurScore = 0
    local MaxScore = 0
    local CurStar = 0
    if self.CombatData and self.CombatData.CurScore then
      CurScore = self.CombatData.CurScore
    end
    if self.CombatData and self.CombatData.MaxScore then
      MaxScore = self.CombatData.MaxScore
    end
    if self.CombatData and self.CombatData.CurStar then
      CurStar = self.CombatData.CurStar
    end
    local CurEventId = DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue
    local Params = {
      LevelScore = CurScore,
      IsWin = IsWin,
      Text_Title = "FeinaEvent_DungeonFinish_Title",
      Text_GetReward = "FeinaEvent_DungeonFinish_Reward",
      ActivityId = CurEventId,
      IsNewRecord = CurScore > MaxScore,
      DungeonId = CurrentDungeonId
    }
    Params.ScoreInfo = {}
    local LeveDes = DataMgr.PaotaiMiniGame[CurrentDungeonId].LeveDes
    for i = 1, #LeveDes do
      table.insert(Params.ScoreInfo, {
        text = string.format(GText(LeveDes[i]), DataMgr.PaotaiMiniGame[CurrentDungeonId].Level[i]),
        isFinish = i <= CurStar
      })
    end
    
    function Params.ContinueCallback()
      local CustomParams = {
        PaotaiId = DataMgr.PaotaiMiniGame[CurrentDungeonId].Id
      }
      Avatar:EnterEventDungeon(nil, CurrentDungeonId, nil, CurEventId, CustomParams)
    end
    
    ActivityUtils.OpenActivitySettlement(DataMgr.PaotaiEventConstant.PaotaiGameEventId.ConstantValue, CurrentDungeonId, Params)
  elseif CurDungeonType and "SoloRaid" == CurDungeonType then
    local CurScore = 0
    local MaxScore = 0
    local RawTimeRemain = 0
    if ClientRes and ClientRes.ResRaidScore then
      CurScore = ClientRes.ResRaidScore
    end
    if ClientRes and ClientRes.RawTimeRemain then
      RawTimeRemain = ClientRes.RawTimeRemain
    end
    MaxScore = self.CombatData.MaxScore or 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return nil
    end
    local CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
    local RaidSeason = Avatar.RaidSeasons[CurrentRaidSeasonId]
    local EventId = DataMgr.RaidSeason[CurrentRaidSeasonId] and DataMgr.RaidSeason[CurrentRaidSeasonId].EventId or DataMgr.RaidSeason[1].EventId
    local IsShowReturnText = false
    local RaidDungeonConfig = DataMgr.RaidDungeon[CurrentDungeonId]
    if RaidDungeonConfig and RaidDungeonConfig.TicketNum then
      for _, TicketCount in pairs(RaidDungeonConfig.TicketNum) do
        if TicketCount and TicketCount > 0 then
          IsShowReturnText = true
          break
        end
      end
    end
    
    local function MergeRewardTable(target, source)
      if not source then
        return
      end
      for key, value in pairs(source) do
        if type(value) == "table" then
          if not target[key] then
            target[key] = {}
          end
          MergeRewardTable(target[key], value)
        elseif target[key] and type(target[key]) == "number" and type(value) == "number" then
          target[key] = target[key] + value
        else
          target[key] = value
        end
      end
    end
    
    local MergedRewards = {}
    if Rewards then
      MergeRewardTable(MergedRewards, Rewards)
    end
    if DungeonRewards then
      MergeRewardTable(MergedRewards, DungeonRewards)
    end
    local ResId, ConsumeTicketCount, CurrentTicketCount = GuildWarUtils.GetDungeonTicketInfo(CurrentDungeonId)
    local Params = {
      LevelScore = math.floor(CurScore),
      IsWin = IsWin,
      Text_Title = "FeinaEvent_DungeonFinish_Title",
      Text_GetReward = "FeinaEvent_DungeonFinish_Reward",
      ActivityId = EventId,
      IsNewRecord = CurScore > MaxScore,
      DungeonId = CurrentDungeonId,
      TimeRemain = math.floor(RawTimeRemain or 0),
      RewardsInfo = MergedRewards,
      IsShowReturnText = IsShowReturnText
    }
    if ResId > 0 and ConsumeTicketCount > 0 then
      Params.CostParams = {
        ResourceId = ResId,
        Numerator = CurrentTicketCount,
        Denominator = ConsumeTicketCount,
        bShowDenominator = true,
        Owner = nil
      }
    end
    
    function Params.ContinueCallback()
      return GuildWarUtils.EnterEventDungeon(CurrentDungeonId, EventId)
    end
    
    ActivityUtils.OpenActivitySettlement(EventId, CurrentDungeonId, Params)
  elseif CurDungeonType and "Temple" == CurDungeonType then
    local CurScore = 0
    local MaxScore = 0
    local CurStar = 0
    if self.CombatData and self.CombatData.Score then
      CurScore = self.CombatData.Score
    end
    if self.CombatData and self.CombatData.Score then
      MaxScore = self.CombatData.Score
    end
    if self.CombatData and self.CombatData.StarLevel then
      CurStar = self.CombatData.StarLevel
    end
    local Params = {
      LevelScore = CurScore,
      IsWin = IsWin,
      Text_Title = "TempleSolo_DungeonFinish_Title",
      Text_GetReward = "TempleSolo_DungeonFinish_Reward",
      ActivityId = 108001,
      IsNewRecord = CurScore > MaxScore,
      DungeonId = CurrentDungeonId,
      Text_TotalScore = "TempleSolo_Total_Time"
    }
    Params.ScoreInfo = {}
    local TempleInfo = DataMgr.Temple[CurrentDungeonId]
    for i = 1, #TempleInfo.RatingRange do
      local TextInfo = ""
      local Target = TempleInfo.RatingRange[i]
      local TextRule2 = ""
      if TempleInfo.SucRule == "Time" or TempleInfo.SucRule == "CountDown" then
        TextRule2 = "SECONDS"
      elseif "Score" == TempleInfo.SucRule then
        TextRule2 = "SCORE"
      elseif TempleInfo.SucRule == "Collect" then
        TextRule2 = "COUNT"
      end
      if nil == Target then
        TextInfo = ""
      elseif 0 == Target then
        TextInfo = GText("UI_TEMPLE_SUCRULE_ZERO")
      elseif TempleInfo.SucRule == "CountDown" and TempleInfo.UIShowType and TempleInfo.UIShowType > 0 then
        TextInfo = string.format(GText("UI_TEMPLE_SUCRULE_COUNTDOWN_" .. TempleInfo.UIShowType), 100 - Target)
      elseif "SCORE" == TextRule2 or "COUNT" == TextRule2 then
        TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target
      else
        TextInfo = GText("UI_TEMPLE_SUCRULE_" .. string.upper(TempleInfo.SucRule)) .. Target .. GText("UI_TEMPLE_MEASURE_" .. TextRule2)
      end
      table.insert(Params.ScoreInfo, {
        text = TextInfo,
        isFinish = i <= CurStar
      })
    end
    local IsHardMode = DataMgr.TempleEventLevel[CurrentDungeonId].IsHardMode
    if IsHardMode then
      Params.IconPath = "/Game/UI/Texture/Static/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge.T_Activity_Temple_Solo_Star_Challenge"
      Params.IconPath_2 = "/Game/UI/Texture/Static/Atlas/Activity/Temple/Solo/T_Activity_Temple_Solo_Star_Challenge_Empty.T_Activity_Temple_Solo_Star_Challenge_Empty"
    end
    
    function Params.ContinueCallback()
      Avatar:EnterEventDungeon(nil, CurrentDungeonId, nil, 108001)
    end
    
    ActivityUtils.OpenActivitySettlement(108001, CurrentDungeonId, Params)
  else
    UIManager:LoadUINew("DungeonSettlement", LogicServerInfo, self.DungeonIdCache, self.CombatData)
  end
end

function BP_EMGameInstance_C:CheckMaintenanceInfo(RequestHotNum, Callback)
  CdnTool:GetMaintenance(RequestHotNum, function(Maintenances)
    self:GetMaintenanceCb(RequestHotNum, Maintenances, Callback)
  end)
end

function BP_EMGameInstance_C:JumpToHomepage(RequestHotNum)
  local function CheckCbChannel(ChannelId, ImgChannelId, Data)
    if not Data then
      return false
    end
    if -1 == ChannelId and -1 == ImgChannelId then
      return true
    end
    if Data.medium then
      for _, Id in ipairs(Data.medium) do
        if ChannelId == tonumber(Id) then
          return true
        end
      end
    end
    if Data.channel_ids then
      local ChannelInfo = DataMgr.ChannelInfo[ChannelId]
      local Provider = ChannelInfo and ChannelInfo.Provider
      if Provider then
        for _, ChannelInfo in ipairs(Data.channel_ids) do
          if Provider == ChannelInfo or Provider == ChannelInfo.code then
            return true
          end
        end
      end
    end
    if Data.img_channel_id then
      local ImgChannelInfo = DataMgr.ImgChannelInfo[ImgChannelId]
      local Provider = ImgChannelInfo and ImgChannelInfo.Provider
      if Provider then
        for _, ChannelInfo in ipairs(Data.img_channel_id) do
          if Provider == ChannelInfo or Provider == ChannelInfo.code then
            return true
          end
        end
      end
    end
    return false
  end
  
  CdnTool:GetMaintenanceInterceptUrl(RequestHotNum, function(InterceptUrl)
    local JumpURL
    if InterceptUrl and InterceptUrl.mediumList then
      local ChannelId = Utils.HeroUSDKSubsystem():GetChannelId()
      local ImgChannelId = Utils.HeroUSDKSubsystem():GetMirrorChannelId()
      for _, Data in ipairs(InterceptUrl.mediumList) do
        if CheckCbChannel(ChannelId, ImgChannelId, Data) then
          JumpURL = Data.content and Data.content[1] and Data.content[1].url
          local SystemLanguage = EMCache:Get("SystemLanguage")
          for _, InfoContent in ipairs(Data.content) do
            if InfoContent.language and InfoContent.language.code == SystemLanguage then
              JumpURL = InfoContent.url
              break
            end
          end
          break
        end
      end
    end
    if JumpURL then
      UE4.UKismetSystemLibrary.LaunchURL(JumpURL)
    end
  end)
end

function BP_EMGameInstance_C:GetMaintenanceCb(RequestHotNum, Maintenances, Callback)
  local IsSuccess = true
  local bHasContent = false
  if Maintenances then
    local Now = TimeUtils.NowTime()
    for _, Info in pairs(Maintenances) do
      if Info.Content and #Info.Content > 0 and Now > Info.StartTimestamp and Now < Info.EndTimestamp then
        local Content
        local SystemLanguage = EMCache:Get("SystemLanguage")
        for _, InfoContent in ipairs(Info.Content) do
          if InfoContent.language == SystemLanguage then
            Content = InfoContent
            break
          end
        end
        if Content then
          IsSuccess = false
          local Params = {}
          Params.ShortText = Content.body
          
          function Params.RightCallbackFunction()
            self:JumpToHomepage(RequestHotNum)
          end
          
          UIManager(self):ShowCommonPopupUI(100205, Params)
          bHasContent = true
          break
        end
      end
    end
  end
  if Callback then
    Callback(IsSuccess, bHasContent)
  end
end

function BP_EMGameInstance_C:SetProgressData(DataTable, PlayerSlice)
  self.InterruptProgressData = DataTable
  self.PlayerSliceData = PlayerSlice
end

function BP_EMGameInstance_C:GetProgressData()
  return self.InterruptProgressData
end

function BP_EMGameInstance_C:GetPlayerSliceData()
  return self.PlayerSliceData
end

function BP_EMGameInstance_C:ClearProgressData()
  self.InterruptProgressData = nil
end

function BP_EMGameInstance_C:ClearPlayerSliceData()
  self.PlayerSliceData = nil
end

function BP_EMGameInstance_C:SetExitDungeonData(DataTable)
  self.ExitDungeonData = DataTable
end

function BP_EMGameInstance_C:GetExitDungeonData()
  return self.ExitDungeonData
end

function BP_EMGameInstance_C:ClearExitDungeonData()
  self.ExitDungeonData = nil
end

function BP_EMGameInstance_C:LoadLogoAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:LoadUI(UIConst.PROLOGUEENDLOGO, "PrologueEndLogo", UIConst.ZORDER_ABOVE_ALL)
  if nil ~= PrologueEndLogoUI then
    PrologueEndLogoUI:Show("Talk")
  end
  self.LogoLanguageMap = {
    TextMapContent = "CN_In",
    ContentEN = "EN_In",
    ContentJP = "JP_In",
    ContentKR = "KR_In",
    ContentTC = "TC_In"
  }
end

function BP_EMGameInstance_C:UnLoadLogoAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:Close()
end

function BP_EMGameInstance_C:ShowLogoAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  local LogoIn = self.LogoLanguageMap[CommonConst.SystemLanguage] or self.LogoLanguageMap[CommonConst.SystemLanguages.Default]
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI[LogoIn])
end

function BP_EMGameInstance_C:ShowWhiteAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Static_Img_BottomMask_In)
end

function BP_EMGameInstance_C:ShowBlackAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Black_In)
end

function BP_EMGameInstance_C:HideLogoAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Logo_Out)
end

function BP_EMGameInstance_C:HideBlackAtEndOfPrologue()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Black_Out)
end

function BP_EMGameInstance_C:PrologueLogoSetFirstDialog()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI.Text_ChapterDesc:SetText(GText("UI_LOGO_DIALOGUE_10018201"))
  PrologueEndLogoUI.Text_WorldDesc:SetText(GText("UI_LOGO_DIALOGUE_10018201_WORLD"))
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_In)
end

function BP_EMGameInstance_C:PrologueLogoUnSetFirstDialog()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_Out)
end

function BP_EMGameInstance_C:PrologueLogoSetSecondDialog()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI.Text_ChapterDesc:SetText(GText("UI_LOGO_DIALOGUE_10018202"))
  PrologueEndLogoUI.Text_WorldDesc:SetText(GText("UI_LOGO_DIALOGUE_10018202_WORLD"))
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_In)
end

function BP_EMGameInstance_C:PrologueLogoUnSetSecondDialog()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  local PrologueEndLogoUI = UIManager:GetUIObj("PrologueEndLogo")
  PrologueEndLogoUI:PlayAnimation(PrologueEndLogoUI.Text_Out)
end

function BP_EMGameInstance_C:OnGlobalGameUITagChanged(OldTag, NewTag)
  DebugPrint("LHQ_OnGlobalGameUITagChanged: start")
  if "" == NewTag then
    self:TriggerAllNpcPauseAndHide("None")
  else
    self:TriggerAllNpcPauseAndHide(NewTag)
  end
  DebugPrint("LHQ_OnGlobalGameUITagChanged: end")
end

function BP_EMGameInstance_C:TriggerAllNpcPauseAndHide(NewTag)
  DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: start")
  
  local function PlayHideActorEffect(Actor)
    if Actor.FXComponent then
      Actor:SetTickableWhenPaused(true)
    end
    if Actor.FXComponent then
      Actor.FXComponent:PlayEffectByIDParams(302, {bTickEvenWhenPaused = true, NotAttached = true})
    else
      local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
      local Location = Actor:K2_GetActorLocation()
      Player.FXComponent:PlayEffectByIDParams(302, {
        UseAbsoluteLocation = true,
        Location = {
          Location.X,
          Location.Y,
          Location.Z
        },
        bTickEvenWhenPaused = true
      })
    end
  end
  
  local CurGameMode = UE4.UGameplayStatics.GetGameMode(self)
  local CurGameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if not CurGameMode or not CurGameInstance then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local NpcCharacterMap = GameState.NpcCharacterMap:ToTable()
  for _, Npc in pairs(NpcCharacterMap) do
    local NpcData = DataMgr.Npc[Npc.UnitId]
    if nil ~= NpcData then
      if nil ~= NpcData.GlobalGameUITagList then
        for _, value in pairs(NpcData.GlobalGameUITagList) do
          if value == NewTag then
            Npc:TriggerNpcGlobalTimeDilation(true)
            Npc:SetActorHideTag("GlobalTimeDilation", false, false, true)
            goto lbl_82
          end
        end
      end
      if (not Npc.HideTags or 0 == Npc.HideTags:Num()) and "None" ~= NewTag then
        Npc:TriggerNpcGlobalTimeDilation(true)
        PlayHideActorEffect(Npc)
      end
      Npc:SetActorHideTag("GlobalTimeDilation", true, false, true)
      ::lbl_82::
      if "None" == NewTag then
        Npc:SetActorHideTag("GlobalTimeDilation", false, false, true)
      end
    end
    local NpcName = Npc:GetName()
    local IsHidden = Npc.bHidden
    if IsHidden then
      DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: " .. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "true")
    else
      DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: " .. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "false")
    end
  end
  local CustomNpcs = GameState.CustomNpcSet:ToTable()
  for _, CustomNpc in pairs(CustomNpcs) do
    if (not CustomNpc.HideTags or 0 == CustomNpc.HideTags:Num()) and "None" ~= NewTag then
      PlayHideActorEffect(CustomNpc)
    end
    CustomNpc:SetCustomNpcHideTag("GlobalTimeDilation", true)
    if "None" == NewTag then
      CustomNpc:SetCustomNpcHideTag("GlobalTimeDilation", false)
    end
    local NpcName = CustomNpc:GetName()
    local IsHidden = CustomNpc.bHidden
    if IsHidden then
      DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: " .. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "true")
    else
      DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: " .. NewTag .. " Npc: " .. NpcName .. " IsHidden: " .. "false")
    end
  end
  DebugPrint("LHQ_OnGlobalGameUITagChanged_HideNpc: end")
end

function BP_EMGameInstance_C:OnGameInputMethodChanged(CurInputDeviceType, CurInputDeviceName)
  self.CurInputDeviceType = CurInputDeviceType
  self.CurInputDeviceName = CurInputDeviceName
end

function BP_EMGameInstance_C:BindGamepadEvent()
  if self.CurInputDeviceType ~= nil then
    return
  end
  local GameInputModeSubsystem = self:GetGameUIManager():GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    self.CurInputDeviceType = GameInputModeSubsystem:GetCurrentInputType()
    self.CurInputDeviceName = GameInputModeSubsystem:GetCurrentGamepadName()
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnGameInputMethodChanged)
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SendInputDiviceChangeMessage)
  end
end

function BP_EMGameInstance_C:UnBindGamepadEvent()
  if self.CurInputDeviceType == nil then
    return
  end
  local GameInputModeSubsystem = self:GetGameUIManager():GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnGameInputMethodChanged)
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SendInputDiviceChangeMessage)
  end
  self.CurInputDeviceType = nil
  self.CurInputDeviceName = nil
end

function BP_EMGameInstance_C:ReceiveInit()
  GWorld.GameInstance = self
  if IsDedicatedServer(self) then
    return
  end
  ReddotManager._Init()
  
  function self:OnApplicationWillEnterBackground()
    EventManager:FireEvent(EventID.ApplicationWillEnterBackground)
    EMCache:SaveAll(false)
  end
  
  self.ApplicationWillEnterBackgroundDelegate:Add(self, self.OnApplicationWillEnterBackground)
  
  function self:OnApplicationHasEnteredForeground()
    EventManager:FireEvent(EventID.ApplicationHasEnteredForeground)
  end
  
  self.ApplicationHasEnteredForegroundDelegate:Add(self, self.OnApplicationHasEnteredForeground)
  
  function self:OnApplicationWillDeactivate()
    EventManager:FireEvent(EventID.ApplicationWillDeactivate)
    EMCache:SaveAll(false)
  end
  
  self.ApplicationWillDeactivateDelegate:Add(self, self.OnApplicationWillDeactivate)
  
  function self:OnApplicationHasReactivated()
    EventManager:FireEvent(EventID.ApplicationHasReactivated)
  end
  
  self.ApplicationHasReactivatedDelegate:Add(self, self.OnApplicationHasReactivated)
  local TeammateEffects = EMCache:Get("TeammateEffects")
  if TeammateEffects then
    UEMGameInstance.SetFriendFXQuality(TeammateEffects)
  else
    local NowContentPerformance = self.GetGameplayScalabilityLevel()
    UEMGameInstance.SetFriendFXQuality(NowContentPerformance <= 1 and 0 or 1)
  end
  self.CacheShowRewardUIParams = {}
  self.ScriptDetectionCheckRecordNum = 0
  EventManager:AddEvent(EventID.TalkHiddenGameUI, self, self.OnTalkHiddenGameUIChange)
  EventManager:AddEvent(EventID.ConditionComplete, self, self.OnConditionComplete)
end

function BP_EMGameInstance_C:OnApplicationWillTerminate()
  self.ApplicationWillTerminateDelegate:Clear()
  EMCache:SaveAll(false)
end

function BP_EMGameInstance_C:ReceiveShutdown()
  if IsDedicatedServer(self) then
    return
  end
  local ShundownCount = EMCache:Get("ShundownCount") or 0
  EMCache:Set("ShundownCount", ShundownCount + 1)
  ShundownCount = EMCache:Get("ShundownCount") or 0
  ReddotManager._Close()
  EMCache:SaveAll(true)
  if not URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    local Platform = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
    if "Windows" == Platform and ShundownCount > 3 then
      UEMGameInstance.ForceQuitGame()
    end
  end
end

function BP_EMGameInstance_C:InitGameSetting()
  SettingUtils.InitPerformanceSetting()
  self:InitGameSystemLanguage()
  self:InitGameSystemVoice()
  self:InitGameInterfaceMode()
  self:InitGameMuteBackstage()
  self:InitHideBackWeapons()
end

function BP_EMGameInstance_C:InitGameSystemLanguage()
  local SystemLanguage = EMCache:Get("SystemLanguage")
  if nil ~= SystemLanguage then
    CommonConst.SystemLanguage = CommonConst.SystemLanguages[SystemLanguage]
    self.SystemLanguage = Language2ESystemLanguage[CommonConst.SystemLanguage]
  else
    local IsGlobalPak = UE.AHotUpdateGameMode.IsGlobalPak()
    if IsGlobalPak then
      local LanguageMapping = {
        zh = "CN",
        en = "EN",
        ko = "KR",
        ja = "JP"
      }
      local ChineseLanguageMapping = {
        cn = "CN",
        hk = "TC",
        tw = "TC",
        mo = "TC"
      }
      local VoiceMapping = {
        CN = "CN",
        TC = "CN",
        EN = "EN",
        KR = "KR",
        JP = "JP"
      }
      local WindowsLanguage = UE4.UKismetSystemLibrary.GetDefaultLanguage()
      local NationWindowsLanguage = string.sub(WindowsLanguage, 1, 2)
      NationWindowsLanguage = string.lower(NationWindowsLanguage)
      local LangMapping = LanguageMapping[NationWindowsLanguage] or "EN"
      if "CN" == LangMapping then
        local RegionWindowsLanguage = string.lower(WindowsLanguage)
        for key, value in pairs(ChineseLanguageMapping) do
          if string.find(RegionWindowsLanguage, key) then
            LangMapping = value
            break
          end
        end
      end
      CommonConst.SystemLanguage = CommonConst.SystemLanguages[LangMapping]
      self.SystemLanguage = Language2ESystemLanguage[CommonConst.SystemLanguage]
      local Voice = VoiceMapping[LangMapping] or "EN"
      CommonConst.SystemVoice = Voice
      EMCache:Set("SystemVoice", Voice)
      EMCache:Set("SystemLanguage", LangMapping)
    else
      CommonConst.SystemLanguage = CommonConst.SystemLanguages.CN
      EMCache:Set("SystemLanguage", "CN")
      CommonConst.SystemVoice = CommonConst.SystemVoices.CN
      EMCache:Set("SystemVoice", "CN")
    end
    self:OnSystemLanguageChanged()
  end
  local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
  if not IsPIE then
    self:SetCurrentLanguage()
  end
  self:SetUsdkLanguage()
  local AnnounceUtils = require("BluePrints.UI.WBP.Announcement.AnnounceUtils")
  AnnounceUtils:Init(self)
end

function BP_EMGameInstance_C:SetCurrentLanguage()
  local Cultures = {
    CN = "en",
    EN = "en",
    KR = "ko",
    JP = "ja",
    TC = "zh-Hant-tw"
  }
  local SystemLanguage = EMCache:Get("SystemLanguage")
  local Culture = Cultures[SystemLanguage] or "en"
  UE4.UKismetInternationalizationLibrary.SetCurrentLanguage(Culture, true)
end

function BP_EMGameInstance_C:SetUsdkLanguage()
  local UsdkLanguageMapping = {
    CN = "HeroLanguageZhHans",
    TC = "HeroLanguageZhHant",
    EN = "HeroLanguageEn",
    JP = "HeroLanguageJa",
    KR = "HeroLanguageKo"
  }
  local SystemLanguage = EMCache:Get("SystemLanguage")
  local UsdkLanguage = UsdkLanguageMapping[SystemLanguage]
  self:InitUsdkLanguage(EHeroUsdkLanguageFlag[UsdkLanguage])
end

function BP_EMGameInstance_C:InitGameSystemVoice()
  if IsDedicatedServer(self) then
    return
  end
  local SystemVoice = EMCache:Get("SystemVoice")
  if nil ~= SystemVoice then
    CommonConst.SystemVoice = SystemVoice
  end
  self:AddDelayFrameFunc(function()
    AudioManager(self):RecoverSavedData()
  end, 1)
  self:OnSystemVoiceLanguageChanged()
end

function BP_EMGameInstance_C:InitGameInterfaceMode()
  local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
  if IsPIE then
    return
  end
  if UE4.UUCloudGameInstanceSubsystem and UE4.UUCloudGameInstanceSubsystem.IsCloudGame(self) then
    return
  end
  local OptionName = "InterfaceMode"
  local OptionCacheName = "InterfaceModeCacheName"
  local GameInterfaceMode = EMCache:Get(OptionCacheName)
  if nil == GameInterfaceMode then
    local SceneManager = self:GetSceneManager()
    if nil == SceneManager then
      return
    end
    local InterfaceModeList = {
      [1] = EWindowMode.Fullscreen,
      [2] = EWindowMode.Windowed,
      [3] = EWindowMode.WindowedFullscreen
    }
    local OptionInfo = DataMgr.Option[OptionName]
    local DefaultMode = EWindowMode.WindowedFullscreen
    if OptionInfo then
      DefaultMode = InterfaceModeList[tonumber(OptionInfo.DefaultValue)]
      if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM then
        DefaultMode = InterfaceModeList[tonumber(OptionInfo.DefaultValueM)]
      end
    end
    SceneManager:ResizeWindow(DefaultMode)
    EMCache:Set(OptionCacheName, DefaultMode)
    DebugPrint("初始化显示模式 包体首次登陆时设置成无边框窗口化 InitGameInterfaceMode DefaultMode:" .. DefaultMode)
  end
end

function BP_EMGameInstance_C:InitGameMuteBackstage()
  local OptionName = "MuteBackstage"
  local GameMuteBackstage = EMCache:Get(OptionName)
  if nil == GameMuteBackstage then
    local OptionInfo = DataMgr.Option[OptionName]
    if OptionInfo.DefaultValue == "True" then
      GameMuteBackstage = true
    else
      GameMuteBackstage = false
    end
    EMCache:Set(OptionName, GameMuteBackstage)
  end
  if GameMuteBackstage then
    AudioManager(self):BindLogicToWindowActivatedDeactivated()
  else
    AudioManager(self):UnBindLogicToWindowActivatedDeactivated()
  end
end

function BP_EMGameInstance_C:InitHideBackWeapons()
  local CacheName = "HideBackWeapons"
  local bHideBackWeapon = EMCache:Get(CacheName)
  if nil == bHideBackWeapon then
    local OptionInfo = DataMgr.Option[CacheName]
    if OptionInfo.DefaultValue == "True" then
      bHideBackWeapon = true
    else
      bHideBackWeapon = false
    end
    EMCache:Set(CacheName, bHideBackWeapon)
  end
  if not AWeaponBase or not AWeaponBase.SetWeaponBackTimerEnabled then
    return
  end
  AWeaponBase.SetWeaponBackTimerEnabled(self, bHideBackWeapon)
end

function BP_EMGameInstance_C:UploadLuaCallError(ErrorMsg)
  if not GWorld or not GWorld:GetAvatar() then
    return ""
  end
  local Avatar = GWorld:GetAvatar()
  local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(self, 0)
  
  local function GetPlayerSceneName()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not (PlayerCharacter and GameState) or not GameMode then
      return ""
    end
    local WCSubsystem = GameMode:GetWCSubSystem()
    if WCSubsystem then
      if GameState:IsInDungeon() then
        return WCSubsystem:GetLocationLevelName(PlayerCharacter:K2_GetActorLocation())
      elseif Avatar:IsInBigWorld() then
        return WCSubsystem:GetLocationLevelName(PlayerCharacter:K2_GetActorLocation())
      end
      return ""
    else
      if not GameState:IsInDungeon() then
        return ""
      end
      local LevelShortName = UE4.URuntimeCommonFunctionLibrary.GetLevelLoadJsonName(PlayerCharacter)
      
      local function JsonLoads(ShortName)
        local ProPath = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
        local Path = ProPath .. "Script/Datas/Houdini_data/" .. ShortName .. ".json"
        local Info = UE4.URuntimeCommonFunctionLibrary.LoadFile(Path)
        local Json = require("rapidjson")
        local Res = Json.decode(Info)
        return Res
      end
      
      local LevelIds = PlayerCharacter.CurrentLevelId
      if not LevelIds then
        return ""
      end
      local LevelInfo = string.format("当前玩家进的拼接关卡: %s", LevelShortName)
      local LevelData = JsonLoads(LevelShortName)
      for _, point in pairs(LevelData.points) do
        for i = 1, LevelIds:Length() do
          local cur_id = LevelIds:Get(i)
          if tostring(point.id) == cur_id then
            local cur_artLevel = point.art_path
            if "" == cur_artLevel then
              cur_artLevel = string.gsub(point.struct, "Data_Design", "Data_Art", 1)
            end
            LevelInfo = LevelInfo .. string.format("，所在的美术关卡是: %s， 关卡id是： %s", cur_artLevel, cur_id)
          end
        end
      end
      return LevelInfo
    end
  end
  
  local SceneName = "Error"
  pcall(function()
    SceneName = GetPlayerSceneName()
  end)
  local SceneId = ""
  if WorldTravelSubsystem and WorldTravelSubsystem() then
    SceneId = tostring(WorldTravelSubsystem():GetCurrentSceneId())
  end
  local PlayerLocation = PlayerCharacter and tostring(PlayerCharacter:K2_GetActorLocation()) or " "
  local WrapErrorMsg = "Uid:" .. tostring(Avatar.Uid) .. "\n" .. "SceneId:" .. SceneId .. "\n" .. "SceneName:" .. tostring(SceneName) .. "\n" .. "PlayerLocation:" .. PlayerLocation .. "\n" .. ErrorMsg
  Avatar:ReportClientTrace(WrapErrorMsg)
  local EMSentrySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEMSentrySubsystem)
  if EMSentrySubsystem then
    EMSentrySubsystem:ReportLuaTrace(ErrorMsg, {
      SceneId = SceneId,
      SceneName = tostring(SceneName),
      Location = PlayerLocation
    })
  end
end

function BP_EMGameInstance_C:GetDeviceTypeByPlatformName()
  return CommonUtils:GetDeviceTypeByPlatformName()
end

function BP_EMGameInstance_C:SimulateMovementDebugPlatform()
  if Const.SimulateMovementDebugPlatform == "Android" or Const.SimulateMovementDebugPlatform == "Windows" or Const.SimulateMovementDebugPlatform == "IOS" or Const.SimulateMovementDebugPlatform == "Mac" then
    return Const.SimulateMovementDebugPlatform
  end
  local Plat = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  return Plat
end

function BP_EMGameInstance_C:DisableLuaMemoryMonitorFromCPP()
  LuaMemoryManager:DisableLuaMemoryMonitor()
end

function BP_EMGameInstance_C:RequestShowPopup(PopupId, Params, ParentWidget)
  if not self.RequestPopupQueue then
    self.RequestPopupQueue = {}
  end
  table.insert(self.RequestPopupQueue, {
    PopupId = PopupId,
    Params = Params,
    ParentWidget = ParentWidget
  })
  
  local function TryShowPopup()
    DebugPrint("Tianyi@ Try to show popup")
    if not self.RequestPopupQueue then
      self:RemoveTimer(self.RequestShowPopupTimer)
    end
    if self:CheckCanShowPopup() then
      DebugPrint("Tianyi@ TryShowPopup")
      self:RemoveTimer(self.RequestShowPopupTimer)
      local UIManager = GWorld.GameInstance:GetGameUIManager()
      for _, PopupRequest in ipairs(self.RequestPopupQueue) do
        UIManager:ShowCommonPopupUI(PopupRequest.PopupId, PopupRequest.Params, PopupRequest.ParentWidget)
      end
      self.RequestPopupQueue = nil
    end
  end
  
  if not self.RequestShowPopupTimer then
    self.RequestShowPopupTimer = self:AddTimer(0.2, TryShowPopup, true)
  end
end

function BP_EMGameInstance_C:CheckCanShowPopup()
  local LoadingUI = self:GetLoadingUI()
  if LoadingUI then
    return false
  end
  return true
end

function BP_EMGameInstance_C:OnTalkHiddenGameUIChange()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar:IsInBigWorld() then
    return
  end
  UE4.UKismetSystemLibrary.K2_SetTimerDelegate({
    self,
    function()
      local TalkContext = self:GetTalkContext()
      if not IsValid(TalkContext) or TalkContext:HasHiddenGameUI() then
        return
      end
      for _, Param in pairs(self.CacheShowRewardUIParams) do
        UIUtils.ShowDungeonRewardUI(table.unpack(Param))
      end
      self.CacheShowRewardUIParams = {}
    end
  }, 0.01, false, 0)
end

function BP_EMGameInstance_C:OnConditionComplete(ConditionId)
  if DataMgr.ConditionId2ModArchiveId and DataMgr.ConditionId2ModArchiveId[ConditionId] then
    for _, ModArchiveId in pairs(DataMgr.ConditionId2ModArchiveId[ConditionId]) do
      if ModArchiveId then
        local ModArchiveInfo = DataMgr.ModGuideBookArchive[ModArchiveId]
        if ModArchiveInfo then
          local NewNum = #ModArchiveInfo.ModList
          local ReddotNode = DataMgr.ModGuideBookArchiveTab[ModArchiveInfo.TabId].ReddotNode
          if not ReddotManager.GetTreeNode("ModArchive") then
            ReddotManager.AddNodeEx("ModArchive")
          end
          local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
          CacheDetail = CacheDetail or {}
          if not CacheDetail.NewNum then
            CacheDetail.NewNum = 0
          end
          if not CacheDetail.States then
            CacheDetail.States = {}
          end
          for i = 1, #ModArchiveInfo.ModList do
            local ModId = ModArchiveInfo.ModList[i]
            if not CacheDetail.States[ModId] then
              CacheDetail.States[ModId] = true
            else
              NewNum = NewNum - 1
            end
          end
          CacheDetail.NewNum = CacheDetail.NewNum + NewNum
          ReddotManager.IncreaseLeafNodeCount(ReddotNode, NewNum, CacheDetail)
        end
      end
    end
  end
end

function BP_EMGameInstance_C:CloseLoadingUI()
  UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Shadow.ForceCacheUpdate 1", nil)
  self.Overridden.CloseLoadingUI(self)
end

function BP_EMGameInstance_C:SpawnOtherRole(ObjId, RoleInfo, MoveInfo)
  local function LoadClassFinished(self, UnitBlueprint)
    local Avatar = GWorld:GetAvatar()
    
    if Avatar and Avatar.OtherRoleInfo[ObjId].BornState == Const.ShouldDetory then
      Avatar.OtherRoleInfo[ObjId] = nil
      return
    end
    local Location = FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z)
    local Rotation = FRotator(MoveInfo.Rotation.Pitch, MoveInfo.Rotation.Yaw, MoveInfo.Rotation.Roll):ToQuat()
    local SpawnTransform = FTransform(Rotation, Location)
    local CurrentCharacter = self:GetWorld():SpawnActor(UnitBlueprint, SpawnTransform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
    CurrentCharacter.FromOtherWorld = true
    if CurrentCharacter and CurrentCharacter:GetMovementComponent() and CurrentCharacter:GetMovementComponent().EnableSmoothStep then
      CurrentCharacter:GetMovementComponent().EnableSmoothStep = false
    end
    local Info = {}
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    Info.RoleId = RoleInfo.CharId
    Info.SkinId = RoleInfo.SkinId
    Info.FromOtherWorld = true
    Info.AppearanceSuit = RoleInfo.AppearanceSuit
    Info.RegionWeaponInfo = RoleInfo.RegionWeaponInfo
    Info.ShowWeapon = RoleInfo.ShowWeapon
    if self.RandomClientRegionPlayerRoleId then
      local AllRoleId = {
        1101,
        1103,
        1501,
        1502,
        1801,
        2101,
        2301,
        3101,
        3103,
        3201,
        3301,
        4101,
        4202,
        4301,
        5101,
        5102,
        5301,
        5401
      }
      local RandomRoleId = AllRoleId[math.random(1, #AllRoleId)]
      Info.RoleId = RandomRoleId
      Info.SkinId = RandomRoleId
      Info.AppearanceSuit.SkinId = RandomRoleId
      RoleInfo.CharId = RandomRoleId
      RoleInfo.SkinId = RandomRoleId
      RoleInfo.AppearanceSuit.SkinId = RandomRoleId
    end
    
    local function CharacterRead(Character)
      print(_G.LogTag, "CharacterRead", Character:K2_GetActorLocation(), Character:K2_GetActorRotation())
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        if Avatar.OtherRoleInfo[ObjId].BornState == Const.ShouldDetory and Character then
          Character:K2_DestroyActor()
          Avatar.OtherRoleInfo[ObjId] = nil
          return
        end
        Avatar.OtherRoleInfo[ObjId].BornState = Const.Bonred
        Avatar.OtherRoleInfo[ObjId].CharEid = Character.Eid
      end
      Character:AddInteractiveComponent()
      if Character.RegionInterComp then
        Character.RegionInterComp:InitRegionInfo(Character.Eid, ObjId)
      end
      if Character.RegionInterAddFriendComp then
        Character.RegionInterAddFriendComp:InitRegionInfo(Character.Eid, ObjId)
      end
      if Character.RegionInterInviteTeamComp then
        Character.RegionInterInviteTeamComp:InitRegionInfo(Character.Eid, ObjId)
      end
      if Character.RegionInterPersonInfoComp then
        Character.RegionInterPersonInfoComp:InitRegionInfo(Character.Eid, ObjId)
      end
      EventManager:FireEvent(EventID.OnlineAddOtherPlayer, CurrentCharacter.Eid, RoleInfo.Uid, Character, ObjId)
    end
    
    Info.LoadFinishCallback = CharacterRead
    CurrentCharacter:InitCharacterInfoForRegionPlayer(Info)
    EventManager:FireEvent(EventID.AddRegionIndicatorInfo, CurrentCharacter.Eid, RoleInfo.Uid, CurrentCharacter:K2_GetActorLocation(), ObjId)
    CurrentCharacter:RegisterOtherWorldPlayerCharacterToSubSystem()
  end
  
  if not self.bRegionClientOnlyShowUI then
    local Path = "/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C"
    UE4.UResourceLibrary.LoadClassAsync(self, Path, {self, LoadClassFinished})
  else
    local Eid = self:AddPlayerHeadUI(FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z))
    local Avatar = GWorld:GetAvatar()
    if Eid > 0 and Avatar then
      Avatar.OtherRoleInfo[ObjId].BornState = Const.Bonred
      Avatar.OtherRoleInfo[ObjId].CharEid = Eid
      EventManager:FireEvent(EventID.AddRegionIndicatorInfo, Eid, RoleInfo.Uid, FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z), ObjId)
      EventManager:FireEvent(EventID.OnlineAddOtherPlayer, Eid, RoleInfo.Uid, nil, ObjId)
    end
  end
end

function BP_EMGameInstance_C:HeadUIReady(ObjIdStr, Eid, Location)
  local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
  if not RegionSyncSubsys then
    print(_G.LogTag, "RegionPlayerInitInfo RegionSyncSubsys is nil")
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar is nil")
    return
  end
  if not Avatar.OtherRoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo Avatar.TempRoleInfo is nil")
    return
  end
  if not CommonUtils.IsObjIdStr(ObjIdStr) then
    print(_G.LogTag, "RegionPlayerInitInfo ObjId is  not a Legal ObjIdStr")
    return
  end
  local LuaObjId = CommonUtils.Str2ObjId(ObjIdStr)
  local RoleInfo = Avatar.OtherRoleInfo[LuaObjId]
  if not RoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
    return
  end
  RoleInfo.BornState = Const.Bonred
  RoleInfo.CharEid = Eid
  EventManager:FireEvent(EventID.AddRegionIndicatorInfo, Eid, RoleInfo.Uid, Location, LuaObjId)
  EventManager:FireEvent(EventID.OnlineAddOtherPlayer, Eid, RoleInfo.Uid, nil, LuaObjId)
end

function BP_EMGameInstance_C:CreatePlayerCharacterWhileOnlyShowUI(Eid, Transform)
  local Avatar = GWorld:GetAvatar()
  if Eid <= 0 or not Avatar then
    return
  end
  local RoleInfo = {}
  local Info = {}
  local ObjId
  for Id, _Info in pairs(Avatar.OtherRoleInfo or {}) do
    if _Info.CharEid == Eid then
      ObjId = Id
      RoleInfo = _Info
      break
    end
  end
  if not ObjId then
    return
  end
  local Path = "/Game/BluePrints/Char/BP_PlayerCharacter.BP_PlayerCharacter_C"
  local CurrentCharacter = self:GetWorld():SpawnActor(LoadClass(Path), Transform, UE4.ESpawnActorCollisionHandlingMethod.AlwaysSpawn)
  if not CurrentCharacter then
    return
  end
  CurrentCharacter.FromOtherWorld = true
  local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(self)
  if RegionSyncSubsys then
    RegionSyncSubsys:RegisterBornCharWhileOnlyCreateHeadUI(CommonUtils.ObjId2Str(ObjId), CurrentCharacter)
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.OtherRoleInfo then
    return
  end
  local RoleInfo = Avatar.OtherRoleInfo[ObjId]
  if not RoleInfo then
    print(_G.LogTag, "RegionPlayerInitInfo RoleInfo is nil")
    return
  end
  CurrentCharacter.CacheInfo = RoleInfo
  if RoleInfo.AppearanceSuit then
    CurrentCharacter.CurrentSkinId = RoleInfo.AppearanceSuit.SkinId
  else
    CurrentCharacter.CurrentSkinId = RoleInfo.SkinId
  end
  CurrentCharacter.ShadowModelId = RoleInfo.ShadowModelId or 0
  RoleInfo.Eid = Eid
  CurrentCharacter:PreInitInfo(RoleInfo)
  CurrentCharacter:RegionPlayerPendingInit()
  CurrentCharacter:AddInteractiveComponent()
  RoleInfo.CharEid = CurrentCharacter.Eid
  if CurrentCharacter.RegionInterComp then
    CurrentCharacter.RegionInterComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
  end
  if CurrentCharacter.RegionInterAddFriendComp then
    CurrentCharacter.RegionInterAddFriendComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
  end
  if CurrentCharacter.RegionInterInviteTeamComp then
    CurrentCharacter.RegionInterInviteTeamComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
  end
  if CurrentCharacter.RegionInterPersonInfoComp then
    CurrentCharacter.RegionInterPersonInfoComp:InitRegionInfo(CurrentCharacter.Eid, ObjId)
  end
  EventManager:FireEvent(EventID.AddRegionIndicatorInfo, CurrentCharacter.Eid, RoleInfo.Uid, CurrentCharacter:K2_GetActorLocation(), ObjId)
  CurrentCharacter:RegisterOtherWorldPlayerCharacterToSubSystem()
  if RoleInfo.IsCrouching then
    CurrentCharacter:SetCrouch(true)
  else
    CurrentCharacter:SetCrouch(false)
  end
end

function BP_EMGameInstance_C:TeleportToCloestTeleportPoint()
  DebugPrint("============TeleportToCloestTeleportPoint==============", self.TriggerBoxID)
  CommonUtils:TeleportToCloestTeleportPoint(self.TriggerBoxID)
  self.TriggerBoxID = nil
  EventManager:RemoveEvent(EventID.CloseLoading, GWorld.GameInstance)
  EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainEnd, GWorld.GameInstance)
end

function BP_EMGameInstance_C:GetIsOpenCrashSight()
  return EMCache:Get("IsOpenCrashSight")
end

function BP_EMGameInstance_C:IsInSquadDungeon()
  local DungeonId = self:GetCurrentDungeonId()
  local DungeonData = DataMgr.Dungeon[DungeonId]
  if DungeonData then
    local Avatar = GWorld:GetAvatar()
    local DungeonInfo = Avatar.Dungeons[DungeonId]
    if DungeonInfo then
      DebugPrint("gmy@BP_EMGameInstance_C BP_EMGameInstance_C:IsInSquadDungeon", DungeonData.Squad, DungeonInfo.Squad)
      return DungeonData.Squad and 0 ~= DungeonInfo.Squad
    end
  end
  return false
end

function BP_EMGameInstance_C:SendInputDiviceChangeMessage(CurInputDeviceType, CurInputDeviceName)
  DebugPrint("yklua___@BP_EMGameInstance_C BP_EMGameInstance_C:SendInputDiviceChangeMessage", CurInputDeviceType, CurInputDeviceName)
  local DeviceTypeMap = {
    [ECommonInputType.MouseAndKeyboard] = "MouseAndKeyboard",
    [ECommonInputType.Gamepad] = "Gamepad",
    [ECommonInputType.Touch] = "Touch",
    [ECommonInputType.Count] = "Count"
  }
  local NewTrack = {
    device_type = DeviceTypeMap[CurInputDeviceType] or "未知设备类型"
  }
  if not DeviceTypeMap[CurInputDeviceType] then
    DebugPrint("yklua 切换设备时无法识别输入设备类型")
  end
  HeroUSDKSubsystem(self):UploadTrackLog_Lua("input_device_change", NewTrack)
end

function BP_EMGameInstance_C:VerifyArraySendTrace(CRC, NewCRC)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self.MemChangeWarning then
    self.MemChangeWarning = true
    local CheatLog = "CRC memory modification"
    Avatar:CallServerMethod("ReportSentimentSDKCheat", CheatLog, 1, 1, {})
    return
  end
end

function BP_EMGameInstance_C:InitFloatVerifyArray()
  local Avatar = GWorld:GetAvatar()
  local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
  if AvatarInfo and AvatarInfo.RoleInfo and AvatarInfo.RoleInfo.ReplaceAttrs and AvatarInfo.RoleInfo.ReplaceAttrs.TotalValues then
    local TotalValues = AvatarInfo.RoleInfo.ReplaceAttrs.TotalValues
    self.FloatVerifyArray:Add(TotalValues.DEF)
    self.FloatVerifyArray:Add(TotalValues.MaxHp)
    self.FloatVerifyArray:Add(TotalValues.SPD)
    self.FloatVerifyArray:Add(TotalValues.MaxES)
    self.FloatVerifyArray:Add(TotalValues.MaxSp)
    self.FloatVerifyArray:Add(TotalValues.SkillEfficiency)
    self.FloatVerifyArray:Add(TotalValues.SkillIntensity)
    self.FloatVerifyArray:Add(TotalValues.SkillSustain)
    self.FloatVerifyArray:Add(TotalValues.SkillRange)
  end
end

function BP_EMGameInstance_C:UpdatePostProcessMaterial()
  if IsDedicatedServer(self) then
    return
  end
  local WorldSettings = URuntimeCommonFunctionLibrary.GetWorldSettsings(self)
  local NeedClose = WorldSettings and WorldSettings.bClosePostProcessMaterial
  if NeedClose then
    local PlatformName = UGameplayStatics.GetPlatformName()
    local IsPhone = self:GetUseMapPhoneInPC() or "IOS" == PlatformName or "Android" == PlatformName
    local IsLowScalabilityLevel = self:GetGameplayScalabilityLevel() <= 1
    local IsLowMemoryDevice = self:IsLowMemoryDevice()
    if IsPhone and (IsLowScalabilityLevel or IsLowMemoryDevice) then
      UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 0")
    else
      UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 1")
    end
  else
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.Mobile.PostProcessMaterial 1")
  end
end

function BP_EMGameInstance_C:SetDynamicResolution(Tag, bEnable)
  if not Const.bUseDynamicResolution then
    return
  end
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "PC" == PlatformName then
    return
  end
  if UEMGameInstance.IsLowMemoryDevice() then
    return
  end
  if not rawget(self, "DynamicResolution") then
    if "Android" == PlatformName then
      rawset(self, "DynamicResolution", {
        [1] = {
          100,
          80,
          720
        },
        [2] = {
          110,
          90,
          750
        },
        [3] = {
          150,
          100,
          810
        },
        [4] = {
          150,
          100,
          900
        },
        [5] = {
          150,
          100,
          1260
        }
      })
    elseif "IOS" == PlatformName then
      rawset(self, "DynamicResolution", {
        [1] = {
          75,
          75,
          0
        },
        [2] = {
          80,
          80,
          0
        },
        [3] = {
          85,
          85,
          0
        },
        [4] = {
          90,
          90,
          0
        },
        [5] = {
          105,
          105,
          0
        }
      })
    else
      return
    end
  end
  if not rawget(self, "DynamicResolutionTags") then
    rawset(self, "DynamicResolutionTags", {})
  end
  self.DynamicResolutionTags[Tag] = bEnable and true or nil
  if 0 ~= CommonUtils.TableLength(self.DynamicResolutionTags) then
    local CacheName = "MobileResolution"
    local OptionIndex = EMCache:Get(CacheName)
    if nil == OptionIndex then
      local OptionInfo = DataMgr.Option[CacheName]
      OptionIndex = tonumber(OptionInfo.DefaultValue)
    end
    local ResolutionInfo = self.DynamicResolution[OptionIndex]
    if not ResolutionInfo then
      OptionIndex = 5
    end
    ResolutionInfo = self.DynamicResolution[OptionIndex]
    GWorld.GameInstance.SetScreenPercentageLevel(ResolutionInfo[1], ResolutionInfo[2], ResolutionInfo[3])
  else
    SettingUtils.ResetMobileResolution()
  end
end

return BP_EMGameInstance_C
