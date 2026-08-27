require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  if self.Btn_Height then
    self.Btn_Height:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Init(UserData, CommonKeyDatas)
  self.ItemPlacedCallBack = UserData.ItemPlacedCallBack
  self.GuildManager = UserData.GuildManager
  self.OperatorSave = UserData.OperatorSave
  local Config = {
    Owner = self,
    HintText = GText("UI_SearchComponent"),
    bLimitBr = true,
    Events = {
      OnTextChanged = self.RefreshTabsData
    }
  }
  self.Input_Name:Init(Config)
  self:InitButton()
  self:RefreshTabsData("")
  self.ComponentWidgetMap = {}
  self.List_Component.BP_OnEntryInitialized:Clear()
  self.List_Component.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
  self:InitGuildEvents()
end

function M:InitGuildEvents()
  if self.GuildManager and self.GuildManager.OnBuyItemChanged then
    self.GuildManager.OnBuyItemChanged:Add(self, self.OnGuildItemCountChanged)
  end
end

function M:OnGuildItemCountChanged(ChangedItemIds)
  if not ChangedItemIds then
    return
  end
  local GuildItemCount = self.GuildManager and self.GuildManager.GuildItemCount
  local IdList = ChangedItemIds.ToTable and ChangedItemIds:ToTable() or nil
  if not IdList then
    IdList = {}
    for Index = 1, ChangedItemIds:Num() do
      IdList[#IdList + 1] = ChangedItemIds:Get(Index)
    end
  end
  local ListItems = self.List_Component and self.List_Component.GetListItems and self.List_Component:GetListItems() or nil
  for _, ItemID in ipairs(IdList) do
    local ItemCount = GuildItemCount and GuildItemCount[ItemID]
    local Count = ItemCount and ItemCount.TotalCount or 0
    if ListItems then
      for _, Item in pairs(ListItems:ToTable()) do
        if Item and Item.UnitId == ItemID then
          Item.Count = Count
          break
        end
      end
    end
    local Widget = self.ComponentWidgetMap and self.ComponentWidgetMap[ItemID]
    if Widget and IsValid(Widget) and Widget.RefreshCount then
      Widget:RefreshCount(Count)
    end
  end
end

function M:OnEntryInitialized(Content, Widget)
  if not (Content and Content.UnitId) or not Widget then
    return
  end
  for UnitId, EntryWidget in pairs(self.ComponentWidgetMap or {}) do
    if EntryWidget == Widget and UnitId ~= Content.UnitId then
      self.ComponentWidgetMap[UnitId] = nil
      break
    end
  end
  self.ComponentWidgetMap[Content.UnitId] = Widget
end

function M:RefreshTabsData(FilterText)
  local GuildItems = DataMgr.GuildItem or {}
  local FilterItems = {}
  local FilterContent = {}
  for Key, Data in pairs(GuildItems) do
    local Name = Data.Name
    FilterContent[Key] = GText(Name)
  end
  FilterItems = CommonUtils.FuzzySearch(FilterContent, FilterText)
  local SortedKeys = {}
  for K, Data in pairs(GuildItems) do
    if FilterItems[K] then
      SortedKeys[#SortedKeys + 1] = K
    end
  end
  table.sort(SortedKeys)
  local CategoryMap = {}
  local Level1Index = {}
  local Level2Index = {}
  for _, K in ipairs(SortedKeys) do
    local Item = GuildItems[K]
    local Level1 = DataMgr.GuildFirstCategory[Item.FirstCategory].Name
    local Level2 = DataMgr.GuildSecondCategory[Item.SecondCategory].Name
    if not Level1Index[Level1] then
      Level1Index[Level1] = #CategoryMap + 1
      CategoryMap[Level1Index[Level1]] = {
        Key = Level1,
        Subs = {}
      }
    end
    local Level1List = CategoryMap[Level1Index[Level1]].Subs
    local L2Key = Level1 .. "|" .. Level2
    if not Level2Index[L2Key] then
      Level2Index[L2Key] = #Level1List + 1
      Level1List[Level2Index[L2Key]] = {
        Key = Level2,
        Items = {}
      }
    end
    table.insert(Level1List[Level2Index[L2Key]].Items, Item.ItemID)
  end
  self.GuildItemCategory = CategoryMap
  local TabData = {
    LeftKey = "Q",
    RightKey = "E",
    Tabs = {}
  }
  for Index, Item in ipairs(CategoryMap) do
    table.insert(TabData.Tabs, {
      Text = GText(Item.Key),
      TabId = Index
    })
  end
  self.Tab:Init(TabData)
  self.Tab:BindEventOnTabSelected(self, self.OnTabChanged)
  self.Tab:ClickTab(1)
end

function M:InitButton()
  self.Btn_Save:SetText(GText("UI_SaveAndPublish"))
  self.Btn_Save:BindEventOnClicked(self, function()
    if self.OperatorSave then
      self.OperatorSave()
    end
  end)
  self.bBtn_Fold = false
  self.Btn_Fold.Btn_Fold.OnClicked:Clear()
  self.Btn_Fold.Btn_Fold.OnClicked:Add(self, function()
    self.bBtn_Fold = not self.bBtn_Fold
    if self.bBtn_Fold then
      self:PlayAnimation(self.List_Out)
    else
      self:PlayAnimation(self.List_In)
    end
  end)
end

function M:OnTabChanged()
  local TabIndex = self.Tab:GetCurrentTabIndex()
  self:SwitchTabIndex(TabIndex)
end

function M:SwitchTabIndex(TabIndex)
  if not self.GuildItemCategory or TabIndex > #self.GuildItemCategory then
    return
  end
  local TabData = {
    LeftKey = "Z",
    RightKey = "C",
    Tabs = {}
  }
  for Index, Item in ipairs(self.GuildItemCategory[TabIndex].Subs) do
    table.insert(TabData.Tabs, {
      Text = Item.Key,
      TabId = Index
    })
  end
  self.SubTab:Init(TabData)
  self.SubTab:BindEventOnTabSelected(self, self.OnSubChanged)
  self.SubTab:ClickTab(1)
end

function M:OnSubChanged()
  local TabIndex = self.Tab:GetCurrentTabIndex()
  local SubTabIndex = self.SubTab:GetCurrentTabIndex()
  self:SwitchSubTabIndex(TabIndex, SubTabIndex)
end

function M:SwitchSubTabIndex(TabIndex, SubTabIndex)
  if not self.List_Component then
    return
  end
  if not self.GuildItemCategory or TabIndex > #self.GuildItemCategory or SubTabIndex > #self.GuildItemCategory[TabIndex].Subs then
    return
  end
  self.ComponentWidgetMap = {}
  local ItemList = self.GuildItemCategory[TabIndex].Subs[SubTabIndex].Items
  self.List_Component:ClearListItems()
  for _, UnitId in ipairs(ItemList) do
    local ClassPath = UIUtils.GetCommonItemContentClass()
    local Item = NewObject(ClassPath)
    local Data = DataMgr.GuildItem[UnitId]
    local Name = Data.Name
    Item.Icon = self.GuildManager:GetAssetObjectIconStringPath(UnitId)
    Item.Name = Name
    Item.UnitId = UnitId
    Item.Count = self.GuildManager.GuildItemCount and self.GuildManager.GuildItemCount[UnitId] and self.GuildManager.GuildItemCount[UnitId].TotalCount or 0
    Item.PlacedCallBack = self.ItemPlacedCallBack
    self.List_Component:AddItem(Item)
  end
end

return M
