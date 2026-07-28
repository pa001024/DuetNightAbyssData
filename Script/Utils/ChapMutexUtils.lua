local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local ChapMutexUtils = {}

function ChapMutexUtils.ShowChooseChapterPopup(ChapterIdList, OnChoose, OnCancel, ParentWidget)
  if not ChapterIdList then
    if OnCancel then
      OnCancel()
    end
    return
  end
  local UIManager = UIManager(GWorld.GameInstance)
  if not UIManager then
    if OnCancel then
      OnCancel()
    end
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    if OnCancel then
      OnCancel()
    end
    return
  end
  local QuestList = {}
  local QuestME = DataMgr.QuestMutualExclusion
  for _, ChapId in ipairs(ChapterIdList) do
    local QuestChainId = QuestME[ChapId] and QuestME[ChapId].QuestChainId
    local ShowChainId
    if QuestChainId then
      for i, Id in ipairs(QuestChainId) do
        if Avatar.QuestChains[Id] and Avatar.QuestChains[Id]:IsStop() then
          ShowChainId = Id
          goto lbl_64
        end
      end
      ::lbl_64::
      if ShowChainId then
        QuestList[ChapId] = ShowChainId
      end
    end
  end
  if CommonUtils.Size(QuestList) <= 0 then
    if OnCancel then
      OnCancel()
    end
    return
  end
  if 1 == CommonUtils.Size(QuestList) then
    if OnChoose then
      for ChapId, v in pairs(QuestList) do
        OnChoose(ChapId)
        break
      end
    end
    return
  end
  local Params = {
    QuestList = QuestList,
    LeftCallbackFunction = function()
      if OnCancel then
        OnCancel()
      end
    end,
    RightCallbackFunction = function()
      if OnChoose then
        OnChoose(TaskUtils:GetAndClearChooseCharId())
      end
    end
  }
  UIManager:ShowCommonPopupUI(100356, Params, ParentWidget)
end

function ChapMutexUtils.BuildTaskKey(NeedUnlockChapterIdList)
  if not NeedUnlockChapterIdList or #NeedUnlockChapterIdList <= 0 then
    return nil
  end
  local UniqueSet = {}
  local Normalized = {}
  for _, ChapterId in ipairs(NeedUnlockChapterIdList) do
    if type(ChapterId) == "number" and ChapterId > 0 and not UniqueSet[ChapterId] then
      UniqueSet[ChapterId] = true
      table.insert(Normalized, ChapterId)
    end
  end
  if #Normalized <= 0 then
    return nil
  end
  table.sort(Normalized)
  return table.concat(Normalized, ",")
end

function ChapMutexUtils.NormalizeTaskList(NeedUnlockChapterIdList)
  local Key = ChapMutexUtils.BuildTaskKey(NeedUnlockChapterIdList)
  if not Key then
    return nil, nil
  end
  local Normalized = {}
  for ChapterIdStr in string.gmatch(Key, "([^,]+)") do
    table.insert(Normalized, tonumber(ChapterIdStr))
  end
  return Key, Normalized
end

function ChapMutexUtils.CollectUnlockCandidates(Avatar)
  if not Avatar or not Avatar.QuestChapters then
    return {}
  end
  local Candidates = {}
  for ChapterId, Chapter in pairs(Avatar.QuestChapters) do
    DebugPrint("CollectUnlockCandidates: ChapterState", ChapterId, Chapter.State)
    if Chapter and Chapter.State == CommonConst.QuestChapterState.Lock then
      local HasDoingConflict = false
      for _, MEChapId in ipairs(Chapter.MEChapId or {}) do
        local MEChapter = Avatar.QuestChapters[MEChapId]
        if MEChapter and MEChapter.State == CommonConst.QuestChapterState.Doing then
          DebugPrint("CollectUnlockCandidates: HasDoingConflict", ChapterId)
          HasDoingConflict = true
          break
        end
      end
      if not HasDoingConflict then
        table.insert(Candidates, ChapterId)
      end
    end
  end
  table.sort(Candidates)
  return Candidates
end

function ChapMutexUtils.FilterGroupByExternalDoing(Avatar, ChapterIdList)
  if not (Avatar and Avatar.QuestChapters and ChapterIdList) or #ChapterIdList <= 0 then
    return {}
  end
  local ChapterIdSet = {}
  for _, ChapId in ipairs(ChapterIdList) do
    ChapterIdSet[ChapId] = true
  end
  local Filtered = {}
  for _, ChapId in ipairs(ChapterIdList) do
    local IsBlockedByExternalDoing = false
    local Chapter = Avatar.QuestChapters[ChapId]
    for _, MEChapId in ipairs(Chapter and Chapter.MEChapId or {}) do
      if not ChapterIdSet[MEChapId] then
        local MEChapter = Avatar.QuestChapters[MEChapId]
        if MEChapter and MEChapter.State == CommonConst.QuestChapterState.Doing then
          IsBlockedByExternalDoing = true
          break
        end
      end
    end
    if not IsBlockedByExternalDoing then
      table.insert(Filtered, ChapId)
    end
  end
  table.sort(Filtered)
  return Filtered
end

function ChapMutexUtils.BuildUnlockGroup(Avatar)
  if not Avatar or not Avatar.QuestChapters then
    return nil
  end
  local Candidates = ChapMutexUtils.CollectUnlockCandidates(Avatar)
  DebugPrint("BuildUnlockGroup: Candidates", #Candidates)
  if #Candidates <= 0 then
    return nil
  end
  local CandidateSet = {}
  for _, ChapterId in ipairs(Candidates) do
    CandidateSet[ChapterId] = true
  end
  for _, ChapterId in ipairs(Candidates) do
    local Chapter = Avatar.QuestChapters[ChapterId]
    local Group = {ChapterId}
    local GroupSet = {
      [ChapterId] = true
    }
    for _, MEChapId in ipairs(Chapter and Chapter.MEChapId or {}) do
      if CandidateSet[MEChapId] and not GroupSet[MEChapId] then
        GroupSet[MEChapId] = true
        table.insert(Group, MEChapId)
      end
    end
    local FilteredGroup = ChapMutexUtils.FilterGroupByExternalDoing(Avatar, Group)
    if #FilteredGroup >= 1 then
      return FilteredGroup
    end
  end
  return ChapMutexUtils.FilterGroupByExternalDoing(Avatar, {
    Candidates[1]
  })
end

return ChapMutexUtils
