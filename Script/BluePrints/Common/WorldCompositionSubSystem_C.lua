require("Unlua")
local M = Class("BluePrints.Common.TimerMgr")
local SettingUtils = require("Utils.SettingUtils")
local GameFlowUtils = require("Utils.GameFlowUtils")

function M:OnAsyncTravelBegin_Lua(Player)
  if not self.TravelRequests then
    self.TravelRequests = {}
  end
  local Controller = Player
  local MovementComponent = Player:GetMovementComponent()
  local OriginalMovementMode = MovementComponent.MovementMode
  local ParamsTable = {OriginalMovementMode}
  self.TravelRequests[Controller] = ParamsTable
  MovementComponent:SetMovementMode(UE4.EMovementMode.Move_None)
  Player:AddDisableInputTag("WCAsyncTravel")
  Player:ResetIdle()
  UGameplayStatics.GetPlayerController(self, 0):SetViewTargetWithBlend(Player)
  local LevelLoader = UE4.UGameplayStatics.GetActorOfClass(self, UE4.ALevelLoader:StaticClass())
  if LevelLoader then
    LevelLoader:SetForceGCAfterLevelStreamedOut(true)
  end
end

function M:AddOnAsyncTravelEnded(Obj, Func)
  if not self.Callbacks then
    self.Callbacks = {}
  end
  self.Callbacks[Obj] = Func
end

function M:OnPlayerLanded_Lua()
  if self.Callbacks then
    for Obj, Func in pairs(self.Callbacks) do
      Func(Obj)
    end
    self.Callbacks = {}
  end
end

function M:OnAsyncTravelEnded_Lua(Player)
  local Controller = Player
  local MovementComponent = Player:GetMovementComponent()
  if not self.TravelRequests or not self.TravelRequests[Controller] then
    return
  end
  local OriginalMovementMode = self.TravelRequests[Controller][1]
  local Movement = Player:GetMovementComponent()
  if 5 == OriginalMovementMode then
    OriginalMovementMode = Movement.DefaultLandMovementMode
  end
  self.TravelRequests[Controller] = nil
  MovementComponent:SetMovementMode(Movement.DefaultLandMovementMode)
  self:AddTimer(2, function()
    Player:RemoveDisableInputTag("WCAsyncTravel")
  end)
  Player:AddMovementInput(Player:GetActorForwardVector() * 0.001)
  local LevelLoader = UE4.UGameplayStatics.GetActorOfClass(self, UE4.ALevelLoader:StaticClass())
  if LevelLoader then
    LevelLoader:SetForceGCAfterLevelStreamedOut(false)
  end
end

function M:ShowRegionError_Lua(Text, NeedDebugTrace, SendToQaWeb, ErrorType, ErrorTitle, IsFromCPP)
  local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
  local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
  if bDistribution and not bEnableShippingLog then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Space = "=========================================================\n"
  local ct = {
    Space,
    "报错文本:\n\r",
    tostring(Text),
    "\n"
  }
  if NeedDebugTrace then
    table.insert(ct, Space)
    table.insert(ct, [[
Traceback:
	]])
    table.insert(ct, debug.traceback())
    table.insert(ct, "\n")
    table.insert(ct, Space)
    table.insert(ct, UBattleFunctionLibrary.GetTraceStack(50))
  end
  local FinalMsg = table.concat(ct)
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    ScreenPrint("区域报错:\n" .. FinalMsg)
  end
  Avatar:SendToFeiShuForRegionMgr(FinalMsg, "区域报错 | " .. Avatar.CurrentRegionId)
  if SendToQaWeb then
    if IsFromCPP then
      ErrorType = Const.RegionErrorType[ErrorType]
      ErrorTitle = Const.RegionErrorTitle[ErrorTitle]
    end
    local TraceType = {
      first = GText("区域报错"),
      second = ErrorType,
      third = ErrorTitle
    }
    local DescribeInfo = {
      title = GText("详细信息"),
      trace_content = FinalMsg
    }
    Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
  end
end

function M:OnWaitForDataIdle_Lua()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:TryRestartQuestChains()
end

function M:Initialize_Lua()
  EventManager:AddEvent(EventID.StartTalk, self, self.OnStartTalk)
  EventManager:AddEvent(EventID.EndTalk, self, self.OnEndTalk)
  self.AsyncTravelUseGameFlow = true
  if UE4.UUIFunctionLibrary.GetDevicePlatformName(self) == "OpenHarmony" then
    print("Initialize_Lua")
    UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "r.HZBOcclusion 0")
  end
end

function M:Deinitialize_Lua()
  EventManager:RemoveEvent(EventID.StartTalk, self)
  EventManager:RemoveEvent(EventID.EndTalk, self)
end

function M:OnStartTalk()
  DebugPrint("WorldCompositionSubSystem", "OnStartTalk")
  self.BOpenRegionDataTickLog = false
end

function M:OnEndTalk()
  DebugPrint("WorldCompositionSubSystem", "OnEndTalk")
  self.BOpenRegionDataTickLog = true
end

function M:RemoveFlow()
  if not self.AsyncTravelUseGameFlow then
    return
  end
  DebugPrint("WC RemoveFlow", self.FlowId)
  if self.FlowId and self.FlowId >= 0 then
    GameFlowUtils:RemoveFlow(self.FlowId)
  end
end

function M:GetRealStreamingDistanceRatio(ScalabilityLevel, Platform)
  local Ratio = 1
  if "Android" == Platform or "OpenHarmony" == Platform then
    Ratio = Const.AndroidRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
  elseif "IOS" == Platform then
    Ratio = Const.IOSRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
  else
    Ratio = Const.PCRealStreamingDistanceRatio[ScalabilityLevel] or Ratio
  end
  return Ratio
end

function M:GetIsWCDungeonUnloadSmall()
  return Const.WCDungeonUnloadSmall
end

function M:GetWCDungeonDistanceRatio()
  return Const.WCDungeonDistanceRatio
end

function M:GetWCDungeonLevelProxyDistanceRatio()
  return Const.WCDungeonLevelProxyDistanceRatio
end

function M:GetFoliageQualityEMCache()
  local OptionName = "PlantEnhance"
  local OptionInfo = DataMgr.Option[OptionName]
  if not OptionInfo then
    DebugPrint("Error GetFoliageQualityEMCache OptionInfo is nil")
    return 2
  end
  local PlatformName = UGameplayStatics.GetPlatformName()
  local GameInstance = GWorld.GameInstance
  local IsPhone = "IOS" == PlatformName or "Android" == PlatformName or "OpenHarmony" == PlatformName or GameInstance and GameInstance:GetUseMapPhoneInPC()
  local DefaultValue = 0
  if IsPhone then
    DefaultValue = OptionInfo.DefaultValueM
  else
    DefaultValue = OptionInfo.DefaultValue
  end
  local CacheValue = SettingUtils.GetEMCache(OptionInfo.EMCacheName, OptionInfo.EMCacheKey, DefaultValue - 1)
  DebugPrint("GetFoliageQualityEMCache", CacheValue, "DefaultValue", DefaultValue - 1)
  return CacheValue
end

function M:IsFoliageLevelContain(TableFoliageLevel, IsPhone, PackageName)
  local FoliageStrTable = {}
  if IsPhone then
    FoliageStrTable = Const.NewFoliageRulePhone[TableFoliageLevel]
  else
    FoliageStrTable = Const.NewFoliageRulePC[TableFoliageLevel]
  end
  for _, v in pairs(FoliageStrTable) do
    if string.find(PackageName, v) then
      return true
    end
  end
  return false
end

function M:IsNewFoliageRuleMap(PackageName)
  for _, v in pairs(Const.OldFoliageRuleMap) do
    if string.find(PackageName, v) then
      return false
    end
  end
  return true
end

function M:DestroyAllRegionDataAndEnterDungeon(DungeonId)
  if not DungeonId or not DataMgr.Dungeon[DungeonId] then
    return
  end
  local Data = DataMgr.Dungeon[DungeonId]
  self:PauseAndAsyncDestroyRegionData({
    self,
    function()
      local EidKeys = Battle(self):GetAllEntities():Keys()
      for _, Eid in pairs(EidKeys) do
        local Ent = Battle(self):GetEntity(Eid)
        if Ent and not Ent.BpBorn then
          if Ent.EMActorDestroy and (not Ent.IsPlayer or not Ent:IsPlayer()) then
            Ent:EMActorDestroy(EDestroyReason.LevelUnloadedSaveGame)
          elseif not Ent.IsPlayer or not Ent:IsPlayer() then
            Ent:Destroy()
          end
        end
      end
      self:ClearAllRegionData()
      self:UnloadDesignLevel(true)
      self:RefreshDungeonId()
      self:RespawnGameMode(true, DungeonId)
      self:LoadDesignLevel(true, DungeonId)
      self:AddTimer(0.5, function()
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        GameMode:SetGameModeState(EGameModeState.EPrepare)
        GameMode:GetLevelLoader():LevelLoaderReady()
        GameMode:TryTriggerOnPrepare("BattleInit")
        GameMode:TryTriggerOnPrepare("GameModeBeginPlay")
        local Controller = UGameplayStatics.GetPlayerController(self, 0)
        local AvatarEidStr = Controller.AvatarEidStr
        if GameMode.LevelLoader and not GameMode.AlreadyInit then
          GameMode.LevelLoader:SetInitTrans(Controller)
        end
        GameMode:OnCharacterReady(AvatarEidStr, self)
        GameMode:TryTriggerOnInit(AvatarEidStr)
        local GameState = UGameplayStatics.GetGameState(self)
        GameState.EndLoadingSuccess = false
        GameState:TryEndLoading("PlayerReady")
      end)
    end
  })
end

return M
