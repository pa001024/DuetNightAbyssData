require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  TeamController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == TeamCommon.EventId.DsTeamOnDelPlayer then
      self:UpdateIndex()
    elseif EventId == TeamCommon.EventId.TeamOnDelPlayer then
      self:UpdateIndex()
    end
  end)
end

function M:Destruct()
  TeamController:UnRegisterEvent(self)
end

function M:UpdateIndex()
  if not self.TeamMemberUid then
    DebugPrint(WarningTag, LXYTag, "WBP_Team_Tag_C 没有队伍成员的Uid，不知道确切的索引变更")
    return
  end
  local TeamMember = TeamController:GetModel():GetTeamMember(self.TeamMemberUid)
  if not TeamMember then
    return
  end
  self:SetPosText(TeamMember.Index)
end

function M:SetPosText(NewIndex)
  if NewIndex == self.PosIdx then
    DebugPrint(LXYTag, "WBP_Team_Tag_C 队伍成员索引没有变化，不更新索引", NewIndex, self.PosIdx)
    return
  end
  self.PosIdx = NewIndex
  self.Num_Player:SetText(string.format("%sP", self.PosIdx))
end

function M:Init(bCaption, Pos, TeamMemberUid)
  self.IsCaption = bCaption
  self.TeamMemberUid = TeamMemberUid
  self:SetPosText(Pos)
  if self.IsCaption then
    self:PlayAnimation(self.Captain)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:SetDeadState(bDead)
  if bDead then
    self:PlayAnimation(self.Dead)
  else
    self:Init(self.IsCaption, self.PosIdx, self.TeamMemberUid)
  end
end

return M
