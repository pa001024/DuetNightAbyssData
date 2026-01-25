local Component = {}

function Component:HasHandlePenalize()
  return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.HandlePenalize and 1 == self.Data.BossPenalize.HandlePenalize
end

function Component:HasCannotCondemn()
  return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.CannotCondemn and 1 == self.Data.BossPenalize.CannotCondemn
end

function Component:IsEnterPenalizeAfterDeath()
  return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.EnterPenalizeAfterDeath and 1 == self.Data.BossPenalize.EnterPenalizeAfterDeath
end

function Component:IsEnterDeathStory()
  return self.Data and self.Data.BossPenalize and self.Data.BossPenalize.PlayStoryAfterDeath and self.Data.BossPenalize.PlayStoryAfterDeath >= 0
end

function Component:IsHpEnterDeathStory()
  if not self:IsEnterDeathStory() then
    return
  end
  local CurrentHp = self:GetAttr("Hp")
  local MaxHp = self:GetAttr("MaxHp")
  return self.Data.BossPenalize.PlayStoryAfterDeath >= CurrentHp / MaxHp
end

function Component:IsHpEnterTrueDamage()
  if not self:HasHandlePenalize() or not self:IsInDefeat() then
    return
  end
  if not (self.Data and self.Data.BossPenalize) or not self.Data.BossPenalize.MaxHpPercent then
    return
  end
  local CurrentHp = self:GetAttr("Hp")
  local MaxHp = self:GetAttr("MaxHp")
  return self.Data.BossPenalize.MaxHpPercent >= CurrentHp / MaxHp
end

function Component:MultiCastSetCharacterTagAfterMaxTN_Implementation(CharacterTag)
  if "Idle" == CharacterTag then
    self.IsBossDefeated = false
    local CondemnPath = self:GetCondemnMontagePath("CondemnEnd_Montage")
    local AnimTime = self:PlayMontageByPath(CondemnPath) or 0
    AnimTime = math.max(0, AnimTime - 0.25)
    if IsAuthority(self) then
      self:SetEnableBeCondemned(ECondemnState.DefeatedEndToIdle)
    end
    self:AddTimer(AnimTime, function()
      self:SetCharacterTag(CharacterTag)
    end, false, 0, "DefeatedToIdle")
    if IsClient(self) or IsStandAlone(self) then
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local UIManager = GameInstance:GetGameUIManager()
      local DefeatedUI = UIManager:GetUIObj("DefeatedInteract")
      if DefeatedUI then
        DefeatedUI:StopAllAnimations()
        DefeatedUI:ChangeUIDefeatedState(false)
        DefeatedUI:Close()
        self:SetHeightLightTip(false)
      end
    end
  end
end

function Component:DefeatedRecoverToIdle(RecoverMaxTN)
  if not self:CharacterInTag("Defeated") then
    return
  end
  self.IsBossDefeated = false
  if self:GetAttr("Hp") > 0 then
    if RecoverMaxTN then
      self:TriggerRecoverMaxTNEvent()
      Battle(self):TriggerBattleEvent(BattleEventName.RecoverMaxTNEvent, self)
      self:MultiCastSetCharacterTagAfterMaxTN("Idle")
    else
      self:MulticastSetCharacterTagOnHitLogic("Idle", false)
    end
    self:RecoverToMaxTN()
  elseif self:IsEnterDeathStory() then
    self:SendPenalizeStoryEvent()
  else
    Battle(self):BattleOnDead(self.Eid, self.CondemnerEid or 0, 0, EDeathReason.Execute)
  end
  self.CondemnerEid = nil
  self:UseDefeatedCallBack()
  self:EnableToughnessRecover()
end

function Component:GetCondemnMontagePath(CondemnPathSuffix)
  local MontageFolder, MontagePrefix = self:GetHitMontageFolderAndPrefix()
  if MontageFolder then
    local Path = MontageFolder .. "Combat/Hit/" .. MontagePrefix .. CondemnPathSuffix
    return Path
  end
end

function Component:SetCharacterDefeatedTag()
  if not self:HasHandlePenalize() then
    return
  end
  if not self:CharacterInTag("Defeated") then
    self.EnterDefeatedCount = self.EnterDefeatedCount and self.EnterDefeatedCount + 1 or 1
    self:MulticastSetCharacterTagOnHitLogic("Defeated", true)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and 1 == self.EnterDefeatedCount then
      GameMode:TriggerFirstCondemn()
    end
  end
end

function Component:CharQuitHitTag(CombatConditionId, EnterCharacterTag)
  local ChangeInfo = self:GetStateLimitInfo(self.AutoSyncProp.CharacterTag)
  if not ChangeInfo then
    return
  end
  local TagTypeMap = self:GetStateLimitTagTypeMap(ChangeInfo)
  if not TagTypeMap.Hit then
    return
  end
  local TraceInfo = "From HitLogicComponent_C:CharQuitHitTag"
  if Battle(self):CheckConditionNew(CombatConditionId, self, nil, TraceInfo) then
    if self.EMAnimInstance then
      self.EMAnimInstance:Montage_Stop(Const.MontageBlendOutTime)
    end
    if "Defeated" == EnterCharacterTag then
      self:SetCharacterDefeatedTag()
    else
      self:MulticastSetCharacterTagOnHitLogic(EnterCharacterTag, false)
    end
  end
end

function Component:QuitDefeatedTag()
  if self:CharacterInTag("Defeated") then
    self:TriggerExecuteCondemnedEvent()
    Battle(self):TriggerBattleEvent(BattleEventName.ExecuteCondemnedEvent, self)
    self:DefeatedRecoverToIdle()
  end
end

function Component:MultiCastPlayCondemnMontage_Implementation()
  if self:IsMonster() then
    self:TriggerBeCondemned()
    Battle(self):TriggerBattleEvent(BattleEventName.BeCondemned, self)
  end
  local CondemnPath = self:GetCondemnMontagePath("Condemn_Montage")
  if not IsAuthority(self) then
    self:PlayMontageByPath(CondemnPath)
  else
    local AnimTime, AnimationAsset = self:PlayMontageByPath(CondemnPath)
    if not AnimationAsset then
      self:QuitDefeatedTag()
      DebugPrint("处刑动画路径文件不存在", CondemnPath)
    else
      local FrameNum = math.floor(AnimationAsset.SequenceLength / 0.03333333333333333 + 1.0E-4) + 1
      if FrameNum > 61 then
        self:AddTimer(60 / FrameNum * AnimTime, function()
          if self:GetAttr("Hp") <= 0 then
            self:QuitDefeatedTag()
            self:RemoveTimer("QuitDefeatedTag")
          end
        end)
      end
      local BlendOutTime = 0 ~= AnimationAsset:GetDefaultBlendOutTime() and AnimationAsset:GetDefaultBlendOutTime() or 0.25
      self:AddTimer(AnimTime - BlendOutTime, self.QuitDefeatedTag, false, 0, "QuitDefeatedTag")
    end
  end
end

function Component:PlayEnterCondemnMontage()
  local CondemnPath = self:GetCondemnMontagePath("CondemnStart_Montage")
  local MontageSecond = self:PlayMontageByPath(CondemnPath)
  MontageSecond = self.BattleCharInfo.TNRecoverTimeZ or MontageSecond
  return MontageSecond
end

function Component:EnterDefeatedTag()
  local Movement = self:GetMovementComponent()
  Movement:SetMovementMode(Movement.DefaultLandMovementMode)
  self:TriggerEnterDefeatedEvent()
  Battle(self):TriggerBattleEvent(BattleEventName.EnterDefeatedEvent, self)
  local MontageSecond = self:PlayEnterCondemnMontage()
  if IsAuthority(self) then
    self:SetEnableBeCondemned(not MontageSecond and ECondemnState.AccessEnterDefeated or ECondemnState.CantEnterDefeated)
    if MontageSecond then
      self:AddTimer_Combat(MontageSecond, function()
        self:SetEnableBeCondemned(ECondemnState.AccessEnterDefeated)
      end)
    end
  end
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  if not self:HasCannotCondemn() then
    local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
    DefeatedUI = DefeatedUI or UIManager(self):LoadUINew("DefeatedInteract")
    DefeatedUI:InitDefeatedCharacter(self)
    self:SetHeightLightTip(true)
  end
  UIManager(self):LoadUINew("ToughnessWeak", self)
  if self.BossBloodUI then
    self.BossBloodUI:ShowToughnessBar(false)
  end
end

function Component:LeaveDefeatedTag()
  if IsAuthority(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      for i, PlayerCharacter in pairs(GameMode:GetAllPlayer()) do
        if PlayerCharacter then
          PlayerCharacter.BattleAchievement:SubmitDamageValueOnLeaveDefeated()
        end
      end
    end
  end
  if not IsClient(self) and not IsStandAlone(self) then
    return
  end
  if not self:HasCannotCondemn() then
    local DefeatedUI = UIManager(self):GetUIObj("DefeatedInteract")
    if DefeatedUI then
      DefeatedUI:StopAllAnimations()
      DefeatedUI:PlayAnimation(DefeatedUI.out)
      DefeatedUI:TryShowPhoneUI(false)
    end
    self:SetHeightLightTip(false)
  end
  if self.BossBloodUI then
    self.BossBloodUI:ShowToughnessBar(true)
  end
end

function Component:SendPenalizeStoryEvent()
  self:SetEnableBeCondemned(ECondemnState.CantEnterDefeated)
  self:PostCustomEvent(self.Data.BossPenalize.StoryEvent)
  self:AddTimer_Combat(1, function()
    Battle(self):BattleOnDead(self.Eid, self.CondemnerEid or 0, 0, EDeathReason.Execute)
  end)
  self.CondemnerEid = nil
end

function Component:SetEnableBeCondemned(EnableBeCondemned)
  self.EnableBeCondemned = EnableBeCondemned
end

function Component:GetEnableBeCondemned()
  return self:CharacterInTag("Defeated") and self.EnableBeCondemned == ECondemnState.AccessEnterDefeated
end

function Component:IsCantLeaveDefeated()
  return self:CharacterInTag("Defeated") and not self:IsExistTimer("QuitDefeatedTag") and (self.EnableBeCondemned == ECondemnState.AccessEnterDefeated or self.EnableBeCondemned == ECondemnState.DefeatedStopNotify)
end

function Component:ApplyEffectAddtiveHit(DamageEvent)
  if DamageEvent.DamageTag then
    for _, tag in pairs(DamageEvent.DamageTag) do
      if "Dot" == tag then
        return false
      end
    end
  end
  local ShoulPlayAdditiveAnim = false
  if self:IsMonster() and not self:IsBossMonster() then
    if not DamageEvent.CauseHitDamage then
      ShoulPlayAdditiveAnim = true
    else
      local CurTN = self:GetAttr("TN")
      if CurTN and CurTN > 0 then
        ShoulPlayAdditiveAnim = true
      end
    end
  else
    ShoulPlayAdditiveAnim = true
  end
  if ShoulPlayAdditiveAnim then
    local DamageCauser = Battle(self):GetEntity(DamageEvent.SourceEid)
    DamageCauser = DamageCauser and DamageCauser:GetRootSource()
    return DamageCauser and self:PlayHitAddtiveAnimation(DamageCauser:K2_GetActorLocation())
  else
    return false
  end
end

return Component
