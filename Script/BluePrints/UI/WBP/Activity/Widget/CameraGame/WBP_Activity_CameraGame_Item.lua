require("UnLua")
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
end

function M:HandleNavigationUp()
  if not self.Content or not self.Content.Index then
    return
  end
  local Contents = self.ParentWidget.PhotoItemContents
  local PrevContent = Contents and Contents[self.Content.Index - 1]
  if not PrevContent or 2 == PrevContent.ShowType then
    return
  end
  local PrevIndex = self.Content.Index - 2
  self.ParentWidget.ListView_Left:NavigateToIndex(PrevIndex)
end

function M:HandleNavigationDown()
  if not (self.Content and self.Content.Index) or not self.ParentWidget then
    return
  end
  local Contents = self.ParentWidget.PhotoItemContents
  local NextContent = Contents and Contents[self.Content.Index + 1]
  if not NextContent or 2 == NextContent.ShowType then
    return
  end
  local NextIndex = self.Content.Index
  self.ParentWidget.ListView_Left:NavigateToIndex(NextIndex)
end

function M:SwitchShowType()
  local WidgetIndex
  if self.Content.QuestState == self.QCS.finish then
    WidgetIndex = 0
    self.Content.Texture = LoadObject(self.Content.PhotoPath)
    self.Image_Canmer:SetBrushFromTexture(self.Content.Texture)
  elseif self.Content.QuestState == self.QCS.unlock or self.Content.QuestState == self.QCS.doing then
    WidgetIndex = 1
    self.Content.Texture = LoadObject(self.Content.PhotoPath)
    self.Image_CanmerNone:SetBrushFromTexture(self.Content.Texture)
  else
    WidgetIndex = 2
    self:SetUnlockTimeText()
  end
  self.Switch_Type:SetActiveWidgetIndex(WidgetIndex)
end

function M:SetUnlockTimeText()
  local UnlockTime = self.Content.UnlockTime
  if not UnlockTime or type(UnlockTime) ~= "number" then
    return
  end
  
  local function _SetUnlockTimeText()
    local RemainTimeDict, _ = UIUtils.GetLeftTimeStrStyle2(UnlockTime)
    self.Content.RemainTimeText = string.format(GText("UI_HardBoss_Unlocklevel"), RemainTimeDict[1])
    self.Text_Time:SetText(self.Content.RemainTimeText)
    if self.ParentWidget and self.ParentWidget.ContentClicked == self.Content then
      self.ParentWidget:RefreshMainPhotoView(self.Content)
    end
  end
  
  _SetUnlockTimeText()
  self:AddTimer(60.0, _SetUnlockTimeText, true, 0, nil, true)
end

function M:ShowReddot(ReddotType)
  if not ReddotType or type(ReddotType) ~= "number" then
    return
  end
  if ReddotType == EReddotType.Normal then
    self.Switch_Reddot:SetActiveWidgetIndex(0)
  elseif ReddotType == EReddotType.New then
    self.Switch_Reddot:SetActiveWidgetIndex(1)
  else
    return
  end
  self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:HideReddot()
  self.Switch_Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

AssembleComponents(M)
return M
