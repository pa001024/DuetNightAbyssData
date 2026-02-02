require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local EMCache = require("EMCache.EMCache")

function M:Construct()
  self.Super.Construct(self)
  self.CanSkip = false
  self.MVPFinishFunction = nil
  self.MVPDamage = 0
  if self.Key_Continue then
    self:InitDeviceInfo()
  elseif self.Btn_Continue then
    self.Btn_Continue:SetText(GText("UI_GACHA_SKIP"))
    self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnClickedButtonContinue)
  end
  local IsSkip = EMCache:Get("SkipMVP")
  if nil == IsSkip then
    local OptionInfo = DataMgr.Option.SkipMVP
    if CommonUtils.GetRuntimePlatform(self) == "Mobile" and OptionInfo and OptionInfo.DefaultValueM then
      IsSkip = OptionInfo.DefaultValueM
    else
      IsSkip = OptionInfo.DefaultValue
    end
    if "False" == IsSkip then
      IsSkip = false
    elseif "True" == IsSkip then
      IsSkip = true
    end
  end
  self.IsSkip = IsSkip
  self.IsClickSkip = false
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:SetFocus()
  self.MVPFinishFunction, self.MVPDamage, self.MVPName, self.MVPTextData = ...
  self.Text_Name:SetText(self.MVPName)
  self.Text_Row01:SetText(GText("UI_STAT_DAMAGE_TITLE") .. ": " .. Utils.FormatNumber(math.floor(self.MVPDamage), true))
  self:SetTextData()
  self:AddTimer(UIConst.MVPSkipShowTime, function()
    if self.IsSkip then
      self:OnFinish()
    else
      self:PlayAnimation(self.In)
      AudioManager(self):PlayUISound(self, "event:/ui/common/level_mvp_in", nil, nil)
      self.CanSkip = true
    end
  end, false, 0)
end

function M:SetTextData()
  local FinalText = ""
  if self.MVPTextData then
    FinalText = GText(self.MVPTextData.Textmap) .. ": " .. self.MVPTextData.Value
  end
  self.Text_Row02:SetText(FinalText)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  end
end

function M:OnFinish()
  self:Close()
  if self.MVPFinishFunction then
    self.MVPFinishFunction()
  end
end

function M:OnSequenceFinish()
  self:PlayAnimation(self.Out)
  if self.MVPFinishFunction then
    self.MVPFinishFunction()
  end
end

function M:OnClickedButtonContinue()
  if self.CanSkip and not self.IsClickSkip then
    self:PlayAnimation(self.Out)
    if self.MVPFinishFunction then
      self.MVPFinishFunction()
    end
    self.IsClickSkip = true
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnPCDown(InKeyName)
  local IsEventHandled = false
  if "SpaceBar" == InKeyName or "Escape" == InKeyName then
    IsEventHandled = true
    self:OnClickedButtonContinue()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    IsEventHandled = true
    self:OnClickedButtonContinue()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("RefreshOpInfoByInputDevice", CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:GamePadToPC()
  else
    self:PCToGamepad()
  end
  self.CurInputDeviceType = CurInputDevice
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:GamePadToPC()
  if not self.Key_Continue then
    return
  end
  self:SetFocus()
  self.Key_Continue:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        ImgShortPath = "SpaceBar",
        ClickCallback = self.OnClickedButtonContinue,
        Owner = self
      }
    },
    Desc = GText("UI_GACHA_SKIP")
  })
end

function M:PCToGamepad()
  if not self.Key_Continue then
    return
  end
  self:SetFocus()
  self.Key_Continue:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    },
    Desc = GText("UI_GACHA_SKIP")
  })
end

return M
