require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitData(Content)
  self.Text_Convert:SetText(Content.Text)
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, Content.OnBtnClick)
  self.ParentWidget = Content.Owner
  if Content.IsLocked then
    self:SetLocked(true)
  else
    self:SetLocked(false)
  end
end

function M:SetLocked(Locked)
  if Locked then
    self.Icon:SetVisibility(ESlateVisibility.Collapsed)
    self.Icon_Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Icon_Lock:SetVisibility(ESlateVisibility.Collapsed)
  end
end

return M
