local ArmoryUtils = {}

local SkillUtils = require("Utils.SkillUtils")

-- L-498
function ArmoryUtils:GenModPassiveEffectDesc(ModConf, BaseLevel, ExpectLevel)
    local Desc = ModConf.PassiveEffectsDesc and GText(ModConf.PassiveEffectsDesc) or ""
    if not ModConf.DescValues then
        return Desc
    end

    ExpectLevel = ExpectLevel == nil and BaseLevel or ExpectLevel
    local CastTo
    for i, DescValue in pairs(ModConf.DescValues) do
        Desc, CastTo = SkillUtils.ReplaceDescValueTypeCast(Desc, i)
        CastTo = string.find(DescValue, "math.floor") ~= nil
        local Percent = string.match(DescValue, "%%") or ""
        local ValStr = self:_ModAttrGrowDesc2(DescValue, BaseLevel, ExpectLevel, Percent, CastTo)
        ValStr = ValStr == "" and self:_SkillGrowDesc(DescValue, BaseLevel, ExpectLevel, Percent, CastTo) or ValStr
        Desc = string.gsub(Desc, "#" .. i, ValStr)
    end

    return Desc
end

-- L-516
local function _GetModAttrConf(DescValue, ModId, AttrIdx, ValueType)
    local ModConf = DataMgr.Mod[ModId]
    if not ModConf.AddAttrs then
        error("被动效果数值的ModId填错了!!!" .. "策划检查一下" .. DescValue, 0)
        return nil
    end

    local ModAttrConf = ModConf.AddAttrs[AttrIdx]
    if not ModAttrConf then
        error("被动效果数值的AddAttrs[索引]索引填错了!!!" .. "策划检查一下" .. DescValue, 0)
        return nil
    end

    return ModAttrConf
end

-- L-530
function ArmoryUtils:_ModAttrGrowDesc2(DescValue, BaseLevel, ExpectLevel, Percent, CastTo, ForbidFormat)
    if string.match(DescValue, "GetModValue") then
        local function _GetModValue(GetModValue_Level)
            return function(ModId, AttrIdx, ValueType)
                local ModAttrConf = _GetModAttrConf(DescValue, ModId, AttrIdx, ValueType)
                if not ModAttrConf then
                    return 0
                end

                local Res = self:CalcModAttrByLevel(ModAttrConf, GetModValue_Level or 0, ValueType, ModId)
                return Res
            end
        end

        local OldValStr = SkillUtils.SplitEval(DescValue, "$", {
            GetModValue = _GetModValue(BaseLevel)
        }) .. Percent
        local NewValStr = SkillUtils.SplitEval(DescValue, "$", {
            GetModValue = _GetModValue(ExpectLevel)
        }) .. Percent
        if not ForbidFormat then
            OldValStr = SkillUtils.FormatDescValue1(OldValStr, CastTo)
            NewValStr = SkillUtils.FormatDescValue1(NewValStr, CastTo)
        end
        return OldValStr ~= NewValStr and OldValStr .. " -> " .. string.format("<H>%s</>", NewValStr) or NewValStr
    end

    if string.match(DescValue, "GetModPolarity") then
        local function _GetModPolarity()
            return function(ModId, AttrIdx, ValueType)
                if not DataMgr.Mod[ModId] then
                    return DataMgr.ModPolarity[CommonConst.NonePolarity].Char
                end

                local Polarity = DataMgr.Mod[ModId].Polarity
                return DataMgr.ModPolarity[Polarity].Char
            end
        end

        local ValStr = SkillUtils.SplitEval(DescValue, "$", {
            GetModPolarity = _GetModPolarity()
        })
        return ValStr
    end

    return ""
end

-- L-575
function ArmoryUtils:_SkillGrowDesc(DescValue, BaseLevel, ExpectLevel, Percent, CastTo, ForbidFormat)
    local OldValStr = SkillUtils.CalcSkillDesc(DescValue, BaseLevel) .. Percent
    local NewValStr = SkillUtils.CalcSkillDesc(DescValue, ExpectLevel) .. Percent
    local bRepeatModLevel = string.find(DescValue, "RepeatModLevel")
    if not ForbidFormat and not bRepeatModLevel then
        OldValStr = SkillUtils.FormatDescValue1(OldValStr, CastTo)
        NewValStr = SkillUtils.FormatDescValue1(NewValStr, CastTo)
    end
    return OldValStr ~= NewValStr and OldValStr .. " -> " .. string.format("<H>%s</>", NewValStr) or NewValStr
end

-- L-586
function ArmoryUtils:GenModAttrData(ModAttrConf, ModLevel, AttrConf, ModId)
    local IsRate = ModAttrConf.Rate ~= nil
    local Value = self:CalcModAttrByLevel(ModAttrConf, ModLevel, nil, ModId)
    local ValueStr = CommonUtils.AttrValueToString(AttrConf, Value, IsRate)
    ValueStr = (Value > 0 and "+" or "") .. ValueStr
    return Value, ValueStr
end

-- L-594
function ArmoryUtils:CalcModAttrByLevel(ModAttrConf, ModLevel, ValueType, ModId)
    local IsRate = ModAttrConf.Rate ~= nil
    local Base = IsRate and ModAttrConf.Rate or ModAttrConf.Value
    if ValueType then
        if string.lower(ValueType) == "rate" then
            Base = ModAttrConf.Rate
            IsRate = true
        elseif string.lower(ValueType) == "value" then
            Base = ModAttrConf.Value
            IsRate = false
        end
    end
    if type(Base) ~= "number" then
        local AttrData = SkillUtils.GrowProxy("Mod", ModId, {
            GetSkillLevelInfo = function(self)
                return {
                    SkillLevel = ModLevel
                }
            end
        }, ModAttrConf)
        local Value = tonumber(IsRate and AttrData.Rate or AttrData.Value)
        if not Value then
            error(string.format("ModId: %s 的SkillGrow配置有问题，缺少等级%s的成长数值，请检查SkillGrow表", ModId, ModLevel))
            return 0
        end
        return Value
    end
    return Base + (ModAttrConf.LevelGrow or 0) * ModLevel
end

return ArmoryUtils
