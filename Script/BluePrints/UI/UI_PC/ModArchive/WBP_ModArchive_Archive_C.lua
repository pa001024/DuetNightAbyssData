require("UnLua")
local EMCache = require("EMCache.EMCache")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ModModel = ModController:GetModel()
local WBP_ModArchive_Archive_C = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.DelayFrameComponent"
})
WBP_ModArchive_Archive_C._components = {
  "BluePrints.UI.UI_PC.ModArchive.WBP_ModArchive_Archive_GamepadComp"
}

function WBP_ModArchive_Archive_C:Construct()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  self.SelectedSiftItems = nil
  self.SiftItemDatas = nil
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self:InitModId2ArchiveId()
  self:InitModRewardTips()
  self:CheckRewardReddot()
  self:UpdateOnInputDeviceTypeChange()
  self:InitGamePad()
end

function WBP_ModArchive_Archive_C:Destruct()
  self.SelectedSiftItems = nil
  self.SiftItemDatas = nil
end

function WBP_ModArchive_Archive_C:OnSelected(Params)
  if Params then
    self.Owner = Params.Owner
    self.Index = Params.Index
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  if self.CurInputDeviceType == ECommonInputType.GamePad then
    self.Owner:SwitchComKeyTipsState(7)
  else
    self.Owner:SwitchComKeyTipsState(1)
  end
  self.HasSelected = true
  self.AllMods = DataMgr.ModGuideBookArchive
  self.UIName = self.Owner.WidgetName
  self.Keys = {}
  for archiveId, _ in pairs(self.AllMods) do
    table.insert(self.Keys, archiveId)
  end
  self.CurSelectItem = nil
  self.IsInPolarityView = false
  self.IsInSearchView = false
  self:RefreshInfo()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:UpdateOnInputDeviceTypeChange()
  else
    self:SetFocus()
    DebugPrint("ayff test try setfocus on self")
  end
end

function WBP_ModArchive_Archive_C:InitTab()
  local Tabs = {}
  for i, v in pairs(DataMgr.ModGuideBookArchiveTab) do
    local Tab = {
      Text = GText(v.Name),
      Idx = i
    }
    table.insert(Tabs, Tab)
  end
  local ConfigData = {
    Owner = self,
    ChildWidgetName = "TabSubTextItem",
    Tabs = Tabs,
    SoundFuncReceiver = self,
    SoundFunc = self.TabClickSoundFunc
  }
  self.ArchiveTab:Init(ConfigData)
  self.ArchiveTab:BindEventOnTabSelected(self, self.OnTabSelected)
  if self.CurTab then
    self.ArchiveTab:SelectTab(self.CurTab)
  else
    self.ArchiveTab:SelectTab(1)
  end
  self.TabNum = #Tabs
end

function WBP_ModArchive_Archive_C:OnTabSelected()
  self.FirstSelected = true
  local NextTab = self.ArchiveTab:GetCurrentTabIndex()
  if self.CurTab then
    self.PreTab = self.CurTab
  end
  self.CurTab = NextTab
  local NeedUpdateModCount = true
  self:InitTabList(NeedUpdateModCount)
  self:PlayAnimation(self.SwitchTab)
end

function WBP_ModArchive_Archive_C:InitTabList(NeedUpdateModCount)
  local Index = 0
  self:HandlePreTab()
  self.GroupInfo = {}
  self.Widgets = {}
  local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)
  self:RemoveTimer("ModArchiveListFillEmptyContent")
  self.List_Item:ClearListItems()
  if self.List_Item.SetEmptyGridItemCount then
    self.List_Item:SetEmptyGridItemCount(0)
  end
  self.DelayAddItemNumPerFrame = nil
  self.FirstInitDone = false
  self.CurItemWidget = nil
  local Avatar = GWorld:GetAvatar()
  local Index = 0
  self.Mods = {}
  local AllInControlMods = {}
  local UnlockedModCount = 0
  local LockedModCount = 0
  local CurArchiveType = self:GetModArchiveTypeByTabId(self.CurTab)
  if CurArchiveType and DataMgr.ModArchiveInfo and DataMgr.ModArchiveInfo[CurArchiveType] then
    Index = Index + 1
    local CurArchiveInfo = DataMgr.ModArchiveInfo[CurArchiveType]
    local ApplicationTypeSet = {}
    for _, ApplicationTypeId in ipairs(CurArchiveInfo.ApplicationTypeIdList or {}) do
      ApplicationTypeSet[ApplicationTypeId] = true
    end
    for CurModId, ModInfo in pairs(DataMgr.Mod) do
      if ModInfo and ApplicationTypeSet[ModInfo.ApplicationType] then
        local ReleaseVersion = ModInfo.ReleaseVersion
        local Polarity = ModInfo.Polarity
        local ModInfoTest = Avatar:GetModsByModId(CurModId)
        if ModInfo.NotShowInArchive and 1 == ModInfo.NotShowInArchive then
        elseif self.FilterPolarity and -1 ~= self.FilterPolarity and Polarity ~= self.FilterPolarity then
        elseif self.SearchText and not self:DoModInfoSearch(ModInfo, self.SearchText) then
        elseif not self:IsModMatchSift(ModInfo) then
        elseif not ReleaseVersion or ReleaseVersion <= DataMgr.GlobalConstant.CurrentVersion.ConstantValue then
          local LockState = 3
          local ModCount = 0
          if Avatar and Avatar.HoldMods and Avatar.HoldMods[CurModId] then
            LockState = 1
            UnlockedModCount = UnlockedModCount + 1
            ModCount = Avatar.HoldMods[CurModId]
          else
            LockedModCount = LockedModCount + 1
          end
          table.insert(AllInControlMods, {
            ModId = CurModId,
            GroupId = CurArchiveType,
            LockState = LockState,
            Count = ModCount
          })
        end
      end
    end
  end
  table.sort(AllInControlMods, function(a, b)
    local HasA = self.HasMod and self.HasMod[a.ModId] and 1 or 0
    local HasB = self.HasMod and self.HasMod[b.ModId] and 1 or 0
    if HasA ~= HasB then
      return HasA > HasB
    end
    local ModInfoA = DataMgr.Mod[a.ModId]
    local ModInfoB = DataMgr.Mod[b.ModId]
    local RarityA = ModInfoA and ModInfoA.Rarity or 0
    local RarityB = ModInfoB and ModInfoB.Rarity or 0
    if RarityA ~= RarityB then
      return RarityA > RarityB
    end
    return a.ModId < b.ModId
  end)
  self.DelayAddRequestId = (self.DelayAddRequestId or 0) + 1
  self.DelayAddTotalNum = #AllInControlMods
  self.DelayAddAddedNum = 0
  if #AllInControlMods > 0 then
    self:DelayAddModArchiveListItemByRow(1, AllInControlMods, ModBookModsViewState, self.DelayAddRequestId)
  else
    self:SetTipsInfo(nil, 2)
    self.List_Item:RequestFillEmptyContent()
  end
  if NeedUpdateModCount then
    self:UpdateTabModCountText(UnlockedModCount, LockedModCount)
  end
end

function WBP_ModArchive_Archive_C:UpdateTabModCountText(UnlockedCount, LockedCount)
  self.Text_BottomDetail:SetText(GText("UI_ModArchive_CollectedNum"))
  self.Text_NumNow:SetText(tostring(UnlockedCount or 0))
  self.Text_NumTotal:SetText(tostring(LockedCount + UnlockedCount) or 0)
end

function WBP_ModArchive_Archive_C:GetModArchiveItemNumPerFrame()
  if self.DelayAddItemNumPerFrame then
    return self.DelayAddItemNumPerFrame
  end
  local ItemNumPerFrame = tonumber(self.ModArchiveItemNumPerRow)
  if not ItemNumPerFrame and self.List_Item and UIUtils and UIUtils.GetTileViewContentMaxCount then
    ItemNumPerFrame = UIUtils.GetTileViewContentMaxCount(self.List_Item, "X", true, true)
  end
  ItemNumPerFrame = ItemNumPerFrame or 6
  if ItemNumPerFrame < 1 then
    ItemNumPerFrame = 1
  end
  self.DelayAddItemNumPerFrame = ItemNumPerFrame
  return ItemNumPerFrame
end

function WBP_ModArchive_Archive_C:AddModArchiveListItemContent(Entry, listIdx, ModBookModsViewState)
  if not Entry then
    return
  end
  local CurModInfo = DataMgr.Mod[Entry.ModId]
  if not CurModInfo then
    return
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = Entry.ModId
  Content.Rarity = CurModInfo.Rarity
  Content.Icon = CurModInfo.Icon
  Content.ItemName = CurModInfo.Name
  Content.ItemType = "Mod"
  Content.bPlayInAnim = true
  Content.IsSelected = false
  if Entry.Count <= 0 then
    Content.bShadow = true
  else
    Content.bShadow = false
  end
  local ArchiveId = self.ModId2ArchiveId and self.ModId2ArchiveId[Content.Id] or 0
  if ModBookModsViewState and ModBookModsViewState[ArchiveId] and ModBookModsViewState[ArchiveId][Content.Id] == true then
    Content.RedDotType = UIConst.RedDotType.NewRedDot
  end
  local HasThisMod = self.HasMod and self.HasMod[Content.Id]
  if 1 == Entry.LockState then
    Content.bShadow = not HasThisMod
  end
  
  function Content.AfterInitCallback(Widget)
    self.Mods[listIdx] = Widget
    Widget.Root:SetRenderOpacity(0)
    if 1 == listIdx and not self.FirstInitDone then
      self.FirstInitDone = true
      self:SetTipsInfo(CurModInfo, Entry.LockState)
      Widget:SetSelected(true)
      Widget:SetRedDot(nil)
      Widget.Content.RedDotType = nil
      self.CurItemWidget = Widget
      if self.IsInPolarityView or not self.IsInSearchView then
      end
      if ModBookModsViewState[ArchiveId] and ModBookModsViewState[ArchiveId][CurModInfo.Id] then
        ModBookModsViewState[ArchiveId][CurModInfo.Id] = false
      end
      local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.CurTab].ReddotNode
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
      if CacheDetail.NewNum then
        CacheDetail.NewNum = CacheDetail.NewNum - 1
        if CacheDetail.States and CacheDetail.States[CurModInfo.Id] then
          CacheDetail.States[CurModInfo.Id] = false
        end
      end
      ReddotManager.DecreaseLeafNodeCount(ReddotNode, 1, CacheDetail)
      EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
    end
    Widget:PlayAnimation(Widget.In)
  end
  
  Content.OnMouseButtonUpEvents = {
    Obj = self,
    Callback = self.OnItemClicked,
    Params = {
      CurModInfo,
      Entry.LockState,
      listIdx,
      Entry.GroupId
    }
  }
  Content.OnMouseButtonDownEvent = {
    Obj = self,
    Callback = self.OnItemClickDown,
    Params = {listIdx}
  }
  self.List_Item:AddItem(Content)
end

function WBP_ModArchive_Archive_C:TryFocusFirstModItemOnGamepad(DelayRequestId)
  if not UIUtils.IsGamepadInput() then
    return
  end
  if self.IsInPolarityView or self.IsInSearchView then
    return
  end
  self:AddDelayFrameFunc(function()
    if self.DelayAddRequestId ~= DelayRequestId then
      return
    end
    local FirstWidget = self.Mods[1]
    if not FirstWidget then
      return
    end
    self.List_Item:NavigateToIndex(0)
    FirstWidget:SetFocus()
  end, 10, "ModArchiveTabFocusReset")
end

function WBP_ModArchive_Archive_C:DelayAddModArchiveListItemByRow(startIdx, AllInControlMods, ModBookModsViewState, DelayRequestId)
  if self.DelayAddRequestId ~= DelayRequestId then
    return
  end
  local ItemNumPerFrame = self:GetModArchiveItemNumPerFrame()
  local DelayFrameValue = 2
  local TotalNum = #AllInControlMods
  local RealStartIdx = math.max(startIdx or 1, (self.DelayAddAddedNum or 0) + 1)
  local EndIdx = math.min(RealStartIdx + ItemNumPerFrame - 1, TotalNum)
  for listIdx = RealStartIdx, EndIdx do
    self:AddModArchiveListItemContent(AllInControlMods[listIdx], listIdx, ModBookModsViewState)
    self.DelayAddAddedNum = (self.DelayAddAddedNum or 0) + 1
  end
  if 1 == RealStartIdx then
    self:TryFocusFirstModItemOnGamepad(DelayRequestId)
  end
  if TotalNum > (self.DelayAddAddedNum or 0) then
    local NextIdx = (self.DelayAddAddedNum or 0) + 1
    local DelayKey = "DelayAddModArchiveListItem_" .. tostring(DelayRequestId) .. "_" .. tostring(NextIdx)
    self:AddDelayFrameFunc(function()
      self:DelayAddModArchiveListItemByRow(NextIdx, AllInControlMods, ModBookModsViewState, DelayRequestId)
    end, DelayFrameValue, DelayKey)
  elseif self.DelayAddRequestId == DelayRequestId then
    self:AddTimer(0.1, function()
      if self.DelayAddRequestId ~= DelayRequestId then
        return
      end
      self.List_Item:RequestFillEmptyContent()
    end, false, 0, "ModArchiveListFillEmptyContent")
  end
end

function WBP_ModArchive_Archive_C:RefreshBtnRewardState()
end

function WBP_ModArchive_Archive_C:OnItemSelectionChange(Content)
  if Content and Content.SelfWidget then
    Content.SelfWidget:OnMouseButtonDown()
    Content.SelfWidget:OnMouseButtonUp()
  end
end

function WBP_ModArchive_Archive_C:OnItemClicked(ModInfo, LockState, WidgetIndex, GroupId)
  local Widget = self.Mods[WidgetIndex]
  self.FirstSelected = false
  self:SetTipsInfo(ModInfo, LockState)
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.Key_Rewards:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.CanFocusTips then
    else
    end
  end
  if self.CurItemWidget then
    self.CurItemWidget:SetSelected(false)
  end
  self.CurItemWidget = Widget
  if self.CurItemWidget then
    self.CurItemWidget:SetSelected(true)
  end
  self.IsInViewTips = false
  local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)
  local ArchiveId = self.ModId2ArchiveId and self.ModId2ArchiveId[ModInfo.Id] or 0
  if ModBookModsViewState[ArchiveId] and ModBookModsViewState[ArchiveId][ModInfo.Id] then
    ModBookModsViewState[ArchiveId][ModInfo.Id] = false
    Widget:SetRedDot(nil)
    Widget.Content.RedDotType = nil
    local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.CurTab].ReddotNode
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
    if CacheDetail and CacheDetail.NewNum then
      CacheDetail.NewNum = CacheDetail.NewNum - 1
      if CacheDetail.States and CacheDetail.States[ModInfo.Id] then
        CacheDetail.States[ModInfo.Id] = false
      end
    end
    ReddotManager.DecreaseLeafNodeCount(ReddotNode, 1, CacheDetail)
  end
  EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
  self.Owner:RefreshDot()
  self:PlayAnimation(self.Switch)
end

function WBP_ModArchive_Archive_C:OnItemClickDown(Params)
  local WidgetIndex = Params[1]
  if not (WidgetIndex and self.Mods) or not self.Mods[WidgetIndex] then
    return
  end
  local Widget = self.Mods[WidgetIndex]
  if Widget then
    Widget.Root:SetRenderOpacity(1)
  end
end

function WBP_ModArchive_Archive_C:SetTipsInfo(ModInfo, LockState)
  if 2 == LockState then
    self.VB_Tips:SetVisibility(ESlateVisibility.Collapsed)
    self.List_ModStar:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_ItemName:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Empty:SetText(GText("UI_ModGuideBook_Task_Block"))
    return
  else
    self.VB_Tips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.List_ModStar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_ItemName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Hold:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Text_ItemName:SetText(ModModel:GetModFullNameByConf(ModInfo.Id))
  local FontMaterial = self.Text_ItemName:GetDynamicFontMaterial()
  if ModInfo.Rarity and ModInfo.Rarity > 0 then
    FontMaterial:SetTextureParameterValue("IconTex", self["Img_Text_" .. ModInfo.Rarity])
  else
    FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
  end
  local PlayerAvatar = ModController:GetAvatar()
  local Count = 0
  if PlayerAvatar and ModInfo.Id and PlayerAvatar.GetModCount2ModId then
    Count = PlayerAvatar:GetModCount2ModId(ModInfo.Id)
  end
  self.Text_Hold02:SetText(Count)
  self.Text_Describe:SetText(GText(ModInfo.FunctionDes))
  self.Text_Polarity01:SetText(GText("UI_Tips_Polarity_Cost"))
  if ModInfo.Polarity ~= CommonConst.NonePolarity then
    self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Visible)
    local PolarityText = ModModel:GetPolarityText(ModInfo.Polarity)
    self.Text_Polarity:SetText(PolarityText)
  else
    self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Text_MaxLevel:SetText(ModInfo.MaxLevel)
  self.Text_Level:SetText(ModInfo.MaxLevel)
  self.Text_Polarity02:SetText(ModInfo.Cost + ModInfo.MaxLevel * ModInfo.CostChange)
  self:UpdataEffectDetails(ModInfo, ModInfo.MaxLevel)
  if self.Text_Tag then
    self.Text_Tag:SetVisibility(UIConst.VisibilityOp.Visible)
    local AppTypeTexts = {}
    for i, TagText in ipairs(DataMgr.ModTag[ModInfo.ApplicationType].ModTagText) do
      table.insert(AppTypeTexts, GText(TagText))
    end
    local AppTypeText = GText("UI_Tips_ModApplicationType") .. table.concat(AppTypeTexts, ", ")
    self.Text_Tag:SetText(AppTypeText)
  end
  self.Com_Tips_Line:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Com_Tips_Line.Text_Level:SetText(GText("UI_ModTips_MaxLvPreview"))
  self.Content = {Test = 1}
  self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
  self.Text_TaskRewards:SetText(GText("UI_Tips_Obtining"))
  self:SetAccessItem("Mod", ModInfo.Id)
  self.List_ModStar:ClearListItems()
  local StarNum = ModInfo.Rarity
  local StarNum = ModInfo.ModCardLevelMax
  if StarNum and StarNum > 0 then
    self.List_ModStar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    for i = 1, StarNum do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.bActivate = false
      self.List_ModStar:AddItem(Content)
    end
  else
    self.List_ModStar:SetVisibility(ESlateVisibility.Collapsed)
  end
  if ModInfo and ModInfo.ApplySlot and 1 == #ModInfo.ApplySlot and 9 == ModInfo.ApplySlot[1] then
    self.Icon_Halo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Icon_Halo:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.Group_BottomTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_ExpHint:SetText(string.format(GText("UI_Archive_ModCollectionExp"), ModInfo.CollectRewardExp or 0))
end

function WBP_ModArchive_Archive_C:UpdataEffectDetails(ModDataInfo, ModLevel)
  self.EffectDetails:ClearChildren()
  local ModAttrs = ModDataInfo.AddAttrs
  if ModAttrs then
    for _, ModAttr in ipairs(ModAttrs) do
      local AttrNameKey = ""
      if ModAttr.Tag and ModAttr.RateZone then
        AttrNameKey = string.format("%s_%s_%s", ModAttr.AttrName, ModAttr.Tag, ModAttr.RateZone)
      elseif ModAttr.Tag then
        AttrNameKey = string.format("%s_%s", ModAttr.AttrName, ModAttr.Tag)
      elseif ModAttr.RateZone then
        AttrNameKey = string.format("%s_%s", ModAttr.AttrName, ModAttr.RateZone)
      else
        AttrNameKey = ModAttr.AttrName
      end
      local AttrConfig = DataMgr.AttrConfig[AttrNameKey]
      if not AttrConfig then
      else
        local _, ValueStr = ArmoryUtils:GenModAttrData(ModAttr, ModLevel, AttrConfig, ModDataInfo.Id)
        local ModAttrText = GText(AttrConfig.Name) .. ValueStr
        local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
        EffectItem.Text_Effect:SetText(ModAttrText)
        EffectItem.Switch_Type:SetActiveWidgetIndex(0)
        self.EffectDetails:AddChild(EffectItem)
      end
    end
  end
  if ModDataInfo.PassiveEffectsDesc then
    local ModDescText = ArmoryUtils:GenModPassiveEffectDesc(ModDataInfo, ModLevel)
    local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
    EffectItem.Text_Effect01:SetText(GText("UI_MOD_Effect") .. ModDescText)
    EffectItem.Switch_Type:SetActiveWidgetIndex(1)
    self.EffectDetails:AddChild(EffectItem)
  end
end

function WBP_ModArchive_Archive_C:GetMods()
  if not self.HasMod then
    self.HasMod = {}
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.HoldMods then
    for ModId, GetTime in pairs(Avatar.HoldMods) do
      self.HasMod[ModId] = true
    end
  end
end

function WBP_ModArchive_Archive_C:SetAccessItem(ItemType, ItemId)
  self.Method:ClearChildren(ItemType, ItemId)
  local ItemInfo = DataMgr[ItemType][ItemId]
  assert(ItemInfo, "不存在该物品：", ItemType, ItemId)
  self.Panel_Method:SetVisibility(ESlateVisibility.Collapsed)
  self.Access = {}
  if ItemInfo.AccessKey then
    for _, Access in pairs(ItemInfo.AccessKey) do
      PageJumpUtils:GetItemAccess(self, ItemId, ItemType, Access, self.UIName)
    end
    PageJumpUtils:SortAccessItem(self.Method)
    local Tips = self.Method:GetChildrenCount()
    if Tips > 0 then
      self.Panel_Method:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      local TipsChildren = self.Method:GetAllChildren()
      for i = 1, TipsChildren:Length() do
        local Child = TipsChildren:Get(i)
        if Child.JumpFunc then
          local Func = Child.JumpFunc
          
          function Child.JumpFunc()
            CommonUtils:CloseGuideTouchIfExist(self)
            Func()
          end
          
          self.CanFocusTips = true
          table.insert(self.Access, Child)
        end
      end
    end
  end
end

function WBP_ModArchive_Archive_C:TabClickSoundFunc()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end

function WBP_ModArchive_Archive_C:TrySetMousePosition()
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    ULowEntryExtendedStandardLibrary.SetMousePositionInPercentages(0.0, 0.0)
  end
end

function WBP_ModArchive_Archive_C:RefreshInfo()
  self:GetMods()
  self:InitTab()
  self:SetVisibility(ESlateVisibility.Visibility)
  self:PlayAnimation(self.In)
  self:InitPolarityList()
  local SystemUIConfig = DataMgr.SystemUI.ModArchiveMain
  local TopResource = SystemUIConfig.TabCoin
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", self.CurGamepadName)
  self:InitSearch()
  self:InitSift()
end

function WBP_ModArchive_Archive_C:ReceiveEnterState(StackAction)
  WBP_ModArchive_Archive_C.Super.ReceiveEnterState(self, StackAction)
  DebugPrint("zwkkk ReceiveEnterState WBP_ModArchive_Archive_C")
end

function WBP_ModArchive_Archive_C:RefreshTabNew(SubTabNew)
  for i = 1, self.TabNum do
    if SubTabNew[i] then
      self.ArchiveTab:ShowTabRedDot(i, true, false)
    else
      self.ArchiveTab:ShowTabRedDot(i, false, false)
    end
  end
end

function WBP_ModArchive_Archive_C:RefreshTabReddot(SubTabRed)
  for i = 1, self.TabNum do
    if SubTabRed[i] then
      self.ArchiveTab:ShowTabRedDot(i, false, true)
    end
  end
end

function WBP_ModArchive_Archive_C:AddTabReddotListen()
  for i = 1, #DataMgr.ModGuideBookArchiveTab do
    local ReddotName = DataMgr.ModGuideBookArchiveTab[i].ReddotNode
    if ReddotName then
      ReddotManager.AddListenerEx(ReddotName, self, function(self, Count, RdType, RdName)
        if Count > 0 then
          if RdType == EReddotType.Normal then
          elseif RdType == EReddotType.New and self.ArchiveTab then
            self.ArchiveTab:ShowTabRedDot(i, true, false)
          end
        elseif self.ArchiveTab then
          self.ArchiveTab:ShowTabRedDot(i, false, false)
        end
      end)
    end
  end
end

function WBP_ModArchive_Archive_C:OnNodeChange(Count, RdType, RdName)
  if Count > 0 then
    if RdType == EReddotType.Normal then
      if self.ArchiveTab then
        self.ArchiveTab:ShowTabRedDot(self.CurTab, false, true)
      end
    elseif RdType == EReddotType.New and self.ArchiveTab then
      self.ArchiveTab:ShowTabRedDot(self.CurTab, true, false)
    end
  elseif self.ArchiveTab then
    self.ArchiveTab:ShowTabRedDot(self.CurTab, false, false)
  end
end

function WBP_ModArchive_Archive_C:RemoveTabReddotListen()
  for i = 1, #DataMgr.ModGuideBookArchiveTab do
    local ReddotName = DataMgr.ModGuideBookArchiveTab[i].ReddotNode
    if ReddotName then
      ReddotManager.RemoveListener(ReddotName, self)
    end
  end
end

function WBP_ModArchive_Archive_C:OnTipsOpenChanged(bIsOpen)
  self.Owner:OnTipsOpenChanged(bIsOpen)
  if self.CurInputDeviceType ~= ECommonInputType.GamePad then
    return
  end
  if bIsOpen then
    self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.Hidden)
    self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.Hidden)
  else
    self.ArchiveTab.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.ArchiveTab.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function WBP_ModArchive_Archive_C:OnMenuOpenChanged(bIsOpen)
  self.Owner:OnTipsOpenChanged(bIsOpen)
  if self.CurInputDeviceType ~= ECommonInputType.GamePad then
    return
  end
end

function WBP_ModArchive_Archive_C:HandlePreTab()
  if not self.GroupInfo then
    return
  end
  local ModBookModsViewState = EMCache:Get("ModBookModsViewState", true)
  if not ModBookModsViewState then
    return
  end
  local Num = 0
  for _, ModInfo in pairs(self.GroupInfo) do
    if ModInfo then
      for i = 1, #ModInfo.ModList do
        local ModId = ModInfo.ModList[i]
        if ModBookModsViewState and ModBookModsViewState[ModInfo.ArchiveId] and ModBookModsViewState[ModInfo.ArchiveId][ModId] then
          Num = Num + 1
          ModBookModsViewState[ModInfo.ArchiveId][ModId] = false
        end
      end
    end
  end
  EMCache:Set("ModBookModsViewState", ModBookModsViewState, true)
  self.Owner:RefreshDot()
  if self.PreTab then
    local ReddotNode = DataMgr.ModGuideBookArchiveTab[self.PreTab].ReddotNode
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNode)
    local DecreaseNum = 0
    if CacheDetail.NewNum then
      DecreaseNum = CacheDetail.NewNum
      CacheDetail.NewNum = 0
    end
    if CacheDetail.States then
      for index, value in pairs(CacheDetail.States) do
        CacheDetail.States[index] = false
      end
    end
    CacheDetail.NewNum = 0
    ReddotManager.DecreaseLeafNodeCount(ReddotNode, DecreaseNum, CacheDetail)
  end
end

function WBP_ModArchive_Archive_C:PreClose()
  if not self.PreTab then
    self.PreTab = 1
  end
  self:HandlePreTab()
end

function WBP_ModArchive_Archive_C:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    DebugPrint("zwk    Key_IsGamepadKey", InKeyName)
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    DebugPrint("zwk    Key_IsPC", InKeyName)
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function WBP_ModArchive_Archive_C:Handle_OnPCDown(InKeyName)
  if "A" == InKeyName then
    self.ArchiveTab:TabToLeft()
    return true
  elseif "D" == InKeyName then
    self.ArchiveTab:TabToRight()
    return true
  elseif "SpaceBar" == InKeyName then
    return true
  end
  return false
end

function WBP_ModArchive_Archive_C:OnKeyUp(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function WBP_ModArchive_Archive_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("zwkkk   RefreshOpInfoByInputDevice ", CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateOnInputDeviceTypeChange()
end

function WBP_ModArchive_Archive_C:InitPolarityList()
  if not self.PolarityFilterConf then
    self.PolarityFilterConf = {}
    local SortedConfs = ModModel:GetSortedPolarityConfs()
    for _, PolarityInfo in pairs(SortedConfs) do
      table.insert(self.PolarityFilterConf, {
        Polarity = PolarityInfo.Id
      })
    end
  end
  self.Common_PolarityList_PC:Init(self.PolarityFilterConf)
  ModModel:SetSortConf(1, CommonConst.DESC)
  self.Common_PolarityList_PC:BindEventOnSelectionsChanged(self, function()
    self.FilterPolarity = self.Common_PolarityList_PC:GetFilterInfos()
    self:InitTabList()
  end)
end

function WBP_ModArchive_Archive_C:InitSearch()
  self.Com_Search:BindEventOnContentChanged(self, function()
    self.SearchText = self.Com_Search:GetText()
    self:InitTabList()
  end)
  self.Com_Search:SetHintText(GText("UI_Mod_SearchHint"))
end

function WBP_ModArchive_Archive_C:InitSift()
  self.Sift:SetSiftModelId(ModCommon.ModSiftId)
  self.Sift:BindEventOnSelectionsChanged(self, function(_, SelectedItems, ItemDatas)
    self:SetSiftConf(SelectedItems, ItemDatas)
    self:InitTabList()
  end)
end

function WBP_ModArchive_Archive_C:GetSearchText()
  return self.Com_Search:GetText()
end

function WBP_ModArchive_Archive_C:DoModInfoSearch(ModInfo, SearchText)
  if string.isempty(SearchText) then
    return true
  end
  if not ModInfo then
    return false
  end
  
  local function MatchText(Text)
    if not Text then
      return false
    end
    return string.find(tostring(Text), SearchText, 1, true) ~= nil
  end
  
  if MatchText(GText(ModInfo.Name)) or MatchText(ModInfo.Name) then
    return true
  end
  if MatchText(GText(ModInfo.TypeName)) or MatchText(ModInfo.TypeName) then
    return true
  end
  if MatchText(GText(ModInfo.FunctionDes)) or MatchText(ModInfo.FunctionDes) then
    return true
  end
  if ModInfo.AddAttrs then
    for _, ModAttr in ipairs(ModInfo.AddAttrs) do
      local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
      if AttrConfig and (MatchText(GText(AttrConfig.Name)) or MatchText(AttrConfig.Name)) then
        return true
      end
    end
  end
  if ModInfo.PassiveEffectsDesc and MatchText(GText(ModInfo.PassiveEffectsDesc)) then
    return true
  end
  if ModInfo.FilterTag then
    for _, Tag in ipairs(ModInfo.FilterTag) do
      if MatchText(GText(Tag)) or MatchText(Tag) then
        return true
      end
    end
  end
  return false
end

function WBP_ModArchive_Archive_C:IsModMatchSift(ModItem)
  if table.isempty(self.SelectedSiftItems) then
    return true
  end
  local fieldMapping = {}
  local SubIds = DataMgr.SiftModel[ModCommon.ModSiftId].SubId
  for i, SiftId in ipairs(SubIds) do
    local SiftData = DataMgr.SiftDimens[SiftId]
    fieldMapping[i] = SiftData.SelectionField[1]
  end
  for i, SiftItem in pairs(self.SelectedSiftItems) do
    local FieldName = fieldMapping[i]
    local modFieldValue
    if "FilterTag" == FieldName then
      modFieldValue = ModItem.FilterTag
    else
      modFieldValue = ModItem[FieldName]
      if "Level" == FieldName and type(modFieldValue) == "number" and modFieldValue > 1 then
        modFieldValue = 1
      end
      if "bAura" == FieldName then
        local bAura = self:IsAuraMod(ModItem)
        if bAura then
          modFieldValue = 1
        else
          modFieldValue = 0
        end
      end
      if type(modFieldValue) == "number" then
        modFieldValue = tostring(modFieldValue)
      end
    end
    if not modFieldValue then
      return false
    end
    local siftValues = {}
    for _, index in pairs(SiftItem) do
      local siftValue = self.SiftItemDatas[i].SelectionDatas[index]
      if siftValue then
        table.insert(siftValues, siftValue)
      end
    end
    local matched = false
    if "FilterTag" == fieldMapping[i] then
      for _, tagValue in ipairs(modFieldValue) do
        for _, siftValue in ipairs(siftValues) do
          if tagValue == siftValue then
            matched = true
            break
          end
        end
        if matched then
          break
        end
      end
    else
      for _, siftValue in ipairs(siftValues) do
        if modFieldValue == siftValue then
          matched = true
          break
        end
      end
    end
    if not matched then
      return false
    end
  end
  return true
end

function WBP_ModArchive_Archive_C:IsAuraMod(ModItem)
  if not ModItem.ApplySlot then
    return false
  end
  if type(ModItem.ApplySlot) == "table" then
    for _, slot in ipairs(ModItem.ApplySlot) do
      if 9 == slot then
        return true
      end
    end
  else
    return 9 == ModItem.ApplySlot
  end
  return false
end

function WBP_ModArchive_Archive_C:SetSiftConf(SelectedItems, ItemDatas)
  self.SelectedSiftItems = SelectedItems
  self.SiftItemDatas = ItemDatas
end

function WBP_ModArchive_Archive_C:GetInControlModList(ArchiveInfo)
  local InControlModList = {}
  if not ArchiveInfo or not ArchiveInfo.ModList then
    return InControlModList
  end
  for _, ModId in ipairs(ArchiveInfo.ModList) do
    local ModConf = DataMgr.Mod[ModId]
    if ModConf then
      local ReleaseVersion = ModConf.ReleaseVersion
      if not ReleaseVersion or ReleaseVersion <= DataMgr.GlobalConstant.CurrentVersion.ConstantValue then
        table.insert(InControlModList, ModId)
      end
    end
  end
  return InControlModList
end

function WBP_ModArchive_Archive_C:GetArchiveRewardProgress(ArchiveInfo, Avatar)
  local InControlModList = self:GetInControlModList(ArchiveInfo)
  local NeedNum = #InControlModList
  local HoldNum = 0
  for _, ModId in ipairs(InControlModList) do
    if Avatar.HoldMods and Avatar.HoldMods[ModId] then
      HoldNum = HoldNum + 1
    end
  end
  local RewardsGot = Avatar.HoldModRewards and Avatar.HoldModRewards[ArchiveInfo.ArchiveId] and true or false
  local CanReceive = NeedNum > 0 and NeedNum <= HoldNum and not RewardsGot
  return HoldNum, NeedNum, CanReceive, RewardsGot
end

function WBP_ModArchive_Archive_C:GetModArchiveTypeByTabId(TabId)
  local TabInfo = DataMgr.ModGuideBookArchiveTab[TabId]
  if not TabInfo then
    return nil
  end
  for ArchiveType, ArchiveInfo in pairs(DataMgr.ModArchiveInfo or {}) do
    if ArchiveInfo and ArchiveInfo.ArchiveTitle == TabInfo.Name then
      return ArchiveType, ArchiveInfo
    end
  end
  return nil
end

function WBP_ModArchive_Archive_C:GetTabIdByArchiveId(ArchiveId)
  local ArchiveInfo = DataMgr.ModArchiveInfo and DataMgr.ModArchiveInfo[ArchiveId]
  if not ArchiveInfo then
    return nil
  end
  for TabId, TabInfo in pairs(DataMgr.ModGuideBookArchiveTab or {}) do
    if TabInfo and TabInfo.Name == ArchiveInfo.ArchiveTitle then
      return TabId
    end
  end
  return nil
end

function WBP_ModArchive_Archive_C:GetTabModProgress(TabId, Avatar)
  local ArchiveType, ModArchiveConf = self:GetModArchiveTypeByTabId(TabId)
  if not ArchiveType or not ModArchiveConf then
    return 0, 0
  end
  local NowNum = 0
  if Avatar.GetModArchiveStar then
    NowNum = Avatar:GetModArchiveStar(ArchiveType)
  end
  local NumMax = 0
  local ApplicationTypeIdList = ModArchiveConf.ApplicationTypeIdList or {}
  for _, ModInfo in pairs(DataMgr.Mod) do
    if ModInfo and ModInfo.ApplicationType and CommonUtils.HasValue(ApplicationTypeIdList, ModInfo.ApplicationType) then
      local ReleaseVersion = ModInfo.ReleaseVersion
      if (not ReleaseVersion or ReleaseVersion <= DataMgr.GlobalConstant.CurrentVersion.ConstantValue) and not ModInfo.NotShowInArchive then
        NumMax = NumMax + 1
      end
    end
  end
  if NowNum > NumMax then
    NowNum = NumMax
  end
  return NowNum, NumMax
end

function WBP_ModArchive_Archive_C:BuildModRewardItemsByTab(TabId, Avatar)
  local ArchiveType, ModArchiveConf = self:GetModArchiveTypeByTabId(TabId)
  if not ArchiveType or not ModArchiveConf then
    return {}
  end
  local Step = ModArchiveConf.ArchiveStep or 0
  if Step <= 0 then
    return {}
  end
  local NowNum, NumMax = self:GetTabModProgress(TabId, Avatar)
  local TotalRewardNum = NumMax // Step
  local Items = {}
  for RewardIndex = 1, TotalRewardNum do
    local NeedNum = RewardIndex * Step
    local RewardsGot = false
    if Avatar.ModArchiveRewards and Avatar.ModArchiveRewards[ArchiveType] then
      RewardsGot = CommonUtils.HasValue(Avatar.ModArchiveRewards[ArchiveType], NeedNum)
    end
    local CanReceive = false
    if Avatar.CheckModArchiveCanGetReward then
      CanReceive = Avatar:CheckModArchiveCanGetReward(ArchiveType, NeedNum)
    else
      CanReceive = NowNum >= NeedNum and not RewardsGot
    end
    local Item = {}
    Item.ItemId = RewardIndex
    Item.Type = ArchiveType
    Item.ArchiveType = ArchiveType
    Item.Num = NeedNum
    Item.CanReceive = CanReceive
    Item.RewardsGot = RewardsGot
    Item.NotreachText = GText("UI_Archive_CollectionInProgress")
    Item.NotShowNum = true
    Item.Hint = string.format(GText("UI_ModArchive_CollectionRewardNum"), NeedNum)
    Item.SourceNum = NeedNum
    Item.HideProgressAfterGot = true
    Item.ReddotName = "ModArchive_Archive_Reward"
    Item.ReceiveCallBack = self.GetModArchiveRewardFromPopup
    Item.ReceiveParm = {
      Owner = self,
      TabId = TabId,
      ArchiveType = ArchiveType
    }
    local Rewards = {}
    local RewardInfo = DataMgr.Reward[ModArchiveConf.RewardId]
    if RewardInfo then
      local Ids = RewardInfo.Id or {}
      local RewardCount = RewardInfo.Count or {}
      local TableName = RewardInfo.Type or {}
      for i = 1, #Ids do
        local ItemId = Ids[i]
        local RewardContent = {
          ItemType = TableName[i],
          ItemId = ItemId,
          Count = RewardUtils:GetCount(RewardCount[i]),
          Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
        }
        table.insert(Rewards, RewardContent)
      end
    end
    Item.Rewards = Rewards
    table.insert(Items, Item)
  end
  return Items
end

function WBP_ModArchive_Archive_C:RefreshModRewardPopupItems(PopupWidget, TabId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not PopupWidget then
    return
  end
  local ArchiveType, ModArchiveConf = self:GetModArchiveTypeByTabId(TabId)
  if not ArchiveType or not ModArchiveConf then
    return
  end
  local HaveRewardToGet = false
  local NowNum, _ = self:GetTabModProgress(TabId, Avatar)
  for i = 0, PopupWidget.List_Item:GetNumItems() - 1 do
    local Item = PopupWidget.List_Item:GetItemAt(i)
    if Item and Item.ConfigData and Item.ConfigData.Num then
      local NeedNum = Item.ConfigData.Num
      local RewardsGot = false
      if Avatar.ModArchiveRewards and Avatar.ModArchiveRewards[ArchiveType] then
        RewardsGot = CommonUtils.HasValue(Avatar.ModArchiveRewards[ArchiveType], NeedNum)
      end
      local CanReceive = false
      if Avatar.CheckModArchiveCanGetReward then
        CanReceive = Avatar:CheckModArchiveCanGetReward(ArchiveType, NeedNum)
      else
        CanReceive = NowNum >= NeedNum and not RewardsGot
      end
      Item.ConfigData.ArchiveType = ArchiveType
      Item.ConfigData.CanReceive = CanReceive
      Item.ConfigData.RewardsGot = RewardsGot
      Item.ConfigData.SourceNum = NeedNum
      Item.ConfigData.TextProgress = string.format("%d/%d", NowNum, NeedNum)
      if CanReceive then
        HaveRewardToGet = true
      end
      if Item.SelfWidget then
        Item.SelfWidget:RefreshBtn(RewardsGot, CanReceive)
      end
    end
  end
  local NowNum, NumMax = self:GetTabModProgress(TabId, Avatar)
  if PopupWidget.Type and PopupWidget.ConfigData and PopupWidget.ConfigData.Datas and PopupWidget.ConfigData.Datas[PopupWidget.Type] then
    PopupWidget.ConfigData.Datas[PopupWidget.Type].NowNum = NowNum
    PopupWidget.ConfigData.Datas[PopupWidget.Type].NumMax = NumMax
  end
  if PopupWidget.Text_Num and PopupWidget.Text_NumMax then
    PopupWidget.Text_Num:SetText(tostring(NowNum))
    PopupWidget.Text_NumMax:SetText(tostring(NumMax))
  end
  if PopupWidget.RefreshButton then
    PopupWidget:RefreshButton(HaveRewardToGet)
  end
end

function WBP_ModArchive_Archive_C:GetModArchiveRewardFromPopup(Content)
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Content) or not Content.ConfigData then
    return
  end
  local ReceiveParm = Content.ConfigData.ReceiveParm or {}
  local Owner = ReceiveParm.Owner
  local TabId = ReceiveParm.TabId or Content.ConfigData.Type
  local ArchiveType = ReceiveParm.ArchiveType or Content.ConfigData.ArchiveType
  local ArchiveCount = Content.ConfigData.Num
  if not ArchiveType or not ArchiveCount then
    return
  end
  if Avatar.GetModArchiveReward then
    local function Callback(Ret, Rewards)
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, nil)
      
      if Owner and Owner.RefreshModRewardPopupItems then
        Owner:RefreshModRewardPopupItems(Content.Owner, TabId)
        Owner:RefreshBtnRewardState()
        if Owner.Owner and Owner.Owner.RefreshDot then
          Owner.Owner:RefreshDot()
        end
      end
      Content.ConfigData.ReceiveParm.Owner:CheckRewardReddot()
      Content.SelfWidget:RefreshReddotInfo()
    end
    
    Avatar:GetModArchiveReward(ArchiveType, ArchiveCount, Callback)
  else
    return
  end
end

function WBP_ModArchive_Archive_C:GetAllModArchiveRewardsFromPopup(ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and ReceiveAllParm) or not ReceiveAllParm.SelfWidget then
    return
  end
  local Owner = ReceiveAllParm.Owner
  local TabId = ReceiveAllParm.TabId
  local PopupWidget = ReceiveAllParm.SelfWidget
  local ArchiveType = ReceiveAllParm.ArchiveType
  ArchiveType = ArchiveType or self:GetModArchiveTypeByTabId(TabId)
  if not ArchiveType then
    PopupWidget:RefreshButton(false)
    return
  end
  local HasCanGetReward = false
  if Avatar.CheckModArchiveCanGetReward then
    for i = 0, PopupWidget.List_Item:GetNumItems() - 1 do
      local Item = PopupWidget.List_Item:GetItemAt(i)
      if Item and Item.ConfigData and Item.ConfigData.Num and Avatar:CheckModArchiveCanGetReward(ArchiveType, Item.ConfigData.Num) then
        HasCanGetReward = true
        break
      end
    end
  end
  if not HasCanGetReward then
    PopupWidget:RefreshButton(false)
    return
  end
  if Avatar.GetAllModArchiveReward then
    local function Callback(Ret, Rewards)
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, nil)
      
      if Owner and Owner.RefreshModRewardPopupItems then
        Owner:RefreshModRewardPopupItems(PopupWidget, TabId)
        Owner:RefreshBtnRewardState()
        if Owner.Owner and Owner.Owner.RefreshDot then
          Owner.Owner:RefreshDot()
        end
      end
      ReceiveAllParm.Owner:CheckRewardReddot()
    end
    
    Avatar:GetAllModArchiveReward(ArchiveType, Callback)
  else
    return
  end
  self:AddDelayFrameFunc(function()
  end, 6, "ModArchivePopupAllRewardRefresh")
end

function WBP_ModArchive_Archive_C:MakeModRewardDialogParams()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local Params = {}
  Params.ConfigData = {}
  Params.ConfigData.TabInfo = {}
  Params.ConfigData.Items = {}
  Params.ConfigData.HasTab = true
  Params.ConfigData.Datas = {}
  local SortedTabs = {}
  for _, TabInfo in pairs(DataMgr.ModGuideBookArchiveTab) do
    table.insert(SortedTabs, TabInfo)
  end
  table.sort(SortedTabs, function(a, b)
    return a.TabId < b.TabId
  end)
  for Index, TabInfo in ipairs(SortedTabs) do
    local TabId = TabInfo.TabId
    local TabItem = {}
    TabItem.Index = Index
    TabItem.Type = TabId
    TabItem.Title = GText(TabInfo.Name)
    TabItem.ReddotName = "ModArchive_Archive_Reward"
    TabItem.IsShowIcon = false
    table.insert(Params.ConfigData.TabInfo, TabItem)
    local NowNum, NumMax = self:GetTabModProgress(TabId, Avatar)
    local RewardData = {}
    RewardData.ShowIcon = false
    RewardData.NowNum = NowNum
    RewardData.NumMax = NumMax
    RewardData.Type = TabId
    RewardData.Text_Total = GText("UI_ModArchive_CollectedNum")
    RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
    RewardData.ReceiveAllCallBack = self.GetAllModArchiveRewardsFromPopup
    RewardData.ReceiveAllParam = {
      Owner = self,
      TabId = TabId,
      ArchiveType = self:GetModArchiveTypeByTabId(TabId)
    }
    RewardData.Items = self:BuildModRewardItemsByTab(TabId, Avatar)
    Params.ConfigData.Datas[TabId] = RewardData
  end
  if self.CurTab then
    Params.ConfigData.Type = self.CurTab
  elseif Params.ConfigData.TabInfo[1] then
    Params.ConfigData.Type = Params.ConfigData.TabInfo[1].Type
  end
  local CurTabConf = DataMgr.ModGuideBookArchiveTab[self.CurTab or 0]
  Params.ConfigData.ReddotName = CurTabConf and CurTabConf.ReddotNode or nil
  Params.Title = GText("UI_ArchiveCollectionReward")
  return Params
end

function WBP_ModArchive_Archive_C:OnClickModRewardTips()
  local Params = self:MakeModRewardDialogParams()
  if not Params then
    return
  end
  UIManager(self):ShowCommonPopupUI(100261, Params)
  if self.Click then
    self:PlayAnimation(self.Click)
  end
end

function WBP_ModArchive_Archive_C:InitModRewardTips()
  self.Text_RewardDesc:SetText(GText("UI_ModArchive_CollectionReward"))
  self.Button_Reward.OnClicked:Add(self, self.OnClickModRewardTips)
end

function WBP_ModArchive_Archive_C:CheckRewardReddot()
  if not ReddotManager.GetTreeNode("ModArchive_Archive_Reward") then
    ReddotManager.AddNode("ModArchive_Archive_Reward")
  end
  ReddotManager.ClearLeafNodeCount("ModArchive_Archive_Reward", true)
  local CacheDetail = ReddotManager.GetTreeNode("ModArchive_Archive_Reward")
  if not CacheDetail then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local IncreaceNum = 0
  if Avatar and DataMgr.ModArchiveInfo then
    for ArchiveId, ArchiveInfo in pairs(DataMgr.ModArchiveInfo) do
      local StarCount = 0
      if Avatar.GetModArchiveStar then
        StarCount = Avatar:GetModArchiveStar(ArchiveId)
      end
      local CanGetRewardNum = math.floor(StarCount / ArchiveInfo.ArchiveStep)
      local GotRewardNum = CommonUtils.TableLength(Avatar.ModArchiveRewards and Avatar.ModArchiveRewards[ArchiveId])
      if CanGetRewardNum > GotRewardNum then
        IncreaceNum = IncreaceNum + (CanGetRewardNum - GotRewardNum)
      end
      local TabId = self:GetTabIdByArchiveId(ArchiveId)
      CacheDetail.Cache.Detail[TabId] = CanGetRewardNum > GotRewardNum and true or false
    end
  end
  if IncreaceNum > 0 then
    ReddotManager.IncreaseLeafNodeCount("ModArchive_Archive_Reward", IncreaceNum)
  end
  if CacheDetail and CacheDetail.Count > 0 then
    self.Key_Reward.Reddot:SetVisibility(ESlateVisibility.Visible)
  else
    self.Key_Reward.Reddot:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_ModArchive_Archive_C:InitModId2ArchiveId()
  if self.ModId2ArchiveId then
    return
  end
  self.ModId2ArchiveId = {}
  for ArchiveId, ArchiveInfo in pairs(DataMgr.ModGuideBookArchive) do
    for Index, ModId in pairs(ArchiveInfo.ModList) do
      self.ModId2ArchiveId[ModId] = ArchiveId
    end
  end
end

AssembleComponents(WBP_ModArchive_Archive_C)
return WBP_ModArchive_Archive_C
