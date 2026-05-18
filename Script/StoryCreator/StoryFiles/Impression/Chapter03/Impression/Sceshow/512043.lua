return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806516363013687015",
      startPort = "StoryStart",
      endStory = "177806516363013687017",
      endPort = "In"
    },
    {
      startStory = "177806516363013687017",
      startPort = "Success",
      endStory = "177806516363013687016",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806516363013687015"] = {
      isStoryNode = true,
      key = "177806516363013687015",
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
    ["177806516363013687016"] = {
      isStoryNode = true,
      key = "177806516363013687016",
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
    ["177806516363013687017"] = {
      isStoryNode = true,
      key = "177806516363013687017",
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
            startQuest = "177806516363013687018",
            startPort = "QuestStart",
            endQuest = "177806516363013687023",
            endPort = "In"
          },
          {
            startQuest = "177806516363013687024",
            startPort = "Out",
            endQuest = "177806516363013687019",
            endPort = "Success"
          },
          {
            startQuest = "177806516363013687021",
            startPort = "Option_1",
            endQuest = "177806516363013687024",
            endPort = "In"
          },
          {
            startQuest = "177806516363013687021",
            startPort = "Option_2",
            endQuest = "177806495025512185957",
            endPort = "In"
          },
          {
            startQuest = "177806495025512185957",
            startPort = "Out",
            endQuest = "177806516363013687019",
            endPort = "Success"
          },
          {
            startQuest = "177806516363013687023",
            startPort = "true",
            endQuest = "177806516363013687021",
            endPort = "In"
          },
          {
            startQuest = "177806516363013687023",
            startPort = "false",
            endQuest = "177806502378212187477",
            endPort = "In"
          },
          {
            startQuest = "177806502378212187477",
            startPort = "true",
            endQuest = "177806516363013687022",
            endPort = "In"
          },
          {
            startQuest = "177806502378212187477",
            startPort = "false",
            endQuest = "177806505615812188361",
            endPort = "In"
          },
          {
            startQuest = "177806516363013687022",
            startPort = "Out",
            endQuest = "177806516363013687019",
            endPort = "Success"
          },
          {
            startQuest = "177806505615812188361",
            startPort = "Out",
            endQuest = "177806516363013687019",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177806495025512185957"] = {
            key = "177806495025512185957",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1929.7896103896107, y = 462.1020374552985},
            propsData = {
              VarName = "Scenpc_512043",
              VarValue = 3
            }
          },
          ["177806502378212187477"] = {
            key = "177806502378212187477",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1443.1229437229442, y = 763.768704121965},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512043",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177806505615812188361"] = {
            key = "177806505615812188361",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1794.7896103896107, y = 878.7687041219652},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204329,
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
          ["177806516363013687018"] = {
            key = "177806516363013687018",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 990.8, y = 280.8},
            propsData = {ModeType = 0}
          },
          ["177806516363013687019"] = {
            key = "177806516363013687019",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2426.4666666666662, y = 583.4},
            propsData = {ModeType = 0}
          },
          ["177806516363013687020"] = {
            key = "177806516363013687020",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177806516363013687021"] = {
            key = "177806516363013687021",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1571.6, y = 286.36666666666673},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204301,
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
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["177806516363013687022"] = {
            key = "177806516363013687022",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1782.3916666666669, y = 689.9166666666667},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204324,
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
          ["177806516363013687023"] = {
            key = "177806516363013687023",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1251.3333333333335, y = 326.33333333333337},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512043",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177806516363013687024"] = {
            key = "177806516363013687024",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1936, y = 277},
            propsData = {
              VarName = "Scenpc_512043",
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
