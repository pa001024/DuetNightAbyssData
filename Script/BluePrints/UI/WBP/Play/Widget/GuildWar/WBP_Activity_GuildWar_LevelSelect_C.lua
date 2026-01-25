require("UnLua")
local CommonUtils = require("Utils.CommonUtils")
local MonsterUtils = require("Utils.MonsterUtils")
local WalnutBagController = require("BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagController")
local WalnutBagModel = WalnutBagController:GetModel()
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Play.Widget.GuildWar.GuildWarView"
}
local TypeSort = {
  Char = 1,
  Weapon = 2,
  Mod = 3,
  Draft = 4,
  Reward = 5,
  Resource = 6
}

function M:Construct()
  M.Super.Construct(self)
  M.bOpened = true
  self.Btn_Start:SetText(GText("DUNGEONSINGLE"))
  self.Btn_Start:BindEventOnClicked(self, self.OnClickSolo)
  self.Btn_Ranking:BindEventOnClicked(self, self.OpenGuildWarRank)
  self.Btn_Shop.Btn_Click.OnClicked:Add(self, self.OnShopBtnClicked)
  self.Com_Btn_Details:BindEventOnClicked(self, self.OpenRewardDetails)
  self.Com_Btn_Details_Buff:BindEventOnClicked(self, self.OpenBuffDetails)
  self.ScrollBox_List.OnUserScrolled:Add(self, self.OnUserScrolled)
  self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)
  self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)
  EventManager:AddEvent(EventID.OnRaidRankInfoTopN, self, self.OnRaidRankInfoTopN)
  self:AddDispatcher(EventID.OnRefreshDeputeBtn, self, self.RefreshBtnState)
  self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
  self:AddDispatcher(EventID.OnDisableEscOnDungeonLoading, self, self.DisableEscOnDungeonLoading)
  self:AddDispatcher(EventID.OnRaidRankStart, self, self.Init)
  self:AddDispatcher(EventID.TeamMatchCancel, self, self.OnTeamMatchCancel)
  self.List_Prop.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
  self:AddInputMethodChangedListen()
  self.List_Prop:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Prop:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Prop:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Prop:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Monster:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Monster:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Monster:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Monster:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.IsFocusProp = false
  self.IsFocus_Monster = false
  self.IsFocusEliteProp = false
  self.SquadId = 1
  self.MaxMonNum = 2
  self.WalnutId = nil
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self.FocusTypeName = nil
  self.Panel_Details_Buff:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Btn_Start:SetText(GText("DUNGEONSINGLE"))
  self.Text_Title_Score:SetText(GText("RaidDungeon_Base_Point"))
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:Init()
end

function M:Init()
  self.DungeonList = self:GetCurrentRaidDungeonList()
  if self.DungeonList then
    self:InitLevelList(self.DungeonList)
  end
end

function M:Destruct()
  M.Super.Destruct(self)
  M.bOpened = false
  M.SelectedDungeonId = nil
  self.Btn_Start:UnBindEventOnClickedByObj(self)
  self.Btn_Ranking:UnBindEventOnClickedByObj(self)
end

function M:GetCurrentRaidDungeonList()
  self.RaidSeasons = self:GetRaidSeasons()
  if not self.RaidSeasons then
    DebugPrint("self.RaidSeasons 不存在")
    return nil
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local targetType = 0
  if self.RaidSeasons:IsPreRaidTime() then
    targetType = 1
  elseif self.RaidSeasons:IsRaidTime() then
    targetType = 2
  end
  local resultList = {}
  for _, v in pairs(DataMgr.RaidDungeon) do
    if v.RaidDungeonType == targetType and v.RaidSeason == Avatar.CurrentRaidSeasonId then
      table.insert(resultList, v.DungeonId)
    end
  end
  table.sort(resultList, function(a, b)
    return (a or 0) < (b or 0)
  end)
  return resultList
end

function M:InitLevelList(DungeonList)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "Play_DeputeDetail", nil)
  self:SetFocus()
  self.MonsterIdToItem = {}
  self.TypeTable = {}
  self.TypeTableKeys = {}
  self.CurrentTabIdx = 1
  self.SelectCell = nil
  self.FirstEnter = true
  if not DungeonList then
    return
  end
  self.ActionPointId = DataMgr.ResourceSType2Resource.ActionPoint[1]
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
  self.ObtainTabId = 1
  self.MonsterTabId = 2
  self.Tab_Info:Init({
    LeftKey = "A",
    RightKey = "D",
    Tabs = SubTabList,
    ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Common/Tab/Widget/WBP_Com_TabSubItem01.WBP_Com_TabSubItem01'",
    SoundFunc = self.PlayTabSound,
    SoundFuncReceiver = self
  })
  self.Tab_Info:BindEventOnTabSelected(self, self.OnSubTabChanged)
  self.Tab_Info:SelectTab(1)
  self.ScrollBox_List:ClearChildren()
  self.ScrollBox_List:ScrollToStart()
  self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Wrap)
  self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.ScrollBox_List:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.CurrentRaidSeasonId = Avatar.CurrentRaidSeasonId
  self.RaidSeasons = Avatar.RaidSeasons[self.CurrentRaidSeasonId]
  self.RaidSeasonData = DataMgr.RaidSeason[self.RaidSeasons.RaidSeasonId]
  local LastUnlockedItem, FirstItem
  self:InitOtherPageTab()
  for i, DungeonId in ipairs(DungeonList) do
    local Item = self:CreateWidgetNew("GuildWarLevelItem")
    Item:BindEventOnClicked(self, self.OnClickedLevelCell, Item)
    Item:InitDungeonInfo(DungeonId, i, false, self)
    if 1 == i then
      FirstItem = Item
    end
    if self:CheckDungeonCondition(DungeonId) then
      LastUnlockedItem = Item
    end
    self.ScrollBox_List:AddChild(Item)
  end
  local TargetItem = LastUnlockedItem or FirstItem
  if TargetItem then
    TargetItem.IsSelect = true
    if DataMgr.RaidDungeon[TargetItem.DungeonId].DifficultyLevel <= 1 then
      TargetItem:PlayAnimationForward(TargetItem.Click_Normal)
    else
      TargetItem:PlayAnimationForward(TargetItem.Click)
    end
    self.SelectCell = TargetItem
    self.CurCellDungeonId = TargetItem.DungeonId
    self:InitListCellInfo(TargetItem.DungeonId)
  else
    self.Panel_Detail:SetVisibility(ESlateVisibility.Collapsed)
  end
  if self.SelectCell then
    self:SelectCellFocus()
    self.ScrollBox_List:ScrollWidgetIntoView(self.SelectCell, true, EDescendantScrollDestination.Center)
  end
  local ChildCount = self.ScrollBox_List:GetChildrenCount()
  if not ChildCount or 0 == ChildCount then
    return
  end
  self.ScrollBox_List:GetChildAt(0):SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.ScrollBox_List:GetChildAt(self.ScrollBox_List:GetChildrenCount() - 1):SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self:PlayAnimation(self.In)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:UpdateUIStyleInPlatform(false)
  end
  self.Board:Init()
  if self.RaidSeasons:IsPreRaidTime() and 0 == self.RaidSeasons.MaxRaidScore and self:IsFirstEnterToday() then
    self:OpenGuildWarRewardPop()
  end
  if self.RaidSeasons:IsRaidTime() then
    self.Btn_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Shop.Text_Name:SetText(GText("RaidDungeon_Shop_Name"))
    self.Consume:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Ranking:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if 0 == self.RaidSeasons.MaxPreRaidScore then
      self.Btn_Ranking:ForbidBtn(true)
      self.Btn_Ranking:BindForbidStateExecuteEvent(self, function()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_Abandon_Toast"))
      end)
    end
    local IsNotFirstRaidTime = EMCache:Get("FirstRaidTime", true)
    DebugPrint("判断是是否是首次进入正式赛  IsNotFirstRaidTime : ", IsNotFirstRaidTime)
    if not IsNotFirstRaidTime and 0 ~= self.RaidSeasons.MaxPreRaidScore then
      EMCache:Set("FirstRaidTime", true, true)
      self:OpenGuildWarGroupConfirm()
    end
  else
    self.Btn_Shop:SetVisibility(ESlateVisibility.Collapsed)
    self.Consume:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Ranking:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateTicketNum()
  if not self.RaidSeasons:IsRaidTime() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TicketNumData = DataMgr.RaidDungeon[self.SelectCell.DungeonId].TicketNum
  self.ResId = 0
  self.ConsumeTicketCount = 0
  for key, value in pairs(TicketNumData) do
    self.ResId = key
    self.ConsumeTicketCount = value
  end
  local TicketCount = Avatar.Resources[self.ResId] and Avatar.Resources[self.ResId].Count or 0
  if TicketCount >= self.ConsumeTicketCount then
    self.Switcher_Owned:SetActiveWidgetIndex(0)
    self.Num_Over:SetText(self.ConsumeTicketCount)
  else
    self.Switcher_Owned:SetActiveWidgetIndex(1)
    self.Num_Short:SetText(self.ConsumeTicketCount)
  end
  local Resource = DataMgr.Resource[self.ResId]
  local Icon = LoadObject(Resource.Icon)
  self.Common_Item_Icon:Init({
    Id = self.ResId,
    Icon = Icon,
    ItemType = "Resource",
    IsShowDetails = true,
    IsCantItemSelection = true,
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
  })
end

function M:IsFirstEnterToday()
  local today = os.date("%Y-%m-%d")
  local lastDate = EMCache:Get("GuildWarRewardPopDate", true)
  local isFirstEnter = nil == lastDate or lastDate ~= today
  if isFirstEnter then
    EMCache:Set("GuildWarRewardPopDate", today, true)
  end
  return isFirstEnter
end

function M:InitOtherPageTab()
  local TabConfigData = {
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown,
    StyleName = "Text",
    TitleName = GText("Event_Raid_Title"),
    PopupInfoHotKey = "SpecialLeft",
    GetReplyOnBack = function()
      if self.SelectCell then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.SelectCell)
      else
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.ScrollBox_List)
      end
    end
  }
  if TabConfigData then
    TabConfigData.OverridenTopResouces = DataMgr.SystemUI.GuildWarLevel.TabCoin
  end
  self.Tab:Init(TabConfigData, true)
end

function M:SetPanelDetails(Idx)
  if Idx == self.ObtainTabId then
    self.Text_Details:SetText(GText("UI_CTL_Details"))
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
      self.Switch_Details_Icon:SetActiveWidgetIndex(2)
      self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
      self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Key_Details_GamePad:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Down"}
        }
      })
      self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Key_Details_GamePad_1:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Up"}
        }
      })
    else
      self.Switch_Details_Icon:SetActiveWidgetIndex(1)
      self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(1)
      if not self.Mobile then
        self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
  else
    self.Text_Details:SetText(GText("UI_Dungeon_More"))
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      self.Switch_Details_Icon:SetActiveWidgetIndex(2)
      self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
      self.Key_Details_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Key_Details_GamePad:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Down"}
        }
      })
      self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Key_Details_GamePad_1:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Up"}
        }
      })
      if self.FocusTypeName ~= "RewardWidget" then
        self.Key_MonsterInfo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_MonsterInfo:CreateCommonKey({
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "LS"}
          },
          Desc = GText("UI_Controller_Check")
        })
      end
    else
      self.Switch_Details_Icon:SetActiveWidgetIndex(0)
      self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(1)
      if not self.Mobile then
        self.Key_Details_GamePad:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Details_GamePad_1:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
      end
    end
  end
end

function M:OnSubTabChanged(TabWidget)
  self.CurrentTabIdx = TabWidget.Idx
  self:PlayAnimation(self.Switch_Tab)
  if TabWidget.Idx == self.ObtainTabId then
    self.Panel_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Panel_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
    self:SetPanelDetailsVis(ESlateVisibility.SelfHitTestInvisible)
    if self.CurrentFocusType == "List" then
      self.List_Prop:SetFocus()
      self:UpdatKeyDisplay("RewardWidget")
    end
  elseif TabWidget.Idx == self.MonsterTabId then
    self.Panel_Info:SetVisibility(ESlateVisibility.Collapsed)
    self.Panel_MonsterInfo:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetPanelDetailsVis(ESlateVisibility.Collapsed)
    if self.CurrentFocusType == "List" then
      self.List_Monster:SetFocus()
      self:UpdatKeyDisplay("RewardWidget")
    end
  end
  self:SetPanelDetails(TabWidget.Idx)
end

function M:ItemMenuAnchorChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if bIsOpen then
    self:UpdatKeyDisplay("")
  else
    self:UpdatKeyDisplay("SelfWidget")
    self:SelectCellFocus()
  end
end

function M:OnClickedLevelCell(LevelCell)
  if self.SelectCell ~= nil then
    if self:CheckDungeonCondition(self.SelectCell.DungeonId) then
      self.SelectCell:PlayAnimationReverse(self.SelectCell.Click)
    else
      self.SelectCell:ShowTips(false)
    end
    self.SelectCell.IsSelect = false
  end
  self.SelectCell = LevelCell
  self.SelectCell.IsSelect = true
  if not self:CheckDungeonCondition(self.SelectCell.DungeonId) then
    self.SelectCell:SetTimeShow()
  end
  self.TypeTable = {}
  self.TypeTableKeys = {}
  self.LastMarkType = nil
  self.CurCellDungeonId = LevelCell.DungeonId
  self:InitListCellInfo(LevelCell.DungeonId)
end

function M:InitListCellInfo(DungeonId)
  if self.SelectCell then
    self:SelectCellFocus()
    local RaidDungeon = DataMgr.RaidDungeon[self.CurCellDungeonId]
    local BaseRaidPoint = RaidDungeon.BaseRaidPoint or 0
    self.Text_Score:SetText(BaseRaidPoint)
    self.Text_Floor:SetText(RaidDungeon.DifficultyLevel)
    self:UpdateTicketNum()
  end
  self.CurSelectedDungeonId = DungeonId
  M.SelectedDungeonId = DungeonId
  self.HasTypeSelect = false
  self.Tab_Info:SelectTab(1)
  self:RefreshLevelCellContent(self.CurSelectedDungeonId)
  local bSquad = true
  if bSquad then
    self.DefaultList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local DungeonType = DataMgr.Dungeon[self.CurSelectedDungeonId].DungeonType
    local bDisablePhantom = "Rouge" == DungeonType or false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local SquadId = Avatar.DungeonSquad[DungeonType] and Avatar.DungeonSquad[DungeonType] or 0
      self.DefaultList:Init(self, bDisablePhantom, SquadId, self.CurSelectedDungeonId, true)
    end
  else
    self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
  end
  local CfgDrop = DataMgr.DoubleModDrop and DataMgr.DoubleModDrop[CommonConst.DoubleModDropEventID]
  if not CfgDrop then
    self.Group_TimeTips:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
end

function M:RefreshLevelCellContent(DungeonId)
  if not DungeonId then
    DebugPrint("ZDX DungeonId is nil")
    return
  end
  local DungeonData = DataMgr.Dungeon[DungeonId]
  self.List_Prop:ClearListItems()
  self.List_Monster:ClearListItems()
  self.List_Buff:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:RefreshMonsterInfoList(DungeonId)
  self:RefreshRewardInfoList(DungeonId)
  self:RefreshBuffInfoList()
  self:RefreshBtnState()
end

function M:OpenRewardDetails()
  AudioManager(self):PlayUISound(self, "event:/ui/common/tip_show_click", nil, nil)
  local Params = {}
  Params.RewardList = self.RewardList
  
  function Params.CloseBtnCallbackFunction()
    self:SelectCellFocus()
  end
  
  Params.AutoFocus = true
  local UI = UIManager(self):ShowCommonPopupUI(100156, Params)
end

function M:OpenBuffDetails()
  local GuildWarEnvironment = UIManager(self):LoadUINew("GuildWarEnvironment")
  GuildWarEnvironment:Init(self.RaidBuffIDArry)
end

function M:TryOpenRankTopN()
  if self.RankInfo and self.TopNInfo and self.OpenRankTag then
    self.OpenRankTag = nil
    UIManager():LoadUINew("GuildWarRank", self.RankInfo, self.TopNInfo)
    self:BlockAllUIInput(false)
  end
end

function M:OpenGuildWarRank()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.OpenRankTag = true
  self:BlockAllUIInput(true)
  Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self.RankInfo = {}
      self:TryOpenRankTopN()
    end
  end)
  Avatar:RaidSeasonGetRaidRankTopN(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self.TopNInfo = {}
      self:TryOpenRankTopN()
    end
  end)
end

function M:RefreshBuffInfoList()
  local RaidDungeon = DataMgr.RaidDungeon[self.CurCellDungeonId]
  self.RaidBuffIDArry = RaidDungeon.RaidBuffID
  if self.RaidBuffIDArry then
    self.WS_Buff:SetActiveWidgetIndex(0)
    for _, RaidBuffID in ipairs(self.RaidBuffIDArry) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.RaidDungeonBuffData = DataMgr.RaidBuff[RaidBuffID]
      self.List_Buff:AddItem(Content)
    end
  else
    self.Panel_Details_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WS_Buff:SetActiveWidgetIndex(1)
    self.Text_Buff_Empty:SetText(GText())
  end
  if self:IsExistTimer(self.NextFrameListEmpty) then
    self:RemoveTimer(self.NextFrameListEmpty)
  end
end

function M:RefreshRewardInfoList(DungeonId)
  assert(DataMgr.Dungeon[DungeonId], "副本信息不存在:" .. DungeonId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local FirstRewardList
  if not Avatar.Dungeons[DungeonId] or not Avatar.Dungeons[DungeonId].IsPass then
    local RewardInfo = DataMgr.Reward[DataMgr.Dungeon[DungeonId].FirstCompleteReward]
    if RewardInfo then
      FirstRewardList = {}
      local RewardIds = RewardInfo.Id or {}
      local RewardCounts = RewardInfo.Count or {}
      local RewardTypes = RewardInfo.Type or {}
      for i = 1, #RewardIds do
        local ItemId = RewardIds[i]
        local Count = RewardUtils:GetCount(RewardCounts[i])
        local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
        local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
        local ItemType = RewardTypes[i]
        local RewardContent = {
          Id = ItemId,
          Type = ItemType,
          ItemCount = Count,
          Icon = Icon,
          Rarity = Rarity,
          bFirst = true,
          DropType = "FirstReward"
        }
        table.insert(FirstRewardList, RewardContent)
      end
    end
  end
  local RewardList = RewardUtils:GetRewardViewInfoById(DataMgr.Dungeon[DungeonId].DungeonRewardView)
  
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
  local IsInTimeRange, RewardConfig = self:IsInTimeRange(DungeonId)
  if IsInTimeRange and RewardConfig then
    local EventDungeonRewardList = RewardUtils:GetRewardViewInfoById(RewardConfig.RewardView)
    table.sort(EventDungeonRewardList, SortFunc)
    for _, v in ipairs(EventDungeonRewardList) do
      table.insert(self.RewardList, v)
    end
  end
  for _, ItemData in ipairs(self.RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = true
    Content.UIName = "DeputeDetail"
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
    Content.Count = BaseCount
    self.List_Prop:AddItem(Content)
  end
  if self:IsExistTimer(self.NextFrameListEmpty) then
    self:RemoveTimer(self.NextFrameListEmpty)
  end
  self.NextFrameListEmpty = self:AddTimer(0.01, function()
    local len = self.List_Prop:GetNumItems()
    for i = 1, len do
      local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Prop, i - 1)
      if entryWidget then
        entryWidget:BindEvents(self, {
          OnMenuOpenChanged = self.OnStuffMenuOpenChanged
        })
      end
    end
    self.List_Prop:RequestFillEmptyContent()
  end, false, 0, "GuildWar_LevelSelectListView")
end

function M:IsInTimeRange(dungeonId)
  local nowTimestamp = os.time()
  local dungeonConfig = DataMgr.EventDungeonReward[dungeonId]
  if not dungeonConfig then
    return false
  end
  for startTime, endTable in pairs(dungeonConfig) do
    if type(endTable) == "table" then
      for endTime, config in pairs(endTable) do
        if startTime <= nowTimestamp and endTime >= nowTimestamp then
          return true, config
        end
      end
    end
  end
  return false
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = 0
  return Content
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self.MenuOpen = bIsOpen
  if bIsOpen then
    self.Btn_Start:SetPCVisibility(true)
    self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.Collapsed)
    self:UpdatKeyDisplay("")
    self.Switch_Details_Icon:SetActiveWidgetIndex(self.CurrentTabIdx == self.ObtainTabId and 0 or 1)
    self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(self.CurrentTabIdx == self.ObtainTabId and 0 or 1)
  else
    self.Btn_Start:SetPCVisibility(false)
    self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:UpdatKeyDisplay("RewardWidget")
    self.List_Prop:SetFocus()
    self.Switch_Details_Icon:SetActiveWidgetIndex(2)
    self.Switch_Details_Icon_Buff:SetActiveWidgetIndex(2)
  end
end

function M:OnClickedCell(LvCell)
  if self.SelectLvTabCell ~= nil then
    self.SelectLvTabCell:OnCellUnSelect()
  end
  self.SelectLvTabCell = LvCell
  LvCell:SelectCell()
end

function M:RefreshMonsterInfoList(DungeonId)
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not (DungeonInfo and DungeonInfo.DungeonMonsters) or 0 == #DungeonInfo.DungeonMonsters then
    DebugPrint("ZDX DungeonMonster is nil")
    return
  end
  local DisplayMonsters = CommonUtils.DeepCopy(DungeonInfo.DungeonMonsters)
  table.sort(DisplayMonsters, MonsterUtils.CompareMonsters)
  self.MonsterWeaknessIcon = {}
  self:InitMonsterWeakness(DungeonId)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  for _, MonsterId in ipairs(DisplayMonsters) do
    local MonsterData = DataMgr.Monster[MonsterId]
    if MonsterData then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.ParentWidget = self
      Content.MonsterId = MonsterId
      Content.DisableSelect = true
      Content.SoundEvent = "event:/ui/common/click_mid"
      Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
      self.List_Monster:AddItem(Content)
    end
  end
end

function M:InitMonsterWeakness(DungeonId)
  assert(DungeonId, "dungeon id is nil")
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  assert(DungeonInfo, string.format("dungeon id [%d] is wrong, cant find dungeonInfo", DungeonId))
  local MonsterBuff = DungeonInfo.MonsterBuff
  local Monsters = DungeonInfo.DungeonMonsters
  if MonsterBuff then
    for _, MonsterId in ipairs(Monsters) do
      if type(MonsterId) == "number" then
        local AllBuffs = MonsterUtils.GetRealMonsterBuffs(DungeonId, MonsterId)
        for _, BuffId in ipairs(AllBuffs) do
          local BuffInfo = DataMgr.Buff[BuffId]
          if BuffInfo and BuffInfo.WeaknessType then
            local HasWeakness = not not BuffInfo.WeaknessType
            if HasWeakness then
              local WeaknessIcon = DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
              if WeaknessIcon then
                self.MonsterWeaknessIcon[MonsterId] = self.MonsterWeaknessIcon[MonsterId] or {}
                self.MonsterWeaknessIcon[MonsterId][WeaknessIcon] = true
              end
            end
          end
        end
      end
    end
  end
end

function M:OnClickSolo()
  if not self.CurSelectedDungeonId then
    DebugPrint("SL CurSelectedDungeonId is nil")
    return
  end
  if not self:CheckDungeonCondition(self.CurSelectedDungeonId) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_DungeonLocked_Toast"))
    return
  end
  self:EnterStandalone()
end

function M:EnterStandalone()
  local ExitDungeonInfo = {
    Type = "GuildWar",
    JumpId = 69,
    SquadId = self.SquadId or nil
  }
  GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
  AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self:TryEnterDungeon(Avatar, self.CurSelectedDungeonId, function(RetCode, ...)
      local bRetCode = self.HandleEnterDungeonRetCode(RetCode, ...)
      if not bRetCode then
        self:PlayAnimation(self.In)
      end
    end, nil)
  else
    WorldTravelSubsystem(self):ChangeDungeonByDungeonId(self.CurSelectedDungeonId, CommonConst.DungeonNetMode.Standalone)
  end
end

function M:OnUserScrolled()
  if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
    return
  end
  UIUtils.UpdateScrollBoxArrow(self.ScrollBox_List, self.List_ArrowTop, self.List_ArrowBottom)
end

function M:OnReturnKeyDown()
  AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
  if not self:IsAnimationPlaying(self.Out) and not self:IsAnimationPlaying(self.In) then
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:PlayAnimation(self.Out)
    EventManager:FireEvent(EventID.OnReturnToActivityEntry)
    EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self.Super.Close(self)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    local isInvisible = self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
    local isNotShown = not self.DefaultList.IsShow
    if isInvisible and isNotShown or not isInvisible then
      self:SelectCellFocus()
    end
  else
  end
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdatKeyDisplay(FocusTypeName)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return
  end
  self.FocusTypeName = FocusTypeName
  if "RewardWidget" == FocusTypeName then
    local BottomKeyInfo = {
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
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    self:UpdateUIStyleInPlatform(true)
    self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab_Info:UpdateUIStyleInPlatform(true)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.Collapsed)
      self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
      self.Btn_Start:SetPCVisibility(true)
    end
    self.DefaultList:ApplyPcUiLayout()
  elseif "SelfWidget" == FocusTypeName then
    local BottomKeyInfo = {}
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      self:UpdateUIStyleInPlatform(false)
      self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Tab_Info:UpdateUIStyleInPlatform(true)
      self.Btn_Start:SetPCVisibility(false)
      self.IsFocusProp = false
      self.IsFocus_Monster = false
      self.IsFocusEliteProp = false
      self.DefaultList:InitWidgetInfoInGamePad()
    end
  elseif "MenuAnchor" == FocusTypeName then
    local BottomKeyInfo = {
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
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    self:UpdateUIStyleInPlatform(true)
    self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    local BottomKeyInfo = {}
    self.Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    self:UpdateUIStyleInPlatform(true)
    self.Tab.WBP_Com_Tab_ResourceBar.KeyImg_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab_Info:UpdateUIStyleInPlatform(false)
  end
end

function M:SetPanelDetailsVis(SlateVisibility)
  self.Panel_Details:SetVisibility(SlateVisibility)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if IsUseKeyAndMouse then
    self.Com_Key_More:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Ranking.Key_Shop:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Board.WS_Controller:SetActiveWidgetIndex(0)
    self.Key_MonsterInfo:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Board.WS_Controller:SetActiveWidgetIndex(1)
    self.Board.Key_Reward:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RB"}
      }
    })
    self.Com_Key_More:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Com_Key_More:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      bLongPress = false,
      Desc = GText("UI_Controller_Check")
    })
    self.Btn_Ranking.Key_Shop:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Ranking.Key_Shop:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
    self.Btn_Shop.Key_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Shop.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LB"}
      }
    })
  end
  self:SetPanelDetails(self.CurrentTabIdx)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    if self.DisableEsc and self.DisableEsc == true then
      return IsEventHandled
    end
    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
      self.DefaultList:OnCloseSquadGamepad()
    else
      self:OnReturnKeyDown()
    end
  elseif "A" == InKeyName then
    if self.Tab_Info then
      self.Tab_Info:TabToLeft()
      IsEventHandled = true
    end
  elseif "D" == InKeyName and self.Tab_Info then
    self.Tab_Info:TabToRight()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnGamePadDown(InKeyName)
  DebugPrint("SL OnGamePadDown is InKeyName Detail", InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.DefaultList and self.DefaultList.IsShow and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self.DefaultList:OnCloseSquadGamepad()
      self:UpdatKeyDisplay("SelfWidget")
      IsEventHandled = true
    elseif self.SelectCell then
      local btnArea = self.SelectCell and self.SelectCell.Btn_Click
      if btnArea and not btnArea:HasAnyUserFocus() then
        self:SelectCellFocus()
        IsEventHandled = true
      else
        self:OnReturnKeyDown()
        IsEventHandled = true
      end
    end
  elseif InKeyName ~= UIConst.GamePadKey.SpecialRight then
    IsEventHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName)
  end
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return IsEventHandled
  end
  if "Gamepad_LeftTrigger" == InKeyName or "Gamepad_RightTrigger" == InKeyName then
    if self.Tab_Info then
      self.Tab_Info:Handle_KeyEventOnGamePad(InKeyName)
      IsEventHandled = true
    end
  elseif "Gamepad_Special_Right" == InKeyName then
    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self.DefaultList:OnSpecialRightUp()
      IsEventHandled = true
    end
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    if self.RaidSeasons:IsRaidTime() and self.RaidSeasons.MaxPreRaidScore > 0 then
      self:OpenGuildWarRank()
    end
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    self:OnClickSolo()
  elseif "Gamepad_LeftShoulder" == InKeyName then
    if self.RaidSeasons:IsRaidTime() then
      self:OnShopBtnClicked()
    end
  elseif "Gamepad_RightShoulder" == InKeyName then
    if self.RaidSeasons:IsPreRaidTime() then
      self:OpenGuildWarRewardPop()
    end
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if "SelectCell" ~= self.CurrentFocusType then
      return IsEventHandled
    elseif "SelectCell" == self.CurrentFocusType then
      if self.CurrentTabIdx == self.ObtainTabId then
        self.List_Prop:SetFocus()
        self:UpdatKeyDisplay("RewardWidget")
      elseif self.CurrentTabIdx == self.MonsterTabId then
        self.List_Monster:SetFocus()
        self:UpdatKeyDisplay("RewardWidget")
      end
      self:PlayAnimation(self.Hover)
      self.CurrentFocusType = "List"
      IsEventHandled = true
    end
  end
  return IsEventHandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_DPad_Up" == InKeyName then
      if self.CurrentTabIdx == self.ObtainTabId and not self.MenuOpen then
        self:OpenBuffDetails()
        IsEventHandled = true
      end
    elseif "Gamepad_DPad_Down" == InKeyName then
      if self.CurrentTabIdx == self.ObtainTabId and not self.MenuOpen then
        self:OpenRewardDetails()
        IsEventHandled = true
      end
    elseif "Gamepad_DPad_Right" == InKeyName and not self:IsFocusList() then
      if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then
        return IsEventHandled
      end
      if not self.DefaultList.IsShow then
        local IsChecked = not self.DefaultList.Preview.Switch_Summon:GetChecked()
        self.DefaultList.Preview.Switch_Summon:SetChecked(IsChecked)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
          IsEventHandled = true
          return
        end
        Avatar:SwitchSquadAutoPhantom(IsChecked)
        IsEventHandled = true
      end
    elseif "Gamepad_DPad_Left" == InKeyName and not self:IsFocusList() then
      if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then
        return IsEventHandled
      end
      if not self.DefaultList.IsShow then
        self.DefaultList.Preview:OpenDefaultMenuAnchor()
        self:UpdatKeyDisplay("MenuAnchor")
        IsEventHandled = true
      end
    end
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnShopBtnClicked()
  local PageConfigData = DataMgr.EventPortal[self.RaidSeasonData.EventId]
  if not PageConfigData then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop, self.OnShopClose, self)
end

function M:OnShopClose()
end

function M:SelectCellFocus()
  if not self.SelectCell then
    return
  end
  self:UpdatKeyDisplay("SelfWidget")
  if not self.SelectCell.Btn_Click:HasAnyUserFocus() then
    self.CurrentFocusType = "SelectCell"
    self.SelectCell.Btn_Click:SetFocus()
  end
end

function M:IsFocusList()
  return self.CurrentFocusType == "List"
end

function M:OnForbiddenRightBtnClicked()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_REGISTER_COMINGSOON")
end

function M:OnForbiddenLeftBtnClicked()
  if self.IsComMissing and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Squad_Miss_Challenge")
  end
end

function M:OnForbiddenDoubleModBtnClicked()
  if self.IsDoubleMod and self.ContinuousCombat then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Event_ModDrop_Exhausted")
  end
end

function M:OpenGuildWarRewardPop()
  local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
  GuildWarRewardPop:Init()
end

function M:OpenGuildWarGroupConfirm()
  local GuildWarGroupConfirm = UIManager(self):LoadUINew("GuildWarGroupConfirm")
  GuildWarGroupConfirm:Init()
end

function M:OnCurrentSquadChange(SquadId, IsComMissing)
  self.SquadId = SquadId
  self.IsComMissing = IsComMissing
  self:RefreshBtnState()
end

function M:RefreshBtnState()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.Btn_Start:UnBindEventOnClickedByObj(self)
  self.Btn_Start:ForbidBtn(false)
  self.Btn_Start:SetDefaultGamePadImg("Y")
  local DungeonId = self.SelectCell.DungeonId
  if not self:CheckDungeonCondition(DungeonId) then
    self.Btn_Start:ForbidBtn(true)
    self.Btn_Start:BindForbidStateExecuteEvent(self, function()
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_DungeonLocked_Toast"))
    end)
    return
  end
  if self.RaidSeasons:IsRaidTime() and Avatar then
    local TicketCount = Avatar.Resources[self.ResId] and Avatar.Resources[self.ResId].Count or 0
    if TicketCount < self.ConsumeTicketCount then
      self.Btn_Start:ForbidBtn(true)
      local Resource = DataMgr.Resource[self.ResId]
      self.Btn_Start:BindForbidStateExecuteEvent(self, function()
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("RaidDungeon_NoTicket_Toast"), GText(Resource.ResourceName)))
      end)
      return
    end
  end
  if self.IsComMissing then
    self.Btn_Start:ForbidBtn(true)
    self.Btn_Start:BindForbidStateExecuteEvent(self, self.OnForbiddenLeftBtnClicked)
    return
  end
  if not GuildWarUtils.IsRaidTime() then
    self.Btn_Start:ForbidBtn(true)
    return
  end
  local bIsInTeam = Avatar:IsInTeam()
  if bIsInTeam then
    self.Btn_Start:ForbidBtn(true)
    self.Btn_Start:BindForbidStateExecuteEvent(self, function()
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_TRAINING_FAIL_GUIDWAR")
    end)
    return
  end
  self.Btn_Start:BindEventOnClicked(self, self.OnClickSolo)
end

function M:PlayTabSound()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_03", nil, nil)
end

function M:TryEnterDungeon(Avatar, DungeonId, OtherCallback)
  DebugPrint("SL@M:TryEnterDungeon ", Avatar, DungeonId, self.RaidSeasonData.EventId, OtherCallback)
  if self.DefaultList:GetVisibility() == ESlateVisibility.Collapsed then
    Avatar:EnterEventDungeon(OtherCallback, DungeonId, nil, self.RaidSeasonData.EventId)
  else
    Avatar:EnterEventDungeon(OtherCallback, DungeonId, self.SquadId, self.RaidSeasonData.EventId)
  end
  self.Btn_Start:ForbidBtn(true)
end

function M:SelectMonsterInfoItem(MonsterId)
  UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

function M.HandleEnterDungeonRetCode(RetCode, ...)
  DebugPrint("SL@M.EnterDungeonCallback RetCode", RetCode)
  ErrorCode:Check(RetCode)
  if RetCode == ErrorCode.RET_SUCCESS then
    return true
  else
    return false
  end
end

function M:OnTeamMatchCancel(Ret)
  self.Btn_Start:ForbidBtn(false)
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  EventManager:FireEvent(EventID.GuilfWarLevelSelectReceiveEnterState, StackAction)
end

function M:OnPreRaidRankInfo(arg)
end

function M:OnRaidRankInfo(RankInfo)
  self.RankInfo = RankInfo or {}
  if self.OpenRankTag then
    self:TryOpenRankTopN()
  end
end

function M:OnRaidRankInfoTopN(TopNInfo)
  self.TopNInfo = TopNInfo or {}
  if self.OpenRankTag then
    self:TryOpenRankTopN()
  end
end

function M:DisableEscOnDungeonLoading()
  self.DisableEsc = true
end

AssembleComponents(M)
return M
