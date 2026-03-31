return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17745444111181",
      startPort = "StoryStart",
      endStory = "177454441873093",
      endPort = "In"
    },
    {
      startStory = "177454441873093",
      startPort = "Success",
      endStory = "17745444111195",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17745444111181"] = {
      isStoryNode = true,
      key = "17745444111181",
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
    ["17745444111195"] = {
      isStoryNode = true,
      key = "17745444111195",
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
    ["177454441873093"] = {
      isStoryNode = true,
      key = "177454441873093",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1598, y = 378},
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
            startQuest = "177454441873094",
            startPort = "QuestStart",
            endQuest = "1774544431594534",
            endPort = "In"
          },
          {
            startQuest = "1774544431594534",
            startPort = "Out",
            endQuest = "1774544418730102",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177454441873094"] = {
            key = "177454441873094",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544418730102"] = {
            key = "1774544418730102",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544418730110"] = {
            key = "1774544418730110",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774544431594534"] = {
            key = "1774544431594534",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1396, y = 382},
            propsData = {GuideId = 121}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
