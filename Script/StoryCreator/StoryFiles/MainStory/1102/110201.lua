return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17684466360201",
      startPort = "StoryStart",
      endStory = "176844664094567",
      endPort = "In"
    },
    {
      startStory = "176844664094567",
      startPort = "Success",
      endStory = "178065039055313690835",
      endPort = "In"
    },
    {
      startStory = "178065039055313690835",
      startPort = "Success",
      endStory = "178090983396012518",
      endPort = "In"
    },
    {
      startStory = "178090983396012518",
      startPort = "Success",
      endStory = "17815071548503110614",
      endPort = "In"
    },
    {
      startStory = "17815071548503110614",
      startPort = "Success",
      endStory = "17684466360215",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17684466360201"] = {
      isStoryNode = true,
      key = "17684466360201",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 650, y = 168.00000000000006},
      propsData = {QuestChainId = 110201},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17684466360215"] = {
      isStoryNode = true,
      key = "17684466360215",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 3246.0490868757415, y = 111.18993259157511},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["176844664094567"] = {
      isStoryNode = true,
      key = "176844664094567",
      type = "StoryNode",
      name = "主线开启",
      pos = {x = 1092.8992481203009, y = 152.027067669173},
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
        bIsPlayBlackScreenOnComplete = true,
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
            startQuest = "1768446775846469",
            startPort = "Out",
            endQuest = "1768446775846472",
            endPort = "In"
          },
          {
            startQuest = "1768446775846471",
            startPort = "True",
            endQuest = "1768446775846470",
            endPort = "In"
          },
          {
            startQuest = "1768446775846473",
            startPort = "Out",
            endQuest = "1768446775846469",
            endPort = "In"
          },
          {
            startQuest = "1768446775846473",
            startPort = "Out",
            endQuest = "1768446775846475",
            endPort = "In"
          },
          {
            startQuest = "1768446775846475",
            startPort = "Out",
            endQuest = "1768446775846476",
            endPort = "In"
          },
          {
            startQuest = "1768446775846477",
            startPort = "false",
            endQuest = "1768446775846473",
            endPort = "In"
          },
          {
            startQuest = "1768446775846471",
            startPort = "False",
            endQuest = "176844664094684",
            endPort = "Fail"
          },
          {
            startQuest = "1768446775846475",
            startPort = "Out",
            endQuest = "17697623421339911518",
            endPort = "In"
          },
          {
            startQuest = "17697623421339911518",
            startPort = "Out",
            endQuest = "1768446775846474",
            endPort = "In"
          },
          {
            startQuest = "1768446775846470",
            startPort = "Out",
            endQuest = "176844664094676",
            endPort = "Success"
          },
          {
            startQuest = "1768446775846472",
            startPort = "Out",
            endQuest = "1768446775846471",
            endPort = "Input"
          },
          {
            startQuest = "1768446775846477",
            startPort = "true",
            endQuest = "1768446775846469",
            endPort = "In"
          },
          {
            startQuest = "1768446775846474",
            startPort = "Out",
            endQuest = "1768446775846478",
            endPort = "In"
          },
          {
            startQuest = "176844664094568",
            startPort = "QuestStart",
            endQuest = "1768446775846477",
            endPort = "In"
          }
        },
        nodeData = {
          ["176844664094568"] = {
            key = "176844664094568",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -446.9230769230769, y = -328.3186813186813},
            propsData = {ModeType = 0}
          },
          ["176844664094676"] = {
            key = "176844664094676",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3591.0872167048637, y = -440.84867415865875},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["176844664094684"] = {
            key = "176844664094684",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3668.3374378459516, y = 140.9306220095694},
            propsData = {}
          },
          ["1768446775846469"] = {
            key = "1768446775846469",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 752.8621800431962, y = -328.91726057758655},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {141210132}
            }
          },
          ["1768446775846470"] = {
            key = "1768446775846470",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3028.890812932347, y = -460.8018481012332},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {141210132}
            }
          },
          ["1768446775846471"] = {
            key = "1768446775846471",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 2605.2414361037168, y = -294.5022931614143},
            propsData = {PopupId = 100110}
          },
          ["1768446775846472"] = {
            key = "1768446775846472",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1702.2117140948594, y = -318.6197854802973},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestPoint_EX01",
              IsUseCount = false
            }
          },
          ["1768446775846473"] = {
            key = "1768446775846473",
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
          ["1768446775846474"] = {
            key = "1768446775846474",
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
          ["1768446775846475"] = {
            key = "1768446775846475",
            type = "GoToNode",
            name = "前往",
            pos = {x = 823.7715398294757, y = 86.60013978987749},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 141210133,
              GuideType = "M",
              GuidePointName = "Mechanism_Change2_141210133"
            }
          },
          ["1768446775846476"] = {
            key = "1768446775846476",
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
          ["1768446775846477"] = {
            key = "1768446775846477",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 226.37551899405344, y = -322.07721583628614},
            propsData = {
              FunctionName = "Equal",
              VarName = "Entrance110201",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1768446775846478"] = {
            key = "1768446775846478",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2294.0463508920516, y = 107.59233217091523},
            propsData = {
              VarName = "Entrance110201",
              VarValue = 1
            }
          },
          ["17697623421339911518"] = {
            key = "17697623421339911518",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1260.2399670734087, y = 190.6320709048122},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    },
    ["178065039055313690835"] = {
      isStoryNode = true,
      key = "178065039055313690835",
      type = "StoryNode",
      name = "阿尔卡诺山外围特殊任务",
      pos = {x = 1566.8043936065326, y = 143.08884805135537},
      propsData = {
        QuestId = 11020102,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02",
        QuestDeatil = "Content_110201_02",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Drop_ex02_start_142780646",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178065041563213691422",
            startPort = "Out",
            endQuest = "178065039055413690842",
            endPort = "Fail"
          },
          {
            startQuest = "178238700508431391423",
            startPort = "Out",
            endQuest = "178238710845931392500",
            endPort = "In"
          },
          {
            startQuest = "178065041563213691421",
            startPort = "Fail",
            endQuest = "17827143554062291",
            endPort = "Input"
          },
          {
            startQuest = "178238710845931392500",
            startPort = "Out",
            endQuest = "17827389005698090499",
            endPort = "In"
          },
          {
            startQuest = "17829147541251549",
            startPort = "Out",
            endQuest = "17829147541251550",
            endPort = "In"
          },
          {
            startQuest = "17827143554062291",
            startPort = "Out",
            endQuest = "17829147541251549",
            endPort = "In"
          },
          {
            startQuest = "17829147541251550",
            startPort = "Out",
            endQuest = "178065041563213691422",
            endPort = "In"
          },
          {
            startQuest = "178065041563213691421",
            startPort = "Success",
            endQuest = "178065039055313690839",
            endPort = "Success"
          },
          {
            startQuest = "178065039055313690836",
            startPort = "QuestStart",
            endQuest = "17855057130279753",
            endPort = "In"
          },
          {
            startQuest = "17855057130279753",
            startPort = "Out",
            endQuest = "178065041563213691421",
            endPort = "In"
          },
          {
            startQuest = "178065041563213691421",
            startPort = "PassiveFail",
            endQuest = "17827143554062291",
            endPort = "Input"
          }
        },
        nodeData = {
          ["178065039055313690836"] = {
            key = "178065039055313690836",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -36.42133867276891, y = 142.4125667429443},
            propsData = {ModeType = 0}
          },
          ["178065039055313690839"] = {
            key = "178065039055313690839",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2037.7142857142858, y = 147.2683982683983},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["178065039055413690842"] = {
            key = "178065039055413690842",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3088.0384615384614, y = 444.4230769230769},
            propsData = {}
          },
          ["178065041563213691421"] = {
            key = "178065041563213691421",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1305.857142857143, y = 172.7036220358587},
            propsData = {SpecialConfigId = 11020101, BlackScreenImmediately = true}
          },
          ["178065041563213691422"] = {
            key = "178065041563213691422",
            type = "SkipRegionNode",
            name = "送回据点",
            pos = {x = 2657.9615384615386, y = 424.0271471949106},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178238700508431391423"] = {
            key = "178238700508431391423",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 430.4064236678653, y = 446.77694506262907},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780646}
            }
          },
          ["178238710845931392500"] = {
            key = "178238710845931392500",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 700.0631742399476, y = 447.89427865380964},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_ex02_start_142780646",
              IsUseCount = false
            }
          },
          ["178238727306931395404"] = {
            key = "178238727306931395404",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1787.453199815395, y = 789.1317928773344},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17827143554062291"] = {
            key = "17827143554062291",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1574, y = 282},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = 0
            }
          },
          ["17827389005698090499"] = {
            key = "17827389005698090499",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 965.6239495798318, y = 466.295518207283},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780646}
            }
          },
          ["17829147541251549"] = {
            key = "17829147541251549",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1921.6458131024258, y = 348.57642038656525},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["17829147541251550"] = {
            key = "17829147541251550",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2166.9329414763283, y = 329.4446418844969},
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
                "Fire"
              }
            }
          },
          ["17855049826845301"] = {
            key = "17855049826845301",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "检测是否第一次进入任务",
            pos = {x = -210.8188656029215, y = -186.53850406559394},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110201_1",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17855056638508501"] = {
            key = "17855056638508501",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 345.13946773041187, y = -293.49683739892725},
            propsData = {
              VarName = "ex02_110201_1",
              VarValue = 1
            }
          },
          ["17855057130279753"] = {
            key = "17855057130279753",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 582.4614374273821, y = 136.47664744955767},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    },
    ["178090983396012518"] = {
      isStoryNode = true,
      key = "178090983396012518",
      type = "StoryNode",
      name = "废弃游乐园特殊任务",
      pos = {x = 2028.1199654210525, y = 121.81079789775437},
      propsData = {
        QuestId = 11020103,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03",
        QuestDeatil = "Content_110201_03",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Drop_ex02_start_142790446",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178090983396012527",
            startPort = "Out",
            endQuest = "178090983396012525",
            endPort = "Fail"
          },
          {
            startQuest = "17827165753294847132",
            startPort = "Out",
            endQuest = "17827165753294847133",
            endPort = "In"
          },
          {
            startQuest = "17827165753294847133",
            startPort = "Out",
            endQuest = "17827389269149705539",
            endPort = "In"
          },
          {
            startQuest = "178090983396012526",
            startPort = "Fail",
            endQuest = "17829148504512640",
            endPort = "Input"
          },
          {
            startQuest = "17829148504512640",
            startPort = "Out",
            endQuest = "178090983396012527",
            endPort = "In"
          },
          {
            startQuest = "178090983396012526",
            startPort = "Success",
            endQuest = "178090983396012524",
            endPort = "Success"
          },
          {
            startQuest = "17855066211523323310",
            startPort = "true",
            endQuest = "17855067360346635180",
            endPort = "In"
          },
          {
            startQuest = "178090983396012523",
            startPort = "QuestStart",
            endQuest = "17827164193493233009",
            endPort = "In"
          },
          {
            startQuest = "17827164193493233009",
            startPort = "Out",
            endQuest = "178090983396012526",
            endPort = "In"
          },
          {
            startQuest = "178090983396012526",
            startPort = "PassiveFail",
            endQuest = "17829148504512640",
            endPort = "Input"
          }
        },
        nodeData = {
          ["178090983396012523"] = {
            key = "178090983396012523",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -184.19852941176475, y = 212.6446078431373},
            propsData = {ModeType = 0}
          },
          ["178090983396012524"] = {
            key = "178090983396012524",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2118, y = 154},
            propsData = {ModeType = 0}
          },
          ["178090983396012525"] = {
            key = "178090983396012525",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2434, y = 410},
            propsData = {}
          },
          ["178090983396012526"] = {
            key = "178090983396012526",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 909.467245989305, y = 191.97568085938812},
            propsData = {SpecialConfigId = 11020103, BlackScreenImmediately = false}
          },
          ["178090983396012527"] = {
            key = "178090983396012527",
            type = "SkipRegionNode",
            name = "送回据点",
            pos = {x = 2106, y = 387.29637796414136},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17827164193493233009"] = {
            key = "17827164193493233009",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 268.5660457310047, y = 195.22160631718242},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17827165753294847132"] = {
            key = "17827165753294847132",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 88.520389139327, y = 461.0797754585761},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790446}
            }
          },
          ["17827165753294847133"] = {
            key = "17827165753294847133",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 370.60438429345254, y = 465.1810210356037},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11020101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_ex02_start_142790446",
              IsUseCount = false
            }
          },
          ["17827165753294847134"] = {
            key = "17827165753294847134",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 602.7044939025138, y = 746.0610422619294},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17827389269149705539"] = {
            key = "17827389269149705539",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 668.1552855095729, y = 477.3034274302451},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790446}
            }
          },
          ["17829148504512640"] = {
            key = "17829148504512640",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1656, y = 318},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17855066211523323310"] = {
            key = "17855066211523323310",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "检测是否第一次进入任务",
            pos = {x = -525.9632352941176, y = -20.433823529411825},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110201_2",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17855067360346635180"] = {
            key = "17855067360346635180",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 153.55882352941126, y = -95.24264705882354},
            propsData = {
              VarName = "ex02_110201_2",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17815071548503110614"] = {
      isStoryNode = true,
      key = "17815071548503110614",
      type = "StoryNode",
      name = "追逐法露茜特殊任务",
      pos = {x = 2591.33550327015, y = 117.46429191412183},
      propsData = {
        QuestId = 11020104,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_04",
        QuestDeatil = "Content_110201_04",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "04_tp_rebirth01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17815071548503110623",
            startPort = "Out",
            endQuest = "17815071548503110621",
            endPort = "Fail"
          },
          {
            startQuest = "17827387389354859403",
            startPort = "Out",
            endQuest = "17815071548503110622",
            endPort = "In"
          },
          {
            startQuest = "17815071548503110622",
            startPort = "Fail",
            endQuest = "17829041530483231785",
            endPort = "In"
          },
          {
            startQuest = "17829041530483231785",
            startPort = "Out",
            endQuest = "17829041878473232256",
            endPort = "In"
          },
          {
            startQuest = "17829041878473232256",
            startPort = "Out",
            endQuest = "17829041951483232370",
            endPort = "In"
          },
          {
            startQuest = "17829041951483232370",
            startPort = "Out",
            endQuest = "17829084842324848111",
            endPort = "Input"
          },
          {
            startQuest = "17829148870293693",
            startPort = "Out",
            endQuest = "17829148870293694",
            endPort = "In"
          },
          {
            startQuest = "17829084842324848111",
            startPort = "Out",
            endQuest = "17829148870293693",
            endPort = "In"
          },
          {
            startQuest = "17829148870293694",
            startPort = "Out",
            endQuest = "17815071548503110623",
            endPort = "In"
          },
          {
            startQuest = "17815071548503110622",
            startPort = "Success",
            endQuest = "17815071548503110620",
            endPort = "Success"
          },
          {
            startQuest = "17815071548503110619",
            startPort = "QuestStart",
            endQuest = "178550752301811609810",
            endPort = "In"
          },
          {
            startQuest = "178550752301811609810",
            startPort = "false",
            endQuest = "17827387389354859403",
            endPort = "In"
          },
          {
            startQuest = "178550752301811609810",
            startPort = "true",
            endQuest = "17815071548503110622",
            endPort = "In"
          },
          {
            startQuest = "178550752301811609810",
            startPort = "true",
            endQuest = "178550753487411610271",
            endPort = "In"
          },
          {
            startQuest = "17815071548503110622",
            startPort = "PassiveFail",
            endQuest = "17829041530483231785",
            endPort = "In"
          }
        },
        nodeData = {
          ["17815071548503110619"] = {
            key = "17815071548503110619",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 156.88235294117646, y = 82.82352941176468},
            propsData = {ModeType = 0}
          },
          ["17815071548503110620"] = {
            key = "17815071548503110620",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2118, y = 156},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17815071548503110621"] = {
            key = "17815071548503110621",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2428, y = 446},
            propsData = {}
          },
          ["17815071548503110622"] = {
            key = "17815071548503110622",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1224, y = 202.7036220358587},
            propsData = {SpecialConfigId = 11020104, BlackScreenImmediately = true}
          },
          ["17815071548503110623"] = {
            key = "17815071548503110623",
            type = "SkipRegionNode",
            name = "送回场景",
            pos = {x = 2004, y = 449.29637796414136},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17827387389354859403"] = {
            key = "17827387389354859403",
            type = "GoToNode",
            name = "前往",
            pos = {x = 863.1960672178064, y = 392.7792522197896},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790015,
              GuideType = "M",
              GuidePointName = "04_tp_rebirth01"
            }
          },
          ["17829041530483231785"] = {
            key = "17829041530483231785",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1522, y = 320},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Survey01 destory",
              UnitId = -1
            }
          },
          ["17829041878473232256"] = {
            key = "17829041878473232256",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1526, y = 458.3333333333333},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Survey02 destory",
              UnitId = -1
            }
          },
          ["17829041951483232370"] = {
            key = "17829041951483232370",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1508, y = 586},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Survey03 destory",
              UnitId = -1
            }
          },
          ["17829084842324848111"] = {
            key = "17829084842324848111",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1505.2083333333335, y = 696.2083333333334},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17829148870293693"] = {
            key = "17829148870293693",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1497.3564358130486, y = 832.3992225843676},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["17829148870293694"] = {
            key = "17829148870293694",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1478.6435641869512, y = 1005.6007774156326},
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
                "Fire"
              }
            }
          },
          ["178550752301811609810"] = {
            key = "178550752301811609810",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "检测是否第一次进入任务",
            pos = {x = 501.7062140645734, y = 64.79105994624602},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_110201_3",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178550753487411610271"] = {
            key = "178550753487411610271",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 883.7062140645735, y = -105.32658711257749},
            propsData = {
              VarName = "ex02_110201_3",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {
    ["1768466964570768982"] = {
      key = "1768466964570768982",
      name = "开启阿尔卡诺山外围任务",
      position = {x = 1511.3702067041706, y = 9.065857257530098},
      size = {width = 361.86951834322167, height = 359.4142774179974}
    },
    ["1768466970154769235"] = {
      key = "1768466970154769235",
      name = "主线开启",
      position = {x = 975.8702067041711, y = 24.065857257530077},
      size = {width = 452.7008535690279, height = 345.4036273985999}
    },
    ["178114365360312224276"] = {
      key = "178114365360312224276",
      name = "进入废弃游乐园",
      position = {x = 1904.2113849944355, y = 16.5333197239169},
      size = {width = 529.9999999999999, height = 314.2857142857143}
    },
    ["17815075011923112227"] = {
      key = "17815075011923112227",
      name = "废弃游乐园追逐法露茜",
      position = {x = 2448.8412877649525, y = 18.5177727349199},
      size = {width = 571.1111111111113, height = 310.0000000000001}
    }
  }
}
