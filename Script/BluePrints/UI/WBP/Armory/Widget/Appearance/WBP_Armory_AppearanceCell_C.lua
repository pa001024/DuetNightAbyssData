require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local RarityColorName = {
  [6] = "Img_Quality_Red",
  [5] = "Img_Quality_Gold",
  [4] = "Img_Quality_Purple",
  [3] = "Img_Quality_Blue"
}

function M:Construct()
  self:PlayAnimation(self.Stain_Out, 0, 1, 0, 1000)
end

function M:OnListItemObjectSet(Content)
  rawset(Content, "Widget", self)
  rawset(self, "Content", Content)
  rawset(self, "Owner", Content.Owner)
  rawset(self, "_OnAddedToFocusPath", Content.OnAddedToFocusPath)
  rawset(self, "_OnRemovedFromFocusPath", Content.OnRemovedFromFocusPath)
  rawset(self, "IsPreviewMode", Content.IsPreviewMode)
  rawset(self, "bFormPersonalPage", Content.bFormPersonalPage)
  rawset(self, "IsCharacterTrialMode", Content.IsCharacterTrialMode)
  rawset(self, "IsTargetUnowned", Content.IsTargetUnowned)
  rawset(self, "IsCurrentUse", Content.IsCurrentUse)
  rawset(self, "bDyeable", Content.bDyeable)
  rawset(self, "Type", Content.Type)
  rawset(self, "ItemType", Content.ItemType)
  rawset(self, "DyeInfos", Content.DyeInfos)
  rawset(self, "DyePlanIndex", Content.DyePlanIndex)
  rawset(self, "SpecialColor", Content.SpecialColor)
  rawset(self, "ItemId", Content.ItemId)
  rawset(self, "TipType", Content.TipType)
  rawset(self, "LockType", Content.LockType)
  rawset(self, "Rarity", Content.Rarity)
  rawset(self, "NoState", Content.NoState)
  rawset(self, "bHasGot", Content.bHasGot)
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  if rawget(Content, "IsEmpty") then
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Img:SetActiveWidgetIndex(1)
  else
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Img:SetActiveWidgetIndex(0)
  end
  self:SetIcon(Content.IconPath)
  self:SetDyeable(Content.bDyeable)
  self:SetRarity(Content.Rarity)
  self:InitTextStyle()
  self:SetIsNew(Content.IsNew)
  self:SetIsSelected(Content.IsSelect)
end

function M:SetReddot(IsNew)
  self:SetIsNew(IsNew)
end

function M:SetIsNew(IsNew)
  if IsNew then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetIsCurrentUse(IsCurrentUse)
  self.IsCurrentUse = IsCurrentUse
  self:InitTextStyle()
end

function M:SetRarity(Rarity)
  if RarityColorName[Rarity] then
    self.Img_Quality:SetBrush(self[RarityColorName[Rarity]])
  end
end

function M:InitTextStyle()
  if self.NoState then
    self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if self.ItemType == CommonConst.DataType.Skin then
    self.Text_Disable:SetText(GText("UI_Skin_NoChar"))
  else
    self.Text_Disable:SetText(GText("UI_Skin_NoWeapon"))
  end
  self.WS_State:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  if self.IsCurrentUse then
    if self.IsCharacterTrialMode then
      self.WS_State:SetActiveWidgetIndex(1)
      self.Text_TryOut:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
    elseif self.IsTargetUnowned then
      self.WS_State:SetActiveWidgetIndex(3)
    else
      self.WS_State:SetActiveWidgetIndex(0)
    end
    self:StopAnimation(self.Lock)
    self:PlayAnimation(self.Locked_Normal)
  elseif self.LockType then
    self.WS_State:SetActiveWidgetIndex(2)
    self:StopAnimation(self.Locked_Normal)
    self:PlayAnimation(self.Lock)
  elseif self.IsTargetUnowned then
    self.WS_State:SetActiveWidgetIndex(3)
  elseif self.bHasGot then
    self.WS_State:SetActiveWidgetIndex(4)
    self.Text_Have:SetText(GText("UI_SHOP_ALREADYOWNED"))
  else
    self.WS_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StopAnimation(self.Lock)
    self:PlayAnimation(self.Locked_Normal)
  end
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.Widget = nil
  end
end

function M:OnClicked()
  if not self.Content then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_large", nil, nil)
  if self.Content and self.Content.OnClicked then
    if self.bFormPersonalPage then
      local Content = {
        ItemType = self.TipType,
        ItemId = self.ItemId,
        bCustomStype = true
      }
      if self.ItemId ~= nil and -1 ~= self.ItemId then
        self.ItemDetails_MenuAnchor.ParentWidget = self
        self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
      end
    else
      self.Content.OnClicked(self.Owner, self.Content)
    end
  end
end

function M:SetIcon(IconPath)
  local IconDynaMaterial = self.Img_Avatar:GetDynamicMaterial()
  if IconDynaMaterial and IconPath then
    IconDynaMaterial:SetTextureParameterValue("IconMap", LoadObject(IconPath))
  end
end

function M:SetDyeable(bDyeable)
  if bDyeable then
    self.Tag_Dye:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Tag_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitPreviewView()
  if not self.bFormPersonalPage then
    return
  end
  if self.bDyeable then
    self.DefaultColorId = DataMgr.GlobalConstant[self.Type .. "DefaultColor"].ConstantValue
    if self.SpecialColor ~= nil and DataMgr.SpecialSwatch[self.SpecialColor] then
      local MaterialInstance = LoadObject(DataMgr.SpecialSwatch[self.SpecialColor].MaterialPath)
      self.Image_SPDye:SetBrushResourceObject(MaterialInstance)
      self.List_Color:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Image_SPDye:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.List_Color:ClearListItems()
      local DyeDetialInfo
      if nil == self.DyeInfos or 0 == self.DyeInfos:Length() or nil == self.DyeInfos[self.DyePlanIndex] or 0 == self.DyeInfos[self.DyePlanIndex]:Length() then
        DyeDetialInfo = self:CreateDefaultSkin().Colors
      else
        DyeDetialInfo = self.DyeInfos[self.DyePlanIndex]
      end
      for index, ColorIndex in ipairs(DyeDetialInfo) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ColorId = ColorIndex
        self.List_Color:AddItem(Content)
      end
      self.List_Color:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Image_SPDye:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    self.List_Color:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:CreateDefaultSkin()
  local ColorPartCount = DataMgr.GlobalConstant[self.Type .. "ColorPart"].ConstantValue
  local Skin = {
    Colors = {},
    SpecialColor = self.DefaultColorId
  }
  for i = 1, ColorPartCount do
    Skin.Colors[i] = self.DefaultColorId
  end
  return Skin
end

function M:OnAddedToFocusPath()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Owner, self.Content)
  end
end

function M:OnRemovedFromFocusPath()
  if self._OnRemovedFromFocusPath then
    self._OnRemovedFromFocusPath(self.Owner, self.Content)
  end
end

function M:SetIsSelected(IsSelected)
  if IsSelected then
    self:SetSelect()
  else
    self:SetUnSelect()
  end
end

function M:SetSelect()
  if self.IsPreviewMode then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Select_Click)
  else
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Normal)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
  end
end

function M:SetUnSelect()
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.Click) then
    EMUIAnimationSubsystem:EMStopAnimation(self, self.Click)
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
end

function M:OnBtnHovered()
  if not self.Content or self.Content.IsSelect then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SetSelect()
  else
    AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large", nil, nil)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
  end
end

function M:OnBtnUnhovered()
  if self.Content.IsSelect then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
end

function M:OnBtnPressed()
  if self.Content.IsSelect then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Button_Area)
end

AssembleComponents(M)
return M
