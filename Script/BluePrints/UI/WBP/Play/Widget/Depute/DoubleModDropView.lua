require("UnLua")
local M = {}

function M:GetDoubleModDropData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local defaultData = {
    EventId = CommonConst.DoubleModDropEventID,
    DropTimes = 0,
    EliteRushTimes = 0
  }
  self.DoubleModDrop = Avatar.DoubleModDrop
  if not self.DoubleModDrop then
    return defaultData
  end
  local result = {}
  local keyMap = {
    EventId = "EventId",
    DropTimes = "DropTimes",
    EliteRushTimes = "EliteRushTimes"
  }
  for _, value in pairs(self.DoubleModDrop) do
    if value.Props then
      for name, id in pairs(value.Props) do
        if keyMap[name] then
          result[keyMap[name]] = id
        end
      end
    end
  end
  for k, v in pairs(defaultData) do
    if nil == result[k] then
      result[k] = v
    end
  end
  return result
end

function M:IsDoubleMod()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if not self:IsPrerequisiteSatisfied() then
    return false
  end
  if Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[CommonConst.DoubleModDropEventID] then
    return true
  end
  return false
end

function M:IsPrerequisiteSatisfied()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local DoubleModEventInfo = DataMgr.EventMain[CommonConst.DoubleModDropEventID]
  if not DoubleModEventInfo then
    return false
  end
  local PrerequisiteQuestId = {}
  if DoubleModEventInfo.PretextTasks1 then
    table.insert(PrerequisiteQuestId, DoubleModEventInfo.PretextTasks1)
  end
  for _, QuestId in pairs(DoubleModEventInfo.PretextTasks2 or {}) do
    table.insert(PrerequisiteQuestId, QuestId)
  end
  for _, QuestId in pairs(PrerequisiteQuestId) do
    local QuestChain = Avatar.QuestChains[QuestId]
    if not QuestChain then
      ScreenPrint("魔之楔 配置了一个不存在的任务链Id！请策划检查！Id:" .. QuestId)
      return false
    end
    if not QuestChain:IsFinish() then
      return false
    end
  end
  return true
end

return M
