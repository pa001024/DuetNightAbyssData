require("UnLua")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local M = Class("BluePrints.UI.BP_UIState_C")
local ReviewPopupItemIndex = {
  MainLine = 0,
  BranchLine = 1,
  EndLine = 2
}
local ReviewPopupTitleIndex = {
  Normal = 0,
  End = 1,
  Progress = 2
}
local ReviewItemState = InvestigationWallUtils.ReviewItemState
local OpenSoundEventPath = "event:/ui/common/reading_hud"
local OpenSoundKey = "StringBoardPopupOpen"

function M:Initialize(Initializer)
  self.bPopupClosing = false
  self.bShowJumpButton = false
  self.bGamepadFocusRestoredOnCloseBegin = false
end

function M:OnLoaded(Content, ...)
  self.Content = Content
  self.bPopupClosing = false
  self.bGamepadFocusRestoredOnCloseBegin = false
  self:Init()
  self:PlayOpenAnimation()
  self:ApplyGamepadPopupFocus()
end

function M:Init()
  self:InitGamepadSettings()
  self:BindEvents()
  self:InitReviewPopupItem()
  self:ClearReviewNewAfterPopupBrowsed()
end

function M:ClearReviewNewAfterPopupBrowsed()
  local ReviewId = self.Content and self.Content.ReviewId
  if not ReviewId then
    return
  end
  StringBoardReddotHelper.ClearReviewNew(ReviewId)
end

function M:Destruct()
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self:UnbindCheckShowMapForTrace()
  self:UnbindPopupOpenCloseAnimations()
  self:UnbindEvents()
  self.Content = nil
  self.bPopupClosing = false
  self.bGamepadFocusRestoredOnCloseBegin = false
end

function M:BindEvents()
  local BtnClose = self.Btn_Close
  if BtnClose and BtnClose.Btn_Click and BtnClose.Btn_Click.OnClicked then
    BtnClose.Btn_Click.OnClicked:Clear()
    BtnClose.Btn_Click.OnClicked:Add(self, self.OnCloseClicked)
  end
  local BtnJump = self.Btn_Jump
  if BtnJump and BtnJump.Btn_Click and BtnJump.Btn_Click.OnClicked then
    BtnJump.Btn_Click.OnClicked:Clear()
    BtnJump.Btn_Click.OnClicked:Add(self, self.OnClickTraceTask)
  end
end

function M:UnbindEvents()
  self:UnbindCheckShowMapForTrace()
  local BtnClose = self.Btn_Close
  if BtnClose and BtnClose.Btn_Click and BtnClose.Btn_Click.OnClicked then
    BtnClose.Btn_Click.OnClicked:Remove(self, self.OnCloseClicked)
  end
  local BtnJump = self.Btn_Jump
  if BtnJump and BtnJump.Btn_Click and BtnJump.Btn_Click.OnClicked then
    BtnJump.Btn_Click.OnClicked:Remove(self, self.OnClickTraceTask)
  end
end

function M:UnbindPopupOpenCloseAnimations()
  if self.In and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.In)
  end
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
end

function M:PlayOpenAnimation()
  AudioManager(self):PlayUISound(self, OpenSoundEventPath, OpenSoundKey, nil)
  if self.Out then
    if self.UnbindAllFromAnimationFinished then
      self:UnbindAllFromAnimationFinished(self.Out)
    end
    if self.IsAnimationPlaying and self:IsAnimationPlaying(self.Out) and self.StopAnimation then
      self:StopAnimation(self.Out)
    end
  end
  self.bPopupClosing = false
  if self.In and self.PlayAnimation then
    if self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
      self:StopAnimation(self.In)
    end
    self:PlayAnimation(self.In)
  end
end

function M:Close()
  if not self or not IsValid(self) then
    return
  end
  if self.bPopupClosing then
    return
  end
  if not self.IsInit then
    M.Super.Close(self)
    return
  end
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self.bPopupClosing = true
  self.IsBeginToClose = true
  self:RestoreGamepadFocusOnCloseBegin()
  if self.In and self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  if not self.Out or not self.PlayAnimation then
    self:RealClose()
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  if self.BindToAnimationFinished then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnPopupOutAnimationFinished
    })
  end
  self:PlayAnimation(self.Out)
end

function M:RestoreGamepadFocusOnCloseBegin()
  if self.bSkipRestoreFocusOnClose or self.bGamepadFocusRestoredOnCloseBegin then
    return
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.bGamepadFocusRestoredOnCloseBegin = true
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetNavigateWidgetVisibility then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
  local Content = self.Content
  local OwnerLine = Content and Content.OwnerLine
  local PosX = Content and Content.PosX
  local PosY = Content and Content.PosY
  if OwnerLine and IsValid(OwnerLine) and OwnerLine.RestoreGamepadFocusAfterPopup then
    OwnerLine:RestoreGamepadFocusAfterPopup(PosX, PosY)
  end
end

function M:OnPopupOutAnimationFinished()
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:RealClose()
end

function M:OnCloseClicked()
  if self.bPopupClosing then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_team_preset_click", nil, nil)
  self:Close()
end

function M:GetReviewConfig()
  local ReviewId = self.Content and self.Content.ReviewId
  if not ReviewId then
    return nil
  end
  return DataMgr.Review and DataMgr.Review[ReviewId]
end

local function ResolveReviewPopupItemIndex(ReviewType)
  if 2 == ReviewType then
    return ReviewPopupItemIndex.BranchLine
  end
  if 3 == ReviewType then
    return ReviewPopupItemIndex.EndLine
  end
  return ReviewPopupItemIndex.MainLine
end

local function ResolveReviewPopupTitleIndex(ReviewType)
  if 3 == ReviewType then
    return ReviewPopupTitleIndex.End
  end
  return ReviewPopupTitleIndex.Normal
end

function M:RefreshReviewPopupTitle(ReviewConfig, ReviewItemWidget)
  if not self.WS_Title or not ReviewConfig then
    return
  end
  self.WS_Title:SetActiveWidgetIndex(ResolveReviewPopupTitleIndex(ReviewConfig.ReviewType))
end

function M:ResolveCurrentReviewItemState()
  local ReviewId = self.Content and self.Content.ReviewId
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  return InvestigationWallUtils.ResolveReviewItemState(ReviewId, Avatar)
end

function M:CanShowJumpButton(QuestChainId)
  if not QuestChainId or 0 == QuestChainId then
    return false
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar then
    return false
  end
  local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
  if QuestChain and QuestChain.IsFinish and QuestChain:IsFinish() then
    return false
  end
  return true
end

function M:CanTraceCurrentReviewTask(ReviewConfig, ReviewItemWidget)
  ReviewConfig = ReviewConfig or self:GetReviewConfig()
  if not ReviewConfig then
    return false
  end
  ReviewItemWidget = ReviewItemWidget or self:GetReviewItemWidgetByType(ReviewConfig.ReviewType)
  local CurrentReviewItemState = self:ResolveCurrentReviewItemState(ReviewItemWidget)
  if CurrentReviewItemState ~= ReviewItemState.Exploring then
    return false
  end
  return self:CanShowJumpButton(ReviewConfig.QuestChainId)
end

function M:RefreshDescState(ReviewConfig, ReviewItemWidget)
  if not self.WS_Desc then
    return
  end
  local CurrentReviewItemState = self:ResolveCurrentReviewItemState(ReviewItemWidget)
  local bIsExploring = CurrentReviewItemState == ReviewItemState.Exploring
  self.WS_Desc:SetActiveWidgetIndex(bIsExploring and 1 or 0)
  if not self.Btn_Jump then
    return
  end
  local bShowJumpButton = self:CanTraceCurrentReviewTask(ReviewConfig, ReviewItemWidget)
  self.bShowJumpButton = bShowJumpButton
  self.Btn_Jump:SetVisibility(bShowJumpButton and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
  self:RefreshJumpKeyTipVisibility()
end

function M:InitReviewPopupItem()
  local ReviewConfig = self:GetReviewConfig()
  if not ReviewConfig then
    return
  end
  if self.WS_Item then
    self.WS_Item:SetActiveWidgetIndex(ResolveReviewPopupItemIndex(ReviewConfig.ReviewType))
  end
  local TitleText = ReviewConfig.ReviewName and GText(ReviewConfig.ReviewName) or ""
  if self.Text_NormalTitle then
    self.Text_NormalTitle:SetText(TitleText)
  end
  if self.Text_EndTitle then
    self.Text_EndTitle:SetText(TitleText)
  end
  local DescText = ""
  if ReviewConfig.DisplayText then
    DescText = ReviewConfig.DisplayText
  elseif ReviewConfig.ReviewContent then
    DescText = GText(ReviewConfig.ReviewContent)
  end
  if self.Text_Desc then
    self.Text_Desc:SetText(DescText)
  end
  local BtnJump = self.Btn_Jump
  if BtnJump and BtnJump.Text_Btn then
    BtnJump.Text_Btn:SetText(GText("UI_QUEST_TRACK"))
  end
  local ReviewItemWidget = self:GetReviewItemWidgetByType(ReviewConfig.ReviewType)
  if ReviewItemWidget then
    if ReviewItemWidget.RefreshReviewItemState then
      ReviewItemWidget:RefreshReviewItemState(self.Content)
    end
    if ReviewItemWidget.SetReviewItemImage then
      ReviewItemWidget:SetReviewItemImage(self.Content)
    end
    if ReviewItemWidget.RefreshReviewItemClickable then
      ReviewItemWidget:RefreshReviewItemClickable(false)
    end
  end
  self:RefreshReviewPopupTitle(ReviewConfig, ReviewItemWidget)
  self:RefreshDescState(ReviewConfig, ReviewItemWidget)
  self:RefreshPopupKeyTipsDelayed()
end

function M:GetReviewItemWidgetByType(ReviewType)
  if 2 == ReviewType then
    return self.LineItem02
  end
  if 3 == ReviewType then
    return self.LineItem03
  end
  return self.LineItem01
end

function M:ResolveQuestChainSubRegionId(QuestChainId)
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar or not QuestChainId then
    return 0
  end
  local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
  local DoingQuestId = QuestChain and QuestChain.DoingQuestId
  if not DoingQuestId or DoingQuestId <= 0 then
    return 0
  end
  if not MissionIndicatorManager or not MissionIndicatorManager.GetTargetTaskSubRegionId then
    return 0
  end
  return MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, DoingQuestId) or 0
end

function M:BindCheckShowMapForTrace()
  if self.bListeningCheckShowMapForTrace then
    return
  end
  self.bListeningCheckShowMapForTrace = true
  EventManager:AddEvent(EventID.CheckShowMap, self, self.OnCheckShowMapAfterTrace)
end

function M:UnbindCheckShowMapForTrace()
  if not self.bListeningCheckShowMapForTrace then
    return
  end
  self.bListeningCheckShowMapForTrace = false
  EventManager:RemoveEvent(EventID.CheckShowMap, self)
  self.PendingTraceQuestChainId = nil
  self.PendingTraceSubRegionId = nil
end

function M:OnCheckShowMapAfterTrace(QuestChainId)
  if self.PendingTraceQuestChainId and QuestChainId and QuestChainId ~= self.PendingTraceQuestChainId then
    return
  end
  local PendingQuestChainId = self.PendingTraceQuestChainId or QuestChainId
  local TargetSubRegionId = self.PendingTraceSubRegionId or 0
  self:UnbindCheckShowMapForTrace()
  if not IsValid(self) or self.IsMarkToRemove or self.bPopupClosing then
    return
  end
  self:TryShowLevelMapAfterTrack(PendingQuestChainId, TargetSubRegionId)
end

function M:ClosePopupBeforeOpenLevelMap()
  if not IsValid(self) or self.IsMarkToRemove then
    return
  end
  local Content = self.Content
  local OwnerLine = Content and Content.OwnerLine
  if OwnerLine and IsValid(OwnerLine) then
    OwnerLine.bPendingReopenPopupAfterLevelMap = true
    OwnerLine.PendingReopenPopupContent = Content
  end
  self.bSkipRestoreFocusOnClose = true
  self.bPopupClosing = true
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self:RealClose()
end

function M:TryShowLevelMapAfterTrack(QuestChainId, TargetSubRegionId)
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar then
    self:Close()
    return
  end
  local RegionAction = InvestigationWallUtils.ResolveQuestTrackRegionAction(Avatar, QuestChainId, TargetSubRegionId)
  if RegionAction == InvestigationWallUtils.QuestTrackRegionAction.SameRegion then
    EventManager:FireEvent(EventID.OnSetQuestTracking, QuestChainId)
    EventManager:FireEvent(EventID.PlayLoopAnimAfterBarAnim)
    self:Close()
    return
  end
  if RegionAction == InvestigationWallUtils.QuestTrackRegionAction.CrossRegion then
    local CachedTargetSubRegionId = TargetSubRegionId
    if nil == CachedTargetSubRegionId or CachedTargetSubRegionId <= 0 then
      local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
      CachedTargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, QuestChain and QuestChain.DoingQuestId) or 0
    end
    local CachedQuestChainId = QuestChainId
    local UIMgr = UIManager(self)
    self:ClosePopupBeforeOpenLevelMap()
    local MainMap = UIMgr:LoadUINew("LevelMapMain", true)
    if not MainMap then
      return
    end
    if MainMap.RealWildMap and MainMap.RealWildMap.ChangeRegionForSmartIndicator then
      MainMap.RealWildMap:ChangeRegionForSmartIndicator(CachedTargetSubRegionId, CachedQuestChainId)
    end
    return
  end
  DebugPrint("[StringBoard] TryShowLevelMapAfterTrack: unresolved RegionAction, keep Popup open, QuestChainId=", QuestChainId, "TargetSubRegionId=", TargetSubRegionId)
end

function M:ShowFairyLandDeliverPopup(TrackingQuestData, QuestChainId)
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar or not TrackingQuestData then
    return
  end
  local FairyLandRegionId = TrackingQuestData.SubRegionId
  if not FairyLandRegionId or FairyLandRegionId <= 0 then
    return
  end
  if Avatar.CurrentRegionId == FairyLandRegionId then
    return
  end
  if not DataMgr.QuestChain[QuestChainId] then
    return
  end
  local TaskName = DataMgr.QuestChain[QuestChainId].QuestChainName
  local DeliverIndex = TrackingQuestData.FairyLandDeliverIndex
  local Params = {
    ShortText = string.format(GText("UI_Prompt_QuestTrans"), GText(TaskName)),
    LeftCallbackObj = self,
    LeftCallbackFunction = function()
    end,
    RightCallbackObj = self,
    RightCallbackFunction = function()
      local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
      if IsValid(GameMode) then
        GameMode:HandleLevelDeliver(UE4.EModeType.ModeRegion, FairyLandRegionId, DeliverIndex, true)
      end
    end,
    CloseBtnCallbackObj = self,
    CloseBtnCallbackFunction = function()
    end
  }
  UIManager(self):ShowCommonPopupUI(100160, Params)
end

function M:OnClickTraceTask()
  local ReviewConfig = self:GetReviewConfig()
  local QuestChainId = ReviewConfig and ReviewConfig.QuestChainId
  if not QuestChainId or 0 == QuestChainId then
    return
  end
  if not self:CanShowJumpButton(QuestChainId) then
    return
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar then
    return
  end
  if Avatar.InSpecialQuest then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "QUEST_INSPECIALQUEST_MSG")
    return
  end
  if not TaskUtils:JudgeCanTrack() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("Quest_Tips_QuestTrackLock"))
    return
  end
  local QuestChain = Avatar.QuestChains and Avatar.QuestChains[QuestChainId]
  local DoingQuestId = QuestChain and QuestChain.DoingQuestId
  if not DoingQuestId or DoingQuestId <= 0 then
    self:Close()
    return
  end
  local TrackingQuestData = TaskUtils:GetQuestDetail(QuestChainId, DoingQuestId)
  local TargetSubRegionId = self:ResolveQuestChainSubRegionId(QuestChainId)
  if TargetSubRegionId <= 0 then
    TargetSubRegionId = Avatar.CurrentRegionId or 0
  end
  if TrackingQuestData and TrackingQuestData.IsFairyLand and TrackingQuestData.SubRegionId and TrackingQuestData.SubRegionId > 0 then
    if TargetSubRegionId > 0 then
      Avatar:SetQuestTracking(QuestChainId, TargetSubRegionId)
    end
    self:ShowFairyLandDeliverPopup(TrackingQuestData, QuestChainId)
    self:Close()
    return
  end
  if TaskUtils:GetQuestInterfaceJump(DoingQuestId) then
    if TargetSubRegionId > 0 then
      Avatar:SetQuestTracking(QuestChainId, TargetSubRegionId)
    end
    self:Close()
    PageJumpUtils:JumpToTargetPageByJumpId(TaskUtils:GetQuestInterfaceJumpId(DoingQuestId))
    return
  end
  if TargetSubRegionId <= 0 then
    self:Close()
    return
  end
  self.PendingTraceQuestChainId = QuestChainId
  self.PendingTraceSubRegionId = TargetSubRegionId
  self:BindCheckShowMapForTrace()
  Avatar:SetQuestTracking(QuestChainId, TargetSubRegionId)
end

function M:InitGamepadSettings()
  self.bIsFocusable = true
  if self.SetIsFocusable then
    self:SetIsFocusable(true)
  end
  self.bIsShowNavigateGuide = false
  if self.SetIsShowNavigateGuide then
    self:SetIsShowNavigateGuide(false)
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  self:InitJumpKeyTip()
  self:RefreshJumpKeyTipVisibility()
end

function M:InitJumpKeyTip()
  local BtnJump = self.Btn_Jump
  if BtnJump and BtnJump.Key_Btn and BtnJump.Key_Btn.CreateGamepadKey then
    BtnJump.Key_Btn:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  end
end

function M:RefreshJumpKeyTipVisibility()
  local BtnJump = self.Btn_Jump
  if not BtnJump or not BtnJump.Key_Btn then
    return
  end
  local bShowKeyTip = UIUtils.IsGamepadInput() and self.bShowJumpButton == true
  BtnJump.Key_Btn:SetVisibility(bShowKeyTip and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:HidePopupNavigateCursor()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if not GameInputModeSubsystem then
    return
  end
  if GameInputModeSubsystem.SetShowFocusedWidget then
    GameInputModeSubsystem:SetShowFocusedWidget(nil)
  end
  if GameInputModeSubsystem.SetNavigateWidgetVisibility then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
  end
end

function M:ApplyGamepadPopupFocus()
  if not UIUtils.IsGamepadInput() then
    self:HidePopupNavigateCursor()
    self:SetFocus()
    return
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  self:HidePopupNavigateCursor()
  self:SetFocus()
end

function M:RealClose()
  local Content = self.Content
  self.RestoreOwnerLine = Content and Content.OwnerLine
  self.RestorePosX = Content and Content.PosX
  self.RestorePosY = Content and Content.PosY
  if self.IsInUIMode then
    self:SetInputUIOnly(false)
    self.IsInUIMode = false
  end
  M.Super.RealClose(self)
end

function M:OnEndClose()
  if self.bSkipRestoreFocusOnClose then
    self.bSkipRestoreFocusOnClose = nil
    self.bGamepadFocusRestoredOnCloseBegin = nil
    self.RestoreOwnerLine = nil
    self.RestorePosX = nil
    self.RestorePosY = nil
    if self.SetIsDealWithVirtualAccept then
      self:SetIsDealWithVirtualAccept(false)
    end
    if UIUtils.IsGamepadInput() then
      local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
      if GameInputModeSubsystem and GameInputModeSubsystem.SetNavigateWidgetVisibility then
        GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
      end
    end
    return
  end
  InvestigationWallUtils.TryRecoverBattleHUDIfUIStackEmpty(self)
  if not UIUtils.IsGamepadInput() then
    self.bGamepadFocusRestoredOnCloseBegin = nil
    return
  end
  if self.bGamepadFocusRestoredOnCloseBegin then
    self.bGamepadFocusRestoredOnCloseBegin = nil
    self.RestoreOwnerLine = nil
    self.RestorePosX = nil
    self.RestorePosY = nil
    return
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetNavigateWidgetVisibility then
    GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
  local OwnerLine = self.RestoreOwnerLine
  self.RestoreOwnerLine = nil
  if OwnerLine and IsValid(OwnerLine) and OwnerLine.RestoreGamepadFocusAfterPopup then
    OwnerLine:RestoreGamepadFocusAfterPopup(self.RestorePosX, self.RestorePosY)
  end
  self.RestorePosX = nil
  self.RestorePosY = nil
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonTop and self:CanTraceCurrentReviewTask() then
      self:OnClickTraceTask()
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      return UIUtils.Handled
    end
    return UIUtils.Unhandled
  end
  if "Escape" == InKeyName or "Android_Back" == InKeyName then
    self:OnCloseClicked()
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonTop and self:CanTraceCurrentReviewTask() then
      self:OnClickTraceTask()
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      return UIUtils.Handled
    end
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnCloseClicked()
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:CanDescScroll()
  if self.WS_Desc and self.WS_Desc.GetActiveWidgetIndex and 0 ~= self.WS_Desc:GetActiveWidgetIndex() then
    return false
  end
  local ScrollBox = self.EMScrollBox_Desc
  if not IsValid(ScrollBox) or not ScrollBox.GetScrollOffsetOfEnd then
    return false
  end
  if ScrollBox.ForceLayoutPrepass then
    ScrollBox:ForceLayoutPrepass()
  end
  return (ScrollBox:GetScrollOffsetOfEnd() or 0) > 0
end

function M:BuildPopupBottomKeyInfo(bCanScroll)
  local BottomKeyInfo = {}
  local bIsGamepad = UIUtils.IsGamepadInput()
  if bIsGamepad and bCanScroll then
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
        }
      },
      Desc = GText("UI_Controller_Slide")
    })
  end
  if bIsGamepad then
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnCloseClicked,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnCloseClicked,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
  end
  return BottomKeyInfo
end

function M:RefreshPopupKeyTips()
  local ComKeyTips = self.Com_KeyTips
  if not ComKeyTips then
    return
  end
  local bCanScroll = UIUtils.IsGamepadInput() and self:CanDescScroll()
  local BottomKeyInfo = self:BuildPopupBottomKeyInfo(bCanScroll)
  if ComKeyTips.UpdateKeyInfo then
    ComKeyTips:UpdateKeyInfo(BottomKeyInfo)
  end
  local bShowKeyTips = BottomKeyInfo and #BottomKeyInfo > 0
  ComKeyTips:SetVisibility(bShowKeyTips and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshPopupKeyTipsDelayed()
  local ComKeyTips = self.Com_KeyTips
  if not ComKeyTips then
    return
  end
  if not UIUtils.IsGamepadInput() then
    self:RefreshPopupKeyTips()
    return
  end
  self:RefreshPopupKeyTips()
  if not self.AddTimer then
    return
  end
  self:AddTimer(0.05, function()
    if not IsValid(self) or self.bPopupClosing or self.IsMarkToRemove then
      return
    end
    self:RefreshPopupKeyTips()
  end, false, 0, "PopupDescScrollKeyTip")
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:RefreshPopupKeyTipsDelayed()
  self:RefreshJumpKeyTipVisibility()
  self:HidePopupNavigateCursor()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    if self.WS_Desc and self.WS_Desc.GetActiveWidgetIndex and 0 ~= self.WS_Desc:GetActiveWidgetIndex() then
      return UIUtils.Handled
    end
    local ScrollBox = self.EMScrollBox_Desc
    if IsValid(ScrollBox) then
      UIUtils.ScrollBoxByGamepad(ScrollBox, InAnalogInputEvent)
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
