require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.Entry = nil
  end
end

function M:Init(Content)
  self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
  Content.Entry = self
  self.Content = Content
  self:InitData(Content)
  self:InitCompView()
end

function M:InitData(Content)
  self.IsEmpty = Content.IsEmpty
  self.Id = Content.Id
  self.Name = Content.Name
  self.IconPath = Content.IconPath
  self.Rarity = Content.Rarity
  self.IsLock = Content.IsLock
  self.IsNew = Content.IsNew
  self.CanUpgrade = Content.CanUpgrade
  self.Level = Content.Level
  self.bPlayInAnim = Content.bPlayInAnim
  self.SoundItemType = Content.SoundItemType
  self.DoNotPlaySound = Content.DoNotPlaySound
  self.DoNotPlaySoundGamePad = Content.DoNotPlaySoundGamePad
  self.OnClickCheckBtnEvent = Content.OnClickCheckBtnEvent
  self.OnMouseEnterEvent = Content.OnMouseEnterEvent
  self.OnMouseLeaveEvent = Content.OnMouseLeaveEvent
  self.OnMouseButtonDownEvent = Content.OnMouseButtonDownEvent
  self.OnMouseButtonUpEvent = Content.OnMouseButtonUpEvent
  self.OnFocusReceivedEvent = Content.OnFocusReceivedEvent
  self.OnAddedToFocusPathEvent = Content.OnAddedToFocusPathEvent
  self.OnRemovedFromFocusPathEvent = Content.OnRemovedFromFocusPathEvent
end

function M:InitCompView()
  self:InitCommonView()
end

function M:InitCommonView()
  self:SetEmpty(self.IsEmpty)
  self:SetNew(self.IsNew)
  self:SetLockAndLevele(self.IsLock, self.CanUpgrade, self.Level)
  if not self.IsEmpty then
    self:SetIcon(self.IconPath)
    self:SetName(self.Name)
    self:SetRarity(self.Rarity)
  end
  if self.bPlayInAnim then
    self:PlayInAnimation()
  end
end

function M:SetEmpty(IsEmpty)
  if IsEmpty then
    self.WS_State:SetActiveWidgetIndex(1)
  else
    self.WS_State:SetActiveWidgetIndex(0)
  end
end

function M:SetIcon(IconPath)
  local Object = LoadObject(IconPath)
  local ImgMat = self.Image_Item:GetDynamicMaterial()
  ImgMat:SetTextureParameterValue("IconMap", Object)
end

function M:SetName(Name)
  self.Text_Name:SetText(GText(Name))
end

function M:SetRarity(Rarity)
  local TempRarity = Rarity
  if not TempRarity or TempRarity < 0 or TempRarity > 6 then
    TempRarity = 0
  end
  local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
  if TempRarity and self["Quality_" .. TempRarity] then
    FontMaterial:SetTextureParameterValue("IconTex", self["Quality_" .. TempRarity])
  else
    FontMaterial:SetTextureParameterValue("IconTex", self.Quality_0)
  end
  local ImgMat = self.Image_Item:GetDynamicMaterial()
  if ImgMat and self["MainTex_" .. TempRarity] then
    ImgMat:SetTextureParameterValue("MainTex", self["MainTex_" .. TempRarity])
  end
end

function M:SetLockAndLevele(IsLock, CanUpgrade, Level)
  if IsLock then
    self.WS_Lock:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WS_Lock:SetActiveWidgetIndex(1)
  elseif CanUpgrade then
    self.WS_Lock:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WS_Lock:SetActiveWidgetIndex(0)
    if Level then
      self.Num_Level:SetText(Level)
    end
  else
    self.WS_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetNew(IsNew)
  self.Content.IsNew = IsNew
  if IsNew then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetDoNotPlaySoundGamePad(DoNotPlaySoundGamePad)
  self.Content.DoNotPlaySoundGamePad = DoNotPlaySoundGamePad
end

function M:SetDoNotPlaySound(DoNotPlaySound)
  self.Content.DoNotPlaySound = DoNotPlaySound
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if not self.Content or self.Content.NotInteractive or self.Content.IsSelect or self:IsInAnimationPlaying() then
    return
  end
  if self.OnMouseEnterEvent and self.OnMouseEnterEvent.Callback then
    if self.OnMouseEnterEvent.Params then
      self.OnMouseEnterEvent.Callback(self.OnMouseEnterEvent.Obj, table.unpack(self.OnMouseEnterEvent.Params))
    else
      self.OnMouseEnterEvent.Callback(self.OnMouseEnterEvent.Obj)
    end
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if not self.Content or self.Content.NotInteractive or self.Content.IsSelect or self:IsInAnimationPlaying() then
    return
  end
  if self.OnMouseLeaveEvent and self.OnMouseLeaveEvent.Callback then
    if self.OnMouseLeaveEvent.Params then
      self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj, table.unpack(self.OnMouseLeaveEvent.Params))
    else
      self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj)
    end
  end
  self.bMouseButtonDown = false
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.HandleMouseDown then
    return UWidgetBlueprintLibrary.Handled()
  end
  if self.Content.NotInteractive or self:IsInAnimationPlaying() then
    return UWidgetBlueprintLibrary.UnHandled()
  end
  self:StopAllAnimations()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self:PlayAnimation(self.Press)
  end
  if self.OnMouseButtonDownEvent and self.OnMouseButtonDownEvent.Callback then
    if self.OnMouseButtonDownEvent.Params then
      self.OnMouseButtonDownEvent.Callback(self.OnMouseButtonDownEvent.Obj, table.unpack(self.OnMouseButtonDownEvent.Params))
    else
      self.OnMouseButtonDownEvent.Callback(self.OnMouseButtonDownEvent.Obj)
    end
  end
  self.bMouseButtonDown = true
  return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self.Content.NotInteractive or self:IsInAnimationPlaying() or not self.bMouseButtonDown then
    return UWidgetBlueprintLibrary.Unhandled()
  end
  self.bMouseButtonDown = false
  if not self.Content.DoNotPlaySound and (not self.Content.DoNotPlaySoundGamePad or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
    AudioManager(self):PlayItemSound(self, self.Id, "Click", self.SoundItemType)
  end
  self:PlayAnimation(self.Click)
  if self.OnMouseButtonUpEvent and self.OnMouseButtonUpEvent.Callback then
    if self.OnMouseButtonUpEvent.Params then
      self.OnMouseButtonUpEvent.Callback(self.OnMouseButtonUpEvent.Obj, table.unpack(self.OnMouseButtonUpEvent.Params))
    else
      self.OnMouseButtonUpEvent.Callback(self.OnMouseButtonUpEvent.Obj)
    end
  end
  return UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, TouchEvent)
  return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
  return self:OnMouseButtonDown(MyGeometry, TouchEvent)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.OnFocusReceivedEvent then
    local Obj = self.OnFocusReceivedEvent.Obj
    local Callback = self.OnFocusReceivedEvent.Callback
    local Params = self.OnFocusReceivedEvent.Params
    if Params then
      Callback(Obj, table.unpack(Params))
    else
      Callback(Obj)
    end
  end
  return UIUtils.Handled
end

function M:OnAddedToFocusPath(InFocusEvent)
  if self.OnAddedToFocusPathEvent then
    local Obj = self.OnAddedToFocusPathEvent.Obj
    local Callback = self.OnAddedToFocusPathEvent.Callback
    local Params = self.OnAddedToFocusPathEvent.Params
    if Params then
      Callback(Obj, table.unpack(Params))
    else
      Callback(Obj)
    end
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if self.OnRemovedFromFocusPathEvent then
    local Obj = self.OnRemovedFromFocusPathEvent.Obj
    local Callback = self.OnRemovedFromFocusPathEvent.Callback
    local Params = self.OnRemovedFromFocusPathEvent.Params
    if Params then
      Callback(Obj, table.unpack(Params))
    else
      Callback(Obj)
    end
  end
end

function M:PlayInAnimation()
end

function M:IsInAnimationPlaying()
end

return M
