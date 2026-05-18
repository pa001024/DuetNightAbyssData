require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")

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
      local Params = {}
      Params.ParentWidget = ParentWidgetRef
      Params.OptRewards = OptRewardsRef
      UIManager(self):ShowCommonPopupUI(100347, Params, self)
    end
  end
  
  if CharSkinPreviewTypeList[UseEffectType] then
    UIManager(self):LoadUINew("CharSkinPreview", {
      Type = UseEffectType,
      OptRewardId = StuffConfigData.UseParam,
      ResourceId = StuffConfigData.ResourceId,
      CloseCallback = OpenCallback
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
  CommonDialogParams.OnCloseCallbackFunction = OpenCallback
  
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
        self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam, OpenCallback)
      end
      
      ConfirmParams.DontFocusParentWidget = true
      UIManager(self):ShowCommonPopupUI_Interrupt(PopConfirmUIId, ConfirmParams, self)
    else
      FirstPopUIWidget.DontFocusParentWidget = false
      self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam, OpenCallback)
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

function M:ConfirmDealWithConsumableItems(UseEffectType, UseParam, OpenCallback)
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
  
  local function ReOpenOptDialog()
    OpenCallback(self, nil, true)
  end
  
  local function DealWithConsumableItemsCallback()
    local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
    if "SelectWeapon" == UseEffectType then
      local WeaponChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if WeaponChooseId then
        UIUtils.ShowGetItemPage(BagCommon.StuffType.Weapon, WeaponChooseId, 1, nil, nil, ReOpenOptDialog)
      end
    elseif "SelectCharacter" == UseEffectType then
      local CharChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if CharChooseId then
        UIUtils.ShowGetItemPage("Char", CharChooseId, 1, nil, nil, ReOpenOptDialog, nil, nil, nil, bIsNew)
      end
    elseif "SelectPet" == UseEffectType then
      local PetChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
      if PetChooseId then
        local GameInstance = GWorld.GameInstance
        local UIManager = GameInstance:GetGameUIManager()
        local SystemUIName = "GetItemPage"
        UIManager:LoadUINew(SystemUIName, BagCommon.OptionalItemType.Pet, PetChooseId, 1, nil, ReOpenOptDialog, -1)
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
