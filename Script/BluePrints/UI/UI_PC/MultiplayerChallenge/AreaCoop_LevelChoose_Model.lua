require("UnLua")
local M = {}
local MonsterUtils = require("Utils.MonsterUtils")

function M:Init(ChallengeId)
  self.ChallengeId = ChallengeId
  self.MultiplayerChallengeData = DataMgr.MultiplayerChallenge[ChallengeId]
  if not self.MultiplayerChallengeData then
    ScreenPrint("MultiplayerChallengeData is nil, ChallengeId: " .. ChallengeId)
    return
  end
end

function M:GetTitleName()
  return self.MultiplayerChallengeData.TitleName
end

function M:GetTeleportName()
  return self.MultiplayerChallengeData.TeleportName
end

function M:GetChallengeName()
  return self.MultiplayerChallengeData.ChallengeName
end

function M:GetChallengeDes()
  return self.MultiplayerChallengeData.ChallengeDes
end

function M:GetChallengeIconPath()
  return self.MultiplayerChallengeData.ImgPath
end

function M:GetMonsterPreviewData(DungeonId)
  if not DungeonId then
    return {
      List = {},
      WeaknessIcon = {}
    }
  end
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not (DungeonInfo and DungeonInfo.DungeonMonsters) or 0 == #DungeonInfo.DungeonMonsters then
    return {
      List = {},
      WeaknessIcon = {}
    }
  end
  local DisplayMonsters = CommonUtils.DeepCopy(DungeonInfo.DungeonMonsters)
  table.sort(DisplayMonsters, MonsterUtils.CompareMonsters)
  local WeaknessIcon = {}
  local MonsterBuff = DungeonInfo.MonsterBuff
  if MonsterBuff then
    for _, MonsterId in ipairs(DisplayMonsters) do
      if type(MonsterId) == "number" then
        local AllBuffs = MonsterUtils.GetRealMonsterBuffs(DungeonId, MonsterId)
        for _, BuffId in ipairs(AllBuffs) do
          local BuffInfo = DataMgr.Buff[BuffId]
          if BuffInfo and BuffInfo.WeaknessType then
            local Icon = DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
            if Icon then
              WeaknessIcon[MonsterId] = WeaknessIcon[MonsterId] or {}
              WeaknessIcon[MonsterId][Icon] = true
            end
          end
        end
      end
    end
  end
  return {List = DisplayMonsters, WeaknessIcon = WeaknessIcon}
end

function M:GetRewardPreviewData(DungeonId)
  if not DungeonId then
    return {}
  end
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  if not DungeonInfo then
    return {}
  end
  local RewardViewId = DungeonInfo.DungeonRewardView or DungeonInfo.RewardView
  if not RewardViewId then
    return {}
  end
  local RewardInfo = DataMgr.RewardView[RewardViewId]
  if not RewardInfo then
    return {}
  end
  local Ids = RewardInfo.Id or {}
  local Types = RewardInfo.Type or {}
  local Res = {}
  for i = 1, #Ids do
    local ItemId = Ids[i]
    local Type = Types[i]
    table.insert(Res, {
      Id = ItemId,
      Type = Type,
      Icon = ItemUtils.GetItemIconPath(ItemId, Type),
      Rarity = ItemUtils.GetItemRarity(ItemId, Type)
    })
  end
  return Res
end

function M:Clear()
  self.ChallengeId = nil
end

return M
