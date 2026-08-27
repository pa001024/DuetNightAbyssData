require("UnLua")
local M = Class("BluePrints.UI.WBP.Armory.WBP_Armory_Mastery_Base_C")

function M:Construct()
  M.Super.Construct(self)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  self.Btn_Qa.Tips_MenuAnchor:SetUseApplicationMenuStack(not self.IsGamepadInput)
  if self.IsGamepadInput then
    if not self.IsGamepadKeyCreated then
      self.IsGamepadKeyCreated = true
      self.Key_Tip:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "RS"}
        }
      })
    end
    self.Key_Tip:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Key_Tip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local Widget = self:GetDesiredFocusTarget()
  if Widget and Widget ~= self then
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), Widget)
  end
  return UIUtils.Handled
end

function M:GetDesiredFocusTarget()
  if self.OwnMasteryWeaponTags and #self.OwnMasteryWeaponTags > 0 then
    return self.MasteryBtns[#self.OwnMasteryWeaponTags + 1]
  end
end

return M
