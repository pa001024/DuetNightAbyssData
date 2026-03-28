require("UnLua")
local CameraGameUtils = require("BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self.QCS = CommonConst.QuestChainState
  self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.ParentWidget = self.Content.ParentWidget
  self:SwitchShowType()
  self:UpdateReddot()
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(UE4.EUINavigation.Right, EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:BP_OnEntryReleased()
  self.Content.SelfWidget = nil
  self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.ParentWidget then
    self.ParentWidget:OnPhotoItemClicked(self.Content)
  end
  return self
end

function M:HandleNavigationUp()
  if not self.Content or not self.Content.Index then
    return self
  end
  local Contents = self.ParentWidget.PhotoItemContents
  local PrevContent = Contents and Contents[self.Content.Index - 1]
  if not PrevContent or 2 == PrevContent.ShowType then
    return self
  end
  local PrevIndex = self.Content.Index - 2
  self.ParentWidget.ListView_Left:NavigateToIndex(PrevIndex)
  return PrevContent.SelfWidget
end

function M:HandleNavigationDown()
  if not (self.Content and self.Content.Index) or not self.ParentWidget then
    return self
  end
  local Contents = self.ParentWidget.PhotoItemContents
  local NextContent = Contents and Contents[self.Content.Index + 1]
  if not NextContent or 2 == NextContent.ShowType then
    return self
  end
  local NextIndex = self.Content.Index
  self.ParentWidget.ListView_Left:NavigateToIndex(NextIndex)
  return NextContent.SelfWidget
end

function M:SwitchShowType()
  local WidgetIndex
  if self.Content.QuestState == self.QCS.finish then
    WidgetIndex = 0
    self.Content.Texture = LoadObject(self.Content.PhotoPath)
    self.Image_Canmer:SetBrushFromTexture(self.Content.Texture)
    self.Text_Num01:SetText(GText(self.Content.TextTitle))
  elseif self.Content.QuestState == self.QCS.unlock or self.Content.QuestState == self.QCS.doing then
    WidgetIndex = 1
    self.Content.Texture = LoadObject(self.Content.PhotoPath)
    self.Image_CanmerNone:SetBrushFromTexture(self.Content.Texture)
  else
    WidgetIndex = 2
  end
  self.Switch_Type:SetActiveWidgetIndex(WidgetIndex)
end

function M:UpdateReddot()
  local ReddotType = self.Content.ReddotType
  if not ReddotType or type(ReddotType) ~= "number" then
    self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if ReddotType == CameraGameUtils.ReddotType.RED then
    self.Switch_Reddot:SetActiveWidgetIndex(0)
    self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  elseif ReddotType == CameraGameUtils.ReddotType.NEW then
    self.Switch_Reddot:SetActiveWidgetIndex(1)
    self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:HideReddot()
  self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

AssembleComponents(M)
return M
