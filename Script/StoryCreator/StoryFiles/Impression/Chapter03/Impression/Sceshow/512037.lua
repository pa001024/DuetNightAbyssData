return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17780585506611467",
      startPort = "StoryStart",
      endStory = "17780585613421694",
      endPort = "In"
    },
    {
      startStory = "17780585613421694",
      startPort = "Success",
      endStory = "17780585506611470",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17780585506611467"] = {
      isStoryNode = true,
      key = "17780585506611467",
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
    ["17780585506611470"] = {
      isStoryNode = true,
      key = "17780585506611470",
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
    ["17780585613421694"] = {
      isStoryNode = true,
      key = "17780585613421694",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1536, y = 316},
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
            startQuest = "17780585613421695",
            startPort = "QuestStart",
            endQuest = "1778058997315941018",
            endPort = "In"
          },
          {
            startQuest = "1778058997315941018",
            startPort = "false",
            endQuest = "17780585766552209",
            endPort = "In"
          },
          {
            startQuest = "1778058997315941018",
            startPort = "true",
            endQuest = "1778059039612942033",
            endPort = "In"
          },
          {
            startQuest = "17780585766552209",
            startPort = "Out",
            endQuest = "1778059077932942861",
            endPort = "In"
          },
          {
            startQuest = "1778059077932942861",
            startPort = "Out",
            endQuest = "17780585613421698",
            endPort = "Success"
          },
          {
            startQuest = "1778059039612942033",
            startPort = "Out",
            endQuest = "17780585613421698",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17780585613421695"] = {
            key = "17780585613421695",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17780585613421698"] = {
            key = "17780585613421698",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["17780585613421701"] = {
            key = "17780585613421701",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17780585766552209"] = {
            key = "17780585766552209",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1574.8, y = 285.6},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51203701,
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
          ["1778058997315941018"] = {
            key = "1778058997315941018",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1175.9999999999998, y = 244},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_512307",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["1778059039612942033"] = {
            key = "1778059039612942033",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 55.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51203715,
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
          ["1778059077932942861"] = {
            key = "1778059077932942861",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1938.9916666666668, y = 304.8500000000001},
            propsData = {
              VarName = "Scenpc_512307",
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
