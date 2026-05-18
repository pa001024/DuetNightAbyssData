local StrLib = require("BluePrints.Common.DataStructure")
local Deque = StrLib.Deque
local M = Class("BluePrints.Common.TimerMgr")
M._DefaultUIName = "TeamInviteTip"
M._LoopInterval = 0.05
M._TimerKey = "InviteQueueManager_Timer"
M._DelayNextKey = "InviteQueueManager_DelayNext"
M._WaitLoadingKey = "InviteQueueManager_WaitLoading"
M.InviteType = {
  Team = "Team",
  Friend = "Friend",
  Guild = "Guild"
}
M._Queue = Deque.New()
M._CurrentInvite = nil
M._CurrentView = nil
M._EventListeners = {}

function M:_CloseCurrentView(cb)
  GWorld.GameInstance:RemoveTimer(self._TimerKey)
  if IsValid(self._CurrentView) then
    self._CurrentView:FakeClose(cb)
  end
  self._CurrentView = nil
end

function M:RegisterEvent(Obj, Func)
  if nil == Obj or type(Func) ~= "function" then
    return
  end
  self._EventListeners[Obj] = Func
end

function M:UnRegisterEvent(Obj)
  if nil == Obj then
    return
  end
  self._EventListeners[Obj] = nil
end

function M:_NotifyEvent(EventId, ...)
  for Obj, Func in pairs(self._EventListeners) do
    if IsValid(Obj) then
      local ok, err = pcall(Func, Obj, EventId, ...)
      if not ok then
        DebugPrint(ErrorTag, "InviteQueueManager:_NotifyEvent error", err)
      end
    else
      self._EventListeners[Obj] = nil
    end
  end
end

function M:EnqueueInvite(InviteData)
  if not (InviteData and InviteData.Type) or not InviteData.Uid then
    DebugPrint(ErrorTag, "InviteQueueManager:EnqueueInvite invalid data")
    return
  end
  for _, Item in ipairs(self._Queue:ToArr()) do
    if Item.Type == InviteData.Type and Item.Uid == InviteData.Uid then
      return
    end
  end
  if self._CurrentInvite and self._CurrentInvite.Type == InviteData.Type and self._CurrentInvite.Uid == InviteData.Uid then
    return
  end
  self._Queue:PushBack(InviteData)
  DebugPrint(LXYTag, "InviteQueueManager: Enqueued", InviteData.Type, InviteData.Uid, "QueueSize:", self._Queue:Size())
  if not self._CurrentInvite then
    self:_TryShowNext()
  end
end

function M:AcceptCurrent()
  if not self._CurrentInvite then
    return
  end
  local Invite = self._CurrentInvite
  if Invite.OnAccept then
    local ok, err = pcall(Invite.OnAccept)
    if not ok then
      DebugPrint(ErrorTag, "InviteQueueManager:AcceptCurrent error", err)
    end
  end
end

function M:RefuseCurrent(bAutoRefuse)
  if not self._CurrentInvite then
    return
  end
  local Invite = self._CurrentInvite
  if Invite.OnRefuse then
    local ok, err = pcall(Invite.OnRefuse, bAutoRefuse)
    if not ok then
      DebugPrint(ErrorTag, "InviteQueueManager:RefuseCurrent error", err)
    end
  end
end

function M:FinishCurrentInvite(CancelType)
  self:_CloseCurrentView(function()
    self:_TryShowNext()
  end)
  self._CurrentInvite = nil
  if CancelType then
    self:CancelByType(CancelType)
  end
end

function M:CancelByType(Type)
  local NewQueue = Deque.New()
  for _, Item in ipairs(self._Queue:ToArr()) do
    if Item.Type ~= Type then
      NewQueue:PushBack(Item)
    end
  end
  self._Queue = NewQueue
end

function M:ClearType(Type)
  self:CancelByType(Type)
  if self._CurrentInvite and self._CurrentInvite.Type == Type then
    self:FinishCurrentInvite()
  end
end

function M:CancelByFilter(FilterFn)
  local NewQueue = Deque.New()
  for _, Item in ipairs(self._Queue:ToArr()) do
    if FilterFn(Item) then
      NewQueue:PushBack(Item)
    end
  end
  self._Queue = NewQueue
end

function M:ClearQueue()
  self:_CloseCurrentView()
  self._Queue = Deque.New()
  self._CurrentInvite = nil
end

function M:IsEmpty()
  return self._Queue:IsEmpty()
end

function M:GetCurrentInvite()
  return self._CurrentInvite
end

function M:GetBackInviteInfo()
  return self._CurrentInvite
end

function M:GetBackFriendReqInfo()
  return self._CurrentInvite
end

function M:IsProcessing()
  return self._CurrentInvite ~= nil
end

function M:_TryShowNext()
  if self._CurrentInvite then
    return
  end
  local UIMgr = UIManager(GWorld.GameInstance)
  if UIMgr and UIMgr:GetUIObj("CommonChangeScene") then
    GWorld.GameInstanceelf:RemoveTimer(self._WaitLoadingKey)
    GWorld.GameInstance:AddTimer(0.5, function()
      self:_TryShowNext()
    end, false, 0, self._WaitLoadingKey)
    return
  end
  if self._Queue:IsEmpty() then
    DebugPrint(LXYTag, "InviteQueueManager: Queue empty, exit")
    return
  end
  local Invite = self._Queue:PopFront()
  if not Invite then
    DebugPrint(LXYTag, "InviteQueueManager: Queue empty, exit")
    return
  end
  self._CurrentInvite = Invite
  self:_ShowInvite(Invite)
end

function M:_ShowInvite(Invite)
  local UIMgr = UIManager(GWorld.GameInstance)
  if not UIMgr then
    DebugPrint(ErrorTag, "InviteQueueManager: UIManager not available")
    self:FinishCurrentInvite()
    return
  end
  local UIName = self._DefaultUIName
  local View = UIMgr:GetUIObj(UIName)
  local bIsNew = not IsValid(View)
  if bIsNew then
    DebugPrint(LXYTag, "InviteQueueManager: Open UI", UIName, Invite.Type, Invite.Uid)
    View = UIMgr:LoadUINew(UIName, Invite, Invite.Type)
  else
    DebugPrint(LXYTag, "InviteQueueManager: Reuse UI", UIName, Invite.Type, Invite.Uid)
    View:PlayAnimation(View.Auto_In)
    View:InitUIInfo(UIName, false, nil, Invite, Invite.Type)
  end
  self._CurrentView = View
  local MaxRemainTime = Invite.MaxRemainTime or 15
  local RemainTime = MaxRemainTime
  GWorld.GameInstance:RemoveTimer(self._TimerKey)
  GWorld.GameInstance:AddTimer(self._LoopInterval, function()
    RemainTime = RemainTime - self._LoopInterval
    local Percent = RemainTime / MaxRemainTime
    self:_NotifyEvent("InviteWaiting", Percent)
    if RemainTime > 0 then
      return
    end
    GWorld.GameInstance:RemoveTimer(self._TimerKey)
    if Invite.OnTimeout then
      local ok, err = pcall(Invite.OnTimeout)
      if not ok then
        DebugPrint(ErrorTag, "InviteQueueManager:OnTimeout error", err)
      end
    end
    self:FinishCurrentInvite()
  end, true, 0, self._TimerKey, true)
end

return M
