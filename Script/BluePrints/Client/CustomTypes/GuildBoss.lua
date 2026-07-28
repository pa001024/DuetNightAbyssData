local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local GuildBossRunInfo = Class("GuildBossRunInfo", CustomTypes.CustomAttr)
GuildBossRunInfo.__Props__ = {
  RunId = prop.prop("Str", "save", ""),
  Uid = prop.prop("Int", "client save", 0),
  WeekKey = prop.prop("Int", "save", 0),
  BossId = prop.prop("Int", "client save", 0),
  TargetGuildId = prop.prop("Int", "save", 0),
  IsAssist = prop.prop("Bool", "save", false),
  CreateTime = prop.prop("Int", "save", 0),
  Settled = prop.prop("Bool", "save", false)
}
FormatProperties(GuildBossRunInfo)
local GuildBossRunInfoDict = Class("GuildBossRunInfoDict", CustomTypes.CustomDict)
GuildBossRunInfoDict.KeyType = BaseTypes.Str
GuildBossRunInfoDict.ValueType = GuildBossRunInfo

function GuildBossRunInfoDict:NewRunInfo(RunId)
  local Info = GuildBossRunInfo()
  Info.RunId = RunId or ""
  return Info
end

local AvatarGuildBossData = Class("AvatarGuildBossData", CustomTypes.CustomAttr)
AvatarGuildBossData.__Props__ = {
  WeekKey = prop.prop("Int", "client save", 0),
  Point = prop.prop("Int", "client save", 0),
  PointRewardConfigId = prop.prop("Int", "client save", 0),
  PointRewardGot = prop.prop("Int2IntDict", "client save", {}),
  StageRewardGot = prop.prop("Str2IntDict", "client save", {}),
  ChallengeUsed = prop.prop("Int", "client save", 0),
  AssistUsed = prop.prop("Int", "client save", 0),
  SettleRunIds = prop.prop("Str2IntDict", "save", {}),
  BestScoreByBoss = prop.prop("Int2IntDict", "client save", {}),
  WeekBestScore = prop.prop("Int", "client save", 0),
  ChallengeCountByBoss = prop.prop("Int2IntDict", "client save", {}),
  RunInfos = prop.prop("GuildBossRunInfoDict", "save", {})
}
FormatProperties(AvatarGuildBossData)
local GuildBossRankItem = Class("GuildBossRankItem", CustomTypes.CustomAttr)
GuildBossRankItem.__Props__ = {
  Uid = prop.prop("Int", "client save", 0),
  BossId = prop.prop("Int", "client save", 0),
  Score = prop.prop("Int", "client save", 0),
  Damage = prop.prop("Int", "client save", 0),
  TrialContribution = prop.prop("Float", "client save", 0),
  UpdateTime = prop.prop("Int", "client save", 0),
  Nickname = prop.prop("Str", "client save", ""),
  Squad = prop.prop("Str", "client save", "")
}
FormatProperties(GuildBossRankItem)
local GuildBossRankItemList = Class("GuildBossRankItemList", CustomTypes.CustomList)
GuildBossRankItemList.ValueType = GuildBossRankItem
local GuildBossAssistRecord = Class("GuildBossAssistRecord", CustomTypes.CustomAttr)
GuildBossAssistRecord.__Props__ = {
  Uid = prop.prop("Int", "client save", 0),
  AssistTimes = prop.prop("Int", "client save", 0),
  Score = prop.prop("Int", "client save", 0),
  Damage = prop.prop("Int", "client save", 0),
  TrialContribution = prop.prop("Float", "client save", 0),
  UpdateTime = prop.prop("Int", "client save", 0),
  Nickname = prop.prop("Str", "client save", "")
}
FormatProperties(GuildBossAssistRecord)
local GuildBossAssistRecordList = Class("GuildBossAssistRecordList", CustomTypes.CustomList)
GuildBossAssistRecordList.ValueType = GuildBossAssistRecord
local GuildBossData = Class("GuildBossData", CustomTypes.CustomAttr)
GuildBossData.__Props__ = {
  WeekKey = prop.prop("Int", "client save", 0),
  SeasonKey = prop.prop("Int", "client save", 0),
  BossOrder = prop.prop("IntList", "client save", {}),
  CurrentBossIndex = prop.prop("Int", "client save", 0),
  CurrentBossId = prop.prop("Int", "client save", 0),
  TrialList = prop.prop("IntList", "client save", {}),
  HpProgress = prop.prop("Int2IntDict", "client save", {}),
  TrialProgress = prop.prop("Int2FloatDict", "client save", {}),
  StageUnlocked = prop.prop("Str2IntDict", "client save", {}),
  StageFundGot = prop.prop("Str2IntDict", "client save", {}),
  SettleRunIds = prop.prop("Str2IntDict", "save", {}),
  SingleDamageRank = prop.prop("GuildBossRankItemList", "client save", {}),
  TotalContributionRank = prop.prop("GuildBossRankItemList", "client save", {}),
  AssistRecords = prop.prop("GuildBossAssistRecordList", "client save", {}),
  ForceOpen = prop.prop("Bool", "client save", false)
}
FormatProperties(GuildBossData)
return {
  GuildBossRunInfo = GuildBossRunInfo,
  GuildBossRunInfoDict = GuildBossRunInfoDict,
  AvatarGuildBossData = AvatarGuildBossData,
  GuildBossRankItem = GuildBossRankItem,
  GuildBossRankItemList = GuildBossRankItemList,
  GuildBossAssistRecord = GuildBossAssistRecord,
  GuildBossAssistRecordList = GuildBossAssistRecordList,
  GuildBossData = GuildBossData
}
