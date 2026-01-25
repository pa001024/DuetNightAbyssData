local Utils = require("Utils")
local DaysOrdinal = {
  "1st",
  "2nd",
  "3rd",
  "4th",
  "5th",
  "6th",
  "7th",
  "8th",
  "9th",
  "10th",
  "11th",
  "12th",
  "13th",
  "14th",
  "15th",
  "16th",
  "17th",
  "18th",
  "19th",
  "20th",
  "21st",
  "22nd",
  "23rd",
  "24th",
  "25th",
  "26th",
  "27th",
  "28th",
  "29th",
  "30th",
  "31st"
}

local function Process_e(str, number)
  return tostring(DaysOrdinal[number])
end

function Utils.GDate(DateFormatID, Time, Language)
  local OsTime = os.time()
  if Time then
    Time.Year = Time.Year or 2016
    Time.Month = Time.Month or 1
    Time.Day = Time.Day or 1
    OsTime = os.time({
      year = Time.Year,
      month = Time.Month,
      day = Time.Day
    })
  end
  Time = os.date("*t", OsTime)
  local Format = DataMgr.DateFormat[DateFormatID]
  if not Format then
    return
  end
  Language = Language or CommonConst.SystemLanguage
  if Language == CommonConst.SystemLanguages.CN or Language == CommonConst.SystemLanguages.TC then
    Format = Format.FormatCN
  elseif Language == CommonConst.SystemLanguages.EN then
    Format = Format.FormatEN
  elseif Language == CommonConst.SystemLanguages.JP then
    Format = Format.FormatJP
  elseif Language == CommonConst.SystemLanguages.KR then
    Format = Format.FormatKR
  else
    DebugPrint("Tianyi@ 找不到对应的DateFormat格式，默认以英文形式给出")
    Format = Format.FormatEN
  end
  Format = Format.gsub(Format, "(%%e+)", function(s)
    return Process_e(s, Time.day)
  end)
  if Format then
    return os.date(Format, OsTime)
  end
  return nil
end

return Utils
