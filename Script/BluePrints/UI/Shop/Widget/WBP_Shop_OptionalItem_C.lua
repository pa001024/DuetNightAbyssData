require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ResourceUseEffectDispatcher = require("BluePrints.UI.Common.ResourceUse.ResourceUseEffectDispatcher")
local ResourceUseConsumeCommit = require("BluePrints.UI.Common.ResourceUse.ResourceUseConsumeCommit")

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.ItemCount = Content.Count or 1
  self.ResourceId = Content.ResourceId
  self.ParentWidget = Content.ParentWidget
  if Content.AfterInitCallback then
    Content.AfterInitCallback(self)
  end
  self:InitData()
end

function M:InitData()
  local ResourceData = DataMgr.Resource[self.ResourceId]
  if not ResourceData then
    self.Item_Optional:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Text_Item:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Open:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local ItemContent = {
    Id = self.ResourceId,
    ItemType = "Resource",
    Rarity = ResourceData.Rarity,
    Icon = ResourceData.Icon,
    Count = self.ItemCount,
    IsShowDetails = true,
    NotInteractive = false,
    Type = "Resource",
    HandleMouseDown = true,
    bIsResetFocus = true,
    bNotShowAccess = true,
    OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnMenuOpenChange
    }
  }
  self.Item_Optional:Init(ItemContent)
  self.Text_Item:SetText(GText(ResourceData.ResourceName))
  self.Btn_Open:SetGamepadIconVisibility(false)
  if self:HasAnyFocus() or self:HasAnyUserFocus() then
    self.Btn_Open:SetGamepadIconVisibility(true)
  end
  self.Btn_Open:SetText(GText("UI_OptOpen_Open"))
  self.Btn_Open:BindEventOnClicked(self, function()
    self:OnBtnOpenClicked()
  end)
end

function M:OnBtnOpenClicked()
  if self.ParentWidget and self.ParentWidget.Owner and self.ParentWidget.Owner.OnCloseBtnClicked then
    self.ParentWidget.Owner:OnCloseBtnClicked()
  end
  self:OnClickGoToUseConsume(self.ResourceId)
end

function M:OnBtnCheckClicked()
  self.Item_Optional:SetSelected(true)
end

function M:OnClickGoToUseConsume(ResourceId)
  local ParentWidgetRef = self.ParentWidget
  local OptRewardsRef = ParentWidgetRef and ParentWidgetRef.OptRewards or nil
  local StuffConfigData = DataMgr.Resource[ResourceId]
  
  local function OpenCallback(OnCloseCallbackObj, Data, IsUseOpt)
    local Count = 0
    if Data then
      for k, v in pairs(Data) do
        Count = v.Count or 0
      end
    elseif IsUseOpt then
      Count = 1
    end
    if type(OptRewardsRef) ~= "table" then
      return
    end
    local HasRemaining = false
    for _, RewardInfo in pairs(OptRewardsRef) do
      if RewardInfo.ResourceId == ResourceId then
        RewardInfo.Count = math.max((RewardInfo.Count or 0) - Count, 0)
        break
      end
    end
    for _, RewardInfo in pairs(OptRewardsRef) do
      if RewardInfo.Count > 0 then
        HasRemaining = true
        break
      end
    end
    for i = #OptRewardsRef, 1, -1 do
      if (OptRewardsRef[i].Count or 0) <= 0 then
        table.remove(OptRewardsRef, i)
      end
    end
    if HasRemaining then
      if not IsValid(self) then
        return
      end
      local Params = {}
      Params.ParentWidget = ParentWidgetRef
      Params.OptRewards = OptRewardsRef
      UIManager(self):ShowCommonPopupUI(100347, Params, self)
    end
  end
  
  ResourceUseEffectDispatcher.TryHandle(self, StuffConfigData, {OnClose = OpenCallback})
end

function M:TryToChooseConsumableItems(CurrentChooseInfo)
  self.CurrentChooseInfo = CurrentChooseInfo
end

function M:ConfirmDealWithConsumableItems(UseEffectType, UseParam, OpenCallback)
  local Extra
  if OpenCallback then
    Extra = {
      GetItemCloseCallback = function()
        if not IsValid(self) then
          return
        end
        OpenCallback(self, nil, true)
      end
    }
  end
  ResourceUseConsumeCommit.Items(self, UseEffectType, UseParam, Extra)
end

function M:ConfirmDealWithConsumableResource(UseEffectType)
  local PlayerAvatar = GWorld:GetAvatar()
  if nil == PlayerAvatar then
    DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
    return
  end
  if nil == self.CurrentChooseInfo then
    DebugPrint("ConfirmDealWithConsumableItems error, CurrentChooseInfo is nil")
    return
  end
  DebugPrint("Now ConfirmDealWithConsumableItems The ChooseId is ", self.CurrentChooseInfo.ChooseId)
  local ResourceId, OptionalId, OptIdxList, OptionalList = nil, nil, nil, {}
  if type(self.CurrentChooseInfo) == "table" and "SelectResource" == UseEffectType then
    local k, v = next(self.CurrentChooseInfo)
    ResourceId, OptionalId = v.ResourceId, v.OptionalId
    OptIdxList = {}
    for k, v in pairs(self.CurrentChooseInfo) do
      local ConsumeCount = v.ConsumeCount or 0
      if ConsumeCount > 0 then
        OptIdxList[v.ChooseIndex] = (OptIdxList[v.ChooseIndex] or 0) + ConsumeCount
      end
      OptionalList[v.ChooseId] = ConsumeCount
    end
  else
    ResourceId, OptionalId = self.CurrentChooseInfo.ResourceId, self.CurrentChooseInfo.OptionalId
    if "table" == type(self.CurrentChooseInfo.ChooseIndex) then
      OptIdxList = self.CurrentChooseInfo.ChooseIndex
    else
      OptIdxList = {
        [self.CurrentChooseInfo.ChooseIndex] = 1
      }
    end
  end
  
  local function DealWithConsumableItemsCallback()
    if not IsValid(self) then
      return
    end
    local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
    local AllRewards = {
      Resources = {}
    }
    for k, v in pairs(OptionalItemsDataConfig.Id) do
      if OptionalList[v] and OptionalList[v] > 0 then
        AllRewards.Resources[v] = OptionalList[v] * OptionalItemsDataConfig.Count[k]
      end
    end
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, AllRewards, nil, self, true)
  end
  
  PlayerAvatar:UseOptResourceInBag(ResourceId, OptIdxList, DealWithConsumableItemsCallback)
  self.CurrentChooseInfo = nil
end

function M:ConfirmDealWithConsumableRandomBox()
  local PlayerAvatar = GWorld:GetAvatar()
  if nil == PlayerAvatar then
    DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
    return
  end
  local ResourceId = self.CurrentChooseInfo.ResourceId
  local ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
  
  local function DealWithConsumableItemsCallback(RewardInfo)
    if not IsValid(self) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardInfo, false, function()
    end, self, false)
  end
  
  PlayerAvatar:UseResourceInBag(ResourceId, ConsumeCount, DealWithConsumableItemsCallback)
  self.CurrentChooseInfo = nil
end

function M:ConfirmDealWithConsumablePacks(UseEffectType)
  local PlayerAvatar = GWorld:GetAvatar()
  if nil == PlayerAvatar then
    DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
    return
  end
  local ResourceId = self.CurrentChooseInfo.ResourceId
  local OptionalId = self.CurrentChooseInfo.OptionalId
  local ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
  
  local function DealWithConsumableItemsCallback()
    if not IsValid(self) then
      return
    end
    local OptionalItemsDataConfig = DataMgr.Reward[OptionalId]
    local Count = self.ConsumeCount
    local ResourcePackChooseId = OptionalItemsDataConfig.Id
    local AllRewards = {
      Resources = {}
    }
    for k, v in pairs(OptionalItemsDataConfig.Id) do
      AllRewards.Resources[v] = OptionalItemsDataConfig.Count[k][1] * Count
    end
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, AllRewards, nil, self, true)
  end
  
  PlayerAvatar:UseResourceInBag(ResourceId, ConsumeCount, DealWithConsumableItemsCallback)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
  if CurInputDevice == ECommonInputType.Gamepad then
    self.Btn_Open:SetGamepadIconVisibility(true)
    self.Item_Optional:SetSelected(true)
  end
  return true
end

function M:OnFocusLost(InFocusEvent)
  self.Btn_Open:SetGamepadIconVisibility(false)
  self.Item_Optional:SetSelected(false)
end

function M:OnMenuOpenChange(bIsOpen)
  self.ParentWidget:OnMenuOpenChange(bIsOpen)
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
  if CurInputDevice == ECommonInputType.Gamepad then
    self:StopAllAnimations()
    if self.Hover then
      self:PlayAnimation(self.Hover)
    end
  end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
  if CurInputDevice == ECommonInputType.Gamepad then
    self:StopAllAnimations()
    if self.Hover then
      self:PlayAnimationReverse(self.Hover)
    end
    self:PlayAnimation(self.Normal)
  end
end

return M
