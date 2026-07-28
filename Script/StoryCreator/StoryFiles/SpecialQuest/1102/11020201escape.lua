return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781531329384502",
      startPort = "Success",
      endStory = "1781531329384503",
      endPort = "In"
    },
    {
      startStory = "1781531329384503",
      startPort = "Success",
      endStory = "1781531329384504",
      endPort = "In"
    },
    {
      startStory = "1781531329384504",
      startPort = "Success",
      endStory = "1781531329384505",
      endPort = "In"
    },
    {
      startStory = "17815312618741",
      startPort = "StoryStart",
      endStory = "1781531329384502",
      endPort = "In"
    },
    {
      startStory = "178168239271614715923",
      startPort = "Success",
      endStory = "17815312618745",
      endPort = "StoryEnd"
    },
    {
      startStory = "1781531329384505",
      startPort = "Success",
      endStory = "178168239271614715922",
      endPort = "In"
    },
    {
      startStory = "178168239271614715922",
      startPort = "Success",
      endStory = "178168239271614715923",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17815312618741"] = {
      isStoryNode = true,
      key = "17815312618741",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 809.7391304347825, y = 207.3913043478261},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815312618745"] = {
      isStoryNode = true,
      key = "17815312618745",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1957.317438055166, y = 347.74894810659185},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781531329384502"] = {
      isStoryNode = true,
      key = "1781531329384502",
      type = "StoryNode",
      name = "山谷苏醒危机",
      pos = {x = 1097.6908137125936, y = 200.06645667020234},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01a",
        QuestDeatil = "Content_110202_01a",
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
            startQuest = "17815320308382619",
            startPort = "Out",
            endQuest = "17815775959242100231",
            endPort = "In"
          },
          {
            startQuest = "17815320308382619",
            startPort = "Out",
            endQuest = "17815778711223149814",
            endPort = "In"
          },
          {
            startQuest = "17815778711223149814",
            startPort = "Out",
            endQuest = "17815779599983150682",
            endPort = "In"
          },
          {
            startQuest = "17815779599983150682",
            startPort = "Out",
            endQuest = "17815779439053150484",
            endPort = "In"
          },
          {
            startQuest = "17815775959242100231",
            startPort = "Out",
            endQuest = "1781531329388535",
            endPort = "In"
          },
          {
            startQuest = "1781531329388535",
            startPort = "Out",
            endQuest = "17815782636514200585",
            endPort = "In"
          },
          {
            startQuest = "1781531329387531",
            startPort = "QuestStart",
            endQuest = "17815786028294202228",
            endPort = "In"
          },
          {
            startQuest = "17815786028294202228",
            startPort = "true",
            endQuest = "17815320308382619",
            endPort = "In"
          },
          {
            startQuest = "17815782636514200585",
            startPort = "Out",
            endQuest = "17815786628594203460",
            endPort = "In"
          },
          {
            startQuest = "17815786628594203460",
            startPort = "Out",
            endQuest = "1781531329387532",
            endPort = "Success"
          },
          {
            startQuest = "17815786028294202228",
            startPort = "false",
            endQuest = "1781531329387532",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781531329387531"] = {
            key = "1781531329387531",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -315.42105263157896, y = 235.96992481203006},
            propsData = {ModeType = 0}
          },
          ["1781531329387532"] = {
            key = "1781531329387532",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2046.0900401473907, y = 441.13264207057307},
            propsData = {ModeType = 0}
          },
          ["1781531329388533"] = {
            key = "1781531329388533",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2046.8363636363636, y = 565.7636363636364},
            propsData = {}
          },
          ["1781531329388535"] = {
            key = "1781531329388535",
            type = "TalkNode",
            name = "【Ver0105_SC003】法露茜出现过场",
            pos = {x = 1233.111221756607, y = 163.89052963334996},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC005/SQ_OBT0050_SC005_EF.SQ_OBT0050_SC005'",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17815320308382619"] = {
            key = "17815320308382619",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 512.1366599931507, y = 128.0535442498679},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "tp_lxzx_rebirth01",
              StaticCreatorIdList = {
                142800007,
                142800006,
                142800005,
                142800004,
                142800009
              }
            }
          },
          ["17815775959242100231"] = {
            key = "17815775959242100231",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 877.7610735766385, y = 150.01321146071052},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                142800007,
                142800006,
                142800005,
                142800004,
                142800009
              }
            }
          },
          ["17815778711223149814"] = {
            key = "17815778711223149814",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 869.5792553948202, y = 1.3768478243468252},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11110001,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17815779439053150484"] = {
            key = "17815779439053150484",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1376.5848041938475, y = -21.9072354836496},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11110002,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17815779599983150682"] = {
            key = "17815779599983150682",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1126.9694195784627, y = -31.138004714418713},
            propsData = {WaitTime = 4}
          },
          ["17815782636514200585"] = {
            key = "17815782636514200585",
            type = "TalkNode",
            name = "【Ex02_FixSimple_14】",
            pos = {x = 1601.2001888092316, y = 180.01584143942728},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020114.11020114'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17815786028294202228"] = {
            key = "17815786028294202228",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 120.14165438027386, y = 223.18631570200705},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17815786628594203460"] = {
            key = "17815786628594203460",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1915.8684060039357, y = 174.8109163937132},
            propsData = {
              VarName = "ex02_11020201",
              VarValue = 1
            }
          }
        },
        commentData = {
          ["17815779740323150992"] = {
            key = "17815779740323150992",
            name = "战斗结束后播放",
            position = {x = 1088.8924965015397, y = -78.44569702211109},
            size = {width = 601.1538461538462, height = 195}
          }
        }
      }
    },
    ["1781531329384503"] = {
      isStoryNode = true,
      key = "1781531329384503",
      type = "StoryNode",
      name = "深入洞窟聊天",
      pos = {x = 1408.7091670449702, y = 193.17172750507711},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01b",
        QuestDeatil = "Content_110202_01b",
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
            startQuest = "1781531329392559",
            startPort = "Out",
            endQuest = "1781531329392561",
            endPort = "In"
          },
          {
            startQuest = "17815795691264208192",
            startPort = "Out",
            endQuest = "1781531329392559",
            endPort = "In"
          },
          {
            startQuest = "17815801545884208929",
            startPort = "Out",
            endQuest = "17815795691264208192",
            endPort = "In"
          },
          {
            startQuest = "17815801545884208929",
            startPort = "Out",
            endQuest = "1781531329391556",
            endPort = "In"
          },
          {
            startQuest = "1781531329392561",
            startPort = "Out",
            endQuest = "1781531329392563",
            endPort = "In"
          },
          {
            startQuest = "1781531329391553",
            startPort = "QuestStart",
            endQuest = "17816765261146308639",
            endPort = "In"
          },
          {
            startQuest = "17816765261146308639",
            startPort = "true",
            endQuest = "17815801545884208929",
            endPort = "In"
          },
          {
            startQuest = "17816765425756309116",
            startPort = "Out",
            endQuest = "1781531329391554",
            endPort = "Success"
          },
          {
            startQuest = "17816765261146308639",
            startPort = "false",
            endQuest = "1781531329391554",
            endPort = "Success"
          },
          {
            startQuest = "1781531329392563",
            startPort = "Out",
            endQuest = "178167862295110513356",
            endPort = "In"
          },
          {
            startQuest = "178167862295110513356",
            startPort = "Out",
            endQuest = "17816765425756309116",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781531329391553"] = {
            key = "1781531329391553",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -221.66079915507854, y = 303.49586340433024},
            propsData = {ModeType = 0}
          },
          ["1781531329391554"] = {
            key = "1781531329391554",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2235.784475186649, y = 485.6484467096596},
            propsData = {ModeType = 0}
          },
          ["1781531329391555"] = {
            key = "1781531329391555",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2403.181818181818, y = 601.8181818181818},
            propsData = {}
          },
          ["1781531329391556"] = {
            key = "1781531329391556",
            type = "ChangeStaticCreatorNode",
            name = "生成法露茜&伊薇",
            pos = {x = 783.7532352063118, y = 146.66417320687222},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800010, 142800011}
            }
          },
          ["1781531329391557"] = {
            key = "1781531329391557",
            type = "ChangeStaticCreatorNode",
            name = "销毁法露茜&伊薇",
            pos = {x = 1615.61855477589, y = -65.95421897346264},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781531329392558"] = {
            key = "1781531329392558",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1078.1877927818432, y = -287.7989383995106},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781531329392559"] = {
            key = "1781531329392559",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1114.1298217673504, y = 307.4133677281275},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800012,
              GuideType = "M",
              GuidePointName = "Mechanism_trigger_chaoxue01_142800012"
            }
          },
          ["1781531329392560"] = {
            key = "1781531329392560",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1927.2280404598619, y = 805.9781513837713},
            propsData = {SpecialConfigId = 0, BlackScreenImmediately = false}
          },
          ["1781531329392561"] = {
            key = "1781531329392561",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1396.5675283526543, y = 220.47210151912662},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781531329392562"] = {
            key = "1781531329392562",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1591.4153469614103, y = 942.3653202864202},
            propsData = {
              KillMonsterType = "Nums",
              MonsterNeedNums = 1,
              IsShow = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781531329392563"] = {
            key = "1781531329392563",
            type = "TalkNode",
            name = "【Ex02_FixSimple_15】：暂时和法露茜和解",
            pos = {x = 1693.388443453318, y = 224.9493569105698},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020115.11020115'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17815795691264208192"] = {
            key = "17815795691264208192",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 779.8655096365624, y = 324.8180960661517},
            propsData = {
              Rate = 0.15,
              Mode = "EWT_Damaged"
            }
          },
          ["17815801545884208929"] = {
            key = "17815801545884208929",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 474.81295349704953, y = 278.7118689599243},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_rebirth02",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17816765261146308639"] = {
            key = "17816765261146308639",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 97.83896475824687, y = 539.9925831155491},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17816765425756309116"] = {
            key = "17816765425756309116",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2218.7161577407032, y = 208.32591644888223},
            propsData = {
              VarName = "ex02_11020201",
              VarValue = 2
            }
          },
          ["178167862295110513356"] = {
            key = "178167862295110513356",
            type = "ChangeStaticCreatorNode",
            name = "生成法露茜&伊薇",
            pos = {x = 1937.3812097939133, y = 194.0270683671399},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800010, 142800011}
            }
          }
        },
        commentData = {}
      }
    },
    ["1781531329384504"] = {
      isStoryNode = true,
      key = "1781531329384504",
      type = "StoryNode",
      name = "洞窟入口观察",
      pos = {x = 1715.343669046027, y = 190.93007406373295},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01c",
        QuestDeatil = "Content_110202_01c",
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
            startQuest = "1781531329399601",
            startPort = "QuestStart",
            endQuest = "17816769929717359704",
            endPort = "In"
          },
          {
            startQuest = "17816769929717359704",
            startPort = "true",
            endQuest = "17816774718257362340",
            endPort = "In"
          },
          {
            startQuest = "17816774718257362340",
            startPort = "Out",
            endQuest = "1781531329399604",
            endPort = "In"
          },
          {
            startQuest = "1781531329399604",
            startPort = "Out",
            endQuest = "17816776871228411808",
            endPort = "In"
          },
          {
            startQuest = "17816776871228411808",
            startPort = "Out",
            endQuest = "17816782896788414384",
            endPort = "In"
          },
          {
            startQuest = "17816782896788414384",
            startPort = "Out",
            endQuest = "1781531329399602",
            endPort = "Success"
          },
          {
            startQuest = "17816769929717359704",
            startPort = "false",
            endQuest = "17816783899149463472",
            endPort = "In"
          },
          {
            startQuest = "17816783899149463472",
            startPort = "Out",
            endQuest = "1781531329399602",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781531329399601"] = {
            key = "1781531329399601",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 454.3999999999999, y = 292.8},
            propsData = {ModeType = 0}
          },
          ["1781531329399602"] = {
            key = "1781531329399602",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2427.914285714286, y = 489.79285714285726},
            propsData = {ModeType = 0}
          },
          ["1781531329399603"] = {
            key = "1781531329399603",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781531329399604"] = {
            key = "1781531329399604",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1205.843549923838, y = 237.49906464198426},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800014,
              GuideType = "M",
              GuidePointName = "Mechanism_trigger_chaoxue02_142800014"
            }
          },
          ["1781531329399605"] = {
            key = "1781531329399605",
            type = "TalkNode",
            name = "1.3.4 【特殊演出】：洞窟内都是怪物",
            pos = {x = 1864.5534344837229, y = 828.692066084986},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17816769929717359704"] = {
            key = "17816769929717359704",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 670.8807330827065, y = 460.208395989975},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17816774718257362340"] = {
            key = "17816774718257362340",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 935.5898239917972, y = 312.0083959899751},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_rebirth02",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17816776871228411808"] = {
            key = "17816776871228411808",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1549.0153839390966, y = 277.8669818485608},
            propsData = {
              StaticCreatorId = 142800015,
              UnitId = 20654,
              bGuideUIEnable = true,
              GuidePointName = "Drop_read_juntuanluyin_142800015",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["17816782896788414384"] = {
            key = "17816782896788414384",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2068.1893155630282, y = 230.33834936992838},
            propsData = {
              VarName = "ex02_11020201",
              VarValue = 2
            }
          },
          ["17816783899149463472"] = {
            key = "17816783899149463472",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1113.578730596776, y = 489.56789542175846},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_rebirth02",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["17816776152648410560"] = {
            key = "17816776152648410560",
            name = "巢穴-观察者模式需要接入",
            position = {x = 1104.570939494652, y = 105.64475962633848},
            size = {width = 551.1111111111112, height = 103.3333333333334}
          },
          ["17816781704418412319"] = {
            key = "17816781704418412319",
            name = "要改id的",
            position = {x = 1565.6820506057632, y = 210.08920407078298},
            size = {width = 172.22222222222229, height = 66.6666666666667}
          }
        }
      }
    },
    ["1781531329384505"] = {
      isStoryNode = true,
      key = "1781531329384505",
      type = "StoryNode",
      name = "合作潜行",
      pos = {x = 1106.3793596867524, y = 386.2963127428638},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01d",
        QuestDeatil = "Content_110202_01d",
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
            startQuest = "1781531329403628",
            startPort = "Out",
            endQuest = "1781531329403625",
            endPort = "In"
          },
          {
            startQuest = "1781531329403626",
            startPort = "Out",
            endQuest = "1781531329403627",
            endPort = "In"
          },
          {
            startQuest = "1781531329403627",
            startPort = "Out",
            endQuest = "178168140058312614716",
            endPort = "In"
          },
          {
            startQuest = "178168140058312614716",
            startPort = "Out",
            endQuest = "1781531329404629",
            endPort = "In"
          },
          {
            startQuest = "1781531329404629",
            startPort = "Out",
            endQuest = "178168156980812616090",
            endPort = "In"
          },
          {
            startQuest = "1781531329403621",
            startPort = "QuestStart",
            endQuest = "178168319079017869021",
            endPort = "In"
          },
          {
            startQuest = "178168319079017869021",
            startPort = "true",
            endQuest = "1781531329403626",
            endPort = "In"
          },
          {
            startQuest = "178168319079017869021",
            startPort = "false",
            endQuest = "178168323491117869863",
            endPort = "In"
          },
          {
            startQuest = "178168323491117869863",
            startPort = "true",
            endQuest = "1781531329403627",
            endPort = "In"
          },
          {
            startQuest = "178168323491117869863",
            startPort = "false",
            endQuest = "178168333506218920555",
            endPort = "In"
          },
          {
            startQuest = "178168333506218920555",
            startPort = "false",
            endQuest = "1781531329403622",
            endPort = "Success"
          },
          {
            startQuest = "178168333506218920555",
            startPort = "true",
            endQuest = "1781531329403622",
            endPort = "Success"
          },
          {
            startQuest = "178168156980812616090",
            startPort = "Out",
            endQuest = "178168348430119972970",
            endPort = "In"
          },
          {
            startQuest = "178168348430119972970",
            startPort = "Out",
            endQuest = "1781531329403622",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781531329403621"] = {
            key = "1781531329403621",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 308.83626177743815, y = 282.5490196078431},
            propsData = {ModeType = 0}
          },
          ["1781531329403622"] = {
            key = "1781531329403622",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3118.908722856092, y = 388.79192015414924},
            propsData = {ModeType = 0}
          },
          ["1781531329403623"] = {
            key = "1781531329403623",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781531329403624"] = {
            key = "1781531329403624",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇&法露茜",
            pos = {x = 1467.5333333333333, y = -59.533333333333374},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781531329403625"] = {
            key = "1781531329403625",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇&法露茜",
            pos = {x = 2197.4947368421053, y = -13.81052631578956},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781531329403626"] = {
            key = "1781531329403626",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1118.8470588235293, y = 251.76470588235287},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800016,
              GuideType = "M",
              GuidePointName = "Mechanism_trigger_chaoxue03_142800016"
            }
          },
          ["1781531329403627"] = {
            key = "1781531329403627",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1522.235294117647, y = 218.39999999999998},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800017,
              GuideType = "M",
              GuidePointName = "Mechanism_trigger_chaoxue04_142800017"
            }
          },
          ["1781531329403628"] = {
            key = "1781531329403628",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1898.5684210526317, y = -32.82105263157894},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781531329404629"] = {
            key = "1781531329404629",
            type = "TalkNode",
            name = "EX02_Fix_SEQ_02",
            pos = {x = 2157.0804242062954, y = 216.5627425340844},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020129.11020129'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178168140058312614716"] = {
            key = "178168140058312614716",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1849.0195463310115, y = 235.1359747818621},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11103601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178168156980812616090"] = {
            key = "178168156980812616090",
            type = "TalkNode",
            name = "Ex02_FixSimple_16",
            pos = {x = 2447.372487507482, y = 215.95950419362677},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020116.11020116'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178168319079017869021"] = {
            key = "178168319079017869021",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 688.8350543524016, y = 402.85323791088996},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "3"}
              }
            }
          },
          ["178168323491117869863"] = {
            key = "178168323491117869863",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1084.289599806947, y = 600.7063847640368},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "4"}
              }
            }
          },
          ["178168325907017870415"] = {
            key = "178168325907017870415",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1042.289599806947, y = -97.29361523596322},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178168333506218920555"] = {
            key = "178168333506218920555",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1525.9212873402598, y = 608.4105592273446},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "5"}
              }
            }
          },
          ["178168348430119972970"] = {
            key = "178168348430119972970",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2753.991988697726, y = 215.62436013232164},
            propsData = {
              VarName = "ex02_11020201",
              VarValue = 6
            }
          }
        },
        commentData = {}
      }
    },
    ["1781531329385506"] = {
      isStoryNode = true,
      key = "1781531329385506",
      type = "StoryNode",
      name = "快速逃离",
      pos = {x = 1679.06708135838, y = -208.11658665297125},
      propsData = {
        QuestId = 11020134,
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
            startQuest = "1781531329408659",
            startPort = "QuestStart",
            endQuest = "1781531329408662",
            endPort = "In"
          },
          {
            startQuest = "1781531329408662",
            startPort = "Out",
            endQuest = "1781531329408665",
            endPort = "In"
          },
          {
            startQuest = "1781531329408662",
            startPort = "Out",
            endQuest = "1781531329408666",
            endPort = "In"
          },
          {
            startQuest = "1781531329408662",
            startPort = "Out",
            endQuest = "1781531329408660",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781531329408659"] = {
            key = "1781531329408659",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781531329408660"] = {
            key = "1781531329408660",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1802.105263157895, y = 271.5789473684211},
            propsData = {ModeType = 0}
          },
          ["1781531329408661"] = {
            key = "1781531329408661",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781531329408662"] = {
            key = "1781531329408662",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1183.7628458498023, y = 292.49011857707507},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781531329408663"] = {
            key = "1781531329408663",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1898.1205533596835, y = -154.07015810276684},
            propsData = {
              MessageType = "GameMode",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["1781531329408664"] = {
            key = "1781531329408664",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1897.198757763975, y = -3.8711180124223894},
            propsData = {
              MessageType = "GameMode",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["1781531329408665"] = {
            key = "1781531329408665",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1470.215415019763, y = -109.76185770750993},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781531329408666"] = {
            key = "1781531329408666",
            type = "ChangeStaticCreatorNode",
            name = "生成法露茜",
            pos = {x = 1464.1792772444946, y = 27.86042855195779},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          }
        },
        commentData = {}
      }
    },
    ["178168239271614715921"] = {
      isStoryNode = true,
      key = "178168239271614715921",
      type = "StoryNode",
      name = "护送伊薇",
      pos = {x = 1359.3669903068926, y = -132.08134337986598},
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
            startQuest = "178168239271814715938",
            startPort = "QuestStart",
            endQuest = "178168239271814715941",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715941",
            startPort = "Out",
            endQuest = "178168239271814715942",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715942",
            startPort = "Out",
            endQuest = "178168239271814715943",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715943",
            startPort = "Out",
            endQuest = "178168239271814715945",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715945",
            startPort = "Out",
            endQuest = "178168239271814715944",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715944",
            startPort = "Out",
            endQuest = "178168239271814715946",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715946",
            startPort = "Out",
            endQuest = "178168239271814715947",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715947",
            startPort = "Out",
            endQuest = "178168239271814715948",
            endPort = "In"
          },
          {
            startQuest = "178168239271814715948",
            startPort = "Out",
            endQuest = "178168239271814715940",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178168239271814715938"] = {
            key = "178168239271814715938",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 794, y = 305},
            propsData = {ModeType = 0}
          },
          ["178168239271814715939"] = {
            key = "178168239271814715939",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2731.2, y = 542.5},
            propsData = {ModeType = 0}
          },
          ["178168239271814715940"] = {
            key = "178168239271814715940",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2608, y = 878.8},
            propsData = {}
          },
          ["178168239271814715941"] = {
            key = "178168239271814715941",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1069.1366310892172, y = 285.53296919739415},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239271814715942"] = {
            key = "178168239271814715942",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1333.7696993335, y = 282.35545777959214},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["178168239271814715943"] = {
            key = "178168239271814715943",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1623.2579584428122, y = 273.67651041117097},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239271814715944"] = {
            key = "178168239271814715944",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1614.2579584428124, y = 620.8765104111709},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239271814715945"] = {
            key = "178168239271814715945",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1922.612626563298, y = 276.1408653549115},
            propsData = {
              MessageType = "GameMode",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["178168239271814715946"] = {
            key = "178168239271814715946",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1916.0126265632978, y = 619.6408653549115},
            propsData = {
              MessageType = "GameMode",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["178168239271814715947"] = {
            key = "178168239271814715947",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1895.9067824074539, y = 886.2252809393269},
            propsData = {WaitTime = 5}
          },
          ["178168239271814715948"] = {
            key = "178168239271814715948",
            type = "TalkNode",
            name = "1.3.8 【过场演出】：法露茜救场",
            pos = {x = 2231.449639550311, y = 876.9681380821843},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {
          ["1768551295210766297"] = {
            key = "1768551295210766297",
            name = "护送一阶段",
            position = {x = 1588.4165791324672, y = 182.56003531538556},
            size = {width = 619.1960474308305, height = 267.88083003952596}
          },
          ["1768551308061766559"] = {
            key = "1768551308061766559",
            name = "护送二阶段",
            position = {x = 1568.0165791324675, y = 507.76003531538566},
            size = {width = 651.5960474308303, height = 291.8808300395259}
          }
        }
      }
    },
    ["178168239271614715922"] = {
      isStoryNode = true,
      key = "178168239271614715922",
      type = "StoryNode",
      name = "护送流程",
      pos = {x = 1389.5496856357531, y = 369.3273030944617},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110202_01e",
        QuestDeatil = "Content_110202_01e",
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
            startQuest = "178168239272414715988",
            startPort = "Out",
            endQuest = "178168239272414715989",
            endPort = "In"
          },
          {
            startQuest = "178168239272414715990",
            startPort = "Out",
            endQuest = "178168239272414715988",
            endPort = "In"
          },
          {
            startQuest = "178168301593214719901",
            startPort = "Out",
            endQuest = "178168239272414715986",
            endPort = "Success"
          },
          {
            startQuest = "178168239272414715985",
            startPort = "QuestStart",
            endQuest = "178168340668319971185",
            endPort = "In"
          },
          {
            startQuest = "178168340668319971185",
            startPort = "false",
            endQuest = "178168341333119971298",
            endPort = "In"
          },
          {
            startQuest = "178168239272414715985",
            startPort = "QuestStart",
            endQuest = "178168301593214719901",
            endPort = "In"
          }
        },
        nodeData = {
          ["178168239272414715985"] = {
            key = "178168239272414715985",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 461.1428571428571, y = 227.85714285714283},
            propsData = {ModeType = 0}
          },
          ["178168239272414715986"] = {
            key = "178168239272414715986",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1954, y = 286.5},
            propsData = {ModeType = 0}
          },
          ["178168239272414715987"] = {
            key = "178168239272414715987",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178168239272414715988"] = {
            key = "178168239272414715988",
            type = "TalkNode",
            name = "【过场演出】：法露茜启动炮台",
            pos = {x = 1574.2857142857144, y = -134.14285714285717},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178168239272414715989"] = {
            key = "178168239272414715989",
            type = "TalkNode",
            name = "【Ex02_FixSimple_16】：三人探讨离开的方法",
            pos = {x = 1842.080357142857, y = -157.3839285714286},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
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
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178168239272414715990"] = {
            key = "178168239272414715990",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1251.99377394636, y = -157.32417365974877},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168301593214719901"] = {
            key = "178168301593214719901",
            type = "TalkNode",
            name = "Ver0105_SC005",
            pos = {x = 1397.4642857142858, y = 248.17857142857127},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC005/SQ_OBT0050_SC005_EF.SQ_OBT0050_SC005'",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178168340668319971185"] = {
            key = "178168340668319971185",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 611.7500000000001, y = 438.2499999999999},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "6"}
              }
            }
          },
          ["178168341333119971298"] = {
            key = "178168341333119971298",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 853.1785714285714, y = 738.2499999999998},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "7"}
              }
            }
          }
        },
        commentData = {
          ["178168309329715769645"] = {
            key = "178168309329715769645",
            name = "分段记录",
            position = {x = 1003.1785714285716, y = 83.96428571428565},
            size = {width = 237.142857142857, height = 44.28571428571413}
          }
        }
      }
    },
    ["178168239271614715923"] = {
      isStoryNode = true,
      key = "178168239271614715923",
      type = "StoryNode",
      name = "轨道滑行",
      pos = {x = 1657.4101666368251, y = 364.9813269003169},
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
            startQuest = "178168239272714716018",
            startPort = "Out",
            endQuest = "178168239272614716013",
            endPort = "Success"
          },
          {
            startQuest = "178168239272614716012",
            startPort = "QuestStart",
            endQuest = "178168406803323127061",
            endPort = "In"
          },
          {
            startQuest = "178168406803323127061",
            startPort = "Out",
            endQuest = "178168239272714716018",
            endPort = "In"
          }
        },
        nodeData = {
          ["178168239272614716012"] = {
            key = "178168239272614716012",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 624.4360902255639, y = 285.7142857142857},
            propsData = {ModeType = 0}
          },
          ["178168239272614716013"] = {
            key = "178168239272614716013",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2702.1052631578946, y = 279.4736842105263},
            propsData = {ModeType = 0}
          },
          ["178168239272614716014"] = {
            key = "178168239272614716014",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178168239272614716015"] = {
            key = "178168239272614716015",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1247.7894736842106, y = 523.7293233082706},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239272614716016"] = {
            key = "178168239272614716016",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1573.3684210526317, y = 478.42105263157896},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239272714716017"] = {
            key = "178168239272714716017",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1824.6315789473683, y = 443.36842105263156},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["178168239272714716018"] = {
            key = "178168239272714716018",
            type = "TalkNode",
            name = "【Ver0105_SC006】主角救法露茜",
            pos = {x = 2326.5263157894738, y = 276.94736842105254},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC006/SQ_Ver0105_SC006_EF.SQ_Ver0105_SC006'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178168406803323127061"] = {
            key = "178168406803323127061",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 940.8378312863606, y = 294.1276664511958},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx_reborth04",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
