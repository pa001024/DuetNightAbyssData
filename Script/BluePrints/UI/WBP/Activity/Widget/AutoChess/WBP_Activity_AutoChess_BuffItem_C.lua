require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GText = _ENV.GText

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self.Content = Content
  Content.Widget = self
  self.bUnlocked = false
  self.bSelected = false
  self:InitView(Content)
  self:BindEvents()
end

function M:BindEvents()
  if not self.BtnArea then
    return
  end
  if self.BtnArea.OnClicked then
    self.BtnArea.OnClicked:Clear()
    self.BtnArea.OnClicked:Add(self, self.OnBtnAreaClicked)
  end
  if self.BtnArea.OnPressed then
    self.BtnArea.OnPressed:Clear()
    self.BtnArea.OnPressed:Add(self, self.OnBtnAreaPressed)
  end
  if self.BtnArea.OnHovered then
    self.BtnArea.OnHovered:Clear()
    self.BtnArea.OnHovered:Add(self, self.OnBtnAreaHovered)
  end
  if self.BtnArea.OnUnhovered then
    self.BtnArea.OnUnhovered:Clear()
    self.BtnArea.OnUnhovered:Add(self, self.OnBtnAreaUnhovered)
  end
end

function M:InitView(Content)
  if Content.IsEmpty then
    if self.Ws_State then
      self.Ws_State:SetActiveWidgetIndex(1)
    end
    if self.Choosed then
      self.Choosed:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Lock then
      self.Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Content = nil
    return
  end
  local ChallengeBuff = Content.ChallengeBuff
  if self.Ws_State then
    self.Ws_State:SetActiveWidgetIndex(0)
  end
  if self.TextTitle then
    local BuffName = ChallengeBuff.BuffName and GText(ChallengeBuff.BuffName) or ""
    self.TextTitle:SetText(BuffName)
  end
  if self.TextNum and ChallengeBuff.DifficultyStar then
    self.HorizontalBox_StarBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.TextNum:SetText(tostring(ChallengeBuff.DifficultyStar))
  else
    self.HorizontalBox_StarBox:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Image_Icon and ChallengeBuff.BuffIcon then
    self:SetImageIcon(self.Image_Icon, ChallengeBuff.BuffIcon)
  end
  local bUnlocked = Content.Owner and Content.Owner.IsChallengeBuffUnlocked and Content.Owner:IsChallengeBuffUnlocked(ChallengeBuff)
  self.bUnlocked = bUnlocked and true or false
  if self.Lock then
    self.Lock:SetVisibility(bUnlocked and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  local ItemIndex = Content.Owner and Content.Owner.GetBuffItemIndex and Content.Owner:GetBuffItemIndex(Content)
  local bListItemSelected = nil ~= ItemIndex and Content.Owner.IsBuffListItemSelected and Content.Owner:IsBuffListItemSelected(ItemIndex)
  self:SetSelected(bListItemSelected, true)
  local bChosen = bUnlocked and Content.Owner and Content.Owner.IsBuffSelected and Content.Owner:IsBuffSelected(ChallengeBuff.ChallengeBuffId)
  self:SetChoose(bChosen, true)
end

function M:OnBtnAreaClicked()
  local Content = self.Content
  if not (Content and not Content.IsEmpty and Content.Owner) or not Content.Owner.OnBuffListItemClicked then
    return
  end
  Content.Owner:OnBuffListItemClicked(Content)
end

function M:PlayStateAnimation(AnimName)
  local Anim = self[AnimName]
  if not Anim then
    return
  end
  self:PlayAnimation(Anim)
end

function M:OnBtnAreaPressed()
  if self.bSelected then
    return
  end
  self:PlayStateAnimation("Press")
end

function M:OnBtnAreaHovered()
  if self.bSelected then
    return
  end
  self:PlayStateAnimation("Hover")
end

function M:OnBtnAreaUnhovered()
  if self.bSelected then
    return
  end
  self:PlayStateAnimation("UnHover")
end

function M:SetSelected(bSelected, bSkipAnim)
  self.bSelected = bSelected and true or false
  if not self.Click then
    return
  end
  if bSelected then
    if bSkipAnim then
      if self.Normal then
        self:StopAnimation(self.Normal)
      end
      self:PlayAnimation(self.Click)
      if self.SetAnimationCurrentTime and self.Click.GetEndTime then
        self:SetAnimationCurrentTime(self.Click, self.Click:GetEndTime())
      end
    else
      if self.Normal then
        self:StopAnimation(self.Normal)
      end
      self:PlayAnimationForward(self.Click)
    end
    return
  end
  self:StopAnimation(self.Click)
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.UnHover then
    self:StopAnimation(self.UnHover)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:SetChoose(bChosen, bSkipAnim)
  if not self.bUnlocked then
    return
  end
  if bSkipAnim then
    if self.Choosed then
      self.Choosed:SetVisibility(bChosen and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  if bChosen then
    self:PlayAnimationForward(self.Choose)
  else
    self:PlayAnimationReverse(self.Choose)
  end
end

function M:SetImageIcon(ImageWidget, IconPath)
  if not (ImageWidget and IconPath) or "" == IconPath then
    return
  end
  local IconObj = LoadObject(IconPath)
  if IconObj then
    ImageWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    ImageWidget:SetBrushResourceObject(IconObj)
  end
end

return M
