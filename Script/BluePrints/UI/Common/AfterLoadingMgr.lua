local FSM = require("BluePrints.UI.ControllerFSM")
local EMCache = require("EMCache.EMCache")
local MiscUtils = require("Utils.MiscUtils")
local StorylineUtils = require("StoryCreator.StoryLogic.StorylineUtils")
local FIRST_OPEN_LAYOUT_PLAN_03_KEY = "FirstOpenLayoutPlan03"
local LAYOUT_PLAN_QUEST_CHAIN_ID = 100201
local LAYOUT_PLAN_QUEST_ID = 10020101

local function IsBattleMainInVisible()
  local Player = GWorld:GetMainPlayer()
  if Player and Player.IsImmersionModel then
    return false
  end
  local BattleMain = UIManager():GetUIObj("BattleMain")
  return not IsValid(BattleMain) or BattleMain.IsPlayOutAnim or not BattleMain:IsVisible()
end

local function ShouldHoldForLayoutPlanQuestProgress()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not UIUtils.IsMobileInput() then
    return false
  end
  if EMCache:Get(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true) then
    return false
  end
  local TrackingQuestChainId = Avatar.TrackingQuestChainId
  if not TrackingQuestChainId or 0 == TrackingQuestChainId then
    return false
  end
  if TrackingQuestChainId < LAYOUT_PLAN_QUEST_CHAIN_ID then
    return true
  end
  if TrackingQuestChainId > LAYOUT_PLAN_QUEST_CHAIN_ID then
    return false
  end
  local QuestChain = Avatar.QuestChains and Avatar.QuestChains[LAYOUT_PLAN_QUEST_CHAIN_ID]
  if not QuestChain then
    return true
  end
  local DoingQuestId = QuestChain.DoingQuestId or 0
  return DoingQuestId < LAYOUT_PLAN_QUEST_ID
end

local function GetNextStateWaitGuideOrBattleMain(self, AfterLoadingMgr)
  if ShouldHoldForLayoutPlanQuestProgress() then
    return self.StateName
  end
  if AfterLoadingMgr.bGuideEndPending then
    AfterLoadingMgr.bGuideEndPending = nil
    if IsBattleMainInVisible() then
      return self.StateName
    else
      return DataMgr.AfterLoadingFSM[self.StateName].NextState
    end
  end
  if StorylineUtils:IsGuideNodeRunning() or IsBattleMainInVisible() then
    return self.StateName
  else
    return DataMgr.AfterLoadingFSM[self.StateName].NextState
  end
end

local function IsOldLayoutUser(Avatar, PlanIndex)
  if not Avatar or not PlanIndex then
    return false
  end
  local LayoutEntryIndex = Avatar.GetLayoutEntryIndexByPlanIndex and Avatar:GetLayoutEntryIndexByPlanIndex(PlanIndex) or PlanIndex
  return 1 == LayoutEntryIndex or 2 == LayoutEntryIndex
end

local State = {
  __index = {
    GetNextState = function(self)
      return DataMgr.AfterLoadingFSM[self.StateName].NextState
    end,
    OnAfterEnter = function(AfterLoadingMgr, NowState)
      AfterLoadingMgr:Fallback(NowState)
    end
  },
  New = function(Class, StateName, FuncTable)
    local NewObj = {}
    setmetatable(NewObj, Class)
    
    function NewObj.OnEnter(AfterLoadingMgr)
      try({
        exec = FuncTable.OnEnter,
        catch = function(err)
          DebugPrint(ErrorTag, string.format("AfterLoading有流程出错了,出错状态：%s, 请根据日志报错的行去找人", AfterLoadingMgr.FSM:Current()))
          LogError(Traceback(ErrorTag, err, true))
          UIManager():DestroyAfterLoadingMgr()
        end
      }, AfterLoadingMgr)
    end
    
    NewObj.StateName = StateName
    if FuncTable.OnAfterEnter then
      NewObj.OnAfterEnter = FuncTable.OnAfterEnter
    end
    if FuncTable.OnLeave then
      NewObj.OnLeave = FuncTable.OnLeave
    end
    if FuncTable.GetNextState then
      NewObj.GetNextState = FuncTable.GetNextState
    end
    return NewObj
  end
}
local StateImpl = Class("BluePrints.Common.TimerMgr")
StateImpl.BeginState = State:New("BeginState", {
  OnEnter = function(AfterLoadingMgr)
    GWorld.NetworkMgr:UpdateNetDisconnectUIConfirm()
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
    if IsValid(GameInputSubsystem) then
      GameInputSubsystem:DisableInputMode("CommonChangeScene")
    end
    GWorld.StoryMgr:EnableStory()
    local PlayerCharacter = GWorld:GetMainPlayer()
    if PlayerCharacter then
      PlayerCharacter:SetCanInteractiveTrigger(true, "Loading")
    end
  end,
  GetNextState = function(self)
    return DataMgr.AfterLoadingFSM[self.StateName].NextState
  end
})
StateImpl.JumpToRogueMain = State:New("JumpToRogueMain", {
  OnEnter = function(AfterLoadingMgr)
    local PlayerCharacter = GWorld:GetMainPlayer()
    local CurDungeonType = WorldTravelSubsystem():GetCurrentDungeonType()
    if CurDungeonType == CommonConst.DungeonType.Abyss and PlayerCharacter then
      PlayerCharacter:DisableBattleWheel()
    end
    local GameState = GameState()
    if GameState and GameState.IsInRegion and GameState:IsInRegion() then
      local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData()
      if ExitDungeonInfo then
        local BattleView = UIManager():GetUIObj("BattleMain")
        if BattleView then
          BattleView:Hide("Temp1.4Fix")
        end
        local Time = 0
        if UGameplayStatics.GetPlatformName() == "IOS" then
          Time = 0.1
        end
        GWorld.GameInstance:AddTimer(Time, function()
          GWorld.GameInstance:ClearExitDungeonData()
          if ExitDungeonInfo.Type == "Abyss" then
            local AbyssId = ExitDungeonInfo.AbyssId
            local AbyssLevelId = ExitDungeonInfo.AbyssLevelId
            local AbyssDungeonIndex = ExitDungeonInfo.AbyssDungeonIndex
            PageJumpUtils:JumpToAbyssLevelInfoPage(AbyssId, AbyssLevelId, AbyssDungeonIndex)
          elseif ExitDungeonInfo.Type == "Rouge" then
            PageJumpUtils:JumpToRougeMain("ExitFromRouge", true)
          elseif ExitDungeonInfo.Type == "TryOut" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            local CurSelectIndex = ExitDungeonInfo.CurSelectIndex
            local ActivityId = ExitDungeonInfo.ActivityId
            PageJumpUtils:JumpToTryOut(CurTabIndex, ActivityId, CurSelectIndex)
          elseif ExitDungeonInfo.Type == "Paotai" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            local CurSelectIndex = ExitDungeonInfo.CurSelectIndex
            PageJumpUtils:JumpToPaotai(CurTabIndex, CurSelectIndex)
          elseif ExitDungeonInfo.Type == "FeinaEvent" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            PageJumpUtils:JumpToFeinaEvent(CurTabIndex)
          elseif ExitDungeonInfo.Type == "Depute" then
            if not ExitDungeonInfo.IsFromRegionMechanism then
              local DeputeType = ExitDungeonInfo.DeputeType
              PageJumpUtils:JumpToStyleOfPlaySubUI("NewDeputeRoot", true, DeputeType)
            end
          elseif ExitDungeonInfo.Type == "GuildWar" then
            local JumpId = ExitDungeonInfo.JumpId
            PageJumpUtils:JumpToTargetPageByJumpId(JumpId, false, false, true)
          elseif ExitDungeonInfo.Type == "Temple" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            PageJumpUtils:JumpToTempleSolo(CurTabIndex)
          elseif ExitDungeonInfo.Type == "MonsterRush" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            local EventId = ExitDungeonInfo.EventId
            local DungeonId = ExitDungeonInfo.DungeonId
            PageJumpUtils:JumpToMonsterRush(CurTabIndex, EventId, DungeonId)
          elseif ExitDungeonInfo.Type == "AutoChess" then
            PageJumpUtils:JumpToAutoChessMain()
          elseif ExitDungeonInfo.Type == "SoloTreasure" then
            if 1 == ExitDungeonInfo.Mode then
              local Mode = ExitDungeonInfo.Mode
              local bIsDifficulty = ExitDungeonInfo.bIsDifficulty
              local EventDungeonId = ExitDungeonInfo.EventDungeonId
              if ExitDungeonInfo.IsPermanent then
                PageJumpUtils:SoloTreasurePermanentRepeatLevel(Mode, bIsDifficulty, EventDungeonId)
              else
                local EventId = ExitDungeonInfo.EventId
                PageJumpUtils:SoloTreasureRepeatLevel(EventId, Mode, bIsDifficulty, EventDungeonId)
              end
            end
          elseif ExitDungeonInfo.Type == "AsyncCombat" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            PageJumpUtils:JumpToAsyncCombatRoomPage(CurTabIndex)
          elseif ExitDungeonInfo.Type == "GuildBoss" then
            if not ExitDungeonInfo.IsFromRegionMechanism then
              local SubRegionId = ExitDungeonInfo.SubRegionId
              local TeleportPoint = ExitDungeonInfo.TeleportPoint or 1
              if SubRegionId then
                local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
                if IsValid(GameMode) then
                  GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, SubRegionId, TeleportPoint, nil, nil, true)
                end
              end
            end
          elseif ExitDungeonInfo.Type == "WeaponVerify" then
            local CurTabIndex = ExitDungeonInfo.CurTabIndex
            local CurSelectIndex = ExitDungeonInfo.CurSelectIndex
            PageJumpUtils:JumpToWeaponVerify(CurTabIndex, CurSelectIndex)
          end
          local Time = 0
          if UGameplayStatics.GetPlatformName() == "IOS" then
            Time = 0.5
          end
          GWorld.GameInstance:AddTimer(Time, function()
            local BattleView = UIManager():GetUIObj("BattleMain")
            if BattleView then
              BattleView:Show("Temp1.4Fix")
            end
          end)
        end)
      end
    end
  end
})
StateImpl.GameplayReward = State:New("GameplayReward", {
  OnEnter = function(AfterLoadingMgr)
  end
})
StateImpl.DungeonUI = State:New("DungeonUI", {
  OnEnter = function(AfterLoadingMgr)
  end
})
StateImpl.SystemUnlock = State:New("SystemUnlock", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:HandleCloseLoadingEvent_WhileSystemUnlock()
    end
  end
})
StateImpl.Entertainment = State:New("Entertainment", {
  OnEnter = function(AfterLoadingMgr)
    local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
    if SojournsGameInstanceSubsystem then
      SojournsGameInstanceSubsystem:OnEnterOtherRegion()
    end
  end,
  GetNextState = function(self, AfterLoadingMgr)
    local NextStateName = DataMgr.AfterLoadingFSM[self.StateName].NextState
    local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, USojournsGameInstanceSubsystem)
    if not SojournsGameInstanceSubsystem then
      return NextStateName
    end
    if SojournsGameInstanceSubsystem:IsNeedBlockAfterLoading() then
      return self.StateName
    end
    return NextStateName
  end
})
StateImpl.CutSceneReview = State:New("CutSceneReview", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    if Avatar:IsCutSceneReviewRunning() then
      Avatar:RunCutSceneReviewStoryline()
    elseif Avatar:IsCutSceneReviewStopping() then
      Avatar:ExitCutSceneReview()
    end
  end,
  GetNextState = function(self, AfterLoadingMgr)
    local NextStateName = DataMgr.AfterLoadingFSM[self.StateName].NextState
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return NextStateName
    end
    if not Avatar:IsInCutSceneReview() then
      return NextStateName
    end
    return self.StateName
  end
})
StateImpl.TriggerGuide = State:New("TriggerGuide", {
  OnEnter = function(AfterLoadingMgr)
    local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
    local GameMode = MiscUtils.GameMode()
    if not GWorld.GameInstance:IsNullDungeonId(DungeonId) then
      DebugPrint("SystemGuide Enter Dungeon")
      EventManager:FireEvent(EventID.ExitRegion)
      EventManager:FireEvent(EventID.SystemGuideEnterDungeon, DungeonId)
    elseif nil ~= GameMode and GameMode.IsInRegion and GameMode:IsInRegion() then
      local CurMode = UE4.URuntimeCommonFunctionLibrary.GetInputMode(GWorld.GameInstance:GetWorld())
      DebugPrint("SystemGuide Enter Region", CurMode)
      EventManager:FireEvent(EventID.SystemGuideEnterRegion)
    else
      DebugPrint("ERROR:SystemGuide Not Enter Region And Not Enter Dungeon")
    end
  end,
  GetNextState = function(self, AfterLoadingMgr)
    if AfterLoadingMgr.bGuideEndPending then
      AfterLoadingMgr.bGuideEndPending = nil
      if IsBattleMainInVisible() then
        return self.StateName
      else
        return DataMgr.AfterLoadingFSM[self.StateName].NextState
      end
    end
    if StorylineUtils:IsGuideNodeRunning() or IsBattleMainInVisible() then
      return self.StateName
    else
      return DataMgr.AfterLoadingFSM[self.StateName].NextState
    end
  end
})
StateImpl.BackToTrial = State:New("BackToTrial", {
  OnEnter = function(AfterLoadingMgr)
    local GameMode = MiscUtils.GameMode()
    local GameState = GameState()
    if nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Trial" then
      AfterLoadingMgr:Pause()
      UIManager():AddTimer(0.1, function()
        UIManager():LoadUINew("TryOutMain")
      end, false, 0, nil, true)
      return
    end
  end
})
StateImpl.ReturnActivity = State:New("ReturnActivity", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if Avatar and ReturnActivityController and ReturnActivityController.DisplayReturnWelcomBannerCache then
      ReturnActivityController.DisplayReturnWelcomBannerCache = nil
      local ReturnUtils = require("Blueprints.UI.WBP.Activity.Widget.Return.ReturnUtils")
      if ReturnUtils and nil ~= ReturnUtils.GetCurrentEventSchemeId() then
        ReturnActivityController:TryDisplayReturnWelcomBanner()
      end
    end
  end
})
StateImpl.Advertisement = State:New("Advertisement", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local LoginPopUpModel = require("BluePrints.UI.WBP.Activity.Widget.AdvertisingPopUp.LoginPopUpModel")
      local NeedShowList = LoginPopUpModel:CalculateNeedOpenLoginPopUp()
      if table.isempty(NeedShowList) then
        return
      end
      local PlayerCharacter = GWorld:GetMainPlayer()
      UIManager(PlayerCharacter):LoadUINew("AdvertisingPopUpMain", NeedShowList)
    end
  end
})
StateImpl.MonthCard = State:New("MonthCard", {
  OnEnter = function(AfterLoadingMgr)
    MonthSignInController:TryPopUpMonthSignIn()
  end
})
StateImpl.LayoutPlan = State:New("LayoutPlan", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if Avatar and UIUtils.IsMobileInput() then
      local PlayerCharacter = GWorld:GetMainPlayer()
      local LayoutPlanIndex = Avatar:GetCurrentMobileHudPlanIndex()
      local bHasSeenLayoutPlan03 = EMCache:Get(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true)
      local bIsOldLayoutUser = IsOldLayoutUser(Avatar, LayoutPlanIndex)
      if not bHasSeenLayoutPlan03 and not bIsOldLayoutUser then
        EMCache:Set(FIRST_OPEN_LAYOUT_PLAN_03_KEY, true, true)
      elseif PlayerCharacter and bIsOldLayoutUser and not bHasSeenLayoutPlan03 then
        UIManager(PlayerCharacter):LoadUINew("LayoutPlan")
      end
    end
  end
})
StateImpl.MainLineQuest = State:New("MainLineQuest", {
  OnEnter = function(AfterLoadingMgr)
    local GameMode = MiscUtils.GameMode()
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.NotifyAvatarRegionAllReady and GameMode and GameMode:IsInRegion() then
      local BattleMainUI = UIManager():GetUIObj("BattleMain")
      if Avatar and 0 ~= Avatar.TrackingQuestChainId and Avatar.TrackingQuestChainId ~= nil and BattleMainUI.Pos_TaskBar then
        BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Visible)
      else
        BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      Avatar:NotifyAvatarRegionAllReady()
    end
  end,
  GetNextState = function(self, AfterLoadingMgr)
    return GetNextStateWaitGuideOrBattleMain(self, AfterLoadingMgr)
  end
})
StateImpl.DynamicQuest = State:New("DynamicQuest", {
  OnEnter = function(AfterLoadingMgr)
    local GameMode = MiscUtils.GameMode()
    if GameMode and GameMode.ActivateDynamicQuestEvent then
      GameMode:ActivateDynamicQuestEvent()
    end
  end
})
StateImpl.ShowLevel = State:New("ShowLevel", {
  OnEnter = function(AfterLoadingMgr)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      UIManager():TryShowPlayerLevelUpInfo({
        CurLevel = Avatar.Level,
        ShowProgresBar = false
      })
    end
  end
})
StateImpl.GuildSceneUI = State:New("GuildSceneUI", {
  OnEnter = function(AfterLoadingMgr)
    local GameState = GameState()
    if GameState and GameState.IsInRegion and GameState:IsInRegion() and UIUtils.AmIInGuildScene() then
      local BattleMain = UIManager():GetUIObj("BattleMain")
      if BattleMain then
        BattleMain:PlayGuildInfoIn()
      end
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return
      end
      Avatar:NotifyCharacterStartSync(Avatar.CurrentOnlineType)
      PrintTable({
        GuildSceneUI_others = Avatar.RegionAvatars,
        GlobalRegionItemCache = Avatar.GlobalRegionItemCache
      }, 10)
      for i, v in pairs(Avatar.RegionAvatars) do
        Avatar:RegionSyncAddRoleToCreate(i, v)
        Avatar:InitOnlineStateData(i, v)
      end
    end
  end
})
StateImpl.EndState = State:New("EndState", {
  OnEnter = function(AfterLoadingMgr)
    UIManager():DestroyAfterLoadingMgr()
    UIManager():StartScriptDetectionCheck()
  end,
  GetNextState = function(self)
  end
})
local AfterLoadingMgr = Class()

function AfterLoadingMgr.New()
  local NewObj = {}
  setmetatable(NewObj, AfterLoadingMgr)
  NewObj.FSM = FSM.New(NewObj, StateImpl)
  return NewObj
end

function AfterLoadingMgr:Pause()
  self.bPause = true
  DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机暂停，当前状态：%s", self.FSM:Current()))
end

function AfterLoadingMgr:Fallback(State)
  State = State or self.FSM:Current()
  if not self.bPause and self:IsCurrentState(State) then
    DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机没有被暂停，继续执行 State: %s", State))
    self:Continue()
  end
end

function AfterLoadingMgr:IsCurrentState(State)
  return self.FSM:Current() == State
end

function AfterLoadingMgr:IsEnd()
  local CurrState = self.FSM:Current()
  return "EndState" == CurrState
end

function AfterLoadingMgr:Continue()
  if self.bPause then
    DebugPrint(WarningTag, string.format("AfterLoadingMgr 状态机从暂停中恢复, CurrState: %s", self.FSM:Current()))
  end
  self.bPause = false
  if self:IsEnd() then
    DebugPrint(WarningTag, "AfterLoadingMgr 状态机执行完毕！！！")
    return
  end
  local CurrState = self.FSM:Current()
  if not CurrState then
    DebugPrint(WarningTag, "AfterLoadingMgr 状态机开始执行！！！")
    self.FSM:Enter("BeginState")
    return
  end
  local NextState = StateImpl[CurrState]:GetNextState(self)
  if NextState then
    if NextState == CurrState then
      DebugPrint(WarningTag, string.format("AfterLoadingMgr GetNextState保持原状，暂停切换 CurrState:%s", CurrState))
      return
    end
    DebugPrint(WarningTag, string.format("AfterLoadingMgr 切换状态，前个状态：%s，下个状态：%s", CurrState, NextState))
    self.FSM:Enter(NextState)
  end
end

return AfterLoadingMgr
