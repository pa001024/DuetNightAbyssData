return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "176493310227919746620",
      startPort = "StoryStart",
      endStory = "176493310455119746678",
      endPort = "In"
    },
    {
      startStory = "176493310455119746678",
      startPort = "Success",
      endStory = "1765179541460672",
      endPort = "In"
    },
    {
      startStory = "1765179541460672",
      startPort = "Success",
      endStory = "17651852542782090209",
      endPort = "In"
    },
    {
      startStory = "17651938690864181646",
      startPort = "Success",
      endStory = "17651942414394184533",
      endPort = "In"
    },
    {
      startStory = "17651942414394184533",
      startPort = "Success",
      endStory = "17651943125064186086",
      endPort = "In"
    },
    {
      startStory = "17651943125064186086",
      startPort = "Success",
      endStory = "17651943353314186745",
      endPort = "In"
    },
    {
      startStory = "17659611443691059773",
      startPort = "Success",
      endStory = "17651938690864181646",
      endPort = "In"
    },
    {
      startStory = "17651852542782090209",
      startPort = "Success",
      endStory = "17651936355533135760",
      endPort = "In"
    },
    {
      startStory = "17651943353314186745",
      startPort = "Success",
      endStory = "17676902270196179692",
      endPort = "In"
    },
    {
      startStory = "17676902270196179692",
      startPort = "Success",
      endStory = "17676903666966180869",
      endPort = "In"
    },
    {
      startStory = "17676903666966180869",
      startPort = "Success",
      endStory = "176493310228019746623",
      endPort = "StoryEnd"
    },
    {
      startStory = "17651936355533135760",
      startPort = "Success",
      endStory = "17791781854791450189",
      endPort = "In"
    },
    {
      startStory = "17791781854791450189",
      startPort = "Success",
      endStory = "17651937148873137426",
      endPort = "In"
    },
    {
      startStory = "17651937148873137426",
      startPort = "Success",
      endStory = "17659611443691059773",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["176493310227919746620"] = {
      isStoryNode = true,
      key = "176493310227919746620",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 815.832258064516, y = 98.39999999999998},
      propsData = {QuestChainId = 100403},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["176493310228019746623"] = {
      isStoryNode = true,
      key = "176493310228019746623",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2742.3756745845994, y = 343.5543122642515},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["176493310455119746678"] = {
      isStoryNode = true,
      key = "176493310455119746678",
      type = "StoryNode",
      name = "前往爆炸现场",
      pos = {x = 1121.9325396825398, y = 92.4948869932049},
      propsData = {
        QuestId = 10040301,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040301_01",
        QuestDeatil = "Description_10040301_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = true,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0,
        QuestUIId = 100404
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782405204331442123",
            startPort = "Success",
            endQuest = "176493310455119746682",
            endPort = "Success"
          },
          {
            startQuest = "17782405204331442123",
            startPort = "Fail",
            endQuest = "17788270433371465383",
            endPort = "In"
          },
          {
            startQuest = "17782405204331442123",
            startPort = "PassiveFail",
            endQuest = "17788270433371465383",
            endPort = "In"
          },
          {
            startQuest = "17788270433371465383",
            startPort = "Out",
            endQuest = "176493310455119746685",
            endPort = "Fail"
          },
          {
            startQuest = "17788269792731708",
            startPort = "Out",
            endQuest = "17791878350152077",
            endPort = "In"
          },
          {
            startQuest = "17791878350152077",
            startPort = "Out",
            endQuest = "17782405204331442123",
            endPort = "In"
          },
          {
            startQuest = "176493310455119746679",
            startPort = "QuestStart",
            endQuest = "17793651361089875",
            endPort = "In"
          },
          {
            startQuest = "17793651361089875",
            startPort = "true",
            endQuest = "17793651378709916",
            endPort = "In"
          },
          {
            startQuest = "17793651378709916",
            startPort = "Out",
            endQuest = "17788269792731708",
            endPort = "In"
          },
          {
            startQuest = "17793651361089875",
            startPort = "false",
            endQuest = "17793693566045800727",
            endPort = "In"
          },
          {
            startQuest = "17793693566045800727",
            startPort = "Out",
            endQuest = "17793693467255800406",
            endPort = "Input"
          },
          {
            startQuest = "17793693467255800406",
            startPort = "True",
            endQuest = "17782405204331442123",
            endPort = "In"
          },
          {
            startQuest = "17793693467255800406",
            startPort = "False",
            endQuest = "17788270433371465383",
            endPort = "In"
          }
        },
        nodeData = {
          ["176493310455119746679"] = {
            key = "176493310455119746679",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -125.43371163665714, y = 92.37109034412667},
            propsData = {ModeType = 0}
          },
          ["176493310455119746682"] = {
            key = "176493310455119746682",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2411.1402834312285, y = 68.54086579527359},
            propsData = {ModeType = 0}
          },
          ["176493310455119746685"] = {
            key = "176493310455119746685",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2415.796113445378, y = 338.61123949579826},
            propsData = {}
          },
          ["17782405204331442123"] = {
            key = "17782405204331442123",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1346.629706477733, y = 88.82587761209052},
            propsData = {SpecialConfigId = 10040301, BlackScreenImmediately = true}
          },
          ["17788269792731708"] = {
            key = "17788269792731708",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家到芙罗拉专列外",
            pos = {x = 737.7268674270921, y = 86.87525216329567},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Teleport_10040312",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17788270433371465383"] = {
            key = "17788270433371465383",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1987.2176176792555, y = 226.59603174603177},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791878350152077"] = {
            key = "17791878350152077",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1015.7851037851036, y = 93.95702075702059},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["17793651361089875"] = {
            key = "17793651361089875",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 157.31708303007747, y = 85.47672724592219},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040301",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17793651378709916"] = {
            key = "17793651378709916",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 464.15241774367314, y = 84.66678935772353},
            propsData = {
              VarName = "First10040301",
              VarValue = 1
            }
          },
          ["17793693467255800406"] = {
            key = "17793693467255800406",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1359.1419720443487, y = 306.41877178026033},
            propsData = {PopupId = 100110}
          },
          ["17793693566045800727"] = {
            key = "17793693566045800727",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1019.0350017199866, y = 313.9722569424412},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          }
        },
        commentData = {}
      }
    },
    ["1765179541460672"] = {
      isStoryNode = true,
      key = "1765179541460672",
      type = "StoryNode",
      name = "调查爆炸现场",
      pos = {x = 1367.399365867108, y = 101.76811594202894},
      propsData = {
        QuestId = 10040302,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040302_01",
        QuestDeatil = "Description_10040303_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782440946712873118",
            startPort = "Success",
            endQuest = "1765179541461676",
            endPort = "Success"
          },
          {
            startQuest = "17782440946712873118",
            startPort = "Fail",
            endQuest = "17788355104241327",
            endPort = "In"
          },
          {
            startQuest = "17782440946712873118",
            startPort = "PassiveFail",
            endQuest = "17788355104241327",
            endPort = "In"
          },
          {
            startQuest = "17788355104241327",
            startPort = "Out",
            endQuest = "1765179541461679",
            endPort = "Fail"
          },
          {
            startQuest = "1765179541460673",
            startPort = "QuestStart",
            endQuest = "17793656193434357150",
            endPort = "In"
          },
          {
            startQuest = "17793656193434357150",
            startPort = "false",
            endQuest = "17791932656202898214",
            endPort = "In"
          },
          {
            startQuest = "17791932656202898214",
            startPort = "Out",
            endQuest = "17793656661084357736",
            endPort = "Input"
          },
          {
            startQuest = "17793656661084357736",
            startPort = "True",
            endQuest = "17782440946712873118",
            endPort = "In"
          },
          {
            startQuest = "17793656661084357736",
            startPort = "False",
            endQuest = "17788355104241327",
            endPort = "In"
          },
          {
            startQuest = "17793656193434357150",
            startPort = "true",
            endQuest = "17793656524564357275",
            endPort = "In"
          },
          {
            startQuest = "17793656193434357150",
            startPort = "true",
            endQuest = "17782440946712873118",
            endPort = "In"
          }
        },
        nodeData = {
          ["1765179541460673"] = {
            key = "1765179541460673",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1524.7036789297658, y = 321.30531400966186},
            propsData = {ModeType = 0}
          },
          ["1765179541461676"] = {
            key = "1765179541461676",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 241.99523809523816, y = 282.4571428571428},
            propsData = {ModeType = 0}
          },
          ["1765179541461679"] = {
            key = "1765179541461679",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 312.04347826087, y = 699.1739130434783},
            propsData = {}
          },
          ["17782440946712873118"] = {
            key = "17782440946712873118",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -268.43654810102134, y = 297.90109890109886},
            propsData = {SpecialConfigId = 10040302, BlackScreenImmediately = true}
          },
          ["17788355104241327"] = {
            key = "17788355104241327",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 48, y = 482.00000000000006},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791932656202898214"] = {
            key = "17791932656202898214",
            type = "GoToNode",
            name = "前往",
            pos = {x = -1119.6666666666667, y = 636.8333333333334},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["17793656193434357150"] = {
            key = "17793656193434357150",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -1153.363636363636, y = 318.3333333333331},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040302",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17793656524564357275"] = {
            key = "17793656524564357275",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -705.1969696969692, y = 123.3333333333332},
            propsData = {
              VarName = "First10040302",
              VarValue = 1
            }
          },
          ["17793656661084357736"] = {
            key = "17793656661084357736",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = -660.3926218708822, y = 646.1594202898548},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17651852542782090209"] = {
      isStoryNode = true,
      key = "17651852542782090209",
      type = "StoryNode",
      name = "回复士兵",
      pos = {x = 1640.1643680390487, y = 100.52095521699053},
      propsData = {
        QuestId = 10040303,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040303_01",
        QuestDeatil = "Description_10040303_02",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17785970386233693",
            startPort = "Out",
            endQuest = "17785970581394173",
            endPort = "In"
          },
          {
            startQuest = "17785970581394173",
            startPort = "Out",
            endQuest = "17785970594444227",
            endPort = "In"
          },
          {
            startQuest = "17782442738252874017",
            startPort = "Fail",
            endQuest = "17788355467811448405",
            endPort = "In"
          },
          {
            startQuest = "17782442738252874017",
            startPort = "PassiveFail",
            endQuest = "17788355467811448405",
            endPort = "In"
          },
          {
            startQuest = "17788355467811448405",
            startPort = "Out",
            endQuest = "17651852542782090216",
            endPort = "Fail"
          },
          {
            startQuest = "17782442738252874017",
            startPort = "Success",
            endQuest = "17651852542782090213",
            endPort = "Success"
          },
          {
            startQuest = "17651852542782090210",
            startPort = "QuestStart",
            endQuest = "17793658496995807225",
            endPort = "In"
          },
          {
            startQuest = "17793658496995807225",
            startPort = "false",
            endQuest = "17791932812032898709",
            endPort = "In"
          },
          {
            startQuest = "17791932812032898709",
            startPort = "Out",
            endQuest = "17793658564435807427",
            endPort = "Input"
          },
          {
            startQuest = "17793658564435807427",
            startPort = "True",
            endQuest = "17782442738252874017",
            endPort = "In"
          },
          {
            startQuest = "17793658564435807427",
            startPort = "False",
            endQuest = "17788355467811448405",
            endPort = "In"
          },
          {
            startQuest = "17793658496995807225",
            startPort = "true",
            endQuest = "17793658513635807256",
            endPort = "In"
          },
          {
            startQuest = "17793658496995807225",
            startPort = "true",
            endQuest = "17782442738252874017",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651852542782090210"] = {
            key = "17651852542782090210",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -260.01923076923094, y = 371.8159340659341},
            propsData = {ModeType = 0}
          },
          ["17651852542782090213"] = {
            key = "17651852542782090213",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1334.6336457659982, y = 383.3931803490626},
            propsData = {ModeType = 0}
          },
          ["17651852542782090216"] = {
            key = "17651852542782090216",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1479.6923076923078, y = 848},
            propsData = {}
          },
          ["17782442738252874017"] = {
            key = "17782442738252874017",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1035.0124951802586, y = 366.3076923076923},
            propsData = {SpecialConfigId = 10040303, BlackScreenImmediately = true}
          },
          ["17785970386233693"] = {
            key = "17785970386233693",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1353.8757576917408, y = -33.531351001939356},
            propsData = {
              VarName = "Chapter03_10040305_01",
              VarValue = 0
            }
          },
          ["17785970581394173"] = {
            key = "17785970581394173",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1662.1522301228185, y = -38.22430510665822},
            propsData = {
              VarName = "Chapter03_10040305_02",
              VarValue = 0
            }
          },
          ["17785970594444227"] = {
            key = "17785970594444227",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1954.235294117647, y = -32.66839043309642},
            propsData = {
              VarName = "Chapter03_10040305_03",
              VarValue = 0
            }
          },
          ["17788355467811448405"] = {
            key = "17788355467811448405",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1224.8890013495277, y = 840.6316862961601},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791932812032898709"] = {
            key = "17791932812032898709",
            type = "GoToNode",
            name = "前往",
            pos = {x = 270.5, y = 676.25},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["17793658496995807225"] = {
            key = "17793658496995807225",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 257.19318181818204, y = 374.25000000000006},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040303",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17793658513635807256"] = {
            key = "17793658513635807256",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 658.3765151515154, y = 175.14999999999992},
            propsData = {
              VarName = "First10040303",
              VarValue = 1
            }
          },
          ["17793658564435807427"] = {
            key = "17793658564435807427",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 680.5265151515155, y = 676.7500000000001},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {
          ["17785971918976040"] = {
            key = "17785971918976040",
            name = "把下一环任务要用的变量先设置一下",
            position = {x = 1306.9502262443439, y = -122.21266968325801},
            size = {width = 899.2533936651588, height = 306.10859728506796}
          }
        }
      }
    },
    ["17651936355533135760"] = {
      isStoryNode = true,
      key = "17651936355533135760",
      type = "StoryNode",
      name = "仓库调查",
      pos = {x = 1933.3481159363514, y = 102.30324980149094},
      propsData = {
        QuestId = 10040305,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040305_01",
        QuestDeatil = "Description_10040305_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782445164254309471",
            startPort = "Success",
            endQuest = "17651936355533135764",
            endPort = "Success"
          },
          {
            startQuest = "17782445164254309471",
            startPort = "Fail",
            endQuest = "17788356416151449115",
            endPort = "In"
          },
          {
            startQuest = "17782445164254309471",
            startPort = "PassiveFail",
            endQuest = "17788356416151449115",
            endPort = "In"
          },
          {
            startQuest = "17788356416151449115",
            startPort = "Out",
            endQuest = "17651936355533135767",
            endPort = "Fail"
          },
          {
            startQuest = "17651936355533135761",
            startPort = "QuestStart",
            endQuest = "17793659651978705664",
            endPort = "In"
          },
          {
            startQuest = "17793659651978705664",
            startPort = "true",
            endQuest = "17793659693228705768",
            endPort = "In"
          },
          {
            startQuest = "17793659651978705664",
            startPort = "false",
            endQuest = "17791934130072899955",
            endPort = "In"
          },
          {
            startQuest = "17791934130072899955",
            startPort = "Out",
            endQuest = "17793659783568706032",
            endPort = "Input"
          },
          {
            startQuest = "17793659783568706032",
            startPort = "True",
            endQuest = "17782445164254309471",
            endPort = "In"
          },
          {
            startQuest = "17793659783568706032",
            startPort = "False",
            endQuest = "17788356416151449115",
            endPort = "In"
          },
          {
            startQuest = "17793659651978705664",
            startPort = "true",
            endQuest = "17782445164254309471",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651936355533135761"] = {
            key = "17651936355533135761",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1510.2152294166813, y = 255.56505237049703},
            propsData = {ModeType = 0}
          },
          ["17651936355533135764"] = {
            key = "17651936355533135764",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 171.2074088895397, y = 228.34960270491308},
            propsData = {ModeType = 0}
          },
          ["17651936355533135767"] = {
            key = "17651936355533135767",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 166, y = 400},
            propsData = {}
          },
          ["17782445164254309471"] = {
            key = "17782445164254309471",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -399.5357142857143, y = 245.60714285714286},
            propsData = {SpecialConfigId = 10040305, BlackScreenImmediately = true}
          },
          ["17788356416151449115"] = {
            key = "17788356416151449115",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -120, y = 400},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791934130072899955"] = {
            key = "17791934130072899955",
            type = "GoToNode",
            name = "前往",
            pos = {x = -1110.8645320197047, y = 580.3103448275863},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["17793659651978705664"] = {
            key = "17793659651978705664",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -1136.2818181818175, y = 252.58876341050262},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040305",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17793659693228705768"] = {
            key = "17793659693228705768",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -763.448484848484, y = 42.58876341050248},
            propsData = {
              VarName = "First10040305",
              VarValue = 1
            }
          },
          ["17793659783568706032"] = {
            key = "17793659783568706032",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = -772.4484848484842, y = 592.5887634105027},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17651937148873137426"] = {
      isStoryNode = true,
      key = "17651937148873137426",
      type = "StoryNode",
      name = "引爆炸弹战斗节点",
      pos = {x = 2220.117699208258, y = 106.92874807772452},
      propsData = {
        QuestId = 10040306,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040306_01",
        QuestDeatil = "Description_10040305_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Storeroom_2480211",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782450403765743626",
            startPort = "Success",
            endQuest = "17651937148873137430",
            endPort = "Success"
          },
          {
            startQuest = "17782450403765743626",
            startPort = "Fail",
            endQuest = "17788356566021449688",
            endPort = "In"
          },
          {
            startQuest = "17782450403765743626",
            startPort = "PassiveFail",
            endQuest = "17788356566021449688",
            endPort = "In"
          },
          {
            startQuest = "17788356566021449688",
            startPort = "Out",
            endQuest = "17651937148873137433",
            endPort = "Fail"
          },
          {
            startQuest = "17651937148873137427",
            startPort = "QuestStart",
            endQuest = "177936652419210156509",
            endPort = "In"
          },
          {
            startQuest = "177936652419210156509",
            startPort = "true",
            endQuest = "177936652581510156545",
            endPort = "In"
          },
          {
            startQuest = "177936652419210156509",
            startPort = "false",
            endQuest = "17791903330802122",
            endPort = "In"
          },
          {
            startQuest = "17791903330802122",
            startPort = "Out",
            endQuest = "177936656553210157486",
            endPort = "Input"
          },
          {
            startQuest = "177936656553210157486",
            startPort = "True",
            endQuest = "17782450403765743626",
            endPort = "In"
          },
          {
            startQuest = "177936656553210157486",
            startPort = "False",
            endQuest = "17788356566021449688",
            endPort = "In"
          },
          {
            startQuest = "177936652419210156509",
            startPort = "true",
            endQuest = "17782450403765743626",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651937148873137427"] = {
            key = "17651937148873137427",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -486.4589015447028, y = 404.9232177612076},
            propsData = {ModeType = 0}
          },
          ["17651937148873137430"] = {
            key = "17651937148873137430",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 869.9527672404996, y = 371.0946441329569},
            propsData = {ModeType = 0}
          },
          ["17651937148873137433"] = {
            key = "17651937148873137433",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1072.673076923077, y = 560.1346153846155},
            propsData = {}
          },
          ["17782450403765743626"] = {
            key = "17782450403765743626",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 584, y = 380},
            propsData = {SpecialConfigId = 10040306, BlackScreenImmediately = true}
          },
          ["17788356566021449688"] = {
            key = "17788356566021449688",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 830.5, y = 551.75},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791903330802122"] = {
            key = "17791903330802122",
            type = "GoToNode",
            name = "前往",
            pos = {x = -96.22500000000014, y = 680.2122807017543},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2480211,
              GuideType = "M",
              GuidePointName = "Mechanism_Storeroom_2480211"
            }
          },
          ["177936652419210156509"] = {
            key = "177936652419210156509",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -109.93181818181813, y = 393.75000000000006},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040306",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177936652581510156545"] = {
            key = "177936652581510156545",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 243.90151515151524, y = 161.49999999999994},
            propsData = {
              VarName = "First10040306",
              VarValue = 1
            }
          },
          ["177936656553210157486"] = {
            key = "177936656553210157486",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 255.90151515151516, y = 685.0000000000001},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17651938690864181646"] = {
      isStoryNode = true,
      key = "17651938690864181646",
      type = "StoryNode",
      name = "调查任务",
      pos = {x = 1118.6680084621266, y = 331.34187305254244},
      propsData = {
        QuestId = 10040307,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040307_01",
        QuestDeatil = "Description_10040307_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782473686697178911",
            startPort = "Success",
            endQuest = "17651938690864181652",
            endPort = "Success"
          },
          {
            startQuest = "17782473686697178911",
            startPort = "Fail",
            endQuest = "17788357459754343023",
            endPort = "In"
          },
          {
            startQuest = "17782473686697178911",
            startPort = "PassiveFail",
            endQuest = "17788357459754343023",
            endPort = "In"
          },
          {
            startQuest = "17788357459754343023",
            startPort = "Out",
            endQuest = "17651938690864181653",
            endPort = "Fail"
          },
          {
            startQuest = "17651938690864181651",
            startPort = "QuestStart",
            endQuest = "177936697953111609029",
            endPort = "In"
          },
          {
            startQuest = "17791935080812902279",
            startPort = "Out",
            endQuest = "177936698763011609288",
            endPort = "Input"
          },
          {
            startQuest = "177936698763011609288",
            startPort = "True",
            endQuest = "17782473686697178911",
            endPort = "In"
          },
          {
            startQuest = "177936698763011609288",
            startPort = "False",
            endQuest = "17788357459754343023",
            endPort = "In"
          },
          {
            startQuest = "177936697953111609029",
            startPort = "false",
            endQuest = "17791935080812902279",
            endPort = "In"
          },
          {
            startQuest = "177936697953111609029",
            startPort = "true",
            endQuest = "177936698384611609190",
            endPort = "In"
          },
          {
            startQuest = "177936697953111609029",
            startPort = "true",
            endQuest = "17782473686697178911",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651938690864181651"] = {
            key = "17651938690864181651",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -976.4061800268697, y = 266.3944245409762},
            propsData = {ModeType = 0}
          },
          ["17651938690864181652"] = {
            key = "17651938690864181652",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 475.5801435406702, y = 248.33732057416267},
            propsData = {ModeType = 0}
          },
          ["17651938690864181653"] = {
            key = "17651938690864181653",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 679.5652173913044, y = 491.04347826086956},
            propsData = {}
          },
          ["17782473686697178911"] = {
            key = "17782473686697178911",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 154.35714285714286, y = 264.2857142857143},
            propsData = {SpecialConfigId = 10040307, BlackScreenImmediately = true}
          },
          ["17788357459754343023"] = {
            key = "17788357459754343023",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 425.34394409937875, y = 485.89130434782606},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791935080812902279"] = {
            key = "17791935080812902279",
            type = "GoToNode",
            name = "前往",
            pos = {x = -600.6108374384238, y = 505.960591133005},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["177936697953111609029"] = {
            key = "177936697953111609029",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -607.7164325138459, y = 260.84884004884015},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040307",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177936698384611609190"] = {
            key = "177936698384611609190",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -250.18482331844348, y = 67.09884004884},
            propsData = {
              VarName = "First10040307",
              VarValue = 1
            }
          },
          ["177936698763011609288"] = {
            key = "177936698763011609288",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = -268.77965090465034, y = 509.12470211780555},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17651942414394184533"] = {
      isStoryNode = true,
      key = "17651942414394184533",
      type = "StoryNode",
      name = "前往站长办公室",
      pos = {x = 1371.7339425280604, y = 334.77113281716805},
      propsData = {
        QuestId = 10040308,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040308_01",
        QuestDeatil = "Description_10040307_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782474420538611749",
            startPort = "Success",
            endQuest = "17651942414394184537",
            endPort = "Success"
          },
          {
            startQuest = "17782474420538611749",
            startPort = "Fail",
            endQuest = "17788357603794343498",
            endPort = "In"
          },
          {
            startQuest = "17782474420538611749",
            startPort = "PassiveFail",
            endQuest = "17788357603794343498",
            endPort = "In"
          },
          {
            startQuest = "17788357603794343498",
            startPort = "Out",
            endQuest = "17651942414394184540",
            endPort = "Fail"
          },
          {
            startQuest = "17651942414394184534",
            startPort = "QuestStart",
            endQuest = "177936710215313059527",
            endPort = "In"
          },
          {
            startQuest = "177936710215313059527",
            startPort = "false",
            endQuest = "17791935619652903043",
            endPort = "In"
          },
          {
            startQuest = "17791935619652903043",
            startPort = "Out",
            endQuest = "177936710753413059696",
            endPort = "Input"
          },
          {
            startQuest = "177936710753413059696",
            startPort = "True",
            endQuest = "17782474420538611749",
            endPort = "In"
          },
          {
            startQuest = "177936710753413059696",
            startPort = "False",
            endQuest = "17788357603794343498",
            endPort = "In"
          },
          {
            startQuest = "177936710215313059527",
            startPort = "true",
            endQuest = "17782474420538611749",
            endPort = "In"
          },
          {
            startQuest = "177936710215313059527",
            startPort = "true",
            endQuest = "177936710503913059615",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651942414394184534"] = {
            key = "17651942414394184534",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 297.55555555555543, y = 361.33333333333337},
            propsData = {ModeType = 0}
          },
          ["17651942414394184537"] = {
            key = "17651942414394184537",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1534.4403927068724, y = 358.66619915848526},
            propsData = {ModeType = 0}
          },
          ["17651942414394184540"] = {
            key = "17651942414394184540",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1715.9193548387098, y = 582.8870967741935},
            propsData = {}
          },
          ["17782474420538611749"] = {
            key = "17782474420538611749",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1280, y = 370},
            propsData = {SpecialConfigId = 10040308, BlackScreenImmediately = true}
          },
          ["17788357603794343498"] = {
            key = "17788357603794343498",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1454, y = 592.2500000000001},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791935619652903043"] = {
            key = "17791935619652903043",
            type = "GoToNode",
            name = "前往",
            pos = {x = 593.9999999999999, y = 601.3333333333334},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480425,
              GuideType = "M",
              GuidePointName = "Mechanism_BaozhaStart_2530031"
            }
          },
          ["177936710215313059527"] = {
            key = "177936710215313059527",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 589.5404040404042, y = 356.0000000000001},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040308",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177936710503913059615"] = {
            key = "177936710503913059615",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 921.8181818181821, y = 193.77777777777774},
            propsData = {
              VarName = "First10040308",
              VarValue = 1
            }
          },
          ["177936710753413059696"] = {
            key = "177936710753413059696",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 935.3737373737376, y = 607.1111111111112},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17651943125064186086"] = {
      isStoryNode = true,
      key = "17651943125064186086",
      type = "StoryNode",
      name = "寻找史蒂芬",
      pos = {x = 1640.258410905752, y = 339.5679530034941},
      propsData = {
        QuestId = 10040309,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040309_01",
        QuestDeatil = "Description_10040308_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = true,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Shidifen_152480367",
        JumpId = 0,
        QuestUIId = 100405
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17785006461141764",
            startPort = "Out",
            endQuest = "17785008164492494",
            endPort = "In"
          },
          {
            startQuest = "17651943125064186087",
            startPort = "QuestStart",
            endQuest = "17785010093951462611",
            endPort = "In"
          },
          {
            startQuest = "17785010093951462611",
            startPort = "Out",
            endQuest = "17785006461141764",
            endPort = "In"
          },
          {
            startQuest = "17651943125064186087",
            startPort = "QuestStart",
            endQuest = "17793829867821781",
            endPort = "Input"
          },
          {
            startQuest = "17785008164492494",
            startPort = "Out",
            endQuest = "17793831669772484",
            endPort = "Input"
          },
          {
            startQuest = "17793831669772484",
            startPort = "Out",
            endQuest = "17651943125064186090",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17651943125064186087"] = {
            key = "17651943125064186087",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 236.2499999999999, y = 293.75},
            propsData = {ModeType = 0}
          },
          ["17651943125064186090"] = {
            key = "17651943125064186090",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1658.6487854251013, y = 312.1690283400809},
            propsData = {ModeType = 0}
          },
          ["17651943125064186093"] = {
            key = "17651943125064186093",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1666.326923076923, y = 468.8076923076923},
            propsData = {}
          },
          ["17785006461141764"] = {
            key = "17785006461141764",
            type = "GoToNode",
            name = "前往",
            pos = {x = 791.304347826087, y = 306.67911255411263},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2490001,
              GuideType = "N",
              GuidePointName = "Npc_Shidifen_152480367"
            }
          },
          ["17785008164492494"] = {
            key = "17785008164492494",
            type = "TalkNode",
            name = "史蒂芬对话",
            pos = {x = 1107.1043478260867, y = 310.42911255411263},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044401.10044401'",
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
          ["17785010093951462611"] = {
            key = "17785010093951462611",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 521.3043478260868, y = 301.6791125541125},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480367}
            }
          },
          ["17793829867821781"] = {
            key = "17793829867821781",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 522.3980876708433, y = 121.7185497680852},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true
            }
          },
          ["17793831669772484"] = {
            key = "17793831669772484",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1359.32116459392, y = 307.48778053731587},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17651943353314186745"] = {
      isStoryNode = true,
      key = "17651943353314186745",
      type = "StoryNode",
      name = "神弃者boss战",
      pos = {x = 1930.372279795483, y = 338.9465244320657},
      propsData = {
        QuestId = 10040310,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040310_01",
        QuestDeatil = "Description_10040309_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kanuo_152480368",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651943353314186746",
            startPort = "QuestStart",
            endQuest = "17785011775954382567",
            endPort = "In"
          },
          {
            startQuest = "17785011775954382567",
            startPort = "Out",
            endQuest = "17785011620334382160",
            endPort = "In"
          },
          {
            startQuest = "17785011620334382160",
            startPort = "Out",
            endQuest = "177824762766911476370",
            endPort = "In"
          },
          {
            startQuest = "177824762766911476370",
            startPort = "Success",
            endQuest = "17785016257094383918",
            endPort = "In"
          },
          {
            startQuest = "17785016257094383918",
            startPort = "Out",
            endQuest = "17651943353324186749",
            endPort = "Success"
          },
          {
            startQuest = "177824762766911476370",
            startPort = "Fail",
            endQuest = "17785016269944383977",
            endPort = "In"
          },
          {
            startQuest = "177824762766911476370",
            startPort = "PassiveFail",
            endQuest = "17785016269944383977",
            endPort = "In"
          },
          {
            startQuest = "17785016269944383977",
            startPort = "Out",
            endQuest = "17788358166185790176",
            endPort = "In"
          },
          {
            startQuest = "17788358166185790176",
            startPort = "Out",
            endQuest = "17651943353324186752",
            endPort = "Fail"
          },
          {
            startQuest = "17651943353314186746",
            startPort = "QuestStart",
            endQuest = "17793556454072901591",
            endPort = "In"
          }
        },
        nodeData = {
          ["17651943353314186746"] = {
            key = "17651943353314186746",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -66.08695652173915, y = 291.95652173913044},
            propsData = {ModeType = 0}
          },
          ["17651943353324186749"] = {
            key = "17651943353324186749",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1424.75, y = 272.75},
            propsData = {ModeType = 0}
          },
          ["17651943353324186752"] = {
            key = "17651943353324186752",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1684, y = 480.25},
            propsData = {}
          },
          ["177824762766911476370"] = {
            key = "177824762766911476370",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 878.0514705882351, y = 290.5},
            propsData = {SpecialConfigId = 10040310, BlackScreenImmediately = true}
          },
          ["17785011620334382160"] = {
            key = "17785011620334382160",
            type = "GoToNode",
            name = "前往",
            pos = {x = 530.8819659442725, y = 293.43075508755607},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2540002,
              GuideType = "M",
              GuidePointName = "Npc_Kanuo_152480368"
            }
          },
          ["17785011775954382567"] = {
            key = "17785011775954382567",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 227.13196594427257, y = 289.6807550875561},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480368, 152480413}
            }
          },
          ["17785016257094383918"] = {
            key = "17785016257094383918",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1140.8819659442727, y = 295.9307550875561},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                152480367,
                152480368,
                152480413
              }
            }
          },
          ["17785016269944383977"] = {
            key = "17785016269944383977",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1144.6319659442727, y = 459.68075508755624},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                152480367,
                152480368,
                152480413
              }
            }
          },
          ["17788358166185790176"] = {
            key = "17788358166185790176",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1411, y = 462.7647058823529},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_HajiluoBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17793556454072901591"] = {
            key = "17793556454072901591",
            type = "TalkNode",
            name = "史蒂芬可选对话",
            pos = {x = 223.92857142857144, y = 60.49999999999994},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100415,
              GuideUIEnable = false,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 100499503,
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
          }
        },
        commentData = {}
      }
    },
    ["17659611443691059773"] = {
      isStoryNode = true,
      key = "17659611443691059773",
      type = "StoryNode",
      name = "炸弹调查后对话",
      pos = {x = 2496.3434572667666, y = 117.30686424603996},
      propsData = {
        QuestId = 10040313,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040313_01",
        QuestDeatil = "Description_10040313_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Storeroom_2480211",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782456737057177605",
            startPort = "Success",
            endQuest = "17659611443691059777",
            endPort = "Success"
          },
          {
            startQuest = "17782456737057177605",
            startPort = "Fail",
            endQuest = "17788357166682896360",
            endPort = "In"
          },
          {
            startQuest = "17782456737057177605",
            startPort = "PassiveFail",
            endQuest = "17788357166682896360",
            endPort = "In"
          },
          {
            startQuest = "17788357166682896360",
            startPort = "Out",
            endQuest = "17659611443691059780",
            endPort = "Fail"
          },
          {
            startQuest = "17659611443691059774",
            startPort = "QuestStart",
            endQuest = "177936667064310158652",
            endPort = "In"
          },
          {
            startQuest = "177936667064310158652",
            startPort = "false",
            endQuest = "17791934466882900917",
            endPort = "In"
          },
          {
            startQuest = "17791934466882900917",
            startPort = "Out",
            endQuest = "177936667372810158720",
            endPort = "Input"
          },
          {
            startQuest = "177936667372810158720",
            startPort = "True",
            endQuest = "17782456737057177605",
            endPort = "In"
          },
          {
            startQuest = "177936667372810158720",
            startPort = "False",
            endQuest = "17788357166682896360",
            endPort = "In"
          },
          {
            startQuest = "177936667064310158652",
            startPort = "true",
            endQuest = "177936667226010158696",
            endPort = "In"
          },
          {
            startQuest = "177936667064310158652",
            startPort = "true",
            endQuest = "17782456737057177605",
            endPort = "In"
          }
        },
        nodeData = {
          ["17659611443691059774"] = {
            key = "17659611443691059774",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 428.41379310344826, y = 282.7448275862069},
            propsData = {ModeType = 0}
          },
          ["17659611443691059777"] = {
            key = "17659611443691059777",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1686.4000000000005, y = 267.6},
            propsData = {ModeType = 0}
          },
          ["17659611443691059780"] = {
            key = "17659611443691059780",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1894, y = 524},
            propsData = {}
          },
          ["17782456737057177605"] = {
            key = "17782456737057177605",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1340, y = 272},
            propsData = {SpecialConfigId = 10040313, BlackScreenImmediately = true}
          },
          ["17788357166682896360"] = {
            key = "17788357166682896360",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1612, y = 510},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17791934466882900917"] = {
            key = "17791934466882900917",
            type = "GoToNode",
            name = "前往",
            pos = {x = 752.7586206896552, y = 577.1724137931035},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2480211,
              GuideType = "M",
              GuidePointName = "Mechanism_Storeroom_2480211"
            }
          },
          ["177936667064310158652"] = {
            key = "177936667064310158652",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 760.5267204060311, y = 281.2132594417077},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040313",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177936667226010158696"] = {
            key = "177936667226010158696",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1068.3053311006838, y = 116.32570321981848},
            propsData = {
              VarName = "First10040313",
              VarValue = 1
            }
          },
          ["177936667372810158720"] = {
            key = "177936667372810158720",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1071.5324675324678, y = 597.7649835796386},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17676902270196179692"] = {
      isStoryNode = true,
      key = "17676902270196179692",
      type = "StoryNode",
      name = "回到站长办公室",
      pos = {x = 2215.415434715143, y = 340.8142576866928},
      propsData = {
        QuestId = 10040311,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040311_01",
        QuestDeatil = "Description_10040311_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Aisenbaen_152480366",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17785036227651282",
            startPort = "Out",
            endQuest = "177824780535412908664",
            endPort = "In"
          },
          {
            startQuest = "17676902270196179693",
            startPort = "QuestStart",
            endQuest = "17787439999524375917",
            endPort = "In"
          },
          {
            startQuest = "17787439999524375917",
            startPort = "Out",
            endQuest = "17785036227651282",
            endPort = "In"
          },
          {
            startQuest = "177824780535412908664",
            startPort = "Success",
            endQuest = "17787440295994376513",
            endPort = "In"
          },
          {
            startQuest = "17787440295994376513",
            startPort = "Out",
            endQuest = "17676902270196179696",
            endPort = "Success"
          },
          {
            startQuest = "177824780535412908664",
            startPort = "Fail",
            endQuest = "17787440300654376532",
            endPort = "In"
          },
          {
            startQuest = "177824780535412908664",
            startPort = "PassiveFail",
            endQuest = "17787440300654376532",
            endPort = "In"
          },
          {
            startQuest = "17787440300654376532",
            startPort = "Out",
            endQuest = "17788360647817237524",
            endPort = "In"
          },
          {
            startQuest = "17788360647817237524",
            startPort = "Out",
            endQuest = "17676902270196179699",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17676902270196179693"] = {
            key = "17676902270196179693",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 133.57142857142853, y = 312.5},
            propsData = {ModeType = 0}
          },
          ["17676902270196179696"] = {
            key = "17676902270196179696",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1601.48128342246, y = 293.06417112299465},
            propsData = {ModeType = 0}
          },
          ["17676902270196179699"] = {
            key = "17676902270196179699",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1833, y = 452.2941176470589},
            propsData = {}
          },
          ["177824780535412908664"] = {
            key = "177824780535412908664",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1064.8914197257852, y = 310.5817116320212},
            propsData = {SpecialConfigId = 10040311, BlackScreenImmediately = true}
          },
          ["17785036227651282"] = {
            key = "17785036227651282",
            type = "GoToNode",
            name = "前往",
            pos = {x = 734.125, y = 319.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480420,
              GuideType = "N",
              GuidePointName = "Npc_Aisenbaen_152480366"
            }
          },
          ["17787439999524375917"] = {
            key = "17787439999524375917",
            type = "ChangeStaticCreatorNode",
            name = "生成艾森巴恩和士兵",
            pos = {x = 432, y = 317},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480418, 152480419}
            }
          },
          ["17787440295994376513"] = {
            key = "17787440295994376513",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1334, y = 291},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480418, 152480419}
            }
          },
          ["17787440300654376532"] = {
            key = "17787440300654376532",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1330, y = 432},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480418, 152480419}
            }
          },
          ["17788360647817237524"] = {
            key = "17788360647817237524",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1600, y = 452.7647058823529},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Baozhaxianchang",
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
    ["17676903666966180869"] = {
      isStoryNode = true,
      key = "17676903666966180869",
      type = "StoryNode",
      name = "回复芙罗拉",
      pos = {x = 2487.115547102755, y = 343.8526699323418},
      propsData = {
        QuestId = 10040312,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040312_01",
        QuestDeatil = "Description_10040312_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = true,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_ClosetoTrain_152480278",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177824785569714340143",
            startPort = "Success",
            endQuest = "17676903666966180873",
            endPort = "Success"
          },
          {
            startQuest = "177824785569714340143",
            startPort = "Fail",
            endQuest = "17676903666966180876",
            endPort = "Fail"
          },
          {
            startQuest = "177824785569714340143",
            startPort = "PassiveFail",
            endQuest = "17676903666966180876",
            endPort = "Fail"
          },
          {
            startQuest = "17676903666966180870",
            startPort = "QuestStart",
            endQuest = "17796089195543925",
            endPort = "In"
          },
          {
            startQuest = "17796089195543925",
            startPort = "Out",
            endQuest = "177824785569714340143",
            endPort = "In"
          },
          {
            startQuest = "17676903666966180870",
            startPort = "QuestStart",
            endQuest = "17796089540384458",
            endPort = "In"
          }
        },
        nodeData = {
          ["17676903666966180870"] = {
            key = "17676903666966180870",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 224.86111111111123, y = 300.41666666666674},
            propsData = {ModeType = 0}
          },
          ["17676903666966180873"] = {
            key = "17676903666966180873",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1365.5405594405593, y = 284.3496503496504},
            propsData = {ModeType = 0}
          },
          ["17676903666966180876"] = {
            key = "17676903666966180876",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1358.5, y = 443.03846153846155},
            propsData = {}
          },
          ["177824785569714340143"] = {
            key = "177824785569714340143",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 991.9910031488977, y = 294.18263607737293},
            propsData = {SpecialConfigId = 10040312, BlackScreenImmediately = true}
          },
          ["17796089195543925"] = {
            key = "17796089195543925",
            type = "GoToNode",
            name = "靠近列车",
            pos = {x = 552.1132375507376, y = 294.6102716727713},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480278,
              GuideType = "M",
              GuidePointName = "Mechanism_ClosetoTrain_152480278"
            }
          },
          ["17796089540384458"] = {
            key = "17796089540384458",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 552.1132375507377, y = 112.38804945054925},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {
                "Story_YT",
                "Story_BHCZ",
                "Story_YT_GBZ"
              }
            }
          }
        },
        commentData = {}
      }
    },
    ["17791781854791450189"] = {
      isStoryNode = true,
      key = "17791781854791450189",
      type = "StoryNode",
      name = "仓库调查后对话",
      pos = {x = 2074.9118486260904, y = -111.9847101256155},
      propsData = {
        QuestId = 10040304,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040305_01",
        QuestDeatil = "Description_10040305_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17791781854791450190",
            startPort = "QuestStart",
            endQuest = "17791782148921450765",
            endPort = "In"
          },
          {
            startQuest = "17791782148921450765",
            startPort = "Out",
            endQuest = "17791781854791450193",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17791781854791450190"] = {
            key = "17791781854791450190",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17791781854791450193"] = {
            key = "17791781854791450193",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1369.473684210526, y = 312.63157894736844},
            propsData = {ModeType = 0}
          },
          ["17791781854791450196"] = {
            key = "17791781854791450196",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1374.2105263157894, y = 477.3684210526316},
            propsData = {}
          },
          ["17791782148921450765"] = {
            key = "17791782148921450765",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1079.7894736842104, y = 310.3157894736842},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043501.10043501'",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
