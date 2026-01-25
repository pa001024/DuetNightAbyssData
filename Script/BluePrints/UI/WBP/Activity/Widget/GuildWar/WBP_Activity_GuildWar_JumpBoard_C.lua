require("UnLua")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self:AddDispatcher(EventID.OnPreRaidRankInfo, self, self.OnPreRaidRankInfo)
  self:AddDispatcher(EventID.OnRaidRankInfo, self, self.OnRaidRankInfo)
  self:AddDispatcher(EventID.OnRaidRankStart, self, self.OnRaidRankStart)
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
end

function M:Update()
  self:RefreshBoardWidget()
end

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.Avatar = PlayerAvatar
  self.RootWidget = self.ParentWidget and self.ParentWidget.ParentWidget
  self.EventId = ActivityConfigData.EventId
  self:RefreshBoardWidget()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  self:SetJumpPageButtonDisable()
end

function M:SetJumpPageButtonDisable()
  if GuildWarUtils.IsRaidTime() then
    return
  end
  local ParentWidget = self.ParentWidget
  if ParentWidget and ParentWidget.WS then
    ParentWidget.WS:SetActiveWidgetIndex(2)
    ParentWidget.Text_Complete:SetText(GText("UI_GameEvent_EventEnd"))
  end
end

function M:RefreshBoardWidget()
  if GuildWarUtils.IsPreRaidTime() then
    self:RefreshQualificationBoard()
  else
    self:RefreshOfficialBoard()
  end
end

function M:RefreshQualificationBoard()
  local SeasonData, _ = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData then
    return
  end
  local PreRaidDuration = SeasonData.PreRaidTime * 3600
  local CurEventData = DataMgr.EventMain[self.EventId]
  local QualificationEndTime = CurEventData.EventStartTime + PreRaidDuration
  local QualificationEndDateText = self:GetDateText(QualificationEndTime)
  self.WS_Type:SetActiveWidgetIndex(0)
  self.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local BoardWidget = self.WB_QualificationBoard
  BoardWidget.Key_Reward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  local QualificationEndDate = TimeUtils.TimestampToDataObj(QualificationEndTime)
  local OfficalMathcStartDateText = table.concat({
    self:PadZero(QualificationEndDate.month),
    "-",
    self:PadZero(QualificationEndDate.day),
    " ",
    self:PadZero(QualificationEndDate.hour),
    ":",
    self:PadZero(QualificationEndDate.min)
  })
  BoardWidget.Text_Reward:SetText(GText("UI_Event_MidTerm_GotoPreview"))
  BoardWidget.Btn_Check:Init({
    ClickCallback = self.OnRewardPreviewClicked,
    OwnerWidget = self
  })
  BoardWidget.Text_Status:SetText(OfficalMathcStartDateText)
  BoardWidget.Text_QualificationMatch:SetText(GText("RaidDungeon_PreRaid_Rank"))
  BoardWidget.Text_OfficialMathch:SetText(GText("RaidDungeon_Raid_Rank"))
  local DataText = table.concat({
    self:GetDateText(CurEventData.EventStartTime),
    " ~ ",
    QualificationEndDateText
  })
  BoardWidget.Text_Date:SetText(DataText)
  self.Avatar:RaidSeasonGetPreRaidRankInfo(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self:SetRankTextureImage(BoardWidget, 0)
    end
  end)
  self:AddTimer(0.2, function()
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BoardWidget:PlayAnimation(BoardWidget.In)
  end)
end

function M:RefreshOfficialBoard()
  local SeasonData, _ = GuildWarUtils.GetSeasonAndEventData()
  if not SeasonData then
    return
  end
  local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  self.WS_Type:SetActiveWidgetIndex(1)
  self.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local PreRaidDuration = SeasonData.PreRaidTime * 3600
  local RaidDuration = SeasonData.RaidTime * 3600
  local CurEventData = DataMgr.EventMain[self.EventId]
  local QualificationEndTime = CurEventData.EventStartTime + PreRaidDuration
  local QualificationEndDateText = self:GetDateText(QualificationEndTime)
  local BoardWidget = self.WB_OfficialBoard
  BoardWidget.Text_Ranking:SetVisibility(UIConst.VisibilityOp.Collapsed)
  BoardWidget.Btn_GainReward.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  BoardWidget.Text_Status:SetText(GText("RaidDungeon_PreRaid_End"))
  BoardWidget.Text_QualificationMatch:SetText(GText("RaidDungeon_PreRaid_Rank"))
  BoardWidget.Text_OfficialMathch:SetText(GText("RaidDungeon_Raid_Rank"))
  local DataText = table.concat({
    QualificationEndDateText,
    " ~ ",
    self:GetDateText(QualificationEndTime + RaidDuration)
  })
  BoardWidget.Text_Date:SetText(DataText)
  self:RefreshPreRaidRewardGot(BoardWidget)
  self:SetRankTextureImage(BoardWidget, RaidSeasons.PreRaidGroupId)
  self.Avatar:RaidSeasonGetRaidRankInfo(function(ErrCode)
    if not ErrorCode:Check(ErrCode) and self then
      self:InitRaidRankText(0)
    end
  end)
  self:AddTimer(0.2, function()
    self.WS_Type:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BoardWidget:PlayAnimation(BoardWidget.In)
  end)
end

function M:OnPreRaidRankInfo(RankInfo)
  if RankInfo and GuildWarUtils.IsPreRaidTime() then
    self:SetRankTextureImage(self.WB_QualificationBoard, RankInfo.PreRaidGroupId)
  end
end

function M:OnRaidRankInfo(RankInfo)
  local Rank = RankInfo and RankInfo.Rank
  self:InitRaidRankText(Rank)
end

function M:OnRaidRankStart(_, RaidGroupId)
  self:RefreshOfficialBoard()
  if RaidGroupId then
    self:SetRankTextureImage(self.WB_OfficialBoard, RaidGroupId)
  end
end

function M:RefreshPreRaidRewardGot(BoardWidget)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RaidSeasons = Avatar.RaidSeasons[Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  if RaidSeasons.PreRaidGroupId > 0 and not RaidSeasons:IsPreRaidRewardGot() then
    BoardWidget.Btn_GainReward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    BoardWidget.Btn_GainReward:Init(self, self.OnRewardGotBtnClicked)
  else
    BoardWidget.Btn_GainReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  GuildWarUtils.RefreshRewardGotReddot()
end

function M:InitRaidRankText(RankNum)
  local TextWidget = self.WB_OfficialBoard.Text_Ranking
  if not TextWidget then
    return
  end
  if RankNum and RankNum > 0 then
    TextWidget:SetText(GText("RaidDungeon_Rank") .. " " .. RankNum)
    TextWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    TextWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnRewardGotBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", "", nil)
  
  local function Callback(ErrCode, Ret)
    if self.RootWidget and self.RootWidget.BlockAllUIInput then
      self.RootWidget:BlockAllUIInput(false)
    end
    self:RefreshPreRaidRewardGot(self.WB_OfficialBoard)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    local PreRaidRankData = DataMgr.PreRaidRank[1]
    local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
    if not RaidSeasons or not RaidSeasons.PreRaidGroupId then
      DebugPrint("获取不到预选赛分组信息!")
      return
    end
    local RewardId = PreRaidRankData.RankReward[RaidSeasons.PreRaidGroupId]
    local AllRewards = RewardUtils:GetRewards(RewardId, nil)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
      self:AddTimer(0.8, function()
        UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, AllRewards, self.PlayOutAnim, self, true)
      end)
    else
      UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, AllRewards, self.PlayOutAnim, self, true)
    end
  end
  
  if self.RootWidget and self.RootWidget.BlockAllUIInput then
    self.RootWidget:BlockAllUIInput(true)
  end
  self.Avatar:RaidSeasonGetPreRankReward(Callback)
end

function M:OnRewardPreviewClicked(IsChecked)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", "", nil)
  local GuildWarRewardPop = UIManager(self):LoadUINew("GuildWarRewardPop")
  GuildWarRewardPop:Init()
end

function M:SetRankTextureImage(Widget, GroupId)
  local IconIndex = GroupId or 0
  if IconIndex < 0 or type(IconIndex) ~= "number" then
    IconIndex = 0
  end
  local RankIcon = self["Rank_" .. IconIndex]
  Widget.Icon_Rank:SetBrush(RankIcon)
end

function M:PadZero(Num)
  return Num < 10 and "0" .. tostring(Num) or tostring(Num)
end

function M:GetDateText(Timestamp)
  if type(Timestamp) ~= "number" then
    return
  end
  local Date = TimeUtils.TimestampToDataObj(Timestamp)
  return table.concat({
    Date.year,
    "-",
    self:PadZero(Date.month),
    "-",
    self:PadZero(Date.day)
  })
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
    self:InitKeyBoardView()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:InitGamepadView()
  end
end

function M:InitKeyBoardView()
  if GuildWarUtils.IsPreRaidTime() then
    self.WB_QualificationBoard.WS_Controller:SetActiveWidget(self.WB_QualificationBoard.Btn_Check)
    return
  end
  local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  if not RaidSeasons:IsPreRaidRewardGot() then
    self.WB_OfficialBoard.Btn_GainReward.Key_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitGamepadView()
  if GuildWarUtils.IsPreRaidTime() then
    self.WB_QualificationBoard.WS_Controller:SetActiveWidget(self.WB_QualificationBoard.Key_Reward)
    return
  end
  local RaidSeasons = self.Avatar.RaidSeasons[self.Avatar.CurrentRaidSeasonId]
  if not RaidSeasons then
    return
  end
  if not RaidSeasons:IsPreRaidRewardGot() then
    self.WB_OfficialBoard.Btn_GainReward.Key_Controller:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:HandleKeyDownOnGamePad(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialLeft then
    IsEventHandled = true
    if GuildWarUtils.IsPreRaidTime() then
      self:OnRewardPreviewClicked()
    else
      self:OnRewardGotBtnClicked()
    end
  end
  return IsEventHandled
end

AssembleComponents(M)
return M
