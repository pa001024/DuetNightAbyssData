require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local SwitchToLineTextKey = "UI_SwitchToReview"
local SwitchToBoardTextKey = "UI_SwitchToClue"
local OpenSoundEventPath = "event:/ui/common/ex2_clue_open"
local OpenSoundKey = "StringBoardOpen"
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")

function M:Initialize(Initializer)
  self.bIsBoardView = true
  self.bLineWidgetLoaded = false
  self.bBoardWidgetLoaded = false
  self.bBoardCanOpenDetailKeyTip = false
  self.bBoardDetailListCanScroll = false
  self.bViewChangeAnimating = false
  self.bPlayingCloseAnimation = false
  self.bProgressRewardNavigateOverlayActive = false
  self.bIgnoreNextProgressMenuKeyUp = false
  self.bIgnoreNextFaceButtonRightKeyUp = false
  self.ReviewPageId = 1
end

function M:OnLoaded(ReviewPageId, ...)
  self.ReviewPageId = ReviewPageId or self.ReviewPageId or 1
  self:Init()
end

function M:Init()
  StringBoardReddotHelper.EnsureNodes()
  self:BindEvents()
  self:BindViewChangeNewReddotListeners()
  self:BindProgressRewardReddotListener()
  self:InitUI()
end

function M:Destruct()
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self:UnbindProgressRewardReddotListener()
  self:UnbindViewChangeNewReddotListeners()
  self:UnbindViewChangeAnimations()
  self:UnbindCloseOutAnimation()
  self:UnbindEvents()
  self.bProgressRewardNavigateOverlayActive = false
  self.bIgnoreNextProgressMenuKeyUp = false
  self.bIgnoreNextFaceButtonRightKeyUp = false
  self.ProgressRewardFocusRestore = nil
end

function M:BindViewChangeNewReddotListeners()
  StringBoardReddotHelper.EnsureNodes()
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.BoardNew, self, self.OnViewChangeNewReddotChanged)
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.LineNew, self, self.OnViewChangeNewReddotChanged)
end

function M:UnbindViewChangeNewReddotListeners()
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.BoardNew, self)
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.LineNew, self)
end

function M:BindProgressRewardReddotListener()
  StringBoardReddotHelper.EnsureNodes()
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.ProgressReward, self, self.OnProgressRewardReddotChanged)
end

function M:UnbindProgressRewardReddotListener()
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.ProgressReward, self)
end

function M:OnProgressRewardReddotChanged(Count, RdType, Name)
  self:RefreshBtnProgressRewardReddotOnly(Count, RdType)
end

function M:OnViewChangeNewReddotChanged(Count, RdType, Name)
  self:RefreshBtnChangeNewReddot()
end

function M:RefreshBtnChangeNewReddot()
  local BtnChange = self.Btn_Change
  if not BtnChange or not BtnChange.EMShowReddot then
    return
  end
  local bShow = false
  if self.bIsBoardView then
    bShow = StringBoardReddotHelper.HasLineNewsOnReviewPage(self.ReviewPageId)
  else
    bShow = StringBoardReddotHelper.HasBoardNews()
  end
  BtnChange:EMShowReddot(bShow, EReddotType.New)
end

function M:ClearGamepadNavigatePinOnClose()
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget then
    BoardWidget.bPreferSubTabGamepadCursor = false
    BoardWidget.PendingFocusSubTabListIndex = nil
    if BoardWidget.ClearSubTabNavigationLock then
      BoardWidget:ClearSubTabNavigationLock()
    end
    local TilePanel = BoardWidget.Group_Item
    if TilePanel and TilePanel.ClearFocus then
      TilePanel:ClearFocus()
    end
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem and GameInputModeSubsystem.SetShowFocusedWidget then
    GameInputModeSubsystem:SetShowFocusedWidget(nil)
  end
end

function M:RealClose()
  self:ClearPendingReopenPopupAfterLevelMap()
  self:UnloadStringBoardPopupIfExist()
  self:ClearGamepadNavigatePinOnClose()
  if self.IsInUIMode then
    self:SetInputUIOnly(false)
    self.IsInUIMode = false
  end
  M.Super.RealClose(self)
end

function M:OnEndClose()
  InvestigationWallUtils.TryRecoverBattleHUDIfUIStackEmpty(self)
end

function M:OnShow(ShowTag)
  if M.Super.OnShow then
    M.Super.OnShow(self, ShowTag)
  end
  if ShowTag ~= UIConst.CommonHideTagName.UIStackChange then
    return
  end
  self:RefreshBtnProgressReward()
  self:TryReopenPopupAfterLevelMap()
end

function M:ClearPendingReopenPopupAfterLevelMap()
  local LineWidget = self.WBP_StringBoard_Line
  if LineWidget and LineWidget.ClearPendingReopenPopupAfterLevelMap then
    LineWidget:ClearPendingReopenPopupAfterLevelMap()
  end
end

function M:UnloadStringBoardPopupIfExist()
  local UIMgr = UIManager(self)
  if not UIMgr then
    return
  end
  if UIMgr:GetUIObj("StringBoardPopup") then
    UIMgr:UnLoadUINew("StringBoardPopup")
  end
end

function M:ShouldSkipReopenPopupAfterLevelMap()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(PlayerCharacter) and PlayerCharacter.IsInDeliver then
    return true
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsValid(GameMode) and GameMode.TargetSubRegion then
    return true
  end
  return false
end

function M:OnCheckShowMapAfterQuestTrack(QuestChainId)
  if not IsValid(self) or self.IsMarkToRemove or self.IsBeginToClose then
    return
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar then
    return
  end
  local ResolvedQuestChainId = QuestChainId or Avatar.TrackingQuestChainId
  local RegionAction = InvestigationWallUtils.ResolveQuestTrackRegionAction(Avatar, ResolvedQuestChainId, nil)
  if RegionAction == InvestigationWallUtils.QuestTrackRegionAction.SameRegion then
    self:Close()
  end
end

function M:OnLevelDeliverBlackCurtainStart()
  self:ClearPendingReopenPopupAfterLevelMap()
  self:UnloadStringBoardPopupIfExist()
  if not IsValid(self) or self.IsMarkToRemove or self.IsBeginToClose then
    return
  end
  self:Close()
end

function M:TryReopenPopupAfterLevelMap()
  local LineWidget = self.WBP_StringBoard_Line
  if not LineWidget or not LineWidget.bPendingReopenPopupAfterLevelMap then
    return
  end
  if not LineWidget.ReopenPopupAfterLevelMap then
    return
  end
  if self:ShouldSkipReopenPopupAfterLevelMap() then
    self:ClearPendingReopenPopupAfterLevelMap()
    self:UnloadStringBoardPopupIfExist()
    return
  end
  LineWidget:ReopenPopupAfterLevelMap()
end

function M:BindEvents()
  EventManager:AddEvent(EventID.CheckShowMap, self, self.OnCheckShowMapAfterQuestTrack)
  EventManager:AddEvent(EventID.OnLevelDeliverBlackCurtainStart, self, self.OnLevelDeliverBlackCurtainStart)
  local BtnChange = self.Btn_Change
  if BtnChange and BtnChange.Btn_Click and BtnChange.Btn_Click.OnClicked then
    BtnChange.Btn_Click.OnClicked:Clear()
    BtnChange.Btn_Click.OnClicked:Add(self, self.OnBtnChangeClicked)
  end
  local BtnProgress = self.Btn_Progress
  if BtnProgress and BtnProgress.Btn_Click and BtnProgress.Btn_Click.OnClicked then
    BtnProgress.Btn_Click.OnClicked:Clear()
    BtnProgress.Btn_Click.OnClicked:Add(self, self.OnBtnProgressClicked)
  end
end

function M:UnbindEvents()
  EventManager:RemoveEvent(EventID.CheckShowMap, self)
  EventManager:RemoveEvent(EventID.OnLevelDeliverBlackCurtainStart, self)
  local BtnChange = self.Btn_Change
  if BtnChange and BtnChange.Btn_Click and BtnChange.Btn_Click.OnClicked then
    BtnChange.Btn_Click.OnClicked:Remove(self, self.OnBtnChangeClicked)
  end
  local BtnProgress = self.Btn_Progress
  if BtnProgress and BtnProgress.Btn_Click and BtnProgress.Btn_Click.OnClicked then
    BtnProgress.Btn_Click.OnClicked:Remove(self, self.OnBtnProgressClicked)
  end
end

function M:InitUI()
  self:InitComTab()
  self:InitBoard()
  self:InitLine()
  self:InitGamePad()
  self:InitBasicUI()
  StringBoardReddotHelper.SyncProgressRewardReddot()
  self:RefreshBtnProgressReward()
  self:PlayOpenAnimation()
end

function M:InitBoard()
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget then
    BoardWidget.OwnerStringBoard = self
  end
  self:EnsureChildWidgetLoaded(BoardWidget, "bBoardWidgetLoaded")
end

function M:InitLine()
  local LineWidget = self.WBP_StringBoard_Line
  if LineWidget then
    LineWidget.OwnerStringBoard = self
  end
  self:EnsureChildWidgetLoaded(LineWidget, "bLineWidgetLoaded", self.ReviewPageId)
end

function M:InitComTab()
  local ComTab = self.Com_Tab
  if not ComTab or not ComTab.Init then
    return
  end
  ComTab:Init({
    DynamicNode = {"Back", "BottomKey"},
    LeftKey = "NotShow",
    RightKey = "NotShow",
    TitleName = GText("UI_StringBoard"),
    BottomKeyInfo = self:BuildBoardBottomKeyInfo(self.bBoardCanOpenDetailKeyTip),
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.OnBackOrEscape
  }, true)
  self:HideComTabTopChrome()
end

function M:HideComTabTopChrome()
  local ComTab = self.Com_Tab
  if not ComTab then
    return
  end
  if ComTab.Bg_Top then
    ComTab.Bg_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if ComTab.BackgroundBlur_Top then
    ComTab.BackgroundBlur_Top:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if ComTab.Com_BarBg then
    ComTab.Com_BarBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetBoardCanOpenDetailKeyTip(bCanOpenDetail)
  local bNewCanOpenDetail = bCanOpenDetail and true or false
  if self.bBoardCanOpenDetailKeyTip == bNewCanOpenDetail then
    return
  end
  self.bBoardCanOpenDetailKeyTip = bNewCanOpenDetail
  if not self.bIsBoardView then
    return
  end
  self:RefreshComTabBottomKeyInfo()
end

function M:SetBoardDetailListScrollKeyTip(bCanScroll)
  local bNewCanScroll = bCanScroll and true or false
  if self.bBoardDetailListCanScroll == bNewCanScroll then
    return
  end
  self.bBoardDetailListCanScroll = bNewCanScroll
  if not self.bIsBoardView then
    return
  end
  self:RefreshComTabBottomKeyInfo()
end

function M:BuildBoardBottomKeyInfo(bCanOpenDetail)
  local BottomKeyInfo = {}
  if self.bBoardDetailListCanScroll then
    table.insert(BottomKeyInfo, {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
        }
      },
      Desc = GText("UI_Controller_Slide")
    })
  elseif bCanOpenDetail then
    table.insert(BottomKeyInfo, {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_Check")
    })
  end
  local BackKeyInfo = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnBackOrEscape,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  }
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    BackKeyInfo.KeyInfoList = {
      {
        Type = "Text",
        Text = "Esc",
        ClickCallback = self.OnBackOrEscape,
        Owner = self
      }
    }
  end
  table.insert(BottomKeyInfo, BackKeyInfo)
  return BottomKeyInfo
end

function M:BuildLineBottomKeyInfo()
  local BackKeyInfo = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = self.OnBackOrEscape,
        Owner = self
      }
    },
    Desc = GText("UI_BACK")
  }
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    BackKeyInfo.KeyInfoList = {
      {
        Type = "Text",
        Text = "Esc",
        ClickCallback = self.OnBackOrEscape,
        Owner = self
      }
    }
  end
  return {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumbNormal
        }
      },
      Desc = GText("UI_CTL_Move")
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_Check")
    },
    BackKeyInfo
  }
end

function M:RefreshComTabBottomKeyInfo()
  local ComTab = self.Com_Tab
  if not ComTab or not ComTab.UpdateBottomKeyInfo then
    return
  end
  if self.bIsBoardView then
    ComTab:UpdateBottomKeyInfo(self:BuildBoardBottomKeyInfo(self.bBoardCanOpenDetailKeyTip))
  else
    ComTab:UpdateBottomKeyInfo(self:BuildLineBottomKeyInfo())
  end
end

function M:InitBasicUI()
  self.bIsBoardView = true
  self:RefreshContentView()
  self:InitTitle()
end

function M:InitTitle()
  local TitleWidget = self.Title
  if not TitleWidget or not TitleWidget.Text_Title then
    return
  end
  local ReviewPageId = self.ReviewPageId or 1
  local ReviewPageData = DataMgr.ReviewPage and DataMgr.ReviewPage[ReviewPageId]
  local EpisodeName = ReviewPageData and ReviewPageData.EpisodeName
  if EpisodeName then
    TitleWidget.Text_Title:SetText(GText(EpisodeName))
  else
    TitleWidget.Text_Title:SetText("")
  end
end

function M:EnsureChildWidgetLoaded(ChildWidget, LoadedFlagName, ...)
  if not ChildWidget or self[LoadedFlagName] then
    return
  end
  self[LoadedFlagName] = true
  if ChildWidget.Init then
    ChildWidget:Init(...)
  end
end

function M:RefreshContentView()
  local LineWidget = self.WBP_StringBoard_Line
  local BoardWidget = self.WBP_StringBoard_Board
  if self.bIsBoardView then
    self:ApplyBoardViewFinalVisibility()
    if BoardWidget and BoardWidget.RefreshInitialState then
      BoardWidget:RefreshInitialState()
    end
  else
    self:ApplyLineViewFinalVisibility()
    if LineWidget and LineWidget.RefreshInitialState then
      LineWidget:RefreshInitialState()
    end
  end
  self:RefreshBtnChangeText()
  self:RefreshBtnChangeIcon()
  self:RefreshBtnChangeVisibility()
  self:RefreshBtnChangeNewReddot()
  self.bBoardCanOpenDetailKeyTip = false
  self.bBoardDetailListCanScroll = false
  self:RefreshComTabBottomKeyInfo()
  self:FocusContentView()
end

function M:SetWidgetRenderOpacity(Widget, Opacity)
  if Widget and Widget.SetRenderOpacity then
    Widget:SetRenderOpacity(Opacity)
  end
end

function M:ApplyLineViewFinalVisibility()
  local LineWidget = self.WBP_StringBoard_Line
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget then
    if BoardWidget.CancelClueItemInStagger then
      BoardWidget:CancelClueItemInStagger()
    end
    BoardWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetWidgetRenderOpacity(BoardWidget, 0)
  end
  if LineWidget then
    LineWidget:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:SetWidgetRenderOpacity(self.Image_Mask, 0)
end

function M:ApplyBoardViewFinalVisibility()
  local LineWidget = self.WBP_StringBoard_Line
  local BoardWidget = self.WBP_StringBoard_Board
  if LineWidget then
    if LineWidget.CancelLineItemInStagger then
      LineWidget:CancelLineItemInStagger()
    end
    LineWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if BoardWidget then
    BoardWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    self:SetWidgetRenderOpacity(BoardWidget, 1)
  end
end

function M:PrepareViewChangeShellChrome()
  self:RefreshBtnChangeText()
  self:RefreshBtnChangeIcon()
  self:RefreshBtnChangeVisibility()
  self:RefreshBtnChangeNewReddot()
  self.bBoardCanOpenDetailKeyTip = false
  self.bBoardDetailListCanScroll = false
  self:RefreshComTabBottomKeyInfo()
end

function M:StopViewChangeShellAnimations()
  if self.Change_In and self.StopAnimation then
    self:StopAnimation(self.Change_In)
  end
  if self.Change_Out and self.StopAnimation then
    self:StopAnimation(self.Change_Out)
  end
end

function M:FocusContentView()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.bIsBoardView then
    local BoardWidget = self.WBP_StringBoard_Board
    if BoardWidget and BoardWidget.FocusToCurrentSelectionForGamepad then
      BoardWidget:FocusToCurrentSelectionForGamepad()
      return
    end
    if BoardWidget and BoardWidget.FocusDefaultForGamepad then
      BoardWidget:FocusDefaultForGamepad()
    end
    return
  end
  local LineWidget = self.WBP_StringBoard_Line
  if LineWidget and LineWidget.FocusDefaultForGamepad then
    LineWidget:FocusDefaultForGamepad()
  end
end

function M:SetFocus_Lua()
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:FocusToCurrentSelectionForGamepad()
end

function M:FocusToCurrentSelectionForGamepad()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.bIsBoardView then
    local BoardWidget = self.WBP_StringBoard_Board
    if BoardWidget and BoardWidget.FocusToCurrentSelectionForGamepad then
      BoardWidget:FocusToCurrentSelectionForGamepad()
      return
    end
    self:FocusContentView()
    return
  end
  local LineWidget = self.WBP_StringBoard_Line
  if LineWidget and LineWidget.FocusToCurrentSelectionForGamepad then
    LineWidget:FocusToCurrentSelectionForGamepad()
    return
  end
  self:FocusContentView()
end

function M:RefreshBtnChangeText()
  local BtnChange = self.Btn_Change
  if not BtnChange or not BtnChange.Text_LineBtn then
    return
  end
  local TextKey = self.bIsBoardView and SwitchToLineTextKey or SwitchToBoardTextKey
  if "" ~= TextKey then
    BtnChange.Text_LineBtn:SetText(GText(TextKey))
  else
    BtnChange.Text_LineBtn:SetText("")
  end
end

function M:RefreshBtnChangeIcon()
  local BtnChange = self.Btn_Change
  if not BtnChange or not BtnChange.WS_Icon then
    return
  end
  BtnChange.WS_Icon:SetActiveWidgetIndex(self.bIsBoardView and 0 or 1)
end

function M:IsLineFirstColumnShowable()
  local ReviewPageId = InvestigationWallUtils.ResolveReviewPageId(self.ReviewPageId)
  if not ReviewPageId then
    return false
  end
  local PageData = DataMgr.ReviewPage and DataMgr.ReviewPage[ReviewPageId]
  local SequenceIds = PageData and PageData.ReviewChainSequence
  local FirstSequenceId = SequenceIds and SequenceIds[1]
  if not FirstSequenceId then
    return false
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar or not Avatar.IsReviewChainSequenceShow then
    return false
  end
  return Avatar:IsReviewChainSequenceShow(FirstSequenceId)
end

function M:RefreshBtnChangeVisibility()
  local BtnChange = self.Btn_Change
  if not BtnChange then
    return
  end
  local bShow = not self.bIsBoardView or self:IsLineFirstColumnShowable()
  BtnChange:SetVisibility(bShow and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:OnBtnChangeClicked()
  if self.bViewChangeAnimating or self.bPlayingCloseAnimation or self.IsBeginToClose then
    return
  end
  if self.bIsBoardView and not self:IsLineFirstColumnShowable() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_story_btn_click", nil, nil)
  AudioManager(self):PlayUISound(self, "event:/ui/common/cine_review_sub_page_in", nil, nil)
  self:HideClueDetailIfShowing()
  local bSwitchToBoard = not self.bIsBoardView
  self.bIsBoardView = not self.bIsBoardView
  if bSwitchToBoard then
    self:PlayChangeToBoardAnimation()
  else
    self:PlayChangeToLineAnimation()
  end
end

function M:PlayOpenAnimation()
  AudioManager(self):PlayUISound(self, OpenSoundEventPath, OpenSoundKey, nil)
  if not self.In or not self.PlayAnimation then
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) then
    return
  end
  self:PlayAnimation(self.In)
end

function M:UnbindViewChangeAnimations()
  if self.Change_In and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Change_In)
  end
  if self.Change_Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Change_Out)
  end
  self.bViewChangeAnimating = false
end

function M:UnbindCloseOutAnimation()
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self.bPlayingCloseAnimation = false
end

function M:OnViewChangeAnimationFinished()
  if self.bIsBoardView then
    self:ApplyBoardViewFinalVisibility()
  else
    self:ApplyLineViewFinalVisibility()
  end
  self:UnbindViewChangeAnimations()
end

function M:PlayChangeToBoardAnimation()
  self:UnbindViewChangeAnimations()
  self:StopViewChangeShellAnimations()
  self.bViewChangeAnimating = true
  local LineWidget = self.WBP_StringBoard_Line
  local BoardWidget = self.WBP_StringBoard_Board
  if LineWidget then
    if LineWidget.CancelLineItemInStagger then
      LineWidget:CancelLineItemInStagger()
    end
    LineWidget:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if BoardWidget then
    BoardWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    self:SetWidgetRenderOpacity(BoardWidget, 0)
  end
  self:PrepareViewChangeShellChrome()
  if not self.Change_Out or not self.PlayAnimation then
    self:ApplyBoardViewFinalVisibility()
    self.bViewChangeAnimating = false
    self:FocusContentView()
    return
  end
  self:FocusContentView()
  self:BindToAnimationFinished(self.Change_Out, {
    self,
    self.OnViewChangeAnimationFinished
  })
  self:PlayAnimation(self.Change_Out)
end

function M:PlayChangeToLineAnimation()
  self:UnbindViewChangeAnimations()
  self:StopViewChangeShellAnimations()
  self.bViewChangeAnimating = true
  local LineWidget = self.WBP_StringBoard_Line
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget and BoardWidget.CancelClueItemInStagger then
    BoardWidget:CancelClueItemInStagger()
  end
  if BoardWidget then
    BoardWidget:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if LineWidget then
    if LineWidget.PlayLineItemInStaggerFromBoardSwitch then
      LineWidget:PlayLineItemInStaggerFromBoardSwitch()
    end
    LineWidget:SetVisibility(UIConst.VisibilityOp.Visible)
    if LineWidget.RefreshInitialState then
      LineWidget:RefreshInitialState()
    end
  end
  self:PrepareViewChangeShellChrome()
  if not self.Change_In or not self.PlayAnimation then
    self:ApplyLineViewFinalVisibility()
    self.bViewChangeAnimating = false
    self:FocusContentView()
    return
  end
  self:FocusContentView()
  self:BindToAnimationFinished(self.Change_In, {
    self,
    self.OnViewChangeAnimationFinished
  })
  self:PlayAnimation(self.Change_In)
end

function M:OnCloseOutAnimationFinished()
  self:UnbindCloseOutAnimation()
  M.Super.Close(self)
end

function M:Close()
  if self.bPlayingCloseAnimation or self.IsBeginToClose then
    return
  end
  if not self.IsInit then
    M.Super.Close(self)
    return
  end
  AudioManager(self):SetEventSoundParam(self, OpenSoundKey, {ToEnd = 1})
  self:UnbindViewChangeAnimations()
  self:StopViewChangeShellAnimations()
  if self.WBP_StringBoard_Board and self.WBP_StringBoard_Board.CancelClueItemInStagger then
    self.WBP_StringBoard_Board:CancelClueItemInStagger()
  end
  if self.WBP_StringBoard_Line and self.WBP_StringBoard_Line.CancelLineItemInStagger then
    self.WBP_StringBoard_Line:CancelLineItemInStagger()
  end
  if not self.Out or not self.PlayAnimation then
    M.Super.Close(self)
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.Out) then
    return
  end
  self.bPlayingCloseAnimation = true
  if self.In and self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnCloseOutAnimationFinished
  })
  self:PlayAnimation(self.Out)
end

function M:OnBtnProgressClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
  self:OpenProgressRewardPopup()
end

function M:RefreshBtnProgressRewardReddotOnly(Count, RdType)
  local BtnProgress = self.Btn_Progress
  local Reddot = BtnProgress and BtnProgress.Reddot
  if not Reddot or not Reddot.EMShowReddot then
    return
  end
  if nil == Count then
    Count = StringBoardReddotHelper.GetLeafCount(StringBoardReddotHelper.NodeName.ProgressReward)
  end
  Reddot:EMShowReddot(Count > 0, RdType or EReddotType.Normal)
end

function M:RefreshBtnProgressReward()
  local BtnProgress = self.Btn_Progress
  if not BtnProgress then
    return
  end
  local FinishedCount, MaxClueTargetNum = InvestigationWallUtils.GetProgressRewardProgressNums(InvestigationWallUtils.GetAvatarSafe())
  local TextLine = BtnProgress.Text_Line
  if TextLine and TextLine.SetText then
    TextLine:SetText(GText("UI_StringBoard_Process"))
  end
  local TextNum = BtnProgress.Text_Num
  if TextNum and TextNum.SetText then
    TextNum:SetText(string.format("%d/%d", FinishedCount, MaxClueTargetNum))
  end
  self:RefreshBtnProgressRewardReddotOnly()
end

function M:HideShellNavigateCursor()
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

function M:RefreshNavigateCursorWhileProgressRewardOpen()
  if not self.bProgressRewardNavigateOverlayActive then
    return
  end
  self:HideShellNavigateCursor()
end

function M:ApplyGamepadWhileProgressRewardOpen()
  self.bProgressRewardNavigateOverlayActive = true
  if not UIUtils.IsGamepadInput() then
    self.ProgressRewardFocusRestore = nil
    self:HideShellNavigateCursor()
    return
  end
  self:CaptureGamepadFocusBeforeProgressReward()
  self:ReleaseDetailGamepadCaptureForProgressReward()
  self:HideShellNavigateCursor()
end

function M:ReleaseDetailGamepadCaptureForProgressReward()
  local BoardWidget = self.WBP_StringBoard_Board
  if not (BoardWidget and BoardWidget.IsClueDetailShowing) or not BoardWidget:IsClueDetailShowing() then
    return
  end
  local BoardDetail = BoardWidget.Board_Detail
  if BoardDetail and BoardDetail.ClearGamepadDetailFocus then
    BoardDetail:ClearGamepadDetailFocus()
  end
end

function M:CaptureGamepadFocusBeforeProgressReward()
  self.ProgressRewardFocusRestore = nil
  if self.bIsBoardView then
    local BoardWidget = self.WBP_StringBoard_Board
    if not BoardWidget then
      return
    end
    if BoardWidget.IsClueDetailShowing and BoardWidget:IsClueDetailShowing() then
      self.ProgressRewardFocusRestore = {
        View = "Board",
        Kind = "Detail",
        X = BoardWidget.RestoreDetailFocusX or BoardWidget.LastFocusedClueTileX,
        Y = BoardWidget.RestoreDetailFocusY or BoardWidget.LastFocusedClueTileY
      }
      return
    end
    if BoardWidget.bPreferSubTabGamepadCursor then
      self.ProgressRewardFocusRestore = {
        View = "Board",
        Kind = "SubTab",
        SubTabListIndex = (BoardWidget.SelectedClueListIndex or 1) - 1
      }
      return
    end
    self.ProgressRewardFocusRestore = {
      View = "Board",
      Kind = "Tile",
      X = BoardWidget.LastFocusedClueTileX,
      Y = BoardWidget.LastFocusedClueTileY
    }
    return
  end
  local LineWidget = self.WBP_StringBoard_Line
  if not LineWidget then
    return
  end
  self.ProgressRewardFocusRestore = {
    View = "Line",
    Kind = "Tile",
    X = LineWidget.LastFocusedLineTileX,
    Y = LineWidget.LastFocusedLineTileY
  }
end

function M:RestoreGamepadAfterProgressRewardClose()
  self.bProgressRewardNavigateOverlayActive = false
  local Restore = self.ProgressRewardFocusRestore
  self.ProgressRewardFocusRestore = nil
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget and BoardWidget.IsClueDetailShowing and BoardWidget:IsClueDetailShowing() then
    if BoardWidget.ApplyGamepadWhileDetailOpen then
      BoardWidget:ApplyGamepadWhileDetailOpen()
    elseif BoardWidget.HideGamepadNavigateCursor then
      BoardWidget:HideGamepadNavigateCursor()
    else
      self:HideShellNavigateCursor()
    end
    if not UIUtils.IsGamepadInput() then
      return
    end
  elseif UIUtils.IsGamepadInput() then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem and GameInputModeSubsystem.SetNavigateWidgetVisibility then
      GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
    end
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  if not Restore then
    self:FocusContentView()
    return
  end
  if Restore.View == "Board" then
    BoardWidget = self.WBP_StringBoard_Board
    if not BoardWidget then
      return
    end
    if Restore.Kind == "Detail" then
      if BoardWidget.IsClueDetailShowing and BoardWidget:IsClueDetailShowing() and BoardWidget.ApplyGamepadWhileDetailOpen then
        BoardWidget:ApplyGamepadWhileDetailOpen()
        return
      end
      if BoardWidget.RestoreGamepadFocusAfterProgressReward then
        BoardWidget:RestoreGamepadFocusAfterProgressReward(Restore.X, Restore.Y)
      end
      return
    end
    if Restore.Kind == "SubTab" and BoardWidget.FocusTargetSubTabAfterSwitch then
      BoardWidget:FocusTargetSubTabAfterSwitch(Restore.SubTabListIndex or 0)
      return
    end
    if Restore.Kind == "Tile" and BoardWidget.RestoreGamepadFocusAfterProgressReward then
      BoardWidget:RestoreGamepadFocusAfterProgressReward(Restore.X, Restore.Y)
      return
    end
    self:FocusContentView()
    return
  end
  local LineWidget = self.WBP_StringBoard_Line
  if LineWidget and LineWidget.RestoreGamepadFocusAfterPopup then
    LineWidget:RestoreGamepadFocusAfterPopup(Restore.X, Restore.Y)
    return
  end
  self:FocusContentView()
end

function M:OnProgressRewardPopupClosed()
  self:RestoreGamepadAfterProgressRewardClose()
end

function M:OnProgressRewardPopupKeyDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == Const.GamepadFaceButtonRight then
    self.bIgnoreNextFaceButtonRightKeyUp = true
  end
end

function M:EnsureProgressRewardPopupGamepadFocus(PopupUI)
  if not (UIUtils.IsGamepadInput() and PopupUI) or not IsValid(PopupUI) then
    return
  end
  local RewardContent = PopupUI.GetContentWidgetByName and PopupUI:GetContentWidgetByName("Common_Reward")
  if RewardContent and RewardContent.List_Item and RewardContent.List_Item.SetFocus then
    RewardContent.List_Item:SetFocus()
    return true
  end
  if PopupUI.SetFocus then
    PopupUI:SetFocus()
    return true
  end
  return false
end

function M:RestoreProgressRewardDialogGamepadFocus(DialogWidget)
  if not IsValid(self) then
    return
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  if not DialogWidget or not IsValid(DialogWidget) then
    return
  end
  
  local function ApplyFocus()
    if not IsValid(self) or not IsValid(DialogWidget) then
      return
    end
    if DialogWidget.List_Item and DialogWidget.List_Item.SetFocus then
      DialogWidget.List_Item:SetFocus()
    end
    if DialogWidget.NavigateToFirstDisplayedItem and DialogWidget.List_Item then
      DialogWidget:NavigateToFirstDisplayedItem(DialogWidget.List_Item)
    end
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem and GameInputModeSubsystem.UpdateCurrentFocusWidgetPos then
      GameInputModeSubsystem:UpdateCurrentFocusWidgetPos()
    end
  end
  
  if self.AddTimer then
    self:AddTimer(0.01, ApplyFocus, false, 0, "RestoreProgressRewardDialogFocus", true)
    return
  end
  ApplyFocus()
end

function M:OpenProgressRewardPopup()
  self:ApplyGamepadWhileProgressRewardOpen()
  local ConfigData = InvestigationWallUtils.BuildProgressRewardPopupConfigData(InvestigationWallUtils.GetAvatarSafe(), self)
  local Params = {
    Title = GText("UI_StringBoard_Reward"),
    ConfigData = ConfigData,
    DontFocusParentWidget = true,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnProgressRewardPopupClosed,
    OnKeyDownCallbackObj = self,
    OnKeyDownCallbackFunction = self.OnProgressRewardPopupKeyDown
  }
  local PopupUI = UIManager(self):ShowCommonPopupUI(100158, Params, self)
  self:EnsureProgressRewardPopupGamepadFocus(PopupUI)
end

function M:OnProgressRewardReceive(Content)
  if not (Content and Content.ConfigData) or not Content.ConfigData.ReceiveParm then
    return
  end
  local SortId = Content.ConfigData.ReceiveParm.SortId
  if not SortId then
    return
  end
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar or not Avatar.GetClueReward then
    return
  end
  local DialogWidget = Content.Owner
  Avatar:GetClueReward(SortId, function(ErrCode, Rewards)
    DebugPrint("[StringBoard] GetClueReward callback, SortId=", SortId, " ErrCode=", ErrCode)
    if not IsValid(self) then
      return
    end
    if not ErrorCode:Check(ErrCode) then
      DebugPrint("[StringBoard] GetClueReward failed, SortId=", SortId, " ErrCode=", ErrCode)
      return
    end
    InvestigationWallUtils.MarkProgressRewardClaimedLocally(SortId)
    StringBoardReddotHelper.SyncProgressRewardReddot()
    self:RefreshProgressRewardDialog(DialogWidget)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      if not IsValid(self) then
        return
      end
      self:RestoreProgressRewardDialogGamepadFocus(DialogWidget)
    end, DialogWidget)
  end)
end

function M:OnProgressRewardReceiveAll(DialogWidget, ReceiveAllParam)
  DialogWidget = DialogWidget or ReceiveAllParam and ReceiveAllParam.SelfWidget
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  if not Avatar or not Avatar.GetAllClueReward then
    self:RefreshProgressRewardDialog(DialogWidget)
    return
  end
  Avatar:GetAllClueReward(function(ErrCode, Rewards)
    DebugPrint("[StringBoard] GetAllClueReward callback, ErrCode=", ErrCode)
    if not IsValid(self) then
      return
    end
    if not ErrorCode:Check(ErrCode) then
      DebugPrint("[StringBoard] GetAllClueReward failed, ErrCode=", ErrCode)
      self:RefreshProgressRewardDialog(DialogWidget)
      return
    end
    InvestigationWallUtils.MarkAllClaimableProgressRewardsLocally(Avatar)
    StringBoardReddotHelper.SyncProgressRewardReddot()
    self:RefreshProgressRewardDialog(DialogWidget)
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      if not IsValid(self) then
        return
      end
      self:RestoreProgressRewardDialogGamepadFocus(DialogWidget)
    end, DialogWidget)
  end)
end

function M:RefreshProgressRewardDialog(DialogWidget)
  self:RefreshBtnProgressReward()
  if not DialogWidget or not IsValid(DialogWidget) then
    return
  end
  local ConfigData = InvestigationWallUtils.BuildProgressRewardPopupConfigData(InvestigationWallUtils.GetAvatarSafe(), self)
  if DialogWidget.Refresh then
    DialogWidget:Refresh(ConfigData)
  end
  if DialogWidget.RefreshButton then
    local HasRewardToGet = false
    for _, Item in ipairs(ConfigData.Items or {}) do
      if Item.CanReceive and not Item.RewardsGot then
        HasRewardToGet = true
        break
      end
    end
    DialogWidget:RefreshButton(HasRewardToGet)
  end
end

function M:HideClueDetailIfShowing()
  local BoardWidget = self.WBP_StringBoard_Board
  if BoardWidget and BoardWidget.IsClueDetailShowing and BoardWidget:IsClueDetailShowing() then
    BoardWidget:HideClueDetail()
    return true
  end
  return false
end

function M:OnBackOrEscape()
  if self.bPlayingCloseAnimation or self.IsBeginToClose then
    return
  end
  if self:HideClueDetailIfShowing() then
    return
  end
  if not self.IsBeginToClose and self.IsInit then
    self:Close()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  if ("Escape" == InKeyName or "Android_Back" == InKeyName) and self.IsAllowEscape then
    self:OnBackOrEscape()
    return UIUtils.Handled
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamePadKeyUp(InKeyName) then
    return UIUtils.Handled
  end
  if M.Super.OnKeyUp then
    return M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:InitGamePad()
  self:ForbidShellWidgetFocus()
  self:InitShellKeyTips()
  self:RefreshShellKeyTipsVisibility(UIUtils.IsGamepadInput())
  self.bIgnoreNextProgressMenuKeyUp = true
end

function M:ForbidShellWidgetFocus()
  self:SetWidgetFocusable(self.Btn_Change, false)
  self:SetWidgetFocusable(self.Btn_Progress, false)
  self:SetWidgetFocusable(self.Title, false)
  self:SetWidgetFocusable(self.Com_Tab, false)
  local ComTab = self.Com_Tab
  if ComTab then
    self:SetWidgetFocusable(ComTab.BackWidget, false)
    self:SetWidgetFocusable(ComTab.Panel_Back, false)
    if ComTab.BackWidget and ComTab.BackWidget.Btn_Back then
      self:SetWidgetFocusable(ComTab.BackWidget.Btn_Back, false)
    end
  end
  local BtnChange = self.Btn_Change
  if BtnChange then
    self:SetWidgetFocusable(BtnChange.Btn_Click, false)
    self:SetWidgetFocusable(BtnChange.Key_Btn, false)
  end
  local BtnProgress = self.Btn_Progress
  if BtnProgress then
    self:SetWidgetFocusable(BtnProgress.Btn_Click, false)
    self:SetWidgetFocusable(BtnProgress.Key_Btn, false)
    self:SetWidgetFocusable(BtnProgress.Panel_Reddot, false)
    self:SetWidgetFocusable(BtnProgress.Reddot, false)
  end
end

function M:SetWidgetFocusable(Widget, bFocusable)
  if not Widget then
    return
  end
  Widget.bIsFocusable = bFocusable
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(bFocusable)
  end
end

function M:InitShellKeyTips()
  local BtnChange = self.Btn_Change
  if BtnChange and BtnChange.Key_Btn and BtnChange.Key_Btn.CreateGamepadKey then
    BtnChange.Key_Btn:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  end
  local BtnProgress = self.Btn_Progress
  if BtnProgress and BtnProgress.Key_Btn and BtnProgress.Key_Btn.CreateGamepadKey then
    BtnProgress.Key_Btn:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  end
end

function M:RefreshShellKeyTipsVisibility(bIsGamepad)
  local Visibility = bIsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  local BtnChange = self.Btn_Change
  if BtnChange and BtnChange.Key_Btn then
    BtnChange.Key_Btn:SetVisibility(Visibility)
  end
  local BtnProgress = self.Btn_Progress
  if BtnProgress and BtnProgress.Key_Btn then
    BtnProgress.Key_Btn:SetVisibility(Visibility)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:ForbidShellWidgetFocus()
  self:RefreshShellKeyTipsVisibility(CurInputType == ECommonInputType.Gamepad)
  self:RefreshNavigateCursorWhileProgressRewardOpen()
end

function M:HandleGamePadKeyDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonTop or InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.SpecialRight then
    return true
  end
  return false
end

function M:HandleGamePadKeyUp(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnBtnChangeClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.bIgnoreNextFaceButtonRightKeyUp then
      self.bIgnoreNextFaceButtonRightKeyUp = false
      return true
    end
    if self.bIsBoardView then
      local BoardWidget = self.WBP_StringBoard_Board
      if BoardWidget and BoardWidget.TryHandleGamepadBackToSubTab and BoardWidget:TryHandleGamepadBackToSubTab() then
        return true
      end
    end
    self:OnBackOrEscape()
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    if self.bIgnoreNextProgressMenuKeyUp then
      self.bIgnoreNextProgressMenuKeyUp = false
      return true
    end
    self:OnBtnProgressClicked()
    return true
  end
  return false
end

return M
