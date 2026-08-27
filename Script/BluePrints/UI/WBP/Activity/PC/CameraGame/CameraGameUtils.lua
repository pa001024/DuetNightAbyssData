require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local CameraGameUtils = {}
CameraGameUtils.ReddotNodeName = "Acti_CameraGame"
CameraGameUtils.ReddotType = {
  NONE = 0,
  RED = 1,
  NEW = 2,
  SEEN = 3
}

function CameraGameUtils.GetEventId()
  local FallbackEventId
  local FallbackStartTime = -1
  for EventId, _ in pairs(DataMgr.PhotoEvent) do
    if ActivityUtils.CheckEventIsInActiveTime(EventId) then
      return EventId
    end
    local EventMain = DataMgr.EventMain[EventId]
    local StartTime = EventMain and EventMain.EventStartTime and EventMain.EventStartTime:GetTime() or 0
    if FallbackStartTime < StartTime then
      FallbackStartTime = StartTime
      FallbackEventId = EventId
    end
  end
  return FallbackEventId
end

function CameraGameUtils.GetPhotoProgress()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local EventId = CameraGameUtils.GetEventId()
  local PhotoEventData = DataMgr.PhotoEvent[EventId] or {}
  local TotalCount = #PhotoEventData
  local CurCount = 0
  for _, Data in pairs(PhotoEventData) do
    local QuestChain = Avatar.QuestChains[Data.QuestChain]
    if QuestChain and QuestChain.State == CommonConst.QuestChainState.finish then
      CurCount = CurCount + 1
    end
  end
  return CurCount, TotalCount
end

function CameraGameUtils.RefreshReddot(EventId)
  local FinalEventId = EventId or CameraGameUtils.GetEventId()
  if not FinalEventId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local PhotoEventConfigs = DataMgr.PhotoEvent[FinalEventId]
  if not PhotoEventConfigs then
    return
  end
  local ReddotNodeName = CameraGameUtils.ReddotNodeName
  local Node = ReddotManager.GetTreeNode(ReddotNodeName)
  if not Node then
    ReddotManager.AddNodeEx(ReddotNodeName)
  end
  local ReddotType = CameraGameUtils.ReddotType
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotNodeName)
  if not CacheDetail then
    return
  end
  local SeenSet = {}
  for k, v in pairs(CacheDetail) do
    if type(k) == "number" and v == ReddotType.SEEN then
      SeenSet[k] = true
    end
  end
  if Node.Count > 0 then
    ReddotManager.ClearLeafNodeCount(ReddotNodeName)
  end
  for k in pairs(CacheDetail) do
    if type(k) == "number" then
      CacheDetail[k] = ReddotType.NONE
    end
  end
  local QCS = CommonConst.QuestChainState
  for _, QuestData in pairs(PhotoEventConfigs) do
    local QuestChainId = QuestData.QuestChain
    local IsRewardGot = Avatar.PhotoActRewardGot[QuestChainId]
    local QuestChain = Avatar.QuestChains[QuestChainId]
    local QuestState = QuestChain and QuestChain.State or QCS.lock
    if not IsRewardGot and QuestState ~= QCS.lock then
      if QuestState == QCS.finish then
        CacheDetail[QuestChainId] = ReddotType.RED
        ReddotManager.IncreaseLeafNodeCount(ReddotNodeName)
      elseif QuestState == QCS.doing or QuestState == QCS.unlock then
        if SeenSet[QuestChainId] then
          CacheDetail[QuestChainId] = ReddotType.SEEN
        else
          CacheDetail[QuestChainId] = ReddotType.NEW
          ReddotManager.IncreaseLeafNodeCount(ReddotNodeName)
        end
      end
    else
      CacheDetail[QuestChainId] = ReddotType.NONE
    end
  end
end

return CameraGameUtils
