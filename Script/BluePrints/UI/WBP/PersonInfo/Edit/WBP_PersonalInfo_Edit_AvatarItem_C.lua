require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
  self.Btn_Click.OnHovered:Clear()
  self.Btn_Click.OnHovered:Add(self, self.OnItemHover)
  self.Btn_Click.OnUnHovered:Clear()
  self.Btn_Click.OnUnHovered:Add(self, self.OnItemUnHover)
  self.Btn_Click.OnPressed:Clear()
  self.Btn_Click.OnPressed:Add(self, self.OnItemPress)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:_HandleGamepadCameraRoamFromSlot(InKeyName, true) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName ~= UIConst.GamePadKey.FaceButtonBottom then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local OwnerPage = self:_GetOwnerPage()
  if OwnerPage and OwnerPage.HandleGamepadConfirmCharacterSlotFromEntry and OwnerPage:HandleGamepadConfirmCharacterSlotFromEntry(self.Content, self) then
    self:OnItemClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:_HandleGamepadCameraRoamFromSlot(InKeyName, false) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnItemClick()
  if self.bIsEmpty then
    return
  end
  self:PlayAnimation(self.Click)
end

function M:OnItemHover()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large_crystal", nil, nil)
  if self.Content and self.Content.IsSelected == true then
    return
  end
  if self.PlayAnimation and self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnItemUnHover()
  if self.Content and self.Content.IsSelected == true then
    return
  end
  if self.IsAnimationPlaying and self.Click and self:IsAnimationPlaying(self.Click) then
    return
  end
  if self.PlayAnimation and self.UnHover then
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnItemPress()
  if self.Content and self.Content.CanInteract ~= true then
    return
  end
  if self.PlayAnimation and self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:FreshView(image, name, lv, Rarity, Uuid)
  self.bIsEmpty = false
  self.Uuid = Uuid
  local MaterialInstance = self.Image_Avatar:GetDynamicMaterial()
  MaterialInstance:SetTextureParameterValue("IconMap", image)
  self:StopAllAnimations()
  self.Text_Lv:SetText(GText("UI_LEVEL_NAME") .. tostring(lv))
  self.Text_AvatarName:SetText(GText(name))
  self.Image_Avatar:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Text_Lv:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Text_AvatarName:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Removes:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Image_BottomBlack:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Group_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if 2 == Rarity then
    self:PlayAnimation(self.Green)
  elseif 3 == Rarity then
    self:PlayAnimation(self.Blue)
  elseif 4 == Rarity then
    self:PlayAnimation(self.Purple)
  else
    self:PlayAnimation(self.Yellow)
  end
end

function M:SetEmpty()
  self.bIsEmpty = true
  self.Uuid = nil
  self:StopAllAnimations()
  self:PlayAnimation(self.NormalColor)
  self.Image_BottomBlack:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_Add:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Image_Avatar:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Lv:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_AvatarName:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_WeaponSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Removes:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:SetFocusCallback(func)
  if type(func) == "function" then
    self.FocusCallback = func
  else
    ScreenPrint("传入的参数不是函数")
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.FocusCallback and type(self.FocusCallback) == "function" then
    self.FocusCallback()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:SetFocusLostCallback(func)
  if type(func) == "function" then
    self.RemoveCallback = func
  else
    ScreenPrint("传入的参数不是函数")
  end
end

function M:OnFocusLost(InFocusEvent)
  if self.RemoveCallback and type(self.RemoveCallback) == "function" then
    self.RemoveCallback()
  end
end

function M:_GetOwnerPage()
  return self.Content and self.Content.OwnerPage or nil
end

function M:_HandleGamepadCameraRoamFromSlot(InKeyName, bPressed)
  local CameraRoamKeyNameMap = {
    Gamepad_DPad_Up = "W",
    Gamepad_DPad_Down = "S",
    Gamepad_DPad_Left = "A",
    Gamepad_DPad_Right = "D"
  }
  local CameraKeyName = CameraRoamKeyNameMap[InKeyName]
  if not CameraKeyName then
    return false
  end
  local OwnerPage = self:_GetOwnerPage()
  if not OwnerPage then
    return false
  end
  if bPressed then
    return OwnerPage.OnCameraRoamKeyDown and OwnerPage:OnCameraRoamKeyDown(CameraKeyName) == true
  end
  return OwnerPage.OnCameraRoamKeyUp and true == OwnerPage:OnCameraRoamKeyUp(CameraKeyName)
end

return M
