local TeamHallDatas = require("BluePrints.UI.WBP.TeamHall.TeamHallData")
local TeamHallData = TeamHallDatas.TeamHallData
local table_insert = table.insert
local table_sort = table.sort
local DefaultMaxTeamMemberCount = 3
local M = Class("BluePrints.Common.MVC.Model")
local RecruitAllFirstTypeId = 0
M.RecruitAllFirstTypeId = RecruitAllFirstTypeId

function M:Init()
  M.Super.Init(self)
  self.HallData = nil
  self.LocalRecruitmentInfo = nil
  self.RecruitBoardFilterState = {
    FirstTypeId = nil,
    ItemDatas = {},
    OnlyShowNotFull = false,
    SelectedItems = {}
  }
end

function M:SetRawHallData(RawData)
  self.HallData = TeamHallData.New(RawData)
end

function M:IsRecruiting()
  local Avatar = self:GetAvatar()
  if not Avatar or not Avatar.AvatarStatus then
    return false
  end
  return Avatar:InStatus(nil, CommonConst.AvatarStatus.InTeamHall) and true or false
end

function M:IsTeamInRecruiting()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  if Avatar:InStatus(nil, CommonConst.AvatarStatus.InTeamHall) then
    return true
  end
  local TeamData = TeamController:GetModel():GetTeam()
  if not TeamData or not TeamData.Members then
    return false
  end
  local LeaderId = TeamData:GetLeaderId()
  if not LeaderId or 0 == LeaderId then
    return false
  end
  local LeaderMember
  for _, Member in ipairs(TeamData.Members) do
    if Member.Uid == LeaderId then
      LeaderMember = Member
      break
    end
  end
  if not LeaderMember or not LeaderMember.AvatarStatus then
    return false
  end
  return LeaderMember.AvatarStatus[CommonConst.AvatarStatus.InTeamHall] and true or false
end

function M:BuildDefaultRecruitmentInfo(FirstTypeId)
  local DefaultFirstTypeId = FirstTypeId
  if not DefaultFirstTypeId or DefaultFirstTypeId == RecruitAllFirstTypeId then
    DefaultFirstTypeId = self:_GetDefaultFirstTypeId()
  end
  if not DefaultFirstTypeId then
    return nil
  end
  local DefaultSecondTypeId = self:_GetDefaultSecondTypeId(DefaultFirstTypeId)
  if not DefaultSecondTypeId then
    return nil
  end
  return {
    FirstType = DefaultFirstTypeId,
    SecondType = DefaultSecondTypeId,
    DungeonLevel = self:_GetDefaultDungeonLevel(DefaultSecondTypeId),
    Tags = {}
  }
end

function M:GetHallData()
  return self.HallData
end

function M:GetRecruitSubTabInfoList()
  local AllSubTabInfo = {}
  local TeamFirstType = DataMgr.TeamFirstType or {}
  table_insert(AllSubTabInfo, {
    Text = GText("UI_TeamAllGameModes"),
    TabId = RecruitAllFirstTypeId,
    DisplayOrder = -1
  })
  for FirstTypeId, FirstTypeCfg in pairs(TeamFirstType) do
    if FirstTypeCfg then
      table_insert(AllSubTabInfo, {
        Text = GText(FirstTypeCfg.Name),
        TabId = FirstTypeId,
        DisplayOrder = FirstTypeCfg.DisplayOrder or FirstTypeId
      })
    end
  end
  table_sort(AllSubTabInfo, function(A, B)
    return A.DisplayOrder < B.DisplayOrder
  end)
  return AllSubTabInfo
end

function M:SetLocalRecruitmentInfo(RecruitmentInfo)
  self.LocalRecruitmentInfo = RecruitmentInfo
end

function M:GetLocalRecruitmentInfo()
  return self.LocalRecruitmentInfo
end

function M:HasLocalRecruitmentInfo()
  return self.LocalRecruitmentInfo ~= nil
end

function M:GetRecruitBoardFilterState()
  return self.RecruitBoardFilterState
end

function M:SetRecruitBoardFilterState(FirstTypeId, SelectedItems, ItemDatas, bOnlyShowNotFull)
  self.RecruitBoardFilterState = {
    FirstTypeId = FirstTypeId,
    ItemDatas = ItemDatas or {},
    OnlyShowNotFull = bOnlyShowNotFull and true or false,
    SelectedItems = SelectedItems or {}
  }
end

function M:GetRecruitBoardSiftItemDatas(FirstTypeId)
  local TeamFirstType = DataMgr.TeamFirstType or {}
  local TeamSecondType = DataMgr.TeamSecondType or {}
  if FirstTypeId == RecruitAllFirstTypeId then
    local SortedSecondTypeList = {}
    for SecondTypeId, SecondTypeCfg in pairs(TeamSecondType) do
      if SecondTypeCfg then
        table_insert(SortedSecondTypeList, {
          DisplayOrder = SecondTypeCfg.DisplayOrder or SecondTypeId,
          Name = SecondTypeCfg.Name,
          SecondTypeId = SecondTypeId
        })
      end
    end
    table_sort(SortedSecondTypeList, function(A, B)
      return A.DisplayOrder < B.DisplayOrder
    end)
    local SelectionDatas = {}
    local SelectionText = {}
    for Index, SecondTypeInfo in ipairs(SortedSecondTypeList) do
      SelectionDatas[Index] = SecondTypeInfo.SecondTypeId
      SelectionText[Index] = SecondTypeInfo.Name
    end
    if 0 == #SelectionDatas then
      return {}
    end
    return {
      {
        HasSelectAll = true,
        SelectionDatas = SelectionDatas,
        SelectionText = SelectionText,
        SelectionValueMode = "Value",
        Title = "UI_TeamAllGameModes"
      }
    }
  end
  local FirstTypeCfg = TeamFirstType[FirstTypeId]
  if not FirstTypeCfg then
    return {}
  end
  local SortedSecondTypeList = {}
  for _, SecondTypeId in ipairs(self:_GetSecondTypeIdListByFirstType(FirstTypeId)) do
    local SecondTypeCfg = TeamSecondType[SecondTypeId]
    if SecondTypeCfg then
      table_insert(SortedSecondTypeList, {
        DisplayOrder = SecondTypeCfg.DisplayOrder or SecondTypeId,
        Name = SecondTypeCfg.Name,
        SecondTypeId = SecondTypeId
      })
    end
  end
  table_sort(SortedSecondTypeList, function(A, B)
    return A.DisplayOrder < B.DisplayOrder
  end)
  local SelectionDatas = {}
  local SelectionText = {}
  for Index, SecondTypeInfo in ipairs(SortedSecondTypeList) do
    SelectionDatas[Index] = SecondTypeInfo.SecondTypeId
    SelectionText[Index] = SecondTypeInfo.Name
  end
  if 0 == #SelectionDatas then
    return {}
  end
  return {
    {
      HasSelectAll = true,
      SelectionDatas = SelectionDatas,
      SelectionText = SelectionText,
      SelectionValueMode = "Value",
      Title = FirstTypeCfg.Name
    }
  }
end

function M:BuildRecruitmentRequestFilters(FirstTypeId, DefaultSecondTypeId)
  local SelectedSecondTypeIds = self:_GetSelectedRecruitSecondTypeIds(FirstTypeId)
  if #SelectedSecondTypeIds > 0 then
    return SelectedSecondTypeIds
  end
  if FirstTypeId == RecruitAllFirstTypeId then
    return {}
  end
  if DefaultSecondTypeId then
    return {DefaultSecondTypeId}
  end
  return self:GetTagsByFirsttype(FirstTypeId)
end

function M:IsRecruitmentMatchFilter(RecruitmentData)
  if not RecruitmentData then
    return false
  end
  local FilterState = self:GetRecruitBoardFilterState()
  if not FilterState then
    return true
  end
  local SelectedSecondTypeIds = FilterState.SelectedItems and FilterState.SelectedItems[1] or {}
  local SelectedSecondTypeMap = {}
  for _, SecondTypeId in ipairs(SelectedSecondTypeIds) do
    SelectedSecondTypeMap[SecondTypeId] = true
  end
  local bPassTypeFilter = true
  if next(SelectedSecondTypeMap) then
    bPassTypeFilter = true == SelectedSecondTypeMap[RecruitmentData.SecondType]
  elseif FilterState.FirstTypeId and FilterState.FirstTypeId ~= RecruitAllFirstTypeId then
    bPassTypeFilter = RecruitmentData.FirstType == FilterState.FirstTypeId
  end
  return bPassTypeFilter and (not FilterState.OnlyShowNotFull or not self:IsRecruitmentFull(RecruitmentData))
end

function M:FilterRecruitmentList(RecruitmentList)
  local FilteredList = {}
  for _, RecruitmentData in ipairs(RecruitmentList or {}) do
    if self:IsRecruitmentMatchFilter(RecruitmentData) then
      table_insert(FilteredList, RecruitmentData)
    end
  end
  return FilteredList
end

function M:IsRecruitmentFull(RecruitmentData)
  if not RecruitmentData then
    return false
  end
  local MemberList = RecruitmentData.Members or {}
  local MaxCapacity = self:_GetRecruitFilterMaxCapacity(RecruitmentData.FirstType)
  return MaxCapacity <= #MemberList
end

function M:_GetRecruitFilterMaxCapacity(FirstTypeId)
  if not FirstTypeId then
    return self:_GetRecruitTeamMemberLimit()
  end
  local TeamFirstType = DataMgr.TeamFirstType or {}
  local FirstTypeCfg = TeamFirstType[FirstTypeId]
  if FirstTypeCfg and FirstTypeCfg.FilterMaxCapacity then
    return FirstTypeCfg.FilterMaxCapacity
  end
  return self:_GetRecruitTeamMemberLimit()
end

function M:GetRawHallData()
  return self.HallData and self.HallData:GetRawData() or nil
end

function M:GetTeamRequestList()
  local Avatar = self:GetAvatar()
  return Avatar and Avatar.TeamRequestList or nil
end

function M:GetTagsByFirsttype(FirstTypeId)
  if FirstTypeId == RecruitAllFirstTypeId then
    local TeamSecondType = DataMgr.TeamSecondType or {}
    local AllSecondTypeIds = {}
    for SecondTypeId in pairs(TeamSecondType) do
      table_insert(AllSecondTypeIds, SecondTypeId)
    end
    table_sort(AllSecondTypeIds)
    return AllSecondTypeIds
  end
  return self:_GetSecondTypeIdListByFirstType(FirstTypeId)
end

function M:ClearHallData()
  self.HallData = nil
end

function M:ClearLocalRecruitmentInfo()
  self.LocalRecruitmentInfo = nil
end

function M:Destory()
  self:ClearHallData()
  self:ClearLocalRecruitmentInfo()
  M.Super.Destory(self)
end

function M:_GetSelectedRecruitSecondTypeIds(FirstTypeId)
  local FilterState = self:GetRecruitBoardFilterState()
  if not FilterState or FilterState.FirstTypeId ~= FirstTypeId then
    return {}
  end
  return FilterState.SelectedItems and FilterState.SelectedItems[1] or {}
end

function M:_GetRecruitTeamMemberLimit()
  local GlobalConstant = DataMgr.GlobalConstant or {}
  local MaxTeamMember = GlobalConstant.MaxTeamMember
  return MaxTeamMember and MaxTeamMember.ConstantValue or DefaultMaxTeamMemberCount
end

function M:_GetSecondTypeIdListByFirstType(FirstTypeId)
  local TeamFirstType = DataMgr.TeamFirstType or {}
  local FirstTypeCfg = TeamFirstType[FirstTypeId]
  if not FirstTypeCfg then
    return {}
  end
  if type(FirstTypeCfg.SecondTypes) == "table" then
    return FirstTypeCfg.SecondTypes
  end
  return {}
end

function M:_GetDefaultFirstTypeId()
  local TeamFirstType = DataMgr.TeamFirstType or {}
  local SortedFirstTypeList = {}
  for FirstTypeId, FirstTypeCfg in pairs(TeamFirstType) do
    local SecondTypeList = FirstTypeCfg.SecondTypes
    if SecondTypeList and SecondTypeList[1] then
      table_insert(SortedFirstTypeList, {
        FirstTypeId = FirstTypeId,
        DisplayOrder = FirstTypeCfg.DisplayOrder or FirstTypeId
      })
    end
  end
  table_sort(SortedFirstTypeList, function(A, B)
    return A.DisplayOrder < B.DisplayOrder
  end)
  local DefaultFirstTypeInfo = SortedFirstTypeList[1]
  return DefaultFirstTypeInfo and DefaultFirstTypeInfo.FirstTypeId or nil
end

function M:_GetDefaultSecondTypeId(FirstTypeId)
  local SecondTypeIdList = self:_GetSecondTypeIdListByFirstType(FirstTypeId)
  return SecondTypeIdList[1]
end

function M:_GetDefaultDungeonLevel(SecondTypeId)
  local TeamSecondType = DataMgr.TeamSecondType or {}
  local SecondTypeCfg = TeamSecondType[SecondTypeId]
  local DungeonLevelMap = SecondTypeCfg and SecondTypeCfg.DungeonLevel
  if not DungeonLevelMap then
    return 0
  end
  local DefaultDungeonLevel = 0
  local HighestLevelValue = 0
  for Index, LevelValue in ipairs(DungeonLevelMap) do
    local NumericLevelValue = tonumber(LevelValue) or 0
    if HighestLevelValue < NumericLevelValue then
      HighestLevelValue = NumericLevelValue
      DefaultDungeonLevel = Index
    end
  end
  return DefaultDungeonLevel
end

_G.TeamHallModel = M
return M
