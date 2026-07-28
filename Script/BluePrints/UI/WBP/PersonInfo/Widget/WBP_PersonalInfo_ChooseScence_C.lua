require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function IsGamepadInput(Owner)
  if Owner and Owner.CurInputDeviceType ~= nil then
    return Owner.CurInputDeviceType == ECommonInputType.Gamepad
  end
  local RootOwner = Owner and Owner.EditRootController and Owner.EditRootController.OwnerWidget or nil
  return nil ~= RootOwner and RootOwner.CurInputDeviceType == ECommonInputType.Gamepad
end

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
  self.HostPage = self.Content and self.Content.OwnerPage or nil
  if self.HostPage then
    self.HostPage:RegisterSceneEntry(self, self.Content)
  end
  self:RefreshEntry()
end

function M:BP_OnEntryReleased()
  if self.HostPage then
    self.HostPage:UnregisterSceneEntry(self, self.Content)
  end
  self.Content = nil
  self.HostPage = nil
end

function M:OnItemClick()
  local Content = self.Content
  if not (Content and Content.SceneId) or not self.HostPage then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/special_content_01_click", nil, nil)
  self.HostPage:OnSceneEntryClicked(Content, self)
end

function M:OnItemHover()
  self:PlayAnimation(self.Hover)
end

function M:OnItemUnHover()
  if self:IsAnimationPlaying(self.Click) then
    return
  end
  self:PlayAnimation(self.UnHover)
end

function M:OnItemPress()
  if not self.Content then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:RefreshEntry()
  local Content = self.Content
  if not Content then
    return
  end
  self:SetVisibility(Content.IsSelected == true and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.SelfHitTestInvisible)
  self:RefreshStaticEntryState()
  self:RefreshSceneVisualState()
end

function M:RefreshStaticEntryState()
  local Content = self.Content
  if not Content then
    return
  end
  self.New:SetVisibility(Content.IsNew == true and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if Content.Icon then
    local Texture = LoadObject(Content.Icon)
    if Texture then
      local SceneIconMaterial = self.Image_Icon:GetDynamicMaterial()
      if SceneIconMaterial then
        SceneIconMaterial:SetTextureParameterValue("IconMap", Texture)
      end
      self.Image_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      return
    end
  end
  self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:RefreshSceneVisualState()
  self:RefreshSceneOverlayTrack()
  self:RefreshSceneSelectTrack()
end

function M:RefreshSceneSelectTrack()
  local Content = self.Content
  if not Content then
    return
  end
  if Content.IsSelected == true then
    self:PlayAnimation(self.Click)
    return
  end
  self:PlayAnimation(self.Normal)
end

function M:RefreshSceneOverlayTrack()
  local Content = self.Content
  if not Content then
    return
  end
  if Content.IsLocked == true then
    if self.Lock_Normal then
      self:PlayAnimation(self.Lock_Normal)
    end
    return
  end
  if true == Content.IsUsed then
    if self.Used_Normal then
      self:PlayAnimation(self.Used_Normal)
    end
    return
  end
  if self.UnLock_Normal then
    self:PlayAnimation(self.UnLock_Normal)
  end
end

function M:PlaySceneSelectNormal()
  if self.Content then
    self.Content.IsSelected = false
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.Normal)
end

function M:PlaySceneSelectClick()
  if self.Content then
    self.Content.IsSelected = true
  end
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:PlayAnimation(self.Click)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Content = self.Content
  if not (Content and Content.SceneId) or not self.HostPage then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if not IsGamepadInput(self.HostPage) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self.HostPage:OnSceneEntryClicked(Content, self)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
end

function M:PlaySceneUsedClear()
  if self.Content then
    self.Content.IsUsed = false
  end
  if self.UnLock_Normal then
    self:PlayAnimation(self.UnLock_Normal)
  end
end

function M:PlaySceneUsedApply()
  if self.Content then
    self.Content.IsUsed = true
  end
  if self.Used_Normal then
    self:PlayAnimation(self.Used_Normal)
  end
end

function M:SetSceneNewState(bIsNew)
  if self.Content then
    self.Content.IsNew = true == bIsNew
  end
  self.New:SetVisibility(true == bIsNew and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:_PlaySceneStateAnimation()
  self:RefreshSceneVisualState()
end

return M
