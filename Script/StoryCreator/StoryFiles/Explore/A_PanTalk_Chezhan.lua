return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17413419832852417503",
      startPort = "StoryStart",
      endStory = "17413419832852417505",
      endPort = "In"
    },
    {
      startStory = "17413419832852417505",
      startPort = "Success",
      endStory = "17413419832852417504",
      endPort = "StoryEnd"
    },
    {
      startStory = "17413419832852417505",
      startPort = "Fail",
      endStory = "17413419832852417504",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17413419832852417503"] = {
      isStoryNode = true,
      key = "17413419832852417503",
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
    ["17413419832852417504"] = {
      isStoryNode = true,
      key = "17413419832852417504",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17413419832852417505"] = {
      isStoryNode = true,
      key = "17413419832852417505",
      type = "StoryNode",
      name = "火车站区域潘神对话",
      pos = {x = 1524, y = 314},
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
            startQuest = "17413419832852417519",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17413419832852417506",
            startPort = "QuestStart",
            endQuest = "17413419832852417510",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_1",
            endQuest = "17413419832852417519",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_2",
            endQuest = "1776322076253918763",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_3",
            endQuest = "1776322080245918906",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_4",
            endQuest = "1776322080245918907",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_5",
            endQuest = "1776322083771919027",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_6",
            endQuest = "1776322083771919028",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_7",
            endQuest = "1776322083771919029",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_8",
            endQuest = "1776322083771919030",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_9",
            endQuest = "1776322086959919145",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_10",
            endQuest = "1776322086959919146",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_11",
            endQuest = "1776322086959919147",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_12",
            endQuest = "1776322086960919148",
            endPort = "In"
          },
          {
            startQuest = "1776322076253918763",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322080245918906",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322080245918907",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322083771919027",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322083771919028",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322083771919029",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322083771919030",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322086959919145",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322086959919146",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322086959919147",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "1776322086960919148",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_13",
            endQuest = "17766679499161662",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_14",
            endQuest = "17766679499161663",
            endPort = "In"
          },
          {
            startQuest = "17766679499161662",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17766679499161663",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_15",
            endQuest = "17768441313311619",
            endPort = "In"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_16",
            endQuest = "17768441313311620",
            endPort = "In"
          },
          {
            startQuest = "17768441313311619",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17768441313311620",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          },
          {
            startQuest = "17413419832852417510",
            startPort = "Branch_17",
            endQuest = "1776844204505926186",
            endPort = "In"
          },
          {
            startQuest = "1776844204505926186",
            startPort = "Out",
            endQuest = "17413419832852417507",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17413419832852417506"] = {
            key = "17413419832852417506",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 137.62626262626247, y = 546.808080808081},
            propsData = {ModeType = 0}
          },
          ["17413419832852417507"] = {
            key = "17413419832852417507",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2862.4721190327596, y = 360.5422597996967},
            propsData = {ModeType = 0}
          },
          ["17413419832852417508"] = {
            key = "17413419832852417508",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3138.909090909091, y = 145.63636363636363},
            propsData = {}
          },
          ["17413419832852417510"] = {
            key = "17413419832852417510",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 801.5128205128204, y = 319.2820512820513},
            propsData = {
              Branches = {
                720047,
                720048,
                720049,
                720050,
                720051,
                720052,
                720053,
                720054,
                720055,
                720056,
                720057,
                720058,
                720059,
                720060,
                720061,
                720062,
                720063
              }
            }
          },
          ["17413419832852417519"] = {
            key = "17413419832852417519",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1707.9088992727177, y = -586.1308453619934},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72004701,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720047",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322076253918763"] = {
            key = "1776322076253918763",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1711.060508876865, y = -411.2878349660688},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72004801,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720048",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322080245918906"] = {
            key = "1776322080245918906",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1716.1513707414579, y = -259.9545016327354},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72004901,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720049",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322080245918907"] = {
            key = "1776322080245918907",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1719.3029803456052, y = -87.11149123681082},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005001,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720050",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322083771919027"] = {
            key = "1776322083771919027",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1725.0301350070877, y = 87.60124398567012},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005101,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720051",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322083771919028"] = {
            key = "1776322083771919028",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1730.181744611235, y = 256.4442543815947},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005201,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720052",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322083771919029"] = {
            key = "1776322083771919029",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1735.2726064758278, y = 409.7775877149281},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005301,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720053",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322083771919030"] = {
            key = "1776322083771919030",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1738.4242160799752, y = 582.6205981108526},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005401,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720054",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322086959919145"] = {
            key = "1776322086959919145",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1737.0301350070877, y = 771.9345773190034},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005501,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720055",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322086959919146"] = {
            key = "1776322086959919146",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1740.181744611235, y = 944.7775877149279},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005601,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720056",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322086959919147"] = {
            key = "1776322086959919147",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1745.2726064758278, y = 1096.1109210482614},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005701,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720057",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776322086960919148"] = {
            key = "1776322086960919148",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1746.4242160799752, y = 1272.9539314441859},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005801,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720058",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17766679499161662"] = {
            key = "17766679499161662",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1747.4241951979263, y = 1457.5784948020378},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72005901,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720059",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17766679499161663"] = {
            key = "17766679499161663",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1748.5758048020737, y = 1634.4215051979622},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72006001,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720060",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17768441313311619"] = {
            key = "17768441313311619",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1757.4241951979263, y = 1809.5784948020378},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72006101,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720061",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17768441313311620"] = {
            key = "17768441313311620",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1758.5758048020737, y = 1986.4215051979622},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72006201,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720062",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1776844204505926186"] = {
            key = "1776844204505926186",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1760, y = 2154},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 72006301,
              FlowAssetPath = "",
              TalkType = "PanFixSimple",
              TalkStageName = "Stage_720063",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 820000,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
