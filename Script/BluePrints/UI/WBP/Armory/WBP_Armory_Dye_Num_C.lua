require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitContent(Params, PopupData, Owner)
  self.Text_Fenghua:SetText(GText("UI_AppearanceScore_ScoreName"))
  self.Text_DyeCost:SetText(GText("UI_COMMONPOP_TEXT_100100"))
  self.DyeAddScore = AddScore
  local IsMaxScore = false
  if Params.AppearanceScore >= Params.DyeMaxScore then
    IsMaxScore = true
  end
  if Params.DyeAddScore > 0 and not IsMaxScore then
    self.Num_Fenghua_Now:SetText(Params.AppearanceScore)
    self.Num_Fenghua_Preview:SetText(math.min(Params.AppearanceScore + Params.DyeAddScore, Params.DyeMaxScore))
    self.Panel_Tip:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local Contents = Params.UseItemsArray
  local AllChildren = self.WB_DyeItem:GetAllChildren():ToTable()
  local ChildrenNum = #AllChildren
  local ContentNum = #Contents
  local ItemPerRow = 3
  local WidgetClass = UGameplayStatics.GetObjectClass(AllChildren[1])
  local UIManager = UIManager(self)
  if ChildrenNum > ContentNum then
    for i = ChildrenNum, ContentNum + 1, -1 do
      AllChildren[i]:RemoveFromParent()
    end
  elseif ChildrenNum < ContentNum then
    for i = ChildrenNum, ContentNum - 1 do
      self.WB_DyeItem:AddChild(UIManager:CreateWidget(WidgetClass, false))
    end
  end
  AllChildren = self.WB_DyeItem:GetAllChildren():ToTable()
  for i = 1, #AllChildren do
    if Contents[i] then
      AllChildren[i]:OnListItemObjectSet(Contents[i])
      AllChildren[i]:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

return M
