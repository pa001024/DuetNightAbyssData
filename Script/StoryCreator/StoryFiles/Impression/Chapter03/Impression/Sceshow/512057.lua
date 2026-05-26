return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806724630232485109",
      startPort = "StoryStart",
      endStory = "177806724630232485111",
      endPort = "In"
    },
    {
      startStory = "177806724630232485111",
      startPort = "Success",
      endStory = "177806724630232485110",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806724630232485109"] = {
      isStoryNode = true,
      key = "177806724630232485109",
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
    ["177806724630232485110"] = {
      isStoryNode = true,
      key = "177806724630232485110",
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
    ["177806724630232485111"] = {
      isStoryNode = true,
      key = "177806724630232485111",
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
            startQuest = "177806724630232485112",
            startPort = "QuestStart",
            endQuest = "177806724630232485115",
            endPort = "In"
          },
          {
            startQuest = "177806724630232485115",
            startPort = "Out",
            endQuest = "177806724630232485118",
            endPort = "In"
          },
          {
            startQuest = "177806724630232485118",
            startPort = "Out",
            endQuest = "177806724630232485113",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177806724630232485112"] = {
            key = "177806724630232485112",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 889.55, y = 489.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806724630232485113"] = {
            key = "177806724630232485113",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806724630232485114"] = {
            key = "177806724630232485114",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806724630232485115"] = {
            key = "177806724630232485115",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 457.8666666666667},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51205701,
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
          ["177806724630232485116"] = {
            key = "177806724630232485116",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51205615,
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
          ["177806724630232485117"] = {
            key = "177806724630232485117",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1195, y = 57.75},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512057",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806724630232485118"] = {
            key = "177806724630232485118",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1969.0701754385964, y = 216.01754385964912},
            propsData = {
              VarName = "Scenpc_512057",
              VarValue = 2
            }
          },
          ["177806724630232485119"] = {
            key = "177806724630232485119",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1206.5, y = 330},
            propsData = {
              Branches = {5120492, 512054}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
