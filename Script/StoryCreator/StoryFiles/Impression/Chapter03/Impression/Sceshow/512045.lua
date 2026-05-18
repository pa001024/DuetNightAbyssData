return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806583287516504757",
      startPort = "StoryStart",
      endStory = "177806583287516504759",
      endPort = "In"
    },
    {
      startStory = "177806583287516504759",
      startPort = "Success",
      endStory = "177806583287516504758",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806583287516504757"] = {
      isStoryNode = true,
      key = "177806583287516504757",
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
    ["177806583287516504758"] = {
      isStoryNode = true,
      key = "177806583287516504758",
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
    ["177806583287516504759"] = {
      isStoryNode = true,
      key = "177806583287516504759",
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
            startQuest = "177806583287516504764",
            startPort = "Out",
            endQuest = "177806583287516504761",
            endPort = "Success"
          },
          {
            startQuest = "177806583287516504760",
            startPort = "QuestStart",
            endQuest = "177806583287516504765",
            endPort = "In"
          },
          {
            startQuest = "177806583287516504765",
            startPort = "false",
            endQuest = "177806583287516504763",
            endPort = "In"
          },
          {
            startQuest = "177806583287516504763",
            startPort = "Out",
            endQuest = "177806583287516504766",
            endPort = "In"
          },
          {
            startQuest = "177806583287516504766",
            startPort = "Out",
            endQuest = "177806583287516504761",
            endPort = "Success"
          },
          {
            startQuest = "177806583287516504765",
            startPort = "true",
            endQuest = "177806583287516504764",
            endPort = "In"
          }
        },
        nodeData = {
          ["177806583287516504760"] = {
            key = "177806583287516504760",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 990.8, y = 280.8},
            propsData = {ModeType = 0}
          },
          ["177806583287516504761"] = {
            key = "177806583287516504761",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806583287516504762"] = {
            key = "177806583287516504762",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806583287516504763"] = {
            key = "177806583287516504763",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1569.6, y = 462.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204501,
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
          ["177806583287516504764"] = {
            key = "177806583287516504764",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204511,
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
          ["177806583287516504765"] = {
            key = "177806583287516504765",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1258, y = 140},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512045",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806583287516504766"] = {
            key = "177806583287516504766",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1798, y = 250},
            propsData = {
              VarName = "Scenpc_512045",
              VarValue = 2
            }
          },
          ["177806583287516504767"] = {
            key = "177806583287516504767",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1286, y = 370},
            propsData = {
              Branches = {5120442, 512044}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
