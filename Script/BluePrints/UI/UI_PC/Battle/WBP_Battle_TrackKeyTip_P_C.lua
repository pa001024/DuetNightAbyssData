require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SWITCH_ACTION = {
  Left = "ChangeSlideMechLeft",
  Right = "ChangeSlideMechRight"
}
local DEFAULT_KEY = {Left = "A", Right = "D"}
local GAMEPAD_ICON = {
  Left = UIConst.GamePadImgKey.LeftTriggerThreshold,
  Right = UIConst.GamePadImgKey.RightTriggerThreshold
}
local KEY_IMG_FIX_PATH = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Instruction/T_Key_%s_L.T_Key_%s_L'"

function M:Construct()
  self:SetVisibility(ESlateVisibility.Collapsed)
  self.ShowingLeft = false
  self.ShowingRight = false
  self.HidingLeft = false
  self.HidingRight = false
  if IsValid(self.Key_L) then
    self.Key_L:BindToAnimationFinished(self.Key_L.Out, {
      self,
      self.OnLeftOutFinished
    })
  end
  if IsValid(self.Key_R) then
    self.Key_R:BindToAnimationFinished(self.Key_R.Out, {
      self,
      self.OnRightOutFinished
    })
  end
  if not IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
  EventManager:AddEvent(EventID.OnChangeKeyBoardSet, self, self.OnKeyBoardSetChanged)
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
  EventManager:RemoveEvent(EventID.OnChangeKeyBoardSet, self)
end

function M:SetPromptVisible(bVisible, bShowLeft, bShowRight, bIsPlayAudio)
  if not bVisible then
    self.ShowingLeft = false
    self.ShowingRight = false
    self:BeginHideKey("Left")
    self:BeginHideKey("Right")
    if not self.HidingLeft and not self.HidingRight then
      self:SetVisibility(ESlateVisibility.Collapsed)
    end
    local AudioMgr = AudioManager(self)
    AudioMgr:StopSound(self, "QTEShow")
    if bIsPlayAudio then
      AudioMgr:PlayUISound(self, "event:/ui/common/qte_press", "", nil)
      AudioMgr:PlayUISound(self, "event:/ui/common/qte_success", "", nil)
    end
    return
  end
  self.HidingLeft = false
  self.HidingRight = false
  self.ShowingLeft = true == bShowLeft
  self.ShowingRight = true == bShowRight
  self:ApplyKeyState("Left", self.ShowingLeft)
  self:ApplyKeyState("Right", self.ShowingRight)
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if self.ShowingLeft or self.ShowingRight then
    AudioManager(self):PlayUISound(self, "event:/ui/common/qte_show", "QTEShow", nil)
  end
end

function M:ApplyKeyState(Direction, bShow)
  local KeyWidget = "Left" == Direction and self.Key_L or self.Key_R
  if not IsValid(KeyWidget) then
    return
  end
  if not bShow then
    KeyWidget:StopAnimation(KeyWidget.In)
    KeyWidget:StopAnimation(KeyWidget.Loop)
    KeyWidget:StopAnimation(KeyWidget.Out)
    KeyWidget:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  KeyWidget:StopAnimation(KeyWidget.Out)
  KeyWidget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:RefreshKeyView(Direction)
  KeyWidget:PlayAnimation(KeyWidget.In)
  KeyWidget:PlayAnimation(KeyWidget.Loop, 0, 0)
end

function M:BeginHideKey(Direction)
  local KeyWidget = "Left" == Direction and self.Key_L or self.Key_R
  if not IsValid(KeyWidget) or KeyWidget:GetVisibility() == ESlateVisibility.Collapsed then
    return
  end
  if "Left" == Direction then
    self.HidingLeft = true
  else
    self.HidingRight = true
  end
  KeyWidget:StopAnimation(KeyWidget.In)
  KeyWidget:StopAnimation(KeyWidget.Loop)
  KeyWidget:PlayAnimation(KeyWidget.Out)
end

function M:RefreshKeyView(Direction)
  local KeyWidget = "Left" == Direction and self.Key_L or self.Key_R
  if not IsValid(KeyWidget) then
    return
  end
  KeyWidget.Main:SetRenderOpacity(1)
  KeyWidget.Text_Describe:SetText("")
  KeyWidget.Key_Plus:SetVisibility(ESlateVisibility.Collapsed)
  KeyWidget.Key02_Img:SetVisibility(ESlateVisibility.Collapsed)
  if UIUtils.IsGamepadInput() then
    KeyWidget.Switch_Type:SetActiveWidgetIndex(1)
    KeyWidget.Key_Img:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = GAMEPAD_ICON[Direction],
          bLargeSize = true
        }
      }
    })
    return
  else
    local KeyName = CommonUtils:GetActionMappingKeyName(SWITCH_ACTION[Direction])
    if not KeyName or "" == KeyName then
      KeyName = DEFAULT_KEY[Direction]
    end
    KeyWidget.Switch_Type:SetActiveWidgetIndex(1)
    KeyWidget.Key_Img:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          ImgShortPath = KeyName,
          bLargeSize = true
        }
      }
    })
  end
end

function M:OnLeftOutFinished()
  if not self.HidingLeft then
    return
  end
  self.HidingLeft = false
  if IsValid(self.Key_L) then
    self.Key_L:SetVisibility(ESlateVisibility.Collapsed)
  end
  if not self.HidingLeft and not self.HidingRight then
    self:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnRightOutFinished()
  if not self.HidingRight then
    return
  end
  self.HidingRight = false
  if IsValid(self.Key_R) then
    self.Key_R:SetVisibility(ESlateVisibility.Collapsed)
  end
  if not self.HidingLeft and not self.HidingRight then
    self:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnInputMethodChanged(CurInputType, CurGamepadName)
  if self.ShowingLeft then
    self:RefreshKeyView("Left")
  end
  if self.ShowingRight then
    self:RefreshKeyView("Right")
  end
end

function M:OnKeyBoardSetChanged()
  if self.ShowingLeft then
    self:RefreshKeyView("Left")
  end
  if self.ShowingRight then
    self:RefreshKeyView("Right")
  end
end

return M
