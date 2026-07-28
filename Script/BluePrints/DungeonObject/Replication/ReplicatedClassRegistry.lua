local TestClass = require("BluePrints.DungeonObject.Replication.TestClass")
local TestClass2 = require("BluePrints.DungeonObject.Replication.TestClass2")
local Player = require("BluePrints.DungeonObject.Entity.Player")
local RougeProEvent = require("BluePrints.DungeonObject.RougePro.RougeProEventManager.RougeProEvent")
local RougeTreasure = require("BluePrints.DungeonObject.Entity.RougeTreasure")
local RougeProRewardDropBox = require("BluePrints.DungeonObject.RougePro.RougeProRewardDropBoxManager.RougeProRewardDropBox")
return {
  TestClass = TestClass,
  TestClass2 = TestClass2,
  Player = Player,
  RougeProEvent = RougeProEvent,
  RougeTreasure = RougeTreasure,
  RougeProRewardDropBox = RougeProRewardDropBox
}
