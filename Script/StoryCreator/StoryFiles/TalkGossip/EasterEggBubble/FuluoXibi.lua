return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17758104081971794567",
      startPort = "StoryStart",
      endStory = "17758104081971794569",
      endPort = "In"
    },
    {
      startStory = "17758104081971794569",
      startPort = "Success",
      endStory = "17758104081971794568",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17758104081971794567"] = {
      isStoryNode = true,
      key = "17758104081971794567",
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
    ["17758104081971794568"] = {
      isStoryNode = true,
      key = "17758104081971794568",
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
    ["17758104081971794569"] = {
      isStoryNode = true,
      key = "17758104081971794569",
      type = "StoryNode",
      name = "芙罗拉西比尔互动",
      pos = {x = 1442, y = 318},
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
            startQuest = "17758104081971794570",
            startPort = "QuestStart",
            endQuest = "17758104081971794573",
            endPort = "In"
          },
          {
            startQuest = "17758104081971794573",
            startPort = "Out",
            endQuest = "17758104081971794571",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17758104081971794570"] = {
            key = "17758104081971794570",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17758104081971794571"] = {
            key = "17758104081971794571",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17758104081971794572"] = {
            key = "17758104081971794572",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17758104081971794573"] = {
            key = "17758104081971794573",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1348, y = 368},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90280801,
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
