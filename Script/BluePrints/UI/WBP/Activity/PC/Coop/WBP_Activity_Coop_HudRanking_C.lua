require("UnLua")
local M = Class()

function M:Initialize()
  self.TotalHp = nil
  self.Damage = nil
  self.Uid = nil
  self.RankingNum = nil
  self.Content = nil
  self.bMyself = nil
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Owner = Content.Owner
  self:UpdateDisplay()
end

function M:UpdateAnimation(bMyself)
  if bMyself then
    self:PlayAnimation(self.Active)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:UpdateDisplay()
  self.Damage = self.Content.Damage
  self.Uid = self.Content.Uid
  self.RankingNum = self.Content.RankingNum
  self.Content.UI = self
  self.bMyself = self.Content.bMyself
  if not self.TotalHp then
    self.TotalHp = GWorld.GameInstance[CommonConst.DungeonSyncMsg.AsyncCombatRoomStateUpdate].TotalHp or GWorld.GameInstance[CommonConst.DungeonSyncMsg.AsyncCombatRoomStateUpdate].RoomTotalHp
    if not self.TotalHp then
      self.TotalHp = 1000000
    end
  end
  local Contribution = self.Damage / self.TotalHp
  if Contribution <= 0 then
    Contribution = 0
  end
  if Contribution >= 1 then
    Contribution = 1
  end
  local ContributionPercent = Contribution * 100
  self.TextNum:SetText(CommonUtils.FormatNumInFrench(string.format("%.1f", ContributionPercent) .. "%"))
  self.TextRankingNum:SetText(tostring(self.RankingNum))
  self.Filled:SetPercent(Contribution)
  self.TextTeamName:SetText(self.Content.Name or "mamba")
  self:UpdateAnimation(self.Content.bMyself)
  if self.bMyself and self.Owner then
    self:UpdateRankingChangeAnimation(self.Owner.bShouldRefreshMyself)
  end
end

function M:UpdateRankingChangeAnimation(bChange)
  if not bChange then
    return
  end
  if self.Change then
    self:PlayAnimation(self.Change)
  end
  self.Owner.bShouldRefreshMyself = false
end

return M
