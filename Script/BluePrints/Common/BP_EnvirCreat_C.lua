local BP_EnvirCreat = Class()

function BP_EnvirCreat:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  print("BP_EnvirCreate Begin")
  self.ReloadLightingScenario = false
end

function BP_EnvirCreat:OnLightingScenarioLoaded(LevelName)
  print("BP_EnvirCreate OnLightingScenarioLoaded", LevelName)
  if not self.ReloadLightingScenario and "Huaxu_Haojing_Art_Light_Day" == LevelName then
    self.ReloadLightingScenario = true
    print("BP_EnvirCreate ReloadCurrentLightingScenario")
    self:ReloadCurrentLightingScenario()
  else
    self.ReloadLightingScenario = false
    print("BP_EnvirCreate RefreshReflectionCapture")
    self:RefreshReflectionCapture()
  end
end

return BP_EnvirCreat
