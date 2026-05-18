local RougeProGame = DungeonClass.Class()
RougeProGame.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProProfession",
  "BluePrints.DungeonObject.RougePro.RougeProEffect",
  "BluePrints.DungeonObject.RougePro.RougeProEffectImplement",
  "BluePrints.DungeonObject.RougePro.RougeProRandom",
  "BluePrints.DungeonObject.RougePro.RougeProShop",
  "BluePrints.DungeonObject.RougePro.RougeProContract"
}

function RougeProGame:BeginPlay()
  if self.CustomDungeonParams then
    self.SeasonId = self.CustomDungeonParams.SeasonId
  end
end

function RougeProGame:InitExtra(Info)
  if self.SeasonId then
    return
  end
  self.SeasonId = Info.PlayerInfo.RougePro.ProgressingSeasonId
end

function RougeProGame:InitClassRegistry()
  self:RegisterReplicatedClass({
    Npc = "BluePrints.DungeonObject.Entity.Npc",
    RougeTreasure = "BluePrints.DungeonObject.Entity.RougeTreasure"
  })
end

function RougeProGame:OnNotifyServerDungeonEvent_OnInit()
  print("Game OnInit")
  self:StartProfessionSelect()
end

function RougeProGame:StartProfessionSelect()
  self:Log("StartProfessionSelect")
  assert(self.SeasonId)
  local SeasonInfo = DataMgr.RougeProSeason[self.SeasonId]
  local ClassChooseTime = SeasonInfo.ClassChooseTime
  self:NotifyGameModeDungeonEvent("OnStartProfessionSelect")
end

function RougeProGame:StartGame()
  self:ActivateProfessionEffect()
end

function RougeProGame:AddTreasureForPlayer(Player, TreasureId)
  local TreasureData = DataMgr.RougeProTreasure[TreasureId]
  if not TreasureData then
    print("AddTreasureForPlayer but cannot find Treasure Data")
    return
  end
  self:Log("AddTreasureForPlayer", TreasureId)
  Player:AddNewTreasure(TreasureId)
  self:ActivateRougeProEffects(Player, TreasureData.Effect)
end

DungeonClass.AssembleComponents(RougeProGame)
return RougeProGame
