require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

local function GetGlobalConstantNumber(Key)
  local Config = DataMgr.GlobalConstant and DataMgr.GlobalConstant[Key]
  return Config and tonumber(Config.ConstantValue) or nil
end

function M:Initialize()
  self.Super.Initialize(self)
  self.BossList = {}
  self.SelectedBossId = nil
  self.SelectedIndex = 1
  self.IsAutoChallenge = false
  self.TargetGuildId = nil
  self.IsAssistMode = false
  self.SquadId = 0
  self.bAssistConfirmPopupOpening = false
  self.bMechanismInteractiveEnded = false
end

function M:Construct()
  self.Super.Construct(self)
  self.bIsFocusable = true
  self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
  self:BindButtonEvents()
  self:InitGamepadKeyInfo()
  self:InitInputDeviceListener()
  AudioManager(self):PlayUISound(self, "event:/ui/common/common_panel_normal_expand", "GuildBossLevelChoosePanel", nil)
end

function M:Destruct()
  self:UnBindButtonEvents()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshInputDevice)
  end
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.ExtraInfo = (...)
  self.RankingPlayerInfos = {}
  self.RankingPendingBosses = {}
  self.RankingLoadId = (self.RankingLoadId or 0) + 1
  self:RefreshAssistMode()
  self:RefreshTextMap()
  self:InitQaButton()
  self:RefreshAll()
  self:PlayInAnim()
  self:SetFocus()
  self:FocusBossList()
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  if 1 == StackAction then
    self:RefreshDefaultListSquad()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if not self.bAssistConfirmPopupOpening and not self.DefaultList.IsShow then
    self:FocusBossList()
  end
  return UIUtils.Handled
end

function M:SetFocus_Lua()
  if self.bAssistConfirmPopupOpening then
    return
  end
  if self.DefaultList.IsShow then
    self.DefaultList.Team_Armory:SetFocus()
    return
  end
  self:SetFocus()
  self:FocusBossList()
end

function M:RefreshTextMap()
  if self.Btn_Challenge then
    local TextId = self.IsAssistMode and "UI_GuildBoss_AssistChallenge" or "UI_GuildBoss_Start"
    self.Btn_Challenge:SetText(GText(TextId))
  end
  if self.Btn_Ranking and self.Btn_Ranking.Text_Name then
    self.Btn_Ranking.Text_Name:SetText(GText("UI_GuildBoss_DrillData"))
  end
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_GuildBoss_TrialProgress"))
  end
end

function M:RefreshAssistMode()
  self.TargetGuildId = nil
  self.IsAssistMode = false
  if not GuildModel then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local CandidateTargetGuildId = type(self.ExtraInfo) == "table" and self.ExtraInfo.TargetGuildId or nil
  CandidateTargetGuildId = CandidateTargetGuildId or GuildModel:GetCurrentGuildRegionTargetGuildId()
  local DisplayGuildId = GuildModel:ResolveGuildBossDisplayGuildId(CandidateTargetGuildId)
  self.TargetGuildId = DisplayGuildId > 0 and DisplayGuildId or nil
  local SelfGuildId = Avatar and tonumber(Avatar.GuildId) or 0
  self.IsAssistMode = self.TargetGuildId ~= nil and self.TargetGuildId ~= SelfGuildId
end

function M:BindButton(Button, Func)
  if not Button or not Func then
    return
  end
  if Button.UnBindEventOnClickedByObj then
    Button:UnBindEventOnClickedByObj(self)
  end
  if Button.BindEventOnClicked then
    Button:BindEventOnClicked(self, Func)
  elseif Button.OnClicked then
    Button.OnClicked:Add(self, Func)
  end
end

function M:BindButtonEvents()
  self:BindButton(self.Btn_Close, self.OnClickClose)
  self:BindButton(self.Btn_Challenge, self.OnClickChallenge)
  self:BindButton(self.Btn_Qa, self.OnClickQa)
  self.CheckBox_Auto:AddEventOnCheckStateChanged(self, self.OnAutoChallengeChanged)
end

function M:UnBindButton(Button, Func)
  if not Button or not Func then
    return
  end
  if Button.UnBindEventOnClicked then
    Button:UnBindEventOnClicked(self, Func)
  elseif Button.UnBindEventOnClickedByObj then
    Button:UnBindEventOnClickedByObj(self)
  end
end

function M:UnBindButtonEvents()
  self:UnBindButton(self.Btn_Close, self.OnClickClose)
  self:UnBindButton(self.Btn_Challenge, self.OnClickChallenge)
  self:UnBindButton(self.Btn_Qa, self.OnClickQa)
  self.CheckBox_Auto:RemoveEventOnCheckStateChanged(self)
end

function M:InitGamepadKeyInfo()
  if self.Controller_Qa and self.Controller_Qa.CreateCommonKey then
    self.Controller_Qa:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      }
    })
  end
  if self.Controller_Auto and self.Controller_Auto.CreateCommonKey then
    self.Controller_Auto:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumb
        }
      }
    })
  end
  if self.Btn_Challenge and self.Btn_Challenge.SetGamePadImg then
    self.Btn_Challenge:SetGamePadImg(UIConst.GamePadImgKey.FaceButtonTop)
  elseif self.Btn_Challenge and self.Btn_Challenge.Key_Controller and self.Btn_Challenge.Key_Controller.CreateCommonKey then
    self.Btn_Challenge.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
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

function M:RefreshInputDevice(CurInputType, _)
  local bIsGamepad = CurInputType == ECommonInputType.Gamepad
  local VisibleType = bIsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  if self.Controller_Qa then
    self.Controller_Qa:SetVisibility(VisibleType)
  end
  if self.Controller_Auto then
    self.Controller_Auto:SetVisibility(VisibleType)
  end
  if self.Btn_Challenge and self.Btn_Challenge.Key_Controller then
    self.Btn_Challenge.Key_Controller:SetVisibility(VisibleType)
  end
  if self.Btn_Ranking and self.Btn_Ranking.Key_Controller then
    self.Btn_Ranking.Key_Controller:SetVisibility(VisibleType)
  end
  if bIsGamepad and not self.bAssistConfirmPopupOpening then
    if self.DefaultList.IsShow then
      self.DefaultList.Team_Armory:SetFocus()
    else
      self:FocusBossList()
    end
  end
end

function M:PlayInAnim()
  if self.In and self.PlayAnimationForward then
    self:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self:BindToAnimationFinished(self.In, {
      self,
      function()
        self:UnbindAllFromAnimationFinished(self.In)
        self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      end
    })
    self:PlayAnimationForward(self.In)
    return
  end
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:FocusBossList()
  if not (not self.bAssistConfirmPopupOpening and UIUtils.IsGamepadInput()) or not self.List_Boss then
    return
  end
  if self.List_Boss.SetFocus then
    self.List_Boss:SetFocus()
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.List_Boss)
  end
  local Index = math.max((self.SelectedIndex or 1) - 1, 0)
  if self.List_Boss.NavigateToIndex then
    self.List_Boss:NavigateToIndex(Index)
  end
  if self.List_Boss.SetSelectedIndex then
    self.List_Boss:SetSelectedIndex(Index)
  end
end

function M:PlayClickRefreshAnim()
  if self.ClickRefresh and self.PlayAnimation then
    self:PlayAnimation(self.ClickRefresh)
  end
end

function M:InitQaButton()
  if not self.Btn_Qa or not self.Btn_Qa.Init then
    return
  end
  if self.Btn_Qa.GetParent then
    local Parent = self.Btn_Qa:GetParent()
    if Parent and Parent.SetVisibility then
      Parent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  self.Btn_Qa:SetVisibility(UE4.ESlateVisibility.Visible)
  self.Btn_Qa:Init({
    OwnerWidget = self,
    TextContent = GText("UI_GuildBoss_Rule_1"),
    OnMenuOpenChangedCallBack = self.OnQaMenuOpenChanged
  })
end

function M:IsQaMenuOpen()
  return self.Btn_Qa and self.Btn_Qa.IsMenuAnchorOpen and self.Btn_Qa:IsMenuAnchorOpen()
end

function M:OpenQaMenu()
  if not self.Btn_Qa then
    return
  end
  if self.Btn_Qa.GetParent then
    local Parent = self.Btn_Qa:GetParent()
    if Parent and Parent.SetVisibility then
      Parent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  self.Btn_Qa:SetVisibility(UE4.ESlateVisibility.Visible)
  if self.Btn_Qa.PlayAnimation and self.Btn_Qa.Click then
    self.Btn_Qa:PlayAnimation(self.Btn_Qa.Click)
  end
  if self.Btn_Qa.SetChecked then
    self.Btn_Qa:SetChecked(true)
  elseif self.Btn_Qa.Btn_Click and self.Btn_Qa.Btn_Click.SetChecked then
    self.Btn_Qa.Btn_Click:SetChecked(true)
  end
  if self.Btn_Qa.OpenMenuAnchor then
    self.Btn_Qa:OpenMenuAnchor()
  end
end

function M:CloseQaMenu()
  if not self.Btn_Qa then
    return false
  end
  if self.Btn_Qa.Btn_Click and self.Btn_Qa.Btn_Click.SetChecked then
    self.Btn_Qa.Btn_Click:SetChecked(false)
  elseif self.Btn_Qa.SetChecked then
    self.Btn_Qa:SetChecked(false)
  end
  if self.Btn_Qa.CloseMenuAnchor then
    self.Btn_Qa:CloseMenuAnchor()
  end
  return true
end

function M:OnQaMenuOpenChanged(bIsOpen)
  self.bQaMenuOpen = true == bIsOpen
  if not self.bQaMenuOpen then
    self:FocusBossList()
  end
end

function M:OnClickClose()
  AudioManager(self):SetEventSoundParam(self, "GuildBossLevelChoosePanel", {ToEnd = 1})
  if self.Out and self.PlayAnimationForward then
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self:UnbindAllFromAnimationFinished(self.Out)
        self:Close()
      end
    })
    self:PlayAnimationForward(self.Out)
    return
  end
  self:Close()
end

function M:EndMechanismInteractive()
  if self.bMechanismInteractiveEnded then
    return
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local Player = PlayerController and PlayerController:GetMyPawn()
  if not (Player and Player.MechanismEid) or 0 == Player.MechanismEid then
    return
  end
  local Mechanism = Battle(self):GetEntity(Player.MechanismEid)
  if not Mechanism or not Mechanism.EndInteractive then
    return
  end
  self.bMechanismInteractiveEnded = true
  Mechanism:EndInteractive(Player, true)
end

function M:Close(...)
  self:EndMechanismInteractive()
  return M.Super.Close(self, ...)
end

function M:RefreshAll()
  self.AvatarGuildBossData = GuildModel and GuildModel:GetAvatarGuildBossData() or nil
  self:RefreshGuildBossData(function()
    self:RefreshAllWithGuildBossData()
  end)
end

function M:RefreshAllWithGuildBossData()
  self.BossList = self:GetBossIdList()
  if self.Btn_Ranking and self.Btn_Ranking.Init then
    self.Btn_Ranking:Init({
      Parent = self,
      GuildBossData = self.GuildBossData,
      TargetGuildId = self.TargetGuildId,
      GamePadKey = UIConst.GamePadImgKey.SpecialLeft
    })
  end
  local DefaultBossId = self:GetDefaultBossId()
  self:SelectBoss(DefaultBossId, self:GetBossIndex(DefaultBossId), true)
  self:RefreshAutoChallengeState()
  self:RefreshBossList()
  self:RefreshEmptyState()
  self:InitDefaultList()
end

function M:RefreshGuildBossData(Callback)
  if not GuildModel or not GuildModel.GetGuildBossDataByGuildId then
    self.GuildBossData = nil
    if Callback then
      Callback()
    end
    return
  end
  local RequestTargetGuildId = self.TargetGuildId
  GuildModel:GetGuildBossDataByGuildId(RequestTargetGuildId, function(GuildBossData, GuildInfo)
    if RequestTargetGuildId ~= self.TargetGuildId then
      return
    end
    self.GuildBossData = GuildBossData
    self.GuildInfo = GuildInfo
    if Callback then
      Callback()
    end
  end)
end

function M:GetBossIdList()
  local BossIds = {}
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig(self.GuildBossData)
  local BossOrder = GuildBossUtils.GetBossOrderList(RefreshInfo, self.GuildBossData)
  for _, BossId in ipairs(BossOrder) do
    table.insert(BossIds, BossId)
  end
  return BossIds
end

function M:GetDefaultBossId()
  if self.GuildBossData then
    local CurrentBossId = self.GuildBossData:GetCurrentBossId()
    for _, BossId in ipairs(self.BossList) do
      if tostring(BossId) == tostring(CurrentBossId) then
        return CurrentBossId
      end
    end
  end
  return self.BossList[1]
end

function M:GetBossIndex(BossId)
  for Index, CurBossId in ipairs(self.BossList) do
    if tostring(CurBossId) == tostring(BossId) then
      return Index
    end
  end
  return 1
end

function M:GetDefaultListDungeonId()
  local BossCfg = self.SelectedBossId and DataMgr.GuildBossInfo[self.SelectedBossId] or nil
  if BossCfg and BossCfg.DungeonID then
    return BossCfg.DungeonID
  end
  for _, BossId in ipairs(self.BossList) do
    BossCfg = DataMgr.GuildBossInfo[BossId]
    if BossCfg and BossCfg.DungeonID then
      return BossCfg.DungeonID
    end
  end
end

function M:GetBossState(BossId)
  if self.IsAssistMode then
    return GuildBossUtils.GetAssistGuildBossStateByBossId(self.GuildBossData, self.GuildInfo, BossId)
  end
  return GuildBossUtils.GetBossStateByBossId(BossId)
end

function M:GetEmptyTextByBossState(BossId)
  local State, RemainSec = self:GetBossState(BossId)
  if "NotStarted" == State then
    return string.format(GText("UI_GuildBoss_UnlockDrillLater"), UIUtils.FormatRemainDurationCoarseLoc(RemainSec))
  end
  if "ScoreNotEnough" == State then
    local ActivityNeedData = DataMgr.GlobalConstant.GuildBossOpenConditionData
    local ActivityNeed = ActivityNeedData and tonumber(ActivityNeedData.ConstantValue) or nil
    if ActivityNeed then
      return string.format(GText("UI_GuildBoss_UnlockByActivity"), ActivityNeed)
    end
    return nil
  end
  if "Ended" == State or nil == State then
    return GText("UI_GuildBoss_PeriodEnded")
  end
  return nil
end

function M:RefreshBossList()
  if not self.List_Boss or not self.List_Boss.ClearListItems then
    return
  end
  self.List_Boss:ClearListItems()
  self.List_Boss:SetVisibility(#self.BossList > 0 and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  for Index, BossId in ipairs(self.BossList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    if not Content then
      return
    end
    local CurrentBossId = self.GuildBossData and self.GuildBossData:GetCurrentBossId()
    Content.BossId = BossId
    Content.Index = Index
    Content.Parent = self
    Content.IsLocked = tostring(BossId) ~= tostring(CurrentBossId) or self:GetBossState(BossId) ~= "Active"
    Content.IsSelect = tostring(BossId) == tostring(self.SelectedBossId)
    local BossCfg = DataMgr.GuildBossInfo[BossId]
    Content.Title = BossCfg and BossCfg.Name and GText(BossCfg.Name) or ""
    Content.NumberOfChoices = #self.BossList
    self.List_Boss:AddItem(Content)
  end
end

function M:RefreshBossListSelection()
  if not (self.List_Boss and self.List_Boss.GetNumItems) or not self.List_Boss.GetItemAt then
    return
  end
  for Index = 0, self.List_Boss:GetNumItems() - 1 do
    local Content = self.List_Boss:GetItemAt(Index)
    if Content then
      local CurrentBossId = self.GuildBossData and self.GuildBossData:GetCurrentBossId()
      Content.IsLocked = tostring(Content.BossId) ~= tostring(CurrentBossId) or self:GetBossState(Content.BossId) ~= "Active"
      Content.IsSelect = tostring(Content.BossId) == tostring(self.SelectedBossId)
      if Content.Entry and Content.Entry.RefreshState then
        Content.Entry:RefreshState()
      end
    end
  end
end

function M:SelectBoss(BossId, Index, bSilent)
  if not BossId then
    self.SelectedBossId = nil
    self.SelectedIndex = 1
    self:RefreshBossDetail(nil)
    return
  end
  self.SelectedBossId = BossId
  if Index then
    self.SelectedIndex = Index
  else
    self.SelectedIndex = self:GetBossIndex(BossId)
  end
  self:RefreshBossDetail(BossId)
  if not bSilent then
    self:PlayClickRefreshAnim()
    self:RefreshBossListSelection()
    self:FocusBossList()
  end
end

function M:SelectBossByOffset(Offset)
  if #self.BossList <= 0 then
    return
  end
  local Index = self.SelectedIndex or 1
  Index = Index + Offset
  if Index < 1 then
    Index = #self.BossList
  elseif Index > #self.BossList then
    Index = 1
  end
  self:SelectBoss(self.BossList[Index], Index, false)
  self:FocusBossList()
end

function M:RefreshBossDetail(BossId)
  local HasBoss = nil ~= BossId
  local BossState
  if HasBoss then
    BossState = self:GetBossState(BossId)
  end
  local CurrentBossId = self.GuildBossData and self.GuildBossData:GetCurrentBossId()
  local IsCurrentBoss = HasBoss and tostring(BossId) == tostring(CurrentBossId)
  local IsLocked = HasBoss and (not IsCurrentBoss or "Active" ~= BossState)
  local BossName, BossDesc
  if HasBoss then
    local BossCfg = DataMgr.GuildBossInfo[BossId]
    BossName = BossCfg and BossCfg.Name and GText(BossCfg.Name) or nil
    BossDesc = BossCfg and BossCfg.Desc and GText(BossCfg.Desc) or nil
  end
  if self.Text_BossName then
    self.Text_BossName:SetText(BossName or "")
  end
  if self.Text_BossDetail then
    self.Text_BossDetail:SetText(BossDesc or "")
  end
  if self.Panel_Trail then
    self.Panel_Trail:SetVisibility(not (not HasBoss or IsLocked) and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Panel_Ranking then
    self.Panel_Ranking:SetVisibility(not (not HasBoss or IsLocked) and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Group_Button then
    self.Group_Button:SetVisibility(not (not HasBoss or IsLocked) and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Group_LastTime then
    self.Group_LastTime:SetVisibility(IsCurrentBoss and "Active" == BossState and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  self:RefreshBossImage(BossId)
  self:RefreshTrialProgress(BossId, IsLocked)
  self:RefreshRanking(BossId, IsLocked)
  self:RefreshButtonState(BossId, IsLocked)
  if IsLocked then
  end
  self:RefreshBossEndTime(BossId, BossState)
  self:RefreshEmptyState()
end

function M:RefreshBossImage(BossId)
  if not BossId or not self.Image_Boss then
    return
  end
  local Cfg = DataMgr.GuildBossInfo[BossId]
  if not Cfg or not Cfg.LevelChooseImgBPPath then
    return
  end
  local ImagePath = Cfg.LevelChooseImgBPPath
  if not ImagePath or not LoadObject then
    return
  end
  local ImageObject = LoadObject(ImagePath)
  if not ImageObject then
    return
  end
  if self.Image_Boss.GetDynamicMaterial then
    local Mat = self.Image_Boss:GetDynamicMaterial()
    if Mat and Mat.SetTextureParameterValue then
      Mat:SetTextureParameterValue("IconTex", ImageObject)
    end
  elseif self.Image_Boss.SetBrushFromTexture then
    self.Image_Boss:SetBrushFromTexture(ImageObject)
  end
end

function M:GetTrialProgressContent(BossId, TrialId, Index)
  local Percent = 0
  local EffectText = ""
  local ConditionText = ""
  if TrialId then
    if self.GuildBossData and self.GuildBossData.GetTrialProgressOfTrial then
      Percent = GuildBossUtils.CalcTrialProgressPercent(TrialId, self.GuildBossData:GetTrialProgressOfTrial(TrialId))
    end
    local TrialCfg = DataMgr and DataMgr.GuildWarTest and DataMgr.GuildWarTest[TrialId] or nil
    if TrialCfg then
      ConditionText = GText("UI_GuildBoss_BrokenCondition") .. GuildBossUtils.FormatGuildWarTestDesc(TrialCfg)
      local BossCfg = DataMgr.GuildBossInfo[BossId]
      local BuffId = BossCfg and BossCfg.GuildWarBuff and BossCfg.GuildWarBuff[Index] or nil
      local BuffCfg = BuffId and DataMgr and DataMgr.GuildWarBuff and DataMgr.GuildWarBuff[BuffId] or nil
      if BuffCfg then
        EffectText = GuildBossUtils.FormatGuildWarBuffDesc(BuffCfg)
      end
    end
  end
  return {
    Text_Effect = EffectText,
    Text_Condition = ConditionText,
    IconPath = GuildBossUtils.GetTrialIconPath(Index),
    Percent = tostring(Percent or 0)
  }
end

function M:RefreshTrialProgress(BossId, IsLocked)
  local Widgets = {
    self.TrialProgress_1,
    self.TrialProgress_2,
    self.TrialProgress_3
  }
  local TrialList = {}
  if not IsLocked and self.GuildBossData and self.GuildBossData.GetTrialList then
    TrialList = self.GuildBossData:GetTrialList()
  end
  for Index, Widget in ipairs(Widgets) do
    local TrialId = type(TrialList) == "table" and TrialList[Index] or nil
    if Widget then
      Widget:SetVisibility(not IsLocked and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
      if not IsLocked and Widget.InitContent then
        Widget:InitContent(self:GetTrialProgressContent(BossId, TrialId, Index))
      end
    end
  end
end

function M:GetRankList(BossId)
  local RankList = {}
  local SingleDamageRank = self.GuildBossData and self.GuildBossData.GetSingleDamageRank and self.GuildBossData:GetSingleDamageRank()
  local Source = SingleDamageRank and SingleDamageRank.Values and SingleDamageRank:Values() or {}
  for _, RankData in ipairs(Source) do
    if RankData and tonumber(RankData.BossId) == tonumber(BossId) then
      table.insert(RankList, RankData)
    end
  end
  table.sort(RankList, function(A, B)
    local ADamage = tonumber(A.Damage) or 0
    local BDamage = tonumber(B.Damage) or 0
    if ADamage == BDamage then
      return (tonumber(A.Uid) or 0) < (tonumber(B.Uid) or 0)
    end
    return ADamage > BDamage
  end)
  return RankList
end

function M:RefreshRanking(BossId, IsLocked)
  local RankWidgets = {
    self.RankingInfo_1,
    self.RankingInfo_2,
    self.RankingInfo_3
  }
  local RankList = IsLocked and {} or self:GetRankList(BossId)
  local Avatar = GWorld:GetAvatar()
  if not self.IsAssistMode then
    for Index = 1, math.min(#RankList, #RankWidgets) do
      local Uid = RankList[Index].Uid
      if Avatar and tostring(Uid) == tostring(Avatar.Uid) then
        self.RankingPlayerInfos[Uid] = Avatar
        self.RankingPlayerInfos[tostring(Uid)] = Avatar
      elseif not self.RankingPlayerInfos[Uid] and not self.RankingPlayerInfos[tostring(Uid)] and not self.RankingPlayerInfos[tonumber(Uid)] then
        local Member = GuildModel:GetCurrMember(Uid)
        if Member and rawget(Member, "HeadIconId") ~= nil then
          self.RankingPlayerInfos[Uid] = Member
          self.RankingPlayerInfos[tostring(Uid)] = Member
        end
      end
    end
  end
  for Index, Widget in ipairs(RankWidgets) do
    local RankData = RankList[Index]
    local Uid = RankData and RankData.Uid
    local PlayerInfo = Uid and (self.RankingPlayerInfos[Uid] or self.RankingPlayerInfos[tostring(Uid)] or self.RankingPlayerInfos[tonumber(Uid)])
    Widget:Refresh(RankData, Index, PlayerInfo, self.GuildInfo)
  end
  local Uids = {}
  for Index = 1, math.min(#RankList, #RankWidgets) do
    local Uid = RankList[Index].Uid
    if not self.RankingPlayerInfos[Uid] and not self.RankingPlayerInfos[tostring(Uid)] and not self.RankingPlayerInfos[tonumber(Uid)] then
      table.insert(Uids, Uid)
    end
  end
  if 0 == #Uids then
    return
  end
  local BossLoadId = (self.RankingPendingBosses[BossId] or 0) + 1
  self.RankingPendingBosses[BossId] = BossLoadId
  local LoadId = self.RankingLoadId
  local _, WillCallback = GuildModel:QueryGuildMemberInfo(function(Ret, MemberInfos)
    if not IsValid(self) or LoadId ~= self.RankingLoadId or BossLoadId ~= self.RankingPendingBosses[BossId] then
      return
    end
    self.RankingPendingBosses[BossId] = nil
    if Ret ~= ErrorCode.RET_SUCCESS or type(MemberInfos) ~= "table" then
      return
    end
    for _, Uid in ipairs(Uids) do
      local PlayerInfo = MemberInfos[Uid] or MemberInfos[tostring(Uid)]
      if PlayerInfo then
        self.RankingPlayerInfos[Uid] = PlayerInfo
        self.RankingPlayerInfos[tostring(Uid)] = PlayerInfo
        local NumUid = tonumber(Uid)
        if NumUid then
          self.RankingPlayerInfos[NumUid] = PlayerInfo
        end
      end
    end
    if self.SelectedBossId ~= BossId then
      return
    end
    for Index, Widget in ipairs(RankWidgets) do
      local RankData = RankList[Index]
      local Uid = RankData and RankData.Uid
      local PlayerInfo = Uid and (self.RankingPlayerInfos[Uid] or self.RankingPlayerInfos[tostring(Uid)] or self.RankingPlayerInfos[tonumber(Uid)])
      Widget:Refresh(RankData, Index, PlayerInfo, self.GuildInfo)
    end
  end, Uids, true)
  if not WillCallback then
    self.RankingPendingBosses[BossId] = nil
  end
end

function M:GetChallengeRemain()
  local Used = 0
  local Total = GetGlobalConstantNumber("GuildBossEnterNum")
  self.AvatarGuildBossData = GuildModel and GuildModel:GetAvatarGuildBossData() or nil
  if self.AvatarGuildBossData and self.AvatarGuildBossData.GetChallengeUsed then
    Used = self.AvatarGuildBossData:GetChallengeUsed()
  end
  if not Total then
    return nil, Used, nil
  end
  if Total <= 0 then
    return 0, Used, 0
  end
  return math.max(Total - Used, 0), Used, Total
end

function M:GetAssistRemain()
  local Used = 0
  local Total = GetGlobalConstantNumber("GuildBossHelpEnterNum")
  self.AvatarGuildBossData = GuildModel and GuildModel:GetAvatarGuildBossData() or nil
  if self.AvatarGuildBossData and self.AvatarGuildBossData.GetAssistUsed then
    Used = self.AvatarGuildBossData:GetAssistUsed()
  end
  if not Total then
    return nil, Used, nil
  end
  if Total <= 0 then
    return 0, Used, 0
  end
  return math.max(Total - Used, 0), Used, Total
end

function M:ApplyChallengeButtonForbid(bForbid)
  if not self.Btn_Challenge then
    return
  end
  if self.Btn_Challenge.ForbidBtn then
    self.Btn_Challenge:ForbidBtn(bForbid)
  end
  if not bForbid then
    if self.Btn_Challenge.Button_Area and self.Btn_Challenge.Button_Area.SetIsEnabled then
      self.Btn_Challenge.Button_Area:SetIsEnabled(true)
    end
    if self.Btn_Challenge.PlayButtonUnForbidAnim then
      self.Btn_Challenge:PlayButtonUnForbidAnim()
    end
  end
end

function M:RefreshChallengeButtonText(Remain, Total)
  if not self.Btn_Challenge or not self.Btn_Challenge.SetText then
    return
  end
  local TextId = self.IsAssistMode and "UI_GuildBoss_AssistChallenge" or "UI_GuildBoss_Start"
  local ButtonText = GText(TextId)
  if nil ~= Total then
    ButtonText = string.format("%s(%d/%d)", ButtonText, tonumber(Remain) or 0, tonumber(Total) or 0)
  end
  self.Btn_Challenge:SetText(ButtonText)
end

function M:RefreshButtonState(BossId, IsLocked)
  local Remain, Total
  if self.IsAssistMode then
    local RemainData = {
      self:GetAssistRemain()
    }
    Remain = RemainData[1]
    Total = RemainData[3]
  else
    local RemainData = {
      self:GetChallengeRemain()
    }
    Remain = RemainData[1]
    Total = RemainData[3]
  end
  local bMissingTotal = nil == Total
  local bNoRemain = nil ~= Remain and Remain <= 0
  local bForbidChallenge = not BossId or IsLocked or bMissingTotal or bNoRemain
  self:RefreshChallengeButtonText(Remain, Total)
  self:ApplyChallengeButtonForbid(bForbidChallenge)
  if self.Text_Auto then
    self.Text_Auto:SetText(GText("UI_Auto_Round_Title"))
  end
end

function M:InitDefaultList()
  if not self.DefaultList then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self.DefaultList:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local DungeonId = self:GetDefaultListDungeonId()
  if not DungeonId then
    self.DefaultList:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local DungeonCfg = DataMgr.Dungeon[DungeonId]
  local DungeonType = DungeonCfg and DungeonCfg.DungeonType or nil
  local SquadId = 0
  if DungeonType and Avatar.DungeonSquad and Avatar.DungeonSquad[DungeonType] then
    SquadId = Avatar.DungeonSquad[DungeonType]
  end
  self.SquadId = SquadId
  if self.DefaultList.Init then
    self.DefaultList:Init(self, false, SquadId, DungeonId)
  else
    self.DefaultList:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.DefaultList.Preview and self.DefaultList.Preview.Btn_Qa_Summon then
    local Btn = self.DefaultList.Preview.Btn_Qa_Summon
    Btn:RemoveTimer("RefreshPlacementInViewport")
    Btn:Init({
      OwnerWidget = self,
      TextContent = GText("UI_ArmourySquad_AutoSummonTips"),
      MenuPlacement = EMenuPlacement.MenuPlacement_ComboBox,
      OnMenuOpenChangedCallBack = self.OnQaMenuOpenChanged
    })
  end
end

function M:RefreshDefaultListSquad()
  if not self.DefaultList or not self.DefaultList.RefreshData then
    return
  end
  local DungeonId = self:GetDefaultListDungeonId()
  if not DungeonId then
    return
  end
  self.DefaultList.CurSelectedDungeonId = DungeonId
  self.DefaultList.CurrentSquad = self.SquadId or 0
  self.DefaultList:RefreshData()
end

function M:OnCurrentSquadChange(SquadId, _, CurSelectedDungeonId)
  if CurSelectedDungeonId ~= self:GetDefaultListDungeonId() then
    return
  end
  self.SquadId = SquadId or 0
end

function M:RefreshBossEndTime(BossId, State)
  if "Active" ~= State then
    return
  end
  local RefreshInfo = GuildBossUtils.GetCurrentRefreshConfig and GuildBossUtils.GetCurrentRefreshConfig(self.GuildBossData)
  local HasTime = GuildBossUtils.SetBossSlotTimeText and GuildBossUtils.SetBossSlotTimeText(self.Time, RefreshInfo, BossId, self.GuildBossData)
  if not HasTime then
    if self.Group_LastTime then
      self.Group_LastTime:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    return
  end
  if self.Time and self.Time.Text_TimeTitle and self.Time.Text_TimeDesc and self.Time.Text_TimeDesc.GetText then
    local RemainTimeText = self.Time.Text_TimeDesc:GetText()
    self.Time.Text_TimeTitle:SetText(tostring(RemainTimeText) .. GText("UI_GuildBoss_EndDrill"))
    self.Time.Text_TimeTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Time and self.Time.Text_TimeDesc then
    self.Time.Text_TimeDesc:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshEmptyState()
  local HasData = #self.BossList > 0
  local State = HasData and self.SelectedBossId and self:GetBossState(self.SelectedBossId) or nil
  local CurrentBossId = self.GuildBossData and self.GuildBossData:GetCurrentBossId()
  local IsCurrentBoss = HasData and self.SelectedBossId and tostring(self.SelectedBossId) == tostring(CurrentBossId)
  local ShowEmpty = not HasData or not IsCurrentBoss or "Active" ~= State
  if self.WS_Type and self.WS_Type.SetActiveWidgetIndex then
    self.WS_Type:SetActiveWidgetIndex(ShowEmpty and 1 or 0)
  end
  if self.Com_Empty then
    self.Com_Empty:SetVisibility(ShowEmpty and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Text_Empty then
    self.Text_Empty:SetVisibility(ShowEmpty and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if ShowEmpty and HasData and self.SelectedBossId then
    if self.Text_Empty then
      self.Text_Empty:SetText(self:GetEmptyTextByBossState(self.SelectedBossId) or "")
    end
  elseif not ShowEmpty and self.Text_Empty then
    self.Text_Empty:SetText("")
  end
end

function M:OnClickChallenge()
  if not self.SelectedBossId then
    return
  end
  local CurrentBossId = self.GuildBossData and self.GuildBossData:GetCurrentBossId()
  if tostring(self.SelectedBossId) ~= tostring(CurrentBossId) then
    return
  end
  if self:GetBossState(self.SelectedBossId) ~= "Active" then
    return
  end
  if self.IsAssistMode then
    self:OnClickAssist(self.TargetGuildId)
    return
  end
  local Remain, _, Total = self:GetChallengeRemain()
  if not Total then
    return
  end
  if Remain <= 0 then
    return
  end
  AudioManager(self):PlayUISound(self.Btn_Challenge, "event:/ui/common/click_btn_confirm", nil, nil)
  self:ReqEnterGuildBoss(self.SelectedBossId, false, nil)
end

function M:OnClickQa()
  if self:IsQaMenuOpen() then
    self:CloseQaMenu()
  else
    self:OpenQaMenu()
  end
end

function M:OnClickRanking()
  if self.Btn_Ranking and self.Btn_Ranking.OpenRankUI then
    AudioManager(self):PlayUISound(self.Btn_Ranking, "event:/ui/common/click_mid", nil, nil)
    self.Btn_Ranking:OpenRankUI()
  end
end

function M:OnAutoChallengeChanged(bChecked)
  self.IsAutoChallenge = true == bChecked
end

function M:RefreshAutoChallengeState()
  local DungeonId = self:GetDefaultListDungeonId()
  local Avatar = GWorld:GetAvatar()
  local DungeonData = Avatar and Avatar.Dungeons and DungeonId and Avatar.Dungeons[DungeonId]
  self.IsAutoChallenge = DungeonData and DungeonData.AutoProgress > 0 or false
  if self.CheckBox_Auto and self.CheckBox_Auto.SetChecked then
    self.CheckBox_Auto:SetChecked(self.IsAutoChallenge, false)
  end
end

function M:ToggleAutoChallenge()
  if self.CheckBox_Auto and self.CheckBox_Auto.GetChecked then
    self.IsAutoChallenge = not self.CheckBox_Auto:GetChecked()
  else
    self.IsAutoChallenge = not self.IsAutoChallenge
  end
  if self.CheckBox_Auto and self.CheckBox_Auto.SetChecked then
    self.CheckBox_Auto:SetChecked(self.IsAutoChallenge, true)
  end
end

function M:OnClickAssist(TargetGuildId)
  if not self.SelectedBossId then
    return
  end
  if not TargetGuildId then
    return
  end
  local Remain, _, Total = self:GetAssistRemain()
  if not Total then
    return
  end
  if Remain <= 0 then
    return
  end
  AudioManager(self):PlayUISound(self.Btn_Challenge, "event:/ui/common/click_btn_confirm", nil, nil)
  self:ShowAssistChallengeConfirmPopup(TargetGuildId)
end

function M:ShowAssistChallengeConfirmPopup(TargetGuildId)
  local PopupId = 100396
  local CommonDialogParams = {}
  self.bAssistConfirmPopupOpening = true
  CommonDialogParams.AutoFocus = true
  CommonDialogParams.OnCloseCallbackObj = self
  CommonDialogParams.OnCloseCallbackFunction = self.OnAssistChallengeConfirmClosed
  
  function CommonDialogParams.RightCallbackFunction()
    self:ReqEnterGuildBoss(self.SelectedBossId, true, TargetGuildId)
  end
  
  local PopupUI = UIManager(self):ShowCommonPopupUI(PopupId, CommonDialogParams, self)
  if not PopupUI then
    self:OnAssistChallengeConfirmClosed()
  end
end

function M:SetDungeonExitInfo()
  local ExitDungeonInfo = GWorld.GameInstance:GetExitDungeonData() or {}
  ExitDungeonInfo.Type = "GuildBoss"
  ExitDungeonInfo.SubRegionId = 300101
  ExitDungeonInfo.TeleportPoint = 1
  ExitDungeonInfo.IsFromRegionMechanism = true
  GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
end

function M:OnAssistChallengeConfirmClosed()
  self.bAssistConfirmPopupOpening = false
  self:SetFocus_Lua()
end

function M:ReqEnterGuildBoss(BossId, IsAssist, TargetGuildId)
  local BossCfg = BossId and DataMgr.GuildBossInfo[BossId] or nil
  local DungeonId = BossCfg and BossCfg.DungeonID or nil
  if not DungeonId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CustomParams = {}
  if IsAssist and TargetGuildId then
    CustomParams.TargetGuildId = TargetGuildId
  end
  Avatar:SetDungeonAutoProgress(DungeonId, self.IsAutoChallenge and 1 or 0)
  self:SetDungeonExitInfo()
  Avatar:EnterDungeon(DungeonId, nil, nil, nil, self.SquadId or 0, CustomParams)
end

function M:HandleGamepadKeyDown(InKeyName)
  if not UIUtils.IsGamepadInput() then
    return false
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.DefaultList:OnSpecialRightUp()
    if not self.DefaultList.IsShow then
      self:FocusBossList()
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    local Preview = self.DefaultList.Preview
    if Preview.Btn_Qa_Summon:IsMenuAnchorOpen() then
      Preview.Btn_Qa_Summon:SetChecked(false)
      self:FocusBossList()
      return true
    end
  end
  if self.DefaultList.IsShow then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self.DefaultList:OnCloseSquadGamepad()
      self:FocusBossList()
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self:IsQaMenuOpen() then
      self:CloseQaMenu()
      return true
    end
    self:OnClickClose()
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.LeftStickUp then
    self:SelectBossByOffset(-1)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.LeftStickDown then
    self:SelectBossByOffset(1)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    local Switch = self.DefaultList.Preview.Switch_Summon
    Switch:SetChecked(not Switch:GetChecked(), true)
    return true
  elseif InKeyName == UIConst.GamePadKey.DPadLeft then
    local Preview = self.DefaultList.Preview
    if Preview.Btn_Qa_Summon:IsMenuAnchorOpen() then
      Preview.Btn_Qa_Summon:SetChecked(false)
      self:FocusBossList()
    else
      Preview:OpenDefaultMenuAnchor()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self:OnClickQa()
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    self:ToggleAutoChallenge()
    return true
  elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
    self:OnClickRanking()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnClickChallenge()
    return true
  end
  return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleGamepadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:HandleGamepadKeyDown(InKeyName) then
    return UIUtils.Handled
  elseif "Escape" == InKeyName then
    self:OnClickClose()
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnAnalogValueChanged(_, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY and UIUtils.CheckScrollBoxCanScroll(self.List_TrialProgress) then
    local AddOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurScrollOffset = self.List_TrialProgress:GetScrollOffset()
    local ScrollOffset = math.min(math.max(CurScrollOffset - AddOffset, 0), self.List_TrialProgress:GetScrollOffsetOfEnd())
    self.List_TrialProgress:SetScrollOffset(ScrollOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
