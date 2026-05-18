local BP_DungeonObject_C = Class()
local DungeonFactory = require("BluePrints.DungeonObject.DungeonFactory")

function BP_DungeonObject_C:OnRep_DungeonId()
  local DungeonInfo = DataMgr.Dungeon[self.DungeonId]
  if not DungeonInfo then
    return
  end
  local DungeonType = DungeonInfo.DungeonType
  self.ClientDungeonObject = DungeonFactory.CreateClientDungeon(DungeonType)
  GWorld:SetClientDungeonObject_C(self.ClientDungeonObject)
end

function BP_DungeonObject_C:ReceiveBeginPlay()
  self.DungeonObject = GWorld:GetGameModeDungeonObject()
  if self.DungeonObject then
    self.DungeonObject:BindCObject(self)
  end
end

function BP_DungeonObject_C:ReceiveEndPlay()
  GWorld:SetClientDungeonObject_C(nil)
end

return BP_DungeonObject_C
