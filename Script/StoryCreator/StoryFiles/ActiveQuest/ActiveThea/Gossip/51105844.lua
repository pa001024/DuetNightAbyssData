return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1778487648541501149",
      startPort = "StoryStart",
      endStory = "1778487648541501151",
      endPort = "In"
    },
    {
      startStory = "1778487648541501151",
      startPort = "Success",
      endStory = "1778487648541501150",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1778487648541501149"] = {
      isStoryNode = true,
      key = "1778487648541501149",
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
    ["1778487648541501150"] = {
      isStoryNode = true,
      key = "1778487648541501150",
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
    ["1778487648541501151"] = {
      isStoryNode = true,
      key = "1778487648541501151",
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
            startQuest = "1778487648541501152",
            startPort = "QuestStart",
            endQuest = "1778487648541501155",
            endPort = "In"
          },
          {
            startQuest = "1778487648541501155",
            startPort = "Out",
            endQuest = "1778487648541501153",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778487648541501152"] = {
            key = "1778487648541501152",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778487648541501153"] = {
            key = "1778487648541501153",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778487648541501154"] = {
            key = "1778487648541501154",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1778487648541501155"] = {
            key = "1778487648541501155",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1591.4117647058824, y = 371.0588235294119},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51105844,
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
