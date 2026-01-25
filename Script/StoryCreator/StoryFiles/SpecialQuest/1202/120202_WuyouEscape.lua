return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621593594251",
      startPort = "StoryStart",
      endStory = "176215936932473",
      endPort = "In"
    },
    {
      startStory = "176215936932473",
      startPort = "Success",
      endStory = "17621593594265",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621593594251"] = {
      isStoryNode = true,
      key = "17621593594251",
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
    ["17621593594265"] = {
      isStoryNode = true,
      key = "17621593594265",
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
    ["176215936932473"] = {
      isStoryNode = true,
      key = "176215936932473",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1223.25, y = 345.875},
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
            startQuest = "176215936932474",
            startPort = "QuestStart",
            endQuest = "1762159376706349",
            endPort = "In"
          }
        },
        nodeData = {
          ["176215936932474"] = {
            key = "176215936932474",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["176215936932481"] = {
            key = "176215936932481",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["176215936932488"] = {
            key = "176215936932488",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1762159376706349"] = {
            key = "1762159376706349",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1389.8181818181818, y = 325.8181818181818},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
