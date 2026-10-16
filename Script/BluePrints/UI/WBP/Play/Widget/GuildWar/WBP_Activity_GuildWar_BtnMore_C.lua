require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked_BtnMore)
  self.Text_More:SetText(GText("Raid_Season_Floor_More"))
  self:InitControllerMore()
  self:SetControllerMoreVisible(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
end

function M:InitControllerMore()
  if not self.Controller then
    return
  end
  self.Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.SpecialRight
      }
    },
    bLongPress = true,
    bButton = true
  })
end

function M:SetControllerMoreVisible(bVisible)
  if self.Controller then
    self.Controller:SetVisibility(bVisible and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:StartGamepadLongPress()
  if self.Controller then
    self.Controller:OnButtonPressed()
  end
end

function M:StopGamepadLongPress()
  if self.Controller then
    self.Controller:OnButtonReleased()
  end
end

function M:OnClicked_BtnMore()
  UIManager(self):ShowCommonPopupUI(100440)
end

return M
