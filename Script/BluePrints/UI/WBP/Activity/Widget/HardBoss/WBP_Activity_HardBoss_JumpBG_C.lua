require("UnLua")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local PlayTimerKey = "HardBossJumpBGPlayVideo"
local LastOpenCacheKey = "HardBossJumpBGLastOpenTime"
local TailGuardFrames = 1.5
local MinVideoAdvanceTime = 0.02
local MaxVideoAdvanceTime = 0.12
local DefaultVideoAdvanceTime = 0.05
local MaxPollDeltaSeconds = 0.15
local PauseRetryCooldownSeconds = 0.15
local SwapAbortMaxSeconds = 3.0
local LoopRetryMax = 1
local SwapAbortPollInterval = 0.5
local PrerollSeconds = 0
local InTailInterval = 0.01
local TailCorrectInterval = 0.5
local InTailMaxFailSeconds = 3.0
local FrameGateInterval = 0.01
local FrameGateSteadyTick = 2
local FrameGateMaxSeconds = 3.0
local FrameGatePlayingTick = 3
local LoopPreheatDelay = 0
local FirstStandbyPreheatDelay = 0.5
local LoopReadyInterval = 0.02
local LoopReadyMaxSeconds = 2.0
local StandbyWaitMaxSeconds = 0.3
local InSwitchWaitMaxSeconds = 0.8
local StandbyPresentingMaxSeconds = 0.5
local ProgressWatchInterval = 0.25
local ProgressStallSeconds = 0.6
local ProgressOpenStallSeconds = 3
local InTailTimerKey = "HardBossJumpBGInTail"
local InTailSwitchTimerKey = "HardBossJumpBGInTailSwitch"
local LoopTailSwitchTimerKey = "HardBossJumpBGLoopTailSwitch"
local WaitCoverTimerKey = "HardBossJumpBGWaitCover"
local InGateTimerKey = "HardBossJumpBGInGate"
local LoopGateTimerKey = "HardBossJumpBGLoopGate"
local LoopGateSwapTimerKey = "HardBossJumpBGLoopGateSwap"
local LoopGateRecoverTimerKey = "HardBossJumpBGLoopGateRecover"
local LoopPreheatTimerKey = "HardBossJumpBGLoopPreheat"
local LoopReadyTimerKey = "HardBossJumpBGLoopReady"
local LoopTailTimerKey = "HardBossJumpBGLoopTail"
local SwapWaitTimerKey = "HardBossJumpBGSwapWait"
local ProgressWatchTimerKey = "HardBossJumpBGProgressWatch"
local LoopSwapAbortTimerKey = "HardBossJumpBGLoopSwapAbort"
local AllTimerKeys = {
  PlayTimerKey,
  InTailTimerKey,
  InTailSwitchTimerKey,
  LoopTailSwitchTimerKey,
  WaitCoverTimerKey,
  InGateTimerKey,
  LoopGateTimerKey,
  LoopGateSwapTimerKey,
  LoopGateRecoverTimerKey,
  LoopPreheatTimerKey,
  LoopReadyTimerKey,
  LoopTailTimerKey,
  SwapWaitTimerKey,
  ProgressWatchTimerKey,
  LoopSwapAbortTimerKey
}
local LastActiveInstance
local VideoAssetPrefix = "/Game/Asset/UIVideo/SystemShow/Activity/Video_Activity_HardBoss_JumpBG-"
local AdaptiveBoxWidth = 1920
local AdaptiveBoxHeight = 1080
local ResidualLayerNames = {
  "Bg",
  "Chess",
  "LineGlow",
  "NiagaraSystemWidget_650",
  "Panel_VX"
}

local function GetEnumNumber(Getter)
  local bOk, Value = pcall(Getter)
  if bOk and type(Value) == "number" then
    return Value
  end
  return nil
end

local CachedMathLib
local bMathLibResolved = false

local function GetMathLib()
  if not bMathLibResolved then
    bMathLibResolved = true
    local MathLib = not UKismetMathLibrary and UE4 and UE4.UKismetMathLibrary
    CachedMathLib = MathLib and MathLib.GetTotalSeconds and MathLib or nil
  end
  return CachedMathLib
end

local CachedGameplayStatics
local bGameplayStaticsResolved = false

local function GetGameplayStatics()
  if not bGameplayStaticsResolved then
    bGameplayStaticsResolved = true
    local Statics = not UGameplayStatics and UE4 and UE4.UGameplayStatics
    CachedGameplayStatics = Statics and Statics.GetRealTimeSeconds and Statics or nil
  end
  return CachedGameplayStatics
end

local function GetTimespanSeconds(Timespan)
  if not Timespan then
    return nil
  end
  local MathLib = GetMathLib()
  if not MathLib then
    return nil
  end
  local bOk, Seconds = pcall(MathLib.GetTotalSeconds, Timespan)
  if bOk and type(Seconds) == "number" then
    return Seconds
  end
  return nil
end

local function GetPlayedSeconds(MediaPlayer)
  if not IsValid(MediaPlayer) or not MediaPlayer.GetTime then
    return nil
  end
  return GetTimespanSeconds(MediaPlayer:GetTime())
end

local DurationCacheField = "JumpBGCachedDuration"
local PresentedCacheField = "JumpBGFramePresented"

local function SetPlayerFramePresented(VideoPlayer, bPresented)
  if IsValid(VideoPlayer) then
    rawset(VideoPlayer, PresentedCacheField, bPresented and true or false)
  end
end

local function IsPlayerFramePresented(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return false
  end
  return rawget(VideoPlayer, PresentedCacheField) == true
end

local function GetCachedDuration(VideoPlayer, MediaPlayer)
  if IsValid(VideoPlayer) then
    local Cached = rawget(VideoPlayer, DurationCacheField)
    if Cached and Cached > 0 then
      return Cached
    end
  end
  if not IsValid(MediaPlayer) or not MediaPlayer.GetDuration then
    return nil
  end
  local Duration = GetTimespanSeconds(MediaPlayer:GetDuration())
  if Duration and Duration > 0 and IsValid(VideoPlayer) then
    rawset(VideoPlayer, DurationCacheField, Duration)
  end
  return Duration
end

local function ClearCachedDuration(VideoPlayer)
  if IsValid(VideoPlayer) then
    rawset(VideoPlayer, DurationCacheField, nil)
  end
end

local MediaSourceCache = {}

local function GetMediaSource(MediaPath)
  local Cached = MediaSourceCache[MediaPath]
  if IsValid(Cached) then
    return Cached
  end
  local MediaSource = LoadObject(MediaPath)
  MediaSourceCache[MediaPath] = IsValid(MediaSource) and MediaSource or nil
  return MediaSourceCache[MediaPath]
end

local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Initialize(Initializer)
  self.ActivityEntry = nil
  self.InVideoPlayer = nil
  self.LoopVideoPlayer = nil
  self.StaticBg = nil
  self.BlackBg = nil
  self.ResidualWidgets = nil
  self.ContainerWidgets = nil
  self.ScaleBoxWidget = nil
  self.SizeBoxWidget = nil
  self.AttachCanvas = nil
  self.PlayToken = 0
  self.InEndToken = 0
  self.bLoopPreheated = false
  self.LoopReadyTick = 0
  self.InTailFailTick = 0
  self.GateState = {}
  self.LoopRetryCount = 0
  self.LoopRetryStart = nil
  self.ActiveLoopPlayer = nil
  self.StandbyLoopPlayer = nil
  self.bLoopPingPong = false
  self.bStandbyPreheated = false
  self.bPrerollStarted = false
  self.bLoopSwapping = false
  self.LoopTailFailTick = 0
  self.bLoopTailUnsupported = false
  self.RecoverStep = 0
  self.RecoverMode = nil
  self.SwapActive = nil
  self.SwapStandby = nil
  self.ProgressWatchPlayer = nil
  self.ProgressWatchMode = nil
  self.ProgressWatchLast = nil
  self.ProgressWatchIdle = 0
  self.bProgressWatchAdvanced = false
  self.bLoopSwitching = false
  self.bInTailUnsupported = false
  self.InTailFailStart = nil
  self.LoopTailFailStart = nil
  self.LastPollTime = nil
  self.LastPollDelta = nil
  self.LastVideoAdvanceTime = nil
  self.LoopPauseIssuedTime = nil
  self.bInTailSwitchArmed = false
  self.bLoopTailSwitchArmed = false
  self.WaitCoverPlayer = nil
  self.WaitCoverStartOpacity = 1
  self.WaitCoverTick = 0
end

function M:GetRealSeconds()
  local Statics = GetGameplayStatics()
  if not Statics then
    return nil
  end
  local bOk, Seconds = pcall(Statics.GetRealTimeSeconds, self)
  if bOk and type(Seconds) == "number" then
    return Seconds
  end
  return nil
end

function M:IsWaitExpired(StartTime, LimitSeconds, Ticks)
  if StartTime then
    local Now = self:GetRealSeconds()
    if Now then
      return LimitSeconds <= Now - StartTime
    end
  end
  if not Ticks then
    return false
  end
  return Ticks >= math.max(2, math.ceil(LimitSeconds * 30))
end

function M:UpdatePollDelta()
  local Now = self:GetRealSeconds()
  if not Now then
    return
  end
  local Last = self.LastPollTime
  self.LastPollTime = Now
  if not Last then
    return
  end
  local Delta = Now - Last
  local Coarse = Delta > MaxPollDeltaSeconds
  if Coarse then
    Delta = self.LastPollDelta
  end
  if not Delta or Delta <= 0 or Delta > 0.5 then
    return
  end
  local Smoothed
  if Coarse then
    Smoothed = self.LastVideoAdvanceTime
  else
    Smoothed = self.LastPollDelta
  end
  local Settled = Smoothed and Smoothed * 0.8 + Delta * 0.2 or Delta
  self.LastPollDelta = Settled
  if not Coarse then
    self.LastVideoAdvanceTime = Settled
  end
end

function M:GetVideoAdvanceTime()
  local Delta = self.LastVideoAdvanceTime
  if not Delta or Delta <= 0 then
    Delta = self.LastPollDelta
  end
  if not Delta or Delta <= 0 then
    return DefaultVideoAdvanceTime
  end
  local Advance = Delta * TailGuardFrames
  if Advance < MinVideoAdvanceTime then
    return MinVideoAdvanceTime
  end
  if Advance > MaxVideoAdvanceTime then
    return MaxVideoAdvanceTime
  end
  return Advance
end

function M:RemoveAllJumpBGTimer()
  if not self.RemoveTimer then
    return
  end
  for _, Key in ipairs(AllTimerKeys) do
    self:RemoveTimer(Key)
  end
end

function M:InitUI(ActivityConfigData, PageConfigData, CurTabId, Parent)
  self.PlayToken = (self.PlayToken or 0) + 1
  if LastActiveInstance ~= self and IsValid(LastActiveInstance) then
    LastActiveInstance:StopAllJumpBGVideo()
  end
  LastActiveInstance = self
  self.ActivityEntry = IsValid(Parent) and Parent or nil
  self:EnforceBgInputState()
  self:EnforceAdaptiveBox()
  self:HideResidualLayers()
  self:RemoveAllJumpBGTimer()
  GetMediaSource(self:GetMediaPath("Loop"))
  if self.AddTimer then
    self:AddTimer(0.01, self.PlayJumpBGVideo, false, 0, PlayTimerKey, true)
  else
    self:StopLeftoverUMGAnims()
    self:PlayJumpBGVideo()
  end
end

function M:IsFirstOpenToday()
  local LastOpenTime = EMCache:Get(LastOpenCacheKey, true)
  local NowTime = TimeUtils.NowTime()
  if not LastOpenTime then
    return true
  end
  return 0 ~= TimeUtils.GetIntervalDay(LastOpenTime, NowTime)
end

function M:MarkOpenedToday()
  EMCache:Set(LastOpenCacheKey, TimeUtils.NowTime(), true)
end

function M:GetMediaPath(Suffix)
  return VideoAssetPrefix .. Suffix .. ".Video_Activity_HardBoss_JumpBG-" .. Suffix
end

function M:FindNamedWidget(WidgetName)
  local Widget = self[WidgetName]
  if IsValid(Widget) then
    return Widget
  end
  if self.WidgetTree and self.WidgetTree.FindWidget then
    Widget = self.WidgetTree:FindWidget(WidgetName)
    if IsValid(Widget) then
      return Widget
    end
  end
  if self.GetWidgetFromName then
    Widget = self:GetWidgetFromName(WidgetName)
    if IsValid(Widget) then
      return Widget
    end
  end
  return nil
end

function M:GetFirstChild(Panel)
  if not IsValid(Panel) or not Panel.GetChildAt then
    return nil
  end
  local Child = Panel:GetChildAt(0)
  if IsValid(Child) then
    return Child
  end
  return nil
end

function M:ResolveScaleBoxChain()
  if IsValid(self.AttachCanvas) then
    return self.AttachCanvas
  end
  local ScaleBox = self:FindNamedWidget("ScaleBox_0")
  self.ScaleBoxWidget = ScaleBox
  if not IsValid(ScaleBox) then
    return nil
  end
  local SizeBox = self:GetFirstChild(ScaleBox)
  local Inner = self:GetFirstChild(SizeBox)
  if not IsValid(Inner) then
    Inner = SizeBox
    SizeBox = nil
  end
  self.SizeBoxWidget = SizeBox
  if not IsValid(Inner) or not Inner.AddChildToCanvas then
    return nil
  end
  self.AttachCanvas = Inner
  local List = {ScaleBox}
  if IsValid(SizeBox) then
    List[#List + 1] = SizeBox
  end
  List[#List + 1] = Inner
  self.ContainerWidgets = List
  return Inner
end

function M:ResolveVideoPlayers()
  if IsValid(self.InVideoPlayer) then
    self.LoopVideoPlayer = IsValid(self.LoopVideoPlayer) and self.LoopVideoPlayer or self.InVideoPlayer
    return true
  end
  local InPlayer = self:FindNamedWidget("VideoPlayer") or self:FindNamedWidget("WBP_VideoPlayer") or self:FindNamedWidget("InVideoPlayer")
  local LoopPlayer = self:FindNamedWidget("LoopVideoPlayer") or self:FindNamedWidget("WBP_LoopVideoPlayer")
  if not IsValid(InPlayer) then
    return false
  end
  self:PrepareCreatedPlayer(InPlayer)
  if IsValid(LoopPlayer) and LoopPlayer ~= InPlayer then
    self:PrepareCreatedPlayer(LoopPlayer)
  end
  self.InVideoPlayer = InPlayer
  self.LoopVideoPlayer = IsValid(LoopPlayer) and LoopPlayer or InPlayer
  return true
end

function M:DisableFocusOnWidget(Widget)
  if not IsValid(Widget) then
    return
  end
  if Widget.SetIsFocusable then
    Widget:SetIsFocusable(false)
    return
  end
  if Widget.bIsFocusable ~= nil then
    Widget.bIsFocusable = false
  end
end

function M:DisableActivationLeaf(Widget)
  if not IsValid(Widget) then
    return
  end
  Widget.bSupportsActivationFocus = false
  Widget.bIsBackHandler = false
  Widget.bAutoActivate = false
  self:DisableFocusOnWidget(Widget)
  if Widget.DeactivateWidget then
    pcall(function()
      Widget:DeactivateWidget()
    end)
  end
end

function M:EnforceBgInputState()
  self:DisableActivationLeaf(self)
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  local InnerRoot = self:FindNamedWidget("Root")
  if IsValid(InnerRoot) then
    InnerRoot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:DisableFocusOnWidget(InnerRoot)
  end
  self:DisableActivationLeaf(self.InVideoPlayer)
  if self.LoopVideoPlayer ~= self.InVideoPlayer then
    self:DisableActivationLeaf(self.LoopVideoPlayer)
  end
end

function M:GetActivityEntry()
  if IsValid(self.ActivityEntry) then
    return self.ActivityEntry
  end
  local UIMgr = UIManager(self)
  if UIMgr and UIMgr.GetUIObj then
    local Entry = UIMgr:GetUIObj("ActivityMain")
    if IsValid(Entry) then
      self.ActivityEntry = Entry
      return Entry
    end
  end
  return nil
end

function M:GetEntryFocusTarget(Entry)
  if not IsValid(Entry) then
    return nil
  end
  local UIMgr = UIManager(self)
  if UIMgr and UIMgr.GetCurrentState then
    local TopState = UIMgr:GetCurrentState()
    if IsValid(TopState) and TopState ~= Entry and TopState.BP_GetDesiredFocusTarget then
      local TopTarget = TopState:BP_GetDesiredFocusTarget()
      if IsValid(TopTarget) then
        return TopTarget
      end
    end
  end
  local FocusTarget
  if Entry.BP_GetDesiredFocusTarget then
    FocusTarget = Entry:BP_GetDesiredFocusTarget()
  end
  if not IsValid(FocusTarget) then
    FocusTarget = Entry.List_Tab
  end
  return FocusTarget
end

function M:BP_GetDesiredFocusTarget()
  return self:GetEntryFocusTarget(self:GetActivityEntry())
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  local Entry = self:GetActivityEntry()
  local FocusTarget = self:GetEntryFocusTarget(Entry)
  if not IsValid(FocusTarget) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), FocusTarget)
end

function M:HandleKeyDownInBg(MyGeometry, InKeyEvent)
  return false
end

function M:PrepareCreatedPlayer(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer.IsFullScreen = false
  VideoPlayer.IsInit = true
  VideoPlayer.IsAllowEscape = false
  self:DisableActivationLeaf(VideoPlayer)
end

function M:SetPlayerSurfacePrewarm(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  VideoPlayer:SetRenderOpacity(0)
end

function M:PreparePlayer(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  self:PrepareCreatedPlayer(VideoPlayer)
  if VideoPlayer.HideSkipButton and IsValid(VideoPlayer.Button_Skip) then
    VideoPlayer:HideSkipButton(true)
  end
  self:SetPlayerSurfacePrewarm(VideoPlayer)
end

function M:ShowPlayerWidget(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  VideoPlayer:SetRenderOpacity(1)
  if IsValid(VideoPlayer.Image_Video) then
    VideoPlayer.Image_Video:SetRenderOpacity(1)
    VideoPlayer.Image_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if IsValid(VideoPlayer.Image_Mask) then
    VideoPlayer.Image_Mask:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:DimPlayerWidget(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  VideoPlayer:SetRenderOpacity(0)
  if VideoPlayer.Pause then
    VideoPlayer:Pause()
  end
end

function M:HidePlayerWidget(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if VideoPlayer.Pause then
    VideoPlayer:Pause()
  end
end

function M:ClearPlayEndBind(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  VideoPlayer.Obj = nil
  VideoPlayer.Event = nil
end

function M:StopVideoPlayer(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  self:ClearPlayEndBind(VideoPlayer)
  self:HidePlayerWidget(VideoPlayer)
end

function M:GetCachedWidgets(CacheKey, NameList)
  local Cached = self[CacheKey]
  if Cached then
    return Cached
  end
  local List = {}
  for _, Name in ipairs(NameList) do
    local Widget = self:FindNamedWidget(Name)
    if IsValid(Widget) then
      List[#List + 1] = Widget
    end
  end
  self[CacheKey] = List
  return List
end

function M:GetResidualWidgets()
  return self:GetCachedWidgets("ResidualWidgets", ResidualLayerNames)
end

function M:GetContainerWidgets()
  if self.ContainerWidgets then
    return self.ContainerWidgets
  end
  self:ResolveScaleBoxChain()
  return self.ContainerWidgets or {}
end

function M:ResetContainerLayers()
  for _, Widget in ipairs(self:GetContainerWidgets()) do
    if IsValid(Widget) then
      Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      Widget:SetRenderOpacity(1)
      if Widget.SetRenderScale then
        Widget:SetRenderScale(FVector2D(1, 1))
      end
      if Widget.SetRenderTranslation then
        Widget:SetRenderTranslation(FVector2D(0, 0))
      end
      if Widget.SetRenderTransformAngle then
        Widget:SetRenderTransformAngle(0)
      end
    end
  end
end

function M:EnforceAdaptiveBox()
  self:ResolveScaleBoxChain()
  self:ResetContainerLayers()
  local ScaleBox = self.ScaleBoxWidget
  if IsValid(ScaleBox) and ScaleBox.SetStretch then
    local Stretch = GetEnumNumber(function()
      return UE4.EStretch.ScaleToFill
    end)
    if Stretch then
      ScaleBox:SetStretch(Stretch)
    end
    if ScaleBox.SetStretchDirection then
      local Both = GetEnumNumber(function()
        return UE4.EStretchDirection.Both
      end)
      if Both then
        ScaleBox:SetStretchDirection(Both)
      end
    end
  end
  local SizeBox = self.SizeBoxWidget
  if IsValid(SizeBox) then
    if SizeBox.SetWidthOverride then
      SizeBox:SetWidthOverride(AdaptiveBoxWidth)
    end
    if SizeBox.SetHeightOverride then
      SizeBox:SetHeightOverride(AdaptiveBoxHeight)
    end
  end
end

function M:HideResidualLayers()
  self:ResetContainerLayers()
  for _, Widget in ipairs(self:GetResidualWidgets()) do
    if IsValid(Widget) then
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  local Black = self.BlackBg
  if not IsValid(Black) then
    Black = self:FindNamedWidget("BGBlack")
    self.BlackBg = Black
  end
  if IsValid(Black) then
    Black:SetRenderOpacity(1)
    if Black.SetColorAndOpacity and UE4 and UE4.FLinearColor then
      Black:SetColorAndOpacity(UE4.FLinearColor(0, 0, 0, 1))
    end
    Black:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:StopLeftoverUMGAnims()
  if self.In then
    self:StopAnimation(self.In)
  end
  if self.Loop then
    self:StopAnimation(self.Loop)
  end
end

function M:HoldResidualHidden()
  self:StopLeftoverUMGAnims()
  self:HideResidualLayers()
  self:EnforceBgInputState()
end

function M:ShowStaticBg()
  self:StopVideoPlayer(self.InVideoPlayer)
  if self.LoopVideoPlayer ~= self.InVideoPlayer then
    self:StopVideoPlayer(self.LoopVideoPlayer)
  end
  self:ResetContainerLayers()
  local BgPanel = self:FindNamedWidget("Bg")
  if IsValid(BgPanel) then
    BgPanel:SetRenderOpacity(1)
    BgPanel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  local StaticBg = self.StaticBg
  if not IsValid(StaticBg) then
    StaticBg = self:FindNamedWidget("Image_BG")
    self.StaticBg = StaticBg
  end
  if IsValid(StaticBg) then
    StaticBg:SetRenderOpacity(1)
    StaticBg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
  end
end

function M:PlayMediaOnPlayer(VideoPlayer, MediaPath, bLoop, EndCallback)
  if not IsValid(VideoPlayer) then
    return false
  end
  local MediaSource = GetMediaSource(MediaPath)
  if not IsValid(MediaSource) then
    return false
  end
  self:ClosePlayerMedia(VideoPlayer)
  self:PreparePlayer(VideoPlayer)
  self:ClearPlayEndBind(VideoPlayer)
  if EndCallback and VideoPlayer.BindEventToMediaPlayEnd then
    VideoPlayer:BindEventToMediaPlayEnd(self, EndCallback)
  end
  if VideoPlayer.SetLooping then
    VideoPlayer:SetLooping(bLoop and true or false)
  end
  if VideoPlayer.CancelPauseOnFirstFrame then
    VideoPlayer:CancelPauseOnFirstFrame()
  end
  VideoPlayer:SetUrlByMediaSource(MediaSource)
  local bPlayed = true
  if VideoPlayer.Play then
    bPlayed = VideoPlayer:Play()
  end
  if true ~= bPlayed then
    return false
  end
  return true
end

function M:ClosePlayerMedia(VideoPlayer)
  if not IsValid(VideoPlayer) then
    return
  end
  ClearCachedDuration(VideoPlayer)
  SetPlayerFramePresented(VideoPlayer, false)
  local MediaPlayer = VideoPlayer.MediaPlayer
  if IsValid(MediaPlayer) and MediaPlayer.Close then
    MediaPlayer:Close()
  end
end

function M:PlayLoopOnPlayer(VideoPlayer, EndCallback)
  return self:PlayMediaOnPlayer(VideoPlayer, self:GetMediaPath("Loop"), false, EndCallback)
end

function M:ResetLoopPingPongState()
  self.bLoopPingPong = false
  self.bStandbyPreheated = false
  self.bPrerollStarted = false
  self.bLoopSwapping = false
  self.LoopRetryCount = 0
  self.LoopRetryStart = nil
  if self.RemoveTimer then
    self:RemoveTimer(LoopSwapAbortTimerKey)
  end
  self.ActiveLoopPlayer = nil
  self.StandbyLoopPlayer = nil
  self.LoopTailFailTick = 0
  self.bLoopTailUnsupported = false
  self.RecoverStep = 0
  self.RecoverMode = nil
  self.SwapActive = nil
  self.SwapStandby = nil
  self.bLoopTailSwitchArmed = false
end

function M:CancelLoopPreheat()
  if not self.RemoveTimer then
    return
  end
  self:RemoveTimer(LoopPreheatTimerKey)
  self:RemoveTimer(LoopReadyTimerKey)
end

function M:PlayJumpBGVideo()
  self:StopLeftoverUMGAnims()
  self:ResetContainerLayers()
  self:EnforceBgInputState()
  local bFirstOpenToday = self:IsFirstOpenToday()
  if not self:ResolveVideoPlayers() then
    self:ShowStaticBg()
    return
  end
  local Token = self.PlayToken
  local InSuffix = bFirstOpenToday and "In1" or "In2"
  local InPath = self:GetMediaPath(InSuffix)
  self.InEndToken = Token
  self.bLoopSwitching = false
  self.bInTailUnsupported = false
  self.bLoopPreheated = false
  self:ResetTailFailWindow("InTailFailStart", "InTailFailTick")
  self:StopProgressWatch()
  self:ResetLoopPingPongState()
  if not self:PlayMediaOnPlayer(self.InVideoPlayer, InPath, false, self.OnInVideoEnd) then
    if self.LoopVideoPlayer ~= self.InVideoPlayer then
      if self:PlayLoopOnPlayer(self.LoopVideoPlayer, self.OnPingPongLoopEnd) then
        self:WaitFirstFrame(self.LoopVideoPlayer, LoopGateTimerKey, Token, function(Owner)
          if Owner.PlayToken ~= Token then
            return
          end
          Owner:ShowPlayerWidget(Owner.LoopVideoPlayer)
          Owner:StartLoopPingPong(Owner.LoopVideoPlayer, Owner.InVideoPlayer)
          Owner:StartProgressWatch(Owner.LoopVideoPlayer, "loop")
        end, self.HoldResidualHidden)
      else
        self:ShowStaticBg()
      end
    elseif self:PlayMediaOnPlayer(self.InVideoPlayer, self:GetMediaPath("Loop"), true, nil) then
      self:WaitFirstFrame(self.InVideoPlayer, LoopGateTimerKey, Token, function(Owner)
        if Owner.PlayToken ~= Token then
          return
        end
        Owner:ShowPlayerWidget(Owner.InVideoPlayer)
        Owner:StartProgressWatch(Owner.InVideoPlayer, "loop")
      end, self.HoldResidualHidden)
    else
      self:ShowStaticBg()
    end
    return
  end
  self:WaitFirstFrame(self.InVideoPlayer, InGateTimerKey, Token, function(Owner, bHit)
    if Owner.PlayToken ~= Token then
      return
    end
    Owner:ShowPlayerWidget(Owner.InVideoPlayer)
    if bFirstOpenToday and bHit then
      Owner:MarkOpenedToday()
    end
  end, self.HoldResidualHidden)
  self:StartProgressWatch(self.InVideoPlayer, "in")
  if self.LoopVideoPlayer ~= self.InVideoPlayer and self.AddTimer then
    self:AddTimer(LoopPreheatDelay, function(Owner)
      if Owner.PlayToken == Token then
        Owner:PreheatLoopVideo(Token)
      end
    end, false, 0, LoopPreheatTimerKey, true)
  end
  self:StartWaitInTail()
end

function M:WaitFirstFrame(VideoPlayer, TimerKey, Token, Callback, TickFunc, OnAbort)
  if not IsValid(VideoPlayer) or not self.AddTimer then
    if Callback and self.PlayToken == Token then
      Callback(self, false)
    end
    return
  end
  self.GateState = self.GateState or {}
  self.GateState[TimerKey] = {
    Hit = 0,
    Tick = 0,
    PlayTick = 0,
    Start = self:GetRealSeconds() or false
  }
  self:AddTimer(FrameGateInterval, function(Owner)
    local State = Owner.GateState and Owner.GateState[TimerKey]
    if not State or Owner.PlayToken ~= Token or not IsValid(VideoPlayer) then
      Owner:RemoveTimer(TimerKey)
      Owner:NotifyFirstFrameGateAborted(VideoPlayer, Token, OnAbort)
      return
    end
    if TickFunc then
      TickFunc(Owner)
    end
    State.Tick = State.Tick + 1
    local MediaPlayer = VideoPlayer.MediaPlayer
    local Seconds = GetPlayedSeconds(MediaPlayer)
    local bHit
    if Seconds then
      State.Hit = Seconds > 0 and State.Hit + 1 or 0
      bHit = State.Hit >= FrameGateSteadyTick
    else
      if IsValid(MediaPlayer) and MediaPlayer.IsPlaying and MediaPlayer:IsPlaying() then
        State.PlayTick = State.PlayTick + 1
      end
      bHit = State.PlayTick >= FrameGatePlayingTick
    end
    if bHit or Owner:IsWaitExpired(State.Start or nil, FrameGateMaxSeconds, State.Tick) then
      Owner:RemoveTimer(TimerKey)
      Owner.GateState[TimerKey] = nil
      if Callback then
        Callback(Owner, bHit)
      end
    end
  end, true, 0, TimerKey, true)
end

function M:NotifyFirstFrameGateAborted(VideoPlayer, Token, OnAbort)
  if OnAbort then
    OnAbort(self, Token)
    return
  end
  if self.PlayToken ~= Token then
    return
  end
  if VideoPlayer == self.ActiveLoopPlayer or VideoPlayer == self.InVideoPlayer then
    self:RecoverLoopWithNativeLooping(self:GetLoopRecoverTarget())
  end
end

function M:PreheatLoopVideo(Token)
  local LoopPlayer = self.LoopVideoPlayer
  if not IsValid(LoopPlayer) or LoopPlayer == self.InVideoPlayer then
    return
  end
  SetPlayerFramePresented(LoopPlayer, false)
  self.bPrerollStarted = false
  if not self:PlayLoopOnPlayer(LoopPlayer, nil) then
    return
  end
  self:SetPlayerSurfacePrewarm(LoopPlayer)
  self:WaitLoopPlayerReady(LoopPlayer, Token, function(Owner)
    Owner.bLoopPreheated = true
  end)
end

function M:CheckLoopPlayerReady(VideoPlayer, Presented)
  local MediaPlayer = IsValid(VideoPlayer) and VideoPlayer.MediaPlayer or nil
  if not IsValid(MediaPlayer) then
    return Presented, false
  end
  local Seconds = GetPlayedSeconds(MediaPlayer)
  if nil == Seconds then
    if MediaPlayer.IsPlaying and MediaPlayer:IsPlaying() then
      Presented = true
    end
  elseif Seconds > 0 then
    Presented = true
  end
  local bReady = Presented and MediaPlayer.IsReady and MediaPlayer:IsReady() and MediaPlayer.IsPlaying and not MediaPlayer:IsPlaying()
  return Presented, bReady
end

function M:PauseAtPreheatHead(VideoPlayer)
  local MediaPlayer = IsValid(VideoPlayer) and VideoPlayer.MediaPlayer or nil
  if not (IsValid(MediaPlayer) and MediaPlayer.IsPlaying) or not MediaPlayer:IsPlaying() then
    return false
  end
  local Played = GetPlayedSeconds(MediaPlayer)
  if not Played or Played <= 0 then
    return false
  end
  if Played > StandbyPresentingMaxSeconds then
    self:ForceRewindPause(VideoPlayer)
    return true
  end
  MediaPlayer:Pause()
  return true
end

function M:ForceRewindPause(VideoPlayer)
  local MediaPlayer = IsValid(VideoPlayer) and VideoPlayer.MediaPlayer or nil
  if not IsValid(MediaPlayer) then
    return
  end
  if MediaPlayer.Rewind then
    MediaPlayer:Rewind()
  end
  if MediaPlayer.IsPlaying and MediaPlayer:IsPlaying() then
    MediaPlayer:Pause()
  end
end

function M:WaitLoopPlayerReady(VideoPlayer, Token, OnReady)
  if not self.AddTimer then
    return
  end
  self.LoopReadyTick = 0
  SetPlayerFramePresented(VideoPlayer, false)
  local StartTime = self:GetRealSeconds() or false
  self.LoopPauseIssuedTime = nil
  self:AddTimer(LoopReadyInterval, function(Owner)
    if Owner.PlayToken ~= Token then
      Owner:RemoveTimer(LoopReadyTimerKey)
      return
    end
    Owner.LoopReadyTick = (Owner.LoopReadyTick or 0) + 1
    local Now = Owner:GetRealSeconds()
    local LastPause = Owner.LoopPauseIssuedTime
    local bCooldownPassed = not LastPause or not Now or Now - LastPause >= PauseRetryCooldownSeconds
    if bCooldownPassed and Owner:PauseAtPreheatHead(VideoPlayer) then
      Owner.LoopPauseIssuedTime = Now
    end
    local bReady
    local Presented = IsPlayerFramePresented(VideoPlayer)
    Presented, bReady = Owner:CheckLoopPlayerReady(VideoPlayer, Presented)
    SetPlayerFramePresented(VideoPlayer, Presented)
    if bReady then
      Owner:RemoveTimer(LoopReadyTimerKey)
      if OnReady then
        OnReady(Owner)
      end
    elseif Owner:IsWaitExpired(StartTime or nil, LoopReadyMaxSeconds, Owner.LoopReadyTick) then
      Owner:RemoveTimer(LoopReadyTimerKey)
      Owner:ForceRewindPause(VideoPlayer)
    end
  end, true, 0, LoopReadyTimerKey, true)
end

function M:IsNearMediaTail(VideoPlayer, MediaPlayer, Seconds)
  if not Seconds then
    return false
  end
  local TotalDuration = GetCachedDuration(VideoPlayer, MediaPlayer)
  if not TotalDuration or TotalDuration <= 0 then
    return false
  end
  return TotalDuration - Seconds <= self:GetVideoAdvanceTime()
end

function M:TickTailFailWindow(StartField, TickField)
  if nil == self[StartField] then
    self[StartField] = self:GetRealSeconds() or false
  end
  self[TickField] = (self[TickField] or 0) + 1
  return self:IsWaitExpired(self[StartField] or nil, InTailMaxFailSeconds, self[TickField])
end

function M:ResetTailFailWindow(StartField, TickField)
  self[StartField] = nil
  self[TickField] = 0
end

function M:ScheduleTailSwitch(SwitchKey, Remain, Advance, SwitchFunc, Trigger, ReadyCheck, OnMiss)
  if not self.AddTimer then
    return
  end
  local Wait = Remain - Advance
  if Wait <= 0 then
    return
  end
  local Token = self.PlayToken
  self:AddTimer(Wait, function(Owner)
    if Owner.PlayToken ~= Token then
      return
    end
    if ReadyCheck and not ReadyCheck(Owner) then
      if OnMiss then
        OnMiss(Owner)
      else
        Owner:RearmTailPollAfterFailedSwitch()
      end
      return
    end
    Owner:RemoveTimer(InTailTimerKey)
    Owner:RemoveTimer(LoopTailTimerKey)
    Owner:RemoveTimer(SwitchKey)
    SwitchFunc(Owner, Trigger)
  end, false, 0, SwitchKey, true)
end

function M:IsLoopSwapReady()
  if not self.bLoopPingPong or self.bLoopSwapping then
    return false
  end
  if self.PlayToken ~= self.InEndToken then
    return false
  end
  local Active = self.ActiveLoopPlayer
  local Standby = self.StandbyLoopPlayer
  if not (IsValid(Active) and IsValid(Standby)) or Active == Standby then
    return false
  end
  return true
end

function M:IsInToLoopSwapReady()
  if self.bLoopSwitching then
    return false
  end
  if self.PlayToken ~= self.InEndToken then
    return false
  end
  if not IsValid(self.LoopVideoPlayer) or not IsValid(self.InVideoPlayer) then
    return false
  end
  return true
end

function M:RearmInTailPollAfterMissedSwitch()
  if self.PlayToken ~= self.InEndToken or self.bLoopSwitching or not self.AddTimer then
    return
  end
  self:StartWaitInTail()
end

function M:RearmTailPollAfterFailedSwitch()
  if self.PlayToken ~= self.InEndToken or not self.bLoopPingPong then
    return
  end
  if self.bLoopSwitching then
    return
  end
  self:StartWaitLoopTail()
end

function M:ArmTailCorrectPoll(ArmedField, PollFunc, PollKey)
  if self[ArmedField] or not self.AddTimer then
    return
  end
  self[ArmedField] = true
  self:AddTimer(TailCorrectInterval, PollFunc, true, 0, PollKey, true)
end

function M:StartProgressWatch(VideoPlayer, Mode)
  if not self.AddTimer or not IsValid(VideoPlayer) then
    return
  end
  self.ProgressWatchPlayer = VideoPlayer
  self.ProgressWatchMode = Mode or "loop"
  self.ProgressWatchLast = nil
  self.ProgressWatchIdle = 0
  self.bProgressWatchAdvanced = false
  self:AddTimer(ProgressWatchInterval, self.CheckProgressWatch, true, 0, ProgressWatchTimerKey, true)
end

function M:StopProgressWatch()
  self.ProgressWatchPlayer = nil
  self.ProgressWatchMode = nil
  self.ProgressWatchLast = nil
  self.ProgressWatchIdle = 0
  self.bProgressWatchAdvanced = false
  if self.RemoveTimer then
    self:RemoveTimer(ProgressWatchTimerKey)
  end
end

function M:GetProgressStallLimit()
  if self.bProgressWatchAdvanced then
    return ProgressStallSeconds
  end
  return ProgressOpenStallSeconds
end

function M:CheckProgressWatch()
  local VideoPlayer = self.ProgressWatchPlayer
  if not IsValid(VideoPlayer) or self.PlayToken ~= self.InEndToken then
    self:StopProgressWatch()
    return
  end
  if self.bLoopSwapping then
    self.ProgressWatchIdle = 0
    return
  end
  local MediaPlayer = VideoPlayer.MediaPlayer
  local Seconds = GetPlayedSeconds(MediaPlayer)
  if nil == Seconds then
    self.ProgressWatchIdle = (self.ProgressWatchIdle or 0) + ProgressWatchInterval
    if self.ProgressWatchIdle < ProgressOpenStallSeconds then
      return
    end
    local Mode = self.ProgressWatchMode
    self:StopProgressWatch()
    self:RecoverStalledPlayer(VideoPlayer, Mode)
    return
  end
  local Last = self.ProgressWatchLast
  if Last and Seconds > Last + 0.001 then
    self.ProgressWatchLast = Seconds
    self.ProgressWatchIdle = 0
    self.bProgressWatchAdvanced = true
    return
  end
  self.ProgressWatchLast = Seconds
  if self:IsNearMediaTail(VideoPlayer, MediaPlayer, Seconds) then
    self.ProgressWatchIdle = 0
    return
  end
  self.ProgressWatchIdle = (self.ProgressWatchIdle or 0) + ProgressWatchInterval
  local Limit = self:GetProgressStallLimit()
  if Limit > self.ProgressWatchIdle then
    return
  end
  local Mode = self.ProgressWatchMode
  self:StopProgressWatch()
  self:RecoverStalledPlayer(VideoPlayer, Mode)
end

function M:RecoverStalledPlayer(VideoPlayer, Mode)
  if self.PlayToken ~= self.InEndToken then
    return
  end
  if self.RecoverMode ~= Mode then
    self.RecoverMode = Mode
    self.RecoverStep = 0
  end
  self.RecoverStep = (self.RecoverStep or 0) + 1
  if "in" == Mode then
    self:SwitchToLoopVideo("stall")
    return
  end
  if "last" == Mode then
    self:StopLeftoverUMGAnims()
    self:ShowStaticBg()
    return
  end
  if self.RecoverStep <= 1 and IsValid(VideoPlayer) and IsValid(VideoPlayer.MediaPlayer) then
    if VideoPlayer.CancelPauseOnFirstFrame then
      VideoPlayer:CancelPauseOnFirstFrame()
    end
    VideoPlayer.MediaPlayer:Play()
    self:StartProgressWatch(VideoPlayer, "loop")
    return
  end
  if 2 == self.RecoverStep and VideoPlayer == self.ActiveLoopPlayer and self:PlayLoopOnPlayer(VideoPlayer, self.OnPingPongLoopEnd) then
    local Token = self.PlayToken
    self:SetPlayerFramePresented(VideoPlayer, false)
    self.bLoopSwapping = true
    if self.RemoveTimer then
      self:RemoveTimer(LoopTailTimerKey)
      self:RemoveTimer(LoopTailSwitchTimerKey)
    end
    self:WaitFirstFrame(VideoPlayer, LoopGateRecoverTimerKey, Token, function(Owner, bHit)
      Owner:FinishRecoverReopenGate(VideoPlayer, Token, bHit)
    end, nil, function(Owner)
      Owner:FinishRecoverReopenGate(VideoPlayer, Token, false, true)
    end)
    return
  end
  self:RecoverLoopWithNativeLooping(VideoPlayer)
end

function M:RecoverLoopWithNativeLooping(VideoPlayer)
  self.bLoopPingPong = false
  self.bLoopSwapping = false
  self.SwapActive = nil
  self.SwapStandby = nil
  self:StopProgressWatch()
  self:CancelLoopPreheat()
  self:StopWaitWindowCover()
  if self.RemoveTimer then
    self:RemoveTimer(LoopTailTimerKey)
    self:RemoveTimer(LoopTailSwitchTimerKey)
    self:RemoveTimer(SwapWaitTimerKey)
    self:RemoveTimer(WaitCoverTimerKey)
  end
  if not IsValid(VideoPlayer) or not IsValid(VideoPlayer.MediaPlayer) then
    self:ShowStaticBg()
    return
  end
  if VideoPlayer.CancelPauseOnFirstFrame then
    VideoPlayer:CancelPauseOnFirstFrame()
  end
  if VideoPlayer.SetLooping then
    VideoPlayer:SetLooping(true)
  end
  VideoPlayer.MediaPlayer:Rewind()
  VideoPlayer.MediaPlayer:Play()
  self:ShowPlayerWidget(VideoPlayer)
  if IsValid(self.StandbyLoopPlayer) and self.StandbyLoopPlayer ~= VideoPlayer then
    self:StopVideoPlayer(self.StandbyLoopPlayer)
  end
  self:StartProgressWatch(VideoPlayer, "last")
end

function M:GetLoopRecoverTarget()
  if IsValid(self.ActiveLoopPlayer) then
    return self.ActiveLoopPlayer
  end
  if IsValid(self.LoopVideoPlayer) then
    return self.LoopVideoPlayer
  end
  return nil
end

function M:StartWaitInTail()
  if not self.AddTimer then
    return
  end
  self.LastPollTime = nil
  self.bInTailSwitchArmed = false
  self:ResetTailFailWindow("InTailFailStart", "InTailFailTick")
  if self.RemoveTimer then
    self:RemoveTimer(InTailSwitchTimerKey)
  end
  self:AddTimer(InTailInterval, self.CheckInTail, true, 0, InTailTimerKey, true)
end

function M:CheckInTail()
  if self.PlayToken ~= self.InEndToken then
    if self.RemoveTimer then
      self:RemoveTimer(InTailTimerKey)
      self:RemoveTimer(InTailSwitchTimerKey)
    end
    return
  end
  if self.bLoopSwitching then
    if self.RemoveTimer then
      self:RemoveTimer(InTailTimerKey)
      self:RemoveTimer(InTailSwitchTimerKey)
    end
    return
  end
  self:UpdatePollDelta()
  local InPlayer = self.InVideoPlayer
  local MediaPlayer = IsValid(InPlayer) and InPlayer.MediaPlayer or nil
  local Played = GetPlayedSeconds(MediaPlayer)
  local TotalDuration = Played and GetCachedDuration(InPlayer, MediaPlayer) or nil
  if Played and TotalDuration then
    self:ResetTailFailWindow("InTailFailStart", "InTailFailTick")
    local Remain = TotalDuration - Played
    local Advance = self:GetVideoAdvanceTime()
    if PrerollSeconds > 0 and self.bLoopPreheated and Remain <= PrerollSeconds + Advance then
      self:StartPreroll(self.LoopVideoPlayer)
    end
    if TotalDuration > 0 and Remain <= Advance then
      if self.RemoveTimer then
        self:RemoveTimer(InTailTimerKey)
        self:RemoveTimer(InTailSwitchTimerKey)
      end
      self:SwitchToLoopVideo()
      return
    end
    self:ScheduleTailSwitch(InTailSwitchTimerKey, Remain, Advance, self.SwitchToLoopVideo, nil, self.IsInToLoopSwapReady, self.RearmInTailPollAfterMissedSwitch)
    self:ArmTailCorrectPoll("bInTailSwitchArmed", self.CheckInTail, InTailTimerKey)
  elseif self:TickTailFailWindow("InTailFailStart", "InTailFailTick") and not self.bInTailUnsupported then
    self.bInTailUnsupported = true
    if self.RemoveTimer then
      self:RemoveTimer(InTailTimerKey)
      self:RemoveTimer(InTailSwitchTimerKey)
    end
  end
end

function M:SwitchToLoopVideo(Trigger)
  if self.bLoopSwitching then
    return
  end
  self.bLoopSwitching = true
  local bPreheating = false
  if self.IsExistTimer then
    bPreheating = self:IsExistTimer(LoopPreheatTimerKey) or self:IsExistTimer(LoopReadyTimerKey)
  end
  self:StopProgressWatch()
  self:StopWaitWindowCover()
  if self.RemoveTimer then
    self:RemoveTimer(InTailTimerKey)
    self:RemoveTimer(InTailSwitchTimerKey)
    self:RemoveTimer(InGateTimerKey)
  end
  if self.GateState then
    self.GateState[InGateTimerKey] = nil
  end
  local InPlayer = self.InVideoPlayer
  local LoopPlayer = self.LoopVideoPlayer
  local Token = self.PlayToken
  if LoopPlayer == InPlayer then
    self:CancelLoopPreheat()
    if not self:PlayMediaOnPlayer(InPlayer, self:GetMediaPath("Loop"), true, nil) then
      self:ShowStaticBg()
      return
    end
    self:WaitFirstFrame(InPlayer, LoopGateTimerKey, Token, function(Owner)
      if Owner.PlayToken ~= Token then
        return
      end
      Owner:ShowPlayerWidget(Owner.InVideoPlayer)
      Owner:StartProgressWatch(Owner.InVideoPlayer, "loop")
    end)
    return
  end
  if self.bLoopPreheated then
    self:CancelLoopPreheat()
    if self:ResumePreheatedLoop(LoopPlayer, InPlayer) then
      return
    end
    bPreheating = false
  end
  if bPreheating then
    self:WaitLoopPreheatThenSwitch(LoopPlayer, InPlayer, self.PlayToken)
    return
  end
  self:CancelLoopPreheat()
  local Presented, bLoopReady = self:CheckLoopPlayerReady(LoopPlayer, IsPlayerFramePresented(LoopPlayer))
  SetPlayerFramePresented(LoopPlayer, Presented)
  if (bLoopReady or self:IsPlayerPresenting(LoopPlayer)) and self:ResumePreheatedLoop(LoopPlayer, InPlayer) then
    return
  end
  self:ReopenLoopAndSwitch(LoopPlayer, InPlayer, self.PlayToken)
end

function M:ResumePreheatedLoop(LoopPlayer, InPlayer)
  local MediaPlayer = IsValid(LoopPlayer) and LoopPlayer.MediaPlayer or nil
  if not IsValid(MediaPlayer) then
    return false
  end
  if LoopPlayer.BindEventToMediaPlayEnd then
    LoopPlayer:BindEventToMediaPlayEnd(self, self.OnPingPongLoopEnd)
  end
  if LoopPlayer.CancelPauseOnFirstFrame then
    LoopPlayer:CancelPauseOnFirstFrame()
  end
  rawset(LoopPlayer, "bShouldPauseOnFirstFrame", false)
  MediaPlayer:Play()
  self:ShowPlayerWidget(LoopPlayer)
  self:StopWaitWindowCover()
  self:DimPlayerWidget(InPlayer)
  self:StartLoopPingPong(LoopPlayer, InPlayer)
  self:StartProgressWatch(LoopPlayer, "loop")
  return true
end

function M:ReopenLoopAndSwitch(LoopPlayer, InPlayer, Token)
  self:StopWaitWindowCover()
  self:SetPlayerFramePresented(LoopPlayer, false)
  if not self:PlayLoopOnPlayer(LoopPlayer, self.OnPingPongLoopEnd) then
    if self.RemoveTimer then
      self:RemoveTimer(LoopSwapAbortTimerKey)
    end
    self:StopVideoPlayer(InPlayer)
    self:ShowStaticBg()
    return
  end
  self:LaunchLoopSwapAbortWatch(Token, nil)
  self:WaitFirstFrame(LoopPlayer, LoopGateTimerKey, Token, function(Owner)
    if Owner.PlayToken ~= Token then
      return
    end
    Owner:StopLoopSwapAbortWatch()
    Owner:ShowPlayerWidget(Owner.LoopVideoPlayer)
    Owner:DimPlayerWidget(Owner.InVideoPlayer)
    Owner:StartLoopPingPong(Owner.LoopVideoPlayer, Owner.InVideoPlayer)
    Owner:StartProgressWatch(Owner.LoopVideoPlayer, "loop")
  end, nil, function(Owner, AbortToken)
    Owner:OnReopenLoopGateAbort(AbortToken)
  end)
end

function M:OnReopenLoopGateAbort(Token)
  if self.PlayToken ~= Token then
    return
  end
  self:StopLoopSwapAbortWatch()
  self:SwitchToLoopVideoAbortGuard()
end

function M:SwitchToLoopVideoAbortGuard()
  local LoopPlayer = self.LoopVideoPlayer
  local InPlayer = self.InVideoPlayer
  if self.bLoopPreheated and IsValid(LoopPlayer) and IsValid(LoopPlayer.MediaPlayer) and self:ResumePreheatedLoop(LoopPlayer, InPlayer) then
    self.LoopRetryCount = 0
    self.LoopRetryStart = nil
    return
  end
  if self.LoopRetryStart == nil then
    self.LoopRetryStart = self:GetRealSeconds() or false
    self.LoopRetryCount = 0
  end
  self.LoopRetryCount = (self.LoopRetryCount or 0) + 1
  if self.LoopRetryCount > LoopRetryMax or self:IsWaitExpired(self.LoopRetryStart or nil, SwapAbortMaxSeconds, self.LoopRetryCount) then
    self.LoopRetryStart = nil
    self.LoopRetryCount = 0
    self:RecoverLoopWithNativeLooping(self:GetLoopRecoverTarget())
    return
  end
  self:ReopenLoopAndSwitch(LoopPlayer, InPlayer, self.PlayToken)
end

function M:LaunchLoopSwapAbortWatch(Token, OnVerdict)
  if not self.AddTimer then
    return
  end
  local Ticks = 0
  local StartTime = self:GetRealSeconds() or false
  local AbortPlayer = self.StandbyLoopPlayer
  self:AddTimer(SwapAbortPollInterval, function(Owner)
    Ticks = Ticks + 1
    if Owner.PlayToken ~= Token then
      Owner:RemoveTimer(LoopSwapAbortTimerKey)
      return
    end
    if not Owner:IsWaitExpired(StartTime or nil, SwapAbortMaxSeconds, Ticks) then
      return
    end
    Owner:RemoveTimer(LoopSwapAbortTimerKey)
    if OnVerdict then
      OnVerdict(Owner)
      return
    end
    if not Owner.bLoopSwapping and Owner.ActiveLoopPlayer == AbortPlayer then
      return
    end
    local LoopPlayer = Owner.LoopVideoPlayer
    if Owner.bLoopPreheated and IsValid(LoopPlayer) and IsValid(LoopPlayer.MediaPlayer) and Owner:ResumePreheatedLoop(LoopPlayer, Owner.InVideoPlayer) then
      return
    end
    Owner:RecoverLoopWithNativeLooping(Owner:GetLoopRecoverTarget())
  end, true, 0, LoopSwapAbortTimerKey, true)
end

function M:StopLoopSwapAbortWatch()
  if self.RemoveTimer then
    self:RemoveTimer(LoopSwapAbortTimerKey)
  end
end

function M:FinishRecoverReopenGate(VideoPlayer, Token, bHit)
  if self.PlayToken ~= Token then
    return
  end
  self.bLoopSwapping = false
  self:ShowPlayerWidget(VideoPlayer)
  self:StartProgressWatch(VideoPlayer, "loop")
  if self.bLoopPingPong then
    self:StartWaitLoopTail()
  end
end

function M:WaitLoopPreheatThenSwitch(LoopPlayer, InPlayer, Token)
  if not self.AddTimer then
    self:CancelLoopPreheat()
    self:ReopenLoopAndSwitch(LoopPlayer, InPlayer, Token)
    return
  end
  self:StartWaitWindowCover(InPlayer)
  local Ticks = 0
  local StartTime = self:GetRealSeconds() or false
  local Presented = IsPlayerFramePresented(LoopPlayer)
  self:AddTimer(LoopReadyInterval, function(Owner)
    Ticks = Ticks + 1
    if Owner.PlayToken ~= Token or not Owner.bLoopSwitching then
      Owner:RemoveTimer(SwapWaitTimerKey)
      Owner:StopWaitWindowCover()
      return
    end
    local bReady = Owner.bLoopPreheated
    if not bReady then
      Presented, bReady = Owner:CheckLoopPlayerReady(LoopPlayer, Presented)
      SetPlayerFramePresented(LoopPlayer, Presented)
    end
    if bReady then
      Owner:RemoveTimer(SwapWaitTimerKey)
      Owner:CancelLoopPreheat()
      if Owner:ResumePreheatedLoop(LoopPlayer, InPlayer) then
        return
      end
      Owner:ReopenLoopAndSwitch(LoopPlayer, InPlayer, Token)
      return
    end
    if Owner:IsWaitExpired(StartTime or nil, InSwitchWaitMaxSeconds, Ticks) then
      Owner:RemoveTimer(SwapWaitTimerKey)
      Owner:CancelLoopPreheat()
      Owner:ReopenLoopAndSwitch(LoopPlayer, InPlayer, Token)
    end
  end, true, 0, SwapWaitTimerKey, true)
end

function M:StartLoopPingPong(ActivePlayer, StandbyPlayer)
  if not (IsValid(ActivePlayer) and IsValid(StandbyPlayer)) or ActivePlayer == StandbyPlayer then
    return
  end
  self.bLoopPingPong = true
  self.ActiveLoopPlayer = ActivePlayer
  self.StandbyLoopPlayer = StandbyPlayer
  self.bStandbyPreheated = false
  self.bPrerollStarted = false
  self.bLoopSwapping = false
  self.LoopRetryCount = 0
  self.LoopRetryStart = nil
  self:ResetTailFailWindow("LoopTailFailStart", "LoopTailFailTick")
  self.bLoopTailUnsupported = false
  self.RecoverStep = 0
  self.RecoverMode = nil
  self:StopLeftoverUMGAnims()
  if not self.AddTimer then
    if ActivePlayer.SetLooping then
      ActivePlayer:SetLooping(true)
    end
    return
  end
  self:StartWaitLoopTail()
  local Token = self.PlayToken
  self:AddTimer(FirstStandbyPreheatDelay, function(Owner)
    if Owner.PlayToken == Token then
      Owner:PreheatStandbyLoop(Token)
    end
  end, false, 0, LoopPreheatTimerKey, true)
end

function M:PreheatStandbyLoop(Token)
  local Player = self.StandbyLoopPlayer
  if not IsValid(Player) or Player == self.ActiveLoopPlayer then
    return
  end
  self.bStandbyPreheated = false
  SetPlayerFramePresented(Player, false)
  self.bPrerollStarted = false
  if not self:PlayLoopOnPlayer(Player, nil) then
    return
  end
  self:SetPlayerSurfacePrewarm(Player)
  self:WaitLoopPlayerReady(Player, Token, function(Owner)
    if Owner.StandbyLoopPlayer ~= Player then
      return
    end
    Owner.bStandbyPreheated = true
  end)
end

function M:StartWaitLoopTail()
  if not self.AddTimer then
    return
  end
  self.LastPollTime = nil
  self.bLoopTailSwitchArmed = false
  self:ResetTailFailWindow("LoopTailFailStart", "LoopTailFailTick")
  if self.RemoveTimer then
    self:RemoveTimer(LoopTailSwitchTimerKey)
  end
  self:AddTimer(InTailInterval, self.CheckLoopTail, true, 0, LoopTailTimerKey, true)
end

function M:CheckLoopTail()
  if self.PlayToken ~= self.InEndToken or not self.bLoopPingPong then
    if self.RemoveTimer then
      self:RemoveTimer(LoopTailTimerKey)
      self:RemoveTimer(LoopTailSwitchTimerKey)
    end
    return
  end
  if self.bLoopSwapping then
    return
  end
  self:UpdatePollDelta()
  local ActivePlayer = self.ActiveLoopPlayer
  local MediaPlayer = IsValid(ActivePlayer) and ActivePlayer.MediaPlayer or nil
  local Played = GetPlayedSeconds(MediaPlayer)
  local TotalDuration = Played and GetCachedDuration(ActivePlayer, MediaPlayer) or nil
  if Played and TotalDuration then
    self:ResetTailFailWindow("LoopTailFailStart", "LoopTailFailTick")
    local Remain = TotalDuration - Played
    local Advance = self:GetVideoAdvanceTime()
    if PrerollSeconds > 0 and self.bStandbyPreheated and Remain <= PrerollSeconds + Advance then
      self:StartPreroll(self.StandbyLoopPlayer)
    end
    if TotalDuration > 0 and Remain <= Advance then
      if not self:IsLoopSwapReady() then
        self:RearmTailPollAfterFailedSwitch()
        return
      end
      if self.RemoveTimer then
        self:RemoveTimer(LoopTailTimerKey)
        self:RemoveTimer(LoopTailSwitchTimerKey)
      end
      self:SwapLoopPlayers("tail")
      return
    end
    self:ScheduleTailSwitch(LoopTailSwitchTimerKey, Remain, Advance, self.SwapLoopPlayers, "tail", self.IsLoopSwapReady)
    self:ArmTailCorrectPoll("bLoopTailSwitchArmed", self.CheckLoopTail, LoopTailTimerKey)
  elseif self:TickTailFailWindow("LoopTailFailStart", "LoopTailFailTick") and not self.bLoopTailUnsupported then
    self.bLoopTailUnsupported = true
    if self.RemoveTimer then
      self:RemoveTimer(LoopTailTimerKey)
      self:RemoveTimer(LoopTailSwitchTimerKey)
    end
  end
end

function M:SwapLoopPlayers(Trigger)
  if not self.bLoopPingPong or self.bLoopSwapping then
    return
  end
  if self.PlayToken ~= self.InEndToken then
    return
  end
  local Active = self.ActiveLoopPlayer
  local Standby = self.StandbyLoopPlayer
  if not (IsValid(Active) and IsValid(Standby)) or Active == Standby then
    self:RecoverLoopWithNativeLooping(Active)
    return
  end
  local bPreheating = false
  if self.IsExistTimer then
    bPreheating = self:IsExistTimer(LoopPreheatTimerKey) or self:IsExistTimer(LoopReadyTimerKey)
  end
  self.bLoopSwapping = true
  self:StopProgressWatch()
  if self.RemoveTimer then
    self:RemoveTimer(LoopTailTimerKey)
    self:RemoveTimer(LoopTailSwitchTimerKey)
    self:RemoveTimer(LoopGateTimerKey)
    self:RemoveTimer(LoopGateSwapTimerKey)
    self:RemoveTimer(LoopGateRecoverTimerKey)
    self:RemoveTimer(SwapWaitTimerKey)
  end
  if self.bStandbyPreheated or not bPreheating then
    self:CancelLoopPreheat()
    bPreheating = false
  end
  self:ClearPlayEndBind(Active)
  local Token = self.PlayToken
  self.SwapActive = Active
  self.SwapStandby = Standby
  if self.bStandbyPreheated and IsValid(Standby.MediaPlayer) then
    self:FinishSwapOnPreheated(Standby, Token)
    return
  end
  local Presented, bReady = self:CheckLoopPlayerReady(Standby, IsPlayerFramePresented(Standby))
  SetPlayerFramePresented(Standby, Presented)
  if bReady then
    self:CancelLoopPreheat()
    self:FinishSwapOnPreheated(Standby, Token)
    return
  end
  if not bPreheating then
    self:SwapLoopFallback(Standby, Token)
    return
  end
  self:WaitStandbyPreheated(Standby, Token)
end

function M:FinishSwapOnPreheated(Standby, Token)
  local Active = self.SwapActive
  if self.PlayToken ~= Token then
    return
  end
  if not IsValid(Standby) or not IsValid(Active) then
    self.bLoopSwapping = false
    return
  end
  local MediaPlayer = Standby.MediaPlayer
  if not IsValid(MediaPlayer) then
    self:SwapLoopFallback(Standby, Token)
    return
  end
  if Standby.BindEventToMediaPlayEnd then
    Standby:BindEventToMediaPlayEnd(self, self.OnPingPongLoopEnd)
  end
  if Standby.CancelPauseOnFirstFrame then
    Standby:CancelPauseOnFirstFrame()
  end
  rawset(Standby, "bShouldPauseOnFirstFrame", false)
  MediaPlayer:Play()
  self:ShowPlayerWidget(Standby)
  self:DimPlayerWidget(Active)
  self:FinishLoopSwap(Standby, Active, Token)
end

function M:WaitStandbyPreheated(Standby, Token)
  if not self.AddTimer then
    self:SwapLoopFallback(Standby, Token)
    return
  end
  local Ticks = 0
  local StartTime = self:GetRealSeconds() or false
  local Presented = IsPlayerFramePresented(Standby)
  self:AddTimer(LoopReadyInterval, function(Owner)
    Ticks = Ticks + 1
    if Owner.PlayToken ~= Token or not Owner.bLoopSwapping then
      Owner:RemoveTimer(SwapWaitTimerKey)
      return
    end
    local bReady = Owner.bStandbyPreheated
    if not bReady then
      Presented, bReady = Owner:CheckLoopPlayerReady(Standby, Presented)
      SetPlayerFramePresented(Standby, Presented)
    end
    if bReady and IsValid(Standby) and IsValid(Standby.MediaPlayer) then
      Owner:RemoveTimer(SwapWaitTimerKey)
      Owner:CancelLoopPreheat()
      Owner:FinishSwapOnPreheated(Standby, Token)
      return
    end
    if Owner:IsWaitExpired(StartTime or nil, StandbyWaitMaxSeconds, Ticks) then
      Owner:RemoveTimer(SwapWaitTimerKey)
      Owner:CancelLoopPreheat()
      Owner:SwapLoopFallback(Standby, Token)
    end
  end, true, 0, SwapWaitTimerKey, true)
end

function M:IsPlayerPresenting(VideoPlayer)
  local MediaPlayer = IsValid(VideoPlayer) and VideoPlayer.MediaPlayer or nil
  if not IsValid(MediaPlayer) then
    return false
  end
  local Played = GetPlayedSeconds(MediaPlayer)
  if nil == Played then
    return MediaPlayer.IsPlaying and MediaPlayer:IsPlaying() and true or false
  end
  return Played > 0 and Played <= StandbyPresentingMaxSeconds
end

function M:StartWaitWindowCover(VideoPlayer)
  if not IsValid(VideoPlayer) or not self.AddTimer then
    return
  end
  self.WaitCoverPlayer = VideoPlayer
  self.WaitCoverTick = 0
  self.WaitCoverStartOpacity = VideoPlayer.GetRenderOpacity and VideoPlayer:GetRenderOpacity() or 1
  self:AddTimer(0.03, self.TickWaitWindowCover, true, 0, WaitCoverTimerKey, true)
end

function M:TickWaitWindowCover()
  local Player = self.WaitCoverPlayer
  if not IsValid(Player) then
    self:StopWaitWindowCover()
    return
  end
  self.WaitCoverTick = (self.WaitCoverTick or 0) + 1
  local Alpha = 1 - self.WaitCoverTick / 5
  if Alpha < 0 then
    Alpha = 0
  end
  Player:SetRenderOpacity((self.WaitCoverStartOpacity or 1) * Alpha)
  if Alpha <= 0 then
    self:StopWaitWindowCover()
  end
end

function M:StopWaitWindowCover()
  if self.RemoveTimer then
    self:RemoveTimer(WaitCoverTimerKey)
  end
  self.WaitCoverPlayer = nil
  self.WaitCoverTick = 0
end

function M:StartPreroll(VideoPlayer)
  if self.bPrerollStarted then
    return
  end
  local MediaPlayer = IsValid(VideoPlayer) and VideoPlayer.MediaPlayer or nil
  if not IsValid(MediaPlayer) then
    return
  end
  self.bPrerollStarted = true
  if VideoPlayer.CancelPauseOnFirstFrame then
    VideoPlayer:CancelPauseOnFirstFrame()
  end
  rawset(VideoPlayer, "bShouldPauseOnFirstFrame", false)
  MediaPlayer:Play()
end

function M:ShowFallbackSwap(Standby, Active, Token)
  self:ShowPlayerWidget(Standby)
  self:DimPlayerWidget(Active)
  self:FinishLoopSwap(Standby, Active, Token)
end

function M:SwapLoopFallback(Standby, Token)
  local Active = self.SwapActive
  if not IsValid(Standby) then
    self.bLoopSwapping = false
    self:RecoverLoopWithNativeLooping(Active)
    return
  end
  if self:IsPlayerPresenting(Standby) then
    local MediaPlayer = Standby.MediaPlayer
    if Standby.BindEventToMediaPlayEnd then
      Standby:BindEventToMediaPlayEnd(self, self.OnPingPongLoopEnd)
    end
    if Standby.CancelPauseOnFirstFrame then
      Standby:CancelPauseOnFirstFrame()
    end
    rawset(Standby, "bShouldPauseOnFirstFrame", false)
    if IsValid(MediaPlayer) and MediaPlayer.IsPlaying and not MediaPlayer:IsPlaying() then
      MediaPlayer:Play()
    end
    self:LaunchLoopSwapAbortWatch(Token, nil)
    self:WaitFirstFrame(Standby, LoopGateSwapTimerKey, Token, function(Owner)
      if Owner.PlayToken ~= Token or not Owner.bLoopPingPong then
        return
      end
      Owner:StopLoopSwapAbortWatch()
      Owner:ShowFallbackSwap(Standby, Active, Token)
    end)
    return
  end
  self:SetPlayerFramePresented(Standby, false)
  if not self:PlayLoopOnPlayer(Standby, self.OnPingPongLoopEnd) then
    if self.RemoveTimer then
      self:RemoveTimer(LoopSwapAbortTimerKey)
    end
    self.bLoopSwapping = false
    self:RecoverLoopWithNativeLooping(Active)
    return
  end
  self:LaunchLoopSwapAbortWatch(Token, nil)
  self:WaitFirstFrame(Standby, LoopGateSwapTimerKey, Token, function(Owner)
    if Owner.PlayToken ~= Token or not Owner.bLoopPingPong then
      return
    end
    Owner:StopLoopSwapAbortWatch()
    Owner:ShowFallbackSwap(Standby, Active, Token)
  end)
end

function M:FinishLoopSwap(Standby, Active, Token)
  if self.PlayToken ~= Token then
    return
  end
  self:StopLeftoverUMGAnims()
  self.ActiveLoopPlayer = Standby
  self.StandbyLoopPlayer = Active
  self.bStandbyPreheated = false
  self.bPrerollStarted = false
  self.bLoopSwapping = false
  self:StopLoopSwapAbortWatch()
  self.SwapActive = nil
  self.SwapStandby = nil
  self.LoopTailFailTick = 0
  self.bLoopTailUnsupported = false
  self.bLoopTailSwitchArmed = false
  self.RecoverStep = 0
  self:StartWaitLoopTail()
  self:StartProgressWatch(Standby, "loop")
  if self.AddTimer then
    self:AddTimer(FirstStandbyPreheatDelay, function(Owner)
      if Owner.PlayToken == Token then
        Owner:PreheatStandbyLoop(Token)
      end
    end, false, 0, LoopPreheatTimerKey, true)
  end
end

function M:OnPingPongLoopEnd()
  if self.PlayToken ~= self.InEndToken then
    return
  end
  if not self.bLoopPingPong then
    return
  end
  self:SwapLoopPlayers()
end

function M:OnInVideoEnd()
  if self.PlayToken ~= self.InEndToken then
    return
  end
  self:SwitchToLoopVideo()
end

function M:StopAllJumpBGVideo()
  self.PlayToken = (self.PlayToken or 0) + 1
  self.bLoopSwitching = false
  self.bInTailUnsupported = false
  self.bLoopPreheated = false
  SetPlayerFramePresented(self.InVideoPlayer, false)
  SetPlayerFramePresented(self.LoopVideoPlayer, false)
  self.LoopReadyTick = 0
  self.InTailFailTick = 0
  self.bInTailSwitchArmed = false
  self.bLoopTailSwitchArmed = false
  self.LastPollTime = nil
  self.LastPollDelta = nil
  self.LastVideoAdvanceTime = nil
  self.LoopPauseIssuedTime = nil
  self.LoopRetryCount = 0
  self.LoopRetryStart = nil
  self.GateState = {}
  self:StopWaitWindowCover()
  self:StopProgressWatch()
  self:ResetLoopPingPongState()
  self:RemoveAllJumpBGTimer()
  self:StopVideoPlayer(self.InVideoPlayer)
  if self.LoopVideoPlayer ~= self.InVideoPlayer then
    self:StopVideoPlayer(self.LoopVideoPlayer)
  end
end

function M:PrepareForActivityEntryOut()
  self:StopLeftoverUMGAnims()
  self:StopAllJumpBGVideo()
end

function M:Destruct()
  self:StopAllJumpBGVideo()
  if self.CleanTimer then
    self:CleanTimer()
  end
  self.ActivityEntry = nil
  self.InVideoPlayer = nil
  self.LoopVideoPlayer = nil
  self.StaticBg = nil
  self.BlackBg = nil
  self.ResidualWidgets = nil
  self.ContainerWidgets = nil
  self.ScaleBoxWidget = nil
  self.SizeBoxWidget = nil
  self.AttachCanvas = nil
  self.GateState = nil
  self.LoopReadyTick = nil
  self.InTailFailTick = nil
  self.bLoopPreheated = nil
  self.bLoopSwitching = nil
  self.bInTailUnsupported = nil
  self.PlayToken = nil
  self.InEndToken = nil
  self.ActiveLoopPlayer = nil
  self.StandbyLoopPlayer = nil
  self.bLoopPingPong = nil
  self.bStandbyPreheated = nil
  self.bLoopSwapping = nil
  self.bPrerollStarted = nil
  self.LoopTailFailTick = nil
  self.bLoopTailUnsupported = nil
  self.RecoverStep = nil
  self.RecoverMode = nil
  self.SwapActive = nil
  self.SwapStandby = nil
  self.ProgressWatchPlayer = nil
  self.ProgressWatchMode = nil
  self.ProgressWatchLast = nil
  self.ProgressWatchIdle = nil
  self.bProgressWatchAdvanced = nil
  self.InTailFailStart = nil
  self.LoopTailFailStart = nil
  self.LastPollTime = nil
  self.LastPollDelta = nil
  self.LastVideoAdvanceTime = nil
  self.LoopPauseIssuedTime = nil
  self.LoopRetryCount = nil
  self.LoopRetryStart = nil
  self.bInTailSwitchArmed = nil
  self.bLoopTailSwitchArmed = nil
  self.WaitCoverPlayer = nil
  self.WaitCoverStartOpacity = nil
  self.WaitCoverTick = nil
  if LastActiveInstance == self then
    LastActiveInstance = nil
  end
end

AssembleComponents(M)
return M
