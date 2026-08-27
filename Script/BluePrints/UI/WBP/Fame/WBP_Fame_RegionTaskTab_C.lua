require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick_Clicked)
  self.bIsFocusable = true
end

function M:OnListItemObjectSet(InContent)
  InContent.EntryWidget = self
  self.Content = InContent
  self:Init(InContent.Owner, InContent.OnTaskTabClicked, InContent.QuestChainType)
  self:SetImageDone(InContent.AllItemsAlreadyClaimed)
  self:ShowRedDot(InContent.ShowRedDot)
  if InContent.Owner and InContent == InContent.Owner.List_Tab:GetItemAt(0) then
    self:Selected()
  end
end

function M:ShowRedDot(bShow)
  if self.Reddot then
    self.Reddot:SetVisibility(bShow and ESlateVisibility.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Owner and self.Owner.CurInputDeviceType == ECommonInputType.Gamepad then
    self.Owner:SelectTaskTab(self.Content)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:Init(Owner, CalllBack, Key)
  self.Owner = Owner
  self.CalllBack = CalllBack
  self.QuestChainType = Key
  if Const.MainQuestChainType == tonumber(self.QuestChainType) then
    local textStr = GText("MainTask")
    self.Text_TabTitle:SetText(textStr)
  elseif Const.SideQuestChainType == tonumber(self.QuestChainType) then
    local textStr = GText("SideLine")
    self.Text_TabTitle:SetText(textStr)
  end
end

function M:OnBtnClick_Clicked()
  if self.Owner and self.CalllBack then
    self.CalllBack(self.Owner, self.QuestChainType)
  end
end

function M:SetImageDone(IsAllDone)
  if IsAllDone then
    self.ImageDone:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.ImageDone:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:UnSelected()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
end

function M:Selected()
  self:PlayAnimation(self.Click)
end

return M
