return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17651933643981033944",
      startPort = "StoryStart",
      endStory = "17651933643981033946",
      endPort = "In"
    },
    {
      startStory = "17651933643981033946",
      startPort = "Success",
      endStory = "17651933643981033945",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17651933643981033944"] = {
      isStoryNode = true,
      key = "17651933643981033944",
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
    ["17651933643981033945"] = {
      isStoryNode = true,
      key = "17651933643981033945",
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
    ["17651933643981033946"] = {
      isStoryNode = true,
      key = "17651933643981033946",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1387.6428571428573, y = 321.1487484289904},
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
            startQuest = "17651933643981033947",
            startPort = "QuestStart",
            endQuest = "17651933643981033950",
            endPort = "In"
          },
          {
            startQuest = "17651933643981033950",
            startPort = "Out",
            endQuest = "17651933643981033948",
            endPort = "Success"
          },
          {
            startQuest = "17651933643981033950",
            startPort = "Fail",
            endQuest = "17651933643981033949",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17651933643981033947"] = {
            key = "17651933643981033947",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["17651933643981033948"] = {
            key = "17651933643981033948",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["17651933643981033949"] = {
            key = "17651933643981033949",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["17651933643981033950"] = {
            key = "17651933643981033950",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1188.503105590062, y = 312.08695652173907},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 51124027,
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
