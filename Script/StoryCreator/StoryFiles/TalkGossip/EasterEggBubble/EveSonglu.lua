return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17816820020701",
      startPort = "StoryStart",
      endStory = "178168200571285",
      endPort = "In"
    },
    {
      startStory = "178168200571285",
      startPort = "Success",
      endStory = "17816820020705",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17816820020701"] = {
      isStoryNode = true,
      key = "17816820020701",
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
    ["17816820020705"] = {
      isStoryNode = true,
      key = "17816820020705",
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
    ["178168200571285"] = {
      isStoryNode = true,
      key = "178168200571285",
      type = "StoryNode",
      name = "伊薇松露",
      pos = {x = 1360, y = 400},
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
            startQuest = "178168200571286",
            startPort = "QuestStart",
            endQuest = "1781682067983694",
            endPort = "In"
          },
          {
            startQuest = "1781682067983694",
            startPort = "Out",
            endQuest = "178168200571294",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178168200571286"] = {
            key = "178168200571286",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178168200571294"] = {
            key = "178168200571294",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781682005712102"] = {
            key = "1781682005712102",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781682067983694"] = {
            key = "1781682067983694",
            type = "TalkNode",
            name = "伊薇松露互动",
            pos = {x = 1618, y = 372},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 90290701,
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
