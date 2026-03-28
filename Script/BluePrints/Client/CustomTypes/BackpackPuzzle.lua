local Class = _G.TypeClass
local BaseTypes = require("BluePrints.Client.CustomTypes.BaseTypes")
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local BackpackPuzzle = Class("BackpackPuzzle", CustomTypes.CustomAttr)
BackpackPuzzle.__Props__ = {
  EventId = prop.prop("Int", "client save"),
  BackpackLevelId = prop.prop("Int", "client save"),
  FinishScore = prop.prop("Int", "client save", 0),
  ScoreRewardsGot = prop.prop("Int2IntDict", "client save")
}

function BackpackPuzzle:Init(BackpackLevelId)
  self.BackpackLevelId = BackpackLevelId
end

function BackpackPuzzle:SetScoreRewardGot(RewardKeyId)
  self.ScoreRewardsGot[RewardKeyId] = 2
end

function BackpackPuzzle:SetScoreCompleted(RewardKeyId)
  self.ScoreRewardsGot[RewardKeyId] = 1
end

function BackpackPuzzle:IsScoreRewardGot(RewardKeyId)
  return 2 == self.ScoreRewardsGot[RewardKeyId]
end

function BackpackPuzzle:IsScoreCompleted(RewardKeyId)
  return 1 == self.ScoreRewardsGot[RewardKeyId]
end

FormatProperties(BackpackPuzzle)
local BackpackPuzzleDict = Class("BackpackPuzzleDict", CustomTypes.CustomDict)
BackpackPuzzleDict.KeyType = BaseTypes.Int
BackpackPuzzleDict.ValueType = BackpackPuzzle

function BackpackPuzzleDict:GetNewBackpackPuzzle(BackpackLevelId)
  if not self[BackpackLevelId] then
    self[BackpackLevelId] = self:NewBackpackPuzzle(BackpackLevelId)
  end
  return self[BackpackLevelId]
end

function BackpackPuzzleDict:GetBackpackPuzzle(BackpackLevelId)
  return self[BackpackLevelId]
end

function BackpackPuzzleDict:NewBackpackPuzzle(BackpackLevelId)
  return BackpackPuzzle(BackpackLevelId)
end

return {BackpackPuzzle = BackpackPuzzle, BackpackPuzzleDict = BackpackPuzzleDict}
