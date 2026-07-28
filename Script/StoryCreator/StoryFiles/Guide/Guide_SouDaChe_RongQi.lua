return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740112565901",
      startPort = "StoryStart",
      endStory = "177401126484085",
      endPort = "In"
    },
    {
      startStory = "177401126484085",
      startPort = "Success",
      endStory = "17740112565905",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740112565901"] = {
      isStoryNode = true,
      key = "17740112565901",
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
    ["17740112565905"] = {
      isStoryNode = true,
      key = "17740112565905",
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
    ["177401126484085"] = {
      isStoryNode = true,
      key = "177401126484085",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1300, y = 352},
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
            startQuest = "177401126484086",
            startPort = "QuestStart",
            endQuest = "1774011288680609",
            endPort = "In"
          },
          {
            startQuest = "1774011288680609",
            startPort = "Out",
            endQuest = "177401126484094",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177401126484086"] = {
            key = "177401126484086",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401126484094"] = {
            key = "177401126484094",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1932, y = 302},
            propsData = {ModeType = 0}
          },
          ["1774011264840102"] = {
            key = "1774011264840102",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774011288680609"] = {
            key = "1774011288680609",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1444, y = 348},
            propsData = {GuideId = 132}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
