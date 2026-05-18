return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17783183547233444417",
      startPort = "StoryStart",
      endStory = "17783183547233444419",
      endPort = "In"
    },
    {
      startStory = "17783183547233444419",
      startPort = "Success",
      endStory = "17783183547233444418",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17783183547233444417"] = {
      isStoryNode = true,
      key = "17783183547233444417",
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
    ["17783183547233444418"] = {
      isStoryNode = true,
      key = "17783183547233444418",
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
    ["17783183547233444419"] = {
      isStoryNode = true,
      key = "17783183547233444419",
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
            startQuest = "17783183547233444424",
            startPort = "Out",
            endQuest = "17783183547233444422",
            endPort = "Success"
          },
          {
            startQuest = "17783183547233444421",
            startPort = "QuestStart",
            endQuest = "17783183547233444424",
            endPort = "In"
          }
        },
        nodeData = {
          ["17783183547233444420"] = {
            key = "17783183547233444420",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1580.5, y = 700.0789473684213},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51206701,
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
          ["17783183547233444421"] = {
            key = "17783183547233444421",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 889.55, y = 489.30000000000007},
            propsData = {ModeType = 0}
          },
          ["17783183547233444422"] = {
            key = "17783183547233444422",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["17783183547233444423"] = {
            key = "17783183547233444423",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 564},
            propsData = {}
          },
          ["17783183547233444424"] = {
            key = "17783183547233444424",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1570.85, y = 452.8666666666667},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51202302,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17783183547233444425"] = {
            key = "17783183547233444425",
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
          ["17783183547233444426"] = {
            key = "17783183547233444426",
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
          ["17783183547233444427"] = {
            key = "17783183547233444427",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1694.3333333333333, y = 252.33333333333334},
            propsData = {
              VarName = "Scenpc_512057",
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
