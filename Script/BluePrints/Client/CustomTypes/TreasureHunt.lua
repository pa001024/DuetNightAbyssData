local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local TreasureHunt = Class("TreasureHunt", CustomTypes.CustomAttr)
TreasureHunt.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  TotalScore = prop.prop("Int", "client save", 0),
  NormalSquadInfoMap = prop.prop("Int2StrDict", "client save", {}),
  HardSquadInfoMap = prop.prop("Int2StrDict", "client save", {})
}

function TreasureHunt:Init(EventId)
  self.EventId = EventId
end

function TreasureHunt:GetScore()
  return self.TotalScore
end

function TreasureHunt:GetSquadInfo(DungeonId, IsHard)
  local SquadInfoStr
  if IsHard then
    SquadInfoStr = self.HardSquadInfoMap[DungeonId]
  else
    SquadInfoStr = self.NormalSquadInfoMap[DungeonId]
  end
  if not SquadInfoStr then
    return
  end
  return SerializeUtils:UnSerialize(SquadInfoStr)
end

function TreasureHunt:SetSquadInfo(DungeonId, Squad, IsHard)
  local SquadInfoStr = SerializeUtils:Serialize(Squad)
  if IsHard then
    self.HardSquadInfoMap[DungeonId] = SquadInfoStr
  else
    self.NormalSquadInfoMap[DungeonId] = SquadInfoStr
  end
end

FormatProperties(TreasureHunt)
local TreasureHuntDict = Class("TreasureHuntDict", CustomTypes.CustomDict)
TreasureHuntDict.KeyType = BaseTypes.Int
TreasureHuntDict.ValueType = TreasureHunt

function TreasureHuntDict:NewTreasureHunt(EventId)
  return TreasureHunt(EventId)
end

function TreasureHuntDict:GetTreasureHunt(EventId)
  if nil == self[EventId] then
    self[EventId] = self:NewTreasureHunt(EventId)
  end
  return self[EventId]
end

return {TreasureHunt = TreasureHunt, TreasureHuntDict = TreasureHuntDict}
