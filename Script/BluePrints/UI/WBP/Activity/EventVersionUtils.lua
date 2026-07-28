local TimeUtils = require("Utils.TimeUtils")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local EventVersionUtils = {}

function EventVersionUtils.ShowVersionHit(showVersions, currentVer)
  if not showVersions or nil == currentVer then
    return false
  end
  for i = 1, #showVersions do
    if showVersions[i] == currentVer then
      return true
    end
  end
  return false
end

function EventVersionUtils.GetVersionEventIds(ver)
  local out = {}
  local seen = {}
  if nil == ver then
    return out
  end
  local coll = DataMgr.LimitEventRewardCollection
  if not coll then
    return out
  end
  for _, row in pairs(coll) do
    if row and EventVersionUtils.ShowVersionHit(row.ShowVersion, ver) then
      local eventId = row.EventId
      if eventId and not seen[eventId] and DataMgr.EventMain[eventId] then
        seen[eventId] = true
        table.insert(out, eventId)
      end
    end
  end
  table.sort(out)
  return out
end

function EventVersionUtils.GetVersionPreviewEventBuckets(ver, now)
  local incoming, ing, lock = {}, {}, {}
  now = now or TimeUtils.NowTime()
  
  local function GetEventStartSec(cfg)
    if not cfg then
      return 0
    end
    return cfg.EventStartTime and cfg.EventStartTime:GetTime() or 0
  end
  
  local function GetEventEndSec(cfg)
    if not cfg then
      return nil
    end
    local endSec = cfg.EventEndTime and cfg.EventEndTime:GetTime() or nil
    if nil == endSec then
      endSec = cfg.PermanenEventTime and cfg.PermanenEventTime:GetTime() or nil
    end
    return endSec
  end
  
  if nil == ver then
    return incoming, ing, lock
  end
  local coll = DataMgr.LimitEventRewardCollection
  if not coll then
    return incoming, ing, lock
  end
  for _, row in pairs(coll) do
    if EventVersionUtils.ShowVersionHit(row.ShowVersion, ver) then
      local eventId = row.EventId
      if eventId then
        local cfg = DataMgr.EventMain[eventId]
        if cfg then
          local startSec = GetEventStartSec(cfg)
          local endSec = GetEventEndSec(cfg)
          if now < startSec then
            table.insert(incoming, eventId)
          elseif nil ~= endSec and now > endSec then
            table.insert(lock, eventId)
          elseif ActivityUtils.CheckEventIsOpen(eventId) then
            table.insert(ing, eventId)
          end
        end
      end
    end
  end
  table.sort(incoming, function(a, b)
    local sa = GetEventStartSec(DataMgr.EventMain[a])
    local sb = GetEventStartSec(DataMgr.EventMain[b])
    if sa ~= sb then
      return sa < sb
    end
    return a < b
  end)
  table.sort(ing, function(a, b)
    local ea = GetEventEndSec(DataMgr.EventMain[a]) or math.huge
    local eb = GetEventEndSec(DataMgr.EventMain[b]) or math.huge
    if ea ~= eb then
      return ea < eb
    end
    return a < b
  end)
  table.sort(lock)
  return incoming, ing, lock
end

function EventVersionUtils.EventHasLeafNewReddot(eventId)
  if not eventId then
    return false
  end
  local cfg = DataMgr.EventMain[eventId]
  local nodeName = cfg and cfg.ReddotNode
  if type(nodeName) ~= "string" or "" == nodeName then
    return false
  end
  local detail = ReddotManager.GetLeafNodeCacheDetail(nodeName)
  return detail and detail.New and detail.New >= 1
end

function EventVersionUtils.VersionHasAnyEventNewReddot(ver)
  local _, ing = EventVersionUtils.GetVersionPreviewEventBuckets(ver)
  for _, eventId in ipairs(ing) do
    if EventVersionUtils.EventHasLeafNewReddot(eventId) then
      return true
    end
  end
  return false
end

function EventVersionUtils.GetVersionActivityReddotNodeNames(ver)
  local names = {}
  local seen = {}
  for _, eventId in ipairs(EventVersionUtils.GetVersionEventIds(ver)) do
    local cfg = DataMgr.EventMain[eventId]
    local nodeName = cfg and cfg.ReddotNode
    if type(nodeName) == "string" and "" ~= nodeName and not seen[nodeName] then
      seen[nodeName] = true
      table.insert(names, nodeName)
    end
  end
  return names
end

return EventVersionUtils
