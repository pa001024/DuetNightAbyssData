return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870208994278393554",
      startPort = "StoryStart",
      endStory = "17870209033868393699",
      endPort = "In"
    },
    {
      startStory = "17870209368668394288",
      startPort = "Success",
      endStory = "17870208994288393557",
      endPort = "StoryEnd"
    },
    {
      startStory = "17870209033868393699",
      startPort = "Success",
      endStory = "1790175603295416",
      endPort = "In"
    },
    {
      startStory = "1790175603295416",
      startPort = "Success",
      endStory = "17870209368668394288",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17870208994278393554"] = {
      isStoryNode = true,
      key = "17870208994278393554",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 120704},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870208994288393557"] = {
      isStoryNode = true,
      key = "17870208994288393557",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1876, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870209033868393699"] = {
      isStoryNode = true,
      key = "17870209033868393699",
      type = "StoryNode",
      name = "酒馆",
      pos = {x = 1077.6888888888886, y = 288},
      propsData = {
        QuestId = 12070401,
        QuestDescriptionComment = "回酒馆打听蕾伊情况",
        QuestDescription = "Description_120704_1",
        QuestDeatil = "Content_120704_1",
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
        SubRegionId = 101107,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kamila120704_351220221",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870209033868393700",
            startPort = "QuestStart",
            endQuest = "17885116862605132564",
            endPort = "In"
          },
          {
            startQuest = "17885116862605132564",
            startPort = "Out",
            endQuest = "17870209699208394817",
            endPort = "In"
          },
          {
            startQuest = "17870209699208394817",
            startPort = "Success",
            endQuest = "17870209033868393703",
            endPort = "Success"
          },
          {
            startQuest = "179023886052727502470",
            startPort = "Out",
            endQuest = "179023886052727502469",
            endPort = "In"
          },
          {
            startQuest = "179023886052727502469",
            startPort = "Out",
            endQuest = "17870209033878393706",
            endPort = "Fail"
          },
          {
            startQuest = "17870209699208394817",
            startPort = "Fail",
            endQuest = "179023886052727502470",
            endPort = "In"
          },
          {
            startQuest = "17870209699208394817",
            startPort = "PassiveFail",
            endQuest = "179023886052727502470",
            endPort = "In"
          }
        },
        nodeData = {
          ["17870209033868393700"] = {
            key = "17870209033868393700",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1036.2121212121212, y = 298.4848484848485},
            propsData = {ModeType = 0}
          },
          ["17870209033868393703"] = {
            key = "17870209033868393703",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1983.287878787879, y = 275.03282828282823},
            propsData = {ModeType = 0}
          },
          ["17870209033878393706"] = {
            key = "17870209033878393706",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1984.6666666666667, y = 734.6818181818182},
            propsData = {}
          },
          ["17870209699208394817"] = {
            key = "17870209699208394817",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务401",
            pos = {x = 1660.9626074408684, y = 285.31675450153705},
            propsData = {SpecialConfigId = 12070401, BlackScreenImmediately = true}
          },
          ["17885116862605132564"] = {
            key = "17885116862605132564",
            type = "GoToNode",
            name = "前往酒馆吧台",
            pos = {x = 1371.4466403162055, y = 291.08300395256924},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351220215,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351220215"
            }
          },
          ["179023886052727502469"] = {
            key = "179023886052727502469",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1982.9925891739301, y = 592.974774192333},
            propsData = {}
          },
          ["179023886052727502470"] = {
            key = "179023886052727502470",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1984.1982902081259, y = 427.95169639590193},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_BarRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17870209368668394288"] = {
      isStoryNode = true,
      key = "17870209368668394288",
      type = "StoryNode",
      name = "下水道",
      pos = {x = 1594.8, y = 284},
      propsData = {
        QuestId = 12070402,
        QuestDescriptionComment = "下水道调查",
        QuestDescription = "Description_120704_3",
        QuestDeatil = "Content_120704_3",
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
        SubRegionId = 101701,
        SubRegionIdList = {101702, 101703},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351720775",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178710878773810124707",
            startPort = "Out",
            endQuest = "17870210009498395329",
            endPort = "In"
          },
          {
            startQuest = "17870210009498395329",
            startPort = "Success",
            endQuest = "17870209368678394292",
            endPort = "Success"
          },
          {
            startQuest = "179023924973027508405",
            startPort = "Out",
            endQuest = "17870209368678394295",
            endPort = "Fail"
          },
          {
            startQuest = "17870210009498395329",
            startPort = "Fail",
            endQuest = "179023927939627508778",
            endPort = "In"
          },
          {
            startQuest = "17870210009498395329",
            startPort = "PassiveFail",
            endQuest = "179023927939627508778",
            endPort = "In"
          },
          {
            startQuest = "179023927939627508778",
            startPort = "Out",
            endQuest = "179023924973027508405",
            endPort = "In"
          },
          {
            startQuest = "1790566316316952",
            startPort = "false",
            endQuest = "1790566316316953",
            endPort = "In"
          },
          {
            startQuest = "17870209368668394289",
            startPort = "QuestStart",
            endQuest = "1790566316316952",
            endPort = "In"
          },
          {
            startQuest = "1790566316316952",
            startPort = "false",
            endQuest = "17905663776722303",
            endPort = "In"
          },
          {
            startQuest = "1790566316316952",
            startPort = "true",
            endQuest = "178710878773810124707",
            endPort = "In"
          },
          {
            startQuest = "17905663776722303",
            startPort = "Out",
            endQuest = "1790566316316954",
            endPort = "In"
          },
          {
            startQuest = "1790566316316954",
            startPort = "Out",
            endQuest = "17870210009498395329",
            endPort = "In"
          },
          {
            startQuest = "1790566316316952",
            startPort = "false",
            endQuest = "179024091193736094631",
            endPort = "In"
          }
        },
        nodeData = {
          ["17870209368668394289"] = {
            key = "17870209368668394289",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 486.9451603868395, y = 311.81958581148996},
            propsData = {ModeType = 0}
          },
          ["17870209368678394292"] = {
            key = "17870209368678394292",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1938.1541529408805, y = 268.5378001860839},
            propsData = {ModeType = 0}
          },
          ["17870209368678394295"] = {
            key = "17870209368678394295",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1936.2604593307735, y = 719.6092574591825},
            propsData = {}
          },
          ["17870210009498395329"] = {
            key = "17870210009498395329",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务402",
            pos = {x = 1617.8561872909697, y = 279.51505016722405},
            propsData = {SpecialConfigId = 12070402, BlackScreenImmediately = true}
          },
          ["178710878773810124707"] = {
            key = "178710878773810124707",
            type = "GoToNode",
            name = "前往藏身处起点",
            pos = {x = 1203.9302403743184, y = 124.5609371138605},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351720775,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351720775"
            }
          },
          ["179023924973027508405"] = {
            key = "179023924973027508405",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1935.9854111405834, y = 568.4214559386974},
            propsData = {}
          },
          ["179023927939627508778"] = {
            key = "179023927939627508778",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1935.6007957559684, y = 403.4214559386975},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SewThief0",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["179024091193736094631"] = {
            key = "179024091193736094631",
            type = "CommonBlackFadeInOutNode",
            name = "通用黑屏淡入淡出节点",
            pos = {x = 1216.102467996771, y = 640.2107535975604},
            propsData = {FadeTime = 0.5, FadeType = "FadeOut"}
          },
          ["1790566316316952"] = {
            key = "1790566316316952",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 795.6675547395564, y = 303.3718815079265},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "79"}
              }
            }
          },
          ["1790566316316953"] = {
            key = "1790566316316953",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1217.082908903859, y = 475.2368141442474},
            propsData = {VarName = "1.7_Lise01", VarValue = 79}
          },
          ["1790566316316954"] = {
            key = "1790566316316954",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1341.8976626517479, y = 301.4474308300393},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SewThief0",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17905663776722303"] = {
            key = "17905663776722303",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1092.260869565217, y = 300.6086956521738},
            propsData = {
              RegionType = 2,
              IsEnter = "Enter",
              RegionId = 1017,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    },
    ["1790175603295416"] = {
      isStoryNode = true,
      key = "1790175603295416",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1334.2153846153844, y = 281.0769230769231},
      propsData = {
        QuestId = 12070411,
        QuestDescriptionComment = "去蕾伊家",
        QuestDescription = "Description_120704_2",
        QuestDeatil = "Content_120704_2",
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
        SubRegionId = 101101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351192127",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17901758381582386",
            startPort = "Out",
            endQuest = "17901758381582387",
            endPort = "In"
          },
          {
            startQuest = "17901758381582388",
            startPort = "false",
            endQuest = "17901758381592389",
            endPort = "In"
          },
          {
            startQuest = "17901758381582388",
            startPort = "true",
            endQuest = "17901758381582386",
            endPort = "In"
          },
          {
            startQuest = "1790175603295417",
            startPort = "QuestStart",
            endQuest = "17901758381582388",
            endPort = "In"
          },
          {
            startQuest = "17901758381582387",
            startPort = "Success",
            endQuest = "1790175603295420",
            endPort = "Success"
          },
          {
            startQuest = "179023893286227503323",
            startPort = "Out",
            endQuest = "179023893286227503322",
            endPort = "In"
          },
          {
            startQuest = "179023893286227503322",
            startPort = "Out",
            endQuest = "1790175603295423",
            endPort = "Fail"
          },
          {
            startQuest = "17901758381582387",
            startPort = "Fail",
            endQuest = "179023893286227503323",
            endPort = "In"
          },
          {
            startQuest = "17901758381582387",
            startPort = "PassiveFail",
            endQuest = "179023893286227503323",
            endPort = "In"
          },
          {
            startQuest = "17901758381582388",
            startPort = "false",
            endQuest = "17901758381582387",
            endPort = "In"
          }
        },
        nodeData = {
          ["1790175603295417"] = {
            key = "1790175603295417",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1790175603295420"] = {
            key = "1790175603295420",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2104.5454545454545, y = 280.1818181818182},
            propsData = {ModeType = 0}
          },
          ["1790175603295423"] = {
            key = "1790175603295423",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2092.5454545454545, y = 768.4545454545455},
            propsData = {}
          },
          ["17901758381582386"] = {
            key = "17901758381582386",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1450.0421175580161, y = 179.18181482649635},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192127,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192127"
            }
          },
          ["17901758381582387"] = {
            key = "17901758381582387",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务411",
            pos = {x = 1766.170250390096, y = 291.6502586633612},
            propsData = {SpecialConfigId = 12070411, BlackScreenImmediately = true}
          },
          ["17901758381582388"] = {
            key = "17901758381582388",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1113.829749609904, y = 297.3524620233487},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "90"}
              }
            }
          },
          ["17901758381592389"] = {
            key = "17901758381592389",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1446.739195140112, y = 426.5779426573991},
            propsData = {VarName = "1.7_Lise01", VarValue = 90}
          },
          ["179023893286227503322"] = {
            key = "179023893286227503322",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 2095.121484022261, y = 608.3646165089693},
            propsData = {}
          },
          ["179023893286227503323"] = {
            key = "179023893286227503323",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2096.969425068648, y = 428.8172016728488},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_CityRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
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
