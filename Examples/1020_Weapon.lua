require("UnLua")

-- 配置项开始
local WeaponId = 20509 -- 织梦的白羽
local Levels = {1, 20, 30, 40, 50, 60, 70, 80}
-- 配置项结束

-- 入参处理开始
local args = {}
for i = 1, select("#", ...) do
    args[i] = select(i, ...)
end

if #args > 0 then
    WeaponId = tonumber(args[1])
end
-- 入参处理结束

local ItemUtils = require("Utils.ItemUtils")
local SkillUtils = require("Utils.SkillUtils")

local WeaponData = DataMgr.Weapon[WeaponId]
local BattleWeaponData = DataMgr.BattleWeapon[WeaponId]
local LevelUpData = DataMgr.WeaponLevelUp

print(string.format("%s: %s", "Name", GText(WeaponData.WeaponName)))
print(string.format("%s: %s", "Desc", GText(WeaponData.WeaponDescribe)))

print("\n===== 属性 =====")
print(string.format("%s\t%s", "Level", "ATK"))
for _, Level in pairs(Levels) do
    local Attrs = {}

    local BaseATK = BattleWeaponData.ATK or 0
    local ATKLevelGrow = BattleWeaponData.ATKLevelGrow
    if BaseATK and ATKLevelGrow then
        for _AttrName, _ in pairs(DataMgr.Attribute) do
            local AttrName = "ATK_" .. _AttrName
            if BattleWeaponData[AttrName] then
                BaseATK = BaseATK + BattleWeaponData[AttrName]
            end
        end

        table.insert(Attrs, {
            Key = "ATK",
            Value = BaseATK * LevelUpData[Level][ATKLevelGrow]
        })
    end

    local NewAttrs = {}
    for _, Attr in ipairs(Attrs) do
        local Data = DataMgr.AttrConfig[Attr.Key]
        table.insert(NewAttrs, {
            AttrName = Data.Name,
            AttrValue = CommonUtils.AttrValueToString(Data, Attr.Value)
        })
    end

    for _, Attr in pairs(NewAttrs) do
        print(string.format("%d\t%s", Level, Attr.AttrValue))
    end
end

print("\n===== 突破 =====")
local WeaponBreakData = DataMgr.WeaponBreak[WeaponId]
for _, BreakInfo in pairs(WeaponBreakData) do
    print(string.format("----- Stage %d -----", BreakInfo.WeaponBreakNum))
    for Index, ResourceId in ipairs(BreakInfo.ItemId) do
        local ResourceName = ItemUtils:GetItemName(ResourceId, "Resource")
        print(string.format("%s × %d", GText(ResourceName), BreakInfo.ItemNum[Index]))
    end
end

print("\n===== 熔炼 =====")
local WeaponCardLevelData = DataMgr.WeaponCardLevel[WeaponId]
local MaxGradeLevel = WeaponCardLevelData and WeaponCardLevelData.CardLevelMax or 5
for GradeLevel = 1, MaxGradeLevel, 1 do
    local SkillDesc = SkillUtils.CalcWeaponPassiveEffectsDesc(BattleWeaponData, GradeLevel)
    print(string.format("%d\t%s", GradeLevel, SkillDesc))
end
