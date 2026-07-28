require("UnLua")
local HitResult = FHitResult()
local M = {}

local function GetObjectNameSafe(Object)
  if not Object then
    return "None"
  end
  if Object.GetName then
    return Object:GetName()
  end
  return tostring(Object)
end

function M:Init(Params)
  Params = Params or {}
  self.ViewUI = Params.ViewUI
  self.SceneService = Params.SceneService
  self.EnableReflection = Params.EnableReflection ~= false
  self.EnableSelectionCollision = Params.EnableSelectionCollision == true
  self.Actor = nil
  self.ReflectionActor = nil
  self.OwnsActorInstance = false
  self.OwnsReflectionInstance = false
  self.Avatar = nil
  self.CharInfo = nil
  self.HideTags = {}
  self.CurrentTransform = nil
  self.CurrentAppearanceInfo = nil
  self.ScenePlacementTransform = nil
  self.BaseRotation = nil
  self.RootActor = nil
end

local function SetActorLocationInternal(TargetActor, Loc)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorLocation(Loc, false, HitResult, false)
end

local function SetActorRotationInternal(TargetActor, Rot)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorRotation(Rot, false, HitResult, false)
end

local function SetActorScaleInternal(TargetActor, Scale)
  if not TargetActor then
    return
  end
  TargetActor:SetActorScale3D(Scale)
end

local function SetActorRelativeLocationInternal(TargetActor, Loc)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorRelativeLocation(Loc, false, HitResult, false)
end

local function SetActorRelativeRotationInternal(TargetActor, Rot)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorRelativeRotation(Rot, false, HitResult, false)
end

local function SetActorRelativeScaleInternal(TargetActor, Scale)
  if not TargetActor then
    return
  end
  TargetActor:SetActorRelativeScale3D(Scale)
end

local function AttachActorToRoot(TargetActor, RootActor)
  if not TargetActor or not RootActor then
    return
  end
  TargetActor:K2_AttachToActor(RootActor, "", UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, UE4.EAttachmentRule.KeepRelative, false)
end

local function BuildRelativeTransform(ScenePlacementTransform, BaseRotation, RelativeTransform)
  if not RelativeTransform then
    return nil
  end
  ScenePlacementTransform = ScenePlacementTransform or FTransform()
  local ResultTransform = FTransform()
  ResultTransform.Translation = UE4.UKismetMathLibrary.TransformLocation(ScenePlacementTransform, RelativeTransform.Translation or FVector(0, 0, 0))
  if RelativeTransform.Rotation then
    local RotationTransform = FTransform()
    RotationTransform.Rotation = (BaseRotation or FRotator(0, 0, 0)):ToQuat()
    RotationTransform.Scale3D = FVector(1, 1, 1)
    ResultTransform.Rotation = UE4.UKismetMathLibrary.TransformRotation(RotationTransform, RelativeTransform.Rotation:ToRotator()):ToQuat()
  else
    ResultTransform.Rotation = (BaseRotation or FRotator(0, 0, 0)):ToQuat()
  end
  ResultTransform.Scale3D = RelativeTransform.Scale3D or ScenePlacementTransform.Scale3D or FVector(1, 1, 1)
  return ResultTransform
end

local function BuildWorldTransformFromDraft(SceneRootTransform, ScenePlacementTransform, BaseRotation, RelativeTransform)
  local LocalTransform = BuildRelativeTransform(ScenePlacementTransform, BaseRotation, RelativeTransform)
  if not LocalTransform then
    return nil
  end
  SceneRootTransform = SceneRootTransform or FTransform()
  local ResultTransform = FTransform()
  ResultTransform.Translation = UE4.UKismetMathLibrary.TransformLocation(SceneRootTransform, LocalTransform.Translation or FVector(0, 0, 0))
  local LocalRotator = LocalTransform.Rotation and LocalTransform.Rotation:ToRotator() or FRotator(0, 0, 0)
  ResultTransform.Rotation = UE4.UKismetMathLibrary.TransformRotation(SceneRootTransform, LocalRotator):ToQuat()
  ResultTransform.Scale3D = LocalTransform.Scale3D or SceneRootTransform.Scale3D or FVector(1, 1, 1)
  return ResultTransform
end

local function BuildDefaultRelativeTransform(ScenePlacementTransform, BaseRotation)
  local RelativeTransform = FTransform()
  RelativeTransform.Translation = ScenePlacementTransform and ScenePlacementTransform.Translation or FVector(0, 0, 0)
  RelativeTransform.Rotation = (BaseRotation or FRotator(0, 90, 0)):ToQuat()
  RelativeTransform.Scale3D = ScenePlacementTransform and ScenePlacementTransform.Scale3D or FVector(1, 1, 1)
  return RelativeTransform
end

local function SetActorRelativeTransformInternal(TargetActor, Transform)
  if not TargetActor then
    return
  end
  TargetActor:K2_SetActorRelativeTransform(Transform, false, nil, false)
end

local function GetActorRelativeTransformInternal(TargetActor)
  if not TargetActor then
    return nil
  end
  if TargetActor.GetActorRelativeTransform then
    return TargetActor:GetActorRelativeTransform()
  end
  return nil
end

local function BuildDraftTransformFromRelative(ScenePlacementTransform, BaseRotation, RelativeTransform)
  if not RelativeTransform then
    return nil
  end
  local DraftTransform = FTransform()
  local BaseTranslation = ScenePlacementTransform and ScenePlacementTransform.Translation or FVector(0, 0, 0)
  DraftTransform.Translation = RelativeTransform.Translation - BaseTranslation
  local RelativeRotator = RelativeTransform.Rotation and RelativeTransform.Rotation:ToRotator() or FRotator(0, 0, 0)
  local BaseRotator = BaseRotation or FRotator(0, 0, 0)
  DraftTransform.Rotation = FRotator(RelativeRotator.Pitch - BaseRotator.Pitch, RelativeRotator.Yaw - BaseRotator.Yaw, RelativeRotator.Roll - BaseRotator.Roll):ToQuat()
  DraftTransform.Scale3D = RelativeTransform.Scale3D or FVector(1, 1, 1)
  return DraftTransform
end

local function BuildScenePlacement(SceneService, Actor)
  local BaseTransform = FTransform()
  BaseTransform.Translation = FVector(0, 0, 0)
  BaseTransform.Rotation = FRotator(0, 0, 0):ToQuat()
  BaseTransform.Scale3D = FVector(1, 1, 1)
  if Actor and Actor.CapsuleComponent then
    BaseTransform.Translation.Z = BaseTransform.Translation.Z + Actor.CapsuleComponent:GetScaledCapsuleHalfHeight() + 2.4
  end
  local BaseRotation = FRotator(0, 90, 0)
  return BaseTransform, BaseRotation
end

local function ApplyHideState(TargetActor, Tag, IsHidden)
  if not TargetActor then
    return
  end
  TargetActor:SetActorHideTag(Tag, IsHidden, false, true)
  TargetActor:HideAllEffectCreature(Tag, IsHidden)
end

local function SyncPreviewAnimInstance(TargetActor)
  if not (TargetActor and TargetActor.Mesh) or not TargetActor.Mesh.GetAnimInstance then
    return
  end
  local AnimInstance = TargetActor.Mesh:GetAnimInstance()
  if not AnimInstance then
    return
  end
  TargetActor.EMAnimInstance = AnimInstance
  if TargetActor.PlayerAnimInstance ~= nil then
    TargetActor.PlayerAnimInstance = AnimInstance
  elseif nil ~= TargetActor.NpcAnimInstance then
    TargetActor.NpcAnimInstance = AnimInstance
  end
end

local function RestorePreviewAnimationBlueprintState(TargetActor)
  if not TargetActor then
    return
  end
  if TargetActor.Mesh and TargetActor.Mesh.SetAnimationMode then
    local AnimBlueprintMode = UE4.EAnimationMode and UE4.EAnimationMode.AnimationBlueprint or nil
    if nil ~= AnimBlueprintMode then
      TargetActor.Mesh:SetAnimationMode(AnimBlueprintMode, true)
    end
  end
  SyncPreviewAnimInstance(TargetActor)
  if TargetActor.StopMontage then
    TargetActor:StopMontage()
  end
  if TargetActor.StopArmoryIdle then
    TargetActor:StopArmoryIdle()
  end
  if TargetActor.SetEmoIdleEnabled then
    TargetActor:SetEmoIdleEnabled(false, true)
  end
end

local function ResetPreviewAnimationState(TargetActor)
  if not TargetActor then
    return
  end
  RestorePreviewAnimationBlueprintState(TargetActor)
  if TargetActor.SetArmoryTag then
    TargetActor:SetArmoryTag("None")
  end
  if TargetActor.EMAnimInstance and TargetActor.EMAnimInstance.ResetIdleTag then
    TargetActor.EMAnimInstance:ResetIdleTag()
  end
end

local function GetDelayedAnimationHost(Handle)
  if Handle.ViewUI and Handle.ViewUI.AddTimer then
    return Handle.ViewUI
  end
  if Handle.SceneService and Handle.SceneService.ArmoryHelper and Handle.SceneService.ArmoryHelper.AddTimer then
    return Handle.SceneService.ArmoryHelper
  end
  return nil
end

local function RunAfterSequenceRestore(Handle, Func)
  if type(Func) ~= "function" then
    return
  end
  Handle.AnimationApplySerial = (Handle.AnimationApplySerial or 0) + 1
  local ApplySerial = Handle.AnimationApplySerial
  local bNeedDelay = Handle.bSequenceRestorePending == true
  if not bNeedDelay then
    Func()
    return
  end
  local TimerHost = GetDelayedAnimationHost(Handle)
  if not TimerHost then
    Handle.bSequenceRestorePending = false
    Func()
    return
  end
  local ActorName = GetObjectNameSafe(Handle.Actor)
  DebugPrint(string.format("PreviewCharacterHandle: delay animation after sequence actor=%s serial=%s", tostring(ActorName), tostring(ApplySerial)))
  TimerHost:AddTimer(0.03, function()
    if Handle.AnimationApplySerial ~= ApplySerial then
      return
    end
    Handle.bSequenceRestorePending = false
    Func()
  end, false, 0, "PreviewCharacterHandle_DelayAnim_" .. tostring(ActorName), true)
end

local function NormalizeSequenceDocument(Document)
  if not Document or "" == Document then
    return nil
  end
  local DocumentPath = Document
  if string.sub(DocumentPath, 1, 1) == "/" then
    DocumentPath = string.sub(DocumentPath, 2)
  end
  if string.sub(DocumentPath, -1) ~= "/" then
    DocumentPath = DocumentPath .. "/"
  end
  return DocumentPath
end

local function AddSequenceCandidate(Candidates, Seen, SequenceRoot, DocumentPath, PrefixName, PoseName)
  if not (SequenceRoot and DocumentPath and PrefixName and "" ~= PrefixName and PoseName) or "" == PoseName then
    return
  end
  local AssetName = string.format("%s_%s", PrefixName, PoseName)
  local AssetPath = string.format("AnimSequence'%s%s%s.%s'", SequenceRoot, DocumentPath, AssetName, AssetName)
  if Seen[AssetPath] then
    return
  end
  Seen[AssetPath] = true
  Candidates[#Candidates + 1] = AssetPath
end

local function BuildCharacterSequenceAssetPaths(TargetActor, Document, PoseName)
  if not (TargetActor and Document and "" ~= Document and PoseName) or "" == PoseName then
    return nil, nil
  end
  local RoleId = TargetActor.CurrentRoleId or 0
  local BattleCharConfig = DataMgr.BattleChar and DataMgr.BattleChar[RoleId] or nil
  local ModelId = BattleCharConfig and BattleCharConfig.ModelId or TargetActor.ModelId
  local ModelData = ModelId and DataMgr.Model and DataMgr.Model[ModelId] or nil
  local MontageFolder = ModelData and ModelData.MontageFolder or nil
  local MontagePrefix = ModelData and ModelData.MontagePrefix or nil
  if not (MontageFolder and "" ~= MontageFolder and MontagePrefix) or "" == MontagePrefix then
    return nil, {
      RoleId = RoleId,
      ModelId = ModelId,
      MontageFolder = MontageFolder,
      MontagePrefix = MontagePrefix
    }
  end
  local SequenceRoot = string.gsub(MontageFolder, "/Montage/$", "/Sequence/")
  if SequenceRoot == MontageFolder then
    SequenceRoot = string.gsub(MontageFolder, "Montage/", "Sequence/")
  end
  local PrefixName = string.gsub(MontagePrefix, "_$", "")
  local Candidates = {}
  local Seen = {}
  local DocumentPath = NormalizeSequenceDocument(Document)
  local PoseCandidates = {PoseName}
  if string.find(PoseName, "_Idle$") then
    PoseCandidates[#PoseCandidates + 1] = string.gsub(PoseName, "_Idle$", "_idle")
  elseif string.find(PoseName, "_idle$") then
    PoseCandidates[#PoseCandidates + 1] = string.gsub(PoseName, "_idle$", "_Idle")
  end
  local DocumentCandidates = {}
  if DocumentPath then
    DocumentCandidates[#DocumentCandidates + 1] = DocumentPath
  end
  if string.find(PoseName, "Fish") and "Interactive/Fishing/" ~= DocumentPath then
    DocumentCandidates[#DocumentCandidates + 1] = "Interactive/Fishing/"
  end
  if string.find(PoseName, "Crouch") and "Locomotion/" ~= DocumentPath then
    DocumentCandidates[#DocumentCandidates + 1] = "Locomotion/"
  end
  for _, CandidateDocument in ipairs(DocumentCandidates) do
    for _, CandidatePoseName in ipairs(PoseCandidates) do
      AddSequenceCandidate(Candidates, Seen, SequenceRoot, CandidateDocument, PrefixName, CandidatePoseName)
    end
  end
  return Candidates, {
    RoleId = RoleId,
    ModelId = ModelId,
    MontageFolder = MontageFolder,
    MontagePrefix = MontagePrefix,
    SequenceRoot = SequenceRoot,
    Document = DocumentPath,
    PoseName = PoseName
  }
end

local function ApplyAnimSequenceInternal(TargetActor, AnimSpec)
  if not (TargetActor and TargetActor.Mesh) or not AnimSpec then
    DebugPrint(string.format("PreviewCharacterHandle: sequence invalid actor=%s mesh=%s mode=%s document=%s pose=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(TargetActor and GetObjectNameSafe(TargetActor.Mesh) or nil), tostring(AnimSpec and AnimSpec.Mode or nil), tostring(AnimSpec and AnimSpec.Document or nil), tostring(AnimSpec and AnimSpec.PoseName or nil)))
    return false
  end
  local AssetPaths, ResolveMeta = BuildCharacterSequenceAssetPaths(TargetActor, AnimSpec.Document, AnimSpec.PoseName)
  if not AssetPaths or #AssetPaths <= 0 then
    DebugPrint(string.format("PreviewCharacterHandle: sequence path build failed actor=%s roleId=%s modelId=%s montageFolder=%s montagePrefix=%s document=%s pose=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(TargetActor.CurrentRoleId), tostring(ResolveMeta and ResolveMeta.ModelId or nil), tostring(ResolveMeta and ResolveMeta.MontageFolder or nil), tostring(ResolveMeta and ResolveMeta.MontagePrefix or nil), tostring(AnimSpec.Document), tostring(AnimSpec.PoseName)))
    return false
  end
  local AnimationAsset, ResolvedAssetPath
  for _, AssetPath in ipairs(AssetPaths) do
    DebugPrint(string.format("PreviewCharacterHandle: sequence resolve actor=%s roleId=%s modelId=%s document=%s pose=%s path=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(TargetActor.CurrentRoleId), tostring(ResolveMeta and ResolveMeta.ModelId or nil), tostring(AnimSpec.Document), tostring(AnimSpec.PoseName), tostring(AssetPath)))
    AnimationAsset = LoadObject(AssetPath)
    if AnimationAsset then
      ResolvedAssetPath = AssetPath
      break
    end
  end
  if not AnimationAsset then
    DebugPrint(string.format("PreviewCharacterHandle: sequence asset missing roleId=%s modelId=%s document=%s pose=%s firstPath=%s", tostring(TargetActor.CurrentRoleId), tostring(ResolveMeta and ResolveMeta.ModelId or nil), tostring(AnimSpec.Document), tostring(AnimSpec.PoseName), tostring(AssetPaths[1])))
    return false
  end
  ResetPreviewAnimationState(TargetActor)
  DebugPrint(string.format("PreviewCharacterHandle: sequence play actor=%s mesh=%s asset=%s path=%s animMode=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(GetObjectNameSafe(TargetActor.Mesh)), tostring(GetObjectNameSafe(AnimationAsset)), tostring(ResolvedAssetPath), tostring(TargetActor.Mesh.GetAnimationMode and TargetActor.Mesh:GetAnimationMode() or nil)))
  TargetActor.Mesh:PlayAnimation(AnimationAsset, true)
  return true
end

local function ResolveAvatarChar(Avatar, CharInfo)
  if not CharInfo then
    return nil
  end
  if CharInfo.DumpAppearanceSuit then
    return CharInfo
  end
  local Uuid = CharInfo.Uuid
  if Avatar and Avatar.Chars and Uuid then
    return Avatar.Chars[Uuid]
  end
  return nil
end

local function ApplyCharacterPreviewState(TargetActor)
  if not TargetActor then
    return
  end
  TargetActor:ClearWeapon()
  TargetActor:SetCharacterTag("Interactive")
  TargetActor:KawaiiSwitch(true)
  if TargetActor.PlayerAnimInstance then
    TargetActor.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
  end
  ResetPreviewAnimationState(TargetActor)
end

local function EnableActorSelectionCollision(TargetActor)
  TargetActor:SetActorEnableCollision(true)
  TargetActor.CapsuleComponent:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
  TargetActor.CapsuleComponent:SetCollisionResponseToAllChannels(UE4.ECollisionResponse.ECR_Ignore)
  TargetActor.CapsuleComponent:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_GameTraceChannel3, UE4.ECollisionResponse.ECR_Block)
  TargetActor.CapsuleComponent:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Visibility, UE4.ECollisionResponse.ECR_Block)
  TargetActor.CapsuleComponent:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Camera, UE4.ECollisionResponse.ECR_Block)
  if TargetActor.CameraFadeCapsule then
    TargetActor.CameraFadeCapsule:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
    TargetActor.CameraFadeCapsule:SetCollisionResponseToAllChannels(UE4.ECollisionResponse.ECR_Ignore)
    TargetActor.CameraFadeCapsule:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_GameTraceChannel3, UE4.ECollisionResponse.ECR_Block)
    TargetActor.CameraFadeCapsule:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Visibility, UE4.ECollisionResponse.ECR_Block)
    TargetActor.CameraFadeCapsule:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Camera, UE4.ECollisionResponse.ECR_Block)
  end
  TargetActor.Mesh:SetCollisionEnabled(ECollisionEnabled.QueryOnly)
  TargetActor.Mesh:SetCollisionResponseToAllChannels(UE4.ECollisionResponse.ECR_Ignore)
  TargetActor.Mesh:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_GameTraceChannel3, UE4.ECollisionResponse.ECR_Block)
  TargetActor.Mesh:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Visibility, UE4.ECollisionResponse.ECR_Block)
  TargetActor.Mesh:SetCollisionResponseToChannel(UE4.ECollisionChannel.ECC_Camera, UE4.ECollisionResponse.ECR_Block)
end

local function ChangeCharacterInternal(TargetActor, Avatar, CharInfo)
  if not TargetActor or not CharInfo then
    return nil
  end
  local CharId
  local AvatarBattleInfo = {}
  local GameMode = UE4.UGameplayStatics.GetGameMode(TargetActor)
  local Char = ResolveAvatarChar(Avatar, CharInfo)
  if TargetActor.CharacterFashion then
    TargetActor.CharacterFashion.Type2PartId = {}
  end
  if Char and Avatar and GameMode then
    CharId = Char.CharId
    AvatarBattleInfo = AvatarUtils:GetDefaultBattleInfo(Avatar, {Char = Char})
    AvatarBattleInfo = {AvatarInfo = AvatarBattleInfo}
    AvatarBattleInfo = GameMode:SimplifyInfoForInit(AvatarBattleInfo)
    AvatarBattleInfo.FromArmory = true
    TargetActor:InitCharacterInfo(AvatarBattleInfo)
  else
    CharId = CharInfo.CharId
    if not CharId then
      return nil
    end
    AvatarBattleInfo.FromOtherWorld = true
    AvatarBattleInfo.FromArmory = true
    TargetActor:ChangeRole(CharId, AvatarBattleInfo)
  end
  ApplyCharacterPreviewState(TargetActor)
  return CharId
end

function M:GetActor()
  return self.Actor
end

function M:GetReflectionActor()
  return self.ReflectionActor
end

function M:IsValid()
  return IsValid(self.Actor)
end

function M:SetAvatar(Avatar)
  self.Avatar = Avatar
end

function M:GetAvatar()
  return self.Avatar
end

function M:Create(CharInfo, Avatar)
  self.CharInfo = CharInfo
  self.Avatar = Avatar
  local UIManager = UIManager(self.ViewUI)
  self.Actor = UIManager:CreatePreviewPlayerActor(self.CharInfo, self.Avatar)
  self.OwnsActorInstance = self.Actor ~= nil
  if not self.Actor then
    return
  end
  ChangeCharacterInternal(self.Actor, self.Avatar, self.CharInfo)
  if self.EnableSelectionCollision then
    EnableActorSelectionCollision(self.Actor)
  end
  self.RootActor = self.SceneService and self.SceneService:GetPreviewRootActor() or nil
  self.ScenePlacementTransform, self.BaseRotation = BuildScenePlacement(self.SceneService, self.Actor)
  AttachActorToRoot(self.Actor, self.RootActor)
  if self.ScenePlacementTransform then
    local DefaultTransform = BuildDefaultRelativeTransform(self.ScenePlacementTransform, self.BaseRotation)
    if self.RootActor then
      SetActorRelativeTransformInternal(self.Actor, DefaultTransform)
    else
      self.Actor:K2_SetActorLocation(DefaultTransform.Translation, false, HitResult, false)
      self.Actor:K2_SetActorRotation(DefaultTransform.Rotation:ToRotator(), false, HitResult, false)
      self.Actor:SetActorScale3D(DefaultTransform.Scale3D)
    end
  end
  if self.EnableReflection then
    self.ReflectionActor = UIManager:CreatePreviewPlayerReflection(self.CharInfo, self.Avatar)
    self.OwnsReflectionInstance = nil ~= self.ReflectionActor
    ChangeCharacterInternal(self.ReflectionActor, self.Avatar, self.CharInfo)
    AttachActorToRoot(self.ReflectionActor, self.RootActor)
    self:UpdateReflectionTransform()
  end
end

function M:ChangeCharacter(CharInfo, Avatar, bForceChange)
  self.CharInfo = CharInfo or self.CharInfo
  self.Avatar = Avatar or self.Avatar
  if not self.Actor then
    self:Create(self.CharInfo, self.Avatar)
    return
  end
  local CharId = self.CharInfo and self.CharInfo.CharId
  if not CharId then
    return
  end
  ChangeCharacterInternal(self.Actor, self.Avatar, self.CharInfo)
  if self.EnableSelectionCollision then
    EnableActorSelectionCollision(self.Actor)
  end
  if self.ReflectionActor then
    ChangeCharacterInternal(self.ReflectionActor, self.Avatar, self.CharInfo)
    self:UpdateReflectionTransform()
  elseif self.EnableReflection then
    self:Create(self.CharInfo, self.Avatar)
  end
  self.ScenePlacementTransform, self.BaseRotation = BuildScenePlacement(self.SceneService, self.Actor)
  self.RootActor = self.SceneService and self.SceneService:GetPreviewRootActor() or self.RootActor
  AttachActorToRoot(self.Actor, self.RootActor)
  AttachActorToRoot(self.ReflectionActor, self.RootActor)
  if self.CurrentTransform then
    self:SetTransform(self.CurrentTransform)
  elseif self.ScenePlacementTransform then
    local DefaultTransform = BuildDefaultRelativeTransform(self.ScenePlacementTransform, self.BaseRotation)
    self:SetTransform(DefaultTransform)
  end
end

function M:SetTransform(Transform)
  self.CurrentTransform = Transform
  if not Transform then
    return
  end
  local TargetTransform
  if self.RootActor then
    TargetTransform = BuildRelativeTransform(self.ScenePlacementTransform, self.BaseRotation, Transform)
  else
    local SceneRootTransform = self.SceneService and self.SceneService.GetPreviewSceneTrans and self.SceneService:GetPreviewSceneTrans() or nil
    TargetTransform = BuildWorldTransformFromDraft(SceneRootTransform, self.ScenePlacementTransform, self.BaseRotation, Transform)
  end
  local Loc = TargetTransform and TargetTransform.Translation or nil
  local Rot = TargetTransform and TargetTransform.Rotation and TargetTransform.Rotation:ToRotator() or nil
  local Scale = TargetTransform and TargetTransform.Scale3D or nil
  if Loc then
    self:SetLocation(Loc)
  end
  if Rot then
    self:SetRotation(Rot)
  end
  if Scale then
    self:SetScale(Scale)
  end
end

function M:GetTransform()
  if self.Actor then
    if self.RootActor then
      local RelativeTransform = GetActorRelativeTransformInternal(self.Actor)
      if RelativeTransform then
        return BuildDraftTransformFromRelative(self.ScenePlacementTransform, self.BaseRotation, RelativeTransform)
      end
    end
    return self.Actor:GetTransform()
  end
  return self.CurrentTransform
end

function M:SetLocation(Loc)
  if self.RootActor then
    SetActorRelativeLocationInternal(self.Actor, Loc)
    SetActorRelativeLocationInternal(self.ReflectionActor, Loc)
    return
  end
  SetActorLocationInternal(self.Actor, Loc)
  SetActorLocationInternal(self.ReflectionActor, Loc)
end

function M:SetRotation(Rot)
  if self.RootActor then
    SetActorRelativeRotationInternal(self.Actor, Rot)
    SetActorRelativeRotationInternal(self.ReflectionActor, Rot)
    return
  end
  SetActorRotationInternal(self.Actor, Rot)
  SetActorRotationInternal(self.ReflectionActor, Rot)
end

function M:SetScale(Scale)
  if self.RootActor then
    SetActorRelativeScaleInternal(self.Actor, Scale)
    SetActorRelativeScaleInternal(self.ReflectionActor, Scale)
    return
  end
  SetActorScaleInternal(self.Actor, Scale)
  SetActorScaleInternal(self.ReflectionActor, Scale)
end

function M:Show(Tag)
  Tag = Tag or "PreviewCharacterHandle"
  self.HideTags[Tag] = nil
  ApplyHideState(self.Actor, Tag, false)
  ApplyHideState(self.ReflectionActor, Tag, false)
end

function M:Hide(Tag)
  Tag = Tag or "PreviewCharacterHandle"
  self.HideTags[Tag] = true
  ApplyHideState(self.Actor, Tag, true)
  ApplyHideState(self.ReflectionActor, Tag, true)
end

function M:ClearHideTag(Tag)
  if not Tag then
    return
  end
  self.HideTags[Tag] = nil
  ApplyHideState(self.Actor, Tag, false)
  ApplyHideState(self.ReflectionActor, Tag, false)
end

function M:ClearAllHideTags()
  for Tag, _ in pairs(self.HideTags) do
    self:ClearHideTag(Tag)
  end
end

function M:UpdateReflectionTransform()
  if not self.Actor or not self.ReflectionActor then
    return
  end
  self.ReflectionActor:K2_SetActorTransform(self.Actor:GetTransform(), false, nil, false)
  local Trans = self.ReflectionActor.Mesh:K2_GetComponentToWorld()
  if Trans.Scale3D.Z > 0 then
    Trans.Scale3D.Z = -Trans.Scale3D.Z
  end
  self.ReflectionActor.Mesh:K2_SetWorldTransform(Trans, false, nil, false)
  self.ReflectionActor.Mesh:SetBoundsScale(10000)
end

function M:PlayMontage(AnimSpec)
  if not self.Actor or not AnimSpec then
    return
  end
  local bUseSequence = AnimSpec.Mode == "Sequence" or AnimSpec.Mode == nil and AnimSpec.Document and AnimSpec.PoseName
  if bUseSequence then
    DebugPrint(string.format("PreviewCharacterHandle: route sequence actor=%s mode=%s poseId=%s document=%s pose=%s", tostring(GetObjectNameSafe(self.Actor)), tostring(AnimSpec.Mode), tostring(AnimSpec.PoseId), tostring(AnimSpec.Document), tostring(AnimSpec.PoseName)))
    self:PlayAnimSequence(AnimSpec)
    return
  end
  RestorePreviewAnimationBlueprintState(self.Actor)
  if self.ReflectionActor then
    RestorePreviewAnimationBlueprintState(self.ReflectionActor)
  end
  RunAfterSequenceRestore(self, function()
    if AnimSpec.MontagePath then
      local MontagePath = AnimSpec.MontagePath
      local MontageSubFile = "Interactive"
      if AnimSpec.ReleaseWheel and string.sub(MontagePath, 1, 8) ~= "Gesture_" then
        MontageSubFile = "Interactive/Gesture"
      elseif string.sub(MontagePath, 1, 8) == "Gesture_" then
        MontageSubFile = "Interactive/Gesture"
      end
      DebugPrint(string.format("PreviewCharacterHandle: route montage actor=%s mode=%s poseId=%s releaseWheel=%s subFile=%s montage=%s", tostring(GetObjectNameSafe(self.Actor)), tostring(AnimSpec.Mode), tostring(AnimSpec.PoseId), tostring(AnimSpec.ReleaseWheel), tostring(MontageSubFile), tostring(MontagePath)))
      if AnimSpec.ReleaseWheel and MontagePath then
        local function PlayGestureResourceInternal(TargetActor)
          if not TargetActor then
            return
          end
          if TargetActor.PlayResourceAction then
            DebugPrint(string.format("PreviewCharacterHandle: play resource action actor=%s releaseWheel=%s action=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(AnimSpec.ReleaseWheel), tostring(MontagePath)))
            TargetActor:PlayResourceAction(MontagePath)
            return
          end
          local MontageName = MontagePath
          if string.sub(MontageName, -9) ~= "_Montage" then
            MontageName = MontageName .. "_Montage"
          end
          DebugPrint(string.format("PreviewCharacterHandle: fallback montage actor=%s releaseWheel=%s subFile=%s montage=%s", tostring(GetObjectNameSafe(TargetActor)), tostring(AnimSpec.ReleaseWheel), tostring(MontageSubFile), tostring(MontageName)))
          TargetActor:PlayActionMontage(MontageSubFile, MontageName, {})
        end
        
        PlayGestureResourceInternal(self.Actor)
        PlayGestureResourceInternal(self.ReflectionActor)
        return
      end
      self.Actor:PlayActionMontage(MontageSubFile, MontagePath, {})
      if self.ReflectionActor then
        self.ReflectionActor:PlayActionMontage(MontageSubFile, MontagePath, {})
      end
    elseif AnimSpec.PoseTag then
      if AnimSpec.PoseTag == "Pose" or AnimSpec.PoseTag == "Gesture" then
        return
      end
      
      local function ApplyPoseTagInternal(TargetActor)
        if not TargetActor or not TargetActor.SetArmoryTag then
          return
        end
        TargetActor:SetArmoryTag(AnimSpec.PoseTag)
      end
      
      ApplyPoseTagInternal(self.Actor)
      ApplyPoseTagInternal(self.ReflectionActor)
    end
  end)
end

function M:PlayAnimSequence(AnimSpec)
  if not self.Actor or not AnimSpec then
    return false
  end
  local bPlayedActor = ApplyAnimSequenceInternal(self.Actor, AnimSpec)
  local bPlayedReflection = false
  if self.ReflectionActor then
    bPlayedReflection = ApplyAnimSequenceInternal(self.ReflectionActor, AnimSpec)
  end
  if bPlayedActor or bPlayedReflection then
    self.AnimationApplySerial = (self.AnimationApplySerial or 0) + 1
    self.bSequenceRestorePending = true
  end
  return bPlayedActor or bPlayedReflection
end

function M:StopMontage()
  self.AnimationApplySerial = (self.AnimationApplySerial or 0) + 1
  self.bSequenceRestorePending = false
  if self.Actor then
    ResetPreviewAnimationState(self.Actor)
    self.Actor:StopMontage()
  end
  if self.ReflectionActor then
    ResetPreviewAnimationState(self.ReflectionActor)
    self.ReflectionActor:StopMontage()
  end
end

function M:ChangeDisplayWeapon(WeaponData)
  if not self.Actor or not WeaponData then
    return false
  end
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  local WeaponTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
  
  local function ChangePlayerWeaponInternal(PlayCharacter)
    if nil == PlayCharacter then
      return false
    end
    local PlayerWeapon = PlayCharacter[WeaponTag .. "Weapon"]
    if PlayerWeapon and PlayerWeapon.WeaponId ~= WeaponData.WeaponId then
      if PlayCharacter.RemoveWeaponWithId then
        PlayCharacter:RemoveWeaponWithId(PlayerWeapon.WeaponId)
      else
        PlayCharacter.Weapons:Remove(PlayerWeapon.WeaponId)
        PlayerWeapon:Destroy()
        PlayCharacter[WeaponTag .. "Weapon"] = nil
      end
      PlayerWeapon = nil
    end
    if not PlayerWeapon and PlayCharacter.GetWeapon then
      PlayerWeapon = PlayCharacter:GetWeapon(WeaponData.WeaponId)
    end
    local Weapon = PlayerWeapon
    if not Weapon then
      local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, WeaponData)
      WeaponInfos = WeaponInfos and WeaponInfos[WeaponTag .. "Weapon"]
      Weapon = PlayCharacter:AddWeapon(WeaponData.WeaponId, WeaponInfos)
    end
    if not Weapon and PlayCharacter.GetWeapon then
      Weapon = PlayCharacter:GetWeapon(WeaponData.WeaponId)
    end
    if not Weapon then
      DebugPrint(string.format("PreviewCharacterHandle: bind display weapon failed actor=%s weaponTag=%s weaponId=%s", tostring(GetObjectNameSafe(PlayCharacter)), tostring(WeaponTag), tostring(WeaponData.WeaponId)))
      return false
    end
    Weapon:InitWeaponAppearance(WeaponData:DumpAppearanceInfo())
    PlayCharacter[WeaponTag .. "Weapon"] = Weapon
    PlayCharacter.UsingWeapon = Weapon
    if PlayCharacter.Tag2WeaponId then
      PlayCharacter.Tag2WeaponId:Add(WeaponTag, Weapon.WeaponId)
    end
    Weapon:SetWeaponTypeChanged(true)
    Weapon:SetActorHiddenInGame(true)
    Weapon:OnWeaponReady()
    Weapon:SetWeaponTypeChanged(false)
    DebugPrint(string.format("PreviewCharacterHandle: bind display weapon actor=%s weaponTag=%s weaponId=%s usingWeapon=%s slotWeapon=%s", tostring(GetObjectNameSafe(PlayCharacter)), tostring(WeaponTag), tostring(WeaponData.WeaponId), tostring(GetObjectNameSafe(PlayCharacter.UsingWeapon)), tostring(GetObjectNameSafe(PlayCharacter[WeaponTag .. "Weapon"]))))
    return true
  end
  
  local bMainChanged = ChangePlayerWeaponInternal(self.Actor)
  local bReflectionChanged = true
  if self.ReflectionActor then
    bReflectionChanged = ChangePlayerWeaponInternal(self.ReflectionActor)
  end
  return true == bMainChanged and true == bReflectionChanged
end

function M:ClearDisplayWeapon(WeaponTag)
  if not self.Actor then
    return
  end
  if "Melee" ~= WeaponTag and "Ranged" ~= WeaponTag then
    return
  end
  
  local function ClearPlayerWeaponInternal(PlayCharacter)
    if nil == PlayCharacter then
      return
    end
    local PlayerWeapon = PlayCharacter[WeaponTag .. "Weapon"]
    if PlayerWeapon then
      if PlayCharacter.ClearWeapon then
        PlayCharacter:ClearWeapon()
      elseif PlayCharacter.RemoveWeaponWithId then
        PlayCharacter:RemoveWeaponWithId(PlayerWeapon.WeaponId)
      else
        PlayCharacter.Weapons:Remove(PlayerWeapon.WeaponId)
        if PlayCharacter.Tag2WeaponId then
          PlayCharacter.Tag2WeaponId:Remove(WeaponTag)
        end
        PlayerWeapon:Destroy()
        PlayCharacter[WeaponTag .. "Weapon"] = nil
        if PlayCharacter.UsingWeapon == PlayerWeapon then
          PlayCharacter.UsingWeapon = nil
        end
      end
    end
  end
  
  ClearPlayerWeaponInternal(self.Actor)
  ClearPlayerWeaponInternal(self.ReflectionActor)
end

function M:Dispose()
  self:ClearAllHideTags()
  if self.Actor and self.OwnsActorInstance then
    if self.Actor.IsPlayer and self.Actor:IsPlayer() then
      self.Actor:ServerRemoveBattlePet()
    end
    if self.Actor.ClearWeapon then
      self.Actor:ClearWeapon()
    end
    self.Actor:EMActorDestroy(EDestroyReason.Armory)
    self.Actor:K2_DestroyActor()
  end
  if self.ReflectionActor and self.OwnsReflectionInstance then
    if self.ReflectionActor.IsPlayer and self.ReflectionActor:IsPlayer() then
      self.ReflectionActor:ServerRemoveBattlePet()
    end
    if self.ReflectionActor.ClearWeapon then
      self.ReflectionActor:ClearWeapon()
    end
    self.ReflectionActor:EMActorDestroy(EDestroyReason.Armory)
    self.ReflectionActor:K2_DestroyActor()
  end
  self.Actor = nil
  self.ReflectionActor = nil
end

function M:New(Params)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Params)
  return Obj
end

return M
