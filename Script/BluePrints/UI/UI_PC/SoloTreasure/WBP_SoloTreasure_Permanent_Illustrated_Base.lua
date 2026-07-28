require("UnLua")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Initialize(Initializer)
  self.AllTabInfo = {}
  self.TreasureIllustratedTotalCount = -1
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:PlayInAnim()
end

function M:Destruct()
  self:ClearListenEvent()
  M.Super.Destruct(self)
end

function M:InitRewardButtonInfo()
  self:InitTreasureIllustratedTotalCount()
  self.Btn_Reward:Init(self, self.OnRewardBtnClick, GText("UI_Play_TreasureHunt_TreasureArchiveReward"))
  self.Btn_Reward:SetProgress(SoloTreasurePermanentDataModel:GetTreasureIllustratedUnlockedCount(), self.TreasureIllustratedTotalCount)
  self.Btn_Reward:SetControllerVisible(false)
end

function M:InitTreasureIllustratedTotalCount()
  if -1 ~= self.TreasureIllustratedTotalCount then
    return
  end
  self.TreasureIllustratedTotalCount = SoloTreasurePermanentDataModel:GetTreasureIllustratedTotalCount()
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.OnTreasureHuntManualInfoChanged, self, self.OnTreasureHuntManualInfoChanged)
end

function M:ClearListenEvent()
  self:RemoveDispatcher(EventID.OnTreasureHuntManualInfoChanged)
end

function M:OnTreasureHuntManualInfoChanged(ChangeKeys, OldValue)
  if self.Btn_Reward and self.Btn_Reward.SetProgress then
    self.Btn_Reward:SetProgress(SoloTreasurePermanentDataModel:GetTreasureIllustratedUnlockedCount(), self.TreasureIllustratedTotalCount)
  end
  if IsValid(self.RewardPopupWidget) then
    self:RefreshRewardPopupItems(self.RewardPopupWidget)
  end
  SoloTreasurePermanentDataModel:RefreshManualArchiveRewardReddot()
end

function M:OnTabItemSelected(TabWidget, TabData)
  local TabId = TabData and TabData.TabId or SoloTreasurePermanentDataModel.ALL_TAB_ID
  if self.List_Item and self.List_Item.ResetTreasureScrollOffset then
    self.List_Item:ResetTreasureScrollOffset()
  end
  if self.List_Item and self.List_Item.RefreshContent then
    self.List_Item:RefreshContent(TabId)
  end
end

function M:OnReturnKeyDown()
  self:ClearListenEvent()
  self:PlayOutAnim()
end

function M:OnRewardBtnClick()
  self:SetRewardParams()
  self.Params.OnCloseCallbackObj = self
  self.Params.OnCloseCallbackFunction = self.OnRewardPopupClosed
  local PopupUI = UIManager(self):ShowCommonPopupUI(100158, self.Params, self)
  self.RewardPopupWidget = PopupUI and PopupUI.GetContentWidgetByName and PopupUI:GetContentWidgetByName("Common_Reward")
end

function M:OnRewardPopupClosed()
  self.RewardPopupWidget = nil
end

function M:GetAllRewards(ReceiveAllParam)
  ReceiveAllParam.IllustratedPanel:CallServerGetTreasureManualReward(-1)
end

function M:GetRewards(Content)
  local ReceiveParm = Content.ConfigData.ReceiveParm
  ReceiveParm.IllustratedPanel:CallServerGetTreasureManualReward(ReceiveParm.Progress)
end

function M:PlayInAnim()
  self:InitTabInfo()
  self:InitRewardButtonInfo()
  self:InitListenEvent()
  SoloTreasurePermanentDataModel:RefreshManualArchiveRewardReddot()
  self.Text_Tip:SetText(GText("UI_Play_TreasureHunt_TreasureArchiveUnlockTips"))
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "TreasureIllustratedOpen", nil)
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  if not self.Out then
    AudioManager(self):SetEventSoundParam(self, "TreasureIllustratedOpen", {ToEnd = 1})
    self:Close()
    return
  end
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "TreasureIllustratedOpen", {ToEnd = 1})
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimationForward(self.Out)
end

function M:GetTreasureListView()
  return self.List_Item and self.List_Item.List_Treasure
end

function M:GetTreasureScrollBox()
  return self.List_Item and self.List_Item.GetTreasureScrollBox and self.List_Item:GetTreasureScrollBox()
end

function M:NotifyTreasureScrollChanged()
  if self.List_Item and self.List_Item.NotifyDisplayedItemGroupsScrollChanged then
    self.List_Item:NotifyDisplayedItemGroupsScrollChanged()
  end
end

function M:SetRewardParams()
  self.Params = {}
  local ConfigData = {
    Items = {},
    ShowIcon = false,
    Text_Total = "UI_Play_TreasureHunt_TreasureArchiveProgress",
    ReceiveAllCallBack = self.GetAllRewards,
    ReceiveAllParam = {IllustratedPanel = self},
    SortType = 2,
    Rewards = {},
    NowNum = SoloTreasurePermanentDataModel:GetTreasureIllustratedUnlockedCount(),
    NumMax = self.TreasureIllustratedTotalCount,
    ReceiveButtonText = "UI_GameEvent_ClaimAll"
  }
  local Items = {}
  for Progress, Info in pairs(DataMgr.TreasureArchiveReward) do
    if Progress > self.TreasureIllustratedTotalCount then
    else
      local Item = {
        Text = GText("UI_GameEvent_ClaimReward"),
        ItemId = Progress,
        CanReceive = false,
        InProgress = false,
        RewardsGot = false,
        Rewards = {},
        Nums = Progress,
        NotreachText = "UI_GameEvent_ToBeFinished",
        Hint = string.format(GText("UI_Archive_CollectionTarget"), Progress),
        ReceiveCallBack = self.GetRewards,
        ReceiveParm = {Progress = Progress, IllustratedPanel = self},
        LeftAligned = true
      }
      local Rewards = {}
      local RewardInfo = DataMgr.Reward[Info.RewardId]
      if RewardInfo then
        local Ids = RewardInfo.Id or {}
        local RewardCount = RewardInfo.Count or {}
        local TableName = RewardInfo.Type or {}
        for i = 1, #Ids do
          local ItemId = Ids[i]
          local Count = RewardUtils:GetCount(RewardCount[i])
          local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
          table.insert(Rewards, {
            ItemType = TableName[i],
            ItemId = ItemId,
            Count = Count,
            Rarity = Rarity
          })
        end
      end
      Item.Rewards = Rewards
      local RewardState = self:GetTreasureRewardItemState(Progress)
      Item.CanReceive = RewardState.CanReceive
      Item.RewardsGot = RewardState.RewardsGot
      Item.InProgress = RewardState.InProgress
      table.insert(Items, Item)
    end
  end
  table.sort(Items, function(a, b)
    return a.ItemId < b.ItemId
  end)
  ConfigData.Items = Items
  self.Params.ConfigData = ConfigData
  self.Params.Title = "UI_Play_TreasureHunt_TreasureArchiveProgress"
end

function M:GetTreasureRewardItemState(Progress)
  local IsRewardCanReceive = Progress <= SoloTreasurePermanentDataModel:GetTreasureIllustratedUnlockedCount()
  local IsRewardHasGot = SoloTreasurePermanentDataModel:IsRewardClaimed(Progress)
  return {
    CanReceive = IsRewardCanReceive and not IsRewardHasGot,
    RewardsGot = IsRewardHasGot,
    InProgress = not IsRewardCanReceive and not IsRewardHasGot
  }
end

function M:RefreshRewardPopupItems(PopupWidget)
  if not IsValid(PopupWidget) or not PopupWidget.List_Item then
    return
  end
  local UnlockedCount = SoloTreasurePermanentDataModel:GetTreasureIllustratedUnlockedCount()
  local HaveRewardToGet = false
  for i = 0, PopupWidget.List_Item:GetNumItems() - 1 do
    local Item = PopupWidget.List_Item:GetItemAt(i)
    if Item and Item.ConfigData then
      local Progress = Item.ConfigData.ItemId
      if Progress then
        local RewardState = self:GetTreasureRewardItemState(Progress)
        Item.ConfigData.CanReceive = RewardState.CanReceive
        Item.ConfigData.RewardsGot = RewardState.RewardsGot
        Item.ConfigData.InProgress = RewardState.InProgress
        if RewardState.CanReceive then
          HaveRewardToGet = true
        end
        if Item.SelfWidget then
          Item.SelfWidget:RefreshBtn(RewardState.RewardsGot, RewardState.CanReceive)
        end
      end
    end
  end
  if PopupWidget.ConfigData then
    PopupWidget.ConfigData.NowNum = UnlockedCount
  end
  if PopupWidget.Text_Num then
    PopupWidget.Text_Num:SetText(tostring(UnlockedCount))
  end
  if PopupWidget.RefreshButton then
    PopupWidget:RefreshButton(HaveRewardToGet)
  end
end

function M:CallServerGetTreasureManualReward(Progress)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Callback(RetCode, Rewards)
    if not ErrorCode:Check(RetCode) then
      return
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, true)
  end
  
  Avatar:TreasureHuntsGetTreasureManualReward(Progress, Callback)
end

return M
