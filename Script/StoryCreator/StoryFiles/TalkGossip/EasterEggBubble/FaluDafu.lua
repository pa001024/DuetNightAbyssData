return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849770738241",
      startPort = "StoryStart",
      endStory = "1784977086688122",
      endPort = "In"
    },
    {
      startStory = "1784977086688122",
      startPort = "Success",
      endStory = "17849770738245",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849770738241"] = {
      isStoryNode = true,
      key = "17849770738241",
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
    ["17849770738245"] = {
      isStoryNode = true,
      key = "17849770738245",
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
    ["1784977086688122"] = {
      isStoryNode = true,
      key = "1784977086688122",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1350, y = 144},
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
            startQuest = "1784977086688123",
            startPort = "QuestStart",
            endQuest = "1784977102400557",
            endPort = "In"
          },
          {
            startQuest = "1784977102400557",
            startPort = "Out",
            endQuest = "1784977086688131",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1784977086688123"] = {
            key = "1784977086688123",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1784977086688131"] = {
            key = "1784977086688131",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1784977086688139"] = {
            key = "1784977086688139",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1784977102400557"] = {
            key = "1784977102400557",
            type = "TalkNode",
            name = "法露茜达芙涅",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90300401,
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
