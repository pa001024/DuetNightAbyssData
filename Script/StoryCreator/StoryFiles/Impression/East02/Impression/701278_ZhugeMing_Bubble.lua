return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17759956665287855090",
      startPort = "StoryStart",
      endStory = "17759956665287855092",
      endPort = "In"
    },
    {
      startStory = "17759956665287855092",
      startPort = "Success",
      endStory = "17759956665287855091",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17759956665287855090"] = {
      isStoryNode = true,
      key = "17759956665287855090",
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
    ["17759956665287855091"] = {
      isStoryNode = true,
      key = "17759956665287855091",
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
    ["17759956665287855092"] = {
      isStoryNode = true,
      key = "17759956665287855092",
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
            startQuest = "17759956665287855093",
            startPort = "QuestStart",
            endQuest = "17759956665287855096",
            endPort = "In"
          },
          {
            startQuest = "17759956665287855096",
            startPort = "Out",
            endQuest = "17759956665287855094",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17759956665287855093"] = {
            key = "17759956665287855093",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["17759956665287855094"] = {
            key = "17759956665287855094",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["17759956665287855095"] = {
            key = "17759956665287855095",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17759956665287855096"] = {
            key = "17759956665287855096",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406, y = 284.57142857142856},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51178301,
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
                  TalkActorId = 701278,
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
