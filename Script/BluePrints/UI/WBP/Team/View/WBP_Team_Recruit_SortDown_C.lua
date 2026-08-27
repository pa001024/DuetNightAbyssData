require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

local function GetOptionText(Option)
  if not Option then
    return ""
  end
  return Option.TextKey and GText(Option.TextKey) or Option.Text or ""
end

local function MakeContent(Owner, Option, Role, Index, FirstType)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Owner = Owner
  Content.Value = Option.Id
  Content.Index = Index
  Content.FirstType = FirstType
  Content.Role = Role
  Content.Text = GetOptionText(Option)
  Content.IsSelected = false
  Content.OnListItemClicked = Owner.OnListItemClicked
  Content.OnListItemHovered = Owner.OnListItemHovered
  Content.OnListItemFocused = Owner.OnListItemFocused
  return Content
end

local function RefreshSelection(Contents, SelectedValue)
  for _, Content in ipairs(Contents or {}) do
    Content.IsSelected = Content.Value == SelectedValue
    if Content.Entry and Content.Entry.OnEntrySelectionChanged then
      Content.Entry:OnEntrySelectionChanged()
    end
  end
end

local function IsGamepadInput()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:Construct()
  self.bIsFocusable = true
  self.FocusPathRequestId = 0
  self.CloseFocusRequestId = 0
  self.ListNavigationRefreshId = 0
  self.Filter_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Filter_List.AudioEventPath = "event:/ui/common/click"
  self.Btn_Filter_List.OnClicked:Add(self, self.ListOpenBtnClicked)
  self:AddInputMethodChangedListen()
end

function M:Destruct()
  self.FocusPathRequestId = (self.FocusPathRequestId or 0) + 1
  self.CloseFocusRequestId = (self.CloseFocusRequestId or 0) + 1
  self.ListNavigationRefreshId = (self.ListNavigationRefreshId or 0) + 1
  self.Btn_Filter_List.OnClicked:Remove(self, self.ListOpenBtnClicked)
  self.Callback = nil
  self.CallbackOwner = nil
  self.GetSecondTypeOptions = nil
  M.Super.Destruct(self)
end

function M:SetListForbidden(bForbidden)
  if bForbidden and self.IsListViewOpened then
    self:OnListClosed(false)
  end
  self.Btn_Filter_List:SetForbidden(bForbidden)
end

function M:InitTarget(FirstTypeOptions, GetSecondTypeOptions, SelectedFirstType, SelectedSecondType, CallbackOwner, Callback)
  self.Mode = "Target"
  self:SetListForbidden(false)
  self.FirstTypeOptions = FirstTypeOptions or {}
  self.GetSecondTypeOptions = GetSecondTypeOptions
  self.SelectedFirstType = SelectedFirstType
  self.PreviewFirstType = SelectedFirstType
  self.SelectedValue = SelectedSecondType
  self.PreviewValue = SelectedSecondType
  self.CallbackOwner = CallbackOwner
  self.Callback = Callback
  self.Group_Front:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.List_Front:SetVisibility(UIConst.VisibilityOp.Visible)
  self:RefreshTargetLists()
  self:RefreshDisplayText()
end

function M:InitSingle(Options, SelectedValue, CallbackOwner, Callback)
  self.Mode = "Single"
  self.Options = Options or {}
  self:SetListForbidden(#self.Options <= 1)
  self.SelectedValue = SelectedValue
  self.PreviewValue = SelectedValue
  self.CallbackOwner = CallbackOwner
  self.Callback = Callback
  self.Group_Front:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Front:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:RefreshSingleList()
  self:RefreshDisplayText()
end

function M:RefreshTargetLists()
  self.PreviewFirstType = self.PreviewFirstType or self.SelectedFirstType
  self.List_Front:ClearListItems()
  self.LeftContents = {}
  for Index, Option in ipairs(self.FirstTypeOptions or {}) do
    local Content = MakeContent(self, Option, "First", Index)
    self.LeftContents[#self.LeftContents + 1] = Content
    self.List_Front:AddItem(Content)
  end
  RefreshSelection(self.LeftContents, self.PreviewFirstType)
  self:RefreshSecondTypeList()
end

function M:RefreshSecondTypeList()
  self.List:ClearListItems()
  self.RightContents = {}
  local SecondTypeOptions = self.GetSecondTypeOptions and self.GetSecondTypeOptions(self.PreviewFirstType) or {}
  for Index, Option in ipairs(SecondTypeOptions or {}) do
    local Content = MakeContent(self, Option, "Second", Index, self.PreviewFirstType)
    self.RightContents[#self.RightContents + 1] = Content
    self.List:AddItem(Content)
  end
  RefreshSelection(self.RightContents, self.PreviewValue)
  self:ScheduleListNavigationRefresh()
end

function M:RefreshSingleList()
  self.List:ClearListItems()
  self.SingleContents = {}
  for Index, Option in ipairs(self.Options or {}) do
    local Content = MakeContent(self, Option, "Single", Index)
    self.SingleContents[#self.SingleContents + 1] = Content
    self.List:AddItem(Content)
  end
  RefreshSelection(self.SingleContents, self.PreviewValue)
  self:ScheduleListNavigationRefresh()
end

function M:RefreshDisplayText()
  local Text = ""
  if self.Mode == "Target" then
    local FirstText = ""
    local SecondText = ""
    for _, Option in ipairs(self.FirstTypeOptions or {}) do
      if Option.Id == self.SelectedFirstType then
        FirstText = GetOptionText(Option)
        break
      end
    end
    local Options = self.GetSecondTypeOptions and self.GetSecondTypeOptions(self.SelectedFirstType) or {}
    for _, Option in ipairs(Options) do
      if Option.Id == self.SelectedValue then
        SecondText = GetOptionText(Option)
        break
      end
    end
    Text = FirstText
    if "" ~= SecondText then
      Text = "" ~= Text and Text .. "·" .. SecondText or SecondText
    end
  else
    for _, Option in ipairs(self.Options or {}) do
      if Option.Id == self.SelectedValue then
        Text = GetOptionText(Option)
        break
      end
    end
  end
  self.Text_Filterlist:SetText(Text)
end

function M:ListOpenBtnClicked()
  if self.Btn_Filter_List:GetForbidden() then
    return
  end
  if self.IsListViewOpened then
    self:OnListClosed()
    return
  end
  self.CloseFocusRequestId = (self.CloseFocusRequestId or 0) + 1
  self.IsListViewOpened = true
  self.Filter_List:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.Mode == "Target" then
    self.PreviewFirstType = self.SelectedFirstType
    self.PreviewValue = self.SelectedValue
    self:RefreshTargetLists()
  else
    self.PreviewValue = self.SelectedValue
    self:RefreshSingleList()
  end
  self:ScheduleListNavigationRefresh(true)
end

function M:OnListClosed(bRestoreFocus)
  if not self.IsListViewOpened then
    return
  end
  self.IsListViewOpened = false
  self.ListNavigationRefreshId = (self.ListNavigationRefreshId or 0) + 1
  if self.List and self.List.BP_CancelScrollIntoView then
    self.List:BP_CancelScrollIntoView()
  end
  if self.List_Front and self.List_Front.BP_CancelScrollIntoView then
    self.List_Front:BP_CancelScrollIntoView()
  end
  self.Filter_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PreviewFirstType = self.SelectedFirstType
  self.PreviewValue = self.SelectedValue
  self.CloseFocusRequestId = (self.CloseFocusRequestId or 0) + 1
  local RequestId = self.CloseFocusRequestId
  if false ~= bRestoreFocus and IsGamepadInput() and self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(function()
      if not IsValid(self) or self.CloseFocusRequestId ~= RequestId or self.IsListViewOpened or not IsValid(self.Btn_Filter_List) then
        return
      end
      self.Btn_Filter_List:SetFocus()
    end, 1)
  end
end

function M:OnListItemHovered(Content)
  if not (self.Mode == "Target" and Content) or Content.Role ~= "First" then
    return
  end
  self:UpdatePreviewFirstType(Content.Value, false)
end

function M:UpdatePreviewFirstType(FirstType, bSelectPreview)
  local bFirstTypeChanged = self.PreviewFirstType ~= FirstType
  self.PreviewFirstType = FirstType
  self.PreviewValue = self.SelectedValue
  if bSelectPreview then
    RefreshSelection(self.LeftContents, self.PreviewFirstType)
  end
  if not bFirstTypeChanged then
    return
  end
  self:RefreshSecondTypeList()
end

function M:OnListItemFocused(Content)
  if not IsGamepadInput() or not Content then
    return
  end
  if self.Mode == "Target" and Content.Role == "First" then
    self:UpdatePreviewFirstType(Content.Value, false)
  end
end

function M:OnListItemClicked(Content)
  if not Content then
    return
  end
  if self.Mode == "Target" and Content.Role == "First" then
    self:UpdatePreviewFirstType(Content.Value, true)
    return
  end
  if self.Mode == "Target" then
    self.SelectedFirstType = Content.FirstType or self.PreviewFirstType
    self.PreviewFirstType = self.SelectedFirstType
    self.SelectedValue = Content.Value
    self.PreviewValue = self.SelectedValue
    RefreshSelection(self.LeftContents, self.SelectedFirstType)
    RefreshSelection(self.RightContents, self.PreviewValue)
    self:RefreshDisplayText()
    self:OnListClosed()
    if self.Callback then
      self.Callback(self.CallbackOwner, self.SelectedFirstType, self.SelectedValue)
    end
    return
  end
  self.SelectedValue = Content.Value
  self.PreviewValue = self.SelectedValue
  RefreshSelection(self.SingleContents, self.PreviewValue)
  self:RefreshDisplayText()
  self:OnListClosed()
  if self.Callback then
    self.Callback(self.CallbackOwner, self.SelectedValue)
  end
end

function M:ScheduleListNavigationRefresh(bMoveFocus)
  if not self.IsListViewOpened or not self.AddDelayFrameFunc then
    return
  end
  self.ListNavigationRefreshId = (self.ListNavigationRefreshId or 0) + 1
  local RequestId = self.ListNavigationRefreshId
  self:AddDelayFrameFunc(function()
    if not IsValid(self) or self.ListNavigationRefreshId ~= RequestId or not self.IsListViewOpened then
      return
    end
    self:UpdateListNavigation()
    if bMoveFocus then
      self:UpdateGamePadFocus()
    end
  end, 3)
end

function M:UpdateListNavigation()
  local LeftContents = self.Mode == "Target" and self.LeftContents or self.SingleContents
  local RightContents = self.Mode == "Target" and self.RightContents or nil
  local LeftSelectedButton, RightSelectedButton
  for _, Content in ipairs(LeftContents or {}) do
    if Content.Value == (self.Mode == "Target" and self.PreviewFirstType or self.PreviewValue) then
      LeftSelectedButton = Content.Entry and Content.Entry.BtnArea
      break
    end
  end
  for _, Content in ipairs(RightContents or {}) do
    if Content.Value == self.PreviewValue then
      RightSelectedButton = Content.Entry and Content.Entry.BtnArea
      break
    end
  end
  if not RightSelectedButton then
    for _, Content in ipairs(RightContents or {}) do
      local Entry = Content.Entry
      if Entry and Entry.BtnArea then
        RightSelectedButton = Entry.BtnArea
        break
      end
    end
  end
  for Index, Content in ipairs(LeftContents or {}) do
    local Entry = Content.Entry
    local Button = Entry and Entry.BtnArea
    if Button then
      local Previous = LeftContents[Index - 1] and LeftContents[Index - 1].Entry
      local Next = LeftContents[Index + 1] and LeftContents[Index + 1].Entry
      if Previous and Previous.BtnArea then
        Button:SetNavigationRuleExplicit(UE4.EUINavigation.Up, Previous.BtnArea)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
      end
      if Next and Next.BtnArea then
        Button:SetNavigationRuleExplicit(UE4.EUINavigation.Down, Next.BtnArea)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
      end
      if RightContents then
        if RightSelectedButton then
          Button:SetNavigationRuleExplicit(UE4.EUINavigation.Right, RightSelectedButton)
        else
          Button:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
        end
        Button:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
        Button:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
      end
    end
  end
  for Index, Content in ipairs(RightContents or {}) do
    local Entry = Content.Entry
    local Button = Entry and Entry.BtnArea
    if Button then
      local Previous = RightContents[Index - 1] and RightContents[Index - 1].Entry
      local Next = RightContents[Index + 1] and RightContents[Index + 1].Entry
      if Previous and Previous.BtnArea then
        Button:SetNavigationRuleExplicit(UE4.EUINavigation.Up, Previous.BtnArea)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
      end
      if Next and Next.BtnArea then
        Button:SetNavigationRuleExplicit(UE4.EUINavigation.Down, Next.BtnArea)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
      end
      if LeftSelectedButton then
        Button:SetNavigationRuleExplicit(UE4.EUINavigation.Left, LeftSelectedButton)
      else
        Button:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
      end
      Button:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
    end
  end
end

function M:UpdateGamePadFocus()
  if not (IsGamepadInput() and self.bAddedToFocusPath) or not self.IsListViewOpened then
    return
  end
  local Contents = self.Mode == "Target" and self.LeftContents or self.SingleContents
  local SelectedValue = self.Mode == "Target" and self.PreviewFirstType or self.PreviewValue
  for _, Content in ipairs(Contents or {}) do
    if Content.Value == SelectedValue then
      local ListView = self.Mode == "Target" and self.List_Front or self.List
      ListView:BP_NavigateToItem(Content)
      return
    end
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  self.bAddedToFocusPath = true
  self.FocusPathRequestId = (self.FocusPathRequestId or 0) + 1
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self.bAddedToFocusPath = false
  self.FocusPathRequestId = (self.FocusPathRequestId or 0) + 1
  local RequestId = self.FocusPathRequestId
  if not self.IsListViewOpened or not self.AddDelayFrameFunc then
    return
  end
  self:AddDelayFrameFunc(function()
    if not IsValid(self) or self.FocusPathRequestId ~= RequestId or not self.IsListViewOpened then
      return
    end
    if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
      self.bAddedToFocusPath = true
      return
    end
    self:OnListClosed(false)
  end, 1)
end

function M:ForwardRecruitPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonRight and self.IsListViewOpened then
    self:OnListClosed()
    return true
  end
  if self.CallbackOwner and self.CallbackOwner.HandleRecruitChildPreviewKeyDown then
    return self.CallbackOwner:HandleRecruitChildPreviewKeyDown(MyGeometry, InKeyEvent) == true
  end
  return false
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self:ForwardRecruitPreviewKeyDown(MyGeometry, InKeyEvent) then
    return UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnPreviewKeyDown(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self:ForwardRecruitPreviewKeyDown(MyGeometry, InKeyEvent) then
    return UWidgetBlueprintLibrary.Handled()
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:BP_GetDesiredFocusTarget()
  return self.Btn_Filter_List
end

return M
