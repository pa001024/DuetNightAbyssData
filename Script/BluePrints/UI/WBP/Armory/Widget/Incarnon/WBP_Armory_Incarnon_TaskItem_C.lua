require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local QCS = CommonConst.QuestChainState

function M:Construct()
  self.Btn_Go:SetText(GText("UI_Event_Btn_Goto"))
  self.Btn_Reward:SetText(GText("UI_GameEvent_ClaimReward"))
  self.Text_Reward:SetText(GText("UI_HyperWeapon_ForgeLevelTaskReward"))
  self.Btn_Go:BindSingleEventOnClicked(self, self.OnBtnGoClicked)
  self.Btn_Reward:BindSingleEventOnClicked(self, self.OnBtnRewardClicked)
end

function M:InitContent(Content)
  self.Content = Content
  if Content.IsEmpty then
    self.WS_State:SetActiveWidgetIndex(1)
    return
  end
  self.WS_State:SetActiveWidgetIndex(0)
  self.Parent = Content.Parent
  self.QuestId = Content.QuestId
  self.QuestInfo = DataMgr.ForgeLevelQuest[self.QuestId]
  self.Avatar = GWorld:GetAvatar()
  self:RefreshAllInfo()
  self:InitGamepadIcon()
  self:AddInputMethodChangedListen()
  self.Text_Task:SetText(GText(self.QuestInfo.DailyTasktDes))
end

function M:RefreshAllInfo()
  self:RefreshRewardItems()
  self:RefreshButtonState()
end

function M:InitGamepadIcon()
  self.Key_Reward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
end

function M:RefreshRewardItems()
  local bHasRewardGot = self:HasRewardGot()
  local RewarId = self.QuestInfo.QuestReward and self.QuestInfo.QuestReward[1] or 0
  local RewardList = RewardUtils:GetRewardViewInfoById(RewarId)
  local Contents = {}
  for _, RewardInfo in pairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UnitId = RewardInfo.Id
    Content.Count = RewardInfo.Quantity[1] or 0
    Content.Rarity = RewardInfo.Rarity or 1
    Content.IsShowDetails = true
    Content.ItemType = RewardInfo.Type
    Content.Icon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
    Content.RewardGot = bHasRewardGot
    Content.UIName = "ArmoryIncarnonDetail"
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnMenuOpenChanged
    }
    table.insert(Contents, Content)
  end
  local Panel = self.WB_Item
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for i, Content in pairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:Init(Content)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    local Widget = Panel:GetChildAt(i)
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshButtonState()
  local bHasRewardGot = self:HasRewardGot()
  if bHasRewardGot then
    self.WS_Btn:SetActiveWidgetIndex(2)
    self.Text_Progressing:SetText(GText("UI_GameEvent_HasClaimed"))
    return
  end
  local Quest = self.Avatar.WeaponForgeQuests[self.QuestId]
  if Quest and Quest:IsComplete() then
    self.WS_Btn:SetActiveWidgetIndex(1)
    return
  end
  if self.QuestInfo.InterfaceJump then
    self.WS_Btn:SetActiveWidgetIndex(0)
  else
    self.WS_Btn:SetActiveWidgetIndex(2)
    self.Text_Progressing:SetText(GText("UI_GameEvent_ToBeFinished"))
  end
end

function M:HasRewardGot()
  local Quest = self.Avatar.WeaponForgeQuests[self.QuestId]
  if not Quest then
    return false
  end
  if not Quest:IsComplete() then
    return false
  end
  return Quest.RewardsGot
end

function M:OnBtnGoClicked()
  local JumpId = self.QuestInfo.InterfaceJump
  if not JumpId or 0 == JumpId then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(JumpId)
end

function M:OnBtnRewardClicked()
  if not self.Parent then
    return
  end
  
  local function Callback(Ret, Rewards)
    self.Parent:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
      return
    end
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Rewards, nil, self, true)
    self:RefreshAllInfo()
    self:RefreshParentInfo()
  end
  
  self.Parent:BlockAllUIInput(true)
  self.Avatar:WeaponForgeQuestGetReward(Callback, self.QuestId)
end

function M:RefreshParentInfo()
  if not self.Parent then
    return
  end
  if self.Parent.RefreshProgressBar then
    self.Parent:RefreshProgressBar()
  end
  if self.Parent.RefreshRewardBtnState then
    self.Parent:RefreshRewardBtnState()
  end
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
    self:OnButtonBottomClicked()
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
    if InKeyName == UIConst.GamePadKey.RightThumb then
      IsHandled = self:NavigateToFirstReward()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsHandled = self:OnReturnKeyDown()
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:NavigateToFirstReward()
  self.bIsInRewardPreview = true
  self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local Widget = self.WB_Item:GetChildAt(0)
  self.Parent.bIsInItemChooseState = true
  self.Parent:ResetDynamicNode()
  Widget:SetFocus()
  return true
end

function M:OnButtonBottomClicked()
  DebugPrint("Yihan@ OnButtonBottomClicked")
  local bHasRewardGot = self:HasRewardGot()
  if bHasRewardGot then
    return
  end
  local Quest = self.Avatar.WeaponForgeQuests[self.QuestId]
  if not Quest then
    return
  end
  if Quest:IsComplete() then
    self:OnBtnRewardClicked()
  end
  if self.QuestInfo.InterfaceJump then
    self:OnBtnGoClicked()
  end
end

function M:OnAddedToFocusPath(MyGeometry, InFocusEvent)
  DebugPrint("Yihan@ OnFocusReceived")
  if UIUtils.IsGamepadInput() then
    self.Btn_Reward:SetGamePadIconVisible(true)
    self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    self:StopAllAnimations()
    if self.Hover then
      self:PlayAnimation(self.Hover)
    end
  else
    self.Btn_Reward:SetGamePadIconVisible(false)
    self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_Go.WS_Key:SetVisibility(UIConst.VisibilityOp.Visible)
  return UIUtils.Handled
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.Btn_Reward:SetGamePadIconVisible(false)
  self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Go.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:StopAllAnimations()
  if self.UnHover then
    self:PlayAnimation(self.UnHover)
  end
  return UIUtils.Handled
end

function M:OnReturnKeyDown()
  if self.bIsInRewardPreview then
    self.Parent.WS_Left:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Parent.WS_Right:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Key_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    self.bIsInRewardPreview = false
    self.Parent.bIsInItemChooseState = false
    self.Parent:ResetDynamicNode()
    self:SetFocus()
    return true
  end
end

function M:OnMenuOpenChanged(IsOpen)
  if IsOpen and UIUtils.IsGamepadInput() then
    self.Parent.HB_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Parent.HB_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

return M
