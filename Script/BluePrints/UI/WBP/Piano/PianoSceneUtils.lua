require("DataMgr")
local EMCache = require("EMCache.EMCache")
local PianoSceneUtils = {}
PianoSceneUtils.HOME_SCENE_ICON = "/Game/UI/Texture/Dynamic/Image/Piano/T_Piano_LevelSelect_00.T_Piano_LevelSelect_00"
PianoSceneUtils.CACHE_DUNGEON_BGM_DISABLED = "PianoSystem_DungeonBgmDisabledChapters"
PianoSceneUtils.CACHE_CHAPTER_CUSTOM_BGM = "PianoSystem_ChapterCustomBGM"
local WarnedMissingDungeonTypes = {}

function PianoSceneUtils.NormalizeChapterId(ChapterId)
  if nil == ChapterId or "" == ChapterId then
    return nil
  end
  if type(ChapterId) == "string" then
    ChapterId = tonumber(ChapterId)
  end
  if nil == ChapterId or 0 == ChapterId then
    return nil
  end
  return ChapterId
end

function PianoSceneUtils.IsHomeSceneId(ChapterId)
  return PianoSceneUtils.NormalizeChapterId(ChapterId) == nil
end

function PianoSceneUtils.IsSameSceneId(SceneIdA, SceneIdB)
  return PianoSceneUtils.NormalizeChapterId(SceneIdA) == PianoSceneUtils.NormalizeChapterId(SceneIdB)
end

function PianoSceneUtils.GetHomeSceneDisplayName()
  return GText("UI_SUBREGION_NAME_210101")
end

function PianoSceneUtils.GetDungeonTypeKeyByChapterId(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[ChapterId]
  if not (ChapterCfg and ChapterCfg.DungeonList) or not ChapterCfg.DungeonList[1] then
    return nil
  end
  local DungeonId = ChapterCfg.DungeonList[1]
  local DungeonCfg = DataMgr.Dungeon[DungeonId]
  return DungeonCfg and DungeonCfg.DungeonType
end

function PianoSceneUtils.GetDungeonTypeCfgByChapterId(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  local TypeKey = ChapterId and PianoSceneUtils.GetDungeonTypeKeyByChapterId(ChapterId)
  if not TypeKey then
    return nil
  end
  local TypeCfg = DataMgr.DungeonType and DataMgr.DungeonType[TypeKey]
  if not TypeCfg then
    local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[ChapterId]
    local DungeonId = ChapterCfg and ChapterCfg.DungeonList and ChapterCfg.DungeonList[1]
    local WarnKey = tostring(ChapterId) .. ":" .. TypeKey
    if not WarnedMissingDungeonTypes[WarnKey] then
      WarnedMissingDungeonTypes[WarnKey] = true
      DebugPrint(string.format("Piano: DungeonType 未配置, ChapterId=%s, DungeonId=%s, DungeonType=%s", tostring(ChapterId), tostring(DungeonId), TypeKey))
    end
    return nil
  end
  return TypeCfg
end

function PianoSceneUtils.IsChapterAvailableInPianoScene(ChapterId)
  return PianoSceneUtils.GetDungeonTypeCfgByChapterId(ChapterId) ~= nil
end

function PianoSceneUtils.CollectPianoSceneChapters()
  local Chapters = {}
  for ChapterId, ChapterCfg in pairs(DataMgr.SelectDungeon or {}) do
    if PianoSceneUtils.IsChapterAvailableInPianoScene(ChapterId) then
      local DungeonType = PianoSceneUtils.GetDungeonTypeKeyByChapterId(ChapterId)
      if DungeonType then
        Chapters[#Chapters + 1] = {
          ChapterId = ChapterId,
          Sequence = ChapterCfg.Sequence or 0,
          DungeonType = DungeonType,
          Condition = ChapterCfg.Condition
        }
      end
    end
  end
  table.sort(Chapters, function(A, B)
    if A.Sequence ~= B.Sequence then
      return A.Sequence < B.Sequence
    end
    return A.ChapterId < B.ChapterId
  end)
  local Result = {}
  local GroupIndexByType = {}
  for _, ChapterInfo in ipairs(Chapters) do
    local GroupIndex = GroupIndexByType[ChapterInfo.DungeonType]
    if not GroupIndex then
      GroupIndex = #Result + 1
      GroupIndexByType[ChapterInfo.DungeonType] = GroupIndex
      Result[GroupIndex] = {
        ChapterId = ChapterInfo.ChapterId,
        Sequence = ChapterInfo.Sequence,
        DungeonType = ChapterInfo.DungeonType,
        SourceChapters = {}
      }
    end
    local SourceChapters = Result[GroupIndex].SourceChapters
    SourceChapters[#SourceChapters + 1] = {
      ChapterId = ChapterInfo.ChapterId,
      Condition = ChapterInfo.Condition
    }
  end
  return Result
end

function PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  local DungeonType = PianoSceneUtils.GetDungeonTypeKeyByChapterId(ChapterId)
  if not DungeonType then
    return ChapterId
  end
  for _, ChapterInfo in ipairs(PianoSceneUtils.CollectPianoSceneChapters()) do
    if ChapterInfo.DungeonType == DungeonType then
      return ChapterInfo.ChapterId
    end
  end
  return ChapterId
end

function PianoSceneUtils.ResolvePianoSceneDisplayChapterId(ChapterId)
  ChapterId = PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  local DungeonType = PianoSceneUtils.GetDungeonTypeKeyByChapterId(ChapterId)
  if "Defence" ~= DungeonType then
    return ChapterId
  end
  for _, ChapterInfo in ipairs(PianoSceneUtils.CollectPianoSceneChapters()) do
    if ChapterInfo.DungeonType == DungeonType then
      for _, Source in ipairs(ChapterInfo.SourceChapters or {}) do
        local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[Source.ChapterId]
        if ChapterCfg and not ChapterCfg.IronSurvival then
          return Source.ChapterId
        end
      end
      break
    end
  end
  return ChapterId
end

function PianoSceneUtils.IsPianoSceneChapterGroupUnlocked(ChapterGroup)
  local SourceChapters = ChapterGroup and ChapterGroup.SourceChapters
  if not SourceChapters or 0 == #SourceChapters then
    return false
  end
  for _, Source in ipairs(SourceChapters) do
    local Condition = Source.Condition
    if not (Condition and PageJumpUtils) or not PageJumpUtils.CheckDungeonCondition then
      return true
    end
    if PageJumpUtils:CheckDungeonCondition(Condition) then
      return true
    end
  end
  return false
end

function PianoSceneUtils.IsPianoSceneDungeonTypeUnlocked(DungeonType)
  if not DungeonType then
    return true
  end
  for _, ChapterGroup in ipairs(PianoSceneUtils.CollectPianoSceneChapters()) do
    if ChapterGroup.DungeonType == DungeonType then
      return PianoSceneUtils.IsPianoSceneChapterGroupUnlocked(ChapterGroup)
    end
  end
  return false
end

function PianoSceneUtils.GetChapterDisplayNameKey(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  local TypeCfg = ChapterId and PianoSceneUtils.GetDungeonTypeCfgByChapterId(ChapterId)
  return TypeCfg and TypeCfg.Name
end

function PianoSceneUtils.GetChapterThumbPath(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  local TypeCfg = ChapterId and PianoSceneUtils.GetDungeonTypeCfgByChapterId(ChapterId)
  return TypeCfg and TypeCfg.Icon
end

function PianoSceneUtils.GetChapterDetailInfo(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  local TypeCfg = ChapterId and PianoSceneUtils.GetDungeonTypeCfgByChapterId(ChapterId)
  if not TypeCfg then
    return nil, nil, nil
  end
  return TypeCfg.Name, TypeCfg.Desc, TypeCfg.RewardViewId
end

function PianoSceneUtils.LoadDungeonBgmDisabledChapters()
  return EMCache:Get(PianoSceneUtils.CACHE_DUNGEON_BGM_DISABLED, true) or {}
end

function PianoSceneUtils.SaveDungeonBgmDisabledChapters(DisabledChapters)
  EMCache:Set(PianoSceneUtils.CACHE_DUNGEON_BGM_DISABLED, DisabledChapters or {}, true)
end

function PianoSceneUtils.IsDungeonBgmEnabledForChapter(ChapterId, DisabledChapters)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return true
  end
  DisabledChapters = DisabledChapters or PianoSceneUtils.LoadDungeonBgmDisabledChapters()
  return not DisabledChapters[ChapterId] and not DisabledChapters[tostring(ChapterId)]
end

function PianoSceneUtils.GetCanonicalChapterIdByDungeonId(DungeonId)
  if not DungeonId or 0 == DungeonId then
    return nil
  end
  local ChapterId = DataMgr.Dungeon2Select and DataMgr.Dungeon2Select[DungeonId]
  if not ChapterId then
    local ParentDungeonId = DataMgr.Dungeon2SubDungeon and DataMgr.Dungeon2SubDungeon[DungeonId]
    ChapterId = ParentDungeonId and DataMgr.Dungeon2Select and DataMgr.Dungeon2Select[ParentDungeonId]
  end
  return PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(ChapterId)
end

function PianoSceneUtils.ShouldPlayDungeonBGMForDungeonId(DungeonId)
  if not DungeonId or 0 == DungeonId then
    return true
  end
  local ChapterId = PianoSceneUtils.GetCanonicalChapterIdByDungeonId(DungeonId)
  if not ChapterId then
    return true
  end
  return PianoSceneUtils.IsDungeonBgmEnabledForChapter(ChapterId)
end

local function GetChapterCustomMusicIdFromTable(ChapterCustomBGM, ChapterId)
  if not ChapterCustomBGM or not ChapterId then
    return nil
  end
  local MusicId = ChapterCustomBGM[ChapterId]
  if nil == MusicId then
    MusicId = ChapterCustomBGM[tostring(ChapterId)]
  end
  if nil == MusicId then
    return nil
  end
  return MusicId
end

function PianoSceneUtils.LoadChapterCustomBGM()
  return EMCache:Get(PianoSceneUtils.CACHE_CHAPTER_CUSTOM_BGM, true) or {}
end

function PianoSceneUtils.SaveChapterCustomBGM(ChapterCustomBGM)
  EMCache:Set(PianoSceneUtils.CACHE_CHAPTER_CUSTOM_BGM, ChapterCustomBGM or {}, true)
end

function PianoSceneUtils.GetChapterCustomMusicId(ChapterId, ChapterCustomBGM)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  ChapterCustomBGM = ChapterCustomBGM or PianoSceneUtils.LoadChapterCustomBGM()
  return GetChapterCustomMusicIdFromTable(ChapterCustomBGM, ChapterId)
end

function PianoSceneUtils.SetChapterCustomMusicId(ChapterId, MusicId, ChapterCustomBGM)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return
  end
  ChapterCustomBGM = ChapterCustomBGM or PianoSceneUtils.LoadChapterCustomBGM()
  ChapterCustomBGM[ChapterId] = MusicId
  ChapterCustomBGM[tostring(ChapterId)] = nil
  PianoSceneUtils.SaveChapterCustomBGM(ChapterCustomBGM)
end

function PianoSceneUtils.GetDefaultChapterDungeonBgmEvent(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[ChapterId]
  local DungeonId = ChapterCfg and ChapterCfg.DungeonList and ChapterCfg.DungeonList[1]
  local DungeonCfg = DungeonId and DataMgr.Dungeon[DungeonId]
  return DungeonCfg and DungeonCfg.DungeonBGM
end

function PianoSceneUtils.GetEffectiveChapterBgmEvent(ChapterId, ChapterCustomBGM)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return nil
  end
  local MusicId = PianoSceneUtils.GetChapterCustomMusicId(ChapterId, ChapterCustomBGM)
  if MusicId and MusicId > 0 then
    local MusicInfo = DataMgr.Music and DataMgr.Music[MusicId]
    if MusicInfo and MusicInfo.Event then
      return MusicInfo.Event
    end
  end
  return PianoSceneUtils.GetDefaultChapterDungeonBgmEvent(ChapterId)
end

function PianoSceneUtils.PlayEffectiveDungeonBGM(Context, DungeonId)
  if not PianoSceneUtils.ShouldPlayDungeonBGMForDungeonId(DungeonId) then
    AudioManager(Context):PauseDungeonBGM()
    return
  end
  local ChapterId = PianoSceneUtils.GetCanonicalChapterIdByDungeonId(DungeonId)
  local CustomMusicId = PianoSceneUtils.GetChapterCustomMusicId(ChapterId)
  if CustomMusicId and CustomMusicId > 0 then
    local EventPath = PianoSceneUtils.GetEffectiveChapterBgmEvent(ChapterId)
    if EventPath then
      local Original_EventPath = EventPath:gsub("/musicbox", "")
      local bUseOriginal = AudioManager(Context):DoesEventPathIsLoop(Original_EventPath)
      if bUseOriginal then
        EventPath = Original_EventPath
      end
      AudioManager(Context):PlayDungeonBGMWithEvent(EventPath)
      return
    end
  end
  AudioManager(Context):PlayDungeonBGM()
end

return PianoSceneUtils
