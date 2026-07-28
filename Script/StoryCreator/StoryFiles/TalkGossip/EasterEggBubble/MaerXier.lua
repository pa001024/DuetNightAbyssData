return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "175325242059037244054",
      startPort = "Success",
      endStory = "175325242059037244053",
      endPort = "StoryEnd"
    },
    {
      startStory = "175325242059037244052",
      startPort = "StoryStart",
      endStory = "175325242059037244054",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["175325242059037244052"] = {
      isStoryNode = true,
      key = "175325242059037244052",
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
    ["175325242059037244053"] = {
      isStoryNode = true,
      key = "175325242059037244053",
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
    ["175325242059037244054"] = {
      isStoryNode = true,
      key = "175325242059037244054",
      type = "StoryNode",
      name = "玛尔洁希尔妲互动",
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
            startQuest = "175325242059037244055",
            startPort = "QuestStart",
            endQuest = "175325242059037244058",
            endPort = "In"
          },
          {
            startQuest = "175325242059037244058",
            startPort = "Out",
            endQuest = "175325242059037244056",
            endPort = "Success"
          }
        },
        nodeData = {
          ["175325242059037244055"] = {
            key = "175325242059037244055",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["175325242059037244056"] = {
            key = "175325242059037244056",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646, y = 314},
            propsData = {ModeType = 0}
          },
          ["175325242059037244057"] = {
            key = "175325242059037244057",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610, y = 554},
            propsData = {}
          },
          ["175325242059037244058"] = {
            key = "175325242059037244058",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1230, y = 292},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90170601,
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
