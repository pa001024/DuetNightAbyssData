require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:SetInfo(Name)
  if Name then
    local Text = GText(Name)
    if Text then
      local Length = string.len(Text)
      local left_quote = "“"
      local right_quote = "”"
      local left_len = #left_quote
      local right_len = #right_quote
      if Length >= left_len + right_len and Text:sub(1, left_len) == left_quote and Text:sub(-right_len) == right_quote then
        Text = Text:sub(left_len + 1, -right_len - 1)
      end
    end
    self.Text_BossName:SetText(Text)
    self.Text_WorldBossName:SetText(EnText(Name))
  end
end

return M
