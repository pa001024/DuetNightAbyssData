return {
  storyName = "结束剧情",
  storyDescription = "",
  lineData = {
    {
      startStory = "1773299930697949358",
      startPort = "Success",
      endStory = "1773299930697949357",
      endPort = "StoryEnd"
    },
    {
      startStory = "1773299930697949356",
      startPort = "StoryStart",
      endStory = "1773299930697949358",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["1773299930697949356"] = {
      isStoryNode = true,
      key = "1773299930697949356",
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
    ["1773299930697949357"] = {
      isStoryNode = true,
      key = "1773299930697949357",
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
    ["1773299930697949358"] = {
      isStoryNode = true,
      key = "1773299930697949358",
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
            startQuest = "1773299930697949359",
            startPort = "QuestStart",
            endQuest = "1773299930697949362",
            endPort = "In"
          },
          {
            startQuest = "1773299930697949362",
            startPort = "Out",
            endQuest = "1773299930697949360",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1773299930697949359"] = {
            key = "1773299930697949359",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 100, y = 140},
            propsData = {ModeType = 0}
          },
          ["1773299930697949360"] = {
            key = "1773299930697949360",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1500, y = 140},
            propsData = {ModeType = 0}
          },
          ["1773299930697949361"] = {
            key = "1773299930697949361",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500, y = 340},
            propsData = {}
          },
          ["1773299930697949362"] = {
            key = "1773299930697949362",
            type = "BossBattleOpenNode",
            name = "BOSS战开场播片",
            pos = {x = 399, y = 129},
            propsData = {
              SequencePath = "LevelSequence'/Game/Asset/Cinematics/SystemShow/HardBoss/HardBoss_Xibi/HardBoss_Xibi_Start.HardBoss_Xibi_Start'",
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
