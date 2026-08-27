require("UnLua")
local BP_UIStateBridge_C = Class("BluePrints.UI.BP_UIState_C")

function BP_UIStateBridge_C:OnLoaded()
  self:SetupTypeModule()
  local SystemUIConfig = DataMgr.SystemUI[self.ConfigName]
  local UIType = SystemUIConfig.UIType
  if not UIType then
    return
  end
  if not self.TypeModulePaths then
    return
  end
  local TypeModulePath = self.TypeModulePaths[UIType]
  if not TypeModulePath then
    return
  end
  self.TypeModule = nil
  if type(TypeModulePath) == "string" then
    self.TypeModule = require(TypeModulePath)
  elseif type(TypeModulePath) == "table" then
    self.TypeModule = TypeModulePath
  end
  if not self.TypeModule then
    return
  end
  for k, v in pairs(self.TypeModule) do
    rawset(self, k, v)
  end
end

function BP_UIStateBridge_C:SetupTypeModule()
end

function BP_UIStateBridge_C:Tick(...)
  if self.Overridden and self.Overridden.Tick then
    self.Overridden.Tick(self, ...)
  end
  if self.TypeModule and self.TypeModule.RealTick then
    self.TypeModule.RealTick(self, ...)
  end
end

return BP_UIStateBridge_C
