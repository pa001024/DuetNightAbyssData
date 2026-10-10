return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1789117771956570",
      startPort = "StoryStart",
      endStory = "1789117772776604",
      endPort = "In"
    },
    {
      startStory = "1789117772776604",
      startPort = "Success",
      endStory = "1789117771956573",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1789117771956570"] = {
      isStoryNode = true,
      key = "1789117771956570",
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
    ["1789117771956573"] = {
      isStoryNode = true,
      key = "1789117771956573",
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
    ["1789117772776604"] = {
      isStoryNode = true,
      key = "1789117772776604",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1668, y = 312},
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
            startQuest = "1789117772776609",
            startPort = "QuestStart",
            endQuest = "1789117772776612",
            endPort = "In"
          },
          {
            startQuest = "1789117772776612",
            startPort = "Out",
            endQuest = "1789117772776610",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1789117772776609"] = {
            key = "1789117772776609",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1789117772776610"] = {
            key = "1789117772776610",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1789117772776611"] = {
            key = "1789117772776611",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1789117772776612"] = {
            key = "1789117772776612",
            type = "TalkNode",
            name = "法露茜希尔妲",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90400034,
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
