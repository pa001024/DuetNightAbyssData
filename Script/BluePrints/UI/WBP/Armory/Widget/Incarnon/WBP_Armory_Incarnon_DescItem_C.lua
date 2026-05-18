require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitContent(Content)
  if not Content then
    return
  end
  self:PlayAnimation(Content.IsLocked and self.Locked or self.Unlocked)
  self.Text_Talent:SetText(GText(Content.Name))
  self.Text_TalentDesc:SetText(GText(Content.Desc))
end

return M
