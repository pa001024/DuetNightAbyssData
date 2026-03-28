require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitPunishCount(PunishCount)
  self.TextBan:SetText(GText("UI_DungeonPunish_Tips"))
  self.PunishCountText = string.format(GText("UI_DungeonPunish_Times"), PunishCount)
  self.TextTimeContent:SetText(self.PunishCountText)
  self.Btn.Onclicked:Add(self, self.ShowPunishPopup)
  self.WBP_Com_BtnQa:Init({
    OwnerWidget = self,
    PopupID = 100297,
    ClickCallback = self.ShowPunishPopup
  })
  self:RefreshControllerUI()
end

function M:Construct()
  M.Super.Construct(self)
  self:AddInputMethodChangedListen()
  self.TextTimeNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:ShowPunishPopup()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/baned_click", nil, nil)
  local Params = {
    Tips = {
      self.PunishCountText
    }
  }
  UIManager(self):ShowCommonPopupUI(100333, Params)
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  M.Super.Destruct(self)
end

function M:RefreshControllerUI()
  local isGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not isGamepad then
    self.Key:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Key:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:RefreshControllerUI()
end

return M
