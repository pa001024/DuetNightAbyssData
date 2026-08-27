require("UnLua")
local BP_SabotagePlusComponent_C = Class({
  "BluePrints.Common.TimerMgr"
})

function BP_SabotagePlusComponent_C:InitSabotagePlusComponent()
  self.GameMode = self:GetOwner()
  local SabotagePlusInfo = DataMgr.SabotagePlus[self.GameMode.DungeonId]
  if not SabotagePlusInfo then
    GameState(self):ShowDungeonError("SabotagePlusComponent:当前副本ID没有填写在对应的副本表中, 读表失败! 读入Id：" .. self.GameMode.DungeonId, Const.DungeonErrorType.DungeonGame, Const.DungeonErrorTitle.Config)
    return
  end
  self.TargetKillNum = SabotagePlusInfo.TargetKillNum or 1
  self.TargetDestroyNum = SabotagePlusInfo.TargetDestroyNum or 1
  self.TimeLimit = SabotagePlusInfo.TimeLimit or -1
  DebugPrint("BP_SabotagePlusComponent_C InitSabotagePlusComponent")
end

function BP_SabotagePlusComponent_C:InitSabotagePlusBaseInfo()
end

return BP_SabotagePlusComponent_C
