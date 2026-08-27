local EMCache = require("EMCache.EMCache")
local Component = {}
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local CoopModel = require("BluePrints.UI.WBP.Activity.PC.Coop.Model.CoopModel")

function Component:AsyncCombatCreateRoom(InCallback, RoomId, Rate, Permission)
  local function Callback(ErrorCode, RoomInfo)
    self.logger.info("AsyncCombatCreateRoom ", ErrorCode, RoomInfo)
    
    if InCallback then
      InCallback(ErrorCode, RoomInfo)
    end
  end
  
  self:CallServer("AsyncCombatCreateRoom", Callback, RoomId, Rate, Permission)
end

function Component:AsyncCombatJoinRoom(InCallback, RoomUniId, bIsMaster, bInvite)
  local function Callback(ErrorCode)
    self.logger.info("AsyncCombatJoinRoom ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode)
    end
  end
  
  self:CallServer("AsyncCombatJoinRoom", Callback, RoomUniId, bIsMaster, bInvite)
end

function Component:AsyncCombatGetRoomList(InCallback, Permission, LastRoomUid)
  local function Callback(ErrorCode, RoomList)
    self.logger.info("AsyncCombatGetRoomList ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode, RoomList)
    end
  end
  
  self:CallServer("AsyncCombatGetRoomList", Callback, Permission, LastRoomUid)
end

function Component:AsyncCombatGetOwnedRoom(InCallback)
  local function Callback(ErrorCode, RoomList)
    self.logger.info("AsyncCombatGetOwnedRoom ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode, RoomList)
    end
  end
  
  self:CallServer("AsyncCombatGetOwnedRoom", Callback)
end

function Component:AsyncCombatGetMemberRoomInfo(InCallback, RoomUniId)
  local function Callback(ErrorCode, RoomData)
    self.logger.info("AsyncCombatGetMemberRoomInfo ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode, RoomData)
    end
  end
  
  self:CallServer("AsyncCombatGetMemberRoomInfo", Callback, RoomUniId)
end

function Component:AsyncCombatClaimReward(InCallback, RoomUniIds)
  local function Callback(ErrorCode, RewardResources)
    self.logger.info("AsyncCombatClaimReward ", ErrorCode)
    
    if InCallback then
      InCallback(ErrorCode, RewardResources)
    end
  end
  
  self:CallServer("AsyncCombatClaimReward", Callback, RoomUniIds)
end

function Component:AsyncCombatGetRoomDamageList(InCallBack, RoomUniId)
  self.logger.info("AsyncCombatGetRoomDamageList")
  
  local function Cb(ErrCode, DamageList)
    DebugPrint("AsyncCombatGetRoomDamageList", ErrorCode:Name(ErrCode))
    if InCallBack then
      InCallBack(ErrCode, DamageList)
    end
  end
  
  self:CallServer("AsyncCombatGetRoomDamageList", Cb, RoomUniId)
end

function Component:RegisterRoomDamageListListener(ListenerKey, Listener)
  if not ListenerKey or not Listener then
    return
  end
  self.RoomDamageListListeners = self.RoomDamageListListeners or {}
  self.RoomDamageListListeners[ListenerKey] = Listener
end

function Component:UnregisterRoomDamageListListener(ListenerKey)
  if not ListenerKey or not self.RoomDamageListListeners then
    return
  end
  self.RoomDamageListListeners[ListenerKey] = nil
  if nil == next(self.RoomDamageListListeners) then
    self.RoomDamageListListeners = nil
  end
end

function Component:OnGetRoomDamageList(RetErrorCode, DamageList)
  self.logger.debug("OnGetRoomDamageList", RetErrorCode, DamageList)
  if self.RoomDamageListListeners then
    local ListenerList = {}
    for _, Listener in pairs(self.RoomDamageListListeners) do
      table.insert(ListenerList, Listener)
    end
    for _, Listener in ipairs(ListenerList) do
      Listener(RetErrorCode, DamageList)
    end
  end
end

function Component:OnAsyncCombatRoomEnd(RoomUniId, IsPass, RewardState)
  self.logger.debug("OnAsyncCombatRoomEnd", RoomUniId, IsPass, RewardState)
  if not self.AsyncCombatLoginSuccess then
    return
  end
  if true == IsPass and 1 == RewardState then
    ReddotManager.IncreaseLeafNodeCount("AsyncCombatReward", 1, {CacheKey = "Red"})
  end
  EventManager:FireEvent("AsyncCombatRoomEnd", RoomUniId, IsPass, RewardState)
end

function Component:OnAsyncCombatRoomDelete(RoomUniId, bSendRewardMail)
  self.logger.debug("OnAsyncCombatRoomDelete", RoomUniId, bSendRewardMail)
  if not self.AsyncCombatLoginSuccess then
    return
  end
  if true == bSendRewardMail then
    ReddotManager.DecreaseLeafNodeCount("AsyncCombatReward", 1, {CacheKey = "Red"})
  end
end

function Component:OnAsyncCombatExtraRoomNotify(RoomUid, State)
  self.logger.debug("OnAsyncCombatExtraRoomNotify", RoomUid, State)
  if not self.AsyncCombatLoginSuccess then
    return
  end
  if State == CommonConst.AsyncCombatExtraRoomState.Open then
    ReddotManager.IncreaseLeafNodeCount("AsyncCombatStoppageNew", 1, {
      CacheKey = "New",
      Type = "StoppageRoom",
      RoomIds = {RoomUid}
    })
  elseif State == CommonConst.AsyncCombatExtraRoomState.Close then
    ReddotManager.DecreaseLeafNodeCount("AsyncCombatStoppageNew", 1, {
      CacheKey = "New",
      Type = "StoppageRoom",
      RoomIds = {RoomUid}
    })
  end
end

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.RefreshRedDot)
end

function Component:LeaveWorld()
  self.AsyncCombatLoginSuccess = false
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:RefreshRedDot()
  self.AsyncCombatLoginSuccess = true
  self:RefreshAsyncCombatNew()
  self:RefreshAsyncCombatRewardRedDot()
end

function Component:RefreshAsyncCombatNew()
  local NodeName = "AsyncCombatNew"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  ReddotManager.ClearLeafNodeCount(NodeName, true)
  local ActivityID = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  if ActivityUtils.CheckEventIsOpen(ActivityID) then
    local FreeCreateTimes, FreeGiveNum = CoopModel:AsyncCombatGetFreeCreateTimes()
    if FreeCreateTimes < FreeGiveNum then
      if FreeCreateTimes > 0 then
        return
      end
      local AsyncCombatCreateBtnCickTime = EMCache:Get("AsyncCombatFreeBtnTime", true)
      if not AsyncCombatCreateBtnCickTime then
        ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {CacheKey = "New", Type = "FreeCreate"})
      else
        local FreeGiveWeekDay = DataMgr.AsyncCombatEventConstant.Async_FreeGiveWeekDay.ConstantValue
        local NextFreshTime = TimeUtils.NextWeekDayRefreshTime(FreeGiveWeekDay)
        local LastFreshTime = NextFreshTime - 604800
        if AsyncCombatCreateBtnCickTime < LastFreshTime then
          ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {CacheKey = "New", Type = "FreeCreate"})
        end
      end
    else
      local AsyncCombatData = self.AsyncCombats and self.AsyncCombats[ActivityID]
      if not AsyncCombatData then
        DebugPrint(ErrorTag, "RefreshAsyncCombatNew: AsyncCombatData is nil", ActivityID)
        return
      end
      local NewTimes = AsyncCombatData.CreateRoomTimes or 0
      if NewTimes > 0 then
        return
      end
      local AsyncCombatCreateBtnCickTime = EMCache:Get("AsyncCombatBtnTime", true)
      if not AsyncCombatCreateBtnCickTime then
        ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {
          CacheKey = "New",
          Type = "NormalCreate"
        })
      else
        local TimeCheck = TimeUtils.IsTimestampFromPreviousWeek(AsyncCombatCreateBtnCickTime or 0)
        if true == TimeCheck then
          ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {
            CacheKey = "New",
            Type = "NormalCreate"
          })
        end
      end
    end
  end
end

function Component:RefreshAsyncCombatRewardRedDot()
  local NodeName = "AsyncCombatReward"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  ReddotManager.ClearLeafNodeCount(NodeName, true)
  local StoppageNodeName = "AsyncCombatStoppageNew"
  if not ReddotManager.GetTreeNode(StoppageNodeName) then
    ReddotManager.AddNode(StoppageNodeName)
  end
  local ActivityID = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  if ActivityUtils.CheckEventIsOpen(ActivityID) then
    self:AsyncCombatGetOwnedRoom(function(Err, RoomList)
      if Err ~= ErrorCode.RET_SUCCESS then
        return
      end
      local RewardCount = 0
      local StoppageRoom = {}
      local RoomDuration = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomDuration.ConstantValue * 60
      local StoppageRoomDuration = DataMgr.AsyncCombatEventConstant.AsyncCombat_StoppageTimeRoomDuration.ConstantValue * 60
      local StoppageRoomCache = EMCache:Get("AsynccombatStoppageRoomClickTime" .. ActivityID, true)
      local CurrentTime = TimeUtils.NowTime()
      for _, roomData in ipairs(RoomList) do
        if 1 == roomData.RewardState then
          RewardCount = RewardCount + 1
        end
        if roomData.IsPass and roomData.IsPass == true then
          if roomData.IsMaster == false and 0 == roomData.RewardState and roomData.CloseTime and CurrentTime < roomData.CloseTime + StoppageRoomDuration then
            if not StoppageRoomCache then
              table.insert(StoppageRoom, roomData.RoomUniqueId)
            elseif StoppageRoomCache and not StoppageRoomCache[roomData.RoomUniqueId] then
              table.insert(StoppageRoom, roomData.RoomUniqueId)
            end
          end
        else
          local CreateTime = roomData.CreateTime or 0
          if roomData.IsMaster == false and CurrentTime >= CreateTime + RoomDuration and 0 == roomData.RewardState and roomData.CloseTime and CurrentTime < roomData.CloseTime + StoppageRoomDuration then
            if not StoppageRoomCache then
              table.insert(StoppageRoom, roomData.RoomUniqueId)
            elseif StoppageRoomCache and not StoppageRoomCache[roomData.RoomUniqueId] then
              table.insert(StoppageRoom, roomData.RoomUniqueId)
            end
          end
        end
      end
      if RewardCount > 0 then
        ReddotManager.IncreaseLeafNodeCount(NodeName, RewardCount, {CacheKey = "Red"})
      end
      if #StoppageRoom > 0 then
        ReddotManager.IncreaseLeafNodeCount(StoppageNodeName, #StoppageRoom, {
          CacheKey = "New",
          Type = "StoppageRoom",
          RoomIds = StoppageRoom
        })
      end
    end)
  else
    local CacheName = "AsynccombatStoppageRoomClickTime" .. ActivityID
    local StoppageRoomCache = EMCache:Get(CacheName, true)
    if StoppageRoomCache and next(StoppageRoomCache) == nil then
      EMCache:Remove(CacheName, true)
    end
  end
end

return Component
