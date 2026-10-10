return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178912881181717870093",
      startPort = "StoryStart",
      endStory = "178912881181717870095",
      endPort = "In"
    },
    {
      startStory = "178912881181717870095",
      startPort = "Success",
      endStory = "178912881181717870094",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178912881181717870093"] = {
      isStoryNode = true,
      key = "178912881181717870093",
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
    ["178912881181717870094"] = {
      isStoryNode = true,
      key = "178912881181717870094",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1518.1176470588232, y = 292.9411764705883},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178912881181717870095"] = {
      isStoryNode = true,
      key = "178912881181717870095",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1159.6425770308124, y = 289.71421767087384},
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
            startQuest = "178912881181717870099",
            startPort = "Out",
            endQuest = "178912881181717870097",
            endPort = "Success"
          },
          {
            startQuest = "178912881181717870096",
            startPort = "QuestStart",
            endQuest = "178912881181717870099",
            endPort = "In"
          }
        },
        nodeData = {
          ["178912881181717870096"] = {
            key = "178912881181717870096",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -236.23529411764733, y = 482.1176470588236},
            propsData = {ModeType = 0}
          },
          ["178912881181717870097"] = {
            key = "178912881181717870097",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 517.4901960784309, y = 481.80392156862746},
            propsData = {ModeType = 0}
          },
          ["178912881181717870098"] = {
            key = "178912881181717870098",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1190.5882352941173, y = -279.76470588235304},
            propsData = {}
          },
          ["178912881181717870099"] = {
            key = "178912881181717870099",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 271.709114414997, y = 552.005171299289},
            propsData = {GuideId = 46}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
