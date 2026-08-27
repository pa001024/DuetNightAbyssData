return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17817809794271",
      startPort = "StoryStart",
      endStory = "1781781035420294",
      endPort = "In"
    },
    {
      startStory = "1781781035420293",
      startPort = "Success",
      endStory = "17817809794285",
      endPort = "StoryEnd"
    },
    {
      startStory = "1781781035420294",
      startPort = "Success",
      endStory = "1781781035420293",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17817809794271"] = {
      isStoryNode = true,
      key = "17817809794271",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 935, y = 256.875},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17817809794285"] = {
      isStoryNode = true,
      key = "17817809794285",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2289.9427558947796, y = 224.89573395120618},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781781035419289"] = {
      isStoryNode = true,
      key = "1781781035419289",
      type = "StoryNode",
      name = "主线开启",
      pos = {x = 1085.5326332939185, y = -1006.0279378142081},
      propsData = {
        QuestId = 11020101,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_01",
        QuestDeatil = "Content_110201_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestPoint_EX01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1781781035427326",
            startPort = "Out",
            endQuest = "1781781035427329",
            endPort = "In"
          },
          {
            startQuest = "1781781035427328",
            startPort = "True",
            endQuest = "1781781035427327",
            endPort = "In"
          },
          {
            startQuest = "1781781035427330",
            startPort = "Out",
            endQuest = "1781781035427326",
            endPort = "In"
          },
          {
            startQuest = "1781781035427330",
            startPort = "Out",
            endQuest = "1781781035428332",
            endPort = "In"
          },
          {
            startQuest = "1781781035428332",
            startPort = "Out",
            endQuest = "1781781035428333",
            endPort = "In"
          },
          {
            startQuest = "1781781035428334",
            startPort = "false",
            endQuest = "1781781035427330",
            endPort = "In"
          },
          {
            startQuest = "1781781035427328",
            startPort = "False",
            endQuest = "1781781035426325",
            endPort = "Fail"
          },
          {
            startQuest = "1781781035426323",
            startPort = "QuestStart",
            endQuest = "1781781035428334",
            endPort = "In"
          },
          {
            startQuest = "1781781035428334",
            startPort = "true",
            endQuest = "1781781035428336",
            endPort = "In"
          },
          {
            startQuest = "1781781035428336",
            startPort = "Out",
            endQuest = "1781781035427326",
            endPort = "In"
          },
          {
            startQuest = "1781781035427329",
            startPort = "Out",
            endQuest = "1781781035428337",
            endPort = "In"
          },
          {
            startQuest = "1781781035428337",
            startPort = "Out",
            endQuest = "1781781035427328",
            endPort = "Input"
          },
          {
            startQuest = "1781781035429338",
            startPort = "Out",
            endQuest = "1781781035428335",
            endPort = "In"
          },
          {
            startQuest = "1781781035427331",
            startPort = "Out",
            endQuest = "1781781035429338",
            endPort = "In"
          },
          {
            startQuest = "1781781035428332",
            startPort = "Out",
            endQuest = "1781781035429340",
            endPort = "In"
          },
          {
            startQuest = "1781781035429340",
            startPort = "Out",
            endQuest = "1781781035427331",
            endPort = "In"
          },
          {
            startQuest = "1781781035427327",
            startPort = "Out",
            endQuest = "1781781035426324",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035426323"] = {
            key = "1781781035426323",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -446.9230769230769, y = -328.3186813186813},
            propsData = {ModeType = 0}
          },
          ["1781781035426324"] = {
            key = "1781781035426324",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3591.0872167048637, y = -438.7058170158016},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1781781035426325"] = {
            key = "1781781035426325",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3668.3374378459516, y = 140.9306220095694},
            propsData = {}
          },
          ["1781781035427326"] = {
            key = "1781781035427326",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 752.8621800431962, y = -328.91726057758655},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1210081}
            }
          },
          ["1781781035427327"] = {
            key = "1781781035427327",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3246.390812932347, y = -458.9268481012332},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1210081}
            }
          },
          ["1781781035427328"] = {
            key = "1781781035427328",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 2605.2414361037168, y = -292.73758727906136},
            propsData = {PopupId = 100110}
          },
          ["1781781035427329"] = {
            key = "1781781035427329",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1702.2117140948594, y = -318.6197854802973},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 10052,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "QuestPoint_EX01",
              IsUseCount = false
            }
          },
          ["1781781035427330"] = {
            key = "1781781035427330",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 259.8399872694731, y = 90.61741542976387},
            propsData = {
              StaticCreatorIdList = {},
              ManualItemIdList = {121001},
              StateId = 1500110,
              QuestId = 0
            }
          },
          ["1781781035427331"] = {
            key = "1781781035427331",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1579.847968495011, y = 187.18440234919885},
            propsData = {
              StaticCreatorIdList = {},
              ManualItemIdList = {121001},
              StateId = 1500111,
              QuestId = 0
            }
          },
          ["1781781035428332"] = {
            key = "1781781035428332",
            type = "GoToNode",
            name = "前往",
            pos = {x = 823.7715398294757, y = 86.60013978987749},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 1210124,
              GuideType = "M",
              GuidePointName = "Mechanism_Change_1210124"
            }
          },
          ["1781781035428333"] = {
            key = "1781781035428333",
            type = "CameraLookAtNode",
            name = "CameraLookAt",
            pos = {x = 1241.8170580367594, y = -26.493103568071785},
            propsData = {
              TargetType = "Point",
              PointName = "QuestPoint_EX01",
              ActorId = 0,
              Duration = 2,
              EasingFunc = 4,
              bDisableUserInput = true
            }
          },
          ["1781781035428334"] = {
            key = "1781781035428334",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -79.62448100594656, y = -340.07721583628614},
            propsData = {
              FunctionName = "Equal",
              VarName = "Entrance110101",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1781781035428335"] = {
            key = "1781781035428335",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2294.0463508920516, y = 107.59233217091523},
            propsData = {
              VarName = "Entrance110101",
              VarValue = 1
            }
          },
          ["1781781035428336"] = {
            key = "1781781035428336",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 267.979820875719, y = -339.03676470588266},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035428337"] = {
            key = "1781781035428337",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2068.828560371517, y = -312.9963235294122},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035429338"] = {
            key = "1781781035429338",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2015.4952270381843, y = 91.17034313725443},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035429339"] = {
            key = "1781781035429339",
            type = "CollisionBoxNode",
            name = "进入/离开判定盒节点",
            pos = {x = 1108.2544243625987, y = -910.1246393206114},
            propsData = {StaticCreatorId = 1210124}
          },
          ["1781781035429340"] = {
            key = "1781781035429340",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1260.2399670734087, y = 192.0606423333836},
            propsData = {WaitTime = 1}
          },
          ["1781781035429341"] = {
            key = "1781781035429341",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1621.2939131273545, y = -89.03825876551758},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 121001,
              StateId = 1500112,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["1781781035429342"] = {
            key = "1781781035429342",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 3228.660827207299, y = -891.1281809432107},
            propsData = {SpecialConfigId = 11020101, BlackScreenImmediately = false}
          },
          ["1781781035429343"] = {
            key = "1781781035429343",
            type = "SkipRegionNode",
            name = "送回据点",
            pos = {x = 3797.3073934788554, y = -823.9426690866454},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              IsWhite = true
            }
          },
          ["1781781035430344"] = {
            key = "1781781035430344",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 3540.820762678762, y = -829.3443602915258},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1781781035420293"] = {
      isStoryNode = true,
      key = "1781781035420293",
      type = "StoryNode",
      name = "前往村庄",
      pos = {x = 1799.5592747419328, y = 222.1186660602984},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110203_01d",
        QuestDeatil = "Content_110203_01d",
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
            startQuest = "1781781035455494",
            startPort = "Out",
            endQuest = "1781781035455495",
            endPort = "In"
          },
          {
            startQuest = "1781781035456499",
            startPort = "Out",
            endQuest = "178213378408612830373",
            endPort = "In"
          },
          {
            startQuest = "1781781035454491",
            startPort = "QuestStart",
            endQuest = "178213510012914973449",
            endPort = "In"
          },
          {
            startQuest = "178213510012914973449",
            startPort = "Out",
            endQuest = "1781781035455496",
            endPort = "In"
          },
          {
            startQuest = "178213510012914973449",
            startPort = "Out",
            endQuest = "178316231117115185267",
            endPort = "In"
          },
          {
            startQuest = "178316231117115185267",
            startPort = "Out",
            endQuest = "1781781035455494",
            endPort = "In"
          },
          {
            startQuest = "1781781035455495",
            startPort = "Out",
            endQuest = "178316263478216267259",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "178213401382612832399",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "1781781035456499",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "178316287624217350624",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "17847242044432224942",
            endPort = "In"
          },
          {
            startQuest = "178316292979817351363",
            startPort = "Out",
            endQuest = "17847242645884440495",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "17847770795846655943",
            endPort = "In"
          },
          {
            startQuest = "178316263478216267259",
            startPort = "Out",
            endQuest = "17847770869946656064",
            endPort = "In"
          },
          {
            startQuest = "17847242044432224942",
            startPort = "Out",
            endQuest = "178316296158217352346",
            endPort = "In"
          },
          {
            startQuest = "178316287624217350624",
            startPort = "Out",
            endQuest = "178316292979817351363",
            endPort = "In"
          },
          {
            startQuest = "178316296158217352346",
            startPort = "Out",
            endQuest = "178479687999611087780",
            endPort = "In"
          },
          {
            startQuest = "178479687999611087780",
            startPort = "Out",
            endQuest = "178479688707711088056",
            endPort = "In"
          },
          {
            startQuest = "1781781035454491",
            startPort = "QuestStart",
            endQuest = "17855110566481108803",
            endPort = "Input"
          },
          {
            startQuest = "17855112288633317285",
            startPort = "Out",
            endQuest = "17855112288633317286",
            endPort = "In"
          },
          {
            startQuest = "17855112288633317286",
            startPort = "Out",
            endQuest = "17855112288633317287",
            endPort = "In"
          },
          {
            startQuest = "178213401382612832399",
            startPort = "Out",
            endQuest = "17855112288633317285",
            endPort = "In"
          },
          {
            startQuest = "17855112288633317287",
            startPort = "Out",
            endQuest = "17855112386393317638",
            endPort = "Input"
          },
          {
            startQuest = "17855112386393317638",
            startPort = "Out",
            endQuest = "178213444451912833936",
            endPort = "In"
          },
          {
            startQuest = "17847242044432224942",
            startPort = "Out",
            endQuest = "17866042114031123146",
            endPort = "In"
          },
          {
            startQuest = "17847242044432224942",
            startPort = "Out",
            endQuest = "17866042114031123145",
            endPort = "In"
          },
          {
            startQuest = "1781781035455495",
            startPort = "Out",
            endQuest = "17866353466681927",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781781035454491"] = {
            key = "1781781035454491",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 388.86956521739137, y = 325.9130434782609},
            propsData = {ModeType = 0}
          },
          ["1781781035455492"] = {
            key = "1781781035455492",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4193.928571428572, y = 571.948051948052},
            propsData = {ModeType = 0}
          },
          ["1781781035455493"] = {
            key = "1781781035455493",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3321.5384615384614, y = 780.7692307692307},
            propsData = {}
          },
          ["1781781035455494"] = {
            key = "1781781035455494",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1266.7958074534158, y = 331.95159093385644},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800023,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_chukou_142800023"
            }
          },
          ["1781781035455495"] = {
            key = "1781781035455495",
            type = "TalkNode",
            name = "【Ex02_FixSimple_25】：到回村子的路",
            pos = {x = 1507.1684782608697, y = 347.94565217391306},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020125.11020125'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["1781781035455496"] = {
            key = "1781781035455496",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇&法露茜",
            pos = {x = 1069.5, y = 173.125},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800025, 142800024}
            }
          },
          ["1781781035456499"] = {
            key = "1781781035456499",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2038.4118525153012, y = 233.11796536796535},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142800026,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_kaiche_142800026"
            }
          },
          ["178213378408612830373"] = {
            key = "178213378408612830373",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2317.3197261663286, y = 156.6023265105415},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11105901,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178213401382612832399"] = {
            key = "178213401382612832399",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2476.1673763139706, y = 447.2975334774876},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800036,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_zhongdian_142800036"
            }
          },
          ["178213444451912833936"] = {
            key = "178213444451912833936",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3783.5584505894503, y = 491.36388799052037},
            propsData = {}
          },
          ["178213510012914973449"] = {
            key = "178213510012914973449",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 707.9744046268885, y = 319.966560461631},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx2_rebirth03",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178316231117115185267"] = {
            key = "178316231117115185267",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1014, y = 331.62500000000006},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800046,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_caiji01_142800046"
            }
          },
          ["178316263478216267259"] = {
            key = "178316263478216267259",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1753.375, y = 314.75},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx2_rebirth05",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178316287624217350624"] = {
            key = "178316287624217350624",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1995.064241486068, y = 1141.0096749226007},
            propsData = {Rate = 0.25, Mode = "EWT_Normal"}
          },
          ["178316292979817351363"] = {
            key = "178316292979817351363",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2312.811628496072, y = 1132.0141175946335},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire",
                "Jump"
              }
            }
          },
          ["178316296158217352346"] = {
            key = "178316296158217352346",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 2372.571428571429, y = 671.9821428571429},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["17847242044432224942"] = {
            key = "17847242044432224942",
            type = "TalkNode",
            name = "开车",
            pos = {x = 2055.985219372989, y = 533.6421054435759},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11106001,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17847242645884440495"] = {
            key = "17847242645884440495",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2629.4175686284807, y = 1131.8294534551515},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17847770795846655943"] = {
            key = "17847770795846655943",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2044.0589614204148, y = 43.14138815261149},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "TCST_dongkou",
              UnitId = 111114
            }
          },
          ["17847770869946656064"] = {
            key = "17847770869946656064",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2043.5326456309415, y = -98.96387500528328},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "TCST_dongkou",
              UnitId = 111220
            }
          },
          ["178479687999611087780"] = {
            key = "178479687999611087780",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2712.027898225786, y = 667.4452493522634},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire",
                "Jump"
              }
            }
          },
          ["178479688707711088056"] = {
            key = "178479688707711088056",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2990.6732184228294, y = 670.2504420027414},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17855110566481108803"] = {
            key = "17855110566481108803",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 800.5, y = 83},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17855112288633317285"] = {
            key = "17855112288633317285",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 2739.3886655138604, y = 495.2669493282998},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["17855112288633317286"] = {
            key = "17855112288633317286",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2990.987992311075, y = 477.87291296627757},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire",
                "Jump"
              }
            }
          },
          ["17855112288633317287"] = {
            key = "17855112288633317287",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 3228.9190267938325, y = 469.9638199024697},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17855112386393317638"] = {
            key = "17855112386393317638",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 3503.3846153846152, y = 477.9999999999998},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = true,
              ForceWeatherType = -1
            }
          },
          ["17866042114031123145"] = {
            key = "17866042114031123145",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2339.4220846233225, y = 969.1599587203307},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "TCST_Arriave",
              UnitId = 111114
            }
          },
          ["17866042114031123146"] = {
            key = "17866042114031123146",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2361.836945304437, y = 819.995872033024},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "TCST_Arriave",
              UnitId = 111220
            }
          },
          ["17866353466681927"] = {
            key = "17866353466681927",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1730.1510577915376, y = 55.37358101135192},
            propsData = {
              NewDescription = "Description_110203_01e",
              NewDetail = "Content_110203_01e",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["1781781035420294"] = {
      isStoryNode = true,
      key = "1781781035420294",
      type = "StoryNode",
      name = "到达湖边树林",
      pos = {x = 1367.0887944565693, y = 241.2836989555166},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110203_01a",
        QuestDeatil = "Content_110203_01a",
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
            startQuest = "17821195206621991",
            startPort = "Out",
            endQuest = "1781781035461531",
            endPort = "In"
          },
          {
            startQuest = "17831469504603623",
            startPort = "Out",
            endQuest = "17821208158422142817",
            endPort = "In"
          },
          {
            startQuest = "1781781035461531",
            startPort = "Out",
            endQuest = "17831508814661088503",
            endPort = "In"
          },
          {
            startQuest = "17831508814661088503",
            startPort = "Out",
            endQuest = "17831509096111089007",
            endPort = "In"
          },
          {
            startQuest = "17831509096111089007",
            startPort = "Out",
            endQuest = "1781781035461532",
            endPort = "In"
          },
          {
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "17831510968523252505",
            endPort = "Input"
          },
          {
            startQuest = "17821208158422142817",
            startPort = "true",
            endQuest = "17821195206621991",
            endPort = "In"
          },
          {
            startQuest = "1781781035461531",
            startPort = "Out",
            endQuest = "17821203427201072270",
            endPort = "In"
          },
          {
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "17831469504603623",
            endPort = "In"
          },
          {
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "17866046668344470414",
            endPort = "In"
          },
          {
            startQuest = "17866046668344470414",
            startPort = "Out",
            endQuest = "17866049769904471666",
            endPort = "In"
          },
          {
            startQuest = "17866049769904471666",
            startPort = "Out",
            endQuest = "17866046668344470414",
            endPort = "In"
          },
          {
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "17866077325625589210",
            endPort = "In"
          },
          {
            startQuest = "17866080363436703538",
            startPort = "Out",
            endQuest = "17866081233987818715",
            endPort = "In"
          },
          {
            startQuest = "17866081233987818715",
            startPort = "Out",
            endQuest = "17866080363436703538",
            endPort = "In"
          },
          {
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "17866080363436703538",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936099",
            startPort = "true",
            endQuest = "17866082444118936101",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936101",
            startPort = "Out",
            endQuest = "17866082444118936098",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936101",
            startPort = "Out",
            endQuest = "17866082444118936102",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936102",
            startPort = "Out",
            endQuest = "17866082444118936105",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936105",
            startPort = "Out",
            endQuest = "17866082444118936106",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936106",
            startPort = "Out",
            endQuest = "17866082444118936103",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936108",
            startPort = "Out",
            endQuest = "17866082444128936109",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936107",
            startPort = "Out",
            endQuest = "17866082444128936113",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936113",
            startPort = "Out",
            endQuest = "17866082444118936108",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936099",
            startPort = "false",
            endQuest = "17866082444128936111",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936109",
            startPort = "Out",
            endQuest = "17866082444128936117",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936117",
            startPort = "Out",
            endQuest = "17866082444128936110",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936117",
            startPort = "Out",
            endQuest = "17866082444128936119",
            endPort = "Input"
          },
          {
            startQuest = "17821208158422142817",
            startPort = "false",
            endQuest = "17866082444118936099",
            endPort = "In"
          },
          {
            startQuest = "17821300070634282844",
            startPort = "Out",
            endQuest = "17866082444118936101",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936101",
            startPort = "Out",
            endQuest = "17866082444118936097",
            endPort = "In"
          },
          {
            startQuest = "1781781035461532",
            startPort = "Out",
            endQuest = "17821300070634282844",
            endPort = "In"
          },
          {
            startQuest = "17821300070634282844",
            startPort = "Out",
            endQuest = "17821299596574281630",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936111",
            startPort = "true",
            endQuest = "17866082444128936116",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936116",
            startPort = "Out",
            endQuest = "17866082444128936115",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936103",
            startPort = "Out",
            endQuest = "17866082444118936100",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936100",
            startPort = "Out",
            endQuest = "17866082444118936107",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936112",
            startPort = "Out",
            endQuest = "1781781035460529",
            endPort = "Success"
          },
          {
            startQuest = "17866082444128936111",
            startPort = "false",
            endQuest = "1781781035460529",
            endPort = "Success"
          },
          {
            startQuest = "17866082444128936114",
            startPort = "Out",
            endQuest = "17866087630438951002",
            endPort = "In"
          },
          {
            startQuest = "17866087630438951002",
            startPort = "Out",
            endQuest = "17866082444128936112",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936117",
            startPort = "Out",
            endQuest = "17866046668344470414",
            endPort = "Stop"
          },
          {
            startQuest = "17866082444128936117",
            startPort = "Out",
            endQuest = "17866080363436703538",
            endPort = "Stop"
          },
          {
            startQuest = "17866082444128936110",
            startPort = "Out",
            endQuest = "17866088306248952799",
            endPort = "Input"
          },
          {
            startQuest = "17866088306248952799",
            startPort = "Out",
            endQuest = "17866082444128936114",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936101",
            startPort = "Out",
            endQuest = "178661210977812299815",
            endPort = "In"
          },
          {
            startQuest = "17866082444118936106",
            startPort = "Out",
            endQuest = "17866082444118936104",
            endPort = "In"
          },
          {
            startQuest = "17866082444128936115",
            startPort = "Out",
            endQuest = "178661259838213416335",
            endPort = "In"
          },
          {
            startQuest = "178661259838213416335",
            startPort = "Out",
            endQuest = "17866082444118936100",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781781035460528"] = {
            key = "1781781035460528",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -612.245378151261, y = 243.10924369747897},
            propsData = {ModeType = 0}
          },
          ["1781781035460529"] = {
            key = "1781781035460529",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 7667.835334771865, y = 803.5081777527603},
            propsData = {ModeType = 0}
          },
          ["1781781035460530"] = {
            key = "1781781035460530",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2578.75, y = 1159.375},
            propsData = {}
          },
          ["1781781035461531"] = {
            key = "1781781035461531",
            type = "TalkNode",
            name = "【Ex02_FixSimple_21】：主角醒来",
            pos = {x = 875.6386375062845, y = 228.68690296631468},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020121.11020121'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["1781781035461532"] = {
            key = "1781781035461532",
            type = "TalkNode",
            name = "【Ex02_FixSimple_22】：与法露茜交互",
            pos = {x = 1744.011464842347, y = 269.05736910148676},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020122.11020122'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["17821195206621991"] = {
            key = "17821195206621991",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 537.3222246793451, y = 208.41928350287483},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx2_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17821203427201072270"] = {
            key = "17821203427201072270",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1173.6415881384028, y = 88.67165050534791},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800018, 142800019}
            }
          },
          ["17821208158422142817"] = {
            key = "17821208158422142817",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 240.77706812721487, y = 478.52187208782584},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020301",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17821299596574281630"] = {
            key = "17821299596574281630",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2321.8264763460156, y = 21.43466807311819},
            propsData = {
              VarName = "ex02_11020301",
              VarValue = 1
            }
          },
          ["17821300070634282844"] = {
            key = "17821300070634282844",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2015.9033341255044, y = 280.36498999159795},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800018, 142800019}
            }
          },
          ["17831469504603623"] = {
            key = "17831469504603623",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -158.96557381041578, y = 277.2631578947369},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["17831508814661088503"] = {
            key = "17831508814661088503",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1180.174701459532, y = 248.46063688633313},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800045}
            }
          },
          ["17831509096111089007"] = {
            key = "17831509096111089007",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1461.8889871738177, y = 255.05154597724226},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020108,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_watchfaluxi_142800045",
              IsUseCount = false
            }
          },
          ["17831510968523252505"] = {
            key = "17831510968523252505",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -243.9205366357063, y = 120.17492260061871},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17866046668344470414"] = {
            key = "17866046668344470414",
            type = "GoToNode",
            name = "前往",
            pos = {x = 4656.177359405299, y = -886.7774994613221},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142800336,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_gouhuo01_142800336"
            }
          },
          ["17866049769904471666"] = {
            key = "17866049769904471666",
            type = "TalkNode",
            name = "晚上踏入不熟悉的森林太危险了，等天亮再过去吧。",
            pos = {x = 5099.128038370297, y = -860.8918027277153},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11105701,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17866077325625589210"] = {
            key = "17866077325625589210",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 4641.717111303242, y = -1293.3882691544545},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800335, 142800334}
            }
          },
          ["17866080363436703538"] = {
            key = "17866080363436703538",
            type = "GoToNode",
            name = "前往",
            pos = {x = 4632.448535451849, y = -1076.952826050087},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142800337,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_gouhuo02_142800337"
            }
          },
          ["17866081233987818715"] = {
            key = "17866081233987818715",
            type = "TalkNode",
            name = "晚上踏入不熟悉的森林太危险了，等天亮再过去吧。",
            pos = {x = 5083.05620281029, y = -1082.0548238330064},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11105701,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17866082444118936097"] = {
            key = "17866082444118936097",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3150.68037677828, y = 45.70708248524389},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800020, 142800019}
            }
          },
          ["17866082444118936098"] = {
            key = "17866082444118936098",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3385.913739150284, y = 171.87654531704558},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11105501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17866082444118936099"] = {
            key = "17866082444118936099",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 2190.208069367146, y = 671.2262493768358},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020301",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17866082444118936100"] = {
            key = "17866082444118936100",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 4907.606654257759, y = 258.1331231319588},
            propsData = {
              VarName = "ex02_11020301",
              VarValue = 2
            }
          },
          ["17866082444118936101"] = {
            key = "17866082444118936101",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2683.8835427035256, y = 328.58141668779615},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx2_rebirth04",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17866082444118936102"] = {
            key = "17866082444118936102",
            type = "ChangeStaticCreatorNode",
            name = "生成拾取物",
            pos = {x = 3273.0841463470297, y = 364.69681411629057},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                142800050,
                142800049,
                142800048,
                142800047,
                142800202,
                142800205
              }
            }
          },
          ["17866082444118936103"] = {
            key = "17866082444118936103",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 4466.515852786281, y = 360.2111316872816},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11105601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17866082444118936104"] = {
            key = "17866082444118936104",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 4493.725561951682, y = 161.68124140470388},
            propsData = {
              NewDescription = "Description_110203_01c",
              NewDetail = "Content_110203_01c",
              SubTaskTargetIndex = 0
            }
          },
          ["17866082444118936105"] = {
            key = "17866082444118936105",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 3700.1322720993116, y = 378.4536429193646},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020109,
              UnitCount = 3,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "22_Sphere_pickup",
              IsUseCount = true
            }
          },
          ["17866082444118936106"] = {
            key = "17866082444118936106",
            type = "ChangeStaticCreatorNode",
            name = "生成拾取物",
            pos = {x = 4002.094762196527, y = 383.6382057491339},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                142800051,
                142800050,
                142800049,
                142800048,
                142800047,
                142800202,
                142800204,
                142800205
              }
            }
          },
          ["17866082444118936107"] = {
            key = "17866082444118936107",
            type = "GoToNode",
            name = "前往",
            pos = {x = 5197.9777421236, y = 358.1540003770605},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800022,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_huodui_142800022"
            }
          },
          ["17866082444118936108"] = {
            key = "17866082444118936108",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 5816.6892082890145, y = 266.6380229334515},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020110,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_huodui_sitdown_142800052",
              IsUseCount = false
            }
          },
          ["17866082444128936109"] = {
            key = "17866082444128936109",
            type = "TalkNode",
            name = "Ex02_FixSimple_23】：主角和法露茜交心",
            pos = {x = 6060.553294580011, y = 355.1019515722528},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020123.11020123'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["17866082444128936110"] = {
            key = "17866082444128936110",
            type = "TalkNode",
            name = "【Ex02_FixSimple_24】：第二天醒来",
            pos = {x = 6555.509149945301, y = 347.7667936897955},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020124.11020124'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
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
          ["17866082444128936111"] = {
            key = "17866082444128936111",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 3837.463147168521, y = 824.8574147392264},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020301",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17866082444128936112"] = {
            key = "17866082444128936112",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 7675.178645277746, y = 397.0872844562425},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800020, 142800019}
            }
          },
          ["17866082444128936113"] = {
            key = "17866082444128936113",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 5516.474922574728, y = 299.1380229334515},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800052}
            }
          },
          ["17866082444128936114"] = {
            key = "17866082444128936114",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 7081.460312185119, y = 361.3003605957892},
            propsData = {
              VarName = "ex02_11020301",
              VarValue = 3
            }
          },
          ["17866082444128936115"] = {
            key = "17866082444128936115",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 4306.972824672632, y = 599.6770132909203},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800020, 142800019}
            }
          },
          ["17866082444128936116"] = {
            key = "17866082444128936116",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 4026.6341662864033, y = 628.6248228662544},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "tp_lxzx2_rebirth02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17866082444128936117"] = {
            key = "17866082444128936117",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 6317.037205800199, y = 342.9822284999347},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11125201,
              FlowAssetPath = "",
              TalkType = "Black",
              BlendInTime = 0,
              BlendOutTime = 0,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = true,
              ShowSkipButton = false,
              ShowReviewButton = false,
              ShowWikiButton = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17866082444128936119"] = {
            key = "17866082444128936119",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 6557.156730238608, y = 203.5982369754638},
            propsData = {
              TargetTime = 15,
              NeedLerp = true,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17866082444128936120"] = {
            key = "17866082444128936120",
            type = "ChangeStaticCreatorNode",
            name = "生成拾取物",
            pos = {x = 4198.861464358978, y = -221.50618994436576},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                142800051,
                142800050,
                142800049,
                142800048,
                142800047,
                142800202,
                142800204,
                142800205
              }
            }
          },
          ["17866087630438951002"] = {
            key = "17866087630438951002",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 7364.28956323212, y = 382.56107276086664},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142800335, 142800334}
            }
          },
          ["17866088306248952799"] = {
            key = "17866088306248952799",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 6819.421015113573, y = 347.4372752701611},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["178661210977812299815"] = {
            key = "178661210977812299815",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 3164.7141835931416, y = -120.2827561155724},
            propsData = {
              NewDescription = "Description_110203_01b",
              NewDetail = "Content_110203_01b",
              SubTaskTargetIndex = 0
            }
          },
          ["178661259838213416335"] = {
            key = "178661259838213416335",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 4676.312655683487, y = 524.2922757926628},
            propsData = {
              NewDescription = "Description_110203_01c",
              NewDetail = "Content_110203_01c",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {
          ["17866081529417819746"] = {
            key = "17866081529417819746",
            name = "空气墙",
            position = {x = 4584.12763138172, y = -1401.6083952615777},
            size = {width = 872.1428571428571, height = 732.8571428571429}
          }
        }
      }
    }
  },
  commentData = {}
}
