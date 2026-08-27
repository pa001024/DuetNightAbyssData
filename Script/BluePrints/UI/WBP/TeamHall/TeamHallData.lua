local TeamHallPlayerData = Class()

function TeamHallPlayerData.New(RawData)
  local NewObj = {}
  setmetatable(NewObj, TeamHallPlayerData)
  NewObj:SetRawData(RawData)
  return NewObj
end

function TeamHallPlayerData:SetRawData(RawData)
  RawData = RawData or {}
  self.RawData = RawData
  self.Uid = RawData[1]
  self.HeadIconId = RawData[2]
  self.HeadFrameId = RawData[3]
end

local TeamHallRecruitmentData = Class()

function TeamHallRecruitmentData.New(RawData)
  local NewObj = {}
  setmetatable(NewObj, TeamHallRecruitmentData)
  NewObj:SetRawData(RawData)
  return NewObj
end

function TeamHallRecruitmentData:SetRawData(RawData)
  RawData = RawData or {}
  self.RawData = RawData
  self.RecruitmentId = RawData[1]
  self.FirstType = RawData[2]
  self.SecondType = RawData[3]
  self.DungeonLevel = RawData[4] or 0
  self.VisibleType = RawData[5] or {}
  self.Tags = RawData[6] or {}
  self.CustomTags = RawData[7] or {}
  self.TeamIconInfo = RawData[8] or {}
  self.Members = {}
  local MemberList = self.TeamIconInfo
  for _, MemberData in ipairs(MemberList) do
    table.insert(self.Members, TeamHallPlayerData.New(MemberData))
  end
end

local TeamHallData = Class()

function TeamHallData.New(RawData)
  local NewObj = {}
  setmetatable(NewObj, TeamHallData)
  NewObj:SetRawData(RawData)
  return NewObj
end

function TeamHallData:GetRawData()
  return self.RawData
end

function TeamHallData:SetRawData(RawData)
  RawData = RawData or {}
  self.RawData = RawData
  self.RecruitmentList = {}
  for _, RecruitmentData in ipairs(RawData) do
    table.insert(self.RecruitmentList, TeamHallRecruitmentData.New(RecruitmentData))
  end
end

function TeamHallData:GetRecruitmentList()
  return self.RecruitmentList
end

return {
  TeamHallData = TeamHallData,
  TeamHallPlayerData = TeamHallPlayerData,
  TeamHallRecruitmentData = TeamHallRecruitmentData
}
