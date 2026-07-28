return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177599604629310590627",
      startPort = "StoryStart",
      endStory = "177599604629310590629",
      endPort = "In"
    },
    {
      startStory = "177599604629310590629",
      startPort = "Success",
      endStory = "177599604629310590628",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177599604629310590627"] = {
      isStoryNode = true,
      key = "177599604629310590627",
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
    ["177599604629310590628"] = {
      isStoryNode = true,
      key = "177599604629310590628",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1528, y = 304},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177599604629310590629"] = {
      isStoryNode = true,
      key = "177599604629310590629",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1196, y = 276},
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
        bIsNotifyGameMode = false,
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
            startQuest = "177599604629310590630",
            startPort = "QuestStart",
            endQuest = "177599604629310590633",
            endPort = "In"
          },
          {
            startQuest = "177599604629310590633",
            startPort = "Out",
            endQuest = "177599604629310590631",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177599604629310590630"] = {
            key = "177599604629310590630",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["177599604629310590631"] = {
            key = "177599604629310590631",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["177599604629310590632"] = {
            key = "177599604629310590632",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177599604629310590633"] = {
            key = "177599604629310590633",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1407.4285714285713, y = 284.57142857142856},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51178601,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "StayOnLast",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = true,
              BubblePlayCD = 10,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 701281,
                  TalkActorVisible = true
                }
              },
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
