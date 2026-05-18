return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177806901335534371761",
      startPort = "StoryStart",
      endStory = "177806901335534371763",
      endPort = "In"
    },
    {
      startStory = "177806901335534371763",
      startPort = "Success",
      endStory = "177806901335534371762",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177806901335534371761"] = {
      isStoryNode = true,
      key = "177806901335534371761",
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
    ["177806901335534371762"] = {
      isStoryNode = true,
      key = "177806901335534371762",
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
    ["177806901335534371763"] = {
      isStoryNode = true,
      key = "177806901335534371763",
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
            startQuest = "177806901335534371767",
            startPort = "Out",
            endQuest = "177806901335534371765",
            endPort = "Success"
          },
          {
            startQuest = "177806735455233803361",
            startPort = "Out",
            endQuest = "177806901335534371765",
            endPort = "Success"
          },
          {
            startQuest = "177806901335534371764",
            startPort = "QuestStart",
            endQuest = "177806901335534371771",
            endPort = "In"
          },
          {
            startQuest = "177806901335534371771",
            startPort = "Branch_2",
            endQuest = "177806735455233803361",
            endPort = "In"
          },
          {
            startQuest = "177806901335534371771",
            startPort = "Branch_1",
            endQuest = "177806901335534371767",
            endPort = "In"
          },
          {
            startQuest = "177806901335534371771",
            startPort = "Branch_2",
            endQuest = "177806901335534371767",
            endPort = "In"
          }
        },
        nodeData = {
          ["177806735455233803361"] = {
            key = "177806735455233803361",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1535.5, y = 707.5789473684213},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51205901,
              FlowAssetPath = "",
              TalkType = "Bubble",
              BubblePlayType = "StayOnLast",
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              bBubblePlayCDEnable = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              OverrideFailBlend = false
            }
          },
          ["177806901335534371764"] = {
            key = "177806901335534371764",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 889.55, y = 489.30000000000007},
            propsData = {ModeType = 0}
          },
          ["177806901335534371765"] = {
            key = "177806901335534371765",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["177806901335534371766"] = {
            key = "177806901335534371766",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["177806901335534371767"] = {
            key = "177806901335534371767",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1756.85, y = 448.3666666666667},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51205902,
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
          ["177806901335534371768"] = {
            key = "177806901335534371768",
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
          ["177806901335534371769"] = {
            key = "177806901335534371769",
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
          ["177806901335534371770"] = {
            key = "177806901335534371770",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1694.3333333333333, y = 252.33333333333334},
            propsData = {
              VarName = "Scenpc_512057",
              VarValue = 2
            }
          },
          ["177806901335534371771"] = {
            key = "177806901335534371771",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1237.5, y = 497.66666666666674},
            propsData = {
              Branches = {512059, 5120592}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
