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
ComRankingUtils.ColumnWidgetPathByType = {
  RankingNum = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/Info/WBP_Com_Ranking_RankingNum.WBP_Com_Ranking_RankingNum'",
  GradeIcon = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/Info/WBP_Com_Ranking_GradeIcon.WBP_Com_Ranking_GradeIcon'",
  Name = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/Info/WBP_Com_Ranking_Name.WBP_Com_Ranking_Name'",
  TextInfo = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/Info/WBP_Com_Ranking_TextInfo.WBP_Com_Ranking_TextInfo'",
  Team = "WidgetBlueprint'/Game/UI/WBP/Common/Ranking/Widget/Info/WBP_Com_Ranking_Team.WBP_Com_Ranking_Team'"
}
ComRankingUtils.HeaderNameByType = {
  RankingNum = "RaidDungeon_Rank",
  GradeIcon = "RaidDungeon_Rank_Tier",
  Name = "RaidDungeon_Rank_Name",
  Team = "RaidDungeon_Rank_CharList"
}

function ComRankingUtils.IsSameUid(A, B)
  if nil == A or nil == B then
    return false
  end
  if A == B then
    return true
  end
  local NumA, NumB = tonumber(A), tonumber(B)
  if NumA and NumB then
    return NumA == NumB
  end
  return tostring(A) == tostring(B)
end

function ComRankingUtils.LookupByUid(Dict, Uid)
  if nil == Dict or nil == Uid then
    return nil
  end
  
  local function TryIndex(Key)
    local Ok, Value = pcall(function()
      return Dict[Key]
    end)
    if Ok then
      return Value
    end
    return nil
  end
  
  local Value = TryIndex(Uid)
  if nil ~= Value then
    return Value
  end
  local Num = tonumber(Uid)
  if nil ~= Num then
    Value = TryIndex(Num)
    if nil ~= Value then
      return Value
    end
  end
  return TryIndex(tostring(Uid))
end

function ComRankingUtils.IsEmptyTable(tbl)
  if type(tbl) ~= "table" then
    return true
  end
  for _ in pairs(tbl) do
    return false
  end
  return true
end

function ComRankingUtils.IsValidConfigId(Id)
  return type(Id) == "number" and Id > 0
end

function ComRankingUtils.GetSquadInfo(RankInfo)
  local CharSlots = {}
  local PhantomSlots = {}
  if type(RankInfo) ~= "table" then
    return CharSlots, PhantomSlots
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.RoleId) then
    CharSlots[1] = {
      Id = RankInfo.RoleId,
      Level = RankInfo.RoleLevel,
      Type = "Char"
    }
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.MeleeWeaponId) then
    CharSlots[2] = {
      Id = RankInfo.MeleeWeaponId,
      Level = RankInfo.MeleeWeaponLevel,
      Type = "Weapon"
    }
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.RangedWeaponId) then
    CharSlots[3] = {
      Id = RankInfo.RangedWeaponId,
      Level = RankInfo.RangedWeaponLevel,
      Type = "Weapon"
    }
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.PetId) then
    CharSlots[4] = {
      Id = RankInfo.PetId,
      Level = RankInfo.PetLevel,
      Type = "Pet"
    }
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.Phantom1RoleId) then
    PhantomSlots[1] = {
      Num = "01",
      RoleId = RankInfo.Phantom1RoleId,
      WeaponId = RankInfo.Phantom1WeaponId
    }
  end
  if ComRankingUtils.IsValidConfigId(RankInfo.Phantom2RoleId) then
    PhantomSlots[2] = {
      Num = "02",
      RoleId = RankInfo.Phantom2RoleId,
      WeaponId = RankInfo.Phantom2WeaponId
    }
  end
  return CharSlots, PhantomSlots
end

return ComRankingUtils
