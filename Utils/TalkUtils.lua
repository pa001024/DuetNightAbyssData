local TalkUtils = {}

---@param DialogueId string
function TalkUtils:DialogueIdToContent(DialogueId)
    DialogueId = tonumber(DialogueId)

    local DialogueInfo = DataMgr.Dialogue[DialogueId]
    if not DialogueInfo then
        error("DialogueId 在 Dialogue 表中不存在: " .. DialogueId)
    end

    local Content = DialogueInfo.Content
    if CommonConst.SystemLanguage ~= CommonConst.SystemLanguages.Default then
        local ContentLanguage = DialogueInfo[CommonConst.SystemLanguage]
        if ContentLanguage then
            Content = ContentLanguage
        end
    end

    return Content
end

return TalkUtils
