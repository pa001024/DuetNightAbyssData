require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function formatYMD(time, useServerTimezone)
  if nil == time then
    return nil
  end
  if type(time) == "table" and time.GetTime then
    time = time:GetTime()
  end
  if type(time) ~= "number" then
    return nil
  end
  if nil == useServerTimezone then
    useServerTimezone = true
  end
  local d = TimeUtils.TimestampToDataObj(time, useServerTimezone)
  if not d then
    return nil
  end
  return string.format("%d/%d/%d", d.year, d.month, d.day)
end

function M:SetTimeText(TextDesc, TimeDict, TimeIconPath)
  self.Text_TimeTitle:SetText(TextDesc)
  local FinalResult = ""
  if TimeDict then
    for TimeCount, ThisTimeInfo in ipairs(TimeDict) do
      if TimeCount > 2 then
        DebugPrint("WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
        break
      end
      FinalResult = string.format("%s%02d%s", FinalResult, ThisTimeInfo.TimeValue, GText("UI_GameEvent_TimeRemain_" .. ThisTimeInfo.TimeType))
    end
  else
    FinalResult = "-"
  end
  self.Text_TimeDesc:SetText(FinalResult)
  if nil ~= TimeIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {
      self,
      M.OnIconLoadFinished
    })
  end
end

function M:SetPeriodTimeText(TextDesc, StartTime, EndTime, TimeIconPath, UseServerTimezone)
  if nil == StartTime or nil == EndTime then
    DebugPrint("WBP_Com_Time_CountDown SetPeriodTimeText: StartTime and EndTime are both required, skip set")
    return
  end
  local a = formatYMD(StartTime, UseServerTimezone)
  local b = formatYMD(EndTime, UseServerTimezone)
  if not a or not b then
    DebugPrint("WBP_Com_Time_CountDown SetPeriodTimeText: invalid StartTime or EndTime, skip set")
    return
  end
  self.Text_TimeTitle:SetText(TextDesc)
  self.Text_TimeDesc:SetText(a .. "-" .. b)
  if nil ~= TimeIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {
      self,
      M.OnIconLoadFinished
    })
  end
end

function M:SetEmptyTimeText(TextDesc, TimeStrList, TimeIconPath)
  self.Text_TimeTitle:SetText(TextDesc)
  local FinalResult = ""
  for Index, TimeStr in ipairs(TimeStrList) do
    if Index > 2 then
      DebugPrint("WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
      break
    end
    FinalResult = string.format("%s%s%s", FinalResult, "-", GText("UI_GameEvent_TimeRemain_" .. TimeStr))
  end
  self.Text_TimeDesc:SetText(FinalResult)
  if nil ~= TimeIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {
      self,
      M.OnIconLoadFinished
    })
  end
end

function M:SetForeverTimeText(TextDesc, TimeIconPath)
  self.Text_TimeTitle:SetText(TextDesc)
  self.Text_TimeDesc:SetText(GText("UI_EventTime_Permanent"))
  if nil ~= TimeIconPath then
    UE.UResourceLibrary.LoadObjectAsync(self, TimeIconPath, {
      self,
      M.OnIconLoadFinished
    })
  end
end

function M:OnIconLoadFinished(Object)
  if IsValid(self) then
    self.Image_ClockIcon:SetBrushResourceObject(Object)
  end
end

return M
