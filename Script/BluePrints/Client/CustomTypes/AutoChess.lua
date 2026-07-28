local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local AutoChessCard = Class("AutoChessCard", CustomTypes.CustomAttr)
AutoChessCard.__Props__ = {
  Equips = prop.prop("IntList", "client save")
}

function AutoChessCard:AddEquip(EquipId)
  if self.Equips:Length() >= 2 then
    return false
  end
  self.Equips:Append(EquipId)
  return true
end

function AutoChessCard:ReplaceEquip(Idx, EquipId)
  self.Equips[Idx] = EquipId
end

FormatProperties(AutoChessCard)
local AutoChessCardDict = Class("AutoChessCardDict", CustomTypes.CustomDict)
AutoChessCardDict.KeyType = BaseTypes.Int
AutoChessCardDict.ValueType = AutoChessCard
local AutoChessSquadList = Class("AutoChessSquadList", CustomTypes.CustomList)
AutoChessSquadList.ValueType = CustomTypes.Int2IntDict
local AutoChessSharedSquad = Class("AutoChessSharedSquad", CustomTypes.CustomAttr)
AutoChessSharedSquad.__Props__ = {
  Buffs = prop.prop("IntList", "client save"),
  Squad = prop.prop("Int2IntDict", "client save"),
  Equips = prop.prop("Int2IntListDict", "client save"),
  ShareCode = prop.prop("Str", "client save", ""),
  ChallengeCount = prop.prop("Int", "client save", 0),
  WinCount = prop.prop("Int", "client save", 0),
  Cost = prop.prop("Int", "client save", 0),
  BattleCost = prop.prop("Int", "client save", 0)
}

function AutoChessSharedSquad:AddBuff(BuffId)
  self.Buffs:Append(BuffId)
end

function AutoChessSharedSquad:AddChallengeCount()
  self.ChallengeCount = self.ChallengeCount + 1
end

function AutoChessSharedSquad:AddWinCount()
  self.WinCount = self.WinCount + 1
end

FormatProperties(AutoChessSharedSquad)
local AutoChessSharedSquadDict = Class("AutoChessSharedSquadDict", CustomTypes.CustomDict)
AutoChessSharedSquadDict.KeyType = BaseTypes.Int
AutoChessSharedSquadDict.ValueType = AutoChessSharedSquad
local AutoChess = Class("AutoChess", CustomTypes.CustomAttr)
AutoChess.__Props__ = {
  EventId = prop.prop("Int", "client save", 0),
  RankLevel = prop.prop("Int", "client save", 1),
  RankScore = prop.prop("Int", "client save", 0),
  UnlockedCards = prop.prop("AutoChessCardDict", "client save"),
  UnlockedEquips = prop.prop("IntList", "client save"),
  Squads = prop.prop("AutoChessSquadList", "client save"),
  RefreshCount = prop.prop("Int", "client save", 0),
  RandomMissionId = prop.prop("Int", "client save", 0),
  RandomFactor = prop.prop("Int", "client save", 0),
  RandomBuffList = prop.prop("IntList", "client save"),
  DailyChallengeBuffs = prop.prop("IntSet", "client save"),
  ChallengeBuffs = prop.prop("IntSet", "client save"),
  PassChallengeBuffs = prop.prop("IntSet", "client save"),
  LastWinSquad = prop.prop("Int2IntDict", "client save"),
  SharedSquads = prop.prop("AutoChessSharedSquadDict", "client save"),
  ShareCodeSet = prop.prop("StrSet", "client save"),
  ShareCodeList = prop.prop("StrList", "client save"),
  ChallengedShareCodeSet = prop.prop("StrSet", "client save"),
  SharedSquadTotalWinCount = prop.prop("Int", "client save", 0)
}

function AutoChess:ClearRandomMission()
  self.RandomMissionId = 0
  self.RandomFactor = 0
  self.RandomBuffList = {}
end

function AutoChess:ClearEventData()
  self.EventId = 0
  self.RankLevel = 1
  self.RankScore = 0
  self.UnlockedCards = {}
  self.UnlockedEquips = {}
  self.DailyChallengeBuffs = {}
  self.ChallengeBuffs = {}
  self.PassChallengeBuffs = {}
  self.LastWinSquad = {}
  self.SharedSquads = {}
  self.ShareCodeSet = {}
  self.ShareCodeList = {}
  self.ChallengedShareCodeSet = {}
  self.SharedSquadTotalWinCount = 0
  self:ClearRandomMission()
  self.Squads = {}
  for i = 1, DataMgr.GlobalConstant.AUTO_CHESS_SQUAD_MAX.ConstantValue do
    self.Squads:Append({})
    self.SharedSquads:AddValue(i, {})
  end
end

function AutoChess:IsEquipUnlocked(EquipId)
  return self.UnlockedEquips:HasValue(EquipId)
end

function AutoChess:UnlockCard(CardId)
  self.UnlockedCards:AddValue(CardId, AutoChessCard())
end

function AutoChess:UnlockEquip(EquipId)
  self.UnlockedEquips:Append(EquipId)
end

function AutoChess:AddSharedSquadTotalWinCount()
  self.SharedSquadTotalWinCount = (self.SharedSquadTotalWinCount or 0) + 1
end

FormatProperties(AutoChess)
return {
  AutoChessCard = AutoChessCard,
  AutoChessCardDict = AutoChessCardDict,
  AutoChessSquadList = AutoChessSquadList,
  AutoChessSharedSquad = AutoChessSharedSquad,
  AutoChessSharedSquadDict = AutoChessSharedSquadDict,
  AutoChess = AutoChess
}
