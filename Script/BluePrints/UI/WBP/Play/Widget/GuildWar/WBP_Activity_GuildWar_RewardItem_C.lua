require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.List_Reward.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self:AddInputMethodChangedListen()
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Parent = Content.Parent
  self.IsEmpty = Content.IsEmpty
  if not self.IsEmpty then
    self.RankPercent = Content.RankPercent
    self.RankName = Content.RankName
    self.RankReward = Content.RankReward
  end
  self:InitItemContent()
end

function M:InitItemContent()
  self.Text_Ranking:SetText(self.RankPercent)
  local RankIcon = self["Rank_" .. self.RankName]
  if RankIcon then
    self.Icon_Rank:SetBrush(RankIcon)
  end
  local Bg = self["BG_" .. self.RankName]
  if Bg then
    self.BG:SetBrush(Bg)
  end
  self:RefreshRewardInfoList(self.RankReward)
  self.BG_Text:SetColorAndOpacity(self["Color_0" .. self.RankName])
end

function M:RefreshRewardInfoList(RankRewardID)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Rewards = DataMgr.Reward[RankRewardID]
  if Rewards then
    self.RewardList = {}
    local RewardIds = Rewards.Id
    local RewardCounts = Rewards.Count
    local RewardTypes = Rewards.Type
    for i = 1, #RewardIds do
      local ItemId = RewardIds[i]
      local Count = RewardUtils:GetCount(RewardCounts[i])
      local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
      local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
      local ItemType = RewardTypes[i]
      local RewardContent = {
        Id = ItemId,
        Type = ItemType,
        ItemCount = Count,
        Icon = Icon,
        Rarity = Rarity
      }
      table.insert(self.RewardList, RewardContent)
    end
    self.List_Reward:ClearListItems()
    for _, ItemInfo in pairs(self.RewardList) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = ItemInfo.Id
      Content.Icon = ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
      Content.ParentWidget = self
      Content.ItemType = ItemInfo.Type
      Content.Count = ItemInfo.ItemCount
      Content.Rarity = ItemInfo.Rarity or 1
      Content.IsShowDetails = true
      if ItemInfo.Quantity then
        Content.Count = ItemInfo.Quantity[1]
        Content.MaxCount = ItemInfo.Quantity[2] or nil
      end
      self.List_Reward:AddItem(Content)
    end
  end
  if self:IsExistTimer(self.NextFrameListEmpty) then
    self:RemoveTimer(self.NextFrameListEmpty)
  end
  self.NextFrameListEmpty = self:AddTimer(0.01, function()
    local len = self.List_Reward:GetNumItems()
    for i = 1, len do
      local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, i - 1)
      if entryWidget then
        entryWidget:BindEvents(self, {
          OnMenuOpenChanged = self.OnStuffMenuOpenChanged
        })
      end
    end
    self.List_Reward:RequestFillEmptyContent()
  end, false, 0, "GuildWar_RewardItem")
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if bIsOpen then
    self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = 0
  return Content
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_LeftThumbstick" == InKeyName then
    local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
    if not RewardItemUIs[1]:HasAnyUserFocus() then
      self.List_Reward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.List_Reward:NavigateToIndex(0)
      self:UpdatKeyDisplay("RewardWidget")
      IsEventHandled = true
    else
      self:SetFocus()
      self:UpdatKeyDisplay("SelfWidget")
      self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
      IsEventHandled = true
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    local RewardItemUIs = self.List_Reward:GetDisplayedEntryWidgets()
    for i = 1, RewardItemUIs:Length() do
      if RewardItemUIs[i]:HasAnyUserFocus() then
        self:SetFocus()
        self:UpdatKeyDisplay("SelfWidget")
        self.List_Reward:SetVisibility(ESlateVisibility.HitTestInvisible)
        IsEventHandled = true
        break
      end
    end
    if not IsEventHandled then
      self.Parent:OnReturnKeyDown()
      IsEventHandled = true
    end
  end
  return IsEventHandled
end

function M:UpdatKeyDisplay(FocusTypeName)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if "RewardWidget" == FocusTypeName then
    self.Parent.Key_Check:SetVisibility(ESlateVisibility.Collapsed)
    self.Parent.Key_CheckReward:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Parent.Key_CheckReward:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
  elseif "SelfWidget" == FocusTypeName then
    self.Parent.Key_CheckReward:SetVisibility(ESlateVisibility.Collapsed)
    self.Parent.Key_Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Parent.Key_Check:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_Check")
    })
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Parent.WBox_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    self:UpdatKeyDisplay("SelfWidget")
  else
  end
end

return M
