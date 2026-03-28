local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Title = self.Text_Title
  self.Time = self.Activity_Time.Com_Time
  self.DescSwitcher = self.WS_TextDesc
  self.BlackDesc = self.Text_ActivityDesc
  self.WhiteDesc = self.Text_ActivityDesc_White
  self.bTimeOut = false
  self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  self:ListenInputTypeChanged()
end

function M:Destruct()
  self:UnlistenInputTypeChanged()
end

function M:ListenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
  end
end

function M:UnlistenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
  end
end

function M:SetInputType(NewInputType, NewGamepadName)
  if NewInputType == ECommonInputType.Touch then
    return
  end
  if NewInputType == ECommonInputType.Gamepad then
    self:UpdateUIStyleInPlatform(true)
  else
    self:UpdateUIStyleInPlatform(false)
  end
end

function M:SetTitle(Text)
  self.Title:SetText(Text)
end

function M:SetTime(Time)
  local TimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(Time)
  self.bTimeOut = 0 == TimeCount and Time
  if Time then
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    ActivityUtils.SetLeftTimeView(self.Time, false, self.bTimeOut, TimeDict, self.bTimeOut)
  else
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetDesc(Text, bBlack)
  bBlack = bBlack or false
  if bBlack then
    self.DescSwitcher:SetActiveWidgetIndex(0)
    self.BlackDesc:SetText(Text)
  else
    self.DescSwitcher:SetActiveWidgetIndex(1)
    self.WhiteDesc:SetText(Text)
  end
end

function M:IsTimeOut()
  return self.bTimeOut
end

function M:SetTips(EventRule, InfoClickFunction, InfoClickObj)
  if EventRule then
    self.Text_ActivityDescTitle:SetText(GText("UI_Common_Rule"))
    self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp.VisibilityOp)
    self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp.VisibilityOp)
  else
    self.Com_BtnExplanation:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Group_ActivityQa:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local BtnExplanationConfigData = {}
  BtnExplanationConfigData.ClickCallback = InfoClickFunction
  BtnExplanationConfigData.OwnerWidget = InfoClickObj
  BtnExplanationConfigData.Desc = "UI_Common_Rule"
  
  function BtnExplanationConfigData.SoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  end
  
  self.Com_BtnExplanation:Init(BtnExplanationConfigData)
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
  self.Com_BtnExplanation:UpdateUIStyleInPlatform(IsUseGamePad)
end

function M:SetGamePadImg(ImgShortPath, ImgLongPath)
  self.Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = ImgShortPath,
        ImgLongPath = ImgLongPath
      }
    }
  })
end

return M
