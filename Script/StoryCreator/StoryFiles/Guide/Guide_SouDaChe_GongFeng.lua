return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17740119860631",
      startPort = "StoryStart",
      endStory = "1774011999312122",
      endPort = "In"
    },
    {
      startStory = "1774011999312122",
      startPort = "Success",
      endStory = "17740119860635",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17740119860631"] = {
      isStoryNode = true,
      key = "17740119860631",
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
    ["17740119860635"] = {
      isStoryNode = true,
      key = "17740119860635",
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
    ["1774011999312122"] = {
      isStoryNode = true,
      key = "1774011999312122",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1562, y = 350},
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
            startQuest = "1774011999312123",
            startPort = "QuestStart",
            endQuest = "1774012807593463",
            endPort = "In"
          },
          {
            startQuest = "1774012807593463",
            startPort = "Out",
            endQuest = "1774011999312131",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1774011999312123"] = {
            key = "1774011999312123",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774011999312131"] = {
            key = "1774011999312131",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774011999313139"] = {
            key = "1774011999313139",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774012807593463"] = {
            key = "1774012807593463",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1540, y = 456},
            propsData = {GuideId = 135}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
