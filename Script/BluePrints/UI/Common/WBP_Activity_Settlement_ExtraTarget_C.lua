require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitExtraTargets(Targets, TitleText)
  if TitleText then
    self.Text_GetReward:SetText(TitleText)
  end
  self.List_Reward:ClearListItems()
  if not Targets then
    return
  end
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) ~= CommonConst.CLIENT_DEVICE_TYPE.PC
  for Index, Target in ipairs(Targets) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Text = Target.Text
    Content.IsFinish = Target.IsFinish
    Content.IsMobile = IsMobile
    Content.ParentWidget = self
    Content.Idx = Index
    self.List_Reward:AddItem(Content)
  end
end

return M
