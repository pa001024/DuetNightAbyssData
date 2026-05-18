require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_More:Init({
    ClickCallback = self.OnBtn_MoreClicked,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end,
    SoundFuncReceiver = self,
    OwnerWidget = self
  })
  self.Text_Talent:SetText(GText("UI_Armory_HyperPassive"))
end

function M:OnBtn_MoreClicked()
  if self.Type == "Char" then
    UIManager(self):ShowCommonPopupUI(100215, self.PopupParams, self)
  elseif self.Type == "Weapon" then
    UIManager(self):ShowCommonPopupUI(100352, self.PopupParams, self)
  end
end

function M:Init(Params)
  Params = Params or {}
  self.Type = Params.Type
  self.Owner = Params.Owner
  self.PopupParams = Params.PopupParams or {}
  self:SwitchState(self.Type)
  if self.Type == "Char" then
    UIUtils.AddPositioningTagToPanel(self.HB_Tag, self.PopupParams.CharId)
  elseif self.Type == "Weapon" then
    self:InitHyperWeaponInfo(Params.PopupParams)
  end
end

function M:InitHyperWeaponInfo(Params)
  local CurTalentCount = HyperWeaponUtils.GetHyperWeaponCurTalentCount(Params.WeaponUuid)
  local MaxTalentCount = HyperWeaponUtils.GetHyperWeaponMaxTalentCount(Params.WeaponId)
  self.Num_Talent_Now:SetText(CurTalentCount)
  self.Num_Talent_Max:SetText(MaxTalentCount)
end

function M:SwitchState(Type)
  if "Char" == Type then
    self.WS_State:SetActiveWidgetIndex(0)
  elseif "Weapon" == Type then
    self.WS_State:SetActiveWidgetIndex(1)
  end
  self.Type = Type
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Btn_More)
end

return M
