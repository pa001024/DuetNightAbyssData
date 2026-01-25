return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1765201114634395590",
      startPort = "StoryStart",
      endStory = "1765201114634395592",
      endPort = "In"
    },
    {
      startStory = "1765201114634395592",
      startPort = "Success",
      endStory = "1765201114634395591",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1765201114634395590"] = {
      isStoryNode = true,
      key = "1765201114634395590",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1014, y = 322.25},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1765201114634395591"] = {
      isStoryNode = true,
      key = "1765201114634395591",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1795, y = 315},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1765201114634395592"] = {
      isStoryNode = true,
      key = "1765201114634395592",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1389.6428571428573, y = 321.1487484289904},
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
            startQuest = "1765201114634395593",
            startPort = "QuestStart",
            endQuest = "1765201114634395596",
            endPort = "In"
          },
          {
            startQuest = "1765201114634395596",
            startPort = "Out",
            endQuest = "1765201114634395594",
            endPort = "Success"
          },
          {
            startQuest = "1765201114634395596",
            startPort = "Fail",
            endQuest = "1765201114634395595",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1765201114634395593"] = {
            key = "1765201114634395593",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["1765201114634395594"] = {
            key = "1765201114634395594",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["1765201114634395595"] = {
            key = "1765201114634395595",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["1765201114634395596"] = {
            key = "1765201114634395596",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1188.503105590062, y = 312.08695652173907},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              FirstDialogueId = 51120032,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
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
              SwitchToMaster = "None",
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
