require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_Dismiss:SetText(GText("UI_RemovalWarning"))
  self.MenuAnchor.OnGetMenuContentEvent:Bind(self, self.OnGetMenuContent)
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  self.IsBubbleVisible = false
  self.CountDownDay = 0
  self.CountDownText = ""
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.DPadRight
      }
    }
  })
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClick)
  self.MenuAnchor.OnGetMenuContentEvent:Unbind()
end

function M:SetCounstDownDay(CountDownDay)
  self.CountDownDay = CountDownDay
  self.CountDownText = string.format(GText("UI_GuildMasterInactivityRemoval"), tostring(CountDownDay))
end

function M:OnBtnClick()
  self.MenuAnchor:Open(true)
end

function M:CloseBubble()
  self.MenuAnchor:Close()
end

function M:OnGetMenuContent()
  if not IsValid(self.Bubble) then
    self.Bubble = UIManager(self):CreateWidget("/Game/UI/WBP/Common/WBP_Com_HudBubble.WBP_Com_HudBubble")
  end
  local ConfigData = {}
  ConfigData.Text = self.CountDownText
  ConfigData.ColorType = 5
  ConfigData.Arrow = 10
  self.Bubble:Init(ConfigData)
  return self.Bubble
end

function M:SetKeyControllerVisibility(bVisible)
  if bVisible then
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if not UIUtils.IsGamepadInput() then
    self:SetKeyControllerVisibility(false)
  end
end

return M
