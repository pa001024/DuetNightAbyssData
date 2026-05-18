require("UnLua")
local WBP_Guild_DynamicsMessageItem_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function WBP_Guild_DynamicsMessageItem_C:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  local MsgData = Content.MessageData
  if not MsgData then
    return
  end
  local Root = Content.Root
  local FormattedText = Root and Root:FormatMessageText(MsgData) or ""
  self.Text_Message:SetText(FormattedText)
end

return WBP_Guild_DynamicsMessageItem_C
