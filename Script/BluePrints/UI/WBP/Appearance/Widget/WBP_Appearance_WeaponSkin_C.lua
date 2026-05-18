require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.AccessoryWidget2Type = {
    [self.Accessory_Skin] = CommonConst.WeaponAccessoryTypes.Accessory,
    [self.WeaponSpecial_Skin] = CommonConst.WeaponAccessoryTypes.RunAttack
  }
  self.AccessoryType2Widget = {}
  for key, value in pairs(self.AccessoryWidget2Type) do
    self.AccessoryType2Widget[value] = key
  end
  self.NoneAccessoryIconPaths = ArmoryUtils:GetWeaponNoneAccessoryIconPaths()
end

function M:Init(MainModel, Params)
  self.Parent = Params.Parent
  self.OnSkinClosed = Params.OnCloseCallback
  self._OnAddedToFocusPath = Params.OnAddedToFocusPath
  self.MainModel = MainModel
  self.Type = CommonConst.ArmoryType.Weapon
  self.IsPreviewMode = Params.IsPreviewMode
  self.IsTargetUnowned = Params.IsTargetUnowned
  self.IsCharacterTrialMode = Params.IsCharacterTrialMode
  self.NoReddot = self.IsPreviewMode or self.IsTargetUnowned or self.IsCharacterTrialMode
  self:InitWeaponAppearanceSuits()
  self:AddWeaponAppearanceReddotListen(self.MainModel:GetSelectedWeapon().WeaponId)
end

function M:InitWeaponAppearanceSuits()
  local Target = self.MainModel:GetSelectedWeapon()
  local Appearance = Target:GetAppearance()
  local WeaponData = Target:Data()
  local SkinId = Appearance.SkinId
  if not SkinId or SkinId <= 0 then
    SkinId = Target.WeaponId
  end
  local SkinData = DataMgr.WeaponSkin[SkinId] or {
    LongIcon = WeaponData.LongIcon or WeaponData.GachaIcon
  }
  local ColorInfos, CurrentDyePlanIndex, SpecialColor
  if self.bFormPersonalPage then
    local WeaponDyeInfos = Target:GetSkin(SkinId)
    ColorInfos = WeaponDyeInfos.Colors
    SpecialColor = WeaponDyeInfos.SpecialColor
    CurrentDyePlanIndex = WeaponDyeInfos.CurrentPlanIndex
  end
  local SkinItemContent = {
    bDyeable = true,
    IconPath = SkinData.LongIcon,
    Rarity = SkinData.Rarity,
    Owner = self,
    Type = self.Type,
    bFormPersonalPage = self.bFormPersonalPage,
    IsPreviewMode = self.IsPreviewMode,
    IsTargetUnowned = self.IsTargetUnowned,
    DyeInfos = ColorInfos,
    DyePlanIndex = CurrentDyePlanIndex,
    SpecialColor = SpecialColor,
    NoState = true,
    OnClicked = function()
      local Params = {
        Target = self.MainModel:GetSelectedWeapon(),
        Type = self.Type,
        SkinId = SkinId,
        OnCloseCallback = self.OnSkinClosed,
        IsCharacterTrialMode = self.IsCharacterTrialMode,
        IsTargetUnowned = self.IsTargetUnowned,
        Parent = self.Parent
      }
      self:OpenSkin(Params)
    end,
    ItemId = SkinId or nil,
    TipType = DataMgr.WeaponSkin[SkinId] and "WeaponSkin" or nil
  }
  
  function SkinItemContent.OnAddedToFocusPath(_self, Content)
    self.CurrentFocusedWidget = Content.Widget
  end
  
  self.Weapon_Skin:OnListItemObjectSet(SkinItemContent)
  local WeaponAccessoryData
  for Widget, AccessoryType in pairs(self.AccessoryWidget2Type) do
    local AccessoryId = Appearance.Accessory[CommonConst.WeaponAccessoryTypeIndex[AccessoryType]] or -1
    WeaponAccessoryData = DataMgr.WeaponAccessory[AccessoryId]
    if CommonConst.WeaponAccessoryTypes.Accessory ~= AccessoryType then
      for key, value in pairs(Appearance.Accessory) do
        if key ~= CommonConst.WeaponAccessoryTypeIndex.Accessory then
          WeaponAccessoryData = DataMgr.WeaponAccessory[value]
          AccessoryId = value
          if WeaponAccessoryData then
            for AccType, Idx in pairs(CommonConst.WeaponAccessoryTypeIndex) do
              if key == Idx then
                AccessoryType = AccType
                break
              end
            end
            break
          end
        end
      end
    end
    local AccessoryContent = {
      Owner = self,
      OnClicked = function()
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
        local Params = {
          Target = self.MainModel:GetSelectedWeapon(),
          Type = self.Type,
          AccessoryId = AccessoryId,
          AccessoryType = AccessoryType,
          OnCloseCallback = self.OnSkinClosed,
          Parent = self.Parent,
          IsCharacterTrialMode = self.IsCharacterTrialMode,
          IsTargetUnowned = self.IsTargetUnowned
        }
        self:OpenSkin(Params)
      end,
      Rarity = WeaponAccessoryData and WeaponAccessoryData.Rarity,
      IsPreviewMode = self.IsPreviewMode,
      IsTargetUnowned = self.IsTargetUnowned,
      TipType = "WeaponAccessory",
      AccessoryId = AccessoryId
    }
    if not WeaponAccessoryData then
      AccessoryContent.IconPath = self.NoneAccessoryIconPaths[AccessoryType] or self.NoneAccessoryIconPaths[CommonConst.WeaponAccessoryTypes.RunAttack]
      AccessoryContent.IsNoneIcon = true
    else
      AccessoryContent.IconPath = WeaponAccessoryData.Icon
      AccessoryContent.IsNoneIcon = false
    end
    
    function AccessoryContent.OnAddedToFocusPath(_self, Content)
      self.CurrentFocusedWidget = Content.Entry
    end
    
    Widget:OnListItemObjectSet(AccessoryContent)
  end
end

function M:OpenSkin(Params)
  Params.IsPreviewMode = self.IsPreviewMode
  local UIConfig = DataMgr.SystemUI.ArmorySkin
  Params.ActorController = self.Parent and self.Parent.ActorController
  UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), Params)
end

function M:JumpLogic(JumpParams)
  if JumpParams and next(JumpParams) then
    local JumpSkinParams = {
      Target = self.MainModel:GetSelectedWeapon(),
      Type = self.Type,
      SkinId = JumpParams.SkinId,
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

function M:AddWeaponAppearanceReddotListen(WeaponId)
  if self.NoReddot then
    return
  end
  self.AppearanceNodeNames = self.AppearanceNodeNames or {}
  self:RemoveAppearanceReddotListen()
  local NodeName = WeaponId .. CommonConst.DataType.Weapon .. CommonConst.DataType.WeaponSkin
  local LeafNodes = {}
  local Data = DataMgr.Weapon[WeaponId]
  if Data and Data.SkinApplicationType then
    for _, value in pairs(Data.SkinApplicationType) do
      local LeafNodeName = CommonConst.DataType.WeaponSkin .. (value or "")
      LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
    end
  end
  self.AppearanceNodeNames[NodeName] = 1
  if not IsEmptyTable(LeafNodes) then
    ReddotManager.AddListener(NodeName, self, function(_self, Count)
      local Content = self.Weapon_Skin.Content
      Content.IsNew = Count > 0
      ArmoryUtils:UpdateContentRetDotType(Content)
      self.Weapon_Skin:SetReddot(Content.RedDotType)
    end, LeafNodes)
  end
  local WeaponAccessoryNodeName = CommonConst.DataType.WeaponAccessory
  self.AppearanceNodeNames[WeaponAccessoryNodeName] = 1
  ReddotManager.AddListener(WeaponAccessoryNodeName, self, function(_self, Count)
    local Content = self.Accessory_Skin.Content
    Content.IsNew = Count > 0
    ArmoryUtils:UpdateContentRetDotType(Content)
    self.Accessory_Skin:SetReddot(Content.RedDotType)
  end, nil, true)
  local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
  if BattleWeaponData and BattleWeaponData.ModApplicationType then
    for key, ApplicationType in pairs(BattleWeaponData.ModApplicationType) do
      local StanceFXNodeName = "WeaponStanceFX" .. ApplicationType
      self.AppearanceNodeNames[StanceFXNodeName] = 1
      ReddotManager.AddListener(StanceFXNodeName, self, function(_self, Count)
        local Content = self.WeaponSpecial_Skin.Content
        Content.IsNew = ArmoryUtils:GetWeaponAppearanceReddotCount(WeaponId).NewWeaponStanceFXCount > 0
        ArmoryUtils:UpdateContentRetDotType(Content)
        self.WeaponSpecial_Skin:SetReddot(Content.RedDotType)
      end, nil, true)
    end
  end
end

function M:RemoveAppearanceReddotListen()
  if self.NoReddot then
    return
  end
  for key, value in pairs(self.AppearanceNodeNames) do
    ReddotManager.RemoveListener(key, self)
  end
  self.AppearanceNodeNames = {}
end

function M:Destruct()
  self:RemoveAppearanceReddotListen()
end

function M:OnAddedToFocusPath()
  if self._OnAddedToFocusPath then
    self._OnAddedToFocusPath()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.CurrentFocusedWidget or self.Weapon_Skin)
end

function M:ClearFocusState()
  self.CurrentFocusedWidget = nil
end

return M
