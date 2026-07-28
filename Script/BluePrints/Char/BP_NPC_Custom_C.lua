require("UnLua")
local StoryPlayableUtils = require("BluePrints.Story.StoryPlayableUtils")
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local QuestStateType = {Doing = 1, Success = 2}
local TalkStateType = {
  Compelete = 0,
  UnCompelete = 1,
  CheckSuccess = 2,
  CheckFail = 3
}
local QuestChainStateType = {Doing = 1, Success = 2}
local M = Class()

function M:ReceiveBeginPlay()
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  if "Android" == PlatformName or "IOS" == PlatformName or "OpenHarmony" == PlatformName then
    self.bMeshLodBudgetEnable = true
  else
    self.bMeshLodBudgetEnable = false
  end
  self.bHiddenBudgetEnable = true
  self.IsNPC = true
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if GameInstance then
    local TalkContext = GameInstance:GetTalkContext()
    if IsValid(TalkContext) then
      TalkContext:RecordCustomNPCInfo(self, true)
    end
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.CustomNpcSet:Add(self)
  GameState:RecordNpcEntity(self, true)
  EventManager:AddEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, self, self.SetCustomNpcFlexibShowOrHide)
  self:SetCustomNpcFlexibShowOrHide()
  EventManager:AddEvent(EventID.CloseLoading, self, self.ResetLocation)
  self.IsDestroied = false
  self.Overridden.ReceiveBeginPlay(self)
end

function M:ResetLocation()
  if self.bInteractiveState == false then
    return
  end
  local SpawnPos = self:K2_GetActorLocation()
  local HalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
  local MeshOffsetZ = -self.Mesh.RelativeLocation.Z
  if HalfHeight < MeshOffsetZ and MeshOffsetZ < HalfHeight + 5 then
    HalfHeight = MeshOffsetZ
  end
  local Start = SpawnPos + FVector(0, 0, HalfHeight)
  local End = SpawnPos + FVector(0, 0, -500)
  local HitResult = FHitResult()
  local Ret = UE4.UKismetSystemLibrary.LineTraceSingle(self, Start, End, ETraceTypeQuery.TraceScene, true, nil, 0, HitResult, true)
  if Ret then
    DebugPrint("CustomNPC半高：", HalfHeight, "打中位置：", HitResult.ImpactPoint, "打中目标：", HitResult.Actor:GetName(), "Pawn名字：", self:GetName(), "============sssss================")
    local SurfacePos = FVector(HitResult.ImpactPoint.X, HitResult.ImpactPoint.Y, HitResult.ImpactPoint.Z + HalfHeight)
    self:K2_SetActorLocation(SurfacePos, false, nil, false)
    if math.abs(HitResult.ImpactPoint.Z - SpawnPos.Z) > HalfHeight * 2 then
      Utils.ScreenPrint("CustomNPC静态刷新点位置异常,Pawn名字：" .. self:GetName() .. " SpawnPos.Z：" .. SpawnPos.Z .. " ImpactPoint.Z:" .. HitResult.ImpactPoint.Z)
    end
  end
end

function M:ReceiveEndPlay()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if GameInstance then
    local TalkContext = GameInstance:GetTalkContext()
    if IsValid(TalkContext) then
      TalkContext:RemoveCustomNPCInfo(self)
    end
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.CustomNpcSet:Remove(self)
  GameState:RecordNpcEntity(self, false)
  EventManager:RemoveEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, self)
  EventManager:RemoveEvent(EventID.CloseLoading, self)
  self.IsDestroied = true
  self:DeInitLightBubbleTalk()
end

function M:SetCustomNpcFlexibShowOrHide()
  if Const.IsOpenFlexibleShowHideCppOpt then
    self:SetCustomNpcFlexibShowOrHideOptimized()
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TempFlexibleMap = {}
  local FNpcArrayNum = self.FlexibleShowHide:Num()
  for FNpcArray, IsHide in pairs(self.FlexibleShowHide) do
    local NewFlexibleMapElement = {
      NpcArray = {Quest = nil, ImpressionTalk = nil},
      IsHide = false
    }
    NewFlexibleMapElement.NpcArray = FNpcArray
    NewFlexibleMapElement.IsHide = IsHide
    TempFlexibleMap[FNpcArrayNum] = NewFlexibleMapElement
    FNpcArrayNum = FNpcArrayNum - 1
  end
  
  local function SetNpcShowOrHide(IsShow)
    if IsShow then
      self:SetCustomNpcHideTag("Flexible", false)
      self:SetCollisionDisableTag("Flexible", false)
    else
      self:SetCustomNpcHideTag("Flexible", true)
      self:SetCollisionDisableTag("Flexible", true)
    end
  end
  
  for i = 1, self.FlexibleShowHide:Num() do
    local TargetQuestId = TempFlexibleMap[i].NpcArray.Quest.QuestId
    local TargetQuestState = TempFlexibleMap[i].NpcArray.Quest.MyQuestState
    local TargetTalkTriggerId = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkTriggerId
    local TalkState = TempFlexibleMap[i].NpcArray.ImpressionTalk.TalkQuestState
    local FlexibleQuestChainId = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainId
    local FlexibleQuestChainState = TempFlexibleMap[i].NpcArray.QuestChain.QuestChainState
    if 0 == TempFlexibleMap[i].NpcArray.EditableStructType then
      local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))
      local QuestStateType = {Doing = 1, Success = 2}
      if not Avatar.QuestChains[QuestChainId] then
        DebugPrint("QuestChain is unexist:", QuestChainId)
      else
        local QuestChains = Avatar.QuestChains[QuestChainId]
        if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        elseif TargetQuestState == QuestStateType.Success then
          if QuestChains:CheckQuestIdComplete(TargetQuestId) then
            SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
            return
          end
        else
          DebugPrint("QuestChain state is error:", QuestChainId)
        end
      end
    elseif 1 == TempFlexibleMap[i].NpcArray.EditableStructType then
      local TalkStateType = {
        Compelete = 0,
        UnCompelete = 1,
        CheckSuccess = 2,
        CheckFail = 3
      }
      if TalkState == TalkStateType.Compelete then
        if ImpressionModel:IsStorylineComplete(TargetTalkTriggerId) then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        end
      elseif TalkState == TalkStateType.UnCompelete then
        if ImpressionModel:IsStorylineUnComplete(TargetTalkTriggerId) then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        end
      elseif TalkState == TalkStateType.CheckSuccess then
        if ImpressionModel:IsStorylineSuccess(TargetTalkTriggerId) then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        end
      else
        if TalkState == TalkStateType.CheckFail and ImpressionModel:IsStorylineFailure(TargetTalkTriggerId) then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        else
        end
      end
    elseif 2 == TempFlexibleMap[i].NpcArray.EditableStructType then
      local QuestChainStateType = {Doing = 1, Success = 2}
      if not Avatar.QuestChains[FlexibleQuestChainId] then
        DebugPrint("QuestChain is unexist:", FlexibleQuestChainId)
      else
        local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]
        if FlexibleQuestChainState == QuestChainStateType.Doing and TargetQuestChain:IsDoing() then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        elseif FlexibleQuestChainState == QuestChainStateType.Success and TargetQuestChain:IsFinish() then
          SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
          return
        else
          DebugPrint("QuestChain state is error:", FlexibleQuestChainId)
        end
      end
    elseif 4 == TempFlexibleMap[i].NpcArray.EditableStructType then
      local FuncName = TempFlexibleMap[i].NpcArray.Var.FunctionName
      local VarName = TempFlexibleMap[i].NpcArray.Var.VarName
      local ParamName = TempFlexibleMap[i].NpcArray.Var.ParamName
      local ParamValue = TempFlexibleMap[i].NpcArray.Var.ParamValue
      if self:FlexibleCheckVarFunc(FuncName, VarName, ParamName, ParamValue) then
        SetNpcShowOrHide(TempFlexibleMap[i].IsHide)
        return
      end
    end
  end
end

function M:SetNpcShowOrHide(IsShow)
  if IsShow then
    self:SetCustomNpcHideTag("Flexible", false)
    self:SetCollisionDisableTag("Flexible", false)
  else
    self:SetCustomNpcHideTag("Flexible", true)
    self:SetCollisionDisableTag("Flexible", true)
  end
end

function M:SetCustomNpcFlexibShowOrHideOptimized()
  if self.GenerateReverseFlexibleData == nil or self:GenerateReverseFlexibleData() == false then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  for i = 1, self.ReverseFlexibleShowHide:Num() do
    if 0 == self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.EditableStructType then
      local TargetQuestId = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Quest.QuestId
      local IsActive = self.ReverseFlexibleShowHide:FindRef(i).IsActive
      local TargetQuestState = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Quest.MyQuestState
      local QuestChainId = tonumber(string.sub(TargetQuestId, 1, 6))
      if not Avatar.QuestChains[QuestChainId] then
      else
        local QuestChains = Avatar.QuestChains[QuestChainId]
        if TargetQuestState == QuestStateType.Doing and QuestChains.DoingQuestId == TargetQuestId then
          self:SetNpcShowOrHide(IsActive)
          return
        else
          if TargetQuestState == QuestStateType.Success and QuestChains:CheckQuestIdComplete(TargetQuestId) then
            self:SetNpcShowOrHide(IsActive)
            return
          else
          end
        end
      end
    elseif 1 == self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.EditableStructType then
      local TargetTalkTriggerId = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.ImpressionTalk.TalkTriggerId
      local TalkState = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.ImpressionTalk.TalkQuestState
      local IsActive = self.ReverseFlexibleShowHide:FindRef(i).IsActive
      if TalkState == TalkStateType.Compelete then
        if ImpressionModel:IsStorylineComplete(TargetTalkTriggerId) then
          self:SetNpcShowOrHide(IsActive)
          return
        end
      elseif TalkState == TalkStateType.UnCompelete then
        if ImpressionModel:IsStorylineUnComplete(TargetTalkTriggerId) then
          self:SetNpcShowOrHide(IsActive)
          return
        end
      elseif TalkState == TalkStateType.CheckSuccess then
        if ImpressionModel:IsStorylineSuccess(TargetTalkTriggerId) then
          self:SetNpcShowOrHide(IsActive)
          return
        end
      else
        if TalkState == TalkStateType.CheckFail and ImpressionModel:IsStorylineFailure(TargetTalkTriggerId) then
          self:SetNpcShowOrHide(IsActive)
          return
        else
        end
      end
    elseif 2 == self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.EditableStructType then
      local FlexibleQuestChainId = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.QuestChain.QuestChainId
      local FlexibleQuestChainState = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.QuestChain.QuestChainState
      local IsActive = self.ReverseFlexibleShowHide:FindRef(i).IsActive
      if not Avatar.QuestChains[FlexibleQuestChainId] then
      else
        local TargetQuestChain = Avatar.QuestChains[FlexibleQuestChainId]
        if FlexibleQuestChainState == QuestChainStateType.Doing and Avatar:IsQuestChainDoing(FlexibleQuestChainId) then
          self:SetNpcShowOrHide(IsActive)
          return
        else
          if FlexibleQuestChainState == QuestChainStateType.Success and Avatar:IsQuestChainFinished(FlexibleQuestChainId) then
            self:SetNpcShowOrHide(IsActive)
            return
          else
          end
        end
      end
    elseif 4 == self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.EditableStructType then
      local FuncName = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Var.FunctionName
      local VarName = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Var.VarName
      local ParamName = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Var.ParamName
      local ParamValue = self.ReverseFlexibleShowHide:FindRef(i).ReverseShowHideArray.Var.ParamValue
      local IsActive = self.ReverseFlexibleShowHide:FindRef(i).IsActive
      if self:FlexibleCheckVarFunc(FuncName, VarName, ParamName, ParamValue) then
        self:SetNpcShowOrHide(IsActive)
        return
      end
    end
  end
end

function M:FlexibleCheckVarFunc(FunctionName, VarName, ParamName, ParamValue)
  if not VarName or "" == VarName then
    return false
  end
  local VarInfo = DataMgr.StoryVariable[VarName]
  if not VarInfo then
    return true
  end
  local VarLogType = UE.EStoryLogType.StoryVar
  local NewVarInfos = {}
  if tonumber(ParamValue) then
    NewVarInfos[ParamName] = tonumber(ParamValue)
  else
    NewVarInfos[ParamName] = ParamValue
  end
  local StorySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UStorySubsystem:StaticClass())
  local Ret = StorySubsystem:ExecuteBlueprintVarFunction(FunctionName, VarName, NewVarInfos, nil, true)
  if type(Ret) ~= "number" or 0 ~= Ret % 1 then
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, VarLogType, "CustomNPC灵活显隐出错", "函数[" .. tostring(FunctionName) .. "]的返回值不是bool类型")
    return false
  end
  if 0 == Ret then
    return false
  elseif 1 == Ret then
    return true
  end
  return true
end

function M:ActiveSetCustomNpcHideByAvatarSuitData()
  if 0 == self.AtmosphereTagArray:Num() then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local SuitData = Avatar.Suits:GetSuitBase(CommonConst.SuitType.PlayerCharacterSuit)
    if SuitData and SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag) then
      local SubSuitData = SuitData:GetSubSuitBase(CommonConst.PlayerCharacterSuit.NpcHideShowTag)
      for Tag, Value in pairs(SubSuitData) do
        if self.AtmosphereTagArray:Contains(Tag) then
          self:SetCustomNpcHideTag(Tag, Value)
          self:SetCollisionDisableTag(Tag, Value)
        end
      end
    end
  end
end

function M:InitHeadWidgetComponent()
  if IsValid(self.HeadWidgetComponent) then
    return
  end
  local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
  if not HeadUISubsystem then
    return
  end
  self.HeadWidgetComponent = HeadUISubsystem:InitHeadWidgetComponent(self)
end

function M:EnableHeadWidget(WidgetName, bEnable, ...)
  if bEnable then
    self:InitHeadWidgetComponent()
  end
  if IsValid(self.HeadWidgetComponent) then
    if bEnable then
      if self.HeadWidgetComponent:NeedForceInit() then
        self.HeadWidgetComponent:AdjustSelfTransform()
      end
      self.HeadWidgetComponent:EnableWidget(WidgetName, ...)
    else
      self.HeadWidgetComponent:DisableWidget(WidgetName, ...)
    end
  end
end

function M:EnableBubbleWidget(bEnable, Content)
  self:EnableHeadWidget("Long_Bubble", bEnable, Content)
end

function M:EnableNameWidget(bEnable, Name)
  self:EnableHeadWidget("Name", bEnable, GText(Name))
end

function M:PreEnterStory(OnFinished, bCacheMeshMaterials, bPauseBT)
  if self.bInStory then
    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
    return
  end
  if bCacheMeshMaterials and self.CharacterFashion then
    self.CharacterFashion:PreEnterStory(bCacheMeshMaterials)
  end
  self:AddTimer(0.01, function()
    self.NativeMeshTickOptions = {}
    self.NativeInSetShadow = {}
    local SKMeshComps = self:K2_GetComponentsByClass(USkeletalMeshComponent):ToTable()
    for _, SKMeshComp in pairs(SKMeshComps) do
      if IsValid(SKMeshComp) then
        self.NativeMeshTickOptions[SKMeshComp] = SKMeshComp.VisibilityBasedAnimTickOption
        SKMeshComp.VisibilityBasedAnimTickOption = EVisibilityBasedAnimTickOption.AlwaysTickPoseAndRefreshBones
        self.NativeInSetShadow[SKMeshComp] = SKMeshComp.bCastInsetShadow
        SKMeshComp:SetCastInsetShadow(true)
      end
    end
  end)
  if bPauseBT and self.StopBT then
    self:StopBT("Talk")
  end
  self.bInStory = true
  StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

function M:PreExitStory(OnFinished, bStartBT, bIsExternal)
  if not self.bInStory then
    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
    return
  end
  if self.CharacterFashion then
    self.CharacterFashion:PreExitStory()
  end
  for SKMeshComp, TickOption in pairs(self.NativeMeshTickOptions or {}) do
    if IsValid(SKMeshComp) then
      SKMeshComp.VisibilityBasedAnimTickOption = TickOption
    end
  end
  self.NativeMeshTickOptions = nil
  for SKMeshComp, bCastInsetShadow in pairs(self.NativeInSetShadow or {}) do
    if IsValid(SKMeshComp) then
      SKMeshComp:SetCastInsetShadow(bCastInsetShadow)
    end
  end
  self.NativeInSetShadow = nil
  if bStartBT and self.RestartBT then
    self:RestartBT()
  end
  local EMGameState = UE4.UGameplayStatics.GetGameState(self)
  EMGameState:HideNpc(false, Const.TalkHideTag, self)
  self.bInStory = false
  StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

function M:IsInStory()
  return self.bInStory
end

return M
