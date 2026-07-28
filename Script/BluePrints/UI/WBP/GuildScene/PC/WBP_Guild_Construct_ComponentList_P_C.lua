require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(UserData, CommonKeyDatas)
  self.GuildItemCount = UserData.GuildItems
  self.ItemPlacedCallBack = UserData.ItemPlacedCallBack
  self.GuildManager = UserData.GuildManager
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
  self.Key_List:InitKey(CommonKeyDatas)
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
    local Level1 = Item.FirstCategory
    local Level2 = Item.SecondCategory
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
    Item.Count = self.GuildItemCount[UnitId] or 0
    Item.PlacedCallBack = self.ItemPlacedCallBack
    self.List_Component:AddItem(Item)
    DebugPrint("chenxiaokang", UnitId, Item.Icon, Item.Name)
  end
end

return M
