require("UnLua")

local ArmoryUtils = require("Utils.ArmoryUtils")
local TableUtils = require("Utils.TableUtils")

local ModData = DataMgr.Mod

local ModIdList = {}
for _, ModInfo in pairs(ModData) do
    if not ModInfo.IsNotOpen and ModInfo.CollectRewardExp then
        table.insert(ModIdList, ModInfo.Id)
    end
end

---@class ModGrowData
---@field Level integer @等级
---@field Cost integer @耐受值
---@field Attrs table<integer, string> @属性列表
---@field PassiveEffectsDesc string|nil @被动效果描述

---@class ModData
---@field Id integer @ID
---@field TypeName string @Mod筛选用类型名
---@field Name string @名称
---@field Rarity integer @稀有度
---@field Polarity integer @极性
---@field ApplicationType string @适用类型
---@field MaxLevel integer @最大等级(含增幅)
---@field GrowDatas table<integer, ModGrowData> @成长数据
---@field Icon string @图标

---@type table<integer, ModData>
local ModInfos = {}

for _, ModId in ipairs(ModIdList) do
    local ModInfo = ModData[ModId]

    local AppTypeTexts = {}
    for _, TagText in ipairs(DataMgr.ModTag[ModInfo.ApplicationType].ModTagText) do
        table.insert(AppTypeTexts, GText(TagText))
    end
    local AppTypeText = table.concat(AppTypeTexts, ", ")

    local function GetModAttrTexts(ModInfo, ModLevel)
        local Texts = {}
        local ModAttrs = ModInfo.AddAttrs
        if ModAttrs then
            for _, ModAttr in ipairs(ModAttrs) do
                local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
                if AttrConfig then
                    local _, ValueStr = ArmoryUtils:GenModAttrData(ModAttr, ModLevel, AttrConfig, ModInfo.Id)
                    local ModAttrText = GText(AttrConfig.Name) .. ValueStr
                    table.insert(Texts, ModAttrText)
                end
            end
        end
        return Texts
    end

    local function GetPassiveEffectsDesc(ModInfo, ModLevel)
        local PassiveEffectsDesc = ModInfo.PassiveEffectsDesc
        if PassiveEffectsDesc then
            local ModDescText = ArmoryUtils:GenModPassiveEffectDesc(ModInfo, ModLevel)
            return ModDescText
        end
        return nil
    end

    local GrowDatas = {}
    local ModMaxLevel = ModInfo.MaxLevel + (ModInfo.ModCardLevelMax or 0)
    for ModLevel = 0, ModMaxLevel, 1 do
        local GrowData = {
            Level = ModLevel,
            Cost = ModInfo.Cost + ModLevel * ModInfo.CostChange,
            Attrs = GetModAttrTexts(ModInfo, ModLevel),
            PassiveEffectsDesc = GetPassiveEffectsDesc(ModInfo, ModLevel)
        }
        table.insert(GrowDatas, GrowData)
    end

    local Info = {
        Id = ModInfo.Id,
        TypeName = GText(ModInfo.TypeName),
        Name = GText(ModInfo.TypeName) .. GText(ModInfo.Name),
        Rarity = ModInfo.Rarity,
        Polarity = ModInfo.Polarity,
        ApplicationType = AppTypeText,
        MaxLevel = ModMaxLevel,
        GrowDatas = GrowDatas,
        Icon = ModInfo.Icon
    }
    table.insert(ModInfos, Info)
end

table.sort(ModInfos, function(a, b)
    return a.Id < b.Id
end)

print(TableUtils:Dump(ModInfos))
