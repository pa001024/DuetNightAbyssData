require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.BtnCD = 0.5
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  local Params = (...)
  self.OldBuffId = Params.OldBuffId
  self.NewBuffId = Params.NewBuffId
  self.Parent = Params.Parent
  self:InitText()
  self:InitButtons()
  self:InitChoices()
  self:SetFocus()
  self:PlayAnimation(self.In)
  self:PlayAnimation(self.Change_Normal)
  self:AddDispatcher(EventID.OnPlayShowDamageEffect, self, self.PlayHitAnim)
  self:AddDispatcher(EventID.OnSoloTreasureGetTicket, self, self.OnGetTicket)
  self.New:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.Old:SetVisibility(ESlateVisibility.HitTestInvisible)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_fengxiang_replace_exist_in", nil, nil)
  EventManager:FireEvent(EventID.ShowCountDownTips)
end

function M:InitText()
  self.Text_Choose:SetText(GText("UI_Extraction_TM_20"))
end

function M:InitButtons()
  self:InitConfirmBtn()
  self:InitCancelBtn()
end

function M:InitConfirmBtn()
  self.Btn_Confirm.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Btn_Confirm:InitButton({
    Text = GText("UI_Extraction_TM_21")
  })
  self.Btn_Confirm.Btn_Area.OnClicked:Add(self, self.SendTicketSelectRPC)
  self.Btn_Confirm:SetForbid(false)
end

function M:SendTicketSelectRPC()
  if self.Btn_Confirm.IsForbid then
    return
  end
  self.CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  if self.ConfirmStartTime and self.CurrentTime - self.ConfirmStartTime < self.BtnCD then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_confirm", nil, nil)
  self.ConfirmStartTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  self.Parent:SendTicketSelectRPC()
  self.Btn_Cancel:SetForbid(true)
  self.Btn_Confirm:SetForbid(true)
end

function M:OnGetTicket(TicketId)
  self:BindToAnimationFinished(self.Change, {
    self,
    function()
      self.Parent:CloseAndPlayToast(TicketId)
      self:Close()
    end
  })
  self:PlayAnimation(self.Change)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_fengxiang_replace_confimed", nil, nil)
end

function M:InitCancelBtn()
  self.Btn_Cancel.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    }
  })
  self.Btn_Cancel:InitButton({
    Text = GText("UI_Extraction_TM_46")
  })
  self.Btn_Cancel.Btn_Area.OnClicked:Add(self, function()
    self:Close()
  end)
  self.Btn_Cancel:SetForbid(false)
end

function M:InitChoices()
  self.New:InitInfo({
    LotteryId = self.NewBuffId,
    Owned = false
  })
  self.Old:InitInfo({
    LotteryId = self.OldBuffId,
    Owned = true
  })
end

function M:PlayHitAnim()
  if not self:IsAnimationPlaying(self.Hit) then
    self:PlayAnimation(self.Hit)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == Const.GamepadFaceButtonDown then
    IsHandled = true
    self:SendTicketSelectRPC()
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or InKeyName == Const.GamepadFaceButtonRight then
    self:Close()
  end
end

function M:Close()
  self.Super.Close(self)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_cancel", nil, nil)
  self.Parent:RegainFocus()
end

return M
