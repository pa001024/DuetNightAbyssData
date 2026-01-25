return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621592350831",
      startPort = "StoryStart",
      endStory = "1762159295738106",
      endPort = "In"
    },
    {
      startStory = "1762159295738106",
      startPort = "Success",
      endStory = "17621592350845",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621592350831"] = {
      isStoryNode = true,
      key = "17621592350831",
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
    ["17621592350845"] = {
      isStoryNode = true,
      key = "17621592350845",
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
    ["1762159295738106"] = {
      isStoryNode = true,
      key = "1762159295738106",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1320.75, y = 286},
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
            startQuest = "1762159295738107",
            startPort = "QuestStart",
            endQuest = "1762159312386675",
            endPort = "In"
          }
        },
        nodeData = {
          ["1762159295738107"] = {
            key = "1762159295738107",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1762159295738114"] = {
            key = "1762159295738114",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1762159295738121"] = {
            key = "1762159295738121",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1762159312386675"] = {
            key = "1762159312386675",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1693, y = 336.3636363636364},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
