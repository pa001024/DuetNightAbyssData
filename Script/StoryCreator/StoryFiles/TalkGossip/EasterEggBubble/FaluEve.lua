return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849772315111085628",
      startPort = "StoryStart",
      endStory = "17849772315111085630",
      endPort = "In"
    },
    {
      startStory = "17849772315111085630",
      startPort = "Success",
      endStory = "17849772315111085629",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849772315111085628"] = {
      isStoryNode = true,
      key = "17849772315111085628",
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
    ["17849772315111085629"] = {
      isStoryNode = true,
      key = "17849772315111085629",
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
    ["17849772315111085630"] = {
      isStoryNode = true,
      key = "17849772315111085630",
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
            startQuest = "17849772315121085631",
            startPort = "QuestStart",
            endQuest = "17849772315121085634",
            endPort = "In"
          },
          {
            startQuest = "17849772315121085634",
            startPort = "Out",
            endQuest = "17849772315121085632",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17849772315121085631"] = {
            key = "17849772315121085631",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17849772315121085632"] = {
            key = "17849772315121085632",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17849772315121085633"] = {
            key = "17849772315121085633",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17849772315121085634"] = {
            key = "17849772315121085634",
            type = "TalkNode",
            name = "法露茜伊薇",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90300501,
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
