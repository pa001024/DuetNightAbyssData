local NumberModel = require("BluePrints.UI.WBP.Appearance.WBP_AppearanceArchive_Number_Model")
local AppearanceArchiveRewardModel = {}

function AppearanceArchiveRewardModel:OpenReward(Widget, Type)
  self:SetRewardParams(Type)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100375, self.Params, Widget)
end

function AppearanceArchiveRewardModel:SetRewardParams(Type)
  self.Params = {}
  local ConfigData = {
    HasTab = true,
    ReddotName = "AppearanceArchiveReward",
    TabInfo = {},
    Datas = {}
  }
  if Type then
    ConfigData.Type = Type
  end
  local SortedArchiveInfo = {}
  for _, Data in pairs(DataMgr.AppearanceCollect) do
    table.insert(SortedArchiveInfo, Data)
  end
  table.sort(SortedArchiveInfo, function(a, b)
    return a.Entrance < b.Entrance
  end)
  for TabIndex, ArchiveInfo in ipairs(SortedArchiveInfo) do
    local TableItem = {}
    TableItem.Title = ArchiveInfo.EntranceName
    TableItem.Type = ArchiveInfo.Entrance
    TableItem.ReddotName = "AppearanceArchiveReward"
    if ArchiveInfo.RewardTabIconPath then
      TableItem.ShowIcon = true
      TableItem.IconPath = ArchiveInfo.RewardTabIconPath
    end
    table.insert(ConfigData.TabInfo, TableItem)
    local SumNum = NumberModel["Get" .. ArchiveInfo.Type .. "SumNumber"](NumberModel)
    local Avatar = GWorld:GetAvatar()
    local Archive = Avatar.AppearanceCollects[ArchiveInfo.Entrance]
    local CurrentNum = NumberModel:GetCurrentNumber(ArchiveInfo.Entrance)
    if SumNum < CurrentNum then
      CurrentNum = SumNum
    end
    local Data = {
      Items = {}
    }
    for Index, Target in ipairs(ArchiveInfo.QuantityTarget) do
      local Item = {}
      Item.Index = Index
      Item.Nums = Target
      Item.Type = ArchiveInfo.Entrance
      Item.CanReceive = false
      Item.RewardsGot = false
      if CurrentNum < Item.Nums then
        Item.InProgress = true
      else
        Item.InProgress = false
        if Archive.AppearanceCollectRewardGot[Item.Index] then
          Item.CanReceive = false
          Item.RewardsGot = true
        else
          Item.CanReceive = true
          Item.RewardsGot = false
        end
      end
      Item.NotreachText = GText("UI_Archive_CollectionInProgress")
      Item.Hint = string.format(GText("UI_Archive_CollectionTarget"), Item.Nums)
      Item.ReceiveCallBack = self.GetRewards
      Item.ReceiveParm = {ArchiveMain = self}
      Item.Rewards = {}
      local RewardId = ArchiveInfo.QuantityReward[Index]
      local Rewards = {RewardId}
      local IsGot = not Item.CanReceive
      for _, RewardId in pairs(Rewards) do
        local RewardInfo = DataMgr.Reward[RewardId]
        if RewardInfo then
          local Ids = RewardInfo.Id or {}
          local RewardCount = RewardInfo.Count or {}
          local TableName = RewardInfo.Type or {}
          for i = 1, #Ids do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            local ItemId = Ids[i]
            Content.IsShowDetails = true
            Content.Id = ItemId
            Content.ItemId = ItemId
            Content.Count = RewardUtils:GetCount(RewardCount[i])
            Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
            Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
            Content.ItemType = TableName[i]
            Content.bHasGot = IsGot
            table.insert(Item.Rewards, Content)
          end
        end
      end
      table.insert(Data.Items, Item)
    end
    Data.ShowIcon = false
    Data.ShowSourceNum = true
    Data.Text_Total = GText("UI_ArchiveCollectionReward")
    Data.NowNum = CurrentNum
    Data.NumMax = SumNum
    Data.ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
    Data.ReceiveAllCallBack = self.GetAllRewards
    Data.ReceiveAllParam = {
      ArchiveMain = self,
      Type = ArchiveInfo.Entrance
    }
    ConfigData.Datas[ArchiveInfo.Entrance] = Data
  end
  self.Params.ConfigData = ConfigData
  self.Params.Title = GText("UI_ArchiveCollectionReward")
end

function AppearanceArchiveRewardModel.GetRewards(RewardItem, Content)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(Ret, Rewards)
      local Archive = Avatar.AppearanceCollects[Content.ConfigData.Type]
      
      local CurrentNum = NumberModel:GetCurrentNumber(Content.ConfigData.Type)
      Content.ConfigData.CanReceive = false
      Content.ConfigData.RewardsGot = false
      if CurrentNum < Content.ConfigData.Nums then
        Content.ConfigData.InProgress = true
      else
        Content.ConfigData.InProgress = false
        if Archive.AppearanceCollectRewardGot[Content.ConfigData.Index] then
          Content.ConfigData.CanReceive = false
          Content.ConfigData.RewardsGot = true
        else
          Content.ConfigData.CanReceive = true
          Content.ConfigData.RewardsGot = false
        end
      end
      Content.SelfWidget:RefreshBtn(0 == Ret)
      Content.Owner:RefreshButton(Content.ConfigData.ReceiveParm.ArchiveMain:CheckHaveRewardToGet(Content.ConfigData.Type))
      Content.ConfigData.ReceiveParm.ArchiveMain:RefreshReddotInfo(Content.ConfigData.Type, Content.ConfigData.Index)
      if not ErrorCode:Check(Ret) then
        return
      end
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
        RewardItem:SetFocus()
      end, RewardItem)
    end
    
    Avatar:GetAppearanceCollectReward(Callback, Content.ConfigData.Type, Content.ConfigData.Index)
  end
end

function AppearanceArchiveRewardModel:CheckHaveRewardToGet(Type)
  local ArchiveInfo = DataMgr.AppearanceCollect[Type]
  local Avatar = GWorld:GetAvatar()
  local Archive = Avatar.AppearanceCollects[ArchiveInfo.Entrance]
  local CurrentNum = NumberModel:GetCurrentNumber(ArchiveInfo.Entrance)
  for Index, Target in ipairs(ArchiveInfo.QuantityTarget) do
    if Target <= CurrentNum and not Archive.AppearanceCollectRewardGot[Index] then
      return true
    end
  end
  return false
end

function AppearanceArchiveRewardModel:RefreshReddotInfo(Type, Index)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceArchiveReward")
  if CacheDetail[Type] and CacheDetail[Type][Index] then
    CacheDetail[Type][Index] = nil
    if nil == next(CacheDetail[Type]) then
      CacheDetail[Type] = nil
    end
    ReddotManager.DecreaseLeafNodeCount("AppearanceArchiveReward")
  end
end

function AppearanceArchiveRewardModel:GetAllRewards(ReceiveAllParm)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(Ret, Rewards)
      for i = 0, ReceiveAllParm.SelfWidget.List_Item:GetNumItems() - 1 do
        local Content = ReceiveAllParm.SelfWidget.List_Item:GetItemAt(i)
        
        local Archive = Avatar.AppearanceCollects[Content.ConfigData.Type]
        local CurrentNum = NumberModel:GetCurrentNumber(Content.ConfigData.Type)
        Content.ConfigData.CanReceive = false
        Content.ConfigData.RewardsGot = false
        if CurrentNum < Content.ConfigData.Nums then
          Content.ConfigData.InProgress = true
        else
          Content.ConfigData.InProgress = false
          if Archive.AppearanceCollectRewardGot[Content.ConfigData.Index] then
            Content.ConfigData.CanReceive = false
            Content.ConfigData.RewardsGot = true
          else
            Content.ConfigData.CanReceive = true
            Content.ConfigData.RewardsGot = false
          end
        end
        if Content.SelfWidget then
          Content.SelfWidget:RefreshBtn(Content.ConfigData.RewardsGot)
        end
        Content.ConfigData.ReceiveParm.ArchiveMain:RefreshReddotInfo(Content.ConfigData.Type, Content.ConfigData.Index)
      end
      ReceiveAllParm.SelfWidget:RefreshButton(ReceiveAllParm.ArchiveMain:CheckHaveRewardToGet(ReceiveAllParm.Type))
      if not ErrorCode:Check(Ret) then
        return
      end
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
        ReceiveAllParm.SelfWidget:SetFocus()
      end, ReceiveAllParm.SelfWidget)
    end
    
    Avatar:GetAllAppearanceCollectReward(Callback, ReceiveAllParm.Type)
  end
end

return AppearanceArchiveRewardModel
