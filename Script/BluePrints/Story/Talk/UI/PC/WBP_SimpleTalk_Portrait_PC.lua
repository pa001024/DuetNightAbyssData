local MiscUtils = require("Utils.MiscUtils")
local EImpressionButtonState = require("BluePrints.UI.UI_PC.Impression.ImpressionConst").EImpressionButtonState
local Scroll_Mouse = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PC/T_Key_MouseScroll.T_Key_MouseScroll")
local Scroll_Xbox = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_LV.T_Key_LV")
local Scroll_PS = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_LV.T_Key_LV")
local ImpressionItemUIPath = "/Game/UI/WBP/Impression/PC/WBP_Impression_Item_P.WBP_Impression_Item_P"
require("UnLua")
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local WBP_SimpleTalk_PC = Class("BluePrints.Story.Talk.UI.Common.WBP_SimpleTalk_Portrait_Base")
WBP_SimpleTalk_PC._components = {
  "BluePrints.UI.UI_PC.Common.LSFocusComp"
}

function WBP_SimpleTalk_PC:InitImpressionUI()
  WBP_SimpleTalk_PC.Super.InitImpressionUI(self)
  self:RefreshBaseInfo()
end

function WBP_SimpleTalk_PC:GetImpressionItemUIPath()
  return ImpressionItemUIPath
end

function WBP_SimpleTalk_PC:InitOptions(OptionData, TalkTriggerId, ImpressionAreaId)
  WBP_SimpleTalk_PC.Super.InitOptions(self, OptionData, TalkTriggerId, ImpressionAreaId)
  self:RefreshBaseInfo()
end

function WBP_SimpleTalk_PC:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.SelectImpressionItemIndex then
    return UIUtils.Unhandled
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftX" == InKeyName then
    self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  elseif "Gamepad_LeftY" == InKeyName then
    self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  end
  local InKeyName
  if self.MoveDeltaY and 0 ~= self.MoveDeltaY then
    if self.MoveDeltaY > 0.5 then
      InKeyName = "Gamepad_LeftStick_Up"
    elseif self.MoveDeltaY < -0.5 then
      InKeyName = "Gamepad_LeftStick_Down"
    end
  end
  if "Gamepad_LeftStick_Up" == InKeyName then
    if self.CdTimer then
      return UIUtils.Unhandled
    else
      self:CreateCDTimer()
    end
    self:OnUpSelectItem()
  elseif "Gamepad_LeftStick_Down" == InKeyName then
    if self.CdTimer then
      return UIUtils.Unhandled
    else
      self:CreateCDTimer()
    end
    self:OnDownSelectItem()
  end
  return UIUtils.Handled
end

function WBP_SimpleTalk_PC:CreateCDTimer()
  self.CdTimer = self:AddTimer(0.2, function()
    self.CdTimer = nil
  end, nil, nil, nil, true)
end

function WBP_SimpleTalk_PC:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if not self.SelectImpressionItemIndex then
    return UIUtils.Unhandled
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local Handled = true
  if "Gamepad_DPad_Up" == InKeyName then
    self:OnUpSelectItem()
  elseif "Gamepad_DPad_Down" == InKeyName then
    self:OnDownSelectItem()
  end
  return UIUtils.Unhandled
end

function WBP_SimpleTalk_PC:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self:IsTipsOpen() and InKey.KeyName == "Gamepad_FaceButton_Right" then
    self:SetFocus()
    return UIUtils.Handled
  end
  return WBP_SimpleTalk_PC.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function WBP_SimpleTalk_PC:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  IsHandled = self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
  if IsHandled then
    return UIUtils.Handled
  end
  return WBP_SimpleTalk_PC.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
end

function WBP_SimpleTalk_PC:OnReviewButtonClicked()
  if self:IsTipsOpen() then
    return
  end
  WBP_SimpleTalk_PC.Super.OnReviewButtonClicked(self)
end

function WBP_SimpleTalk_PC:OnWikiButtonClicked()
  if self:IsTipsOpen() then
    return
  end
  WBP_SimpleTalk_PC.Super.OnWikiButtonClicked(self)
end

function WBP_SimpleTalk_PC:IsTipsOpen()
  return self.OptionComp:IsTipsOpen()
end

function WBP_SimpleTalk_PC:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("WBP_SimpleTalk_PC:RefreshOpInfoByInputDevice", CurInputDevice, CurGamepadName)
  local IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  self.IsGamePad = IsGamePad
  if IsGamePad and (not self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    self:SetFocus()
  end
  self.OptionComp:Event_UpdateKeyImg(IsGamePad, CurGamepadName)
  self.WBP_Story_PlayKey_P:UpdateKeyImg(IsGamePad)
end

function WBP_SimpleTalk_PC:ClearOptions()
  WBP_SimpleTalk_PC.Super.ClearOptions(self)
  self:RefreshBaseInfo()
end

function WBP_SimpleTalk_PC:AdaptPlatform()
  self.OptionComp:Event_AdaptPlatform(false)
  self.DimensionComp:Event_AdaptPlatform(false)
end

function WBP_SimpleTalk_PC:InitPlayKey()
  self.WBP_Story_PlayKey_P:Init(self.IsGamePad)
end

function WBP_SimpleTalk_PC:InitAutoPlay()
end

function WBP_SimpleTalk_PC:PreExitTalkTask(TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
  WBP_SimpleTalk_PC.Super.PreExitTalkTask(self, TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
  self.WBP_Story_PlayKey_P:StopAllAnimations()
  self:RemoveFocusTarget("Menu")
end

AssembleComponents(WBP_SimpleTalk_PC)
return WBP_SimpleTalk_PC
