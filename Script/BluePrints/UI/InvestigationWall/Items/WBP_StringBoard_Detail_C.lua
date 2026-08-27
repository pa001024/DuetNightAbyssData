require("UnLua")
local CommonConst = require("CommonConst")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardConfig = require("BluePrints.UI.InvestigationWall.StringBoardConfig")
local UIUtils = require("Utils.UIUtils")
local DetailDescItemPhase1 = InvestigationWallUtils.DetailDescItemPhase1
local DetailDescItemPhase2 = InvestigationWallUtils.DetailDescItemPhase2
local table_insert = table.insert
local math_abs = math.abs
local math_clamp = math.clamp
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
end

function M:InitUI(Parent)
  self.Parent = Parent
  self.DetailAnimState = "Idle"
  self:BindEvents()
  self:InitGamepadSettings()
  self:Hide()
end

function M:BindEvents()
  local BtnClose = self.Btn_Close
  if BtnClose and BtnClose.Btn_Click and BtnClose.Btn_Click.OnClicked then
    BtnClose.Btn_Click.OnClicked:Clear()
    BtnClose.Btn_Click.OnClicked:Add(self, self.OnCloseClicked)
  end
  local ListDesc = self.List_Desc
  if ListDesc and ListDesc.OnListViewScrolled then
    ListDesc.OnListViewScrolled:Clear()
    ListDesc.OnListViewScrolled:Add(self, self.OnDetailDescListScrolled)
  end
end

function M:UnbindEvents()
  local BtnClose = self.Btn_Close
  if BtnClose and BtnClose.Btn_Click and BtnClose.Btn_Click.OnClicked then
    BtnClose.Btn_Click.OnClicked:Remove(self, self.OnCloseClicked)
  end
  local ListDesc = self.List_Desc
  if ListDesc and ListDesc.OnListViewScrolled then
    ListDesc.OnListViewScrolled:Remove(self, self.OnDetailDescListScrolled)
  end
end

function M:Destruct()
  self:CancelDescListEntranceAnimations()
  if self.CleanTimer then
    self:CleanTimer()
  end
  self:ClearGamepadDetailFocus()
  self:UnbindDetailOpenCloseAnimations()
  self:UnbindEvents()
  self.DetailAnimState = "Idle"
  self.Parent = nil
  self.Content = nil
  self.ClueState = nil
end

function M:IsShowing()
  return self:GetVisibility() ~= UIConst.VisibilityOp.Collapsed
end

function M:IsDetailClosing()
  return self.DetailAnimState == "Closing"
end

function M:Hide()
  self:CancelDescListEntranceAnimations()
  self:ClearDescList()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.DetailAnimState = "Idle"
end

function M:Show()
  self:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:ApplyClueDetailContent(Content, ClueState)
  self.Content = Content
  self.ClueState = ClueState
  self:SetDetailImage(self:ResolveCluePicPath(Content, ClueState))
  self:RefreshDetailTitle(Content)
  self:RefreshDescList(Content)
end

function M:UnbindDetailOpenCloseAnimations()
  if self.In and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.In)
  end
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
end

function M:SnapDetailAnimationToEnd(Animation)
  if not Animation or not self.PlayAnimation then
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(Animation)
  end
  local EndTime = Animation.GetEndTime and Animation:GetEndTime() or nil
  if EndTime then
    self:PlayAnimation(Animation, EndTime)
    if self.SetAnimationCurrentTime then
      self:SetAnimationCurrentTime(Animation, EndTime)
    end
  else
    self:PlayAnimation(Animation)
  end
  if self.StopAnimation then
    self:StopAnimation(Animation)
  end
end

function M:NotifyParentPlayBoardDetailInAnimation()
  local Parent = self.Parent
  if Parent and Parent.PlayBoardDetailInAnimation then
    Parent:PlayBoardDetailInAnimation()
  end
end

function M:NotifyParentPlayBoardDetailOutAnimation()
  local Parent = self.Parent
  if Parent and Parent.PlayBoardDetailOutAnimation then
    Parent:PlayBoardDetailOutAnimation()
  end
end

function M:PlayOpenAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/common/month_signin_trans_to_keep_page", nil, nil)
  if self.Out then
    self:SnapDetailAnimationToEnd(self.Out)
  end
  self:Show()
  self.DetailAnimState = "Open"
  self:NotifyParentPlayBoardDetailInAnimation()
  if self.In and self.PlayAnimation then
    self:PlayAnimation(self.In)
  end
  if self.Parent and self.Parent.OnClueDetailShown then
    self.Parent:OnClueDetailShown()
  end
end

function M:PlaySwitchInAnimation()
  if self.Out then
    self:SnapDetailAnimationToEnd(self.Out)
  end
  self.DetailAnimState = "Open"
  if not self.In or not self.PlayAnimation then
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self:PlayAnimation(self.In)
end

function M:OnCloseAnimationFinished()
  if self.Out and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:Hide()
  if self.Parent and self.Parent.OnClueDetailHidden then
    self.Parent:OnClueDetailHidden()
  end
end

function M:PlayCloseAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/common/month_signin_trans_to_normal_page", nil, nil)
  self:CancelDescListEntranceAnimations()
  self.DetailAnimState = "Closing"
  self:NotifyParentPlayBoardDetailOutAnimation()
  if self.Parent and self.Parent.OnClueDetailCloseBegin then
    self.Parent:OnClueDetailCloseBegin()
  end
  if self.In then
    self:SnapDetailAnimationToEnd(self.In)
  end
  if not self.Out or not self.PlayAnimation then
    self:Hide()
    if self.Parent and self.Parent.OnClueDetailHidden then
      self.Parent:OnClueDetailHidden()
    end
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  if self.BindToAnimationFinished then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnCloseAnimationFinished
    })
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:RequestHide()
  if not self:IsShowing() then
    return
  end
  if self:IsDetailClosing() then
    return
  end
  self:NotifyParentDetailListScrollKeyTip(false)
  self:PlayCloseAnimation()
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
end

function M:ApplyGamepadDetailFocus()
  if not UIUtils.IsGamepadInput() then
    if self.SetFocus then
      self:SetFocus()
    end
    return
  end
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    if GameInputModeSubsystem.SetShowFocusedWidget then
      GameInputModeSubsystem:SetShowFocusedWidget(nil)
    end
    if GameInputModeSubsystem.SetNavigateWidgetVisibility then
      GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    end
  end
  if self.SetFocus then
    self:SetFocus()
  end
end

function M:ClearGamepadDetailFocus()
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.LeftStickUp or InKeyName == UIConst.GamePadKey.LeftStickDown or InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.LeftStickRight then
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
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.LeftStickUp or InKeyName == UIConst.GamePadKey.LeftStickDown or InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.LeftStickRight then
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

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftY" == InKeyName or "Gamepad_LeftX" == InKeyName then
    return UIUtils.Handled
  end
  if "Gamepad_RightY" == InKeyName then
    self:HandleDetailListRightStickScroll(InAnalogInputEvent)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:HandleDetailListRightStickScroll(InAnalogInputEvent)
  local ListDesc = self.List_Desc
  if not (ListDesc and ListDesc.GetScrollOffset) or not ListDesc.SetScrollOffset then
    return
  end
  if not ListDesc.GetScrollOffsetOfEnd then
    return
  end
  local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  local DeadZone = StringBoardConfig.DetailListRightStickDeadZone or 0.2
  if DeadZone > math_abs(AnalogValue) then
    return
  end
  if ListDesc.ForceLayoutPrepass then
    ListDesc:ForceLayoutPrepass()
  end
  local MaxOffset = ListDesc:GetScrollOffsetOfEnd() or 0
  if MaxOffset <= 0 then
    return
  end
  local ScrollSpeed = StringBoardConfig.DetailListRightStickScrollSpeed or 10
  local Delta = -1 * AnalogValue * ScrollSpeed
  local CurrentOffset = ListDesc:GetScrollOffset() or 0
  local NextOffset = math_clamp(CurrentOffset + Delta, 0, MaxOffset)
  ListDesc:SetScrollOffset(NextOffset)
  self:ScheduleVisibleDescEntryPendingAnimations()
end

function M:OnDetailDescListScrolled()
  self:ScheduleVisibleDescEntryPendingAnimations()
end

function M:ScheduleVisibleDescEntryPendingAnimations()
  self:RemoveTimer("DetailDescPendingAnimRefresh")
  local LayoutDelay = StringBoardConfig.DetailDescListAnimLayoutDelay or 0.05
  self:AddTimer(LayoutDelay, function()
    if not IsValid(self) or not self:IsShowing() then
      return
    end
    self:TryPlayVisibleDescEntryPendingAnimations()
    self:RemoveTimer("DetailDescPendingAnimRefresh")
  end, false, 0, "DetailDescPendingAnimRefresh")
end

function M:TryPlayVisibleDescEntryPendingAnimations()
  local ListDesc = self.List_Desc
  if not ListDesc or not ListDesc.GetDisplayedEntryWidgets then
    return
  end
  local DisplayedEntryWidgets = ListDesc:GetDisplayedEntryWidgets()
  if not DisplayedEntryWidgets then
    return
  end
  local EntryWidgetTable = DisplayedEntryWidgets.ToTable and DisplayedEntryWidgets:ToTable() or DisplayedEntryWidgets
  local PendingFirstFinishMap = self.DescListPendingPhase1ClueContentIdMap
  local PendingFirstUnlockMap = self.DescListPendingPhase2ClueContentIdMap
  for _, EntryWidget in pairs(EntryWidgetTable) do
    if not EntryWidget or not IsValid(EntryWidget) then
    else
      local Content = EntryWidget.Content
      local ClueContentId = Content and Content.ClueContentId
      local Plan = Content and Content.DescAnimPlan
      local bIsPendingFirstFinish = ClueContentId and PendingFirstFinishMap and PendingFirstFinishMap[ClueContentId]
      local bIsPendingFirstUnlock = ClueContentId and PendingFirstUnlockMap and PendingFirstUnlockMap[ClueContentId]
      if bIsPendingFirstFinish then
        if EntryWidget.PlayPhase1EntranceSequence then
          EntryWidget:PlayPhase1EntranceSequence(self, function()
            self:OnDescFirstFinishEntryCompleted(self.DescListEntranceStaggerToken)
          end)
        end
        PendingFirstFinishMap[ClueContentId] = nil
      elseif bIsPendingFirstUnlock and self.bDescListFirstFinishCompleted then
        if EntryWidget.PlayUnlockInAnimation then
          EntryWidget:PlayUnlockInAnimation(nil)
        end
        PendingFirstUnlockMap[ClueContentId] = nil
      else
        local Phase1 = Plan and Plan.Phase1
        if (Phase1 == DetailDescItemPhase1.PlayNormal or Phase1 == DetailDescItemPhase1.PlayFinish) and EntryWidget.ShouldPlayDescItemEntranceAnimation and EntryWidget:ShouldPlayDescItemEntranceAnimation() and EntryWidget.PlayPhase1EntranceSequence then
          EntryWidget:PlayPhase1EntranceSequence(self, nil)
        elseif self.bDescListFirstFinishCompleted and EntryWidget.ShouldPlayDescItemUnlockInAnimation and EntryWidget:ShouldPlayDescItemUnlockInAnimation() and EntryWidget.PlayUnlockInAnimation then
          EntryWidget:PlayUnlockInAnimation(nil)
        end
      end
    end
  end
end

function M:ResolveCluePicPath(Content, ClueState)
  if ClueState == CommonConst.ClueState.Finished then
    return Content.CluePic2
  end
  return Content.CluePic1
end

function M:SetDetailImage(PicPath)
  if not (self.Image_Icon and PicPath) or "" == PicPath then
    return
  end
  local ImageObject = LoadObject(PicPath)
  if not ImageObject then
    return
  end
  if self.Image_Icon.SetBrushFromTexture then
    self.Image_Icon:SetBrushFromTexture(ImageObject)
  else
    self.Image_Icon:SetBrushResourceObject(ImageObject)
  end
end

function M:RefreshDetailTitle(Content)
  if not self.Text_Title then
    return
  end
  local TitleTextKey = Content and Content.ClueName
  if TitleTextKey then
    self.Text_Title:SetText(GText(TitleTextKey))
  else
    self.Text_Title:SetText("")
  end
end

function M:BuildVisibleClueContentDescList(Content)
  local DescList = {}
  if not Content then
    return DescList
  end
  local ClueId = Content.ClueId
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  for _, ClueContentId in ipairs(Content.ClueContentIdList or {}) do
    local ClueContentState = InvestigationWallUtils.CheckClueContentState(ClueContentId, Avatar, ClueId)
    if InvestigationWallUtils.IsClueContentVisibleInDetail(ClueContentState) then
      local ClueContentConfig = DataMgr.ClueContent and DataMgr.ClueContent[ClueContentId]
      local DescText = ""
      if ClueContentConfig then
        if ClueContentConfig.DisplayText then
          DescText = ClueContentConfig.DisplayText
        elseif ClueContentConfig.TextMapId then
          DescText = GText(ClueContentConfig.TextMapId)
        end
      end
      local DescAnimPlan = InvestigationWallUtils.ResolveDetailDescItemPlayPlan(ClueContentState, ClueId, ClueContentId)
      table_insert(DescList, {
        ClueContentId = ClueContentId,
        ClueContentState = ClueContentState,
        DescText = DescText,
        DescAnimPlan = DescAnimPlan
      })
    end
  end
  return DescList
end

function M:ClearDescList()
  self:CancelDescListEntranceAnimations()
  if self.List_Desc then
    self.List_Desc:ClearListItems()
  end
end

function M:ResetListDescScrollToTop()
  local ListDesc = self.List_Desc
  if not ListDesc then
    return
  end
  if ListDesc.BP_CancelScrollIntoView then
    ListDesc:BP_CancelScrollIntoView()
  end
  if ListDesc.SetScrollOffset then
    ListDesc:SetScrollOffset(0)
  end
end

function M:CanListDescScroll()
  local ListDesc = self.List_Desc
  if not ListDesc or not ListDesc.GetScrollOffsetOfEnd then
    return false
  end
  if ListDesc.ForceLayoutPrepass then
    ListDesc:ForceLayoutPrepass()
  end
  return (ListDesc:GetScrollOffsetOfEnd() or 0) > 0
end

function M:NotifyParentDetailListScrollKeyTip(bCanScroll)
  local Parent = self.Parent
  if Parent and Parent.SetDetailListScrollKeyTip then
    Parent:SetDetailListScrollKeyTip(bCanScroll and true or false)
  end
end

function M:RefreshDetailListScrollKeyTipDelayed()
  self:NotifyParentDetailListScrollKeyTip(false)
  if not UIUtils.IsGamepadInput() then
    return
  end
  self:AddTimer(0.05, function()
    if not IsValid(self) or not self:IsShowing() then
      return
    end
    if not UIUtils.IsGamepadInput() then
      self:NotifyParentDetailListScrollKeyTip(false)
      return
    end
    self:NotifyParentDetailListScrollKeyTip(self:CanListDescScroll())
  end)
end

function M:RefreshDescList(Content)
  local ListDesc = self.List_Desc
  if not ListDesc then
    return
  end
  self:CancelDescListEntranceAnimations()
  ListDesc:ClearListItems()
  local DescList = self:BuildVisibleClueContentDescList(Content)
  for _, DescData in ipairs(DescList) do
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.ClueContentId = DescData.ClueContentId
    ItemContent.ClueContentState = DescData.ClueContentState
    ItemContent.DescText = DescData.DescText
    ItemContent.DescAnimPlan = DescData.DescAnimPlan
    ItemContent.ClueId = Content and Content.ClueId
    ListDesc:AddItem(ItemContent)
  end
  self:ResetListDescScrollToTop()
  self:ScheduleDescListEntranceAnimations()
end

function M:CancelDescListEntranceTimers()
  self.DescListEntranceStaggerToken = (self.DescListEntranceStaggerToken or 0) + 1
  self.DescListPendingPhase1ClueContentIdMap = nil
  self.DescListPendingPhase2ClueContentIdMap = nil
  self.bDescListFirstFinishCompleted = false
  self.DescListFirstFinishPendingCount = 0
  self:RemoveTimer("DetailDescListEntranceStagger")
  self:RemoveTimer("DetailDescListPhase1Stagger")
  self:RemoveTimer("DetailDescListPhase2InStagger")
  self:RemoveTimer("DetailDescListEntryWaitWidget")
  self:RemoveTimer("DetailDescListAnimLayout")
  self:RemoveTimer("DetailDescPendingAnimRefresh")
end

function M:CancelDescListEntranceAnimations()
  self:CancelDescListEntranceTimers()
  self:CancelAllDescEntryItemAnimations()
end

function M:CancelAllDescEntryItemAnimations()
  local ListDesc = self.List_Desc
  if not ListDesc or not ListDesc.GetDisplayedEntryWidgets then
    return
  end
  local DisplayedEntryWidgets = ListDesc:GetDisplayedEntryWidgets()
  if not DisplayedEntryWidgets then
    return
  end
  local EntryWidgetTable = DisplayedEntryWidgets.ToTable and DisplayedEntryWidgets:ToTable() or DisplayedEntryWidgets
  for _, EntryWidget in pairs(EntryWidgetTable) do
    if EntryWidget and IsValid(EntryWidget) and EntryWidget.CancelDescItemAnimations then
      EntryWidget:CancelDescItemAnimations()
    end
  end
end

function M:BuildDescPlayQueues()
  local ImmediateQueue = {}
  local FirstFinishQueue = {}
  local FirstUnlockQueue = {}
  local ListDesc = self.List_Desc
  if not ListDesc or not ListDesc.GetListItems then
    return ImmediateQueue, FirstFinishQueue, FirstUnlockQueue
  end
  local ListItems = ListDesc:GetListItems()
  local ListItemTable = ListItems.ToTable and ListItems:ToTable() or ListItems
  for _, ItemContent in ipairs(ListItemTable or {}) do
    if not ItemContent or not ItemContent.ClueContentId then
    else
      local Plan = ItemContent.DescAnimPlan
      local Phase1 = Plan and Plan.Phase1
      local Phase2 = Plan and Plan.Phase2
      if Phase1 == DetailDescItemPhase1.PlayFinishIn then
        table_insert(FirstFinishQueue, {
          ClueContentId = ItemContent.ClueContentId
        })
      elseif Phase2 == DetailDescItemPhase2.PlayUnlockIn then
        table_insert(FirstUnlockQueue, {
          ClueContentId = ItemContent.ClueContentId
        })
      elseif Phase1 == DetailDescItemPhase1.PlayNormal or Phase1 == DetailDescItemPhase1.PlayFinish then
        table_insert(ImmediateQueue, {
          ClueContentId = ItemContent.ClueContentId
        })
      end
    end
  end
  return ImmediateQueue, FirstFinishQueue, FirstUnlockQueue
end

function M:FindDescEntryWidgetByClueContentId(ClueContentId)
  local ListDesc = self.List_Desc
  if not (ListDesc and ClueContentId) or not ListDesc.GetDisplayedEntryWidgets then
    return nil
  end
  local DisplayedEntryWidgets = ListDesc:GetDisplayedEntryWidgets()
  if not DisplayedEntryWidgets then
    return nil
  end
  local EntryWidgetTable = DisplayedEntryWidgets.ToTable and DisplayedEntryWidgets:ToTable() or DisplayedEntryWidgets
  for _, EntryWidget in pairs(EntryWidgetTable) do
    if EntryWidget and IsValid(EntryWidget) and EntryWidget.Content and EntryWidget.Content.ClueContentId == ClueContentId then
      return EntryWidget
    end
  end
  return nil
end

function M:TryPlayDescImmediateEntry(ImmediateEntry)
  if not ImmediateEntry then
    return
  end
  local EntryWidget = self:FindDescEntryWidgetByClueContentId(ImmediateEntry.ClueContentId)
  if not EntryWidget or not IsValid(EntryWidget) then
    return
  end
  if not EntryWidget.ShouldPlayDescItemEntranceAnimation or not EntryWidget:ShouldPlayDescItemEntranceAnimation() then
    return
  end
  if EntryWidget.PlayPhase1EntranceSequence then
    EntryWidget:PlayPhase1EntranceSequence(self, nil)
  end
end

function M:OnDescFirstFinishEntryCompleted(StaggerToken)
  if StaggerToken and self.DescListEntranceStaggerToken ~= StaggerToken then
    return
  end
  self.DescListFirstFinishPendingCount = (self.DescListFirstFinishPendingCount or 0) - 1
  if self.DescListFirstFinishPendingCount <= 0 then
    self:OnDescListFirstFinishAllCompleted(StaggerToken)
  end
end

function M:OnDescListFirstFinishAllCompleted(StaggerToken)
  if StaggerToken and self.DescListEntranceStaggerToken ~= StaggerToken then
    return
  end
  self.bDescListFirstFinishCompleted = true
  local FirstUnlockQueue = self.DescListPhase2UnlockInQueue or {}
  self:StartDescListPhase2UnlockInStagger(FirstUnlockQueue, StaggerToken)
end

function M:TryPlayDescFirstFinishEntry(FirstFinishEntry, StaggerToken)
  if not FirstFinishEntry then
    self:OnDescFirstFinishEntryCompleted(StaggerToken)
    return
  end
  local EntryWidget = self:FindDescEntryWidgetByClueContentId(FirstFinishEntry.ClueContentId)
  if not EntryWidget or not IsValid(EntryWidget) then
    self.DescListPendingPhase1ClueContentIdMap = self.DescListPendingPhase1ClueContentIdMap or {}
    self.DescListPendingPhase1ClueContentIdMap[FirstFinishEntry.ClueContentId] = true
    local LayoutDelay = StringBoardConfig.DetailDescListAnimLayoutDelay or 0.05
    self:AddTimer(LayoutDelay, function()
      if not IsValid(self) or self.DescListEntranceStaggerToken ~= StaggerToken then
        return
      end
      self:TryPlayDescFirstFinishEntry(FirstFinishEntry, StaggerToken)
    end, false, 0, "DetailDescListEntryWaitWidget")
    return
  end
  if not EntryWidget.ShouldPlayDescItemEntranceAnimation or not EntryWidget:ShouldPlayDescItemEntranceAnimation() then
    self:OnDescFirstFinishEntryCompleted(StaggerToken)
    return
  end
  if EntryWidget.PlayPhase1EntranceSequence then
    EntryWidget:PlayPhase1EntranceSequence(self, function()
      self:OnDescFirstFinishEntryCompleted(StaggerToken)
    end)
  else
    self:OnDescFirstFinishEntryCompleted(StaggerToken)
  end
  if self.DescListPendingPhase1ClueContentIdMap then
    self.DescListPendingPhase1ClueContentIdMap[FirstFinishEntry.ClueContentId] = nil
  end
end

function M:TryPlayDescPhase2UnlockInEntry(Phase2Entry, StaggerToken)
  if not Phase2Entry then
    return
  end
  local EntryWidget = self:FindDescEntryWidgetByClueContentId(Phase2Entry.ClueContentId)
  if not EntryWidget or not IsValid(EntryWidget) then
    self.DescListPendingPhase2ClueContentIdMap = self.DescListPendingPhase2ClueContentIdMap or {}
    self.DescListPendingPhase2ClueContentIdMap[Phase2Entry.ClueContentId] = true
    return
  end
  if not EntryWidget.ShouldPlayDescItemUnlockInAnimation or not EntryWidget:ShouldPlayDescItemUnlockInAnimation() then
    return
  end
  if EntryWidget.PlayUnlockInAnimation then
    EntryWidget:PlayUnlockInAnimation(nil)
  end
  if self.DescListPendingPhase2ClueContentIdMap then
    self.DescListPendingPhase2ClueContentIdMap[Phase2Entry.ClueContentId] = nil
  end
end

function M:ScheduleDescListEntranceAnimations()
  self:CancelDescListEntranceTimers()
  local LayoutDelay = StringBoardConfig.DetailDescListAnimLayoutDelay or 0.05
  local StaggerToken = self.DescListEntranceStaggerToken
  self:AddTimer(LayoutDelay, function()
    if not IsValid(self) or self.DescListEntranceStaggerToken ~= StaggerToken then
      return
    end
    if not self:IsShowing() then
      return
    end
    self:ResetListDescScrollToTop()
    self:StartDescListEntranceAnimations(StaggerToken)
  end, false, 0, "DetailDescListAnimLayout")
end

function M:StartDescListEntranceAnimations(ExpectedStaggerToken)
  if ExpectedStaggerToken and self.DescListEntranceStaggerToken ~= ExpectedStaggerToken then
    return
  end
  local ImmediateQueue, FirstFinishQueue, FirstUnlockQueue = self:BuildDescPlayQueues()
  self.DescListPhase2UnlockInQueue = FirstUnlockQueue
  self.bDescListFirstFinishCompleted = false
  self.DescListFirstFinishPendingCount = #FirstFinishQueue
  local StaggerToken = self.DescListEntranceStaggerToken
  for _, ImmediateEntry in ipairs(ImmediateQueue) do
    self:TryPlayDescImmediateEntry(ImmediateEntry)
  end
  if 0 == #FirstFinishQueue then
    self:OnDescListFirstFinishAllCompleted(StaggerToken)
    return
  end
  self:StartDescListFirstFinishStagger(FirstFinishQueue, StaggerToken)
end

function M:StartDescListFirstFinishStagger(FirstFinishQueue, StaggerToken)
  if not FirstFinishQueue or 0 == #FirstFinishQueue then
    self:OnDescListFirstFinishAllCompleted(StaggerToken)
    return
  end
  local PlayIndex = 0
  local Interval = StringBoardConfig.DetailDescPhase1StaggerInterval or 0.1
  
  local function PlayNextFirstFinishEntry()
    if not IsValid(self) or self.DescListEntranceStaggerToken ~= StaggerToken then
      return false
    end
    PlayIndex = PlayIndex + 1
    local FirstFinishEntry = FirstFinishQueue[PlayIndex]
    if FirstFinishEntry then
      self:TryPlayDescFirstFinishEntry(FirstFinishEntry, StaggerToken)
    end
    return PlayIndex < #FirstFinishQueue
  end
  
  if not PlayNextFirstFinishEntry() then
    return
  end
  self:AddTimer(Interval, function()
    if not PlayNextFirstFinishEntry() then
      self:RemoveTimer("DetailDescListPhase1Stagger")
    end
  end, true, 0, "DetailDescListPhase1Stagger")
end

function M:StartDescListPhase2UnlockInStagger(Phase2Queue, StaggerToken)
  if not Phase2Queue or 0 == #Phase2Queue then
    return
  end
  local PlayIndex = 0
  local Interval = StringBoardConfig.DetailDescInStaggerInterval or 1.0
  
  local function PlayNextPhase2Entry()
    if not IsValid(self) or self.DescListEntranceStaggerToken ~= StaggerToken then
      return false
    end
    PlayIndex = PlayIndex + 1
    local Phase2Entry = Phase2Queue[PlayIndex]
    if Phase2Entry then
      self:TryPlayDescPhase2UnlockInEntry(Phase2Entry, StaggerToken)
    end
    return PlayIndex < #Phase2Queue
  end
  
  if not PlayNextPhase2Entry() then
    return
  end
  self:AddTimer(Interval, function()
    if not PlayNextPhase2Entry() then
      self:RemoveTimer("DetailDescListPhase2InStagger")
    end
  end, true, 0, "DetailDescListPhase2InStagger")
end

function M:ShowClueDetail(Content, ClueState)
  if not Content then
    return false
  end
  if self:IsDetailClosing() then
    return false
  end
  if self:IsShowing() then
    self:ApplyClueDetailContent(Content, ClueState)
    self:PlaySwitchInAnimation()
    self:RefreshDetailListScrollKeyTipDelayed()
    return true
  end
  self:ApplyClueDetailContent(Content, ClueState)
  self:PlayOpenAnimation()
  self:RefreshDetailListScrollKeyTipDelayed()
  return true
end

function M:OnCloseClicked()
  if not self:IsShowing() or self:IsDetailClosing() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_team_preset_click", nil, nil)
  self:RequestHide()
end

return M
