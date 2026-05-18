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
      startStory = "17651936355533135760",
      startPort = "Success",
      endStory = "17651937148873137426",
      endPort = "In"
    },
    {
      startStory = "17651937148873137426",
      startPort = "Success",
      endStory = "17659611443691059773",
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
      pos = {x = 1121.9325396825398, y = 91.03147235905855},
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
            startQuest = "17782405204331442123",
            startPort = "Success",
            endQuest = "176493310455119746682",
            endPort = "Success"
          },
          {
            startQuest = "176493310455119746679",
            startPort = "QuestStart",
            endQuest = "17788269792731708",
            endPort = "In"
          },
          {
            startQuest = "17788269792731708",
            startPort = "Out",
            endQuest = "17782405204331442123",
            endPort = "In"
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
          }
        },
        nodeData = {
          ["176493310455119746679"] = {
            key = "176493310455119746679",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1069.5270942241489, y = 108.5673052403416},
            propsData = {ModeType = 0}
          },
          ["176493310455119746682"] = {
            key = "176493310455119746682",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2387.9974262883716, y = 90.31229436670216},
            propsData = {ModeType = 0}
          },
          ["176493310455119746685"] = {
            key = "176493310455119746685",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2362.738970588235, y = 311.26838235294116},
            propsData = {}
          },
          ["17782405204331442123"] = {
            key = "17782405204331442123",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1637.329706477733, y = 107.42587761209052},
            propsData = {SpecialConfigId = 10040301, BlackScreenImmediately = false}
          },
          ["17788269792731708"] = {
            key = "17788269792731708",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家到芙罗拉专列外",
            pos = {x = 1373.2844827586207, y = 119.34722222222226},
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
            pos = {x = 2061.0969827586205, y = 297.47222222222223},
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
    ["1765179541460672"] = {
      isStoryNode = true,
      key = "1765179541460672",
      type = "StoryNode",
      name = "调查爆炸现场",
      pos = {x = 1365.2777777777778, y = 101.76811594202894},
      propsData = {
        QuestId = 10040302,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040302_01",
        QuestDeatil = "Description_10040301_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1765179541460673",
            startPort = "QuestStart",
            endQuest = "17782440946712873118",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["1765179541460673"] = {
            key = "1765179541460673",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -677.9717948717949, y = 298.5444444444445},
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
            pos = {x = 329.00000000000045, y = 497},
            propsData = {}
          },
          ["17782440946712873118"] = {
            key = "17782440946712873118",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -268.43654810102134, y = 297.90109890109886},
            propsData = {SpecialConfigId = 10040302, BlackScreenImmediately = false}
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651852542782090210",
            startPort = "QuestStart",
            endQuest = "17782442738252874017",
            endPort = "In"
          },
          {
            startQuest = "17782442738252874017",
            startPort = "Success",
            endQuest = "17785970386233693",
            endPort = "In"
          },
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
            startQuest = "17785970594444227",
            startPort = "Out",
            endQuest = "17651852542782090213",
            endPort = "Success"
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
          }
        },
        nodeData = {
          ["17651852542782090210"] = {
            key = "17651852542782090210",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 658.730769230769, y = 368.0659340659341},
            propsData = {ModeType = 0}
          },
          ["17651852542782090213"] = {
            key = "17651852542782090213",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2351.633645765998, y = 404.3931803490626},
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
            propsData = {SpecialConfigId = 10040303, BlackScreenImmediately = false}
          },
          ["17785970386233693"] = {
            key = "17785970386233693",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1395.8757576917408, y = 389.46864899806064},
            propsData = {
              VarName = "Chapter03_10040305_01",
              VarValue = 0
            }
          },
          ["17785970581394173"] = {
            key = "17785970581394173",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1704.1522301228185, y = 384.7756948933418},
            propsData = {
              VarName = "Chapter03_10040305_02",
              VarValue = 0
            }
          },
          ["17785970594444227"] = {
            key = "17785970594444227",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1996.235294117647, y = 390.3316095669036},
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
          }
        },
        commentData = {
          ["17785971918976040"] = {
            key = "17785971918976040",
            name = "把下一环任务要用的变量先设置一下",
            position = {x = 1348.9502262443439, y = 300.787330316742},
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651936355533135761",
            startPort = "QuestStart",
            endQuest = "17782445164254309471",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17651936355533135761"] = {
            key = "17651936355533135761",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -886.9048845890951, y = 244.15125926704877},
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
            propsData = {SpecialConfigId = 10040305, BlackScreenImmediately = false}
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
        QuestDeatil = "Description_10040306_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651937148873137427",
            startPort = "QuestStart",
            endQuest = "17782450403765743626",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17651937148873137427"] = {
            key = "17651937148873137427",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 292.4410984552972, y = 375.27321776120755},
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
            propsData = {SpecialConfigId = 10040306, BlackScreenImmediately = false}
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
      pos = {x = 1118.6680084621266, y = 332.0735803696156},
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651938690864181651",
            startPort = "QuestStart",
            endQuest = "17782473686697178911",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17651938690864181651"] = {
            key = "17651938690864181651",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -134.09090909090912, y = 255.11363636363632},
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
            pos = {x = 194, y = 260},
            propsData = {SpecialConfigId = 10040307, BlackScreenImmediately = false}
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
      pos = {x = 1372.5910853852033, y = 334.77113281716805},
      propsData = {
        QuestId = 10040308,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040308_01",
        QuestDeatil = "Description_10040308_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17651942414394184534",
            startPort = "QuestStart",
            endQuest = "17782474420538611749",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17651942414394184534"] = {
            key = "17651942414394184534",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1012, y = 358},
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
            propsData = {SpecialConfigId = 10040308, BlackScreenImmediately = false}
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
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
            startQuest = "17785008164492494",
            startPort = "Out",
            endQuest = "17785010239641463082",
            endPort = "In"
          },
          {
            startQuest = "17785010239641463082",
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
            pos = {x = 1599.8026315789473, y = 319.09210526315786},
            propsData = {ModeType = 0}
          },
          ["17651943125064186093"] = {
            key = "17651943125064186093",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1613.25, y = 451.5},
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
              GuideType = "M",
              GuidePointName = "Npc_Shidifen_152480367"
            }
          },
          ["17785008164492494"] = {
            key = "17785008164492494",
            type = "TalkNode",
            name = "史蒂芬对话",
            pos = {x = 1096.3043478260868, y = 310.42911255411263},
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
          ["17785010239641463082"] = {
            key = "17785010239641463082",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1356.3043478260868, y = 319.1791125541125},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480367}
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
        QuestDeatil = "Description_10040310_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
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
            propsData = {SpecialConfigId = 10040310, BlackScreenImmediately = false}
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
              StaticCreatorIdList = {152480368, 152480367}
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
              StaticCreatorIdList = {152480367, 152480368}
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
              StaticCreatorIdList = {152480367, 152480368}
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17659611443691059774",
            startPort = "QuestStart",
            endQuest = "17782456737057177605",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17659611443691059774"] = {
            key = "17659611443691059774",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1082, y = 266.40000000000003},
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
            propsData = {SpecialConfigId = 10040313, BlackScreenImmediately = false}
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
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
            pos = {x = 1084.8914197257852, y = 306.8317116320212},
            propsData = {SpecialConfigId = 10040311, BlackScreenImmediately = false}
          },
          ["17785036227651282"] = {
            key = "17785036227651282",
            type = "GoToNode",
            name = "前往",
            pos = {x = 734.125, y = 319.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480274,
              GuideType = "M",
              GuidePointName = "Npc_Aisenbaen_152480366"
            }
          },
          ["17787439999524375917"] = {
            key = "17787439999524375917",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 432, y = 317},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480366}
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
              StaticCreatorIdList = {152480366}
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
              StaticCreatorIdList = {152480366}
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
      pos = {x = 2486.178047102755, y = 343.8526699323418},
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17676903666966180870",
            startPort = "QuestStart",
            endQuest = "177824785569714340143",
            endPort = "In"
          },
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
          }
        },
        nodeData = {
          ["17676903666966180870"] = {
            key = "17676903666966180870",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
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
            pos = {x = 1077.5465587044532, y = 296.40485829959516},
            propsData = {SpecialConfigId = 10040312, BlackScreenImmediately = false}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
