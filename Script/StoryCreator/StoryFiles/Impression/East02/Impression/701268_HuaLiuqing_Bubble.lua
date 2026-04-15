return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1775995044179566376",
      startPort = "StoryStart",
      endStory = "1775995044179566378",
      endPort = "In"
    },
    {
      startStory = "1775995044179566378",
      startPort = "Success",
      endStory = "1775995044179566377",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1775995044179566376"] = {
      isStoryNode = true,
      key = "1775995044179566376",
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
    ["1775995044179566377"] = {
      isStoryNode = true,
      key = "1775995044179566377",
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
    ["1775995044179566378"] = {
      isStoryNode = true,
      key = "1775995044179566378",
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
            startQuest = "1775995044179566379",
            startPort = "QuestStart",
            endQuest = "1775995044179566382",
            endPort = "In"
          },
          {
            startQuest = "1775995044179566382",
            startPort = "Out",
            endQuest = "1775995044179566380",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775995044179566379"] = {
            key = "1775995044179566379",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["1775995044179566380"] = {
            key = "1775995044179566380",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["1775995044179566381"] = {
            key = "1775995044179566381",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1775995044179566382"] = {
            key = "1775995044179566382",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406, y = 286},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51175701,
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
                  TalkActorId = 701268,
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
