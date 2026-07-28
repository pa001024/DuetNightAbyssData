require("UnLua")
local ActivityRaceUtils = require("BluePrints.UI.WBP.Activity.Widget.Racing.ActivityRaceUtils")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  self.Text_Title:SetText(GText("UI_Event_RaceLottery_Title_PlaceBet"))
  self.Text_RewardTitle:SetText(GText("UI_Event_RaceLottery_ExpectedReward"))
  self.Text_CostTitle:SetText(GText("UI_Event_RaceLottery_CurrencyConsume"))
  self.CoinId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local ResourceInfo = DataMgr.Resource[self.CoinId] or {}
  self.Com_ItemIcon:Init({
    Icon = ResourceInfo.Icon
  })
  self.Com_ItemIcon_Cost:Init({
    Icon = ResourceInfo.Icon
  })
  self.Btn_Cancel.Text_Btn:SetText(GText("UI_Event_RaceLottery_CancelBet"))
  self.Btn_Cancel.Btn_Click.OnClicked:Add(self, self.OnCancelBtnClicked)
  self.Btn_Cancel.Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonRight)
  self.Btn_Confirm.Text_Btn:SetText(GText("UI_Event_RaceLottery_ConfirmBet"))
  self.Btn_Confirm.Btn_Click.OnClicked:Clear()
  self.Btn_Confirm.Btn_Click.OnClicked:Add(self, self.OnConfirmBtnClicked)
  self.Btn_Confirm.Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.CloseSelf
  })
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Destruct()
  self.Btn_Cancel.Btn_Click.OnClicked:Remove(self, self.OnCancelBtnClicked)
  self.Btn_Confirm.Btn_Click.OnClicked:Remove(self, self.OnConfirmBtnClicked)
  self.IsClickConfirmBtn = nil
  self:UnbindAllFromAnimationFinished(self.Out)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local Params = (...) or {}
  self.PlayerList = Params.PlayerList
  self.PageOwner = Params.PageOwner
  self.Avatar = GWorld:GetAvatar()
  self.Multiple = 0
  self.MaxCostNum = self:InitMaxCostNum()
  self.CostNum = self:InitCostNum()
  self.IsClickConfirmBtn = false
  self:InitMultipliers()
  self:InitSlider()
  self:InitResourceBar()
  self:PlayInAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/common/npc_info_panel", "RacingGuessPop", nil)
end

function M:RequestRefreshHomePage()
  local function RefreshCallback()
    if self.PageOwner and self.PageOwner.RefreshMainPage then
      self.PageOwner:RefreshMainPage()
    end
  end
  
  local TimerOwner = GWorld and GWorld.GameInstance and GWorld.GameInstance:GetGameUIManager() or nil
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.1, RefreshCallback, false, 0, "ActivityRacingChooseGuess_RefreshHome")
  else
    RefreshCallback()
  end
end

function M:InitMultipliers()
  self.List_Multiplier:ClearListItems()
  self.MultiplierContents = {}
  for Index, Data in pairs(DataMgr.RaceLotteryRewardRate or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Parent = self
    Content.Index = Index
    Content.Num = Data.TargetHitNum
    Content.Multiple = Data.RewardRate
    Content.CallbackObj = self
    Content.ClickCallback = self.OnMultiplerItemClicked
    self.List_Multiplier:AddItem(Content)
    table.insert(self.MultiplierContents, Content)
  end
  self.FirstTargetIndex = ActivityRaceUtils.GetGuessTempRewardRateIndex() or 0
  self.List_Multiplier:NavigateToIndex(self.FirstTargetIndex)
end

function M:InitSlider()
  local Params = {
    InitValue = self.CostNum,
    MaxValue = self.MaxCostNum,
    EnableMiniBtn = true,
    EnableMaxBtn = true,
    OwnerPanel = self,
    MinusBtnCallback = self.SliderChangeCallback,
    AddBtnCallback = self.SliderChangeCallback,
    MaxBtnCallback = self.SliderChangeCallback,
    SliderChangeCallback = self.SliderChangeCallback
  }
  self.Racing_Slider:Init(Params)
end

function M:InitMaxCostNum()
  local CurNum = self.Avatar:GetResourceNum(self.CoinId)
  local CurDay = CommonUtils.GetRaceLotteryAlreadyOpenDays()
  local MaxInfo = DataMgr.RaceLotteryMaxStake[CurDay] or {}
  local DataLenth = #DataMgr.RaceLotteryMaxStake
  local MaxNum = MaxInfo.MaxStake and MaxInfo.MaxStake - RacingOutsiderModel:GetNowBetCount() or DataMgr.RaceLotteryMaxStake[DataLenth].MaxStake - RacingOutsiderModel:GetNowBetCount()
  local Result = math.min(CurNum, MaxNum)
  return math.floor(Result)
end

function M:InitCostNum()
  if 0 == self.MaxCostNum then
    return 0
  end
  local CostNum = ActivityRaceUtils.GetGuessTempCostNum()
  local CostNum = math.clamp(CostNum, 0, self.MaxCostNum)
  local CurNum = self.Avatar:GetResourceNum(self.CoinId)
  if CurNum > 0 and 0 == CostNum then
    CostNum = 1
  end
  return CostNum
end

function M:InitResourceBar()
  self.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Visible)
  self.WBP_Com_Tab_Node_ResourceBar.HostCommonDialog = self
  self.WBP_Com_Tab_Node_ResourceBar:InitResourceBar({
    self.CoinId
  })
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
  self.WBP_Com_Tab_Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
end

function M:OnMultiplerItemClicked(Content)
  if self.LastClickedItem == Content then
    return
  end
  if not Content.SelfWidget then
    return
  end
  Content.SelfWidget:PlaySelectedAnimation()
  if self.LastClickedItem then
    local Widget = self.LastClickedItem.SelfWidget
    if Widget then
      Widget:PlayNormalAnimation()
    end
  end
  self.LastClickedItem = Content
  self.Multiple = Content.Multiple or 0
  if self.OldMultiple and self.Multiple > self.OldMultiple then
    self:PlayAnimation(self.Num_Change)
  end
  self:UpdateCostAndRewardInfo()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_photo_click", nil, nil)
end

function M:OnCancelBtnClicked()
  local AnteNum = self.Avatar.RaceLotteryInfo.RaceLotteryAnteNum
  local RaceLotteryPlayerList = self.Avatar.RaceLotteryInfo.RaceLotteryPlayerList
  ActivityRaceUtils.SetGuessTempCostNum(self.CostNum)
  ActivityRaceUtils.SetGuessTempRewardRateIndex(self.LastClickedItem and self.LastClickedItem.Index or 0)
  self:PlayOutAnimation()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
end

function M:OnConfirmBtnClicked()
  if self.IsClickConfirmBtn then
    return
  end
  if self.Btn_Confirm.IsForbidden then
    local CurNum = self.Avatar:GetResourceNum(self.CoinId)
    if CurNum <= 0 then
      UIManager(self):ShowUITip("CommonTopTips", string.format(GText("UI_Event_RaceLottery_LackofCoin")))
    elseif 0 == self.MaxCostNum then
      UIManager(self):ShowUITip("CommonTopTips", string.format(GText("UI_RaceLottery_Toast_MaxAntenum")))
    end
    return
  end
  self.IsClickConfirmBtn = true
  if self.PlayerList and #self.PlayerList > 0 then
    self.Avatar:RaceLotterySelectPlayer(self.PlayerList, function(ErrCode)
      if ErrorCode:Check(ErrCode) then
        self.Avatar:RaceLotteryAddAnteNum(self.CostNum, function(ErrCode)
          if not ErrorCode:Check(ErrCode) then
            local GuessPage = UIManager(self):GetUIObj("ActivityRacingChooseGuess")
            if GuessPage then
              GuessPage:Close()
            end
          else
            AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_sign_success", nil, nil)
            local ShuffledList = self.PlayerList
            for i = #ShuffledList, 2, -1 do
              local j = math.random(i)
              ShuffledList[i], ShuffledList[j] = ShuffledList[j], ShuffledList[i]
            end
            local SelectedPlayers = {}
            for i = 1, math.min(3, #ShuffledList) do
              table.insert(SelectedPlayers, ShuffledList[i])
            end
            for _, PlayerId in ipairs(SelectedPlayers) do
              local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
              local PetData = DataMgr.Pet[PlayerId]
              local PetNameTag = PetData and PetData.PetNameTag
              AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_happy", "PetVoice" .. PlayerId)
            end
            self:RequestRefreshHomePage()
          end
          self.IsClickConfirmBtn = false
        end)
        ActivityRaceUtils.SetGuessTempCostNum(0)
        ActivityRaceUtils.SetGuessTempRewardRateIndex(0)
        local GuessPage = UIManager(self):GetUIObj("ActivityRacingChooseGuess")
        if GuessPage then
          self:PlayOutAnimation()
        end
        if self.PageOwner and self.PageOwner.bShowPetPage then
          self.PageOwner:bShowPetPage(false)
        end
      end
    end)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
end

function M:UpdateCostAndRewardInfo()
  if self.CostNum == self.OldCostNum and self.Multiple == self.OldMultiple then
    return
  end
  local RewardNum = self.CostNum * self.Multiple
  self.Text_RewardNum:SetText(math.floor(RewardNum))
  self.Text_CostNum:SetText(self.CostNum)
  local SliderNumText = table.concat({
    self.CostNum,
    "/",
    self.MaxCostNum
  })
  self.Text_SliderTitle:SetText(GText("UI_Event_RaceLottery_BetNum") .. SliderNumText)
  self.OldCostNum = self.CostNum
  self.OldMultiple = self.Multiple
  self:UpdateConfirmBtnState()
end

function M:UpdateConfirmBtnState()
  local IsForbidden = self.CostNum <= 0 or self.MaxCostNum <= 0
  if IsForbidden == self.Btn_Confirm.IsForbidden then
    return
  end
  self.Btn_Confirm:StopAllAnimations()
  if IsForbidden then
    self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Forbidden)
  else
    self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Normal)
  end
  self.Btn_Confirm.IsForbidden = IsForbidden
end

function M:SliderChangeCallback(CurCount, OldCount)
  self.CostNum = math.floor(CurCount)
  self:UpdateCostAndRewardInfo()
end

function M:PlayInAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "RacingGuessPop", {ToEnd = 1})
end

function M:CloseSelf()
  self:Close()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
    self.Btn_Confirm.Com_KeyImg:SetVisibility(Visible)
    self.Btn_Cancel.Com_KeyImg:SetVisibility(Visible)
    self.List_Multiplier:SetFocus()
  else
    local Collapsed = UIConst.VisibilityOp.Collapsed
    self.Btn_Confirm.Com_KeyImg:SetVisibility(Collapsed)
    self.Btn_Cancel.Com_KeyImg:SetVisibility(Collapsed)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UIUtils.Handled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self.Racing_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  else
    IsEventHandled = self:Handle_KeyDownOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyDownOnPC(InKeyName)
  if "Escape" == InKeyName then
    self:OnCancelBtnClicked()
    return true
  end
  return false
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnCancelBtnClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnConfirmBtnClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(self.LastClickedItem.SelfWidget)
    self.WBP_Com_Tab_Node_ResourceBar:SetFocus()
    self.WBP_Com_Tab_Node_ResourceBar:FocusToResource()
    return true
  end
  return false
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_KeyUpOnGamePad(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyUpOnGamePad(InKeyName)
  return self.Racing_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
end

return M
