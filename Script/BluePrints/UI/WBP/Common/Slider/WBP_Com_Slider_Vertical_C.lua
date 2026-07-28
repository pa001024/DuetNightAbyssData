require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Common.Slider.WBP_Com_Slider_C"
})

function M:Construct()
  self.SliderType = "Vertical"
  M.Super.Construct(self)
end

function M:Init(ConfigData)
  rawset(self, "GamePadMinKeyPath", "Down")
  rawset(self, "GamePadAddKeyPath", "Up")
  M.Super.Init(self, ConfigData)
end

function M:MiniMaxUseGamePadStyle(UseGamePadStyle)
end

function M:UpdateMouseGamePadImage(CurGamepadName)
  if self.CurGamepadNameName == CurGamepadName then
    return
  end
  local ResourceIconPath = UIUtils.UtilsGetKeyIconPathInGamepad("RVH", CurGamepadName)
  local Img = LoadObject(ResourceIconPath)
  if not IsValid(Img) then
    return
  end
  self.Slider_Controller.WidgetStyle.NormalThumbImage.ResourceObject = Img
end

return M
