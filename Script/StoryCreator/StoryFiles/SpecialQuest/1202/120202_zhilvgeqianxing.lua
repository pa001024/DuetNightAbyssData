return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621589353871",
      startPort = "StoryStart",
      endStory = "176215893740467",
      endPort = "In"
    },
    {
      startStory = "176215893740467",
      startPort = "Success",
      endStory = "17621589353885",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621589353871"] = {
      isStoryNode = true,
      key = "17621589353871",
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
    ["17621589353885"] = {
      isStoryNode = true,
      key = "17621589353885",
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
    ["176215893740467"] = {
      isStoryNode = true,
      key = "176215893740467",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1578, y = 352},
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
            startQuest = "176215893740468",
            startPort = "QuestStart",
            endQuest = "1762159580231684952",
            endPort = "In"
          }
        },
        nodeData = {
          ["176215893740468"] = {
            key = "176215893740468",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["176215893740575"] = {
            key = "176215893740575",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["176215893740582"] = {
            key = "176215893740582",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1762159580231684952"] = {
            key = "1762159580231684952",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1246.5252437481142, y = 308.4884872080089},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
