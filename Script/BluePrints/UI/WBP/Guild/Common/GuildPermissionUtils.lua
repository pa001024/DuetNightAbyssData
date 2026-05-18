local GuildPermissionUtils = {}
GuildPermissionUtils.TitlePresident = 5
GuildPermissionUtils.TitleVicePresident = 4
GuildPermissionUtils.TitleManager = 3
GuildPermissionUtils.TitleDeacon = 2
GuildPermissionUtils.TitleMember = 1
GuildPermissionUtils.COLUMN_TITLES = {
  5,
  4,
  3,
  2,
  1
}
GuildPermissionUtils.PERMISSION_ROWS = {
  {
    Key = "ModifyDeclaration",
    LocKey = "UI_EditGuildDeclaration"
  },
  {
    Key = "ApproveApplication",
    LocKey = "UI_GuildReviewApplication"
  },
  {
    Key = "KickMembers",
    LocKey = "UI_GuildRemoveMembers"
  },
  {
    Key = "ModifyNameEmblem",
    LocKey = "UI_EditGuildName"
  }
}

function GuildPermissionUtils.IsEligibleByTable(titleId, permissionKey)
  local cfg = titleId and DataMgr.GuildTitle and DataMgr.GuildTitle[titleId]
  if not cfg or not permissionKey then
    return false
  end
  return 1 == cfg[permissionKey]
end

function GuildPermissionUtils.IsPermissionClosed(closedPermission, titleId, permissionKey)
  if not (closedPermission and titleId) or not permissionKey then
    return false
  end
  if type(closedPermission.HasElement) == "function" then
    return closedPermission:HasElement(titleId, permissionKey)
  end
  local set = closedPermission[titleId]
  if type(set) == "table" then
    return true == set[permissionKey] or 1 == set[permissionKey]
  end
  return false
end

function GuildPermissionUtils.GetEffectivePermission(closedPermission, titleId, permissionKey)
  if not GuildPermissionUtils.IsEligibleByTable(titleId, permissionKey) then
    return false
  end
  return not GuildPermissionUtils.IsPermissionClosed(closedPermission, titleId, permissionKey)
end

function GuildPermissionUtils.CanEditColumn(viewerTitle, targetTitle)
  viewerTitle = tonumber(viewerTitle) or 0
  targetTitle = tonumber(targetTitle) or 0
  if viewerTitle == targetTitle then
    return false
  end
  if viewerTitle == GuildPermissionUtils.TitlePresident then
    return targetTitle < GuildPermissionUtils.TitlePresident
  end
  if viewerTitle == GuildPermissionUtils.TitleVicePresident then
    return targetTitle < GuildPermissionUtils.TitleVicePresident
  end
  return false
end

function GuildPermissionUtils.CloneClosedDraft(closedPermission)
  local out = {}
  for t = GuildPermissionUtils.TitleMember, GuildPermissionUtils.TitleVicePresident do
    out[t] = {}
    for _, row in ipairs(GuildPermissionUtils.PERMISSION_ROWS) do
      local key = row.Key
      if GuildPermissionUtils.IsEligibleByTable(t, key) and GuildPermissionUtils.IsPermissionClosed(closedPermission, t, key) then
        out[t][key] = true
      end
    end
  end
  return out
end

function GuildPermissionUtils.DraftEffective(draft, titleId, permissionKey)
  if not GuildPermissionUtils.IsEligibleByTable(titleId, permissionKey) then
    return false
  end
  local row = draft[titleId]
  return not row or not row[permissionKey]
end

return GuildPermissionUtils
