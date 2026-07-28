require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function SetIconByPath(Img, IconPath)
  if not (IsValid(Img) and IconPath) or "" == IconPath then
    return
  end
  local Mat = Img.GetDynamicMaterial and Img:GetDynamicMaterial() or nil
  if Mat then
    local Obj = LoadObject(IconPath)
    if not IsValid(Obj) and string.find(IconPath, "/Game/") and not string.find(IconPath, "'") then
      Obj = LoadObject("Texture2D'" .. IconPath .. "'")
    end
    Mat:SetTextureParameterValue("MainTex", Obj)
  end
end

function M:Construct()
  self.BtnArea.OnClicked:Add(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Add(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Add(self, self.OnBtnPressed)
end

function M:Destruct()
  self.BtnArea.OnClicked:Remove(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Remove(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Remove(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Remove(self, self.OnBtnPressed)
end

function M:ResetItemState()
  if self.Owner and self.Owner.SelectItem == self then
    self.Owner.SelectItem = nil
  end
  self.bPlaySelect = false
  self:StopAllAnimations()
end

function M:SyncOwnerSelectItem(Content)
  if not self.Owner then
    return
  end
  if Content.bSelectTag and not Content.bOccupied then
    self.Owner.SelectItem = self
  elseif self.Owner.SelectItem == self then
    self.Owner.SelectItem = nil
  end
end

function M:OnListItemObjectSet(Content)
  self:ResetItemState()
  self.Content = Content
  self.Owner = Content and Content.Owner or nil
  if not Content then
    return
  end
  local AffixId = Content.UniqueId
  local AffixCfg = Model.GetAffixCfg(AffixId)
  self.TextTitle:SetText(AffixCfg and AffixCfg.Name and GText(AffixCfg.Name) or "")
  self.TextContent:SetText(AffixCfg and AffixCfg.Desc and GText(AffixCfg.Desc) or "")
  self.Textuse:SetText(GText("UI_WeaponVerify_Chosen"))
  self.Textuse:GetParent():SetVisibility(Content.bOccupied and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  self:StopAllAnimations()
  if Content.bOccupied then
    self.Textuse:GetParent():SetRenderOpacity(1)
    self:PlayAnimation(self.Lock_Normal)
  elseif Content.bSelectTag then
    self:PlayItem_Select()
  else
    self:PlayAnimation(self.Normal)
  end
  self:SyncOwnerSelectItem(Content)
  SetIconByPath(self.Icon, AffixCfg and (AffixCfg.IconPath or AffixCfg.Icon))
end

function M:OnBtnClicked()
  local Content = self.Content
  if Content and Content.Owner and Content.OnSelect then
    Content.OnSelect(Content.Owner, Content.UniqueId, Content, self)
  end
end

function M:OnBtnHovered()
  local Content = self.Content
  if not Content or Content.bOccupied then
    return
  end
  if self.bPlaySelect then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
  local Content = self.Content
  if not Content or Content.bOccupied then
    return
  end
  if self.bPlaySelect then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
end

function M:OnBtnPressed()
  local Content = self.Content
  if not Content or Content.bOccupied then
    return
  end
  if self.bPlaySelect then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:PlayItem_Select()
  if not self.bPlaySelect then
    self.bPlaySelect = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
  end
end

function M:PlayItem_Unselect()
  if self.bPlaySelect then
    self.bPlaySelect = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
