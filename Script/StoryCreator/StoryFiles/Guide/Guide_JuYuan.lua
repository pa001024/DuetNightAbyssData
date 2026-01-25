return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17648464107831",
      startPort = "StoryStart",
      endStory = "176484641485791",
      endPort = "In"
    },
    {
      startStory = "176484641485791",
      startPort = "Success",
      endStory = "17648464107835",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17648464107831"] = {
      isStoryNode = true,
      key = "17648464107831",
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
    ["17648464107835"] = {
      isStoryNode = true,
      key = "17648464107835",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1514, y = 324},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["176484641485791"] = {
      isStoryNode = true,
      key = "176484641485791",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1208, y = 322},
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
        bIsShowOnComplete = true,
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
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "176484641485792",
            startPort = "QuestStart",
            endQuest = "1764846427770495",
            endPort = "In"
          },
          {
            startQuest = "1764846427770495",
            startPort = "Out",
            endQuest = "176484641485899",
            endPort = "Success"
          }
        },
        nodeData = {
          ["176484641485792"] = {
            key = "176484641485792",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["176484641485899"] = {
            key = "176484641485899",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1514, y = 288},
            propsData = {ModeType = 0}
          },
          ["1764846414858106"] = {
            key = "1764846414858106",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1764846427770495"] = {
            key = "1764846427770495",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1156, y = 286},
            propsData = {GuideId = 114}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
