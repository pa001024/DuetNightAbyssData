return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17739990026961",
      startPort = "StoryStart",
      endStory = "1773999043326139",
      endPort = "In"
    },
    {
      startStory = "1773999043326139",
      startPort = "Success",
      endStory = "17739990026975",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17739990026961"] = {
      isStoryNode = true,
      key = "17739990026961",
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
    ["17739990026975"] = {
      isStoryNode = true,
      key = "17739990026975",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1656, y = 354},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1773999043326139"] = {
      isStoryNode = true,
      key = "1773999043326139",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1306, y = 330},
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
        bIsNotifyGameMode = true,
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
            startQuest = "1773999054478472",
            startPort = "Out",
            endQuest = "1773999043327148",
            endPort = "Success"
          },
          {
            startQuest = "1773999043326140",
            startPort = "QuestStart",
            endQuest = "1774429212396373",
            endPort = "In"
          },
          {
            startQuest = "1774429212396373",
            startPort = "Out",
            endQuest = "1773999054478472",
            endPort = "In"
          }
        },
        nodeData = {
          ["1773999043326140"] = {
            key = "1773999043326140",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1773999043327148"] = {
            key = "1773999043327148",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1962, y = 314},
            propsData = {ModeType = 0}
          },
          ["1773999043327156"] = {
            key = "1773999043327156",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1773999054478472"] = {
            key = "1773999054478472",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1410, y = 302},
            propsData = {GuideId = 134}
          },
          ["1774429212396373"] = {
            key = "1774429212396373",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1104, y = 466},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
