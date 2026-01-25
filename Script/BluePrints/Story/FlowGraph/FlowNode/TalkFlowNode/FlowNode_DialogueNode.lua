local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local LibraryPath = "/Game/Asset/Effect/Blueprint/PostProcess/PostProcessFunctionLibrary.PostProcessFunctionLibrary"
local FFlowDialogue = {}
local FlowLogType = UE.EStoryLogType.TalkFlow

function FFlowDialogue.New(DialogueData, DialogueSetting, DialogueSection)
  local function GetRawData(Key)
    if DialogueSection and nil ~= DialogueSection[Key] then
      return DialogueSection[Key]
    end
    if DialogueData and nil ~= DialogueData[Key] then
      return DialogueData[Key]
    end
    if DialogueSetting and nil ~= DialogueSetting[Key] then
      return DialogueSetting[Key]
    end
    return FFlowDialogue[Key]
  end
  
  local M = setmetatable({}, {
    __index = function(t, Key)
      local Value = GetRawData(Key)
      if Value then
        rawset(t, Key, Value)
      end
      return Value
    end
  })
  M.bForbiddenDSL = false
  M.bWaitAsyncTag = false
  if DialogueSection then
    M.EnableSkip = DialogueSection.EnableSkip
  else
    M.EnableSkip = true
  end
  return M
end

function FFlowDialogue:BindOnDialogueFinish(Func)
  self.OnDialogueFinish = Func
end

function FFlowDialogue:ExecuteOnDialogueFinish(...)
  if self.OnDialogueFinish then
    self.OnDialogueFinish(...)
  end
end

function FFlowDialogue:BindOnForceCompleteDialogue(Func)
  self.OnForceCompleteDialogue = Func
end

function FFlowDialogue:ExecuteOnForceCompleteDialogue(...)
  if self.OnForceCompleteDialogue then
    self.OnForceCompleteDialogue(...)
  end
end

function FFlowDialogue:IsForbiddenDSL()
  return self.bForbiddenDSL
end

function FFlowDialogue:SetForbiddenDSL(bValue)
  self.bForbiddenDSL = bValue
end

function FFlowDialogue:IsWaitAsyncTag()
  return self.bWaitAsyncTag
end

function FFlowDialogue:SetWaitAsyncTag(bValue)
  self.bWaitAsyncTag = bValue
end

function FFlowDialogue:SetAutoToNext()
  self.bAutoToNext = true
end

function FFlowDialogue:NeedAutoToNext()
  return self.bAutoToNext
end

function FFlowDialogue:SetEnableSkip(bValue)
  self.EnableSkip = bValue
end

function M:ReceiveBeginPlay()
end

function M:TryGetCurrentDialogueData()
  local DialogueData = self.DialogueTables[self.Index]
  return DialogueData
end

function M:TryFinishDialogue(DialogueId)
  if self.SequencePlayer then
    self.SequencePlayer:TryStopDialogueId(DialogueId)
  end
end

function M:OnDialogueFinish(DialogueId)
  local DialogueData = self:TryGetCurrentDialogueData()
  if DialogueData and DialogueData.DialogueId == DialogueId then
    self:IterForward()
    if not self:IsDialogueNodeFinish() then
      self:TryFinishDialogue(DialogueId)
    end
  else
    local Message = string.format("当前Dialogue节点OnDialogueFinish时 DialogueId %d 与回调 %d不同，请检查 self.Index: %d, Dialogue Num: %d", DialogueData and DialogueData.DialogueId or 0, DialogueId or 0, self.Index, self.DialogueTables and #self.DialogueTables or -1)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueFinish", Message)
  end
end

function M:OnDialogueForceToEnd(DialogueId)
  local DialogueData = self:TryGetCurrentDialogueData()
  DebugPrint("DialogueFlowNode: OnDialogueForceToEnd", DialogueId)
  if DialogueData and DialogueData.DialogueId == DialogueId then
    if self.SequencePlayer then
      DebugPrint("DialogueFlowNode: OnDialogueForceToEnd Skip", DialogueId, self.SequenceFinishIndex)
      if self.SequenceFinishIndex and -1 ~= self.SequenceFinishIndex then
        self.RuntimeProxy:SetInSkip(true)
        self:EnableResetPhysic(true)
        self.SequencePlayer:SkipToDialogueEnd(DialogueId)
        self:EnableResetPhysic(false)
        self.RuntimeProxy:SetInSkip(false)
        self:OnSequencePause()
      end
      DebugPrint("DialogueFlowNode: OnDialogueForceToEnd AfterPause", DialogueId)
    end
  else
    local Message = string.format("当前Dialogue节点OnDialogueFinish时 DialogueId %d 与回调 %d不同，请检查 self.Index: %d, Dialogue Num: %d", DialogueData and DialogueData.DialogueId or 0, DialogueId or 0, self.Index, self.DialogueTables and #self.DialogueTables or -1)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:OnDialogueForceToEnd", Message)
  end
end

function M:PlayDialogue(FlowDialogueData)
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  local DialogueRecordComponent = self:TryGetRecordComponent()
  local DialogueId = FlowDialogueData.DialogueId
  FlowDialogueData:BindOnForceCompleteDialogue(function(DialogueId)
    self:OnDialogueForceToEnd(DialogueId)
  end)
  FlowDialogueData:BindOnDialogueFinish(function(DialogueId)
    self:OnDialogueFinish(DialogueId)
  end)
  DialogueFlowGraphComponent:PlayDialogue(FlowDialogueData)
  DialogueRecordComponent:OnDialogueRecord(DialogueId, DataMgr.Dialogue[DialogueId])
  self:TriggerNormalOutput(DialogueId)
end

function M:IsDialogueNodeFinish()
  local DialogueData = self:TryGetCurrentDialogueData()
  if not DialogueData then
    return true
  end
  if self.RuntimeProxy and self.Index == #self.DialogueTables then
    return self.SequenceFinishIndex == nil
  end
end

function M:IterForward()
  self.Index = self.Index + 1
  local DialogueData = self:TryGetCurrentDialogueData()
  DebugPrint("DialogueFlowNode:IterForward", self.Index, DialogueData and DialogueData.DialogueId, UE.UKismetSystemLibrary.GetFrameCount())
  if not DialogueData then
    self:FinishDialogue()
    return
  end
  if self.SequencePlayer then
    self.SequenceFinishIndex = self.Index
    local Index = self.Index
    if not self.SequencePlayer:TryPlayToDialogueId(DialogueData.DialogueId) then
      if 1 == Index then
        self:EnableResetPhysic(false)
      end
      self:IterForward()
    elseif 1 == Index then
      self:EnableResetPhysic(false)
    end
  else
    local FlowDialogueData = FFlowDialogue.New(DialogueData, self.DialogueSettingsTable[DialogueData.DialogueId])
    self:PlayDialogue(FlowDialogueData)
  end
end

function M:Start()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  if not DialogueFlowGraphComponent then
    local Message = string.format("当前Dialogue节点，注册的Task不存在 DialogueFlowGraphComponent，请注册")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:DialogueFlowGraphComponent无效", Message)
    return
  end
  local DialogueRecordComponent = self:TryGetRecordComponent()
  if not DialogueRecordComponent then
    local Message = string.format("当前Dialogue节点，注册的Task不存在 DialogueRecordComponent，请注册")
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:DialogueRecordComponent无效", Message)
    return
  end
  self.DialogueSettingsTable = self.DialogueSetting:ToTable()
  local DialogueIds = self.DialogueData:ToTable()
  self.DialogueTables = DialogueIds
  self.Index = 0
  self:TryStartSequence()
  self:IterForward()
end

function M:BindSequenceActors()
  local DialogueAssets = self:GetFlowAsset()
  local LevelSequenceActor = DialogueAssets.LevelSequenceActor
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TalkTask = self:TryGetTalkTask()
  local BindNpcs = TalkTask.TalkTaskData.TalkActors
  local LevelSequence = self.LevelSequence
  self.SavedLodActor = {}
  local bMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  for _, NpcData in pairs(BindNpcs) do
    local UnitId = NpcData.TalkActorId
    local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
    if TalkActorData and TalkActorData.TalkActor then
      local NpcIdTag = tostring(UnitId)
      if UTalkFunctionLibrary.IsSequenceOwnTag(LevelSequence, NpcIdTag) then
        LevelSequenceActor:AddBindingByTag(NpcIdTag, TalkActorData.TalkActor, false)
        local TalkActor = TalkActorData.TalkActor
        if TalkActor.Mesh and not bMobile then
          TalkActor.Mesh:SetForcedLOD(1)
          self.SavedLodActor[TalkActor] = TalkActor.Mesh:GetForcedLOD()
        end
      end
    end
  end
  self:EnableResetPhysic(true)
  local UPostProcessFunctionLibrary = LoadClass(LibraryPath)
  if UPostProcessFunctionLibrary and UPostProcessFunctionLibrary.MobileCloseLights then
    UPostProcessFunctionLibrary.MobileCloseLights(LevelSequenceActor)
  end
end

function M:TryStartSequence()
  if not IsValid(self.LevelSequence) then
    return false
  end
  self:PlaySequence()
  if not IsValid(self.SequencePlayer) or not IsValid(self.RuntimeProxy) then
    return
  end
  local RuntimeProxy = self.RuntimeProxy
  RuntimeProxy.OnSpecialDialoguePlay:Add(self, self.SequenceIterForward)
  RuntimeProxy.OnSpecialDialogueEnd:Add(self, self.SequenceIterEnd)
  self.SequencePlayer.OnFinished:Add(self, self.OnSequenceFinish)
  self.SequencePlayer.PauseAtFrameEvent:Add(self, self.OnSequencePause)
  self:BindSequenceActors()
  RuntimeProxy:SetUpLua(self:TryGetTalkTask())
  return true
end

function M:SequenceIterForward(Section)
  if self.IterSection then
    local Message = string.format("当前Dialogue节点，Sequence 上句台本尚未结束 %d，就要播放下一句台本 %d", self.IterSection.DialogueId, Section.DialogueId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:SequenceIterForward", Message)
  end
  DebugPrint("SequenceIterForward", Section.DialogueId, UE.UKismetSystemLibrary.GetFrameCount())
  self.IterSection = Section
  local DialogueData = self:TryGetCurrentDialogueData()
  if Section.DialogueId ~= DialogueData.DialogueId then
    local Message = string.format("当前Dialogue节点，Sequence 上句台本尚未结束 %d，就要播放下一句台本 %d", DialogueData.DialogueId, Section.DialogueId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "Flow对话节点出错:SequenceIterForward", Message)
  end
  local FlowDialogueData = FFlowDialogue.New(DialogueData, self.DialogueSettingsTable[DialogueData.DialogueId], Section)
  local Dialogue = DataMgr.Dialogue[DialogueData.DialogueId]
  if Section.bAutoPlay then
    FlowDialogueData:SetAutoToNext()
  end
  FlowDialogueData:SetForbiddenDSL(true)
  FlowDialogueData:SetWaitAsyncTag(true)
  self:PlayDialogue(FlowDialogueData)
end

function M:SequenceIterEnd(DialogueId)
  self.IterSection = nil
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ForceCompleteDialogue(DialogueId)
end

function M:OnSequenceFinish()
  if self.SequenceFinish then
    return
  end
  self.RuntimeProxy.OnPlayDialogue:Clear()
  self.RuntimeProxy.OnEndPlayDialogue:Clear()
  self.SequencePlayer.OnFinished:Clear()
  self.SequenceFinish = true
  self:FinishDialogue()
end

function M:OnSequencePause()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  if self.Index == self.SequenceFinishIndex then
    self.SequenceFinishIndex = nil
  end
  DialogueFlowGraphComponent:CompleteWaitSequence()
end

function M:SkipCurrentDialogue()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:SkipDialogue()
end

function M:TrySkipToDialogueStart()
  if self.SequencePlayer then
    local DialogueData = self:TryGetCurrentDialogueData()
    DebugPrint("DialogueFlowNode: TrySkipToDialogueStart", DialogueData.DialogueId, UE.UKismetSystemLibrary.GetFrameCount())
    self.SequencePlayer:TrySkipToDialogueId(DialogueData.DialogueId)
  end
end

function M:Skip()
  if self.RuntimeProxy then
    self.RuntimeProxy:SetInSkip(true)
  end
  repeat
    self:TrySkipToDialogueStart()
    self:SkipCurrentDialogue()
    if self.RuntimeProxy then
      self.RuntimeProxy:SetInSkip(true)
    end
    self:IterForward()
  until self:IsDialogueNodeFinish()
  if self.RuntimeProxy then
    self.RuntimeProxy:SetInSkip(false)
  end
end

function M:CanSkip()
  return true
end

function M:Pause()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:PauseDialogue()
  if self.SequencePlayer then
    self.SequencePlayer:Pause()
  end
end

function M:Resume()
  local DialogueFlowGraphComponent = self:TryGetFlowGraphComponent()
  DialogueFlowGraphComponent:ResumeDialogue()
  if self.SequencePlayer then
    local DialogueData = self:TryGetCurrentDialogueData()
    if not DialogueData then
      return
    end
    self.SequencePlayer:TryPlayToDialogueId(DialogueData.DialogueId)
  end
end

function M:EnableResetPhysic(bEnable)
  local TalkContext = GWorld.GameInstance:GetTalkContext()
  local TalkTask = self:TryGetTalkTask()
  local BindNpcs = TalkTask.TalkTaskData.TalkActors
  self.SavedLodActor = {}
  for _, NpcData in pairs(BindNpcs) do
    local UnitId = NpcData.TalkActorId
    local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
    if TalkActorData and IsValid(TalkActorData.TalkActor) then
      TalkActorData.TalkActor.EnableResetPhysic = bEnable
    end
  end
end

function M:K2_Cleanup()
  if not self.RuntimeProxy then
    return
  end
  self.RuntimeProxy.OnPlayDialogue:Clear()
  self.RuntimeProxy.OnEndPlayDialogue:Clear()
  self.SequencePlayer.OnFinished:Clear()
  if self.SavedLodActor then
    for TalkActor, Lod in pairs(self.SavedLodActor) do
      if TalkActor.Mesh then
        TalkActor.Mesh:SetForcedLOD(Lod)
      end
    end
    self.SavedLodActor = nil
  end
end

return M
