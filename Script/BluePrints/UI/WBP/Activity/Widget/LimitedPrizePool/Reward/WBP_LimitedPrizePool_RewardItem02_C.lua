local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function DecreaseLimitedPrizeRewardSelectReddot(Index)
  local NodeName = "LimitedPrizeRewardSelect"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if CacheDetail[Index] then
    CacheDetail[Index] = nil
    ReddotManager.DecreaseLeafNodeCount(NodeName, 1)
  end
end

function M:Construct()
  self.RedDot = self.Reddot
  self.CustomSelectButton = self.Btn_Add
  self.RewardSwitcher = self.WS_Show
  self.RewardTipSwitcher = self.WS_Bottom
  self.OptionalText = self.Text_Optional
  self.Item = self.Item
  self.PromptSelectableAnimation = self.Loop
  self.GotAnimation = self.Get_Normal
  self.NormalAnimation = self.Normal
  self.OptionalText:SetText(GText("UI_LimitedPrizePool_OthSelect"))
  self.Content = nil
  self.GachaGetCallbackFunc = nil
  self.CustomSelectButton.OnClicked:Add(self, self.OnClicked)
  self.CustomSelectButton.OnHovered:Add(self, self.OnHovered)
  self.CustomSelectButton.OnUnhovered:Add(self, self.OnUnhovered)
  self.CustomSelectButton.OnPressed:Add(self, self.OnPressed)
  self.CustomSelectButton.OnReleased:Add(self, self.OnReleased)
end

function M:Destruct()
  self.CustomSelectButton.OnClicked:Remove(self, self.OnClicked)
  self.CustomSelectButton.OnHovered:Remove(self, self.OnHovered)
  self.CustomSelectButton.OnUnhovered:Remove(self, self.OnUnhovered)
  self.CustomSelectButton.OnPressed:Remove(self, self.OnPressed)
  self.CustomSelectButton.OnReleased:Remove(self, self.OnReleased)
end

function M:Init(Content)
  self.Content = Content
  if self.Content.Id then
    self:SetSelectedItem(self.Content)
  else
    self.RedDot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.RewardSwitcher:SetActiveWidgetIndex(0)
    self.RewardTipSwitcher:SetActiveWidgetIndex(0)
  end
  if Content.IsPreviewMode then
    self.RewardTipSwitcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
  elseif Content.bLocked and Content.bGot then
    self.RewardTipSwitcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.RewardTipSwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if Content.bLocked then
    self.RewardTipSwitcher:SetActiveWidgetIndex(2)
    self.Btn_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Add:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  if Content.bGot then
    self:PlayAnimation(self.GotAnimation)
  else
    self:PlayAnimation(self.NormalAnimation)
  end
end

function M:OpenSelectWidget(RestoreIndex)
  local Content = self.Content
  if not IsValid(Content) or Content.Ids and #Content.Ids <= 1 or Content.bLocked then
    return
  end
  local ItemDatas = {}
  for Index, Id in ipairs(Content.Ids) do
    table.insert(ItemDatas, {
      OriginalIndex = Index,
      ResourceId = Id,
      StuffId = Id,
      StuffType = Content.Type,
      StuffName = GText(ItemUtils.GetItemName(Id, Content.Type)),
      StuffIcon = ItemUtils.GetItemIconPath(Id, Content.Type),
      Rarity = ItemUtils.GetItemRarity(Id, Content.Type),
      HaveCountNumber = ItemUtils.GetItemNum(Id, Content.Type),
      IsCanSelect = true,
      StuffCount = Content.Count
    })
  end
  local SelectContext = {
    Content = Content,
    EventId = Content.EventId,
    Number = Content.Number,
    OriginalSelectedIndex = Content.SelectedIndex,
    SelectedId = Content.Id,
    SelectedIndex = Content.SelectedIndex,
    Owner = Content.OnSetSelectableReward and Content.OnSetSelectableReward[1]
  }
  local ConfirmSelectItem = self.ConfirmSelectItem
  UIManager(self):ShowCommonPopupUI(100335, {
    ParentWidget = self,
    AutoFocus = true,
    IsLimitedPrizePool = true,
    Title = GText("UI_LimitedPrizePool_SelecteTitle"),
    OptionalItemsList = ItemDatas,
    SelectedIndex = Content.SelectedIndex,
    FunctionCallbackObj = SelectContext,
    ChooseCallbackFunction = self.SelectItem,
    RightCallbackFunction = function(_, Result, PopUI)
      ConfirmSelectItem(SelectContext, Result, PopUI)
    end,
    RightGamepadImg = EKeys.A.KeyName,
    RightGamepadKey = Const.GamepadFaceButtonBottom,
    RestoreSelectIndex = RestoreIndex
  })
end

function M:SelectItem(Item)
  self.SelectedId = Item.ResourceId
  self.SelectedIndex = Item.OriginalIndex
end

function M:ConfirmSelectItem(Result, PopUI)
  if not self.SelectedIndex or self.OriginalSelectedIndex == self.SelectedIndex then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(Ret)
    if not ErrorCode:Check(Ret) then
      return
    end
    local Content
    if IsValid(self.Owner) and IsValid(self.Owner.Rewards) then
      Content = self.Owner.Rewards:GetItemAt(self.Number - 1)
    end
    if not IsValid(Content) and IsValid(self.Content) then
      Content = self.Content
    end
    if not IsValid(Content) then
      return
    end
    Content.Id = self.SelectedId
    Content.SelectedIndex = self.SelectedIndex
    if IsValid(Content.Entry) then
      Content.Entry:Refresh()
    elseif Content.OnSetSelectableReward and Content.OnSetSelectableReward[1] and Content.OnSetSelectableReward[2] then
      Content.OnSetSelectableReward[2](Content.OnSetSelectableReward[1])
    end
    DecreaseLimitedPrizeRewardSelectReddot(self.Number)
  end
  
  Avatar:SetLimitPrizeSelfSelect(Callback, self.EventId, self.Number, self.SelectedIndex)
end

function M:SetSelectedItem(ItemData)
  self.RedDot:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.RewardSwitcher:SetActiveWidgetIndex(1)
  self.RewardTipSwitcher:SetActiveWidgetIndex(1)
  self.Item:Init({
    Id = ItemData.Id,
    ItemType = ItemData.Type,
    Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type),
    Rarity = ItemUtils.GetItemRarity(ItemData.Id, ItemData.Type),
    Count = ItemData.Count,
    IsShowDetails = true,
    HandleMouseDown = true,
    OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.ItemMenuAnchorChanged
    }
  })
  if self.Content.OnSetSelectableReward and self.Content.OnSetSelectableReward[1] and self.Content.OnSetSelectableReward[2] then
    self.Content.OnSetSelectableReward[2](self.Content.OnSetSelectableReward[1])
  end
end

function M:TryPromptSelectableReward()
  if self.Content.Id then
    return
  end
  self:PlayAnimation(self.PromptSelectableAnimation)
end

function M:PlayGachaInAnimation()
  if self.Choose_In then
    self:PlayAnimation(self.Choose_In)
  end
end

function M:PlayGachaOutAnimation()
  if self.Choose_Out then
    self:PlayAnimation(self.Choose_Out)
  end
end

function M:PlayGachaGetAnimation(CallbackFunc)
  if self.Get then
    self.GachaGetCallbackFunc = CallbackFunc
    self:UnbindAllFromAnimationFinished(self.Get)
    self:BindToAnimationFinished(self.Get, {
      self,
      self.OnGachaGetAnimationFinished
    })
    self:PlayAnimation(self.Get)
  elseif CallbackFunc then
    CallbackFunc()
  end
end

function M:OnGachaGetAnimationFinished()
  if self.Get then
    self:UnbindAllFromAnimationFinished(self.Get)
  end
  if self.GachaGetCallbackFunc then
    local CallbackFunc = self.GachaGetCallbackFunc
    self.GachaGetCallbackFunc = nil
    CallbackFunc()
  end
end

function M:RestoreSelectWidget()
  self:OpenSelectWidget(self.SelectWidgetChooseIndex)
end

function M:TryDecreaseLimitedPrizeRewardSelectReddot(Index)
  DecreaseLimitedPrizeRewardSelectReddot(Index)
end

function M:ItemMenuAnchorChanged(IsOpen)
  if self.Content.OnMenuOpenChangedEvent and self.Content.OnMenuOpenChangedEvent[1] and self.Content.OnMenuOpenChangedEvent[2] then
    self.Content.OnMenuOpenChangedEvent[2](self.Content.OnMenuOpenChangedEvent[1], IsOpen)
  end
end

function M:OnHovered()
  if not self.Content or self.Content.Ids and #self.Content.Ids <= 1 or self.Content.bLocked then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Add_Hover)
end

function M:OnUnhovered()
  if not self.Content or self.Content.Ids and #self.Content.Ids <= 1 or self.Content.bLocked then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Add_UnHover)
end

function M:OnClicked()
  if not self.Content or self.Content.Ids and #self.Content.Ids <= 1 or self.Content.bLocked then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  self:StopAllAnimations()
  self:PlayAnimation(self.Add_Click)
  self:OpenSelectWidget()
end

function M:OnPressed()
  if not self.Content or self.Content.Ids and #self.Content.Ids <= 1 or self.Content.bLocked then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Add_Press)
end

function M:OnReleased()
  if not self.Content or self.Content.Ids and #self.Content.Ids <= 1 or self.Content.bLocked then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Add_Normal)
end

return M
