return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17836017818691",
      startPort = "StoryStart",
      endStory = "1783601804301107",
      endPort = "In"
    },
    {
      startStory = "1783601804301107",
      startPort = "Success",
      endStory = "17836017818705",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17836017818691"] = {
      isStoryNode = true,
      key = "17836017818691",
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
    ["17836017818705"] = {
      isStoryNode = true,
      key = "17836017818705",
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
    ["1783601804301107"] = {
      isStoryNode = true,
      key = "1783601804301107",
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
            startQuest = "1783601804301108",
            startPort = "QuestStart",
            endQuest = "1783601814861435",
            endPort = "In"
          },
          {
            startQuest = "1783601814861435",
            startPort = "Out",
            endQuest = "1783601804301116",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1783601804301108"] = {
            key = "1783601804301108",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783601804301116"] = {
            key = "1783601804301116",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783601804301124"] = {
            key = "1783601804301124",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1783601814861435"] = {
            key = "1783601814861435",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1390, y = 402},
            propsData = {GuideId = 155}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
