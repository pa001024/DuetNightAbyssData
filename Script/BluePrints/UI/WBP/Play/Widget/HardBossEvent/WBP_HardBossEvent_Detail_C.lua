require("UnLua")
local CommonUtils = require("Utils.CommonUtils")
local RewardUtils = require("Utils.RewardUtils")
local ItemUtils = require("Utils.ItemUtils")
local MonsterUtils = require("Utils.MonsterUtils")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local TypeSort = {
  Char = 1,
  Weapon = 2,
  Mod = 3,
  Draft = 4,
  Reward = 5,
  Resource = 6
}
local HardBossRewardPopupCacheKey = "HardBossEventRewardPopup"
local RESTORE_CELL_FOCUS_TIMER = "HardBossEventRestoreCellFocus"
local REFRESH_LIST_ARROW_TIMER = "HardBossEventListArrow"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.WBP.Play.Widget.Common.TeamEnterDungeonComponent"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self:InitEnterDungeon({
    SoloButton = self.Button_Solo,
    MultiButton = self.Button_Multi,
    SoloTextKey = "DUNGEONSINGLE",
    MultiTextKey = "DUNGEONMATCH"
  })
  if self.Controller_Reward then
    self.Controller_Reward:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Down"}
      }
    })
  end
  if self.Controller_Monster then
    self.Controller_Monster:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Down"}
      }
    })
  end
  if self.Controller_Buff then
    self.Controller_Buff:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Up"}
      }
    })
  end
  if self.Controller_Select_Reward then
    self.Controller_Select_Reward:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      }
    })
    self.Controller_Select_Reward:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
  self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
  self:InitGamePadState()
  self:AddInputMethodChangedListen()
  if self.DefaultList then
    self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.List_Prop then
    self.List_Prop.OnCreateEmptyContent:Bind(self, self.CreateEmptyItem)
  end
  if self.List_Monster then
    self.List_Monster.OnCreateEmptyContent:Bind(self, self.CreateEmptyMonsterItem)
  end
  self.CurrentFocusType = "SelectCell"
  self.FocusTypeName = "SelfWidget"
  self.BtnPreviewBound = false
  self.BtnDetailBound = false
  self.TabInited = false
  self.LevelListArrowBound = false
end

function M:InitHardBossDetail(Owner, HardBossDungeonId)
  self.Owner = Owner
  self:InitHardBossData(HardBossDungeonId)
end

function M:BlockAllUIInput(bBlock, Reason)
  if self.Owner and self.Owner.BlockAllUIInput then
    self.Owner:BlockAllUIInput(bBlock, Reason)
  end
end

function M:IsAllUIInputBlocked()
  if self.Owner and self.Owner.IsAllUIInputBlocked then
    return self.Owner:IsAllUIInputBlocked()
  end
  return false
end

function M:Destruct()
  self:RemoveDispatcher(EventID.CurrentSquadChange)
  self:RemoveDispatcher(EventID.UnLoadUI)
  self:RemoveTimer(RESTORE_CELL_FOCUS_TIMER)
  self:DeinitEnterDungeon()
end

function M:OnSystemUIUnLoad(UIName)
  if not (self.Owner and self.Owner.IsDetailActive) or not self.Owner:IsDetailActive() then
    return
  end
  self:RestoreFocusAfterSystemUI()
end

function M:GetCurrentTabList()
  if self.CurrentTabIdx == self.MonsterTabId then
    return self.List_Monster
  end
  return self.List_Prop
end

function M:RestoreFocusAfterSystemUI()
  self:RemoveTimer(RESTORE_CELL_FOCUS_TIMER)
  
  local function TryRestore()
    if not IsValid(self) then
      return
    end
    if self:HasAnyUserFocus() or self:HasFocusedDescendants() then
      return
    end
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
      if self.Owner and self.Owner.RestoreKeyboardFocusToPage then
        self.Owner:RestoreKeyboardFocusToPage()
      end
      return
    end
    if self.CurrentFocusType == "List" then
      local List = self:GetCurrentTabList()
      if IsValid(List) then
        List:SetFocus()
        self:UpdatKeyDisplay("RewardWidget")
        return
      end
    end
    self:SelectCellFocus()
  end
  
  self:AddTimer(0.05, TryRestore, false, 0, RESTORE_CELL_FOCUS_TIMER, true)
  self:AddTimer(0.35, TryRestore, false, 0, RESTORE_CELL_FOCUS_TIMER .. "Retry", true)
end

function M:InitHardBossData(HardBossDungeonId)
  assert(HardBossDungeonId, "HardBossDungeonId 不能为空")
  self.HardBossDungeonId = HardBossDungeonId
  local SelectCfg = DataMgr.HardBossEventDungeonSelect[HardBossDungeonId]
  if not SelectCfg then
    DebugPrint("[HardBossEvent] 未找到 HardBossEventDungeonSelect:", HardBossDungeonId)
    return
  end
  self:InitLevelList(SelectCfg.DungeonId or {})
end

function M:InitLevelList(DungeonList)
  self.ScrollBox_List:ClearChildren()
  if not DungeonList or 0 == #DungeonList then
    return
  end
  self.SelectCell = nil
  local DefaultSelect = DungeonList[1]
  for _, DungeonId in ipairs(DungeonList) do
    local Dun = DataMgr.Dungeon[DungeonId]
    if Dun and PageJumpUtils:CheckDungeonCondition(Dun.Condition) then
      DefaultSelect = DungeonId
      break
    end
  end
  for i, DungeonId in ipairs(DungeonList) do
    local Item = self:CreateWidgetNew("HardBossLevelItem")
    Item:BindEventOnClicked(self, self.OnClickedLevelCell, Item)
    Item:InitDungeonInfo(DungeonId, i, false, self)
    self.ScrollBox_List:AddChild(Item)
    if DungeonId == DefaultSelect then
      Item:SetSelect(true)
      self.SelectCell = Item
    end
  end
  self:RefreshLevelListNavigation()
  self:RefreshInfoListNavigation()
  self:InitLevelListArrow()
  if self.SelectCell then
    self:InitListCellInfo(self.SelectCell.DungeonId)
  end
  self:InitTabInfo()
  self:BindDetailBtn()
  self:BindPreviewBtn()
  self.ObtainTabId = 1
  self.MonsterTabId = 2
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:SelectCellFocus()
  end
end

function M:RefreshLevelListNavigation()
  local ScrollBox = self.ScrollBox_List
  if not ScrollBox then
    return
  end
  ScrollBox:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  ScrollBox:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  ScrollBox:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  ScrollBox:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  local Count = ScrollBox:GetChildrenCount()
  for Index = 0, Count - 1 do
    local FocusTarget = self:GetLevelItemFocusTarget(Index)
    if FocusTarget then
      FocusTarget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
      FocusTarget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      local PrevTarget = self:GetLevelItemFocusTarget(Index - 1)
      local NextTarget = self:GetLevelItemFocusTarget(Index + 1)
      if PrevTarget then
        FocusTarget:SetNavigationRuleExplicit(EUINavigation.Up, PrevTarget)
      else
        FocusTarget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      end
      if NextTarget then
        FocusTarget:SetNavigationRuleExplicit(EUINavigation.Down, NextTarget)
      else
        FocusTarget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      end
    end
  end
end

function M:RefreshInfoListNavigation()
  local Lists = {
    self.List_Prop,
    self.List_Monster
  }
  for _, List in ipairs(Lists) do
    if IsValid(List) then
      List:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      List:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
      List:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    end
  end
end

function M:GetLevelItemFocusTarget(Index)
  local ScrollBox = self.ScrollBox_List
  if not ScrollBox or Index < 0 or Index >= ScrollBox:GetChildrenCount() then
    return nil
  end
  local Item = ScrollBox:GetChildAt(Index)
  return Item and Item.Bg_List and Item.Bg_List.Button_Area or nil
end

function M:GetFocusedLevelItem()
  local ScrollBox = self.ScrollBox_List
  if not ScrollBox then
    return nil
  end
  for Index = 0, ScrollBox:GetChildrenCount() - 1 do
    local FocusTarget = self:GetLevelItemFocusTarget(Index)
    if IsValid(FocusTarget) and FocusTarget:HasAnyUserFocus() then
      return ScrollBox:GetChildAt(Index)
    end
  end
  return nil
end

function M:RefreshLevelListArrow()
  local ScrollBox = self.ScrollBox_List
  if not ScrollBox then
    return
  end
  UIUtils.UpdateScrollBoxArrow(ScrollBox, self.List_ArrowTop, self.List_ArrowBottom)
  UIUtils.UpdateScrollBoxArrow(ScrollBox, self.Arrow_Up, self.Arrow_Down)
end

function M:InitLevelListArrow()
  if not self.ScrollBox_List then
    return
  end
  if not self.LevelListArrowBound then
    self.ScrollBox_List.OnUserScrolled:Add(self, self.RefreshLevelListArrow)
    self.LevelListArrowBound = true
  end
  self:AddTimer(0.03, function()
    if IsValid(self) then
      self:RefreshLevelListArrow()
    end
  end, false, 0, REFRESH_LIST_ARROW_TIMER, true)
end

function M:OnClickedLevelCell(Item)
  if not Item or not Item.DungeonId then
    return
  end
  if self.SelectCell and self.SelectCell ~= Item then
    self.SelectCell:SetSelect(false)
  end
  Item:SetSelect(true)
  self.SelectCell = Item
  self:InitListCellInfo(Item.DungeonId)
end

function M:InitListCellInfo(DungeonId)
  self.CurSelectedDungeonId = DungeonId
  self:InitSquad(DungeonId)
  self:RefreshLevelCellContent(DungeonId)
end

function M:InitSquad(DungeonId)
  if not self.DefaultList then
    return
  end
  local DungeonData = DataMgr.Dungeon[DungeonId]
  if not DungeonData then
    return
  end
  if DungeonData.Squad then
    self.DefaultList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local DungeonType = DungeonData.DungeonType
    local Avatar = GWorld:GetAvatar()
    local SquadId = Avatar and Avatar.DungeonSquad and Avatar.DungeonSquad[DungeonType] or 0
    self.SquadId = SquadId
    self.DefaultList:Init(self, false, SquadId, DungeonId)
  else
    self.SquadId = nil
    self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnCurrentSquadChange(SquadId, IsComMissing)
  self.SquadId = SquadId
end

function M:RefreshLevelCellContent(DungeonId)
  if not DungeonId then
    return
  end
  local DungeonData = DataMgr.Dungeon[DungeonId]
  if not DungeonData then
    return
  end
  self.Title_Level:SetText(GText(DungeonData.DungeonName))
  self.Text_Summary:SetText(GText(DungeonData.DungeonDes))
  self:RefreshRewardTimes(DungeonId)
  self:RefreshBuffInfoList(DungeonId)
  self:RefreshRewardInfoList(DungeonId)
  self:RefreshMonsterInfoList(DungeonId)
  self:RefreshWarningHint(DungeonId)
end

function M:RefreshRewardTimes(DungeonId)
  local DungeonCfg = DataMgr.HardBossEventDungeon[DungeonId]
  local bShowTimes = DungeonCfg and DungeonCfg.HardBossType == "Reward"
  if self.Group_TimeTips then
    self.Group_TimeTips:SetVisibility(bShowTimes and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  end
  if not bShowTimes then
    return
  end
  local EventId = DataMgr.HardBossEventDungeonId2EventId and DataMgr.HardBossEventDungeonId2EventId[DungeonId]
  local MainCfg = EventId and DataMgr.HardBossEventMain[EventId]
  local Avatar = GWorld:GetAvatar()
  local Total = MainCfg and MainCfg.PeriodRewardTime or 0
  local Left = Avatar and Avatar.HardBossEvent and Avatar.HardBossEvent.RewardTimesLeft or 0
  if self.Text_Now then
    self.Text_Now:SetText(tostring(Left))
  end
  if self.Text_Total then
    self.Text_Total:SetText(tostring(Total))
  end
  if self.Text_TimeTipsTitle then
    self.Text_TimeTipsTitle:SetText(GText("UI_HardBoss_ChancesRemain"))
  end
end

function M:RefreshBuffInfoList(DungeonId)
  if not self.List_Buff then
    return
  end
  self.List_Buff:ClearListItems()
  local Cfg = DataMgr.HardBossEventDungeon[DungeonId]
  local BuffId = Cfg and Cfg.DungeonBuff
  local RaidCfg = BuffId and DataMgr.RaidBuff[BuffId]
  if not RaidCfg then
    return
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.RaidDungeonBuffData = RaidCfg
  self.List_Buff:AddItem(Content)
end

function M:RefreshRewardInfoList(DungeonId)
  if not self.List_Prop then
    return
  end
  assert(DataMgr.Dungeon[DungeonId], "副本信息不存在:" .. DungeonId)
  self.List_Prop:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  local FirstRewardList
  if Avatar and (not Avatar.Dungeons[DungeonId] or not Avatar.Dungeons[DungeonId].IsPass) then
    local RewardInfo = DataMgr.Reward[DataMgr.Dungeon[DungeonId].FirstCompleteReward]
    if RewardInfo then
      FirstRewardList = {}
      local RewardIds = RewardInfo.Id or {}
      local RewardCounts = RewardInfo.Count or {}
      local RewardTypes = RewardInfo.Type or {}
      for i = 1, #RewardIds do
        local ItemId = RewardIds[i]
        local ItemType = RewardTypes[i]
        table.insert(FirstRewardList, {
          Id = ItemId,
          Type = ItemType,
          ItemCount = RewardUtils:GetCount(RewardCounts[i]),
          Icon = ItemUtils.GetItemIcon(ItemId, ItemType),
          Rarity = ItemUtils.GetItemRarity(ItemId, ItemType),
          bFirst = true,
          DropType = "FirstReward"
        })
      end
    end
  end
  local RewardView = DataMgr.Dungeon[DungeonId].DungeonRewardView
  local RewardList = RewardView and RewardUtils:GetRewardViewInfoById(RewardView) or {}
  for _, ItemData in ipairs(RewardList) do
    if not ItemData.DropType then
      ItemData.DropType = "DropType_Fixed"
    end
  end
  
  local function SortFunc(A, B)
    if A.Rarity == B.Rarity then
      if TypeSort[A.Type] and TypeSort[B.Type] then
        if TypeSort[A.Type] == TypeSort[B.Type] then
          return A.Id < B.Id
        end
        return TypeSort[A.Type] < TypeSort[B.Type]
      end
      return A.Id < B.Id
    end
    return A.Rarity > B.Rarity
  end
  
  if FirstRewardList then
    table.sort(FirstRewardList, SortFunc)
  end
  table.sort(RewardList, SortFunc)
  self.RewardList = {}
  if FirstRewardList then
    for _, v in ipairs(FirstRewardList) do
      table.insert(self.RewardList, v)
    end
  end
  for _, v in ipairs(RewardList) do
    table.insert(self.RewardList, v)
  end
  for _, ItemData in ipairs(self.RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = true
    Content.UIName = "HardBossEventDetail"
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnRewardTipsMenuChanged
    }
    if ItemData.bFirst then
      Content.BonusType = 2
    end
    local BaseCount = ItemData.ItemCount or nil
    if ItemData.Quantity then
      if #ItemData.Quantity > 1 then
        Content.MaxCount = ItemData.Quantity[2]
      end
      BaseCount = ItemData.Quantity[1] or nil
    end
    if BaseCount then
      Content.Count = BaseCount
    end
    self.List_Prop:AddItem(Content)
  end
  if 0 == self.List_Prop:GetNumItems() then
    self.List_Prop:AddItem(self:CreateEmptyItem())
  end
  self.List_Prop:RequestFillEmptyContent()
end

function M:OnRewardTipsMenuChanged(IsOpen, Content)
  if IsOpen then
    return
  end
  if self.Owner and self.Owner.RestoreKeyboardFocusToPage then
    self.Owner:RestoreKeyboardFocusToPage()
  end
end

function M:RefreshMonsterInfoList(DungeonId)
  if not self.List_Monster then
    return
  end
  self.List_Monster:ClearListItems()
  self.MonsterIdToItem = {}
  local DungeonData = DataMgr.Dungeon[DungeonId]
  local MonsterSource = DungeonData and DungeonData.DungeonMonsters
  if MonsterSource and next(MonsterSource) then
    local DisplayMonsters = CommonUtils.DeepCopy(MonsterSource)
    table.sort(DisplayMonsters, MonsterUtils.CompareMonsters)
    for _, MonsterId in ipairs(DisplayMonsters) do
      local MonsterData = DataMgr.Monster[MonsterId]
      local bRelease = MonsterData and GameState(self).IsUnitRelease(MonsterId)
      if bRelease then
        local Content = NewObject(self:GetMonsterItemContentClass())
        Content.ParentWidget = self
        Content.MonsterId = MonsterId
        Content.DisableSelect = true
        Content.SoundEvent = "event:/ui/common/click_mid"
        self.List_Monster:AddItem(Content)
      end
    end
  end
  if 0 == self.List_Monster:GetNumItems() then
    self.List_Monster:AddItem(self:CreateEmptyMonsterItem())
  end
  self.List_Monster:RequestFillEmptyContent()
end

function M:GetMonsterItemContentClass()
  if not self.MonsterItemContentClass then
    self.MonsterItemContentClass = LoadClass("/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content")
  end
  return self.MonsterItemContentClass
end

function M:CreateEmptyMonsterItem()
  local Content = NewObject(self:GetMonsterItemContentClass())
  Content.IsEmpty = true
  return Content
end

function M:RefreshWarningHint(DungeonId)
  if not self.Panel_WarningHint then
    return
  end
  local DungeonData = DataMgr.Dungeon[DungeonId]
  local Avatar = GWorld:GetAvatar()
  local DefaultList = self.DefaultList
  self.Panel_WarningHint:SetVisibility(ESlateVisibility.Collapsed)
  local CharLevel = DefaultList and DefaultList.CurrentCharLevel
  if not (Avatar and CharLevel) or not DungeonData.DungeonLevel then
    return
  end
  local WarnLevel = DataMgr.GlobalConstant and DataMgr.GlobalConstant.TaskWarningLevel
  if CharLevel <= DungeonData.DungeonLevel - (WarnLevel and WarnLevel.ConstantValue or 0) then
    self.Panel_WarningHint:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.Text_Warning then
      self.Text_Warning:SetText(GText("UI_Warning_CharLevel_Low"))
    end
  end
end

function M:CreateEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = 0
  return Content
end

function M:BindDetailBtn()
  if self.BtnDetailBound or not self.Btn_Check then
    return
  end
  if self.Btn_Check.Btn_Click then
    self.Btn_Check.Btn_Click.OnClicked:Add(self, self.OpenDetails)
    self.BtnDetailBound = true
  end
end

function M:OpenDetails()
  local DungeonData = self.CurSelectedDungeonId and DataMgr.Dungeon[self.CurSelectedDungeonId]
  if not DungeonData then
    return
  end
  UIManager(self):LoadUINew("ItemInformation", {
    Name = GText(DungeonData.DungeonName),
    Desc = GText(DungeonData.DungeonContent)
  }, "LevelDatail")
end

function M:BindPreviewBtn()
  if self.BtnPreviewBound then
    return
  end
  if self.Btn_Reward then
    self.Btn_Reward:BindEventOnClicked(self, self.OpenRewardDetails)
  end
  if self.Btn_Buff then
    self.Btn_Buff:BindEventOnClicked(self, self.OpenBuffDetails)
  end
  self.BtnPreviewBound = true
end

function M:OpenRewardDetails()
  AudioManager(self):PlayUISound(self, "event:/ui/common/tip_show_click", nil, nil)
  local Params = {
    RewardList = self.RewardList,
    AutoFocus = true,
    CloseBtnCallbackFunction = function()
      self:SelectCellFocus()
    end
  }
  UIManager(self):ShowCommonPopupUI(100156, Params)
end

function M:OpenBuffDetails()
  if not self.CurSelectedDungeonId then
    return
  end
  local Cfg = DataMgr.HardBossEventDungeon[self.CurSelectedDungeonId]
  local BuffID = Cfg and Cfg.DungeonBuff
  if not BuffID then
    return
  end
  local Environment = UIManager(self):LoadUINew("HardBossEventEnvironment")
  if Environment then
    Environment.Parent = self
    if Environment.Init then
      Environment:Init({BuffID})
    end
  end
end

function M:InitTabInfo()
  if not self.Tab_Info or self.TabInited then
    return
  end
  local SubTabList = {
    {
      Text = GText("UI_DUNGEON_ObtainType"),
      Id = 1
    },
    {
      Text = GText("UI_DUNGEON_MonsterType"),
      Id = 2
    }
  }
  self.Tab_Info:Init({
    LeftKey = "A",
    RightKey = "D",
    Tabs = SubTabList,
    ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Common/Tab/Widget/WBP_Com_TabSubItem01.WBP_Com_TabSubItem01'",
    SoundFunc = function(Owner, TabIdx)
      if Owner and Owner.PlayTabSound then
        Owner:PlayTabSound(TabIdx)
      end
    end,
    SoundFuncReceiver = self
  })
  self.Tab_Info:BindEventOnTabSelected(self, self.OnSubTabChanged)
  self.Tab_Info:SelectTab(1)
  if self.Panel_Info then
    self.Panel_Info:SetVisibility(ESlateVisibility.Visible)
  end
  if self.Group_RewardInfo then
    self.Group_RewardInfo:SetVisibility(ESlateVisibility.Visible)
  end
  if self.Group_MonsterInfo then
    self.Group_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:SetPreviewBtnVisible(true)
  self.TabInited = true
end

function M:OnSubTabChanged(TabWidget)
  if not TabWidget then
    return
  end
  local Idx = TabWidget.Idx or 1
  self.CurrentTabIdx = Idx
  if self.Panel_Info then
    self.Panel_Info:SetVisibility(ESlateVisibility.Visible)
  end
  local bReward = 1 == Idx
  if self.Group_RewardInfo then
    self.Group_RewardInfo:SetVisibility(bReward and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
  end
  if self.Group_MonsterInfo then
    self.Group_MonsterInfo:SetVisibility(not bReward and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
  end
  if self.Panel_Details then
    self.Panel_Details:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:SetPreviewBtnVisible(bReward)
end

function M:SetPreviewBtnVisible(bShow)
  local Vis = bShow and ESlateVisibility.Visible or ESlateVisibility.Collapsed
  if self.Panel_Details_Reward then
    self.Panel_Details_Reward:SetVisibility(Vis)
  end
  if self.Panel_Details_Buff then
    self.Panel_Details_Buff:SetVisibility(Vis)
  end
end

function M:SetPreviewKeyVisible(bVisible)
  local usingPad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  local Vis = bVisible and usingPad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed
  local KeyWidgets = {
    self.Panel_Controller_Reward,
    self.Panel_Controller_Buff,
    self.Panel_Controller_Monster,
    self.Controller_Reward,
    self.Controller_Buff,
    self.Controller_Monster,
    self.Controller_Select_Reward
  }
  for _, KeyWidget in ipairs(KeyWidgets) do
    if KeyWidget then
      KeyWidget:SetVisibility(Vis)
    end
  end
end

function M:SelectMonsterInfoItem(MonsterId)
  UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

function M:SetTabItemSelection(Item)
end

function M:PlayTabSound()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end

function M:OnGamePadDown(InKeyName)
  self:InitGamePadState()
  self.PressedKeys[InKeyName] = true
  local IsDpadUp = true == self.PressedKeys[Const.GamepadDPadUp]
  local IsEventHandled = false
  if not self:IsSquadGamePadOpen() and self:OnEnterDungeonGamePadDown(InKeyName) then
    return true
  end
  if "Gamepad_FaceButton_Right" == InKeyName then
    self.PressedKeys.Gamepad_DPad_Up = nil
    self.PressedKeys.Gamepad_FaceButton_Right = nil
    if self:IsSquadGamePadOpen() then
      self.DefaultList:OnCloseSquadGamepad()
      self:UpdatKeyDisplay("SelfWidget")
    elseif self.FocusTypeName == "RewardWidget" then
      self:SelectCellFocus()
    elseif self.SelectCell and self.SelectCell.Bg_List and self.SelectCell.Bg_List.Button_Area and not self.SelectCell.Bg_List.Button_Area:HasAnyUserFocus() then
      self:SelectCellFocus()
    else
      self:OnReturnKeyDown()
    end
    IsEventHandled = true
  elseif "Gamepad_LeftTrigger" == InKeyName or "Gamepad_RightTrigger" == InKeyName then
    if self.FocusTypeName ~= "RewardWidget" and self.Tab_Info then
      if not self.TabInited then
        self:InitTabInfo()
      end
      self.Tab_Info:Handle_KeyEventOnGamePad(InKeyName)
      IsEventHandled = true
    end
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    self.CurrentFocusType = "List"
    if self.CurrentTabIdx == self.ObtainTabId and self.List_Prop then
      self.List_Prop:SetFocus()
      self:UpdatKeyDisplay("RewardWidget")
    elseif self.CurrentTabIdx == self.MonsterTabId and self.List_Monster then
      self.List_Monster:SetFocus()
      self:UpdatKeyDisplay("RewardWidget")
    end
    if self.Image_Select then
      self.Image_Select:SetRenderOpacity(0)
    end
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnGamePadUp(InKeyName)
  local IsEventHandled = false
  if self.PressedKeys then
    self.PressedKeys[InKeyName] = false
  end
  return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    self:OnGamePadUp(InKeyName)
    if "Gamepad_Special_Right" == InKeyName then
      self:OnSpecialRightUp()
    end
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnSpecialRightUp()
  local TeamHeadUI = self.Owner and self.Owner.TeamHeadUI
  if TeamHeadUI and TeamHeadUI.bIsFocusable then
    return
  end
  if not self:IsSquadPanelVisible() or not self.DefaultList then
    return
  end
  if self.DefaultList.IsShow then
    self.DefaultList:OnCloseSquadGamepad()
  else
    self.DefaultList:OnOpenSquadGamepad()
    self.CurrentFocusType = "DefaultList"
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self:IsSquadGamePadOpen() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  self:InitGamePadState()
  self.PressedKeys[InKeyName] = true
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom and not self:IsFocusList() then
      local Item = self:GetFocusedLevelItem()
      if IsValid(Item) and Item.Bg_List then
        Item.Bg_List:OnCellClicked()
        IsEventHandled = true
      end
    elseif "Gamepad_DPad_Up" == InKeyName and not self:IsFocusList() then
      self:OpenBuffDetails()
      IsEventHandled = true
    elseif "Gamepad_DPad_Down" == InKeyName and not self:IsFocusList() then
      if self.CurrentTabIdx == self.ObtainTabId then
        self:OpenRewardDetails()
      elseif self.CurrentTabIdx == self.MonsterTabId then
        self:OpenMonsterDetails()
      end
      IsEventHandled = true
    elseif "Gamepad_DPad_Left" == InKeyName and not self:IsFocusList() and self:IsSquadPanelVisible() then
      self.DefaultList.Preview:OpenDefaultMenuAnchor()
      self:UpdatKeyDisplay("MenuAnchor")
      IsEventHandled = true
    elseif "Gamepad_DPad_Right" == InKeyName and not self:IsFocusList() and self:IsSquadPanelVisible() then
      local IsChecked = not self.DefaultList.Preview.Switch_Summon:GetChecked()
      self.DefaultList.Preview.Switch_Summon:SetChecked(IsChecked)
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:SwitchSquadAutoPhantom(IsChecked)
      end
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self:InitGamePadState()
    if self:OnGamePadDown(InKeyName) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if "A" == InKeyName and self.Tab_Info then
    self.Tab_Info:TabToLeft()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "D" == InKeyName and self.Tab_Info then
    self.Tab_Info:TabToRight()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Escape" == InKeyName then
    if self:IsSquadGamePadOpen() then
      self.DefaultList:OnCloseSquadGamepad()
    else
      self:OnReturnKeyDown()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:IsFocusList()
  return self.CurrentFocusType == "List"
end

function M:IsSquadGamePadOpen()
  return self.DefaultList and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow
end

function M:IsSquadPanelVisible()
  return self.DefaultList and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
end

function M:SelectCellFocus()
  self:UpdatKeyDisplay("SelfWidget")
  self.CurrentFocusType = "SelectCell"
  if self.SelectCell and self.SelectCell.Bg_List and self.SelectCell.Bg_List.Button_Area and not self.SelectCell.Bg_List.Button_Area:HasAnyUserFocus() then
    self.SelectCell.Bg_List.Button_Area:SetFocus()
  end
end

function M:OnReturnKeyDown()
  if self.Owner and self.Owner.OnReturnKeyDown then
    self.Owner:OnReturnKeyDown()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if self.Owner and self.Owner.IsDetailActive and not self.Owner:IsDetailActive() then
    return
  end
  if self.FocusTypeName == "RewardWidget" then
    self.CurrentFocusType = "SelectCell"
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if not IsUseKeyAndMouse then
    self:SelectCellFocus()
  else
    self:UpdatKeyDisplay("SelfWidget")
  end
  self:UpdateGamePadKeyState(CurInputDevice)
  self:RefreshEnterDungeonKeyVisible(CurInputDevice)
end

function M:UpdateGamePadKeyState(CurInputDevice)
  local usingPad = (CurInputDevice or UIUtils.UtilsGetCurrentInputType()) == ECommonInputType.Gamepad
  local ControllerVis = usingPad and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed
  if self.Panel_Controller_Reward then
    self.Panel_Controller_Reward:SetVisibility(ControllerVis)
  end
  if self.Panel_Controller_Monster then
    self.Panel_Controller_Monster:SetVisibility(ControllerVis)
  end
  if self.Panel_Controller_Buff then
    self.Panel_Controller_Buff:SetVisibility(ControllerVis)
  end
  if self.Controller_Reward then
    self.Controller_Reward:SetVisibility(ControllerVis)
  end
  if self.Controller_Monster then
    self.Controller_Monster:SetVisibility(ControllerVis)
  end
  if self.Controller_Buff then
    self.Controller_Buff:SetVisibility(ControllerVis)
  end
  if self.Controller_Select_Reward then
    self.Controller_Select_Reward:SetVisibility(ControllerVis)
  end
  if self.Com_Key_More then
    self.Com_Key_More:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.Image_KeyMore_Bg then
    self.Image_KeyMore_Bg:SetVisibility(ESlateVisibility.Collapsed)
  end
  if usingPad then
    if self.FocusTypeName == "RewardWidget" or self.FocusTypeName == "MenuAnchor" then
      self:UpdatKeyDisplay(self.FocusTypeName)
    else
      self:UpdatKeyDisplay("SelfWidget")
    end
  else
    self:UpdatKeyDisplay("SelfWidget")
  end
end

function M:UpdatKeyDisplay(FocusTypeName)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  self.FocusTypeName = FocusTypeName
  local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
  local bRewardMode = "RewardWidget" == FocusTypeName
  local bMenuAnchorMode = "MenuAnchor" == FocusTypeName
  if self.Tab_Info then
    local Vis = (bRewardMode or bMenuAnchorMode) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible
    if self.Tab_Info.Key_Left then
      self.Tab_Info.Key_Left:SetVisibility(Vis)
    end
    if self.Tab_Info.Key_Right then
      self.Tab_Info.Key_Right:SetVisibility(Vis)
    end
  end
  self:SetPreviewKeyVisible(not bRewardMode and not bMenuAnchorMode)
  self:SetEnterDungeonKeyVisible(not bRewardMode and not bMenuAnchorMode)
  if self.DefaultList and not bMenuAnchorMode then
    if bRewardMode then
      self.DefaultList:ApplyPcUiLayout()
    else
      self.DefaultList:InitWidgetInfoInGamePad()
    end
  end
  local BottomKeyInfo
  if bRewardMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  elseif bMenuAnchorMode then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_CloseTips"),
        bLongPress = false
      }
    }
  else
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Up",
            Owner = self
          }
        },
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Down",
            Owner = self
          }
        },
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  end
  if StyleOfPlay then
    StyleOfPlay:UpdateOtherPageTab(BottomKeyInfo)
  end
end

function M:OpenMonsterDetails()
  if not self.CurSelectedDungeonId then
    return
  end
  UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self)
end

function M:TeamMatchTimingEnd(arg)
  TeamController:GetModel().bPressedSolo = false
  TeamController:GetModel().bPressedMulti = false
  self:RefreshTeamEntryBtnState(arg)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.Owner and self.Owner.IsDetailActive and self.Owner:IsDetailActive() then
    self:SelectCellFocus()
  end
end

function M:OnPreEnterDungeonCheck(DungeonId, bIsSolo, continueCallback)
  local Cfg = DataMgr.HardBossEventDungeon[DungeonId]
  if not Cfg or Cfg.HardBossType ~= "Reward" then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  local HardBossEvent = Avatar and Avatar.HardBossEvent
  local Left = HardBossEvent and HardBossEvent.RewardTimesLeft or 0
  if Left > 0 then
    return true
  end
  if self:IsHardBossRewardNoMorePrompts() then
    continueCallback(true)
    return false
  end
  local Params = {
    RightCallbackObj = self,
    RightCallbackFunction = function(_, Data)
      self:SaveHardBossRewardNoMorePrompts(Data)
      continueCallback(true)
    end,
    LeftCallbackFunction = function(_, Data)
      self:SaveHardBossRewardNoMorePrompts(Data)
      continueCallback(false)
    end
  }
  UIManager(self):ShowCommonPopupUI(Const.Popup_SecondConfirm, Params)
  return false
end

function M:IsHardBossRewardNoMorePrompts()
  local IsNoMorePrompts = EMCache:Get(HardBossRewardPopupCacheKey .. "NoMorePrompts", true) or false
  if TimeUtils and IsNoMorePrompts then
    local CachedTimestamp = EMCache:Get(HardBossRewardPopupCacheKey .. "Timestamp", true)
    IsNoMorePrompts = TimeUtils.IsTimestampInCurrentWeek(CachedTimestamp)
  end
  return IsNoMorePrompts
end

function M:SaveHardBossRewardNoMorePrompts(Data)
  local IsSelected = Data and Data.SelectHint and Data.SelectHint.IsSelected
  if nil == IsSelected then
    return
  end
  EMCache:Set(HardBossRewardPopupCacheKey .. "NoMorePrompts", IsSelected, true)
  EMCache:Set(HardBossRewardPopupCacheKey .. "Timestamp", TimeUtils.NowTime(), true)
end

AssembleComponents(M)
return M
