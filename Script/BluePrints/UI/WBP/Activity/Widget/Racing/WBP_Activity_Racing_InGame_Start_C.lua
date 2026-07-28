require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.KeyInputComponent"
}
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

local function ParsePetStartData(Index, PetData)
  local ParsedData = {
    Index = Index,
    PlayerId = nil,
    RumorList = {},
    TotalCostSecond = nil
  }
  if type(PetData) == "table" then
    ParsedData.PlayerId = PetData.PlayerId
    ParsedData.RumorList = PetData.RumorList or {}
    ParsedData.TotalCostSecond = PetData.TotalCostSecond
  end
  return ParsedData
end

function M:Construct()
  M.Super.Construct(self)
  self.bIsFocusable = true
  self.HoldToCloseDuration = 1
  self.Key_Skip:SetVisibility(ESlateVisibility.Collapsed)
  if not UIUtils.IsMobileInput() then
    self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if IsValid(self.GameInputModeSubsystem) then
      self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
    self.HB_Btn:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Button_Skip.Text_Function:SetText(GText("UI_TALK_SKIP_MOIILE"))
    self.HB_Btn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Button_Skip.Button_Area.OnClicked:Add(self, self.OnCloseBtnClicked)
    self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:SetPosition()
  self:InitLongPressEvent()
end

function M:OnLoaded(...)
  local PetDataList, RaceId = ...
  if type(PetDataList) ~= "table" then
    PetDataList = {}
  end
  self.RaceId = RaceId
  self:InitPetList(PetDataList)
  self:SetFocus()
  local CountDown = 5
  self.TimerHandle = self:AddTimer(CountDown, function()
    self:CloseSelf()
  end, false, 0, "CloseInGameStartGoIntoCountDown")
  local CurrentTimeStamp = TimeUtils.NowTime()
  local EventConfigData = DataMgr.EventMain[RacingActivityConst.ActivityEventId]
  local RaceBeginTimeStamp = EventConfigData and EventConfigData.EventStartTime or 0
  local DiffDay = TimeUtils.GetIntervalDay(RaceBeginTimeStamp, CurrentTimeStamp) + 1
  self.Text_Title:SetText(string.format(GText("UI_GameEvent_RaceLottery_ResultBoardTitle"), DiffDay))
  AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_game_start_list_show", "PetRaceGameStartListShow", nil)
  self:PlayAnimation(self.In)
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadView()
  elseif CurInputType == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardView()
  end
end

function M:SetPosition()
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
  local bPCCloudGame = UE4.UUCloudGameInstanceSubsystem.IsPCCloudGame()
  if bPCCloudGame or "PC" == PlatformName then
    self.Condition = false
  else
    self.Condition = true
  end
  self:SetUIPosition()
end

function M:InitGamepadView()
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
        }
      },
      bLongPress = true,
      Desc = GText("UI_TALK_SKIP")
    }
  })
end

function M:InitKeyboardView()
  if UIUtils.IsMobileInput() then
    return
  end
  self.Com_KeyTips:UpdateKeyInfo({
    {
      KeyInfoList = {
        {Type = "Text", Text = "SpaceBar"}
      },
      bLongPress = true,
      Desc = GText("UI_TALK_SKIP")
    }
  })
end

function M:CheckPetIsSelected(PlayerId)
  if not self.ChoosePetList then
    self.ChoosePetList = {}
    for _, PetId in ipairs(RacingOutsiderModel:GetServerChoosePetList()) do
      self.ChoosePetList[PetId] = true
    end
  end
  return self.ChoosePetList[PlayerId] or false
end

function M:InitPetList(PetDataList)
  for Index, PetData in ipairs(PetDataList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.PlayerId = PetData.PlayerId
    Content.RumorList = PetData.RumorList
    Content.TotalCostSecond = PetData.TotalCostSecond
    Content.IsSelected = self:CheckPetIsSelected(PetData.PlayerId)
    self.List_Pet:AddItem(Content)
  end
end

function M:OnCloseBtnClicked()
  self:CloseSelf()
end

function M:CloseSelf()
  self:RemoveTimer(self.TimerHandle)
  self:InitPetRaceUIAndStartProgress()
  AudioManager(self):SetEventSoundParam(self, "PetRaceGameStartListShow", {ToEnd = 1})
  self:PlayAnimation(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Unhandled, false
end

function M:OnTouchStarted(MyGeometry, InTouchEvent)
  self.bMobileHoldToClose = true
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  self.bMobileHoldToClose = false
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:InitLongPressEvent()
  self:AddLongPressEvent("SpaceBar", self.HoldToCloseDuration, self.OnSpaceBar_LongPressStart, self.OnSpaceBar_LongPressCancel, self.OnSpaceBar_LongPressEnd)
  self:AddLongPressEvent(UIConst.GamePadKey.FaceButtonBottom, self.HoldToCloseDuration, self.OnGamepad_FaceButton_Bottom_LongPressStart, self.OnGamepad_FaceButton_Bottom_LongPressCancel, self.OnGamepad_FaceButton_Bottom_LongPressEnd)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:InitPetRaceUIAndStartProgress()
  local CountdownDuration = 4
  local GuideCountDownFloat = UIManager(self):GetUIObj("GuideCountDown")
  GuideCountDownFloat = GuideCountDownFloat or UIManager(self):LoadUINew("GuideCountDown")
  GuideCountDownFloat:InitStartPetRaceCountDown(CountdownDuration, false, self.RaceId)
end

function M:OnSpaceBar_LongPressStart()
  local SpaceBarBtn = self.Com_KeyTips:GetComKeyById(1)
  if SpaceBarBtn then
    SpaceBarBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime("SpaceBar"))
  end
end

function M:OnSpaceBar_LongPressCancel()
  local SpaceBarBtn = self.Com_KeyTips:GetComKeyById(1)
  if SpaceBarBtn then
    SpaceBarBtn:OnButtonReleased()
    SpaceBarBtn:StopAllAnimations()
    SpaceBarBtn:PlayAnimation(SpaceBarBtn.Normal)
  end
end

function M:OnSpaceBar_LongPressEnd()
  self:OnCloseBtnClicked()
end

function M:OnGamepad_FaceButton_Bottom_LongPressStart()
  local FaceButtonBottomBtn = self.Com_KeyTips:GetComKeyById(1)
  if FaceButtonBottomBtn then
    FaceButtonBottomBtn:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime(UIConst.GamePadKey.FaceButtonBottom))
  end
end

function M:OnGamepad_FaceButton_Bottom_LongPressCancel()
  local FaceButtonBottomBtn = self.Com_KeyTips:GetComKeyById(1)
  if FaceButtonBottomBtn then
    FaceButtonBottomBtn:OnButtonReleased()
    FaceButtonBottomBtn:StopAllAnimations()
    FaceButtonBottomBtn:PlayAnimation(FaceButtonBottomBtn.Normal)
  end
end

function M:OnGamepad_FaceButton_Bottom_LongPressEnd()
  self:OnCloseBtnClicked()
end

AssembleComponents(M)
return M
