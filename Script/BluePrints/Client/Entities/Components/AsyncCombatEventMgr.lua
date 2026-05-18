local EMCache = require("EMCache.EMCache")
local Component = {}

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
  if true == IsPass and 1 == RewardState then
    ReddotManager.IncreaseLeafNodeCount("AsyncCombatReward", 1, {CacheKey = "Red"})
  end
  EventManager:FireEvent("AsyncCombatRoomEnd", RoomUniId, IsPass, RewardState)
end

function Component:OnAsyncCombatRoomDelete(RoomUniId, bSendRewardMail)
  self.logger.debug("OnAsyncCombatRoomDelete", RoomUniId, bSendRewardMail)
  if true == bSendRewardMail then
    ReddotManager.DecreaseLeafNodeCount("AsyncCombatReward", 1, {CacheKey = "Red"})
  end
end

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.RefreshRedDot)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:RefreshRedDot()
  self:RefreshAsyncCombatNew()
  self:RefreshAsyncCombatRewardRedDot()
end

function Component:RefreshAsyncCombatNew()
  local NodeName = "AsyncCombatNew"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  ReddotManager.ClearLeafNodeCount(NodeName, true)
  local AsyncCombatCreateBtnCickTime = EMCache:Get("AsyncCombatBtnTime", true)
  if not AsyncCombatCreateBtnCickTime then
    ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {CacheKey = "New"})
  else
    local TimeCheck = TimeUtils.IsTimestampInCurrentWeek(AsyncCombatCreateBtnCickTime or 0)
    if false == TimeCheck then
      ReddotManager.IncreaseLeafNodeCount(NodeName, 1, {CacheKey = "New"})
    end
  end
end

function Component:RefreshAsyncCombatRewardRedDot()
  local NodeName = "AsyncCombatReward"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNode(NodeName)
  end
  ReddotManager.ClearLeafNodeCount(NodeName, true)
  self:AsyncCombatGetOwnedRoom(function(Err, RoomList)
    if Err ~= ErrorCode.RET_SUCCESS then
      return
    end
    local RewardCount = 0
    for _, roomData in ipairs(RoomList) do
      if roomData.IsPass == true and 1 == roomData.RewardState then
        RewardCount = RewardCount + 1
      end
    end
    if RewardCount > 0 then
      ReddotManager.IncreaseLeafNodeCount(NodeName, RewardCount, {CacheKey = "Red"})
    end
  end)
end

return Component
