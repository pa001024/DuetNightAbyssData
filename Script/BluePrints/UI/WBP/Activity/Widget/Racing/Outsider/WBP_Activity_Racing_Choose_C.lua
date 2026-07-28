require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local SpecialLoadingRule = require("Utils.LoadingUtils")

function M:Construct()
  self:InitCompView()
  self:BindButtonEvent()
  self:BindReddotTreeEvents()
  self:PlayAnimationIn()
  self:BindEvent()
end

function M:InitCompView()
  self:InitTextMap()
  self:InitIcon()
  self.Text_Day:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:RefreshStageTip()
  self:UpdateButtonState()
  self:UpdateUpProgressTip()
  local TimerOwner = GWorld.GameInstance:GetGameUIManager()
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.2, function()
      self:UpdatePetList()
    end)
  end
  self.Btn_ChoosePet.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Btn_Goto.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.Btn_GotoRace.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
end

function M:BindEvent()
  EventManager:AddEvent(RacingActivityConst.EventId.NextDayRefresh, self, self.RefreshHomeView)
  EventManager:AddEvent(RacingActivityConst.EventId.EightThirtyRefresh, self, self.RefreshHomeView)
  EventManager:AddEvent(RacingActivityConst.EventId.EightRefresh, self, self.RefreshHomeView)
end

function M:UnBindEvent()
  EventManager:RemoveEvent(RacingActivityConst.EventId.NextDayRefresh, self)
  EventManager:RemoveEvent(RacingActivityConst.EventId.EightThirtyRefresh, self)
  EventManager:RemoveEvent(RacingActivityConst.EventId.EightRefresh, self)
end

function M:RefreshHomeView()
  self:UpdateButtonState()
  self:RefreshStageTip()
  self:UpdateUpProgressTip()
  self:UpdatePetList()
  local Owner = self.ParentWidget
  if Owner and Owner.bShowPetPage and Owner.IsPetPageOpen then
    Owner:bShowPetPage(false)
  end
  local GuessPage = UIManager(self):GetUIObj("ActivityRacingChooseGuess")
  if GuessPage then
    GuessPage:Close()
  end
  local RumorPage = UIManager(self):GetUIObj("ActivityRacingRumor")
  if RumorPage then
    RumorPage:Close()
  end
  if Owner then
    Owner:SetFocus()
  end
end

function M:BuildPetSlotContent(SlotIndex, PlayerId, PetsData)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.OnMouseButtonDownEvents = {
    Obj = self,
    Callback = self.OnSlotClick,
    Params = {PlayerId}
  }
  if not PlayerId then
    Content.bIsEmpty = true
    return Content
  end
  local Pet = DataMgr.RaceLotteryPlayer[PlayerId]
  local PlayerData = PetsData and PetsData[PlayerId] or nil
  if not Pet or not PlayerData then
    Content.bIsEmpty = true
    return Content
  end
  Content.bIsEmpty = false
  Content.Index = SlotIndex
  Content.PlayerId = PlayerId
  Content.PlayerName = Pet.PlayerName
  Content.Icon = Pet.PlayerIcon
  Content.BaseSpeed = PlayerData.InitSpeed or 0
  return Content
end

function M:OnSlotClick(PlayerId)
  if not PlayerId then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/theater_online_stage_btn_click", nil, nil)
  else
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PetData = DataMgr.Pet[PlayerId]
    local PetNameTag = PetData and PetData.PetNameTag
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_hello", "PetVoice")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_select_pet", nil, nil)
  end
  self:OnChoosePetBtnClicked()
end

function M:UpdatePetList()
  self.List_Pet:ClearListItems()
  local ChoosePetList = RacingOutsiderModel:GetServerChoosePetList()
  local PetsData = RacingOutsiderModel:GetTodayPlayerList()
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward and RacingOutsiderModel:GetIsWatched() then
    RacingOutsiderController:SetIsShowRankInfo(true)
  else
    RacingOutsiderController:SetIsShowRankInfo(false)
  end
  for SlotIndex = 1, 6 do
    local PlayerId = ChoosePetList and ChoosePetList[SlotIndex] or nil
    local Content = self:BuildPetSlotContent(SlotIndex, PlayerId, PetsData)
    self.List_Pet:AddItem(Content)
  end
  self.List_Pet:RequestPlayEntriesAnim()
end

function M:UpdateButtonState()
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Btn_ChooseBet:SetBetCount()
    if RacingOutsiderModel:IsServerChoosePetEnough() then
      self.Btn_ChooseBet:ForbidBtn(false)
    else
      self.Btn_ChooseBet:ForbidBtn(true)
    end
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    self.Btn_GotoRace:SetText(GText(RacingActivityConst.GotoArenaText))
    if RacingOutsiderModel:GetIsWatched() or not RacingOutsiderModel:IsServerChoosePetEnough() then
      self.WS_Btn:SetActiveWidgetIndex(1)
      self.Btn_GotoRace:SetText(GText(RacingActivityConst.GotoArenaText))
    else
      self.WS_Btn:SetActiveWidgetIndex(2)
      self.Btn_Goto:IsShowReddot(true)
      self.Btn_Goto:SetText(GText(RacingActivityConst.GotoArenaYellowText))
    end
  else
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Btn_GotoRace:SetText(GText(RacingActivityConst.GotoArenaText))
  end
end

function M:UpdateUpProgressTip()
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    if RacingOutsiderModel:IsServerChoosePetEnough() then
      self.Group_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.WS_Desc:SetActiveWidgetIndex(0)
      self.Text_Title:SetText(GText(RacingActivityConst.HasChoosePetWaitRacingStartText))
      self.Text_TitleDesc01:SetText(GText(RacingActivityConst.MostBetGetText))
      self.Text_TitleDesc01_Num:SetText(RacingOutsiderModel:GetMaxBetRewardCount())
    else
      self.Group_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    self.WS_Desc:SetActiveWidgetIndex(1)
    self.Group_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Title:SetText(GText(RacingActivityConst.RaceFinishText))
    if not RacingOutsiderModel:IsServerChoosePetEnough() then
      self.Text_TitleDesc02:SetText(GText(RacingActivityConst.NotChoosePetText))
    elseif RacingOutsiderModel:GetIsWatched() then
      self.Text_TitleDesc02:SetText(string.format(GText(RacingActivityConst.GuessResultText), tostring(RacingOutsiderModel:GetGuessSuccessPlayerCount()), tostring(DataMgr.RaceLotteryRewardRate[RacingOutsiderModel:GetGuessSuccessPlayerCount()].RewardRate)))
    else
      self.Text_TitleDesc02:SetText(GText(RacingActivityConst.GotoGetRewardText))
    end
  else
    self.WS_Desc:SetActiveWidgetIndex(1)
    self.Group_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Title:SetText(GText(RacingActivityConst.InRacingText))
    self.Text_TitleDesc02:SetText(GText(RacingActivityConst.GotoWatchingText))
  end
end

function M:BindButtonEvent()
  self.Btn_ShopChoose.Btn_Click.OnClicked:Add(self, self.OnShopChooseBtnClicked)
  self.Btn_TaskChoose.Btn_Click.OnClicked:Add(self, self.OnTaskChooseBtnClicked)
  self.Btn_ChooseBet.Btn_Click.OnClicked:Add(self, self.OnChooseBetBtnClicked)
  self.Btn_ChoosePet.Btn_Click.OnClicked:Add(self, self.OnChoosePetBtnClicked)
  self.Btn_GotoRace.Btn_Click.OnClicked:Add(self, self.OnGotoRaceBtnClicked)
  self.Btn_Goto.Btn_Click.OnClicked:Add(self, self.OnGotoRaceBtnClicked)
  self.Btn_History.OnClicked:Add(self, self.OnHistoryBtnClicked)
  self.Btn_History.OnPressed:Add(self, self.OnHistoryBtnPressed)
  self.Btn_History.OnReleased:Add(self, self.OnHistoryBtnReleased)
  self.Btn_History.OnHovered:Add(self, self.OnHistoryBtnHovered)
  self.Btn_History.OnUnhovered:Add(self, self.OnHistoryBtnUnhovered)
end

function M:OnShopChooseBtnClicked()
  DebugPrint("Yihan@ OnShopChooseBtnClicked ")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_tab_btn_click", nil, nil)
  PageJumpUtils:JumpToTargetPageByJumpId(RacingActivityConst.EventShopId, function()
    self:PlayAnimation(self.Back)
  end, self)
end

function M:OnTaskChooseBtnClicked()
  DebugPrint("Yihan@ OnTaskChooseBtnClicked ")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_tab_btn_click", nil, nil)
  RacingOutsiderController:GetModel():OpenTaskReward()
end

function M:OnChooseBetBtnClicked()
  DebugPrint("Yihan@ OnChooseBetBtnClicked ")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  if self.Btn_ChooseBet.IsForbidden then
    if RacingOutsiderModel:GetNowBetCount() > 0 then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(RacingActivityConst.BetAlreadyMaxText))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(RacingActivityConst.ChoosePetFirstText))
    end
    return
  end
  local PlayerIdList = {}
  for _, PlayerId in pairs(RacingOutsiderModel:GetServerChoosePetList()) do
    table.insert(PlayerIdList, PlayerId)
  end
  local Params = {
    PlayerList = PlayerIdList,
    PageOwner = self.ParentWidget
  }
  UIManager(self):LoadUINew("ActivityRacingChooseGuess", Params)
end

function M:OnChoosePetBtnClicked(PlayerId)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  local Owner = self.ParentWidget
  DebugPrint("Yihan@ OnChoosePetBtnClicked ")
  if Owner and Owner.bShowPetPage then
    Owner:bShowPetPage(true)
  end
  self.ParentWidget.WBP_Activity_Racing_Pet_P:InitCompView()
  ReddotManager.ClearLeafNodeCount(RacingActivityConst.ReddotChoosePetKey, false)
end

function M:OnGotoRaceBtnClicked()
  DebugPrint("Yihan@ OnGotoRaceBtnClicked ")
  local JumpId = tonumber(DataMgr.RaceLotteryConstant.EventResultJumpId.ConstantValue)
  PageJumpUtils:JumpToTargetPageByJumpId(JumpId)
  SpecialLoadingRule:TryEnterActivityRacingLoading()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
end

function M:OnHistoryBtnClicked()
  DebugPrint("Yihan@ OnHistoryBtnClicked ")
  self:PlayAnimation(self.History_Click)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_sub_level_btn_click", nil, nil)
  UIManager(self):LoadUINew("ActivityRacingHistoryRecord")
end

function M:OnHistoryBtnPressed()
  self:PlayAnimation(self.History_Press)
end

function M:OnHistoryBtnReleased()
  self:PlayAnimation(self.History_Normal)
end

function M:OnHistoryBtnHovered()
  self:PlayAnimation(self.History_Hover)
end

function M:OnHistoryBtnUnhovered()
  self:PlayAnimation(self.History_Unhover)
end

function M:RefreshStageTip()
  local RaceLotteryStartTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryStartTime.ConstantValue)
  local RaceLotteryEndTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryEndTime.ConstantValue)
  local RaceLotteryResultTime = self:GetStageTimeStamp(DataMgr.RaceLotteryConstant.RaceLotteryResultTime.ConstantValue)
  DebugPrint("Yihan@ RefreshStageTip: ", CommonUtils.IsRaceLotterySelectPlayerTime(), CommonUtils.IsRaceLotteryGetRewardTime())
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.SelectPlayer
    self.WS_SubTitle:SetActiveWidgetIndex(0)
    self.Text_Time:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryStartTime), self:FormatTimeToDescriptionText(RaceLotteryEndTime)))
    self.Image_SubTitleBG:SetColorAndOpacity(self.SubTitleBG_Guess)
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.GetReward
    self.WS_SubTitle:SetActiveWidgetIndex(2)
    self.Text_Time:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryResultTime), self:FormatTimeToDescriptionText(RaceLotteryStartTime)))
    self.Image_SubTitleBG:SetColorAndOpacity(self.SubTitleBG_Result)
    RacingOutsiderModel:GetAllPlayerInfo()
  else
    RacingOutsiderModel.CurActivityStage = RacingActivityConst.RacingActivityStage.WaitingResult
    self.WS_SubTitle:SetActiveWidgetIndex(1)
    self.Text_Time:SetText(string.format("%s-%s", self:FormatTimeToDescriptionText(RaceLotteryEndTime), self:FormatTimeToDescriptionText(RaceLotteryResultTime)))
    self.Image_SubTitleBG:SetColorAndOpacity(self.SubTitleBG_Waiting)
  end
  if self.ParentWidget then
    self.ParentWidget:UpdateBgColor()
  end
end

function M:InitTextMap()
  self.Text_SubTitle_Guess:SetText(GText(RacingActivityConst.SelectPlayerText))
  self.Text_SubTitle_Waiting:SetText(GText(RacingActivityConst.WaitingText))
  self.Text_SubTitle_Result:SetText(GText(RacingActivityConst.GetRewardText))
  self.Btn_ShopChoose.Text_Entry:SetText(GText(RacingActivityConst.ActivityShopText))
  self.Btn_TaskChoose.Text_Entry:SetText(GText(RacingActivityConst.ActivityTaskText))
  self.Btn_ChooseBet.Text_Btn:SetText(GText(RacingActivityConst.ChooseBetText))
  self.Btn_ChoosePet.Text_Btn:SetText(GText(RacingActivityConst.ChoosePetText))
  self.Text_History:SetText(GText(RacingActivityConst.HistoryText))
end

function M:InitIcon()
  local IconResourceId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local IconPath = DataMgr.Resource[IconResourceId].Icon
  local IconDice = LoadObject(IconPath)
  self.Common_Item_Icon.Img_Icon:SetBrushResourceObject(IconDice)
  self.Common_Item_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:GetStageTimeStamp(TimeValue)
  local NeedCalcuTime = tonumber(TimeValue)
  local NowTime = TimeUtils.NowTime()
  local TodayBegin = os.date("*t", NowTime)
  TodayBegin.hour = 0
  TodayBegin.min = 0
  TodayBegin.sec = 0
  local ZeroClockTimeStamp = os.time(TodayBegin)
  return ZeroClockTimeStamp + NeedCalcuTime * 24 * 3600
end

function M:FormatTimeToDescriptionText(Timestamp, UserServerTimezone, Joiner)
  Timestamp = Timestamp or TimeUtils.NowTime()
  if type(Timestamp) == "table" and Timestamp.GetTime then
    Timestamp = Timestamp:GetTime()
  end
  Joiner = Joiner or ":"
  if nil == UserServerTimezone then
    UserServerTimezone = false
  end
  if UserServerTimezone then
    Timestamp = os.time(os.date("!*t", Timestamp)) + TimeUtils.GetServerTimeZone() * 3600
  end
  return os.date("%H" .. Joiner .. "%M", Timestamp)
end

function M:PlayAnimationIn()
  DebugPrint("Yihan@ PlayAnimationIn: ")
  AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_support_page_in", nil, nil)
  self:PlayAnimation(self.In)
  self:PlayAnimation(self.Tips)
  self.IsInAnimation = true
end

function M:PlayAnimationOut()
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self.IsInAnimation = false
  end
end

function M:BindReddotTreeEvents()
  ReddotManager.AddListenerEx(RacingActivityConst.ReddotChoosePetKey, self, function()
    self:UpdateChoosePetReddot()
  end)
  if not ReddotManager.GetTreeNode(RacingActivityConst.ReddotRewardKey) then
    ReddotManager.AddNodeEx(RacingActivityConst.ReddotRewardKey)
  end
  ReddotManager.AddListenerEx(RacingActivityConst.ReddotRewardKey, self, self.OnRefreshTaskRewardReddot)
end

function M:UnBindReddotTreeEvents()
  ReddotManager.RemoveListener(RacingActivityConst.ReddotChoosePetKey, self)
  ReddotManager.RemoveListener(RacingActivityConst.ReddotRewardKey, self)
end

function M:UpdateChoosePetReddot()
  local ChoosePetReddotNode = ReddotManager.GetTreeNode(RacingActivityConst.ReddotChoosePetKey)
  self.Btn_ChoosePet:IsShowNew(ChoosePetReddotNode.Count > 0)
end

function M:OnRefreshTaskRewardReddot(Count, RedType, Name)
  DebugPrint("RacingEntrance=== OnRefreshTaskRewardReddot", Count, RedType, Name)
  self.Btn_TaskChoose:RefreshReddot(Count)
end

function M:Destruct()
  self.Btn_ShopChoose.Btn_Click.OnClicked:Remove(self, self.OnShopChooseBtnClicked)
  self.Btn_TaskChoose.Btn_Click.OnClicked:Remove(self, self.OnTaskChooseBtnClicked)
  self.Btn_ChooseBet.Btn_Click.OnClicked:Remove(self, self.OnChooseBetBtnClicked)
  self.Btn_ChoosePet.Btn_Click.OnClicked:Remove(self, self.OnChoosePetBtnClicked)
  self.Btn_GotoRace.Btn_Click.OnClicked:Remove(self, self.OnGotoRaceBtnClicked)
  self.Btn_Goto.Btn_Click.OnClicked:Remove(self, self.OnGotoRaceBtnClicked)
  self.Btn_History.OnClicked:Remove(self, self.OnHistoryBtnClicked)
  self.Btn_History.OnPressed:Remove(self, self.OnHistoryBtnPressed)
  self.Btn_History.OnReleased:Remove(self, self.OnHistoryBtnReleased)
  self.Btn_History.OnHovered:Remove(self, self.OnHistoryBtnHovered)
  self.Btn_History.OnUnhovered:Remove(self, self.OnHistoryBtnUnhovered)
  self:UnBindReddotTreeEvents()
  self:UnBindEvent()
  SpecialLoadingRule:TryLeaveActivityRacingLoading()
end

return M
