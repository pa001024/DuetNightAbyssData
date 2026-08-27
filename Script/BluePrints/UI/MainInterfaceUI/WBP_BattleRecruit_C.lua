require("UnLua")
local WBP_BattleRecruit_C = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")

function WBP_BattleRecruit_C:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  self.Btn_Click.OnHovered:Add(self, self.OnBtnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self:InitListenEvent()
  self:OnBtnUnhovered()
  if self.Common_Key_Hud_Gamepad then
    self.Common_Key_Hud_Gamepad:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      }
    })
  end
end

function WBP_BattleRecruit_C:InitListenEvent()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function WBP_BattleRecruit_C:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function WBP_BattleRecruit_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  local IsUseGamePad = CurInputDevice == ECommonInputType.Gamepad
  self:InitWidgetInfoInGamePad(IsUseGamePad)
end

function WBP_BattleRecruit_C:InitWidgetInfoInGamePad(IsUseGamePad)
  if self.Key_GamePad then
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if not IsUseGamePad then
    return
  end
end

function WBP_BattleRecruit_C:OnBtnClick()
  UIManager(self):LoadUINew("TeamHall")
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_system_entrance", nil, nil)
end

function WBP_BattleRecruit_C:OnBtnHovered()
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  if "Mobile" == Platform then
    self.Switcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self:StopAnimation(self.HoverOut)
  self:PlayAnimation(self.Hover)
end

function WBP_BattleRecruit_C:OnBtnUnhovered()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.HoverOut)
end

function WBP_BattleRecruit_C:ShowSystemEntranceOnGamePadInput(IsShow)
  if not self.Common_Key_Hud_Gamepad then
    return
  end
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  if IsShow then
    self.Switcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Switcher:SetActiveWidgetIndex(1)
    self.Common_Key_Hud_Gamepad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Switcher:SetActiveWidgetIndex(0)
    self.Common_Key_Hud_Gamepad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_BattleRecruit_C:Destruct()
  TeamHallController:UnRegisterEvent(self)
end

AssembleComponents(WBP_BattleRecruit_C)
return WBP_BattleRecruit_C
