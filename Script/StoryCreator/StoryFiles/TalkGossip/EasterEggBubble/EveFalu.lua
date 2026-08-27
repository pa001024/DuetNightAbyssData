return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17816835367941",
      startPort = "StoryStart",
      endStory = "1781683589810208",
      endPort = "In"
    },
    {
      startStory = "1781683589810208",
      startPort = "Success",
      endStory = "17816835367945",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17816835367941"] = {
      isStoryNode = true,
      key = "17816835367941",
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
    ["17816835367945"] = {
      isStoryNode = true,
      key = "17816835367945",
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
    ["1781683589810208"] = {
      isStoryNode = true,
      key = "1781683589810208",
      type = "StoryNode",
      name = "伊薇法露茜",
      pos = {x = 1753.428574309057, y = 345.9999992733909},
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
            startQuest = "1781683589810209",
            startPort = "QuestStart",
            endQuest = "1781683836480729",
            endPort = "In"
          },
          {
            startQuest = "1781683836480729",
            startPort = "Out",
            endQuest = "1781683589810217",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781683589810209"] = {
            key = "1781683589810209",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781683589810217"] = {
            key = "1781683589810217",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781683589810225"] = {
            key = "1781683589810225",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781683836480729"] = {
            key = "1781683836480729",
            type = "TalkNode",
            name = "伊薇法露茜互动",
            pos = {x = 1754, y = 278},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90290801,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
