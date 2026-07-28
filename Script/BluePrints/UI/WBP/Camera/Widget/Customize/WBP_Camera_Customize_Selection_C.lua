require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.FocusIndex = 1
  self.OptionContents = {}
  self.bParentFocused = false
  self.bChildFocusActive = false
end

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  self.Value = {}
  local SavedValue = OwnerPanel and OwnerPanel:GetValue(Config) or Config.DefaultValue
  for Key, Value in pairs(SavedValue or {}) do
    self.Value[Key] = true == Value
  end
  self.FocusIndex = 1
  self.bParentFocused = false
  self.bChildFocusActive = false
  self:BuildList()
end

function M:BuildList()
  self.OptionContents = {}
  local List = self.List_Selection or self.List_SelectionCheckBox
  if List then
    List:ClearListItems()
  end
  if self.Config and self.Config.AllowAll then
    self:AddOptionContent({
      Id = "__all",
      Text = "全部",
      NewKey = self.Config.NewKey
    }, List)
  end
  for _, Option in ipairs(self.Config and self.Config.Options or {}) do
    self:AddOptionContent(Option, List)
  end
end

function M:AddOptionContent(Option, List)
  local Content = Utils.GetCommonItemContent()
  Content.Config = Option
  Content.ParentConfig = self.Config
  Content.OwnerPanel = self.OwnerPanel
  Content.ParentSelection = self
  Content.Index = #self.OptionContents + 1
  Content.IsFocused = Content.Index == self.FocusIndex
  table.insert(self.OptionContents, Content)
  if List then
    List:AddItem(Content)
  end
end

function M:RegisterEntry(Content, EntryWidget)
  if Content then
    Content.EntryWidget = EntryWidget
    if self.bParentFocused and self.bChildFocusActive and Content.IsFocused then
      self:UpdateGamePadFocusWidget(Content)
    end
  end
end

function M:IsOptionSelected(OptionId)
  if "__all" == OptionId then
    for _, Option in ipairs(self.Config and self.Config.Options or {}) do
      if self.Value[Option.Id] ~= true then
        return false
      end
    end
    return true
  end
  return self.Value[OptionId] == true
end

function M:SetOptionSelected(OptionId, bSelected)
  if "__all" == OptionId then
    for _, Option in ipairs(self.Config and self.Config.Options or {}) do
      self.Value[Option.Id] = true == bSelected
      if self.OwnerPanel then
        self.OwnerPanel:ClearNew(Option.NewKey)
        self.OwnerPanel:OnItemValueChanged(self.Config, true == bSelected, Option.Id)
      end
    end
  else
    self.Value[OptionId] = true == bSelected
    if self.OwnerPanel then
      self.OwnerPanel:OnItemValueChanged(self.Config, true == bSelected, OptionId)
    end
  end
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:RefreshValue()
  self:RefreshNewState()
end

function M:Refresh()
  self:RefreshValue()
  self:RefreshNewState()
end

function M:RefreshValue()
  self.Value = {}
  local SavedValue = self.OwnerPanel and self.OwnerPanel:GetValue(self.Config) or self.Config.DefaultValue
  for Key, Value in pairs(SavedValue or {}) do
    self.Value[Key] = true == Value
  end
  for _, Content in ipairs(self.OptionContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.RefreshValue then
      Content.EntryWidget:RefreshValue()
    elseif Content.EntryWidget and Content.EntryWidget.Refresh then
      Content.EntryWidget:Refresh()
    end
  end
end

function M:RefreshNewState()
  for _, Content in ipairs(self.OptionContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.RefreshNewState then
      Content.EntryWidget:RefreshNewState()
    end
  end
end

function M:ClearNew()
  if self.OwnerPanel then
    self.OwnerPanel:ClearNew(self.Config and self.Config.NewKey)
  end
  self:RefreshNewState()
end

function M:RefreshFocus(bFocused)
  self.bParentFocused = true == bFocused
  if not self.bParentFocused then
    self.bChildFocusActive = false
  end
  for Index, Content in ipairs(self.OptionContents or {}) do
    Content.IsFocused = self.bParentFocused and self.bChildFocusActive and Index == self.FocusIndex
    if Content.EntryWidget and Content.EntryWidget.RefreshFocus then
      Content.EntryWidget:RefreshFocus()
    end
  end
  if self.bParentFocused and self.bChildFocusActive then
    self:UpdateGamePadFocusWidget(self.OptionContents and self.OptionContents[self.FocusIndex])
  end
end

function M:OnParentFocusGained()
  self.FocusIndex = 1
  self.bChildFocusActive = true
  self:RefreshFocus(true)
end

function M:MoveFocus(Delta, bNoWrap)
  local Count = #(self.OptionContents or {})
  if 0 == Count then
    return false
  end
  local NextIndex = self.FocusIndex + Delta
  if bNoWrap and (NextIndex < 1 or Count < NextIndex) then
    return false
  end
  self.FocusIndex = NextIndex
  if self.FocusIndex < 1 then
    self.FocusIndex = Count
  elseif Count < self.FocusIndex then
    self.FocusIndex = 1
  end
  self.bChildFocusActive = true
  self:RefreshFocus(true)
  return true
end

function M:UpdateGamePadFocusWidget(Content)
  local EntryWidget = Content and Content.EntryWidget
  if not EntryWidget then
    return
  end
  local List = self.List_Selection or self.List_SelectionCheckBox
  local Index = Content.Index
  if List and List.SetSelectedIndex and Index then
    List:SetSelectedIndex(Index - 1)
  elseif List and List.BP_SetSelectedItem then
    List:BP_SetSelectedItem(Content)
  end
  if List and List.NavigateToIndex and Index then
    List:NavigateToIndex(Index - 1)
  elseif List and List.BP_NavigateToItem then
    List:BP_NavigateToItem(Content)
  end
  local Host = self.OwnerPanel and self.OwnerPanel.OwnerPanel
  if Host and Host.RefreshCameraCustomizeGamePadCursor then
    Host:RefreshCameraCustomizeGamePadCursor(EntryWidget)
  end
end

function M:HandleLeftRight(Delta)
  if not self.bChildFocusActive then
    self:OnParentFocusGained()
    return true
  end
  return self:MoveFocus(Delta, true)
end

function M:HandleConfirm()
  if not self.bChildFocusActive then
    self:OnParentFocusGained()
    return true
  end
  local Content = self.OptionContents and self.OptionContents[self.FocusIndex]
  if Content and Content.EntryWidget and Content.EntryWidget.HandleConfirm then
    Content.EntryWidget:HandleConfirm()
    return true
  end
  return false
end

function M:HandleGamePadDirection(DirectionKey)
  if not self.bChildFocusActive then
    self:OnParentFocusGained()
    return true
  end
  if DirectionKey == UIConst.GamePadKey.LeftStickLeft or DirectionKey == UIConst.GamePadKey.LeftStickUp or DirectionKey == UIConst.GamePadKey.DPadLeft or DirectionKey == UIConst.GamePadKey.DPadUp then
    return self:MoveFocus(-1, true)
  elseif DirectionKey == UIConst.GamePadKey.LeftStickRight or DirectionKey == UIConst.GamePadKey.LeftStickDown or DirectionKey == UIConst.GamePadKey.DPadRight or DirectionKey == UIConst.GamePadKey.DPadDown then
    return self:MoveFocus(1, true)
  end
  return false
end

return M
