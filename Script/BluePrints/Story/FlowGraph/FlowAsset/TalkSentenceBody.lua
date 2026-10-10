local LibraryPath = "/Game/Asset/Effect/Blueprint/PostProcess/PostProcessFunctionLibrary.PostProcessFunctionLibrary"
local RequiredFields = {"TalkTask", "TalkNode"}
local M = Class()

function M:IsSequenceBody()
  local TalkTask = self.TalkTask
  local TalkTaskData = TalkTask and TalkTask.TalkTaskData
  local BaseType = TalkTaskData and TalkTaskData.BasicTalkType
  local bCanUseSeq = "FixSimple" == BaseType or "Cinematic" == BaseType
  return bCanUseSeq and IsValid(self.TalkNode:GetSequenceByGender())
end

function M:InitializeLua(ctx)
  for _, Field in ipairs(RequiredFields) do
    if nil == ctx[Field] then
      local Message = string.format("句流体 InitializeLua 缺少必备字段 %s", Field)
      UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkFlow, "Flow对话节点出错:InitializeLua", Message)
      return false
    end
  end
  for _, Field in ipairs(RequiredFields) do
    self[Field] = ctx[Field]
  end
  self.SkipTarget = ctx.SkipTarget
  self.DialogueTables = ctx.TalkNode.DialogueData:ToTable()
  self.DialogueSettingsTable = ctx.TalkNode.DialogueSetting:ToTable()
  self.DialogueMap = {}
  for _, DialogueData in ipairs(self.DialogueTables) do
    local Id = DialogueData.DialogueId
    self.DialogueMap[Id] = {
      Data = DialogueData,
      Setting = self.DialogueSettingsTable[Id]
    }
  end
  return true
end

function M:PreStartFlowNode(InStartNode)
  if self:IsSequenceBody() then
    self:TryStartSequence()
  end
  if IsValid(InStartNode) then
    InStartNode:TriggerFirstOutput(true)
  end
end

function M:TryStartSequence()
  local TalkNode = self.TalkNode
  local LevelSequence = TalkNode:GetSequenceByGender()
  if not IsValid(LevelSequence) then
    DebugPrint("WXT__TalkSentenceBody:TryStartSequence", "LevelSequence invalid")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkFlow, "Flow对话节点出错:句流体Sequence起动失败", string.format("TalkNode=%s", tostring(self.TalkNode and self.TalkNode:GetName())))
    return
  end
  local RootAsset = TalkNode:GetFlowAsset()
  if IsValid(RootAsset) and RootAsset:IsCutsceneFlow() then
    UE4.UMovieSceneSequenceExtensions.SetClockSource(LevelSequence, UE4.EUpdateClockSource.Platform)
  end
  if UTalkEditorFunctionLibrary and UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GWorld.GameInstance) then
    local Ret1, Ret2 = UTalkEditorFunctionLibrary.ValidateTalkLevelSequence(LevelSequence)
    local Errors
    if type(Ret1) == "userdata" then
      Errors = Ret1
    else
      Errors = Ret2
    end
    if Errors then
      for _, Msg in pairs(Errors) do
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE4.EStoryLogType.Talk, "对话Seq走/跑跨句未勾自动播放", tostring(Msg))
      end
    end
  end
  TalkNode:PlaySequence()
  if not IsValid(TalkNode.SequencePlayer) or not IsValid(TalkNode.RuntimeProxy) then
    DebugPrint("WXT__TalkSentenceBody:TryStartSequence", "SequencePlayer/RuntimeProxy invalid")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkFlow, "Flow对话节点出错:句流体Sequence起动失败", string.format("TalkNode=%s", tostring(self.TalkNode and self.TalkNode:GetName())))
    return
  end
  self:BindSequenceActors()
  TalkNode.RuntimeProxy:SetUpLua(self.TalkTask)
  local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  UTalkSequenceFunctionLibrary.UpdatePlayerCameraManager(PlayerController)
end

function M:BindSequenceActors()
  local TalkNode = self.TalkNode
  local DialogueAssets = TalkNode:GetFlowAsset()
  local LevelSequenceActor = DialogueAssets.LevelSequenceActor
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TalkTask = self.TalkTask
  local BindNpcs = TalkTask.TalkTaskData.TalkActors
  local LevelSequence = TalkNode:GetSequenceByGender()
  for _, NpcData in pairs(BindNpcs) do
    local UnitId = NpcData.TalkActorId
    local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
    if TalkActorData and TalkActorData.TalkActor then
      local NpcIdTag = tostring(NpcData.OriginTalkActorId or UnitId)
      DialogueAssets:TryCacheNpcTransform(TalkActorData.TalkActor)
      if UTalkFunctionLibrary.IsSequenceOwnTag(LevelSequence, NpcIdTag) then
        LevelSequenceActor:AddBindingByTag(NpcIdTag, TalkActorData.TalkActor, false)
      end
    end
  end
  local UPostProcessFunctionLibrary = LoadClass(LibraryPath)
  if UPostProcessFunctionLibrary and UPostProcessFunctionLibrary.MobileCloseLightTrack then
    UPostProcessFunctionLibrary.MobileCloseLightTrack(LevelSequenceActor)
  end
end

return M
