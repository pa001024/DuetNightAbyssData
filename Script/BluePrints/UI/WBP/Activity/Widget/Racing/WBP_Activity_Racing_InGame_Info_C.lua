require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.List_Info:ClearListItems()
end

function M:OnPetUseSkill(PlayerId, InsideBuffId)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.InsideBuffId = InsideBuffId
  Content.PlayerId = PlayerId
  self.List_Info:AddItem(Content)
  self:ScrollInfoListToBottom()
end

function M:ScrollInfoListToBottom()
  if not self.List_Info then
    return
  end
  if self.List_Info.EndInertialScrolling then
    self.List_Info:EndInertialScrolling()
  end
  if self.List_Info.ScrollToBottom then
    self.List_Info:ScrollToBottom()
    return
  end
  if self.List_Info.GetNumItems and self.List_Info.ScrollIndexIntoView then
    local NumItems = self.List_Info:GetNumItems()
    if NumItems > 0 then
      self.List_Info:ScrollIndexIntoView(NumItems - 1)
    end
  end
end

return M
