require("UnLua")
local EMCache = require("EMCache.EMCache")
local FULL_AUTO_FISHING_NEW_SEEN_CACHE_KEY = "FishingFullAutoNewSeen"
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local FishingGameState = {
  WaitStart = 1,
  WaitFishing = 2,
  Fishing = 3,
  EndFishing = 4
}
local AutoFishingStage = {
  Reward = 1,
  RecastDelay = 2,
  SmallToBigChoice = 3
}
local AUTO_FISHING_RECAST_TIMER_KEY = "AutoFishingRecast"
local AUTO_SMALL_TO_BIG_CONFIRM_DELAY = 10
local EaseFuc = {
  Linear = 0,
  InQuad = 1,
  OutQuad = 2,
  InOutQuad = 3,
  InCubic = 4,
  OutCubic = 5,
  InOutCubic = 6,
  InQuart = 7,
  OutQuart = 8,
  InOutQuart = 9,
  InSine = 10,
  OutSine = 11,
  InOutSine = 12,
  InExpo = 13,
  OutExpo = 14,
  InOutExpo = 15,
  InCirc = 16,
  OutCirc = 17,
  InOutCirc = 18,
  InElastic = 19,
  OutElastic = 20,
  InOutElastic = 21,
  InBack = 22,
  OutBack = 23,
  InOutBack = 24,
  InBounce = 25,
  OutBounce = 26,
  InOutBounce = 27,
  CurveFloat = 28
}

function M:Init(RootPage, FishingSpotId)
  self.RootPage = RootPage
  self.FishingSpotId = FishingSpotId
  self.SuccessTime = 10
  self.bCanSpace = true
  self.bCanEsc = true
  self.LastFishId = -1
  self.bIsSpecial = false
  self.AutoSessionSerial = 0
  self.CurrentAutoRound = nil
  self.bReturnToMainAfterSpecialOut = false
  self.FishingHookResponseTime = DataMgr.GlobalConstant.FishingHookResponseTime.ConstantValue
  self.FishingGameInitialProgress = DataMgr.GlobalConstant.FishingGameInitialProgress.ConstantValue
  self.Angling_Special:Init(self)
  self.Angling_Special:BindToAnimationFinished(self.Angling_Special.Out, {
    self,
    self.OnSpecialFishingPanelOut
  })
  self.ItemUpTime = DataMgr.FishingStick[1].MoveParam[1]
  self.ItemDownTime = DataMgr.FishingStick[1].MoveParam[2]
  self.DefaultBgLength = 392
  self.DefaultItemLength = 154
  self.DefaultItemY = 130
  self.ItemLength = DataMgr.FishingRod[self.RootPage.FishingRodId].Length or self.DefaultItemLength
  self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
  local bAutoPet = self.RootPage:CheckSkipFishingPet()
  self.WBP_Angling_Fishing_Btn:Init(self, bAutoPet)
  self:InitAutoFishingSwitches()
  self.CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
  self:RefreshInfoByInputTypeChange(self.CurMode)
  self:InitExitButton()
  EventManager:AddEvent(EventID.OnFishHook, self, self.OnFishHook)
  self.ResourceBar:InitResourceBar({
    DataMgr.FishingLure[self.RootPage.FishingLureId].ResourceId
  })
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
  self.ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
  self.ResourceBar:InitGamePadTip({
    KeyInfo = {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      },
      Desc = GText("UI_GACHA_DESDETAIL")
    },
    ClickFuncObj = self,
    ClickFunc = self.OnClickTip
  })
  self.ResourceBar:HideTip(false)
  if self.DeviceInPc then
    self.Key_PC.Panel_Key:ClearChildren()
    self.Key_FishingPC_A = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Key_PC.Panel_Key:AddChild(self.Key_FishingPC_A)
    self.Key_FishingPC_A:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Space",
          PressCallback = self.OnSpaceDown,
          ReleaseCallback = self.OnCommonBtnSpaceUp,
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Fish_Throw")
    })
    self.Key_FishingPC_B = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Key_PC.Panel_Key:AddChild(self.Key_FishingPC_B)
    self.Key_FishingPC_B:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnClickEsc,
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Quit")
    })
    self.Key_GamePad.Panel_Key:ClearChildren()
    self.Key_Fishing_A = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Key_GamePad.Panel_Key:AddChild(self.Key_Fishing_A)
    self.Key_Fishing_A:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_CTL_Fish_Throw")
    })
    self.Key_Fishing_B = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.Key_GamePad.Panel_Key:AddChild(self.Key_Fishing_B)
    self.Key_Fishing_B:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_CTL_Quit")
    })
  end
  self.Tip_DayAndNight:Init()
  self.InitGameStateFrame = 0
end

function M:InitAutoFishingSwitches()
  self.Btn_Auto.Text_Name:SetText(GText("UI_Fishing_AutoNode"))
  self.Btn_FFBF.Text_Name:SetText(GText("UI_Fishing_AutoSmallToBig"))
  if self.DeviceInPc then
    self.Btn_FFBF.Controller_CheckBox:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
    self.Btn_Auto.Controller_CheckBox:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  end
  self.Btn_Auto.SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnFullAutoFishingSwitchChanged)
  self.Btn_FFBF.SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnAutoSmallToBigSwitchChanged)
  self:RefreshAutoFishingSwitchState()
end

function M:RefreshAutoFishingSwitchState()
  local bCanAutoFishing = self.RootPage:CheckSkipFishingPet()
  local bFullAutoEnabled = self.RootPage.bFullAutoFishingPreference
  local bAutoSmallToBigEnabled = self.RootPage.bAutoSmallToBigPreference
  self.Btn_Auto.SwitchCheckBox:SetChecked(bFullAutoEnabled, false)
  self.Btn_FFBF.SwitchCheckBox:SetChecked(bAutoSmallToBigEnabled, false)
  self.Btn_Auto:SetVisibility(bCanAutoFishing and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  local SmallToBigVisibility = UIConst.VisibilityOp.Collapsed
  if bCanAutoFishing then
    SmallToBigVisibility = bFullAutoEnabled and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  end
  self.Btn_FFBF:SetVisibility(SmallToBigVisibility)
  local bShowNew = self.RootPage.bShowFullAutoFishingNew
  self.Btn_Auto.New:SetEnable(bShowNew)
  self.Btn_FFBF.New:SetEnable(bShowNew and bFullAutoEnabled)
  if bShowNew and bCanAutoFishing then
    EMCache:Set(FULL_AUTO_FISHING_NEW_SEEN_CACHE_KEY, true, true)
  end
end

function M:DismissAutoFishingSwitchNew()
  self.RootPage.bShowFullAutoFishingNew = false
  self.Btn_Auto.New:SetEnable(false)
  self.Btn_FFBF.New:SetEnable(false)
end

function M:OnFullAutoFishingSwitchChanged(bEnabled)
  self:DismissAutoFishingSwitchNew()
  self.RootPage:SetFullAutoFishingPreference(true == bEnabled)
  self:RefreshAutoFishingSwitchState()
  self:SetFocus()
  local TipTextId = bEnabled and "UI_Fishing_AutoOn_Tips" or "UI_Fishing_AutoOff_Tips"
  UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText(TipTextId))
  local AutoRound = self.CurrentAutoRound
  if not bEnabled and AutoRound and AutoRound.Stage == AutoFishingStage.RecastDelay then
    self:ClearPendingSmallToBigOpportunity(AutoRound)
    self:StopFullAutoFishingSession(true)
  end
end

function M:OnAutoSmallToBigSwitchChanged(bEnabled)
  self:DismissAutoFishingSwitchNew()
  self.RootPage:SetAutoSmallToBigPreference(true == bEnabled)
  self:RefreshAutoFishingSwitchState()
  self:SetFocus()
  local TipTextId = bEnabled and "UI_Fishing_AutoSmallToBigOn_Tips" or "UI_Fishing_AutoSmallToBigOff_Tips"
  UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText(TipTextId))
end

function M:IsCurrentAutoRound(AutoRound)
  return nil ~= AutoRound and self.CurrentAutoRound == AutoRound
end

function M:StartFishingRound(bFromAuto, SmallToBigLureFishId)
  if self.FishingGameState ~= FishingGameState.WaitStart or self.CurrentAutoRound ~= nil then
    return false
  end
  local bIsSmallToBigCast = nil ~= SmallToBigLureFishId
  if not bFromAuto then
    self:DismissAutoFishingSwitchNew()
  end
  local AutoRound
  if bFromAuto or self.RootPage.bFullAutoFishingPreference and self.RootPage:CheckSkipFishingPet() then
    if not bFromAuto then
      self.AutoSessionSerial = self.AutoSessionSerial + 1
    end
    AutoRound = {
      SessionId = self.AutoSessionSerial,
      FishingRodId = self.RootPage.FishingRodId,
      AutoSmallToBigEnabled = self.RootPage.bAutoSmallToBigPreference
    }
    self.CurrentAutoRound = AutoRound
  end
  self.WBP_Angling_Fishing_Btn:SetFullAutoFishingState(self.CurrentAutoRound ~= nil)
  self:SwitchWaitFishing(bIsSmallToBigCast, AutoRound, SmallToBigLureFishId)
  return true
end

function M:SwitchWaitStart(FromSpecial, AutoRound)
  if self.FishingGameState == FishingGameState.WaitStart and not FromSpecial then
    return
  end
  self.FishingGameState = FishingGameState.WaitStart
  self.Panel:SetVisibility(ESlateVisibility.Collapsed)
  self.bCanSpace = true
  self.bCanEsc = true
  if self.DeviceInPc then
    local FishingActionText = GText(AutoRound and "UI_Fishing_AutoEnd" or "UI_CTL_Fish_Throw")
    self.Key_FishingPC_A:ChangeText(FishingActionText)
    self.Key_FishingPC_B:ChangeText(GText("UI_CTL_Quit"))
    self.Key_Fishing_A:ChangeText(FishingActionText)
    self.Key_Fishing_B:ChangeText(GText("UI_CTL_Quit"))
  end
  if self.WBP_Angling_Fishing_Btn.ButtonPress then
    self.WBP_Angling_Fishing_Btn:OnReleaseButton(false)
  end
  if self.bIsSpecial and not AutoRound then
    self.WBP_Angling_Fishing_Btn:SetVisibility(ESlateVisibility.Collapsed)
    self.Angling_Special:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Angling_Special:OnCanSpecialFishing()
    self.bIsSpecial = false
  else
    self.WBP_Angling_Fishing_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Angling_Special:SetVisibility(ESlateVisibility.Collapsed)
    if AutoRound then
      AutoRound.CanSmallToBig = true == self.bIsSpecial
      self.bIsSpecial = false
    end
    self.LastFishId = -1
    local FishingLureData = DataMgr.FishingLure[self.RootPage.FishingLureId]
    local ResourceId = FishingLureData and FishingLureData.ResourceId
    local Count = ResourceId and self.RootPage.Angling_Main:GetResourceCount(ResourceId) or 0
    if 0 == Count then
      self.WBP_Angling_Fishing_Btn:SwitchWaitStart(true)
      self.RootPage.Angling_Main.BtnText:ForbidBtn(true)
    else
      self.WBP_Angling_Fishing_Btn:SwitchWaitStart(false)
      self.RootPage.Angling_Main.BtnText:ForbidBtn(false)
    end
  end
  self.WBP_Angling_Fishing_Btn:SetFullAutoFishingState(self.CurrentAutoRound ~= nil)
end

function M:SwitchWaitFishing(bIsSpecial, AutoRound, SmallToBigLureFishId)
  if self.FishingGameState == FishingGameState.WaitFishing then
    return
  end
  self.FishingGameState = FishingGameState.WaitFishing
  self.WBP_Angling_Fishing_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.WBP_Angling_Fishing_Btn:SwitchWaitFishing()
  self.Panel:SetVisibility(ESlateVisibility.Collapsed)
  self.Angling_Special:SetVisibility(ESlateVisibility.Collapsed)
  if self.DeviceInPc then
    local FishingActionText = GText(AutoRound and "UI_Fishing_AutoEnd" or "UI_CTL_Fish_Collect")
    self.Key_FishingPC_A:ChangeText(FishingActionText)
    self.Key_Fishing_A:ChangeText(FishingActionText)
  end
  self.RootPage:PlayPlayerMontage(1)
  self:AvatarStartFish(bIsSpecial, AutoRound, SmallToBigLureFishId)
end

function M:SwitchFishing()
  if self.FishingGameState == FishingGameState.Fishing then
    return
  end
  self:RemoveTimer("OnFishHookTimeOut")
  self.FishingGameState = FishingGameState.Fishing
  self.WBP_Angling_Fishing_Btn:SwitchFishing()
  self.RootPage.FishingSpot:OnFishing()
  self.Panel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Angling_Special:SetVisibility(ESlateVisibility.Collapsed)
  if self.DeviceInPc then
    self.Key_FishingPC_A:ChangeText(GText("UI_CTL_Fish_Lift"))
    self.Key_Fishing_A:ChangeText(GText("UI_CTL_Fish_Lift"))
    self.Key_FishingPC_B:ChangeText(GText("UI_CTL_Fish_Collect"))
    self.Key_Fishing_B:ChangeText(GText("UI_CTL_Fish_Collect"))
  end
  self:InitFishingGameState()
  self.RootPage:PlayPlayerMontage(2)
end

function M:SwitchEndFishing(bInterupt, bSuccess, AutoRound)
  if self.FishingGameState == FishingGameState.EndFishing then
    return
  end
  self.FishingGameState = FishingGameState.EndFishing
  self.WBP_Angling_Fishing_Btn:SwitchEndFishing()
  self.Panel:SetVisibility(ESlateVisibility.Collapsed)
  self.Angling_Special:SetVisibility(ESlateVisibility.Collapsed)
  self.bCanEsc = false
  if IsValid(self.handle) then
    self.handle:Kill(false)
  end
  local Callback = {
    OnNotifyBegin = function()
      if AutoRound then
        if self:IsCurrentAutoRound(AutoRound) and not AutoRound.CompletionSent then
          AutoRound.CompletionSent = true
          self:AvatarCompleteFish(bSuccess, self.LastFishId, AutoRound)
        end
        return
      end
      if not bInterupt then
        self:AvatarCompleteFish(bSuccess, self.LastFishId)
      end
      self:SwitchWaitStart()
    end
  }
  if bInterupt then
    self:AvatarStopFish()
    self.RootPage.FishingSpot:OnFishFail()
  elseif not bSuccess then
    self.bIsSpecial = false
  end
  if bSuccess then
    self.RootPage.FishingSpot:OnGetFishEnd()
  end
  self.RootPage:PlayPlayerMontage(3, Callback)
  AudioManager(self):StopSound(self, "OnFishHook")
  AudioManager(self):StopSound(self, "FishItemInRegion")
end

function M:OnSpecialFishingPanelOut()
  if self.DeviceInPc then
    self.WidgetSwitcher_MP:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  local AutoRound = self.CurrentAutoRound
  if AutoRound and AutoRound.Stage == AutoFishingStage.SmallToBigChoice then
    self.Angling_Special:RemoveTimer("SpecialFishing")
    self.Angling_Special:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.Angling_Special.bFailed then
      local bReturnToMain = self.bReturnToMainAfterSpecialOut
      self.bReturnToMainAfterSpecialOut = false
      self:ClearPendingSmallToBigOpportunity(AutoRound)
      self:StopFullAutoFishingSession(true)
      if bReturnToMain then
        self.RootPage:SwitchOnMainPage()
      end
    else
      AutoRound.Stage = AutoFishingStage.RecastDelay
      self:OnAutoFishingRecast(AutoRound, AutoRound.FishId)
    end
    return
  end
  if AutoRound then
    self.Angling_Special:RemoveTimer("SpecialFishing")
    return
  end
  if self.Angling_Special.bFailed then
    self.Angling_Special:SetVisibility(ESlateVisibility.Collapsed)
    self:SwitchWaitStart(true)
  else
    self:SwitchWaitFishing(true)
  end
end

function M:OnClickExit()
  if self.CurrentAutoRound then
    self.bReturnToMainAfterSpecialOut = self.CurrentAutoRound.Stage == AutoFishingStage.SmallToBigChoice
    self:RequestEndFullAutoFishing()
    if not self.bReturnToMainAfterSpecialOut then
      self.RootPage:SwitchOnMainPage()
    end
  elseif not self.bCanEsc then
    return
  elseif self.FishingGameState == FishingGameState.Fishing then
    self:SwitchEndFishing(false, false)
  elseif self.FishingGameState == FishingGameState.WaitFishing then
    self:RemoveTimer("OnFishHookTimeOut")
    self:SwitchEndFishing(true, false)
  else
    self:DismissAutoFishingSwitchNew()
    self.RootPage:SwitchOnMainPage()
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
end

function M:InitExitButton()
  self.Btn_Quit.OnClicked:Add(self, self.OnClickEsc)
end

function M:OnClickAnglingButton()
  if self.WBP_Angling_Fishing_Btn:GetVisibility() == ESlateVisibility.Collapsed or not self.bCanSpace then
    return
  end
  if self.CurrentAutoRound then
    self:RequestEndFullAutoFishing()
    return
  end
  if self.FishingGameState == FishingGameState.WaitStart then
    self:StartFishingRound(false)
  elseif self.FishingGameState == FishingGameState.WaitFishing then
    AudioManager(self):StopSound(self, "OnFishHook")
    if -1 == self.LastFishId then
      self:SwitchEndFishing(true, false)
    elseif not self:CheckSkipAngling() then
      self:SwitchFishing()
    else
      self:SwitchEndFishing(false, true)
    end
  elseif self.FishingGameState == FishingGameState.Fishing then
  end
end

function M:InitFishingGameState()
  self.InitSucc = false
  self.Angling_Bar:SetPercent(0)
  self.TotalGameTime = 0
  self.EffectGameTime = self.FishingGameInitialProgress * self.SuccessTime
  self:InitFishCurve()
  self.ItemLength = DataMgr.FishingRod[self.RootPage.FishingRodId].Length or self.DefaultItemLength
  local CanvasSlot1 = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item)
  local Position = CanvasSlot1:GetPosition()
  Position.Y = self.DefaultItemY + (self.DefaultItemLength - self.ItemLength) / 2
  CanvasSlot1:SetPosition(Position)
  local CanvasSlot2 = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Icon01)
  local Position = CanvasSlot2:GetPosition()
  Position.Y = 0
  CanvasSlot2:SetPosition(Position)
  local CanvasSlot3 = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item.Bg02)
  local Size = CanvasSlot3:GetSize()
  Size.Y = self.ItemLength
  CanvasSlot3:SetSize(Size)
  self.bInitGame = true
end

function M:InitWidgetPosition()
  local BGSize = UIManager(self):GetWidgetRenderSize(self.Bg01)
  self.MaxFishY = BGSize.Y / 2
  self.MinFishY = -BGSize.Y / 2
  local ItemSize = UIManager(self):GetWidgetRenderSize(self.WBP_Angling_Fishing_Item)
  self.EffectMaxY = ItemSize.Y / 2
  self.EffectMinY = -ItemSize.Y / 2
  self.MaxItemY = self.DefaultItemY + (self.DefaultItemLength - self.ItemLength) / 2
  self.MinItemY = -self.MaxItemY
  self:FishIconMove()
  self:UpdateFishingItem()
  self:CheckFish(0)
  self.InitSucc = true
end

function M:InitFishCurve()
  local FishData = DataMgr.Fish[self.LastFishId]
  if not FishData then
    GWorld.logger.error("LXZ InitFishingGameState 鱼的Id错误,不存在鱼表的数据， FishId:", self.LastFishId)
  end
  local FishMoveId = FishData.FishMoveId
  if not FishMoveId or not DataMgr.FishMove[FishMoveId] then
    GWorld.logger.error("LXZ InitFishingGameState 鱼的运动Id错误,不存在鱼运动表的数据， FishMoveId:", FishMoveId)
  end
  local FishMoveCurvePath = DataMgr.FishMove[FishMoveId].FishMoveCurve
  self.Curve = LoadObject(FishMoveCurvePath)
  self.CurveMaxTime = DataMgr.FishMove[FishMoveId].MaxTime
  if not FishMoveCurvePath or not self.Curve then
    GWorld.logger.error("LXZ InitFishingGameState 鱼的运动曲线路径错误,不存在曲线路径或对应曲线资产， FishMoveId:", FishMoveId)
  end
end

function M:Tick(MyGeometry, InDeltaTime)
  if self.bInitGame then
    self.InitGameStateFrame = self.InitGameStateFrame + 1
    if self.InitGameStateFrame > 1 then
      self:InitWidgetPosition()
      self.InitGameStateFrame = 0
      self.bInitGame = false
    end
  end
  if self.FishingGameState ~= FishingGameState.Fishing or not self.InitSucc then
    return
  end
  self.TotalGameTime = self.TotalGameTime + InDeltaTime
  if self.TotalGameTime > self.CurveMaxTime then
    self.TotalGameTime = 0
  end
  self:FishIconMove()
  self:UpdateFishingItem()
  self:CheckFish(InDeltaTime)
end

function M:FishIconMove()
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Icon01)
  local Position = CanvasSlot:GetPosition()
  local CurveY = self.Curve:GetFloatValue(self.TotalGameTime)
  Position.Y = math.min(CurveY, self.MaxFishY)
  Position.Y = math.max(CurveY, self.MinFishY)
  CanvasSlot:SetPosition(Position)
end

function M:UpdateFishingItem()
  local ItemSize = UIManager(self):GetWidgetRenderSize(self.WBP_Angling_Fishing_Item)
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item)
  local Position = CanvasSlot:GetPosition()
  local ItemSize = UIManager(self):GetWidgetRenderSize(self.WBP_Angling_Fishing_Item)
  self.EffectMaxY = Position.Y + ItemSize.Y / 2
  self.EffectMinY = Position.Y - ItemSize.Y / 2
end

function M:ChangeItemMove(bPress)
  if self.FishingGameState ~= FishingGameState.Fishing then
    return
  end
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item)
  local Position = CanvasSlot:GetPosition()
  if IsValid(self.handle) then
    self.handle:Kill(false)
  end
  local Long = self.MaxItemY - self.MinItemY
  if bPress then
    local MoveCurve = DataMgr.FishingStick[1].MoveCurve[1]
    local FuncName = EaseFuc[MoveCurve] or EaseFuc.InSine
    self.handle = self:GetEaseValue(Position.Y, Position.Y - Long, self.ItemUpTime, FuncName, {
      self,
      self.ChangeItemMoveUp
    })
  else
    local MoveCurve = DataMgr.FishingStick[1].MoveCurve[2]
    local FuncName = EaseFuc[MoveCurve] or EaseFuc.OutBounce
    local Time = math.sqrt((self.MaxItemY - Position.Y) / Long) * self.ItemDownTime
    self.handle = self:GetEaseValue(Position.Y, self.MaxItemY, Time, FuncName, {
      self,
      self.ChangeItemMoveDown
    })
  end
end

function M:CheckFish(InDeltaTime)
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Icon01)
  local Position = CanvasSlot:GetPosition()
  if Position.Y <= self.EffectMaxY and Position.Y >= self.EffectMinY then
    self.EffectGameTime = self.EffectGameTime + InDeltaTime
    if not self.bFishInAnimationPlayed then
      self.bFishInAnimationPlayed = true
      self.bFishOutAnimationPlayed = false
      self.WBP_Angling_Fishing_Item:StopAnimation(self.WBP_Angling_Fishing_Item.Area_Out)
      self.WBP_Angling_Fishing_Item:PlayAnimation(self.WBP_Angling_Fishing_Item.Area_In)
      AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_in_region", "FishItemInRegion", nil)
    end
  else
    self.EffectGameTime = math.max(self.EffectGameTime - InDeltaTime, 0)
    if not self.bFishOutAnimationPlayed then
      self.bFishInAnimationPlayed = false
      self.bFishOutAnimationPlayed = true
      self.WBP_Angling_Fishing_Item:StopAnimation(self.WBP_Angling_Fishing_Item.Area_In)
      self.WBP_Angling_Fishing_Item:PlayAnimation(self.WBP_Angling_Fishing_Item.Area_Out)
      AudioManager(self):StopSound(self, "FishItemInRegion")
      AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_out_region", nil, nil)
    end
  end
  local Percent = self.EffectGameTime / self.SuccessTime
  self.Angling_Bar:SetPercent(Percent)
  if self.EffectGameTime >= self.SuccessTime then
    self:SwitchEndFishing(false, true)
    AudioManager(self):StopSound(self, "FishItemInRegion")
  elseif self.EffectGameTime <= 0 then
    self:SwitchEndFishing(false, false)
    AudioManager(self):StopSound(self, "FishItemInRegion")
  end
end

function M:OnClickTip()
  local Params = {}
  UIManager(self):LoadUINew("GuideBook", 5, 84)
end

function M:OnSpaceDown()
  if not (not self.SpacePress and self.InitSucc) or not self.bCanSpace then
    return
  end
  self.SpacePress = true
  self:ChangeItemMove(true)
end

function M:OnSpaceUp()
  if not (self.SpacePress and self.InitSucc) or not self.bCanSpace then
    return
  end
  self.SpacePress = false
  if self.FishingGameState == FishingGameState.WaitFishing then
  else
    self:ChangeItemMove(false)
  end
end

function M:OnCommonBtnSpaceUp()
  self.WBP_Angling_Fishing_Btn:OnReleaseButton(true)
  self.WBP_Angling_Fishing_Btn:OnClickButton()
  self:OnSpaceUp()
end

function M:OnClickEsc()
  if self.CurrentAutoRound then
    self:OnClickExit()
  elseif self.Angling_Special:GetVisibility() ~= ESlateVisibility.Collapsed then
    self.Angling_Special:OnClickQuit()
  else
    self:OnClickExit()
  end
end

function M:Handle_KeyEventOnPC(InKeyName)
  if "SpaceBar" == InKeyName then
    self.WBP_Angling_Fishing_Btn:OnPressButton()
    self:OnSpaceDown()
  elseif "E" == InKeyName and not self.CurrentAutoRound and self.Angling_Special:GetVisibility() ~= ESlateVisibility.Collapsed then
    self.Angling_Special:OnClickAngling()
  elseif "Escape" == InKeyName then
    self:OnClickEsc()
  end
  return true
end

function M:Handle_KeyUpEventOnPC(InKeyName)
  if "SpaceBar" == InKeyName then
    self.WBP_Angling_Fishing_Btn:OnReleaseButton(true)
    self.WBP_Angling_Fishing_Btn:OnClickButton()
    self:OnSpaceUp()
  end
  return true
end

function M:Handle_KeyEventOnGamePad(InKeyName)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    if self.CurrentAutoRound then
      self.WBP_Angling_Fishing_Btn:OnPressButton()
      self:OnSpaceDown()
    elseif self.Angling_Special:GetVisibility() ~= ESlateVisibility.Collapsed then
      self.Angling_Special:OnClickAngling()
    else
      self.WBP_Angling_Fishing_Btn:OnPressButton()
      self:OnSpaceDown()
    end
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    if self.Angling_Special:GetVisibility() ~= ESlateVisibility.Collapsed then
      if not self.CurrentAutoRound then
        self.Angling_Special:OnClickAngling()
      end
    elseif self.RootPage:CheckSkipFishingPet() and self.RootPage.bFullAutoFishingPreference then
      self.Btn_FFBF.SwitchCheckBox:OnBtnClicked()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.RootPage:CheckSkipFishingPet() then
      self.Btn_Auto.SwitchCheckBox:OnBtnClicked()
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    self:OnClickEsc()
  elseif "Gamepad_Special_Right" == InKeyName then
    self:OnClickTip()
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.ResourceBar:FocusToResource()
  end
  return true
end

function M:Handle_KeyUpEventOnGamePad(InKeyName)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    self.WBP_Angling_Fishing_Btn:OnReleaseButton(true)
    self.WBP_Angling_Fishing_Btn:OnClickButton()
    self:OnSpaceUp()
  end
  return true
end

function M:Handle_PreviewKeyEventOnGamePad(InKeyName)
  return true
end

function M:GetEaseValue(Start, End, Time, Type, func)
  return UE4.ULTweenBPLibrary.FloatTo(self, func, Start, End, Time, 0, Type)
end

function M:ChangeItemMoveUp(value)
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item)
  local Position = CanvasSlot:GetPosition()
  Position.Y = math.max(value, self.MinItemY)
  CanvasSlot:SetPosition(Position)
end

function M:ChangeItemMoveDown(value)
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WBP_Angling_Fishing_Item)
  local Position = CanvasSlot:GetPosition()
  Position.Y = math.min(value, self.MaxItemY)
  CanvasSlot:SetPosition(Position)
end

function M:OnFishHook(FishId, bIsSpecial)
  if self.FishingGameState ~= FishingGameState.WaitFishing then
    return
  end
  local AutoRound = self.CurrentAutoRound
  local FishData = DataMgr.Fish[FishId]
  if FishData then
    self.SuccessTime = FishData.FishGetDuration or 10
    self.EffectGameTime = FishData.FishHookOffset or 1.5
  end
  self.bIsSpecial = bIsSpecial
  self.LastFishId = FishId
  self.WBP_Angling_Fishing_Btn:SwitchWaitStartFishing()
  self.RootPage.FishingSpot:OnFishHook(FishId, bIsSpecial)
  self.RootPage.Angling_Main:RefreshFishLure(self.RootPage.FishingLureId)
  AudioManager(self):PlayUISound(self, "event:/sfx/common/scene/fish/bite", "OnFishHook", nil)
  if AutoRound then
    local bCanAutoCatch = self:CheckAutoFishingRodLevel(AutoRound.FishingRodId, FishId) and self.RootPage:CheckSkipFishingPet()
    if bCanAutoCatch then
      self:SwitchEndFishing(false, true, AutoRound)
    else
      self:StopFullAutoFishingSession(false)
      self:SwitchFishing()
    end
  elseif not self:CheckSkipAngling() then
    self:AddTimer(self.FishingHookResponseTime, self.OnFishHookTimeOut, false, 0, "OnFishHookTimeOut")
  end
end

function M:OnFishHookTimeOut()
  if self.FishingGameState ~= FishingGameState.WaitFishing then
    return
  end
  UIManager(self):LoadUINew("ExploreToastFail", "UI_Fishing_FishEscape")
  AudioManager(self):StopSound(self, "OnFishHook")
  self:SwitchEndFishing(true, false)
end

function M:CheckAutoFishingRodLevel(FishingRodId, FishId)
  if not FishingRodId or not FishId then
    return false
  end
  local FishingRodData = DataMgr.FishingRod[FishingRodId]
  local FishData = DataMgr.Fish[FishId]
  if not FishingRodData or not FishData then
    return false
  end
  local AutoFishLevel = FishingRodData.AutoFishingLevel or 1
  local FishLevel = FishData.FishLevel or 1
  return AutoFishLevel >= FishLevel
end

function M:CheckSkipAngling()
  if not self.LastFishId or -1 == self.LastFishId then
    print(_G.LogTag, "Error: LXZ 没有上钩的鱼的id，可能是没有鱼竿资源或鱼饵资源")
    return
  end
  if not self:CheckAutoFishingRodLevel(self.RootPage.FishingRodId, self.LastFishId) then
    return false
  end
  if _G.bSkipAngling then
    return true
  end
  return self.RootPage:CheckSkipFishingPet()
end

function M:AvatarStartFish(bIsSpecial, AutoRound, SmallToBigLureFishId)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local FishingSpotId = self.RootPage.FishingSpotId
    local FishingRodId = AutoRound and AutoRound.FishingRodId or self.RootPage.FishingRodId
    local FishingLureId = self.RootPage.FishingLureId
    local OnStartResult
    if AutoRound then
      function OnStartResult(Ret)
        if not IsValid(self) then
          return
        end
        if not IsValid(self.RootPage) then
          self:CleanupFullAutoFishingSession()
          return
        end
        if not (Ret ~= ErrorCode.RET_SUCCESS and self:IsCurrentAutoRound(AutoRound)) or self.FishingGameState ~= FishingGameState.WaitFishing then
          return
        end
        UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
        if bIsSpecial then
          self:AvatarStopFish()
        end
        self:StopFullAutoFishingSession(true)
      end
    end
    if bIsSpecial then
      Avatar:OnFishStart(FishingSpotId, FishingRodId, -1, SmallToBigLureFishId or self.LastFishId, OnStartResult)
      self.LastFishId = -1
    else
      Avatar:OnFishStart(FishingSpotId, FishingRodId, FishingLureId, -1, OnStartResult)
    end
  elseif AutoRound then
    self:StopFullAutoFishingSession(true)
  else
    self:AddTimer(3, self.OnFishHook)
  end
end

function M:AvatarStopFish()
  self.bIsSpecial = false
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:OnFishStop(self.FishingSpotId)
  end
end

function M:AvatarCompleteFish(IsSuccess, LastFishId, AutoRound)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function ShowFishMap(Ret, FishId, FishSize, AvatarIsSuccess, RewardReturn)
      if not IsValid(self) then
        return
      end
      if not IsValid(self.RootPage) then
        self:CleanupFullAutoFishingSession()
        return
      end
      if AutoRound and not self:IsCurrentAutoRound(AutoRound) then
        return
      end
      print(_G.LogTag, "LXZ Avatar:GetFishCountByFishId0000000", RewardReturn)
      PrintTable(RewardReturn, 10)
      if Ret ~= ErrorCode.RET_SUCCESS then
        UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
        self.RootPage.FishingSpot:OnFishFail()
        if AutoRound and self:IsCurrentAutoRound(AutoRound) then
          self:StopFullAutoFishingSession(true)
        end
        return
      end
      if AvatarIsSuccess then
        local RewardFishId = LastFishId or FishId
        local FishCountId = FishId or RewardFishId
        if AutoRound then
          AutoRound.FishId = RewardFishId
          AutoRound.Stage = AutoFishingStage.Reward
          self:SwitchWaitStart(false, AutoRound)
        end
        print(_G.LogTag, "LXZ Avatar:GetFishCountByFishId", Avatar:GetFishCountByFishId(FishCountId))
        self.RootPage.FishingSpot:OnFishSuccess()
        local bIsNew = 1 == Avatar:GetFishCountByFishId(FishCountId)
        local RewardInfo = {
          FishId = RewardFishId,
          FishingPage = self,
          IsNew = bIsNew,
          FishSize = FishSize,
          FishingSpotId = self.RootPage.FishingSpotId,
          Rewards = RewardReturn,
          AutoClose = nil ~= AutoRound,
          AutoSessionId = AutoRound and AutoRound.SessionId or nil
        }
        UIManager(self):LoadUINew("AnglingNewFish", RewardInfo)
        if bIsNew then
          local UnLockData = EMCache:Get("FishUnLockData", true)
          UnLockData = UnLockData or {}
          UnLockData[RewardFishId] = 2
          EMCache:Set("FishUnLockData", UnLockData, true)
          ReddotManager.IncreaseLeafNodeCount("AnglingMap", 1)
        end
      else
        UIManager(self):LoadUINew("ExploreToastFail", "UI_Fishing_Fail")
        self.RootPage.FishingSpot:OnFishFail()
        if AutoRound and self:IsCurrentAutoRound(AutoRound) then
          self:StopFullAutoFishingSession(true)
        end
      end
    end
    
    Avatar:OnCompleteFishGame(IsSuccess, ShowFishMap)
  elseif AutoRound and self:IsCurrentAutoRound(AutoRound) then
    self:StopFullAutoFishingSession(true)
  end
end

function M:ClearPendingSmallToBigOpportunity(AutoRound)
  if not AutoRound or not AutoRound.CanSmallToBig then
    return
  end
  self:AvatarStopFish()
  AutoRound.CanSmallToBig = false
end

function M:RequestEndFullAutoFishing()
  if not self.CurrentAutoRound then
    return
  end
  local AutoRound = self.CurrentAutoRound
  if self.FishingGameState == FishingGameState.WaitFishing then
    self:StopFullAutoFishingSession(false)
    self:SwitchEndFishing(true, false)
    return
  end
  if self.FishingGameState == FishingGameState.EndFishing or AutoRound.Stage == AutoFishingStage.Reward then
    AutoRound.StopAfterCurrent = true
    return
  end
  if AutoRound.Stage == AutoFishingStage.SmallToBigChoice then
    self.Angling_Special:SwitchWaitStart()
    return
  end
  if AutoRound.Stage == AutoFishingStage.RecastDelay then
    self:ClearPendingSmallToBigOpportunity(AutoRound)
  end
  self:StopFullAutoFishingSession(true)
end

function M:OnAutoFishRewardClosed(AutoSessionId)
  if not IsValid(self.RootPage) then
    self:CleanupFullAutoFishingSession()
    return
  end
  local AutoRound = self.CurrentAutoRound
  if not self:IsCurrentAutoRound(AutoRound) or AutoRound.SessionId ~= AutoSessionId or AutoRound.Stage ~= AutoFishingStage.Reward then
    return
  end
  if not (not AutoRound.StopAfterCurrent and self.RootPage.bFullAutoFishingPreference) or not self.RootPage:CheckSkipFishingPet() then
    self:ClearPendingSmallToBigOpportunity(AutoRound)
    self:StopFullAutoFishingSession(true)
    return
  end
  local bSmallToBigCast = AutoRound.CanSmallToBig and AutoRound.AutoSmallToBigEnabled
  if AutoRound.CanSmallToBig and not bSmallToBigCast then
    self:ClearPendingSmallToBigOpportunity(AutoRound)
  end
  if bSmallToBigCast then
    AutoRound.Stage = AutoFishingStage.SmallToBigChoice
    self.LastFishId = AutoRound.FishId
    self.WBP_Angling_Fishing_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Angling_Special:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Angling_Special:OnCanSpecialFishing(AUTO_SMALL_TO_BIG_CONFIRM_DELAY)
    return
  end
  AutoRound.Stage = AutoFishingStage.RecastDelay
  self:AddTimer(3, self.OnAutoFishingRecast, false, 0, AUTO_FISHING_RECAST_TIMER_KEY, false, AutoRound)
end

function M:OnAutoFishingRecast(AutoRound, SmallToBigLureFishId)
  if not IsValid(self.RootPage) then
    self:CleanupFullAutoFishingSession()
    return
  end
  if not self:IsCurrentAutoRound(AutoRound) or AutoRound.Stage ~= AutoFishingStage.RecastDelay then
    return
  end
  if not self.RootPage.bFullAutoFishingPreference or not self.RootPage:CheckSkipFishingPet() then
    self:ClearPendingSmallToBigOpportunity(AutoRound)
    self:StopFullAutoFishingSession(true)
    return
  end
  if not SmallToBigLureFishId then
    local FishingLureData = DataMgr.FishingLure[self.RootPage.FishingLureId]
    local Avatar = GWorld:GetAvatar()
    local FishingSpot = Avatar and Avatar.FishingSpots[self.FishingSpotId]
    if not (FishingLureData and FishingLureData.ResourceId) or 0 == self.RootPage.Angling_Main:GetResourceCount(FishingLureData.ResourceId) or FishingSpot and not FishingSpot:CheckCanFish() then
      self:StopFullAutoFishingSession(true)
      return
    end
  end
  self.CurrentAutoRound = nil
  local bStarted = self:StartFishingRound(true, SmallToBigLureFishId)
  if not bStarted then
    if SmallToBigLureFishId then
      self:ClearPendingSmallToBigOpportunity(AutoRound)
    end
    self:StopFullAutoFishingSession(true)
  end
end

function M:StopFullAutoFishingSession(bReturnToWaitStart)
  self:RemoveTimer(AUTO_FISHING_RECAST_TIMER_KEY)
  self.CurrentAutoRound = nil
  if bReturnToWaitStart then
    self.bIsSpecial = false
    self.LastFishId = -1
    self:SwitchWaitStart(true)
  else
    self.WBP_Angling_Fishing_Btn:SetFullAutoFishingState(false)
  end
end

function M:CleanupFullAutoFishingSession()
  local AutoRound = self.CurrentAutoRound
  if AutoRound and self.FishingGameState == FishingGameState.WaitFishing then
    self:AvatarStopFish()
  elseif AutoRound and self.FishingGameState == FishingGameState.EndFishing and not AutoRound.CompletionSent then
    AutoRound.CompletionSent = true
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:OnCompleteFishGame(true)
    end
  elseif AutoRound and (AutoRound.Stage == AutoFishingStage.Reward or AutoRound.Stage == AutoFishingStage.RecastDelay or AutoRound.Stage == AutoFishingStage.SmallToBigChoice) then
    if AutoRound.Stage == AutoFishingStage.SmallToBigChoice then
      self.Angling_Special:RemoveTimer("SpecialFishing")
    end
    self:ClearPendingSmallToBigOpportunity(AutoRound)
  end
  self:StopFullAutoFishingSession(false)
end

function M:ShowRewardUI(FishId)
  local ResourceId = DataMgr.Fish[FishId].ResourceId
  UIUtils.ShowHudReward(GText("UI_Fishing_Reward"), {
    {
      ItemType = "Resource",
      ItemId = ResourceId,
      Count = 1,
      Rarity = ItemUtils.GetItemRarity(ResourceId, "Resource")
    }
  })
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
  local ControllerVisibility = self.DeviceInPc and CurInputDevice == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Btn_Auto.Controller_CheckBox:SetVisibility(ControllerVisibility)
  self.Btn_FFBF.Controller_CheckBox:SetVisibility(ControllerVisibility)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.DeviceInPc then
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    self.WidgetSwitcher_Tip:SetActiveWidgetIndex(0)
    self.WBP_Angling_Fishing_Btn.WidgetSwitcher_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WBP_Angling_Fishing_Btn.WidgetSwitcher_Key:SetActiveWidgetIndex(0)
    self.ResourceBar:SwitchTipStyle(0)
  elseif CurInputDevice == ECommonInputType.Gamepad and self.DeviceInPc then
    self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
    self.WidgetSwitcher_Tip:SetActiveWidgetIndex(1)
    self.WBP_Angling_Fishing_Btn.WidgetSwitcher_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WBP_Angling_Fishing_Btn.WidgetSwitcher_Key:SetActiveWidgetIndex(1)
    self.ResourceBar:SwitchTipStyle(1)
  elseif CurInputDevice == ECommonInputType.Touch then
  end
  self.Angling_Special:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnFishHook, self)
  self.Btn_Auto.SwitchCheckBox:RemoveEventOnCheckStateChanged(self)
  self.Btn_FFBF.SwitchCheckBox:RemoveEventOnCheckStateChanged(self)
  self:CleanupFullAutoFishingSession()
  self.Super.Destruct(self)
end

return M
