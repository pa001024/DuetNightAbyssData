return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "175325094142530085037",
      startPort = "Success",
      endStory = "175325094142530085036",
      endPort = "StoryEnd"
    },
    {
      startStory = "175325094142530085035",
      startPort = "StoryStart",
      endStory = "175325094142530085037",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["175325094142530085035"] = {
      isStoryNode = true,
      key = "175325094142530085035",
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
    ["175325094142530085036"] = {
      isStoryNode = true,
      key = "175325094142530085036",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1492, y = 306},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["175325094142530085037"] = {
      isStoryNode = true,
      key = "175325094142530085037",
      type = "StoryNode",
      name = "希尔妲赛琪互动",
      pos = {x = 1126, y = 308},
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
            startQuest = "175325094142530085038",
            startPort = "QuestStart",
            endQuest = "175325094142530085041",
            endPort = "In"
          },
          {
            startQuest = "175325094142530085041",
            startPort = "Out",
            endQuest = "175325094142530085039",
            endPort = "Success"
          }
        },
        nodeData = {
          ["175325094142530085038"] = {
            key = "175325094142530085038",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["175325094142530085039"] = {
            key = "175325094142530085039",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646, y = 314},
            propsData = {ModeType = 0}
          },
          ["175325094142530085040"] = {
            key = "175325094142530085040",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610, y = 554},
            propsData = {}
          },
          ["175325094142530085041"] = {
            key = "175325094142530085041",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1230, y = 292},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90140601,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "Once",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
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
