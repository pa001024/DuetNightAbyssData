require("Utils")
local msgpack = require("msgpack_core")
local MiscUtils = require("Utils.MiscUtils")
local EffectResults = require("BluePrints.Combat.BattleLogic.EffectResults")
local ActionLogicComponent = {}

function ActionLogicComponent:InitActionLogicParamas()
  self.AvoidTime = -1
  self.SlideCount = 0
  self.AvoidCount = 0
  self.SlidePrepareInfo = {}
  self.AvoidPrepareInfo = {}
  self.AvoidRemainTimes = 1
end

function ActionLogicComponent:SetupActionLogicPramas()
  self.bUseControllerRotationYaw = false
  self.JumpMaxCount = 3
  local r = DataMgr.PlayerRotationRates.BulletJump
  if r then
    self.BulletRotationSpeed = r.ParamentValue[2]
  else
    self.BulletRotationSpeed = self.PlayerRotationRates:Find("BulletJump").Yaw
  end
  self:InitCapsuleSize()
  if self:IsPlayer() then
    self:SetActionFeatureAttr(self.SlideMaintainTime, self.SlideLaunchDelay)
  end
  self.SlidePrepareInfo = {}
  self.AvoidPrepareInfo = {}
  self.OriginBrakFrictionWalk = self:GetMovementComponent().BrakingDecelerationWalking
  self:SetRotationRate("OnGround")
  self:SetHoldCrouch(false)
  self.ShrinkType = {Tag = "Defaulted", Reverse = false}
  local Movement = self:GetMovementComponent()
  local _AirControl = DataMgr.PlayerRotationRates.FlyAirControl
  if _AirControl then
    Movement.FlyAirControl = _AirControl.ParamentValue[1]
  end
  local _AirControlMulti = DataMgr.PlayerRotationRates.AirControlMultiplier
  if _AirControlMulti then
    Movement.FlyAirControlBoostMultiplier = _AirControlMulti.ParamentValue[1]
  end
  local MaxAvoidExecuteTimes = self:GetAttr("MaxAvoidExecuteTimes")
  if MaxAvoidExecuteTimes then
    self.AvoidRemainTimes = math.max(1, MaxAvoidExecuteTimes)
  end
end

function ActionLogicComponent:GetConstHalfHeight(InShrinkType)
  if "Defaulted" == InShrinkType then
    return self.OriginHalfHeight
  end
  return Const[InShrinkType .. "HalfHeight"]
end

function ActionLogicComponent:GetInteractiveWaitToEnd()
  return Const.InteractiveWaitToEnd
end

function ActionLogicComponent:ResetGravity(Now)
  if self:ClearBulletGravityInfo(Now) then
    self.BulletJumpDirectionInfo = nil
    self.bBulletJumpControlGravity = false
  end
end

function ActionLogicComponent:CounterJump(JumpStage)
  if JumpStage == Const.BulletJump then
    self:CountPlayerSkillUsedTimes("BulletJump")
  elseif JumpStage == Const.FirstJump or JumpStage == Const.SecondJump then
    self:CountPlayerSkillUsedTimes("Jump")
  end
end

function ActionLogicComponent:NotifyBulletToUI()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local DungeonCapture = UIManager:GetUIObj("DungeonCaptureFloat")
  if DungeonCapture then
    DungeonCapture:NotifyBulletJump()
  end
  if self.NeedBulletJumpEvent then
    EventManager:FireEvent(EventID.OnBulletJumpStarted)
  end
end

function ActionLogicComponent:BulletJumpRecoverCheck_Lua()
  self.AutoSyncProp.IsBulletJumping = false
  self.ForbidOrient = false
  self:ChangeOrientControll()
end

function ActionLogicComponent:SetEnterInteractive(InInteractive, MontageName, CharacterTag, SubFile)
  self.IsInteractive = InInteractive
  if self.PlayerAnimInstance then
    self.PlayerAnimInstance.IsInteractive = InInteractive
    self.PlayerAnimInstance:ResetIdleTag()
  end
  if InInteractive and MontageName then
    local Callback = {
      OnCompleted = self.OnExitInteractive,
      OnInterrupted = self.OnExitInteractive,
      OnBlendOut = self.OnExitInteractive
    }
    SubFile = SubFile or "MechInteractive"
    self:PlayActionMontage("Interactive/" .. SubFile, MontageName, Callback, false, true)
    self.InteractiveMont = self.MontToPlay
  end
  if self.NeedInteractiveEvent then
    EventManager:FireEvent(EventID.OnInteractivePressed)
  end
end

function ActionLogicComponent:OnExitInteractive()
  if self:IsPlayer() then
    self:MinusForbidTag("Battle")
  end
  self.InteractiveMont = nil
  self.IsInteractive = false
  self.WaitCallBack = false
  if self.PlayerAnimInstance then
    self.PlayerAnimInstance.IsInteractive = false
  end
  if self.OnInteractiveDelegate:IsBound() then
    self.OnInteractiveDelegate:Broadcast(self)
  end
  self:GetMovementComponent().RootMotionZScale = 1
  if self:CharacterInTag("Interactive") or self:CharacterInTag("Seating") then
    self:ServerSetCharacterTag("Idle")
    self:SetCharacterTagIdle()
  end
end

function ActionLogicComponent:PlayArmoryAction(ActionId, bHideUntilLoop)
  DebugPrint("gmy@ActionLogicComponent:PlayArmoryAction ActionId", ActionId)
  if 0 == ActionId then
    return
  end
  local ActionName = Const.ArmoryActionIdToArmoryTag[ActionId]
  if ActionName then
    if 0 ~= self.CurrentSkillId then
      self:StopSkill(UE.ESkillStopReason.ArmoryCancel)
    end
    self:SetArmoryTag(ActionName, nil, bHideUntilLoop)
  end
end

function ActionLogicComponent:CanUseArmoryAction(ActionId)
  DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", ActionId)
  if 0 == ActionId then
    return
  end
  local ActionName = Const.ArmoryActionIdToArmoryTag[ActionId]
  if ActionName == Const.Melee then
    DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", self.MeleeWeapon)
    local MeleeWeapon = self.MeleeWeapon
    if not IsValid(MeleeWeapon) then
      return false
    end
  elseif ActionName == Const.Ranged then
    DebugPrint("gmy@ActionLogicComponent ActionLogicComponent:CanUseArmoryAction", self.RangedWeapon)
    local RangedWeapon = self.RangedWeapon
    if not IsValid(RangedWeapon) then
      return false
    end
  end
  return true
end

function ActionLogicComponent:EmptyCurResourceId()
  self.CurResourceId = 0
  if self.FromOtherWorld then
    self.PlayerAnimInstance:SetEmoIdleEnabled(true, true)
  end
end

function ActionLogicComponent:PlayResourceAction(ActionName, bHideUntilLoop)
  local Callback = {}
  self:PlayActionMontage("Interactive/Gesture", ActionName .. "_Montage", Callback, false, nil, nil, bHideUntilLoop)
end

function ActionLogicComponent:PlayActionMontage(SubFile, MontageSuffix, Callback, ShouldForbidAction, ExcuteFnishOnlyWhenCompelete, bLoadAsync, bHideUntilLoop)
  if ShouldForbidAction then
    self:AddForbidTag("Battle")
  end
  if 0 ~= self.CurrentSkillId then
    self:StopSkill(UE.ESkillStopReason.ActionCancel)
  end
  local MontPath = self:GetMontagePath(SubFile, MontageSuffix)
  print(_G.LogTag, "PlayActionMontage", MontPath)
  if bLoadAsync then
    UResourceLibrary.LoadObjectAsync(self, MontPath, {
      self,
      function(_, Montage)
        self.MontToPlay = Montage
        if Montage then
          DebugPrint("ActionLogicComponent:PlayActionMontage", self:GetName(), Montage:GetName())
        end
        local MontParam = {
          OnCompleted = Callback.OnCompleted,
          OnBlendOut = Callback.OnBlendOut,
          OnInterrupted = Callback.OnInterrupted,
          OnNotifyBegin = Callback.OnNotifyBegin,
          OnNotifyEnd = Callback.OnNotifyEnd,
          ExcuteFnishOnlyWhenCompelete = ExcuteFnishOnlyWhenCompelete
        }
        self:SetCanExtractZVelocity()
        MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, self.MontToPlay, MontParam)
        if bHideUntilLoop and self.MontToPlay then
          self:HideActorBeforeLoop(self.MontToPlay)
        end
      end
    })
    return nil
  end
  self.MontToPlay = LoadObject(MontPath)
  local MontParam = {
    OnCompleted = Callback.OnCompleted,
    OnBlendOut = Callback.OnBlendOut,
    OnInterrupted = Callback.OnInterrupted,
    OnNotifyBegin = Callback.OnNotifyBegin,
    OnNotifyEnd = Callback.OnNotifyEnd,
    ExcuteFnishOnlyWhenCompelete = ExcuteFnishOnlyWhenCompelete
  }
  self:SetCanExtractZVelocity()
  MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, self.MontToPlay, MontParam)
  if bHideUntilLoop and self.MontToPlay then
    self:HideActorBeforeLoop(self.MontToPlay)
  end
end

function ActionLogicComponent:HideActorBeforeLoop(Montage)
  if Montage then
    local StartTime = self:GetMontageSectionStartTime(Montage, "Loop")
    if StartTime > 0 then
      self:SetActorHideTag("GestureMontage", true, false, true)
      self:AddTimer(StartTime, function()
        self:SetActorHideTag("GestureMontage", false, false, true)
      end)
    end
  end
end

function ActionLogicComponent:GetCapsuleRootLocation()
  return self.Mesh:GetSocketLocation("Root")
end

function ActionLogicComponent:IsAnimCrouch()
  if not self.PlayerAnimInstance then
    return false
  end
  return self.PlayerAnimInstance.IsCrouching
end

function ActionLogicComponent:PlayerLanded()
  print(_G.LogTag, "PlayerLanded", self:GetCharacterTag())
  if not self:CharacterInTag("Slide") then
    self:ResetCapSize()
    self:SetRotationRate("OnGround")
  end
  self.PlayerAnimInstance.WallJumpIndex = 0
  return true
end

function ActionLogicComponent:PlayerImpending()
  if self.AutoSyncProp.IsBulletJumping then
    return false
  end
  if self:IsFlying() then
    return false
  end
  if self.ImpendingSetted then
    return
  end
  if not self:CharacterInTag("Slide") then
    self:SetRotationRate("InAir")
  end
  self.PlayerAnimInstance.WallJumpIndex = 0
  return true
end

function ActionLogicComponent:PlayTeleportAction(...)
  local MontageSuffix
  if self.InfoForInit and self.InfoForInit.AppearanceSuit then
    local AccessorySuit = self.InfoForInit.AppearanceSuit.AccessorySuit or {}
    if AccessorySuit[CommonConst.NewCharAccessoryTypes.FX_Teleport] then
      local Data = DataMgr.CharAccessory[AccessorySuit[CommonConst.NewCharAccessoryTypes.FX_Teleport]]
      if Data then
        MontageSuffix = Data.Montage
      end
    end
  end
  MontageSuffix = MontageSuffix or "Teleport_01_Montage"
  local MontagePath = self:GetMontagePath("Interactive/MechInteractive", MontageSuffix)
  local Montage = LoadObject(MontagePath)
  if not Montage then
    MontageSuffix = "Teleport_01_Montage"
  end
  self:PlayActionMontage("Interactive/MechInteractive", MontageSuffix, ...)
end

return ActionLogicComponent
