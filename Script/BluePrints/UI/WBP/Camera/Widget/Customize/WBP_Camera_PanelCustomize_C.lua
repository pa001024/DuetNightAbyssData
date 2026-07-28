require("UnLua")
local Utils = require("BluePrints.UI.WBP.Camera.CameraCustomizeUtils")
local TabSubItem07BPPath = "/Game/UI/WBP/Common/Tab/Widget/WBP_Com_TabSubItem07.WBP_Com_TabSubItem07"
local TabClickSound = "event:/ui/common/click_btn_sort_tab"
local TabIconPathMap = {
  Basic = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Role.T_Tab_Role",
  Action = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Action.T_Tab_Action",
  Selection = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_SettingDisplay.T_Tab_SettingDisplay"
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.CurrentTabIndex = 1
  self.FocusIndex = 1
end

function M:Init(Config, OwnerPanel)
  self.Config = Config
  self.OwnerPanel = OwnerPanel
  self.CurrentTabIndex = 1
  self.FocusIndex = 1
  self:RefreshTabs()
  self:RefreshPanel()
end

function M:RefreshTabs()
  self.TabItems = {}
  if not self.Config then
    return
  end
  for Index, Tab in ipairs(self.Config.Tabs or {}) do
    self.TabItems[Index] = Tab
  end
  if self.Tab_Customize and self.Tab_Customize.Init then
    local TabData = {}
    for Index, Tab in ipairs(self.TabItems) do
      TabData[Index] = {
        Text = Tab.Text,
        TabId = Tab.Id,
        IsNew = Tab.HasNew == true,
        HideText = true,
        IconPath = TabIconPathMap[Tab.Id]
      }
    end
    self.CurSelectTabWidget = nil
    self.Tab_Customize.bUserTabItemSizeAuto = true
    self.Tab_Customize:Init({
      Tabs = TabData,
      OwnerPanel = self,
      PlatformName = self.OwnerPanel and self.OwnerPanel.GetPlatformName and self.OwnerPanel:GetPlatformName(),
      LeftKey = "Q",
      RightKey = "E",
      LeftGamePadKey = "LeftShoulder",
      RightGamePadKey = "RightShoulder",
      ChildWidgetBPPath = TabSubItem07BPPath
    })
    if self.Tab_Customize.BindEventOnTabSelected then
      self.Tab_Customize:BindEventOnTabSelected(self, self.OnTabSelected)
    end
    if self.Tab_Customize.SelectTab then
      self.bSuppressTabSelectSound = true
      self.Tab_Customize:SelectTab(self.CurrentTabIndex)
      self.bSuppressTabSelectSound = false
    end
  end
end

function M:OnTabSelected(TabWidget)
  if TabWidget and TabWidget.Idx then
    if not self.bSuppressTabSelectSound and AudioManager then
      AudioManager(self):PlayUISound(self.Tab_Customize or self, TabClickSound, nil, nil)
    end
    self:SelectTab(TabWidget.Idx, TabWidget)
  end
end

function M:RefreshPanel()
  local Tab = self.TabItems and self.TabItems[self.CurrentTabIndex]
  if self.CustomizeList and self.CustomizeList.Init then
    self.CustomizeList:Init(Tab, self)
  end
  self:FocusDefaultItem()
  self:RefreshNewState()
end

function M:RefreshNewState()
  if not self.TabItems or not self.OwnerPanel then
    return
  end
  for _, Tab in ipairs(self.TabItems) do
    Tab.HasNew = self:HasNewInTab(Tab)
  end
  if self.Tab_Customize and self.Tab_Customize.ShowTabRedDot then
    for Index, Tab in ipairs(self.TabItems) do
      self.Tab_Customize:ShowTabRedDot(Index, Tab.HasNew == true)
    end
  end
  if self.CustomizeList and self.CustomizeList.RefreshNewState then
    self.CustomizeList:RefreshNewState()
  end
end

function M:RefreshValue()
  if self.CustomizeList and self.CustomizeList.RefreshValue then
    self.CustomizeList:RefreshValue()
  end
end

function M:HasNewInTab(Tab)
  if not Tab or not self.Config then
    return false
  end
  for _, ItemId in ipairs(Tab.Items or {}) do
    local ItemConfig = self.Config.Items[ItemId]
    if self.OwnerPanel.HasNewInItem(self.OwnerPanel, ItemConfig) then
      return true
    end
  end
  return false
end

function M:GetTabWidget(Index)
  if self.Tab_Customize and self.Tab_Customize.List_Tab then
    return self.Tab_Customize.List_Tab:GetChildAt(math.max(Index - 1, 0))
  end
  return nil
end

function M:RefreshSelectedTabText(TabWidget)
  if self.CurSelectTabWidget and self.CurSelectTabWidget ~= TabWidget and self.CurSelectTabWidget.ShowText then
    self.CurSelectTabWidget:ShowText(false)
  end
  self.CurSelectTabWidget = TabWidget
  if self.CurSelectTabWidget and self.CurSelectTabWidget.ShowText then
    self.CurSelectTabWidget:ShowText(true)
  end
end

function M:SelectTab(Index, TabWidget)
  if not self.TabItems or not self.TabItems[Index] then
    return
  end
  self.CurrentTabIndex = Index
  self.FocusIndex = 1
  self:RefreshSelectedTabText(TabWidget or self:GetTabWidget(Index))
  self:RefreshPanel()
end

function M:FocusDefaultItem()
  if self.CustomizeList and self.CustomizeList.FocusDefaultItem then
    self.CustomizeList:FocusDefaultItem()
  end
end

function M:RefreshGamePadFocus()
  if self.CustomizeList and self.CustomizeList.RefreshCurrentFocus then
    self.CustomizeList:RefreshCurrentFocus()
  elseif self.CustomizeList and self.CustomizeList.FocusDefaultItem then
    self.CustomizeList:FocusDefaultItem()
  end
end

function M:ResetGamePadFocusStyle()
  if self.CustomizeList and self.CustomizeList.ResetGamePadFocusStyle then
    self.CustomizeList:ResetGamePadFocusStyle()
  end
end

function M:SelectNextTab()
  if not self.TabItems or 0 == #self.TabItems then
    return
  end
  if self.Tab_Customize and self.Tab_Customize.TabToRight then
    self.Tab_Customize:TabToRight()
    return
  end
  local NextIndex = self.CurrentTabIndex + 1
  if NextIndex > #self.TabItems then
    NextIndex = 1
  end
  self:SelectTab(NextIndex)
end

function M:SelectPrevTab()
  if not self.TabItems or 0 == #self.TabItems then
    return
  end
  if self.Tab_Customize and self.Tab_Customize.TabToLeft then
    self.Tab_Customize:TabToLeft()
    return
  end
  local PrevIndex = self.CurrentTabIndex - 1
  if PrevIndex < 1 then
    PrevIndex = #self.TabItems
  end
  self:SelectTab(PrevIndex)
end

function M:MoveFocus(Delta)
  if self.CustomizeList and self.CustomizeList.MoveFocus then
    return self.CustomizeList:MoveFocus(Delta)
  end
  return false
end

function M:HandleConfirm()
  if self.CustomizeList and self.CustomizeList.HandleConfirm then
    return self.CustomizeList:HandleConfirm()
  end
  return false
end

function M:GetFocusedControllerOpInfo()
  if self.CustomizeList and self.CustomizeList.GetFocusedControllerOpInfo then
    return self.CustomizeList:GetFocusedControllerOpInfo()
  end
  return nil
end

function M:HandleLeftRight(Delta)
  if self.CustomizeList and self.CustomizeList.HandleLeftRight then
    return self.CustomizeList:HandleLeftRight(Delta)
  end
  return false
end

function M:HandleGamePadKeyDown(InKeyName)
  if self.CustomizeList and self.CustomizeList.HandleGamePadKeyDown then
    return self.CustomizeList:HandleGamePadKeyDown(InKeyName)
  end
  return false
end

function M:HandleGamePadKeyUp(InKeyName)
  if self.CustomizeList and self.CustomizeList.HandleGamePadKeyUp then
    return self.CustomizeList:HandleGamePadKeyUp(InKeyName)
  end
  return false
end

function M:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  if self.CustomizeList and self.CustomizeList.HandleGamePadAnalog then
    return self.CustomizeList:HandleGamePadAnalog(AxisName, DirectionKey, Value)
  end
  return false
end

function M:HandleKeyEventOnPC(InKeyName)
  if self.Tab_Customize and self.Tab_Customize.Handle_KeyEventOnPC then
    return self.Tab_Customize:Handle_KeyEventOnPC(InKeyName)
  end
  if "Q" == InKeyName then
    self:SelectPrevTab()
    return true
  elseif "E" == InKeyName then
    self:SelectNextTab()
    return true
  end
  return false
end

function M:OnItemValueChanged(ItemConfig, Value, Extra)
  local bSuccess = true
  if self.OwnerPanel and self.OwnerPanel.NotifyCustomizeValueChanged then
    bSuccess = self.OwnerPanel:NotifyCustomizeValueChanged(ItemConfig, Value, Extra)
  end
  self:RefreshValue()
  if false ~= bSuccess then
    self:RefreshNewState()
  end
  return false ~= bSuccess
end

function M:ClearNew(NewKey)
  if self.OwnerPanel and self.OwnerPanel.ClearNew then
    self.OwnerPanel:ClearNew(NewKey)
  end
end

function M:IsNewVisible(NewKey)
  if self.OwnerPanel and self.OwnerPanel.IsNewVisible then
    return self.OwnerPanel:IsNewVisible(NewKey)
  end
  return false
end

function M:GetValue(ItemConfig)
  if self.OwnerPanel and self.OwnerPanel.GetCustomizeValue then
    return self.OwnerPanel:GetCustomizeValue(ItemConfig)
  end
  return ItemConfig and ItemConfig.DefaultValue
end

return M
