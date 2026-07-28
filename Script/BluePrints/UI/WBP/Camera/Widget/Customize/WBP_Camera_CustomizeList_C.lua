require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.FocusIndex = 1
  self.ItemContents = {}
end

function M:Init(TabConfig, OwnerPanel)
  self.TabConfig = TabConfig
  self.OwnerPanel = OwnerPanel
  self.FocusIndex = 1
  self:DisableListScroll()
  self:BuildList()
end

function M:DisableListScroll()
  local List = self.List_Customize
  if not List then
    return
  end
  if List.SetScrollbarVisibility then
    List:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if List.SetAllowOverscroll then
    List:SetAllowOverscroll(false)
  end
  if List.SetWheelScrollMultiplier then
    List:SetWheelScrollMultiplier(0)
  end
  if List.SetConsumeMouseWheel and EConsumeMouseWheel then
    List:SetConsumeMouseWheel(EConsumeMouseWheel.Never)
  elseif EConsumeMouseWheel then
    List.ConsumeMouseWheel = EConsumeMouseWheel.Never
  end
  if List.SetScrollWhenFocusChanges and UE4.EScrollWhenFocusChanges then
    List:SetScrollWhenFocusChanges(UE4.EScrollWhenFocusChanges.NoScroll)
  end
end

function M:BuildList()
  self.ItemContents = {}
  if self.List_Customize then
    self.List_Customize:ClearListItems()
  end
  if not (self.TabConfig and self.OwnerPanel) or not self.OwnerPanel.Config then
    return
  end
  for _, ItemId in ipairs(self.TabConfig.Items or {}) do
    local ItemConfig = self.OwnerPanel.Config.Items[ItemId]
    if ItemConfig then
      local Content = Utils.GetCommonItemContent()
      Content.Config = ItemConfig
      Content.OwnerPanel = self.OwnerPanel
      Content.ParentList = self
      Content.IsFocused = false
      table.insert(self.ItemContents, Content)
      if self.List_Customize then
        self.List_Customize:AddItem(Content)
      end
    end
  end
  self:RefreshFocus("Default")
end

function M:RegisterEntry(Content, EntryWidget)
  if Content then
    Content.EntryWidget = EntryWidget
    if Content.IsFocused then
      self:UpdateGamePadFocusWidget(Content)
    end
  end
end

function M:FocusDefaultItem()
  self.FocusIndex = 1
  self:RefreshFocus("Default")
end

function M:RefreshCurrentFocus()
  self:RefreshFocus("InputModeChanged")
end

function M:ResetGamePadFocusStyle()
  for _, Content in ipairs(self.ItemContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.ResetGamePadFocusStyle then
      Content.EntryWidget:ResetGamePadFocusStyle()
    end
  end
end

function M:RefreshNewState()
  for _, Content in ipairs(self.ItemContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.RefreshNewState then
      Content.EntryWidget:RefreshNewState()
    end
  end
end

function M:RefreshValue()
  for _, Content in ipairs(self.ItemContents or {}) do
    if Content.EntryWidget and Content.EntryWidget.RefreshValue then
      Content.EntryWidget:RefreshValue()
    end
  end
end

function M:MoveFocus(Delta)
  local Count = #(self.ItemContents or {})
  if 0 == Count then
    return false
  end
  self.FocusIndex = self.FocusIndex + Delta
  if self.FocusIndex < 1 then
    self.FocusIndex = Count
  elseif Count < self.FocusIndex then
    self.FocusIndex = 1
  end
  self:RefreshFocus("Navigation")
  return true
end

function M:RefreshFocus(FocusEnterReason)
  for Index, Content in ipairs(self.ItemContents or {}) do
    Content.IsFocused = Index == self.FocusIndex
    if Content.EntryWidget and Content.EntryWidget.RefreshFocus then
      Content.EntryWidget:RefreshFocus(FocusEnterReason)
    end
  end
  local FocusContent = self.ItemContents and self.ItemContents[self.FocusIndex]
  self:UpdateGamePadFocusWidget(FocusContent)
end

function M:UpdateGamePadFocusWidget(Content, bSkipDelay)
  local EntryWidget = Content and Content.EntryWidget
  if not EntryWidget then
    return
  end
  if self.List_Customize and self.List_Customize.BP_CancelScrollIntoView then
    self.List_Customize:BP_CancelScrollIntoView()
  end
  if EntryWidget.SetFocus then
    EntryWidget:SetFocus()
  end
  local Host = self.OwnerPanel and self.OwnerPanel.OwnerPanel
  if Host and Host.RefreshCameraCustomizeGamePadCursor then
    Host:RefreshCameraCustomizeGamePadCursor(EntryWidget)
  else
    local Subsystem = Host and Host.GameInputModeSubsystem
    if Subsystem and Subsystem.SetTargetUIFocusWidget then
      if Subsystem.SetNavigateWidgetOpacity then
        Subsystem:SetNavigateWidgetOpacity(1)
      end
      Subsystem:SetTargetUIFocusWidget(EntryWidget)
      if Subsystem.UpdateCurrentFocusWidgetPos then
        Subsystem:UpdateCurrentFocusWidgetPos()
      end
    end
  end
  if not (not bSkipDelay and Host) or not Host.AddDelayFrameFunc then
    return
  end
  local DelayContent = Content
  local DelayEntryWidget = EntryWidget
  local DelayKey = "CameraCustomizeListFocus_" .. tostring(Content.Config and Content.Config.Id or self.FocusIndex)
  Host:AddDelayFrameFunc(function()
    if DelayContent and DelayContent.IsFocused == true and DelayContent.EntryWidget == DelayEntryWidget then
      self:UpdateGamePadFocusWidget(DelayContent, true)
    end
  end, 1, DelayKey)
end

function M:GetFocusEntry()
  local Content = self.ItemContents and self.ItemContents[self.FocusIndex]
  return Content and Content.EntryWidget or nil
end

function M:GetFocusedControllerOpInfo()
  local Entry = self:GetFocusEntry()
  if Entry and Entry.GetControllerOpInfo then
    return Entry:GetControllerOpInfo()
  end
  return nil
end

function M:RefreshFocusedGamePadWidget()
  local Content = self.ItemContents and self.ItemContents[self.FocusIndex]
  if Content then
    self:UpdateGamePadFocusWidget(Content, true)
  end
end

function M:IsFocusedActionItem()
  local Content = self.ItemContents and self.ItemContents[self.FocusIndex]
  return Content and Content.Config and Content.Config.Type == Utils.ItemType.Action
end

function M:IsFocusedInnerContainerItem()
  local Content = self.ItemContents and self.ItemContents[self.FocusIndex]
  return Content and Content.Config and (Content.Config.Type == Utils.ItemType.Action or Content.Config.Type == Utils.ItemType.Selection)
end

function M:HandleConfirm()
  local Entry = self:GetFocusEntry()
  if Entry and Entry.HandleConfirm then
    local bHandled = Entry:HandleConfirm() ~= false
    if bHandled then
      self:RefreshFocusedGamePadWidget()
    end
    return bHandled
  end
  return false
end

function M:HandleLeftRight(Delta)
  local Entry = self:GetFocusEntry()
  if Entry and Entry.HandleLeftRight then
    local bHandled = Entry:HandleLeftRight(Delta)
    if bHandled then
      self:RefreshFocusedGamePadWidget()
    end
    return bHandled
  end
  return false
end

function M:HandleGamePadKeyDown(InKeyName)
  local Entry = self:GetFocusEntry()
  if Entry and Entry.HandleGamePadKeyDown then
    local bHandled = Entry:HandleGamePadKeyDown(InKeyName)
    if bHandled then
      self:RefreshFocusedGamePadWidget()
    end
    return bHandled
  end
  return false
end

function M:HandleGamePadKeyUp(InKeyName)
  local Entry = self:GetFocusEntry()
  if Entry and Entry.HandleGamePadKeyUp then
    local bHandled = Entry:HandleGamePadKeyUp(InKeyName)
    if bHandled then
      self:RefreshFocusedGamePadWidget()
    end
    return bHandled
  end
  return false
end

function M:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  if not DirectionKey then
    local Entry = self:GetFocusEntry()
    if Entry and Entry.HandleGamePadAnalog then
      local bHandled = Entry:HandleGamePadAnalog(AxisName, DirectionKey, Value)
      if bHandled then
        self:RefreshFocusedGamePadWidget()
      end
      return bHandled
    end
    return false
  end
  local Entry = self:GetFocusEntry()
  if Entry and Entry.HandleGamePadDirection and Entry:HandleGamePadDirection(DirectionKey) then
    if not self:IsFocusedInnerContainerItem() then
      self:RefreshFocusedGamePadWidget()
    end
    return true
  end
  if DirectionKey == UIConst.GamePadKey.LeftStickUp or DirectionKey == UIConst.GamePadKey.DPadUp then
    return self:MoveFocus(-1)
  elseif DirectionKey == UIConst.GamePadKey.LeftStickDown or DirectionKey == UIConst.GamePadKey.DPadDown then
    return self:MoveFocus(1)
  elseif DirectionKey == UIConst.GamePadKey.LeftStickLeft or DirectionKey == UIConst.GamePadKey.DPadLeft then
    self:RefreshFocusedGamePadWidget()
    return true
  elseif DirectionKey == UIConst.GamePadKey.LeftStickRight or DirectionKey == UIConst.GamePadKey.DPadRight then
    self:RefreshFocusedGamePadWidget()
    return true
  end
  return false
end

return M
