local MiscUtils = require("Utils.MiscUtils")
local M = {}
local NoBreakLinePunctuations = ",.?;~!%，、。；：？！·)]}〉》」』】〕〗）”’"
local OpenBracketPunctuations = "([{〈《「『【〔〖（“‘"
local EllipsisAndDash = "—…"

function M.CalcRichTextSize(CalcWidget, Text)
  if not CalcWidget or not CalcWidget.SetText then
    return FVector2D(0, 0)
  end
  CalcWidget:SetText(Text or "")
  if CalcWidget.ForceLayoutPrepass then
    CalcWidget:ForceLayoutPrepass()
  end
  if CalcWidget.GetDesiredSize then
    return CalcWidget:GetDesiredSize()
  end
  return FVector2D(0, 0)
end

local function AssignPunctuation(LeftText, RightText)
  local RightLength = UE4.UKismetStringLibrary.Len(RightText)
  if RightLength <= 0 then
    return LeftText, RightText
  end
  local LeftLength = UE4.UKismetStringLibrary.Len(LeftText)
  local LeftLastChar = UE4.UKismetStringLibrary.GetSubstring(LeftText, LeftLength - 1, 1)
  if string.find(OpenBracketPunctuations, LeftLastChar, 1, true) then
    LeftText = UE4.UKismetStringLibrary.GetSubstring(LeftText, 0, LeftLength - 1)
    RightText = LeftLastChar .. RightText
    return LeftText, RightText
  end
  local RightFirstChar = UE4.UKismetStringLibrary.GetSubstring(RightText, 0, 1)
  if string.find(EllipsisAndDash, RightFirstChar, 1, true) then
    for Index = LeftLength - 1, 1, -1 do
      local LeftChar = UE4.UKismetStringLibrary.GetSubstring(LeftText, Index, 1)
      if not string.find(EllipsisAndDash, LeftChar, 1, true) and not string.find(NoBreakLinePunctuations, LeftChar, 1, true) then
        RightText = UE4.UKismetStringLibrary.GetSubstring(LeftText, Index, LeftLength) .. RightText
        LeftText = UE4.UKismetStringLibrary.GetSubstring(LeftText, 0, Index)
        break
      end
    end
    return LeftText, RightText
  end
  local PunctuationCount = 0
  local PunctuationText = ""
  local CurrentChar = RightFirstChar
  repeat
    if not ("" ~= CurrentChar and string.find(NoBreakLinePunctuations, CurrentChar, 1, true)) then
      break
    end
    PunctuationCount = PunctuationCount + 1
    PunctuationText = PunctuationText .. CurrentChar
    if not (PunctuationCount > 2) then
      CurrentChar = UE4.UKismetStringLibrary.GetSubstring(RightText, PunctuationCount, 1)
    else
      break
    end
  until RightLength < PunctuationCount
  if PunctuationCount > 2 then
    for Index = LeftLength, 1, -1 do
      local LeftChar = UE4.UKismetStringLibrary.GetSubstring(LeftText, Index, 1)
      if not string.find(NoBreakLinePunctuations, LeftChar, 1, true) then
        RightText = UE4.UKismetStringLibrary.GetSubstring(LeftText, Index, LeftLength) .. RightText
        LeftText = UE4.UKismetStringLibrary.GetSubstring(LeftText, 0, Index)
        return LeftText, RightText
      end
    end
  end
  LeftText = LeftText .. PunctuationText
  RightText = UE4.UKismetStringLibrary.GetSubstring(RightText, PunctuationCount, RightLength)
  return LeftText, RightText
end

local function CanSplitByCharacter(Word)
  if MiscUtils.IsSingleByteWord(Word) then
    return false
  end
  local SystemLanguage = CommonConst.SystemLanguage
  return SystemLanguage == CommonConst.SystemLanguages.CN or SystemLanguage == CommonConst.SystemLanguages.JP or SystemLanguage == CommonConst.SystemLanguages.TC
end

local function SplitSegmentByWidth(CalcWidget, SegmentText, MaxLineWidth)
  if not SegmentText or "" == SegmentText then
    return "", nil
  end
  local SegmentSize = M.CalcRichTextSize(CalcWidget, SegmentText)
  if MaxLineWidth >= (SegmentSize.X or 0) then
    return SegmentText, nil
  end
  local Words = Utils.Split(SegmentText, " ")
  if 0 == #Words then
    Words = {SegmentText}
  end
  local RemainWidth = MaxLineWidth
  local LeftText = ""
  local SpaceWidth = M.CalcRichTextSize(CalcWidget, " ").X or 0
  local RightText
  for _, Word in ipairs(Words) do
    local WordWidth = M.CalcRichTextSize(CalcWidget, Word).X or 0
    if RemainWidth >= WordWidth then
      RemainWidth = RemainWidth - WordWidth - SpaceWidth
      LeftText = LeftText .. Word .. " "
    else
      if CanSplitByCharacter(Word) then
        do
          local WordLength = UE4.UKismetStringLibrary.Len(Word)
          local LeftBound = 0
          local MidBound = 0
          local RightBound = WordLength
          local LeftWord = ""
          while LeftBound < RightBound do
            local MidCandidate = math.floor((RightBound - LeftBound) / 2) + LeftBound
            if MidCandidate == MidBound then
              break
            end
            MidBound = MidCandidate
            LeftWord = UE4.UKismetStringLibrary.GetSubstring(Word, 0, MidBound)
            local LeftWordWidth = M.CalcRichTextSize(CalcWidget, LeftWord).X or 0
            if RemainWidth > LeftWordWidth then
              LeftBound = MidBound
            else
              RightBound = MidBound
            end
          end
          LeftText = LeftText .. LeftWord
          RightText = string.sub(SegmentText, #LeftText + 1, #SegmentText)
          LeftText, RightText = AssignPunctuation(LeftText, RightText or "")
          LeftText = LeftText .. " "
          if "" == RightText then
            RightText = nil
          end
        end
        break
      end
      if "" == LeftText then
        LeftText = Word
        RightText = string.sub(SegmentText, #LeftText + 1, #SegmentText)
        if "" == RightText then
          RightText = nil
        end
        break
      end
      RightText = string.sub(SegmentText, #LeftText + 1, #SegmentText)
      break
    end
  end
  LeftText = string.gsub(LeftText, "%s+$", "")
  RightText = RightText and string.gsub(RightText, "^%s+", "")
  if "" == LeftText and RightText then
    return RightText, nil
  end
  return LeftText, RightText
end

function M.SplitDescTextToLines(CalcWidget, DescText, MaxLineWidth)
  local LineTexts = {}
  if not DescText or "" == DescText then
    return LineTexts
  end
  if not MaxLineWidth or MaxLineWidth <= 0 then
    table.insert(LineTexts, DescText)
    return LineTexts
  end
  local Paragraphs = UE4.UKismetStringLibrary.ParseIntoArray(DescText, "\n")
  local bHasParagraph = false
  for _, ParagraphText in pairs(Paragraphs) do
    bHasParagraph = true
    local RemainText = ParagraphText
    if "" == RemainText then
      table.insert(LineTexts, "")
    else
      while RemainText do
        local LeftText, RightText = SplitSegmentByWidth(CalcWidget, RemainText, MaxLineWidth)
        table.insert(LineTexts, LeftText or "")
        RemainText = RightText
      end
    end
  end
  if not bHasParagraph then
    table.insert(LineTexts, DescText)
  end
  return LineTexts
end

return M
