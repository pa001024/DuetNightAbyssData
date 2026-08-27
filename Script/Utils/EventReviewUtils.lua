local EventReviewUtils = {}

function EventReviewUtils:GetPreSequenceId(CurReviewChainSequenceId)
  if not DataMgr.ReviewChain[CurReviewChainSequenceId] then
    return
  end
  return DataMgr.ReviewChainPageId2PreReviewChainSequenceId[CurReviewChainSequenceId] or -1
end

return EventReviewUtils
