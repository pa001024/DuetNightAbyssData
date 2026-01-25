local M = Class()

function M:InitializeLua(TalkTask)
  self.TalkTask = TalkTask
end

function M:IsFinish()
  return self:IsActive()
end

function M:GetTalkActorData()
  if self.CreatTalkActors then
    return self.CreatTalkActors
  end
  local TalkActors = {}
  local RawTalkActors = self.TalkActors:ToTable()
  for _, RawTalkActor in pairs(RawTalkActors) do
    if RawTalkActor.Type == ETalkActorType.Player then
      table.insert(TalkActors, {
        TalkActorType = "Player",
        TalkActorId = 0,
        TalkActorVisible = RawTalkActor.Visibility,
        Source = "FlowAsset"
      })
    else
      table.insert(TalkActors, {
        TalkActorType = "Npc",
        TalkActorId = RawTalkActor.UnitId,
        TalkActorVisible = RawTalkActor.Visibility,
        Source = "FlowAsset"
      })
    end
  end
  self.CreatTalkActors = TalkActors
  return TalkActors
end

return M
