require("UnLua")
local ComRankingUtils = {}
ComRankingUtils.ItemType = {Squad = 0, Score = 1}
ComRankingUtils.RankIconPath = {
  [1] = "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_1.T_Activity_GuildWar_PatternRanking_1'",
  [2] = "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_2.T_Activity_GuildWar_PatternRanking_2'",
  [3] = "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/GuildWar/T_Activity_GuildWar_PatternRanking_3.T_Activity_GuildWar_PatternRanking_3'"
}
ComRankingUtils.RankPatternPath = {
  [1] = "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_1.T_Activity_GuideWar_PatternRanking_L_1'",
  [2] = "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_2.T_Activity_GuideWar_PatternRanking_L_2'",
  [3] = "Texture2D'/Game/UI/Texture/Static/Image/Activity/GuildWar/T_Activity_GuideWar_PatternRanking_L_3.T_Activity_GuideWar_PatternRanking_L_3'"
}
ComRankingUtils.BottomKeyState = {
  Normal = 1,
  NoItems = 2,
  HeaderQaTipOpen = 3,
  EmptyState = 4
}

function ComRankingUtils.IsEmptyTable(tbl)
  if type(tbl) ~= "table" then
    return true
  end
  for _ in pairs(tbl) do
    return false
  end
  return true
end

function ComRankingUtils.GetSquadInfo(SquadSnapShot)
  if not SquadSnapShot then
    return
  end
  local Squad = SerializeUtils:UnSerialize(SquadSnapShot)
  if not Squad or ComRankingUtils.IsEmptyTable(Squad) then
    return
  end
  local RoleInfo, PetInfo = {}, {}
  if Squad.AvatarInfo then
    local CharacterInfo = Squad.AvatarInfo.CharacterInfo
    if CharacterInfo and CharacterInfo.RoleInfo then
      RoleInfo[1] = {
        id = CharacterInfo.RoleInfo.RoleId,
        level = CharacterInfo.RoleInfo.Level
      }
    end
    local PhantomIndex = 2
    local PhantomInfo1 = Squad.AvatarInfo.PhantomInfo1
    if PhantomInfo1 and PhantomInfo1.RoleInfo then
      RoleInfo[PhantomIndex] = {
        id = PhantomInfo1.RoleInfo.RoleId,
        level = PhantomInfo1.RoleInfo.Level
      }
      PhantomIndex = PhantomIndex + 1
    end
    local PhantomInfo2 = Squad.AvatarInfo.PhantomInfo2
    if PhantomInfo2 and PhantomInfo2.RoleInfo then
      RoleInfo[PhantomIndex] = {
        id = PhantomInfo2.RoleInfo.RoleId,
        level = PhantomInfo2.RoleInfo.Level
      }
    end
  end
  if Squad.CommonCombatInfo then
    PetInfo = {
      id = Squad.CommonCombatInfo.pet_id,
      level = Squad.CommonCombatInfo.pet_level
    }
  end
  return RoleInfo, PetInfo
end

return ComRankingUtils
