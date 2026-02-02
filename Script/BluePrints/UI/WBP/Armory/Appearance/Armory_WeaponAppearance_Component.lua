local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:Construct()
  self:AddDispatcher(EventID.OnWeaponAccessoryChanged, self, self.OnWeaponAccessoryChanged)
  self:AddDispatcher(EventID.OnWeaponSkinChanged, self, self.OnWeaponSkinChanged)
  self:AddDispatcher(EventID.OnWeaponColorsChanged, self, self.OnWeaponColorsChanged)
  self:AddDispatcher(EventID.OnNewWeaponSkinObtained, self, self.OnNewWeaponSkinObtained)
  self:AddDispatcher(EventID.OnNewWeaponAccessoryObtained, self, self.OnNewWeaponAccessoryObtained)
end

function M:OnWeaponColorsChanged()
  self:ResetTarget()
end

function M:OnNewWeaponAccessoryObtained(AccessoryId)
  self:AddTimer(0.01, function()
    self:OnNewAccessoryObtained(AccessoryId)
  end)
end

function M:OnNewWeaponSkinObtained(SkinId)
  self:AddTimer(0.01, function()
    self:OnNewSkinObtained(SkinId)
  end)
end

function M:AddTopTabReddotListen()
  if self.NoReddot then
    return
  end
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  
  local function SetTopTabReddot(TabIdx, IsNew)
    local Content = self.TopTabs[TabIdx]
    Content.IsNew = IsNew
    if IsValid(Content.UI) then
      Content.UI:SetReddot(Content.IsNew)
    end
  end
  
  self:AddWeaponAppearanceReddotListen(function()
    local NewSkinCount = 0
    local Data = DataMgr.Weapon[self.Target.WeaponId]
    if Data and Data.SkinApplicationType then
      for _, value in pairs(Data.SkinApplicationType) do
        local NodeName = CommonConst.DataType.WeaponSkin .. (value or "")
        local NewSkinNode = ReddotManager.GetTreeNode(NodeName)
        NewSkinCount = NewSkinCount + (NewSkinNode and NewSkinNode.Count or 0)
      end
    end
    local NewAccessoryNode = ReddotManager.GetTreeNode(CommonConst.DataType.WeaponAccessory)
    local NewAccessoryCount = NewAccessoryNode and NewAccessoryNode.Count or 0
    SetTopTabReddot(1, NewSkinCount > 0)
    SetTopTabReddot(2, NewAccessoryCount > 0)
  end, self.Target.WeaponId)
end

function M:RemoveTopTabReddotListen()
  if self.NoReddot then
    return
  end
  self:RemoveWeaponAppearanceReddotListen()
end

function M:InitWeaponSkin()
  local SkinId = self.JumpToSkinId or self.SelectedSkinId
  self.JumpToSkinId = nil
  self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  self:InitWeaponSkinList()
  self:SelectSkinById(SkinId)
end

function M:InitWeaponSkinList()
  if self.bWeaponSkinListInited then
    return
  end
  self.bWeaponSkinListInited = true
  self.SkinMap = {}
  self.SkinArray = {}
  local Avatar = GWorld:GetAvatar()
  local CurWeaponId = self.Target.WeaponId
  local CurSkin = self.Target:GetCurrentSkin() or {}
  local CurSkinId = CurSkin.SkinId or CurWeaponId
  local LeafNodeNamePre = CommonConst.DataType.WeaponSkin
  for SkinId, Data in pairs(DataMgr.WeaponSkin) do
    if not UIUtils.CanApplyWeaponSkin(CurWeaponId, Data.ApplicationType) then
    elseif not Avatar.OwnedWeaponSkins[SkinId] and not UIUtils.ShouldDisplayItem(CommonConst.DataType.WeaponSkin, SkinId) then
    else
      local CacheDetail = {}
      if not self.NoReddot then
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeNamePre .. (Data.ApplicationType or "")) or {}
      end
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      rawset(Obj, "SkinId", Data.SkinID)
      rawset(Obj, "ItemId", Data.SkinID)
      rawset(Obj, "IconPath", Data.LongIcon)
      rawset(Obj, "Name", GText(Data.Name))
      rawset(Obj, "Name_World", EnText(Data.Name))
      rawset(Obj, "Rarity", Data.Rarity)
      rawset(Obj, "Text", GText(Data.Dec))
      rawset(Obj, "Owner", self)
      rawset(Obj, "OnClicked", self.OnSkinItemClicked)
      rawset(Obj, "bDyeable", true)
      rawset(Obj, "RedDotType", 1 == CacheDetail[SkinId] and UIConst.RedDotType.NewRedDot)
      rawset(Obj, "ItemType", CommonConst.DataType.WeaponSkin)
      rawset(Obj, "IsTargetUnowned", self.IsTargetUnowned)
      rawset(Obj, "SkinId", Data.SkinID)
      if Avatar.OwnedWeaponSkins[SkinId] then
        rawset(Obj, "LockType", false)
      else
        rawset(Obj, "LockType", SkinId ~= CurWeaponId)
      end
      local WeaponTypeInfo = DataMgr.WeaponTypeContrast[Data.ApplicationType]
      if WeaponTypeInfo then
        rawset(Obj, "CharName", string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
        rawset(Obj, "WeaponTypeIcon", WeaponTypeInfo.Icon)
      end
      self.SkinMap[Obj.SkinId] = Obj
      table.insert(self.SkinArray, Obj)
      self:OnSkinContentCreated(Obj)
    end
  end
  table.sort(self.SkinArray, function(a, b)
    return a.SkinId < b.SkinId
  end)
  local WeaponData = self.Target:Data()
  local DefaultSkin = NewObject(UIUtils.GetCommonItemContentClass())
  rawset(DefaultSkin, "SkinId", CurWeaponId)
  rawset(DefaultSkin, "IconPath", WeaponData.LongIcon or WeaponData.GachaIcon)
  rawset(DefaultSkin, "Owner", self)
  rawset(DefaultSkin, "OnClicked", self.OnSkinItemClicked)
  rawset(DefaultSkin, "bDyeable", true)
  rawset(DefaultSkin, "IsTargetUnowned", self.IsTargetUnowned)
  self.SkinMap[DefaultSkin.SkinId] = DefaultSkin
  table.insert(self.SkinArray, 1, DefaultSkin)
  self:OnSkinContentCreated(DefaultSkin)
  if CurSkinId and self.SkinMap[CurSkinId] then
    self.CurrentSkinContent = self.SkinMap[CurSkinId]
    self.CurrentSkinContent.IsEquipped = true
  end
  self:InitSkinList()
end

function M:OnWeaponSkinChanged(Ret, WeaponUuid, SkinId)
  self:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:ResetTarget()
  if self.CurrentSkinContent then
    ArmoryUtils:SetItemSelectTag(self.CurrentSkinContent, false)
  end
  self.CurrentSkinContent = self.SkinMap[SkinId]
  ArmoryUtils:SetItemSelectTag(self.CurrentSkinContent, true)
  self:UpdateFunctionBtn(self.CurrentSkinContent, self.CurrentSkinContent)
end

function M:OnWeaponSkinConfirmBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ChangeWeaponAppearanceSkin(self.Target.Uuid, self.SelectedSkinId)
end

function M:InitWeaponAccessory()
  self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  self:CreateWeaponAccessoryContents(self.Target)
  if self.ArmoryHelper then
    self.ArmoryHelper:ResetRotation()
  end
  self.NoneAccessory.bSelectTag = false
  self.NoneAccessory.IsSelect = false
  self.CurrentContent = self.NoneAccessory
  if #self.Array_WeaponAccessoryContents <= 0 then
    self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:UpdateAccessoryDetails(self.CurrentContent)
    return
  end
  if self.ComparedContent then
    self.ComparedContent.IsSelect = false
    if self.ComparedContent.SelfWidget then
      self.ComparedContent.SelfWidget:SetSelected(self.ComparedContent.IsSelect)
    end
  end
  self.ComparedContent = nil
  self:InitWeaponAccessoryList()
  self:SelectAccessoryItem(self.ComparedContent)
  self.List_Accessory:BP_ScrollItemIntoView(self.ComparedContent)
end

local function AddWeaponAccessoryContent(self, AccessoryId)
  local Data = DataMgr.WeaponAccessory[AccessoryId]
  local Content = self:CreateWeaponAccessoryContent(Data)
  if Content then
    Content.SoundDataName = "WeaponAccessory"
    self.BP_AccessoryContents:Add(Content)
    self.Map_AccessoryContents[AccessoryId] = Content
    table.insert(self.Array_WeaponAccessoryContents, Content)
    self:CheckWeaponAccessoryContentReddot(AccessoryId)
    self:OnAccessoryContentCreated(Content)
  end
end

function M:CheckWeaponAccessoryContentReddot(AccessoryId)
  if self.NoReddot then
    return
  end
  local Content = self.Map_AccessoryContents[AccessoryId]
  if not Content then
    return
  end
  local CacheDetail = {}
  local ReddotName = CommonConst.DataType.WeaponAccessory
  if ReddotManager.GetTreeNode(ReddotName) then
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.WeaponAccessory) or {}
  end
  Content.RedDotType = 1 == CacheDetail[AccessoryId] and UIConst.RedDotType.NewRedDot
end

function M:CreateWeaponAccessoryContents(Weapon, bRecreate)
  if self.IsAccessoryContentsCreated and not bRecreate then
    return
  end
  self.IsAccessoryContentsCreated = true
  self.CurrentContent = nil
  self.ComparedContent = nil
  self.NoneAccessory = NewObject(UIUtils.GetCommonItemContentClass())
  self.NoneAccessory.Id = -1
  self.NoneAccessory.Parent = self
  self.NoneAccessory.Icon = UIUtils.GetNoneAccessoryIconPath()
  self.NoneAccessory.ItemType = CommonConst.DataType.WeaponAccessory
  self.BP_AccessoryContents:Clear()
  self.BP_AccessoryContents:Add(self.NoneAccessory)
  self:OnAccessoryContentCreated(self.NoneAccessory)
  self.Map_AccessoryContents = {}
  self.Array_WeaponAccessoryContents = {}
  local Avatar = GWorld:GetAvatar()
  for AccessoryId, Data in pairs(DataMgr.WeaponAccessory) do
    if Avatar:IsWeaponAccessoryExist(AccessoryId) or UIUtils.ShouldDisplayItem(CommonConst.DataType.WeaponAccessory, AccessoryId) then
      AddWeaponAccessoryContent(self, AccessoryId)
    end
  end
  for key, AccessoryId in pairs(Avatar.WeaponAccessorys) do
    local Content = self.Map_AccessoryContents[AccessoryId]
    if Content then
      Content.IsHide = nil
      Content.LockType = nil
    end
  end
  local AppearanceSuit = Weapon:GetAppearance()
  for _, AccessoryId in pairs(AppearanceSuit.Accessory) do
    local Content = self.Map_AccessoryContents[AccessoryId]
    if Content then
      Content.bSelectTag = true
    end
  end
end

function M:OnAccessoryContentCreated(Content)
end

function M:CreateWeaponAccessoryContent(Data)
  if Data.BeginTime then
    local Time = TimeUtils.NowTime()
    if Time < Data.BeginTime:GetTime() then
      return
    end
  end
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.ItemType = CommonConst.DataType.WeaponAccessory
  Obj.Icon = Data.Icon or ""
  Obj.Id = Data.WeaponAccessoryId
  Obj.AccessoryId = Data.WeaponAccessoryId
  Obj.SortPriority = Data.SortPriority or 0
  Obj.LockType = 2
  Obj.IsHide = Data.IsHide
  Obj.IsSelect = false
  Obj.UnlockOptionText = GText(Data.UnlockOption or "")
  Obj.Parent = self
  Obj.Rarity = Data.Rarity or 0
  return Obj
end

function M:InitWeaponAccessoryList()
  self.List_Accessory:ClearListItems()
  table.sort(self.Array_WeaponAccessoryContents, function(a, b)
    if a.LockType and b.LockType or not a.LockType and not b.LockType then
      if a.SortPriority == b.SortPriority then
        return a.AccessoryId > b.AccessoryId
      end
      return a.SortPriority > b.SortPriority
    else
      return b.LockType
    end
  end)
  self.List_Accessory:AddItem(self.NoneAccessory)
  self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
  self.FilteredContents = {}
  for _, Content in ipairs(self.Array_WeaponAccessoryContents) do
    if not Content.IsHide then
      if self.JumpToAccessoryId and self.JumpToAccessoryId == Content.AccessoryId then
        self.ComparedContent = Content
      end
      if Content.bSelectTag then
        self.CurrentContent = Content
      end
      self.List_Accessory:AddItem(Content)
      table.insert(self.FilteredContents, Content)
    end
  end
  self.JumpToAccessoryId = nil
  self.CurrentContent.IsSelect = true
  self.ComparedContent = self.ComparedContent or self.CurrentContent
  self.ComparedContent.IsSelect = true
end

function M:OnWeaponSkinGoToShopBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  local SkinInfo = DataMgr.WeaponSkin[self.SelectedSkinId]
  if not SkinInfo then
    return
  end
  local ItemIds = SkinInfo.GoShopTypeId
  if not ItemIds or not next(ItemIds) then
    return
  end
  for _, ItemId in ipairs(ItemIds) do
    local ShopItemData = DataMgr.ShopItem[ItemId]
    if ShopItemData then
      local bSuccess, JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType, "Shop", ShopItemData.TypeId)
      if bSuccess and JumpToPage then
        JumpToPage()
        return
      end
    end
  end
  Utils.ScreenPrint("皮肤表对应的商品Id可能没配对,麻烦策划检查一下")
end

function M:SelectAccessoryItem(Content)
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  self.ActorController:ChangeWeaponAccessory(Content.AccessoryId)
end

function M:RecoverAccessory()
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  if not self.ComparedContent or self.ComparedContent == self.CurrentContent then
    return
  end
  self.ActorController:ChangeWeaponAccessory(self.CurrentContent.AccessoryId)
end

function M:OnWeaponAccessoryConfirmBtnClicked()
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  if self.ComparedContent.AccessoryId then
    Avatar:ChangeWeaponAppearanceAccessory(self.Target.Uuid, self.ComparedContent.AccessoryId)
  else
    Avatar:ChangeWeaponAppearanceAccessory(self.Target.Uuid, -1)
  end
end

function M:OnWeaponAccessoryChanged(Ret, WeaponUuid, AccessoryId)
  self:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:ResetTarget()
  self:OnEquipedAccessoryContentChanged()
  self:UpdateAccessoryDetails(self.CurrentContent)
end

function M:OnTopTabSelected(TabWidget, Content)
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  if self.CurrentTopTabIdx == self.SkinTabIdx then
    rawset(self, "bRecoverAppearanceWhenDestruct", true)
    if self.IsAccessoryContentsCreated then
      self:RecoverAccessory()
    end
    self:InitWeaponSkin()
  else
    self.Tab_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Mask_Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitWeaponAccessory()
  end
end

function M:UpdateActorAppearance(SkinId)
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  SkinId = SkinId or self.CurrentSkinContent and self.CurrentSkinContent.SkinId
  if not SkinId then
    return
  end
  self:UpdateActorSkin(SkinId)
  self:UpdateActorColors(SkinId)
end

function M:UpdateActorSkin(SkinId)
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  self.ActorController:ChangeWeaponSkin(SkinId)
end

function M:UpdateActorColors(SkinId)
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  local ColorInfo = self.Target:DumpColors(SkinId)
  self.ActorController:ChangeWeaponColor(ColorInfo)
end

function M:OnConfirmBtnClicked()
  if self.Type ~= CommonConst.ArmoryType.Weapon then
    return
  end
  if self.CurrentTopTabIdx == self.SkinTabIdx and not self.CurrentLockContent then
    self:OnWeaponSkinConfirmBtnClicked()
  elseif self.CurrentTopTabIdx == self.SkinTabIdx and self.CurrentLockContent then
    self:OnWeaponSkinGoToShopBtnClicked()
  else
    self:OnWeaponAccessoryConfirmBtnClicked()
  end
end

return M
