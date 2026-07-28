local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent"
})

function M:InitializeLua(TalkTask)
  self.TalkTask = TalkTask
  self.SaveTickOptimizations = nil
  self.RecoverTimer = nil
  self.OnFinish:Add(self, self.OnFinishEvent)
  self.CachedNpcTransforms = {}
end

function M:PreStartFlowNode(StartNode)
  self.PendingStartNode = StartNode
  if self.TalkTask then
    self.TalkTask:ContinueFlowStart(function()
      local Node = self.PendingStartNode
      self.PendingStartNode = nil
      if IsValid(Node) then
        Node:TriggerFirstOutput(true)
      end
      if self.RestartDialogueId then
        self:SetSkipInRestartTag(true)
        self:SkipToEnd()
        self:SetSkipInRestartTag(nil)
      end
    end)
  elseif UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    self:StartDebugTalkTaskCreation()
  end
end

function M:StartDebugTalkTaskCreation()
  local TemplatePath = UE4.UKismetSystemLibrary.GetPathName(self.TemplateAsset)
  local AssetName = UE4.UNameStringFunctionLibrary.LongPathNameToName(TemplatePath)
  Utils.ScreenPrint("DialogueFlow Debug Run: " .. TemplatePath)
  local TS = TalkSubsystem()
  TS:RegisterExistingFlowTalkTask(TemplatePath, self)
  local RawData = self:BuildDebugTalkNodeData(TemplatePath, AssetName)
  if not RawData then
    return
  end
  self.bDebugRun = true
  local Key = TS:RegisterTalkData(RawData)
  local Task, TaskData = TS:CreateTalkTaskData(Key)
  TS:TryFireEnterStoryEvent(Task)
  Task:ContinueFlowStart(function()
    local Node = self.PendingStartNode
    self.PendingStartNode = nil
    if IsValid(Node) then
      Node:TriggerFirstOutput(true)
    end
    if self.RestartDialogueId then
      self:SetSkipInRestartTag(true)
      self:SkipToEnd()
      self:SetSkipInRestartTag(nil)
    end
  end)
end

function M:BuildDebugTalkNodeData(AssetPath, AssetName)
  local pro_path = UE4.UKismetSystemLibrary.GetProjectContentDirectory()
  local talkNodesPath = pro_path .. "../Tools/storycreator/talk_nodes.json"
  if UBlueprintPathsLibrary.FileExists(talkNodesPath) then
    local a, Info = UE4.URuntimeCommonFunctionLibrary.ParseTalkNodesByPath(GWorld, talkNodesPath, AssetName, true)
    if Info and "" ~= Info then
      local TalkNodeInfo = Json.decode(Info)
      local FilePath = TalkNodeInfo.filePath
      Utils.ScreenPrint("DialogueFlow Debug Run TalkNode: " .. FilePath)
      if FilePath then
        local ModulePath = self:FilePathToModulePath(FilePath)
        local ok, module = pcall(require, ModulePath)
        if ok and module then
          local Props = self:ExtractTalkNodeProps(module, AssetName, true)
          if Props then
            return Props
          end
        end
      end
    end
  end
  Utils.ScreenPrint("DialogueFlow Debug Run: fallback to FlowTemplate")
  local ok, module = pcall(require, "StoryCreator.StoryFiles.FlowTemplate")
  if ok and module then
    local Props = self:ExtractTalkNodeProps(module, AssetName, false)
    if Props then
      Props.FlowAssetPath = AssetPath
    end
    return Props
  end
  return nil
end

function M:FilePathToModulePath(FilePath)
  local ModulePath = string.gsub(FilePath, "../../Content/Script/", "")
  ModulePath = string.gsub(ModulePath, "%.lua$", "")
  ModulePath = string.gsub(ModulePath, "[/\\]", ".")
  return ModulePath
end

function M:ExtractTalkNodeProps(Module, AssetName, bMatchFlowAsset)
  local storyNodes = Module.storyNodeData or {}
  for _, storyNode in pairs(storyNodes) do
    local nodeData = storyNode.questNodeData and storyNode.questNodeData.nodeData or {}
    for nodeId, node in pairs(nodeData) do
      if node.type == "TalkNode" and node.propsData then
        if not bMatchFlowAsset then
          return node.propsData
        end
        if node.propsData.FlowAssetPath and node.propsData.FlowAssetPath ~= "" and string.find(node.propsData.FlowAssetPath, AssetName, 1, true) then
          return node.propsData
        end
      end
    end
  end
  return nil
end

function M:IsFinish()
  return self:IsActive()
end

function M:GetTalkActorData()
  if self.CreatTalkActors then
    return self.CreatTalkActors
  end
  local TalkActors = {}
  local RawTalkActors = self.TalkActors:ToTable()
  for _, RawTalkActor in pairs(RawTalkActors) do
    if RawTalkActor.Type == ETalkActorType.Player then
      table.insert(TalkActors, {
        TalkActorType = "Player",
        TalkActorId = 0,
        TalkActorVisible = RawTalkActor.Visibility,
        Source = "FlowAsset"
      })
    else
      table.insert(TalkActors, {
        TalkActorType = "Npc",
        TalkActorId = RawTalkActor.UnitId,
        TalkActorVisible = RawTalkActor.Visibility,
        Source = "FlowAsset"
      })
    end
  end
  self.CreatTalkActors = TalkActors
  return TalkActors
end

function M:SetRestartDialogueId(DialogueId)
  self.RestartDialogueId = DialogueId
end

function M:SetSkipInRestartTag(bTag)
  self.bIsInRestartDialogueSkip = bTag
end

function M:OnSequenceCameraChanged(CameraComponent)
  if not IsValid(CameraComponent) then
    return
  end
  self:CloseTalkActorsOptimization()
end

function M:CloseTalkActorsOptimization()
  if not self.TalkTask then
    return
  end
  local TalkTask = self.TalkTask
  local TalkContext = TalkTask.TalkContext
  if not TalkContext then
    return
  end
  if self.RecoverTimer then
    self:RemoveTimer(self.RecoverTimer)
    self.RecoverTimer = nil
  end
  self.RecoverTimer = self:AddTimer(0.1, function()
    self:RecoverTalkActorsOptimization()
  end)
  if self.SaveTickOptimizations then
    return
  end
  local SaveTickOptimizations = {}
  self.SaveTickOptimizations = SaveTickOptimizations
  for _, NpcData in pairs(TalkTask.TalkTaskData.TalkActors) do
    local UnitId = NpcData.TalkActorId
    local TalkActorData = TalkContext:GetTalkActorData(TalkTask, UnitId)
    local TalkActor = TalkActorData and TalkActorData.TalkActor
    if IsValid(TalkActor) and IsValid(TalkActor.Mesh) then
      SaveTickOptimizations[TalkActor] = TalkActor.Mesh.VisibilityBasedAnimTickOption
      TalkActor.Mesh.VisibilityBasedAnimTickOption = UE4.EVisibilityBasedAnimTickOption.AlwaysTickPoseAndRefreshBones
      if TalkActor.ForceResetDynamics and not TalkActor.Mesh:WasRecentlyRendered(0.05) then
        TalkActor:ForceResetDynamics()
        USequenceMontageLibrary.ForceRefreshAnimation(TalkActor)
      end
    end
  end
end

function M:OnFinishEvent()
  self:RecoverTalkActorsOptimization()
  self:ResetNpcTransform()
  if self:GetFinishPolicy() == UE4.EFlowFinishPolicy.Abort and self.TalkTask then
    self.TalkTask:EndDialogue()
  end
  if self.bDebugRun then
    self.bDebugRun = nil
    TalkSubsystem():TryFireLeaveStoryEvent()
  end
end

function M:RecoverTalkActorsOptimization()
  if self.RecoverTimer then
    self:RemoveTimer(self.RecoverTimer)
    self.RecoverTimer = nil
  end
  if not self.SaveTickOptimizations then
    return
  end
  local SaveTickOptimizations = self.SaveTickOptimizations
  self.SaveTickOptimizations = nil
  for TalkActor, TickOption in pairs(SaveTickOptimizations) do
    if IsValid(TalkActor) and IsValid(TalkActor.Mesh) then
      TalkActor.Mesh.VisibilityBasedAnimTickOption = TickOption
    end
  end
end

function M:TryCacheNpcTransform(Npc)
  if not Npc or not IsValid(Npc) then
    return
  end
  if self.CachedNpcTransforms[Npc] then
    return
  end
  self.CachedNpcTransforms[Npc] = Npc:GetTransform()
end

function M:TryRecoverNpcTransform(Npc)
  if not Npc or not IsValid(Npc) then
    return
  end
  if not self.CachedNpcTransforms[Npc] then
    return
  end
  Npc:K2_SetActorTransform(self.CachedNpcTransforms[Npc], false, nil, true)
  self.CachedNpcTransforms[Npc] = nil
end

function M:ResetNpcTransform()
  for Npc, _ in pairs(self.CachedNpcTransforms) do
    self:TryRecoverNpcTransform(Npc)
  end
end

return M
