require("UnLua")
local UIUtils = require("Utils.UIUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local BattleUtils = require("Utils.BattleUtils")
local Utils = {}
Utils.ItemType = {
  Switch = "Switch",
  Slide = "Slide",
  Action = "Action",
  Selection = "Selection"
}
Utils.CacheKeyPrefix = "CameraCustomize_1_5_New_"
Utils.WheelActionItemId = "WheelAction"
local CachedConfig, CachedConfigLanguage
local WheelActionResourceSType = "GestureItem"
local WheelActionSortAttrs = {"Rarity", "UnitId"}
local WheelActionDefaultText = "默认"

local function IsEmpty(Value)
  return nil == Value or "" == Value
end

local function GetCurrentLanguage()
  if CommonConst then
    return not CommonConst.SystemLanguage and CommonConst.SystemLanguages and CommonConst.SystemLanguages.Default
  end
  return nil
end

local function SortBySortId(A, B)
  return (A.SortId or 0) < (B.SortId or 0)
end

local function GetTextByKey(TextKey)
  if IsEmpty(TextKey) then
    return ""
  end
  if GText then
    return GText(TextKey) or TextKey
  end
  return TextKey
end

local function BuildSubItem(Row)
  return {
    Id = IsEmpty(Row.SubKey) and tostring(Row.SubItemId) or Row.SubKey,
    TextKey = Row.TextKey or "",
    Text = GetTextByKey(Row.TextKey),
    NewKey = IsEmpty(Row.NewKey) and Row.SubKey or Row.NewKey,
    SortId = Row.SortId or 0
  }
end

local function BuildItem(Row)
  if IsEmpty(Row.Handler) then
  end
  local Item = {
    Id = IsEmpty(Row.ItemKey) and tostring(Row.ItemId) or Row.ItemKey,
    Type = Row.Type,
    TextKey = Row.TextKey or "",
    Text = GetTextByKey(Row.TextKey),
    NewKey = IsEmpty(Row.NewKey) and Row.ItemKey or Row.NewKey,
    Handler = Row.Handler,
    SortId = Row.SortId or 0,
    ItemId = Row.ItemId
  }
  if Row.Type == Utils.ItemType.Switch then
    Item.DefaultValue = Row.DefaultBool == true
  elseif Row.Type == Utils.ItemType.Slide then
    Item.DefaultValue = Row.DefaultNumber or 0
    Item.Min = Row.MinValue or 0
    Item.Max = Row.MaxValue or 0
    Item.Step = Row.Step or 1
  elseif Row.Type == Utils.ItemType.Action then
    Item.Actions = {}
  elseif Row.Type == Utils.ItemType.Selection then
    Item.AllowAll = true == Row.AllowAll
    Item.DefaultValue = {}
    Item.Options = {}
  end
  return Item
end

local function BuildEmptyConfig()
  return {
    ItemType = Utils.ItemType,
    CacheKeyPrefix = Utils.CacheKeyPrefix,
    Tabs = {},
    Items = {}
  }
end

function Utils.GetConfig()
  local CurrentLanguage = GetCurrentLanguage()
  if CachedConfig and CachedConfigLanguage == CurrentLanguage then
    return CachedConfig
  end
  if not (DataMgr and DataMgr.CameraCustomizeTab and DataMgr.CameraCustomizeItem) or not DataMgr.CameraCustomizeSubItem then
    return BuildEmptyConfig()
  end
  local Config = BuildEmptyConfig()
  local TabByRowId = {}
  local ItemByRowId = {}
  local ControlSelectionByRowId = {}
  for _, Row in pairs(DataMgr.CameraCustomizeTab) do
    local Tab = {
      Id = IsEmpty(Row.TabKey) and tostring(Row.TabId) or Row.TabKey,
      TextKey = Row.TextKey or "",
      Text = GetTextByKey(Row.TextKey),
      Items = {},
      SortId = Row.SortId or 0
    }
    TabByRowId[Row.TabId] = Tab
    table.insert(Config.Tabs, Tab)
  end
  for _, Row in pairs(DataMgr.CameraCustomizeItem) do
    local Item = BuildItem(Row)
    Config.Items[Item.Id] = Item
    ItemByRowId[Row.ItemId] = Item
    local Tab = TabByRowId[Row.TabId]
    if Tab then
      table.insert(Tab.Items, Item.Id)
    end
    if Row.ControlSelectionItemId and 0 ~= Row.ControlSelectionItemId then
      ControlSelectionByRowId[Row.ItemId] = Row.ControlSelectionItemId
    end
  end
  for ItemId, SelectionItemId in pairs(ControlSelectionByRowId) do
    local Item = ItemByRowId[ItemId]
    local SelectionItem = ItemByRowId[SelectionItemId]
    if Item and SelectionItem then
      Item.ControlSelection = SelectionItem.Id
    end
  end
  for _, Row in pairs(DataMgr.CameraCustomizeSubItem) do
    local ParentItem = ItemByRowId[Row.ParentItemId]
    if ParentItem then
      local SubItem = BuildSubItem(Row)
      if ParentItem.Type == Utils.ItemType.Action then
        table.insert(ParentItem.Actions, SubItem)
      elseif ParentItem.Type == Utils.ItemType.Selection then
        table.insert(ParentItem.Options, SubItem)
        ParentItem.DefaultValue[SubItem.Id] = Row.DefaultSelected == true
      end
    end
  end
  table.sort(Config.Tabs, SortBySortId)
  for _, Tab in ipairs(Config.Tabs) do
    table.sort(Tab.Items, function(A, B)
      local ItemA = Config.Items[A]
      local ItemB = Config.Items[B]
      return (ItemA and ItemA.SortId or 0) < (ItemB and ItemB.SortId or 0)
    end)
  end
  for _, Item in pairs(Config.Items) do
    if Item.Actions then
      table.sort(Item.Actions, SortBySortId)
    end
    if Item.Options then
      table.sort(Item.Options, SortBySortId)
    end
  end
  CachedConfig = Config
  CachedConfigLanguage = CurrentLanguage
  return Config
end

function Utils.GetTabById(Config, TabId)
  if not Config then
    return nil
  end
  for _, Tab in ipairs(Config.Tabs or {}) do
    if Tab.Id == TabId then
      return Tab
    end
  end
end

function Utils.BuildSelectionValue(SelectionConfig, StoredValue)
  local Value = {}
  for Key, DefaultValue in pairs(SelectionConfig.DefaultValue or {}) do
    Value[Key] = true == DefaultValue
  end
  if type(StoredValue) == "table" then
    for Key, Selected in pairs(StoredValue) do
      Value[Key] = true == Selected
    end
  end
  return Value
end

function Utils.IsSelectionAllSelected(SelectionConfig, SelectionValue)
  if not SelectionConfig then
    return false
  end
  for _, Option in ipairs(SelectionConfig.Options or {}) do
    if SelectionValue[Option.Id] ~= true then
      return false
    end
  end
  return #(SelectionConfig.Options or {}) > 0
end

function Utils.GetCommonItemContent()
  return NewObject(UIUtils.GetCommonItemContentClass())
end

function Utils.NewWheelActionDefaultContent(Owner)
  local Obj = Utils.GetCommonItemContent()
  Obj.Type = CommonConst.DataType.Resource
  Obj.ItemType = CommonConst.DataType.Resource
  Obj.Id = 0
  Obj.UnitId = 0
  Obj.ResourceSType = ""
  Obj.ResourceCount = ""
  Obj.Count = 0
  Obj.IsEventItemt = false
  Obj.IsEquiped = false
  Obj.Rarity = 0
  Obj.ButtonIcon = 1
  Obj.ParentWidget = Owner
  Obj.bEnableDrag = false
  Obj.ActionName = WheelActionDefaultText
  Obj.IsDefaultAction = true
  Obj.IsPlayableAction = true
  Obj.IsForbiddenAction = false
  Obj.IsNew = false
  return Obj
end

function Utils.GetWheelActionAvatar()
  if ArmoryUtils and ArmoryUtils.GetAvatar then
    return ArmoryUtils:GetAvatar()
  end
  if GWorld and GWorld.GetAvatar then
    return GWorld:GetAvatar()
  end
end

function Utils.IsWheelActionResource(Resource)
  if not Resource or not Resource.Data then
    return false
  end
  local Data = Resource:Data()
  if not Data or not Data.Type then
    return false
  end
  return Resource.ResourceSType == WheelActionResourceSType and Data.Type == "InfiniteBattleItem" and not BattleUtils.ShouldHideCharacterAttributeSwitchPhantom(Data)
end

function Utils.GetPlayableWheelActionResourceIds(Avatar)
  local PlayableResourceIds = {}
  Avatar = Avatar or Utils.GetWheelActionAvatar()
  if not (Avatar and Avatar.Wheels) or not Avatar.Resources then
    return PlayableResourceIds
  end
  local WheelIndex = Avatar.WheelIndex
  local Wheel = WheelIndex and Avatar.Wheels[WheelIndex]
  if not Wheel then
    return PlayableResourceIds
  end
  for _, SlotData in pairs(Wheel) do
    local ResourceId = SlotData and SlotData.ResourceId
    local Resource = ResourceId and Avatar.Resources[ResourceId]
    if ResourceId and Utils.IsWheelActionResource(Resource) then
      PlayableResourceIds[ResourceId] = true
    end
  end
  return PlayableResourceIds
end

function Utils.NewWheelActionContent(Resource, Owner, bPlayable)
  local Data = Resource and Resource:Data()
  if not Data then
    return nil
  end
  local Obj = Utils.GetCommonItemContent()
  Obj.Type = CommonConst.DataType.Resource
  Obj.ItemType = CommonConst.DataType.Resource
  Obj.Id = Resource.ResourceId
  Obj.UnitId = Resource.ResourceId
  Obj.ResourceSType = Resource.ResourceSType or ""
  Obj.ResourceCount = 0
  Obj.Count = Resource.Count
  Obj.IsEventItemt = Obj.ResourceSType == "EventItem"
  Obj.IsEquiped = true == bPlayable
  Obj.IsPlayableAction = true == bPlayable
  Obj.IsForbiddenAction = true ~= bPlayable
  Obj.Rarity = Data.Rarity or 0
  Obj.Icon = Data.Icon
  Obj.CharId = Data.UseParam
  Obj.ButtonIcon = 1
  Obj.ParentWidget = Owner
  Obj.bEnableDrag = false
  Obj.ActionName = GText(Data.ResourceName or Data.Name or "") or tostring(Obj.UnitId)
  if Data.Type == "InfiniteBattleItem" then
    Obj.ResourceCount = ""
    Obj.ItemName = GText("INFINITY_SYMBOL")
  elseif Data.BattleItemLimit then
    Obj.ResourceCount = math.min(Resource.Count or 0, Data.BattleItemLimit)
  end
  Obj.IsNew = ArmoryUtils:TryAddNewResourceReddot(Resource, Resource.ResourceId)
  if Obj.IsNew then
    Obj.RedDotType = UIConst.RedDotType.NewRedDot
  end
  return Obj
end

function Utils.SortWheelActionContents(Contents)
  if not Contents or #Contents <= 0 then
    return
  end
  ArmoryUtils:SortItemContents(Contents, WheelActionSortAttrs, CommonConst.DESC, nil, function(A, B)
    if A.IsEventItemt then
      return true
    end
    if B.IsEventItemt then
      return false
    end
  end)
end

function Utils.BuildWheelActionContents(Owner)
  local Contents = {}
  local Avatar = Utils.GetWheelActionAvatar()
  if not Avatar or not Avatar.Resources then
    table.insert(Contents, Utils.NewWheelActionDefaultContent(Owner))
    return Contents
  end
  local PlayableResourceIds = Utils.GetPlayableWheelActionResourceIds(Avatar)
  local PlayableContents = {}
  local ForbiddenContents = {}
  for _, Resource in pairs(Avatar.Resources) do
    if Utils.IsWheelActionResource(Resource) then
      local bPlayable = PlayableResourceIds[Resource.ResourceId] == true
      local Content = Utils.NewWheelActionContent(Resource, Owner, bPlayable)
      if Content then
        table.insert(bPlayable and PlayableContents or ForbiddenContents, Content)
      end
    end
  end
  Utils.SortWheelActionContents(PlayableContents)
  Utils.SortWheelActionContents(ForbiddenContents)
  table.insert(Contents, 1, Utils.NewWheelActionDefaultContent(Owner))
  for _, Content in ipairs(PlayableContents) do
    table.insert(Contents, Content)
  end
  for _, Content in ipairs(ForbiddenContents) do
    table.insert(Contents, Content)
  end
  return Contents
end

function Utils.HasNewWheelActionResource()
  local Avatar = Utils.GetWheelActionAvatar()
  if not Avatar or not Avatar.Resources then
    return false
  end
  for _, Resource in pairs(Avatar.Resources) do
    if Utils.IsWheelActionResource(Resource) and ArmoryUtils:TryAddNewResourceReddot(Resource, Resource.ResourceId) then
      return true
    end
  end
  return false
end

function Utils.SetWheelActionReddotRead(Content)
  if not Content or not Content.Id then
    return
  end
  ArmoryUtils:SetItemReddotRead(Content, Content.IsNew)
end

function Utils.SetVisibility(Widget, bVisible, bHidden)
  if not Widget then
    return
  end
  if bVisible then
    Widget:SetVisibility(UE4.ESlateVisibility.Visible)
  elseif bHidden then
    Widget:SetVisibility(UE4.ESlateVisibility.Hidden)
  else
    Widget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function Utils.SetText(Widget, Text)
  if Widget and Widget.SetText then
    Widget:SetText(Text or "")
  end
end

function Utils.SetNew(Widget, bVisible)
  if not Widget then
    return
  end
  if Widget.SetEnable then
    Widget:SetEnable(true == bVisible)
  else
    Utils.SetVisibility(Widget, true == bVisible)
  end
end

function Utils.BindClick(Widget, Owner, Func)
  if not (Widget and Owner) or not Func then
    return
  end
  local Button = Widget
  if Widget.Btn_Click then
    Button = Widget.Btn_Click
  elseif Widget.Btn_Area then
    Button = Widget.Btn_Area
  elseif Widget.Button_Area then
    Button = Widget.Button_Area
  elseif Widget.ButtonArea then
    Button = Widget.ButtonArea
  end
  if Button and Button.OnClicked then
    Button.OnClicked:Add(Owner, Func)
  end
end

function Utils.SetSwitcherWidget(Switcher, Widget, Index)
  if not Switcher then
    return
  end
  if Widget and Switcher.SetActiveWidget then
    Switcher:SetActiveWidget(Widget)
  elseif Index and Switcher.SetActiveWidgetIndex then
    Switcher:SetActiveWidgetIndex(Index)
  end
end

function Utils.SetChecked(CheckBox, bChecked, bNotify)
  if not CheckBox then
    return
  end
  if CheckBox.SetChecked then
    CheckBox:SetChecked(true == bChecked, true == bNotify)
  elseif CheckBox.SetIsCheckedWithoutCallback then
    CheckBox:SetIsCheckedWithoutCallback(true == bChecked)
  elseif CheckBox.SetIsChecked then
    CheckBox:SetIsChecked(true == bChecked)
  end
end

function Utils.SetCheckedState(CheckBox, bChecked)
  if not CheckBox then
    return
  end
  bChecked = true == bChecked
  if CheckBox.SetIsCheckedState then
    CheckBox:SetIsCheckedState(bChecked)
    return
  end
  if CheckBox.SetChecked and CheckBox.GetChecked and CheckBox.Open_Normal and CheckBox.Close_Normal then
    CheckBox.IsChecked = bChecked
    if CheckBox.StopAllAnimations then
      CheckBox:StopAllAnimations()
    end
    local Anim = bChecked and CheckBox.Open_Normal or CheckBox.Close_Normal
    if Anim and CheckBox.PlayAnimation then
      CheckBox:PlayAnimation(Anim)
    end
    return
  end
  Utils.SetChecked(CheckBox, bChecked, false)
end

function Utils.GetChecked(CheckBox)
  if not CheckBox then
    return false
  end
  if CheckBox.GetChecked then
    return CheckBox:GetChecked()
  elseif CheckBox.IsChecked then
    return CheckBox:IsChecked()
  end
  return false
end

function Utils.SafeCall(Obj, FuncName, ...)
  if Obj and Obj[FuncName] then
    return Obj[FuncName](Obj, ...)
  end
end

return Utils
