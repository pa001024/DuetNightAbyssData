require("UnLua")
require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.bExpanded = false
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
end

function M:OnListItemObjectSet(Content)
  local ItemData = Content.ItemData
  self.ItemData = ItemData
  self.Parent = Content.Parent
  self.Text_Name:SetText(self:GetDisplayName(ItemData.Name))
  self.Text_Cost:SetText(tostring(ItemData.ConsumeValue or 0))
  self.Btn_TakeBack:SetText(GText("UI_RetrieveComponent"))
  self.Btn_Edit:SetText(GText("UI_EditComponent"))
  self.Btn_TakeBack:BindSingleEventOnClicked(self, self.OnTakeBackClick)
  self.Btn_Edit:BindSingleEventOnClicked(self, self.OnEditClick)
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
  self:InitGamepad()
  self:SetExpanded(false)
end

function M:InitGamepad()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self.Btn_TakeBack:SetGamePadImg("Menu")
  self.Btn_Edit:SetGamePadImg("Y")
  self:AddInputMethodChangedListen()
end

function M:GetDisplayName(Name)
  local Text = tostring(Name or "")
  local Parts = string.split(Text, "/")
  return Parts[#Parts] or Text
end

function M:SetExpanded(bExpanded)
  self.bExpanded = bExpanded
  self.Bottom:SetVisibility(bExpanded and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  self:PlayAnimation(bExpanded and self.Open or self.Close)
end

function M:OnItemClick()
  self:SetExpanded(not self.bExpanded)
  self.Parent:OnComponentItemClicked(self.ItemData, self, self.bExpanded)
end

function M:OnTakeBackClick()
  self.Parent:OnComponentTakeBackClicked(self.ItemData)
end

function M:OnEditClick()
  self.Parent:OnComponentEditClicked(self.ItemData)
end

function M:OnAddedToFocusPath()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Parent:OnComponentFocusChanged(self)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self:PlayItem_UnHover()
end

function M:PlayItem_Hover(InFocusEvent)
  if not self.bPlayHover then
    self.bPlayHover = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Item_Hover)
    self.Btn_TakeBack:SetGamepadIconVisibility(true)
    self.Btn_Edit:SetGamepadIconVisibility(true)
  end
end

function M:PlayItem_UnHover()
  if self.bPlayHover then
    self.bPlayHover = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Item_UnHover)
    self.Btn_TakeBack:SetGamepadIconVisibility(false)
    self.Btn_Edit:SetGamepadIconVisibility(false)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    self:OnItemClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == Const.GamepadFaceButtonUp then
    if self.bExpanded and self.Btn_Edit.Key_GamePad:IsVisible() then
      self:OnEditClick()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif InKeyName == Const.GamepadSpecialRight and self.bExpanded and self.Btn_TakeBack.Key_GamePad:IsVisible() then
    self:OnTakeBackClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamepad and self.bPlayHover then
    self:PlayItem_UnHover()
  elseif IsGamepad and not self.bPlayHover and self.Parent.FocusItemWidget == self and UIUtils.HasAnyFocus(self.Parent.List_Component) then
    self:PlayItem_Hover()
  end
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

return M
