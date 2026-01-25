require("UnLua")
local FStoryLog = require("BluePrints/Story/Log/StoryLog")
local M = Class()

function M:OnInitialize()
end

function M:OnDeinitialize()
end

function M:OnPrintToFeiShu(Type, Title, Message)
  if not (Type and Title) or not Message then
    DebugPrint(ErrorTag, "BP_StoryLogSubsystem:OnPrintToFeiShu, 参数为空", Type, Title, Message)
    return
  end
  local TypeString
  local Success, Result = pcall(function()
    return UE.EStoryLogType:GetDisplayNameTextByValue(Type)
  end)
  if not (Success and Result) or "" == Result then
    DebugPrint(ErrorTag, "BP_StoryLogSubsystem:OnPrintToFeiShu, 参数Type不是有效的EStoryLogType枚举值", Type)
    return
  end
  TypeString = Result
  if not GWorld.StoryLogDict then
    GWorld.StoryLogDict = {}
  end
  local ErrorDictContent = TypeString .. Title .. Message
  if "" ~= ErrorDictContent and GWorld.StoryLogDict[ErrorDictContent] then
    return
  end
  GWorld.StoryLogDict[ErrorDictContent] = true
  local StoryLog = FStoryLog:New()
  local Ct = {
    "【错误大类】: ",
    TypeString,
    "\n",
    "【标题】: ",
    Title,
    "\n",
    "【具体内容】: ",
    Message
  }
  local Ret = table.concat(Ct)
  StoryLog:AddTextLine(Ret)
  self:AddTracebackLog(StoryLog)
  self:AddPlatformLog(StoryLog)
  self:AddSubregionLog(StoryLog)
  self:AddWorkingTalkTaskLog(StoryLog)
  ScreenPrint(string.format([[
%s
%s]], Title, StoryLog:ToString()))
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SendToFeishuForJQ(StoryLog:ToRichString(), Title)
  end
end

function M:AddTracebackLog(StoryLog, Level, LineLimit)
  Level = Level or 4
  LineLimit = LineLimit or 10
  local Traceback
  local NativeTraceback = debug.traceback(nil, Level)
  local Lines = string.split(NativeTraceback, "\n")
  local LineCount = #Lines
  if LineLimit < LineCount then
    local HeadLineCount = math.ceil(LineLimit / 2)
    local HeadLine = table.concat(Lines, "\n", 1, HeadLineCount)
    HeadLineCount = HeadLineCount + 1
    HeadLine = string.format([[
%s
(...skip calls...)]], HeadLine)
    local TailLineCount = LineLimit - HeadLineCount
    local TailLine = table.concat(Lines, "\n", LineCount - TailLineCount + 1, LineCount)
    Traceback = string.format([[
%s
%s]], HeadLine, TailLine)
  else
    Traceback = NativeTraceback
  end
  StoryLog:AddSeparator()
  StoryLog:AddTitleLine("调用栈")
  StoryLog:AddTextLine(Traceback)
end

function M:AddPlatformLog(StoryLog)
  local PlatformName = UE4.UGameplayStatics.GetPlatformName()
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GWorld.GameInstance) then
    PlatformName = "编辑器"
  end
  StoryLog:AddSeparator()
  StoryLog:AddTitleLine("平台信息")
  StoryLog:AddKeyLine("平台", PlatformName)
end

function M:AddSubregionLog(StoryLog)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  local SubregionId = Avatar:GetCurrentRegionId()
  local SubregionName = "无效的子区域命名"
  local SubregionData = DataMgr.SubRegion[SubregionId]
  if SubregionData then
    local TextData = DataMgr.TextMap[SubregionData.SubRegionName]
    if TextData then
      SubregionName = GText(SubregionData.SubRegionName)
    end
  end
  StoryLog:AddSeparator()
  StoryLog:AddTitleLine("区域信息")
  StoryLog:AddKeyLine("子区域 ID", SubregionId)
  StoryLog:AddKeyLine("子区域名称", SubregionName)
end

function M:AddWorkingTalkTaskLog(StoryLog)
  local TS = TalkSubsystem()
  if not TS then
    return
  end
  local Logs = TS:GetAllWorkingTaskDebugLogs()
  if not Logs or 0 == #Logs then
    return
  end
  StoryLog:AddSeparator()
  StoryLog:AddTitleLine("当前运行中的对话任务信息")
  for _, Log in pairs(Logs) do
    StoryLog:AddMapLine(Log)
  end
end

return M
