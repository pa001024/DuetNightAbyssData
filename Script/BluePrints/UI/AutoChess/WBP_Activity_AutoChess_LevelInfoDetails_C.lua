require("UnLua")
local UIUtils = require("Utils.UIUtils")
local TimeUtils = require("Utils.TimeUtils")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local LevelState = {
  Pass = 0,
  UnPass = 1,
  UnLock = 2
}

function M:Construct()
  self.TextTips:SetText(GText("UI_AutoChess_ProfitImprove"))
  self.Panel_RewardTip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:BindEvents()
end

function M:BindEvents()
  if self.Btn_Challenge then
    self.Btn_Challenge.Button_Area.OnClicked:Add(self, self.OnChallengeClicked)
  end
  if self.Btn_Refresh then
    self.Btn_Refresh:BindEventOnClicked(self, self.OnRefreshClicked)
  end
end

function M:SetCallbacks(Callbacks)
  self.Callbacks = Callbacks
end

function M:OnChallengeClicked()
  if self.Callbacks and self.Callbacks.OnChallenge then
    self.Callbacks.OnChallenge()
  end
end

function M:OnRefreshClicked()
  if self.Callbacks and self.Callbacks.OnRefresh then
    self.Callbacks.OnRefresh()
  end
end

function M:RefreshLinear(Info, State, SelectedItem)
  self:PlayAnimation(self.Change)
  self.Text_Name:SetText(GText(DataMgr.Dungeon[Info.DungeonId].DungeonName))
  self.WS_Type:SetActiveWidgetIndex(0)
  self:InitRankInfo(Info, State)
  self.List_Condition:ClearListItems()
  self.List_Enemy:ClearListItems()
  self.List_Buff:ClearListItems()
  self.List_Reward:ClearListItems()
  self.Text_Condition:SetText(GText("UI_AutoChess_UnlockInfo"))
  self.Panel_RewardTip:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if State ~= LevelState.UnLock then
    self.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitCondition(Info, State)
    self:InitEnemy(Info, SelectedItem)
    self.Panel_Buff:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitBuff(Info, SelectedItem, nil, AutoChessConst.LevelSelectType.Linear)
    self:InitReward(Info, SelectedItem, nil, AutoChessConst.LevelSelectType.Linear, State)
    self:InitBtn(AutoChessConst.LevelSelectType.Linear)
  else
    self.Panel_Buff:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitCondition(Info, State)
    self.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Btn_Lock.Text_Button:SetText(GText("UI_AutoChess_MissionEntryUnlock"))
  end
end

function M:RefreshRandom(Info, Avatar, RandomId)
  self:PlayAnimation(self.Change)
  self.Text_Name:SetText(GText(DataMgr.Dungeon[Info.DungeonId].DungeonName))
  self.WS_Type:SetActiveWidgetIndex(1)
  self.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:InitRandomRank(Avatar)
  self.List_Enemy:ClearListItems()
  self.List_Buff:ClearListItems()
  self.List_Reward:ClearListItems()
  self.Panel_Enemy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Panel_Buff:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Panel_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:InitEnemy(Info, nil, RandomId)
  self:InitBuff(Info, nil, RandomId, AutoChessConst.LevelSelectType.Random, Avatar)
  self:InitReward(Info, nil, RandomId, AutoChessConst.LevelSelectType.Random, nil)
  self:InitBtn(AutoChessConst.LevelSelectType.Random)
end

function M:InitRankInfo(Info, State)
  if Info.UnlockRankID then
    self.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_RankUp:SetText(GText("UI_AutoChess_RankLimitUpAfter"))
    local RankInfo = DataMgr.AutoChessPoint[Info.UnlockRankID]
    self.Icon_Rank:SetBrushResourceObject(LoadObject(RankInfo.RankIcon))
    if State == LevelState.Pass then
      self:PlayAnimation(self.Rank_Complete)
    else
      self:PlayAnimation(self.Rank_Normal)
    end
  else
    self.Panel_RankUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitCondition(Info, State)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if Info.UnlockMissionId then
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.State = State
    local PreDungeonId = DataMgr.AutoChessMission[Info.UnlockMissionId].DungeonId
    local Language = CommonConst.SystemLanguage
    Content.Text = nil
    if Language == CommonConst.SystemLanguages.KR then
      Content.Text = GText(DataMgr.Dungeon[PreDungeonId].DungeonName) .. " " .. GText("UI_AutoChess_CompleteText")
    else
      Content.Text = GText("UI_AutoChess_CompleteText") .. GText(DataMgr.Dungeon[PreDungeonId].DungeonName)
    end
    local bPrePass = false
    if Avatar.Dungeons[PreDungeonId] and Avatar.Dungeons[PreDungeonId].IsPass then
      bPrePass = true
    else
      bPrePass = false
    end
    if bPrePass then
      Content.Success = true
    else
      Content.Success = false
    end
    self.List_Condition:AddItem(Content)
  end
  if Info.UnlockDay then
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local TimeUnlock = self:CheckUnlockDay(Info)
    if TimeUnlock then
      Content.Success = true
    else
      Content.Success = false
    end
    Content.Text = GText(Info.UnlockText)
    self.List_Condition:AddItem(Content)
  end
  if self.List_Condition:GetNumItems() <= 0 then
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:CheckUnlockDay(Info)
  local UnlockDay = Info.UnlockDay
  if not UnlockDay then
    return true
  end
  local EventStartTime = DataMgr.EventMain[AutoChessConst.ActiveId].EventStartTime
  local StartTimestamp = EventStartTime:GetTime()
  local CurrentTime = TimeUtils.NowTime()
  local StartDate = os.date("*t", StartTimestamp)
  local RefreshHour = TimeUtils.RefreshHMS[1] or 5
  local RefreshMin = TimeUtils.RefreshHMS[2] or 0
  local RefreshSec = TimeUtils.RefreshHMS[3] or 0
  local FirstRefreshTime = os.time({
    year = StartDate.year,
    month = StartDate.month,
    day = StartDate.day,
    hour = RefreshHour,
    min = RefreshMin,
    sec = RefreshSec
  })
  if StartTimestamp >= FirstRefreshTime then
    FirstRefreshTime = FirstRefreshTime + 86400
  end
  local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
  if CurrentTime < UnlockTime then
    return false
  end
  return true
end

function M:InitEnemy(Info, SelectedItem, RandomId)
  if not Info then
    return
  end
  self.Text_Enemy:SetText(GText("UI_AutoChess_EnemyInfo"))
  local MosterInfoData = Model:GetMonsterInfoByMissionId(Info.MissionId)
  for Index = 1, #MosterInfoData do
    local Row = MosterInfoData[Index]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.AutoChessId = Row.MonsterId
    Content.EquipCount = #Row.EquipList
    Content.MissionId = nil
    if SelectedItem then
      Content.MissionId = SelectedItem.Id
    else
      Content.MissionId = RandomId
    end
    self.List_Enemy:AddItem(Content)
  end
end

function M:InitBuff(Info, SelectedItem, RandomId, Type, Avatar)
  if not Info then
    return
  end
  self.Text_Buff:SetText(GText("UI_AutoChess_BuffInfo"))
  local MissionId
  if SelectedItem then
    MissionId = SelectedItem.Id
  else
    MissionId = RandomId
  end
  if Info.RegularBuffId then
    local BuffInfo = DataMgr.AutoChessBuff[Info.RegularBuffId]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Path = BuffInfo.BuffIcon
    Content.MissionId = MissionId
    self.List_Buff:AddItem(Content)
  end
  if Info.SpecifyBuffId then
    for key, value in pairs(Info.SpecifyBuffId) do
      local BuffInfo = DataMgr.AutoChessBuff[value]
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Path = BuffInfo.BuffIcon
      Content.MissionId = MissionId
      self.List_Buff:AddItem(Content)
    end
  end
  if Type == AutoChessConst.LevelSelectType.Random then
    Avatar = Avatar or GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local Buff = Avatar.AutoChess.RandomBuffList
    for key, value in pairs(Buff) do
      local BuffInfo = DataMgr.AutoChessBuff[value]
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Path = BuffInfo.BuffIcon
      Content.MissionId = MissionId
      self.List_Buff:AddItem(Content)
    end
  end
  Avatar = Avatar or GWorld:GetAvatar()
  if Avatar and Type == AutoChessConst.LevelSelectType.Random then
    local ChallengeBuffs = Avatar.AutoChess.ChallengeBuffs
    if ChallengeBuffs then
      for ChallengeBuffId, _ in pairs(ChallengeBuffs) do
        local BuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
        if BuffData then
          local Content = NewObject(UIUtils.GetCommonItemContentClass())
          Content.Path = BuffData.BuffIcon
          Content.MissionId = MissionId
          self.List_Buff:AddItem(Content)
        end
      end
      if ChallengeBuffs:Length() > 0 then
        self.Panel_RewardTip:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Image_Up:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Image_Down:SetVisibility(UIConst.VisibilityOp.Collapsed)
      else
        self.Panel_RewardTip:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
end

function M:InitReward(Info, SelectedItem, RandomId, Type, State)
  if not Info then
    return
  end
  self.Text_Reward:SetText(GText("UI_AutoChess_RewardInfo"))
  local DungeonRewardView = DataMgr.Dungeon[Info.DungeonId].DungeonRewardView
  local RewardInfo = DataMgr.RewardView[DungeonRewardView]
  if RewardInfo then
    local Ids = RewardInfo.Id or {}
    local RewardCount = RewardInfo.Count or {}
    local TableName = RewardInfo.Type or {}
    for i = 1, #Ids do
      local ItemId = Ids[i]
      local Count = RewardUtils:GetCount(RewardCount[i])
      local Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
      local Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
      local ItemType = TableName[i]
      local RewardContent = NewObject(UIUtils.GetCommonItemContentClass())
      RewardContent.Id = ItemId
      if 0 ~= Count then
        RewardContent.Count = Count
      end
      RewardContent.Icon = Icon
      RewardContent.Rarity = Rarity
      RewardContent.ItemType = ItemType
      RewardContent.IsShowDetails = true
      RewardContent.MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft
      if Type == AutoChessConst.LevelSelectType.Linear then
        if State == LevelState.Pass then
          RewardContent.bHasGot = true
        else
          RewardContent.bHasGot = false
        end
      else
        RewardContent.bHasGot = false
      end
      self.List_Reward:AddItem(RewardContent)
    end
  end
end

function M:InitBtn(Type, Avatar)
  Avatar = Avatar or GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.WS_Btn:SetActiveWidgetIndex(0)
  self.Btn_Challenge.Text_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Challenge.Text_Button:SetText(GText("UI_AutoChess_MissionEntry"))
  if Type == AutoChessConst.LevelSelectType.Random then
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Refresh.Text_Refresh:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Btn_Refresh.Text_Button:SetText(GText("UI_AutoChess_Refresh"))
    local Count = DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue - Avatar.AutoChess.RefreshCount
    if 0 == Count then
      self.Btn_Refresh:ForbidBtn(true)
    else
      self.Btn_Refresh:ForbidBtn(false)
    end
    self.Btn_Refresh.Text_Refresh:SetText(Count .. "/" .. DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue)
  else
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitRandomRank(Avatar)
  Avatar = Avatar or GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Rank = Avatar.AutoChess.RankLevel
  local Info = DataMgr.AutoChessPoint[Rank]
  self.Rank.Icon_Rank:SetBrushResourceObject(LoadObject(Info.RankIcon))
  self.Rank.Text_Rank:SetText(GText(Info.RankName))
  self.Rank.Text_Exp:SetText(Avatar.AutoChess.RankScore .. "/" .. Info.RankMaxPoint)
end

function M:InitGamePad()
  if self.Controller_Enemy then
    self.Controller_Enemy:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Up"}
      }
    })
  end
  if self.Controller_Buff then
    self.Controller_Buff:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Down"}
      }
    })
  end
  if self.Controller_Reward then
    self.Controller_Reward:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      }
    })
  end
  if self.Btn_Challenge then
    self.Btn_Challenge:SetGamePadImg("A")
  end
  if self.Btn_Lock then
    self.Btn_Lock:SetGamePadImg("A")
  end
  if self.Btn_Refresh then
    self.Btn_Refresh:SetGamePadImg("Y")
  end
end

function M:ShowOrHideGamePad(bShow)
  if bShow then
    if self.Controller_Enemy then
      self.Controller_Enemy:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.Controller_Buff then
      self.Controller_Buff:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.Controller_Reward then
      self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.Btn_Refresh then
      self.Btn_Refresh:SetGamepadIconVisibility(true)
    end
    if self.Btn_Challenge then
      self.Btn_Challenge:SetGamepadIconVisibility(true)
    end
    if self.Btn_Lock then
      self.Btn_Lock:SetGamepadIconVisibility(false)
    end
  else
    if self.Controller_Enemy then
      self.Controller_Enemy:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Controller_Buff then
      self.Controller_Buff:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Controller_Reward then
      self.Controller_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.Btn_Refresh then
      self.Btn_Refresh:SetGamepadIconVisibility(false)
    end
    if self.Btn_Challenge then
      self.Btn_Challenge:SetGamepadIconVisibility(false)
    end
    if self.Btn_Lock then
      self.Btn_Lock:SetGamepadIconVisibility(false)
    end
  end
end

function M:SetRewardListFocus()
  if self.List_Reward then
    self.List_Reward:SetFocus()
  end
end

function M:HasRewardListFocus()
  if self.List_Reward then
    return self.List_Reward:HasFocusedDescendants() or self.List_Reward:HasAnyUserFocus()
  end
  return false
end

return M
