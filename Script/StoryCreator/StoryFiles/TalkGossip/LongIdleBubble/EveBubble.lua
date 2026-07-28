return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17816817114981",
      startPort = "StoryStart",
      endStory = "1781681717229108",
      endPort = "In"
    },
    {
      startStory = "1781681717229108",
      startPort = "Success",
      endStory = "17816817114995",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17816817114981"] = {
      isStoryNode = true,
      key = "17816817114981",
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
    ["17816817114995"] = {
      isStoryNode = true,
      key = "17816817114995",
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
    ["1781681717229108"] = {
      isStoryNode = true,
      key = "1781681717229108",
      type = "StoryNode",
      name = "伊薇放置",
      pos = {x = 1440, y = 362},
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
            startQuest = "1781681717229109",
            startPort = "QuestStart",
            endQuest = "1781681745709665",
            endPort = "In"
          },
          {
            startQuest = "1781681745709665",
            startPort = "Out",
            endQuest = "1781681717230117",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781681717229109"] = {
            key = "1781681717229109",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681717230117"] = {
            key = "1781681717230117",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781681717230125"] = {
            key = "1781681717230125",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781681745709665"] = {
            key = "1781681745709665",
            type = "TalkNode",
            name = "伊薇放置",
            pos = {x = 1374.6241512764973, y = 329.00506968628895},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90290000,
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
