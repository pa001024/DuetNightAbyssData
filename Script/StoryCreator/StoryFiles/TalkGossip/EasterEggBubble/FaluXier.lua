return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17849772672122194942",
      startPort = "StoryStart",
      endStory = "17849772672122194944",
      endPort = "In"
    },
    {
      startStory = "17849772672122194944",
      startPort = "Success",
      endStory = "17849772672122194943",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17849772672122194942"] = {
      isStoryNode = true,
      key = "17849772672122194942",
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
    ["17849772672122194943"] = {
      isStoryNode = true,
      key = "17849772672122194943",
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
    ["17849772672122194944"] = {
      isStoryNode = true,
      key = "17849772672122194944",
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
            startQuest = "17849772672122194945",
            startPort = "QuestStart",
            endQuest = "17849772672122194948",
            endPort = "In"
          },
          {
            startQuest = "17849772672122194948",
            startPort = "Out",
            endQuest = "17849772672122194946",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17849772672122194945"] = {
            key = "17849772672122194945",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17849772672122194946"] = {
            key = "17849772672122194946",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17849772672122194947"] = {
            key = "17849772672122194947",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17849772672122194948"] = {
            key = "17849772672122194948",
            type = "TalkNode",
            name = "法露茜希尔妲",
            pos = {x = 1418, y = 374},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90300601,
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
