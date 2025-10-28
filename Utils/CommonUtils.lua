local CommonUtils = {}

-- L-412
function CommonUtils.AttrValueToString(AttrConfig, Value, IsRate, NotFormat)
    if not AttrConfig then
        return Value
    end
    if AttrConfig.NumCorrect and not IsRate then
        Value = Value * AttrConfig.NumCorrect
    end
    local percent = ""
    if AttrConfig.IsPercent or IsRate then
        Value = Value * 100
        percent = "%"
    end
    if NotFormat then
        return tostring(Value) .. percent
    end
    local a, b = math.modf(Value)
    if not (math.abs(b - 0) < 10e-6 or math.abs(b - 1) < 10e-6) then
        local floor = math.floor(b * 10 ^ 2 + 0.5) / 10 ^ 2
        if floor ~= 0 then
            a = a + floor
        end
    elseif b > 0.5 then
        a = a + 1
    end
    local str = tostring(a)
    local k
    while true do
        str, k = string.gsub(str, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then
            break
        end
    end
    return str .. percent
end

-- L-833
function CommonUtils.Round(FloatValue)
    if FloatValue == 0 then
        return 0
    end
    if FloatValue > 0 then
        return math.floor(FloatValue + 0.5)
    else
        return -CommonUtils.Round(-FloatValue)
    end
end

-- L-844
CommonUtils.AttrConvert = {
    Hp = CommonUtils.Round,
    MaxHp = CommonUtils.Round,
    ES = CommonUtils.Round,
    MaxES = CommonUtils.Round,
    MagazineCapacity = CommonUtils.Round,
    MagazineBulletNum = CommonUtils.Round,
    Sp = CommonUtils.Round,
    MaxSp = CommonUtils.Round,
    BulletNum = CommonUtils.Round
}

return CommonUtils
