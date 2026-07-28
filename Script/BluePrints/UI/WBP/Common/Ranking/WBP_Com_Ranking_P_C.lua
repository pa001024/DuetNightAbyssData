require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Common.Ranking.WBP_Com_Ranking_Base_C"
})
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local BottomKeyState = ComRankingUtils.BottomKeyState
local HeaderQaDirection = {Left = -1, Right = 1}

function M:Construct()
  self.Super.Construct(self)
  if self.Com_Empty and self.Com_Empty.SetIsShowNavigateGuide then
    self.Com_Empty:SetIsShowNavigateGuide(false)
  end
  if self.List_Ranking then
    self._SavedRankingListFocusable = self.List_Ranking.bIsFocusable
  end
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:HideRankingListNavigation()
  if not self.List_Ranking then
    return
  end
  if self.List_Ranking.SetIsShowNavigateGuide then
    self.List_Ranking:SetIsShowNavigateGuide(false)
  end
  if self._SavedRankingListFocusable == nil then
    self._SavedRankingListFocusable = self.List_Ranking.bIsFocusable
  end
  self.List_Ranking.bIsFocusable = false
  if self.List_Ranking.SetIsFocusable then
    self.List_Ranking:SetIsFocusable(false)
  end
end

function M:ShowRankingListNavigation()
  if not self.List_Ranking then
    return
  end
  local bFocusable = self._SavedRankingListFocusable ~= false
  self.List_Ranking.bIsFocusable = bFocusable
  if self.List_Ranking.SetIsFocusable then
    self.List_Ranking:SetIsFocusable(bFocusable)
  end
  if self.List_Ranking.SetIsShowNavigateGuide then
    self.List_Ranking:SetIsShowNavigateGuide(true)
  end
end

function M:IsRankingListEmpty()
  if not self.ValidItemNum or self.ValidItemNum <= 0 then
    return true
  end
  if self.WS_Type and self.Com_Empty then
    return self.WS_Type:GetActiveWidget() == self.Com_Empty
  end
  return false
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self:RemoveTimer("RankingHideUnderUI")
  self:RemoveTimer("RankingDeferredFocus")
  self.Super.Destruct(self)
end

function M:ShowRankingUI()
  if self._bRankingShown or not IsValid(self) then
    return
  end
  self._bRankingShown = true
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:RemoveTimer("RankingPreviewReady")
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayInAnimation()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
  end
  self:RemoveTimer("RankingHideUnderUI")
  self:AddTimer(0.3, function()
    if not IsValid(self) then
      return
    end
    local UiMgr = UIManager(self)
    local UnderUI = UiMgr and UiMgr:GetUnderState()
    if UnderUI and IsValid(UnderUI) then
      UnderUI:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end, false, 0, "RankingHideUnderUI", true)
  if self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:RemoveTimer("RankingDeferredFocus")
    self:AddTimer(0.05, function()
      if not IsValid(self) then
        return
      end
      self:FocusSelectedItem()
    end, false, 0, "RankingDeferredFocus", true)
  end
end

function M:InitBottomTabInfo()
  self.NormalBottomKeyInfo = {
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_CTL_PositionPlayer"),
      bLongPress = false
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_Check"),
      bLongPress = false
    }
  }
  if self.IsShowActor then
    table.insert(self.NormalBottomKeyInfo, {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "RH"}
      },
      Desc = GText("UI_CTL_RotatePreview")
    })
  end
  table.insert(self.NormalBottomKeyInfo, {
    KeyInfoList = {
      {Type = "Text", Text = "Esc"}
    },
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK"),
    bLongPress = false
  })
  self.NoItemsBottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Text", Text = "Esc"}
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  self.HeaderQaOpenBottomKeyInfo = {
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
        }
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  self.EmptyStateBottomKeyInfo = {}
end

function M:InitMainTab()
  self.Super.InitMainTab(self)
  local SubWidgetInfo = self.MainTab.SubWidgetInfo
  if SubWidgetInfo then
    self.CustomGamepadKey = SubWidgetInfo.GamepadKey
  end
  self:InitBottomTabInfo()
  local TabConfigData = {
    TitleName = GText(self.MainTab.TitleName),
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    LeftKey = "Q",
    RightKey = "E",
    BottomKeyInfo = self.NormalBottomKeyInfo
  }
  self.Tab:Init(TabConfigData, true)
end

function M:UpdateTabBottomKeyInfo(State)
  if not State then
    return
  end
  if State == BottomKeyState.Normal then
    self.Tab:UpdateBottomKeyInfo(self.NormalBottomKeyInfo)
  elseif State == BottomKeyState.NoItems then
    self.Tab:UpdateBottomKeyInfo(self.NoItemsBottomKeyInfo)
  elseif State == BottomKeyState.HeaderQaTipOpen then
    if self.QaWidgets and #self.QaWidgets > 0 then
      self.Tab:UpdateBottomKeyInfo(self.HeaderQaOpenBottomKeyInfo)
    else
      self.Tab:UpdateBottomKeyInfo(self.EmptyStateBottomKeyInfo)
    end
  else
    State = BottomKeyState.EmptyState
    self.Tab:UpdateBottomKeyInfo(self.EmptyStateBottomKeyInfo)
  end
  self.MainTabState = State
end

function M:InitBackgroundImage()
  local BgParams = self.Params.BgParams
  local BgWidgetPath = BgParams and BgParams.BgWidgetPath
  if not BgWidgetPath then
    return
  end
  local BgWidget = UIManager(self):CreateWidget(BgWidgetPath)
  if not BgWidget then
    return
  end
  self.Bg:ClearChildren()
  self.Bg:AddChild(BgWidget)
  local OffsetParams = BgParams.PCSlotOffset
  if not OffsetParams then
    return
  end
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg)
  if CanvasSlot then
    local Offset = FMargin()
    Offset.Left = OffsetParams[1]
    Offset.Top = OffsetParams[2]
    Offset.Right = OffsetParams[3]
    Offset.Bottom = OffsetParams[4]
    CanvasSlot:SetOffsets(Offset)
  end
end

local function StopWidgetNavigationRuleBase(Widget)
  if not Widget then
    return
  end
  if Widget.SetIsShowNavigateGuide then
    Widget:SetIsShowNavigateGuide(false)
  end
  Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  Widget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:BlockSubTabGamepadNavigation()
  if not self.SubTab or not self.SubTab.List_Tab then
    return
  end
  self.SubTab.bIsFocusable = false
  if self.SubTab.SetIsFocusable then
    self.SubTab:SetIsFocusable(false)
  end
  StopWidgetNavigationRuleBase(self.SubTab)
  local TabCount = self.SubTab.List_Tab:GetChildrenCount()
  for i = 0, TabCount - 1 do
    local TabWidget = self.SubTab.List_Tab:GetChildAt(i)
    if TabWidget then
      TabWidget.bIsFocusable = false
      if TabWidget.SetIsFocusable then
        TabWidget:SetIsFocusable(false)
      end
      StopWidgetNavigationRuleBase(TabWidget)
    end
    local Btn = TabWidget and TabWidget.Btn_Click
    if Btn then
      Btn.bIsFocusable = false
      if Btn.SetIsFocusable then
        Btn:SetIsFocusable(false)
      end
      StopWidgetNavigationRuleBase(Btn)
    end
  end
end

function M:UpdateBottomKeyOnSubTabChange()
  if not self.TabId then
    self:UpdateTabBottomKeyInfo(BottomKeyState.EmptyState)
    return
  end
  local TopNInfo = self.TopNRankInfo[self.TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self:UpdateTabBottomKeyInfo(BottomKeyState.NoItems)
  else
    self:UpdateTabBottomKeyInfo(BottomKeyState.Normal)
  end
end

function M:UpdateRankInfos(TabId)
  self.Super.UpdateRankInfos(self, TabId)
  if self:IsRankingListEmpty() then
    self:HideRankingListNavigation()
  end
end

function M:UpdateHeaderInfo(TabId)
  self.Super.UpdateHeaderInfo(self, TabId)
  if not self.Params or not self.Params.HeaderNames then
    return
  end
  local HeaderNames = self.Params.HeaderNames[TabId]
  if not HeaderNames then
    return
  end
  for i, NameInfo in ipairs(HeaderNames) do
    local ControllerQa = self["Controller_Qa_" .. i]
    if not ControllerQa then
    elseif NameInfo.QaText and ControllerQa.CreateCommonKey then
      ControllerQa:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.RightThumb
          }
        }
      })
      ControllerQa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      ControllerQa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  self:RefreshHeaderQaControllerVisibility()
end

function M:RefreshHeaderQaControllerVisibility()
  local bIsGamepad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  for i = 1, 4 do
    local ControllerQa = self["Controller_Qa_" .. i]
    local QaWidget = self["Btn_Qa_" .. i]
    if not ControllerQa then
    elseif bIsGamepad and QaWidget and QaWidget:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      ControllerQa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      ControllerQa:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad then
    self:BlockSubTabGamepadNavigation()
    if UIUtils.HasAnyFocus(self) then
      self:FocusSelectedItem()
    end
  end
  self:RefreshHeaderQaControllerVisibility()
end

function M:OnHeadMenuOpenChanged(bOpen)
  if bOpen then
    if not self.LastTabState then
      self.LastTabState = self.MainTabState
    end
    self:UpdateTabBottomKeyInfo(BottomKeyState.HeaderQaTipOpen)
  elseif self.LastTabState then
    self:UpdateTabBottomKeyInfo(self.LastTabState)
    self.LastTabState = nil
  end
end

function M:ShowHeaderQaInfoView(bShow)
  if bShow then
    if not self.LastTabState then
      self.LastTabState = self.MainTabState
    end
    self:UpdateTabBottomKeyInfo(BottomKeyState.HeaderQaTipOpen)
    self:SwitchHeaderQaView(HeaderQaDirection.Right)
  else
    if self.LastTabState then
      self:UpdateTabBottomKeyInfo(self.LastTabState)
      self.LastTabState = nil
    end
    local QaWdiget = self.QaWidgets[self.CurQaIndex]
    if QaWdiget then
      QaWdiget:OnViewInfoClick(false)
    end
    self.CurQaIndex = nil
  end
end

function M:IsHeaderQaMenuOpen()
  if self.CurQaIndex and self.QaWidgets and self.QaWidgets[self.CurQaIndex] then
    local QaWidget = self.QaWidgets[self.CurQaIndex]
    if QaWidget.IsMenuAnchorOpen and QaWidget:IsMenuAnchorOpen() then
      return true
    end
  end
  return false
end

function M:CloseHeaderQaMenu()
  self.CanSwitchQa = false
  self:ShowHeaderQaInfoView(false)
  self:FocusSelectedItem()
  return true
end

function M:SwitchHeaderQaView(Direction)
  if not self.QaWidgets or #self.QaWidgets < 1 then
    return
  end
  local QaNum = #self.QaWidgets
  
  local function GetTargetIndex()
    if self.CurQaIndex then
      return self.CurQaIndex + Direction
    end
    return Direction > 0 and 1 or QaNum
  end
  
  local TargetIndex = GetTargetIndex()
  if TargetIndex <= 0 or QaNum < TargetIndex then
    return
  end
  if self.CurQaIndex and self.CurQaIndex ~= TargetIndex then
    local QaWidget = self.QaWidgets[self.CurQaIndex]
    if QaWidget then
      QaWidget:OnViewInfoClick(false)
    end
  end
  self.CurQaIndex = TargetIndex
  local QaWidget = self.QaWidgets[self.CurQaIndex]
  if QaWidget then
    QaWidget:OnViewInfoClick(true)
  end
end

function M:OnGamepadHeaderQaPressed()
  if not self.QaWidgets or #self.QaWidgets < 1 then
    return false
  end
  self.CanSwitchQa = true
  self:ShowHeaderQaInfoView(true)
  return true
end

function M:OpenSelectedRankItemHeadMenu()
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    local TabId = self.TabId or 1
    local Index = self.NavigatedRankIndex or 0
    local Contents = self.TopNContents and self.TopNContents[TabId]
    Content = Contents and Contents[Index + 1]
  end
  if not Content or Content.Empty or not Content.SelfWidget then
    return false
  end
  local ItemWidget = Content.SelfWidget
  if ItemWidget.OpenHeadMenu then
    return ItemWidget:OpenHeadMenu()
  end
  if ItemWidget.Head_Anchor then
    ItemWidget.Head_Anchor:Open(true)
    return true
  end
  return false
end

function M:HandleGamepadKeyDown(InKeyName)
  if self:IsSelectedItemHeadMenuOpen() then
    local HeadMenu = self:GetOpenHeadMenuWidget()
    if InKeyName == UIConst.GamePadKey.SpecialLeft or "Gamepad_Special_Left" == InKeyName then
      if HeadMenu and HeadMenu.DoBlockAction then
        HeadMenu:DoBlockAction()
        return true
      end
    elseif InKeyName == UIConst.GamePadKey.SpecialRight or "Gamepad_Special_Right" == InKeyName then
      if HeadMenu and HeadMenu.DoReportAction then
        HeadMenu:DoReportAction()
        return true
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom or "Gamepad_FaceButton_Bottom" == InKeyName then
      return false
    elseif InKeyName ~= UIConst.GamePadKey.FaceButtonRight and "Gamepad_FaceButton_Right" ~= InKeyName then
      return false
    end
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight or "Gamepad_FaceButton_Right" == InKeyName then
    if self:IsHeaderQaMenuOpen() then
      self:CloseHeaderQaMenu()
      return true
    end
    if self:TryCloseListRankItemHeadMenu() then
      return true
    end
    self:CloseSelf()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom or "Gamepad_FaceButton_Bottom" == InKeyName then
    if self:IsSelectedItemHeadMenuOpen() then
      return false
    end
    if not self.CanSwitchQa and self:OpenSelectedRankItemHeadMenu() then
      return true
    end
    if self.SubTab and self.SubTab.Handle_KeyEventOnGamePad then
      self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.LeftThumb or "Gamepad_LeftThumbstick" == InKeyName then
    self:OnMyselfButtonClicked()
    return true
  elseif InKeyName == self.CustomGamepadKey and self.MainTabSubWidget then
    self.MainTabSubWidget:Handle_OnGamePadDown(InKeyName)
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb or "Gamepad_RightThumbstick" == InKeyName then
    return self:OnGamepadHeaderQaPressed()
  elseif InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.LeftStickRight then
    if self.CanSwitchQa then
      local Direction = InKeyName == UIConst.GamePadKey.LeftStickRight and HeaderQaDirection.Right or HeaderQaDirection.Left
      self:SwitchHeaderQaView(Direction)
      return true
    end
  elseif self.SubTab and self.SubTab.Handle_KeyEventOnGamePad then
    self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
    return true
  end
  return false
end

function M:GetOpenHeadMenuWidget()
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    local TabId = self.TabId or 1
    local Index = self.NavigatedRankIndex or 0
    local Contents = self.TopNContents and self.TopNContents[TabId]
    Content = Contents and Contents[Index + 1]
  end
  if not Content or Content.Empty or not Content.SelfWidget then
    return nil
  end
  return Content.SelfWidget.HeadMenuWidget
end

function M:TryCloseListRankItemHeadMenu()
  if not self.LastClickedItem then
    return false
  end
  local ItemWidget = self.LastClickedItem.SelfWidget
  if ItemWidget and ItemWidget.Head_Anchor and ItemWidget.Head_Anchor:IsOpen() then
    ItemWidget.Head_Anchor:Close()
    return true
  end
  return false
end

function M:IsSelectedItemHeadMenuOpen()
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    local TabId = self.TabId or 1
    local Index = self.NavigatedRankIndex or 0
    local Contents = self.TopNContents and self.TopNContents[TabId]
    Content = Contents and Contents[Index + 1]
  end
  if not Content or Content.Empty or not Content.SelfWidget then
    return false
  end
  local ItemWidget = Content.SelfWidget
  if ItemWidget.Head_Anchor and ItemWidget.Head_Anchor:IsOpen() then
    return true
  end
  return false
end

function M:OnListRankItemGamepadConfirm()
  local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamePad then
    return false
  end
  return self:OpenSelectedRankItemHeadMenu()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamepadKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self:ShowHeaderQaInfoView(false)
    self:FocusSelectedItem()
    self.CanSwitchQa = false
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self:IsSelectedItemHeadMenuOpen() then
      if self:HandleGamepadKeyDown(InKeyName) then
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    if self:HandleGamepadKeyDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  else
    self:Handle_OnPCDown(InKeyName)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:Handle_OnPCDown(InKeyName)
  if "Escape" == InKeyName then
    self:CloseSelf()
  else
    self.SubTab:Handle_KeyEventOnPC(InKeyName)
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  self:HandleGamepadKeyDown(InKeyName)
end

function M:OnFocusReceived()
  self:FocusSelectedItem()
  return UIUtils.Handled
end

function M:FocusSelectedItem()
  if self:IsRankingListEmpty() then
    self:HideRankingListNavigation()
    if self.Com_Empty and self.Com_Empty.SetFocus then
      self.Com_Empty:SetFocus()
    else
      self:SetFocus()
    end
    if IsValid(self.GameInputModeSubsystem) then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
    end
    return
  end
  self:ShowRankingListNavigation()
  local Index = self.NavigatedRankIndex or 0
  local LastItem = self.LastClickedItem
  if LastItem and LastItem.RankInfo and LastItem.RankInfo.RankNum then
    Index = LastItem.RankInfo.RankNum - 1
  end
  self:FocusSelectedListEntry(Index, true)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.ActorController and self.IsShowActor then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragViewActor({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
