return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17784656996201",
      startPort = "StoryStart",
      endStory = "1778465860026159",
      endPort = "In"
    },
    {
      startStory = "1778465860026159",
      startPort = "Success",
      endStory = "17784656996205",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17784656996201"] = {
      isStoryNode = true,
      key = "17784656996201",
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
    ["17784656996205"] = {
      isStoryNode = true,
      key = "17784656996205",
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
    ["1778465860026159"] = {
      isStoryNode = true,
      key = "1778465860026159",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1514, y = 390},
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
            startQuest = "1778465860026160",
            startPort = "QuestStart",
            endQuest = "1778465966087757",
            endPort = "In"
          },
          {
            startQuest = "1778465966087757",
            startPort = "Out",
            endQuest = "1778465860026168",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778465860026160"] = {
            key = "1778465860026160",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778465860026168"] = {
            key = "1778465860026168",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778465860026176"] = {
            key = "1778465860026176",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778465966087757"] = {
            key = "1778465966087757",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1498, y = 346},
            propsData = {GuideId = 152}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
