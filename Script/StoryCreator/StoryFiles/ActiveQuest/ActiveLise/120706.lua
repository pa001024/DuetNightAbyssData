return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178702139719313432601",
      startPort = "StoryStart",
      endStory = "178702140233613432821",
      endPort = "In"
    },
    {
      startStory = "178702140233613432821",
      startPort = "Success",
      endStory = "178702142046513433237",
      endPort = "In"
    },
    {
      startStory = "178702142046513433237",
      startPort = "Success",
      endStory = "178702139719313432604",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178702139719313432601"] = {
      isStoryNode = true,
      key = "178702139719313432601",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 120706},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178702139719313432604"] = {
      isStoryNode = true,
      key = "178702139719313432604",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1884, y = 288},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178702140233613432821"] = {
      isStoryNode = true,
      key = "178702140233613432821",
      type = "StoryNode",
      name = "剧院",
      pos = {x = 1170.3428571428572, y = 279.9428571428572},
      propsData = {
        QuestId = 12070601,
        QuestDescriptionComment = "剧院打探帕西法尔消息",
        QuestDescription = "Description_120706_1",
        QuestDeatil = "Content_120706_1",
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
        SubRegionId = 101901,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351970005",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "179024344043346406811",
            startPort = "Out",
            endQuest = "179024342745346406725",
            endPort = "In"
          },
          {
            startQuest = "179024342745346406725",
            startPort = "Out",
            endQuest = "178702140233713432828",
            endPort = "Fail"
          },
          {
            startQuest = "178702143900713433680",
            startPort = "Fail",
            endQuest = "179024344043346406811",
            endPort = "In"
          },
          {
            startQuest = "178702143900713433680",
            startPort = "PassiveFail",
            endQuest = "179024344043346406811",
            endPort = "In"
          },
          {
            startQuest = "178702140233613432822",
            startPort = "QuestStart",
            endQuest = "1787123943446535",
            endPort = "In"
          },
          {
            startQuest = "1787123943446535",
            startPort = "Out",
            endQuest = "178702143900713433680",
            endPort = "In"
          },
          {
            startQuest = "178702143900713433680",
            startPort = "Success",
            endQuest = "178702140233613432825",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178702140233613432822"] = {
            key = "178702140233613432822",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1069.9088630667577, y = 289.4201412622465},
            propsData = {ModeType = 0}
          },
          ["178702140233613432825"] = {
            key = "178702140233613432825",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1957.233975089238, y = 261.1132983975091},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["178702140233713432828"] = {
            key = "178702140233713432828",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1951.3436507936503, y = 732.7242424242426},
            propsData = {}
          },
          ["178702143900713433680"] = {
            key = "178702143900713433680",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务601",
            pos = {x = 1646.6956521739132, y = 273.6869565217391},
            propsData = {SpecialConfigId = 12070601, BlackScreenImmediately = true}
          },
          ["1787123943446535"] = {
            key = "1787123943446535",
            type = "GoToNode",
            name = "前往剧院门口",
            pos = {x = 1373.0857142857142, y = 285.1428571428572},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351970005,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351970005"
            }
          },
          ["179024342745346406725"] = {
            key = "179024342745346406725",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1951.75, y = 579.0454545454544},
            propsData = {}
          },
          ["179024344043346406811"] = {
            key = "179024344043346406811",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1952.2045454545455, y = 407.22727272727263},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_Theater1_1207",
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
    ["178702142046513433237"] = {
      isStoryNode = true,
      key = "178702142046513433237",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1526, y = 282},
      propsData = {
        QuestId = 12070602,
        QuestDescriptionComment = "城墙告别过去",
        QuestDescription = "Description_120706_2",
        QuestDeatil = "Content_120706_2",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        StoryGuidePointName = "Mechanism_QuestTrigger_351192106",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178702148645913435096",
            startPort = "Success",
            endQuest = "178702142046513433241",
            endPort = "Success"
          },
          {
            startQuest = "17901397705552007",
            startPort = "false",
            endQuest = "17901398345843722",
            endPort = "In"
          },
          {
            startQuest = "17901397705552007",
            startPort = "true",
            endQuest = "17871241741634937",
            endPort = "In"
          },
          {
            startQuest = "17901397705552007",
            startPort = "false",
            endQuest = "17885932191192293046",
            endPort = "In"
          },
          {
            startQuest = "17885932191192293046",
            startPort = "Out",
            endQuest = "178702148645913435096",
            endPort = "In"
          },
          {
            startQuest = "17871241741634937",
            startPort = "Out",
            endQuest = "178702148645913435096",
            endPort = "In"
          },
          {
            startQuest = "179024361104648126711",
            startPort = "Out",
            endQuest = "179024360435748126603",
            endPort = "In"
          },
          {
            startQuest = "179024360435748126603",
            startPort = "Out",
            endQuest = "178702142046513433244",
            endPort = "Fail"
          },
          {
            startQuest = "178702148645913435096",
            startPort = "Fail",
            endQuest = "179024361104648126711",
            endPort = "In"
          },
          {
            startQuest = "178702148645913435096",
            startPort = "PassiveFail",
            endQuest = "179024361104648126711",
            endPort = "In"
          },
          {
            startQuest = "178702142046513433238",
            startPort = "QuestStart",
            endQuest = "17901397705552007",
            endPort = "In"
          }
        },
        nodeData = {
          ["178702142046513433238"] = {
            key = "178702142046513433238",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 398.56115473731654, y = 297.5739114708381},
            propsData = {ModeType = 0}
          },
          ["178702142046513433241"] = {
            key = "178702142046513433241",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1719.5565982404694, y = 248.85395894428152},
            propsData = {ModeType = 0}
          },
          ["178702142046513433244"] = {
            key = "178702142046513433244",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1718.7049853372437, y = 726.3225806451613},
            propsData = {}
          },
          ["178702148645913435096"] = {
            key = "178702148645913435096",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务602",
            pos = {x = 1405.2090399213566, y = 263.2757969382887},
            propsData = {SpecialConfigId = 12070602, BlackScreenImmediately = true}
          },
          ["17871241741634937"] = {
            key = "17871241741634937",
            type = "GoToNode",
            name = "前往冰湖城大街上",
            pos = {x = 1066.299853178639, y = 131.99240357343808},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192106,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192106"
            }
          },
          ["17885932191192293046"] = {
            key = "17885932191192293046",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1064.4962196723818, y = 300.95949810642446},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_StreetEnd_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17901397705552007"] = {
            key = "17901397705552007",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 707.6125573576848, y = 281.0430390865173},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "98"}
              }
            }
          },
          ["17901398345843722"] = {
            key = "17901398345843722",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1062.61387879154, y = 476.81529606492126},
            propsData = {VarName = "1.7_Lise01", VarValue = 98}
          },
          ["179024360435748126603"] = {
            key = "179024360435748126603",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1719.532258064516, y = 565.8225806451613},
            propsData = {}
          },
          ["179024361104648126711"] = {
            key = "179024361104648126711",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1722.032258064516, y = 390.3225806451613},
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
