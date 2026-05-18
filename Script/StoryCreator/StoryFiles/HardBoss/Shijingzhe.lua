return {
  storyName = "结束剧情",
  storyDescription = "",
  lineData = {
    {
      startStory = "177778519010029999561",
      startPort = "Success",
      endStory = "177778519010029999560",
      endPort = "StoryEnd"
    },
    {
      startStory = "177778519010029999559",
      startPort = "StoryStart",
      endStory = "177778519010029999561",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["177778519010029999559"] = {
      isStoryNode = true,
      key = "177778519010029999559",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 103, y = 138},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177778519010029999560"] = {
      isStoryNode = true,
      key = "177778519010029999560",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 721, y = 176},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177778519010029999561"] = {
      isStoryNode = true,
      key = "177778519010029999561",
      type = "StoryNode",
      name = "开场剧情",
      pos = {x = 378, y = 130},
      propsData = {
        QuestId = 10100,
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177778519010029999562",
            startPort = "QuestStart",
            endQuest = "177778519010029999565",
            endPort = "In"
          },
          {
            startQuest = "177778519010029999565",
            startPort = "Out",
            endQuest = "177778519010029999563",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177778519010029999562"] = {
            key = "177778519010029999562",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 100, y = 140},
            propsData = {ModeType = 0}
          },
          ["177778519010029999563"] = {
            key = "177778519010029999563",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1500, y = 140},
            propsData = {ModeType = 0}
          },
          ["177778519010029999564"] = {
            key = "177778519010029999564",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500, y = 340},
            propsData = {}
          },
          ["177778519010029999565"] = {
            key = "177778519010029999565",
            type = "BossBattleOpenNode",
            name = "BOSS战开场播片",
            pos = {x = 399, y = 129},
            propsData = {
              SequencePath = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Shijingzhe/HardBoss_Shijingzhe_Start.HardBoss_Shijingzhe_Start'",
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
