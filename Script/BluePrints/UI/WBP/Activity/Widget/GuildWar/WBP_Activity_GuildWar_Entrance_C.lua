require("UnLua")
local EastSeasonQuestUtils = require("BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  EventManager:AddEvent(EventID.OnRaidRankInfoTopN, self, self.InitOnGetTopN)
  EventManager:AddEvent(EventID.OnRaidRankInfo, self, self.InitOnRankInfoSelf)
  EventManager:AddEvent(EventID.OnRaidRankStart, self, self.ShowRankingButton)
  EventManager:AddEvent(EventID.OnResourcesChanged, self, self.RefreshShopCoinQuantity)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:AddInputMethodChangedListen()
  if not ReddotManager.GetTreeNode(GuildWarUtils.ReddotNodeKey) then
    ReddotManager.AddNodeEx(GuildWarUtils.ReddotNodeKey)
  end
  if not self.AddListenerFinish then
    self.AddListenerFinish = true
    ReddotManager.AddListener(GuildWarUtils.ReddotNodeKey, self, self.RefreshReddot)
    ReddotManager.AddListener(GuildWarUtils.ReddotRewardKey, self, self.RefreshQuestReddot)
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnRaidRankInfoTopN, self)
  EventManager:RemoveEvent(EventID.OnRaidRankInfo, self)
  EventManager:RemoveEvent(EventID.OnRaidRankStart, self)
  self:RemoveInputMethodChangedListen()
  ReddotManager.RemoveListener(GuildWarUtils.ReddotNodeKey, self)
  ReddotManager.RemoveListener(GuildWarUtils.ReddotRewardKey, self)
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.Avatar = PlayerAvatar
  self.RootWidget = self.ParentWidget and self.ParentWidget.ParentWidget
  local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  self.Entrance_Shop:Init(self, self.GoToShopClick, "RaidDungeon_Shop_Name", "X")
  self.Entrance_Quest:Init(self, self.OnQuestBtnClicked, "RaidDungeon_Rank_Task", "Y")
  self:ShowRankingButton()
  self.EventId = RaidSeasons.EventId
  local CurEventData = DataMgr.EventMain[self.EventId]
  if CurEventData then
    self.Entrance_Shop:SetTimeText(CurEventData.EventEndTime)
  end
  self.CoinId = self:GetCoinIdByShop(RaidSeasons.Shop)
  self:RefreshShopCoinQuantity()
  self.Entrance_Shop:SetCoinIconByShop(self.CoinId)
  self.ParentWidget.Group_BtnBuy:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  if self.ParentWidget and self.ParentWidget.NotNeedShowButtonActivityId then
    self.ParentWidget.NotNeedShowButtonActivityId[self.EventId] = true
  end
  self:RefreshReddot()
end

function M:ShowRankingButton()
  if not GuildWarUtils.IsPreRaidTime() then
    self.Entrance_Ranking:Init(self, self.OnRankBtnClicked, "RaidDungeon_Rank", "RS")
    self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Visible)
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
    if RaidSeasons and RaidSeasons.PreRaidGroupId < 1 then
      self.ForbidRank = true
      self.Entrance_Ranking:SetForbiddenState(true)
    end
  else
    self.Entrance_Ranking:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshReddot()
  self:RefreshShopReddot()
  self:RefreshEntranceReddot()
end

function M:RefreshShopReddot()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail or not CacheDetail[self.EventId] then
    self.Entrance_Shop:SetReddotVisibility("Collapsed")
    return
  end
  if CacheDetail[self.EventId][GuildWarUtils.ShopCacheKey] then
    self.Entrance_Shop:SetReddotVisibility("SelfHitTestInvisible")
  else
    self.Entrance_Shop:SetReddotVisibility("Collapsed")
  end
end

function M:RefreshQuestReddot(Count, RdType, Name)
  if Count > 0 then
    self.Entrance_Quest:SetReddotVisibility("SelfHitTestInvisible")
  else
    self.Entrance_Quest:SetReddotVisibility("Collapsed")
  end
end

function M:RefreshEntranceReddot()
  if not GuildWarUtils.IsRaidTime() then
    return
  end
  local Btn_Confirm = self.ParentWidget.Btn_Confirm
  if not Btn_Confirm then
    return
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(GuildWarUtils.ReddotNodeKey)
  if not CacheDetail or not CacheDetail[self.EventId] then
    Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if CacheDetail[self.EventId][GuildWarUtils.EntranceCacheKey] then
    Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    Btn_Confirm:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:GetCoinIdByShop(ShopKey)
  local SubTabId
  for _, ShopData in pairs(DataMgr.ShopItem2ShopSubId.Resource[ShopKey] or {}) do
    local ShopIDData = ShopData[1]
    if ShopIDData then
      SubTabId = ShopIDData.SubTabId
    end
    break
  end
  if not SubTabId then
    return
  end
  local CoinId = DataMgr.ShopTabSub[SubTabId].TabCoin[1]
  return CoinId
end

function M:RefreshShopCoinQuantity(ResourceId)
  if ResourceId and ResourceId ~= self.CoinId then
    return
  end
  local Quantity = self.Avatar:GetResourceNum(self.CoinId)
  self.Entrance_Shop:SetCoinQuantity(Quantity)
  GuildWarUtils.RefreshShopReddot()
end

function M:TryOpenRankTopN()
  if self.RankInfo and self.TopNInfo and self.OpenRankTag then
    self.OpenRankTag = nil
    UIManager():LoadUINew("GuildWarRank", self.RankInfo, self.TopNInfo)
    if self.RootWidget and self.RootWidget.BlockAllUIInput then
      self.RootWidget:BlockAllUIInput(false)
    end
  end
end

function M:InitOnGetTopN(TopNInfo)
  self.TopNInfo = TopNInfo or {}
  if self.OpenRankTag then
    self:TryOpenRankTopN()
  end
end

function M:InitOnRankInfoSelf(RankInfo)
  self.RankInfo = RankInfo or {}
  if self.OpenRankTag then
    self:TryOpenRankTopN()
  end
end

function M:OnRankBtnClicked()
  if self.ForbidRank then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RaidDungeon_PreRaid_Abandon_Toast"))
    return
  end
  self.OpenRankTag = true
  if self.RootWidget and self.RootWidget.BlockAllUIInput then
    self.RootWidget:BlockAllUIInput(true)
  end
  self.Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self.RankInfo = {}
      self:TryOpenRankTopN()
    end
  end)
  self.Avatar:RaidSeasonGetRaidRankTopN(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self.TopNInfo = {}
      self:TryOpenRankTopN()
    end
  end)
end

function M:OnShopClose()
  self:RefreshShopCoinQuantity()
  GuildWarUtils.RefreshShopReddot()
end

function M:GoToShopClick()
  local PageConfigData = DataMgr.EventPortal[self.EventId]
  if not PageConfigData.EventShop then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop, self.OnShopClose, self)
end

function M:OnQuestDialogClose()
  GuildWarUtils.RefreshQuestReddot()
end

function M:OnQuestBtnClicked()
  GuildWarUtils.RefreshQuestReddot(true)
  local Avatar = GWorld:GetAvatar()
  if Avatar.CommonQuestActivity[self.EventId] then
    local Params = self:MakeRaidRewardData(self.EventId)
    Params.Title = GText("RaidDungeon_Rank_Task")
    Params.CloseBtnCallbackFunction = self.OnQuestDialogClose
    UIManager(GWorld.GameInstance):ShowCommonPopupUI(100173, Params, GWorld.GameInstance)
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("无法获取任务数据"))
  end
end

function M:MakeRaidRewardData(EventId)
  local Avatar = GWorld:GetAvatar()
  local Params = {}
  Params.ConfigData = {}
  Params.ConfigData.TabInfo = {}
  Params.ConfigData.Items = {}
  Params.ConfigData.HasTab = true
  Params.ConfigData.Datas = {}
  local SortedRaidInfo = {}
  for QuestPhaseId, PhaseConfig in pairs(DataMgr.CommonQuestPhase) do
    local TabIndex = 1
    if PhaseConfig.EventId == EventId then
      local TabItem = {}
      TabItem.Index = TabIndex
      TabIndex = TabIndex + 1
      TabItem.Type = QuestPhaseId
      TabItem.Title = PhaseConfig.QuestPhaseName
      TabItem.ReddotName = "RaidReward"
      TabItem.IconPath = PhaseConfig.SplineBP
      TabItem.IsShowIcon = true
      table.insert(Params.ConfigData.TabInfo, TabItem)
      local RewardData = {}
      RewardData.ShowIcon = false
      RewardData.NowNum, RewardData.NumMax = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, QuestPhaseId)
      RewardData.ReceiveAllCallBack = self.GetAllRaidRewards
      RewardData.ReceiveAllParam = {}
      RewardData.ReceiveAllParam.EventId = EventId
      RewardData.ReceiveAllParam.QuestPhaseId = QuestPhaseId
      RewardData.Type = QuestPhaseId
      RewardData.Text_Total = string.format(GText("Abyss_RewardList_Title"))
      RewardData.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
      local CommonQuestActivity = Avatar.CommonQuestActivity[EventId]
      if not CommonQuestActivity then
        DebugPrint("Avatar.CommonQuestActivity is nil, EvantId: ", EventId)
        return
      end
      local Items = {}
      for QuestId, Config in pairs(DataMgr.CommonQuestDetail) do
        if Config.QuestPhaseId == QuestPhaseId then
          local Item = {}
          Item.ItemId = QuestId
          Item.CanReceive = CommonQuestActivity[QuestId].Progress >= CommonQuestActivity[QuestId].Target and false == CommonQuestActivity[QuestId].RewardsGot
          Item.Type = QuestPhaseId
          Item.RewardsGot = CommonQuestActivity[QuestId].RewardsGot
          Item.NotreachText = GText("UI_Archive_CollectionInProgress")
          Item.Hint = GText(Config.StarterQuestDes)
          Item.ReddotName = "RaidReward"
          Item.ReceiveButtonText = GText("UI_Archive_CollectionClaim")
          Item.Num = Config.Target
          Item.ReceiveCallBack = self.GetRaidReward
          Item.ReceiveParm = {}
          Item.ReceiveParm.QuestId = QuestId
          Item.ReceiveParm.EventId = EventId
          local Rewards = {}
          for _, RewardItemId in ipairs(Config.QuestReward) do
            local RewardInfo = DataMgr.Reward[RewardItemId]
            if RewardInfo then
              local Ids = RewardInfo.Id or {}
              local RewardCount = RewardInfo.Count or {}
              local TableName = RewardInfo.Type or {}
              for i = 1, #Ids do
                local ItemId = Ids[i]
                local Count = RewardUtils:GetCount(RewardCount[i])
                local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
                local ItemType = TableName[i]
                local RewardContent = {
                  ItemType = ItemType,
                  ItemId = ItemId,
                  Count = Count,
                  Rarity = Rarity
                }
                table.insert(Rewards, RewardContent)
              end
            end
          end
          Item.Rewards = Rewards
          table.insert(Items, Item)
        end
      end
      RewardData.Items = Items
      Params.ConfigData.Datas[QuestPhaseId] = RewardData
    end
  end
  Params.ConfigData.Type = Params.ConfigData.TabInfo[1].Type
  Params.ConfigData.ReddotName = "RaidReward"
  return Params
end

function M:GetAllRaidRewards(ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function CallBack(Ret, Reward)
      DebugPrint("@@@Raid GetAllRewards CallBack")
      
      local HaveReWardToGet = false
      local CommonQuestActivity = Avatar.CommonQuestActivity[ReceiveAllParm.EventId]
      for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
        local Item = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
        if Item then
          local CanReceive = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
          local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
          if CanReceive and not IsGot then
            HaveReWardToGet = true
          end
          DebugPrint("@@@Raid GetAllRewards ,Type,ItemId,CanReceive,IsGot", Item.ConfigData.Type, Item.ConfigData.ItemId, CanReceive, IsGot)
          Item.ConfigData.CanReceive = CanReceive
          Item.ConfigData.RewardsGot = IsGot
          if Item.SelfWidget then
            Item.SelfWidget:RefreshBtn(IsGot)
          end
        end
      end
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Reward, false, function()
        ReceiveAllParm.SelfWidget:SetFocus()
      end, ReceiveAllParm.SelfWidget)
      ReceiveAllParm.SelfWidget:RefreshButton(HaveReWardToGet)
      DebugPrint("@@@hRaid GetAllRewards HaveReWardToGet", HaveReWardToGet)
      ReceiveAllParm.SelfWidget:RefreshReddotInfo()
    end
    
    Avatar:CommonQuestActivityGetPhaseReward(CallBack, ReceiveAllParm.EventId, ReceiveAllParm.QuestPhaseId)
  end
end

function M:GetRaidReward(Content)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(ErrCode, Rewards)
      if not ErrorCode:Check(ErrCode) then
        return
      end
      DebugPrint("@@@Raid GetReward CallBack")
      local HaveReWardToGet = false
      local CommonQuestActivity = Avatar.CommonQuestActivity[Content.ConfigData.ReceiveParm.EventId]
      for i = 0, Content.Owner.List_Item:GetNumItems() - 1 do
        local Item = Content.Owner.List_Item:GetItemAt(i)
        if Item then
          local CanReceive = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Progress >= CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].Target and CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot == false
          local IsGot = CommonQuestActivity[Item.ConfigData.ReceiveParm.QuestId].RewardsGot
          if CanReceive and not IsGot then
            HaveReWardToGet = true
          end
          DebugPrint("@@@Raid GetReward ,Type,ItemId,CanReceive,IsGot", Item.ConfigData.Type, Item.ConfigData.ItemId, CanReceive, IsGot)
          Item.ConfigData.CanReceive = CanReceive
          Item.ConfigData.RewardsGot = IsGot
          if Item.SelfWidget then
            Item.SelfWidget:RefreshBtn(IsGot)
          end
        end
      end
      Content.SelfWidget:RefreshReddotInfo()
      Content.Owner:RefreshButton(HaveReWardToGet)
      DebugPrint("@@@Raid GetReward HaveReWardToGet", HaveReWardToGet)
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
        Content.SelfWidget:SetFocus()
      end, Content.SelfWidget)
    end
    
    Avatar:CommonQuestActivityGetReward(Callback, Content.ConfigData.ReceiveParm.EventId, Content.ConfigData.ReceiveParm.QuestId)
  end
end

function M:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RemoveInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:SetGamepadView(false)
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:SetGamepadView(true)
  end
end

function M:SetGamepadView(IsGamepad)
  local VisiblityKey = IsGamepad and "SelfHitTestInvisible" or "Collapsed"
  self.Entrance_Ranking:SetGamepadVisibility(VisiblityKey)
  self.Entrance_Shop:SetGamepadVisibility(VisiblityKey)
  self.Entrance_Quest:SetGamepadVisibility(VisiblityKey)
end

function M:HandleKeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.RightThumb then
    if not GuildWarUtils.IsPreRaidTime() then
      IsEventHandled = true
      self:OnRankBtnClicked()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    IsEventHandled = true
    self:OnQuestBtnClicked()
  end
  return IsEventHandled
end

return M
