local MOUTH_FRAME_MIN = 0
local MOUTH_FRAME_MAX = 2
local MOUTH_FRAME_INTERVAL_MIN = 0.08
local MOUTH_FRAME_INTERVAL_MAX = 0.16
local EMouthState = {
  None = 0,
  Idle = 1,
  Speak = 2
}
local EFacialState = {
  Show = 0,
  Hide = 1,
  Collapsed = 2
}
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M.EMouthState = EMouthState

function M:Construct()
  self.FaceWidget = self.Img_GuideMan
  self.EyesWidget = self.Img_GuideMan_Eyes
  self.MouthWidget = self.Img_GuideMan_Mouth
  self.EyesAnimation = self.Loop
  self.FacialState = EFacialState.Collapsed
  self.CurrentRowId = nil
  self.RequestSeq = 0
  self.MouthState = EMouthState.None
  self.MouthDefaultFrame = MOUTH_FRAME_MIN
  self.MouthFrameOffset = MOUTH_FRAME_MIN
  self.MouthFrameElapsed = 0
  self.MouthFrameNextInterval = MOUTH_FRAME_INTERVAL_MIN
  self.EyesMaterial = self.EyesWidget:GetDynamicMaterial()
  self.MouthMaterial = self.MouthWidget:GetDynamicMaterial()
  self:SetVisibility(ESlateVisibility.Collapsed)
end

function M:Tick(MyGeometry, InDeltaTime)
  self:UpdateMouthFrame(InDeltaTime)
end

function M:Destruct()
  self:InvalidateRequest()
end

function M:SetFacial(bSpeakerExists, Row)
  local RowId = Row and Row.PortraitFacialId
  if bSpeakerExists and not string.isempty(RowId) and RowId == self.CurrentRowId then
    return
  end
  local RequestSeq = self:InvalidateRequest()
  self:SetMouthState(EMouthState.None)
  self.MouthDefaultFrame = MOUTH_FRAME_MIN
  if not bSpeakerExists then
    self:SetFacialState(EFacialState.Collapsed)
    return
  end
  if not Row then
    self:SetFacialState(EFacialState.Hide)
    return
  end
  self:SetFacialState(EFacialState.Show)
  local MouthDefaultFrame = Row.MouthDefaultFrame
  if type(MouthDefaultFrame) ~= "number" or MouthDefaultFrame < MOUTH_FRAME_MIN or MouthDefaultFrame > MOUTH_FRAME_MAX then
    MouthDefaultFrame = MOUTH_FRAME_MIN
  end
  self.MouthDefaultFrame = MouthDefaultFrame
  self:SetMouthState(EMouthState.Idle)
  self:ApplyRowTextures(Row, RequestSeq)
end

function M:SetMouthState(NewState)
  if self.MouthState == NewState then
    return
  end
  self.MouthFrameElapsed = 0
  self.MouthFrameOffset = self.MouthDefaultFrame
  self:SetMouthFrameOffset(self.MouthDefaultFrame)
  self.MouthState = NewState
end

function M:UpdateMouthFrame(InDeltaTime)
  if self.MouthState ~= EMouthState.Speak then
    return
  end
  self.MouthFrameElapsed = self.MouthFrameElapsed + InDeltaTime
  if self.MouthFrameElapsed < self.MouthFrameNextInterval then
    return
  end
  self.MouthFrameElapsed = 0
  self.MouthFrameNextInterval = MOUTH_FRAME_INTERVAL_MIN + math.random() * (MOUTH_FRAME_INTERVAL_MAX - MOUTH_FRAME_INTERVAL_MIN)
  local Next = math.random(MOUTH_FRAME_MIN, MOUTH_FRAME_MAX - 1)
  if Next >= self.MouthFrameOffset then
    Next = Next + 1
  end
  self.MouthFrameOffset = Next
  self:SetMouthFrameOffset(Next)
end

function M:InvalidateRequest()
  self.CurrentRowId = nil
  self.RequestSeq = self.RequestSeq + 1
  return self.RequestSeq
end

function M:SetFacialState(NewState)
  self.FacialState = NewState
  if NewState == EFacialState.Show then
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:PlayEyesAnimation()
    return
  end
  self:StopAnimation(self.EyesAnimation)
  if NewState == EFacialState.Collapsed then
    self:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self:SetVisibility(ESlateVisibility.Hidden)
end

function M:ApplyRowTextures(Row, RequestSeq)
  local RowId = Row.PortraitFacialId
  self.CurrentRowId = RowId
  local WorldContext = GWorld and GWorld.GameInstance
  local Parts = {
    {
      Path = Row.FaceTexture,
      Widget = self.FaceWidget
    },
    {
      Path = Row.EyesTexture,
      Material = self.EyesMaterial,
      Index = Row.EyesIndex
    },
    {
      Path = Row.MouthTexture,
      Material = self.MouthMaterial,
      Index = Row.MouthIndex
    }
  }
  local Remaining = #Parts
  
  local function OnPartLoaded(Part, Texture)
    Part.Texture = Texture
    Remaining = Remaining - 1
    if Remaining > 0 then
      return
    end
    if not IsValid(self) or self.RequestSeq ~= RequestSeq then
      return
    end
    for _, Loaded in ipairs(Parts) do
      if not Loaded.Texture then
        UStoryLogUtils.PrintToFeiShu(GWorld and GWorld.GameInstance, UE.EStoryLogType.NPC, "头像表情贴图加载失败", string.format("头像表情非空但三部位贴图未齐（面部/眼睛/嘴巴需同配），反馈策划检查配置，表行键：%s", tostring(RowId)))
        return
      end
    end
    for _, Loaded in ipairs(Parts) do
      if Loaded.Material then
        self:ApplyPartEmotion(Loaded.Material, Loaded.Texture, Loaded.Index)
      else
        Loaded.Widget:SetBrushFromTexture(Loaded.Texture)
      end
    end
  end
  
  for _, Part in ipairs(Parts) do
    if not WorldContext or string.isempty(Part.Path) then
      OnPartLoaded(Part, nil)
    else
      UResourceLibrary.LoadObjectAsync(WorldContext, Part.Path, {
        WorldContext,
        function(_, Asset)
          OnPartLoaded(Part, Asset)
        end
      })
    end
  end
end

function M:SetMouthFrameOffset(Offset)
  if not self.MouthMaterial then
    return
  end
  self.MouthMaterial:SetScalarParameterValue("FrameOffset", Offset)
end

function M:PlayEyesAnimation()
  if self:IsAnimationPlaying(self.EyesAnimation) then
    return
  end
  self:PlayAnimation(self.EyesAnimation, 0, 0, EUMGSequencePlayMode.Forward, 1.0)
end

function M:ApplyPartEmotion(Material, Texture, Index)
  if not Material then
    return
  end
  Material:SetTextureParameterValue("EmotionTex", Texture)
  Material:SetScalarParameterValue("RowIndex", Index or 0)
end

return M
