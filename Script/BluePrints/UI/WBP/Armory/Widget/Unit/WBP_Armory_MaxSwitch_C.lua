require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SwitchType = {Avatar = "Avatar", Attribute = "Attribute"}

function M:Construct()
  self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  rawset(self, "GameInputModeSubsystem", UGameInputModeSubsystem.GetGameInputModeSubsystem(self))
  if rawget(self, "GameInputModeSubsystem") then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "IsGamepadInput", CurInputDevice == ECommonInputType.Gamepad)
  if self.IsGamepadInput then
    self.Key_Switch:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.Key_Switch:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Init(Params)
  self.OnBtnClicked = Params.OnBtnClicked
  self.SwitchType = Params.SwitchType or SwitchType.Avatar
  if self.SwitchType == SwitchType.Attribute then
    self:InitSwitchAttribute(Params)
  else
    self:InitSwitchAvatar(Params)
  end
end

function M:InitSwitchAvatar(Params)
  local Avatars = Params and Params.Avatars
  if Avatars then
    rawset(self, "bSingleTarget", true)
    rawset(self, "AvatarPrime", Avatars[1])
    rawset(self, "AvatarMax", Avatars[2])
    local CurrentAvatar = rawget(self, "CurrentAvatar")
    if CurrentAvatar ~= Avatars[1] and CurrentAvatar ~= Avatars[2] then
      rawset(self, "CurrentAvatar", Params.CurrentAvatar or Avatars[1])
    end
  else
    rawset(self, "bSingleTarget", false)
    rawset(self, "AvatarPrime", ArmoryUtils:GetDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime))
    rawset(self, "AvatarMax", ArmoryUtils:GetDummyAvatar(ArmoryUtils.PreviewTargetStates.Max))
    rawset(self, "CurrentAvatar", ArmoryUtils:GetDummyAvatar(ArmoryUtils:GetPreviewTargetState()) or self.AvatarPrime)
  end
  self:UpdateText()
  self.Key_Switch:CreateCommonKey(Params.KeyInfo)
end

function M:UpdateText()
  if self.CurrentAvatar == self.AvatarPrime then
    self.Text_MaxSwitch:SetText(GText("UI_Preview_SwitchtoMax"))
  else
    self.Text_MaxSwitch:SetText(GText("UI_Preview_SwitchtoInit"))
  end
end

function M:BindEventOnClicked(Obj, Event)
  rawset(self, "Obj", Obj)
  rawset(self, "Event", Event)
end

function M:OnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  if self.OnBtnClicked then
    self.OnBtnClicked()
    return
  end
  if self.CurrentAvatar == self.AvatarPrime then
    self.CurrentAvatar = self.AvatarMax
  else
    self.CurrentAvatar = self.AvatarPrime
  end
  self:UpdateText()
  if self.bSingleTarget then
    EventManager:FireEvent(EventID.OnArmoryTargetStateChanged, self.CurrentAvatar)
  elseif self.CurrentAvatar == self.AvatarPrime then
    ArmoryUtils:SwitchPreviewTargetState(ArmoryUtils.PreviewTargetStates.Prime)
  else
    ArmoryUtils:SwitchPreviewTargetState(ArmoryUtils.PreviewTargetStates.Max)
  end
end

function M:GetCurrentAvatar()
  return self.CurrentAvatar
end

function M:InitSwitchAttribute(Params)
  self.Text_MaxSwitch:SetText(GText("UI_Switch_Attribute"))
  self.Key_Switch:CreateCommonKey(Params.KeyInfo)
end

function M:SetReddot(RedDotType)
  if RedDotType == UIConst.RedDotType.CommonRedDot then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if RedDotType == UIConst.RedDotType.NewRedDot then
      self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

return M
