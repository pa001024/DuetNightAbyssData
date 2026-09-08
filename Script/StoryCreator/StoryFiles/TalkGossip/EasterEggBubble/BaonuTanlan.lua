return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17557807779143671439",
      startPort = "Success",
      endStory = "17557807779143671438",
      endPort = "StoryEnd"
    },
    {
      startStory = "17557807779143671437",
      startPort = "StoryStart",
      endStory = "17557807779143671439",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17557807779143671437"] = {
      isStoryNode = true,
      key = "17557807779143671437",
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
    ["17557807779143671438"] = {
      isStoryNode = true,
      key = "17557807779143671438",
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
    ["17557807779143671439"] = {
      isStoryNode = true,
      key = "17557807779143671439",
      type = "StoryNode",
      name = "莉兹贝尔贪婪互动",
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
            startQuest = "17557807779143671440",
            startPort = "QuestStart",
            endQuest = "17557807779143671443",
            endPort = "In"
          },
          {
            startQuest = "17557807779143671443",
            startPort = "Out",
            endQuest = "17557807779143671441",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17557807779143671440"] = {
            key = "17557807779143671440",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17557807779143671441"] = {
            key = "17557807779143671441",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1646, y = 314},
            propsData = {ModeType = 0}
          },
          ["17557807779143671442"] = {
            key = "17557807779143671442",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1610, y = 554},
            propsData = {}
          },
          ["17557807779143671443"] = {
            key = "17557807779143671443",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1230, y = 292},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90250501,
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
