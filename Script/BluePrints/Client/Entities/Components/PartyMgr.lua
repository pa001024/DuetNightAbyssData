local Component = {}
local EntertainmentController = require("BluePrints.UI.WBP.Entertainment.EntertainmentController")

function Component:_OnLoginSuccess()
  EntertainmentController:Init()
end

function Component:LeaveWorld()
  EntertainmentController:Destory()
end

function Component:GetPartyTopic(CharId, Level)
  if not CharId then
    return
  end
  if not Level then
    return
  end
  local Party = self.PartyNpcs[CharId]
  if not Party then
    return
  end
  local PartyTopic = Party.PartyTopics[Level]
  if not PartyTopic then
    return
  end
  return PartyTopic
end

function Component:GetPartyTopicLockState(CharId, Level)
  local PartyTopic = self:GetPartyTopic(CharId, Level)
  if PartyTopic then
    return PartyTopic
  end
  DebugPrint(string.format("GetPartyTopicLockState CharId %d Level %d not found", CharId or -1, Level or -1))
  local PartyTopicClass = require("BluePrints.Client.CustomTypes.PartyTopic").PartyTopic
  local PartyNpcData = DataMgr.PartyNpc[CharId]
  if not PartyNpcData then
    return
  end
  local PartyTopicData = PartyNpcData.PartyTopicList[Level]
  if not PartyTopicData then
    return
  end
  PartyTopic = PartyTopicClass(PartyTopicData)
  PartyTopic.State = 0
  return PartyTopic
end

function Component:TriggerPartyTopicUnLock(CharId, Level, HandleCallback)
  CharId = tonumber(CharId)
  Level = tonumber(Level)
  self.logger.debug("TriggerPartyTopicUnLock Start", CharId, Level)
  
  local function Callback(Ret)
    self.logger.debug("TriggerPartyTopicUnLock callback", Ret, CharId, Level)
    if HandleCallback then
      HandleCallback(Ret)
    end
    EntertainmentController:GetModel():RefreshRedState()
  end
  
  self:CallServer("TriggerPartyTopicUnLock", Callback, CharId, Level)
end

function Component:TriggerPartyTopicComplete(PartyId, Level, HandleCallback)
  PartyId = tonumber(PartyId)
  Level = tonumber(Level)
  self.logger.debug("TriggerPartyTopicComplete Start", PartyId, Level)
  
  local function Callback(Ret)
    self.logger.debug("TriggerPartyTopicComplete callback", Ret, PartyId, Level)
    if HandleCallback then
      HandleCallback(Ret)
    end
    EntertainmentController:GetModel():RefreshRedState()
  end
  
  self:CallServer("TriggerPartyTopicComplete", Callback, PartyId, Level)
end

function Component:StartSojourns(PartyId, Level, HandleCallback)
  local function Callback(Ret)
    if HandleCallback then
      HandleCallback(ErrorCode:Check(Ret), Ret)
    end
  end
  
  self:CallServer("StartSojourns", Callback, PartyId, Level)
end

function Component:ExitSojourns(PartyId, Level, HandleCallback)
  local function Callback(Ret)
    if HandleCallback then
      HandleCallback(ErrorCode:Check(Ret), Ret)
    end
  end
  
  self:CallServer("ExitSojourns", Callback, PartyId, Level)
end

return Component
