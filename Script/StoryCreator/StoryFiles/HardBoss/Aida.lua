return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1785921424396479",
      startPort = "StoryStart",
      endStory = "1785921425486508",
      endPort = "In"
    },
    {
      startStory = "1785921425486508",
      startPort = "Success",
      endStory = "1785921424396482",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1785921424396479"] = {
      isStoryNode = true,
      key = "1785921424396479",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1274, y = 162},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1785921424396482"] = {
      isStoryNode = true,
      key = "1785921424396482",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1919.5, y = 160.5},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1785921425486508"] = {
      isStoryNode = true,
      key = "1785921425486508",
      type = "StoryNode",
      name = "开场剧情",
      pos = {x = 1606, y = 160.00000000000006},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = false,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1785921425486513",
            startPort = "QuestStart",
            endQuest = "1785921425486516",
            endPort = "In"
          },
          {
            startQuest = "1785921425486516",
            startPort = "Out",
            endQuest = "1785921425486514",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1785921425486513"] = {
            key = "1785921425486513",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 100, y = 140},
            propsData = {ModeType = 0}
          },
          ["1785921425486514"] = {
            key = "1785921425486514",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1500, y = 140},
            propsData = {ModeType = 0}
          },
          ["1785921425486515"] = {
            key = "1785921425486515",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500, y = 340},
            propsData = {}
          },
          ["1785921425486516"] = {
            key = "1785921425486516",
            type = "BossBattleOpenNode",
            name = "BOSS战开场播片",
            pos = {x = 399, y = 129},
            propsData = {
              SequencePath = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_aida/HardBoss_aida_Start.HardBoss_aida_Start'",
              EnableFadeIn = true,
              EnableFadeOut = true,
              EnableSkip = false,
              PauseGameGlobal = true,
              HideNpcs = true,
              HideMonsters = true
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
