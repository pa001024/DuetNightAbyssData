local Class = _G.TypeClass
local AvatarEntity = require("BluePrints.Client.Wrapper.Entity").AvatarEntity
local Assemble = require("NetworkEngine.Common.Assemble")
local MiscUtils = require("Utils.MiscUtils")
local DSEntity = Class("DSEntity", AvatarEntity)
local bHookGameModeReadyForInitNext = false
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
    return nil, "cannot start dsperf: " .. tostring(Pipe)
  end
  local Output = Pipe:read("*a") or ""
  local CloseOk, CloseReason, CloseCode = Pipe:close()
  if true ~= CloseOk then
    return nil, string.format("dsperf failed reason=%s code=%s output=%s", tostring(CloseReason), tostring(CloseCode), Output)
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
  if not Tool or Tool:sub(1, 1) ~= "/" or Tool:find("[\r\n%z]") then
    return nil, "missing or invalid absolute -DSPerfTool"
  end
  return Tool
end

local function ProviderDirectory(CaptureId)
  local SavedDirectory = tostring(UE.UKismetSystemLibrary.GetProjectSavedDirectory()):gsub("\\", "/"):gsub("/+$", "")
  if "/" ~= SavedDirectory:sub(1, 1) then
    return nil, "project Saved directory is not absolute"
  end
  return SavedDirectory .. "/Profiling/DSPerf/" .. CaptureId
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

local function StartProvider(CaptureId, Pid)
  local Tool, ErrorMessage = GetDSPerfTool()
  if not Tool then
    return nil, ErrorMessage
  end
  local Directory
  Directory, ErrorMessage = ProviderDirectory(CaptureId)
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

DSEntity.__Component__ = {
  "BluePrints.Client.Entities.DSComponents.DSRewardsComponent",
  "BluePrints.Client.Entities.DSComponents.DSBattleComponent",
  "BluePrints.Client.Entities.DSComponents.DSPerformanceCaptureComponent",
  "BluePrints.Client.Entities.CommonComponents.ResourceUseComponent",
  "BluePrints.Client.Entities.CommonComponents.AutoBattleTestComponent",
  "BluePrints.Client.Entities.DSComponents.DSTargetComponent",
  "Blueprints.Client.Entities.CommonComponents.GameModeWalnutComponent",
  "Blueprints.Client.Entities.CommonComponents.DungeonGameObjectComponent",
  "Blueprints.Client.Entities.CommonComponents.ServerGameControlComponent",
  "Blueprints.Client.Entities.DSComponents.DSServerDungeonComponent"
}
local bStatusInPreloading = false

function DSEntity:Init(eid)
  DSEntity.Super.Init(self, eid)
  self.bClientEntity = false
  self.bStartSuccess = false
  self.PerformanceCaptureRound = 0
  self.bCPUCaptureActive = false
  self.bMemCaptureActive = false
  self.DSPerfCapture = nil
end

function DSEntity:InitFromDict(attrs)
end

function DSEntity:CreateSuccess()
  self:CallServerMethod("OnCreateClientEntity", true)
end

function DSEntity:BecomePlayer(DSStatus)
  if DSStatus == CommonConst.DSRunningStatus.Preloading then
    bStatusInPreloading = true
  end
  DSEntity.Super.BecomePlayer(self)
end

function DSEntity:OnBecomePlayer()
  DSEntity.Super.OnBecomePlayer(self)
  self.logger.info("DSEntity OnBecomePlayer")
  self:EnterWorld()
  local BP_Avatar = GWorld.GameInstance:GetAvatar()
  if BP_Avatar then
    BP_Avatar:SetDSEntity(self)
  end
  self:StartSuccess()
  self:QueryHotfix()
end

function DSEntity:QueryHotfix()
  local index = GWorld.HotfixDataIndex or 0
  self:CallServerMethod("QueryHotfix", index)
end

function DSEntity:OnQueryHotfixSuccess(HotfixScript, HotfixIndex)
  ServerPrint("OnQueryHotfixSuccess", HotfixScript, HotfixIndex)
  if HotfixIndex then
    require("HotFix").ExecHotFix(HotfixIndex, HotfixScript)
    GWorld.HotfixDataIndex = HotfixIndex
  end
end

function DSEntity:CallSkynetServerMethod(FuncName, ...)
  self:CallServerMethod(FuncName, ...)
end

function DSEntity:CallSkynetServerCallback(CallbackId, ...)
  self:CallServerMethod("CallSkynetServerCallback", CallbackId, ...)
end

function DSEntity:StartSuccess()
  self:TestHotUpdate()
  local GameInstance = GWorld.GameInstance
  local Pid = GameInstance:GetPID()
  local PPid = GameInstance:GetPPid()
  local DSVersion = MiscUtils.GetGameCofingSettings("DSVersion") or 0
  local LogPath = GameInstance:LogPath()
  local DSType = GameInstance.DSType
  if GameInstance.DSType ~= CommonConst.DSType.Root then
    local DungeonId = GameInstance.TargetDungeonId
    if not DungeonId then
      error("DungeonId is nil")
    end
    if WorldTravelSubsystem():GetCurrentSceneId() ~= DungeonId then
      self:ChangeMap(DungeonId)
    else
      GameInstance:UpdateNetDriverInfo()
    end
  end
  local Ip = GameInstance.LastUploadIp
  local Port = GameInstance.LastUploadPort
  local DSInfo = {
    Ip = Ip,
    Port = Port,
    Type = DSType,
    Pid = Pid,
    PPid = PPid,
    Hostnum = GameInstance.DSConnectHostnum,
    DSVersion = DSVersion,
    LogPath = LogPath,
    bDynamic = GameInstance.bDynamicNode,
    LocalUser = UE.UKismetSystemLibrary:GetPlatformUserName(),
    DungeonId = GameInstance.TargetDungeonId
  }
  ServerPrint("Ip, Port, PID, PPID, DSVersion, LogPath", Ip, Port, Pid, PPid, DSVersion, LogPath)
  
  local function callback(ret, LogParam)
    if 0 ~= DSVersion and DSType == CommonConst.DSType.Root then
      if bStatusInPreloading then
        self:StartPreload()
      else
        GameInstance:RecordRunningSuccess()
        self:HotUpdate()
      end
      self:UpdateDSLogSetting(LogParam)
    end
  end
  
  if GameInstance.DSType == CommonConst.DSType.Root and bStatusInPreloading then
    self:CallServer("StartSuccess", callback)
  else
    self:CallServer("StartSuccess", callback, DSInfo)
  end
  self.bStartSuccess = true
end

function DSEntity:UpdateNetDriverInfo(ip, port)
  if not self.bStartSuccess then
    return
  end
  if ip and port then
    self:CallServerMethod("UpdateNetDriverInfo", ip, port)
  end
end

function DSEntity:ConnectDSServerSuccess(AvatarEid, bReconnect)
  ServerPrint("ConnectDSServerSuccess", AvatarEid, bReconnect)
  self:CallSkynetServerMethod("ConnectDSServerSuccess", AvatarEid, bReconnect)
end

function DSEntity:DisconnectDSServerSuccess(AvatarEid)
  ServerPrint("DisconnectDSServerSuccess", AvatarEid)
  self:CallServerMethod("DisconnectDSServerSuccess", AvatarEid)
end

function DSEntity:CloseDS(Reason)
  self.logger.debug("CloseDS", Reason)
  GWorld.GameInstance:CloseDS(Reason)
end

function DSEntity:ChangeMap(DungeonId)
  ServerPrint("Change to Map: ", DungeonId)
  self:TryCreateServerDungeon(DungeonId)
  self.HasLeaveAvatars = {}
  self.bBlock = false
  GWorld.GameInstance:ChangeMapAsDedicatedServer(DungeonId)
end

function DSEntity:SystemRequireGameModeInitWithoutAnyPlayer()
  bHookGameModeReadyForInitNext = true
  local GameMode = GWorld.GameInstance:GetCurrentGameMode()
  GameMode:SetGameStartType(0)
end

function DSEntity:HookGameModeReady(GameMode)
  if self.IsAutoBattle then
    GameMode:TryTriggerOnRealInit()
  end
  if bHookGameModeReadyForInitNext then
    GameMode:RealInit()
  end
  local GameInstance = GWorld.GameInstance
  if GameInstance.DSType == CommonConst.DSType.Child then
    self:CallServerMethod("FinishChangeMap", GameInstance.TargetDungeonId)
  end
end

function DSEntity:KickPlayer(PlayerId)
  local ret
  local GameMode = GWorld.GameInstance:GetCurrentGameMode()
  if PlayerId then
    ret = GameMode:KickPlayer(PlayerId)
  else
    ret = GameMode:KickAllPlayers()
  end
  self:CallServerMethod("OnKickPlayer", ret, PlayerId)
end

function DSEntity:ForkSubProcess(ForkNums, DSType, DungeonId)
  GWorld.GameInstance.TargetDungeonId = DungeonId
  GWorld.GameInstance:SetForkInfo(ForkNums, DSType)
  GWorld.GameInstance:StartFork()
end

function DSEntity:StartPreload()
  GWorld.GameInstance:GetDSAssetsManager():PreLoadAssets()
end

function DSEntity:QueryDeviceInfo(Callback)
  print(_G.LogTag, "QueryDeviceInfo")
  local Info = {}
  Info.CPUCores = GWorld.GameInstance:GetNumberOfCores()
  self:CallSkynetServerCallback(Callback, Info)
end

function DSEntity:TriggerCondition(ConditionId)
  self:CallServerMethod("TriggerCondition", ConditionId)
end

function DSEntity:HotUpdate()
  GWorld.GameInstance:GetDSAssetsManager():HotUpdate()
end

function DSEntity:HotPatch(bNeedRestart)
  GWorld.GameInstance:QuickRestartProcess(bNeedRestart, false)
end

function DSEntity:UpdateDSLogSetting(LogParam)
  local WhiteCategory = TArray(FName)
  local BlackCategory = TArray(FName)
  local WhiteContent = TArray("")
  local BlackContent = TArray("")
  
  local function AddToArray(Arr, T)
    for i = 1, #T do
      Arr:Add(T[i])
    end
  end
  
  LogParam = LogParam or {}
  for k, v in pairs(LogParam) do
    if "WhiteCategory" == k then
      AddToArray(WhiteCategory, v)
    elseif "BlackCategory" == k then
      AddToArray(BlackCategory, v)
    elseif "WhiteContent" == k then
      AddToArray(WhiteContent, v)
    elseif "BlackContent" == k then
      AddToArray(BlackContent, v)
    end
  end
  GWorld.GameInstance:UpdateDSLogSetting(WhiteCategory, BlackCategory, WhiteContent, BlackContent)
end

function DSEntity:ServerMulticast(FuncName, ...)
  print(_G.LogTag, "ServerMulticast", FuncName)
  self:CallServerMethod("Multicast", FuncName, ...)
end

function DSEntity:SendAvatar(AvatarEid, FuncName, ...)
  if not AvatarEid then
    print(_G.LogTag, "SendAvatar with nil AvatarEid")
    return
  end
  self:CallServerMethod("DSSendAvatar", AvatarEid, FuncName, ...)
end

function DSEntity:ServerConditionalMulticast(ConditionalAvatars, FuncName, ...)
  print(_G.LogTag, "ServerConditionalMulticast", FuncName)
  self:CallServerMethod("ConditionalMulticast", ConditionalAvatars, FuncName, ...)
end

local function BuildPerformanceCaptureId(self, CaptureType)
  local GameInstance = GWorld.GameInstance
  local DungeonId = GameInstance:GetCurrentDungeonId()
  local DungeonConfig = DataMgr.Dungeon[DungeonId]
  if not DungeonConfig or not DungeonConfig.DungeonName then
    return nil, "current dungeon has no DungeonName config: " .. tostring(DungeonId)
  end
  local DungeonName = tostring(DungeonConfig.DungeonName)
  local DSEid = tostring(CommonUtils.ObjId2Str(self.id))
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

function DSEntity:StartCPU(DurationSeconds)
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
  if IsLinuxServer() then
    local ProviderState
    ProviderState, ErrorMessage = StartProvider(CaptureId, GameInstance:GetPID())
    if not ProviderState then
      self.logger.error("StartCPU dsperf failed", ErrorMessage)
      return false
    end
    self.DSPerfCapture = ProviderState
  end
  if not GameInstance:StartCPU(DurationSeconds, CaptureId) then
    self.logger.error("StartCPU UE capture failed", CaptureId)
    if self.DSPerfCapture then
      local Stopped, StopError = StopProvider(self.DSPerfCapture)
      if not Stopped then
        self.logger.error("StartCPU dsperf rollback failed", StopError)
      else
        self.DSPerfCapture = nil
      end
    end
    return false
  end
  self.bCPUCaptureActive = true
  GameInstance:AddTimer(DurationSeconds, function()
    self:StopCPU()
  end, false, 0, CPUCaptureTimerKey, true)
  self.logger.info("StartCPU succeeded", CaptureId, DurationSeconds)
  return true
end

function DSEntity:StopCPU()
  local WasActive = self.bCPUCaptureActive or self.DSPerfCapture ~= nil
  if not WasActive then
    self.logger.warning("StopCPU ignored because CPU capture is idle")
    return false
  end
  local GameInstance = GWorld.GameInstance
  GameInstance:RemoveTimer(CPUCaptureTimerKey)
  local UEStopped = GameInstance:StopCPU()
  local HadProvider = self.DSPerfCapture ~= nil
  local ProviderStopped = true
  if self.DSPerfCapture then
    local ErrorMessage
    ProviderStopped, ErrorMessage = StopProvider(self.DSPerfCapture)
    if ProviderStopped then
      self.DSPerfCapture = nil
    else
      self.logger.error("StopCPU dsperf failed", ErrorMessage)
    end
  end
  self.bCPUCaptureActive = not ProviderStopped
  self.logger.info("StopCPU finished", UEStopped, ProviderStopped)
  return ProviderStopped and (UEStopped or HadProvider)
end

function DSEntity:StartMem(DurationSeconds, IntervalSeconds)
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

function DSEntity:StopMem()
  if not self.bMemCaptureActive then
    self.logger.warning("StopMem ignored because Mem capture is idle")
    return false
  end
  local GameInstance = GWorld.GameInstance
  GameInstance:RemoveTimer(MemCaptureTimerKey)
  local Stopped = GameInstance:StopMem()
  self.bMemCaptureActive = false
  if Stopped then
    self.logger.info("StopMem finished")
  else
    self.logger.error("StopMem UE capture did not stop successfully")
  end
  return Stopped
end

function DSEntity:LeaveWorld()
  if self.bCPUCaptureActive or self.DSPerfCapture then
    self:StopCPU()
  end
  if self.bMemCaptureActive then
    self:StopMem()
  end
end

function DSEntity:Ping()
  self:CallServerMethod("Echo")
end

function DSEntity:DSStat(Cmd, ...)
  local CmdStr = tostring(Cmd)
  for _, Arg in ipairs({
    ...
  }) do
    CmdStr = CmdStr .. " " .. tostring(Arg)
  end
  print(_G.LogTag, "DSStat", CmdStr)
  GWorld.GameInstance:ExecuteCmd(CmdStr)
end

function DSEntity:TestHotUpdate()
  print(_G.LogTag, "TestHotUpdate", false)
end

function DSEntity:SendToFeishuForBattle(msg, msg_title)
  self:CallServerMethod("SendToFeishuForBattle", msg, msg_title)
end

function DSEntity:SendTraceToQaWeb(trace_type, describe_info)
  self:CallServerMethod("SendTraceToQaWeb", trace_type, describe_info)
end

function DSEntity:BLog(...)
  self:CallServerMethod("DSBLog", ...)
end

function DSEntity:SendToFeiShuForRegionMgr(msg, msg_title)
  self:CallServerMethod("SendToFeiShuForRegionMgr", msg, msg_title)
end

function DSEntity:SendToFeishuForMonster(msg, msg_title)
  self:CallServerMethod("SendToFeiShuForMonster", msg, msg_title)
end

Assemble.AssembleComponents(DSEntity)
return DSEntity
