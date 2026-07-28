require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatModel = ChatController:GetModel()
local InGameModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingInGameModel")
local SpeedModeList = {
  1,
  2,
  4
}
local AudienceNumMin = {
  [1] = 10,
  [2] = 50,
  [3] = 80
}
local AudienceNumMax = {
  [1] = 20,
  [2] = 75,
  [3] = 100
}
local ScrollingLaneGap = 20
local ScrollingDefaultWidgetHeight = 50
local ScrollingTopPadding = 20
local ScrollingBottomPadding = 20
local ScrollingHorizontalGap = 20

local function SetTextSafely(Widget, Text)
  if not (Widget and Widget.SetText) or nil == Text then
    return
  end
  Widget:SetText(Text)
end

local function SetVisibilitySafely(Widget, Visibility)
  if Widget and Widget.SetVisibility then
    Widget:SetVisibility(Visibility)
  end
end

function M:Construct()
  self.bIsFocusable = true
  self.FirstPlaceProgress = 0
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self:GetAudienceNumConfig()
  self.SpeedModeIndex = 1
  self.SpeedModeValue = SpeedModeList[self.SpeedModeIndex]
  self.SelectedPetPlayerId = nil
  self.InGame_Progress.Text_StartTitle:SetText(GText("UI_RaceLottery_StartPoint"))
  self.InGame_Progress.Text_EndTitle:SetText(GText("UI_RaceLottery_FinishPoint"))
  SetTextSafely(self.Text_WatchNum_Title, GText("UI_RaceLottery_WatchingNum"))
  self.Btn_Info.Btn_Check:SetChecked(true)
  self.Btn_Scrolling.Btn_Check:SetChecked(true)
  self.Btn_Info.Btn_Check.OnCheckStateChanged:Add(self, self.OnChatBtnCheckStateChange)
  self.Btn_Scrolling.Btn_Check.OnCheckStateChanged:Add(self, self.OnScrollingBtnCheckStateChange)
  ChatController:RegisterEvent(self, self.OnChatControllerEvent)
  InGameModel:SetChoosePlayerList()
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local Params = (...)
  if type(Params) ~= "table" then
    Params = {}
  end
  self.RaceId = Params.RaceId
  self:InitRaceData(Params)
  self.ScrollingAnchor:ClearChildren()
  if Params.SelectedPetPlayerId ~= nil then
    self:MarkSelectedPet(Params.SelectedPetPlayerId)
  end
  if not ChatController or not ChatController.SendQueryRegionOnlineChannelState then
    return
  end
  ChatController:SendQueryRegionOnlineChannelState(self.RegionId)
  self:AddTimer(self.RefreshTime, self.OnAudienceNumUpdate, true, 0, "AudienceNumUpdate", true)
  self:BindSpeedButtonEvent()
  self:BindResetButtonEvent()
  self:RefreshSpeedModeUI()
  self:InitListenEvent()
  self.bNeedInitScrollingHeight = true
end

function M:GetAudienceNumConfig()
  local Constaant = DataMgr.RaceLotteryConstant
  self.RegionId = tonumber(Constaant.RaceLotteryRegionOnlineId.ConstantValue)
  self.Coefficient = tonumber(Constaant.RaceLotteryAudienceCoefficient.ConstantValue) or 10
  self.RefreshTime = tonumber(Constaant.RaceLotteryAudienceRefreshTime.ConstantValue) or 1.0
  AudienceNumMin[1] = tonumber(Constaant.RaceLotteryChannelNormalMin.ConstantValue) or AudienceNumMin[1]
  AudienceNumMin[2] = tonumber(Constaant.RaceLotteryChannelBusyMin.ConstantValue) or AudienceNumMin[2]
  AudienceNumMin[3] = tonumber(Constaant.RaceLotteryChannelFullMin.ConstantValue) or AudienceNumMin[3]
  AudienceNumMax[1] = tonumber(Constaant.RaceLotteryChannelNormalMax.ConstantValue) or AudienceNumMax[1]
  AudienceNumMax[2] = tonumber(Constaant.RaceLotteryChannelBusyMax.ConstantValue) or AudienceNumMax[2]
  AudienceNumMax[3] = tonumber(Constaant.RaceLotteryChannelFullMax.ConstantValue) or AudienceNumMax[3]
end

function M:InitRaceData(Params)
  if type(Params) ~= "table" then
    return
  end
  self.FirstPlaceProgress = 0
  if self.InGame_Progress and Params.Progress ~= nil then
    self:SetFirstPlaceProgress(Params.Progress)
  end
  if self.Pet then
    self.Pet:SetParentWidget(self)
    if nil ~= Params.TotalCount then
      self.Pet:SetTotalCount(Params.TotalCount)
    end
    if Params.PetList then
      self:RefreshPetList(Params.PetList)
    end
    self.Pet:Reset2DefaultType()
  end
  SetTextSafely(self.Button_Skip.Text_Function, GText("UI_TALK_SKIP_MOIILE"))
end

function M:InitGamepadView()
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "menu"}
      },
      Desc = GText("UI_CTL_Barrage")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      },
      Desc = GText("UI_CTL_Commentary")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      },
      Desc = GText("UI_CTL_RestorePerspective")
    }
  }
  self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
  self.Key_Speed:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Key_Skip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitKeyboardView()
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Text", Text = "H"}
      },
      Desc = GText("UI_CTL_Barrage")
    },
    {
      KeyInfoList = {
        {Type = "Text", Text = "G"}
      },
      Desc = GText("UI_CTL_Commentary")
    },
    {
      KeyInfoList = {
        {Type = "Text", Text = "R"}
      },
      Desc = GText("UI_CTL_RestorePerspective")
    }
  }
  self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
  self.Key_Speed:SetVisibility(ESlateVisibility.Collapsed)
  self.Key_Skip:SetVisibility(ESlateVisibility.Collapsed)
end

function M:UpdateRaceRuntimeData(Params)
  if type(Params) ~= "table" then
    return
  end
  if Params.Progress ~= nil then
    self:SetFirstPlaceProgress(Params.Progress)
  end
  if Params.PetList then
    self:RefreshPetList(Params.PetList)
  end
end

function M:SetTitleText(Text)
  SetTextSafely(self.Text_Title, Text)
end

function M:BindResetButtonEvent()
  if not self.Mobile then
    return
  end
  if not (self.Btn_Reset and self.Btn_Reset.Btn_Reset) or not self.Btn_Reset.Btn_Reset.OnClicked then
    return
  end
  self.Btn_Reset.Btn_Reset.OnClicked:Remove(self, self.OnResetBtnClicked)
  self.Btn_Reset.Btn_Reset.OnClicked:Add(self, self.OnResetBtnClicked)
end

function M:OnResetBtnClicked()
  if self.Pet and self.Pet.Reset2DefaultType then
    self.Pet:Reset2DefaultType()
  end
end

function M:BindSpeedButtonEvent()
  local SpeedButton = self.Button_Speed
  if not (SpeedButton and SpeedButton.Button_Area) or not SpeedButton.Button_Area.OnClicked then
  else
    SpeedButton.Button_Area.OnClicked:Add(self, self.OnSpeedBtnClicked)
  end
  self.Button_Skip.Button_Area.OnClicked:Add(self, self.OnSkipBtnClicked)
  if self.Mobile then
    return
  end
  self.Key_Speed:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RS"}
    }
  })
  self.Key_Skip:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    }
  })
end

function M:InitListenEvent()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:OnSpeedBtnClicked()
  local NextIndex = self.SpeedModeIndex + 1
  if NextIndex > #SpeedModeList then
    NextIndex = 1
  end
  self.SpeedModeIndex = NextIndex
  self.SpeedModeValue = SpeedModeList[self.SpeedModeIndex]
  self:RefreshSpeedModeUI()
  self:RequestSetRaceSpeed(self.SpeedModeValue)
end

function M:SetCameraUpdateType(PetId, IsRacePetType)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Spline = GameState.PetRaceSplineMaps:FindRef(self.RaceId)
  Spline:SetCameraUpdateType(PetId, IsRacePetType)
end

function M:OnSkipBtnClicked()
  self.PopupUI = UIManager(self):ShowCommonPopupUI(100389, {
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj, PackageData)
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      local Spline = GameState.PetRaceSplineMaps:FindRef(self.RaceId)
      Spline.GameLogicComponent:EndRaceGameLogic()
    end
  }, self)
end

function M:RefreshSpeedModeUI()
  local SpeedButton = self.Button_Speed
  if not SpeedButton or not SpeedButton.Text_Function then
    return
  end
  local Speed = self.SpeedModeValue or 1
  local SpeedText = "X" .. tostring(Speed)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Spline = GameState.PetRaceSplineMaps:FindRef(self.RaceId)
  Spline.GameLogicComponent.RaceGameTimes = Speed
  EventManager:FireEvent(EventID.OnRaceGameTimesSet, Speed)
  SetTextSafely(SpeedButton.Text_Function, SpeedText)
end

function M:RequestSetRaceSpeed(SpeedMode)
end

function M:SetFirstPlaceProgress(ProgressValue)
  local ProgressWidget = self.InGame_Progress
  if not ProgressWidget then
    return
  end
  local Progress = tonumber(ProgressValue) or 0
  Progress = math.max(0, math.min(1, Progress))
  if self.FirstPlaceProgress >= 1 and Progress <= 0 then
    return
  end
  self.FirstPlaceProgress = math.max(self.FirstPlaceProgress or 0, Progress)
  if ProgressWidget.SetProgressPercent then
    ProgressWidget:SetProgressPercent(self.FirstPlaceProgress)
    return
  end
end

function M:RefreshPetList(PetDataList)
  local PetWidget = self.Pet
  if not PetWidget or not PetWidget.RefreshPetList then
    return
  end
  local ChoosePetData = {}
  for PetId, PetData in pairs(PetDataList) do
    if InGameModel:IsChoosePlayer(PetId) then
      table.insert(ChoosePetData, PetData)
    end
  end
  PetWidget:RefreshPetList(ChoosePetData)
end

function M:MarkSelectedPet(PlayerId)
  self.SelectedPetPlayerId = PlayerId
  local PetWidget = self.Pet
  if PetWidget and PetWidget.MarkSelectedPet then
    PetWidget:MarkSelectedPet(PlayerId)
  end
  self:RequestPetSelectedChanged(PlayerId)
end

function M:RequestPetSelectedChanged(PlayerId)
end

function M:OnPetSelectedNotify(PlayerId)
  self:MarkSelectedPet(PlayerId)
end

function M:OnChatBtnCheckStateChange(bIsSelect)
  if bIsSelect then
    self.Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Info.Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Info:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Info.Check:SetVisibility(ESlateVisibility.Collapsed)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "PetRaceInGameBtn", nil)
end

function M:OnScrollingBtnCheckStateChange(bIsSelect)
  if bIsSelect then
    self.ScrollingAnchor:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Scrolling.Check:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.ScrollingAnchor:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Scrolling.Check:SetVisibility(ESlateVisibility.Collapsed)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", "PetRaceInGameBtn", nil)
end

function M:ClickChatBtn()
  local bChecked = self.Btn_Info.Btn_Check:IsChecked()
  self.Btn_Info.Btn_Check:SetChecked(not bChecked)
end

function M:ClickScrollingBtn()
  local bChecked = self.Btn_Scrolling.Btn_Check:IsChecked()
  self.Btn_Scrolling.Btn_Check:SetChecked(not bChecked)
end

function M:OnPetUseSkill(PlayerId, InsideBuffId)
  self.Info:OnPetUseSkill(PlayerId, InsideBuffId)
  if not InGameModel:IsScrollingPlayer(PlayerId) then
    return
  end
  local Widget = UIManager(self):_CreateWidgetNew("RaceLotteryScrolling")
  self.ScrollingAnchor:AddChild(Widget)
  if self.bNeedInitScrollingHeight then
    local Height = Widget:GetHeight()
    if Height and Height > 0 then
      ScrollingDefaultWidgetHeight = Height
      self.bNeedInitScrollingHeight = false
    end
  end
  local StartX, StartY, LaneIndex = self:GetScrollingStartPosition(Widget)
  Widget:Init(PlayerId, InsideBuffId, StartX, StartY, LaneIndex)
end

function M:OnPetReachEnd(PlayerId)
  InGameModel:OnPlayerReachEnd(PlayerId)
end

function M:GetScrollingStartPosition(Widget)
  local StartX
  local StartY = 0
  local LaneIndex = 1
  if not self.ScrollingAnchor then
    return StartX, StartY
  end
  local AnchorWidth, AnchorHeight = self:GetScrollingAnchorSize()
  if AnchorWidth > 0 then
    StartX = AnchorWidth
  end
  if AnchorHeight > 0 then
    local LaneHeight = ScrollingDefaultWidgetHeight + ScrollingLaneGap
    local UsableStartY = ScrollingTopPadding
    local UsableHeight = math.max(0, AnchorHeight - ScrollingTopPadding - ScrollingBottomPadding)
    if UsableHeight <= 0 then
      UsableStartY = 0
      UsableHeight = AnchorHeight
    end
    local LaneCount = math.max(1, math.floor((UsableHeight + ScrollingLaneGap) / LaneHeight))
    LaneIndex = InGameModel:GetNextScrollingLaneIndex(LaneCount)
    local UsableMaxY = math.max(0, UsableHeight - ScrollingDefaultWidgetHeight)
    local MaxY = math.max(0, AnchorHeight - ScrollingDefaultWidgetHeight)
    StartY = math.min(MaxY, UsableStartY + math.min(UsableMaxY, (LaneIndex - 1) * LaneHeight))
  end
  if AnchorWidth > 0 then
    local PreviousScrolling = InGameModel:GetScrollingLaneWidget(LaneIndex)
    if PreviousScrolling and IsValid(PreviousScrolling) then
      local PreviousTailX = PreviousScrolling:GetTailX()
      if AnchorWidth < PreviousTailX then
        StartX = PreviousTailX + ScrollingHorizontalGap
      end
    end
  end
  return StartX, StartY, LaneIndex
end

function M:GetScrollingAnchorSize()
  local Slot = self.ScrollingAnchor and self.ScrollingAnchor.Slot
  if not Slot or not Slot.GetOffsets then
    return 0, 0
  end
  local Parent = self.ScrollingAnchor:GetParent()
  if not Parent then
    return 0, 0
  end
  local ParentGeometry = Parent:GetCachedGeometry()
  local ParentSize = UE4.USlateBlueprintLibrary.GetLocalSize(ParentGeometry)
  local Offsets = Slot:GetOffsets()
  if not ParentSize or not Offsets then
    return 0, 0
  end
  local AnchorWidth = math.max(0, (ParentSize.X or 0) - (Offsets.Left or 0) - (Offsets.Right or 0))
  local AnchorHeight = math.max(0, (ParentSize.Y or 0) - (Offsets.Top or 0) - (Offsets.Bottom or 0))
  return AnchorWidth, AnchorHeight
end

function M:OnAudienceNumUpdate()
  ChatController:SendQueryRegionOnlineChannelState(self.RegionId)
end

function M:OnChatControllerEvent(EventId, channel_type, channel_list)
  if EventId ~= ChatCommon.EventID.RecvChannelPlayerNum and EventId ~= ChatCommon.EventID.RecvAllChatChannel then
    return
  end
  if channel_type ~= self.RegionId then
    return
  end
  self:UpdateAudienceNum(channel_list)
end

function M:UpdateAudienceNum(channel_list)
  if type(channel_list) ~= "table" then
    return
  end
  local ChannelStateNum = {
    [1] = 0,
    [2] = 0,
    [3] = 0
  }
  for Index, State in pairs(channel_list) do
    ChannelStateNum[State] = ChannelStateNum[State] + 1
  end
  local AudienceNum = 0
  for i = 1, 3 do
    local RandomNum = self:GetRandomNum(i)
    AudienceNum = AudienceNum + RandomNum * ChannelStateNum[i]
  end
  AudienceNum = math.floor(AudienceNum * self.Coefficient)
  SetTextSafely(self.Text_WatchNum, AudienceNum)
end

function M:GetRandomNum(State)
  return AudienceNumMin[State] + math.random() * (AudienceNumMax[State] - AudienceNumMin[State])
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
  elseif "G" == InKeyName then
    IsEventHandled = true
    self:ClickChatBtn()
  elseif "H" == InKeyName then
    IsEventHandled = true
    self:ClickScrollingBtn()
  elseif InKeyName == UE4.EKeys.Q.KeyName then
    if self.Pet then
      IsEventHandled = true
      self.Pet:ChooseLeft()
    end
  elseif InKeyName == UE4.EKeys.E.KeyName then
    if self.Pet then
      IsEventHandled = true
      self.Pet:ChooseRight()
    end
  elseif InKeyName == UE4.EKeys.R.KeyName and self.Pet then
    IsEventHandled = true
    self.Pet:Reset2DefaultType()
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_Special_Left" == InKeyName then
    IsEventHandled = true
    self:ClickScrollingBtn()
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    IsEventHandled = true
    self:ClickChatBtn()
  elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
    if self.Pet then
      IsEventHandled = true
      self.Pet:ChooseLeft()
    end
  elseif InKeyName == UIConst.GamePadKey.RightShoulder then
    if self.Pet then
      IsEventHandled = true
      self.Pet:ChooseRight()
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if self.Pet then
      IsEventHandled = true
      self.Pet:Reset2DefaultType()
    end
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self:OnSpeedBtnClicked()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnSkipBtnClicked()
  end
  return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    self.Pet:UpdateInputStyle(true)
    return
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Pet:UpdateInputStyle(true)
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:InitKeyboardView()
  else
    self:InitGamepadView()
  end
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Pet:UpdateInputStyle(true)
    return
  end
  if IsUseKeyAndMouse then
    self.Com_KeyImg_Info:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Com_KeyImg_Scrolling:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.Pet and self.Pet.UpdateInputStyle then
      self.Pet:UpdateInputStyle(true)
    end
  else
    self:SetFocus()
    self.Com_KeyImg_Info:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_KeyImg_Info:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
    self.Com_KeyImg_Scrolling:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_KeyImg_Scrolling:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      }
    })
    if self.Pet and self.Pet.UpdateInputStyle then
      self.Pet:UpdateInputStyle(false)
    end
  end
end

function M:Destruct()
  if ChatController then
    ChatController:UnRegisterEvent(self)
  end
  if self.Btn_Info and self.Btn_Info.Btn_Check and self.Btn_Info.Btn_Check.OnCheckStateChanged then
    self.Btn_Info.Btn_Check.OnCheckStateChanged:Remove(self, self.OnChatBtnCheckStateChange)
  end
  if self.Btn_Scrolling and self.Btn_Scrolling.Btn_Check and self.Btn_Scrolling.Btn_Check.OnCheckStateChanged then
    self.Btn_Scrolling.Btn_Check.OnCheckStateChanged:Remove(self, self.OnScrollingBtnCheckStateChange)
  end
  local SpeedButton = self.Button_Speed
  if SpeedButton and SpeedButton.Button_Area and SpeedButton.Button_Area.OnClicked then
    SpeedButton.Button_Area.OnClicked:Remove(self, self.OnSpeedBtnClicked)
  end
  if self.Btn_Reset and self.Btn_Reset.Btn_Reset and self.Btn_Reset.Btn_Reset.OnClicked then
    self.Btn_Reset.Btn_Reset.OnClicked:Remove(self, self.OnResetBtnClicked)
  end
end

return M
