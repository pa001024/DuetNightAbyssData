require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local GuildBossPointRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossPointRewardUtils")
local GuildBossRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossRewardUtils")
local LIST_ITEM_CONTENT_CLASS = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
local FOCUS_BOSS_TAB_TIMER_KEY = "FocusBossTabTimer"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

local function ResolvePath(Root, Path)
  for Part in string.gmatch(Path, "[^.]+") do
    if not Root then
      return nil
    end
    Root = Root[Part]
  end
  return Root
end

local GAMEPAD_KEY_ICON_CONFIGS = {
  {
    "Controller_Qa",
    UIConst.GamePadImgKey.RightThumb
  },
  {
    "Btn_Ranking.Key_Controller",
    UIConst.GamePadImgKey.LeftThumb
  },
  {
    "Btn_Challenge.Key_GamePad",
    UIConst.GamePadImgKey.FaceButtonBottom
  }
}

local function SetGamepadWidgetVisibility(Widget, bIsGamepad, UpdateParent)
  if not Widget then
    return
  end
  local Vis = bIsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  Widget:SetVisibility(Vis)
  if UpdateParent then
    local Parent = Widget:GetParent()
    if Parent then
      Parent:SetVisibility(Vis)
    end
  end
end

local function SetWidgetFocusable(Widget, bFocusable)
  if not Widget then
    return
  end
  Widget.bIsFocusable = bFocusable
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(bFocusable)
  end
end

local function PreloadCommonRankingUI(UIManager)
  if not UIManager or UIManager:GetPreloadUIClass("CommonRanking") then
    return
  end
  if UIManager.AddClassToPreloadAsync then
    UIManager:AddClassToPreloadAsync("CommonRanking")
    return
  end
  local Config = DataMgr.SystemUI.CommonRanking
  if not Config then
    return
  end
  local BPPath = CommonUtils.GetDeviceTypeByPlatformName(UIManager) == "PC" and Config.PCBPPath or Config.MobileBPPath or Config.PCBPPath
  if not BPPath then
    return
  end
  UE.UResourceLibrary.LoadClassAsync(UIManager, BPPath, {
    UIManager,
    function(_, UIClass)
      if not (UIManager and UIClass) or not IsValid(UIClass) then
        return
      end
      if UIManager:GetPreloadUIClass("CommonRanking") then
        return
      end
      UIManager.PreLoadUIStates:Add("CommonRanking", UIClass)
    end
  })
end

local function SetRewardControllerActivityGamepadVisible(self, bShow)
  local Widget = self.Reward and self.Reward.Controller_Activity
  if not Widget then
    return
  end
  if bShow then
    Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if Widget.CreateGamepadKey then
      Widget:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
    elseif Widget.CreateCommonKey then
      Widget:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
          }
        }
      })
    end
  else
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

local function ResolveBossId(self, OptionalBossId)
  local BossId = OptionalBossId or self.BossId
  if BossId and 0 ~= BossId then
    return BossId
  end
  local GuildBossData = GuildModel:GetGuildBossData()
  return GuildBossData and GuildBossData:GetCurrentBossId()
end

local function IsCurrentBoss(BossId)
  local GuildBossData = GuildModel:GetGuildBossData()
  local CurrentBossId = GuildBossData and GuildBossData:GetCurrentBossId()
  return BossId and CurrentBossId and tostring(BossId) == tostring(CurrentBossId)
end

function M:Construct()
  if self.Reward and self.Reward.Btn_Click then
    self.Reward.Btn_Click.OnClicked:Add(self, self.OnClickedReward)
  end
  if self.Btn_Rule and self.Btn_Rule.Button_Area then
    self.Btn_Rule.Button_Area.OnClicked:Add(self, self.OnBtnInfoClicked)
  end
  self:InitBossMainContent()
  self:InitUI()
  self:InitBossGamepadKeys()
  self:InitInputDeviceListener()
  self:DisableFocusableButtons()
  ReddotManager.AddListenerEx("GuildBossHub", self, self.RefreshRewardReddot)
end

function M:Destruct()
  self:RestoreFocusableButtons()
  self:StopTimeRefreshTicker()
  ReddotManager.RemoveListener("GuildBossHub", self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshInputDevice)
  end
end

function M:RefreshUIInfo()
  self:InitUI()
  self:RefreshBossMainData()
  if self.Refresh then
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_select_in", nil, nil)
    self:PlayAnimation(self.Refresh)
  end
  self._bSkipInAnim = true
end

function M:PlayInAnim()
  if self._bSkipInAnim then
    self._bSkipInAnim = false
    return
  end
  if self.In then
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_select_in", nil, nil)
    self:PlayAnimation(self.In)
  end
end

function M:PlayOutAnim()
  if self.Out then
  end
end

function M:OnTabItemSelected(TabWidget, Tab)
end

function M:InitBossMainContent()
  self:RefreshBossMainData()
  self:InitTitle()
  self:InitChallengeBtn()
  self:InitRankingBtn()
  self:InitQaBtn()
  PreloadCommonRankingUI(GWorld.GameInstance and GWorld.GameInstance:GetGameUIManager())
  GuildModel:RefreshGuildBossPersonPointRewardReddot()
  GuildBossRewardUtils.RefreshBossStageReddot()
end

function M:RefreshBossMainData()
  self:RefreshBossWidgets()
  self:RefreshBossTime()
  self:RefreshChallengeChance()
  self:InitTrialProgressItemList()
  self:InitRewardProgress()
  self:RefreshBossHpText()
  self:RefreshChallengeBtnState()
  self:RefreshCurrentBossDependentUI()
end

function M:InitUI()
  if not self.List_Boss then
    return
  end
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig()
  if not RefreshInfo then
    DebugPrint("WBP_Guild_Boss: no valid GuildBossRefresh config")
    return
  end
  local BossOrder = GuildBossUtils.GetBossOrderList(RefreshInfo)
  self.BossNum = #BossOrder
  if self.BossNum <= 0 then
    DebugPrint("WBP_Guild_Boss: empty BossOrder")
    return
  end
  self.List_Boss:ClearListItems()
  local CurrentBossId = GuildModel:GetGuildBossData() and GuildModel:GetGuildBossData():GetCurrentBossId()
  local CurrentBossIndex
  local hasActiveBoss = false
  for Index, BossId in ipairs(BossOrder) do
    local BossInfo = GuildBossUtils.GetBossInfo(BossId)
    if BossInfo then
      local State = GuildBossUtils.GetBossStateByBossId(BossId)
      if "Active" == State then
        hasActiveBoss = true
      end
    end
  end
  DebugPrint("WBP_Guild_Boss: BossTab list begin, count=", #BossOrder)
  for Index, BossId in ipairs(BossOrder) do
    local BossInfo = GuildBossUtils.GetBossInfo(BossId)
    if BossInfo then
      local BossName = BossInfo.Name and GText(BossInfo.Name) or ""
      DebugPrint(string.format("WBP_Guild_Boss: BossTab[%d] BossId=%s Name=%s", Index, tostring(BossId), BossName))
      local Obj = NewObject(UE4.LoadClass(LIST_ITEM_CONTENT_CLASS))
      Obj.Parent = self
      Obj.BossId = BossId
      Obj.BossInfo = BossInfo
      Obj.Index = Index
      Obj.RefreshInfo = RefreshInfo
      self.List_Boss:AddItem(Obj)
      if not hasActiveBoss then
        Obj.IsSelected = 1 == Obj.Index
      else
        Obj.IsSelected = GuildBossUtils.GetBossStateByBossId(BossId) == "Active"
      end
      if CurrentBossId and tostring(BossId) == tostring(CurrentBossId) then
        CurrentBossIndex = Index - 1
      end
    else
      DebugPrint("WBP_Guild_Boss: GuildBossInfo not found", BossId)
    end
  end
  self.RefreshInfo = RefreshInfo
  self.CurrentBossIndex = CurrentBossIndex or 0
end

function M:RefreshBossInfo(BossId)
  if self.BossId == BossId then
    return
  end
  local bShouldPlayRefreshAnim = self.BossId ~= nil and 0 ~= self.BossId
  if bShouldPlayRefreshAnim then
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  end
  self.BossId = BossId
  self:RefreshBossWidgets(BossId)
  self:RefreshBtnState(BossId)
  local RefreshInfo = self.RefreshInfo or GuildBossUtils.GetCurrentRefreshConfig()
  if RefreshInfo then
    self:UpdateRewardPeriodTime(RefreshInfo)
  end
  self:RefreshBossProgress(BossId)
  self:InitTrialProgressItemList()
  self:InitRewardProgress()
  self:RefreshBossHpText(BossId)
  self:RefreshChallengeBtnState()
  self:RefreshCurrentBossDependentUI(BossId)
  if bShouldPlayRefreshAnim and self.Refresh then
    DebugPrint("WBP_Guild_Boss_Main: PlayUISound association_boss_select_in")
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_select_in", nil, nil)
    self:PlayAnimation(self.Refresh)
  end
end

function M:OnBossTabClicked()
  if self.CanGotoBoss then
    self:OnBtnChallengeClicked()
  end
end

function M:RefreshBtnState(BossId)
  if not self.WS_Button or not self.Hint then
    return
  end
  local State = GuildBossUtils.GetBossStateByBossId(BossId)
  if "Active" ~= State then
    self.WS_Button:SetActiveWidgetIndex(1)
    self.CanGotoBoss = false
    if "NotStarted" == State then
      self.Hint.Text_Hint_Locked:SetText(GText("UI_GuildBoss_NotOpenYet"))
    elseif "Ended" == State then
      self.Hint.Text_Hint_Normal:SetText(GText("UI_GuildBoss_PeriodEnded_2"))
    elseif "ScoreNotEnough" == State then
      local NeedActivity = DataMgr.GlobalConstant.GuildBossOpenConditionData and tonumber(DataMgr.GlobalConstant.GuildBossOpenConditionData.ConstantValue) or 3000
      self.Hint.Text_Hint_Locked:SetText(string.format(GText("UI_GuildBoss_WeeklyActUnlock"), NeedActivity))
    end
  else
    self.WS_Button:SetActiveWidgetIndex(0)
    self.CanGotoBoss = true
  end
  if "Ended" == State then
    self.Hint.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  else
    self.Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
  end
  self:RefreshChallengeBtnState()
end

function M:RefreshBossProgress(BossId)
  local State = GuildBossUtils.GetBossStateByBossId(BossId)
  local GuildBossData = GuildModel:GetGuildBossData()
  if not GuildBossData then
    return
  end
  local TrialList = GuildBossData:GetTrialList()
  local TrialProgress = GuildBossData:GetTrialProgress()
  local BossCfg = DataMgr.GuildBossInfo[BossId]
  if not BossCfg then
    DebugPrint("RefreshBossProgress invalid BossId", BossId)
    return
  end
  local BuffList = BossCfg.GuildWarBuff
  if "NotStarted" == State then
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    self.CanFocusTrailProgress = false
  else
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(0)
    end
    self.CanFocusTrailProgress = true
  end
  for i = 1, self.BossNum or 0 do
    local Progress = 0
    if "Active" == State then
      Progress = TrialProgress[TrialList[i]]
    end
    local BuffConfig = BuffList and DataMgr.GuildWarBuff[BuffList[i]]
    local TrailConfig = DataMgr.GuildWarTest[TrialList[i]]
    local CalulationRule = TrailConfig and TrailConfig.CalulationRule or nil
    local Params = {
      Title = BuffConfig and GuildBossUtils.FormatGuildWarBuffDesc(BuffConfig) or "",
      Desc = TrailConfig and GText("GuildBoss_TestClear") .. GuildBossUtils.FormatGuildWarTestDesc(TrailConfig) or "",
      Progress = Progress,
      MaxProgress = CalulationRule and (CalulationRule.Rate or CalulationRule.Hit) or 0,
      Icon = GuildBossUtils.GetTrialIconPath(i),
      Owner = self
    }
    local TrailWidget = self["TrailProgress_" .. i]
    if TrailWidget then
      TrailWidget:Init(Params)
    end
  end
  if self.Reward then
    self.Reward.Text_Now:SetText(GuildModel:GetAvatarGuildBossData():GetPoint())
    self.Reward.Text_Total:SetText(GuildBossPointRewardUtils.GetPointMax(GuildModel:GetAvatarGuildBossData()))
  end
  self:RefreshBossHpText(BossId)
end

function M:InitTitle()
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_GuildBoss_TrialProgress"))
  end
end

function M:RefreshCurrentBossDependentUI(OptionalBossId)
  local BossId = ResolveBossId(self, OptionalBossId)
  local State = GuildBossUtils.GetBossStateByBossId(BossId)
  local bIsActive = "Active" == State
  local Vis = bIsActive and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.RewardProgress then
    self.RewardProgress:SetVisibility(Vis)
  end
  if self.Reward then
    self.Reward:SetVisibility(Vis)
  end
  if self.Btn_Ranking then
    self.Btn_Ranking:SetVisibility(Vis)
  end
  if self.HorizontalBox_1 then
    self.HorizontalBox_1:SetVisibility(Vis)
  end
  for i = 1, 3 do
    local Widget = self["TrialProgress_" .. i]
    if Widget and Widget.SetEmptyState then
      if bIsActive then
        Widget:SetEmptyState(false)
      else
        Widget:SetEmptyState(true, "UI_GuildBoss_TrialNotStarted")
      end
    end
  end
  if bIsActive then
    self:RefreshBossTime()
  elseif self.Time then
    self.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshRewardReddot()
end

function M:InitTrialProgressItemList()
  local BossId = ResolveBossId(self)
  if not IsCurrentBoss(BossId) then
    self:RefreshCurrentBossDependentUI(BossId)
    return
  end
  local GuildBossData = GuildModel:GetGuildBossData()
  if not GuildBossData then
    return
  end
  local TrialList = GuildBossData:GetTrialList()
  for i = 1, 3 do
    local Widget = self["TrialProgress_" .. i]
    if Widget then
      local Content = self:BuildTrialProgressContent(TrialList[i], i)
      Widget:InitContent(Content)
    end
  end
  self:RefreshCurrentBossDependentUI(BossId)
end

function M:BuildTrialProgressContent(TrialId, Index)
  local GuildBossData = GuildModel:GetGuildBossData()
  local Percent = 0
  local TestDes = ""
  local EffectText = ""
  if TrialId and GuildBossData then
    Percent = GuildBossUtils.CalcTrialProgressPercent(TrialId, GuildBossData:GetTrialProgressOfTrial(TrialId))
    local TrialCfg = DataMgr.GuildWarTest and DataMgr.GuildWarTest[TrialId]
    if TrialCfg then
      TestDes = GText("UI_GuildBoss_BrokenCondition") .. (GuildBossUtils.FormatGuildWarTestDesc(TrialCfg) or "")
      local BossId = ResolveBossId(self)
      local BossCfg = BossId and DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[BossId]
      local BuffId
      if BossCfg and BossCfg.GuildWarBuff then
        BuffId = BossCfg.GuildWarBuff[Index]
      end
      local BuffCfg = BuffId and DataMgr.GuildWarBuff and DataMgr.GuildWarBuff[BuffId]
      if BuffCfg then
        local BuffName = GText(BuffCfg.BuffName) or ""
        local BuffDes = GuildBossUtils.FormatGuildWarBuffDesc(BuffCfg)
        EffectText = BuffDes
      end
    end
  end
  return {
    Text_Effect = EffectText,
    Text_Condition = TestDes,
    IconPath = GuildBossUtils.GetTrialIconPath(Index),
    Percent = tostring(Percent)
  }
end

function M:InitRewardProgress()
  if not self.RewardProgress then
    return
  end
  local BossId = ResolveBossId(self)
  local HpProgress = GuildBossRewardUtils.GetBossHpProgress(BossId)
  self.RewardProgress:InitProgress(GText("UI_GuildBoss_DrillProgress"), HpProgress)
end

function M:BuildGuildBossRewardParams(DefaultType)
  return GuildBossRewardUtils.BuildGuildBossRewardParams(self, DefaultType, ResolveBossId(self))
end

function M:OnClickedReward()
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/large_btn_click", nil, nil)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:LoadUINew("GuildReward", self:BuildGuildBossRewardParams("Personal"))
end

function M:UpdateRewardPeriodTime(RefreshInfo)
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  if not self.Reward or not self.Reward.Time then
    return
  end
  local WeekEnd = GuildBossUtils.GetCurrentWeekSlotEndTime(RefreshInfo)
  if not WeekEnd then
    return
  end
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(WeekEnd, nil)
  if self.Reward.Time.SetCountdownTextOnly then
    self.Reward.Time:SetCountdownTextOnly(RemainTimeDict)
  else
    self.Reward.Time:SetTimeText(nil, RemainTimeDict)
  end
end

function M:RefreshBossWidgets(OptionalBossId)
  local BossId = ResolveBossId(self, OptionalBossId)
  if not BossId or 0 == BossId then
    DebugPrint("WBP_Guild_Boss_Main: invalid current BossId")
    return
  end
  local BossInfo = GuildBossUtils.GetBossInfo(BossId)
  if not BossInfo then
    DebugPrint("WBP_Guild_Boss_Main: BossInfo not found", BossId)
    return
  end
  self:RefreshBossChildWidget(self.Pos_BossImage, BossInfo.GuildBossMainBPPath, "BossImage")
  self:RefreshBossChildWidget(self.Pos_BossTitle, BossInfo.TitleBPPath, "BossTitle", BossInfo.Name)
end

function M:RefreshBossChildWidget(SlotContainer, BPPath, DebugName, BossNameTextMapId)
  if not SlotContainer then
    return
  end
  if not BPPath then
    DebugPrint("WBP_Guild_Boss_Main: " .. DebugName .. " path not found")
    return
  end
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  SlotContainer:ClearChildren()
  local Widget = UIManager:CreateWidget(BPPath)
  if not IsValid(Widget) then
    DebugPrint("WBP_Guild_Boss_Main: " .. DebugName .. " Create Failed", BPPath)
    return
  end
  if BossNameTextMapId and Widget.SetBossName then
    print("WBP_Guild_Boss_Main: SetBossName", GText(BossNameTextMapId))
    Widget:SetBossName(GText(BossNameTextMapId))
  end
  local Slot = SlotContainer:AddChildToOverlay(Widget)
  Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
end

function M:RefreshBossHpText(OptionalBossId)
  if self.Text_ProgressDesc then
    self.Text_ProgressDesc:SetText(GText("UI_GuildBoss_DrillProgress_2"))
  end
  if not self.Text_Percent then
    return
  end
  local BossId = ResolveBossId(self, OptionalBossId)
  if not BossId or 0 == BossId then
    self.Text_Percent:SetText(0)
    return
  end
  local GuildBossData = GuildModel:GetGuildBossData()
  local CurProgress = GuildBossData and GuildBossData:GetHpProgressOfBoss(BossId) or 0
  local BossInfo = GuildBossUtils.GetBossInfo(BossId)
  local MaxHp = BossInfo and tonumber(BossInfo.BossTotalHP) or 0
  local RemainingHp = math.max(0, MaxHp - CurProgress)
  self.Text_Percent:SetText(tostring(math.floor(RemainingHp)))
end

function M:RefreshBossTime()
  if not self.Time then
    return
  end
  if not IsCurrentBoss(ResolveBossId(self)) then
    self.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig()
  local WeekEnd = RefreshInfo and GuildBossUtils.GetCurrentWeekSlotEndTime(RefreshInfo)
  if not WeekEnd then
    self.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StopTimeRefreshTicker()
    return
  end
  self.Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(WeekEnd, nil)
  if self.Time.SetCountdownTextOnly then
    self.Time:SetCountdownTextOnly(RemainTimeDict, "")
  else
    self.Time:SetTimeText("", RemainTimeDict)
  end
  self:StartTimeRefreshTicker()
end

function M:StartTimeRefreshTicker()
  GuildBossUtils.StartBossTimeRefreshTicker(self, self.OnGuildBossTimeTick)
end

function M:OnGuildBossTimeTick()
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  self:RefreshBossTime()
  local RefreshInfo = self.RefreshInfo or GuildBossUtils.GetCurrentRefreshConfig()
  if RefreshInfo then
    self:UpdateRewardPeriodTime(RefreshInfo)
  end
end

function M:StopTimeRefreshTicker()
  GuildBossUtils.StopBossTimeRefreshTicker(self)
end

function M:InitChallengeBtn()
  if self.Btn_Challenge then
    self.Btn_Challenge:SetText(GText("UI_GuildBoss_Start"))
    self.Btn_Challenge:BindEventOnClicked(self, self.OnBtnChallengeClicked)
    self.Btn_Challenge:BindForbidStateExecuteEvent(self, self.OnBtnChallengeForbidden)
    if self.Btn_Challenge.Reddot then
      self.Btn_Challenge.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:RefreshChallengeBtnState()
  end
end

function M:OnBtnChallengeClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    GuildModel:RequestEnterGuildOnline(Avatar.GuildId, 2)
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, 300101, 2, nil, nil, true)
end

function M:OnBtnChallengeForbidden()
  local ForbidTip = self:GetChallengeForbidTip()
  if ForbidTip then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, ForbidTip)
  end
end

function M:RefreshChallengeBtnState()
  if not self.Btn_Challenge then
    return
  end
  self.Btn_Challenge:ForbidBtn(self:GetChallengeForbidTip() ~= nil)
end

function M:GetChallengeForbidTip()
  if self:GetChallengeRemainingTimes() <= 0 then
    return GText("UI_GuildBoss_AttemptsExhausted")
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsInTeam() then
    return GText("UI_GuildBoss_LeaveTeamFirst")
  end
  return nil
end

function M:GetChallengeRemainingTimes()
  local AvatarGuildBossData = GuildModel:GetAvatarGuildBossData()
  local UsedTimes = AvatarGuildBossData and AvatarGuildBossData:GetChallengeUsed() or 0
  local TotalTimes = DataMgr.GlobalConstant.GuildBossEnterNum and tonumber(DataMgr.GlobalConstant.GuildBossEnterNum.ConstantValue) or 10
  return math.max(0, TotalTimes - UsedTimes), TotalTimes
end

function M:RefreshChallengeChance()
  if not self.Text_Chance then
    return
  end
  local RemainingTimes = self:GetChallengeRemainingTimes()
  local BaseText = GText("UI_GuildBoss_WeeklyAttemptsRemain")
  local FormattedText = string.format(BaseText, RemainingTimes)
  if RemainingTimes <= 0 then
    FormattedText = string.format("<Highlight>%s</>", FormattedText)
  end
  self.Text_Chance:SetText(FormattedText)
end

function M:InitRankingBtn()
  if self.Btn_Ranking then
    if self.Btn_Ranking.Init then
      self.Btn_Ranking:Init({
        Parent = self,
        GuildBossData = GuildModel:GetGuildBossData(),
        GamePadKey = UIConst.GamePadImgKey.SpecialLeft
      })
    end
    self.Btn_Ranking.Btn_Click.OnClicked:Add(self, self.OnBtnRankingClicked)
    if self.Btn_Ranking.Text_Name then
      self.Btn_Ranking.Text_Name:SetText(GText("UI_GuildBoss_DrillData"))
    end
  end
end

function M:DisableFocusableButtons()
  if self.Btn_Challenge and self.Btn_Challenge.Button_Area then
    local Widget = self.Btn_Challenge.Button_Area
    self._SavedChallengeBtnAreaFocusable = Widget.bIsFocusable
    SetWidgetFocusable(Widget, false)
  end
  if self.Btn_Ranking and self.Btn_Ranking.Btn_Click then
    local Widget = self.Btn_Ranking.Btn_Click
    self._SavedRankingBtnClickFocusable = Widget.bIsFocusable
    SetWidgetFocusable(Widget, false)
  end
end

function M:RestoreFocusableButtons()
  if self.Btn_Challenge and self.Btn_Challenge.Button_Area and self._SavedChallengeBtnAreaFocusable ~= nil then
    SetWidgetFocusable(self.Btn_Challenge.Button_Area, self._SavedChallengeBtnAreaFocusable)
    self._SavedChallengeBtnAreaFocusable = nil
  end
  if self.Btn_Ranking and self.Btn_Ranking.Btn_Click and nil ~= self._SavedRankingBtnClickFocusable then
    SetWidgetFocusable(self.Btn_Ranking.Btn_Click, self._SavedRankingBtnClickFocusable)
    self._SavedRankingBtnClickFocusable = nil
  end
end

function M:OnBtnRankingClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if self.Btn_Ranking and self.Btn_Ranking.OpenRankUI then
    self.Btn_Ranking:OpenRankUI()
  end
end

function M:InitQaBtn()
  if not self.Btn_Qa then
    return
  end
  local Parent = self.Btn_Qa.GetParent and self.Btn_Qa:GetParent()
  if Parent and Parent.SetVisibility then
    Parent:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.Btn_Qa:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Qa:Init({
    OwnerWidget = self,
    TextContent = GText("UI_GuildBoss_UnlockGuildShop"),
    MenuPlacement = EMenuPlacement.MenuPlacement_CenteredAboveAnchor,
    OnMenuOpenChangedCallBack = self.OnQaMenuOpenChanged,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end,
    SoundFuncReceiver = self
  })
end

function M:OnQaMenuOpenChanged(bIsOpen)
  self.bQaMenuOpen = true == bIsOpen
  if not self.bQaMenuOpen and UIUtils.IsGamepadInput() then
    self:FocusToCurrentBoss()
    self:UpdateFocusState(1)
  end
end

function M:IsQaMenuOpen()
  return self.Btn_Qa and self.Btn_Qa.IsMenuAnchorOpen and self.Btn_Qa:IsMenuAnchorOpen()
end

function M:CloseQaMenu()
  if not self.Btn_Qa then
    return false
  end
  if self.Btn_Qa.SetChecked then
    self.Btn_Qa:SetChecked(false)
  end
  if self.Btn_Qa.CloseMenuAnchor then
    self.Btn_Qa:CloseMenuAnchor()
  end
  return true
end

function M:OnBtnInfoClicked()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100393)
end

function M:RefreshRewardReddot(Count)
  if not self.Reward or not self.Reward.Reddot then
    return
  end
  if nil == Count then
    local Node = ReddotManager.GetTreeNode("GuildBossHub")
    Count = Node and Node.Count or 0
  end
  local bShow = IsCurrentBoss(ResolveBossId(self)) and Count > 0
  if bShow then
    self.Reward.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.Reward.Reddot.WS_Icon then
      self.Reward.Reddot.WS_Icon:SetActiveWidgetIndex(0)
    end
  else
    self.Reward.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitBossGamepadKeys()
  self:InitGamepadKeyInfo()
  self:InitBossOnlyGamepadKeys()
end

function M:InitGamepadKeyInfo()
  for _, cfg in ipairs(GAMEPAD_KEY_ICON_CONFIGS) do
    local Widget = ResolvePath(self, cfg[1])
    if Widget then
      Widget:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = cfg[2]
          }
        }
      })
    end
  end
end

function M:InitBossOnlyGamepadKeys()
  if self.Reward and self.Reward.Key_Controller then
    self.Reward.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
    })
  end
  if self.Controller_Trail then
    self.Controller_Trail:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      }
    })
  end
  if self.Controller_Rule then
    self.Controller_Rule:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.SpecialRight
        }
      },
      Desc = GText("UI_Common_Rule")
    })
  end
end

function M:InitInputDeviceListener()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInputDevice)
    self:RefreshInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshInputDevice(CurInputType, CurGamepadName)
  local bIsGamepad = CurInputType == ECommonInputType.Gamepad
  local bIsCurrentBoss = IsCurrentBoss(ResolveBossId(self))
  SetGamepadWidgetVisibility(self.Controller_Qa, bIsGamepad, false)
  SetGamepadWidgetVisibility(self.Btn_Ranking and self.Btn_Ranking.Key_Controller, bIsGamepad, false)
  if bIsGamepad and self.Btn_Ranking and bIsCurrentBoss then
    self.Btn_Ranking:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  SetGamepadWidgetVisibility(self.Btn_Challenge and self.Btn_Challenge.Key_Controller, bIsGamepad, false)
end

function M:DispatchGamepadAction(DebugMsg, TargetWidget, EventName)
  DebugPrint(DebugMsg)
  if TargetWidget and TargetWidget[EventName] then
    TargetWidget[EventName]:Broadcast()
  end
end

function M:OnGamepadQaPressed()
  if self:IsQaMenuOpen() then
    self:CloseQaMenu()
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local QaBtn = self.Btn_Qa
    if not QaBtn then
      return
    end
    if QaBtn.SetChecked then
      QaBtn:SetChecked(true)
    end
    if QaBtn.OpenMenuAnchor then
      QaBtn:OpenMenuAnchor()
    end
  end
end

function M:OnGamepadRewardProgressClicked()
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  self:DispatchGamepadAction("WBP_Guild_Boss_Main: OnGamepadRewardProgressClicked", self.RewardProgress and self.RewardProgress.Btn_Click, "OnClicked")
end

function M:OnGamepadRewardClicked()
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  DebugPrint("WBP_Guild_Boss_Main: OnGamepadRewardClicked")
  self:OnClickedReward()
end

function M:OnGamepadChallengePressed()
  if self.Btn_Challenge then
    if self:GetChallengeForbidTip() then
      self:OnBtnChallengeForbidden()
    else
      self:OnBtnChallengeClicked()
    end
  end
end

function M:OnGamepadRankingPressed()
  if not IsCurrentBoss(ResolveBossId(self)) then
    return
  end
  self:DispatchGamepadAction("WBP_Guild_Boss_Main: OnGamepadRankingPressed", self.Btn_Ranking and self.Btn_Ranking.Btn_Click, "OnClicked")
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  DebugPrint("[GuildBossMain] OnContentKeyDown called, KeyName=", tostring(InKeyName), "IsGamepad=", UIUtils.IsGamepadInput())
  if not UIUtils.IsGamepadInput() then
    return false
  end
  local bIsBackKey = "Gamepad_FaceButton_Right" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight
  if bIsBackKey and self:IsQaMenuOpen() then
    self:CloseQaMenu()
    return true
  end
  if self.IsFocusingTrailProgress then
    if "Gamepad_FaceButton_Right" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight then
      if self.IsOpenTrailTip then
        for i = 1, self.BossNum or 0 do
          local TrailWidget = self["TrailProgress_" .. i]
          if TrailWidget and TrailWidget.MenuAnchor then
            TrailWidget.MenuAnchor:Close()
          end
        end
        return true
      end
      self.IsFocusingTrailProgress = false
      self:FocusToBossList()
      self:UpdateFocusState(1)
      return true
    end
    return false
  end
  if "Gamepad_DPad_Up" == InKeyName or InKeyName == UIConst.GamePadKey.DPadUp or "Gamepad_DPad_Down" == InKeyName or InKeyName == UIConst.GamePadKey.DPadDown or "Gamepad_LeftStick_Up" == InKeyName or InKeyName == UIConst.GamePadKey.LeftStickUp or "Gamepad_LeftStick_Down" == InKeyName or InKeyName == UIConst.GamePadKey.LeftStickDown then
    return false
  end
  if "Gamepad_DPad_Left" == InKeyName or InKeyName == UIConst.GamePadKey.DPadLeft or "Gamepad_DPad_Right" == InKeyName or InKeyName == UIConst.GamePadKey.DPadRight or "Gamepad_LeftStick_Left" == InKeyName or InKeyName == UIConst.GamePadKey.LeftStickLeft or "Gamepad_LeftStick_Right" == InKeyName or InKeyName == UIConst.GamePadKey.LeftStickRight then
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightThumb or "Gamepad_RightThumbstick" == InKeyName then
    self:OnGamepadQaPressed()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop or "Gamepad_FaceButton_Top" == InKeyName then
    self:OnGamepadRewardProgressClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb or "Gamepad_LeftThumbstick" == InKeyName then
    self:OnGamepadRankingPressed()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom or "Gamepad_FaceButton_Bottom" == InKeyName then
    self:OnGamepadChallengePressed()
    return true
  elseif "Gamepad_Special_Right" == InKeyName or InKeyName == UIConst.GamePadKey.SpecialRight then
    self:OnBtnInfoClicked()
    return true
  end
  return false
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:FocusToCurrentBoss()
  else
    self:FocusToBossList()
  end
  return UIUtils.Handled
end

function M:UpdateUIType(CurInputDevice, CurGamepadName, NeedFocus)
  if UIUtils.IsGamepadInput() then
    self:RefreshGamepadView(NeedFocus)
    for i = 1, self.BossNum or 0 do
      local TrailWidget = self["TrailProgress_" .. i]
      if TrailWidget and TrailWidget.RefreshGamepadView then
        TrailWidget:RefreshGamepadView()
      end
    end
  else
    self:RefreshKeyboardView()
    for i = 1, self.BossNum or 0 do
      local TrailWidget = self["TrailProgress_" .. i]
      if TrailWidget and TrailWidget.RefreshKeyboardView then
        TrailWidget:RefreshKeyboardView()
      end
    end
  end
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshGamepadView(NeedFocus)
  self:InitBaseBottomKeyInfo()
  if NeedFocus then
    self:FocusToCurrentBoss()
  end
  if self.Reward and self.Reward.Key_Controller and IsCurrentBoss(ResolveBossId(self)) then
    self.Reward.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Controller_Trail then
    self.Controller_Trail:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.WS_Rule then
    self.WS_Rule:SetActiveWidgetIndex(1)
  end
  if self.Btn_Challenge and self.Btn_Challenge.SetGamePadVisibility then
    self.Btn_Challenge:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshKeyboardView()
  if self.Reward and self.Reward.Key_Controller then
    self.Reward.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Controller_Trail then
    self.Controller_Trail:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.WS_Rule then
    self.WS_Rule:SetActiveWidgetIndex(0)
  end
  if self.Btn_Challenge and self.Btn_Challenge.SetGamePadVisibility then
    self.Btn_Challenge:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:FocusBossListAtIndex(FocusIndex)
  if not self.List_Boss then
    return
  end
  local BossNum = self.BossNum or 0
  if BossNum <= 0 then
    return
  end
  if FocusIndex < 0 or FocusIndex >= BossNum then
    FocusIndex = 0
  end
  self.List_Boss:SetSelectedIndex(FocusIndex)
  self.List_Boss:ScrollIndexIntoView(FocusIndex)
  if self.List_Boss.NavigateToIndex then
    self.List_Boss:NavigateToIndex(FocusIndex)
  end
  if self.List_Boss.SetFocus then
    self.List_Boss:SetFocus()
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.List_Boss)
  end
end

function M:FocusBossListDeferred(FocusIndex)
  if not self.List_Boss then
    return
  end
  if self.AddTimer then
    self:AddTimer(0.05, function()
      if not IsValid(self) or not self.List_Boss then
        return
      end
      self:FocusBossListAtIndex(FocusIndex)
    end, false, 0, FOCUS_BOSS_TAB_TIMER_KEY)
  else
    self:FocusBossListAtIndex(FocusIndex)
  end
end

function M:FocusToBossList()
  if not self.List_Boss then
    return
  end
  if UIUtils.IsGamepadInput() then
    self:FocusBossListDeferred(self.CurrentBossIndex or 0)
  else
    self.List_Boss:SetFocus()
  end
end

function M:FocusToCurrentBoss()
  self:FocusBossListDeferred(self.CurrentBossIndex or 0)
end

function M:InitBaseBottomKeyInfo()
  if self.ParentWidget then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.ParentWidget:UpdateComTab(BottomKeyInfo)
  end
end

function M:UpdateFocusState(Index)
  self.FocusIndex = Index
  if 1 == self.FocusIndex then
    self:InitBaseBottomKeyInfo()
    self:RefreshGamepadView(false)
  elseif 2 == self.FocusIndex then
    if self.ParentWidget then
      local BottomKeyInfo = {
        {
          GamePadInfoList = {
            {
              Type = "Img",
              ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom,
              Owner = self
            }
          },
          Desc = GText("UI_Tips_Ensure")
        },
        {
          GamePadInfoList = {
            {
              Type = "Img",
              ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
              Owner = self
            }
          },
          Desc = GText("UI_BACK")
        }
      }
      self.ParentWidget:UpdateComTab(BottomKeyInfo)
    end
    self:RefreshKeyboardView()
  elseif 3 == self.FocusIndex then
    if self.ParentWidget then
      self.ParentWidget:UpdateComTab({})
    end
    self:RefreshKeyboardView()
  end
end

return M
