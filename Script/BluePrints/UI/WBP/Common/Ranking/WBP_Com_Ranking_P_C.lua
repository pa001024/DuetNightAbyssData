require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Common.Ranking.WBP_Com_Ranking_Base_C"
})
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local BottomKeyState = ComRankingUtils.BottomKeyState
local HeaderQaDirection = {Left = -1, Right = 1}
local ShowTeamTextKey = "UI_Ranking_ShowSquad"
local SortGamepadKey = "View"
local RewardGamepadKey = "Y"

function M:Construct()
  M.Super.Construct(self)
  if self.Com_Empty and self.Com_Empty.SetIsShowNavigateGuide then
    self.Com_Empty:SetIsShowNavigateGuide(false)
  end
  if self.List_Ranking then
    self._SavedRankingListFocusable = self.List_Ranking.bIsFocusable
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  self:BindRankingHideUIButton()
end

function M:BindRankingHideUIButton()
  if not self.Btn_Visible then
    return
  end
  if self.Btn_Visible.UnBindEventOnClickedByObj then
    self.Btn_Visible:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_Visible.BindEventOnClicked then
    self.Btn_Visible:BindEventOnClicked(self, self.OnHideUIClick)
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
  if self.Btn_Reward then
    self.Btn_Reward:UnBindEventOnClickedByObj(self)
  end
  if self.CheckBox_ShowTeam then
    self.CheckBox_ShowTeam:RemoveEventOnCheckStateChanged(self)
  end
  if self.Sort_Visible then
    self.Sort_Visible:BindEventOnSelectionsChanged(nil, nil)
  end
  if self.Btn_Visible and self.Btn_Visible.UnBindEventOnClickedByObj then
    self.Btn_Visible:UnBindEventOnClickedByObj(self)
  end
  M.Super.Destruct(self)
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
  self:RequestFillRankingEmptyContent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem:SetTargetUIFocusWidget(self)
  end
  self:RemoveTimer("RankingHideUnderUI")
  self:AddTimer(0.3, function()
    if not IsValid(self) then
      return
    end
    self:ForceHideStackUnderUI()
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
  self.HideUIBottomKeyInfo = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "U",
        ClickCallback = self.OnHideUIClick,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft,
        ClickCallback = self.OnHideUIClick,
        Owner = self
      }
    },
    Desc = GText("UI_Dye_HideUI"),
    bLongPress = false
  }
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
  table.insert(self.NormalBottomKeyInfo, self.HideUIBottomKeyInfo)
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
    self.HideUIBottomKeyInfo,
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
  M.Super.InitMainTab(self)
  local SubWidgetInfo = self.MainTab.SubWidgetInfo
  if SubWidgetInfo then
    self.CustomGamepadKey = SubWidgetInfo.GamepadKey
  end
  self:InitBottomTabInfo()
  self.TabBottomKeyStateStack = {}
  self.bTabStateSaved = false
  self:InitFilterBar()
  local TabConfig = self.MainTab or {}
  TabConfig.OwnerPanel = self
  if not TabConfig.BackCallback then
    TabConfig.BackCallback = self.CloseSelf
  end
  if not TabConfig.BottomKeyInfo then
    TabConfig.BottomKeyInfo = self.NormalBottomKeyInfo
  end
  self.Tab:Init(TabConfig, true)
  self:BindRankingHideUIButton()
end

function M:InitFilterBar()
  local FilterBar = self.Params and self.Params.FilterBar
  if not FilterBar then
    self:SetFilterBarItemVisible(self.Btn_Reward, false)
    self:SetFilterBarItemVisible(self.CheckBox_ShowTeam, false)
    self:SetFilterBarItemVisible(self.Text_ShowTeam, false)
    self:SetFilterBarItemVisible(self.Sort_Visible, false)
    self:RefreshShowTeamControllerVisibility()
    return
  end
  local BtnRewardCfg = FilterBar.BtnReward
  if self.Btn_Reward then
    if BtnRewardCfg then
      if BtnRewardCfg.Text then
        self.Btn_Reward:SetText(GText(BtnRewardCfg.Text))
      end
      self._BtnRewardCallback = BtnRewardCfg.OnClicked
      if BtnRewardCfg.OnClicked then
        self.Btn_Reward:BindEventOnClicked(self, self.OnBtnRewardClicked)
      end
      if self.Btn_Reward.SetGamePadImg then
        self.Btn_Reward:SetGamePadImg(RewardGamepadKey)
      end
      self:SetFilterBarItemVisible(self.Btn_Reward, true)
    else
      self:SetFilterBarItemVisible(self.Btn_Reward, false)
    end
  end
  if self.CheckBox_ShowTeam then
    if self:IsShowTeamFeatureEnabled() then
      self._ShowTeamCallback = FilterBar.ShowTeam.OnCheckChanged
      if self.CheckBox_ShowTeam.AddEventOnCheckStateChanged then
        self.CheckBox_ShowTeam:AddEventOnCheckStateChanged(self, self.OnShowTeamCheckChanged)
      end
      self.bShowTeam = FilterBar.ShowTeam.bDefaultChecked == true
      self.CheckBox_ShowTeam:SetChecked(self.bShowTeam, false)
      self:UpdateShowTeamToggleVisibility()
    else
      self:UpdateShowTeamToggleVisibility()
    end
  end
  if self:IsShowTeamFeatureEnabled() and self.Controller_ShowTeam and self.Controller_ShowTeam.CreateCommonKey then
    self.Controller_ShowTeam:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      }
    })
  end
  local SortVisibleCfg = FilterBar.SortVisible
  if self.Sort_Visible then
    local Options = SortVisibleCfg and SortVisibleCfg.Options or {}
    local TextList = {}
    for _, Opt in ipairs(Options) do
      table.insert(TextList, Opt.Text)
    end
    if SortVisibleCfg and #TextList > 0 then
      self._SortOptions = Options
      self.Sort_Visible:Init(TextList, SortGamepadKey, self)
      self.Sort_Visible:BindEventOnSelectionsChanged(self, self.OnSortVisibleSelectionsChanged)
      self:SetFilterBarItemVisible(self.Sort_Visible, true)
    else
      self:SetFilterBarItemVisible(self.Sort_Visible, false)
    end
  end
  self:RefreshShowTeamControllerVisibility()
end

function M:SetFilterBarItemVisible(Widget, bShow)
  if not Widget then
    return
  end
  Widget:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:IsShowTeamFeatureEnabled()
  local ShowTeam = self.Params and self.Params.FilterBar and self.Params.FilterBar.ShowTeam
  if not ShowTeam or ShowTeam.bEnable ~= true then
    return false
  end
  return self:HasTeamColumn()
end

function M:HasBoardData()
  local CurTopNInfo = self.TopNRankInfo and self.TopNRankInfo[self.TabId or 1]
  if not CurTopNInfo or ComRankingUtils.IsEmptyTable(CurTopNInfo) then
    return false
  end
  return true
end

function M:UpdateShowTeamToggleVisibility()
  if self.Text_ShowTeam then
    self.Text_ShowTeam:SetText(GText(ShowTeamTextKey))
  end
  local bShow = self:HasBoardData() and self:IsShowTeamFeatureEnabled()
  self:SetFilterBarItemVisible(self.CheckBox_ShowTeam, bShow)
  self:SetFilterBarItemVisible(self.Text_ShowTeam, bShow)
end

function M:IsBtnRewardFeatureEnabled()
  if not self._BtnRewardCallback or not self.Btn_Reward then
    return false
  end
  local Visibility = self.Btn_Reward:GetVisibility()
  return Visibility ~= UIConst.VisibilityOp.Collapsed and Visibility ~= UIConst.VisibilityOp.Hidden
end

function M:IsSortVisibleFeatureEnabled()
  if not (self.Sort_Visible and self._SortOptions) or #self._SortOptions < 1 then
    return false
  end
  local Visibility = self.Sort_Visible:GetVisibility()
  return Visibility ~= UIConst.VisibilityOp.Collapsed and Visibility ~= UIConst.VisibilityOp.Hidden
end

function M:HasTeamColumn()
  if not self.ColumnSchema then
    return false
  end
  for _, ColumnSchema in pairs(self.ColumnSchema) do
    for _, ColumnDecl in ipairs(ColumnSchema or {}) do
      if ColumnDecl.Type == "Team" then
        return true
      end
    end
  end
  return false
end

function M:OnBtnRewardClicked()
  if self._BtnRewardCallback then
    self._BtnRewardCallback(self)
  end
end

function M:OnShowTeamCheckChanged(bChecked)
  self:ApplyShowTeam(true == bChecked)
  if self._ShowTeamCallback then
    self._ShowTeamCallback(bChecked)
  end
end

function M:OnSortVisibleSelectionsChanged(Index)
  local Opt = self._SortOptions and self._SortOptions[Index]
  if Opt and Opt.Callback then
    Opt.Callback(self, Index)
  end
end

function M:UpdateTabBottomKeyInfo(State)
  if not State then
    return
  end
  if not self.Tab or not self.Tab.UpdateBottomKeyInfo then
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
  local OffsetParams
  if UIUtils.IsMobileInput() then
    OffsetParams = BgParams.MobileSlotOffset or BgParams.PCSlotOffset
  else
    OffsetParams = BgParams.PCSlotOffset
  end
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
  M.Super.UpdateRankInfos(self, TabId)
  if self:IsRankingListEmpty() then
    self:HideRankingListNavigation()
  else
    self:ShowRankingListNavigation()
  end
end

function M:UpdateHeaderInfo(TabId)
  M.Super.UpdateHeaderInfo(self, TabId)
  if not self.HeaderColumns then
    return
  end
  for _, ColumnWidget in ipairs(self.HeaderColumns) do
    local ControllerQa = ColumnWidget.Controller_Qa
    local BtnQa = ColumnWidget.Btn_Qa
    if ControllerQa then
      if BtnQa and BtnQa:GetVisibility() ~= UIConst.VisibilityOp.Collapsed and ControllerQa.CreateCommonKey then
        ControllerQa:CreateCommonKey({
          KeyInfoList = {
            {
              Type = "Img",
              ImgShortPath = UIConst.GamePadImgKey.DPadRight
            }
          }
        })
        ControllerQa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      else
        ControllerQa:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
  self:RefreshHeaderQaControllerVisibility()
end

function M:RefreshHeaderQaControllerVisibility()
  local bIsGamepad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not self.HeaderColumns then
    return
  end
  for _, ColumnWidget in ipairs(self.HeaderColumns) do
    local ControllerQa = ColumnWidget.Controller_Qa
    local BtnQa = ColumnWidget.Btn_Qa
    if ControllerQa then
      if bIsGamepad and BtnQa and BtnQa:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
        ControllerQa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      else
        ControllerQa:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
end

function M:RefreshShowTeamControllerVisibility()
  if not self.Controller_ShowTeam then
    return
  end
  local bIsGamepad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  local bShow = bIsGamepad and self:HasBoardData() and self:IsShowTeamFeatureEnabled()
  self.Controller_ShowTeam:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local bWasGamePad = self.IsGamePad
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad then
    if not bWasGamePad then
      self:RefreshDisplayedRankSelection(nil, nil)
    end
    self:BlockSubTabGamepadNavigation()
    if UIUtils.HasAnyFocus(self) then
      self:FocusSelectedItem()
    end
  end
  self:RefreshHeaderQaControllerVisibility()
  self:RefreshShowTeamControllerVisibility()
end

function M:PushTabBottomKeyState()
  if not self.TabBottomKeyStateStack then
    self.TabBottomKeyStateStack = {}
  end
  table.insert(self.TabBottomKeyStateStack, self.MainTabState)
  self.bTabStateSaved = true
  self:UpdateTabBottomKeyInfo(BottomKeyState.HeaderQaTipOpen)
end

function M:PopTabBottomKeyState()
  local Stack = self.TabBottomKeyStateStack
  if not Stack or #Stack < 1 then
    self.bTabStateSaved = false
    self:UpdateBottomKeyOnSubTabChange()
    return
  end
  local LastTabState = table.remove(Stack)
  self.bTabStateSaved = #Stack > 0
  self.LastTabState = nil
  if LastTabState then
    self:UpdateTabBottomKeyInfo(LastTabState)
  else
    self:UpdateBottomKeyOnSubTabChange()
  end
end

function M:OnHeadMenuOpenChanged(bOpen)
  if bOpen then
    self:PushTabBottomKeyState()
  else
    self:PopTabBottomKeyState()
  end
end

function M:ShowHeaderQaInfoView(bShow)
  if bShow then
    self:PushTabBottomKeyState()
    self:SwitchHeaderQaView(HeaderQaDirection.Right)
  else
    self:PopTabBottomKeyState()
    if self.QaWidgets and self.CurQaIndex then
      local QaWidget = self.QaWidgets[self.CurQaIndex]
      if QaWidget then
        QaWidget:OnViewInfoClick(false)
      end
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
  if self.CanSwitchQa or self:IsHeaderQaMenuOpen() then
    self:SwitchHeaderQaView(HeaderQaDirection.Right)
    return true
  end
  self.CanSwitchQa = true
  self:ShowHeaderQaInfoView(true)
  return true
end

function M:OnGamepadHeaderQaSwitchLeft()
  if not self.QaWidgets or #self.QaWidgets < 1 then
    return false
  end
  if not self.CanSwitchQa and not self:IsHeaderQaMenuOpen() then
    return false
  end
  self:SwitchHeaderQaView(HeaderQaDirection.Left)
  return true
end

function M:OnGamepadRightThumbPressed()
  if not self:IsShowTeamFeatureEnabled() then
    return false
  end
  local bNew = self.bShowTeam ~= true
  if self.CheckBox_ShowTeam and self.CheckBox_ShowTeam.SetChecked then
    self.CheckBox_ShowTeam:SetChecked(bNew, true)
  else
    self:OnShowTeamCheckChanged(bNew)
  end
  return true
end

function M:IsSortListOpen()
  return self.Sort_Visible ~= nil and self.Sort_Visible.IsListViewOpened == true
end

function M:TryCloseSortList()
  if not self:IsSortListOpen() then
    return false
  end
  if self.Sort_Visible.OnListClosed then
    self.Sort_Visible:OnListClosed()
  end
  return true
end

function M:GetSortGamepadKeyName()
  if self.Sort_Visible and self.Sort_Visible.GamePadKey then
    return self.Sort_Visible.GamePadKey
  end
  return Const.ShortKeyToGamePadKey and Const.ShortKeyToGamePadKey[SortGamepadKey]
end

function M:HandleGamepadKeyDown(InKeyName)
  local bIsHideUIKey = InKeyName == UIConst.GamePadKey.FaceButtonLeft or "Gamepad_FaceButton_Left" == InKeyName
  local bIsBackKey = InKeyName == UIConst.GamePadKey.FaceButtonRight or "Gamepad_FaceButton_Right" == InKeyName
  if self:IsRankingUIHidden() then
    if bIsHideUIKey then
      self:OnHideUIClick()
      return true
    end
    if bIsBackKey then
      self:RecoverRankingUI()
      return true
    end
    return true
  end
  if bIsHideUIKey then
    self:OnHideUIClick()
    return true
  end
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
    elseif InKeyName == UIConst.GamePadKey.RightThumb or "Gamepad_RightThumbstick" == InKeyName then
      return true
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
    if self:TryCloseSortList() then
      self:FocusSelectedItem()
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
      return self.SubTab:Handle_KeyEventOnGamePad(InKeyName) == true
    end
    return false
  elseif InKeyName == UIConst.GamePadKey.LeftThumb or "Gamepad_LeftThumbstick" == InKeyName then
    if self:IsSortListOpen() then
      self:TryCloseSortList()
    end
    if not self:ShouldShowMyselfBar(self.TabId) then
      return true
    end
    self:OnMyselfButtonClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop or "Gamepad_FaceButton_Top" == InKeyName then
    if self:IsBtnRewardFeatureEnabled() then
      self:OnBtnRewardClicked()
      return true
    end
    return false
  elseif self:IsSortVisibleFeatureEnabled() and InKeyName == self:GetSortGamepadKeyName() then
    if self.Sort_Visible and self.Sort_Visible.FocusToSelf then
      return true == self.Sort_Visible:FocusToSelf()
    end
    return false
  elseif InKeyName == self.CustomGamepadKey and self.MainTabSubWidget then
    self.MainTabSubWidget:Handle_OnGamePadDown(InKeyName)
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb or "Gamepad_RightThumbstick" == InKeyName then
    return self:OnGamepadRightThumbPressed()
  elseif InKeyName == UIConst.GamePadKey.DPadRight or "Gamepad_DPad_Right" == InKeyName then
    return self:OnGamepadHeaderQaPressed()
  elseif InKeyName == UIConst.GamePadKey.DPadLeft or "Gamepad_DPad_Left" == InKeyName then
    return self:OnGamepadHeaderQaSwitchLeft()
  elseif InKeyName == UIConst.GamePadKey.LeftStickLeft or InKeyName == UIConst.GamePadKey.LeftStickRight then
    if self.CanSwitchQa then
      local Direction = InKeyName == UIConst.GamePadKey.LeftStickRight and HeaderQaDirection.Right or HeaderQaDirection.Left
      self:SwitchHeaderQaView(Direction)
      return true
    end
  elseif self.SubTab and self.SubTab.Handle_KeyEventOnGamePad then
    return self.SubTab:Handle_KeyEventOnGamePad(InKeyName) == true
  end
  return false
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
  if M.Super.OnKeyUp then
    return M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self:HandleGamepadKeyDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self:Handle_OnPCDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:Handle_OnPCDown(InKeyName)
  if self:IsRankingUIHidden() then
    if "U" == InKeyName then
      self:OnHideUIClick()
      return true
    end
    if "Escape" == InKeyName or "Android_Back" == InKeyName then
      self:RecoverRankingUI()
      return true
    end
    return true
  end
  if "U" == InKeyName then
    self:OnHideUIClick()
    return true
  end
  if "Escape" == InKeyName then
    if self:IsHeaderQaMenuOpen() then
      self:CloseHeaderQaMenu()
      return true
    end
    if self:TryCloseListRankItemHeadMenu() then
      return true
    end
    if self:TryCloseSortList() then
      return true
    end
    self:CloseSelf()
    return true
  end
  if self.SubTab and self.SubTab.Handle_KeyEventOnPC then
    return self.SubTab:Handle_KeyEventOnPC(InKeyName) == true
  end
  return false
end

function M:Handle_OnGamePadDown(InKeyName)
  self:HandleGamepadKeyDown(InKeyName)
end

function M:OnFocusReceived()
  if not self.IsGamePad then
    return UIUtils.Unhandled
  end
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
  local SelectedRankNum = self.SelectedRankNumByTab and self.SelectedRankNumByTab[self.TabId or 1]
  if SelectedRankNum then
    Index = SelectedRankNum - 1
  end
  self:FocusSelectedListEntry(Index, true)
end

function M:GetDesiredFocusTarget()
  if self:IsRankingListEmpty() then
    return self.Com_Empty or self
  end
  return self:GetLastClickedRankItemWidget() or self
end

function M:BP_GetDesiredFocusTarget()
  return self:GetDesiredFocusTarget()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    if self.IsShowActor and self.PreviewScene and self.PreviewScene.Controller then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.PreviewScene.Controller:OnDragViewActor({X = DeltaX})
      return UIUtils.Handled
    end
    return UIUtils.Unhandled
  end
  return UIUtils.Unhandled
end

return M
