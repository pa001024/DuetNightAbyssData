require("UnLua")

-- 配置项开始
local CharId = 1801
local Levels = {1, 20, 30, 40, 50, 60, 70, 80}
-- 配置项结束

-- 入参处理开始
local args = {}
for i = 1, select("#", ...) do
    args[i] = select(i, ...)
end

if #args > 0 then
    CharId = tonumber(args[1])
end
-- 入参处理结束

local ItemUtils = require("Utils.ItemUtils")
local SkillUtils = require("Utils.SkillUtils")

local BattleCharData = DataMgr.BattleChar[CharId]
local LevelUpData = DataMgr.LevelUp

print(string.format("%s: %s", GText("UI_Chardata_Char_Name"), GText(BattleCharData.CharName)))

print("\n===== 属性 =====")
for _, Level in pairs(Levels) do
    local Attrs = {}
    local AttrNames = {"MaxHp", "DEF", "MaxES"}

    local BaseATK = BattleCharData.ATK or 0
    local ATKLevelGrow = BattleCharData.ATKLevelGrow
    if BaseATK and ATKLevelGrow then
        local Attribute = BattleCharData.Attribute

        local AttrName = "ATK_" .. Attribute
        if BattleCharData[AttrName] then
            BaseATK = BaseATK + BattleCharData[AttrName]
        end

        table.insert(Attrs, {
            Key = AttrName,
            Value = BaseATK * LevelUpData[Level][ATKLevelGrow]
        })
    end

    for _, AttrName in ipairs(AttrNames) do
        local BaseValue = BattleCharData[AttrName]
        local ValueLevelGrow = BattleCharData[AttrName .. "LevelGrow"]
        if BaseValue and ValueLevelGrow then
            local Value = BaseValue * LevelUpData[Level][ValueLevelGrow]
            if CommonUtils.AttrConvert[AttrName] then
                Value = CommonUtils.AttrConvert[AttrName](Value)
            end
            table.insert(Attrs, {
                Key = AttrName,
                Value = Value
            })
        end
    end

    local NewAttrs = {}
    for _, Attr in ipairs(Attrs) do
        local Data = DataMgr.AttrConfig[Attr.Key]
        table.insert(NewAttrs, {
            AttrName = Data.Name,
            AttrValue = CommonUtils.AttrValueToString(Data, Attr.Value)
        })
    end

    print(string.format("----- Lv.%d -----", Level))
    for _, Attr in pairs(NewAttrs) do
        print(string.format("%s: %s", GText(Attr.AttrName), Attr.AttrValue))
    end
end

print("\n===== 突破 =====")
local CharBreakData = DataMgr.CharBreak[CharId]
for _, BreakInfo in pairs(CharBreakData) do
    print(string.format("----- Stage %d -----", BreakInfo.CharBreakNum))
    for Index, ResourceId in ipairs(BreakInfo.ItemId) do
        local ResourceName = ItemUtils:GetItemName(ResourceId, "Resource")
        print(string.format("%s × %d", GText(ResourceName), BreakInfo.ItemNum[Index]))
    end
end

print("\n===== 技能 =====")
for _, SkillId in ipairs(BattleCharData.SkillList) do
    local SkillData = DataMgr.Skill[SkillId]
    if not SkillData then
        error("Skill 不存在: " .. SkillId)
    end

    local SkillName = SkillUtils.GetSkillName(SkillId)
    print(string.format("----- [%d] %s -----", SkillId, GText(SkillName)))

    local SkillMaxLevel = SkillUtils.GetMaxLevel(SkillId)
    if SkillMaxLevel ~= 1 then
        -- ExtraLevel 处理
        SkillMaxLevel = SkillMaxLevel + 2
    end

    local SkillInfo = SkillData[1][0]
    print(string.format("Name: %s", GText(SkillInfo.SkillName)))
    print(string.format("Desc:\n%s", GText(SkillInfo.SkillDesc)))

    if SkillInfo.ExplanationId then
        for _, Term in ipairs(SkillInfo.ExplanationId) do
            local CombatTermData = DataMgr.CombatTerm[Term]
            if CombatTermData then
                print(string.format("\nName: %s", GText(CombatTermData.CombatTerm)))
                print(string.format("Desc:\n%s", GText(CombatTermData.CombatTermExplaination)))
            else
                error("CombatTerm 不存在: " .. Term)
            end
        end
    end

    for SkillLevel = 1, SkillMaxLevel, 1 do
        if SkillMaxLevel ~= 1 then
            print(string.format("----- Lv.%d -----", SkillLevel))
        end

        local DescIdx2Group = {}
        if SkillInfo.SkillDescGroups then
            for GroupIdx, Group in pairs(SkillInfo.SkillDescGroups) do
                for GroupName, DescIdxs in pairs(Group) do
                    if DescIdxs and #DescIdxs > 0 then
                        for _, DescIdx in ipairs(DescIdxs) do
                            DescIdx2Group[DescIdx] = GText(GroupName)
                        end
                    end
                end
            end
        end

        if SkillInfo.SkillDescKeys then
            for Index, SkillDescKey in ipairs(SkillInfo.SkillDescKeys) do
                local AttrDesc = GText(SkillDescKey)
                if DescIdx2Group[Index] then
                    AttrDesc = string.format("[%s]%s", DescIdx2Group[Index], AttrDesc)
                end
                local AttrValue = SkillUtils.CalcSkillDesc(SkillInfo.SkillDescValues[Index], SkillLevel)
                AttrValue = SkillUtils.FormatDescValue2(AttrValue)
                print(string.format("%s\t%s", AttrDesc, AttrValue))
            end
        end
    end
end

print("\n===== 溯源 =====")
for TraceId, GradeDesc in ipairs(BattleCharData.CharGradeDescription) do
    GradeDesc = GText(GradeDesc)

    for Index, CharGradeParameter in pairs(BattleCharData.CharGradeParameter) do
        local Parameter = SkillUtils.CalcSkillDesc(CharGradeParameter, TraceId)
        local SignIndex = string.find(Parameter, "%%", 1)
        if SignIndex then
            Parameter = Parameter .. "%"
        end
        GradeDesc = string.gsub(GradeDesc, "#" .. Index, Parameter)
    end

    print(string.format("%s:\n%s", GText("UI_ROOT_" .. TraceId), GradeDesc))
end

print("\n===== 档案 =====")
local CharacterData = DataMgr.CharacterDataTarget[CharId]
for _, Data in pairs(CharacterData) do
    local CharDataName = ""
    if Data.CharDataName then
        for _, v in ipairs(Data.CharDataName) do
            CharDataName = CharDataName .. GText(v)
        end
    end
    print(string.format("[%d] %s", Data.CharDataTarget, CharDataName))
    print(GText(Data.CharText))
    print("-----")
end
