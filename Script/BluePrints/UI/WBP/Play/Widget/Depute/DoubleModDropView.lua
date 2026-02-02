require("UnLua")
local ActivityController = require("BluePrints.UI.WBP.Activity.ActivityController")
local M = {}

function M:GetDoubleModDropData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local curEventId = ActivityController:GetDoubleModDropEventID()
  local defaultData = {
    EventId = curEventId,
    DropTimes = 0,
    EliteRushTimes = 0
  }
  self.DoubleModDrop = Avatar.DoubleModDrop
  if not self.DoubleModDrop then
    return defaultData
  end
  local result
  for _, value in pairs(self.DoubleModDrop) do
    local props = value.Props
    if props and props.EventId == curEventId then
      result = {
        EventId = props.EventId or curEventId,
        DropTimes = props.DropTimes or 0,
        EliteRushTimes = props.EliteRushTimes or 0
      }
      break
    end
  end
  result = result or defaultData
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
  local EventId = ActivityController:GetDoubleModDropEventID()
  if Avatar.ActivityTimeOpen and Avatar.ActivityTimeOpen[EventId] then
    return true
  end
  return false
end

function M:IsPrerequisiteSatisfied()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local EventId = ActivityController:GetDoubleModDropEventID()
  local DoubleModEventInfo = DataMgr.EventMain[EventId]
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
    local IsQuestFinished = Avatar:IsQuestFinished(QuestId)
    local IsQuestAssumeFinished = Avatar:IsQuestAssumeFinished(QuestId)
    if not IsQuestFinished and not IsQuestAssumeFinished then
      return false
    end
  end
  return true
end

return M
