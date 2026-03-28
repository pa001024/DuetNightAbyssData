return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740146029531",
      startPort = "StoryStart",
      endStory = "1774014705942124",
      endPort = "In"
    },
    {
      startStory = "1774014705942124",
      startPort = "Success",
      endStory = "17740146029535",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740146029531"] = {
      isStoryNode = true,
      key = "17740146029531",
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
    ["17740146029535"] = {
      isStoryNode = true,
      key = "17740146029535",
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
    ["1774014705942124"] = {
      isStoryNode = true,
      key = "1774014705942124",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1618, y = 342},
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
            startQuest = "1774014705942125",
            startPort = "QuestStart",
            endQuest = "1774014720015518",
            endPort = "In"
          },
          {
            startQuest = "1774014720015518",
            startPort = "Out",
            endQuest = "1774014705942133",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1774014705942125"] = {
            key = "1774014705942125",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774014705942133"] = {
            key = "1774014705942133",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774014705942141"] = {
            key = "1774014705942141",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774014720015518"] = {
            key = "1774014720015518",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1640, y = 358},
            propsData = {GuideId = 139}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
