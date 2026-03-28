local BP_SkillObject_C = Class()
BP_SkillObject_C._components = {
  "BluePrints.Combat.Components.SkillLevelInterface"
}
local SkillConfigs = DataMgr.Skill
local rawget, rawset = rawget, _ENV.rawset
local GetUProperty = _ENV.GetUProperty

local function GetCppProperty(t, mt, key)
  local value = rawget(t, key)
  if nil ~= value then
    return value
  end
  local p = rawget(mt, key)
  if nil == p then
    p = mt[key]
    if nil ~= p then
      rawset(mt, key, p)
    end
  end
  if nil ~= p and type(p) == "userdata" then
    return GetUProperty(t, p)
  end
  return nil
end

local function __InnerIndex(t, k)
  local v = rawget(t, k)
  if nil ~= v then
    return v
  end
  local NilSet = rawget(t, "__nil_cache")
  if NilSet and rawget(NilSet, k) then
    return nil
  end
  local mt = getmetatable(t)
  local p = rawget(mt, k)
  if nil == p then
    p = mt[k]
    if nil == p then
      rawset(mt, k, _NotExist)
    else
      rawset(mt, k, p)
    end
  end
  if rawequal(p, _NotExist) then
  elseif type(p) == "userdata" then
    v = GetUProperty(t, p)
    return v
  elseif nil ~= p then
    rawset(t, k, p)
    return p
  end
  local SkillData = rawget(t, "Data")
  if nil == SkillData then
    local SkillId = GetCppProperty(t, mt, "SkillId")
    if nil == SkillId then
      return
    end
    rawset(t, "SkillId", SkillId)
    local SkillLevel = GetCppProperty(t, mt, "SkillLevel")
    if nil == SkillLevel then
      return
    end
    local SkillGrade = GetCppProperty(t, mt, "SkillGrade")
    if nil == SkillGrade then
      return
    end
    SkillData = SkillConfigs[SkillId][SkillLevel][SkillGrade]
    rawset(t, "Data", SkillData)
  end
  if "Data" == k then
    return SkillData
  elseif SkillData then
    v = SkillData[k]
    if nil ~= v then
      rawset(t, k, v)
      return v
    end
  end
  if not NilSet then
    NilSet = {}
    rawset(t, "__nil_cache", NilSet)
  end
  rawset(NilSet, k, true)
  return nil
end

BP_SkillObject_C.__index = __InnerIndex
AssembleComponents(BP_SkillObject_C)
return BP_SkillObject_C
