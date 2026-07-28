require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.WBP_Common_Dialog_Button_PC_C")
local TimerName = "CommonDialogButtonCountDown"

function M:InitContent(Params, PopupData, Owner)
  self.Owner = Owner
  self:InitButtonStyle(Params, PopupData, Owner)
  self:InitInputSettings()
end

function M:InitButtonStyle(Params, PopupData, Owner)
  self.HideBtnQuitIcon = nil
  self.HideBtnYesIcon = nil
  self.CountDownOwner = Owner
  self.CountDownCallbackObj = Params and Params.CountDownCallbackObj
  self.CountDownCallbackFunction = Params and Params.CountDownCallbackFunction
  self:StopCountDown()
  self:BindOnLeftClickFunc(Owner, Owner.OnLeftBtnClicked, Owner.OnForbiddenLeftBtnClicked)
  self:BindOnRightClickFunc(Owner, Owner.OnRightBtnClicked, Owner.OnForbiddenRightBtnClicked)
  local PopupStyle = DataMgr.CommonPopupUIStyle[PopupData.Style]
  local LeftPanel = self.Panel_Quit or self.SizeBox_Quit
  self.CountDownBaseYesText = self:GetYesButtonText(Params, PopupData)
  if self.Btn_Yes then
    self.Btn_Yes:SetBtnHovered(false)
    
    function self.Btn_Yes.SoundFunc()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    end
  end
  if self.Btn_Quit then
    self.Btn_Quit:SetBtnHovered(false)
    
    function self.Btn_Quit.SoundFunc()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
    end
  end
  if PopupStyle.ShowLeftButton then
    if self.Btn_Quit then
      self.Btn_Quit:SetText(self:GetNoButtonText(Params, PopupData))
      self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Visible)
      self.Btn_Quit:ForbidBtn(self:ShouldForbidLeftButton(Params, PopupStyle))
      if Params and Params.LeftGamepadImg then
        self.Btn_Quit:SetDefaultGamePadImg(Params.LeftGamepadImg)
      end
      if PopupData.NoButtonIconPath then
        self.Btn_Quit:SetNewIcon(PopupData.NoButtonIconPath)
      end
      if PopupData.NoButtonRGBA then
        self.Btn_Quit:SetIconColor(PopupData.NoButtonRGBA)
      end
      if Params and Params.NoButtonPCKey then
        self.HideBtnQuitIcon = true
        self.Btn_Quit:SetPCImg(Params.NoButtonPCKey)
        self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
      end
    end
    self:SetWidgetVisible(LeftPanel, true)
  else
    self:SetWidgetVisible(LeftPanel, false)
  end
  if PopupStyle.ShowRightButton then
    if self.Btn_Yes then
      self.Btn_Yes:SetText(self.CountDownBaseYesText)
      self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Visible)
      self.Btn_Yes:ForbidBtn(self:ShouldForbidRightButton(Params, PopupStyle))
      if Params and Params.RightGamepadImg then
        self.Btn_Yes:SetDefaultGamePadImg(Params.RightGamepadImg)
      end
      if PopupData.YesButtonIconPath then
        self.Btn_Yes:SetNewIcon(PopupData.YesButtonIconPath)
      end
      if PopupData.YesButtonRGBA then
        self.Btn_Yes:SetIconColor(PopupData.YesButtonRGBA)
      end
      if Params and Params.YesButtonPCKey then
        self.HideBtnYesIcon = true
        self.Btn_Yes:SetPCImg(Params.YesButtonPCKey)
        self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
      end
    end
    self:SetWidgetVisible(self.Panel_Yes, true)
  else
    self:SetWidgetVisible(self.Panel_Yes, false)
  end
  local CountDownSeconds = Params and tonumber(Params.CountDownSeconds)
  if CountDownSeconds and CountDownSeconds > 0 then
    self:StartCountDown(math.ceil(CountDownSeconds))
  else
    self:SetCountDownBarVisible(false)
  end
end

function M:GetNoButtonText(Params, PopupData)
  local Text
  if PopupData then
    Text = PopupData.NoButtonText
  end
  if Params and Params.NoButtonText then
    Text = Params.NoButtonText
  end
  return tostring(GText(Text or "UI_PATCH_CANCEL"))
end

function M:GetYesButtonText(Params, PopupData)
  local Text
  if PopupData then
    Text = PopupData.YesButtonText
  end
  if Params and Params.YesButtonText then
    Text = Params.YesButtonText
  end
  return tostring(GText(Text or "UI_PATCH_ENSURE"))
end

function M:ShouldForbidLeftButton(Params, PopupStyle)
  if Params and Params.ForbidLeftBtn then
    return true
  end
  return 2 == PopupStyle.ShowLeftButton
end

function M:ShouldForbidRightButton(Params, PopupStyle)
  if Params and Params.ForbidRightBtn then
    return true
  end
  return 2 == PopupStyle.ShowRightButton
end

function M:SetWidgetVisible(Widget, IsVisible)
  if not Widget then
    return
  end
  if IsVisible then
    Widget:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    Widget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:StartCountDown(CountDownSeconds)
  self.CountDownTotalSeconds = math.max(CountDownSeconds or 0, 0)
  self.CountDownRemainSeconds = self.CountDownTotalSeconds
  self.CountDownFinished = false
  self.CountDownEndTime = nil
  if self.CountDownTotalSeconds <= 0 then
    self:SetCountDownBarVisible(false)
    return
  end
  self.CountDownEndTime = TimeUtils.NowTime() + self.CountDownTotalSeconds
  self:SetCountDownBarVisible(true)
  self:RefreshCountDownView()
  self:AddTimer(0.1, self.TickCountDown, true, 0, TimerName, true)
end

function M:StopCountDown()
  if self:IsExistTimer(TimerName) then
    self:RemoveTimer(TimerName)
  end
  self.CountDownEndTime = nil
end

function M:TickCountDown()
  if self.CountDownFinished then
    return
  end
  if self.CountDownEndTime then
    self.CountDownRemainSeconds = math.max(self.CountDownEndTime - TimeUtils.NowTime(), 0)
  else
    self.CountDownRemainSeconds = math.max((self.CountDownRemainSeconds or 0) - 0.1, 0)
  end
  self:RefreshCountDownView()
  if self.CountDownRemainSeconds <= 0 then
    self:OnCountDownFinished()
  end
end

function M:RefreshCountDownView()
  local RemainSeconds = math.max(self.CountDownRemainSeconds or 0, 0)
  local TotalSeconds = math.max(self.CountDownTotalSeconds or 0, 1)
  if self.Btn_Yes then
    self.Btn_Yes:SetText(string.format("%s(%ds)", self.CountDownBaseYesText or "", math.ceil(RemainSeconds)))
  end
  if self.Bar_CountDown then
    self.Bar_CountDown:SetPercent(RemainSeconds / TotalSeconds)
  end
end

function M:SetCountDownBarVisible(IsVisible)
  if not self.Bar_CountDown then
    return
  end
  if IsVisible then
    self.Bar_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Bar_CountDown:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnCountDownFinished()
  if self.CountDownFinished then
    return
  end
  self.CountDownFinished = true
  self:StopCountDown()
  if self.CountDownCallbackFunction then
    local Data
    if self.CountDownOwner and self.CountDownOwner.PackageResult then
      Data = self.CountDownOwner:PackageResult()
    end
    self.CountDownCallbackFunction(self.CountDownCallbackObj, Data, self.CountDownOwner)
    return
  end
  self:SimulateLeftBtnClick()
end

function M:SimulateLeftBtnClick()
  self:StopCountDown()
  M.Super.SimulateLeftBtnClick(self)
end

function M:SimulateRightBtnClick()
  self:StopCountDown()
  M.Super.SimulateRightBtnClick(self)
end

function M:OnDestroyed()
  self:StopCountDown()
  if M.Super.OnDestroyed then
    M.Super.OnDestroyed(self)
  end
end

return M
