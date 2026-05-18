local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")

function M:NotifyOnGetGuildInfo(GuildFullInfo)
  self.Cache.Count = 0
  self.Cache.Detail = {}
  self.Count = 0
  self:TryFireOnCountChange(0, true)
  self:UpdateParentsCount()
  local Avatar = GWorld:GetAvatar()
  local SelfMemberInfo = GuildFullInfo:GetMemberByUid(Avatar.Uid)
  if SelfMemberInfo and GuildPermissionUtils.GetEffectivePermission(GuildFullInfo.ClosedPermission, SelfMemberInfo.Title, "ApproveApplication") then
    for Uid, _ in pairs(GuildFullInfo.JoinRequestUids or {}) do
      self.Cache.Detail[Uid] = 1
      self.Cache.Count = self.Cache.Count + 1
    end
  end
  self:InitNodeCache()
end

function M:OnInitNodeCache(NodeCache)
  GuildController:UnRegisterEvent(self)
  GuildController:RegisterEvent(self)
end

function M:OnDisposeNode()
  GuildController:UnRegisterEvent(self)
end

return M
