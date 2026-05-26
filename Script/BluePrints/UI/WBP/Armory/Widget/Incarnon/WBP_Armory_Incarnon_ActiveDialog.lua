require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  self.Parent = Params.RightCallbackObj
  self.WeaponId = Params.WeaponId
  self.CardLevel = Params.CardLevel
  self.TargetTalentId = Params.TargetTalentId
  local Talents = HyperWeaponUtils.GetTalents(self.WeaponId, self.CardLevel)
  self.LeftWidgetItem = self.Incarnon_ActiveItem
  self.RightWidgetItem = self.Incarnon_ActiveItem_1
  if self.TargetTalentId == Talents[1] then
    self.FocusWidget = self.LeftWidgetItem
  else
    self.FocusWidget = self.RightWidgetItem
  end
  self:InitGamepadKeys()
  self:ShowGamepadCloseBtn(false)
  self.LeftWidgetItem:InitContent({
    Parent = self,
    TalentId = Talents[1],
    CallbackObj = self,
    Callback = self.OnSubWidgetClicked
  })
  self.RightWidgetItem:InitContent({
    Parent = self,
    TalentId = Talents[2],
    CallbackObj = self,
    Callback = self.OnSubWidgetClicked
  })
  self.FocusWidget:OnButtonClicked()
  self.FocusWidget:SetFocus()
end

function M:OnSubWidgetClicked(SubWidget, TalentId)
  self:RefreshTitleText(TalentId)
  if self.LastClickItem then
    self.LastClickItem:PlayNormalAnimation()
  end
  self.LastClickItem = SubWidget
  self.Parent.TargetTalentId = TalentId
end

function M:RefreshTitleText(TalentId)
  local TalentName = HyperWeaponUtils.GetTalentName(TalentId)
  local Text = string.format(GText("UI_HyperWeapon_ResourceFreePopUpText"), TalentName)
  self.Text_Active:SetText(Text)
end

function M:InitGamepadKeys()
  self.GamepadSwitchItemKeyInfo = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LH"}
    },
    Desc = GText("UI_Controller_Switch")
  })
  self.GamepadBackKeyInfo = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
      }
    },
    Desc = GText("UI_BACK")
  })
  self.GamepadCheckDetailsKeyInfo = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    },
    Desc = GText("UI_Controller_CheckDetails")
  })
  self:HideAllGamepadShortcut()
end

function M:InitGamepadView()
end

function M:InitKeyboardView()
  self:HideAllGamepadShortcut()
end

function M:OnEnterState_Normal()
  self:HideGamepadShortcut(self.GamepadBackKeyInfo)
  self:HideGamepadShortcut(self.GamepadCheckDetailsKeyInfo)
  self:ShowGamepadShortcut(self.GamepadSwitchItemKeyInfo)
  self:SetGamepadBtnKeyVisibility(true)
end

function M:OnEnterState_CheckItem()
  self:HideGamepadShortcut(self.GamepadSwitchItemKeyInfo)
  self:ShowGamepadShortcut(self.GamepadBackKeyInfo)
  self:ShowGamepadShortcut(self.GamepadCheckDetailsKeyInfo)
  self:SetGamepadBtnKeyVisibility(false)
end

function M:OnEnterState_ShowTip()
  self:HideAllGamepadShortcut()
end

function M:OnSubWidgetFocus(SubWidget)
  self.FocusWidget = SubWidget
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if self.FocusWidget then
    IsEventHandled = self.FocusWidget:OnContentKeyDown(MyGeometry, InKeyEvent)
  end
  return IsEventHandled
end

return M
