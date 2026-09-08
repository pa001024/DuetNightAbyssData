return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "175325221076534637839",
      startPort = "Success",
      endStory = "175325221076534637838",
      endPort = "StoryEnd"
    },
    {
      startStory = "175325221076534637837",
      startPort = "StoryStart",
      endStory = "175325221076534637839",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["175325221076534637837"] = {
      isStoryNode = true,
      key = "175325221076534637837",
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
    ["175325221076534637838"] = {
      isStoryNode = true,
      key = "175325221076534637838",
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
    ["175325221076534637839"] = {
      isStoryNode = true,
      key = "175325221076534637839",
      type = "StoryNode",
      name = "菲娜传教士互动",
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
            startQuest = "175325221076534637840",
            startPort = "QuestStart",
            endQuest = "175325221076534637843",
            endPort = "In"
          },
          {
            startQuest = "175325221076534637843",
            startPort = "Out",
            endQuest = "175325221076534637841",
            endPort = "Success"
          }
        },
        nodeData = {
          ["175325221076534637840"] = {
            key = "175325221076534637840",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["175325221076534637841"] = {
            key = "175325221076534637841",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646, y = 314},
            propsData = {ModeType = 0}
          },
          ["175325221076534637842"] = {
            key = "175325221076534637842",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610, y = 554},
            propsData = {}
          },
          ["175325221076534637843"] = {
            key = "175325221076534637843",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1230, y = 292},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90150901,
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
