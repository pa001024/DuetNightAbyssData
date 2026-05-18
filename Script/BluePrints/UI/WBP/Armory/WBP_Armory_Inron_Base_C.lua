require("UnLua")
local SkillUtils = require("Utils.SkillUtils")
local UpgradeUtils = require("Utils.UpgradeUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self:AddDispatcher(EventID.OnCharGradeLevelUp, self, self.OnCharGradeLevelUp)
  self:AddDispatcher(EventID.OnCharExtraGradeLevelUp, self, self.OnCharExtraGradeLevelUp)
  self:AddDispatcher(EventID.OnCharCardLevelResourcesChanged, self, self.OnCharCardLevelResourcesChanged)
  self:AddDispatcher(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
  self:AddDispatcher(EventID.OnMenuClose, self, self.OnClickBtnFullClose)
  self.UnLockedText = GText("UI_UNLOCKED")
  self.UnLockText = GText("UI_UNLOCK")
  self.bIsFocusable = true
  self.IsOpenDetails = false
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
end

function M:Init(Params)
  self.Params = Params
  self.Parent = Params.Parent
  self.Char = Params.Target
  self.Type = Params.Type
  self.Tag = Params.Tag
  self.IsPreviewMode = Params.IsPreviewMode or Params.IsTargetUnowned
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self._OnRemovedFromFocusPath = Params.OnRemovedFromFocusPath
  self.NewChar = false
  self.TotalMaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue) + 1
  self:InitTraceMain()
end

function M:InitTraceMain()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char = self.Char
  if self.CharId and self.CharId ~= Char.CharId and not self.IsOpenDetails then
    self.NewChar = true
  end
  self.CharId = Char.CharId
  self.CharGradeLevel = Char.GradeLevel
  self.MaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
  self.HasUltraGrade = Char:HasUltraGradeLevel()
  self.IsExtraGradeUnlocked = Char:IsExtraGradeLevelUnlocked()
  self.EffectiveGradeLevel = Char:GetEffectiveGradeLevel()
  self.Attribute = DataMgr.BattleChar[self.CharId].Attribute
  self.Line_Attr:SetColorAndOpacity(self[self.Attribute])
  self.Line_Attr_Sp:SetColorAndOpacity(self[self.Attribute])
  local BgTopAllChildren = self.Panel_BgTop:GetAllChildren():ToTable() or {}
  for index, value in ipairs(BgTopAllChildren) do
    value:SetColorAndOpacity(self[self.Attribute])
  end
  local BgBottomAllChildren = self.Panel_BgBottom:GetAllChildren():ToTable() or {}
  for index, value in ipairs(BgBottomAllChildren) do
    value:SetColorAndOpacity(self[self.Attribute])
  end
  local AllVXChildren = self.VX:GetAllChildren():ToTable() or {}
  for index, value in ipairs(AllVXChildren) do
    value:SetColorAndOpacity(self[self.Attribute .. "_VX"])
  end
  for i = 1, self.CharGradeLevel do
    if self["InronItem_" .. i] then
      self["InronItem_" .. i]:Init(self, i, false)
      if self.IsPreviewMode or self.NewChar or (not (self.Details and self.SelectTraceId) or self.SelectTraceId ~= i) and (not self.LastFocusItem or self.LastFocusItem ~= self["InronItem_" .. i] or not not self["InronItem_" .. i]:HasAnyUserFocus()) then
        self["InronItem_" .. i]:SetNormalState()
      end
      self["InronItem_" .. i].Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  for j = self.CharGradeLevel + 1, self.MaxGradeLevel do
    if self["InronItem_" .. j] then
      self["InronItem_" .. j]:Init(self, j, true)
      if self.IsPreviewMode or self.NewChar or (not (self.Details and self.SelectTraceId) or self.SelectTraceId ~= j) and (not self.LastFocusItem or self.LastFocusItem ~= self["InronItem_" .. j] or not not self["InronItem_" .. j]:HasAnyUserFocus()) then
        self["InronItem_" .. j]:SetNormalState()
      end
      self["InronItem_" .. j].Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  if self.InronItem_7 then
    if self.HasUltraGrade then
      self.InronItem_7:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      local IsLock7 = not self.IsExtraGradeUnlocked
      self.InronItem_7:Init(self, 7, IsLock7)
      if self.NewChar or (not (self.Details and self.SelectTraceId) or 7 ~= self.SelectTraceId) and (not self.LastFocusItem or self.LastFocusItem ~= self.InronItem_7 or not not self.InronItem_7:HasAnyUserFocus()) then
        self.InronItem_7:SetNormalState()
      end
      self.InronItem_7.Num_Intron:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.WS_Line:SetActiveWidgetIndex(1)
    else
      self.InronItem_7:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.WS_Line:SetActiveWidgetIndex(0)
    end
  end
  if self["InronItem_" .. self.CharGradeLevel + 1] and self.CharGradeLevel + 1 <= self.MaxGradeLevel then
    self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(self:CheckCharCanUpGradeLevel())
  end
  if self.InronItem_7 and self.HasUltraGrade then
    if not self.IsExtraGradeUnlocked and self.CharGradeLevel >= self.MaxGradeLevel then
      self.InronItem_7:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
    else
      self.InronItem_7:SetReddotState(false)
    end
  end
  if self.InronItem_7 and self.HasUltraGrade then
    local IsNewUltraGrade = self:CheckUltraGradeNewState()
    self.InronItem_7:SetNewState(IsNewUltraGrade)
  end
  if self.InronItem_6 then
    if self.HasUltraGrade and self.InronItem_7 and self.InronItem_7:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
      self.InronItem_6:SetNavigationRuleExplicit(EUINavigation.Left, self.InronItem_7)
      self.InronItem_6:SetNavigationRuleExplicit(EUINavigation.Down, self.InronItem_7)
      self.InronItem_7:SetNavigationRuleExplicit(EUINavigation.Up, self.Parent.EMListView_SubTab)
    else
      self.InronItem_6:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Escape)
      self.InronItem_6:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
    end
  end
  for k = 1, self.TotalMaxGradeLevel do
    if self["InronItem_" .. k] then
      self["InronItem_" .. k]:PlayActivatableNormal()
    end
  end
  self.SelectTraceId = -1
  if self.LastFocusItem ~= nil and self.CurInputDeviceType == ECommonInputType.Gamepad and not self.IsOpenDetails and self.ShouldFocusLast then
    self.LastFocusItem:SetFocus()
    self.ShouldFocusLast = false
  end
end

function M:CheckUltraGradeNewState()
  if self.IsPreviewMode then
    return false
  end
  if self.IsExtraGradeUnlocked then
    return false
  end
  local NodeName = DataMgr.ReddotNode.NewUltraGradeChar.Name
  local UltraNode = ReddotManager.GetTreeNode(NodeName)
  if not UltraNode or UltraNode.Count <= 0 then
    return false
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if not CacheDetail then
    return false
  end
  return 1 == CacheDetail[self.CharId]
end

function M:LoadSkillDetailsUI()
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain and ArmoryMain.ActorController then
    self.ActorController = ArmoryMain.ActorController
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryType.Grade, "Detail")
  end
  self.Details = UIManager(self):LoadUINew("ArmoryTraceDetails", self, self.SelectTraceId, self.SelectMod)
  self:AddDelayFrameFunc(function()
    for i = 1, self.MaxGradeLevel do
      if self["InronItem_" .. i] then
        self["InronItem_" .. i].IsClick = false
        self["InronItem_" .. i]:SetNormalState()
      end
    end
  end, 2, "PlayItemNormalAnim")
end

function M:OnTraceDetailsDestruct(SelectTraceId)
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain then
    ArmoryMain:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ArmoryMain.Panel_SubUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.SelectTraceId = SelectTraceId
  self.DetailsClose = true
  self.Details = nil
  self.IsOpenDetails = false
  self.ShouldFocusLast = true
  if self["InronItem_" .. self.SelectTraceId] then
    self.LastFocusItem = self["InronItem_" .. self.SelectTraceId]
  end
end

function M:OnClickTraceItem(TraceId)
  if self.IsOutAnimPlayed then
    return
  end
  if self.SelectTraceId == TraceId then
    return
  end
  if 7 == TraceId and self.HasUltraGrade and not self.IsPreviewMode then
    local NodeName = DataMgr.ReddotNode.NewUltraGradeChar.Name
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if CacheDetail and 1 == CacheDetail[self.CharId] then
      ArmoryUtils:SetUltraGradeCharReddotRead(self.CharId)
      if self.InronItem_7 then
        self.InronItem_7:SetNewState(false)
      end
      EventManager:FireEvent(EventID.OnCharExtraGradeItemClick, self.Char.Uuid)
    end
  end
  if not self.Details or self.Details.InFinished then
    local IsUnlocked = false
    if TraceId <= self.MaxGradeLevel then
      IsUnlocked = TraceId <= self.CharGradeLevel
    else
      IsUnlocked = self.IsExtraGradeUnlocked
    end
    if IsUnlocked then
      AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click", nil, nil)
    else
      AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_point_click_unlock", nil, nil)
    end
  end
  if self["InronItem_" .. self.SelectTraceId] then
    self["InronItem_" .. self.SelectTraceId].IsClick = false
    self["InronItem_" .. self.SelectTraceId]:SetNormalState()
    self["InronItem_" .. self.SelectTraceId]:CollapseVX()
    self.LastFocusItem = self["InronItem_" .. self.SelectTraceId]
  end
  self.SelectTraceId = TraceId
  if self.SelectTraceId ~= self.CharGradeLevel + 1 and self["InronItem_" .. self.CharGradeLevel + 1] and self.CharGradeLevel + 1 <= self.MaxGradeLevel then
    self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(self:CheckCharCanUpGradeLevel())
  end
  if 7 ~= self.SelectTraceId and self.InronItem_7 and self.HasUltraGrade and not self.IsExtraGradeUnlocked and self.CharGradeLevel >= self.MaxGradeLevel then
    self.InronItem_7:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
  end
  self.SelectMod = 1
  if self.IsPreviewMode then
    self.SelectMod = 4
  elseif 7 == TraceId then
    if self.IsExtraGradeUnlocked then
      self.SelectMod = 1
    else
      self.SelectMod = 2
      if self.CharGradeLevel < self.MaxGradeLevel then
        self.SelectMod = 3
      end
    end
  elseif self.SelectTraceId <= self.CharGradeLevel then
    self.SelectMod = 1
  elseif self.SelectTraceId == self.CharGradeLevel + 1 then
    self.SelectMod = 2
  else
    self.SelectMod = 3
  end
  if self.IsOpenDetails and self.Details then
    self.Details:UpdateDetailInfo(self.SelectTraceId, self.SelectMod)
  else
    self:LoadSkillDetailsUI()
  end
end

function M:InitResourceNeeded()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char = self.Char
  local ResourceNeeded = {}
  local IsOrdered = false
  if 7 == self.SelectTraceId then
    ResourceNeeded = Char:CalculateCharUltraGradeLevelUpResources()
    IsOrdered = true
  elseif DataMgr.CharCardLevelUp[Char.CharId] and DataMgr.CharCardLevelUp[Char.CharId][self.SelectTraceId - 1] then
    local Data = DataMgr.CharCardLevelUp[Char.CharId][self.SelectTraceId - 1]
    ResourceNeeded = Char:CalculateCharGradeLevelUpResources(Data)
  end
  self.Details.HB_Item:ClearChildren()
  local ResType = 1
  local FirstResource1, FirstResource2
  
  local function iterateResources(resources, isOrdered, callback)
    if isOrdered then
      for _, entry in ipairs(resources) do
        callback(entry.Id, entry.Num)
      end
    else
      for key, value in pairs(resources) do
        callback(key, value)
      end
    end
  end
  
  iterateResources(ResourceNeeded, IsOrdered, function(Key, Value)
    local Resource = Avatar.Resources[Key]
    local ResourceConf = DataMgr.Resource[Key]
    local TypeId2ShopItem = DataMgr.TypeId2ShopItem[CommonConst.DataType.Resource]
    local ShopItemId = TypeId2ShopItem and TypeId2ShopItem[Key] and TypeId2ShopItem[Key][1]
    local ShopItemData = ShopItemId and DataMgr.ShopItem[ShopItemId]
    local FakeContent = {
      Id = Key,
      Icon = ResourceConf.Icon,
      Count = Resource and Resource.Count or 0,
      ItemType = CommonConst.ItemType.Resource,
      Rarity = ResourceConf.Rarity,
      IsShowDetails = true,
      NeedCount = Value,
      ShopItemId = ShopItemId,
      CountTextWhite = true
    }
    local Item = UIManager(self):_CreateWidgetNew("ComItemUniversalM")
    Item:BindEvents(self, {
      OnMenuOpenChanged = self.OnTipsOpenChanged
    })
    Item.bIsFocusable = true
    self.Details.HB_Item:AddChild(Item)
    Item:Init(FakeContent)
    local CurType = 1
    local CurResource1 = FakeContent
    local CurResource2
    if Value > FakeContent.Count then
      local NeedNum = Value - FakeContent.Count
      local TypeId2ShopItem2 = DataMgr.TypeId2ShopItem[CommonConst.DataType.Resource]
      local ShopItemId2 = TypeId2ShopItem2 and TypeId2ShopItem2[Key] and TypeId2ShopItem2[Key][1]
      local ShopItemData2 = ShopItemId2 and DataMgr.ShopItem[ShopItemId2]
      if ShopItemData2 then
        local Resource2 = Avatar.Resources[ShopItemData2.PriceType] or {Count = 0}
        local NeedCount = ShopItemData2.Price * NeedNum
        local NeedContent = {
          Id = ShopItemData2.PriceType,
          Icon = DataMgr.Resource[ShopItemData2.PriceType].Icon,
          ItemType = CommonConst.DataType.Resource,
          Rarity = DataMgr.Resource[ShopItemData2.PriceType].Rarity,
          Count = NeedCount,
          ShopItemId = ShopItemId2,
          Price = ShopItemData2.Price,
          IsShowDetails = true
        }
        CurResource2 = NeedContent
        if NeedCount <= Resource2.Count then
          CurType = 2
        else
          CurType = 3
        end
      else
        CurType = 4
      end
    end
    if CurType > ResType then
      ResType = CurType
      FirstResource1 = CurResource1
      FirstResource2 = CurResource2
    end
    if nil == FirstResource1 then
      FirstResource1 = CurResource1
      FirstResource2 = CurResource2
    end
  end)
  return {
    ResType,
    FirstResource1,
    FirstResource2
  }
end

function M:OnTipsOpenChanged(bIsOpen)
  if self.Details then
    self.Details:OnTipsOpenChanged(bIsOpen)
  end
end

function M:GetTraceDesc()
  if DataMgr.BattleChar[self.CharId].CharGradeDescription and DataMgr.BattleChar[self.CharId].CharGradeDescription[self.SelectTraceId] then
    local CharGradeDescription = GText(DataMgr.BattleChar[self.CharId].CharGradeDescription[self.SelectTraceId])
    local ReversedParameters = {}
    for index, value in pairs(DataMgr.BattleChar[self.CharId].CharGradeParameter) do
      table.insert(ReversedParameters, {Index = index, Value = value})
    end
    table.sort(ReversedParameters, function(a, b)
      return tonumber(a.Index) > tonumber(b.Index)
    end)
    for _, param in ipairs(ReversedParameters) do
      local Parameter = SkillUtils.CalcSkillDesc(param.Value, 1)
      local SignIndex = string.find(Parameter, "%%", 1)
      if SignIndex then
        Parameter = Parameter .. "%"
      end
      CharGradeDescription = string.gsub(CharGradeDescription, "#" .. param.Index, Parameter)
    end
    return CharGradeDescription
  elseif 7 == self.SelectTraceId then
    local SkillId = DataMgr.CharId2UltraPassiveSkillId and DataMgr.CharId2UltraPassiveSkillId[self.CharId]
    if SkillId then
      local SkillData = DataMgr.Skill[SkillId] and DataMgr.Skill[SkillId][1] and DataMgr.Skill[SkillId][1][0]
      if SkillData then
        local Desc = GText(SkillData.SkillDesc)
        if SkillData.SkillDescValues then
          local ReversedParameters = {}
          for index, value in pairs(SkillData.SkillDescValues) do
            table.insert(ReversedParameters, {Index = index, Value = value})
          end
          table.sort(ReversedParameters, function(a, b)
            return tonumber(a.Index) > tonumber(b.Index)
          end)
          for _, param in ipairs(ReversedParameters) do
            local Parameter = SkillUtils.CalcSkillDesc(param.Value, 1)
            local SignIndex = string.find(Parameter, "%%", 1)
            if SignIndex then
              Parameter = Parameter .. "%"
            end
            Desc = string.gsub(Desc, "#" .. param.Index, Parameter)
          end
        end
        return Desc
      end
    end
    return ""
  end
  return ""
end

function M:OnClickBtnFullClose()
  if -1 == self.SelectTraceId then
    return
  else
    if self["InronItem_" .. self.SelectTraceId] then
      self["InronItem_" .. self.SelectTraceId].IsClick = false
      self["InronItem_" .. self.SelectTraceId]:SetNormalState()
    end
    if self["InronItem_" .. self.CharGradeLevel + 1] and self.CharGradeLevel + 1 <= self.MaxGradeLevel then
      self["InronItem_" .. self.CharGradeLevel + 1].IsClick = false
    end
    self.SelectTraceId = -1
  end
end

function M:OnClickBTN(Type, Resource1, Resource2)
  if 7 == self.SelectTraceId then
    if self.IsExtraGradeUnlocked then
      return
    end
    if 4 == Type then
      UIManager(self):ShowUITip("CommonToastMain", "UI_FORGING_MATERIAL_NOTENOUGH")
      return
    end
    if 1 == Type then
      if self.InronItem_7 then
        self.InronItem_7:SetReddotState(false)
      end
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        self.Parent:BlockAllUIInput(true)
        local Char = self.Char
        DebugPrint("zwkkk OnClickBTN UpCharExtraGradeLevel")
        local CallServerFunc = Avatar.UpCharExtraGradeLevel
        CallServerFunc(Avatar, Char.Uuid)
      end
    elseif 2 == Type or 3 == Type then
      local Avatar = GWorld:GetAvatar()
      local Resource1Data = {}
      Resource1Data.Count = Avatar.Resources[Resource1.Id] and Avatar.Resources[Resource1.Id].Count or 0
      Resource1Data.ResourceName = DataMgr.Resource[Resource1.Id] and DataMgr.Resource[Resource1.Id].ResourceName or ""
      local BuyCount = Resource1.NeedCount - Resource1.Count
      local Params = {
        LeftItems = {
          {
            ItemId = Resource2.Id,
            ItemType = Resource2.ItemType,
            Count = Resource2.Count
          }
        },
        RightItems = {
          {
            ItemId = Resource1.Id,
            ItemType = Resource2.ItemType,
            Count = BuyCount
          }
        },
        ShortTextParams = {
          Resource2.Count,
          BuyCount,
          GText(Resource1Data.ResourceName)
        },
        RightCallbackFunction = function()
          self.Parent:BlockAllUIInput(true)
          self.IsWatingForBuyResource = true
          self.IsWatingForUltraUpgrade = true
          Avatar:PurchaseShopItem(Resource1.ShopItemId, BuyCount, true)
        end
      }
      if 3 == Type then
        function Params.RightCallbackFunction()
          UIManager(self):ShowCommonPopupUI(100248, {
            RightCallbackFunction = function()
              PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
            end
          }, self)
        end
      end
      UIManager(self):ShowCommonPopupUI(100247, Params, self)
    end
    return
  end
  if self.CharGradeLevel == self.MaxGradeLevel or self.SelectTraceId ~= self.CharGradeLevel + 1 then
    return
  end
  if 4 == Type then
    UIManager(self):ShowUITip("CommonToastMain", "UI_FORGING_MATERIAL_NOTENOUGH")
    return
  end
  if 1 == Type then
    if -1 ~= self.SelectTraceId then
      self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(false)
    end
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      self.Parent:BlockAllUIInput(true)
      local Char = self.Char
      local CallServerFunc = Avatar.UpCharGradeLevel
      CallServerFunc(Avatar, Char.Uuid, tonumber(Char.GradeLevel))
    end
  elseif 2 == Type or 3 == Type then
    local Avatar = GWorld:GetAvatar()
    local Resource1Data = {}
    Resource1Data.Count = Avatar.Resources[Resource1.Id] and Avatar.Resources[Resource1.Id].Count or 0
    Resource1Data.ResourceName = DataMgr.Resource[Resource1.Id] and DataMgr.Resource[Resource1.Id].ResourceName or ""
    local BuyCount = Resource1.NeedCount - Resource1.Count
    local Params = {
      LeftItems = {
        {
          ItemId = Resource2.Id,
          ItemType = Resource2.ItemType,
          Count = Resource2.Count
        }
      },
      RightItems = {
        {
          ItemId = Resource1.Id,
          ItemType = Resource2.ItemType,
          Count = BuyCount
        }
      },
      ShortTextParams = {
        Resource2.Count,
        BuyCount,
        GText(Resource1Data.ResourceName)
      },
      RightCallbackFunction = function()
        self.Parent:BlockAllUIInput(true)
        self.IsWatingForBuyResource = true
        self.IsWatingForUltraUpgrade = false
        Avatar:PurchaseShopItem(Resource1.ShopItemId, BuyCount, true)
      end
    }
    if 3 == Type then
      function Params.RightCallbackFunction()
        UIManager(self):ShowCommonPopupUI(100248, {
          RightCallbackFunction = function()
            PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
          end
        }, self)
      end
    end
    UIManager(self):ShowCommonPopupUI(100247, Params, self)
  end
end

function M:OnPurchaseShopItem(Ret)
  if not self.IsWatingForBuyResource then
    return
  end
  self.Parent:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  if self.IsWatingForBuyResource then
    self.IsWatingForBuyResource = false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      self.Parent:BlockAllUIInput(true)
      local Char = self.Char
      if self.IsWatingForUltraUpgrade then
        DebugPrint("zwkkk OnPurchaseShopItem UpCharExtraGradeLevel")
        Avatar:UpCharExtraGradeLevel(Char.Uuid)
      else
        if -1 ~= self.SelectTraceId and self["InronItem_" .. self.CharGradeLevel + 1] then
          self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(false)
        end
        local CallServerFunc = Avatar.UpCharGradeLevel
        CallServerFunc(Avatar, Char.Uuid, tonumber(Char.GradeLevel))
      end
    end
  end
end

function M:SyncCharData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.Char then
    return false
  end
  self.Char = Avatar.Chars[self.Char.Uuid] or self.Char
  self.CharId = self.Char.CharId
  self.CharGradeLevel = self.Char.GradeLevel
  self.HasUltraGrade = self.Char:HasUltraGradeLevel()
  self.IsExtraGradeUnlocked = self.Char:IsExtraGradeLevelUnlocked()
  self.EffectiveGradeLevel = self.Char:GetEffectiveGradeLevel()
  return true
end

function M:GetSelectMod(TraceId)
  if self.IsPreviewMode then
    return 4
  elseif 7 == TraceId then
    if self.IsExtraGradeUnlocked then
      return 1
    elseif self.CharGradeLevel < self.MaxGradeLevel then
      return 3
    end
    return 2
  elseif TraceId <= self.CharGradeLevel then
    return 1
  elseif TraceId == self.CharGradeLevel + 1 then
    return 2
  end
  return 3
end

function M:RefreshTraceReddot()
  if self.IsPreviewMode then
    return
  end
  if self["InronItem_" .. self.CharGradeLevel + 1] and self.CharGradeLevel + 1 <= self.MaxGradeLevel then
    self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(self:CheckCharCanUpGradeLevel())
  end
  if self.InronItem_7 and self.HasUltraGrade then
    if not self.IsExtraGradeUnlocked and self.CharGradeLevel >= self.MaxGradeLevel then
      self.InronItem_7:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
    else
      self.InronItem_7:SetReddotState(false)
    end
    self.InronItem_7:SetNewState(self:CheckUltraGradeNewState())
  end
end

function M:RefreshCurrentTraceInfo()
  if not self:SyncCharData() then
    return
  end
  self:RefreshTraceReddot()
  if self.SelectTraceId and -1 ~= self.SelectTraceId and self.Details then
    self.SelectMod = self:GetSelectMod(self.SelectTraceId)
    self.Details:UpdateDetailInfo(self.SelectTraceId, self.SelectMod)
  end
end

function M:OnCharCardLevelResourcesChanged(ResourceId, CharId, Uuid)
  if self.IsPreviewMode then
    return
  end
  if Uuid and self.Char and Uuid ~= self.Char.Uuid then
    return
  end
  if CharId and self.CharId and CharId ~= self.CharId then
    return
  end
  self:RefreshCurrentTraceInfo()
end

function M:OnResourcesChanged(ResourceId)
  if self.IsPreviewMode or not ResourceId then
    return
  end
  self:RefreshCurrentTraceInfo()
end

function M:CheckCharCanUpGradeLevel()
  if self.IsPreviewMode then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char = self.Char
  return UpgradeUtils.CheckCharCanUpgradeCardLevel(Char)
end

function M:CheckCharCanUpUltraGradeLevel()
  if self.IsPreviewMode then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char = self.Char
  return UpgradeUtils.CheckCharCanUpgradeUltraCardLevel(Char)
end

function M:OnCharGradeLevelUp(Ret, CharUuid, CurrentGradeLevel)
  DebugPrint("zwkkk OnCharGradeLevelUp ", Ret, CharUuid, CurrentGradeLevel)
  self.Parent:BlockAllUIInput(false)
  if ErrorCode:Check(Ret) then
    local Avatar = GWorld:GetAvatar()
    self.Char = Avatar.Chars[self.Char.Uuid]
    self.CharGradeLevel = CurrentGradeLevel + 1
    if self["InronItem_" .. self.SelectTraceId] then
      AudioManager(self):PlayUISound(self, "event:/ui/armory/card_level_unlock", nil, nil)
      self["InronItem_" .. self.SelectTraceId]:PlayUnLockAnim()
    end
    if self["InronItem_" .. self.CharGradeLevel + 1] and self.CharGradeLevel + 1 <= self.MaxGradeLevel then
      self["InronItem_" .. self.CharGradeLevel + 1]:SetReddotState(self:CheckCharCanUpGradeLevel())
    end
    if self.CharGradeLevel >= self.MaxGradeLevel and self.HasUltraGrade and self.InronItem_7 then
      self.IsExtraGradeUnlocked = self.Char:IsExtraGradeLevelUnlocked()
      if not self.IsExtraGradeUnlocked then
        self.InronItem_7:SetReddotState(self:CheckCharCanUpUltraGradeLevel())
      end
    end
    if self.Details then
      self.Details:UpdateDetailInfo(self.SelectTraceId, 1)
    end
  end
end

function M:OnCharExtraGradeLevelUp(Ret, CharUuid)
  self.Parent:BlockAllUIInput(false)
  if ErrorCode:Check(Ret) then
    local Avatar = GWorld:GetAvatar()
    self.Char = Avatar.Chars[self.Char.Uuid]
    self.IsExtraGradeUnlocked = true
    if self["InronItem_" .. self.SelectTraceId] then
      AudioManager(self):PlayUISound(self, "event:/ui/armory/card_level_unlock", nil, nil)
      self["InronItem_" .. self.SelectTraceId]:PlayUnLockAnim()
    end
    if self.InronItem_7 then
      self.InronItem_7:SetReddotState(false)
    end
    if self.Details then
      self.Details:UpdateDetailInfo(self.SelectTraceId, 1)
    end
  end
end

function M:ClickToNextTraceItem()
  self.Parent:BlockAllUIInput(false)
end

function M:PlayInAnim()
  self.IsOutAnimPlayed = false
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:RefreshCurrentTraceInfo()
  if not self.IsOpenDetails and not self.DetailsClose then
    self:StopAllAnimations()
    self:FlushAnimations()
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/suyuan_points_show", nil, nil)
    if self.InronItem_1 then
      self.LastFocusItem = self.InronItem_1
    end
  end
  self.DetailsClose = false
end

function M:PlayOutAnim()
  self.IsOutAnimPlayed = true
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:StopAllAnimations()
  self:FlushAnimations()
  self:PlayAnimation(self.Out)
  for i = 1, self.TotalMaxGradeLevel do
    if self["InronItem_" .. i] then
      self["InronItem_" .. i]:CollapseNiagara()
    end
  end
  return self.Out:GetEndTime()
end

function M:SetDetailsUnlockPlaying(IsPlaying)
  if self.Details then
    self.Details.UnlockPlaying = IsPlaying
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  self.CurInputDeviceType = CurInputDevice
end

function M:OnTraceItemFocused(TraceId)
  if (self.IsGamepadInput and self.IsOpenDetails or self.IsOpenDetails and self.CurInputDeviceType == ECommonInputType.GamePad) and self["InronItem_" .. TraceId] then
    self["InronItem_" .. TraceId].IsClick = false
    self["InronItem_" .. TraceId]:SetClickState()
    self.LastFocusItem = self["InronItem_" .. TraceId]
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.InronItem_1)
end

function M:OnAddedToFocusPath()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath(self.Parent, self)
  end
end

function M:OnRemovedFromFocusPath()
  if self._OnRemovedFromFocusPath then
    self._OnRemovedFromFocusPath(self.Parent, self)
  end
end

function M:OnPopUIKeyDown(InKeyName)
  if not self.PopupUI then
    return
  end
  if InKeyName == UIConst.GamePadKey.RightThumb then
    local ItemWidget = self.PopupUI:GetContentWidgetByName("ItemSubsize")
    if ItemWidget then
      local Item = ItemWidget.Item:GetChildAt(0)
      if Item then
        local Events = {
          OnMenuOpenChanged = self.ItemMenuAnchorChanged
        }
        Item:BindEvents(self, Events)
        Item:OpenItemMenu()
      end
    end
  end
end

function M:ItemMenuAnchorChanged(bIsOpen)
  if not self.PopupUI then
    return
  end
  local CurMode = UIUtils.UtilsGetCurrentInputType()
  if CurMode ~= ECommonInputType.Gamepad then
    return
  end
  if bIsOpen then
    self.PopupUI:SetGamepadBtnKeyVisibility(false)
    self.PopupUI:HideGamepadShortcut(self.OpenTipsButtonIndex)
  else
    self.PopupUI:SetGamepadBtnKeyVisibility(true)
    self.PopupUI:ShowGamepadShortcut(self.OpenTipsButtonIndex)
  end
end

function M:InitKeySetting()
end

AssembleComponents(M)
return M
