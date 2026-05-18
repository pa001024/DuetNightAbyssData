require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
  self.GroupList = {}
  self.List_Reward:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Reward:SetControlScrollbarInside(true)
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.List_Reward:ClearListItems()
  self.GroupList = Params.Groups or {}
  for Index, Group in ipairs(self.GroupList) do
    local ItemObject = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObject.Index = Index
    ItemObject.Parent = self
    ItemObject.GroupTitle = Group.Title or ""
    ItemObject.RewardId = Group.RewardId
    self.List_Reward:AddItem(ItemObject)
  end
  self.List_Reward:NavigateToIndex(0)
end

function M:OnMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:ShowGamepadCloseBtn(not bIsOpen)
  end
end

function M:HandleDialogFocused()
  if self.List_Reward and self.List_Reward:IsVisible() then
    return self.List_Reward
  end
  return nil
end

return M
