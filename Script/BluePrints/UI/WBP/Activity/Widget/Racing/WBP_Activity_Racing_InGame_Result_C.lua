require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local InGameModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingInGameModel")
local ResultState = {PlayerRanking = 0, Income = 1}
local ResultStarInInterval = 0.3
local ResultStarInTimerKeyPrefix = "RacingResultStarIn_"

function M:Construct()
  self.Super.Construct(self)
  self.Btn_Again.Text_Btn:SetText(GText("UI_CTL_LookAgain"))
  self.Btn_GetReward.Text_Btn:SetText(GText("UI_CTL_Quit"))
  self.Text_ScoreTitle:SetText(GText("UI_Event_RaceLottery_BetReward"))
  self.Text_Tip:SetText(GText("UI_Event_RaceLottery_ClickToClose"))
  self.List_Pet:ClearListItems()
  self.ListedPlayerNum = DataMgr.RaceLotteryConstant.ShortListedPlayerNum.ConstantValue
  self.ListedPlayerNum = tonumber(self.ListedPlayerNum)
  self.AnteNum = 0
  self.CorrectNum = 0
  self.Rate = DataMgr.RaceLotteryRewardRate[0].RewardRate
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  for i = 1, self.ListedPlayerNum do
    local ResultStar = self["ResultStar_" .. i]
    ResultStar.Image_Star:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:Destruct()
  self:ClearScoreAnimation()
  self.Super.Destruct(self)
  MissionIndicatorManager:TriggerAllIndicatorVisible(true)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local CurrentTimeStamp = TimeUtils.NowTime()
  local EventConfigData = DataMgr.EventMain[RacingActivityConst.ActivityEventId]
  local RaceBeginTimeStamp = EventConfigData and EventConfigData.EventStartTime or 0
  local DiffDay = TimeUtils.GetIntervalDay(RaceBeginTimeStamp, CurrentTimeStamp) + 1
  self.Text_Title:SetText(string.format(GText("UI_GameEvent_RaceLottery_ResultBoardTitle"), DiffDay))
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.RaceLotteryInfo then
    return
  end
  self.AnteNum = Avatar.RaceLotteryInfo.RaceLotteryAnteNum
  if not self.Mobile then
    local BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_TALK_SKIP_MOIILE")
      }
    }
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
  end
  self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self:UpdateUIStyleInPlatform(not self.Gamepad)
  self:InitIcon()
  AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_finish_page_show", "PetRaceResult", nil)
end

function M:InitIcon()
  local IconResourceId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local IconPath = DataMgr.Resource[IconResourceId].Icon
  local IconDice = LoadObject(IconPath)
  self.Common_Item_Icon.Img_Icon:SetBrushResourceObject(IconDice)
  self.Common_Item_Icon.NotInteractive = true
end

function M:InitPetList(TotalPlayerList, ChoosePlayerList)
  local PlayerList = ChoosePlayerList
  local CurNum = 0
  self.CorrectNum = 0
  for _, PlayerId in pairs(PlayerList) do
    CurNum = CurNum + 1
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.PlayerId = PlayerId
    Content.No = TotalPlayerList[PlayerId].No
    Content.InitSpeed = TotalPlayerList[PlayerId].Speed
    Content.Ranking = TotalPlayerList[PlayerId].Ranking
    Content.RumorList = TotalPlayerList[PlayerId].RumorList
    self.List_Pet:AddItem(Content)
    if Content.Ranking <= self.ListedPlayerNum then
      self.CorrectNum = self.CorrectNum + 1
    end
  end
  self.Rate = DataMgr.RaceLotteryRewardRate[self.CorrectNum].RewardRate
  if 0 == CurNum then
    self.bNeedSkipMultiAnimaiton = true
  end
  if CurNum < self.ListedPlayerNum then
    self:FillPetList(CurNum)
  end
end

function M:FillPetList(CurNum)
  for i = CurNum + 1, self.ListedPlayerNum do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    self.List_Pet:AddItem(Content)
  end
end

function M:ShowList(TotalPlayerList, ChoosePlayerList)
  self.Btn_Close:SetVisibility(ESlateVisibility.Visible)
  self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_List:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_List:SetRenderOpacity(1.0)
  local Pos = FVector2D(0, 0)
  self.Group_List:SetRenderTranslation(Pos)
  self.Group_Score:SetVisibility(ESlateVisibility.Collapsed)
  self.HB_Btn:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_ScoreItem:SetVisibility(ESlateVisibility.Collapsed)
  self.CurState = ResultState.PlayerRanking
  self.Btn_Close.OnClicked:Add(self, self.OnCloseBtnClick)
  self:InitPetList(TotalPlayerList, ChoosePlayerList)
  self:PlayAnimation(self.In)
end

function M:ShowScore()
  self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
  self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
  self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Score:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Group_ScoreItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_ItemNum:SetText(0)
  local BounsStr = "x" .. self.Rate
  self.Text_Bouns:SetText(BounsStr)
  self.CurState = ResultState.Income
  self.Btn_GetReward.Btn_Click.OnClicked:Add(self, self.OnCloseBtnClick)
  self.Btn_Again.Btn_Click.OnClicked:Add(self, self.Replay)
  self:UnbindAllFromAnimationFinished(self.Score_In)
  self:BindToAnimationFinished(self.Score_In, {
    self,
    self.OnScoreInAnimationFinished
  })
  self:PlayAnimation(self.Score_In)
  if self.bNeedSkipMultiAnimaiton then
    AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_finish_reward_in_bet", "PetRaceResultBet", nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_finish_reward_in_bet", "PetRaceResultBet", nil)
  end
end

function M:InitScore()
  self:ClearScoreAnimation()
  local StarNum = math.min(self.CorrectNum, self.ListedPlayerNum)
  for i = 1, self.ListedPlayerNum do
    local ResultStar = self["ResultStar_" .. i]
    if ResultStar and ResultStar.Image_Star then
      ResultStar.Image_Star:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  if StarNum <= 0 then
    self:PlayRefreshAnimation()
    return
  end
  for i = 1, StarNum do
    local StarIndex = i
    local ResultStar = self["ResultStar_" .. StarIndex]
    local TimerKey = ResultStarInTimerKeyPrefix .. StarIndex
    self:AddTimer(ResultStarInInterval * (StarIndex - 1), function()
      if not ResultStar then
        return
      end
      ResultStar.Image_Star:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      if StarIndex == StarNum then
        ResultStar:UnbindAllFromAnimationFinished(ResultStar.In)
        ResultStar:BindToAnimationFinished(ResultStar.In, {
          self,
          self.OnLastStarInAnimationFinished
        })
      end
      ResultStar:PlayAnimation(ResultStar.In)
      AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_finish_reward_in_bet_crown_add", "PetRaceResultStar", nil)
    end, false, 0, TimerKey)
  end
end

function M:ClearScoreAnimation()
  if self.ListedPlayerNum then
    for i = 1, self.ListedPlayerNum do
      self:RemoveTimer(ResultStarInTimerKeyPrefix .. i)
      local ResultStar = self["ResultStar_" .. i]
      if ResultStar and ResultStar.In then
        ResultStar:UnbindAllFromAnimationFinished(ResultStar.In)
      end
    end
  end
  local RefreshAnimation = self:GetRefreshAnimation()
  if RefreshAnimation then
    self:UnbindAllFromAnimationFinished(RefreshAnimation)
  end
  if self.Multiply then
    self:UnbindAllFromAnimationFinished(self.Multiply)
  end
  self:RemoveTimer("UpdateNum")
end

function M:GetRefreshAnimation()
  return self.Refrsh or self.Refresh
end

function M:OnLastStarInAnimationFinished()
  self:PlayRefreshAnimation()
end

function M:PlayRefreshAnimation()
  local RefreshAnimation = self:GetRefreshAnimation()
  if not RefreshAnimation then
    self.Text_ItemNum:SetText(self.AnteNum)
    self:PlayMultiplyAnimation()
    return
  end
  self:UnbindAllFromAnimationFinished(RefreshAnimation)
  self:BindToAnimationFinished(RefreshAnimation, {
    self,
    self.OnRefreshAnimationFinished
  })
  self:PlayAnimation(RefreshAnimation)
end

function M:OnRefreshAnimationFinished()
  local RefreshAnimation = self:GetRefreshAnimation()
  if RefreshAnimation then
    self:UnbindAllFromAnimationFinished(RefreshAnimation)
  end
  self:RemoveTimer("UpdateNum")
  self.Text_ItemNum:SetText(self.AnteNum)
  self:PlayMultiplyAnimation()
end

function M:PlayMultiplyAnimation()
  self:UnbindAllFromAnimationFinished(self.Multiply)
  self:BindToAnimationFinished(self.Multiply, {
    self,
    self.OnMultiplyAnimationFinished
  })
  self:PlayAnimation(self.Multiply)
  AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_finish_reward_in_bet_bonus_in", "PetRaceResultMultiply", nil)
end

function M:OnCloseBtnClick()
  if not self:IsAnimationPlaying(self.In) and not self:IsAnimationPlaying(self.Out) then
    if self.CurState == ResultState.PlayerRanking then
      self:ShowScore()
      self.CurState = ResultState.Income
    else
      self:UnbindAllFromAnimationFinished(self.Out)
      self:BindToAnimationFinished(self.Out, {
        self,
        self.OnOutAnimationFinished
      })
      self:PlayAnimation(self.Out)
      AudioManager(self):SetEventSoundParam(self, "PetRaceResult", {ToEnd = 1})
    end
  end
end

function M:OnOutAnimationFinished()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:RaceLotteryGetReward()
  end
  UIManager(self):HideAllUI_EX(InGameModel:GetShowUIList(), false, "PetRaceInGame")
  AudioManager(self):StopWorldChallengeSound()
  UIManager(self):SetBannedActionCallback("BlackScreen", false, "PetRaceStart")
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.bInPetRace = false
  self:Close()
end

function M:OnScoreInAnimationFinished()
  self.Group_List:SetVisibility(ESlateVisibility.Collapsed)
  if self.bNeedSkipMultiAnimaiton then
    self.HB_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Continue)
    return
  end
  self:InitScore()
end

function M:OnMultiplyAnimationFinished()
  self:RemoveTimer("UpdateNum")
  self.Text_ItemNum:SetText(math.floor(self.AnteNum * self.Rate))
  self.HB_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.Continue)
end

function M:Num_Add()
  local TargetNum = math.floor(self.AnteNum * self.Rate)
  local RefreshAnimation = self:GetRefreshAnimation()
  local OrigNum = self.AnteNum
  local AddNum = TargetNum - self.AnteNum
  if RefreshAnimation and self:IsAnimationPlaying(RefreshAnimation) then
    OrigNum = 0
    AddNum = self.AnteNum
  elseif self.Multiply and self:IsAnimationPlaying(self.Multiply) then
    OrigNum = self.AnteNum
    AddNum = TargetNum - self.AnteNum
  else
    return
  end
  self:RemoveTimer("UpdateNum")
  UIUtils.RollingNumberEffect(self, self.Text_ItemNum, OrigNum, AddNum, 1)
end

function M:Replay()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:RaceLotteryQueryRandomRaceId()
  end
  self:Close()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.Mobile then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    IsEventHandled = true
    self:OnCloseBtnClick()
  elseif "Gamepad_FaceButton_Top" == InKeyName and self.CurState == ResultState.Income then
    IsEventHandled = true
    self:Replay()
  end
  return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if IsUseKeyAndMouse then
    self.Btn_Again.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Btn_GetReward.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
  else
    self:SetFocus()
    self.Btn_Again.Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Again.Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
    self.Btn_GetReward.Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_GetReward.Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      }
    })
    if self.CurState == ResultState.PlayerRanking then
      self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
end

return M
