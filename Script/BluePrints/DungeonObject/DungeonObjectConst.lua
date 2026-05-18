local DungeonObjectConst = {}
DungeonObjectConst.OpenDungeonObjectsTypes = {
  SoloTreasure = true,
  RougePro = true,
  IronSurvival = true
}
DungeonObjectConst.TypeToActorClass = {
  SoloTreasure = nil,
  RougePro = UE and UE.ARougePro,
  IronSurvival = nil
}
return DungeonObjectConst
