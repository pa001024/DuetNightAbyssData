return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17869682909525035231",
      startPort = "StoryStart",
      endStory = "17869683051825035538",
      endPort = "In"
    },
    {
      startStory = "17869683075035035676",
      startPort = "Success",
      endStory = "17869683096705035793",
      endPort = "In"
    },
    {
      startStory = "17869683096705035793",
      startPort = "Success",
      endStory = "17869682909525035234",
      endPort = "StoryEnd"
    },
    {
      startStory = "17901726531172141",
      startPort = "Success",
      endStory = "17901726832292667",
      endPort = "In"
    },
    {
      startStory = "17901726832292667",
      startPort = "Success",
      endStory = "17901726907732917",
      endPort = "In"
    },
    {
      startStory = "17869683051825035538",
      startPort = "Success",
      endStory = "17901726531172141",
      endPort = "In"
    },
    {
      startStory = "17901726907732917",
      startPort = "Success",
      endStory = "17869683075035035676",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17869682909525035231"] = {
      isStoryNode = true,
      key = "17869682909525035231",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 798, y = 300},
      propsData = {QuestChainId = 120703},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17869682909525035234"] = {
      isStoryNode = true,
      key = "17869682909525035234",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1966.2222222222222, y = 316.44444444444446},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17869683051825035538"] = {
      isStoryNode = true,
      key = "17869683051825035538",
      type = "StoryNode",
      name = "酒馆",
      pos = {x = 1076.984126984127, y = 286.57142857142856},
      propsData = {
        QuestId = 12070301,
        QuestDescriptionComment = "遇到蕾伊&寻找约翰森",
        QuestDescription = "Description_120703_1",
        QuestDeatil = "Content_120703_1",
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_12000101_1220106",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17869684167105037261",
            startPort = "Success",
            endQuest = "17869683051825035542",
            endPort = "Success"
          },
          {
            startQuest = "17884916086346805188",
            startPort = "Out",
            endQuest = "17869684167105037261",
            endPort = "In"
          },
          {
            startQuest = "179017539883414963",
            startPort = "false",
            endQuest = "179017539883414964",
            endPort = "In"
          },
          {
            startQuest = "17869683051825035539",
            startPort = "QuestStart",
            endQuest = "179017539883414963",
            endPort = "In"
          },
          {
            startQuest = "179017539883414963",
            startPort = "true",
            endQuest = "17884916086346805188",
            endPort = "In"
          },
          {
            startQuest = "179017539883414963",
            startPort = "false",
            endQuest = "17869684167105037261",
            endPort = "In"
          },
          {
            startQuest = "179023645314512038772",
            startPort = "Out",
            endQuest = "179023645314512038771",
            endPort = "In"
          },
          {
            startQuest = "17869684167105037261",
            startPort = "Fail",
            endQuest = "179023645314512038772",
            endPort = "In"
          },
          {
            startQuest = "17869684167105037261",
            startPort = "PassiveFail",
            endQuest = "179023645314512038772",
            endPort = "In"
          },
          {
            startQuest = "179023645314512038771",
            startPort = "Out",
            endQuest = "17869683051825035545",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17869683051825035539"] = {
            key = "17869683051825035539",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 612.0478468899522, y = 257.7757177033493},
            propsData = {ModeType = 0}
          },
          ["17869683051825035542"] = {
            key = "17869683051825035542",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1813.6155226352594, y = 172.27401545822596},
            propsData = {ModeType = 0}
          },
          ["17869683051825035545"] = {
            key = "17869683051825035545",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1819.26467611336, y = 634.5002300331248},
            propsData = {}
          },
          ["17869684167105037261"] = {
            key = "17869684167105037261",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务301",
            pos = {x = 1492.0120888519054, y = 216.29959780875106},
            propsData = {SpecialConfigId = 12070301, BlackScreenImmediately = true}
          },
          ["17884916086346805188"] = {
            key = "17884916086346805188",
            type = "GoToNode",
            name = "前往酒馆吧台",
            pos = {x = 1180.1883116883116, y = 89.42857142857133},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 1220106,
              GuideType = "M",
              GuidePointName = "Mechanism_12000101_1220106"
            }
          },
          ["179017539883414963"] = {
            key = "179017539883414963",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 896.8478109081192, y = 238.53428020516697},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "91"}
              }
            }
          },
          ["179017539883414964"] = {
            key = "179017539883414964",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1205.8794618191528, y = 403.81818517350365},
            propsData = {VarName = "1.7_Lise01", VarValue = 91}
          },
          ["179023645314512038771"] = {
            key = "179023645314512038771",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1811.2801122000196, y = 478.0773561476889},
            propsData = {}
          },
          ["179023645314512038772"] = {
            key = "179023645314512038772",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1812.4121954922887, y = 313.84572077538803},
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
    ["17869683075035035676"] = {
      isStoryNode = true,
      key = "17869683075035035676",
      type = "StoryNode",
      name = "百花车站",
      pos = {x = 1362.188328912467, y = 294.1086691086691},
      propsData = {
        QuestId = 12070302,
        QuestDescriptionComment = "和蕾伊去车站找约翰森",
        QuestDescription = "Description_120703_5",
        QuestDeatil = "Content_120703_5",
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
        SubRegionId = 106001,
        SubRegionIdList = {101101},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_352480711",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17870633291712943",
            startPort = "Out",
            endQuest = "17869684720455038050",
            endPort = "In"
          },
          {
            startQuest = "17869684720455038050",
            startPort = "Fail",
            endQuest = "179023752823420629474",
            endPort = "In"
          },
          {
            startQuest = "17869684720455038050",
            startPort = "PassiveFail",
            endQuest = "179023752823420629474",
            endPort = "In"
          },
          {
            startQuest = "179023752823420629474",
            startPort = "Out",
            endQuest = "179023751787320629398",
            endPort = "In"
          },
          {
            startQuest = "179023751787320629398",
            startPort = "Out",
            endQuest = "17869683075035035683",
            endPort = "Fail"
          },
          {
            startQuest = "17869683075035035677",
            startPort = "QuestStart",
            endQuest = "17870633291712943",
            endPort = "In"
          },
          {
            startQuest = "17869684720455038050",
            startPort = "Success",
            endQuest = "17869683075035035680",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17869683075035035677"] = {
            key = "17869683075035035677",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1124.2220148272777, y = 310.493059572007},
            propsData = {ModeType = 0}
          },
          ["17869683075035035680"] = {
            key = "17869683075035035680",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1979.8283363687792, y = 270.87310743321757},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17869683075035035683"] = {
            key = "17869683075035035683",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1987.186588236773, y = 742.1113311050684},
            propsData = {}
          },
          ["17869684720455038050"] = {
            key = "17869684720455038050",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务302",
            pos = {x = 1695.882186234818, y = 285.7326527019891},
            propsData = {SpecialConfigId = 12070302, BlackScreenImmediately = true}
          },
          ["17870633291712943"] = {
            key = "17870633291712943",
            type = "GoToNode",
            name = "前往车站精确框",
            pos = {x = 1416.9794679005206, y = 295.05668016194335},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 352480711,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_352480711"
            }
          },
          ["179023751787320629398"] = {
            key = "179023751787320629398",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1986.2608695652173, y = 596.1739130434785},
            propsData = {}
          },
          ["179023752823420629474"] = {
            key = "179023752823420629474",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1984.1304347826087, y = 419.8260869565217},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_BHCZStart",
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
    ["17869683096705035793"] = {
      isStoryNode = true,
      key = "17869683096705035793",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1662.5873015873017, y = 294.88888888888886},
      propsData = {
        QuestId = 12070303,
        QuestDescriptionComment = "回冰湖城跟着约翰森",
        QuestDescription = "Description_120703_6",
        QuestDeatil = "Content_120703_6",
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
        StoryGuidePointName = "Mechanism_QuestTrigger_351192108",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17869685116365038888",
            startPort = "Success",
            endQuest = "17869683096705035797",
            endPort = "Success"
          },
          {
            startQuest = "17870634695725214",
            startPort = "Out",
            endQuest = "17869685116365038888",
            endPort = "In"
          },
          {
            startQuest = "17869683096705035794",
            startPort = "QuestStart",
            endQuest = "17901393740258577370",
            endPort = "In"
          },
          {
            startQuest = "17901393740258577370",
            startPort = "false",
            endQuest = "17901393866558577643",
            endPort = "In"
          },
          {
            startQuest = "17901393740258577370",
            startPort = "true",
            endQuest = "17870634695725214",
            endPort = "In"
          },
          {
            startQuest = "179023765151122348118",
            startPort = "Out",
            endQuest = "179023764665722347992",
            endPort = "In"
          },
          {
            startQuest = "179023764665722347992",
            startPort = "Out",
            endQuest = "17869683096705035800",
            endPort = "Fail"
          },
          {
            startQuest = "17869685116365038888",
            startPort = "Fail",
            endQuest = "179023765151122348118",
            endPort = "In"
          },
          {
            startQuest = "17869685116365038888",
            startPort = "PassiveFail",
            endQuest = "179023765151122348118",
            endPort = "In"
          },
          {
            startQuest = "17901393740258577370",
            startPort = "false",
            endQuest = "17902454561976875027",
            endPort = "In"
          },
          {
            startQuest = "17902454561976875027",
            startPort = "Out",
            endQuest = "17869685116365038888",
            endPort = "In"
          }
        },
        nodeData = {
          ["17869683096705035794"] = {
            key = "17869683096705035794",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 511.2164285879388, y = 285.2316771837367},
            propsData = {ModeType = 0}
          },
          ["17869683096705035797"] = {
            key = "17869683096705035797",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1725.5253023864002, y = 271.31605099705786},
            propsData = {ModeType = 0}
          },
          ["17869683096705035800"] = {
            key = "17869683096705035800",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1720.940207109639, y = 740.3732829619632},
            propsData = {}
          },
          ["17869685116365038888"] = {
            key = "17869685116365038888",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务303",
            pos = {x = 1428.1007369767126, y = 279.7349575986},
            propsData = {SpecialConfigId = 12070303, BlackScreenImmediately = true}
          },
          ["17870634695725214"] = {
            key = "17870634695725214",
            type = "GoToNode",
            name = "前往城门附近",
            pos = {x = 1108.743762257694, y = 143.89369669232374},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192108,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192108"
            }
          },
          ["17901393740258577370"] = {
            key = "17901393740258577370",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 779.1114369501465, y = 267.3372434017597},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "99"}
              }
            }
          },
          ["17901393866558577643"] = {
            key = "17901393866558577643",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1129.2930596285435, y = 486.27253176930606},
            propsData = {VarName = "1.7_Lise01", VarValue = 99}
          },
          ["179023764665722347992"] = {
            key = "179023764665722347992",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1723.6, y = 596.6285714285716},
            propsData = {}
          },
          ["179023765151122348118"] = {
            key = "179023765151122348118",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1725.0285714285715, y = 416.62857142857143},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_CityRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17902454561976875027"] = {
            key = "17902454561976875027",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "精确传送城门附近",
            pos = {x = 1115.4181263181263, y = 306.3149046355943},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_Stalk_1207",
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
    ["17901726531172141"] = {
      isStoryNode = true,
      key = "17901726531172141",
      type = "StoryNode",
      name = "冰湖城沿路",
      pos = {x = 1088.4, y = 514.3972582972582},
      propsData = {
        QuestId = 12070311,
        QuestDescriptionComment = "冰湖城沿路打探",
        QuestDescription = "Description_120703_2",
        QuestDeatil = "Content_120703_2",
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
            startQuest = "17901727844644590",
            startPort = "Success",
            endQuest = "17901726531182145",
            endPort = "Success"
          },
          {
            startQuest = "17901727327283883",
            startPort = "Out",
            endQuest = "17901727844644590",
            endPort = "In"
          },
          {
            startQuest = "17901728045615017",
            startPort = "true",
            endQuest = "17901727327283883",
            endPort = "In"
          },
          {
            startQuest = "17901726531172142",
            startPort = "QuestStart",
            endQuest = "17901728045615017",
            endPort = "In"
          },
          {
            startQuest = "179023663015813757234",
            startPort = "Out",
            endQuest = "179023663015813757233",
            endPort = "In"
          },
          {
            startQuest = "17901727844644590",
            startPort = "Fail",
            endQuest = "179023663015813757234",
            endPort = "In"
          },
          {
            startQuest = "17901727844644590",
            startPort = "PassiveFail",
            endQuest = "179023663015813757234",
            endPort = "In"
          },
          {
            startQuest = "179023663015813757233",
            startPort = "Out",
            endQuest = "17901726531182148",
            endPort = "Fail"
          },
          {
            startQuest = "17901728045615017",
            startPort = "false",
            endQuest = "17901728045615018",
            endPort = "In"
          },
          {
            startQuest = "17901728045615017",
            startPort = "false",
            endQuest = "17901727844644590",
            endPort = "In"
          }
        },
        nodeData = {
          ["17901726531172142"] = {
            key = "17901726531172142",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 547.1428571428571, y = 293.57142857142856},
            propsData = {ModeType = 0}
          },
          ["17901726531182145"] = {
            key = "17901726531182145",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1844.6583850931677, y = 278.3850931677019},
            propsData = {ModeType = 0}
          },
          ["17901726531182148"] = {
            key = "17901726531182148",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1844.2236024844717, y = 738.9068322981368},
            propsData = {}
          },
          ["17901727327283883"] = {
            key = "17901727327283883",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1154.5714285714287, y = 178.28571428571428},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192127,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192127"
            }
          },
          ["17901727844644590"] = {
            key = "17901727844644590",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务311",
            pos = {x = 1496.6995614035086, y = 290.75415812257916},
            propsData = {SpecialConfigId = 12070311, BlackScreenImmediately = true}
          },
          ["17901728045615017"] = {
            key = "17901728045615017",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 844.3590606233165, y = 296.45636148256665},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "94"}
              }
            }
          },
          ["17901728045615018"] = {
            key = "17901728045615018",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1160.6739627658776, y = 446.9762718248397},
            propsData = {VarName = "1.7_Lise01", VarValue = 94}
          },
          ["179023663015813757233"] = {
            key = "179023663015813757233",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1843.2472195575995, y = 594.2814384683159},
            propsData = {}
          },
          ["179023663015813757234"] = {
            key = "179023663015813757234",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1843.2745195728353, y = 427.7930956931747},
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
    },
    ["17901726832292667"] = {
      isStoryNode = true,
      key = "17901726832292667",
      type = "StoryNode",
      name = "冰湖打怪",
      pos = {x = 1356.177777777778, y = 519.9131313131312},
      propsData = {
        QuestId = 12070321,
        QuestDescriptionComment = "城门外打雪狼",
        QuestDescription = "Description_120703_3",
        QuestDeatil = "Content_120703_3",
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
        SubRegionId = 101103,
        SubRegionIdList = {101101},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351192091",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17901744689669838",
            startPort = "Out",
            endQuest = "17901744689669839",
            endPort = "In"
          },
          {
            startQuest = "17901744689669840",
            startPort = "false",
            endQuest = "17901744689669841",
            endPort = "In"
          },
          {
            startQuest = "17901744689669840",
            startPort = "true",
            endQuest = "17901744689669838",
            endPort = "In"
          },
          {
            startQuest = "17901726832292668",
            startPort = "QuestStart",
            endQuest = "17901744689669840",
            endPort = "In"
          },
          {
            startQuest = "17901744689669839",
            startPort = "Success",
            endQuest = "17901726832302671",
            endPort = "Success"
          },
          {
            startQuest = "179023669876215474615",
            startPort = "Out",
            endQuest = "179023669876215474614",
            endPort = "In"
          },
          {
            startQuest = "17901744689669839",
            startPort = "Fail",
            endQuest = "179023669876215474615",
            endPort = "In"
          },
          {
            startQuest = "17901744689669839",
            startPort = "PassiveFail",
            endQuest = "179023669876215474615",
            endPort = "In"
          },
          {
            startQuest = "179023669876215474614",
            startPort = "Out",
            endQuest = "17901726832302674",
            endPort = "Fail"
          },
          {
            startQuest = "17901744689669840",
            startPort = "false",
            endQuest = "17904780442712679",
            endPort = "In"
          },
          {
            startQuest = "17904780442712679",
            startPort = "Out",
            endQuest = "17901744689669839",
            endPort = "In"
          }
        },
        nodeData = {
          ["17901726832292668"] = {
            key = "17901726832292668",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17901726832302671"] = {
            key = "17901726832302671",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2103.75, y = 276},
            propsData = {ModeType = 0}
          },
          ["17901726832302674"] = {
            key = "17901726832302674",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2091.25, y = 738.75},
            propsData = {}
          },
          ["17901744689669838"] = {
            key = "17901744689669838",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1461.7921175580161, y = 175.18181482649635},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192091,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192091"
            }
          },
          ["17901744689669839"] = {
            key = "17901744689669839",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务321",
            pos = {x = 1780.170250390096, y = 287.6502586633612},
            propsData = {SpecialConfigId = 12070321, BlackScreenImmediately = true}
          },
          ["17901744689669840"] = {
            key = "17901744689669840",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1127.829749609904, y = 293.3524620233487},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "93"}
              }
            }
          },
          ["17901744689669841"] = {
            key = "17901744689669841",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1461.9750368845741, y = 475.56818517350365},
            propsData = {VarName = "1.7_Lise01", VarValue = 93}
          },
          ["179023669876215474614"] = {
            key = "179023669876215474614",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 2091.5365566927358, y = 595.1949983654789},
            propsData = {}
          },
          ["179023669876215474615"] = {
            key = "179023669876215474615",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2102.4634433072647, y = 428.80500163452086},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_WolvesRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17904780442712679"] = {
            key = "17904780442712679",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1459.8050974512744, y = 323.24137931034477},
            propsData = {
              RegionType = 2,
              IsEnter = "Enter",
              RegionId = 1011,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    },
    ["17901726907732917"] = {
      isStoryNode = true,
      key = "17901726907732917",
      type = "StoryNode",
      name = "冰湖城找蕾伊",
      pos = {x = 1641.8188034188038, y = 521.3661227661227},
      propsData = {
        QuestId = 12070331,
        QuestDescriptionComment = "回复蕾伊",
        QuestDescription = "Description_120703_4",
        QuestDeatil = "Content_120703_4",
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
        SubRegionIdList = {101103},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351192127",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "179017527210112722",
            startPort = "Out",
            endQuest = "179017527210112723",
            endPort = "In"
          },
          {
            startQuest = "179017527210112724",
            startPort = "false",
            endQuest = "179017527210112725",
            endPort = "In"
          },
          {
            startQuest = "179017527210112724",
            startPort = "true",
            endQuest = "179017527210112722",
            endPort = "In"
          },
          {
            startQuest = "17901726907732918",
            startPort = "QuestStart",
            endQuest = "179017527210112724",
            endPort = "In"
          },
          {
            startQuest = "179017527210112723",
            startPort = "Success",
            endQuest = "17901726907732921",
            endPort = "Success"
          },
          {
            startQuest = "179023725257818910051",
            startPort = "Out",
            endQuest = "179023725257818910050",
            endPort = "In"
          },
          {
            startQuest = "179023725257818910050",
            startPort = "Out",
            endQuest = "17901726907732924",
            endPort = "Fail"
          },
          {
            startQuest = "179017527210112723",
            startPort = "Fail",
            endQuest = "179023725257818910051",
            endPort = "In"
          },
          {
            startQuest = "179017527210112723",
            startPort = "PassiveFail",
            endQuest = "179023725257818910051",
            endPort = "In"
          },
          {
            startQuest = "179017527210112724",
            startPort = "false",
            endQuest = "17904780912541713271",
            endPort = "In"
          },
          {
            startQuest = "17904780912541713271",
            startPort = "Out",
            endQuest = "179017527210112723",
            endPort = "In"
          }
        },
        nodeData = {
          ["17901726907732918"] = {
            key = "17901726907732918",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17901726907732921"] = {
            key = "17901726907732921",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2081.1428571428573, y = 248.57142857142856},
            propsData = {ModeType = 0}
          },
          ["17901726907732924"] = {
            key = "17901726907732924",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2074, y = 719.4285714285713},
            propsData = {}
          },
          ["179017527210112722"] = {
            key = "179017527210112722",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1430.0421175580161, y = 165.18181482649635},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192127,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192127"
            }
          },
          ["179017527210112723"] = {
            key = "179017527210112723",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务331",
            pos = {x = 1772.170250390096, y = 277.6502586633612},
            propsData = {SpecialConfigId = 12070331, BlackScreenImmediately = true}
          },
          ["179017527210112724"] = {
            key = "179017527210112724",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1119.829749609904, y = 283.3524620233487},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "92"}
              }
            }
          },
          ["179017527210112725"] = {
            key = "179017527210112725",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1432.2530089125462, y = 482.2727306280491},
            propsData = {VarName = "1.7_Lise01", VarValue = 92}
          },
          ["179023725257818910050"] = {
            key = "179023725257818910050",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 2077.754381866282, y = 568.3761966457064},
            propsData = {}
          },
          ["179023725257818910051"] = {
            key = "179023725257818910051",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2080.817046705146, y = 395.6238033542935},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_CityRestart_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17904780912541713271"] = {
            key = "17904780912541713271",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1430.9090909090908, y = 322.5454545454545},
            propsData = {
              RegionType = 2,
              IsEnter = "Enter",
              RegionId = 1011,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
