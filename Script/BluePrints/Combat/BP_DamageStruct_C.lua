require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local table_concat = table.concat
local BP_DamageStruct_C = Class({
  "BluePrints.Combat.Components.SkillLevelInterface"
})

function BP_DamageStruct_C:ShowDetails()
  if Const.bStatDamage and not Const.StartTime then
    Const.StartTime = os.clock()
  end
  Const.EndTime = os.clock()
  DebugPrint("-----------------玩家详细属性------------------")
  local AttrStr = ""
  local GameInstance = GWorld.GameInstance
  self.Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  local ATK = self.Player:GetAttr("ATK")
  local ATK_Char = self.Player:GetAttr("ATK_Char")
  local ATK_Wepon = ATK - ATK_Char
  local SkillIntensity = self.Player:GetAttr("SkillIntensity")
  local SkillSustain = self.Player:GetAttr("SkillSustain")
  local SkillRange = self.Player:GetAttr("SkillRange")
  local SkillEfficiency = self.Player:GetAttr("SkillEfficiency")
  local StrongValue = string.format("%.3f", (1 + (self.Player:GetAttr("StrongValue") or 0)) * 100)
  local EnmityValue = string.format("%.3f", (1 + (self.Player:GetAttr("EnmityValue") or 0)) * 100)
  DebugPrint("背水：" .. EnmityValue .. "%")
  AttrStr = AttrStr .. " 背水：" .. self.Player:GetAttr("EnmityValue")
  DebugPrint("昂扬：" .. StrongValue .. "%")
  AttrStr = AttrStr .. " 昂扬：" .. self.Player:GetAttr("StrongValue")
  local Weapon = self.Player:GetCurrentWeapon()
  if Weapon then
    local CRI = string.format("%.3f", Weapon:GetAttr("CRI") * 100)
    local CRD = string.format("%.3f", Weapon:GetAttr("CRD") * 100)
    local TRI = string.format("%.3f", Weapon:GetAttr("TriggerProbability") * 100)
    local MultiShoot = string.format("%.3f", Weapon:GetAttr("MultiShoot") * 100)
    DebugPrint("多重射击：" .. MultiShoot .. "%")
    DebugPrint("触发概率：" .. TRI .. "%")
    DebugPrint("爆伤：" .. CRD .. "%")
    DebugPrint("暴击：" .. CRI .. "%")
    AttrStr = AttrStr .. " 多重射击：" .. MultiShoot
    AttrStr = AttrStr .. " 触发概率：" .. TRI
    AttrStr = AttrStr .. " 爆伤：" .. CRD
    AttrStr = AttrStr .. " 暴击：" .. CRI
  end
  DebugPrint("技能效益：" .. string.format("%.3f", SkillEfficiency * 100) .. "%")
  DebugPrint("技能耐久：" .. string.format("%.3f", SkillSustain * 100) .. "%")
  DebugPrint("技能范围：" .. string.format("%.3f", SkillRange * 100) .. "%")
  DebugPrint("技能强度：" .. string.format("%.3f", SkillIntensity * 100) .. "%")
  DebugPrint("武器攻击：" .. ATK_Wepon)
  DebugPrint("角色攻击：" .. ATK_Char)
  DebugPrint("总攻击：" .. ATK)
  AttrStr = AttrStr .. " 技能效益：" .. SkillEfficiency
  AttrStr = AttrStr .. " 技能耐久：" .. SkillSustain
  AttrStr = AttrStr .. " 技能范围：" .. SkillRange
  AttrStr = AttrStr .. " 技能强度：" .. SkillIntensity
  AttrStr = AttrStr .. " 武器攻击：" .. ATK_Wepon
  AttrStr = AttrStr .. " 角色攻击：" .. ATK_Char
  DebugPrint("-----------------伤害详细------------------")
  if Const.bStatDamage then
    Const.TotalDamage = Const.TotalDamage + self.TrueValue
  end
  DebugPrint(string.format("本次伤害的SkillId: %d", self.SkillId))
  DebugPrint(string.format("造成的总伤害: %d", self.TrueValue))
  DebugPrint(string.format("对护盾造成伤害: %d", self.TrueValue - self.FinalValue))
  DebugPrint(string.format("对血量造成伤害: %d", self.FinalValue))
  local DamageValues = {}
  for DamageType, RateStruct in pairs(self.DamageValues) do
    local BaseRate = self.DamageBaseRates:Find(DamageType) or 0
    local BaseParamRate = self.DamageBaseParamRates:Find(DamageType) or 0
    local BaseParamValue = self.DamageBaseParamValues:Find(DamageType) or 0
    local RealBaseValue = (RateStruct.BaseValue - BaseParamRate - BaseParamValue) / BaseRate
    local _Str = "BaseValue: " .. tostring(RateStruct.BaseValue)
    if 0 ~= BaseRate then
      _Str = _Str .. " (" .. tostring(string.format("%.3f", RealBaseValue)) .. " × " .. tostring(string.format("%.3f", BaseRate)) .. " + " .. tostring(string.format("%.3f", BaseParamValue))
      if 0 == BaseParamRate then
        _Str = _Str .. ") "
      end
    end
    if 0 ~= BaseParamRate then
      _Str = _Str .. " + " .. tostring(string.format("%.3f", BaseParamRate)) .. ") "
    end
    _Str = _Str .. ",FinalValue: " .. tostring(RateStruct.FinalValue)
    if RateStruct.ShieldValue > 0 then
      _Str = _Str .. ",ShieldValue: " .. tostring(RateStruct.ShieldValue)
    end
    local RateStr
    for k, RateZoneInfo in pairs(RateStruct.DamageRates) do
      if not RateStr then
        RateStr = ",Rates:"
        _Str = _Str .. RateStr
      else
        _Str = _Str .. ","
      end
      local ZoneRatesStr = ""
      for Index = 1, RateZoneInfo.ZoneRates:Length() do
        local Rate = RateZoneInfo.ZoneRates:GetRef(Index)
        if 1 ~= Index then
          ZoneRatesStr = ZoneRatesStr .. "+"
        end
        ZoneRatesStr = ZoneRatesStr .. tostring(string.format("%.3f", Rate))
      end
      _Str = _Str .. tostring(k) .. ":" .. tostring(ZoneRatesStr)
    end
    DamageValues[DamageType] = _Str
  end
  local DamageTags = {}
  for k, v in pairs(self.DamageTag) do
    DamageTags[k] = v
  end
  local Result = {
    Attr = AttrStr,
    SourceEid = self.SourceEid,
    TargetEid = self.TargetEid,
    DamageValues = DamageValues,
    FinalValue = self.FinalValue,
    TrueValue = self.TrueValue,
    DamageTags = DamageTags
  }
  local ct = {
    "PrintTable: ",
    tostring("DamageStrcutDetails"),
    tostring(Result),
    "\n"
  }
  MiscUtils.GetStrTable(ct, Result, 1, 10)
  local ret = table_concat(ct)
  print(LogTag, ret)
  return ret
end

function BP_DamageStruct_C:GetExtraEffectDamageTypes()
  local OutTypes = UE.TArray(FString)
  for DamageType, DamageRate in pairs(self.DamageValues) do
    if DamageRate.ExtraEffect then
      OutTypes:Add(DamageType)
    end
  end
  return OutTypes
end

function BP_DamageStruct_C:GetDamageTags()
  local OutDamageTags = UE.TArray(FString)
  if self.DamageTag then
    for _, v in pairs(self.DamageTag) do
      OutDamageTags:Add(v)
    end
  end
  return OutDamageTags
end

return BP_DamageStruct_C
