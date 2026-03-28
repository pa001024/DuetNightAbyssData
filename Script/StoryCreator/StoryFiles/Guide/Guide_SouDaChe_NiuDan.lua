return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740118254581",
      startPort = "StoryStart",
      endStory = "177401183104386",
      endPort = "In"
    },
    {
      startStory = "177401183104386",
      startPort = "Success",
      endStory = "17740118254595",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740118254581"] = {
      isStoryNode = true,
      key = "17740118254581",
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
    ["17740118254595"] = {
      isStoryNode = true,
      key = "17740118254595",
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
    ["177401183104386"] = {
      isStoryNode = true,
      key = "177401183104386",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1410, y = 314},
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
            startQuest = "177401183104387",
            startPort = "QuestStart",
            endQuest = "1774011849443550",
            endPort = "In"
          },
          {
            startQuest = "1774011849443550",
            startPort = "Out",
            endQuest = "177401183104395",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177401183104387"] = {
            key = "177401183104387",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177401183104395"] = {
            key = "177401183104395",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774011831043103"] = {
            key = "1774011831043103",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774011849443550"] = {
            key = "1774011849443550",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1558, y = 340},
            propsData = {GuideId = 133}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
