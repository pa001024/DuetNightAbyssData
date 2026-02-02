require("UnLua")
local M = Class({
  "BluePrints.GameMode.ClientEventManager.BP_BaseClientEventManager_C"
})

function M:OnClientInit()
  local DungeonInfo = DataMgr.HardBossDg[GameState(self).DungeonId]
  if DungeonInfo then
    self.HardBossId = DungeonInfo.HardBossId or 0
  end
  self.Overridden.OnClientInit(self)
  self:CheckReconnect()
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
