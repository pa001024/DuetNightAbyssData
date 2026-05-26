local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("QuestUI", {
  [100301] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_01",
    ChapterName = "Episode_02",
    QuestId = 100301,
    Title = "Name_100301",
    UIName = "Chapter_Transition02"
  },
  [100302] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_02",
    ChapterName = "Episode_02",
    QuestId = 100302,
    Title = "Name_100302",
    UIName = "Chapter_Transition02"
  },
  [100303] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_03",
    ChapterName = "Episode_02",
    QuestId = 100303,
    Title = "Name_100303",
    UIName = "Chapter_Transition02"
  },
  [100304] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_04",
    ChapterName = "Episode_02",
    QuestId = 100304,
    Title = "Name_100304",
    UIName = "Chapter_Transition02"
  },
  [100305] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_05",
    ChapterName = "Episode_02",
    QuestId = 100305,
    Title = "Name_100305",
    UIName = "Chapter_Transition02"
  },
  [100306] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_06",
    ChapterName = "Episode_02",
    QuestId = 100306,
    Title = "Name_100306",
    UIName = "Chapter_Transition02"
  },
  [100307] = {
    AudioPath = "event:/ui/common/chapter_2_trans",
    AudioPathFinal = "event:/ui/common/chapter_2_trans",
    CantoName = "Episode_02_07",
    ChapterName = "Episode_02",
    QuestId = 100307,
    Title = "Name_100307",
    UIName = "Chapter_Transition02"
  },
  [100400] = {
    AudioPath = "event:/ui/common/main_quest_start_chapter3",
    AudioPathFinal = "event:/ui/common/main_quest_start_chapter3",
    CantoName = "Episode_03",
    ChapterName = "UI_ChapterName_01",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Region/T_Region_Train.T_Region_Train'",
    QuestId = 100400,
    UIName = "ChapterUI02"
  },
  [100401] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"138", "1"},
    QuestId = 100401,
    UIName = "Chapter_Transition04_02"
  },
  [100402] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"137", "1"},
    QuestId = 100402,
    UIName = "Chapter_Transition04_02"
  },
  [100403] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"136", "1"},
    QuestId = 100403,
    UIName = "Chapter_Transition04_02"
  },
  [100404] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"135", "1"},
    QuestId = 100404,
    UIName = "Chapter_Transition04_02"
  },
  [100405] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"134", "1"},
    QuestId = 100405,
    UIName = "Chapter_Transition04_02"
  },
  [100406] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"13", "1"},
    QuestId = 100406,
    UIName = "Chapter_Transition04_02"
  },
  [100407] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock_scare",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition04",
    Params = {"1", "1"},
    QuestId = 100407,
    UIName = "Chapter_Transition04_02"
  },
  [100408] = {
    AudioPath = "event:/ui/common/chapter_3_trans_clock",
    AudioPathFinal = "event:/ui/common/chapter_3_trans_clock",
    ChapterName = "UI_Chapter03_Transition03",
    Params = {"0", "1"},
    QuestId = 100408,
    UIName = "Chapter_Transition04_02"
  },
  [120101] = {
    AudioPath = "event:/ui/common/main_quest_start",
    AudioPathFinal = "event:/ui/common/main_quest_finish",
    CantoName = "Episode_1200",
    ChapterName = "UI_Quest_ChapterHuaxu",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Region/T_Region_Yanjindu.T_Region_Yanjindu'",
    QuestId = 120101,
    UIName = "ChapterUI"
  },
  [120111] = {
    AudioPath = "event:/ui/activity/feina_day_update",
    AudioPathFinal = "event:/ui/activity/feina_day_update",
    CantoName = "1",
    ChapterName = "Episode_Feina",
    QuestId = 120111,
    Title = "Name_120111",
    UIName = "FeinaChangeScene"
  },
  [120112] = {
    AudioPath = "event:/ui/activity/feina_day_update",
    AudioPathFinal = "event:/ui/activity/feina_day_update",
    CantoName = "2",
    ChapterName = "Episode_Feina",
    QuestId = 120112,
    Title = "Name_120112",
    UIName = "FeinaChangeScene"
  },
  [120113] = {
    AudioPath = "event:/ui/activity/feina_day_update",
    AudioPathFinal = "event:/ui/activity/feina_day_update",
    CantoName = "3",
    ChapterName = "Episode_Feina",
    QuestId = 120113,
    Title = "Name_120113",
    UIName = "FeinaChangeScene"
  },
  [120114] = {
    AudioPath = "event:/ui/activity/feina_day_update",
    AudioPathFinal = "event:/ui/activity/feina_day_update",
    CantoName = "6",
    ChapterName = "Episode_Feina",
    QuestId = 120114,
    Title = "Name_120114",
    UIName = "FeinaChangeScene"
  },
  [120200] = {
    AudioPath = "event:/ui/common/main_quest_start",
    AudioPathFinal = "event:/ui/common/main_quest_finish",
    CantoName = "Episode_1202",
    ChapterName = "UI_Quest_ChapterHuaxu",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Region/T_Region_Haojing.T_Region_Haojing'",
    QuestId = 120200,
    UIName = "ChapterUI"
  },
  [120300] = {
    AudioPath = "event:/ui/common/main_quest_start",
    AudioPathFinal = "event:/ui/common/main_quest_finish",
    CantoName = "Episode_1203",
    ChapterName = "UI_Quest_ChapterHuaxu",
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Region/T_Region_FengXiang.T_Region_FengXiang'",
    QuestId = 120300,
    UIName = "ChapterUI"
  }
})
