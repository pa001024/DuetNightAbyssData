require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp"
}

function M:Construct()
  self.Super.Construct(self)
  self.FirstFocus = false
  self.List_Item:SetControlScrollbarInside(true)
  self.List_Item.BP_OnEntryInitialized:Clear()
  self.List_Item.BP_OnEntryInitialized:Add(self, self.OnObjectSetFinished)
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.NotInteractive = true
    Content.IsEmpty = true
    Content.Parent = self
    return Content
  end)
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitListenEvent()
  self:InitWidgetInfoInGamePad()
end

function M:Destruct()
  self.List_Item:ClearListItems()
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self.List_Item.BP_OnEntryInitialized:Remove(self, self.OnObjectSetFinished)
  self:ClearListenEvent()
  self:HorizontalListViewResize_TearDown()
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.EntranceId, self.Type, self.Info = ...
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Touch and self.Type ~= "Skin" and self.Type ~= "WeaponSkin" then
    local WidgetSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Panel_ListCut)
    local Anchors = WidgetSlot:GetAnchors()
    Anchors.Maximum.X = 1
    Anchors.Maximum.Y = 1
    Anchors.Minimum.X = 0
    Anchors.Minimum.Y = 0
    WidgetSlot:SetAnchors(Anchors)
  end
  self:PlayInAnim()
  self:InitCommonTab()
  self:AddTimer(0.01, function()
    self:HorizontalListViewResize_SetUp(self.Panel_ListCut, self.List_Item, 0)
    if next(self.AllTabInfo) == nil then
      self:TabItemClick()
    else
      self.CurTabId = self.AllTabInfo[1].TabId
      self.Com_Tab:BindEventOnTabSelected(self, self.TabItemClick)
      self.Com_Tab:SelectTabById(self.CurTabId)
    end
  end, false, 0, nil, true)
end

function M:InitCommonTab()
  self.AllTabInfo = {}
  local AppearanceCollect = DataMgr.AppearanceCollect
  local AppearanceSubTab = DataMgr.AppearanceSubTab
  if AppearanceCollect[self.EntranceId] and AppearanceCollect[self.EntranceId].SubTabId then
    local SubTabId = AppearanceCollect[self.EntranceId].SubTabId
    for _, TabId in pairs(SubTabId) do
      local AppearanceSubTabInfo = AppearanceSubTab[TabId]
      if AppearanceSubTabInfo then
        table.insert(self.AllTabInfo, {
          Text = GText(AppearanceSubTabInfo.Name),
          IconPath = AppearanceSubTabInfo.TabIcon,
          TabId = AppearanceSubTabInfo.Entrance
        })
      end
    end
  end
  self.Index2TabId = {}
  self.TabId2Index = {}
  for Index, Data in pairs(self.AllTabInfo) do
    self.Index2TabId[Index] = Data.TabId
    self.TabId2Index[Data.TabId] = Index
  end
  table.sort(self.AllTabInfo, function(A, B)
    return A.TabId < B.TabId
  end)
  if #self.AllTabInfo <= 1 then
    self.SingleTab = true
    self.AllTabInfo = {}
  else
    self.SingleTab = false
  end
  if self.AdjustOffset then
    self:AdjustOffset()
  end
  self.TabConfigData = {
    TitleName = GText(DataMgr.AppearanceCollect[self.EntranceId].EntranceName),
    LeftKey = "Q",
    RightKey = "E",
    Tabs = self.AllTabInfo,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.OnClickBack,
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  }
  self.Com_Tab:Init(self.TabConfigData, true)
  self:InitTabReddot()
end

function M:TabItemClick(TabWidget)
  local TabId
  if TabWidget then
    TabId = TabWidget:GetTabId()
  end
  TabId = TabId or DataMgr.AppearanceCollect[self.EntranceId].SubTabId and DataMgr.AppearanceCollect[self.EntranceId].SubTabId[1]
  self.CurTabId = TabId
  self:RefreshList(true)
  local Name
  if self.CurTabId then
    Name = DataMgr.AppearanceSubTab[self.CurTabId].Name
  else
    Name = DataMgr.AppearanceCollect[self.EntranceId].EntranceName
  end
  self.Collect:Init(self.Type, self.EntranceId, nil, Name, self.CurNum, self.SumNum, self, true)
end

function M:RefreshList(bAnimation)
  if nil == bAnimation then
    bAnimation = true
  end
  self:GetListDataByTabId()
  self.FirstFocus = false
  self.List_Item:ClearListItems()
  self.List_Item:ScrollToTop()
  self.List_Item:SetFocus()
  self.ItemId2Index = {}
  self:OnListFillWith()
  if self.List_Item:GetNumItems() > 0 then
    self.List_Item:RequestFillEmptyContent()
    self.List_Item:RequestPlayEntriesAnim()
  end
end

function M:GetListDataByTabId()
  self.CurNum = 0
  self.SumNum = 0
  self.ListDatas = {}
  local AppearanceCollectList = {}
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    AppearanceCollectList = Avatar.AppearanceCollects[self.EntranceId].AppearanceCollectList or {}
  end
  local SubEntracneId = self.CurTabId
  local AppearanceSubTabInfo = DataMgr.AppearanceSubTab[SubEntracneId]
  if AppearanceSubTabInfo then
    if not AppearanceSubTabInfo.FieldName then
      local Data = DataMgr[AppearanceSubTabInfo.ParentIndex]
      if Data then
        for Id, Info in pairs(Data) do
          if not Info.ExcludeCollect then
            local IsLock = true
            self.SumNum = self.SumNum + 1
            if AppearanceCollectList[AppearanceSubTabInfo.ParentIndex .. "#" .. Id] then
              IsLock = false
              self.CurNum = self.CurNum + 1
            end
            self:FillListDatas(Info, IsLock, AppearanceSubTabInfo.ParentIndex)
          end
        end
      end
    else
      local Type = {}
      if AppearanceSubTabInfo.SubType then
        for _, Name in pairs(AppearanceSubTabInfo.SubType) do
          if type(Name) == "string" and string.match(Name, "^%d+$") ~= nil then
            Type[tonumber(Name)] = 1
          else
            Type[Name] = 1
          end
        end
      end
      local Data = DataMgr[AppearanceSubTabInfo.ParentIndex]
      if Data then
        for Id, Info in pairs(Data) do
          if not Info.ExcludeCollect and Info[AppearanceSubTabInfo.FieldName] and Type[Info[AppearanceSubTabInfo.FieldName]] then
            local IsLock = true
            self.SumNum = self.SumNum + 1
            if AppearanceCollectList[AppearanceSubTabInfo.ParentIndex .. "#" .. Id] then
              IsLock = false
              self.CurNum = self.CurNum + 1
            end
            self:FillListDatas(Info, IsLock, AppearanceSubTabInfo.ParentIndex)
          end
        end
      end
    end
  end
  local SkinData = DataMgr.Skin
  table.sort(self.ListDatas, function(A, B)
    if A.IsLock and not B.IsLock then
      return false
    end
    if not A.IsLock and B.IsLock then
      return true
    end
    if A.Rarity == B.Rarity then
      if self.Type == "Skin" then
        local SkinSeries_A = SkinData[A.Id].SkinSeries
        local SkinSeries_B = SkinData[B.Id].SkinSeries
        if SkinSeries_A and SkinSeries_B then
          return A.Id < B.Id
        end
        if not SkinSeries_A and SkinSeries_B then
          return true
        end
        if SkinSeries_A and not SkinSeries_B then
          return false
        end
      end
      return A.Id > B.Id
    end
    if not A.Rarity then
      return false
    end
    if not B.Rarity then
      return true
    end
    return A.Rarity > B.Rarity
  end)
  self:FillReddotInfo()
  if self.Type == "Skin" then
    local NewListDatas = {}
    local SkinSeriesTable = {}
    local SkinUpgradeData = DataMgr.SkinUpgrade
    local NewIndex = 1
    for Index, ItemInfo in ipairs(self.ListDatas) do
      if SkinUpgradeData[ItemInfo.Id] then
        ItemInfo.CanUpgrade = true
        if not ItemInfo.IsLock then
          local CharId = SkinData[ItemInfo.Id].CharId
          local CommonCharsInfo = Avatar.CommonChars[CharId]
          if CommonCharsInfo then
            local OwnedSkins = CommonCharsInfo.OwnedSkins or {}
            if OwnedSkins[ItemInfo.Id] then
              ItemInfo.Level = OwnedSkins[ItemInfo.Id].Level
            end
          else
            ItemInfo.Level = 1
          end
        end
      end
      local SkinSeries = SkinData[ItemInfo.Id].SkinSeries
      if SkinSeries then
        if not SkinSeriesTable[SkinSeries] then
          SkinSeriesTable[SkinSeries] = NewIndex
          NewListDatas[NewIndex] = ItemInfo
          NewIndex = NewIndex + 1
        end
      else
        NewListDatas[NewIndex] = ItemInfo
        NewIndex = NewIndex + 1
      end
    end
    for _, ItemInfo in ipairs(self.ListDatas) do
      local SkinSeries = SkinData[ItemInfo.Id].SkinSeries
      if SkinSeries then
        local Index = SkinSeriesTable[SkinSeries]
        if not NewListDatas[Index].NewTable then
          NewListDatas[Index].NewTable = {}
        end
        if ItemInfo.IsNew then
          table.insert(NewListDatas[Index].NewTable, ItemInfo.Id)
        end
      end
    end
    self.ListDatas = NewListDatas
  end
end

function M:FillListDatas(Data, IsLock, Type)
  local TempTable = {
    Type = Type,
    ResourceSType = Data.ResourceSType,
    Id = Data.SkinId or Data.SkinID or Data.AccessoryId or Data.WeaponAccessoryId or Data.HairId or Data.MountId or Data.ResourceId,
    Rarity = Data.Rarity or Data.MountRarity,
    Name = Data.Name or Data.SkinName or Data.MountName or Data.ResourceName,
    IsLock = IsLock
  }
  if "Skin" == Type or "WeaponSkin" == Type then
    TempTable.Icon = Data.LongIcon
  elseif "Mount" == Type then
    TempTable.Icon = Data.MountIcon
  else
    TempTable.Icon = Data.Icon
  end
  table.insert(self.ListDatas, TempTable)
end

function M:OnListFillWith()
  for Index, ItemInfo in ipairs(self.ListDatas) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    self:SetupListContent(Index, ItemInfo, Content)
    self.ItemId2Index[ItemInfo.Id] = Index
    self.List_Item:AddItem(Content)
  end
end

function M:SetupListContent(ItemIndex, ItemInfo, Content, Type)
  Content.Id = ItemInfo.Id
  Content.Rarity = ItemInfo.Rarity
  Content.IconPath = ItemInfo.Icon
  Content.Name = ItemInfo.Name
  Content.Type = ItemInfo.Type
  Content.IsLock = ItemInfo.IsLock
  Content.IsEmpty = false
  Content.ItemIndex = ItemIndex
  Content.IsNew = ItemInfo.IsNew
  Content.SoundItemType = ItemInfo.SoundItemType
  Content.CanUpgrade = ItemInfo.CanUpgrade
  Content.Level = ItemInfo.Level
  Content.NewTable = ItemInfo.NewTable
  Content.Parent = self
  Content.bToNormalAfterClick = true
  Content.OnMouseButtonUpEvent = {
    Obj = self,
    Callback = self.ClickListItem,
    Params = {Content}
  }
end

function M:FillReddotInfo()
  if self.EntranceId and self.CurTabId then
    local ParentIndex = DataMgr.AppearanceSubTab[self.CurTabId].ParentIndex
    if not ReddotManager.GetTreeNode("AppearanceArchiveNew") then
      ReddotManager.AddNode("AppearanceArchiveNew")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
    if CacheDetail[self.EntranceId] and CacheDetail[self.EntranceId].Ids then
      for Index, ItemInfo in ipairs(self.ListDatas) do
        if ItemInfo.Id and 1 == CacheDetail[self.EntranceId].Ids[ParentIndex .. "#" .. ItemInfo.Id] then
          ItemInfo.IsNew = true
        end
      end
    end
  end
end

function M:OnObjectSetFinished(Content, Widget)
  if 1 == Content.ItemIndex and not self.FirstFocus then
    self.FirstFocus = true
    self.List_Item:BP_NavigateToItem(Content)
  end
end

function M:ClickListItem(Content)
  if Content and not Content.IsEmpty then
    if Content.NewTable then
      if not Content.TargetOptRewardId then
        local TargetOptRewardId
        local OptReward = DataMgr.OptReward
        for OptRewardId, Data in pairs(OptReward) do
          local ItemType = Data.Type[1]
          if "Skin" == ItemType then
            for Index = 1, #Data.Type do
              if Data.Id[Index] == Content.Id then
                TargetOptRewardId = OptRewardId
                break
              end
            end
          end
          if TargetOptRewardId then
            break
          end
        end
        Content.TargetOptRewardId = TargetOptRewardId
      end
      if Content.TargetOptRewardId then
        UIManager(self):LoadUINew("CharSkinPreview", {
          Type = "SelectGeneralSkin",
          OptRewardId = Content.TargetOptRewardId,
          NewTable = Content.NewTable,
          IsAppearanceArchive = true,
          Mode = "Preview"
        })
      end
    elseif self.CurTabId == 402 then
      local ParentIndex = DataMgr.AppearanceSubTab[self.CurTabId].ParentIndex
      local Data = DataMgr[ParentIndex][Content.Id]
      if Data.Video then
        local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo", {
          Path = Data.Video,
          SoundPath = Data.GetSoundPath,
          DestructCB = function()
            self:SetFocus()
          end
        })
        if SkinVideo then
          SkinVideo:SetFocus()
        end
      end
    else
      PageJumpUtils:JumpToSkinPreview({
        ItemType = Content.Type,
        TypeId = Content.Id,
        SinglePreview = true,
        HidePurchase = true
      })
    end
    self:SetArchiveReddotRead(Content)
  end
end

function M:SetArchiveReddotRead(Content)
  if self.EntranceId and self.CurTabId and Content.Id then
    local ParentIndex = DataMgr.AppearanceSubTab[self.CurTabId].ParentIndex
    if not ReddotManager.GetTreeNode("AppearanceArchiveNew") then
      ReddotManager.AddNode("AppearanceArchiveNew")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
    local Idtable = {}
    if Content.NewTable then
      Idtable = Content.NewTable
    else
      table.insert(Idtable, Content.Id)
    end
    local DecreaseNum = 0
    for _, Id in pairs(Idtable) do
      if CacheDetail[self.EntranceId] and CacheDetail[self.EntranceId].Ids and 1 == CacheDetail[self.EntranceId].Ids[ParentIndex .. "#" .. Id] then
        CacheDetail[self.EntranceId].Ids[ParentIndex .. "#" .. Id] = 0
        DecreaseNum = DecreaseNum + 1
      end
    end
    if CacheDetail[self.EntranceId] and CacheDetail[self.EntranceId].Num then
      local Num = CacheDetail[self.EntranceId].Num - DecreaseNum
      if Num < 0 then
        Num = 0
      end
      CacheDetail[self.EntranceId].Num = Num
    end
    self:RefreshItemNew(Content, false)
    ReddotManager.DecreaseLeafNodeCount("AppearanceArchiveNew", DecreaseNum)
    if DecreaseNum > 0 and self.Index2ReddotNum and self.Index2ReddotNum[self.TabId2Index[self.CurTabId]] then
      self.Index2ReddotNum[self.TabId2Index[self.CurTabId]] = self.Index2ReddotNum[self.TabId2Index[self.CurTabId]] - DecreaseNum
      self:RefreshTabReddot()
    end
  end
end

function M:InitTabReddot()
  if next(self.AllTabInfo) == nil then
    return
  end
  self.Index2ReddotNum = {}
  if not ReddotManager.GetTreeNode("AppearanceArchiveNew") then
    ReddotManager.AddNode("AppearanceArchiveNew")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveNew")
  if CacheDetail[self.EntranceId] and CacheDetail[self.EntranceId].Ids and CacheDetail[self.EntranceId].Num and CacheDetail[self.EntranceId].Num > 0 then
    local AppearanceCollect = DataMgr.AppearanceCollect
    local AppearanceSubTab = DataMgr.AppearanceSubTab
    for Index, TabInfo in pairs(self.AllTabInfo) do
      local AppearanceSubTabInfo = AppearanceSubTab[TabInfo.TabId]
      local ParentIndex = AppearanceSubTabInfo.ParentIndex
      local FieldName = AppearanceSubTabInfo.FieldName
      local Type = {}
      if AppearanceSubTabInfo.SubType then
        for _, Name in pairs(AppearanceSubTabInfo.SubType) do
          if type(Name) == "string" and nil ~= string.match(Name, "^%d+$") then
            Type[tonumber(Name)] = 1
          else
            Type[Name] = 1
          end
        end
      end
      self.Index2ReddotNum[Index] = 0
      for Id, Info in pairs(DataMgr[ParentIndex]) do
        if 1 == CacheDetail[self.EntranceId].Ids[ParentIndex .. "#" .. Id] then
          if FieldName then
            if Type[Info[FieldName]] then
              self.Index2ReddotNum[Index] = self.Index2ReddotNum[Index] + 1
            end
          else
            self.Index2ReddotNum[Index] = self.Index2ReddotNum[Index] + 1
          end
        end
      end
    end
  end
  self:RefreshTabReddot()
end

function M:RefreshTabReddot()
  if next(self.AllTabInfo) == nil then
    return
  end
  for Index, _ in pairs(self.AllTabInfo) do
    if self.Index2ReddotNum and self.Index2ReddotNum[Index] and self.Index2ReddotNum[Index] > 0 then
      self.Com_Tab:ShowTabRedDot(Index, true)
    else
      self.Com_Tab:ShowTabRedDot(Index, false)
    end
  end
end

function M:RefreshItemNew(Content, IsNew)
  if Content.NewTable then
    Content.NewTable = {}
  end
  if Content.Entry then
    Content.Entry:SetNew(IsNew)
  else
    Content.IsNew = IsNew
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    self:InitKeyboardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  if UIUtils.HasAnyFocus(self) then
    self.List_Item:SetFocus()
  end
end

function M:InitKeyboardView()
end

function M:InitWidgetInfoInGamePad()
  self.Collect:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
end

function M:BP_GetDesiredFocusTarget()
  return self.List_Item
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      IsEventHandled = true
      self.Collect:OnCellClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsEventHandled = true
      self:OnReturnKeyDown()
    elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    elseif InKeyName == UIConst.GamePadKey.RightShoulder then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  elseif "Q" == InKeyName then
    IsEventHandled = true
    self.Com_Tab:TabToLeft()
  elseif "E" == InKeyName then
    IsEventHandled = true
    self.Com_Tab:TabToRight()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnReturnKeyDown()
  UIUtils.PlayCommonBtnSe(self)
  self:OnClickBack()
end

function M:OnClickBack()
  if self:CheckIsCanCloseSelf() then
    self:Close()
  end
end

function M:CheckIsCanCloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return false
  end
  return true
end

function M:PlayInAnim()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  if self.In then
    self:PlayAnimationForward(self.In)
  end
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  if self.Out then
    self:PlayAnimationForward(self.Out)
  else
    self:Close()
  end
end

function M:Close()
  self.Super.Close(self)
end

AssembleComponents(M)
return M
