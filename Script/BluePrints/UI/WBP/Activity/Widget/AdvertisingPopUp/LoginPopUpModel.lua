local M = Class("BluePrints.Common.MVC.Model")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:SetLoginSuccess(IsLoginSuccess)
  self.LoginSuccess = IsLoginSuccess
end

function M:LoginPopUpInfo()
  local Avatar = self:GetAvatar()
  if not Avatar then
    return {}
  end
  local LoginPopUpRecords = Avatar.LoginPopUpRecords
  return LoginPopUpRecords or {}
end

function M:CalculateNeedOpenLoginPopUp()
  local ShowPopUp = {}
  local Avatar = self:GetAvatar()
  if not Avatar then
    return ShowPopUp
  end
  if self.LoginSuccess == false then
    return ShowPopUp
  end
  self.LoginSuccess = false
  local UIUnlocked = Avatar:CheckUIUnlocked("AdvertisingPopUp")
  if not UIUnlocked then
    return ShowPopUp
  end
  local LoginPopUp = DataMgr.LoginPopUp or {}
  local CurrentTimeStamp = TimeUtils.NowTime()
  for _, PopInfo in pairs(LoginPopUp) do
    if false == self:CheckIsSetLoginPopUpNoPopSevenDays(PopInfo.PopId) then
      local StartTime = PopInfo.PopStartTime:GetTime()
      local EndTime = PopInfo.PopEndTime:GetTime()
      if CurrentTimeStamp >= StartTime and CurrentTimeStamp <= EndTime and (not PopInfo.EndConditonId or false == ConditionUtils.CheckCondition(Avatar, PopInfo.EndConditonId)) and self:CheckRecordCondition(PopInfo) then
        table.insert(ShowPopUp, PopInfo)
      end
    end
  end
  self.NeedShowPopUp = ShowPopUp
  return ShowPopUp
end

function M:CheckRecordCondition(PopInfo)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  local PopId = PopInfo.PopId
  local LoginPopUpRecords = Avatar.LoginPopUpRecords or {}
  local record = LoginPopUpRecords[PopId]
  if not record then
    return true
  end
  local CurrentTimeStamp = TimeUtils.NowTime()
  local ShowTimes = 0
  if PopInfo.PopCycle == "WEEK" then
    for _, PopTime in pairs(record.PopTimes) do
      if TimeUtils.IsTimestampFromPreviousWeek(PopTime) == false then
        ShowTimes = ShowTimes + 1
      end
    end
  else
    for _, PopTime in pairs(record.PopTimes) do
      if 0 == TimeUtils.GetIntervalDay(PopTime, CurrentTimeStamp, TimeUtils.RefreshHMS) then
        ShowTimes = ShowTimes + 1
      end
    end
  end
  return ShowTimes < PopInfo.PopTimePerCycle
end

function M:GetNeedOpenLoginPopUp()
  return self.NeedShowPopUp or self:CalculateNeedOpenLoginPopUp()
end

function M:CheckIsSetLoginPopUpNoPopSevenDays(PopId)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return false
  end
  local LoginPopUpNoPopSevenDaysExpireTime = Avatar.LoginPopUpNoPopSevenDaysExpireTime or {}
  if not LoginPopUpNoPopSevenDaysExpireTime[PopId] then
    return false
  end
  local CurrentTimeStamp = TimeUtils.NowTime()
  return CurrentTimeStamp < LoginPopUpNoPopSevenDaysExpireTime[PopId]
end

function M:UpdateLoginPopUpRecord(PopId, CallBack)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:UpdateLoginPopUpRecord(PopId, CallBack)
end

function M:SetLoginPopUpNoPopSevenDays(NoPopSevenDays, PopIds, CallBack)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:SetLoginPopUpNoPopSevenDays(NoPopSevenDays, PopIds, CallBack)
end

return M
