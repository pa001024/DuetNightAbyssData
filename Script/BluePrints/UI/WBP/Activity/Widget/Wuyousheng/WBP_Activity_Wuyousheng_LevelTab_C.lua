require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClickClicked)
end

function M:Init(DungeonId)
  self.DungeonId = DungeonId
end

function M:OnBtnClickClicked()
  self.ParentWidget:RefreshLevelInfo(self.DungeonId)
  self.ParentWidget:PlayAnimationForward(self.ParentWidget.Change)
  self.ParentWidget.Root.SelectedDungeonId = self.DungeonId
end

return M
