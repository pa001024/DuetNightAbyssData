return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1778487648541501003",
      startPort = "StoryStart",
      endStory = "1778487648541501005",
      endPort = "In"
    },
    {
      startStory = "1778487648541501005",
      startPort = "Success",
      endStory = "1778487648541501004",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1778487648541501003"] = {
      isStoryNode = true,
      key = "1778487648541501003",
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
    ["1778487648541501004"] = {
      isStoryNode = true,
      key = "1778487648541501004",
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
    ["1778487648541501005"] = {
      isStoryNode = true,
      key = "1778487648541501005",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1612, y = 366},
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
            startQuest = "1778487648541501006",
            startPort = "QuestStart",
            endQuest = "1778487648541501009",
            endPort = "In"
          },
          {
            startQuest = "1778487648541501009",
            startPort = "Out",
            endQuest = "1778487648541501007",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778487648541501006"] = {
            key = "1778487648541501006",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778487648541501007"] = {
            key = "1778487648541501007",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778487648541501008"] = {
            key = "1778487648541501008",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778487648541501009"] = {
            key = "1778487648541501009",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1591.4117647058824, y = 371.0588235294119},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51105842,
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
