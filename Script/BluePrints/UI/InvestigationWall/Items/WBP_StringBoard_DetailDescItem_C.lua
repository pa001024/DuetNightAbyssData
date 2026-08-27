require("UnLua")
local InvestigationWallUtils = require("BluePrints.UI.InvestigationWall.InvestigationWallUtils")
local StringBoardConfig = require("BluePrints.UI.InvestigationWall.StringBoardConfig")
local DetailDescTextLayout = require("BluePrints.UI.InvestigationWall.DetailDescTextLayout")
local DetailDescItemVisualState = InvestigationWallUtils.DetailDescItemVisualState
local DetailDescItemPhase1 = InvestigationWallUtils.DetailDescItemPhase1
local DetailDescItemPhase2 = InvestigationWallUtils.DetailDescItemPhase2
local DetailDescItemRestState = InvestigationWallUtils.DetailDescItemRestState
local StrikeProcessTimerInterval = 0.016
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.VisualState = DetailDescItemVisualState.IdleNormal
  self.DescItemAnimToken = 0
  self.OnEntranceSequenceCompletedCallback = nil
  self.bIsStrikeProcessPlaying = false
  self.bFinishInUmgCompleted = false
  self.bShouldChainFinishAfterFinishIn = false
end

function M:ShouldPrepareEntranceHidden(Plan)
  if not Plan then
    return false
  end
  if Plan.Phase1 == DetailDescItemPhase1.PlayNormal and Plan.bPhase1Done ~= true then
    return true
  end
  if Plan.Phase2 == DetailDescItemPhase2.PlayUnlockIn and true ~= Plan.bPhase2Done then
    return true
  end
  return false
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self:RebuildDescLines(Content and Content.DescText or "")
  local Plan = Content and Content.DescAnimPlan
  self:CancelToRest(true)
  if Plan and Plan.Phase1 == DetailDescItemPhase1.PlayFinishIn and Plan.bPhase1Done ~= true then
    self.VisualState = DetailDescItemVisualState.IdleNormal
    self:ApplyFinishInInitialState()
  elseif Plan and Plan.RestState == DetailDescItemRestState.Finish then
    self:EnterIdleFinish()
  else
    self:EnterIdleNormal()
    if self:ShouldPrepareEntranceHidden(Plan) then
      self:SetGroupBoardDetailOpacity(0)
    end
  end
end

function M:Destruct()
  self:StopStrikeProcessTimer()
  self.Content = nil
  self.OnEntranceSequenceCompletedCallback = nil
  if M.Super and M.Super.Destruct then
    M.Super.Destruct(self)
  end
end

function M:GetDescContentMaxWidth()
  local SizeBoxTextContent = self.SizeBox_TextContent
  if SizeBoxTextContent then
    local WidthOverride = SizeBoxTextContent.WidthOverride
    if WidthOverride and WidthOverride > 0 then
      return WidthOverride
    end
    if SizeBoxTextContent.GetDesiredSize then
      local DesiredSize = SizeBoxTextContent:GetDesiredSize()
      if DesiredSize and DesiredSize.X and DesiredSize.X > 0 then
        return DesiredSize.X
      end
    end
  end
  return 356
end

function M:ResolveLineClass(CacheFieldName, ClassPath)
  if self[CacheFieldName] then
    return self[CacheFieldName]
  end
  if ClassPath then
    self[CacheFieldName] = LoadClass(ClassPath)
  end
  return self[CacheFieldName]
end

function M:ApplyDescLineVerticalBoxSlot(LineWidget)
  if not LineWidget then
    return
  end
  local VerticalBoxSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(LineWidget)
  if not VerticalBoxSlot then
    return
  end
  if VerticalBoxSlot.SetHorizontalAlignment then
    VerticalBoxSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Left)
  end
  if VerticalBoxSlot.SetVerticalAlignment then
    VerticalBoxSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Top)
  end
end

function M:EnsureLinePools(LineCount)
  self.NormalLineUIs = self.NormalLineUIs or {}
  self.StrikeLineUIs = self.StrikeLineUIs or {}
  local NormalLineClass = self:ResolveLineClass("CachedNormalLineClass", StringBoardConfig.DetailDescNormalLineClassPath)
  local StrikeLineClass = self:ResolveLineClass("CachedStrikeLineClass", StringBoardConfig.DetailDescStrikeLineClassPath)
  local VBoxNormalText = self.VBox_NormalText
  local VBoxStrikeText = self.VBox_StrikeText
  for LineIndex = 1, LineCount do
    if not self.NormalLineUIs[LineIndex] and NormalLineClass and VBoxNormalText then
      local NormalLineWidget = UE4.UWidgetBlueprintLibrary.Create(self, NormalLineClass)
      VBoxNormalText:AddChild(NormalLineWidget)
      self:ApplyDescLineVerticalBoxSlot(NormalLineWidget)
      NormalLineWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.NormalLineUIs[LineIndex] = NormalLineWidget
    end
    if not self.StrikeLineUIs[LineIndex] and StrikeLineClass and VBoxStrikeText then
      local StrikeLineWidget = UE4.UWidgetBlueprintLibrary.Create(self, StrikeLineClass)
      VBoxStrikeText:AddChild(StrikeLineWidget)
      self:ApplyDescLineVerticalBoxSlot(StrikeLineWidget)
      StrikeLineWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.StrikeLineUIs[LineIndex] = StrikeLineWidget
    end
  end
  for LineIndex = LineCount + 1, #self.NormalLineUIs do
    local NormalLineWidget = self.NormalLineUIs[LineIndex]
    if NormalLineWidget and NormalLineWidget.SetVisibility then
      NormalLineWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  for LineIndex = LineCount + 1, #self.StrikeLineUIs do
    local StrikeLineWidget = self.StrikeLineUIs[LineIndex]
    if StrikeLineWidget and StrikeLineWidget.SetVisibility then
      StrikeLineWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:SetStrikeLineProcess(LineIndex, ProcessValue)
  local StrikeLineWidget = self.StrikeLineUIs and self.StrikeLineUIs[LineIndex]
  if not StrikeLineWidget or not StrikeLineWidget.Canvas_Clip then
    return
  end
  local FullWidth = self.StrikeLineWidths and self.StrikeLineWidths[LineIndex] or 0
  local FullHeight = self.StrikeLineHeights and self.StrikeLineHeights[LineIndex] or 0
  local ClampedProcess = ProcessValue or 0
  if ClampedProcess < 0 then
    ClampedProcess = 0
  elseif ClampedProcess > 1 then
    ClampedProcess = 1
  end
  local ClipWidth = FullWidth * ClampedProcess
  local ClipCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(StrikeLineWidget.Canvas_Clip)
  if not ClipCanvasSlot or not ClipCanvasSlot.SetSize then
    return
  end
  if ClipCanvasSlot.SetAutoSize then
    ClipCanvasSlot:SetAutoSize(false)
  end
  ClipCanvasSlot:SetSize(FVector2D(ClipWidth, FullHeight))
end

function M:PrepareStrikeLineLayout(LineIndex)
  local StrikeLineWidget = self.StrikeLineUIs and self.StrikeLineUIs[LineIndex]
  local NormalLineWidget = self.NormalLineUIs and self.NormalLineUIs[LineIndex]
  if not StrikeLineWidget then
    return 0, 0
  end
  local StrikeTextLine = StrikeLineWidget.Text_Line
  local CanvasClip = StrikeLineWidget.Canvas_Clip
  if not StrikeTextLine or not CanvasClip then
    return 0, 0
  end
  local ClipCanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(CanvasClip)
  if ClipCanvasSlot and ClipCanvasSlot.SetAutoSize then
    ClipCanvasSlot:SetAutoSize(true)
  end
  local MeasureTextLine = NormalLineWidget and NormalLineWidget.Text_Line or StrikeTextLine
  if MeasureTextLine.ForceLayoutPrepass then
    MeasureTextLine:ForceLayoutPrepass()
  end
  local DesiredSize = MeasureTextLine.GetDesiredSize and MeasureTextLine:GetDesiredSize() or FVector2D(0, 0)
  local LineWidth = DesiredSize.X or 0
  local LineHeight = DesiredSize.Y or 0
  
  local function ApplyRootSizeOverride(RootWidget)
    if not RootWidget then
      return
    end
    if LineWidth > 0 and RootWidget.SetWidthOverride then
      RootWidget:SetWidthOverride(LineWidth)
    end
    if LineHeight > 0 and RootWidget.SetHeightOverride then
      RootWidget:SetHeightOverride(LineHeight)
    end
  end
  
  ApplyRootSizeOverride(StrikeLineWidget.Root)
  if NormalLineWidget then
    ApplyRootSizeOverride(NormalLineWidget.Root)
  end
  return LineWidth, LineHeight
end

function M:SetAllStrikeLineProcess(ProcessValue)
  self:PrepareAllStrikeLineLayouts()
  for LineIndex = 1, #(self.DescLineTexts or {}) do
    self:SetStrikeLineProcess(LineIndex, ProcessValue)
  end
end

function M:PrepareAllStrikeLineLayouts()
  local LineWidths = {}
  local LineHeights = {}
  for LineIndex = 1, #(self.DescLineTexts or {}) do
    local LineWidth, LineHeight = self:PrepareStrikeLineLayout(LineIndex)
    LineWidths[LineIndex] = LineWidth
    LineHeights[LineIndex] = LineHeight
  end
  self.StrikeLineWidths = LineWidths
  self.StrikeLineHeights = LineHeights
  return LineWidths
end

function M:ResolveStrikeProcessSpeed(LineCount)
  local TotalDuration = StringBoardConfig.DetailDescStrikeTotalDuration or 1.0
  if TotalDuration <= 0 then
    TotalDuration = 1.0
  end
  local ResolvedLineCount = LineCount or 0
  if ResolvedLineCount <= 0 then
    return 1.0 / TotalDuration
  end
  return ResolvedLineCount / TotalDuration
end

function M:SetStrikeLayerVisible(bVisible)
  local VBoxStrikeText = self.VBox_StrikeText
  if not VBoxStrikeText or not VBoxStrikeText.SetVisibility then
    return
  end
  local Visibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  VBoxStrikeText:SetVisibility(Visibility)
end

function M:SetNormalLayerOpacity(Opacity)
  local VBoxNormalText = self.VBox_NormalText
  if VBoxNormalText and VBoxNormalText.SetRenderOpacity then
    VBoxNormalText:SetRenderOpacity(Opacity)
  end
end

function M:SetStrikeLayerOpacity(Opacity)
  local VBoxStrikeText = self.VBox_StrikeText
  if VBoxStrikeText and VBoxStrikeText.SetRenderOpacity then
    VBoxStrikeText:SetRenderOpacity(Opacity)
  end
end

function M:RebuildDescLines(DescText)
  local MaxLineWidth = self:GetDescContentMaxWidth()
  local LineTexts = DetailDescTextLayout.SplitDescTextToLines(self.RichTextBlock_Calc, DescText or "", MaxLineWidth)
  self.DescLineTexts = LineTexts
  self:EnsureLinePools(#LineTexts)
  for LineIndex, LineText in ipairs(LineTexts) do
    local NormalLineWidget = self.NormalLineUIs[LineIndex]
    if NormalLineWidget then
      NormalLineWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      if NormalLineWidget.Text_Line and NormalLineWidget.Text_Line.SetText then
        NormalLineWidget.Text_Line:SetText(LineText)
      end
    end
    local StrikeLineWidget = self.StrikeLineUIs[LineIndex]
    if StrikeLineWidget then
      StrikeLineWidget:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      if StrikeLineWidget.Text_Line and StrikeLineWidget.Text_Line.SetText then
        StrikeLineWidget.Text_Line:SetText(LineText)
      end
    end
  end
  self:SetAllStrikeLineProcess(0)
end

function M:RealStrikeProcess(InDeltaTime)
  if not self.bIsStrikeProcessPlaying then
    return
  end
  local LineCount = #(self.DescLineTexts or {})
  if LineCount <= 0 then
    self.bIsStrikeProcessPlaying = false
    self:TryCompleteStrikeFinishIn()
    return
  end
  local CurStrikeLineIdx = self.CurStrikeLineIdx or 1
  if LineCount < CurStrikeLineIdx then
    self.bIsStrikeProcessPlaying = false
    self:TryCompleteStrikeFinishIn()
    return
  end
  local Speed = self.StrikeProcessSpeed or self:ResolveStrikeProcessSpeed(LineCount)
  local ProcessValue = (self.StrikeProcessValue or 0) + InDeltaTime * Speed
  if ProcessValue >= 1 then
    self:SetStrikeLineProcess(CurStrikeLineIdx, 1)
    self.CurStrikeLineIdx = CurStrikeLineIdx + 1
    self.StrikeProcessValue = 0
    if LineCount < self.CurStrikeLineIdx then
      self.bIsStrikeProcessPlaying = false
      self:TryCompleteStrikeFinishIn()
    end
    return
  end
  self.StrikeProcessValue = ProcessValue
  self:SetStrikeLineProcess(CurStrikeLineIdx, ProcessValue)
end

function M:StopStrikeProcessTimer()
  local TimerHost = self.StrikeProcessTimerHost
  local TimerName = self.StrikeProcessTimerName
  if TimerHost and IsValid(TimerHost) and TimerHost.RemoveTimer and TimerName then
    TimerHost:RemoveTimer(TimerName)
  end
  self.StrikeProcessTimerHost = nil
  self.StrikeProcessTimerName = nil
end

function M:StartStrikeProcessTimer(TimerHost, ExpectedAnimToken)
  if not TimerHost or not TimerHost.AddTimer then
    return
  end
  self:StopStrikeProcessTimer()
  local ClueContentId = self.Content and self.Content.ClueContentId or 0
  local TimerName = "DetailDescStrikeProcess_" .. tostring(ClueContentId)
  self.StrikeProcessTimerHost = TimerHost
  self.StrikeProcessTimerName = TimerName
  TimerHost:AddTimer(StrikeProcessTimerInterval, function()
    if not IsValid(self) or self.DescItemAnimToken ~= ExpectedAnimToken then
      if TimerHost.RemoveTimer then
        TimerHost:RemoveTimer(TimerName)
      end
      return
    end
    if not self.bIsStrikeProcessPlaying then
      if TimerHost.RemoveTimer then
        TimerHost:RemoveTimer(TimerName)
      end
      return
    end
    self:RealStrikeProcess(StrikeProcessTimerInterval)
  end, true, 0, TimerName)
end

function M:NotifyEntranceSequenceCompleted()
  local OnCompleted = self.OnEntranceSequenceCompletedCallback
  self.OnEntranceSequenceCompletedCallback = nil
  if OnCompleted then
    OnCompleted()
  end
end

function M:ApplyFinishVisualState()
  self:SetStrikeLayerVisible(true)
  self:SetAllStrikeLineProcess(1)
  self:SetNormalLayerOpacity(0)
  self:SetStrikeLayerOpacity(1)
end

function M:SetGroupBoardDetailOpacity(Opacity)
  local GroupBoardDetail = self.Group_BoardDetail
  if GroupBoardDetail and GroupBoardDetail.SetRenderOpacity then
    GroupBoardDetail:SetRenderOpacity(Opacity)
  end
end

function M:StopDescItemAnimation(Animation)
  if not Animation then
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(Animation)
  end
  if self.IsAnimationPlaying and self:IsAnimationPlaying(Animation) and self.StopAnimation then
    self:StopAnimation(Animation)
  end
end

function M:IsDescItemAnimationPlaying(Animation)
  return nil ~= Animation and nil ~= self.IsAnimationPlaying and self:IsAnimationPlaying(Animation) == true
end

function M:SnapAnimationToEnd(Animation)
  if not Animation or not self.PlayAnimation then
    return
  end
  if self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(Animation)
  end
  local EndTime = Animation.GetEndTime and Animation:GetEndTime() or nil
  if EndTime then
    self:PlayAnimation(Animation, EndTime)
    if self.SetAnimationCurrentTime then
      self:SetAnimationCurrentTime(Animation, EndTime)
    end
  else
    self:PlayAnimation(Animation)
  end
  if self.StopAnimation then
    self:StopAnimation(Animation)
  end
end

function M:ApplyIdleNormalLayers()
  self:SetGroupBoardDetailOpacity(1)
  self:SetStrikeLayerVisible(false)
  self:SetAllStrikeLineProcess(0)
  self:SetNormalLayerOpacity(1)
  self:SetStrikeLayerOpacity(0)
end

function M:ApplyFinishInInitialState()
  self:SetGroupBoardDetailOpacity(1)
  self:SetStrikeLayerVisible(true)
  self:SetAllStrikeLineProcess(0)
  self:SetNormalLayerOpacity(1)
  self:SetStrikeLayerOpacity(1)
  self.CurStrikeLineIdx = 1
  self.StrikeProcessValue = 0
end

function M:GetDescAnimPlan()
  return self.Content and self.Content.DescAnimPlan or nil
end

function M:EnterIdleNormal()
  self.VisualState = DetailDescItemVisualState.IdleNormal
  self:ApplyIdleNormalLayers()
end

function M:EnterIdleFinish()
  self.VisualState = DetailDescItemVisualState.IdleFinish
  self:SetGroupBoardDetailOpacity(1)
  self:ApplyFinishVisualState()
end

function M:ResetDescItemVisual(RestState)
  self:CancelToRest(true)
  if RestState == DetailDescItemRestState.Finish then
    self:EnterIdleFinish()
  else
    self:EnterIdleNormal()
  end
end

function M:CancelToRest(bSkipSnap)
  local PrevState = self.VisualState
  self.DescItemAnimToken = (self.DescItemAnimToken or 0) + 1
  self.bIsStrikeProcessPlaying = false
  self.bFinishInUmgCompleted = false
  self.bShouldChainFinishAfterFinishIn = false
  self.OnEntranceSequenceCompletedCallback = nil
  self.CurStrikeLineIdx = 1
  self.StrikeProcessValue = 0
  self.StrikeProcessSpeed = nil
  self:StopStrikeProcessTimer()
  local bFinishInPlaying = self:IsDescItemAnimationPlaying(self.Finish_In)
  local bInPlaying = self:IsDescItemAnimationPlaying(self.In)
  local bNormalPlaying = self:IsDescItemAnimationPlaying(self.Normal)
  local bFinishPlaying = self:IsDescItemAnimationPlaying(self.Finish)
  self:StopDescItemAnimation(self.Finish_In)
  self:StopDescItemAnimation(self.In)
  self:StopDescItemAnimation(self.Normal)
  self:StopDescItemAnimation(self.Finish)
  if not bSkipSnap then
    if PrevState == DetailDescItemVisualState.PlayingFinishIn and bFinishInPlaying then
      self:SnapAnimationToEnd(self.Finish_In)
    elseif PrevState == DetailDescItemVisualState.PlayingFinish and bFinishPlaying then
      self:SnapAnimationToEnd(self.Finish)
    elseif PrevState == DetailDescItemVisualState.PlayingIn and bInPlaying then
      self:SnapAnimationToEnd(self.In)
    elseif PrevState == DetailDescItemVisualState.PlayingNormal and bNormalPlaying then
      self:SnapAnimationToEnd(self.Normal)
    end
  end
  local bToFinish = PrevState == DetailDescItemVisualState.PlayingFinishIn or PrevState == DetailDescItemVisualState.PlayingFinish or PrevState == DetailDescItemVisualState.IdleFinish
  if not bToFinish then
    local Plan = self:GetDescAnimPlan()
    if Plan and Plan.RestState == DetailDescItemRestState.Finish and PrevState ~= DetailDescItemVisualState.PlayingIn and PrevState ~= DetailDescItemVisualState.PlayingNormal then
      bToFinish = true
    end
  end
  if bToFinish then
    self:EnterIdleFinish()
  else
    self:EnterIdleNormal()
  end
end

function M:CancelDescItemAnimations()
  self:CancelToRest(false)
end

function M:TryCompleteStrikeFinishIn()
  if not self.bFinishInUmgCompleted then
    return
  end
  if self.bIsStrikeProcessPlaying then
    return
  end
  self.bFinishInUmgCompleted = false
  if self.bShouldChainFinishAfterFinishIn then
    self.bShouldChainFinishAfterFinishIn = false
    self:ApplyFinishVisualState()
    self:StartPlayingFinish(self.OnEntranceSequenceCompletedCallback, true)
    return
  end
  self:EnterIdleFinish()
  self:NotifyEntranceSequenceCompleted()
end

function M:ShouldPlayDescItemEntranceAnimation()
  local Plan = self:GetDescAnimPlan()
  if not Plan then
    return false
  end
  return Plan.Phase1 ~= DetailDescItemPhase1.None and Plan.bPhase1Done ~= true
end

function M:ShouldPlayDescItemUnlockInAnimation()
  local Plan = self:GetDescAnimPlan()
  if not Plan then
    return false
  end
  return Plan.Phase2 == DetailDescItemPhase2.PlayUnlockIn and Plan.bPhase2Done ~= true
end

function M:PlayPhase1EntranceSequence(TimerHost, OnSequenceCompleted)
  local Plan = self:GetDescAnimPlan()
  if not Plan or Plan.Phase1 == DetailDescItemPhase1.None or Plan.bPhase1Done then
    if OnSequenceCompleted then
      OnSequenceCompleted()
    end
    return
  end
  
  local function OnPhase1Completed()
    Plan.bPhase1Done = true
    if OnSequenceCompleted then
      OnSequenceCompleted()
    end
  end
  
  if Plan.Phase1 == DetailDescItemPhase1.PlayFinishIn then
    self:StartPlayingFinishIn(TimerHost, OnPhase1Completed)
    return
  end
  if Plan.Phase1 == DetailDescItemPhase1.PlayNormal then
    self:StartPlayingNormal(OnPhase1Completed)
    return
  end
  if Plan.Phase1 == DetailDescItemPhase1.PlayFinish then
    self:StartPlayingFinish(OnPhase1Completed, false)
    return
  end
  self:EnterIdleNormal()
  OnPhase1Completed()
end

function M:PlayUnlockInAnimation(OnSequenceCompleted)
  local Plan = self:GetDescAnimPlan()
  if not Plan or Plan.Phase2 ~= DetailDescItemPhase2.PlayUnlockIn or Plan.bPhase2Done then
    if OnSequenceCompleted then
      OnSequenceCompleted()
    end
    return
  end
  Plan.bPhase2Done = true
  Plan.bPhase1Done = true
  self:StartPlayingIn(function()
    if OnSequenceCompleted then
      OnSequenceCompleted()
    end
  end)
end

function M:StartPlayingFinishIn(TimerHost, OnSequenceCompleted)
  self:CancelToRest(true)
  self.VisualState = DetailDescItemVisualState.PlayingFinishIn
  self.OnEntranceSequenceCompletedCallback = OnSequenceCompleted
  self.bShouldChainFinishAfterFinishIn = true
  local Content = self.Content
  if Content then
    InvestigationWallUtils.MarkClueContentFinishEntranceSeenInDetail(Content.ClueId, Content.ClueContentId)
    local Plan = Content.DescAnimPlan
    if Plan then
      Plan.RestState = DetailDescItemRestState.Finish
      Plan.bPhase1Done = true
    end
  end
  local ExpectedAnimToken = self.DescItemAnimToken
  self.bFinishInUmgCompleted = false
  self:ApplyFinishInInitialState()
  self.StrikeProcessSpeed = self:ResolveStrikeProcessSpeed(#(self.DescLineTexts or {}))
  self.bIsStrikeProcessPlaying = true
  self:StartStrikeProcessTimer(TimerHost, ExpectedAnimToken)
  if self.Finish_In and self.PlayAnimation then
    self:PlayAnimation(self.Finish_In)
  end
  if self.Finish_In and self.BindToAnimationFinished then
    self.FinishInExpectedAnimToken = ExpectedAnimToken
    self:BindToAnimationFinished(self.Finish_In, {
      self,
      self.OnFinishInAnimationFinished
    })
  else
    self:OnFinishInAnimationFinished()
  end
end

function M:OnFinishInAnimationFinished()
  if self.FinishInExpectedAnimToken ~= nil and self.DescItemAnimToken ~= self.FinishInExpectedAnimToken then
    return
  end
  self.FinishInExpectedAnimToken = nil
  if self.Finish_In and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Finish_In)
  end
  self.bFinishInUmgCompleted = true
  self:TryCompleteStrikeFinishIn()
end

function M:StartPlayingFinish(OnSequenceCompleted, bKeepFinishInEndVisual)
  if not bKeepFinishInEndVisual then
    self:CancelToRest(true)
  end
  self.VisualState = DetailDescItemVisualState.PlayingFinish
  self.OnEntranceSequenceCompletedCallback = OnSequenceCompleted
  self:SetGroupBoardDetailOpacity(1)
  self:ApplyFinishVisualState()
  if not self.Finish or not self.PlayAnimation then
    self:EnterIdleFinish()
    self:NotifyEntranceSequenceCompleted()
    return
  end
  if self.BindToAnimationFinished then
    self.FinishExpectedAnimToken = self.DescItemAnimToken
    self:BindToAnimationFinished(self.Finish, {
      self,
      self.OnFinishAnimationFinished
    })
  end
  self:PlayAnimation(self.Finish)
end

function M:OnFinishAnimationFinished()
  if self.FinishExpectedAnimToken ~= nil and self.DescItemAnimToken ~= self.FinishExpectedAnimToken then
    return
  end
  self.FinishExpectedAnimToken = nil
  if self.Finish and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Finish)
  end
  self:EnterIdleFinish()
  self:NotifyEntranceSequenceCompleted()
end

function M:StartPlayingNormal(OnSequenceCompleted)
  self:CancelToRest(true)
  self.VisualState = DetailDescItemVisualState.PlayingNormal
  self.OnEntranceSequenceCompletedCallback = OnSequenceCompleted
  self:ApplyIdleNormalLayers()
  if not self.Normal or not self.PlayAnimation then
    self:EnterIdleNormal()
    self:NotifyEntranceSequenceCompleted()
    return
  end
  if self.BindToAnimationFinished then
    self.NormalExpectedAnimToken = self.DescItemAnimToken
    self:BindToAnimationFinished(self.Normal, {
      self,
      self.OnNormalAnimationFinished
    })
  end
  self:PlayAnimation(self.Normal)
end

function M:OnNormalAnimationFinished()
  if self.NormalExpectedAnimToken ~= nil and self.DescItemAnimToken ~= self.NormalExpectedAnimToken then
    return
  end
  self.NormalExpectedAnimToken = nil
  if self.Normal and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.Normal)
  end
  self:EnterIdleNormal()
  self:NotifyEntranceSequenceCompleted()
end

function M:StartPlayingIn(OnSequenceCompleted)
  self:CancelToRest(true)
  self.VisualState = DetailDescItemVisualState.PlayingIn
  self.OnEntranceSequenceCompletedCallback = OnSequenceCompleted
  self:SetGroupBoardDetailOpacity(0)
  self:SetStrikeLayerVisible(false)
  self:SetAllStrikeLineProcess(0)
  self:SetNormalLayerOpacity(1)
  self:SetStrikeLayerOpacity(0)
  if not self.In or not self.PlayAnimation then
    self:EnterIdleNormal()
    self:NotifyEntranceSequenceCompleted()
    return
  end
  if self.BindToAnimationFinished then
    self.InExpectedAnimToken = self.DescItemAnimToken
    self:BindToAnimationFinished(self.In, {
      self,
      self.OnInAnimationFinished
    })
  end
  self:PlayAnimation(self.In)
end

function M:OnInAnimationFinished()
  if self.InExpectedAnimToken ~= nil and self.DescItemAnimToken ~= self.InExpectedAnimToken then
    return
  end
  self.InExpectedAnimToken = nil
  if self.In and self.UnbindAllFromAnimationFinished then
    self:UnbindAllFromAnimationFinished(self.In)
  end
  self:EnterIdleNormal()
  self:NotifyEntranceSequenceCompleted()
end

function M:BP_OnEntryReleased()
  self:ResetDescItemVisual(DetailDescItemRestState.Normal)
  self.StrikeProcessValue = nil
  self.StrikeProcessSpeed = nil
  self.CurStrikeLineIdx = 1
  self.StrikeLineWidths = nil
  self.StrikeLineHeights = nil
  self.DescLineTexts = nil
  self.Content = nil
end

return M
