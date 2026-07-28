return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17759951642921477022",
      startPort = "StoryStart",
      endStory = "17759951642921477024",
      endPort = "In"
    },
    {
      startStory = "17759951642921477024",
      startPort = "Success",
      endStory = "17759951642921477023",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17759951642921477022"] = {
      isStoryNode = true,
      key = "17759951642921477022",
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
    ["17759951642921477023"] = {
      isStoryNode = true,
      key = "17759951642921477023",
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
    ["17759951642921477024"] = {
      isStoryNode = true,
      key = "17759951642921477024",
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
            startQuest = "17759951642921477025",
            startPort = "QuestStart",
            endQuest = "17759951642921477028",
            endPort = "In"
          },
          {
            startQuest = "17759951642921477028",
            startPort = "Out",
            endQuest = "17759951642921477026",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17759951642921477025"] = {
            key = "17759951642921477025",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["17759951642921477026"] = {
            key = "17759951642921477026",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["17759951642921477027"] = {
            key = "17759951642921477027",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17759951642921477028"] = {
            key = "17759951642921477028",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406, y = 286},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51175801,
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
                  TalkActorId = 701269,
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
