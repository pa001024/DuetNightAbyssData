return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17739739338321",
      startPort = "StoryStart",
      endStory = "1773973974768297",
      endPort = "In"
    },
    {
      startStory = "1773973974768297",
      startPort = "Success",
      endStory = "17739739338335",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17739739338321"] = {
      isStoryNode = true,
      key = "17739739338321",
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
    ["17739739338335"] = {
      isStoryNode = true,
      key = "17739739338335",
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
    ["1773973974768297"] = {
      isStoryNode = true,
      key = "1773973974768297",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1664, y = 334},
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
            startQuest = "1773973974768298",
            startPort = "QuestStart",
            endQuest = "17739752885061281",
            endPort = "In"
          },
          {
            startQuest = "17739752885061281",
            startPort = "Out",
            endQuest = "1773973974769306",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1773973974768298"] = {
            key = "1773973974768298",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1773973974769306"] = {
            key = "1773973974769306",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1773973974769314"] = {
            key = "1773973974769314",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739752885061281"] = {
            key = "17739752885061281",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1434, y = 424},
            propsData = {GuideId = 144}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
