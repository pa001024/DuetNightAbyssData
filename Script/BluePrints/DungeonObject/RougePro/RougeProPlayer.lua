local EffectHelper = require("BluePrints.DungeonObject.RougePro.RougeProEffectImplement")
local RougeTreasure = require("BluePrints.DungeonObject.Entity.RougeTreasure")
local Player = DungeonClass.Class()
Player.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProEffectImplement"
}

function Player:PostOnInit()
  self:InitReplicatedProperties(self, "RougeProProfession", 1, "OnRep_RougeProProfession")
  self:InitReplicatedProperties(self, "RougeProTreasureList", {}, "OnRep_RougeProTreasureList")
end

function Player:SetRougeProProfession(ProfessionId)
  self.RougeProProfession = ProfessionId
end

function Player:GetRougeProProfession()
  return self.RougeProProfession
end

function Player:OnRep_RougeProProfession()
  print("OnRep_RougeProProfession", self.RougeProProfession)
end

function Player:OnRep_RougeProTreasureList()
  print("OnRep_RougeProTreasureList", self.RougeProTreasureList)
end

function Player:AddNewTreasure(TreasureId)
  self.RougeProTreasureList[#self.RougeProTreasureList + 1] = RougeTreasure(self.DungeonObject, TreasureId)
  self.RougeProTreasureList = self.RougeProTreasureList
end

function Player:HasRougeProTreasure(TreasureId)
  for i = 1, #self.RougeProTreasureList do
    local Treasure = self.RougeProTreasureList[i]
    if Treasure.TreasureId == TreasureId then
      return true
    end
  end
  return false
end

DungeonClass.AssembleComponents(Player)
return Player
