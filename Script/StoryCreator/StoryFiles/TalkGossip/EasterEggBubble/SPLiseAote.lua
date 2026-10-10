return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17891178778842286629",
      startPort = "StoryStart",
      endStory = "17891178783692286657",
      endPort = "In"
    },
    {
      startStory = "17891178783692286657",
      startPort = "Success",
      endStory = "17891178778842286632",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17891178778842286629"] = {
      isStoryNode = true,
      key = "17891178778842286629",
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
    ["17891178778842286632"] = {
      isStoryNode = true,
      key = "17891178778842286632",
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
    ["17891178783692286657"] = {
      isStoryNode = true,
      key = "17891178783692286657",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1614, y = 328},
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
            startQuest = "17891178783702286662",
            startPort = "QuestStart",
            endQuest = "17891178783702286665",
            endPort = "In"
          },
          {
            startQuest = "17891178783702286665",
            startPort = "Out",
            endQuest = "17891178783702286663",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17891178783702286662"] = {
            key = "17891178783702286662",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17891178783702286663"] = {
            key = "17891178783702286663",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17891178783702286664"] = {
            key = "17891178783702286664",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17891178783702286665"] = {
            key = "17891178783702286665",
            type = "TalkNode",
            name = "法露茜希尔妲",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90400036,
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
