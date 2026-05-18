require("UnLua")
local ClassPath = "/Game/UI/UI_PC/Common/Common_Item_subsize_PC_Content.Common_Item_subsize_PC_Content_C"
local WBP_Guild_DynamicsMessage_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function WBP_Guild_DynamicsMessage_C:OnListItemObjectSet(Content)
  self.Content = Content
  if not Content then
    return
  end
  local Root = Content.Root
  self.Text_Date:SetText(Content.DateText or "")
  if self.In then
    self:PlayAnimation(self.In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1)
  end
  self.List_Message:ClearListItems()
  self.List_Message:DisableScroll(true)
  local Messages = Content.Messages
  if not Messages or 0 == #Messages then
    return
  end
  for _, MsgData in ipairs(Messages) do
    local Obj = NewObject(UE4.LoadClass(ClassPath))
    Obj.Root = Root
    Obj.MessageData = MsgData
    self.List_Message:AddItem(Obj)
  end
end

return WBP_Guild_DynamicsMessage_C
