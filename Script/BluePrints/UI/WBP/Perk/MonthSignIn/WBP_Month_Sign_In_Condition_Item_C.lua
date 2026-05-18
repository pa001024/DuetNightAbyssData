require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self:Init(Content)
end

function M:Init(Content)
  self:InitView()
end

function M:InitView()
  self:SetIconFront()
  self:SetText()
end

function M:SetIconFront()
  if self.Content.Mine >= self.Content.Target then
    local IconPath = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/MI_Com_Chose.MI_Com_Chose'"
    local IconDice = LoadObject(IconPath)
    self.Image_Check:SetBrushResourceObject(IconDice)
  end
end

function M:SetText()
  self.TextContent:SetText(string.format(GText(self.Content.ConditionText), self.Content.Target))
end

return M
