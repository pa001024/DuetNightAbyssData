return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1787298032861561817",
      startPort = "StoryStart",
      endStory = "1787298041196562091",
      endPort = "In"
    },
    {
      startStory = "1787298041196562091",
      startPort = "Success",
      endStory = "1787298032862561820",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1787298032861561817"] = {
      isStoryNode = true,
      key = "1787298032861561817",
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
    ["1787298032862561820"] = {
      isStoryNode = true,
      key = "1787298032862561820",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1766, y = 330},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1787298041196562091"] = {
      isStoryNode = true,
      key = "1787298041196562091",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1362, y = 358},
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
            startQuest = "1787298041196562092",
            startPort = "QuestStart",
            endQuest = "1787298060116562703",
            endPort = "In"
          },
          {
            startQuest = "1787298060116562703",
            startPort = "Out",
            endQuest = "1787298041196562095",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1787298041196562092"] = {
            key = "1787298041196562092",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1787298041196562095"] = {
            key = "1787298041196562095",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1816, y = 386},
            propsData = {ModeType = 0}
          },
          ["1787298041197562098"] = {
            key = "1787298041197562098",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2384, y = 628},
            propsData = {}
          },
          ["1787298060116562703"] = {
            key = "1787298060116562703",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1376, y = 362},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51301201,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "StayOnLast",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = true,
              BubblePlayCD = 10,
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
