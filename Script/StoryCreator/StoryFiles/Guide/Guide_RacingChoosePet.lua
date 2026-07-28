return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17839974431231697690",
      startPort = "StoryStart",
      endStory = "17839974431231697692",
      endPort = "In"
    },
    {
      startStory = "17839974431231697692",
      startPort = "Success",
      endStory = "17839974431231697691",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17839974431231697690"] = {
      isStoryNode = true,
      key = "17839974431231697690",
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
    ["17839974431231697691"] = {
      isStoryNode = true,
      key = "17839974431231697691",
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
    ["17839974431231697692"] = {
      isStoryNode = true,
      key = "17839974431231697692",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1288, y = 294},
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
            startQuest = "17839974431231697693",
            startPort = "QuestStart",
            endQuest = "17839974431231697696",
            endPort = "In"
          },
          {
            startQuest = "17839974431231697696",
            startPort = "Out",
            endQuest = "17839974431231697694",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17839974431231697693"] = {
            key = "17839974431231697693",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17839974431231697694"] = {
            key = "17839974431231697694",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17839974431231697695"] = {
            key = "17839974431231697695",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17839974431231697696"] = {
            key = "17839974431231697696",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1270, y = 324},
            propsData = {GuideId = 157}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
