require("UnLua")
local AvatarIconMaterialPath = "/Game/UI/Materials/CommonItem/MI_PersonalItem_Circle.MI_PersonalItem_Circle"
local GAMEPAD_CONFIRM_KEY = UIConst.GamePadKey.FaceButtonBottom
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.Btn_Area.OnClicked:Clear()
  self.Btn_Area.OnClicked:Add(self, self.OnItemClick)
  self.Btn_Area.OnHovered:Clear()
  self.Btn_Area.OnHovered:Add(self, self.OnItemHover)
  self.Btn_Area.OnUnHovered:Clear()
  self.Btn_Area.OnUnHovered:Add(self, self.OnItemUnHover)
  self.Btn_Area.OnPressed:Clear()
  self.Btn_Area.OnPressed:Add(self, self.OnItemPress)
end

function M:OnListItemObjectSet(ListItemObject)
  self.Content = ListItemObject
  self.bSlotSelectedVisualState = nil
  self.HostPage = self.Content and self.Content.OwnerPage or nil
  if self.HostPage then
    self.HostPage:RegisterCharacterSlotEntry(self, self.Content)
  end
  self:RefreshEntry()
end

function M:BP_OnEntryReleased()
  if self.HostPage then
    self.HostPage:UnregisterCharacterSlotEntry(self, self.Content)
  end
  self.Content = nil
  self.HostPage = nil
  self.bSlotSelectedVisualState = nil
end

function M:OnItemClick()
  local Content = self.Content
  if not Content or Content.CanInteract ~= true or not self.HostPage then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/special_content_01_click", nil, nil)
  self.HostPage:OnCharacterSlotEntryClicked(Content, self)
end

function M:OnItemHover()
  local Content = self.Content
  if not Content or Content.CanInteract ~= true then
    return
  end
  if true == Content.IsSelected then
    return
  end
  self:PlayAnimation(self.Hover)
end

function M:OnItemUnHover()
  local Content = self.Content
  if not Content or Content.CanInteract ~= true or true == Content.IsSelected then
    return
  end
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:PlayAnimation(self.UnHover)
end

function M:OnItemPress()
  local Content = self.Content
  if not Content or Content.CanInteract ~= true then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:RefreshEntry()
  local Content = self.Content
  if not Content then
    return
  end
  self.Add:SetVisibility(Content.ShowAddIcon and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Image_Icon:SetVisibility(Content.HasCharacter and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if Content.HasCharacter and Content.Icon then
    local Texture = LoadObject(Content.Icon)
    if Texture then
      if not self.AvatarIconMaterial then
        self.AvatarIconMaterial = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, LoadObject(AvatarIconMaterialPath), "None")
        self.Image_Icon:SetBrushFromMaterial(self.AvatarIconMaterial)
      end
      self.AvatarIconMaterial:SetTextureParameterValue("IconMap", Texture)
    end
  end
  self.Btn_Area:SetIsEnabled(Content.CanInteract == true)
  self:SetIsEnabled(Content.CanInteract == true)
  self:_PlaySlotStateAnimation()
end

function M:_PlaySlotStateAnimation()
  local Content = self.Content
  if not Content then
    return
  end
  local bSelected = Content.IsSelected == true
  if self.bSlotSelectedVisualState == bSelected then
    if false == bSelected then
      self:PlayAnimation(self.Normal)
    end
    return
  end
  self.bSlotSelectedVisualState = bSelected
  self:SetVisibility(bSelected and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self:StopAllAnimations()
  if bSelected then
    self:PlayAnimation(self.Click)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Content = self.Content
  if not Content or Content.CanInteract ~= true or not self.HostPage then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if self.HostPage.OnCharacterSlotEntryFocused then
    self.HostPage:OnCharacterSlotEntryFocused(Content, self)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local Content = self.Content
  if not Content or Content.CanInteract ~= true or not self.HostPage then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == GAMEPAD_CONFIRM_KEY and self.HostPage.HandleGamepadConfirmCharacterSlotFromEntry and self.HostPage:HandleGamepadConfirmCharacterSlotFromEntry(Content, self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
