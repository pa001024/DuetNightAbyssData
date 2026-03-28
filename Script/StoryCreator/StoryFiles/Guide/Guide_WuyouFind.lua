return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17741726669911",
      startPort = "StoryStart",
      endStory = "177417267796889",
      endPort = "In"
    },
    {
      startStory = "177417267796889",
      startPort = "Success",
      endStory = "17741726669925",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17741726669911"] = {
      isStoryNode = true,
      key = "17741726669911",
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
    ["17741726669925"] = {
      isStoryNode = true,
      key = "17741726669925",
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
    ["177417267796889"] = {
      isStoryNode = true,
      key = "177417267796889",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1314, y = 308},
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
            startQuest = "177417267796890",
            startPort = "QuestStart",
            endQuest = "1774172688998447",
            endPort = "In"
          },
          {
            startQuest = "1774172688998447",
            startPort = "Out",
            endQuest = "177417267796898",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177417267796890"] = {
            key = "177417267796890",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177417267796898"] = {
            key = "177417267796898",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774172677968106"] = {
            key = "1774172677968106",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774172688998447"] = {
            key = "1774172688998447",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1494, y = 508},
            propsData = {GuideId = 146}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
