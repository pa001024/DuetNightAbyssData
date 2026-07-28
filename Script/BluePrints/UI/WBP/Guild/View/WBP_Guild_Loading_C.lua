require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent"
}

function M:Construct()
  self:AddInputMethodChangedListen()
end

function M:Destruct()
  self:UnBindInLoading()
end

function M:InitLoadingData(LoadingData, ParentUI)
  self.CurrentInputDevice = {
    "KeyboardKey",
    "MouseButton"
  }
  self.IsPlaying = true
  self.IsWaiting = false
  self.CurrentAnimationMode = "Forward"
  self.WaitDuration = self.ChangeTime
  self.MinProgress = 30
  self.Progress = 0.0
  self.ProgressSpeed = 100.0
  self.IsProgressing = true
  self.ParentUI = ParentUI
  local bEnableTick = not ParentUI
  self.bEnableTick = bEnableTick
  self.bUseFakeProgress = bEnableTick
  self.bBindInLoading = false
  self.MessageGroupId = LoadingData.MessageGroup
  self:PlayAnimation(self.In)
  self:UpdateProgress()
  self:InitMessageGroup()
  self:InitTitle(LoadingData.TitleBp, LoadingData.TitleTrans)
  self:InitBg(LoadingData.BackGroundBp)
  self:InitUIEvent()
  if not ParentUI then
    local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if IsValid(GameInputSubsystem) then
      local Params = FGameInputModeParams()
      Params.bShowMouseCursor = false
      Params.MouseLockMode = EMouseLockMode.DoNotLock
      GameInputSubsystem:EnableInputMode("CommonChangeScene", EGameInputMode.UI, Params)
    end
    self:SetMouseCursorVisable(false)
    self.bBindInLoading = true
    EventManager:AddEvent(EventID.InLoading, self, self.OnInLoading)
  end
end

function M:UnBindInLoading()
  if self.bBindInLoading then
    EventManager:RemoveEvent(EventID.InLoading, self)
    self.bBindInLoading = nil
  end
end

function M:OnInLoading()
  self:CloseUI()
end

function M:InitUIEvent()
  self.Button_461.OnClicked:Clear()
  self.Button_461.OnClicked:Add(self, self.InitMessageGroup)
  self:SetFocus()
  self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
end

function M:SetRandomTips()
  self:InitMessageGroup()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  self:InitMessageGroup()
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  self.CurrentInputDevice = IsUseKeyAndMouse and {
    "KeyboardKey",
    "MouseButton"
  } or {"GamepadKey"}
  if not IsUseKeyAndMouse and self.RandomMessageIndex then
    self.Button_461:SetFocus()
    self.Com_KeyTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_KeyTitle:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Loading_Next")
    })
  else
    self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:InitBg(BgBp)
  if not BgBp then
    return
  end
  self.Panel_Bg:ClearChildren()
  local BPWidget = UIManager(self):CreateWidget(BgBp)
  if BPWidget then
    self.Panel_Bg:SetContent(BPWidget)
    BPWidget:PlayAnimation(BPWidget.In_Loading)
  end
end

local function StringReplaceUtil(PathString, Number)
  local Length = PathString:len()
  if string.byte(PathString, Length - 1) == Number + 48 then
    return PathString
  end
  local ReplaceChar = tostring(Number)
  local DotPos = PathString:find(".", 1, true)
  if DotPos and DotPos > 1 then
    local PreDotPart = PathString:sub(1, DotPos - 2)
    local PostDotPart = PathString:sub(DotPos + 1, Length - 2)
    local ReplacedString = PreDotPart .. ReplaceChar .. "." .. PostDotPart .. ReplaceChar .. "'"
    return ReplacedString
  end
  return PathString
end

function M:InitTitle(TitleBp, TitleTrans)
  if not TitleBp then
    self.Group_Title:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  local SystemLanguageSurfix = {CN = 1, Other = 2}
  local SystemLanguage = EMCache:Get("SystemLanguage")
  TitleBp = StringReplaceUtil(TitleBp, SystemLanguageSurfix[SystemLanguage] or 2)
  self.Group_Title:ClearChildren()
  local TitleWidget = UIManager(self):CreateWidget(TitleBp)
  self.Group_Title:AddChildToOverlay(TitleWidget)
  TitleWidget:PlayAnimation(TitleWidget.In)
  if TitleTrans and TitleWidget.Text_ENSubTitle then
    TitleWidget.Text_ENSubTitle:SetText(GText(TitleTrans))
  end
end

function M:InitMessageGroup()
  local MessageGroupId = self.MessageGroupId
  local MessageGroup = MessageGroupId and DataMgr.MessageGroup[MessageGroupId]
  if not MessageGroup or not MessageGroup.MessageList then
    return
  end
  local ListLength = #MessageGroup.MessageList
  if ListLength > 1 then
    local RandomIndex = math.random(1, ListLength)
    if self.RandomMessageIndex == RandomIndex then
      RandomIndex = RandomIndex + 1
      if ListLength < RandomIndex then
        RandomIndex = 1
      end
    end
    self.RandomMessageIndex = RandomIndex
    self.ShowTipsInterval = Const.LoadingTipsInterval
    if self.ParentUI and self.ParentUI.ShowTipsInterval then
      self.ParentUI.ShowTipsInterval = Const.LoadingTipsInterval
    end
  end
  local MessageId = MessageGroup.MessageList[self.RandomMessageIndex or 1]
  local RandomTips = DataMgr.Message[MessageId]
  local Title = GText(RandomTips.MessageTitlePC or "")
  self.Text_Title:SetText(Title)
  local RandomMessage
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    RandomMessage = GText(RandomTips.MessageContentGamePad or RandomTips.MessageContentPC)
  elseif "PC" == PlatformName then
    RandomMessage = GText(RandomTips.MessageContentPC)
  elseif "Mobile" == PlatformName then
    RandomMessage = GText(RandomTips.MessageContentPhone)
  end
  local Messages = self:GetFinalContentText(RandomMessage, self.CurrentInputDevice)
  self.Text_Message:SetText(Messages)
end

function M:Tick(MyGeometry, InDeltaTime)
  if not self.bUseFakeProgress then
    return
  end
  if self.Progress >= self.MinProgress then
    self.IsWaitClose = self.IsWaitClose or self:IsFinishGuildLoading()
    if self.IsWaitClose then
      self:CloseUI()
      return
    end
    if not self.IsProgressing then
      return
    end
  end
  self.Progress = self.Progress + self.ProgressSpeed * InDeltaTime
  if self.Progress >= 99.0 then
    self.Progress = 99.0
    self.IsProgressing = false
  end
  if self.ShowTipsInterval then
    self.ShowTipsInterval = self.ShowTipsInterval - InDeltaTime
    if self.ShowTipsInterval <= 0 then
      self:SetRandomTips()
    end
  end
  self:UpdateProgress()
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation ~= self.In then
    return
  end
  if not self.IsPlaying then
    return
  end
  DebugPrint("动画完成: " .. self.CurrentAnimationMode)
  self.IsWaiting = true
end

function M:UpdateProgressBar(Progress)
  self.Progress = Progress
  self:UpdateProgress()
end

function M:UpdateProgress()
  self.ProgressBar:SetPercent(self.Progress / 100)
  self.Progress_Text_Bar:SetText(string.format("%.0f", self.Progress))
end

function M:IsFinishGuildLoading()
  return true
end

function M:CloseUI(UnLoadingCallback)
  if self.Progress < self.MinProgress then
    self.IsWaitClose = self:IsFinishGuildLoading()
    return
  end
  self.IsWaitClose = false
  self.Progress = 100.0
  self:UpdateProgress()
  self:AddTimer(0.1, function()
    self:RemoveFromParent()
    if not self.ParentUI then
      self:SetMouseCursorVisable(true)
      local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(GWorld.GameInstance)
      if IsValid(GameInputSubsystem) then
        GameInputSubsystem:DisableInputMode("CommonChangeScene")
      end
      self:UnBindInLoading()
    end
    self.ParentUI = nil
    if UnLoadingCallback then
      UnLoadingCallback()
    end
  end, false, 0, nil, true)
end

AssembleComponents(M)
return M
