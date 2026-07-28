require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.PersonInfo.Edit.PersonInfo_CustomEditChoosePageBase"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Edit.WBP_PersonalInfo_EditChoose_P_GamepadComp"
}

function M:Construct()
  self.GameInputModeSubsystem = nil
  self.CurInputDeviceType = nil
  self.CurGamepadName = nil
  self:_InitSwitchModeKeyInfo()
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  self.GameInputModeSubsystem = nil
  self.CurInputDeviceType = nil
  self.CurGamepadName = nil
end

function M:InitChoosePage(EditRootController, ChooseMode, Params)
  self.Super.InitChoosePage(self, EditRootController, ChooseMode, Params)
  self:AddInputMethodChangedListen()
end

function M:AddInputMethodChangedListen()
  local GameInputModeSubsystem = self:_GetGameInputModeSubsystem()
  if not GameInputModeSubsystem then
    return
  end
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
  GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:RemoveInputMethodChangedListen()
  local GameInputModeSubsystem = self:_GetGameInputModeSubsystem()
  if not GameInputModeSubsystem then
    return
  end
  GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  if CurInputType == ECommonInputType.Touch then
    return
  end
  self:FreshSubKeyInfo(CurInputType == ECommonInputType.Gamepad)
  if self.RefreshChoosePageGamepadState then
    self:RefreshChoosePageGamepadState()
  end
end

function M:FreshSubKeyInfo(bIsGamePad)
  local Index = bIsGamePad and 1 or 0
  self.Switch_Mode_R:SetActiveWidgetIndex(Index)
  self.Switch_Mode_L:SetActiveWidgetIndex(Index)
  if bIsGamePad then
    local LeftIcon = self.ChooseMode == "Weapon" and "LT" or "LB"
    local RightIcon = self.ChooseMode == "Weapon" and "RT" or "RB"
    self.Key_Controller_L:SetImage("Img", LeftIcon)
    self.Key_Controller_R:SetImage("Img", RightIcon)
  else
    self.Key_Controller_L:SetImage("Img", "LB")
    self.Key_Controller_R:SetImage("Img", "RB")
  end
end

function M:_InitSwitchModeKeyInfo()
  self.Key_L:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "A"}
    }
  })
  self.Key_R:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "D"}
    }
  })
  self.Key_Controller_L:SetImage("Img", "LB")
  self.Key_Controller_R:SetImage("Img", "RB")
  self.Key_L:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Key_R:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Key_Controller_L:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Key_Controller_R:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:_GetGameInputModeSubsystem()
  if IsValid(self.GameInputModeSubsystem) then
    return self.GameInputModeSubsystem
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  if not PlayerController then
    return nil
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  return self.GameInputModeSubsystem
end

AssembleComponents(M)
return M
