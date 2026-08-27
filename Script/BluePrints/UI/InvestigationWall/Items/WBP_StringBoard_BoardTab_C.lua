require("UnLua")
local GText = _ENV.GText
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.Parent = nil
  self.DisplayIndex = nil
  self.ClueTypeID = nil
  self.bIsSelected = nil
  self.bTabHovered = false
  self.bUnlockAnimating = false
end

function M:InitUI(Parent, DisplayIndex, ClueTypeID, bIsSelected)
  self.Parent = Parent
  self.DisplayIndex = DisplayIndex
  self.ClueTypeID = ClueTypeID
  self:ResetTabInteractionVisual()
  self.bIsSelected = nil
  self:BindEvents()
  self:RefreshTabUI(bIsSelected)
end

function M:BindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Clear()
    BtnClick.OnClicked:Add(self, self.OnTabClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Clear()
    BtnClick.OnHovered:Add(self, self.OnTabHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Clear()
    BtnClick.OnUnhovered:Add(self, self.OnTabUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Clear()
    BtnClick.OnPressed:Add(self, self.OnTabPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Clear()
    BtnClick.OnReleased:Add(self, self.OnTabReleased)
  end
end

function M:UnbindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Remove(self, self.OnTabClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Remove(self, self.OnTabHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Remove(self, self.OnTabUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Remove(self, self.OnTabPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Remove(self, self.OnTabReleased)
  end
end

function M:Destruct()
  self:CancelTabUnlockAnimation()
  self:UnbindTabUnselectFinished()
  self:UnbindEvents()
  self.Parent = nil
  self.DisplayIndex = nil
  self.ClueTypeID = nil
  self.bIsSelected = nil
  self.bTabHovered = false
end

function M:StopTabStateAnimations()
  local StateAnimList = {
    self.Normal,
    self.Hover,
    self.UnHover,
    self.Press,
    self.Select,
    self.Unselect,
    self.Unlock
  }
  for _, Anim in ipairs(StateAnimList) do
    if Anim and self.IsAnimationPlaying and self:IsAnimationPlaying(Anim) and self.StopAnimation then
      self:StopAnimation(Anim)
    end
  end
end

function M:PlayTabStateAnimation(Anim)
  if not Anim or not self.PlayAnimation then
    return
  end
  self:StopTabStateAnimations()
  self:PlayAnimation(Anim)
end

function M:PlayTabNormalAnimation()
  self:PlayTabStateAnimation(self.Normal)
end

function M:UnbindTabUnselectFinished()
  if self.Unselect and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Unselect)
  end
end

function M:UnbindTabUnlockFinished()
  if self.Unlock and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Unlock)
  end
end

function M:StopTabUnlockSelectIfPlaying()
  if not self.bUnlockPlayedSelectTogether then
    return
  end
  if self.Select and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Select) and self.StopAnimation then
    self:StopAnimation(self.Select)
  end
  self.bUnlockPlayedSelectTogether = false
end

function M:CancelTabUnlockAnimation()
  local bWasUnlockAnimating = self.bUnlockAnimating == true
  self:UnbindTabUnlockFinished()
  if self.Unlock and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Unlock) and self.StopAnimation then
    self:StopAnimation(self.Unlock)
  end
  self:StopTabUnlockSelectIfPlaying()
  self.bUnlockAnimating = false
  if bWasUnlockAnimating then
    if self.bIsSelected then
      self:ApplyTabSelected()
    else
      self:PlayTabNormalAnimation()
    end
  end
end

function M:TryPlayTabUnlockIfFirstEntrance()
  if not self.ClueTypeID then
    return false
  end
  if StringBoardReddotHelper.HasSeenTabUnlockEntrance(self.ClueTypeID) then
    return false
  end
  local bIsSelectedForUnlock = self.bIsSelected == true or true == self.bPendingSelectedForUnlock
  if bIsSelectedForUnlock then
    StringBoardReddotHelper.MarkTabUnlockEntranceSeen(self.ClueTypeID)
    return false
  end
  return self:TryPlayTabUnlockAnimation()
end

function M:TryPlayTabUnlockAnimation()
  if not self.Unlock or not self.PlayAnimation then
    return false
  end
  if self.bUnlockAnimating then
    return true
  end
  local bPlaySelectTogether = self.bIsSelected == true or true == self.bPendingSelectedForUnlock
  self:UnbindTabUnselectFinished()
  self:UnbindTabUnlockFinished()
  self.bUnlockAnimating = true
  self.bUnlockPlayedSelectTogether = false
  self:StopTabStateAnimations()
  self:PlayAnimation(self.Unlock)
  if bPlaySelectTogether and self.Select then
    self:PlayAnimation(self.Select)
    self.bUnlockPlayedSelectTogether = true
  end
  if self.BindToAnimationFinished then
    self:BindToAnimationFinished(self.Unlock, {
      self,
      self.OnTabUnlockFinished
    })
  else
    self:OnTabUnlockFinished()
  end
  return true
end

function M:OnTabUnlockFinished()
  self:UnbindTabUnlockFinished()
  self.bUnlockAnimating = false
  if self.ClueTypeID then
    StringBoardReddotHelper.MarkTabUnlockEntranceSeen(self.ClueTypeID)
  end
  local bPlayedSelectTogether = self.bUnlockPlayedSelectTogether == true
  self.bUnlockPlayedSelectTogether = false
  if self.bIsSelected then
    if bPlayedSelectTogether then
      return
    end
    self:ApplyTabSelected()
    return
  end
  self:PlayTabNormalAnimation()
end

function M:OnTabUnselectFinished()
  self:UnbindTabUnselectFinished()
  if self.bIsSelected then
    return
  end
  if self.bUnlockAnimating then
    return
  end
  self:PlayTabNormalAnimation()
end

function M:ResetTabInteractionVisual()
  self.bIsSelected = false
  self.bTabHovered = false
  self:CancelTabUnlockAnimation()
  self:UnbindTabUnselectFinished()
  self:PlayTabNormalAnimation()
end

function M:ApplyTabSelected()
  if self.bUnlockAnimating then
    self.bIsSelected = true
    self.bTabHovered = false
    return
  end
  self:UnbindTabUnselectFinished()
  self.bIsSelected = true
  self.bTabHovered = false
  if self.Select then
    self:PlayTabStateAnimation(self.Select)
  end
end

function M:ApplyTabUnselected()
  self.bIsSelected = false
  if self.bUnlockAnimating then
    self:StopTabUnlockSelectIfPlaying()
    return
  end
  self:UnbindTabUnselectFinished()
  if self.Unselect and self.PlayAnimation then
    self:PlayTabStateAnimation(self.Unselect)
    if self.BindToAnimationFinished then
      self:BindToAnimationFinished(self.Unselect, {
        self,
        self.OnTabUnselectFinished
      })
    else
      self:PlayTabNormalAnimation()
    end
    return
  end
  self:PlayTabNormalAnimation()
end

function M:RefreshTabUI(bIsSelected)
  if self.Text_Tab then
    local PageTypeConfig = self.ClueTypeID and DataMgr.CluePageType and DataMgr.CluePageType[self.ClueTypeID]
    local TextKey = PageTypeConfig and PageTypeConfig.ClueTabTypeName or ""
    self.Text_Tab:SetText("" ~= TextKey and GText(TextKey) or "")
  end
  self:RefreshClueTabState(true, bIsSelected)
end

function M:RefreshClueTabState(bCanShow, bIsSelected)
  bIsSelected = true == bIsSelected
  if not bCanShow then
    self:CancelTabUnlockAnimation()
    self:UnbindTabUnselectFinished()
    self.bIsSelected = false
    self.bTabHovered = false
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:RefreshStringBoardNewReddot(true)
    return
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.bPendingSelectedForUnlock = bIsSelected
  self:TryPlayTabUnlockIfFirstEntrance()
  self.bPendingSelectedForUnlock = nil
  self:RefreshStringBoardNewReddot()
  if self.bUnlockAnimating then
    if not bIsSelected then
      self:StopTabUnlockSelectIfPlaying()
    end
    self.bIsSelected = bIsSelected
    self.bTabHovered = false
    return
  end
  if bIsSelected then
    if self.bIsSelected then
      return
    end
    self:ApplyTabSelected()
    return
  end
  if self.bIsSelected then
    self:ApplyTabUnselected()
    return
  end
  self.bIsSelected = false
  self:PlayTabNormalAnimation()
end

function M:RefreshStringBoardNewReddot(bForceHide)
  if not self.EMShowReddot then
    return
  end
  local bShow = true ~= bForceHide and StringBoardReddotHelper.IsTabNew(self.ClueTypeID)
  self:EMShowReddot(true == bShow, EReddotType.New)
end

function M:OnTabHovered()
  self.bTabHovered = true
  if self.bIsSelected or self.bUnlockAnimating then
    return
  end
  self:PlayTabStateAnimation(self.Hover)
end

function M:OnTabUnhovered()
  self.bTabHovered = false
  if self.bIsSelected or self.bUnlockAnimating then
    return
  end
  if self.UnHover then
    self:PlayTabStateAnimation(self.UnHover)
  else
    self:PlayTabNormalAnimation()
  end
end

function M:OnTabPressed()
  if self.bIsSelected or self.bUnlockAnimating then
    return
  end
  self:PlayTabStateAnimation(self.Press)
end

function M:OnTabReleased()
  if self.bIsSelected or self.bUnlockAnimating then
    return
  end
  if self.bTabHovered then
    self:PlayTabStateAnimation(self.Hover)
  else
    self:PlayTabNormalAnimation()
  end
end

function M:OnTabClicked()
  if self.Parent and self.Parent.OnClueTabClick and self.DisplayIndex then
    self.Parent:OnClueTabClick(self.DisplayIndex)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Parent = self.Parent
  if Parent and Parent.OnKeyDown then
    return Parent:OnKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

return M
