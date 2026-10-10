require("UnLua")
local QuestReviewUtils = require("BluePrints.UI.QuestReview.QuestReviewUtils")
local ipairs = _ENV.ipairs
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.OwnerRoot = nil
  self.JumpQuestChainId = nil
  self:BindToAnimationFinished(self.Out, {
    self,
    self.HideSelf
  })
end

function M:Init(OwnerRoot, QuestChainId)
  self.OwnerRoot = OwnerRoot
  self.JumpQuestChainId = QuestChainId
  self:RefreshChapterList()
end

function M:RefreshChapterList()
  if not self.List then
    return
  end
  self.List:ClearListItems()
  local ReviewList = QuestReviewUtils:GetSortedReviewList()
  for _, Cfg in ipairs(ReviewList) do
    local Content = QuestReviewUtils:CreateChapterContent({
      QuestReviewId = Cfg.QuestReviewId,
      OwnerWidget = self
    })
    self.List:AddItem(Content)
  end
  self.List:RequestPlayEntriesAnim()
end

function M:OnChapterClicked(QuestReviewId)
  if self.OwnerRoot then
    self.OwnerRoot:OnChapterClicked(QuestReviewId)
  end
end

function M:SwitchIn()
  if self:IsAnimationPlaying(self.Out) then
    self:StopAnimation(self.Out)
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:SetFocus()
end

function M:SwitchOut()
  self:PlayAnimation(self.Out)
end

function M:InitGamepadView()
  self:NavigateToFirstDisplayedItem(self.List)
end

function M:InitKeyboardView()
  self:SetFocus()
end

function M:NavigateToFirstDisplayedItem(List)
  local ItemUIs = List:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    local TargetWidget = ItemUIs:GetRef(1)
    if TargetWidget then
      List:BP_NavigateToItem(TargetWidget.Content)
      return TargetWidget
    end
  end
  return List
end

function M:BP_GetDesiredFocusTarget()
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    return self:NavigateToFirstDisplayedItem(self.List)
  else
    return self
  end
end

function M:HideSelf()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  self.OwnerRoot = nil
  self.JumpQuestChainId = nil
  self:UnbindAllFromAnimationFinished(self.Out)
end

return M
