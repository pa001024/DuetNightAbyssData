return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17648467867151032460",
      startPort = "StoryStart",
      endStory = "17648467867151032462",
      endPort = "In"
    },
    {
      startStory = "17648467867151032462",
      startPort = "Success",
      endStory = "17648467867151032461",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17648467867151032460"] = {
      isStoryNode = true,
      key = "17648467867151032460",
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
    ["17648467867151032461"] = {
      isStoryNode = true,
      key = "17648467867151032461",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1659.857142857143, y = 180.14285714285714},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17648467867151032462"] = {
      isStoryNode = true,
      key = "17648467867151032462",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1226.6140648567118, y = 279.62727223756656},
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
        bIsShowOnComplete = true,
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
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17648467867151032463",
            startPort = "QuestStart",
            endQuest = "17648467867151032466",
            endPort = "In"
          },
          {
            startQuest = "17648467867151032466",
            startPort = "Out",
            endQuest = "17648467867151032464",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17648467867151032463"] = {
            key = "17648467867151032463",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 891.6923076923077, y = 391.38461538461536},
            propsData = {ModeType = 0}
          },
          ["17648467867151032464"] = {
            key = "17648467867151032464",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2056, y = 274},
            propsData = {ModeType = 0}
          },
          ["17648467867151032465"] = {
            key = "17648467867151032465",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1973.2, y = 557.6000000000001},
            propsData = {}
          },
          ["17648467867151032466"] = {
            key = "17648467867151032466",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1308.0077231121281, y = 395.41561784897016},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              FirstDialogueId = 51125704,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
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
