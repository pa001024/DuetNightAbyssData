require("UnLua")
local GText = _ENV.GText
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.bIsSelected = nil
  self.bTabHovered = false
  self.bUnlockAnimating = false
end

function M:BindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Clear()
    BtnClick.OnClicked:Add(self, self.OnSubTabClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Clear()
    BtnClick.OnHovered:Add(self, self.OnSubTabHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Clear()
    BtnClick.OnUnhovered:Add(self, self.OnSubTabUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Clear()
    BtnClick.OnPressed:Add(self, self.OnSubTabPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Clear()
    BtnClick.OnReleased:Add(self, self.OnSubTabReleased)
  end
end

function M:UnbindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Remove(self, self.OnSubTabClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Remove(self, self.OnSubTabHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Remove(self, self.OnSubTabUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Remove(self, self.OnSubTabPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Remove(self, self.OnSubTabReleased)
  end
end

function M:Destruct()
  self:CancelSubTabUnlockAnimation()
  self:UnbindSubTabUnselectFinished()
  self:UnbindEvents()
  self.Content = nil
  self.bIsSelected = nil
  self.bTabHovered = false
end

function M:StopSubTabStateAnimations()
  local StateAnimList = {
    self.Normal,
    self.Hover,
    self.Unhover,
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

function M:PlaySubTabStateAnimation(Anim)
  if not Anim or not self.PlayAnimation then
    return
  end
  self:StopSubTabStateAnimations()
  self:PlayAnimation(Anim)
end

function M:PlaySubTabNormalAnimation()
  self:PlaySubTabStateAnimation(self.Normal)
end

function M:IsSubTabSelectionAnimating()
  if self.Select and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Select) then
    return true
  end
  if self.Unselect and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Unselect) then
    return true
  end
  return false
end

function M:UnbindSubTabUnselectFinished()
  if self.Unselect and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Unselect)
  end
end

function M:UnbindSubTabUnlockFinished()
  if self.Unlock and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Unlock)
  end
end

function M:StopSubTabUnlockSelectIfPlaying()
  if not self.bUnlockPlayedSelectTogether then
    return
  end
  if self.Select and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Select) and self.StopAnimation then
    self:StopAnimation(self.Select)
  end
  self.bUnlockPlayedSelectTogether = false
end

function M:StopSubTabUnlockAnimationOnly()
  self:UnbindSubTabUnlockFinished()
  if self.Unlock and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Unlock) and self.StopAnimation then
    self:StopAnimation(self.Unlock)
  end
  self:StopSubTabUnlockSelectIfPlaying()
  self.bUnlockAnimating = false
end

function M:CancelSubTabUnlockAnimation()
  local bWasUnlockAnimating = self.bUnlockAnimating == true
  self:StopSubTabUnlockAnimationOnly()
  if bWasUnlockAnimating then
    if self.bIsSelected then
      self:ApplySubTabSelected()
    else
      self:PlaySubTabNormalAnimation()
    end
  end
end

function M:TryPlaySubTabUnlockIfFirstEntrance()
  local CluePageId = self.Content and self.Content.CluePageId
  if not CluePageId then
    return false
  end
  if StringBoardReddotHelper.HasSeenPageUnlockEntrance(CluePageId) then
    return false
  end
  local bIsSelectedForUnlock = self.bIsSelected == true or true == self.bPendingSelectedForUnlock
  if bIsSelectedForUnlock then
    StringBoardReddotHelper.MarkPageUnlockEntranceSeen(CluePageId)
    return false
  end
  return self:TryPlaySubTabUnlockAnimation()
end

function M:TryPlaySubTabUnlockAnimation()
  if not self.Unlock or not self.PlayAnimation then
    return false
  end
  if self.bUnlockAnimating then
    return true
  end
  local bPlaySelectTogether = self.bIsSelected == true or true == self.bPendingSelectedForUnlock
  self:UnbindSubTabUnselectFinished()
  self:UnbindSubTabUnlockFinished()
  self.bUnlockAnimating = true
  self.bUnlockPlayedSelectTogether = false
  self:StopSubTabStateAnimations()
  self:PlayAnimation(self.Unlock)
  if bPlaySelectTogether and self.Select then
    self:PlayAnimation(self.Select)
    self.bUnlockPlayedSelectTogether = true
  end
  if self.BindToAnimationFinished then
    self:BindToAnimationFinished(self.Unlock, {
      self,
      self.OnSubTabUnlockFinished
    })
  else
    self:OnSubTabUnlockFinished()
  end
  return true
end

function M:OnSubTabUnlockFinished()
  self:UnbindSubTabUnlockFinished()
  self.bUnlockAnimating = false
  local CluePageId = self.Content and self.Content.CluePageId
  if CluePageId then
    StringBoardReddotHelper.MarkPageUnlockEntranceSeen(CluePageId)
  end
  local bPlayedSelectTogether = self.bUnlockPlayedSelectTogether == true
  self.bUnlockPlayedSelectTogether = false
  if self.bIsSelected then
    if bPlayedSelectTogether then
      return
    end
    self:ApplySubTabSelected()
    return
  end
  self:PlaySubTabNormalAnimation()
end

function M:OnSubTabUnselectFinished()
  self:UnbindSubTabUnselectFinished()
  if self.bIsSelected then
    return
  end
  if self.bUnlockAnimating then
    return
  end
  self:PlaySubTabNormalAnimation()
end

function M:ResetSubTabInteractionVisual()
  self.bIsSelected = false
  self.bTabHovered = false
  self:UnbindSubTabUnselectFinished()
  self:CancelSubTabUnlockAnimation()
  self:PlaySubTabNormalAnimation()
end

function M:ApplySubTabSelected()
  if self.bUnlockAnimating then
    self.bIsSelected = true
    self.bTabHovered = false
    return
  end
  self:UnbindSubTabUnselectFinished()
  self.bIsSelected = true
  self.bTabHovered = false
  if self.Select then
    self:PlaySubTabStateAnimation(self.Select)
  end
end

function M:ApplySubTabUnselected()
  self.bIsSelected = false
  if self.bUnlockAnimating then
    self:StopSubTabUnlockSelectIfPlaying()
    return
  end
  self:UnbindSubTabUnselectFinished()
  if self.Unselect and self.PlayAnimation then
    self:PlaySubTabStateAnimation(self.Unselect)
    if self.BindToAnimationFinished then
      self:BindToAnimationFinished(self.Unselect, {
        self,
        self.OnSubTabUnselectFinished
      })
    else
      self:PlaySubTabNormalAnimation()
    end
    return
  end
  self:PlaySubTabNormalAnimation()
end

function M:OnListItemObjectSet(Content)
  self:UnbindSubTabUnselectFinished()
  self:CancelSubTabUnlockAnimation()
  self.Content = Content
  self.bIsSelected = nil
  self.bTabHovered = false
  self:BindEvents()
  self:RefreshSubTabText()
  self:RefreshSubTabStateFromParent()
end

function M:RefreshSubTabText()
  local Content = self.Content
  if not Content or not self.Text_Tab then
    return
  end
  local CluePageId = Content.CluePageId
  local CluePageData = CluePageId and DataMgr.CluePage and DataMgr.CluePage[CluePageId]
  local TextKey = CluePageData and CluePageData.CluePageName or ""
  self.Text_Tab:SetText("" ~= TextKey and GText(TextKey) or "")
end

function M:RefreshSubTabStateFromParent()
  local Content = self.Content
  local Parent = Content and Content.Parent
  local CluePageId = Content and Content.CluePageId
  local ListIndex = Content and Content.Index
  if not (Parent and CluePageId) or not ListIndex then
    self:RefreshClueListState(false, false)
    return
  end
  local bCanShow = Parent.CheckClueListCanShow and Parent:CheckClueListCanShow(CluePageId) or false
  local bIsSelected = Parent.SelectedClueListIndex == ListIndex
  self:RefreshClueListState(bCanShow, bIsSelected)
end

function M:RefreshClueListState(bCanShow, bIsSelected)
  bIsSelected = true == bIsSelected
  if not bCanShow then
    self:CancelSubTabUnlockAnimation()
    self.bIsSelected = false
    self.bTabHovered = false
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:RefreshStringBoardNewReddot(true)
    return
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.bPendingSelectedForUnlock = bIsSelected
  self:TryPlaySubTabUnlockIfFirstEntrance()
  self.bPendingSelectedForUnlock = nil
  self:RefreshStringBoardNewReddot()
  if self.bUnlockAnimating then
    if not bIsSelected then
      self:StopSubTabUnlockSelectIfPlaying()
    end
    self.bIsSelected = bIsSelected
    self.bTabHovered = false
    return
  end
  if bIsSelected then
    if self.bIsSelected then
      return
    end
    self:ApplySubTabSelected()
    return
  end
  if self.bIsSelected then
    self:ApplySubTabUnselected()
    return
  end
  self.bIsSelected = false
  self:PlaySubTabNormalAnimation()
end

function M:RefreshStringBoardNewReddot(bForceHide)
  if not self.EMShowReddot then
    return
  end
  local CluePageId = self.Content and self.Content.CluePageId
  local bShow = true ~= bForceHide and StringBoardReddotHelper.IsPageNew(CluePageId)
  self:EMShowReddot(true == bShow, EReddotType.New)
end

function M:OnSubTabHovered()
  self.bTabHovered = true
  if self.bIsSelected or self.bUnlockAnimating or self:IsSubTabSelectionAnimating() then
    return
  end
  self:PlaySubTabStateAnimation(self.Hover)
end

function M:OnSubTabUnhovered()
  self.bTabHovered = false
  if self.bIsSelected or self.bUnlockAnimating or self:IsSubTabSelectionAnimating() then
    return
  end
  if self.Unhover then
    self:PlaySubTabStateAnimation(self.Unhover)
  else
    self:PlaySubTabNormalAnimation()
  end
end

function M:OnSubTabPressed()
  if self.bIsSelected or self.bUnlockAnimating or self:IsSubTabSelectionAnimating() then
    return
  end
  self:PlaySubTabStateAnimation(self.Press)
end

function M:OnSubTabReleased()
  if self.bIsSelected or self.bUnlockAnimating or self:IsSubTabSelectionAnimating() then
    return
  end
  if self.bTabHovered then
    self:PlaySubTabStateAnimation(self.Hover)
  else
    self:PlaySubTabNormalAnimation()
  end
end

function M:OnSubTabClicked()
  local Content = self.Content
  local Parent = Content and Content.Parent
  if Parent and Parent.OnClueSubTabClick then
    Parent:OnClueSubTabClick(Content.Index, Content.CluePageId)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local Parent = self.Content and self.Content.Parent
  if Parent and Parent.OnPreviewKeyDown then
    return Parent:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Parent = self.Content and self.Content.Parent
  if Parent and Parent.OnKeyDown then
    return Parent:OnKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Parent = self.Content and self.Content.Parent
  if Parent and Parent.OnAnalogValueChanged then
    return Parent:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  end
  return UIUtils.Unhandled
end

function M:BP_OnEntryReleased()
  self:UnbindSubTabUnselectFinished()
  self:CancelSubTabUnlockAnimation()
  self:UnbindEvents()
  self:ResetSubTabInteractionVisual()
  self.Content = nil
  self.bIsSelected = nil
end

return M
