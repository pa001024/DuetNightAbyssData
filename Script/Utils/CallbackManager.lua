local Heap = require("BluePrints.Client.Wrapper.Heap")
local Handle = {}

function Handle:New(Callback, EndTime, FuncName, LogError)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Callback, EndTime, FuncName, LogError)
  return Obj
end

function Handle:Init(Callback, EndTime, FuncName, LogError)
  self.Callback = Callback
  self.EndTime = EndTime
  self.FuncName = FuncName
  self.SortValue = self.EndTime
  self.LogError = LogError
end

function Handle:Cancel()
  self.Callback = nil
  self.Canceled = true
end

function Handle:IsValid()
  return self.Callback ~= nil
end

function Handle:Call()
  if self.Callback then
    local ok, err = xpcall(self.Callback, debug.traceback)
    if not ok and self.LogError then
      self.LogError("CallbackManager callback error", self.FuncName, err)
    end
  end
  self.Callback = nil
end

local CallbackManager = {}

function CallbackManager:New(Tag)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(Tag)
  return Obj
end

function CallbackManager:Init(Tag)
  self.Handles = {}
  self.LastCallbackTime = 0
  self.CurrentTimer = nil
  self.Tag = Tag
  self.TickCallback = CommonUtils.Bind(self, self.Tick)
  
  function self.LogError(...)
    self:_LogError(...)
  end
end

function CallbackManager:_Now()
  if skynet and skynet.now then
    return skynet.now()
  end
  if UE4 and UE4.UGameplayStatics and GWorld and GWorld.GameInstance then
    return math.floor(UE4.UGameplayStatics.GetRealTimeSeconds(GWorld.GameInstance) * 100)
  end
  return math.floor(os.clock() * 100)
end

function CallbackManager:_LogError(...)
  if skynet and skynet.error then
    skynet.error(...)
  elseif DebugPrint then
    DebugPrint(...)
  else
    print(...)
  end
end

function CallbackManager:_PopInvalidHandles()
  local changed = false
  while self.Handles and #self.Handles > 0 do
    local handle = self.Handles[1]
    if handle and handle:IsValid() then
      break
    end
    Heap.HeapPop(self.Handles)
    changed = true
  end
  return changed
end

function CallbackManager:AddCallback(Time, Callback, FuncName)
  if type(Time) ~= "number" or not Callback then
    return
  end
  if Time < 0 then
    self:_LogError(string.format("add callback failed for time: %s is less than 0", Time), FuncName)
    Time = 0
  end
  FuncName = FuncName or "unknown"
  local Now = self:_Now()
  local EndTime = Now + math.ceil(Time * 100)
  local _Handle = Handle:New(Callback, EndTime, FuncName, self.LogError)
  Heap.HeapPush(self.Handles, _Handle)
  self:UpdateTick(Now)
  return _Handle
end

function CallbackManager:CancelCallback(_Handle)
  if _Handle then
    _Handle:Cancel()
    self:_PopInvalidHandles()
    if _Handle.EndTime == self.LastCallbackTime then
      self.LastCallbackTime = 0
      self:UpdateTick()
    end
  end
end

function CallbackManager:UpdateTick(Now)
  Now = Now or self:_Now()
  self:_PopInvalidHandles()
  if not self.Handles or next(self.Handles) == nil then
    self:CancelCurrentTimer()
    self.LastCallbackTime = 0
    return
  end
  local FirstEndTime = self.Handles[1].EndTime
  if FirstEndTime < self.LastCallbackTime or 0 == self.LastCallbackTime then
    self.LastCallbackTime = FirstEndTime
    self:CancelCurrentTimer()
    local RemainTime = math.max(FirstEndTime - Now, 0)
    if self.Tag == "Client" then
      if GWorld and GWorld.GameInstance and URuntimeCommonFunctionLibrary then
        self.CurrentTimer = URuntimeCommonFunctionLibrary.K2_SetTimerDelegate({
          GWorld.GameInstance,
          self.TickCallback
        }, RemainTime / 100, false, 0)
      end
    elseif self.Tag == "Server" then
      _, self.CurrentTimer = skynet.timeout(math.ceil(RemainTime), self.TickCallback)
    end
  end
end

function CallbackManager:Tick()
  local Now = self:_Now()
  self:_PopInvalidHandles()
  while self.Handles and #self.Handles > 0 and not (Now < self.Handles[1].EndTime) do
    local _Handle = Heap.HeapPop(self.Handles)
    _Handle:Call()
    self:_PopInvalidHandles()
  end
  self.LastCallbackTime = 0
  self.CurrentTimer = nil
  self:UpdateTick(Now)
end

function CallbackManager:CancelCurrentTimer()
  if not self.CurrentTimer then
    return
  end
  if self.Tag == "Client" then
    if GWorld and GWorld.GameInstance and URuntimeCommonFunctionLibrary then
      URuntimeCommonFunctionLibrary.K2_ClearAndInvalidateTimerHandle(GWorld.GameInstance, self.CurrentTimer)
    end
  elseif self.Tag == "Server" then
    skynet.remove_timeout(self.CurrentTimer)
  end
  self.CurrentTimer = nil
end

function CallbackManager:Release()
  self.Handles = {}
  self:CancelCurrentTimer()
  self.LastCallbackTime = 0
end

return CallbackManager
