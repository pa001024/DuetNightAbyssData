require("UnLua")
local MonthSignInModel = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInModel")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local M = Class({
  "BluePrints.UI.WBP.Perk.MonthSignIn.View.MonthSignInBaseView"
})
local MonthSignInState = {
  NormalCard1 = 1,
  MonthCard = 2,
  NormalCard2 = 3
}

function M:Construct()
  self:InitBaseView()
  self.BtnClose.btn_close.OnClicked:Add(self, self.Close)
  self.BtnClose:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Key_ControllerBuy:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.KeyReward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.BottomKeyInfo = {
    GamePadInfo = {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    GamePadInfo2 = {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    KeyBoardInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "Esc",
            Owner = self,
            ClickCallback = self.Close
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  }
  self.ControllerFSM = ControllerFSM.New(self, {
    [MonthSignInState.NormalCard1] = {
      OnEnter = self.OnEnterState_NormalCard1
    },
    [MonthSignInState.MonthCard] = {
      OnEnter = self.OnEnterState_MonthCard,
      OnLeave = self.OnLeaveState_MonthCard
    },
    [MonthSignInState.NormalCard2] = {
      OnEnter = self.OnEnterState_NormalCard2
    }
  })
  self:SetFocus()
  if not UIUtils.IsMobileInput() then
    self:RefreshOpInfoByInputDevice()
  else
    self.Key_ControllerBuy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.KeyReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local CurTimestamp = TimeUtils.NowTime()
  DebugPrint("Yihan@ CurTimestamp", CurTimestamp)
  EMCache:Set("PreLoadingTime", CurTimestamp, true)
end

function M:OnEnterState_MonthCard()
  DebugPrint("Yihan@ OnEnterState_MonthCard")
  self.Item01:SetFocus()
  self.KeyReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnLeaveState_MonthCard()
  DebugPrint("Yihan@ OnLeaveState_MonthCard")
  self.KeyReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.List:NavigateToIndex(MonthSignInModel:GetTodaySignInDay() - 1)
end

function M:OnEnterState_NormalCard1()
  DebugPrint("Yihan@ OnEnterState_NormalCard1")
  self.KeyReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.List:NavigateToIndex(MonthSignInModel:GetTodaySignInDay() - 1)
end

function M:OnEnterState_NormalCard2()
  DebugPrint("Yihan@ OnEnterState_NormalCard2")
  self.ListCumulative:NavigateToIndex(self.NeedNavigateTo)
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  DebugPrint("Yihan@ RefreshOpInfoByInputDevice", CurInputType, CurGamepadName)
  self:UpdateGamePadIcon(CurInputType)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
    self.ControllerFSM:Enter(MonthSignInState.NormalCard1)
  elseif UIUtils.IsKeyboardInput() then
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.Key_ControllerBuy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Com_KeyImg.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.KeyReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:ResetDynamicNode()
end

function M:InitKeyboardView()
  DebugPrint("Yihan@ InitKeyboardView")
  self.Key_ControllerBuy:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.KeyReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:ResetDynamicNode()
end

function M:UpdateGamePadIcon(CurInputType)
  DebugPrint("Yihan@ UpdateGamePadIcon", CurInputType)
  if CurInputType == ECommonInputType.Gamepad and MonthSignInModel:IsTodaySigned() then
    if 1 == self.NowCard then
      self:InitGamepadView()
      local Item = self.List:GetItemAt(MonthSignInModel:GetTodaySignInDay() - 1)
      self.List:NavigateToIndex(MonthSignInModel:GetTodaySignInDay() - 1)
    else
      local Item = self.ListCumulative:GetItemAt(self.NeedNavigateTo)
      self.ListCumulative:NavigateToIndex(self.NeedNavigateTo)
      Item.SelfWidget.Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  elseif CurInputType == ECommonInputType.MouseAndKeyboard and 1 == self.NowCard then
    self:InitKeyboardView()
  end
end

function M:SetItemFocus(Item)
  if self.WaitFocusTimer then
    self:RemoveTimer(self.WaitFocusTimer)
  end
  self.WaitFocusTimer = self:AddTimer(0.01, function()
    Item:SetFocus()
  end, false, 0, "Item_WaitFocusTimer")
end

function M:ResetDynamicNode()
  local BottomKeyInfo
  if UIUtils.IsGamepadInput() then
    if 1 == self.NowCard then
      BottomKeyInfo = self.BottomKeyInfo.GamePadInfo
    else
      BottomKeyInfo = self.BottomKeyInfo.GamePadInfo2
    end
  elseif UIUtils.IsKeyboardInput() then
    BottomKeyInfo = self.BottomKeyInfo.KeyBoardInfo
  end
  self.Panel_Key:ClearChildren()
  self.ComKeys = {}
  for i, KeyInfo in ipairs(BottomKeyInfo) do
    local KeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Panel_Key:AddChild(KeyWidget)
    table.insert(self.ComKeys, KeyWidget)
    if #KeyInfo.KeyInfoList > 1 then
      KeyWidget:CreateSubKeyDesc(KeyInfo)
    else
      KeyWidget:CreateCommonKey(KeyInfo)
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  DebugPrint("Yihan@ Handle_KeyDownOnGamePad", InKeyName, UIConst.GamePadKey.LeftThumb)
  local CurrentState = self.ControllerFSM:Current()
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:OnBuyBtnClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if CurrentState == MonthSignInState.NormalCard1 then
      if not self.bIsInGetAnimation then
        self:OnSwitchBtnClicked()
        self.ControllerFSM:Enter(MonthSignInState.NormalCard2)
      end
    elseif CurrentState == MonthSignInState.NormalCard2 and not self.bIsInGetAnimation then
      self:OnSwitchBtnClicked()
      self.ControllerFSM:Enter(MonthSignInState.NormalCard1)
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnReturnKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    if CurrentState == MonthSignInState.NormalCard1 then
      self.ControllerFSM:Enter(MonthSignInState.MonthCard)
    end
    return true
  end
  return false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self.List:NavigateToIndex(MonthSignInModel:GetTodaySignInDay() - 1)
    self:ResetDynamicNode()
  end
  return UIUtils.Handled
end

function M:OnReturnKeyDown()
  if UIUtils.IsKeyboardInput() then
    self:Close()
    return
  end
  local CurrentState = self.ControllerFSM:Current()
  DebugPrint("Yihan@ OnReturnKeyDown", CurrentState)
  if CurrentState == MonthSignInState.NormalCard1 or CurrentState == MonthSignInState.NormalCard2 then
    self:Close()
  elseif CurrentState == MonthSignInState.MonthCard then
    self.ControllerFSM:Enter(MonthSignInState.NormalCard1)
  elseif CurrentState == MonthSignInState.ChoosedReward then
    self.ControllerFSM:Enter(MonthSignInState.NormalCard2)
  end
end

function M:Close()
  DebugPrint("Yihan@ Close", MonthSignInModel:IsTodaySigned())
  if self.WaitFocusTimer then
    self:RemoveTimer(self.WaitFocusTimer)
  end
  if self.bIsInGetAnimation or self.IsInAnimation or self.bIsInRefresh then
    return
  end
  M.Super.Close(self)
  self:OnViewClose()
end

return M
