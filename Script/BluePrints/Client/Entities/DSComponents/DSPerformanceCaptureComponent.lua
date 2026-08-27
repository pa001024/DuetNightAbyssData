local Component = {}
local CPUCaptureTimerKey = "DSAutoPerformanceCaptureCPU"
local MemCaptureTimerKey = "DSAutoPerformanceCaptureMem"
local MaxCaptureIdLength = 180

local function IsLinuxServer()
  local PlatformName = tostring(UE.UGameplayStatics.GetPlatformName())
  return PlatformName:sub(1, 5) == "Linux"
end

local function ShellQuote(Value)
  Value = tostring(Value)
  assert(not Value:find("[\r\n%z]"), "shell argument contains a control character")
  return "'" .. Value:gsub("'", "'\\''") .. "'"
end

local function RunCommand(Command)
  if not io or not io.popen then
    return nil, "io.popen is unavailable"
  end
  local Ok, Pipe = pcall(io.popen, Command .. " 2>&1", "r")
  if not Ok or not Pipe then
    return nil, "cannot start command: " .. tostring(Pipe)
  end
  local Output = Pipe:read("*a") or ""
  local CloseOk, CloseReason, CloseCode = Pipe:close()
  if true ~= CloseOk then
    local ErrorMessage = string.format("command failed reason=%s code=%s output=%s", tostring(CloseReason), tostring(CloseCode), Output)
    return nil, ErrorMessage
  end
  return Output
end

local function ParseProviderOutput(Output)
  local Values = {}
  for Line in tostring(Output):gmatch("[^\r\n]+") do
    local Key, Value = Line:match("^([A-Z0-9_]+)=(.*)$")
    if Key then
      Values[Key] = Value
    end
  end
  return Values
end

local function GetDSPerfTool()
  local CommandLine = tostring(UE.UKismetSystemLibrary.GetCommandLine())
  local Tool = CommandLine:match("%-DSPerfTool=\"([^\"]+)\"") or CommandLine:match("%-DSPerfTool=([^%s]+)")
  if not Tool then
    return nil, "-DSPerfTool is not configured", true
  end
  if Tool:sub(1, 1) ~= "/" or Tool:find("[\r\n%z]") then
    return nil, "invalid absolute -DSPerfTool", false
  end
  return Tool
end

local function CheckOptionalProviderAvailability(Tool)
  local Executable, ExecutableError = RunCommand("test -x " .. ShellQuote(Tool) .. " && printf DSPERF_EXECUTABLE")
  if not Executable or not Executable:find("DSPERF_EXECUTABLE", 1, true) then
    return false, "dsperf tool is unavailable: " .. tostring(ExecutableError)
  end
  local DoctorOutput, DoctorError = RunCommand(ShellQuote(Tool) .. " doctor")
  if not DoctorOutput or not DoctorOutput:find("DSPERF_DOCTOR_OK=1", 1, true) then
    return false, "Linux perf toolchain is unavailable: " .. tostring(DoctorError or DoctorOutput)
  end
  return true
end

local function ProviderDirectory(CaptureId, Pid)
  local SavedDirectory = tostring(UE.UKismetSystemLibrary.GetProjectSavedDirectory()):gsub("\\", "/"):gsub("/+$", "")
  Pid = tostring(Pid)
  if "/" ~= SavedDirectory:sub(1, 1) then
    return nil, "project Saved directory is not absolute"
  end
  if not Pid:match("^%d+$") then
    return nil, "process PID is not an unsigned integer"
  end
  return string.format("%s/Profiling/DSAuto/Processes/Pid%s/Sessions/%s/DSPerf/%s", SavedDirectory, Pid, CaptureId, CaptureId)
end

local function ValidateProviderIdentity(State, Values, AcceptedStatuses)
  if not (Values.DSPERF_CAPTURE == State.CaptureId and Values.DSPERF_PID == State.Pid and Values.DSPERF_STARTTIME and Values.DSPERF_STARTTIME:match("^%d+$")) or Values.DSPERF_DIRECTORY ~= State.Directory or Values.DSPERF_MANIFEST ~= State.Directory .. "/capture.manifest" or not AcceptedStatuses[Values.DSPERF_STATUS] then
    return false, "dsperf returned invalid identity or status"
  end
  if State.Starttime and Values.DSPERF_STARTTIME ~= State.Starttime then
    return false, "dsperf starttime changed"
  end
  return true
end

local function StartProvider(CaptureId, Pid, Tool)
  local Directory, ErrorMessage = ProviderDirectory(CaptureId, Pid)
  if not Directory then
    return nil, ErrorMessage
  end
  local State = {
    CaptureId = CaptureId,
    Pid = tostring(Pid),
    Directory = Directory,
    Tool = Tool
  }
  local Command = table.concat({
    ShellQuote(Tool),
    "start",
    ShellQuote(CaptureId),
    ShellQuote(State.Pid),
    ShellQuote(Directory)
  }, " ")
  local Output
  Output, ErrorMessage = RunCommand(Command)
  if not Output then
    return nil, ErrorMessage
  end
  local Values = ParseProviderOutput(Output)
  local Valid
  Valid, ErrorMessage = ValidateProviderIdentity(State, Values, {Running = true})
  if not Valid then
    return nil, ErrorMessage .. ": " .. Output
  end
  State.Starttime = Values.DSPERF_STARTTIME
  State.Manifest = Values.DSPERF_MANIFEST
  return State
end

local function StopProvider(State)
  local Command = table.concat({
    ShellQuote(State.Tool),
    "stop",
    ShellQuote(State.CaptureId),
    ShellQuote(State.Pid),
    ShellQuote(State.Starttime),
    ShellQuote(State.Directory)
  }, " ")
  local Output, ErrorMessage = RunCommand(Command)
  if not Output then
    return false, ErrorMessage
  end
  local Valid
  Valid, ErrorMessage = ValidateProviderIdentity(State, ParseProviderOutput(Output), {Finalizing = true, Completed = true})
  if not Valid then
    return false, ErrorMessage .. ": " .. Output
  end
  return true
end

local function TryStartOptionalProvider(CaptureId, Pid)
  if not IsLinuxServer() then
    return nil
  end
  local Tool, ErrorMessage, IsUnavailable = GetDSPerfTool()
  if not Tool then
    return nil, ErrorMessage, IsUnavailable
  end
  local Available
  Available, ErrorMessage = CheckOptionalProviderAvailability(Tool)
  if not Available then
    return nil, ErrorMessage, true
  end
  local State
  State, ErrorMessage = StartProvider(CaptureId, Pid, Tool)
  if not State then
    return nil, ErrorMessage, false
  end
  return State
end

local function BuildPerformanceCaptureId(self, CaptureType)
  local GameInstance = GWorld.GameInstance
  local DungeonId = GameInstance:GetCurrentDungeonId()
  local DungeonConfig = DataMgr.Dungeon[DungeonId]
  if not DungeonConfig or not DungeonConfig.DungeonName then
    return nil, "current dungeon has no DungeonName config: " .. tostring(DungeonId)
  end
  local DungeonName = tostring(DungeonConfig.DungeonName)
  local DSEid = tostring(CommonUtils.ObjId2Str2(self.id))
  if not DungeonName:match("^[%w_-]+$") or not DSEid:match("^[%w_-]+$") then
    return nil, "DungeonName or DSEid contains unsafe characters"
  end
  local Uids = {}
  local SeenUids = {}
  for _, Info in pairs(self.AvatarInfos or {}) do
    local Uid = Info and Info.PlayerInfo and Info.PlayerInfo.Uid
    if nil == Uid then
      return nil, "AvatarInfos contains an entry without PlayerInfo.Uid"
    end
    Uid = tostring(Uid)
    if not Uid:match("^%d+$") then
      return nil, "player UID is not an unsigned integer: " .. Uid
    end
    if not SeenUids[Uid] then
      SeenUids[Uid] = true
      table.insert(Uids, Uid)
    end
  end
  table.sort(Uids, function(Left, Right)
    return #Left == #Right and Left < Right or #Left < #Right
  end)
  self.PerformanceCaptureRound = self.PerformanceCaptureRound + 1
  local CaptureId = string.format("%s-%d_Pid%s_DSEid%s_Uids%s_%s_%s_R%03d", DungeonName, DungeonId, tostring(GameInstance:GetPID()), DSEid, #Uids > 0 and table.concat(Uids, "-") or "None", CaptureType, os.date("%Y%m%d-%H%M%S"), self.PerformanceCaptureRound)
  if #CaptureId > MaxCaptureIdLength or not CaptureId:match("^[%w][%w_-]*$") then
    return nil, "generated CaptureId is unsafe or too long: " .. CaptureId
  end
  return CaptureId
end

function Component:Init()
  self.PerformanceCaptureRound = 0
  self.bCPUCaptureActive = false
  self.bMemCaptureActive = false
  self.DSPerfCapture = nil
end

function Component:StartCPU(DurationSeconds)
  DurationSeconds = tonumber(DurationSeconds)
  if not DurationSeconds or DurationSeconds <= 0 then
    self.logger.error("StartCPU requires DurationSeconds > 0")
    return false
  end
  if self.bCPUCaptureActive or self.DSPerfCapture then
    self.logger.warning("StartCPU rejected because CPU capture is already active")
    return false
  end
  local CaptureId, ErrorMessage = BuildPerformanceCaptureId(self, "CPU")
  if not CaptureId then
    self.logger.error("StartCPU cannot build CaptureId", ErrorMessage)
    return false
  end
  local GameInstance = GWorld.GameInstance
  if not GameInstance:StartCPU(DurationSeconds, CaptureId) then
    self.logger.error("StartCPU UE capture failed", CaptureId)
    return false
  end
  self.bCPUCaptureActive = true
  local ProviderState, ProviderError, ProviderUnavailable = TryStartOptionalProvider(CaptureId, GameInstance:GetPID())
  if ProviderState then
    self.DSPerfCapture = ProviderState
  elseif ProviderUnavailable then
    self.logger.warning("StartCPU skipped optional Linux dsperf", ProviderError)
  elseif ProviderError then
    self.logger.error("StartCPU dsperf failed; UE session remains active", ProviderError)
  end
  GameInstance:AddTimer(DurationSeconds, function()
    self:StopCPU()
  end, false, 0, CPUCaptureTimerKey, true)
  self.logger.info("StartCPU succeeded", CaptureId, DurationSeconds)
  return true
end

function Component:StopCPU()
  local WasActive = self.bCPUCaptureActive or self.DSPerfCapture ~= nil
  if not WasActive then
    self.logger.warning("StopCPU ignored because CPU capture is idle")
    return false
  end
  local GameInstance = GWorld.GameInstance
  GameInstance:RemoveTimer(CPUCaptureTimerKey)
  local UEStopped = GameInstance:StopCPU()
  if not UEStopped then
    self.logger.error("StopCPU UE capture did not stop successfully")
  end
  if self.DSPerfCapture then
    local ProviderStopped, ErrorMessage = StopProvider(self.DSPerfCapture)
    if not ProviderStopped then
      self.logger.error("StopCPU dsperf failed", ErrorMessage)
    end
  end
  self.DSPerfCapture = nil
  self.bCPUCaptureActive = false
  self.logger.info("StopCPU logically finished", UEStopped)
  return true
end

function Component:StatMem()
  if self.bCPUCaptureActive then
    self.logger.error("StatMem ignored because CPU capture is active")
    return false
  end
  local Stopped = GWorld.GameInstance:StatMem()
  if not Stopped then
    self.logger.error("StatMem was rejected by UE")
    return false
  end
  self.logger.info("StatMem consumed the process memoryprofiler writer")
  return true
end

function Component:StartMem(DurationSeconds, IntervalSeconds)
  DurationSeconds = tonumber(DurationSeconds)
  if not DurationSeconds or DurationSeconds <= 0 then
    self.logger.error("StartMem requires DurationSeconds > 0")
    return false
  end
  if nil == IntervalSeconds then
    IntervalSeconds = 300
  else
    IntervalSeconds = tonumber(IntervalSeconds)
  end
  if not IntervalSeconds or IntervalSeconds <= 0 then
    self.logger.error("StartMem requires IntervalSeconds > 0")
    return false
  end
  if self.bMemCaptureActive then
    self.logger.warning("StartMem rejected because Mem capture is already active")
    return false
  end
  local CaptureId, ErrorMessage = BuildPerformanceCaptureId(self, "Mem")
  if not CaptureId then
    self.logger.error("StartMem cannot build CaptureId", ErrorMessage)
    return false
  end
  local GameInstance = GWorld.GameInstance
  if not GameInstance:StartMem(DurationSeconds, IntervalSeconds, CaptureId) then
    self.logger.error("StartMem UE capture failed", CaptureId)
    return false
  end
  self.bMemCaptureActive = true
  GameInstance:AddTimer(DurationSeconds, function()
    self:StopMem()
  end, false, 0, MemCaptureTimerKey, true)
  self.logger.info("StartMem succeeded", CaptureId, DurationSeconds, IntervalSeconds)
  return true
end

function Component:StopMem()
  if not self.bMemCaptureActive then
    self.logger.warning("StopMem ignored because Mem capture is idle")
    return false
  end
  local GameInstance = GWorld.GameInstance
  GameInstance:RemoveTimer(MemCaptureTimerKey)
  local Stopped = GameInstance:StopMem()
  self.bMemCaptureActive = false
  if not Stopped then
    self.logger.error("StopMem UE capture did not stop successfully")
  end
  self.logger.info("StopMem logically finished", Stopped)
  return true
end

function Component:LeaveWorld()
  if self.bCPUCaptureActive or self.DSPerfCapture then
    self:StopCPU()
  end
  if self.bMemCaptureActive then
    self:StopMem()
  end
end

return Component
