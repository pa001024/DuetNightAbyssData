require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local ResolveDisplayAppearanceSuit, ResolveAccessorySuit

function M:Construct()
  self.AccessoryWidget2Type = {
    [self.Head_Skin] = CommonConst.CharAccessoryTypes.Head,
    [self.Face_Skin] = CommonConst.CharAccessoryTypes.Face,
    [self.Waist_Skin] = CommonConst.CharAccessoryTypes.Waist,
    [self.Back_Skin] = CommonConst.CharAccessoryTypes.Back,
    [self.FX_Dead_Skin] = CommonConst.CharAccessoryTypes.FX_Dead,
    [self.FX_Teleport_Skin] = CommonConst.CharAccessoryTypes.FX_Teleport,
    [self.FX_Footprint_Skin] = CommonConst.CharAccessoryTypes.FX_Footprint,
    [self.FX_Body_Skin] = CommonConst.CharAccessoryTypes.FX_Body,
    [self.FX_PlungingATK_Skin] = CommonConst.CharAccessoryTypes.FX_PlungingATK,
    [self.FX_HelixLeap_Skin] = CommonConst.CharAccessoryTypes.FX_HelixLeap,
    [self.Cap_Skin] = CommonConst.CharAccessoryTypes.Hat,
    [self.SettlementAction_Skin] = CommonConst.CharAccessoryTypes.MVP,
    [self.Tail_Skin] = CommonConst.CharAccessoryTypes.Tail
  }
  self.NoneAccessoryId = DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
  self.DefaultCharAccessoryIds = ArmoryUtils:GetDefaultCharAccessoryIds()
  self.AccessoryType2Widget = {}
  for key, value in pairs(self.AccessoryWidget2Type) do
    self.AccessoryType2Widget[value] = key
  end
  self.NoneAccessoryIconPaths = ArmoryUtils:GetCharNoneAccessoryIconPaths()
  self:InitNavigationRules()
  self.EMScrollBox.OnUserScrolled:Add(self, self.OnScrollBoxScrolled)
  self:AddTimer(0.2, function()
    self:OnScrollBoxScrolled(self.EMScrollBox:GetScrollOffset())
  end)
end

function M:OnScrollBoxScrolled(CurrScrollOffset)
  if CurrScrollOffset >= self.EMScrollBox:GetScrollOffsetOfEnd() - 10 then
    self.List_Arrow_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.List_Arrow_Down:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
end

function M:PlayInAnim()
  self:PlayAnimation(self.In)
end

function M:Init(MainModel, Params)
  self:PlayInAnim()
  self.Parent = Params.Parent
  self.OnSkinClosed = Params.OnCloseCallback
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self.MainModel = MainModel
  self.Type = CommonConst.DataType.Char
  self.IsPreviewMode = Params.IsPreviewMode
  self.IsTargetUnowned = Params.IsTargetUnowned
  self.AppearanceOwnershipChecker = Params.AppearanceOwnershipChecker
  self.OverrideAppearanceSuit = Params.OverrideAppearanceSuit
  self.IsCharacterTrialMode = Params.IsCharacterTrialMode
  self.NoReddot = self.IsPreviewMode or self.IsTargetUnowned or self.IsCharacterTrialMode
  local Target = MainModel:GetSelectedChar()
  local AppearanceSuit = ResolveDisplayAppearanceSuit(Target, MainModel, self.OverrideAppearanceSuit)
  local CharData = Target:Data()
  local Avatar = ArmoryUtils:GetAvatar()
  local CommonChar = Avatar.CommonChars[Target.CharId]
  local SkinId = AppearanceSuit.SkinId or CharData.DefaultSkinId
  local SkinData = DataMgr.Skin[SkinId]
  SkinData = SkinData or DataMgr.Skin[CharData.DefaultSkinId]
  local Skin = CommonChar and CommonChar.OwnedSkins[SkinId]
  local CharDyeInfos, CurrentDyePlanIndex
  if self.bFormPersonalPage then
    CharDyeInfos = Skin and Skin.Colors or {}
    CurrentDyePlanIndex = Skin and Skin.CurrentPlanIndex or nil
  end
  local SkinItemContent = {
    bDyeable = CharData.DefaultSkinId ~= SkinId,
    IconPath = SkinData.LongIcon,
    Owner = self,
    Type = self.Type,
    IsPreviewMode = self.IsPreviewMode,
    IsTargetUnowned = self:IsAppearanceItemUnowned("Skin", SkinId),
    DyeInfos = CharDyeInfos,
    DyePlanIndex = CurrentDyePlanIndex,
    NoState = not self:IsAppearanceItemUnowned("Skin", SkinId),
    OnClicked = function()
      if self.bFormPersonalPage then
        return
      end
      local Params = {
        Target = self.MainModel:GetSelectedChar(),
        Type = self.Type,
        SkinId = SkinId,
        OnCloseCallback = self.OnSkinClosed,
        Parent = self.Parent,
        IsCharacterTrialMode = self.IsCharacterTrialMode,
        IsTargetUnowned = self.IsTargetUnowned
      }
      self:OpenSkin(Params)
    end,
    TipType = "Skin",
    ItemId = SkinId,
    Rarity = SkinData.Rarity
  }
  
  function SkinItemContent.OnAddedToFocusPath(_self, Content)
    self.CurrentFocusedWidget = Content.Widget
    self.EMScrollBox:ScrollWidgetIntoView(self.CurrentFocusedWidget)
  end
  
  self.Char_Skin:OnListItemObjectSet(SkinItemContent)
  local HairId
  if AppearanceSuit.HairId and AppearanceSuit.HairId > 0 then
    HairId = AppearanceSuit.HairId
  else
    HairId = CharData.DefaultHairId or Target.CharId
  end
  local HairData = DataMgr.Hair[HairId]
  HairData = HairData or DataMgr.Hair[CharData.DefaultHairId]
  local Hair = CommonChar and CommonChar.OwnedHairs[SkinId]
  local HairDyeInfos, CurrentHairDyePlanIndex
  if self.bFormPersonalPage then
    HairDyeInfos = Hair and Hair.Colors or {}
    CurrentHairDyePlanIndex = Hair and Hair.CurrentPlanIndex or nil
  end
  local HairItemContent = {
    bDyeable = CharData.DefaultHairId ~= SkinId,
    IconPath = HairData.Icon,
    Owner = self,
    Type = self.Type,
    IsPreviewMode = self.IsPreviewMode,
    IsTargetUnowned = self:IsAppearanceItemUnowned("Hair", HairId),
    DyeInfos = HairDyeInfos,
    DyePlanIndex = CurrentHairDyePlanIndex,
    NoState = not self:IsAppearanceItemUnowned("Hair", HairId),
    OnClicked = function()
      AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
      if self.bFormPersonalPage then
        return
      end
      local Params = {
        Target = self.MainModel:GetSelectedChar(),
        Type = self.Type,
        HairId = HairId,
        OnCloseCallback = self.OnSkinClosed,
        Parent = self.Parent,
        IsCharacterTrialMode = self.IsCharacterTrialMode,
        IsTargetUnowned = self.IsTargetUnowned
      }
      self:OpenSkin(Params)
    end,
    TipType = "Hair",
    ItemId = HairId,
    Rarity = HairData.Rarity
  }
  
  function HairItemContent.OnAddedToFocusPath(_self, Content)
    self.CurrentFocusedWidget = Content.Entry
    self.EMScrollBox:ScrollWidgetIntoView(self.CurrentFocusedWidget)
  end
  
  self.Hair_Skin:OnListItemObjectSet(HairItemContent)
  local PartMeshAccessoryId, PartMeshAccessoryType = Target:GetPartMeshAccessoryInfo(SkinId)
  local AccessorySuit = ResolveAccessorySuit(AppearanceSuit)
  for CharAccessoryType, AccessoryTypeIdx in pairs(CommonConst.NewCharAccessoryTypes) do
    local RawAccessoryId = AccessorySuit[AccessoryTypeIdx]
    local AccessoryId = RawAccessoryId or self.NoneAccessoryId
    if (not RawAccessoryId or RawAccessoryId <= 0) and PartMeshAccessoryType and PartMeshAccessoryType == CharAccessoryType then
      AccessoryId = PartMeshAccessoryId
    end
    local Widget = self.AccessoryType2Widget[CharAccessoryType]
    if Widget then
      local Obj = self:NewCharAccessoryItemContent(AccessoryId, CharAccessoryType, SkinId)
      
      function Obj.OnAddedToFocusPath(_self, Content)
        self.CurrentFocusedWidget = Content.Entry
        self.EMScrollBox:ScrollWidgetIntoView(self.CurrentFocusedWidget)
      end
      
      Widget:OnListItemObjectSet(Obj)
    end
  end
  self:AddCharAppearanceRedDotListen(Target.CharId)
end

function M:NewCharAccessoryItemContent(AccessoryId, AccessoryType, SkinId)
  local CharAccessoryData = DataMgr.CharAccessory[AccessoryId] or DataMgr.CharPartMesh[AccessoryId]
  local Obj = {
    Owner = self,
    OnClicked = function()
      AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
      if self.bFormPersonalPage then
        return
      end
      local Params = {
        Target = self.MainModel:GetSelectedChar(),
        Type = self.Type,
        AccessoryId = AccessoryId,
        AccessoryType = AccessoryType,
        OnCloseCallback = self.OnSkinClosed,
        IsCharacterTrialMode = self.IsCharacterTrialMode,
        IsTargetUnowned = self.IsTargetUnowned,
        Parent = self.Parent
      }
      self:OpenSkin(Params)
    end,
    IsPreviewMode = self.IsPreviewMode,
    IsTargetUnowned = self:IsAppearanceItemUnowned(DataMgr.CharAccessory[AccessoryId] and "CharAccessory" or "CharPartMesh", AccessoryId),
    TipType = DataMgr.CharAccessory[AccessoryId] and "CharAccessory" or "CharPartMesh"
  }
  Obj.AccessoryId = AccessoryId
  Obj.ItemId = AccessoryId
  Obj.AccessoryType = AccessoryType
  Obj.IsCharacterTrialMode = self.IsCharacterTrialMode
  if CharAccessoryData and self.DefaultCharAccessoryIds[AccessoryType] ~= AccessoryId and ArmoryUtils:IsSkinSupportAccessory(SkinId, AccessoryId) then
    Obj.IconPath = CharAccessoryData.Icon
    Obj.IsNoneIcon = false
    Obj.IsDressed = Obj.ItemId and Obj.ItemId > 0 and Obj.ItemId ~= DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue
    Obj.Rarity = CharAccessoryData.Rarity
  else
    Obj.IconPath = self.NoneAccessoryIconPaths[AccessoryType]
    Obj.IsNoneIcon = true
  end
  return Obj
end

function M:IsAppearanceItemUnowned(TipType, ItemId)
  if not self.AppearanceOwnershipChecker then
    return self.IsTargetUnowned == true
  end
  local IsOwned = self.AppearanceOwnershipChecker(self, TipType, ItemId)
  return not IsOwned
end

function M:OpenSkin(Params)
  Params.IsPreviewMode = self.IsPreviewMode
  Params.ActorController = self.Parent and self.Parent.ActorController
  local UIConfig = DataMgr.SystemUI.ArmorySkin
  UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), Params)
end

function M:JumpLogic(JumpParams)
  if JumpParams and next(JumpParams) then
    local JumpSkinParams = {
      Target = self.MainModel:GetSelectedChar(),
      Type = self.Type,
      SkinId = JumpParams.SkinId,
      HairId = JumpParams.HairId,
      AccessoryId = JumpParams.AccessoryId,
      AccessoryType = JumpParams.AccessoryType,
      OnCloseCallback = self.OnSkinClosed,
      Parent = self.Parent,
      IsCharacterTrialMode = self.IsCharacterTrialMode,
      IsTargetUnowned = self.IsTargetUnowned
    }
    self:OpenSkin(JumpSkinParams)
  end
end

function M:AddCharAppearanceRedDotListen(CharId)
  if self.NoReddot then
    return
  end
  self.AppearanceNodeNames = self.AppearanceNodeNames or {}
  self:RemoveAppearanceRedDotListen()
  local Avatar = GWorld:GetAvatar()
  local CommonChar = Avatar.CommonChars[CharId]
  for _, Type in pairs(CommonConst.CharAccessoryTypes) do
    local LeafNodes = {}
    local NodeName = CharId .. CommonConst.DataType.CharAccessory .. Type
    if self.AccessoryType2Widget[Type] then
      local LeafNodeName = CommonConst.DataType.CharAccessory .. Type
      LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
      for key, Skin in pairs(CommonChar.OwnedSkins) do
        LeafNodeName = LeafNodeName .. Skin.SkinId
        LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
      end
      if not IsEmptyTable(LeafNodes) then
        ReddotManager.AddListener(NodeName, self, function(_self, Count)
          local Content = self.AccessoryType2Widget[Type].Content
          Content.IsNew = Count > 0
          ArmoryUtils:UpdateContentRetDotType(Content)
          self.AccessoryType2Widget[Type]:SetReddot(Content.RedDotType)
        end, LeafNodes)
        self.AppearanceNodeNames[NodeName] = 1
      end
    end
  end
  local NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
  ReddotManager.AddListener(NodeName, self, function(_self, Count)
    local Content = self.Char_Skin.Content
    Content.Upgradeable = self:CanSkinUpgrade(CharId)
    if not Content.Upgradeable then
      Content.IsNew = Count > 0
    end
    ArmoryUtils:UpdateContentRetDotType(Content)
    self.Char_Skin:SetReddot(Content.RedDotType)
  end, nil, true)
  self.AppearanceNodeNames[NodeName] = 1
  local CharHairNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
  local CommonCharHairNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair
  ReddotManager.AddListener(NodeName, self, function(_self, Count)
    local Content = self.Hair_Skin.Content
    local CharHairNode = ReddotManager.GetTreeNode(CharHairNodeName)
    local CommonCharHairNode = ReddotManager.GetTreeNode(CommonCharHairNodeName)
    Content.IsNew = CharHairNode and CharHairNode.Count > 0 or CommonCharHairNode and CommonCharHairNode.Count > 0
    ArmoryUtils:UpdateContentRetDotType(Content)
    self.Hair_Skin:SetReddot(Content.RedDotType)
  end, nil, true)
  self.AppearanceNodeNames[CharHairNodeName] = 1
  ReddotManager.AddListener(NodeName, self, function(_self, Count)
    local Content = self.Hair_Skin.Content
    local CharHairNode = ReddotManager.GetTreeNode(CharHairNodeName)
    local CommonCharHairNode = ReddotManager.GetTreeNode(CommonCharHairNodeName)
    Content.IsNew = CharHairNode and CharHairNode.Count > 0 or CommonCharHairNode and CommonCharHairNode.Count > 0
    ArmoryUtils:UpdateContentRetDotType(Content)
    self.Hair_Skin:SetReddot(Content.RedDotType)
  end, nil, true)
  self.AppearanceNodeNames[CommonCharHairNodeName] = 1
end

function M:RemoveAppearanceRedDotListen()
  if self.NoReddot or not self.AppearanceNodeNames then
    return
  end
  for key, value in pairs(self.AppearanceNodeNames) do
    ReddotManager.RemoveListener(key, self)
  end
  self.AppearanceNodeNames = {}
end

function M:CanSkinUpgrade(CharId)
  if not DataMgr.Char[CharId] then
    return false
  end
  for SkinId, Data in pairs(DataMgr.Skin) do
    if Data.CharId == CharId and ArmoryUtils:CanSkinUpgrade(SkinId) then
      return true
    end
  end
  return false
end

function M:Destruct()
  self:RemoveAppearanceRedDotListen()
end

function M:InitNavigationRules()
  local Grid = {
    {
      self.Char_Skin,
      self.Hair_Skin,
      self.SettlementAction_Skin
    },
    {
      self.Char_Skin,
      self.Cap_Skin,
      self.Head_Skin
    },
    {
      self.Face_Skin,
      self.Back_Skin,
      self.Tail_Skin
    },
    {
      self.Waist_Skin,
      self.FX_Teleport_Skin,
      self.FX_Footprint_Skin
    },
    {
      self.FX_Body_Skin,
      self.FX_PlungingATK_Skin,
      self.FX_HelixLeap_Skin
    },
    {
      self.FX_Dead_Skin
    }
  }
  local MaxCol = #Grid[1]
  local MaxRow = #Grid
  local Dirs = {
    {1, 0},
    {0, 1},
    {0, -1},
    {-1, 0}
  }
  local NavDir = {
    EUINavigation.Down,
    EUINavigation.Right,
    EUINavigation.Left,
    EUINavigation.Up
  }
  local Row = 0
  local Col = 0
  local EDir = 0
  for i, GridRow in ipairs(Grid) do
    for j, Widget in ipairs(GridRow) do
      for index, Dir in ipairs(Dirs) do
        Row = i + Dir[1]
        Col = j + Dir[2]
        EDir = NavDir[index]
        if Row <= 0 or MaxRow < Row then
          Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
        elseif Col <= 0 then
          Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Escape)
        elseif MaxCol < Col then
          Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
        elseif Grid[Row][Col] then
          Widget:SetNavigationRuleExplicit(EDir, Grid[Row][Col])
        else
          Widget:SetNavigationRuleBase(EDir, EUINavigationRule.Stop)
        end
      end
    end
  end
  self.Char_Skin:SetNavigationRuleExplicit(EUINavigation.Right, self.Hair_Skin)
end

function M:OnAddedToFocusPath()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.CurrentFocusedWidget or self.Char_Skin)
end

function M:ClearFocusState()
  self.CurrentFocusedWidget = nil
end

function ResolveDisplayAppearanceSuit(Target, MainModel, OverrideAppearanceSuit)
  if type(OverrideAppearanceSuit) == "table" then
    return OverrideAppearanceSuit
  end
  if not (Target and MainModel) or not MainModel.GetSelectedCharAppearanceIndex then
    return nil
  end
  local AppearanceIndex = MainModel:GetSelectedCharAppearanceIndex()
  return Target.AppearanceSuits and Target.AppearanceSuits[AppearanceIndex] or nil
end

function ResolveAccessorySuit(AppearanceSuit)
  local Result = {}
  if type(AppearanceSuit) ~= "table" then
    return Result
  end
  
  local function MergeAccessoryMap(Source)
    if type(Source) ~= "table" then
      return
    end
    for Key, Value in pairs(Source) do
      local SlotKey = tonumber(Key) or Key
      if nil == Result[SlotKey] then
        Result[SlotKey] = Value
      end
    end
  end
  
  MergeAccessoryMap(AppearanceSuit.AccessorySuit)
  MergeAccessoryMap(AppearanceSuit.Accessory)
  return Result
end

AssembleComponents(M)
return M
