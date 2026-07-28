require("UnLua")
local M = Class("BluePrints.UI.Dungeon.WBP_DungeonUIBase_C")

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.CurTime = 0
end

function M:AddTaskToOverlay(BattleMainUI)
  self.Super.AddTaskToOverlay(self, BattleMainUI)
  BattleMainUI.Battle_Map:SwitchMapState(true)
end

function M:InitListenEvent()
  self.Super.InitListenEvent(self)
  self:AddDispatcher(EventID.OnSetTempleLimit, self, self.OnSetTempleLimit)
  self:AddDispatcher(EventID.OnTempleTimeChanged, self, self.OnTempleTimeChanged)
  self:AddDispatcher(EventID.OnTempleEnter, self, self.OnTempleEnter)
  self:AddDispatcher(EventID.OnTempleTipButtonShow, self, self.OnTempleTipButtonShow)
  self:AddDispatcher(EventID.OnUpdatePartyLeftUI, self, self.OnUpdatePartyLeftUI)
  self:AddDispatcher(EventID.OnUpdateWeaponVerifyKillCount, self, self.OnUpdateWeaponVerifyKillCount)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:InitListenEvent()
  EventManager:FireEvent(EventID.OnTempleRightUI)
  self:InitInfo()
  self.ShouldListenInput = false
  if not self:IsListeningForInputAction("ActiveGuide") then
    self:ListenForInputAction("ActiveGuide", EInputEvent.IE_Pressed, true, {
      self,
      self.OnTipButtonClicked
    })
  end
  self.Btn_Click:UnBindEventOnClicked(self, self.OnTipButtonClicked)
  self.Btn_Click:BindEventOnClicked(self, self.OnTipButtonClicked)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  self:RefreshTipInfo()
end

function M:InitInfo()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if not GameInstance then
    return
  end
  self.DungeonId = GameInstance:GetCurrentDungeonId()
  self.DungeonInfo = DataMgr.Dungeon[self.DungeonId]
  if not self.DungeonInfo then
    return
  end
  if self.DungeonInfo.DungeonType == "Temple" then
    self.TempleInfo = DataMgr.Temple[self.DungeonId]
    self:InitTemple()
  elseif self.DungeonInfo.DungeonType == "Party" then
    self.TempleInfo = DataMgr.Party[self.DungeonId]
    if self.TempleInfo.SucRule == "Parkour" then
      EventManager:FireEvent(EventID.OnPartyProgressStart)
    end
    self:InitParty()
  elseif self.DungeonInfo.DungeonType == "WeaponVerify" then
    self:InitWeaponVerify()
  end
  self.Btn_Click:SetText(GText("UI_TEMPLE_TIPS_" .. self.DungeonId))
  self.Text_TempleKeyDesc:SetText(GText("UI_TEMPLE_TIPS_" .. self.DungeonId))
  self:InitTipsKey()
end

function M:InitTemple()
  self.IsCountDown = false
  if self.TempleInfo.SucRule == "CountDown" then
    self.IsCountDown = true
    self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
  elseif 1 == self.TempleInfo.UIHideFailCond then
    self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
    self:InitTargetInfo()
  else
    self.HB_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:InitTargetInfo()
  end
  self.Combo = UIManager(self):GetUIObj("BattleCombo")
  if self.Combo ~= nil and 1 == self.TempleInfo.UIHideCombo then
    self.Combo:SetRenderOpacity(0)
  end
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    self:AddTimer(1, function()
      UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    end, false, nil, nil, false)
  end
end

function M:InitParty()
  self.IsCountDown = false
  self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
  self:InitPartyTargetInfo()
  self.Combo = UIManager(self):GetUIObj("BattleCombo")
  if self.Combo ~= nil and 1 == self.TempleInfo.UIHideCombo then
    self.Combo:SetRenderOpacity(0)
  end
  self.Text_Time:SetText(self:GetTimeStr(0))
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    self:AddTimer(1, function()
      UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    end, false, nil, nil, false)
  end
end

function M:OnTempleTimeChanged(CurrentTime, ThresholdTime)
  local Time = ThresholdTime - CurrentTime
  local ChangeValue = Time - self.CurTime
  if ChangeValue > 1 then
    self.Text_TimeNumChange:SetText("+" .. ChangeValue)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Add)
  elseif ChangeValue < -1 then
    self.Text_TimeNumChange:SetText(ChangeValue)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Time_Minus)
  end
  if self.TempleInfo.SucRule == "Time" then
    self.Text_Time:SetText(self:GetTimeStr(CurrentTime))
  end
  if self.Limit == "TIME" then
    self.CurTime = Time
    if Time >= 0 then
      self.Text_Time:SetText(self:GetTimeStr(Time))
    end
  end
end

function M:OnSetTempleLimit(Limit, Value)
  self.Limit = Limit
  if "TIME" == Limit then
    self.TimeThreshold = Value
    self.CurTime = Value
    local Time = self:GetTimeStr(Value)
    self.Text_Time:SetText(Time)
  else
    self.Text_Time:SetText(Value)
  end
  if self.IsCountDown then
    self:InitTargetInfo()
  end
end

function M:InitTargetInfo()
  local TextRule2 = ""
  if self.TempleInfo.SucRule == "Time" then
    TextRule2 = "SECONDS"
  elseif self.TempleInfo.SucRule == "CountDown" then
    TextRule2 = "SECONDS"
  elseif self.TempleInfo.SucRule == "Score" then
    TextRule2 = "SCORE"
  elseif self.TempleInfo.SucRule == "Collect" then
    TextRule2 = "COUNT"
  end
  self.Text_TempleTitle:SetText(GText("DUNGEON_NAME_" .. self.DungeonId))
  self.Text_TempleDescTitle:SetText(GText("UI_TEMPLE_" .. self.DungeonId))
  if 1 == self.TempleInfo.UIHideDes then
    self.Text_TempleDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Text_TempleDesc:SetText(GText("UI_TEMPLE_DES_" .. self.DungeonId))
  end
end

function M:InitPartyTargetInfo()
  self.Text_TempleTitle:SetText(GText("DUNGEON_NAME_" .. self.DungeonId))
  self.Text_TempleDescTitle:SetText(GText("UI_PARTY_" .. self.DungeonId))
  self.Text_TempleDesc:SetText(GText("UI_PARTY_DES_" .. self.DungeonId))
end

function M:OnTempleEnter()
  EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Add)
  EMUIAnimationSubsystem:EMStopAnimation(self, self.Point_Minus)
  EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Add)
  EMUIAnimationSubsystem:EMStopAnimation(self, self.Time_Minus)
end

function M:OnTempleTipButtonShow(IsShow)
  if IsShow then
    self.ShouldListenInput = true
    self:RefreshTipInfo()
    self.Group_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Btn_In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/guide_button_show", "TipBtnShow", nil)
  else
    self.ShouldListenInput = false
    self:PlayAnimation(self.Btn_Out)
  end
end

function M:OnTipButtonClicked()
  if not self.ShouldListenInput then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    GameMode:GetDungeonComponent():OnClickShowTips()
  end
end

function M:OnUpdatePartyLeftUI(Time)
  self.Text_Time:SetText(self:GetTimeStr(Time))
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:RefreshTipInfo()
end

function M:RefreshTipInfo()
  if not self.ShouldListenInput then
    return
  end
  if CommonUtils.GetRuntimePlatform(self) == "Mobile" or self.CurInputDeviceType == ECommonInputType.Touch then
    self.WS_Btn:SetActiveWidgetIndex(0)
  elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Com_KeyAdd:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_KeyText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Com_KeyText:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_KeyAdd:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:InitTipsKey()
  self.Com_KeyText:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetActionMappingKeyName("ActiveGuide")
      }
    }
  })
  local ActiveGuide1 = UIUtils.GetIconListByActionName("ActiveGuide")[1]
  local ActiveGuide2 = UIUtils.GetIconListByActionName("ActiveGuide")[2]
  self.Com_KeyAdd:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = ActiveGuide1},
      {Type = "Img", ImgShortPath = ActiveGuide2}
    },
    Type = "Add"
  })
end

function M:InitWeaponVerify()
  self.IsCountDown = true
  self.HB_Time:SetVisibility(ESlateVisibility.Collapsed)
  self:InitWeaponVerifyTargetInfo()
  local UIBattleMain = UIManager(self):GetUI("BattleMain")
  if UIBattleMain then
    self:AddTimer(1, function()
      UIBattleMain.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    end, false, nil, nil, false)
  end
end

function M:InitWeaponVerifyTargetInfo()
  local EventLevelInfo = DataMgr.WeaponVerifyEventLevel[self.DungeonId]
  local WeaponVerifyInfo = DataMgr.WeaponVerify[self.DungeonId]
  self.Text_TempleTitle:SetText(GText(EventLevelInfo and EventLevelInfo.LevelName or " "))
  self.WeaponVerifyLevelDesKey = EventLevelInfo and EventLevelInfo.LevelDes
  self.WeaponVerifyWinMode = WeaponVerifyInfo and WeaponVerifyInfo.WinMode or 2
  self.WeaponVerifyWinTarget = WeaponVerifyInfo and WeaponVerifyInfo.WinTarget or 0
  self:RefreshWeaponVerifyLevelDesc(0, false)
  self.Text_TempleDesc:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:FormatWeaponVerifyLevelDes(Count)
  if not self.WeaponVerifyLevelDesKey then
    return ""
  end
  local Template = GText(self.WeaponVerifyLevelDesKey)
  local CurCount = Count or 0
  local Target = 2 == self.WeaponVerifyWinMode and (self.WeaponVerifyWinTarget or 0) or 1
  return string.format(Template, CurCount, Target)
end

function M:RefreshWeaponVerifyLevelDesc(Count, IsWin)
  if IsWin then
    self.WeaponVerifyProgressCount = 2 == self.WeaponVerifyWinMode and (self.WeaponVerifyWinTarget or 0) or 1
  else
    self.WeaponVerifyProgressCount = Count or 0
  end
  self.Text_TempleDescTitle:SetText(self:FormatWeaponVerifyLevelDes(self.WeaponVerifyProgressCount))
end

function M:OnUpdateWeaponVerifyKillCount(KillCount, IsWin)
  self:RefreshWeaponVerifyLevelDesc(KillCount, IsWin)
end

return M
