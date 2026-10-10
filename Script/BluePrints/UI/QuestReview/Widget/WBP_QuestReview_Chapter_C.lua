require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.Content = nil
  self.Btn_Click.OnClicked:Add(self, self.OnClick)
  self.Btn_Click.OnPressed:Add(self, self.OnPress)
  self.Btn_Click.OnHovered:Add(self, self.OnHover)
  self.Btn_Click.OnUnhovered:Add(self, self.OnUnhover)
  self.Btn_Click.OnReleased:Add(self, self.OnReleased)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self:RefreshChapterInfo()
end

function M:RefreshChapterInfo()
  if not self.Content then
    return
  end
  local Cfg = DataMgr.QuestReview[self.Content.QuestReviewId]
  if not Cfg then
    return
  end
  self.Text_Name:SetText(GText(Cfg.CantoName))
  self.Text_Desc:SetText(GText(Cfg.QuestReviewName))
  if Cfg.IconPath then
    local Icon = LoadObject(Cfg.IconPath)
    self.Icon_Chapter:SetBrushFromTexture(Icon)
  end
  if Cfg.BackgroundPath then
    local Background = LoadObject(Cfg.BackgroundPath)
    self.Image_Chapter:SetBrushFromTexture(Background)
  end
  local Total = Cfg.QuestchainId and #Cfg.QuestchainId or 0
  local Now = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.QuestBacktracks then
    for _, Id in pairs(Cfg.QuestchainId or {}) do
      if Avatar.QuestBacktracks[Id] and Avatar.QuestBacktracks[Id]:FinishTrueEnd() then
        Now = Now + 1
      end
    end
  end
  self.Text_Now:SetText(tostring(Now))
  self.Text_Total:SetText(tostring(Total))
end

function M:OnClick()
  self:PlayAnimation(self.Click)
  if self.Content and self.Content.OwnerWidget then
    self.Content.OwnerWidget:OnChapterClicked(self.Content.QuestReviewId)
  end
end

function M:OnHover()
  self.IsHovering = true
  self:PlayAnimation(self.Hover)
end

function M:OnUnhover()
  self.IsHovering = false
  if not self.IsPressing then
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
  end
end

function M:OnPress()
  self.IsPressing = true
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
  self.IsPressing = false
  if not self.IsHovering then
    self:StopAllAnimations()
    self:PlayAnimationReverse(self.Normal)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == KeyName then
    self:OnClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UIUtils.Unhandled
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnClick)
  self.Btn_Click.OnPressed:Remove(self, self.OnPress)
  self.Btn_Click.OnHovered:Remove(self, self.OnHover)
  self.Btn_Click.OnUnhovered:Remove(self, self.OnUnhover)
  self.Btn_Click.OnReleased:Remove(self, self.OnReleased)
  self.Content = nil
end

return M
