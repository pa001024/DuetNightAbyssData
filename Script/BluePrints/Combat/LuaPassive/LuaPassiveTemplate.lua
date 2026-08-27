local M = {}

function M:BeginPlay()
end

function M:InitDamage(Character, Damage, Source, Target)
end

function M:InitDamaged(Character, Damage, Source, Target)
end

function M:InitDamage_Low(Character, Damage, Source, Target)
end

function M:InitDamaged_Low(Character, Damage, Source, Target)
end

function M:CalculateDamage(Character, Damage, Source, Target)
end

function M:Damage(Character, Damage, Source, Target)
end

function M:Damaged(Character, Damage, Source, Target)
end

function M:BreakCountDown(Character, Damage, TargetEid)
end

function M:OnDamageCrit(Character, Damage, Source, Target)
end

function M:OnDamageTrig(Character, Damage, Source, Target)
end

function M:InitHeal(Character, Damage, Source, Target)
end

function M:InitHealed(Character, Damage, Source, Target)
end

function M:CalculateHeal(Character, Damage, Source, Target)
end

function M:Heal(Character, Damage, Source, Target)
end

function M:Healed(Character, Damage, Source, Target)
end

function M:BeforeSkill(Character, Skill)
end

function M:AfterSkill(Character, Skill)
end

function M:AfterNotExecuteSkill(Character, Skill)
end

function M:EnterNode(Character, NodeId, SkillNode)
end

function M:LeaveNode(Character, NodeId, SkillNode)
end

function M:OnSelfDying(Character, Damage)
end

function M:OnBeforeDead(Source, DeathReason)
end

function M:OnAfterDead(Source, KillMineRoleId, DeathReason, KillMineSkillId)
end

function M:OnPhantomDead(Character, Phantom)
end

function M:OnPhantomRecover(Character, Phantom)
end

function M:OnMySummonDying(Character, Summon)
end

function M:OnRecover(Source)
end

function M:OnShieldBreak(Character, Damage, Source, Target)
end

function M:OnLockedHp(LockHpTarget, LockHpRate)
end

function M:OverShieldChanged(Character, Source, Before, After, Reason)
end

function M:BeforeSpChanged(Character, Before, After, Reason)
end

function M:SpChanged(Character, Before, After, Reason)
end

function M:SecondSpChanged(Character, Before, After, Reason)
end

function M:WeaponSpChanged(Character, Before, After)
end

function M:SecondaryResourceChanged(Character, Before, After)
end

function M:MaxSpChanged(Character, Before, After)
end

function M:HpChanged(Character, Before, After)
end

function M:ComboCountChanged(Character, Weapon, BeforeComboCount, BeforeComboLevel, CurrentComboCount, CurrentComboLevel, ClearComboReason)
end

function M:ComboCountOverflowChanged(Character, OverflowComboDelta)
end

function M:AttackSpeedNormalChanged(Character, CurrentWeapon, BeforeValue, AfterValue)
end

function M:SkillSpeedChanged(Character, BeforeValue, AfterValue)
end

function M:AddEnergyShield(Source, Target, Change, IsOverShield)
end

function M:AddedEnergyShield(Character, Source, Change)
end

function M:AfterCutToughness(Character, Target, Skill, BeforeTN, CurrentTN, RealCutValue)
end

function M:AfterBeCutToughness(Character, Source, Skill, BeforeTN, CurrentTN, RealCutValue)
end

function M:OnToughnessToZero(Character)
end

function M:RecoverMaxTNEvent(Character)
end

function M:EnterDefeatedEvent(Character)
end

function M:ExecuteCondemnedEvent(Character)
end

function M:BeCondemned(Character)
end

function M:OnCreateSummon(Character, Summon)
end

function M:OnGetBullet(Character, BeforeSurplusNum, AfterSurplusNum, GetBulletReason)
end

function M:OnConsumeBullet(Character, BeforeSurplusNum, AfterSurplusNum)
end

function M:OnChargeBullet(Character, ChargeAmount)
end

function M:OnMagazineBulletCleared(Source)
end

function M:OnGetDrop(Character, UnitId)
end

function M:OnWeaponChanged(Character, LastWeapon, CurrentWeapon)
end

function M:EnterSlide(Character)
end

function M:QuitSlide(Character)
end

function M:EnterSprint(Character)
end

function M:QuitSprint(Character)
end

function M:EnterDodging(Character, IsDodgeBack)
end

function M:QuitDodging(Character, IsDodgeBack)
end

function M:EnterJetRush(Character)
end

function M:LeaveJetRush(Character)
end

function M:EnterJetJump(Character)
end

function M:LeaveJetJump(Character)
end

function M:EnterBulletJump(Character)
end

function M:QuitBulletJump(Character)
end

function M:EnterLanding(Character, Speed)
end

function M:EnterHitFly(Character, HitDirection)
end

function M:EnterNOS(Character)
end

function M:LeaveNOS(Character)
end

function M:OnDisarm(Source, TargetCount)
end

function M:OnAddBuffToOther(Character, Target, BuffId, BuffNum)
end

function M:OnMonsterAddedBuff(Character, Target, BuffId, BuffNum)
end

function M:OnBuffRemovedFromTarget(Character, Target, BuffId, BuffTime)
end

function M:BeforeSupportSkill(Character)
end

function M:AfterSupportSkill(Character)
end

function M:RougeParamSave(Character, RougeLikeManager)
end

function M:RougeParamRecover(Character, RougeLikeManager)
end

function M:RougeEnterNewRoom(Character)
end

return M
