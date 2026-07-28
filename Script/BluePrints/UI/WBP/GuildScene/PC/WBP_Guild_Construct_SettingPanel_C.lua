require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local SettingUtils = require("Utils.SettingUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GuildEntranceSettingsCacheName = "GuildEntranceSettings"

function M:Construct()
  self.bIsFocusable = true
end

function M:Init(Parent)
  self.Parent = Parent
  self.Text_Title:SetText(GText("UI_ConstructSettings"))
  self:InitGamepad()
  self:RefreshUI()
  self:AddInputMethodChangedListen()
end

function M:InitGamepad()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self:SetFocus()
  self.Controller_Confirm:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Pwner = self
      }
    },
    Desc = GText("UI_Tips_Ensure")
  })
  self.Controller_Back:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        Pwner = self
      }
    },
    Desc = GText("UI_BACK")
  })
end

function M:RefreshUI()
  self.List_Setting:ClearListItems()
  local GroupedItems = self:GroupSettings()
  for _, ItemData in ipairs(GroupedItems) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemData = ItemData
    Content.Parent = self
    self.List_Setting:AddItem(Content)
  end
  self.List_Setting:SetFocus()
end

function M:GroupSettings()
  local Result = {}
  local GroupMap = {}
  local OptionGroupMap = {}
  for _, ItemData in ipairs(DataMgr.GuildEntranceSettings or {}) do
    local Option = self:GetCachedSettingOption(ItemData.Option)
    local GroupID = ItemData.GroupID
    local GroupTable = GroupID and GroupMap[GroupID]
    if not GroupTable then
      GroupTable = {
        Options = {}
      }
      for Key, Value in pairs(ItemData) do
        if "Option" ~= Key and "Option_ID" ~= Key then
          GroupTable[Key] = Value
        end
      end
      table.insert(Result, GroupTable)
      if GroupID then
        GroupMap[GroupID] = GroupTable
      end
    end
    if Option then
      local SubGroupID = ItemData.Option.GroupID
      if SubGroupID and "" ~= SubGroupID then
        local SubGroupTable = OptionGroupMap[SubGroupID]
        if not SubGroupTable then
          SubGroupTable = {}
          OptionGroupMap[SubGroupID] = SubGroupTable
          table.insert(GroupTable.Options, SubGroupTable)
        end
        table.insert(SubGroupTable, Option)
      else
        table.insert(GroupTable.Options, Option)
      end
    end
  end
  return Result
end

function M:GetCachedSettingOption(Option)
  if not Option then
    return nil
  end
  local CachedOption = {}
  for Key, Value in pairs(Option) do
    CachedOption[Key] = Value
  end
  if CachedOption.ID then
    CachedOption.State = self:GetEMSettinCache(Option)
  end
  return CachedOption
end

function M:GetEMSettinCache(Option)
  local Value = SettingUtils.GetEMCache(GuildEntranceSettingsCacheName, Option.ID, Option.State and 1 or 0)
  return 1 == Value
end

function M:SaveEMSettinCache(Option)
  SettingUtils.SaveEMCache(GuildEntranceSettingsCacheName, Option.ID, Option.State and 1 or 0)
end

function M:BP_GetDesiredFocusTarget()
  local SelectedItem = self.List_Setting and self.List_Setting:BP_GetSelectedItem()
  local SettingItem = SelectedItem and SelectedItem.SelfWidget
  return SettingItem or self.List_Setting
end

function M:CloseByGamepad()
  if self.Parent and self.Parent.CloseSidePanel then
    self.Parent:CloseSidePanel()
  elseif self.Close then
    self:Close()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonRight then
    self:CloseByGamepad()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if not self:IsVisible() then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  if self.Mobile then
    return
  end
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self.Panel_Controller:SetVisibility(IsGamepad and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
end

return M
