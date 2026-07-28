local RougeProGame = DungeonClass.Class()
RougeProGame.__Component__ = {
  "BluePrints.DungeonObject.RougePro.RougeProProfession",
  "BluePrints.DungeonObject.RougePro.RougeProEffect",
  "BluePrints.DungeonObject.RougePro.RougeProEffectImplement",
  "BluePrints.DungeonObject.RougePro.RougeProRandom",
  "BluePrints.DungeonObject.RougePro.RougeProShopNpc",
  "BluePrints.DungeonObject.RougePro.RougeProContract",
  "BluePrints.DungeonObject.RougePro.RougeProDungeonGamePlay",
  "BluePrints.DungeonObject.RougePro.RougeProGMCommond"
}

function RougeProGame:BeginPlay()
  self.SeasonId = 1
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
  self:ApplyRougeProContract()
end

function RougeProGame:StartProfessionSelect()
  self:Log("StartProfessionSelect")
  self.SeasonId = 1
  assert(self.SeasonId)
  local SeasonInfo = DataMgr.RougeProSeason[self.SeasonId]
  local ClassChooseTime = SeasonInfo.ClassChooseTime
  self:NotifyGameModeDungeonEvent("OnStartProfessionSelect")
end

function RougeProGame:StartGame()
  self:Log("StartRougeProGame")
  self:ActivateProfessionEffect()
end

function RougeProGame:OnNotifyServerDungeonEvent_GMSetRougeProProfession(AvatarEidStr, ProfessionId)
  ProfessionId = tonumber(ProfessionId)
  AvatarEidStr = AvatarEidStr and tostring(AvatarEidStr) or nil
  if not ProfessionId or not AvatarEidStr then
    self:Log("GMSetRougeProProfession invalid args", AvatarEidStr, ProfessionId)
    return
  end
  self:SelectProfession(AvatarEidStr, ProfessionId)
  self:Log("GMSetRougeProProfession", AvatarEidStr, ProfessionId)
end

function RougeProGame:OnNotifyServerDungeonEvent_GMRougeProStartGame()
  self:Log("GMRougeProStartGame")
  self:StartGame()
end

function RougeProGame:CanAddTreasureForPlayer(Player, TreasureId)
  local TreasureData = DataMgr.RougeProTreasure[TreasureId]
  if not TreasureData then
    print("CanAddTreasureForPlayer but cannot find Treasure Data")
    return false
  end
  if TreasureData.Unique then
    for _, _Player in self:PlayerIterator() do
      if _Player:HasRougeProTreasure(TreasureId) then
        print("CanAddTreasureForPlayer fail. TreasureData.Unique")
        return false
      end
    end
  end
  return true
end

function RougeProGame:AddTreasureForPlayer(Player, TreasureId)
  local TreasureData = DataMgr.RougeProTreasure[TreasureId]
  if not TreasureData then
    print("AddTreasureForPlayer but cannot find Treasure Data")
    return
  end
  if TreasureData.Unique then
    for _, _Player in self:PlayerIterator() do
      if _Player:HasRougeProTreasure(TreasureId) then
        print("AddTreasureForPlayer fail. TreasureData.Unique")
        return
      end
    end
  end
  self:Log("AddTreasureForPlayer", TreasureId)
  Player:AddNewTreasure(TreasureId)
  self:ActivateRougeProEffects(Player, TreasureData.Effect)
end

DungeonClass.AssembleComponents(RougeProGame)
return RougeProGame
