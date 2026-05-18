return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806620962422137313",
      startPort = "StoryStart",
      endStory = "177806620962422137315",
      endPort = "In"
    },
    {
      startStory = "177806620962422137315",
      startPort = "Success",
      endStory = "177806620962422137314",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806620962422137313"] = {
      isStoryNode = true,
      key = "177806620962422137313",
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
    ["177806620962422137314"] = {
      isStoryNode = true,
      key = "177806620962422137314",
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
    ["177806620962422137315"] = {
      isStoryNode = true,
      key = "177806620962422137315",
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
            startQuest = "177806620962422137316",
            startPort = "QuestStart",
            endQuest = "177806620962422137321",
            endPort = "In"
          },
          {
            startQuest = "177806620962422137321",
            startPort = "false",
            endQuest = "177806620962422137319",
            endPort = "In"
          },
          {
            startQuest = "177806620962422137319",
            startPort = "Out",
            endQuest = "177806620962422137322",
            endPort = "In"
          },
          {
            startQuest = "177806620962422137322",
            startPort = "Out",
            endQuest = "177806620962422137317",
            endPort = "Success"
          },
          {
            startQuest = "177806620962422137321",
            startPort = "true",
            endQuest = "177806620962422137320",
            endPort = "In"
          },
          {
            startQuest = "177806620962422137320",
            startPort = "Out",
            endQuest = "177806620962422137317",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177806620962422137316"] = {
            key = "177806620962422137316",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 949.55, y = 503.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806620962422137317"] = {
            key = "177806620962422137317",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806620962422137318"] = {
            key = "177806620962422137318",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806620962422137319"] = {
            key = "177806620962422137319",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 462.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204801,
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
          ["177806620962422137320"] = {
            key = "177806620962422137320",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204814,
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
          ["177806620962422137321"] = {
            key = "177806620962422137321",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1223, y = 223.75},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512048",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806620962422137322"] = {
            key = "177806620962422137322",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1908, y = 360},
            propsData = {
              VarName = "Scenpc_512048",
              VarValue = 2
            }
          },
          ["177806620962422137323"] = {
            key = "177806620962422137323",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1238.5, y = 510},
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
