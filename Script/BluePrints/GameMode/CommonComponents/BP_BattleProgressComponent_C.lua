local M = Class()
local StyleToFunction = {
  EStandard = true,
  ELeftOnly = false,
  EClassic = true,
  EClassicTime = true
}

function M:StartBattleProgress(Style, TotalTime, IsRealTime, MaxProgressNum, DisPlayText)
  if self.IsStarted then
    ScreenPrint("BattleProgressComponent 已经开启此功能，请清除后再重新开启")
    return
  end
  DebugPrint("BattleProgressComponent StartBattleProgress", Style, TotalTime, IsRealTime, MaxProgressNum, DisPlayText)
  self.GameMode = self:GetOwner()
  self.GameState = self.GameMode.EMGameState
  self.IsStarted = true
  self.IsRealTimeCache = IsRealTime
  local StyleName = EBattleProgressStyle:GetNameByValue(Style)
  local IsActiveTimer = StyleToFunction[StyleName] or false
  self.GameState:SetBattleProgressInfo(Style, MaxProgressNum, DisPlayText)
  self.GameState:SetBattleProgressNum(0)
  if IsActiveTimer then
    self.GameMode:BpAddTimer(Const.BattleProgressTimerHandle, TotalTime, IsRealTime, Const.GameModeEventServerClient)
  else
    self.GameMode:AddDungeonEvent(Const.BattleProgressTimerHandle)
  end
end

function M:ClearBattleProgress()
  DebugPrint("BattleProgressComponent ClearBattleProgress")
  self.IsStarted = false
  self:RemoveTimer(Const.BattleProgressTimerHandle, self.IsRealTimeCache)
  self:RemoveClientTimerStruct(Const.BattleProgressTimerHandle)
  self:RemoveDungeonEvent(Const.BattleProgressTimerHandle)
end

function M:DeleteTimer()
  if not self.GameMode then
    return
  end
  if not self.IsStarted then
    return
  end
  self.GameMode:BpDelTimer(Const.BattleProgressTimerHandle, self.IsRealTimeCache, Const.GameModeEventServerClient)
end

function M:GetRemainTime()
  if not self.GameMode then
    return 0
  end
  return self.GameMode:BpGetRemainTime(Const.BattleProgressTimerHandle)
end

function M:OnTimerDel()
  self.Event_OnTimerDel:Broadcast()
  self.IsStarted = false
end

function M:OnTimerEnd()
  self.Event_OnTimerEnd:Broadcast()
  self.IsStarted = false
end

function M:SetBattleProgressNum(Num)
  if not self.GameState then
    return
  end
  if not self.IsStarted then
    return
  end
  self.GameState:SetBattleProgressNum(Num)
end

function M:AddBattleProgressNum(Num)
  if not self.GameState then
    return
  end
  if not self.IsStarted then
    return
  end
  self.GameState:SetBattleProgressNum(self.GameState.BattleProgressNum + Num)
end

function M:GetBattleProgressNum()
  if not self.GameState then
    return -1
  end
  return self.GameState.BattleProgressNum
end

return M
