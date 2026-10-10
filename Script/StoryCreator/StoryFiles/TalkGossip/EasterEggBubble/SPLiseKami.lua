return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17891178215721143715",
      startPort = "StoryStart",
      endStory = "17891178221431143749",
      endPort = "In"
    },
    {
      startStory = "17891178221431143749",
      startPort = "Success",
      endStory = "17891178215721143718",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17891178215721143715"] = {
      isStoryNode = true,
      key = "17891178215721143715",
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
    ["17891178215721143718"] = {
      isStoryNode = true,
      key = "17891178215721143718",
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
    ["17891178221431143749"] = {
      isStoryNode = true,
      key = "17891178221431143749",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1662, y = 306},
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
            startQuest = "17891178221441143754",
            startPort = "QuestStart",
            endQuest = "17891178221441143757",
            endPort = "In"
          },
          {
            startQuest = "17891178221441143757",
            startPort = "Out",
            endQuest = "17891178221441143755",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17891178221441143754"] = {
            key = "17891178221441143754",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17891178221441143755"] = {
            key = "17891178221441143755",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17891178221441143756"] = {
            key = "17891178221441143756",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17891178221441143757"] = {
            key = "17891178221441143757",
            type = "TalkNode",
            name = "法露茜希尔妲",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90400035,
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
