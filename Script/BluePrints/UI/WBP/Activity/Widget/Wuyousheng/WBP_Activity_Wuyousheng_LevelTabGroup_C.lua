require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self:Init(Content)
end

function M:Init(Content)
  if Content.DungeonId1 then
    self.LevelTab_1:Init(Content.DungeonId1)
    self.LevelTab_1.ParentWidget = Content.ParentWidget
  end
  if Content.DungeonId2 == nil then
    self.LevelTab_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.LevelTab_2:Init(Content.DungeonId2)
    self.LevelTab_2.ParentWidget = Content.ParentWidget
  end
end

return M
