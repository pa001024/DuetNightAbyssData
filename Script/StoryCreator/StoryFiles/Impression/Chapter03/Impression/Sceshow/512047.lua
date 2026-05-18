return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806612089720259337",
      startPort = "StoryStart",
      endStory = "177806612089720259339",
      endPort = "In"
    },
    {
      startStory = "177806612089720259339",
      startPort = "Success",
      endStory = "177806612089720259338",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806612089720259337"] = {
      isStoryNode = true,
      key = "177806612089720259337",
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
    ["177806612089720259338"] = {
      isStoryNode = true,
      key = "177806612089720259338",
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
    ["177806612089720259339"] = {
      isStoryNode = true,
      key = "177806612089720259339",
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
            startQuest = "177806612089720259340",
            startPort = "QuestStart",
            endQuest = "177806612089720259345",
            endPort = "In"
          },
          {
            startQuest = "177806612089720259345",
            startPort = "false",
            endQuest = "177806612089720259343",
            endPort = "In"
          },
          {
            startQuest = "177806612089720259343",
            startPort = "Out",
            endQuest = "177806612089720259346",
            endPort = "In"
          },
          {
            startQuest = "177806612089720259346",
            startPort = "Out",
            endQuest = "177806612089720259341",
            endPort = "Success"
          },
          {
            startQuest = "177806612089720259345",
            startPort = "true",
            endQuest = "177806612089720259344",
            endPort = "In"
          },
          {
            startQuest = "177806612089720259344",
            startPort = "Out",
            endQuest = "177806612089720259341",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177806612089720259340"] = {
            key = "177806612089720259340",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 949.55, y = 503.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806612089720259341"] = {
            key = "177806612089720259341",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806612089720259342"] = {
            key = "177806612089720259342",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806612089720259343"] = {
            key = "177806612089720259343",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 462.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204701,
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
          ["177806612089720259344"] = {
            key = "177806612089720259344",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204713,
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
          ["177806612089720259345"] = {
            key = "177806612089720259345",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1223, y = 223.75},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512047",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806612089720259346"] = {
            key = "177806612089720259346",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1908, y = 360},
            propsData = {
              VarName = "Scenpc_512047",
              VarValue = 2
            }
          },
          ["177806612089720259347"] = {
            key = "177806612089720259347",
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
