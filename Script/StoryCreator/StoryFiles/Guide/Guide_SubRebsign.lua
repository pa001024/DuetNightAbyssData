return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17745449018431",
      startPort = "StoryStart",
      endStory = "177454490608683",
      endPort = "In"
    },
    {
      startStory = "177454490608683",
      startPort = "Success",
      endStory = "17745449018445",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17745449018431"] = {
      isStoryNode = true,
      key = "17745449018431",
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
    ["17745449018445"] = {
      isStoryNode = true,
      key = "17745449018445",
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
    ["177454490608683"] = {
      isStoryNode = true,
      key = "177454490608683",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1526, y = 272},
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
            startQuest = "177454490608684",
            startPort = "QuestStart",
            endQuest = "1774544921566546",
            endPort = "In"
          },
          {
            startQuest = "1774544921566546",
            startPort = "Out",
            endQuest = "177454490608792",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177454490608684"] = {
            key = "177454490608684",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177454490608792"] = {
            key = "177454490608792",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1774544906087100"] = {
            key = "1774544906087100",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774544921566546"] = {
            key = "1774544921566546",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1630, y = 382},
            propsData = {GuideId = 127}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
