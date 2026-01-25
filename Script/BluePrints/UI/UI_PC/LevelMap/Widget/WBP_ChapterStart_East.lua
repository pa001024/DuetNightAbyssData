require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  local Id = (...)
  if Id then
    local Info = DataMgr.RegionShowUI[tonumber(Id)]
    self.Text_Title:SetText(GText(Info.TitleText))
    self.Text_BackTitle:SetText(GText(Info.TransText))
    AudioManager(self):PlayUISound(self, Info.AudioPath, nil, nil)
  else
    DebugPrint("lk配表数据不存在")
  end
end

return M
