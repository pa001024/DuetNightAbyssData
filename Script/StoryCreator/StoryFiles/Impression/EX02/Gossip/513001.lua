return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17833374056031413",
      startPort = "StoryStart",
      endStory = "17833374157141785",
      endPort = "In"
    },
    {
      startStory = "17833374157141785",
      startPort = "Success",
      endStory = "17833374056031416",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17833374056031413"] = {
      isStoryNode = true,
      key = "17833374056031413",
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
    ["17833374056031416"] = {
      isStoryNode = true,
      key = "17833374056031416",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1584, y = 326},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17833374157141785"] = {
      isStoryNode = true,
      key = "17833374157141785",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1190, y = 374},
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17833374157141786",
            startPort = "QuestStart",
            endQuest = "1783394427614933",
            endPort = "In"
          },
          {
            startQuest = "178341027480210890543",
            startPort = "Out",
            endQuest = "17833374157151789",
            endPort = "Success"
          },
          {
            startQuest = "1783394427614933",
            startPort = "false",
            endQuest = "17833374541792449",
            endPort = "In"
          },
          {
            startQuest = "17833374541792449",
            startPort = "Out",
            endQuest = "178341027480210890543",
            endPort = "In"
          },
          {
            startQuest = "1783394427614933",
            startPort = "true",
            endQuest = "17833944572791691",
            endPort = "In"
          },
          {
            startQuest = "17833944572791691",
            startPort = "Out",
            endQuest = "17833374157151789",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17833374157141786"] = {
            key = "17833374157141786",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 662, y = 284},
            propsData = {ModeType = 0}
          },
          ["17833374157151789"] = {
            key = "17833374157151789",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1868.125, y = 309.375},
            propsData = {ModeType = 0}
          },
          ["17833374157151792"] = {
            key = "17833374157151792",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17833374541792449"] = {
            key = "17833374541792449",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1344.5, y = 710},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51300101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
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
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1783394427614933"] = {
            key = "1783394427614933",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 958, y = 308},
            propsData = {
              FunctionName = "Equal",
              VarName = "Scenpc_513001",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17833944572791691"] = {
            key = "17833944572791691",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1430, y = 356},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
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
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178341027480210890543"] = {
            key = "178341027480210890543",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1676, y = 714},
            propsData = {
              VarName = "Scenpc_513001",
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
