return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17759954222384209690",
      startPort = "StoryStart",
      endStory = "17759954222384209692",
      endPort = "In"
    },
    {
      startStory = "17759954222384209692",
      startPort = "Success",
      endStory = "17759954222384209691",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17759954222384209690"] = {
      isStoryNode = true,
      key = "17759954222384209690",
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
    ["17759954222384209691"] = {
      isStoryNode = true,
      key = "17759954222384209691",
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
    ["17759954222384209692"] = {
      isStoryNode = true,
      key = "17759954222384209692",
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
            startQuest = "17759954222384209693",
            startPort = "QuestStart",
            endQuest = "17759954222384209696",
            endPort = "In"
          },
          {
            startQuest = "17759954222384209696",
            startPort = "Out",
            endQuest = "17759954222384209694",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17759954222384209693"] = {
            key = "17759954222384209693",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["17759954222384209694"] = {
            key = "17759954222384209694",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["17759954222384209695"] = {
            key = "17759954222384209695",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17759954222384209696"] = {
            key = "17759954222384209696",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406, y = 286},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51177001,
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
                  TalkActorId = 701273,
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
