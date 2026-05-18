return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806665171324956214",
      startPort = "StoryStart",
      endStory = "177806665171324956216",
      endPort = "In"
    },
    {
      startStory = "177806665171324956216",
      startPort = "Success",
      endStory = "177806665171324956215",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806665171324956214"] = {
      isStoryNode = true,
      key = "177806665171324956214",
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
    ["177806665171324956215"] = {
      isStoryNode = true,
      key = "177806665171324956215",
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
    ["177806665171324956216"] = {
      isStoryNode = true,
      key = "177806665171324956216",
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
            startQuest = "177806665171324956220",
            startPort = "Out",
            endQuest = "177806665171324956218",
            endPort = "Success"
          },
          {
            startQuest = "177806665171324956217",
            startPort = "QuestStart",
            endQuest = "177806665171324956220",
            endPort = "In"
          }
        },
        nodeData = {
          ["177806665171324956217"] = {
            key = "177806665171324956217",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 949.55, y = 503.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806665171324956218"] = {
            key = "177806665171324956218",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806665171324956219"] = {
            key = "177806665171324956219",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806665171324956220"] = {
            key = "177806665171324956220",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 462.70000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51205001,
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
          ["177806665171324956221"] = {
            key = "177806665171324956221",
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
          ["177806665171324956222"] = {
            key = "177806665171324956222",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1195, y = 57.75},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512048",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806665171324956223"] = {
            key = "177806665171324956223",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1800, y = 254},
            propsData = {
              VarName = "Scenpc_512048",
              VarValue = 2
            }
          },
          ["177806665171324956224"] = {
            key = "177806665171324956224",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1196.5, y = 274},
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
