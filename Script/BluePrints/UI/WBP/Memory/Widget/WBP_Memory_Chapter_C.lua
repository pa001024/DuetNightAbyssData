local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  if M.Super.Construct then
    M.Super.Construct(self)
  end
  self.Name = self.Name_Chapter
  self.NameShadow = self.Name_Chapter_Shadow
  self.Number = self.Text_Chapter
  self.Icon = self.Icon_Chapter
  self.Pic = self.Img_Memory
  self.ImgSwitcher = self.WS_State
  self.BlendInAnimation = self.In
end

function M:Destruct()
  if M.Super.Destruct then
    M.Super.Destruct(self)
  end
end

function M:BP_OnEntryReleased()
  if self.Content then
    self.Content.Entry = nil
    self.Content = nil
  end
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  Content.Entry = self
  if Content.Id then
    self.Name:SetText(Content.Name)
    self.NameShadow:SetText(Content.Name)
    self.Number:SetText(Content.Number)
    self:SetIcon(Content.IconPath)
    self:SetPic(Content.PicPath)
    self:SetNew(Content.bIsNew)
    self.ImgSwitcher:SetActiveWidgetIndex(0)
    self.Number:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Pic:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if not Content.bSkipBlendIn then
      Content.bSkipBlendIn = true
      self:BlendIn()
    end
  else
    self.Name:SetText(GText("Quest_ToBeContinued"))
    self.NameShadow:SetText(GText("Quest_ToBeContinued"))
    self.Number:SetVisibility(ESlateVisibility.Collapsed)
    self.Icon:SetVisibility(ESlateVisibility.Collapsed)
    self.Pic:SetVisibility(ESlateVisibility.Collapsed)
    self.New:SetVisibility(ESlateVisibility.Collapsed)
    self.ImgSwitcher:SetActiveWidgetIndex(1)
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if IsValid(self.Content) == false or self.Content.Id == nil then
    return
  end
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MouseEvent)
  if IsValid(self.Content) == false or self.Content.Id == nil then
    return
  end
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if IsValid(self.Content) == false or self.Content.Id == nil then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:PlayAnimation(self.Press)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if IsValid(self.Content) == false or self.Content.Id == nil then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  self:PlayAnimation(self.Normal)
  self:OnClicked()
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnClicked()
  if IsValid(self.Content) == false or self.Content.Id == nil then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_pic_large", self:GetName(), nil)
  self:PlayAnimation(self.Click)
end

function M:SetIcon(IconPath)
  if not IconPath then
    return
  end
  local DynamicMaterial = self.Icon:GetDynamicMaterial()
  if not IsValid(DynamicMaterial) then
    return
  end
  DynamicMaterial:SetTextureParameterValue("IconTex", LoadObject(IconPath))
end

function M:SetPic(PicPath)
  if not PicPath then
    return
  end
  local DynamicMaterial = self.Pic:GetDynamicMaterial()
  if not IsValid(DynamicMaterial) then
    return
  end
  DynamicMaterial:SetTextureParameterValue("Tex", LoadObject(PicPath))
end

function M:SetNew(bIsNew)
  if bIsNew then
    self.New:SetVisibility(ESlateVisibility.HitTestInvisible)
  else
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:BlendIn()
  self:SetRenderOpacity(0)
  self:PlayAnimation(self.BlendInAnimation)
end

return M
