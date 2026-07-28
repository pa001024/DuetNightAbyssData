return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1783601934703622927",
      startPort = "StoryStart",
      endStory = "1783601934703622929",
      endPort = "In"
    },
    {
      startStory = "1783601934703622929",
      startPort = "Success",
      endStory = "1783601934703622928",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1783601934703622927"] = {
      isStoryNode = true,
      key = "1783601934703622927",
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
    ["1783601934703622928"] = {
      isStoryNode = true,
      key = "1783601934703622928",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1783601934703622929"] = {
      isStoryNode = true,
      key = "1783601934703622929",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1292, y = 372},
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
            startQuest = "1783601934703622930",
            startPort = "QuestStart",
            endQuest = "1783601934703622933",
            endPort = "In"
          },
          {
            startQuest = "1783601934703622933",
            startPort = "Out",
            endQuest = "1783601934703622931",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1783601934703622930"] = {
            key = "1783601934703622930",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783601934703622931"] = {
            key = "1783601934703622931",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783601934703622932"] = {
            key = "1783601934703622932",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1783601934703622933"] = {
            key = "1783601934703622933",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1390, y = 402},
            propsData = {GuideId = 156}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
