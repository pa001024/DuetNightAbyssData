local Component = {}

function Component:Construct()
  if GWorld and GWorld.bShouldShowWaterMark then
    local GameInstance = GWorld.GameInstance
    if GameInstance and GameInstance.GetGameUIManager then
      if GameInstance:GetGameUIManager():GetUI("WaterMark") then
        return
      end
      GameInstance:GetGameUIManager():ShowWaterMarkUI()
    end
  end
end

return Component
