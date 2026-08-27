require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local CommonConst = require("CommonConst")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local UIUtils = require("Utils.UIUtils")
local ClueItemWidgetIndex = {Unlocked = 0, Locked = 1}

function M:Initialize(Initializer)
end

function M:BindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  BtnClick.bIsFocusable = false
  if BtnClick.SetIsFocusable then
    BtnClick:SetIsFocusable(false)
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Clear()
    BtnClick.OnClicked:Add(self, self.OnClueItemClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Clear()
    BtnClick.OnHovered:Add(self, self.OnClueItemHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Clear()
    BtnClick.OnUnhovered:Add(self, self.OnClueItemUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Clear()
    BtnClick.OnPressed:Add(self, self.OnClueItemPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Clear()
    BtnClick.OnReleased:Add(self, self.OnClueItemReleased)
  end
end

function M:UnbindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Remove(self, self.OnClueItemClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Remove(self, self.OnClueItemHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Remove(self, self.OnClueItemUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Remove(self, self.OnClueItemPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Remove(self, self.OnClueItemReleased)
  end
end

function M:Destruct()
  self:UnbindEvents()
  self.Content = nil
  self.bClueItemHovered = false
  self.bClueItemSelected = false
end

function M:StopClueItemStateAnimations()
  local StateAnimList = {
    self.Normal,
    self.Hover,
    self.Unhover,
    self.Press,
    self.Click
  }
  for _, Anim in ipairs(StateAnimList) do
    if Anim and self.IsAnimationPlaying and self:IsAnimationPlaying(Anim) and self.StopAnimation then
      self:StopAnimation(Anim)
    end
  end
end

function M:PlayClueItemStateAnimation(Anim)
  if not Anim or not self.PlayAnimation then
    return
  end
  self:StopClueItemStateAnimations()
  self:PlayAnimation(Anim)
end

function M:PlayClueItemNormalAnimation()
  self:PlayClueItemStateAnimation(self.Normal)
end

function M:ResetClueItemInteractionVisual()
  self.bClueItemHovered = false
  self.bClueItemSelected = false
  self:PlayClueItemNormalAnimation()
end

function M:ApplyClueItemSelected()
  self.bClueItemSelected = true
  self.bClueItemHovered = false
  if self.Click then
    self:PlayClueItemStateAnimation(self.Click)
  end
end

function M:ClearClueItemSelected()
  if not self.bClueItemSelected then
    return
  end
  self.bClueItemSelected = false
  self:PlayClueItemNormalAnimation()
  if self.Normal and self.SetAnimationCurrentTime and self.Normal.GetEndTime then
    self:SetAnimationCurrentTime(self.Normal, self.Normal:GetEndTime())
  end
  if self.bClueItemHovered then
    self:PlayClueItemStateAnimation(self.Hover)
  end
end

function M:PlayClueItemHoverVisual()
  self.bClueItemHovered = true
  if self.bClueItemSelected then
    return
  end
  if self.ClueState == CommonConst.ClueState.Locked then
    return
  end
  self:PlayClueItemStateAnimation(self.Hover)
end

function M:OnClueItemHovered()
  if UIUtils.IsGamepadInput() then
    return
  end
  self:PlayClueItemHoverVisual()
end

function M:OnClueItemUnhovered()
  if UIUtils.IsGamepadInput() then
    return
  end
  self.bClueItemHovered = false
  if self.bClueItemSelected then
    return
  end
  if self.Unhover then
    self:PlayClueItemStateAnimation(self.Unhover)
  else
    self:PlayClueItemNormalAnimation()
  end
end

function M:OnClueItemPressed()
  if self.bClueItemSelected then
    return
  end
  if self.ClueState == CommonConst.ClueState.Locked then
    return
  end
  self:PlayClueItemStateAnimation(self.Press)
end

function M:OnClueItemReleased()
  if self.bClueItemSelected then
    return
  end
  if self.ClueState == CommonConst.ClueState.Locked then
    return
  end
  if self.bClueItemHovered then
    self:PlayClueItemStateAnimation(self.Hover)
  else
    self:PlayClueItemNormalAnimation()
  end
end

function M:PrepareForStaggeredOpenAnimation()
  if self.SetRenderOpacity then
    self:SetRenderOpacity(0)
  end
end

function M:PlayOpenAnimation()
  if self.SetRenderOpacity then
    self:SetRenderOpacity(1)
  end
  if not self.In or not self.PlayAnimation then
    self:PlayClueItemNormalAnimation()
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self:PlayAnimation(self.In)
end

function M:OnTileItemSet(Content)
  self.Content = Content
  self:ResetClueItemInteractionVisual()
  self:BindEvents()
  self:RefreshClueItemInfo()
  self:PrepareForStaggeredOpenAnimation()
end

function M:ResolveClueState(Content)
  local ClueId = Content and Content.ClueId
  if not ClueId then
    return CommonConst.ClueState.Locked
  end
  return InvestigationWallUtils.CheckClueState(ClueId, InvestigationWallUtils.GetAvatarSafe())
end

function M:RefreshClueItemWidgetSwitcher(ClueState)
  if not self.WS_Item then
    return
  end
  if ClueState == CommonConst.ClueState.Locked then
    self.WS_Item:SetActiveWidgetIndex(ClueItemWidgetIndex.Locked)
    return
  end
  self.WS_Item:SetActiveWidgetIndex(ClueItemWidgetIndex.Unlocked)
end

function M:SetClueItemImage(PicPath)
  if not (self.Image_Icon and PicPath) or "" == PicPath then
    return
  end
  local ImageObject = LoadObject(PicPath)
  if not ImageObject then
    return
  end
  if self.Image_Icon.SetBrushFromTexture then
    self.Image_Icon:SetBrushFromTexture(ImageObject)
  else
    self.Image_Icon:SetBrushResourceObject(ImageObject)
  end
end

function M:ResolveCluePicPath(Content, ClueState)
  if ClueState == CommonConst.ClueState.Finished then
    return Content.CluePic2
  end
  return Content.CluePic1
end

function M:RefreshClueItemClickable(ClueState)
  if not self.Btn_Click or not self.Btn_Click.SetIsEnabled then
    return
  end
  self.Btn_Click:SetIsEnabled(ClueState ~= CommonConst.ClueState.Locked)
end

function M:RefreshClueItemIcon(Content, ClueState)
  if ClueState == CommonConst.ClueState.Locked then
    return
  end
  self:SetClueItemImage(self:ResolveCluePicPath(Content, ClueState))
end

function M:RefreshClueItemIndex(Content)
  local ClueItemIndexWidget = self.ClueItem_Index
  if not ClueItemIndexWidget or not ClueItemIndexWidget.Text_ClueIndex then
    return
  end
  local ClueIndex = Content and Content.ClueIndex
  if not ClueIndex then
    ClueItemIndexWidget.Text_ClueIndex:SetText("")
    return
  end
  ClueItemIndexWidget.Text_ClueIndex:SetText(tostring(ClueIndex))
end

function M:RefreshClueItemInfo()
  local Content = self.Content
  if not Content then
    return
  end
  self.ClueId = Content.ClueId
  local ClueState = self:ResolveClueState(Content)
  self.ClueState = ClueState
  self:RefreshClueItemWidgetSwitcher(ClueState)
  self:RefreshClueItemIcon(Content, ClueState)
  self:RefreshClueItemIndex(Content)
  self:RefreshClueItemClickable(ClueState)
  self:RefreshStringBoardNewReddot()
end

function M:RefreshStringBoardNewReddot(bForceHide)
  if not self.EMShowReddot then
    return
  end
  local bShow = false
  if true ~= bForceHide and self.ClueState ~= CommonConst.ClueState.Locked then
    bShow = StringBoardReddotHelper.IsClueItemNew(self.ClueId)
  end
  self:EMShowReddot(true == bShow, EReddotType.New)
end

function M:OnClueItemClicked()
  local Content = self.Content
  if not Content then
    return
  end
  if self.ClueState == CommonConst.ClueState.Locked then
    return
  end
  if self.bClueItemSelected then
    return
  end
  local Parent = Content.Parent
  if Parent and Parent.OnClueItemClicked then
    Parent:OnClueItemClicked(Content, self.ClueState, self)
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

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local Parent = self.Content and self.Content.Parent
  if Parent and Parent.OnKeyUp then
    return Parent:OnKeyUp(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

return M
