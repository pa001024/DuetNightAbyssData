return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806631103124016214",
      startPort = "StoryStart",
      endStory = "177806631103124016216",
      endPort = "In"
    },
    {
      startStory = "177806631103124016216",
      startPort = "Success",
      endStory = "177806631103124016215",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806631103124016214"] = {
      isStoryNode = true,
      key = "177806631103124016214",
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
    ["177806631103124016215"] = {
      isStoryNode = true,
      key = "177806631103124016215",
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
    ["177806631103124016216"] = {
      isStoryNode = true,
      key = "177806631103124016216",
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
            startQuest = "177806631103124016221",
            startPort = "Out",
            endQuest = "177806631103124016218",
            endPort = "Success"
          },
          {
            startQuest = "177806631103124016217",
            startPort = "QuestStart",
            endQuest = "177806631103124016224",
            endPort = "In"
          },
          {
            startQuest = "177806631103124016224",
            startPort = "Branch_2",
            endQuest = "177806631103124016220",
            endPort = "In"
          },
          {
            startQuest = "177806631103124016224",
            startPort = "Branch_1",
            endQuest = "177806631103124016221",
            endPort = "In"
          },
          {
            startQuest = "177806631103124016220",
            startPort = "Out",
            endQuest = "177806631103124016218",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177806631103124016217"] = {
            key = "177806631103124016217",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 949.55, y = 503.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806631103124016218"] = {
            key = "177806631103124016218",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806631103124016219"] = {
            key = "177806631103124016219",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806631103124016220"] = {
            key = "177806631103124016220",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 462.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204901,
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
          ["177806631103124016221"] = {
            key = "177806631103124016221",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204909,
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
          ["177806631103124016222"] = {
            key = "177806631103124016222",
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
          ["177806631103124016223"] = {
            key = "177806631103124016223",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1800, y = 254},
            propsData = {
              VarName = "Scenpc_512048",
              VarValue = 2
            }
          },
          ["177806631103124016224"] = {
            key = "177806631103124016224",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1238.5, y = 510},
            propsData = {
              Branches = {5120492, 512049}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
