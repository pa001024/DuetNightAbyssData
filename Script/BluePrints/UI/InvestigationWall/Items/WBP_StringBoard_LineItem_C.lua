require("UnLua")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local ReviewItemState = InvestigationWallUtils.ReviewItemState
local ReviewItemWidgetIndex = {Explored = 0, Locked = 1}
local ReviewItemLockProgressIndex = {Pending = 0, Exploring = 1}
local ReviewItemProgressingIndex = {WithIcon = 0, Default = 1}

function M:Initialize(Initializer)
  self.bLineItemHovered = false
end

function M:BindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Clear()
    BtnClick.OnClicked:Add(self, self.OnReviewItemClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Clear()
    BtnClick.OnHovered:Add(self, self.OnLineItemHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Clear()
    BtnClick.OnUnhovered:Add(self, self.OnLineItemUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Clear()
    BtnClick.OnPressed:Add(self, self.OnLineItemPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Clear()
    BtnClick.OnReleased:Add(self, self.OnLineItemReleased)
  end
end

function M:UnbindEvents()
  local BtnClick = self.Btn_Click
  if not BtnClick then
    return
  end
  if BtnClick.OnClicked then
    BtnClick.OnClicked:Remove(self, self.OnReviewItemClicked)
  end
  if BtnClick.OnHovered then
    BtnClick.OnHovered:Remove(self, self.OnLineItemHovered)
  end
  if BtnClick.OnUnhovered then
    BtnClick.OnUnhovered:Remove(self, self.OnLineItemUnhovered)
  end
  if BtnClick.OnPressed then
    BtnClick.OnPressed:Remove(self, self.OnLineItemPressed)
  end
  if BtnClick.OnReleased then
    BtnClick.OnReleased:Remove(self, self.OnLineItemReleased)
  end
end

function M:Destruct()
  self:UnbindEvents()
  self.Content = nil
  self.bLineItemHovered = false
end

function M:StopLineItemStateAnimations()
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

function M:PlayLineItemStateAnimation(Anim)
  if not Anim or not self.PlayAnimation then
    return
  end
  self:StopLineItemStateAnimations()
  self:PlayAnimation(Anim)
end

function M:PlayLineItemNormalAnimation()
  self:PlayLineItemStateAnimation(self.Normal)
end

function M:ResetLineItemInteractionVisual()
  self.bLineItemHovered = false
  if self:IsInteractionAnimSuppressed() then
    return
  end
  self:PlayLineItemNormalAnimation()
end

function M:IsLineItemInteractionBlocked()
  return self.bForbidReviewItemClick == true or self.ReviewItemState == ReviewItemState.Pending
end

function M:IsInteractionAnimSuppressed()
  local OwnerLine = self.Content and self.Content.OwnerLine
  return nil ~= OwnerLine and OwnerLine.bSuppressLineItemFocusVisual == true
end

function M:PlayLineItemFocusHover(bSkipHoverSound)
  self.bLineItemHovered = true
  if self:IsLineItemInteractionBlocked() then
    return
  end
  if self:IsInteractionAnimSuppressed() then
    return
  end
  if self.Hover and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Hover) then
    return
  end
  if not bSkipHoverSound then
    AudioManager(self):PlayUISound(self, "event:/ui/common/ex2_clue_photo_hover", nil, nil)
  end
  self:PlayLineItemStateAnimation(self.Hover)
end

function M:OnLineItemHovered()
  self.bLineItemHovered = true
  if self:IsLineItemInteractionBlocked() or self:IsInteractionAnimSuppressed() then
    return
  end
  if self.Hover and self.IsAnimationPlaying and self:IsAnimationPlaying(self.Hover) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/ex2_clue_photo_hover", nil, nil)
  self:PlayLineItemStateAnimation(self.Hover)
end

function M:OnLineItemUnhovered()
  self.bLineItemHovered = false
  if self:IsLineItemInteractionBlocked() or self:IsInteractionAnimSuppressed() then
    return
  end
  if self.Unhover then
    self:PlayLineItemStateAnimation(self.Unhover)
  else
    self:PlayLineItemNormalAnimation()
  end
end

function M:OnLineItemPressed()
  if self:IsLineItemInteractionBlocked() or self:IsInteractionAnimSuppressed() then
    return
  end
  self:PlayLineItemStateAnimation(self.Press)
end

function M:OnLineItemReleased()
  if self:IsLineItemInteractionBlocked() or self:IsInteractionAnimSuppressed() then
    return
  end
  if self.bLineItemHovered then
    self:PlayLineItemStateAnimation(self.Hover)
  else
    self:PlayLineItemNormalAnimation()
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
    self:PlayLineItemNormalAnimation()
    return
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(self.In) and self.StopAnimation then
    self:StopAnimation(self.In)
  end
  self:PlayAnimation(self.In)
end

function M:OnTileItemSet(Content)
  self.Content = Content
  self:ResetLineItemInteractionVisual()
  self:BindEvents()
  self:RefreshConnectArrow(Content)
  self:RefreshReviewName(Content)
  self:RefreshReviewItemState(Content)
  self:SetReviewItemImage(Content)
  self:PrepareForStaggeredOpenAnimation()
end

function M:GetReviewConfig(Content)
  local ReviewId = Content and Content.ReviewId
  if not ReviewId then
    return nil
  end
  return DataMgr.Review and DataMgr.Review[ReviewId]
end

function M:ResolveReviewItemState(Content)
  local ReviewId = Content and Content.ReviewId
  local Avatar = InvestigationWallUtils.GetAvatarSafe()
  return InvestigationWallUtils.ResolveReviewItemState(ReviewId, Avatar)
end

function M:IsReviewItemExplored(Content)
  return self:ResolveReviewItemState(Content) == ReviewItemState.Explored
end

function M:RefreshReviewItemState(Content)
  Content = Content or self.Content
  if not Content then
    return
  end
  local CurrentReviewItemState = self:ResolveReviewItemState(Content)
  self.ReviewItemState = CurrentReviewItemState
  if CurrentReviewItemState == ReviewItemState.Explored then
    if self.WS_Item then
      self.WS_Item:SetActiveWidgetIndex(ReviewItemWidgetIndex.Explored)
    end
  else
    if self.WS_Item then
      self.WS_Item:SetActiveWidgetIndex(ReviewItemWidgetIndex.Locked)
    end
    if self.WS_Lock_ProgressIng then
      local ProgressIndex = CurrentReviewItemState == ReviewItemState.Exploring and ReviewItemLockProgressIndex.Exploring or ReviewItemLockProgressIndex.Pending
      self.WS_Lock_ProgressIng:SetActiveWidgetIndex(ProgressIndex)
    end
    if CurrentReviewItemState == ReviewItemState.Exploring and self.WS_Progressing then
      local ReviewConfig = self:GetReviewConfig(Content)
      local PicPath = ReviewConfig and ReviewConfig.ReviewPic1
      local bHasReviewPic1 = nil ~= PicPath and "" ~= PicPath
      self.WS_Progressing:SetActiveWidgetIndex(bHasReviewPic1 and ReviewItemProgressingIndex.WithIcon or ReviewItemProgressingIndex.Default)
    end
  end
  local CanClickDetail = CurrentReviewItemState ~= ReviewItemState.Pending
  self:RefreshReviewItemClickable(CanClickDetail)
  self:RefreshStringBoardNewReddot()
  self:RefreshGuidePointVisibility(Content)
  self:RefreshReviewName(Content)
  self:RefreshProgressingText()
end

function M:RefreshGuidePointVisibility(Content)
  local GuidePoint = self.Image_GuidePoint
  if not GuidePoint then
    return
  end
  Content = Content or self.Content
  local ReviewId = Content and Content.ReviewId
  local bCanAccept = InvestigationWallUtils.CanAcceptReviewQuest(ReviewId, InvestigationWallUtils.GetAvatarSafe())
  GuidePoint:SetVisibility(bCanAccept and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshStringBoardNewReddot(bForceHide)
  if not self.EMShowReddot then
    return
  end
  local ReviewId = self.Content and self.Content.ReviewId
  local bShow = false
  if true ~= bForceHide and self.ReviewItemState ~= ReviewItemState.Pending then
    bShow = StringBoardReddotHelper.IsReviewNew(ReviewId)
  end
  self:EMShowReddot(true == bShow, EReddotType.New)
end

function M:RefreshReviewItemClickable(CanClickDetail)
  if not self.Btn_Click then
    return
  end
  if self.Btn_Click.SetIsEnabled then
    self.Btn_Click:SetIsEnabled(true)
  end
  self.bForbidReviewItemClick = true ~= CanClickDetail
end

function M:RefreshProgressingText()
  if not self.Text_Progressing then
    return
  end
  self.Text_Progressing:SetText(GText("UI_StringBoard_Researching"))
end

function M:RefreshReviewName(Content)
  local ReviewConfig = self:GetReviewConfig(Content)
  local TitleText = ""
  if ReviewConfig and ReviewConfig.ReviewName then
    TitleText = GText(ReviewConfig.ReviewName)
  end
  if self.Text_NormalTitle then
    self.Text_NormalTitle:SetText(TitleText)
  end
  if self.Text_ProgressIngTitle then
    local ProgressTitleText = TitleText
    if self:ResolveReviewItemState(Content) == ReviewItemState.Pending then
      ProgressTitleText = GText("Textmap_Review_Unlock")
    end
    self.Text_ProgressIngTitle:SetText(ProgressTitleText)
  end
end

function M:RefreshConnectArrow(Content)
  if not Content or not Content.bIsMainLine then
    self:SetArrowVisibility(self.Image_Arrow_Front, false)
    self:SetArrowVisibility(self.Image_Arrow, false)
    return
  end
  self:SetArrowVisibility(self.Image_Arrow_Front, Content.bShowFrontArrow == true)
  self:SetArrowVisibility(self.Image_Arrow, true == Content.bShowBackArrow)
end

function M:SetArrowVisibility(ArrowImage, bShow)
  if not ArrowImage then
    return
  end
  local Visibility = bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  ArrowImage:SetVisibility(Visibility)
end

function M:OnReviewItemClicked()
  local Content = self.Content
  if not Content then
    return
  end
  if self.bForbidReviewItemClick or self.ReviewItemState == ReviewItemState.Pending then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_photo_click", nil, nil)
  if self.Click then
    self:PlayLineItemStateAnimation(self.Click)
  end
  local UIMgr = UIManager(self)
  local ExistPopup = UIMgr:GetUIObj("StringBoardPopup")
  if ExistPopup then
    UIMgr:UnLoadUINew("StringBoardPopup")
  end
  UIMgr:LoadUINew("StringBoardPopup", Content)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local OwnerLine = self.Content and self.Content.OwnerLine
  if OwnerLine and OwnerLine.OnPreviewKeyDown then
    return OwnerLine:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local OwnerLine = self.Content and self.Content.OwnerLine
  if OwnerLine and OwnerLine.OnKeyUp then
    return OwnerLine:OnKeyUp(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local OwnerLine = self.Content and self.Content.OwnerLine
  local OwnerStringBoard = OwnerLine and OwnerLine.OwnerStringBoard
  if OwnerStringBoard and UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and OwnerStringBoard.HandleGamePadKeyDown and OwnerStringBoard:HandleGamePadKeyDown(InKeyName) then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:ApplyImageTexture(ImageWidget, ImageObject, MaterialParamName)
  if not ImageWidget or not ImageObject then
    return
  end
  if ImageWidget.SetBrushFromTexture then
    ImageWidget:SetBrushFromTexture(ImageObject)
  elseif ImageWidget.SetBrushResourceObject then
    ImageWidget:SetBrushResourceObject(ImageObject)
  end
  if not MaterialParamName or not ImageWidget.GetDynamicMaterial then
    return
  end
  local DynamicMaterial = ImageWidget:GetDynamicMaterial()
  if DynamicMaterial and DynamicMaterial.SetTextureParameterValue then
    DynamicMaterial:SetTextureParameterValue(MaterialParamName, ImageObject)
  end
end

function M:SetReviewItemImage(Content)
  Content = Content or self.Content
  local ReviewConfig = self:GetReviewConfig(Content)
  if not ReviewConfig then
    return
  end
  local PicPath = ReviewConfig.ReviewPic1
  if self:IsReviewItemExplored(Content) then
    PicPath = ReviewConfig.ReviewPic2
  end
  if not PicPath or "" == PicPath then
    return
  end
  local ImageObject = LoadObject(PicPath)
  if not ImageObject then
    return
  end
  if self.Image_Icon then
    self:ApplyImageTexture(self.Image_Icon, ImageObject)
  end
  local VxIcon = self.VX_Icon
  if VxIcon and VxIcon.GetDynamicMaterial then
    local DynamicMaterial = VxIcon:GetDynamicMaterial()
    if DynamicMaterial and DynamicMaterial.SetTextureParameterValue then
      DynamicMaterial:SetTextureParameterValue("DissolveTex", ImageObject)
    end
  end
  if self:ResolveReviewItemState(Content) == ReviewItemState.Exploring then
    self:ApplyImageTexture(self.Image_IconProgressing, ImageObject, "MainTex")
  end
end

return M
