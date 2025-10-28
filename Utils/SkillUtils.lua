local SkillUtils = {}

-- L-20
function SkillUtils.SplitEval(Str, Rep, Args)
    local GText = GText
    local ReStr = "[" .. Rep .. "]" .. "([^" .. Rep .. "]*)" .. "[" .. Rep .. "]"
    Str = string.gsub(Str, ReStr, function(W)
        if W == "" then
            W = "''"
        end
        local LuaStr = "return " .. W

        if not Args then
            Args = {}
        end
        Args.GText = GText or function(...)
            return ""
        end
        Args._G = _G
        Args.SkillUtils = SkillUtils
        setmetatable(Args, {
            __index = _G
        })
        local f = load(LuaStr, LuaStr, "t", Args)

        local Ret = f()
        local RetNum = tonumber(Ret)
        if RetNum then
            if Args.ImpactAttrs and next(Args.ImpactAttrs) then
                if CommonUtils.HasValue(Args.ImpactAttrs, "SkillEfficiency") and CommonUtils.HasValue(Args.ImpactAttrs, "SkillSustain") then
                    Ret = SkillUtils.ApplySkillSustainAndEfficiency(RetNum, Args.Attrs.SkillSustain, Args.Attrs.SkillEfficiency)
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillEfficiency") then
                    Ret = SkillUtils.ApplySkillEfficiencyWithLimit(RetNum, Args.Attrs.SkillEfficiency)
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillSustain") then
                    Ret = SkillUtils.ApplySkillSustain(RetNum, Args.Attrs.SkillSustain)
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillIntensity") then
                    Ret = SkillUtils.ApplySkillIntensity(RetNum, Args.Attrs.SkillIntensity)
                elseif CommonUtils.HasValue(Args.ImpactAttrs, "SkillRange") then
                    Ret = SkillUtils.ApplySkillRange(RetNum, Args.Attrs.SkillRange)
                end
            end
        end
        return tostring(Ret)
    end)
    return Str
end

-- L-61
function SkillUtils.CalcSkillDescValue(Desc, SkillLevel, Args)
    local Str = SkillUtils.CalcSkillDesc(Desc, SkillLevel, Args)
    local NewStr = tonumber(Str)
    if NewStr then
        return NewStr
    end
    return Str
end

-- L-70
function SkillUtils.CalcSkillDesc(Desc, SkillLevel, Args)
    local NewDesc = string.gsub(Desc, "#", "SkillUtils.NewGrowDesc(" .. SkillLevel .. ").")
    local ok, ret = pcall(SkillUtils.SplitEval, NewDesc, "$", Args)
    if not ok then
        -- error("识别技能描述【" .. tostring(Desc) .. "】失败!实际描述为【" .. tostring(NewDesc) .. "】请策划检查表格填写\nError:" .. tostring(ret))
        return NewDesc
    end
    return ret
end

-- L-233
function SkillUtils.GetMaxLevel(SkillId)
    local SkillLevelUpInfo = DataMgr.SkillLevelUp[SkillId]
    if SkillLevelUpInfo then
        return #SkillLevelUpInfo + 1
    end
    return 1
end

-- L-241
function SkillUtils.GrowDescIndex(_FinalProxy, Key)
    local RawData = rawget(_FinalProxy, "RawData")
    assert(RawData, "找不到DataMgr." .. tostring(_FinalProxy.DataProxy._GrowType) .. "[" .. tostring(_FinalProxy.ID) .. "]的数据")
    local Value = RawData[Key]
    assert(Value, "找不到DataMgr." .. tostring(_FinalProxy.DataProxy._GrowType) .. "[" .. tostring(_FinalProxy.ID) .. "]里某个Key[" .. tostring(Key) .. "]的数据")

    local GrowData = rawget(_FinalProxy, "GrowData")
    if type(Value) == "string" and string.sub(Value, 1, 1) == "#" then
        assert(GrowData, tostring(rawget(_FinalProxy, "Error")))
        local Index = tonumber(string.sub(Value, 2, -1))
        local IndexData = GrowData[Index]
        assert(IndexData, tostring(rawget(_FinalProxy, "Error")) .. "Index为[" .. tostring(Index) .. "]")
        Value = IndexData.Value
    end
    if type(Value) ~= "table" then
        return Value
    end

    return SkillUtils.CreateFinalProxy(_FinalProxy.DataProxy, _FinalProxy.ID, GrowData, Value, rawget(_FinalProxy, "Error"))
end

-- L-260
function SkillUtils.CreateFinalProxy(_DataProxy, ID, GrowData, RawData, Error)
    local _FinalProxy = {
        DataProxy = _DataProxy,
        GrowData = GrowData,
        RawData = RawData,
        Error = Error,
        ID = ID
    }
    setmetatable(_FinalProxy, {
        __index = SkillUtils.GrowDescIndex
    })
    return _FinalProxy
end

-- L-274
function SkillUtils.NewGrowDesc(SkillLevel)
    local bDistribution = true
    local _Proxy = {
        _SkillLevel = SkillLevel
    }
    setmetatable(_Proxy, {
        __index = function(M, GrowType)
            local _DataProxy = {
                _GrowType = GrowType,
                _SkillLevel = M._SkillLevel
            }
            setmetatable(_DataProxy, {
                __index = function(M, ID)
                    local RawData = DataMgr[M._GrowType][ID]
                    local Data, Error = SkillUtils.GetGrowData(M._GrowType, ID, M._SkillLevel)
                    if not Data then
                        if bDistribution then
                            return RawData
                        end
                        return SkillUtils.CreateFinalProxy(_DataProxy, ID, nil, RawData, Error)
                    end
                    local FinalProxy = SkillUtils.CreateFinalProxy(_DataProxy, ID, Data, RawData, Error)
                    return FinalProxy
                end
            })
            return _DataProxy
        end
    })
    return _Proxy
end

-- L-303
function SkillUtils.GetGrowData(GrowType, ID, SkillLevel)
    local _Data = DataMgr.SkillGrow[GrowType]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]的成长数据"
    end
    _Data = _Data[ID]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]编号为[" .. tostring(ID) .. "]的成长数据"
    end
    _Data = _Data[SkillLevel]
    if not _Data then
        return nil, "缺少类型为[" .. tostring(GrowType) .. "]编号为[" .. tostring(ID) .. "]等级为[" .. tostring(SkillLevel) .. "]的成长数据"
    end
    return _Data, ""
end

-- L-319
function SkillUtils.GrowProxyBySkillLevel(GrowType, ID, SkillLevel, RawData, Args)
    local GrowProxy = {
        _GrowType = GrowType,
        _ID = ID,
        _SkillLevel = SkillLevel or 1,
        _RawData = RawData,
        _Args = Args
    }
    return SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
end

-- L-330
function SkillUtils.GrowProxy(GrowType, ID, SkillLevelSource, RawData, Args)
    local GrowProxy = {
        _GrowType = GrowType,
        _ID = ID,
        _SkillLevel = 1,
        _RawData = RawData,
        _Args = Args
    }
    if SkillLevelSource then
        GrowProxy._SkillLevel = SkillLevelSource:GetSkillLevelInfo().SkillLevel
    end
    return SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
end

-- L-344
function SkillUtils._GrowProxy(GrowProxy, GrowType, ID, RawData, Args)
    local NeedSplitEvalProxy = false
    if DataMgr.SkillSplitEval[GrowType] and DataMgr.SkillSplitEval[GrowType][ID] then
        NeedSplitEvalProxy = true
    end

    local Data, _ = SkillUtils.GetGrowData(GrowProxy._GrowType, GrowProxy._ID, GrowProxy._SkillLevel)
    if not Data then
        return SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, GrowProxy._SkillLevel, RawData, GrowProxy._Args)
    end

    GrowProxy._GrowData = Data
    setmetatable(GrowProxy, {
        __index = function(M, key)
            local Value = M._RawData[key]
            if M._GrowData and type(Value) == "string" and string.sub(Value, 1, 1) == "#" then
                local GrowIndex = tonumber(string.sub(Value, 2, -1))
                local IndexData = M._GrowData[GrowIndex]
                if IndexData then
                    Value = IndexData.Value
                else
                    Value = 0
                end
            end
            rawset(M, key, Value)
            return Value
        end
    })

    return SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, GrowProxy._SkillLevel, GrowProxy, GrowProxy._Args)
end

-- L-373
function SkillUtils.SplitEvalProxy(NeedSplitEvalProxy, SkillLevel, RawData, Args)
    if not NeedSplitEvalProxy then
        return RawData
    end
    local SplitEvalProxy = {
        _SkillLevel = SkillLevel,
        _RawData = RawData,
        _Args = Args
    }
    setmetatable(SplitEvalProxy, {
        __index = function(M, key)
            local Value = M._RawData[key]
            if type(Value) == "string" then
                Value = SkillUtils.CalcSkillDescValue(Value, M._SkillLevel, Args)
            end
            rawset(M, key, Value)
            return Value
        end
    })
    return SplitEvalProxy
end

-- L-437
function SkillUtils.CalcWeaponPassiveEffectsDesc(WeaponData, GradeLevel, ComparedGradeLevel)
    local data = DataMgr.BattleWeapon[WeaponData.WeaponId]
    local SkillDesc
    if data and data.PassiveEffectsDesc then
        SkillDesc = GText(data.PassiveEffectsDesc)
        if data.PassiveEffectsDescValues then
            local CastTo
            for i, value in ipairs(data.PassiveEffectsDescValues) do
                SkillDesc, CastTo = SkillUtils.ReplaceDescValueTypeCast(SkillDesc, i)
                local valueStr = SkillUtils.CalcSkillDesc(value, math.min(DataMgr.DataConst.MaxSkillLevel, (GradeLevel or WeaponData.GradeLevel or 0) + 1))
                valueStr = SkillUtils.FormatDescValue1(valueStr, CastTo)
                if ComparedGradeLevel then
                    local ComparedValueStr = SkillUtils.CalcSkillDesc(value, math.min(DataMgr.DataConst.MaxSkillLevel, (ComparedGradeLevel or 0) + 1))
                    ComparedValueStr = SkillUtils.FormatDescValue1(ComparedValueStr, CastTo)
                    if valueStr ~= ComparedValueStr then
                        valueStr = valueStr .. "->" .. ComparedValueStr
                    end
                end
                SkillDesc = string.gsub(SkillDesc, "#" .. i, valueStr)
            end
        end
    end
    return SkillDesc
end

-- L-515
function SkillUtils.ReplaceDescValueTypeCast(Desc, Idx)
    if string.find(Desc, "{[I|i][N|n][T|t]}#" .. Idx) then
        return string.gsub(Desc, "{[I|i][N|n][T|t]}#" .. Idx, "#" .. Idx), true
    else
        return Desc, false
    end
end

-- L-523
function SkillUtils.FormatDescValue1(str, bToInt)
    local Res = str
    local value = string.match(str, "(%d+%.?%d*)")
    if value then
        local newValue = tonumber(value)
        local _pattern = "%.1f"
        if bToInt then
            value = math.floor(tonumber(value))
            _pattern = "%d"
        end
        if string.sub(str, -1) == "%" then
            newValue = string.format(_pattern .. "%%", value)
        else
            newValue = string.format(_pattern, newValue)
        end
        Res = newValue
    end
    local index = string.find(Res, "%%", 1)
    if index then
        Res = Res .. "%"
    end
    return Res
end

-- L-547
function SkillUtils.FormatDescValue2(str)
    local _start, _end = string.find(str, "%d+%.?%d*")
    local num = tonumber(string.sub(str, _start, _end))
    if num and math.floor(num) ~= math.ceil(num) then
        num = math.floor(num * 100 + 0.5) / 100
        str = string.sub(str, 1, _start - 1) .. num .. string.sub(str, _end + 1, #str)
    end
    return str
end

-- L-642
function SkillUtils.GetSkillName(SkillId)
    local Data = DataMgr.Skill[SkillId]
    local SkillData = Data and Data[1] and Data[1][0]
    if SkillData then
        return GText(SkillData.SkillName)
    end
end

return SkillUtils
