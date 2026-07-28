require("UnLua")
local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local M = Class("BluePrints.UI.BP_UIState_C")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")

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
  local ShopItemType, ShopItemId, Count, PurchaseRewards, func, ParentWidget, IsReAttachFocusToPage, ToastText = ...
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
end

function M:InitGetItemInfo(ShopItemType, ShopItemId, Count, PurchaseRewards)
  self.List_Item:ClearListItems()
  self.List_Item_Single:ClearListItems()
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
    if #self.RewardInfoList > 7 then
      self.WS_List:SetActiveWidgetIndex(0)
      for _, Value in pairs(self.RewardInfoList) do
        local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
        local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount)
        self.List_Item:AddItem(Content)
      end
      self.NowList = self.List_Item
    else
      self.WS_List:SetActiveWidgetIndex(1)
      for _, Value in pairs(self.RewardInfoList) do
        local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
        local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount)
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
  if 0 ~= OptCount then
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
  self.CurrentChooseInfo = nil
  local CommonDialogParams = {}
  CommonDialogParams.OptionalItemsList = {}
  local UseEffectType, ExtraString, OptCount = StuffConfigData.UseEffectType, ""
  if UseEffectType then
    local ResultData = {}
    if type(self["GenerateDataWith_" .. UseEffectType]) == "function" then
      ResultData, ExtraString, OptCount = self["GenerateDataWith_" .. UseEffectType](self, StuffConfigData.ResourceId, StuffConfigData.UseParam)
    end
    CommonDialogParams.OptionalItemsList = ResultData
  end
  DebugPrint("ayff test use resourceID:" .. StuffConfigData.ResourceId)
  local CharSkinPreviewTypeList = {
    [CommonConst.ResUseEffectType.SelectGeneralSkin] = "SelectGeneralSkin",
    [CommonConst.ResUseEffectType.SelectCharAccessory] = "SelectCharAccessory",
    [CommonConst.ResUseEffectType.SelectWeaponSkin] = "SelectWeaponSkin",
    [CommonConst.ResUseEffectType.SelectWeaponAccessory] = "SelectWeaponAccessory",
    [CommonConst.ResUseEffectType.SelectSkin] = "SelectSkin",
    [CommonConst.ResUseEffectType.SelectGestureItem] = "SelectGestureItem"
  }
  if CharSkinPreviewTypeList[UseEffectType] then
    UIManager(self):LoadUINew("CharSkinPreview", {
      Type = UseEffectType,
      OptRewardId = StuffConfigData.UseParam,
      ResourceId = StuffConfigData.ResourceId
    })
    return
  end
  CommonDialogParams.Title = GText(StuffConfigData.ResourceName)
  if "ResourcePack" == UseEffectType then
    CommonDialogParams.Tips = {
      string.format(ExtraString, "材料包", 1, 1, 1)
    }
  elseif "SelectResource" == UseEffectType then
    CommonDialogParams.Tips = {
      string.format(ExtraString, GText(StuffConfigData.ResourceName), 0, OptCount, 2)
    }
  else
    CommonDialogParams.Tips = {
      string.format(GText("UI_Consumable_Choose"), ExtraString)
    }
  end
  CommonDialogParams.AutoFocus = true
  CommonDialogParams.DontCloseWhenRightBtnClicked = true
  CommonDialogParams.FunctionCallbackObj = self
  CommonDialogParams.ChooseCallbackFunction = self.TryToChooseConsumableItems
  CommonDialogParams.RightGamepadImg = EKeys.A.KeyName
  CommonDialogParams.RightGamepadKey = Const.GamepadFaceButtonBottom
  CommonDialogParams.ParentWidget = self
  CommonDialogParams.HideItemTips = true
  CommonDialogParams.ResourceId = StuffConfigData.ResourceId
  CommonDialogParams.UseParam = StuffConfigData.UseParam
  
  function CommonDialogParams.RightCallbackFunction(_, FirstData, FirstPopUIWidget)
    local ConfirmParams, TargetStuffName, PopConfirmUIId = {}, "", 100210
    if "SelectWeapon" == UseEffectType then
      if self.CurrentChooseInfo then
        TargetStuffName = self.CurrentChooseInfo.ChooseName
      end
      ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
    elseif "SelectCharacter" == UseEffectType then
      local GradeLevel = 0
      if self.CurrentChooseInfo then
        TargetStuffName = self.CurrentChooseInfo.ChooseName
        GradeLevel = CommonDialogParams.OptionalItemsList[self.CurrentChooseInfo.ChooseIndex].GradeLevel or 0
      end
      local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
      if GradeLevel >= MaxGradeLevel then
        ConfirmParams.ShortText = string.format(GText("UI_Consumable_CardLevel_Max"), TargetStuffName)
      else
        ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
      end
    elseif "SelectPet" == UseEffectType then
      if self.CurrentChooseInfo then
        TargetStuffName = self.CurrentChooseInfo.ChooseName
      end
      ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
    elseif "SelectResource" == UseEffectType then
    elseif "ResourcePack" == UseEffectType then
      self.ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
    elseif "RandomSelectPack" == UseEffectType then
    end
    if "ResourcePack" == UseEffectType then
      FirstPopUIWidget.DontFocusParentWidget = true
      FirstPopUIWidget:RemoveFirstItemInPopupQueue()
      FirstPopUIWidget:OnCloseBtnClicked()
      self:ConfirmDealWithConsumablePacks(UseEffectType)
    elseif "SelectResource" == UseEffectType then
      FirstPopUIWidget.DontFocusParentWidget = true
      FirstPopUIWidget:RemoveFirstItemInPopupQueue()
      FirstPopUIWidget:OnCloseBtnClicked()
      self:ConfirmDealWithConsumableResource(UseEffectType)
    elseif "RandomSelectPack" == UseEffectType then
      FirstPopUIWidget.DontFocusParentWidget = true
      FirstPopUIWidget:RemoveFirstItemInPopupQueue()
      FirstPopUIWidget:OnCloseBtnClicked()
      self:ConfirmDealWithConsumableRandomBox(UseEffectType)
    elseif ConfirmParams.ShortText then
      FirstPopUIWidget.DontFocusParentWidget = true
      ConfirmParams.AutoFocus = true
      
      function ConfirmParams.RightCallbackFunction(_, Data, PopUIWidget)
        PopUIWidget:RemoveFirstItemInPopupQueue()
        self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam)
      end
      
      ConfirmParams.DontFocusParentWidget = true
      UIManager(self):ShowCommonPopupUI_Interrupt(PopConfirmUIId, ConfirmParams, self)
    else
      FirstPopUIWidget.DontFocusParentWidget = false
      self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam)
    end
  end
  
  if "ResourcePack" == UseEffectType then
    UIManager(self):ShowCommonPopupUI(100207, CommonDialogParams, self)
  elseif "SelectResource" == UseEffectType then
    UIManager(self):ShowCommonPopupUI(100208, CommonDialogParams, self)
  elseif "RandomSelectPack" == UseEffectType then
    UIManager(self):ShowCommonPopupUI(100343, CommonDialogParams, self)
  else
    UIManager(self):ShowCommonPopupUI(100209, CommonDialogParams, self)
  end
end

function M:TryToChooseConsumableItems(CurrentChooseInfo)
  self.CurrentChooseInfo = CurrentChooseInfo
end

function M:ConfirmDealWithConsumableItems(UseEffectType, UseParam)
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
  local ResourceId, OptionalId, OptIdxList, bIsNew = nil, nil, nil, true
  ResourceId, OptionalId = self.CurrentChooseInfo.ResourceId, self.CurrentChooseInfo.OptionalId
  local OptIndex = 1
  for Index, Id in pairs(DataMgr.OptReward[UseParam].Id) do
    if Id == self.CurrentChooseInfo.ChooseId then
      OptIndex = Index
      break
    end
  end
  OptIdxList = {OptIndex}
  if "SelectCharacter" == UseEffectType then
    bIsNew = not PlayerAvatar:CheckCharEnough({
      [self.CurrentChooseInfo.ChooseId] = 1
    })
  end
  
  local function DealWithConsumableItemsCallback()
    local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
    if "SelectWeapon" == UseEffectType then
      local WeaponChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if WeaponChooseId then
        UIUtils.ShowGetItemPage(BagCommon.StuffType.Weapon, WeaponChooseId, 1)
      end
    elseif "SelectCharacter" == UseEffectType then
      local CharChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if CharChooseId then
        UIUtils.ShowGetItemPage("Char", CharChooseId, 1, nil, nil, nil, nil, nil, nil, bIsNew)
      end
    elseif "SelectPet" == UseEffectType then
      local PetChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if PetChooseId then
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local SystemUIName = "GetItemPage"
        UIManager:LoadUINew(SystemUIName, BagCommon.OptionalItemType.Pet, PetChooseId, 1, nil, -1, -1)
      end
    end
  end
  
  PlayerAvatar:UseOptResourceInBag(ResourceId, OptIdxList, DealWithConsumableItemsCallback)
  self.CurrentChooseInfo = nil
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
  local ResourceId, OptionalId, OptIdxList, OptionalList, Count = nil, nil, nil, {}, 0
  if type(self.CurrentChooseInfo) == "table" and "SelectResource" == UseEffectType then
    local k, v = next(self.CurrentChooseInfo)
    ResourceId, OptionalId = v.ResourceId, v.OptionalId
    OptIdxList = {}
    for k, v in pairs(self.CurrentChooseInfo) do
      for i = 1, v.ConsumeCount do
        table.insert(OptIdxList, v.ChooseIndex)
        Count = Count + 1
      end
      OptionalList[v.ChooseId] = v.ConsumeCount
    end
  else
    ResourceId, OptionalId = self.CurrentChooseInfo.ResourceId, self.CurrentChooseInfo.OptionalId
    if "table" == type(self.CurrentChooseInfo.ChooseIndex) then
      OptIdxList = self.CurrentChooseInfo.ChooseIndex
    else
      OptIdxList = {
        self.CurrentChooseInfo.ChooseIndex
      }
    end
  end
  
  local function DealWithConsumableItemsCallback()
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

function M:GenerateDataWith_SelectWeapon(ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    DebugPrint("GenerateDataWith_SelectWeapon Avatar is nil, Not Connect to Server")
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Weapons) do
        if StuffServerData.WeaponId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.GradeLevel > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.GradeLevel
            RewardObject.IsMaxGradeLevel = DataMgr.WeaponCardLevel[value].CardLevelMax == StuffServerData.GradeLevel
          end
        end
      end
      local WeaponConfigData = DataMgr.Weapon[value]
      local BattleWeaponInfo, AttributeIcon = DataMgr.BattleWeapon[value]
      if BattleWeaponInfo then
        for _, Tag in pairs(BattleWeaponInfo.WeaponTag) do
          local TagInfo = DataMgr.WeaponTag[Tag]
          if TagInfo and TagInfo.WeaponTagfilter and TagInfo.Icon then
            AttributeIcon = TagInfo.Icon
            break
          end
        end
      end
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = WeaponConfigData.Icon
      RewardObject.StuffName = GText(WeaponConfigData.WeaponName)
      RewardObject.StuffType = BagCommon.OptionalItemType.Weapon
      RewardObject.Rarity = WeaponConfigData.WeaponRarity or 1
      RewardObject.AttrIcon = AttributeIcon
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = self
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_SHOP_SUBTAB_NAME_WEAPON")
end

function M:GenerateDataWith_SelectCharacter(ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Chars or {}) do
        if StuffServerData.CharId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.GradeLevel > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.GradeLevel
          end
          local CharPieceId = DataMgr.Char[value].CharPieceId
          RewardObject.Count = Avatar:GetResourceNum(CharPieceId)
        end
      end
      local CharacterConfigData = DataMgr.Char[value]
      local BattleCharInfo, AttributeIcon = DataMgr.BattleChar[value]
      if BattleCharInfo then
        local Attribute = BattleCharInfo.Attribute
        AttributeIcon = DataMgr.Attribute[Attribute] and DataMgr.Attribute[Attribute].Icon
      end
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = CharacterConfigData.Icon
      RewardObject.StuffName = GText(CharacterConfigData.CharName)
      RewardObject.StuffType = BagCommon.OptionalItemType.Avatar
      RewardObject.Rarity = CharacterConfigData.CharRarity
      RewardObject.AttrIcon = AttributeIcon
      RewardObject.Attribute = BattleCharInfo.Attribute
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = self
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_Armory_Char")
end

function M:GenerateDataWith_SelectPet(ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Pets or {}) do
        if StuffServerData.PetId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
          if nil == RewardObject.GradeLevel or StuffServerData.BreakNum > RewardObject.GradeLevel then
            RewardObject.GradeLevel = StuffServerData.BreakNum
          end
        end
      end
      local PetConfigData = DataMgr.Pet[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.Premium = PetConfigData.Premium
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = PetConfigData.Icon
      RewardObject.StuffName = GText(PetConfigData.Name)
      RewardObject.StuffType = BagCommon.OptionalItemType.Pet
      RewardObject.Rarity = PetConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = self
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("MAIN_UI_PET")
end

function M:GenerateDataWith_SelectResource(ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.OptReward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    OptCount = Avatar.Resources[ResourceId].Count
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
        if StuffServerData.ResourceId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
        end
      end
      local ResourceConfigData = DataMgr.Resource[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffCount = Avatar.Resources[value] and Avatar.Resources[value].Count or 0
      RewardObject.StuffIcon = ResourceConfigData.Icon
      RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
      RewardObject.StuffType = "SelectResource"
      RewardObject.Rarity = ResourceConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = self
      RewardObject.Count = OptionalItemsDataConfig.Count[index]
      RewardObject.OptCount = OptCount
      table.insert(ResultData, RewardObject)
    end
  end
  return ResultData, GText("UI_Consumable_Effect_ResourcePack"), OptCount
end

function M:GenerateDataWith_ResourcePack(ResourceId, UseParam)
  local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.Reward[UseParam]
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return ResultData
  end
  if OptionalItemsDataConfig then
    OptCount = Avatar.Resources[ResourceId].Count
    for index, value in ipairs(OptionalItemsDataConfig.Id) do
      local RewardObject = {}
      RewardObject.HaveCountNumber = 0
      for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
        if StuffServerData.ResourceId == value then
          RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
        end
      end
      local ResourceConfigData = DataMgr.Resource[value]
      RewardObject.ResourceId = ResourceId
      RewardObject.OptionalId = UseParam
      RewardObject.StuffId = value
      RewardObject.StuffIcon = ResourceConfigData.Icon
      RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
      RewardObject.StuffType = "ResourcePack"
      RewardObject.Rarity = ResourceConfigData.Rarity or 1
      RewardObject.UIName = BagCommon.MainUIName
      RewardObject.ParentWidget = self
      RewardObject.Count = OptionalItemsDataConfig.Count[index][1] or 1
      RewardObject.OptCount = OptCount
      table.insert(ResultData, RewardObject)
    end
  end
  local ResourcePackText = GText("UI_Consumable_Effect_ResourcePack"), OptCount
  return ResultData, ResourcePackText
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
  self.Panel_Key:AddChild(Item3)
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

function M:NewItemContent(ItemType, ItemId, Count)
  local ItemData = DataMgr[ItemType][ItemId]
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.ItemType = ItemType
  Obj.Id = ItemId
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

function M:CloseSelf()
  if self.bCantClose then
    self.bCantClose = false
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
    if self.NotShowTextTip then
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
    if self.NotShowTextTip then
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
  elseif "Gamepad_FaceButton_Top" == InKeyName and self.Btn_Open then
    self.Btn_Open:OnBtnClicked()
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

return M
