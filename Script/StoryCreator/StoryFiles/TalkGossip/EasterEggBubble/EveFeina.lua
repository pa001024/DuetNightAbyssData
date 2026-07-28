return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17816818340551",
      startPort = "StoryStart",
      endStory = "1781681844182119",
      endPort = "In"
    },
    {
      startStory = "1781681844182119",
      startPort = "Success",
      endStory = "17816818340565",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17816818340551"] = {
      isStoryNode = true,
      key = "17816818340551",
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
    ["17816818340565"] = {
      isStoryNode = true,
      key = "17816818340565",
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
    ["1781681844182119"] = {
      isStoryNode = true,
      key = "1781681844182119",
      type = "StoryNode",
      name = "伊薇菲娜互动",
      pos = {x = 1573.282051252791, y = 402},
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
            startQuest = "1781681844182120",
            startPort = "QuestStart",
            endQuest = "1781681896831860",
            endPort = "In"
          },
          {
            startQuest = "1781681896831860",
            startPort = "Out",
            endQuest = "1781681844183128",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781681844182120"] = {
            key = "1781681844182120",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681844183128"] = {
            key = "1781681844183128",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681844183136"] = {
            key = "1781681844183136",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781681896831860"] = {
            key = "1781681896831860",
            type = "TalkNode",
            name = "伊薇菲娜互动",
            pos = {x = 1192, y = 352},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90290601,
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
