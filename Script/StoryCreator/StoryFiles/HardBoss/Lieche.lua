return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17785758295102355",
      startPort = "StoryStart",
      endStory = "17785758304242385",
      endPort = "In"
    },
    {
      startStory = "17785758304242385",
      startPort = "Success",
      endStory = "17785758295102358",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17785758295102355"] = {
      isStoryNode = true,
      key = "17785758295102355",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17785758295102358"] = {
      isStoryNode = true,
      key = "17785758295102358",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1502.1052631578946, y = 271.5789473684211},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17785758304242385"] = {
      isStoryNode = true,
      key = "17785758304242385",
      type = "StoryNode",
      name = "开场剧情",
      pos = {x = 1154.3157894736842, y = 288.3157894736842},
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
            startQuest = "17785758304242392",
            startPort = "QuestStart",
            endQuest = "17785758304242395",
            endPort = "In"
          },
          {
            startQuest = "17785758304242395",
            startPort = "Out",
            endQuest = "17785758304242393",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17785758304242392"] = {
            key = "17785758304242392",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 100, y = 140},
            propsData = {ModeType = 0}
          },
          ["17785758304242393"] = {
            key = "17785758304242393",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1500, y = 140},
            propsData = {ModeType = 0}
          },
          ["17785758304242394"] = {
            key = "17785758304242394",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500, y = 340},
            propsData = {}
          },
          ["17785758304242395"] = {
            key = "17785758304242395",
            type = "BossBattleOpenNode",
            name = "BOSS战开场播片",
            pos = {x = 399, y = 129},
            propsData = {
              SequencePath = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Lieche/HardBoss_Lieche_Start.HardBoss_Lieche_Start'",
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
