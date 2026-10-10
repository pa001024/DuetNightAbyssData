require("UnLua")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local SelectedVisualWidgetNames = {
  "Hover_1",
  "Hover_2",
  "Hover_3",
  "Hover_Glow",
  "Hover_glow_02",
  "Hover_Glow_1",
  "Hover_glow_2"
}

function M:Construct()
  self:EnsureBtnAeraBindings()
  self:InitNavigation()
end

function M:EnsureBtnAeraBindings()
  if self._bBtnAeraBound or not self.Btn_Aera then
    return
  end
  self.Btn_Aera.OnClicked:Clear()
  self.Btn_Aera.OnClicked:Add(self, self.OnButtonClicked)
  self.Btn_Aera.OnHovered:Clear()
  self.Btn_Aera.OnHovered:Add(self, self.OnButonHovered)
  self.Btn_Aera.OnUnhovered:Clear()
  self.Btn_Aera.OnUnhovered:Add(self, self.OnButonUnhovered)
  self.Btn_Aera.OnPressed:Clear()
  self.Btn_Aera.OnPressed:Add(self, self.OnButonPressed)
  self._bBtnAeraBound = true
end

function M:Destruct()
  self:CloseHeadMenu()
  if self.Btn_Aera then
    self.Btn_Aera.OnClicked:Clear()
    self.Btn_Aera.OnHovered:Clear()
    self.Btn_Aera.OnUnhovered:Clear()
    self.Btn_Aera.OnPressed:Clear()
  end
  self._bBtnAeraBound = false
  self:DetachContent()
  self.NameColumnWidget = nil
end

function M:DetachContent()
  if not self.Content then
    return
  end
  if self.Content.SelfWidget == self then
    self.Content.SelfWidget = nil
  end
  self.Content = nil
end

function M:IsGamepadInput()
  local ParentWidget = self.ParentWidget
  if ParentWidget and ParentWidget.IsGamePad ~= nil then
    return ParentWidget.IsGamePad == true
  end
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:IsMouseHovering()
  if self:IsGamepadInput() then
    return false
  end
  return self._bRowHovered == true
end

function M:IsMyselfBar()
  if self._bIsMyselfBar then
    return true
  end
  if self.Content and self.Content.bIsSelfRow then
    return true
  end
  local ParentWidget = not self.ParentWidget and self.Content and self.Content.ParentWidget
  return nil ~= ParentWidget and ParentWidget.Ranking_Myself == self
end

function M:IsContentSelected(Content)
  if not Content or Content.Empty or Content.bIsSelfRow or self:IsMyselfBar() then
    return false
  end
  local ParentWidget = Content.ParentWidget or self.ParentWidget
  if not (ParentWidget and ParentWidget.SelectedRankNumByTab) or not Content.TabId then
    return false
  end
  return ParentWidget.SelectedRankNumByTab[Content.TabId] == Content.RankNum
end

function M:OnListItemObjectSet(Content)
  self:EnsureBtnAeraBindings()
  Content.SelfWidget = self
  self.Content = Content
  self.RankInfo = Content.RankInfo
  self.RankNum = Content.RankNum
  self.ParentWidget = Content.ParentWidget
  self.CallbackObj = Content.CallbackObj
  self.ClickCallback = Content.ClickCallback
  self.MenuOpenCallback = Content.MenuOpenCallback
  self.NameColumnWidget = nil
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  self:InitColumns(Content.Columns)
  if Content.Empty then
    self.bIsFocusable = false
    if self.SetIsFocusable then
      self:SetIsFocusable(false)
    end
    self:ApplySelectedState(false, false)
    return
  end
  self.bIsFocusable = true
  if self.SetIsFocusable then
    self:SetIsFocusable(true)
  end
  self:ApplySelectedState(self:IsContentSelected(Content), false)
end

function M:BP_OnEntryReleased()
  self:CloseHeadMenu()
  self:DetachContent()
  self._bRowHovered = false
  self:StopAllAnimations()
  self:ApplySelectedState(false, false)
end

function M:InitColumns(Columns)
  if not self.HBox_Info then
    return
  end
  Columns = Columns or {}
  local ChildCount = self.HBox_Info:GetChildrenCount()
  local bCanReuse = ChildCount == #Columns
  if bCanReuse then
    for Index, Column in ipairs(Columns) do
      local Child = self.HBox_Info:GetChildAt(Index - 1)
      if not Child or Child._RankingColumnType ~= Column.Type then
        bCanReuse = false
        break
      end
    end
  end
  if not bCanReuse then
    self.HBox_Info:ClearChildren()
    self.NameColumnWidget = nil
    for _, Column in ipairs(Columns) do
      local WidgetPath = ComRankingUtils.ColumnWidgetPathByType[Column.Type]
      if WidgetPath then
        local ColumnWidget = UIManager(self):CreateWidget(WidgetPath)
        if ColumnWidget then
          ColumnWidget._RankingColumnType = Column.Type
          self.HBox_Info:AddChild(ColumnWidget)
          self:ApplyColumnInit(ColumnWidget, Column)
        end
      end
    end
    return
  end
  self.NameColumnWidget = nil
  for Index, Column in ipairs(Columns) do
    local Child = self.HBox_Info:GetChildAt(Index - 1)
    if Child then
      self:ApplyColumnInit(Child, Column)
    end
  end
end

function M:ApplyColumnInit(ColumnWidget, Column)
  if Column.Type == "Name" then
    self.NameColumnWidget = ColumnWidget
    if self.Content and self.Content.Empty then
      Column.MenuOpenCallback = nil
      Column.OnHeadClicked = nil
    else
      function Column.MenuOpenCallback(bOpen)
        self:ForwardHeadMenuOpenChanged(bOpen)
      end
      
      function Column.OnHeadClicked()
        self:OnButtonClicked()
      end
      
      function Column.OpenHeadMenuDeferred()
        self:OpenHeadMenu()
      end
    end
  end
  ColumnWidget:Init(Column)
end

function M:ForwardHeadMenuOpenChanged(bOpen)
  if self.MenuOpenCallback and self.CallbackObj then
    self.MenuOpenCallback(self.CallbackObj, bOpen)
  end
end

function M:OpenHeadMenu()
  if not self.NameColumnWidget then
    return false
  end
  local Panel = self.ParentWidget
  if Panel and Panel.CloseOpenedRankHeadMenus then
    Panel:CloseOpenedRankHeadMenus(self)
  end
  
  local function OpenFunc()
    if IsValid(self) and IsValid(self.NameColumnWidget) then
      self.NameColumnWidget:OpenHeadMenu()
    end
  end
  
  if Panel and Panel.AddTimer then
    Panel:AddTimer(0.001, OpenFunc, false, 0, "RankingHeadMenuDeferredOpen", true)
  else
    OpenFunc()
  end
  return true
end

function M:IsHeadMenuOpen()
  return self.NameColumnWidget and self.NameColumnWidget:IsHeadMenuOpen()
end

function M:CloseHeadMenu()
  if IsValid(self.NameColumnWidget) then
    self.NameColumnWidget:CloseHeadMenu()
  end
end

function M:GetHeadMenuWidget()
  return self.NameColumnWidget and self.NameColumnWidget.HeadMenuWidget
end

function M:OnButtonClicked()
  if self.Content and self.Content.Empty then
    return
  end
  if self.CallbackObj and self.ClickCallback and type(self.ClickCallback) == "function" then
    self.ClickCallback(self.CallbackObj, self.Content)
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self:IsMyselfBar() then
    self._bSelfRowPointerDown = true
  end
  return UIUtils.Unhandled
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self._bSelfRowPointerDown and self:IsMyselfBar() then
    self._bSelfRowPointerDown = false
    self:OnButtonClicked()
    return UIUtils.Handled
  end
  self._bSelfRowPointerDown = false
  return UIUtils.Unhandled
end

function M:OnMouseLeave(MouseEvent)
  self._bSelfRowPointerDown = false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local ParentWidget = self.ParentWidget
  local Content = self.Content
  local bCanSelect = Content and not Content.Empty and not Content.bIsSelfRow
  if bCanSelect and ParentWidget and ParentWidget.IsGamePad and ParentWidget.OnListRankItemClicked then
    ParentWidget:OnListRankItemClicked(Content, true)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:StopRankItemStateAnimations()
  self:StopAnimation(self.Click)
  self:StopAnimation(self.Normal)
  self:StopAnimation(self.Hover)
  self:StopAnimation(self.UnHover)
  self:StopAnimation(self.Press)
end

function M:SnapAnimationToEnd(Anim)
  if not Anim then
    return
  end
  self:PlayAnimation(Anim)
  if self.SetAnimationCurrentTime and Anim.GetEndTime then
    local EndTime = Anim:GetEndTime()
    if EndTime and EndTime > 0 then
      self:SetAnimationCurrentTime(Anim, math.max(EndTime - 0.01, 0))
    end
  end
end

function M:InvalidateHoverRetainers()
  if self.RetainerBox and self.RetainerBox.RequestRender then
    self.RetainerBox:RequestRender()
  end
  if self.RetainerBox_0 and self.RetainerBox_0.RequestRender then
    self.RetainerBox_0:RequestRender()
  end
end

function M:FindSelectedVisualWidget(Name)
  if self.GetWidgetFromName then
    local Widget = self:GetWidgetFromName(Name)
    if Widget then
      return Widget
    end
  end
  if self[Name] then
    return self[Name]
  end
  if self.WidgetTree and self.WidgetTree.FindWidget then
    return self.WidgetTree:FindWidget(Name)
  end
  return nil
end

function M:ApplySelectedState(bSelected, bPlayAnim)
  if self:IsMyselfBar() then
    bSelected = false
  end
  bSelected = true == bSelected
  self.StopProcess = bSelected
  self:StopRankItemStateAnimations()
  if true == bPlayAnim then
    self:SetSelectedVisual(bSelected)
    local Anim
    if bSelected then
      Anim = self.Click
    elseif self:IsMouseHovering() then
      Anim = self.Hover
    else
      Anim = self.Normal
    end
    if Anim then
      self:PlayAnimation(Anim)
    end
    return
  end
  if bSelected then
    self:SnapAnimationToEnd(self.Click)
  else
    self:SnapAnimationToEnd(self.Normal)
  end
  self:SetSelectedVisual(bSelected)
end

function M:PlayNormalAnimation()
  self:ApplySelectedState(false, true)
end

function M:PlaySelectedAnimation()
  self:ApplySelectedState(true, true)
end

function M:SetSelectedVisual(bSelected)
  local Opacity = bSelected and 1 or 0
  for _, Name in ipairs(SelectedVisualWidgetNames) do
    local Widget = self:FindSelectedVisualWidget(Name)
    if Widget and Widget.SetRenderOpacity then
      Widget:SetRenderOpacity(Opacity)
    end
  end
  self:InvalidateHoverRetainers()
end

function M:PlayClickedAnimation()
  self:ApplySelectedState(true, true)
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:IsListScrolling()
  local ParentWidget = self.ParentWidget
  return nil ~= ParentWidget and ParentWidget.bRankingListScrolling == true
end

function M:ClearRowHoverVisual()
  self._bRowHovered = false
  if self:IsGamepadInput() or self:IsStopProcessEvent() or self:IsMyselfBar() then
    return
  end
  self:StopAnimation(self.Hover)
  self:StopAnimation(self.UnHover)
  self:SnapAnimationToEnd(self.Normal)
  self:SetSelectedVisual(false)
end

function M:SetRowHovered(bHovered)
  bHovered = true == bHovered
  if true == self._bRowHovered == bHovered then
    return
  end
  self._bRowHovered = bHovered
  if self:IsGamepadInput() or self:IsStopProcessEvent() then
    return
  end
  if self:IsListScrolling() then
    if not bHovered then
      self:ClearRowHoverVisual()
    end
    return
  end
  if bHovered then
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
  else
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnButonHovered()
  self:SetRowHovered(true)
end

function M:OnButonUnhovered()
  self:SetRowHovered(false)
end

function M:OnButonPressed()
  if self:IsGamepadInput() or self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:InitNavigation()
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:HandleNavigationUp()
  if not (self.RankNum and self.ParentWidget) or not self.ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = self.RankNum - 1
  if CurIndex > 0 then
    local TargetIndex = CurIndex - 1
    self.ParentWidget.List_Ranking:NavigateToIndex(TargetIndex)
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ParentWidget.List_Ranking, TargetIndex)
    if EntryWidget then
      return EntryWidget
    end
    if self.ParentWidget.FocusSelectedListEntry then
      self.ParentWidget:FocusSelectedListEntry(TargetIndex, true)
    end
    return self
  end
  return self
end

function M:HandleNavigationDown()
  if not (self.RankNum and self.ParentWidget) or not self.ParentWidget.List_Ranking then
    return nil
  end
  local CurIndex = self.RankNum - 1
  local MaxIndex = self.ParentWidget.ValidItemNum - 1
  if CurIndex < MaxIndex then
    local TargetIndex = CurIndex + 1
    self.ParentWidget.List_Ranking:NavigateToIndex(TargetIndex)
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.ParentWidget.List_Ranking, TargetIndex)
    if EntryWidget then
      return EntryWidget
    end
    if self.ParentWidget.FocusSelectedListEntry then
      self.ParentWidget:FocusSelectedListEntry(TargetIndex, true)
    end
    return self
  end
  return self
end

return M
