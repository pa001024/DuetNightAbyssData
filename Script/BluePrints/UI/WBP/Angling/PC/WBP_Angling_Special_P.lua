require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(RootPage, FishingSpotId)
  self.RootPage = RootPage
  self.Btn_Angling.OnClicked:Add(self, self.OnClickAngling)
  if self.RootPage.RootPage.DeviceInPc then
    self.KeyText_E:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "E"}
      }
    })
    self.Key_E_GamePad:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      }
    })
  else
    self.KeyText_E:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Text_Tips:SetText(GText("UI_Fishing_SmallToBigChance"))
  self.FishingSmallToBigDuration = DataMgr.GlobalConstant.FishingSmallToBigDuration.ConstantValue
end

function M:OnCanSpecialFishing(AutoConfirmDelay)
  local bAutoConfirm = nil ~= AutoConfirmDelay
  self.CountTime = AutoConfirmDelay or self.FishingSmallToBigDuration
  self.Text_Time:SetText(self.CountTime)
  self.Panel_Angling:SetVisibility(bAutoConfirm and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Angling:SetVisibility(bAutoConfirm and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.Visible)
  self.WidgetSwitcher_E:SetVisibility(bAutoConfirm and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
  self.bFailed = false
  self:PlayAnimation(self.In)
  if self.RootPage.DeviceInPc then
    self.RootPage.WidgetSwitcher_MP:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:AddTimer(1, self.SpecialFishingCountDown, true, 0, "SpecialFishing", false, bAutoConfirm)
  AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_one_more_start", nil, nil)
end

function M:SpecialFishingCountDown(bAutoConfirm)
  self:PlayAnimation(self.Countdown)
  self.CountTime = self.CountTime - 1
  self.Text_Time:SetText(self.CountTime)
  if self.CountTime <= 0 then
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_one_more_count_down_last", nil, nil)
    if bAutoConfirm then
      self:SwitchWaitFishing()
    else
      self:SwitchWaitStart()
    end
  else
    AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_one_more_count_down", nil, nil)
  end
end

function M:SwitchWaitStart()
  self:RemoveTimer("SpecialFishing")
  self.bFailed = true
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:SwitchWaitFishing()
  self:RemoveTimer("SpecialFishing")
  self.bFailed = false
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:OnClickQuit()
  self:SwitchWaitStart(true)
end

function M:OnClickAngling()
  self:SwitchWaitFishing()
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.RootPage.RootPage.DeviceInPc then
    self.WidgetSwitcher_E:SetActiveWidgetIndex(0)
  elseif CurInputDevice == ECommonInputType.Gamepad and self.RootPage.RootPage.DeviceInPc then
    self.WidgetSwitcher_E:SetActiveWidgetIndex(1)
  elseif CurInputDevice == ECommonInputType.Touch then
  end
end

function M:BP_GetDesiredFocusTarget()
  return self.RootPage
end

return M
