return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17741725434041",
      startPort = "StoryStart",
      endStory = "1774172553667129",
      endPort = "In"
    },
    {
      startStory = "1774172553667129",
      startPort = "Success",
      endStory = "17741725434055",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17741725434041"] = {
      isStoryNode = true,
      key = "17741725434041",
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
    ["17741725434055"] = {
      isStoryNode = true,
      key = "17741725434055",
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
    ["1774172553667129"] = {
      isStoryNode = true,
      key = "1774172553667129",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1574, y = 396},
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
            startQuest = "1774172553667130",
            startPort = "QuestStart",
            endQuest = "1774172571049548",
            endPort = "In"
          },
          {
            startQuest = "1774172571049548",
            startPort = "Out",
            endQuest = "1774172553667138",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1774172553667130"] = {
            key = "1774172553667130",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774172553667138"] = {
            key = "1774172553667138",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774172553667146"] = {
            key = "1774172553667146",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774172571049548"] = {
            key = "1774172571049548",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1526, y = 422},
            propsData = {GuideId = 145}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
