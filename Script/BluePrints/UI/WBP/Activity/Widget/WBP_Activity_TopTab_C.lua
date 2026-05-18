require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", CurGamepadName)
  self.WBP_Com_Tab_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
end

function M:Init(Info)
  self.Info = Info
  self.BackCallback = Info.BackCallback
  self.ParentWidget = Info.OwnerPanel
  self.Title_Tab:SetText(Info.TitleName)
  self.TabBack.Btn_Back.OnClicked:Clear()
  self.TabBack.Btn_Back.OnClicked:Add(self, self.OnReturnClick)
  if Info.OverridenTopResouces then
    self.WBP_Com_Tab_ResourceBar:SetVisibility(UIConst.VisibilityOp.Visible)
    self.WBP_Com_Tab_ResourceBar:InitResourceBar(Info.OverridenTopResouces, false)
  else
    self.WBP_Com_Tab_ResourceBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitVersionInfo()
end

function M:InitVersionInfo()
  self.Btn_RewardPreview.Button_Area.OnClicked:Clear()
  self.Btn_RewardPreview.Button_Area.OnClicked:Add(self, self.OnRewardPreviewClick)
  self.Btn_RewardPreview.Button_Area.OnPressed:Clear()
  self.Btn_RewardPreview.Button_Area.OnPressed:Add(self, self.OnRewardPreviewPressed)
  self.Btn_RewardPreview.Text_Button:SetText(GText("UI_Event_Btn_RewardCollection"))
  self:RefreshLimitRewardPreviewNewReddot()
end

function M:RefreshLimitRewardPreviewNewReddot()
  self.Btn_RewardPreview:RefreshVersionNewReddot()
end

function M:OnRewardPreviewPressed()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_gift_btn_click", nil, nil)
end

function M:OnRewardPreviewClick()
  UIManager(self):LoadUINew("ActivityLimitTimeRewardPreview")
end

function M:OnReturnClick()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
  if type(self.BackCallback) == "function" then
    self.BackCallback(self.ParentWidget)
  end
end

function M:Handle_KeyEventOnPC(InKeyName)
  local IsEventHandled = true
  if InKeyName == UE4.EKeys.Escape.KeyName then
    self:OnReturnClick()
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    self:OnReturnClick()
    IsEventHandled = true
  end
  return IsEventHandled
end

return M
