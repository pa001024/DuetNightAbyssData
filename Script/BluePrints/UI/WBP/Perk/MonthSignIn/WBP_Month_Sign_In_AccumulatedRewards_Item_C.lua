require("UnLua")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local MonthSignInModel = MonthSignInController:GetModel()
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local EnumButtonState = {
  Forbid = 1,
  CanReceive = 2,
  Received = 3
}

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self:Init(Content)
end

function M:Init(Content)
  self.ButtonState = EnumButtonState.CanReceive
  self:InitView(Content)
  self.BtnReward.Button_Area.OnClicked:Add(self, self.OnRewardBtnClicked)
  self.BtnReward.Button_Area.OnHovered:Add(self, self.OnRewardBtnHovered)
  self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Remove(self, self.ItemMenuAnchorChanged)
  self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.ItemMenuAnchorChanged)
  self:AddInputMethodChangedListen()
end

function M:ItemMenuAnchorChanged()
  DebugPrint("Yihan@ ItemMenuAnchorChanged", UIManager(self):IsHaveMenuAnchorOpen())
  local bIsOpen = UIManager(self):IsHaveMenuAnchorOpen()
  self.IsShowItemDetails = bIsOpen
  if bIsOpen and UIUtils.IsGamepadInput() then
    self.Content.ParentWidget.Panel_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Content.ParentWidget.Panel_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:UpdateConditionList(Content)
  self.ListCondition:ClearListItems()
  local ConditionListDatas = Content.ConditionListData
  for _, Data in ipairs(ConditionListDatas) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ConditionText = Data.ConditionText
    Content.Target = Data.Target
    Content.Mine = Data.Mine
    if Content.Mine < Content.Target then
      self.ButtonState = EnumButtonState.Forbid
    end
    self.ListCondition:AddItem(Content)
  end
  self.ListCondition:RequestPlayEntriesAnim()
end

function M:InitView(Content)
  DebugPrint("Yihan@ WBP_Month_Sign_In_AccumulatedRewards_Item_C: InitView", self.Content)
  if Content.bIsEmpty then
    self.Ws_State:SetActiveWidgetIndex(1)
    self.Empty.Text_Empty:SetText(GText(MonthSignInCommon.HaveMore))
    return
  else
    self.Ws_State:SetActiveWidgetIndex(0)
  end
  self.Key:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.TextTitle01:SetText(GText(MonthSignInCommon.MontlyCheckTotalReward))
  self.TextTitle02:SetText(GText(MonthSignInCommon.UnlockCondition))
  self:SetTargetDay()
  self:InitItemHead()
  self:UpdateConditionList(Content)
  self:UpdateButtonState()
end

function M:SetTargetDay()
  self.TextDayNum:SetText(self.Content.TargetDay)
  self.TextDay:SetText(string.format(GText(MonthSignInCommon.MontlyCheckTotalDay)))
end

function M:UpdateButtonState()
  if self.Content.Step and MonthSignInModel:IsGetCumulativeReward(self.Content.Step) then
    self.ButtonState = EnumButtonState.Received
  end
  self.BtnReward:ForbidBtn(self.ButtonState == EnumButtonState.Forbid or self.ButtonState == EnumButtonState.Received)
  if self.ButtonState == EnumButtonState.Forbid then
    self.Ws_Btn:SetActiveWidgetIndex(1)
    self.TextBtn:SetText(GText(MonthSignInCommon.BattlePassClaimlock))
  elseif self.ButtonState == EnumButtonState.CanReceive then
    self.Ws_Btn:SetActiveWidgetIndex(0)
    self.BtnReward.Text_Button:SetText(GText(MonthSignInCommon.AchievementGetReward))
  elseif self.ButtonState == EnumButtonState.Received then
    self.Ws_Btn:SetActiveWidgetIndex(1)
    self.TextBtn:SetText(GText(MonthSignInCommon.RewardReceived))
  end
end

function M:InitItemHead()
  if self.Content.ItemType == "HeadFrame" then
    self.ItemHead:SetHeadFrame(self.Content.Id)
    local EmptyPath = "Texture2D'/Game/UI/Texture/Static/Atlas/Common/T_Com_Empty.T_Com_Empty'"
    local EmptyDice = LoadObject(EmptyPath)
    self.ItemHead.Img_Item:SetBrushResourceObject(EmptyDice)
  elseif self.Content.ItemType == "HeadSculpture" then
    self.ItemHead:SetHeadIconById(self.Content.Id)
  end
  self.ItemHead:BindOnClickEvent(function()
    self:ShowItemTips()
  end)
  self.ItemHead:BindOnMouseHover(function(bIsHover)
    if bIsHover then
      self:PlayAnimation(self.Reward_Hover)
    else
      self:PlayAnimation(self.Reward_UnHover)
    end
  end)
end

function M:OnRewardBtnClicked()
  DebugPrint("Yihan@ OnRewardBtnClicked", self.ButtonState)
  if self.ButtonState == EnumButtonState.Forbid or self.ButtonState == EnumButtonState.Received then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and self.ButtonState == EnumButtonState.CanReceive then
    DebugPrint("Yihan@ OnRewardBtnClicked: rpc to Server ", self.Content.Step)
    Avatar:MonthlyCheckGetTotalReward(self.Content.Step, function(ret, RewardList)
      DebugPrint("Yihan@ rpc callback", ret)
      if ErrorCode:Check(ret) then
        self:ShowGetItemPage(RewardList)
        self:PlayAnimation(self.Get)
        self:SetFocus()
        self:UpdateReddotState()
      end
    end)
  end
end

function M:OnRewardBtnHovered()
end

function M:UpdateReddotState()
  ReddotManager.DecreaseLeafNodeCount(MonthSignInCommon.ReddotName)
end

function M:ShowGetItemPage(RewardList)
  DebugPrint("Yihan@ ShowGetItemPage")
  UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardList, false, function()
    DebugPrint("Yihan@ CloseGetItemPage")
    self:UpdateButtonState()
  end, self, true)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self.Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StopAllAnimations()
    if self.Normal then
      self:PlayAnimation(self.Normal)
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  DebugPrint("Yihan@ OnPreviewKeyDown", InKeyName)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnRewardBtnClicked()
    IsHandled = true
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  DebugPrint("Yihan@ OnKeyDown", InKeyName)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.LeftThumb then
      self:ShowItemTips()
      IsHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsHandled = self:OnReturnKeyDown()
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowItemTips()
  DebugPrint("Yihan@ ShowItemTips")
  self:PlayAnimation(self.Reward_Hover)
  self.ItemDetails_MenuAnchor:SetLastFocusWidget(self)
  self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.Content)
end

function M:OnReturnKeyDown()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.IsShowItemDetails then
    return true
  end
  return false
end

function M:SetGamepadFocus(bFocus)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if bFocus then
    DebugPrint("Yihan@ SetGamepadFocus1111111111111111111111111111111")
    self.Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if self.ButtonState == EnumButtonState.CanReceive then
      self.BtnReward:SetGamePadIconVisible(true)
    end
  else
    self.Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnReward:SetGamePadIconVisible(false)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  DebugPrint("Yihan@ OnFocusReceived")
  if UIUtils.IsGamepadInput() then
    self:SetGamepadFocus(true)
    self:StopAllAnimations()
    if self.Hover then
      self:PlayAnimation(self.Hover)
    end
  end
  if self.ItemDetails_MenuAnchor.bMenuClosing == nil then
    self:PlayAnimation(self.Reward_Normal)
  elseif self.ItemDetails_MenuAnchor.bMenuClosing then
    self:PlayAnimation(self.Reward_UnHover)
    self.ItemDetails_MenuAnchor.bMenuClosing = nil
    self.IsShowItemDetails = false
  end
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  if UIUtils.IsGamepadInput() then
    DebugPrint("Yihan@ OnFocusLost")
    self:SetGamepadFocus(false)
    self:StopAllAnimations()
    if self.UnHover then
      self:PlayAnimation(self.UnHover)
    end
  end
  return UIUtils.Handled
end

function M:Destruct()
  self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.ItemMenuAnchorChanged)
end

return M
