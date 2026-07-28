require("UnLua")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local M = Class({
  "BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.View.RacingChoosePetBaseView"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")

function M:Construct()
  self:InitBaseView()
  self:InitKeyInfo()
  self.WBP_Activity_Racing_Choose_P.ParentWidget = self
  self.WBP_Activity_Racing_Pet_P.ParentWidget = self
  self:InitTab()
  self:RefreshOpInfoByInputDevice()
  self:SetFocus()
end

function M:InitKeyInfo()
  self.WBP_Activity_Racing_Choose_P.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  self.WBP_Activity_Racing_Choose_P.Btn_ShopChoose.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.WBP_Activity_Racing_Choose_P.Btn_TaskChoose.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText(RacingActivityConst.ChooseCancelText)
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText(RacingActivityConst.CheckRumorText)
    }
  }
  self.BottomKeyInfo2 = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText(RacingActivityConst.CheckText)
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText(RacingActivityConst.BackText)
    }
  }
  self.BottomKeyInfo3 = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText(RacingActivityConst.BackText)
    }
  }
end

function M:InitTab()
  local TabConfigData = {
    TitleName = GText(RacingActivityConst.TitleNameText),
    StyleName = "Text",
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BackCallback = self.Close,
    LastFocusWidget = self,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = self,
    OverridenTopResouces = {
      tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
    }
  }
  self.Com_Tab:Init(TabConfigData)
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  DebugPrint("Yihan@ RefreshOpInfoByInputDevice", UIUtils.IsGamepadInput())
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
    local ActivityRacingRumorPage = UIManager(self):GetUIObj("ActivityRacingRumor")
    if not ActivityRacingRumorPage then
      self.WBP_Activity_Racing_Pet_P.List_Pet:NavigateToIndex(0)
    else
      ActivityRacingRumorPage:SetFocus()
    end
  elseif UIUtils.IsKeyboardInput() then
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.WBP_Activity_Racing_Choose_P.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Activity_Racing_Choose_P.Btn_ShopChoose.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Activity_Racing_Choose_P.Btn_TaskChoose.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Activity_Racing_Pet_P.Btn_Reset.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.WBP_Activity_Racing_Pet_P.Key_Qa:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:ResetDynamicNode()
end

function M:InitKeyboardView()
  self.WBP_Activity_Racing_Choose_P.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Activity_Racing_Choose_P.Btn_ShopChoose.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Activity_Racing_Choose_P.Btn_TaskChoose.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Activity_Racing_Pet_P.Btn_Reset.Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WBP_Activity_Racing_Pet_P.Key_Qa:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:ResetDynamicNode()
end

function M:ResetDynamicNode()
  if not self.IsPetPageOpen then
    return
  end
  if UIUtils.IsGamepadInput() then
    self.WBP_Activity_Racing_Pet_P.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.bIsInTips then
      self.WBP_Activity_Racing_Pet_P.Com_MidKeyTips:UpdateKeyInfo(self.BottomKeyInfo3)
    elseif self.bIsInRumorStatus then
      self.WBP_Activity_Racing_Pet_P.Com_MidKeyTips:UpdateKeyInfo(self.BottomKeyInfo2)
    else
      self.WBP_Activity_Racing_Pet_P.Com_MidKeyTips:UpdateKeyInfo(self.BottomKeyInfo)
    end
  else
    self.WBP_Activity_Racing_Pet_P.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  DebugPrint("Yihan@ OnPreviewKeyDown", MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and "Gamepad_FaceButton_Bottom" == InKeyName then
    if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
      if self.IsPetPageOpen then
        local CurrentFocusWidget = RacingOutsiderModel.CurrentFocusWidget
        if IsValid(CurrentFocusWidget) and CurrentFocusWidget.Content then
          self.WBP_Activity_Racing_Pet_P:OnPetItemChoosed(CurrentFocusWidget.Content)
          CurrentFocusWidget:SetIsChoosed()
        end
      else
        self.WBP_Activity_Racing_Choose_P:OnChoosePetBtnClicked()
        self:ResetDynamicNode()
        self:AddTimer(0.2, function()
          self.WBP_Activity_Racing_Pet_P.List_Pet:NavigateToIndex(0)
        end)
      end
    elseif not self.IsInAnimation then
      self.WBP_Activity_Racing_Choose_P:OnGotoRaceBtnClicked()
    end
    IsHandled = true
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  DebugPrint("Yihan@ OnKeyDown", MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if not self.IsPetPageOpen then
    self.Com_Tab:Handle_KeyEventOnGamePad_KeyDown(InKeyName)
  end
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self.IsPetPageOpen then
      IsEventHandled = self:Handle_KeyDownOnGamePadAndPetPageOpen(InKeyName)
    else
      IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    end
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

function M:Handle_KeyDownOnGamePadAndPetPageOpen(InKeyName)
  DebugPrint("Yihan@ Handle_KeyDownOnGamePadAndPetPageOpen", InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft and not self.bIsInTips then
    self.WBP_Activity_Racing_Pet_P:OnConfirmBtnClicked()
    self:SetFocus()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop and not self.bIsInTips then
    self.WBP_Activity_Racing_Pet_P:OnResetBtnClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.bIsInTips then
      self.WBP_Activity_Racing_Pet_P.Com_CheckBoxQa:CloseMenuAnchor()
      self.bIsInTips = false
      self:ResetDynamicNode()
      self.WBP_Activity_Racing_Pet_P.List_Pet:NavigateToIndex(0)
      return true
    end
    if self.bIsInRumorStatus then
      if RacingOutsiderModel.CurrentFocusWidget then
        self.WBP_Activity_Racing_Pet_P.List_Pet:NavigateToIndex(RacingOutsiderModel.CurrentFocusWidget.Content.Index - 1)
      end
      self.bIsInRumorStatus = false
      self:ResetDynamicNode()
      return true
    end
    self.WBP_Activity_Racing_Pet_P:OnCancelBtnClicked()
    self:SetFocus()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb and not self.bIsInTips then
    self.WBP_Activity_Racing_Pet_P.DetailItem01:SetFocus()
    self.bIsInRumorStatus = true
    self:ResetDynamicNode()
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.WBP_Activity_Racing_Pet_P.Com_CheckBoxQa:OpenMenuAnchor()
    self.bIsInTips = true
    self:ResetDynamicNode()
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightThumb then
    local LastFocusWidget = self
    if IsValid(RacingOutsiderModel.CurrentFocusWidget) then
      LastFocusWidget = RacingOutsiderModel.CurrentFocusWidget
    end
    self.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(LastFocusWidget)
    self.Com_Tab.WBP_Com_Tab_ResourceBar:SetFocus()
    self.Com_Tab.WBP_Com_Tab_ResourceBar:FocusToResource()
    return true
  end
  return false
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  DebugPrint("Yihan@ Handle_KeyDownOnGamePad", InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.WBP_Activity_Racing_Choose_P:OnShopChooseBtnClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self.WBP_Activity_Racing_Choose_P:OnTaskChooseBtnClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnReturnKeyDown()
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialLeft then
    self.WBP_Activity_Racing_Choose_P:OnHistoryBtnClicked()
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self.WBP_Activity_Racing_Choose_P:OnChooseBetBtnClicked()
    return true
  end
  return false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  DebugPrint("Yihan@ OnFocusReceived:WBP_Activity_Racing_ChoosePet_P_C")
  if UIUtils.IsGamepadInput() then
    if self.IsPetPageOpen then
      if RacingOutsiderModel.CurrentFocusWidget then
        RacingOutsiderModel.CurrentFocusWidget:SetFocus()
      end
      self:ResetDynamicNode()
    else
      self:AddTimer(0.1, function()
        self:SetFocus()
      end)
    end
  end
  return UIUtils.Handled
end

function M:OnReturnKeyDown()
  DebugPrint("Yihan@ OnReturnKeyDown", self.IsPetPageOpen)
  if self.IsPetPageOpen then
    self:bShowPetPage(false)
  else
    self:Close()
  end
end

function M:Close()
  if self.IsInAnimation then
    return
  end
  local PreviousUI = UIManager(self):GetUnderState()
  if PreviousUI then
    local PreviousUIName = PreviousUI:GetName()
    DebugPrint("JLY 上一个栈的UI是:", PreviousUIName)
    if "ActivityMain" == PreviousUIName then
      EventManager:FireEvent(EventID.OnReturnToActivityEntry)
      EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
    end
  end
  M.Super.Close(self)
  self:OnViewClose()
end

return M
