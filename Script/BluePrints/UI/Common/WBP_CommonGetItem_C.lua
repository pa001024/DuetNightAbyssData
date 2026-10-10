require("UnLua")
local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local M = Class("BluePrints.UI.BP_UIState_C")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ResourceUseEffectDispatcher = require("BluePrints.UI.Common.ResourceUse.ResourceUseEffectDispatcher")
local ResourceUseConsumeCommit = require("BluePrints.UI.Common.ResourceUse.ResourceUseConsumeCommit")

function M:Construct()
  self.List_Item.BP_OnEntryGenerated:Add(self, self.OnItemListEntryGenerated)
  self.List_Item_Single.BP_OnEntryGenerated:Add(self, self.OnItemListEntryGenerated)
end

function M:OnItemListEntryGenerated(Widget)
  if Widget._MostRarityFX and self:IsAnimationPlaying(self.In) then
    Widget:_SetMostRarityFX(0)
  end
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  if not self.bSpecial then
    AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items_high_level", nil, nil)
  end
  self:PlayAnimation(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      if self.NowList then
        for _, Entry in pairs(self.NowList:GetDisplayedEntryWidgets()) do
          Entry:_SetMostRarityFX(Entry.Rarity)
        end
      end
    end
  })
  self.Text_GetItem:SetText(GText("UI_COMMONPOP_TITLE_100017"))
  self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))
  local ShopItemType, ShopItemId, Count, PurchaseRewards, func, ParentWidget, IsReAttachFocusToPage, ToastText, GotoCallback = ...
  self.GotoCallback = GotoCallback
  if -1 == func then
    func = nil
  end
  if -1 == ParentWidget then
    ParentWidget = nil
  end
  if func then
    self:BindActionOnClosed(func, ParentWidget)
  end
  if IsReAttachFocusToPage then
    self:AddTimer(0.5, self.DelayToCheckIsFocusOnReward)
  end
  self.RewardList = {}
  self:AddTimer(self.InTime, function()
    self:InitGetItemInfo(ShopItemType, ShopItemId, Count, PurchaseRewards)
  end, false, 0, nil, true)
  self.IsShowDetails = false
  if ToastText then
    self.Toast_GetItem.Text_Toast:SetText(ToastText)
    self.Toast_GetItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Toast_GetItem:SetVisibility(ESlateVisibility.Collapsed)
  end
  if GotoCallback and self.Btn_Goto then
    self.Btn_Goto:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Goto:SetText(GText("Enter_Now"))
    self.Btn_Goto:SetGamePadImg("Y")
    self.Btn_Goto:BindEventOnClicked(self, self.GotoButtonClicked)
    self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    self.ForbidCloseByGotoBtn = true
  elseif not GotoCallback and self.Btn_Goto then
    self.Btn_Goto:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ForbidCloseByGotoBtn = false
  end
end

function M:InitGetItemInfo(ShopItemType, ShopItemId, Count, PurchaseRewards)
  self.List_Item:ClearListItems()
  self.List_Item_Single:ClearListItems()
  self.BonusInfo = PurchaseRewards and PurchaseRewards.BonusInfo or nil
  if PurchaseRewards then
    local RewardType = DataMgr.RewardType
    for ItemType, _ in pairs(RewardType) do
      local Rewards = PurchaseRewards[ItemType .. "s"]
      if Rewards then
        local RewardInfo = DataMgr[ItemType]
        for ItemId, ItemCount in pairs(Rewards) do
          local count = 0
          if type(ItemCount) == "table" then
            count = RewardBox:GetCount(ItemCount)
          end
          if type(ItemCount) == "number" then
            count = ItemCount
          end
          self.RewardList[string.format("%s,%s", ItemType, ItemId)] = {
            TableName = ItemType,
            ItemCount = count,
            Rarity = RewardInfo[ItemId].Rarity or RewardInfo[ItemId][ItemType .. "Rarity"]
          }
        end
      end
    end
    self.RewardInfoList = {}
    for key, Value in pairs(self.RewardList) do
      local ItemId = tonumber(string.split(key, ",")[2])
      table.insert(self.RewardInfoList, {ItemId = ItemId, ItemInfo = Value})
    end
    table.sort(self.RewardInfoList, function(A, B)
      local RarityA = A.ItemInfo.Rarity or 1
      local RarityB = B.ItemInfo.Rarity or 1
      if RarityA > RarityB then
        return true
      elseif RarityA == RarityB then
        return A.ItemId < B.ItemId
      else
        return false
      end
    end)
    local PetRewardInfos = PurchaseRewards.PetRewardInfos or {}
    local PetRewardsForSort = {}
    for i, PetRewardInfo in ipairs(PetRewardInfos) do
      local PetData = DataMgr.Pet[PetRewardInfo.PetId]
      PetRewardsForSort[i] = {
        OriginalIndex = i,
        PetRewardInfo = PetRewardInfo,
        SortPriority = PetData and PetData.SortPriority or 0,
        PetData = PetData
      }
    end
    table.sort(PetRewardsForSort, function(A, B)
      if A.SortPriority ~= B.SortPriority then
        return A.SortPriority > B.SortPriority
      end
      return A.OriginalIndex < B.OriginalIndex
    end)
    for _, Entry in ipairs(PetRewardsForSort) do
      if Entry.PetData then
        table.insert(self.RewardInfoList, {
          ItemId = Entry.PetRewardInfo.PetId,
          ItemInfo = {
            TableName = CommonConst.DataType.Pet,
            PetRewardInfo = Entry.PetRewardInfo
          }
        })
      else
        DebugPrint(ErrorTag, "WBP_CommonGetItem invalid Pet reward", Entry.PetRewardInfo.PetId)
      end
    end
    if #self.RewardInfoList > 7 then
      self.WS_List:SetActiveWidgetIndex(0)
      for _, Value in ipairs(self.RewardInfoList) do
        local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
        local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount, ItemInfo.PetRewardInfo)
        self.List_Item:AddItem(Content)
      end
      self.NowList = self.List_Item
    else
      self.WS_List:SetActiveWidgetIndex(1)
      for _, Value in ipairs(self.RewardInfoList) do
        local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
        local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount, ItemInfo.PetRewardInfo)
        self.List_Item_Single:AddItem(Content)
      end
      self.NowList = self.List_Item_Single
    end
  else
    if nil ~= ShopItemType and -1 ~= ShopItemType then
      self.WS_List:SetActiveWidgetIndex(1)
      local Content = self:NewItemContent(ShopItemType, ShopItemId, Count)
      self.List_Item_Single:AddItem(Content)
    end
    self.NowList = self.List_Item_Single
  end
  self:InitHandleKeyInfo()
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:OnUpdateUIStyleByInputTypeChange(self.CurInputDeviceType, self.CurGamepadName)
  self:InitOptRewardsInfo()
end

function M:SetDefaultFocus()
  if self.RewardInfoList and #self.RewardInfoList > 7 then
    self.List_Item:SetFocus()
  else
    self.List_Item_Single:SetFocus()
  end
end

function M:DelayToCheckIsFocusOnReward()
  if not self:HasAnyFocus() then
    self:SetDefaultFocus()
  end
end

function M:InitListItem(ContainerWidget, Item, Content, bNewItem)
  if bNewItem then
    ContainerWidget:AddChild(Item)
  end
  Item:Init(Content)
  local Events = {}
  Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
  Item:BindEvents(self, Events)
end

function M:ItemMenuAnchorChanged(bIsOpen)
  self.IsShowDetails = bIsOpen
  if bIsOpen then
    self.bCantClose = bIsOpen
  end
  self:RefreshGotoGamepadIconVisible()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    if not self.IsShowDetails then
      self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
    else
      self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
end

function M:InitOptRewardsInfo()
  local OptRewards = {}
  local OptCount = 0
  for key, Info in pairs(self.RewardList) do
    local ItemId = tonumber(string.split(key, ",")[2])
    local ResourceInfo = DataMgr.Resource[ItemId]
    if ResourceInfo and 7 == ResourceInfo.MaterialClassify then
      table.insert(OptRewards, {
        ResourceId = ItemId,
        Count = Info.ItemCount or 1
      })
      OptCount = OptCount + 1
    end
  end
  local BagMain = UIManager(self):GetUI("BagMain")
  if BagMain then
    OptCount = 0
  end
  if 0 ~= OptCount and self.Gruop_OptionalBtn and self.Btn_Confirm and self.Btn_Open then
    self.IsOptRewardsView = true
    self.Gruop_OptionalBtn:SetVisibility(ESlateVisibility.Visible)
    self.NotShowTextTip = true
    self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    self.Button_Close:SetIsEnabled(false)
    self.Btn_Confirm:SetText(GText("UI_OptOpen_Confirm"))
    self.Btn_Confirm:SetGamePadImg("X")
    self.Btn_Confirm:BindEventOnClicked(self, function()
      self:CloseSelf()
    end)
    self:InitOptRewardHandleKeyInfo()
    self.Btn_Open:SetText(GText("UI_OptOpen_OpenNow"))
    self.Btn_Open:SetGamePadImg("Y")
    if 1 == OptCount then
      self.Btn_Open:BindEventOnClicked(self, function()
        if self.bCantClose then
          self.bCantClose = false
        end
        self:CloseSelf()
        self:OnClickGoToUseConsume(OptRewards[1].ResourceId)
      end)
    else
      self.Btn_Open:BindEventOnClicked(self, function()
        if self.bCantClose then
          self.bCantClose = false
        end
        self:CloseSelf()
        local Params = {}
        Params.ParentWidget = self
        Params.OptRewards = OptRewards
        Params.AutoFocus = true
        UIManager(self):ShowCommonPopupUI(100347, Params, self)
      end)
    end
  else
    self.IsOptRewardsView = false
    self.Button_Close:SetIsEnabled(true)
    if self.Gruop_OptionalBtn then
      self.Gruop_OptionalBtn:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.NotShowTextTip = false
    self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:OnClickGoToUseConsume(ResourceId)
  local StuffConfigData = DataMgr.Resource[ResourceId]
  ResourceUseEffectDispatcher.TryHandle(self, StuffConfigData)
end

function M:TryToChooseConsumableItems(CurrentChooseInfo)
  self.CurrentChooseInfo = CurrentChooseInfo
end

function M:ConfirmDealWithConsumableItems(UseEffectType, UseParam)
  ResourceUseConsumeCommit.Items(self, UseEffectType, UseParam)
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

function M:BP_GetDesiredFocusTarget()
  if self.RewardInfoList and #self.RewardInfoList > 7 then
    return self.List_Item
  else
    return self.List_Item_Single
  end
end

function M:InitHandleKeyInfo()
  self.Panel_Key:ClearChildren()
  local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
  local Item2 = self:CreateWidgetNew("ComKeyTextDesc")
  local Item3 = self:CreateWidgetNew("ComKeyTextDesc")
  Item1:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LH"}
    },
    Desc = GText("UI_Controller_Switch")
  })
  Item2:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_DETAILS")
  })
  Item3:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
  if self.RewardInfoList and #self.RewardInfoList > 1 then
    self.Panel_Key:AddChild(Item1)
  end
  self.Panel_Key:AddChild(Item2)
  if not self.GotoCallback then
    self.Panel_Key:AddChild(Item3)
  end
end

function M:InitOptRewardHandleKeyInfo()
  self.Panel_Key:ClearChildren()
  local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
  Item1:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    },
    Desc = GText("UI_DETAILS")
  })
  self.Panel_Key:AddChild(Item1)
end

function M:NewItemContent(ItemType, ItemId, Count, PetRewardInfo)
  local ItemData = DataMgr[ItemType][ItemId]
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  if "UpgradeMod" == ItemType then
    ItemType = "Mod"
    ItemId = ItemData.ModId
    Obj.ModLevel = ItemData.ModLevel
    Obj.StartLevelNum = ItemData.ModLevel
  end
  Obj.ItemType = ItemType
  Obj.Id = ItemId
  if PetRewardInfo then
    Obj.Type = CommonConst.ArmoryType.Pet
    Obj.PetEntry = PetRewardInfo.EntryIds
    Obj.BreakNum = 0
  end
  local Name
  if "Draft" == ItemType then
    local ProductData = DataMgr[ItemData.ProductType][ItemData.ProductId]
    Name = GText("UI_FORGING_BLUEPRINT") .. GText(ProductData[ItemData.ProductType .. "Name"] or ProductData.Name)
  else
    Name = ItemUtils:GetDropName(ItemId, ItemType)
  end
  Obj.Count = Count
  Obj.Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)
  if "HeadSculpture" == ItemType then
    Obj.Icon = ItemData.HeadPath
    if not Obj.Icon then
      Obj.Icon = ItemData.DynamicPath
    end
  elseif "HeadFrame" == ItemType then
    Obj.Icon = ItemData.Icon
    if not Obj.Icon then
      Obj.Icon = ItemData.DynamicPath
    end
  else
    Obj.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
  end
  Obj.IsShowDetails = true
  Obj.UIName = "GetItemPage"
  local Bonus = self.BonusInfo and self.BonusInfo[ItemId]
  if Bonus then
    Obj.BonusType = Bonus.BonusType
    Obj.ExtraBonusText = Bonus.ExtraBonusText
  end
  Obj.OnMenuOpenChangedEvents = {
    Obj = self,
    Callback = self.ItemMenuAnchorChanged
  }
  return Obj
end

function M:BindActionOnClosed(func, ParentWidget)
  self.OnClosed = func
  self.ParentWidget = ParentWidget
end

function M:GotoButtonClicked()
  self.ForbidCloseByGotoBtn = false
  self:CloseSelf()
  if self.GotoCallback then
    self.GotoCallback()
  end
end

function M:CloseSelf()
  if self.bCantClose then
    self.bCantClose = false
    return
  end
  if self.ForbidCloseByGotoBtn then
    return
  end
  self:RemoveTimer("InitGetItemInfo")
  if not self.bAnimClose then
    self:AddTimer(0.5, function()
      self.bAnimClose = true
    end, false, 0, nil, true)
    return
  end
  local UIState = UIManager(self):GetLastestAndFocusableUIWidgetObj()
  if UIState then
    UIState:SetFocus()
  end
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self:Close()
    if self.OnClosed then
      if self.ParentWidget ~= nil then
        self.OnClosed(self.ParentWidget)
      else
        self:OnClosed()
      end
    end
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    if self.NotShowTextTip or self.ForbidCloseByGotoBtn then
      self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if IsUseKeyAndMouse then
    self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    if self.NotShowTextTip or self.ForbidCloseByGotoBtn then
      self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  elseif CurInputDevice == ECommonInputType.Gamepad then
    if self:HasAnyFocus() then
      self:SetDefaultFocus()
    end
    if not self.IsShowDetails then
      self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
    else
      self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:RefreshGotoGamepadIconVisible()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:CloseSelf()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName and not self.IsOptRewardsView then
    self:CloseSelf()
    IsEventHandled = true
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if self.GotoCallback then
      self:GotoButtonClicked()
    elseif self.Btn_Open then
      self.Btn_Open:OnBtnClicked()
    end
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnGamePadUp(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Left" == InKeyName and self.IsOptRewardsView then
    self.Btn_Confirm:OnBtnClicked()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:RefreshGotoGamepadIconVisible()
  if not self.GotoCallback or not self.Btn_Goto then
    return
  end
  local bShow = UIUtils.IsGamepadInput() and not self.IsShowDetails
  self.Btn_Goto:SetGamepadIconVisibility(bShow)
end

return M
