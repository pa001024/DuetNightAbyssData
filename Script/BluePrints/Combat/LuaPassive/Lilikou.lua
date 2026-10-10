local M = {}

function M:BeginPlay()
  UE4.UBattleFunctionLibrary.SetMaxSecondSp(self.PassiveOwner, 60)
  self.WindChaosCount = 0
end

local function GetStage(self)
  local Stages = UE4.UCreatureFunctionLibrary.GetSkillCreatureByCreatureId(self.PassiveOwner, 540202)
  if Stages and Stages:Num() > 0 then
    return Stages:Get(1)
  end
  return nil
end

local function HasStageBuff(self)
  local Buff = UE4.UBattleFunctionLibrary.FindBuffById(self.PassiveOwner, 540202, 0, false)
  return nil ~= Buff
end

local function CallClient(self, FuncName, ...)
  local Client = self.PassiveEffectClient
  if Client and Client[FuncName] then
    return Client[FuncName](Client, ...)
  end
end

function M:TrySuperBeat()
  local Sp = self.PassiveOwner:GetAttrByConstrain(EAttrName.SecondSp)
  local SpInt = math.floor(Sp + 0.001)
  if SpInt < self.SuperBeatCost then
    return
  end
  UE4.UBattleFunctionLibrary.AddSecondSpToTarget(self.PassiveOwner, self.PassiveOwner, math.floor(-self.SuperBeatCost), EChangedSpReason.FromSkillEffect)
  UE4.UBattleFunctionLibrary.ExecuteSkillEffects(self.PassiveOwner, {
    540232,
    540231,
    540234
  }, self.PassiveOwner, self.OwnerSkill, self.OwnerSkill)
  self.WindChaosCount = 0
  local Stage = GetStage(self)
  if Stage then
    Stage:SuperBeat()
  end
end

function M:OnStage()
  if HasStageBuff(self) then
    CallClient(self, "CreateCopy", false)
    local Stage = GetStage(self)
    if Stage then
      Stage:SwitchStage(true)
    end
  else
    self.PassiveOwner:BlueprintUseSkill(540222)
    local P = self
    self:AddTimer(0.5, function()
      local Stage = GetStage(P)
      if Stage then
        Stage:SwitchStage(false)
      end
      CallClient(P, "CreateCopy", true)
    end, false, 0, "LilikouOnStageDelay")
  end
end

function M:DownStage()
  local Stage = GetStage(self)
  if HasStageBuff(self) then
    CallClient(self, "CreateCopy", false)
    if Stage then
      Stage:SwitchStage(true)
    end
  elseif Stage then
    Stage:SwitchStage(true)
  end
end

local SKILL2OFF_BUFFTYPE = 540201
local SKILL2OFF_SKILLID = 540211
local SKILL2OFF_EFFECT = 540214
local SkillFunctionLibrary

local function GetSkillFunctionLibrary()
  if not SkillFunctionLibrary then
    SkillFunctionLibrary = LoadClass("/Game/BluePrints/Common/BP_SkillFunctionLibrary")
  end
  return SkillFunctionLibrary
end

function M:SpChanged(Character, Before, After, Reason)
  if Before < After or After >= 1 then
    return
  end
  if not Character then
    return
  end
  local Library = GetSkillFunctionLibrary()
  if not Library then
    return
  end
  Library.Skill2Off(Character, SKILL2OFF_BUFFTYPE, SKILL2OFF_SKILLID, {SKILL2OFF_EFFECT})
end

function M:OnAddBuffToOther(Character, Target, BuffId, BuffNum)
  if BuffId ~= (self.WindChaosBuffId or 115) then
    return
  end
  local Skill = self.OwnerSkill
  if not Skill or Skill.SkillGrade < 1 then
    return
  end
  local MaxCount = self.Grade1Max or 0
  if MaxCount <= 0 then
    return
  end
  if not Target or Target:GetEid() == self.PassiveOwner:GetEid() then
    return
  end
  if MaxCount <= self.WindChaosCount then
    return
  end
  self.WindChaosCount = self.WindChaosCount + 1
  UE4.UBattleFunctionLibrary.ExecuteSkillEffects(self.PassiveOwner, {540241, 540242}, Target, self.OwnerSkill, self.OwnerSkill)
end

function M:InitDamage(Character, Damage, Source, Target)
  if not Damage:HaveDamageTag("Skill") then
    return
  end
  if not Character then
    return
  end
  local RangedWeaponId = Character:GetRangedWeaponId()
  local Weapon = RangedWeaponId and RangedWeaponId > 0 and Character:GetWeapon(RangedWeaponId)
  if not Weapon then
    return
  end
  local WeaponTP = Weapon:GetAttr("TriggerProbability")
  if WeaponTP > Damage.TriggerProbability then
    Damage.TriggerProbability = WeaponTP
  end
end

return M
