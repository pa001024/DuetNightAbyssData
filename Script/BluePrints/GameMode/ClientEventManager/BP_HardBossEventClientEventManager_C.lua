require("UnLua")
local M = Class({
  "BluePrints.GameMode.ClientEventManager.BP_BaseClientEventManager_C"
})

function M:OnClientInit()
  self.HardBossId = self:GetHardBossDungeonId(GameState(self).DungeonId)
  self.Overridden.OnClientInit(self)
  self:CheckReconnect()
end

function M:GetHardBossDungeonId(DungeonId)
  for _, Cfg in pairs(DataMgr.HardBossEventDungeonSelect) do
    if Cfg and Cfg.DungeonId then
      for _, Id in pairs(Cfg.DungeonId) do
        if Id == DungeonId then
          return Cfg.HardBossDungeonId or 0
        end
      end
    end
  end
  return 0
end

function M:CheckReconnect()
  if not GameState(self).IsPlayingSkillFeature then
    return
  end
  self:AddTimer(3, function()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    Player.RPCComponent:NotifyServerBossSkillFeatureSequenceFinish(Player.Eid)
    DebugPrint("HardBossDgComponent: CheckReconnect in skillfeature, notify DS to continue.")
  end)
end

return M
