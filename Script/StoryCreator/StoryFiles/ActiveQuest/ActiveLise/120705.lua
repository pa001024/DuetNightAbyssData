return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178702119385311750787",
      startPort = "StoryStart",
      endStory = "178702120323611751087",
      endPort = "In"
    },
    {
      startStory = "178702120323611751087",
      startPort = "Success",
      endStory = "178702123556511751572",
      endPort = "In"
    },
    {
      startStory = "178702123556511751572",
      startPort = "Success",
      endStory = "178702125679111751878",
      endPort = "In"
    },
    {
      startStory = "178702125679111751878",
      startPort = "Success",
      endStory = "178702119385311750790",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178702119385311750787"] = {
      isStoryNode = true,
      key = "178702119385311750787",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 120705},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178702119385311750790"] = {
      isStoryNode = true,
      key = "178702119385311750790",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2148, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178702120323611751087"] = {
      isStoryNode = true,
      key = "178702120323611751087",
      type = "StoryNode",
      name = "剧院",
      pos = {x = 1147.304347826087, y = 288},
      propsData = {
        QuestId = 12070501,
        QuestDescriptionComment = "去剧院与蕾伊对峙",
        QuestDescription = "Description_120705_1",
        QuestDeatil = "Content_120705_1",
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
        SubRegionId = 101901,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351970001",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178712368094512236",
            startPort = "Out",
            endQuest = "178702127776711752246",
            endPort = "In"
          },
          {
            startQuest = "178702120323711751088",
            startPort = "QuestStart",
            endQuest = "178712368094512236",
            endPort = "In"
          },
          {
            startQuest = "178702127776711752246",
            startPort = "Success",
            endQuest = "178702120323711751091",
            endPort = "Success"
          },
          {
            startQuest = "178702127776711752246",
            startPort = "Fail",
            endQuest = "179024159247039531156",
            endPort = "In"
          },
          {
            startQuest = "178702127776711752246",
            startPort = "PassiveFail",
            endQuest = "179024159247039531156",
            endPort = "In"
          },
          {
            startQuest = "179024159247039531156",
            startPort = "Out",
            endQuest = "179024158845439531095",
            endPort = "In"
          },
          {
            startQuest = "179024158845439531095",
            startPort = "Out",
            endQuest = "178702120323711751094",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178702120323711751088"] = {
            key = "178702120323711751088",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1017.5389610389611, y = 256.4155844155845},
            propsData = {ModeType = 0}
          },
          ["178702120323711751091"] = {
            key = "178702120323711751091",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1957.6103896103898, y = 241.48701298701303},
            propsData = {ModeType = 0}
          },
          ["178702120323711751094"] = {
            key = "178702120323711751094",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1948.6168831168836, y = 684.7467532467532},
            propsData = {}
          },
          ["178702127776711752246"] = {
            key = "178702127776711752246",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务501",
            pos = {x = 1621.552795031056, y = 253.51552795031054},
            propsData = {SpecialConfigId = 12070501, BlackScreenImmediately = true}
          },
          ["178712368094512236"] = {
            key = "178712368094512236",
            type = "GoToNode",
            name = "前往剧院门口",
            pos = {x = 1330.883116883117, y = 262.57142857142856},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351970001,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351970001"
            }
          },
          ["179024158845439531095"] = {
            key = "179024158845439531095",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1950.4545454545455, y = 549.7272727272727},
            propsData = {}
          },
          ["179024159247039531156"] = {
            key = "179024159247039531156",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1952.2727272727273, y = 380.6363636363638},
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
    ["178702123556511751572"] = {
      isStoryNode = true,
      key = "178702123556511751572",
      type = "StoryNode",
      name = "下水道舞台",
      pos = {x = 1494, y = 286},
      propsData = {
        QuestId = 12070502,
        QuestDescriptionComment = "下水道舞台告知蕾伊真相",
        QuestDescription = "Description_120705_2",
        QuestDeatil = "Content_120705_2",
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
        SubRegionId = 101703,
        SubRegionIdList = {101701, 101702},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_351740138",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17871234154326559",
            startPort = "Out",
            endQuest = "178702131222911753223",
            endPort = "In"
          },
          {
            startQuest = "178702131222911753223",
            startPort = "Success",
            endQuest = "178702123556511751576",
            endPort = "Success"
          },
          {
            startQuest = "178702123556511751573",
            startPort = "QuestStart",
            endQuest = "179015719321412660",
            endPort = "In"
          },
          {
            startQuest = "179024226031841249358",
            startPort = "false",
            endQuest = "179024226031841249359",
            endPort = "In"
          },
          {
            startQuest = "178702123556511751573",
            startPort = "QuestStart",
            endQuest = "179024226031841249358",
            endPort = "In"
          },
          {
            startQuest = "179024226031841249358",
            startPort = "true",
            endQuest = "17871234154326559",
            endPort = "In"
          },
          {
            startQuest = "179024226031841249358",
            startPort = "false",
            endQuest = "179024236610041250979",
            endPort = "In"
          },
          {
            startQuest = "179024246636841252103",
            startPort = "Out",
            endQuest = "178702123556611751579",
            endPort = "Fail"
          },
          {
            startQuest = "178702131222911753223",
            startPort = "Fail",
            endQuest = "179024247756041252342",
            endPort = "In"
          },
          {
            startQuest = "178702131222911753223",
            startPort = "PassiveFail",
            endQuest = "179024247756041252342",
            endPort = "In"
          },
          {
            startQuest = "179024247756041252342",
            startPort = "Out",
            endQuest = "179024246636841252103",
            endPort = "In"
          },
          {
            startQuest = "179024236610041250979",
            startPort = "Out",
            endQuest = "178702131222911753223",
            endPort = "In"
          }
        },
        nodeData = {
          ["178702123556511751573"] = {
            key = "178702123556511751573",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 657.8753246753246, y = 265.70909090909095},
            propsData = {ModeType = 0}
          },
          ["178702123556511751576"] = {
            key = "178702123556511751576",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1931.422077922078, y = 246.44805194805187},
            propsData = {ModeType = 0}
          },
          ["178702123556611751579"] = {
            key = "178702123556611751579",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1926.5811688311687, y = 702.8668831168831},
            propsData = {}
          },
          ["178702131222911753223"] = {
            key = "178702131222911753223",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务502",
            pos = {x = 1610.5885093167701, y = 258.8369565217391},
            propsData = {SpecialConfigId = 12070502, BlackScreenImmediately = true}
          },
          ["17871234154326559"] = {
            key = "17871234154326559",
            type = "GoToNode",
            name = "前往下水道舞台起点",
            pos = {x = 1297.2951298701298, y = 95.42272727272716},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351740138,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351740138"
            }
          },
          ["179015719321412660"] = {
            key = "179015719321412660",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 986.3982017982019, y = 96.60419580419585},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "SPLiseOpenSewDoor",
              UnitId = -1
            }
          },
          ["179024226031841249358"] = {
            key = "179024226031841249358",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 981.7156430759514, y = 256.7035020612863},
            propsData = {
              FunctionName = "Equal",
              VarName = "1.7_Lise01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "85"}
              }
            }
          },
          ["179024226031841249359"] = {
            key = "179024226031841249359",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1298.1570841967757, y = 434.15104339325933},
            propsData = {VarName = "1.7_Lise01", VarValue = 85}
          },
          ["179024236610041250979"] = {
            key = "179024236610041250979",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1296.3636363636363, y = 269.6363636363637},
            propsData = {
              RegionType = 2,
              IsEnter = "Enter",
              RegionId = 1017,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["179024246636841252103"] = {
            key = "179024246636841252103",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1930.0000000000002, y = 556.5454545454546},
            propsData = {}
          },
          ["179024247756041252342"] = {
            key = "179024247756041252342",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1931.8181818181822, y = 387.4545454545456},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_SewThief0",
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
    ["178702125679111751878"] = {
      isStoryNode = true,
      key = "178702125679111751878",
      type = "StoryNode",
      name = "冰湖城",
      pos = {x = 1808, y = 284},
      propsData = {
        QuestId = 12070503,
        QuestDescriptionComment = "送蕾伊回冰湖城的家",
        QuestDescription = "Description_120705_3",
        QuestDeatil = "Content_120705_3",
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
        StoryGuidePointName = "Mechanism_QuestTrigger_351192103",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178712385371214953",
            startPort = "Out",
            endQuest = "178702133388211753837",
            endPort = "In"
          },
          {
            startQuest = "178702125679111751879",
            startPort = "QuestStart",
            endQuest = "178712385371214953",
            endPort = "In"
          },
          {
            startQuest = "178702133388211753837",
            startPort = "Success",
            endQuest = "178702125679211751882",
            endPort = "Success"
          },
          {
            startQuest = "178702133388211753837",
            startPort = "Fail",
            endQuest = "179024256928142970276",
            endPort = "In"
          },
          {
            startQuest = "178702133388211753837",
            startPort = "PassiveFail",
            endQuest = "179024256928142970276",
            endPort = "In"
          },
          {
            startQuest = "179024256928142970276",
            startPort = "Out",
            endQuest = "179024255749042970111",
            endPort = "In"
          },
          {
            startQuest = "179024255749042970111",
            startPort = "Out",
            endQuest = "178702125679211751885",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["178702125679111751879"] = {
            key = "178702125679111751879",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 902.5974025974026, y = 293.2467532467533},
            propsData = {ModeType = 0}
          },
          ["178702125679211751882"] = {
            key = "178702125679211751882",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1759.8504784688996, y = 258.79186602870834},
            propsData = {ModeType = 0}
          },
          ["178702125679211751885"] = {
            key = "178702125679211751885",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1759.1396103896104, y = 707.9805194805194},
            propsData = {}
          },
          ["178702133388211753837"] = {
            key = "178702133388211753837",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "特殊任务503",
            pos = {x = 1457.695652173913, y = 272.4505928853755},
            propsData = {SpecialConfigId = 12070503, BlackScreenImmediately = true}
          },
          ["178712385371214953"] = {
            key = "178712385371214953",
            type = "GoToNode",
            name = "前往蕾伊家附近",
            pos = {x = 1179.318181818182, y = 281.9275461380724},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 351192103,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_351192103"
            }
          },
          ["179024255749042970111"] = {
            key = "179024255749042970111",
            type = "RestoreRoleNode",
            name = "恢复角色",
            pos = {x = 1757.8685064935069, y = 569.25487012987},
            propsData = {}
          },
          ["179024256928142970276"] = {
            key = "179024256928142970276",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1760.3685064935069, y = 402.11201298701286},
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
