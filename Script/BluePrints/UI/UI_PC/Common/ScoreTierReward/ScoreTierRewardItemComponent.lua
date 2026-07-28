local M = {}

function M:ScoreTierRewardItem_Construct()
  self.RewardItems = {}
  self.State2ChangeIndex = {
    Ing = 0,
    Complete = 1,
    Received = 2
  }
  self.RewardItemWidth = nil
  self.RewardScrollBoxWidth = self.ScrollBox_ItemRewards.Slot:GetSize().X
  self.Btn_Click.OnClicked:Add(self, self.ScoreTierRewardItem_OnClicked)
  self.Btn_Click.OnHovered:Add(self, self.ScoreTierRewardItem_OnBtnHovered)
  self.Btn_Click.OnUnhovered:Add(self, self.ScoreTierRewardItem_OnBtnUnhovered)
  self.Btn_Click.OnPressed:Add(self, self.ScoreTierRewardItem_OnBtnPressed)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:ScoreTierRewardItem_RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:ScoreTierRewardItem_InitListenEvent()
end

function M:ScoreTierRewardItem_Destruct()
  self:ScoreTierRewardItem_ClearListenEvent()
end

function M:ScoreTierRewardItem_OnListItemObjectSet(Content)
  if Content.NotReward then
    self:SetRenderOpacity(0)
    return
  end
  self:SetRenderOpacity(1)
  self.Content = Content
  self.ID = Content.RewardInfoId
  self.Index = Content.Index
  self.Parent = Content.Parent
  self.Bg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Bg_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_Normal:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Name:SetText(Content.GradePoints)
  self.Btn_Jump.IsForbidden = true
  self.Btn_Jump:SetText(GText("UI_Achievement_GetReward"))
  self.Group_IngBtn:SetVisibility(ESlateVisibility.Collapsed)
  local LockedSelf = true
  local LockedNext = true
  local State = "Ing"
  local CurrentScore = self.Parent:GetScoreTierCurrentScore()
  if CurrentScore >= Content.GradePoints then
    LockedSelf = false
  end
  if CurrentScore >= Content.GradePoints + self.Parent.EachGradePoints then
    LockedNext = false
  end
  if self.Parent:IsScoreTierRewardGot(self.Index) then
    State = "Received"
  elseif not LockedSelf then
    State = "Complete"
  end
  for _, item in pairs(self.RewardItems) do
    item:RemoveFromParent()
  end
  local totalWidth = 0
  self.RewardItems = {}
  if self.ID then
    local RewardInfo = DataMgr.Reward[self.ID]
    local RewardList = {}
    if RewardInfo then
      local RewardIds = RewardInfo.Id or {}
      local RewardCounts = RewardInfo.Count or {}
      local RewardTypes = RewardInfo.Type or {}
      for i = 1, #RewardIds do
        local ItemId = RewardIds[i]
        local Count = RewardUtils:GetCount(RewardCounts[i])
        local Icon = ItemUtils.GetItemIconPath(ItemId, RewardTypes[i])
        local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
        table.insert(RewardList, {
          Id = ItemId,
          Type = RewardTypes[i],
          ItemCount = Count,
          Icon = Icon,
          Rarity = Rarity
        })
      end
    end
    table.sort(RewardList, function(A, B)
      local rarityX = A.Rarity or 1
      local rarityY = B.Rarity or 1
      if rarityX == rarityY then
        return A.Id < B.Id
      end
      return rarityX > rarityY
    end)
    local ItemDetailUIName = self.Parent.GetScoreTierItemDetailUIName and self.Parent:GetScoreTierItemDetailUIName() or "ScoreTierReward"
    for _, ItemInfo in pairs(RewardList) do
      local Object = {
        ParentWidget = self,
        ItemType = ItemInfo.Type,
        Id = ItemInfo.Id,
        Count = ItemInfo.ItemCount,
        Icon = ItemInfo.Icon,
        Rarity = ItemInfo.Rarity or 1,
        IsShowDetails = true,
        HandleMouseDown = true,
        UIName = ItemDetailUIName,
        OnMenuOpenChangedEvents = {
          Obj = self,
          Callback = self.OnMenuOpenChanged
        },
        NotInteractive = ItemInfo.TableName == "Char"
      }
      local rewardItem = self:NewRewardItem()
      rewardItem:Init(Object)
      rewardItem:SetVisibility(ESlateVisibility.Visible)
      table.insert(self.RewardItems, rewardItem)
      if not self.RewardItemWidth then
        rewardItem:ForceLayoutPrepass()
        self.RewardItemWidth = rewardItem:GetDesiredSize().X + rewardItem.Slot.Padding.Left + rewardItem.Slot.Padding.Right
      end
      totalWidth = totalWidth + self.RewardItemWidth
    end
    local size = self.Spacer_Reward.Size
    if totalWidth < self.RewardScrollBoxWidth then
      size:Set(self.RewardScrollBoxWidth - totalWidth, 0)
    else
      size:Set(0, 0)
    end
    self.Spacer_Reward:SetSize(size)
  end
  self.CompleteMask:SetVisibility(ESlateVisibility.Collapsed)
  self:ChangeState(State)
  if LockedSelf then
    self.WS_Left:SetActiveWidgetIndex(0)
    self:PlayAnimation(self.Progress)
  else
    self.WS_Left:SetActiveWidgetIndex(1)
    self:PlayAnimation(self.Recive)
  end
  if LockedNext then
    self.WS_Right:SetActiveWidgetIndex(0)
  else
    self.WS_Right:SetActiveWidgetIndex(1)
  end
  if 1 == self.Index then
    self.WS_Left:SetVisibility(ESlateVisibility.Collapsed)
    self.WS_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif self.Index == self.Parent.MaxRewardGot then
    self.WS_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WS_Right:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.WS_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WS_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  self:ScoreTierRewardItem_PlayAnimNew()
end

function M:ScoreTierRewardItem_PlayAnimNew()
  self:StopAnimation(self.In)
  if self.Parent.PlayInAnimation and self.State == "Complete" then
    self:PlayAnimation(self.In)
  end
end

function M:ScoreTierRewardItem_OnClicked()
  if self.State ~= "Complete" then
    return
  end
  self.Parent:RequestClaimScoreTierReward(self.Index, function(RetCode, Rewards)
    if 0 ~= RetCode then
      return
    end
    self:ChangeState("Received")
    self:PlayAnimation(self.Click)
    if self.Parent.ScoreTierReward_OnClaimSuccess then
      self.Parent:ScoreTierReward_OnClaimSuccess(Rewards, self.Index)
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
      self:SetFocus()
    end, self)
  end)
end

function M:ScoreTierRewardItem_OnBtnHovered()
  if self.State == "Complete" or UIUtils.IsGamepadInput() then
    self:StopAnimation(self.Unhover)
    self:PlayAnimation(self.Hover)
    self.IsPlayingHover = true
  end
end

function M:ScoreTierRewardItem_OnBtnUnhovered()
  if self.IsPlayingHover then
    self.IsPlayingHover = false
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Unhover)
  end
end

function M:ScoreTierRewardItem_OnBtnPressed()
  if self.State == "Complete" then
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
  end
end

function M:ChangeState(NewState)
  if self.State2ChangeIndex[NewState] then
    self.State = NewState
    self.Change:SetActiveWidgetIndex(self.State2ChangeIndex[self.State])
    if self.State2ChangeIndex[NewState] == self.State2ChangeIndex.Received then
      for _, Item in pairs(self.RewardItems) do
        Item:SetIsGot(true)
      end
    end
  end
end

function M:CheckIsCompleteState()
  return self.State == "Complete"
end

function M:ScoreTierRewardItem_InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.ScoreTierRewardItem_RefreshOpInfoByInputDevice)
  end
end

function M:ScoreTierRewardItem_ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.ScoreTierRewardItem_RefreshOpInfoByInputDevice)
  end
end

function M:ScoreTierRewardItem_RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:ScoreTierRewardItem_InitKeyboardView()
  else
    self:ScoreTierRewardItem_InitGamepadView()
  end
end

function M:ScoreTierRewardItem_InitGamepadView()
  self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:ScoreTierRewardItem_InitKeyboardView()
  self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:BP_GetDesiredFocusTarget()
  self.Content.Parent:TryChangeCurFocusedItem(self)
  if self.Content.Parent.IsInSelectState then
    self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Reward = self.ScrollBox_ItemRewards:GetChildAt(1)
    return Reward
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  return self.Btn_Click
end

function M:ScoreTierRewardItem_OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_LeftThumbstick" == InKeyName then
      IsEventHandled = self.Content.Parent:TryEnterSelectMode(self)
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      IsEventHandled = self.Content.Parent:TryLeaveSelectMode(self)
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:EnterSelectMode()
  self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local Reward = self.ScrollBox_ItemRewards:GetChildAt(1)
  Reward:SetFocus()
end

function M:LeaveSelectMode()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.ScrollBox_ItemRewards:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  self.Btn_Click:SetFocus()
end

function M:OnMenuOpenChanged(bIsOpen)
  self.Parent:OnMenuOpenChanged(bIsOpen)
end

return M
