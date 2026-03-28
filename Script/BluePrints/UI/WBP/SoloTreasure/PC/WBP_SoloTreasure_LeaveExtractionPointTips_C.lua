require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self.Text_Task02:SetText(GText("UI_Extraction_TM_24"))
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self:AddTimer(0.5, function()
        self:Close()
      end, false, 0, "LeaveExtractionPointTips", true)
    end
  })
end

function M:OnLoaded(...)
  self:InitUI()
  self:PlayAnimation(self.In)
end

function M:InitUI()
end

function M:CloseUI()
  self:RemoveTimer("LeaveExtractionPointTips")
  self:Close()
end

return M
