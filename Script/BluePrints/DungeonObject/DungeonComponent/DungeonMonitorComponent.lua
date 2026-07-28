local DungeonMonitorComponent = DungeonClass.Class()
DungeonMonitorComponent.__Component__ = {}

function DungeonMonitorComponent:BeginPlay()
  print("ljl@ DungeonMonitorComponent BeginPlay")
end

function DungeonMonitorComponent:ShowDungeonObjError(ErrorMsg, IsPrintStack, OnceKey)
  local Space = "======================================\n"
  local tbl = {
    Space,
    "报错文本:\n\t",
    tostring(ErrorMsg),
    "\n"
  }
  table.insert(tbl, Space)
  self:FillCommonInfo(tbl)
  if self.FillCustomGameInfo then
    table.insert(tbl, Space)
    self:FillCustomGameInfo(tbl)
  end
  if IsPrintStack then
    table.insert(tbl, Space)
    self:FillTraceBack(tbl)
  end
  local FinalMsg = table.concat(tbl)
  print(FinalMsg)
  local Opt = {}
  if OnceKey then
    Opt.OnceKey = OnceKey
  end
  self:ReportDungeonWarningToFeishu(FinalMsg)
end

function DungeonMonitorComponent:FillCommonInfo(tbl)
  table.insert(tbl, "副本Id: " .. self.DungeonId .. "\n")
end

function DungeonMonitorComponent:FillTraceBack(tbl)
  table.insert(tbl, [[
Traceback:
	]])
  table.insert(tbl, debug.traceback())
  table.insert(tbl, "\n")
end

DungeonClass.AssembleComponents(DungeonMonitorComponent)
return DungeonMonitorComponent
