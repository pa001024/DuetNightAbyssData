local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local AutoChessShareModel = {}
local CachedAutoChessShareCode

function AutoChessShareModel.CacheAutoChessShareCode(ShareCode, SquadIdx, CostLimit)
  if not ShareCode or "" == ShareCode then
    return nil
  end
  local MsgCopyed = AutoChessShareModel.BuildAutoChessShareDisplayText(SquadIdx)
  CachedAutoChessShareCode = {
    MsgCopyed = MsgCopyed,
    ShareCode = ShareCode,
    SquadIdx = SquadIdx,
    CostLimit = CostLimit
  }
  ULowEntryExtendedStandardLibrary.ClipboardSet(MsgCopyed)
  return CachedAutoChessShareCode
end

function AutoChessShareModel.GetAutoChessShareInfoCopied()
  return CachedAutoChessShareCode
end

function AutoChessShareModel.IsAutoChessShareInfoMsg(InMsgStr)
  local CachedInfo = AutoChessShareModel.GetAutoChessShareInfoCopied()
  if not CachedInfo then
    return false
  end
  return InMsgStr == CachedInfo.MsgCopyed
end

function AutoChessShareModel.GenerateAutoChessShareMsg()
  local CachedInfo = AutoChessShareModel.GetAutoChessShareInfoCopied()
  if not CachedInfo or not CachedInfo.ShareCode then
    return nil
  end
  local Code = table.concat({
    CachedInfo.ShareCode,
    CachedInfo.SquadIdx,
    CachedInfo.CostLimit
  }, "|")
  return ChatCommon.AutoChessShareHeader .. Code
end

function AutoChessShareModel.BuildAutoChessShareDisplayText(SquadIdx)
  local SquadDisplayName = GText(string.format("UI_AutoChess_Lineup%s", SquadIdx))
  local MsgCopyed = string.format(GText("UI_AutoChess_ChallengeMessage"), SquadDisplayName)
  return MsgCopyed
end

function AutoChessShareModel.ParseAutoChessShareMsg(RawText)
  local Content = RawText and string.match(RawText, "^%s*(.-)%s*$") or RawText
  if not Content or "" == Content then
    return nil
  end
  if string.startswith(Content, ChatCommon.AutoChessShareHeader) then
    local ShareCode = string.sub(Content, #ChatCommon.AutoChessShareHeader + 1)
    if ShareCode and "" ~= ShareCode then
      return ShareCode
    end
  end
  return nil
end

function AutoChessShareModel.ClearCache()
  CachedAutoChessShareCode = nil
end

return AutoChessShareModel
