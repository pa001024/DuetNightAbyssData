require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  Content.UI = self
  local Path = LoadObject(Content.Path)
  self.MissionId = Content.MissionId
  self.Icon_Buff:SetBrushResourceObject(Path)
  self.Btn_Click.OnClicked:Add(self, self.OnClick)
end

function M:OnClick()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  UIManager(self):LoadUINew("AutoChessBuffDetail", self.MissionId)
end

return M
