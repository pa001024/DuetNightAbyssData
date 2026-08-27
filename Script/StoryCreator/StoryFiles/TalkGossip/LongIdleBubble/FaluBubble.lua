return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849762468431",
      startPort = "StoryStart",
      endStory = "1784976258525185",
      endPort = "In"
    },
    {
      startStory = "1784976258525185",
      startPort = "Success",
      endStory = "17849762468445",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849762468431"] = {
      isStoryNode = true,
      key = "17849762468431",
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
    ["17849762468445"] = {
      isStoryNode = true,
      key = "17849762468445",
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
    ["1784976258525185"] = {
      isStoryNode = true,
      key = "1784976258525185",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1460, y = 336},
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
            startQuest = "1784976258525186",
            startPort = "QuestStart",
            endQuest = "1784976274140586",
            endPort = "In"
          },
          {
            startQuest = "1784976274140586",
            startPort = "Out",
            endQuest = "1784976258525194",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1784976258525186"] = {
            key = "1784976258525186",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1784976258525194"] = {
            key = "1784976258525194",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1784976258525202"] = {
            key = "1784976258525202",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1784976274140586"] = {
            key = "1784976274140586",
            type = "TalkNode",
            name = "法露茜放置",
            pos = {x = 1330, y = 368},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90300000,
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
