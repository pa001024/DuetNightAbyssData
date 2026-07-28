return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1783997249182637304",
      startPort = "StoryStart",
      endStory = "1783997249182637306",
      endPort = "In"
    },
    {
      startStory = "1783997249182637306",
      startPort = "Success",
      endStory = "1783997249182637305",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1783997249182637304"] = {
      isStoryNode = true,
      key = "1783997249182637304",
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
    ["1783997249182637305"] = {
      isStoryNode = true,
      key = "1783997249182637305",
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
    ["1783997249182637306"] = {
      isStoryNode = true,
      key = "1783997249182637306",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1286, y = 294},
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
            startQuest = "1783997249182637307",
            startPort = "QuestStart",
            endQuest = "1783997249182637310",
            endPort = "In"
          },
          {
            startQuest = "1783997249182637310",
            startPort = "Out",
            endQuest = "1783997249182637308",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1783997249182637307"] = {
            key = "1783997249182637307",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783997249182637308"] = {
            key = "1783997249182637308",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783997249182637309"] = {
            key = "1783997249182637309",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1783997249182637310"] = {
            key = "1783997249182637310",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1270, y = 324},
            propsData = {GuideId = 158}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
