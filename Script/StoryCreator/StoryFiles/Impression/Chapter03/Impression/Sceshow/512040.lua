return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17780637920706183250",
      startPort = "StoryStart",
      endStory = "17780637920706183252",
      endPort = "In"
    },
    {
      startStory = "17780637920706183252",
      startPort = "Success",
      endStory = "17780637920706183251",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17780637920706183250"] = {
      isStoryNode = true,
      key = "17780637920706183250",
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
    ["17780637920706183251"] = {
      isStoryNode = true,
      key = "17780637920706183251",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1912, y = 328},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17780637920706183252"] = {
      isStoryNode = true,
      key = "17780637920706183252",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1542, y = 322},
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
            startQuest = "17780637920706183253",
            startPort = "QuestStart",
            endQuest = "17780638280226560210",
            endPort = "In"
          },
          {
            startQuest = "17780638280226560210",
            startPort = "true",
            endQuest = "17780637920706183257",
            endPort = "In"
          },
          {
            startQuest = "17780638280226560210",
            startPort = "false",
            endQuest = "17780637920706183256",
            endPort = "In"
          },
          {
            startQuest = "17780637920706183256",
            startPort = "Out",
            endQuest = "17780638648396560999",
            endPort = "In"
          },
          {
            startQuest = "17780638648396560999",
            startPort = "Out",
            endQuest = "17780637920706183254",
            endPort = "Success"
          },
          {
            startQuest = "17780637920706183257",
            startPort = "Out",
            endQuest = "17780637920706183254",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17780637920706183253"] = {
            key = "17780637920706183253",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 990.8, y = 280.8},
            propsData = {ModeType = 0}
          },
          ["17780637920706183254"] = {
            key = "17780637920706183254",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["17780637920706183255"] = {
            key = "17780637920706183255",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17780637920706183256"] = {
            key = "17780637920706183256",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1573.6, y = 284.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204001,
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
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17780637920706183257"] = {
            key = "17780637920706183257",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204015,
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
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17780638280226560210"] = {
            key = "17780638280226560210",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1278, y = 258},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512040",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17780638648396560999"] = {
            key = "17780638648396560999",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1886, y = 302},
            propsData = {
              VarName = "Scenpc_512040",
              VarValue = 2
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
