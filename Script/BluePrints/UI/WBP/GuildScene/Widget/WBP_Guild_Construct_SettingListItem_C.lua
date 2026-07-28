require("UnLua")
require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.bIsFocusable = true
  self.FocusWidget = self
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  Content.SelfWidget = self
  local ItemData = Content.ItemData
  self.ItemData = ItemData
  self.Parent = Content.Parent
  self.GroupID = ItemData.GroupID
  self.ItemType = ItemData.ItemType
  self.Text_Title:SetText(GText(ItemData.GroupTitle))
  self:SetupByType(ItemData)
end

function M:SetupByType(ItemData)
  if ItemData.ItemType == "CheckBox" then
    self:SetupCheckBox(ItemData)
  elseif ItemData.ItemType == "Switch" then
    self:SetupSwitch(ItemData)
  elseif ItemData.ItemType == "Button" then
    self:SetupButton(ItemData)
  end
end

function M:SetupCheckBox(ItemData)
  self.FocusWidget = self.SwitchCheckBox.List
  self.WS_Item:SetActiveWidgetIndex(0)
  self.SwitchCheckBox.List:ClearListItems()
  local Options = ItemData.Options or {}
  for Index, Option in ipairs(Options) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Text = GText(Option.Label)
    Content.ParentWidget = self
    Content.Option = Option
    Content.InnerIndex = Index
    self.SwitchCheckBox.List:AddItem(Content)
  end
end

function M:OnCheckBoxChanged(Option, bIsChecked)
  if Option then
    Option.State = bIsChecked
    self.Parent:SaveEMSettinCache(Option)
  end
end

function M:SetupSwitch(ItemData)
  self.FocusWidget = self.Switch.List
  self.WS_Item:SetActiveWidgetIndex(1)
  self.Switch.List:ClearListItems()
  local Options = ItemData.Options or {}
  for Index, Option in ipairs(Options) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.LeftOption = Option[1]
    Content.RightOption = Option[2]
    Content.ParentWidget = self
    Content.InnerIndex = Index
    self.Switch.List:AddItem(Content)
  end
end

function M:OnSwitchClicked(LeftOption, RightOption, SelectedIndex)
  if not LeftOption or not RightOption then
    return
  end
  LeftOption.State = 1 == SelectedIndex
  self.Parent:SaveEMSettinCache(LeftOption)
  RightOption.State = 2 == SelectedIndex
  self.Parent:SaveEMSettinCache(RightOption)
end

function M:SetupButton(ItemData)
  self.FocusWidget = self.BtnList.List_Button
  self.WS_Item:SetActiveWidgetIndex(2)
  self.BtnList.List_Button:ClearListItems()
  local Options = ItemData.Options or {}
  for i, Option in ipairs(Options) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Text = GText(Option.Label)
    Content.ParentWidget = self
    Content.bGamepadIconVisible = false
    Content.GamepadButtonIndex = i
    
    function Content.OnClickFunction()
      self:OnButtonClicked(Option.ID, GText(Option.Label), Content)
    end
    
    self.BtnList.List_Button:AddItem(Content)
  end
end

function M:BP_GetDesiredFocusTarget()
  return self.FocusWidget
end

function M:OnButtonClicked(OptionID, Text)
  Utils.ScreenPrint("ButtonClicked" .. self.GroupID .. OptionID)
  local ShortText = string.format(GText("UI_ConfirmDestroyAll"), Text)
  local Params = {
    ShortText = ShortText,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnSettingPopupClosed,
    RightCallbackFunction = function(_)
      Utils.ScreenPrint("RightCallbackFunction::" .. self.GroupID .. OptionID)
    end
  }
  UIManager(self):ShowCommonPopupUI(100386, Params, self)
end

return M
