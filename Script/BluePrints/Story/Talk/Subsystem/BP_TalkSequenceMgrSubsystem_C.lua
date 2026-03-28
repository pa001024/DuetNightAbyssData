local M = Class()

function M:BindMoveProxyFinish_Lua(BindId, Proxy)
  local function OnMoveFinish()
    self:OnMoveProxyFinish(BindId)
  end
  
  Proxy.OnSuccess:Add(self, OnMoveFinish)
  Proxy.OnFail:Add(self, OnMoveFinish)
end

function M:OnCharacterLightTickStateChanged(Enable)
  if Enable then
    self.SavedEyeAdaptationQuality = UKismetSystemLibrary.GetConsoleVariableIntValue("r.EyeAdaptationQuality")
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.EyeAdaptationQuality 0")
  elseif self.SavedEyeAdaptationQuality then
    UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.EyeAdaptationQuality " .. tostring(self.SavedEyeAdaptationQuality or 2))
    self.SavedEyeAdaptationQuality = nil
  end
end

return M
