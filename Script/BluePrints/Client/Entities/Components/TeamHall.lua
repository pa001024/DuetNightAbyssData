local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local TeamHallDatas = require("BluePrints.UI.WBP.TeamHall.TeamHallData")
local MiscUtils = require("Utils.MiscUtils")
local Component = {}

local function TableToLogString(Data)
  if CommonUtils and CommonUtils.TableToString then
    return CommonUtils.TableToString(Data, 6)
  end
  return tostring(Data)
end

local function IsTeamHallVerboseLogEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableVerboseLog
end

local function IsTeamHallListSummaryLogEnabled()
  return TeamHallCommon.DebugFlags and TeamHallCommon.DebugFlags.EnableListSummaryLog
end

function Component:_GreenPrintTeamHallRpc(Stage, Payload)
  if not IsTeamHallVerboseLogEnabled() then
    return
  end
  MiscUtils.GreenPrint("TeamHallAvatar", Stage, TableToLogString(Payload))
end

function Component:EnterWorld()
  local bSuccess, Err = pcall(function()
    TeamHallController:Init()
  end)
  if not bSuccess and ScreenPrint then
    ScreenPrint("TeamHallController Init failed: " .. tostring(Err))
  end
end

function Component:LeaveWorld()
  local bSuccess, Err = pcall(function()
    TeamHallController:Destory()
  end)
  if not bSuccess and ScreenPrint then
    ScreenPrint("TeamHallController Destory failed: " .. tostring(Err))
  end
end

function Component:_OnPropChangeTeamRequestList(Keys, OldValue)
  local bSuccess, Err = pcall(function()
    TeamHallController:OnTeamRequestListChanged()
  end)
  if not bSuccess and ScreenPrint then
    ScreenPrint("TeamHallController OnTeamRequestListChanged failed: " .. tostring(Err))
  end
end

function Component:OnTeamMemberPropChangedForTeamHall(ChangeData, Uid)
  if not ChangeData or ChangeData.AvatarStatus == nil then
    return
  end
  local TeamModel = TeamController and TeamController.GetModel and TeamController:GetModel() or nil
  if not TeamModel then
    return
  end
  local LeaderUid = TeamModel:GetTeamLeaderId()
  if not LeaderUid then
    return
  end
  GreenPrint(string.format("[TeamHall] OnTeamMemberPropChangedForTeamHall Uid=%s LeaderUid=%s HasAvatarStatus=%s", tostring(Uid), tostring(LeaderUid), tostring(ChangeData.AvatarStatus ~= nil)))
  if tostring(LeaderUid) ~= tostring(Uid) then
    return
  end
  local bSuccess, Err = pcall(function()
    TeamHallController:OnTeamRecruitingStateBridge()
  end)
  if not bSuccess and ScreenPrint then
    ScreenPrint("TeamHallController OnTeamRecruitingStateBridge failed: " .. tostring(Err))
  end
end

function Component:RefreshTeamHallList(Callback, Filters)
  Filters = Filters or {}
  self:_GreenPrintTeamHallRpc("RefreshTeamHallList.Request", {
    Filters = Filters,
    FilterCount = #Filters
  })
  
  local function cb(ret, RawData)
    ret = ret or ErrorCode.RET_SUCCESS
    self:_GreenPrintTeamHallRpc("RefreshTeamHallList.Response", {
      Ret = ret,
      Filters = Filters,
      RawData = RawData
    })
    if ret == ErrorCode.RET_SUCCESS then
      self:_ScreenPrintTeamHallRecruitmentList(RawData, Filters)
    end
    if Callback then
      Callback(ret, RawData)
    end
  end
  
  self:CallServer("RefreshTeamHallList", cb, Filters)
end

function Component:PublishRecruitmentInTeamHall(Callback, RecruitmentInfo, Complete)
  assert(RecruitmentInfo)
  self:_GreenPrintTeamHallRpc("PublishRecruitmentInTeamHall.Request", RecruitmentInfo)
  local bCompleted = false
  
  local function cb(ret)
    if bCompleted then
      return
    end
    bCompleted = true
    self:_GreenPrintTeamHallRpc("PublishRecruitmentInTeamHall.Response", {Ret = ret, RecruitmentInfo = RecruitmentInfo})
    local bSuccess = ErrorCode:Check(ret)
    if not bSuccess then
      if Complete then
        Complete(false, ret)
      end
      return
    end
    if Callback then
      Callback()
    end
    if Complete then
      Complete(true, ret)
    end
  end
  
  RecruitmentInfo.Tags = RecruitmentInfo.Tags or {}
  self:CallServer("PublishRecruitmentInTeamHall", cb, RecruitmentInfo)
  return true
end

function Component:CancelRecruitmentInTeamHall(Callback)
  self:_GreenPrintTeamHallRpc("CancelRecruitmentInTeamHall.Request", {})
  
  local function cb(ret)
    self:_GreenPrintTeamHallRpc("CancelRecruitmentInTeamHall.Response", {Ret = ret})
    if not ErrorCode:Check(ret) then
      return
    end
    if Callback then
      Callback()
    end
  end
  
  self:CallServer("CancelRecruitmentInTeamHall", cb)
end

function Component:NotifyTeamRequestReceived(TeamJoinInfo)
  self:_GreenPrintTeamHallRpc("NotifyTeamRequestReceived", TeamJoinInfo)
  self:_TryCallTeamHallController("OnTeamRequestReceived", TeamJoinInfo)
end

function Component:NotifyOnApprovalTeamRequest(bAgree, Uid)
  self:_GreenPrintTeamHallRpc("NotifyOnApprovalTeamRequest", {bAgree = bAgree, Uid = Uid})
  self:_TryCallTeamHallController("OnTeamRequestHandled", Uid, bAgree)
end

function Component:_ScreenPrintTeamHallRecruitmentList(RawData, Filters)
  if not IsTeamHallListSummaryLogEnabled() then
    return
  end
  local HallData = TeamHallDatas.TeamHallData.New(RawData or {})
  local RecruitmentList = HallData:GetRecruitmentList()
  local MaxPrintCount = math.min(#RecruitmentList, 10)
  MiscUtils.GreenPrint(string.format("TeamHallList success: Count=%d FilterCount=%d Filters=%s", #RecruitmentList, #(Filters or {}), table.concat(Filters or {}, ",")))
  for Index = 1, MaxPrintCount do
    local RecruitmentData = RecruitmentList[Index]
    local MemberCount = RecruitmentData.Members and #RecruitmentData.Members or 0
    MiscUtils.GreenPrint(string.format("[%d] Id=%s First=%s Second=%s Level=%s Members=%d", Index, tostring(RecruitmentData.RecruitmentId), tostring(RecruitmentData.FirstType), tostring(RecruitmentData.SecondType), tostring(RecruitmentData.DungeonLevel), MemberCount))
  end
  if MaxPrintCount < #RecruitmentList then
    MiscUtils.GreenPrint(string.format("... %d more recruitments", #RecruitmentList - MaxPrintCount))
  end
end

function Component:_TryCallTeamHallController(FuncName, ...)
  local Args = {
    ...
  }
  local bSuccess, Err = pcall(function()
    local Func = TeamHallController and TeamHallController[FuncName]
    if Func then
      Func(TeamHallController, table.unpack(Args))
    end
  end)
  if not bSuccess and ScreenPrint then
    ScreenPrint("TeamHallController " .. tostring(FuncName) .. " failed: " .. tostring(Err))
  end
end

return Component
