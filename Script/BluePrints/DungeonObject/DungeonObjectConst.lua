local DungeonObjectConst = {}
DungeonObjectConst.OpenDungeonObjectsTypes = {
  SoloTreasure = true,
  RougePro = true,
  IronSurvival = true,
  WeaponVerify = true,
  GuildBoss = true
}
DungeonObjectConst.TypeToActorClass = {
  SoloTreasure = nil,
  RougePro = UE and UE.ARougePro,
  IronSurvival = nil,
  WeaponVerify = nil
}
return DungeonObjectConst
