return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177738329949110694230",
      startPort = "StoryStart",
      endStory = "177738329949110694232",
      endPort = "In"
    },
    {
      startStory = "177738329949110694232",
      startPort = "Success",
      endStory = "177738329949110694231",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177738329949110694230"] = {
      isStoryNode = true,
      key = "177738329949110694230",
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
    ["177738329949110694231"] = {
      isStoryNode = true,
      key = "177738329949110694231",
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
    ["177738329949110694232"] = {
      isStoryNode = true,
      key = "177738329949110694232",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1196, y = 274.5},
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
            startQuest = "177738329949110694233",
            startPort = "QuestStart",
            endQuest = "177738329949110694236",
            endPort = "In"
          },
          {
            startQuest = "177738329949110694236",
            startPort = "Out",
            endQuest = "177738329949110694234",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177738329949110694233"] = {
            key = "177738329949110694233",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1048.3333333333333, y = 303.3333333333333},
            propsData = {ModeType = 0}
          },
          ["177738329949110694234"] = {
            key = "177738329949110694234",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1731.6666666666665, y = 296.6666666666667},
            propsData = {ModeType = 0}
          },
          ["177738329949110694235"] = {
            key = "177738329949110694235",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177738329949110694236"] = {
            key = "177738329949110694236",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1406, y = 286},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51015000,
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
                  TalkActorId = 701286,
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
