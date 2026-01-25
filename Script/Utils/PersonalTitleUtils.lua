local PersonalTitleUtils = {}

function PersonalTitleUtils.GetTitleName(TitleId)
  local TitleData = DataMgr.Title
  local Title = TitleData[TitleId]
  return Title and GText(Title.Name)
end

function PersonalTitleUtils.GetTitleContent(PrefixId, SuffixId)
  local PrefixTitle = PersonalTitleUtils.GetTitleName(PrefixId)
  local SuffixTitle = PersonalTitleUtils.GetTitleName(SuffixId)
  return (PrefixTitle or " ") .. (SuffixTitle or " ")
end

function PersonalTitleUtils.GetTitleFramePath(TitleFrameId)
  local TitleFrame = DataMgr.TitleFrame[TitleFrameId]
  if TitleFrame then
    if TitleFrame.FramePath then
      return TitleFrame.FramePath
    else
      DebugPrint(ErrorTag, "当前TitleFrameId FramePath为空", TitleFrameId)
    end
  else
    DebugPrint(ErrorTag, "不存在当前TitleFrameId", TitleFrameId)
  end
end

return PersonalTitleUtils
