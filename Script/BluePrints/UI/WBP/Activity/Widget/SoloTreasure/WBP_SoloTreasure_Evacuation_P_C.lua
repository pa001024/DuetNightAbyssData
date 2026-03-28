require("UnLua")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local TimeUtils = require("Utils.TimeUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function M:Initialize(Initializer)
end

function M:Construct()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  self:SetAllUIVisibility(true)
  self:InitExitCountDown()
end

function M:OnLoaded(...)
  DebugPrint("yly test OnLoaded")
  self:InitDeviceInfo()
  self:InitListenEvent()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    GWorld.logger.error("Can't Get GameMode!")
    return true
  end
  self.SolotreasurePreInitInfo = GameMode.PreInitInfo
  if self.SolotreasurePreInitInfo == nil then
    GWorld.logger.error("Can't Get PreInitInfo! ")
    return true
  end
  self.EventId = self.SolotreasurePreInitInfo.EventDungeonId
  self.BagId = self.SolotreasurePreInitInfo.BagId
  self.IsStory = self.SolotreasurePreInitInfo.IsStory
  self.IsEasy = self.SolotreasurePreInitInfo.IsEasy
  self.ScoreToResourceRatio = nil
  self.ResourceUpperLimit = nil
  if not self.IsStory then
    if self.IsEasy then
      self.ScoreToResourceRatio = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyScoreToResource
      self.ResourceUpperLimit = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyMaxConvertResource
    else
      self.ScoreToResourceRatio = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardScoreToResource
      self.ResourceUpperLimit = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardMaxConvertResource
    end
  end
  local LogicServerInfo = (...)
  self.IsWin, self.DungeonId, self.Rewards, self.DungeonRewards, self.PlayerTime, self.GameTime, self.ClientRes = table.unpack(LogicServerInfo)
  self.KillMonsterScore = self.ClientRes.KillMonsterScore or 0
  self.TreasureScore = self.ClientRes.TreasureScore or 0
  if not self.IsWin then
    self.KillMonsterScore = 0
    self.TreasureScore = 0
  end
  self.TicketId = self.ClientRes.Ticket or -1
  if nil == GWorld.GameInstance.CombatData then
    GWorld.logger.error("Can't Get CombatData!")
    return
  end
  self.EvacuationTime = GWorld.GameInstance.CombatData.EvacuationTime
  self:InitBag()
  self.BagId = InventoryController.InventoryModel.BagId
  self.BagCostsResourceId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  self.BagCosts = DataMgr.ExtractionTreasureBag[self.BagId].Price
  if self.IsStory then
    self.playAgainCosts = DataMgr.TreasureHuntStoryDungeon[self.EventId].Fee
    self.playAgainCostsIconId = DataMgr.TreasureHuntStoryDungeon[self.EventId].FeeResource
  else
    self.playAgainCostsIconId = DataMgr.TreasureHuntRepeatDungeon[self.EventId].FeeResource
    if self.IsEasy then
      self.playAgainCosts = DataMgr.TreasureHuntRepeatDungeon[self.EventId].EasyModeFee
    else
      self.playAgainCosts = DataMgr.TreasureHuntRepeatDungeon[self.EventId].HardModeFee
    end
  end
  self:InitUIContent()
  self.AddExtraResourceId = 1
  self.AddExtraResourceNum = 0
  self.AddExtraResourceTbl = self.ClientRes.AddExtraResource or {}
  for key, value in pairs(self.AddExtraResourceTbl) do
    self.AddExtraResourceId = key
    self.AddExtraResourceNum = value
  end
  self.Panel_TransCoin:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.IsWin then
    self:UnbindAllFromAnimationFinished(self.Victory_In)
    self:BindToAnimationFinished(self.Victory_In, {
      self,
      function()
        DebugPrint("yly Victory")
        self:InitSettlementBuff()
        self:PlayExtraRewardsAnim()
      end
    })
    self:PlayAnimation(self.Victory_In)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/sdc_result_final_success_in", nil, nil)
  else
    DebugPrint("yly Defeated")
    self:PlayAnimation(self.Defeat_In)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/sdc_result_final_fail_in", nil, nil)
  end
end

function M:PlayExtraRewardsAnim()
  if not self.IsStory and self.AddExtraResourceNum > 0 and self.ResourceUpperLimit ~= nil then
    self.Text_Num_Coin:SetText(Utils.FormatNumber(0, false))
    self:SetImage(self.AddExtraResourceId, self.Image_6)
    self.Panel_TransCoin:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self:BindToAnimationFinished(self.TransCoin_In, {
      self,
      function()
        DebugPrint("yly TransCoin_In Animation Ended.")
        UIUtils.RollingNumberEffect(self, self.Text_Num_Coin, 0, self.AddExtraResourceNum, nil, nil, self, self.RollingNumCallback)
        AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_result_bonus_add_loop", "BonusAddLoop", nil)
      end
    })
    self:BindToAnimationFinished(self.TransCoin_Out, {
      self,
      function()
        DebugPrint("yly TransCoin_Out Animation Ended.")
        if self.AddExtraResourceNum >= self.ResourceUpperLimit then
          self.Max:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        else
          self.Max:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
      end
    })
    self:PlayAnimation(self.TransCoin_In)
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/sdc_result_bonus_add_show", nil, nil)
  end
end

function M:RollingNumCallback()
  self:PlayAnimation(self.TransCoin_Out)
  AudioManager(self):StopSound(self, "BonusAddLoop")
end

function M:Destruct()
  DebugPrint("yly test Destruct")
  if self:IsExistTimer("CountDown") then
    self:RemoveTimer("CountDown")
  end
  AudioManager(self):StopSound(self, "BonusAddLoop")
end

function M:CheckNeedShowWindow()
  local IsNoMorePrompts = EMCache:Get("IsConfirmPopupNoMorePrompts", true) or false
  if TimeUtils and IsNoMorePrompts then
    local CachedTimestamp = EMCache:Get("IsConfirmPopupTimestamp", true)
    local intervalTime = TimeUtils.GetIntervalDay(CachedTimestamp, TimeUtils.NowTime())
    IsNoMorePrompts = 0 == intervalTime
  end
  return not IsNoMorePrompts
end

function M:OnPlayAgain()
  DebugPrint("Btn_Continue is Clicked")
  local Avatar = GWorld:GetAvatar()
  local CanEnter = false
  if self.ScoreToResourceRatio ~= nil then
    local BagCostsRemain = 0
    if Avatar and self.BagCostsResourceId then
      BagCostsRemain = Avatar:GetResourceNum(self.BagCostsResourceId)
    end
    if self.ownPoints and self.ownPoints >= self.playAgainCosts then
      if BagCostsRemain >= self.BagCosts then
        CanEnter = true
      else
        CanEnter = false
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Extraction_TM_31"))
      end
    else
      CanEnter = false
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreausre_Toast_LackofTicket"))
    end
  else
    self.FinalPlayAgainCosts = self.playAgainCosts + self.BagCosts
    if self.ownPoints and self.ownPoints >= self.FinalPlayAgainCosts then
      CanEnter = true
    else
      CanEnter = false
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Extraction_TM_31"))
    end
  end
  if CanEnter then
    if self:CheckNeedShowWindow() then
      self:ShowPlayAgainConfirmPopup()
    else
      self:PlayAgainSoloTreasure()
    end
  end
end

function M:ExitSoloTreasure()
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ExitDungeonSettlement()
  EventManager:AddEvent(EventID.OnExitDungeon, self, self.DefaultExit)
  if self.IsStory == false then
    self.ExitDungeonData = {
      Type = "SoloTreasure",
      EventId = nil,
      Mode = 1,
      bIsDifficulty = not self.IsEasy,
      EventDungeonId = self.EventId
    }
    GWorld.GameInstance:SetExitDungeonData(self.ExitDungeonData)
  end
end

function M:DefaultExit()
  EventManager:RemoveEvent(EventID.OnExitDungeon, self)
  self:BlockAllUIInput(false)
  self:CloseSelf()
end

function M:CloseSelf()
  DebugPrint("yly     CloseSelf")
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
  self:SetAllUIVisibility(false)
end

function M:OnOutAnimationFinished()
  self:Close()
end

function M:InitBag()
  local ControllerInitParams = {MainWidget = self}
  InventoryController:Init(ControllerInitParams)
  InventoryController:OnMainWidgetLoaded(ControllerInitParams)
end

function M:InitUIContent()
  self.Text_AllValue:SetText(GText("UI_Extraction_TotalScore"))
  self:SetImage(DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue, self.Image_86)
  self.Text_AllValue_1:SetText(GText("UI_Extraction_TM_30"))
  self.Text_AllCoin:SetText(GText("UI_SoloTreasure_ExtraReward"))
  self.Max.Text_Max:SetText(GText("UI_SoloTreasure_MaxExtraReward"))
  self.Text_Score01:SetText(GText("UI_Extraction_BattleScore"))
  self.Text_Score01_1:SetText(GText("UI_Extraction_TreasureScore"))
  self.Text_Num:SetText(Utils.FormatNumber(self.KillMonsterScore + self.TreasureScore, false))
  self.Text_Score01_Num:SetText(Utils.FormatNumber(self.KillMonsterScore, false))
  self.Text_Score01_Num_1:SetText(Utils.FormatNumber(self.TreasureScore, false))
  self.Btn_Continue:SetText(string.format(GText("Abyss_Battle_Again")))
  self.Btn_Continue:SetDefaultGamePadImg("X")
  self.Btn_Continue.Button_Area.OnClicked:Add(self, self.OnPlayAgain)
  self.Btn_Exit:SetText(string.format(GText("UI_Extraction_TM_47")))
  self.Btn_Exit:SetDefaultGamePadImg("B")
  self.Btn_Exit.Button_Area.OnClicked:Add(self, self.ExitSoloTreasure)
  self.Text_Title_Success:SetText(GText("UI_Extraction_TM_25"))
  self.Text_Title_Fail:SetText(GText("UI_Extraction_TM_26"))
  if self.IsWin then
    self.Text_Title_Success:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Title_Fail:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Text_Title_Success:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Title_Fail:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:InitDungeonInfo()
  self:InitPlayAgainCost()
  self:InitBagContent()
  self:InitEvacuationTime()
  self:HideSettlementBuff()
end

function M:InitDungeonInfo()
  if self.DungeonId == nil then
    return
  end
  local dungeonInfo = DataMgr.Dungeon[self.DungeonId]
  local difficultyInfo = DataMgr.SoloTreasure[self.DungeonId].DifficultyDesc
  self.Text_Title02:SetText(GText(dungeonInfo.DungeonTypeShow) .. "-" .. GText(difficultyInfo))
end

function M:InitEvacuationTime()
  local seconds = math.max(0, math.floor(self.EvacuationTime))
  local min = math.floor(seconds / 60)
  local sec = seconds % 60
  self.Text_Time:SetText(string.format("%02d:%02d", min, sec))
end

function M:InitPlayAgainCost()
  local Avatar = GWorld:GetAvatar()
  self.ownPoints = 0
  if Avatar and self.playAgainCostsIconId then
    self.ownPoints = Avatar:GetResourceNum(self.playAgainCostsIconId)
  end
  self.Panel_Cost:SetVisibility(UIConst.VisibilityOp.Visible)
  local bBtnForbid = false
  if self.ScoreToResourceRatio == nil then
    self.FinalPlayAgainCosts = self.playAgainCosts + self.BagCosts
    if self.ownPoints >= self.FinalPlayAgainCosts then
      bBtnForbid = false
    else
      bBtnForbid = true
    end
  else
    self.FinalPlayAgainCosts = self.playAgainCosts
    local BagCostsRemain = 0
    if Avatar and self.BagCostsResourceId then
      BagCostsRemain = Avatar:GetResourceNum(self.BagCostsResourceId)
    end
    if self.ownPoints >= self.FinalPlayAgainCosts and BagCostsRemain >= self.BagCosts then
      bBtnForbid = false
    else
      bBtnForbid = true
    end
  end
  local Params = {
    ResourceId = self.playAgainCostsIconId,
    bShowDenominator = true,
    Numerator = self.ownPoints,
    Denominator = self.FinalPlayAgainCosts,
    Owner = self,
    ItemMenuAnchorChangedCallback = self.OnCostTipsStateChanged
  }
  self.Cost:InitContent(Params)
  self.Cost.Common_Item_Icon.HandleKeyDown = true
  if bBtnForbid then
    self.Btn_Continue:SetRenderOpacity(0.5)
  else
    self.Btn_Continue:SetRenderOpacity(1.0)
  end
end

function M:InitBagContent()
  if self.IsWin then
    self.HorizontalBox_1:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Switch_BagType:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.WBP_Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.HorizontalBox_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Switch_BagType:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Com_EmptyBg.Text_Empty:SetText(GText("UI_Extraction_TM_48"))
    self.WBP_Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:HideSettlementBuff()
  self.WrapBox_0:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitSettlementBuff()
  if self.IsWin and -1 ~= self.TicketId then
    local ticketInfo = DataMgr.ExtractionLottery[self.TicketId]
    local highQualityBuffItem = self.WrapBox_0:GetChildAt(2)
    local midQualityBuffItem = self.WrapBox_0:GetChildAt(1)
    local lowQualityBuffItem = self.WrapBox_0:GetChildAt(0)
    if 1 == ticketInfo.Quality then
      highQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      midQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Visible)
      lowQualityBuffItem:InitData({
        Description = ticketInfo.Desc
      })
    elseif 2 == ticketInfo.Quality then
      highQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      midQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Visible)
      midQualityBuffItem:InitData({
        Description = ticketInfo.Desc
      })
      lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif 3 == ticketInfo.Quality then
      highQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Visible)
      highQualityBuffItem:InitData({
        Description = ticketInfo.Desc
      })
      midQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
      lowQualityBuffItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      DebugPrint("yly     Ticket's Quality not Exists!")
    end
    self.WrapBox_0:SetVisibility(UIConst.VisibilityOp.Visible)
    if 1 == ticketInfo.Quality then
      lowQualityBuffItem:PlayAnimation(lowQualityBuffItem.In)
    elseif 2 == ticketInfo.Quality then
      midQualityBuffItem:PlayAnimation(midQualityBuffItem.In)
    elseif 3 == ticketInfo.Quality then
      highQualityBuffItem:PlayAnimation(highQualityBuffItem.In)
    end
  else
    self.WrapBox_0:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitExitCountDown()
  self.exitTimeleft = DataMgr.GlobalConstant.SoloTreasureEvacuationExitTime.ConstantValue
  self.Text_ExitTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
  self.timer = self:AddTimer(1, self.UpdateCountDownUI, true, 0, "CountDown", false)
end

function M:UpdateCountDownUI()
  if self.exitTimeleft > 0 then
    self.exitTimeleft = self.exitTimeleft - 1
  else
    self.exitTimeleft = 0
    if self:IsExistTimer("CountDown") then
      self:RemoveTimer("CountDown")
    end
    self:ExitSoloTreasure()
  end
  self.Text_ExitTime:SetText(string.format(GText("UI_Text_ExitTime"), self.exitTimeleft))
end

function M:ShowPlayAgainConfirmPopup()
  local CommonDialogParams = {}
  
  function CommonDialogParams.RightCallbackFunction(_, Data, PopupUI)
    DebugPrint("yly     PlayAgain")
    PopupUI.DontPlayOutAnimation = true
    self:PlayAgainSoloTreasure()
    self:UpdateSelectedInfo(Data)
  end
  
  function CommonDialogParams.LeftCallbackFunction(_, Data, PopupUI)
    PopupUI.DontPlayOutAnimation = false
    self:UpdateSelectedInfo(Data)
  end
  
  UIManager(self):ShowCommonPopupUI(100317, CommonDialogParams, self.Parent)
end

function M:PlayAgainSoloTreasure()
  DebugPrint("yly      PlayAgainSoloTreasure")
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CustomParams = {
    EventDungeonId = self.EventId,
    BagId = self.BagId,
    IsStory = self.IsStory,
    IsEasy = self.IsEasy
  }
  Avatar:EnterDungeonAgain(nil, nil, CustomParams)
end

function M:UpdateSelectedInfo(Data)
  local IsSelected = Data.SelectHint.IsSelected
  local CurTimestamp = TimeUtils.NowTime()
  EMCache:Set("IsConfirmPopupNoMorePrompts", IsSelected, true)
  EMCache:Set("IsConfirmPopupTimestamp", CurTimestamp, true)
end

local function _RealSetIcon(self, Texture, Img)
  if Texture then
    Img:SetBrushResourceObject(Texture)
  end
end

function M:SetImage(resourceId, Img)
  local resource = DataMgr.Resource[resourceId]
  local IconObj = LoadObject(resource.Icon)
  if type(IconObj) == "string" then
    self:LoadTextureAsync(IconObj, function(Texture)
      if not Texture then
        Texture = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
        DebugPrint(ErrorTag, string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s", IconObj))
      end
      _RealSetIcon(self, Texture, Img)
    end, "LoadIcon")
  else
    _RealSetIcon(self, IconObj, Img)
  end
end

function M:LoadTextureAsync(TexturePath, cb, TaskName)
  rawset(self, "LoadResourceID", nil)
  local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, TexturePath, {
    self,
    function(self, Texture, ResourceID)
      if not IsValid(self) or nil ~= ResourceID and rawget(self, "LoadResourceID") ~= ResourceID then
        return
      end
      cb(Texture)
    end
  })
  if Handle then
    rawset(self, "LoadResourceID", Handle.ResourceID)
  end
end

function M:SetAllUIVisibility(IsHide)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManger = GameInstance:GetGameUIManager()
  if UIManger then
    UIManger:HideAllUI_EX({
      self:GetName(),
      "DungeonMatchTimingBar"
    }, IsHide, self.HideUITag, false)
  end
  local BattleWarningUI = UIManger:GetUIObj(UIConst.DestroyAlarmName)
  if BattleWarningUI then
    AudioManager(self):StopSound(BattleWarningUI, "BattleWarning")
  end
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("yly     CurGamepadName", CurGamepadName)
  DebugPrint("yly     CurInputDevice", CurInputDevice)
  if self.CurInputDeviceType == CurInputDevice then
    DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateBtnUI()
end

function M:UpdateBtnUI()
  self:UpdateScrollViewTip()
  self:UpdateCostView()
  if not self.IsNotFirstUpdateMainUI then
    self.IsNotFirstUpdateMainUI = true
    return
  end
  if not self.CurInputDeviceType then
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  end
  if self.CurInputDeviceType == ECommonInputType.Touch then
    DebugPrint("yly    IsMoblie")
    return
  end
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    DebugPrint("yly@ 已聚焦至上级界面 不聚焦到结算界面")
    local CommonDialog = UIManager(self):GetUI("CommonDialog")
    if CommonDialog then
      DebugPrint("yly@ 已聚焦至弹窗 不聚焦到结算界面")
      return
    end
  end
  self:SetFocus()
end

function M:UpdateCostView()
  if self.Cost == nil then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
    self.Cost:SwitchToPC()
  else
    self.Cost:SwitchToGamePad()
  end
end

function M:UpdateScrollViewTip()
  if self.Key_Check == nil then
    return
  end
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard or self.CurInputDeviceType == ECommonInputType.Touch then
    self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Key_Check:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
        }
      },
      Desc = GText("UI_Controller_Slide")
    })
    local bCanScroll = UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_62)
    if bCanScroll then
      self.Key_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:Handle_OnGamePadDown(InKeyName)
  if "Gamepad_FaceButton_Left" == InKeyName then
    if self.Btn_Continue:IsVisible() then
      self.Btn_Continue:OnBtnClicked()
      self:OnPlayAgain()
    end
    return true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.Btn_Exit:IsVisible() then
      self.Btn_Exit:OnBtnClicked()
      self:ExitSoloTreasure()
    end
    return true
  elseif "Gamepad_LeftThumbstick" == InKeyName and self.Cost:IsVisible() then
    self.Cost:SetFocus()
    self.Cost:OpenTip()
  end
  return false
end

function M:Handle_OnPCDown(InKeyName)
  if "Escape" == InKeyName then
    return true
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    DebugPrint("yly    Key_IsGamepadKey", InKeyName)
    IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
  else
    DebugPrint("yly    Key_IsPC", InKeyName)
    IsEventHandled = self:Handle_OnPCDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.EMScrollBox_62 then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
  if "Gamepad_RightY" == InKeyName then
    local CurScrollOffset = self.EMScrollBox_62:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.EMScrollBox_62:GetScrollOffsetOfEnd())
    self.EMScrollBox_62:SetScrollOffset(ScrollOffset)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:TempUpdateGamePadUI(bTipsOpen)
  if bTipsOpen then
    self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Exit:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Exit:SetIconPanelVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Cost:SwitchToPC()
    self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Continue:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Continue:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Exit:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Btn_Exit:SetIconPanelVisibility(UIConst.VisibilityOp.Collapsed)
    self.Cost:SwitchToGamePad()
    local bCanScroll = UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_62)
    if bCanScroll then
      self.Key_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Key_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnCostTipsStateChanged(IsOpen)
  DebugPrint("yly WBP_Solotreasure_evacuation OnCostTipsStateChanged IsOpen = ", IsOpen)
  if IsOpen then
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
      self:TempUpdateGamePadUI(true)
    end
  else
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
      self:TempUpdateGamePadUI(false)
    end
    self:AddTimer(0.1, function()
      self:SetFocus()
    end)
  end
end

return M
