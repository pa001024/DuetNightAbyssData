require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:PlayGuideSound()
  AudioManager(self):PlayUISound(self, "event:/ui/minigame/dachui_power_on_hint", nil, nil)
end

return M
