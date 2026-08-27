require("UnLua")
local M = Class("BluePrints.UI.WBP.Camera.Mobile.WBP_Camera_Roll_M_C")

function M:Construct()
  local GuildConstructMain = UIManager(self):GetUIObj("GuildConstructionMain")
  if not GuildConstructMain then
    return
  end
  if self.BindEvnetOnJoyStick then
    self:BindEvnetOnJoyStick(GuildConstructMain, {
      OnMoved = GuildConstructMain.OnJoyStickMoved,
      OnPointerDown = GuildConstructMain.OnPointerDown,
      OnPointerUp = GuildConstructMain.OnPointerUp
    })
  end
end

return M
