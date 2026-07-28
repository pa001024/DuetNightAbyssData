return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740128928931",
      startPort = "StoryStart",
      endStory = "177401289733280",
      endPort = "In"
    },
    {
      startStory = "177401289733280",
      startPort = "Success",
      endStory = "17740128928935",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740128928931"] = {
      isStoryNode = true,
      key = "17740128928931",
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
    ["17740128928935"] = {
      isStoryNode = true,
      key = "17740128928935",
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
    ["177401289733280"] = {
      isStoryNode = true,
      key = "177401289733280",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1500, y = 340},
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
            startQuest = "177401289733281",
            startPort = "QuestStart",
            endQuest = "1774012908141414",
            endPort = "In"
          },
          {
            startQuest = "1774012908141414",
            startPort = "Out",
            endQuest = "177401289733289",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177401289733281"] = {
            key = "177401289733281",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401289733289"] = {
            key = "177401289733289",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401289733297"] = {
            key = "177401289733297",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774012908141414"] = {
            key = "1774012908141414",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1598, y = 404},
            propsData = {GuideId = 136}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
