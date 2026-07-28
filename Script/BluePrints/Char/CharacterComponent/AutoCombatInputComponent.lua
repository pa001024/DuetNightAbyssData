local Component = {}
local AUTO_COMBAT_TICK_INTERVAL = 0.1
local AUTO_ATTACK_RELEASE_DELAY = 0.03
local AUTO_ATTACK_SEARCH_RADIUS = 300
local AUTO_ATTACK_SEARCH_RADIUS_SQR = AUTO_ATTACK_SEARCH_RADIUS * AUTO_ATTACK_SEARCH_RADIUS
local AUTO_ATTACK_CHECK_INTERVAL = 1.0
local AUTO_ATTACK_TRIGGER_INTERVAL = 0.1
local AUTO_SHOOT_CHECK_INTERVAL = 0.1
local AUTO_SHOOT_TRIGGER_INTERVAL = 0.05
local AUTO_SHOOT_RELEASE_DELAY = 0.01
local AUTO_COMBAT_STATE = {
  Uninitialized = "Uninitialized",
  Inactive = "Inactive",
  Checking = "Checking",
  Attacking = "Attacking"
}

local function GetSkillTypeName(Skill)
  if not Skill or not Skill.GetSkillType then
    return nil
  end
  return Skill:GetSkillType()
end

function Component:InitAutoCombatComponent()
  if self.AutoCombatComponentInited then
    return
  end
  if not self.AutoAttackState and not self.AutoShootState then
    self.AutoAttackState = AUTO_COMBAT_STATE.Uninitialized
    self.AutoShootState = AUTO_COMBAT_STATE.Uninitialized
  end
  self.AutoCombatComponentInited = true
  self.AutoAttackEnabled = false
  self.AutoShootEnabled = false
  self.AutoAttackPressing = false
  self.AutoShootPressing = false
  self.AutoAttackLastCheckTime = nil
  self.AutoAttackLastTriggerTime = nil
  self.AutoAttackHasTargets = false
  self.AutoShootLastCheckTime = nil
  self.AutoShootHasTargets = false
  if not self:IsMainPlayer() then
    return
  end
  self:SetAutoAttackState(AUTO_COMBAT_STATE.Inactive)
  self:SetAutoShootState(AUTO_COMBAT_STATE.Inactive)
  self:RefreshAutoCombatTimer()
end

function Component:DeinitAutoCombatComponent()
  if not self.AutoCombatComponentInited then
    return
  end
  if self.AutoCombatTickTimer then
    self:RemoveTimer(self.AutoCombatTickTimer)
    self.AutoCombatTickTimer = nil
  end
  self:ResetAutoCombatState("Deinit")
  self.AutoAttackState = AUTO_COMBAT_STATE.Uninitialized
  self.AutoShootState = AUTO_COMBAT_STATE.Uninitialized
  self.AutoCombatComponentInited = false
end

function Component:SetAutoAttackState(NewState)
  local OldState = self.AutoAttackState
  if OldState == NewState then
    return
  end
  self.AutoAttackState = NewState
  DebugPrint(string.format("lgc@AutoCombat AutoAttackState %s -> %s", tostring(OldState), tostring(NewState)))
  local LeavingInactive = OldState == AUTO_COMBAT_STATE.Inactive and NewState ~= AUTO_COMBAT_STATE.Inactive
  local EnteringInactive = nil ~= OldState and OldState ~= AUTO_COMBAT_STATE.Uninitialized and OldState ~= AUTO_COMBAT_STATE.Inactive and NewState == AUTO_COMBAT_STATE.Inactive
  if LeavingInactive then
    EventManager:FireEvent(EventID.OnAutoAttackEnabledChanged, self, true, false)
  elseif EnteringInactive then
    EventManager:FireEvent(EventID.OnAutoAttackEnabledChanged, self, false, true)
  end
end

function Component:SetAutoShootState(NewState)
  local OldState = self.AutoShootState
  if OldState == NewState then
    return
  end
  self.AutoShootState = NewState
  DebugPrint(string.format("lgc@AutoCombat AutoShootState %s -> %s", tostring(OldState), tostring(NewState)))
  local LeavingInactive = OldState == AUTO_COMBAT_STATE.Inactive and NewState ~= AUTO_COMBAT_STATE.Inactive
  local EnteringInactive = nil ~= OldState and OldState ~= AUTO_COMBAT_STATE.Uninitialized and OldState ~= AUTO_COMBAT_STATE.Inactive and NewState == AUTO_COMBAT_STATE.Inactive
  if LeavingInactive then
    EventManager:FireEvent(EventID.OnAutoShootEnabledChanged, self, true, false)
  elseif EnteringInactive then
    EventManager:FireEvent(EventID.OnAutoShootEnabledChanged, self, false, true)
  end
end

function Component:RefreshAutoCombatTimer()
  if not self.AutoCombatComponentInited or not self:IsMainPlayer() then
    return
  end
  local NeedTimer = self.AutoAttackEnabled or self.AutoShootEnabled
  if NeedTimer and not self.AutoCombatTickTimer then
    self.AutoCombatTickTimer = self:AddTimer(AUTO_COMBAT_TICK_INTERVAL, self.UpdateAutoCombatInTimer, true, 0, "AutoCombatTickTimer", false)
  elseif not NeedTimer and self.AutoCombatTickTimer then
    self:RemoveTimer(self.AutoCombatTickTimer)
    self.AutoCombatTickTimer = nil
  end
end

function Component:SetAutoAttackEnabled(bEnabled)
  bEnabled = true == bEnabled
  if self.AutoAttackEnabled == bEnabled then
    if not bEnabled then
      self:StopAutoAttackInput()
      self:RefreshAutoCombatTimer()
    end
    return
  end
  self.AutoAttackEnabled = bEnabled
  if not bEnabled then
    self.AutoAttackLastCheckTime = nil
    self.AutoAttackLastTriggerTime = nil
    self.AutoAttackHasTargets = false
    self:StopAutoAttackInput()
    self:SetAutoAttackState(AUTO_COMBAT_STATE.Inactive)
  else
    self:SetAutoAttackState(AUTO_COMBAT_STATE.Checking)
  end
  self:RefreshAutoCombatTimer()
end

function Component:SetAutoShootEnabled(bEnabled)
  bEnabled = true == bEnabled
  if self.AutoShootEnabled == bEnabled then
    if not bEnabled then
      self:StopAutoShootInput()
      self:RefreshAutoCombatTimer()
    end
    return
  end
  self.AutoShootEnabled = bEnabled
  if not bEnabled then
    self.AutoShootLastCheckTime = nil
    self.AutoShootHasTargets = false
    self:StopAutoShootInput()
    self:SetAutoShootState(AUTO_COMBAT_STATE.Inactive)
  else
    self:SetAutoShootState(AUTO_COMBAT_STATE.Checking)
  end
  self:RefreshAutoCombatTimer()
end

function Component:IsAutoAttackEnabled()
  return self.AutoAttackEnabled == true
end

function Component:IsAutoShootEnabled()
  return self.AutoShootEnabled == true
end

function Component:GetAutoAttackState()
  return self.AutoAttackState
end

function Component:GetAutoShootState()
  return self.AutoShootState
end

function Component:ResetAutoCombatState(Reason)
  self.AutoAttackEnabled = false
  self.AutoShootEnabled = false
  self.AutoCombatResetReason = Reason
  self.AutoAttackLastCheckTime = nil
  self.AutoAttackLastTriggerTime = nil
  self.AutoAttackHasTargets = false
  self.AutoShootLastCheckTime = nil
  self.AutoShootHasTargets = false
  self:StopAutoAttackInput()
  self:StopAutoShootInput()
  self:SetAutoAttackState(AUTO_COMBAT_STATE.Inactive)
  self:SetAutoShootState(AUTO_COMBAT_STATE.Inactive)
  self:RefreshAutoCombatTimer()
end

function Component:OnAutoCombatSwitchRole()
  self:ResetAutoCombatState("SwitchRole")
end

function Component:OnAutoCombatSwitchWeapon()
  self:ResetAutoCombatState("SwitchWeapon")
end

function Component:UpdateAutoCombatInTimer()
  if not self.AutoCombatComponentInited or not self:IsMainPlayer() then
    return
  end
  if self:ShouldForceDisableAutoCombat() then
    self:ResetAutoCombatState("Invalid")
    return
  end
  self:UpdateAutoShootInTimer()
  self:UpdateAutoAttackInTimer()
end

function Component:ShouldForceDisableAutoCombat()
  if not self.InitSuccess then
    return true
  end
  return false
end

function Component:UpdateAutoAttackInTimer()
  if not self.AutoAttackEnabled then
    self:SetAutoAttackState(AUTO_COMBAT_STATE.Inactive)
    return
  end
  local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  if not self.AutoAttackLastCheckTime or CurrentTime - self.AutoAttackLastCheckTime >= AUTO_ATTACK_CHECK_INTERVAL then
    self.AutoAttackLastCheckTime = CurrentTime
    self.AutoAttackHasTargets = self:HasAutoAttackTargets()
  end
  if not self:CanTriggerAutoAttack() then
    self:SetAutoAttackState(AUTO_COMBAT_STATE.Checking)
    return
  end
  if not self.AutoAttackHasTargets then
    self:SetAutoAttackState(AUTO_COMBAT_STATE.Checking)
    return
  end
  self:SetAutoAttackState(AUTO_COMBAT_STATE.Attacking)
  if self.AutoAttackLastTriggerTime and CurrentTime - self.AutoAttackLastTriggerTime < AUTO_ATTACK_TRIGGER_INTERVAL then
    return
  end
  self.AutoAttackLastTriggerTime = CurrentTime
  self:TriggerAutoAttackOnce()
end

function Component:UpdateAutoShootInTimer()
  if not self.AutoShootEnabled then
    self:StopAutoShootInput()
    self:SetAutoShootState(AUTO_COMBAT_STATE.Inactive)
    return
  end
  local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  if not self.AutoShootLastCheckTime or CurrentTime - self.AutoShootLastCheckTime >= AUTO_SHOOT_CHECK_INTERVAL then
    self.AutoShootLastCheckTime = CurrentTime
    self.AutoShootHasTargets = self:HasAutoShootTargets()
  end
  if not self:CanAutoShoot() and not self.AutoShootTriggerTimer then
    self:StopAutoShootInput()
    self:SetAutoShootState(AUTO_COMBAT_STATE.Checking)
    return
  end
  if not self.AutoShootHasTargets then
    self:StopAutoShootInput()
    self:SetAutoShootState(AUTO_COMBAT_STATE.Checking)
    return
  end
  if not self:HasAutoShootAmmo() then
    self:StopAutoShootInput()
    self:SetAutoShootState(AUTO_COMBAT_STATE.Checking)
    return
  end
  self:SetAutoShootState(AUTO_COMBAT_STATE.Attacking)
  self:StartAutoShootInput()
end

function Component:CanTriggerAutoAttack()
  if self.AutoAttackPressing then
    return false
  end
  if self:CheckForbidInput() then
    return false
  end
  if self.bPressedAttack and not self.AutoAttackPressing then
    return false
  end
  if self:CharacterInTag("Idle") then
    return 0 == self:GetVelocity():Size2D()
  end
  if not self:CharacterInTag("Skill") then
    return false
  end
  local CurrentSkill = self.GetCurrentSkill and self:GetCurrentSkill() or nil
  return nil ~= CurrentSkill and GetSkillTypeName(CurrentSkill) == ESkillType.Attack
end

function Component:CanAutoShoot()
  if self:CheckForbidInput() then
    return false
  end
  if self.bPressedFire and not self.AutoShootPressing then
    return false
  end
  if self.CheckCanShoot and not self:CheckCanShoot(true) then
    return false
  end
  if self:CharacterInTag("Idle") or self:CharacterInTag("Falling") then
    return true
  end
  if not self:CharacterInTag("Skill") then
    return false
  end
  local CurrentSkill = self.GetCurrentSkill and self:GetCurrentSkill() or nil
  if not CurrentSkill then
    return false
  end
  local SkillType = GetSkillTypeName(CurrentSkill)
  return SkillType == ESkillType.Reload or SkillType == ESkillType.Shooting
end

function Component:HasAutoAttackTargets()
  local BattleInstance = Battle(self)
  if not BattleInstance then
    return false
  end
  local SelfLocation = self.CurrentLocation or self:K2_GetActorLocation()
  if not SelfLocation then
    return false
  end
  local Entities = BattleInstance.GetAllEntities and BattleInstance:GetAllEntities() or nil
  if not Entities then
    return false
  end
  for _, Target in pairs(Entities) do
    if IsValid(Target) and Target ~= self and Target.InitSuccess and Target.IsMonster and Target:IsMonster() and self.IsEnemy and self:IsEnemy(Target) and (not Target.IsDead or not Target:IsDead()) then
      local TargetLocation = Target.CurrentLocation or Target:K2_GetActorLocation()
      if TargetLocation then
        local Delta = TargetLocation - SelfLocation
        if Delta:SizeSquared() <= AUTO_ATTACK_SEARCH_RADIUS_SQR then
          return true
        end
      end
    end
  end
  return false
end

function Component:HasAutoShootTargets()
  local TakeAimIndicator = self.TakeAimIndicator
  if IsValid(TakeAimIndicator) then
    local TargetEid = tonumber(TakeAimIndicator.CurTraceTargetEid) or -1
    if TargetEid > 0 then
      local BattleInstance = Battle(self)
      local Target = BattleInstance and BattleInstance:GetEntity(TargetEid) or nil
      if IsValid(Target) then
        local IsMonsterTarget = Target.IsMonster and Target:IsMonster()
        local IsEnemyTarget = self.IsEnemy and self:IsEnemy(Target)
        if IsMonsterTarget and IsEnemyTarget then
          return true
        end
      end
    end
  end
  local ShootingTargets = self.GetShootingTargets and self:GetShootingTargets() or nil
  return nil ~= ShootingTargets and ShootingTargets:Length() > 0
end

function Component:GetAutoShootWeapon()
  local UsingWeapon = self.UsingWeapon
  if IsValid(UsingWeapon) and UsingWeapon.HasTag and UsingWeapon:HasTag("Ranged") then
    return UsingWeapon
  end
  if IsValid(self.RangedWeapon) then
    return self.RangedWeapon
  end
  return nil
end

function Component:HasAutoShootAmmo()
  local Weapon = self:GetAutoShootWeapon()
  if not IsValid(Weapon) or not Weapon.IsBulletCountGreaterZero then
    return false
  end
  return Weapon:IsBulletCountGreaterZero()
end

function Component:TriggerAutoAttackOnce()
  self.AutoAttackPressing = true
  self:ActionCallback("Attack", EInputEvent.IE_Pressed)
  EventManager:FireEvent(EventID.OnBattleMeleeTriggered)
  if self.AutoAttackReleaseTimer then
    self:RemoveTimer(self.AutoAttackReleaseTimer)
    self.AutoAttackReleaseTimer = nil
  end
  self.AutoAttackReleaseTimer = self:AddTimer(AUTO_ATTACK_RELEASE_DELAY, self.ReleaseAutoAttackInput, false, 0, "AutoAttackReleaseTimer", false)
end

function Component:ReleaseAutoAttackInput()
  self.AutoAttackReleaseTimer = nil
  if not self.AutoAttackPressing then
    return
  end
  self:ActionCallback("Attack", EInputEvent.IE_Released)
  self.AutoAttackPressing = false
end

function Component:StartAutoShootInput()
  if self.AutoShootTriggerTimer then
    return
  end
  self:TriggerAutoShootOnce()
  self.AutoShootTriggerTimer = self:AddTimer(AUTO_SHOOT_TRIGGER_INTERVAL, self.TriggerAutoShootOnce, true, 0, "AutoShootTriggerTimer", false)
end

function Component:TriggerAutoShootOnce()
  if self.AutoShootPressing then
    return
  end
  if not self:HasAutoShootAmmo() then
    return
  end
  self.AutoShootPressing = true
  self:ActionCallback("Fire", EInputEvent.IE_Pressed)
  EventManager:FireEvent(EventID.OnBattleFireTriggered)
  if self.AutoShootReleaseTimer then
    self:RemoveTimer(self.AutoShootReleaseTimer)
    self.AutoShootReleaseTimer = nil
  end
  self.AutoShootReleaseTimer = self:AddTimer(AUTO_SHOOT_RELEASE_DELAY, self.ReleaseAutoShootInput, false, 0, "AutoShootReleaseTimer", false)
end

function Component:StopAutoAttackInput()
  if self.AutoAttackReleaseTimer then
    self:RemoveTimer(self.AutoAttackReleaseTimer)
    self.AutoAttackReleaseTimer = nil
  end
  if self.AutoAttackPressing then
    self:ActionCallback("Attack", EInputEvent.IE_Released)
    self.AutoAttackPressing = false
  end
end

function Component:StopAutoShootInput()
  if self.AutoShootTriggerTimer then
    self:RemoveTimer(self.AutoShootTriggerTimer)
    self.AutoShootTriggerTimer = nil
  end
  if self.AutoShootReleaseTimer then
    self:RemoveTimer(self.AutoShootReleaseTimer)
    self.AutoShootReleaseTimer = nil
  end
  if self.AutoShootPressing then
    self:ActionCallback("Fire", EInputEvent.IE_Released)
    self.AutoShootPressing = false
  end
end

function Component:ReleaseAutoShootInput()
  self.AutoShootReleaseTimer = nil
  if not self.AutoShootPressing then
    return
  end
  self:ActionCallback("Fire", EInputEvent.IE_Released)
  self.AutoShootPressing = false
end

return Component
