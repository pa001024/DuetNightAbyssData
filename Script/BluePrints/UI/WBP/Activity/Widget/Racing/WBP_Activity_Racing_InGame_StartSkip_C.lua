require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

function M:Construct()
  M.Super.Construct(self)
  self.HoldToCloseDuration = 1
  self:InitLongPressEvent()
end

function M:OnLoaded(...)
  self.RaceId = (...)
  self:SetFocus()
  self:PlayAnimation(self.In)
  if not UIUtils.IsMobileInput() then
    self.WS_Skip:SetActiveWidgetIndex(0)
    self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if IsValid(self.GameInputModeSubsystem) then
      self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
  else
    self.WS_Skip:SetActiveWidgetIndex(1)
    self.Button_Skip:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Skip.Text_Function:SetText(GText("UI_TALK_SKIP_MOIILE"))
    self.Button_Skip.Button_Area.OnClicked:Add(self, self.OnCloseBtnClicked)
    self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadView()
  elseif CurInputType == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
        }
      },
      bLongPress = true,
      Desc = GText("UI_TALK_SKIP")
    }
  })
end

function M:InitKeyboardView()
  if UIUtils.IsMobileInput() then
    return
  end
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {Type = "Text", Text = "SpaceBar"}
      },
      bLongPress = true,
      Desc = GText("UI_TALK_SKIP")
    }
  })
end

function M:OnCloseBtnClicked()
  self:CloseSelf()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Spline = GameState.PetRaceSplineMaps:FindRef(self.RaceId)
  Spline:GoToEndSequence()
end

function M:CloseSelf()
  self:PlayAnimation(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Unhandled, false
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  self.bMobileHoldToClose = true
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  self.bMobileHoldToClose = false
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitLongPressEvent()
  self:AddLongPressEvent("SpaceBar", self.HoldToCloseDuration, self.OnSpaceBar_LongPressStart, self.OnSpaceBar_LongPressCancel, self.OnSpaceBar_LongPressEnd)
  self:AddLongPressEvent(UIConst.GamePadKey.FaceButtonBottom, self.HoldToCloseDuration, self.OnGamepad_FaceButton_Bottom_LongPressStart, self.OnGamepad_FaceButton_Bottom_LongPressCancel, self.OnGamepad_FaceButton_Bottom_LongPressEnd)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:OnSpaceBar_LongPressStart()
  local SpaceBarBtn = self.Com_KeyTips:GetComKeyById(1)
  if SpaceBarBtn then
    SpaceBarBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime("SpaceBar"))
  end
end

function M:OnSpaceBar_LongPressCancel()
  local SpaceBarBtn = self.Com_KeyTips:GetComKeyById(1)
  if SpaceBarBtn then
    SpaceBarBtn:OnButtonReleased()
    SpaceBarBtn:StopAllAnimations()
    SpaceBarBtn:PlayAnimation(SpaceBarBtn.Normal)
  end
end

function M:OnSpaceBar_LongPressEnd()
  self:OnCloseBtnClicked()
end

function M:OnGamepad_FaceButton_Bottom_LongPressStart()
  local FaceButtonBottomBtn = self.Com_KeyTips:GetComKeyById(1)
  if FaceButtonBottomBtn then
    FaceButtonBottomBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime(UIConst.GamePadKey.FaceButtonBottom))
  end
end

function M:OnGamepad_FaceButton_Bottom_LongPressCancel()
  local FaceButtonBottomBtn = self.Com_KeyTips:GetComKeyById(1)
  if FaceButtonBottomBtn then
    FaceButtonBottomBtn:OnButtonReleased()
    FaceButtonBottomBtn:StopAllAnimations()
    FaceButtonBottomBtn:PlayAnimation(FaceButtonBottomBtn.Normal)
  end
end

function M:OnGamepad_FaceButton_Bottom_LongPressEnd()
  self:OnCloseBtnClicked()
end

AssembleComponents(M)
return M
