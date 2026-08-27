return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104521328735",
      startPort = "StoryStart",
      endStory = "17697590104521328737",
      endPort = "In"
    },
    {
      startStory = "17697590104521328737",
      startPort = "Success",
      endStory = "17697590104521328736",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17697590104521328735"] = {
      isStoryNode = true,
      key = "17697590104521328735",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 814, y = 322},
      propsData = {QuestChainId = 110212},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328736"] = {
      isStoryNode = true,
      key = "17697590104521328736",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1948.8717881419434, y = 342.10256378070164},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104521328737"] = {
      isStoryNode = true,
      key = "17697590104521328737",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1221.612903205959, y = 320},
      propsData = {
        QuestId = 11021201,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110212_1",
        QuestDeatil = "Content_110212_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign1102120101",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17828772101451617486",
            startPort = "Out",
            endQuest = "178290436045919413427",
            endPort = "In"
          },
          {
            startQuest = "17828910071323236605",
            startPort = "Out",
            endQuest = "17829096435892175",
            endPort = "Input_1"
          },
          {
            startQuest = "17829096091031447",
            startPort = "Out",
            endQuest = "17829096435892175",
            endPort = "Input_2"
          },
          {
            startQuest = "17829096187091662",
            startPort = "Out",
            endQuest = "17829096435892175",
            endPort = "Input_3"
          },
          {
            startQuest = "17829096284291786",
            startPort = "Out",
            endQuest = "17829096435892175",
            endPort = "Input_4"
          },
          {
            startQuest = "17697590104521328738",
            startPort = "QuestStart",
            endQuest = "17829096284291786",
            endPort = "In"
          },
          {
            startQuest = "17697590104521328738",
            startPort = "QuestStart",
            endQuest = "17829096187091662",
            endPort = "In"
          },
          {
            startQuest = "17697590104521328738",
            startPort = "QuestStart",
            endQuest = "17829096091031447",
            endPort = "In"
          },
          {
            startQuest = "17697590104521328738",
            startPort = "QuestStart",
            endQuest = "17828910071323236605",
            endPort = "In"
          },
          {
            startQuest = "178290436045919413427",
            startPort = "Success",
            endQuest = "17864388152911119533",
            endPort = "Input"
          },
          {
            startQuest = "17829220409438092495",
            startPort = "Out",
            endQuest = "17864516934532117",
            endPort = "In"
          },
          {
            startQuest = "17829220409438092495",
            startPort = "Out",
            endQuest = "17829220890758093151",
            endPort = "In"
          },
          {
            startQuest = "178290436045919413427",
            startPort = "Fail",
            endQuest = "17864633548815027224",
            endPort = "In"
          },
          {
            startQuest = "178290436045919413427",
            startPort = "PassiveFail",
            endQuest = "17864633548815027224",
            endPort = "In"
          },
          {
            startQuest = "17864633548815027224",
            startPort = "Out",
            endQuest = "17864388304271119883",
            endPort = "Input"
          },
          {
            startQuest = "17829096435892175",
            startPort = "Out",
            endQuest = "17829220409438092495",
            endPort = "In"
          },
          {
            startQuest = "17829096435892175",
            startPort = "Out",
            endQuest = "178713061208131285290",
            endPort = "In"
          },
          {
            startQuest = "178713061208131285290",
            startPort = "Out",
            endQuest = "17828772101451617486",
            endPort = "In"
          },
          {
            startQuest = "17864388304271119883",
            startPort = "Out",
            endQuest = "178714054558934635341",
            endPort = "In"
          },
          {
            startQuest = "178714054558934635341",
            startPort = "Out",
            endQuest = "17697590104521328740",
            endPort = "Fail"
          },
          {
            startQuest = "17864388152911119533",
            startPort = "Out",
            endQuest = "178714055146534635540",
            endPort = "In"
          },
          {
            startQuest = "178714055146534635540",
            startPort = "Out",
            endQuest = "17697590104521328739",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17697590104521328738"] = {
            key = "17697590104521328738",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -248.2488778560461, y = 185.14187882131458},
            propsData = {ModeType = 0}
          },
          ["17697590104521328739"] = {
            key = "17697590104521328739",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3163.1481413387737, y = 88.87328152830817},
            propsData = {ModeType = 0}
          },
          ["17697590104521328740"] = {
            key = "17697590104521328740",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3092.7939866574875, y = 520.7338682921526},
            propsData = {}
          },
          ["17828772101451617486"] = {
            key = "17828772101451617486",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1444.5545828679376, y = 190.7995924404866},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780322,
              GuideType = "P",
              GuidePointName = "QuestSign1102120101"
            }
          },
          ["17828867134431619258"] = {
            key = "17828867134431619258",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1121.3130192451265, y = -42.81546501766201},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerRun1Loop1",
              UnitId = -1
            }
          },
          ["17828910071323236605"] = {
            key = "17828910071323236605",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 210.67078192620752, y = -167.31441576938096},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerRun1Destroy",
              UnitId = -1
            }
          },
          ["178290436045919413427"] = {
            key = "178290436045919413427",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1871.7645135620658, y = 173.00181816764615},
            propsData = {SpecialConfigId = 11021201, BlackScreenImmediately = true}
          },
          ["17829096091031447"] = {
            key = "17829096091031447",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 248.42010495155452, y = 63.90473444320935},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerRun2Destroy",
              UnitId = -1
            }
          },
          ["17829096187091662"] = {
            key = "17829096187091662",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 237.95498895100516, y = 269.71868245401464},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerRun3MDestroy",
              UnitId = -1
            }
          },
          ["17829096284291786"] = {
            key = "17829096284291786",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 230.97824495063875, y = 461.25356113063185},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FuerRun3FDestroy",
              UnitId = -1
            }
          },
          ["17829096435892175"] = {
            key = "17829096435892175",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 648.9838736153431, y = 107.45653462189716},
            propsData = {ListenCount = 4, NeedFinishCount = 4}
          },
          ["17829220409438092495"] = {
            key = "17829220409438092495",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1031.255423832536, y = 570.9681460125086},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312780329,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["17829220890758093151"] = {
            key = "17829220890758093151",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1259.119777838107, y = 849.3231149382744},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11106901,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17864388152911119533"] = {
            key = "17864388152911119533",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2420.3448239877216, y = 61.44827802418428},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17864388304271119883"] = {
            key = "17864388304271119883",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2570.3448217953664, y = 525.2413760898513},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17864516934532117"] = {
            key = "17864516934532117",
            type = "CameraLookAtNode",
            name = "CameraLookAt",
            pos = {x = 1254.4444403628756, y = 625.999979089808},
            propsData = {
              TargetType = "Point",
              PointName = "Lookat1102120101",
              ActorId = 0,
              Duration = 5,
              EasingFunc = 4,
              bDisableUserInput = true
            }
          },
          ["17864633548815027224"] = {
            key = "17864633548815027224",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2256.9164087667027, y = 511.81612275717725},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["178713061208131285290"] = {
            key = "178713061208131285290",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1051.286707758888, y = 239.86316720084415},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780822}
            }
          },
          ["178714054558934635341"] = {
            key = "178714054558934635341",
            type = "SimplePostProcessNode",
            name = "开启关闭屏幕后处理",
            pos = {x = 2833.563833982275, y = 526.8753879046785},
            propsData = {
              bEnablePP = false,
              PPEnum = 3,
              PPWeight = 0.5
            }
          },
          ["178714055146534635540"] = {
            key = "178714055146534635540",
            type = "SimplePostProcessNode",
            name = "开启关闭屏幕后处理",
            pos = {x = 2759.425903597939, y = 97.56504684189456},
            propsData = {
              bEnablePP = false,
              PPEnum = 3,
              PPWeight = 0.5
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
