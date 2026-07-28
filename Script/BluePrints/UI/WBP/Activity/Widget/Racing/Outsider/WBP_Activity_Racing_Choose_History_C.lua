require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderController = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderController")

function M:Construct()
  self:InitVariable()
  self:BindAllEvent()
  self:RefreshBaseInfo()
end

function M:Destruct()
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
end

function M:InitVariable()
  self.PageIndex = 1
  self.PageMax = 1
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:CheckNeedAutoFocusWithInputType()
  local LastestCreateWidget = UIManager(self):GetLastestAndFocusableUIWidgetObj()
  if self == LastestCreateWidget then
    return true
  else
    return false
  end
end

function M:BindAllEvent()
  function self.Btn_Left.SoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
  end
  
  function self.Btn_Right.SoundFunc()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
  end
  
  self.Btn_Left:BindEventOnClicked(self, self.OnFlipBefore)
  self.Btn_Right:BindEventOnClicked(self, self.OnFlipNext)
  self.Key_Previous:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
  self.Key_Next:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)
  self.Btn_Close.OnClicked:Add(self, self.CloseSelf)
end

function M:RefreshBaseInfo()
  self.Text_Title:SetText(GText("UI_Event_RaceLottery_BetHistory"))
  self.Text_HistoryNumTitle:SetText(GText("UI_Event_RaceLottery_BetReward"))
  self.Text_HistoryResultTitle:SetText(GText("UI_Event_RaceLottery_BetResult"))
  self.Text_HistoryDateTitle:SetText(GText("UI_Event_RaceLottery_BetDate"))
  self.Text_Empty:SetText(GText("UI_Event_RaceLottery_History_ListEmpty"))
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if self.PageMax > 1 then
    if CurInputType == ECommonInputType.Gamepad then
      self.Previous:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Next:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Key_Previous:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Key_Next:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Previous:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Next:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Key_Previous:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Key_Next:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self)
  local AllHistory, StartIndex = ...
  self:InitListHistory(AllHistory)
  self.PageTurner:InitPageTurner(self.PageMax, self, self.HandleIndexFunc, StartIndex)
  self:PlayAnimation(self.In)
end

function M:InitListHistory(AllHistory)
  self.AllHistory = AllHistory
  if not self.AllHistory then
    self.AllHistory = RacingOutsiderController:GetModel():GenerateHistoryData()
  end
  if 0 == #self.AllHistory then
    self.WS_List:SetActiveWidgetIndex(1)
    self.Multi:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.WS_List:SetActiveWidgetIndex(0)
    self.PageIndex = 1
    self.PageMax = (#self.AllHistory + RacingActivityConst.PerPageRecordCount - 1) // RacingActivityConst.PerPageRecordCount
    self.Btn_Left:ForbidBtn(false)
    self.Btn_Right:ForbidBtn(false)
    if self.PageIndex == self.PageMax then
      self.Btn_Left:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Btn_Right:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
      self.Btn_Left:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Btn_Right:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Btn_Left:ForbidBtn(true)
    end
    self.Multi:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:UpdateListRecord()
  end
end

function M:UpdateListRecord()
  local HistoryDataInCurPage = self:GetRacingHistoryRecord((self.PageIndex - 1) * RacingActivityConst.PerPageRecordCount, RacingActivityConst.PerPageRecordCount)
  self.List_History:ClearListItems()
  for key, value in pairs(HistoryDataInCurPage) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = key
    Content.CoinId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
    Content.IncomeNum = value.Income
    Content.HitChoice = value.Hit
    Content.TotalChoice = value.Total
    Content.GuessTime = value.RecordTime
    self.List_History:AddItem(Content)
  end
  self.List_History:ScrollIndexIntoView(0)
end

function M:GetRacingHistoryRecord(StartIndex, Limit)
  StartIndex = StartIndex or 0
  local HistoryLength = #self.AllHistory
  Limit = Limit or HistoryLength
  if HistoryLength < StartIndex + Limit then
    Limit = HistoryLength - StartIndex
  end
  local Result = {}
  for i = StartIndex + 1, Limit + StartIndex do
    if self.AllHistory[i] then
      table.insert(Result, self.AllHistory[i])
    end
  end
  return Result
end

function M:OnFlipBefore()
  if 1 == self.PageIndex then
    return
  end
  if self.PageIndex == self.PageMax then
    self.Btn_Right:ForbidBtn(false)
  end
  self.PageTurner:PageLeft()
  if 1 == self.PageIndex then
    self.Btn_Left:ForbidBtn(true)
  end
end

function M:OnFlipNext()
  if self.PageIndex == self.PageMax then
    return
  end
  if 1 == self.PageIndex then
    self.Btn_Left:ForbidBtn(false)
  end
  self.PageTurner:PageRight()
  if self.PageIndex == self.PageMax then
    self.Btn_Right:ForbidBtn(true)
  end
end

function M:HandleIndexFunc(NewPageIndex, bFlipLeft)
  if NewPageIndex == self.PageIndex then
    return
  end
  self.PageIndex = NewPageIndex
  self:PlayAnimation(self.Change)
  self:UpdateListRecord()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif InKeyName == UE4.EKeys.Escape.KeyName then
    self:CloseSelf()
  end
  return IsEventHandled
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.DPadLeft then
    self:OnFlipBefore()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    self:OnFlipNext()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:CloseSelf()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:CloseSelf()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_cancel", nil, nil)
  self:Close()
end

return M
