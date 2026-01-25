local function CreateWildcardReplaceFunctionMap()
  return {
    ["{性别[:：]+.-|.-}"] = "ReplaceProtagonistGenderWildcard",
    
    ["{性别2[:：]+.-|.-}"] = "ReplaceFormerProtagonistGenderWildcard",
    ["{[Cc]+at[Nn]+ame}"] = "ReplaceCatNameWildcard",
    ["{[Nn]+ick[Nn]+ame}"] = "ReplaceNickNameWildcard",
    ["{[Nn]+ick[Nn]+ame2}"] = "ReplaceNickName2Wildcard",
    ["{%$.-%$|.-}"] = "ReplaceTagWildcard",
    ["{序数[:：]+.-}"] = "ReplaceNumberWildcard",
    ["{空格}"] = "ReplaceSpaceWildcard",
    ["{[Qq]+uest%(.-%):.-|.-}"] = "ReplaceQuestWildcard",
    ["{[Qq]+uest[Cc]+hain%(.-%):.-|.-}"] = "ReplaceQuestChainWildcard"
  }
end

local M = Class()

function M:OnInitialize()
  self.bIsInitialized = true
  self.WildcardReplaceFunctionMap = CreateWildcardReplaceFunctionMap()
end

function M:OnDeinitialize()
  self.bIsInitialized = false
  self.WildcardReplaceFunctionMap = nil
end

function M:Reinitialize()
  self.bIsInitialized = true
  self.WildcardReplaceFunctionMap = CreateWildcardReplaceFunctionMap()
end

function M:ReplaceWildcard(Text)
  if nil == Text then
    return nil
  end
  if not self.bIsInitialized then
    self:Reinitialize()
  end
  local ReplacedText, _ = string.gsub(Text, "{.-}", function(Wildcard)
    for WildcardTypeRegex, Function in pairs(self.WildcardReplaceFunctionMap) do
      if string.match(Wildcard, WildcardTypeRegex) then
        return self[Function](self, Wildcard)
      end
    end
    return Wildcard
  end)
  return ReplacedText
end

function M:ReplaceProtagonistGenderWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return "(未联网)主角性别"
  end
  local LeftValue, RightValue = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
  if 0 == Avatar.Sex then
    return LeftValue
  else
    return RightValue
  end
end

function M:ReplaceFormerProtagonistGenderWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return "(未联网)前主角性别"
  end
  local LeftValue, RightValue = string.match(Wildcard, "{.-[：:]+(.-)|(.-)}")
  if 0 == Avatar.WeitaSex then
    return LeftValue
  else
    return RightValue
  end
end

function M:ReplaceCatNameWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.CatName and Avatar.CatName ~= "" then
    return Avatar.CatName
  end
  return GText("UI_Npc_Name_Mao")
end

function M:ReplaceNickNameWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return "夜航主角名"
  end
  return Avatar.Nickname
end

function M:ReplaceNickName2Wildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return "泊暮主角名"
  end
  return Avatar.WeitaName
end

function M:ReplaceTagWildcard(Wildcard)
  local Tag, KeyStr, ValueStr = string.match(Wildcard, "{%$(.-)%((.-)%)%$|(.+)}")
  if nil == Tag and nil == KeyStr and nil == ValueStr then
    Tag, ValueStr = string.match(Wildcard, "{%$(.-)%$|(.-)}")
  end
  local Values = string.split(string.gsub(ValueStr, " ", ""), ":")
  for idx, Value in pairs(Values) do
    local Rule, Value1, Value2 = string.match(Value, "(.-)%((.-)|(.-)%)")
    if Rule and Value1 and Value2 then
      if "性别" == Rule then
        Values[idx] = self:ReplaceProtagonistGenderWildcard("{性别:" .. Value1 .. "|" .. Value2 .. "}")
      elseif "性别2" == Rule then
        Values[idx] = self:ReplaceFormerProtagonistGenderWildcard("{性别2:" .. Value1 .. "|" .. Value2 .. "}")
      end
    end
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return Wildcard
  end
  local SaveValue = Avatar:GetTalkTag(Tag)
  if KeyStr then
    if nil == SaveValue then
      return Wildcard
    end
    local Keys = string.split(string.gsub(KeyStr, " ", ""), ",")
    for i, Key in ipairs(Keys) do
      local KeyInfo = string.split(Key, "_")
      if DataMgr.TalkTag[Tag][KeyInfo[1]][tonumber(KeyInfo[2])] == SaveValue then
        return Values[i]
      end
    end
  elseif SaveValue then
    return Values[1]
  else
    return Values[2]
  end
  return Wildcard
end

function M:ReplaceNumberWildcard(Wildcard)
  local Number = string.match(Wildcard, "{序数[：:]+(.-)}")
  if CommonConst.SystemLanguage ~= CommonConst.SystemLanguages.EN then
    return Number
  end
  if not tonumber(Number) then
    return Number
  end
  if "11" == Number or "12" == Number or "13" == Number then
    return Number .. "th"
  end
  local LastNumber = string.sub(Number, -1)
  if "1" == LastNumber then
    return Number .. "st"
  elseif "2" == LastNumber then
    return Number .. "nd"
  elseif "3" == LastNumber then
    return Number .. "rd"
  else
    return Number .. "th"
  end
end

function M:ReplaceSpaceWildcard(Wildcard)
  return " "
end

function M:ReplaceQuestWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return Wildcard
  end
  local QuestId, LeftValue, RightValue = string.match(Wildcard, "{[Qq]+uest%((.-)%):(.-)|(.+)}")
  QuestId = tonumber(QuestId)
  if Avatar:IsQuestFinished(QuestId) then
    return LeftValue
  else
    return RightValue
  end
end

function M:ReplaceQuestChainWildcard(Wildcard)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return Wildcard
  end
  local QuestChainId, LeftValue, RightValue = string.match(Wildcard, "{[Qq]+uest[Cc]+hain%((.-)%):(.-)|(.+)}")
  QuestChainId = tonumber(QuestChainId)
  if Avatar:IsQuestChainFinished(QuestChainId) then
    return LeftValue
  else
    return RightValue
  end
end

return M
