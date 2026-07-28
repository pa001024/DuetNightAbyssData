return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "174911599956110952945",
      startPort = "StoryStart",
      endStory = "17776326329055275",
      endPort = "In"
    },
    {
      startStory = "17776326336695352",
      startPort = "Success",
      endStory = "177763795417816773243",
      endPort = "In"
    },
    {
      startStory = "177763795417816773243",
      startPort = "Success",
      endStory = "17776326344265420",
      endPort = "In"
    },
    {
      startStory = "17776326344265420",
      startPort = "Success",
      endStory = "177763795518616773311",
      endPort = "In"
    },
    {
      startStory = "177763795518616773311",
      startPort = "Success",
      endStory = "174911599956110952948",
      endPort = "StoryEnd"
    },
    {
      startStory = "17776326329055275",
      startPort = "Success",
      endStory = "177763815767418173755",
      endPort = "In"
    },
    {
      startStory = "177763815767418173755",
      startPort = "Success",
      endStory = "17776326340725394",
      endPort = "In"
    },
    {
      startStory = "177763838346820967006",
      startPort = "Success",
      endStory = "17776326336695352",
      endPort = "In"
    },
    {
      startStory = "17776326340725394",
      startPort = "Success",
      endStory = "17778012387711868763",
      endPort = "In"
    },
    {
      startStory = "17784740583465828089",
      startPort = "Success",
      endStory = "177763838346820967006",
      endPort = "In"
    },
    {
      startStory = "17776326338835375",
      startPort = "Success",
      endStory = "17784740583465828089",
      endPort = "In"
    },
    {
      startStory = "17778012387711868763",
      startPort = "Success",
      endStory = "1778586529923979350",
      endPort = "In"
    },
    {
      startStory = "1778586529923979350",
      startPort = "Success",
      endStory = "17776326338835375",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["174911599956110952945"] = {
      isStoryNode = true,
      key = "174911599956110952945",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = -864.1271416669432, y = 1285.60889162157},
      propsData = {QuestChainId = 100402},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["174911599956110952948"] = {
      isStoryNode = true,
      key = "174911599956110952948",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2341.138569232998, y = 1345.4409105730776},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17776326329055275"] = {
      isStoryNode = true,
      key = "17776326329055275",
      type = "StoryNode",
      name = "攀爬流程",
      pos = {x = -486.6642017851129, y = 1274.999410766691},
      propsData = {
        QuestId = 10040201,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040201_01",
        QuestDeatil = "Description_10040201_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_DixiaQianruEleEnd_272480208",
        JumpId = 0,
        IsBacktrack = false,
        QuestUIId = 100402
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17776335608241402332",
            startPort = "Success",
            endQuest = "17776326329055279",
            endPort = "Success"
          },
          {
            startQuest = "17776351960804195940",
            startPort = "true",
            endQuest = "17776351960804195941",
            endPort = "In"
          },
          {
            startQuest = "17776351960804195941",
            startPort = "Out",
            endQuest = "17776335608241402332",
            endPort = "In"
          },
          {
            startQuest = "177815772155858676368",
            startPort = "Out",
            endQuest = "177815772155858676369",
            endPort = "Input"
          },
          {
            startQuest = "177815772155858676369",
            startPort = "False",
            endQuest = "177815772155858676370",
            endPort = "In"
          },
          {
            startQuest = "17776351960804195940",
            startPort = "false",
            endQuest = "177815772155858676368",
            endPort = "In"
          },
          {
            startQuest = "177815772155858676370",
            startPort = "Out",
            endQuest = "17776326329055282",
            endPort = "Fail"
          },
          {
            startQuest = "177815772155858676369",
            startPort = "True",
            endQuest = "177848614909321906823",
            endPort = "In"
          },
          {
            startQuest = "177848614909321906823",
            startPort = "Out",
            endQuest = "17776335608241402332",
            endPort = "In"
          },
          {
            startQuest = "17787277856719123",
            startPort = "Out",
            endQuest = "17787277856719124",
            endPort = "In"
          },
          {
            startQuest = "17787277856719124",
            startPort = "Out",
            endQuest = "17787277856719125",
            endPort = "In"
          },
          {
            startQuest = "17787277856719122",
            startPort = "Out",
            endQuest = "17787277856719123",
            endPort = "In"
          },
          {
            startQuest = "17776335608241402332",
            startPort = "Fail",
            endQuest = "17787277856719122",
            endPort = "In"
          },
          {
            startQuest = "17776335608241402332",
            startPort = "PassiveFail",
            endQuest = "17787277856719122",
            endPort = "In"
          },
          {
            startQuest = "17787277856719125",
            startPort = "Out",
            endQuest = "177847433979010205179",
            endPort = "In"
          },
          {
            startQuest = "17797124105732838",
            startPort = "Out",
            endQuest = "17776351960804195940",
            endPort = "In"
          },
          {
            startQuest = "17776326329055276",
            startPort = "QuestStart",
            endQuest = "17797124105732838",
            endPort = "In"
          },
          {
            startQuest = "177847433979010205179",
            startPort = "Out",
            endQuest = "17776326329055282",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17776326329055276"] = {
            key = "17776326329055276",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -182.95295936668933, y = 319.3882491186839},
            propsData = {ModeType = 0}
          },
          ["17776326329055279"] = {
            key = "17776326329055279",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1876.2260765550238, y = 202.10526315789474},
            propsData = {ModeType = 0}
          },
          ["17776326329055282"] = {
            key = "17776326329055282",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2491.0706256109484, y = 722.0666340827631},
            propsData = {}
          },
          ["17776335608241402332"] = {
            key = "17776335608241402332",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1449.4482274482275, y = 345.18690768690766},
            propsData = {SpecialConfigId = 10040201, BlackScreenImmediately = true}
          },
          ["17776351960804195940"] = {
            key = "17776351960804195940",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 619.4630053023571, y = 321.81655085704676},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstPanpa100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17776351960804195941"] = {
            key = "17776351960804195941",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1029.746694993761, y = 327.40181613635133},
            propsData = {
              VarName = "FirstPanpa100402",
              VarValue = 1
            }
          },
          ["177815772155858676368"] = {
            key = "177815772155858676368",
            type = "GoToNode",
            name = "前往",
            pos = {x = 578.3134831555884, y = 713.6851661787946},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480208,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianruEleEnd_272480208"
            }
          },
          ["177815772155858676369"] = {
            key = "177815772155858676369",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 897.4261662211791, y = 732.3128371189654},
            propsData = {PopupId = 100110}
          },
          ["177815772155858676370"] = {
            key = "177815772155858676370",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1441.5760881426786, y = 765.0061677732945},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_DixiaQianruEleEnd",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177847433979010205179"] = {
            key = "177847433979010205179",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2061.230769230769, y = 619.6249999999999},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_DixiaQianruEleEnd",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177848614909321906823"] = {
            key = "177848614909321906823",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1224.137254901961, y = 542.8823529411766},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "DeleteFalltrigger",
              UnitId = -1
            }
          },
          ["17787277856719122"] = {
            key = "17787277856719122",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 1947.8760559851319, y = 417.1752320088678},
            propsData = {Duration = 2}
          },
          ["17787277856719123"] = {
            key = "17787277856719123",
            type = "SplineMoveStartNode",
            name = "开始沿Spline移动节点",
            pos = {x = 2226.1365150565985, y = 422.3696393879379},
            propsData = {
              SplineActorIndex = 1004020102,
              WalkType = 3,
              MoveSpeedRate = 1,
              IsTriggerable = false,
              UseEndOverlapBox = false,
              CanMoveReverse = false,
              StopAtEndPoint = true
            }
          },
          ["17787277856719124"] = {
            key = "17787277856719124",
            type = "SplineMoveEndNode",
            name = "结束沿Spline移动节点",
            pos = {x = 2526.125527502401, y = 423.1982435685641},
            propsData = {SplineActorIndex = 1004020101, ExitBlendTime = 0}
          },
          ["17787277856719125"] = {
            key = "17787277856719125",
            type = "SplineMoveEndNode",
            name = "结束沿Spline移动节点",
            pos = {x = 2827.349896430574, y = 404.05077117380927},
            propsData = {SplineActorIndex = 1004020102, ExitBlendTime = 0}
          },
          ["17797124105732838"] = {
            key = "17797124105732838",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 336.94736842105266, y = 334.608695652174},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0162_story_jazz_sneak_into.0162_story_jazz_sneak_into'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17776326336695352"] = {
      isStoryNode = true,
      key = "17776326336695352",
      type = "StoryNode",
      name = "管理室",
      pos = {x = 1245.188733092664, y = 1332.7912662105077},
      propsData = {
        QuestId = 10040204,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040207_01",
        QuestDeatil = "Description_10040207_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Guanlishi_2530014",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17776336046821403734",
            startPort = "Success",
            endQuest = "17776326336695358",
            endPort = "Success"
          },
          {
            startQuest = "17776356787334199352",
            startPort = "true",
            endQuest = "17776356787334199354",
            endPort = "In"
          },
          {
            startQuest = "17776326336695357",
            startPort = "QuestStart",
            endQuest = "17776356787334199352",
            endPort = "In"
          },
          {
            startQuest = "17776356787334199354",
            startPort = "Out",
            endQuest = "17776336046821403734",
            endPort = "In"
          },
          {
            startQuest = "17776336046821403734",
            startPort = "Fail",
            endQuest = "17776326336695359",
            endPort = "Fail"
          },
          {
            startQuest = "17776336046821403734",
            startPort = "PassiveFail",
            endQuest = "17776326336695359",
            endPort = "Fail"
          },
          {
            startQuest = "17776356787334199352",
            startPort = "false",
            endQuest = "177848708289724827847",
            endPort = "In"
          },
          {
            startQuest = "177848708289724827847",
            startPort = "Out",
            endQuest = "177848712287026287646",
            endPort = "Input"
          },
          {
            startQuest = "177848712287026287646",
            startPort = "True",
            endQuest = "17776336046821403734",
            endPort = "In"
          },
          {
            startQuest = "177848712287026287646",
            startPort = "False",
            endQuest = "177848731045926288010",
            endPort = "In"
          },
          {
            startQuest = "177848731045926288010",
            startPort = "Out",
            endQuest = "17776326336695359",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17776326336695357"] = {
            key = "17776326336695357",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 73.14285714285714, y = 186.28571428571428},
            propsData = {ModeType = 0}
          },
          ["17776326336695358"] = {
            key = "17776326336695358",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1548.7058823529412, y = 227.76470588235293},
            propsData = {ModeType = 0}
          },
          ["17776326336695359"] = {
            key = "17776326336695359",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500.289002557545, y = 419.2966751918159},
            propsData = {}
          },
          ["17776336046821403734"] = {
            key = "17776336046821403734",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1193.2307692307693, y = 206.76923076923077},
            propsData = {SpecialConfigId = 10040204, BlackScreenImmediately = true}
          },
          ["17776356787334199352"] = {
            key = "17776356787334199352",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 378.4592644399291, y = 191.84456867080868},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateGuanlishi100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17776356787334199354"] = {
            key = "17776356787334199354",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 720.5804282514156, y = 195.08356065818776},
            propsData = {
              VarName = "FirstStateGuanlishi100402",
              VarValue = 1
            }
          },
          ["177848708289724827847"] = {
            key = "177848708289724827847",
            type = "GoToNode",
            name = "进入管理室",
            pos = {x = 526.0289415009091, y = 533.0490817344364},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530014,
              GuideType = "M",
              GuidePointName = "Mechanism_Guanlishi_2530014"
            }
          },
          ["177848712287026287646"] = {
            key = "177848712287026287646",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 830.5161209880887, y = 550.741389426744},
            propsData = {PopupId = 100110}
          },
          ["177848731045926288010"] = {
            key = "177848731045926288010",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1141.6699671419349, y = 587.1516458370006},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "yt_fuwuyuan1",
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
    ["17776326338835375"] = {
      isStoryNode = true,
      key = "17776326338835375",
      type = "StoryNode",
      name = "混乱车站前",
      pos = {x = 566.3653655650222, y = 1317.5339787024568},
      propsData = {
        QuestId = 10040203,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040205_01",
        QuestDeatil = "Description_10040205_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = true,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = true,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_KaojinZhuanlie_2530011",
        JumpId = 0,
        IsBacktrack = false,
        QuestUIId = 100403
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17776335936101403325",
            startPort = "Success",
            endQuest = "17776326338845381",
            endPort = "Success"
          },
          {
            startQuest = "17776356652074198772",
            startPort = "true",
            endQuest = "17776356652074198774",
            endPort = "In"
          },
          {
            startQuest = "17776326338835380",
            startPort = "QuestStart",
            endQuest = "17776356652074198772",
            endPort = "In"
          },
          {
            startQuest = "17776356652074198774",
            startPort = "Out",
            endQuest = "17776335936101403325",
            endPort = "In"
          },
          {
            startQuest = "17776356652074198772",
            startPort = "false",
            endQuest = "17776370700389786624",
            endPort = "In"
          },
          {
            startQuest = "177821522146085278864",
            startPort = "Out",
            endQuest = "17776335936101403325",
            endPort = "In"
          },
          {
            startQuest = "17776335936101403325",
            startPort = "Fail",
            endQuest = "17784741923257286507",
            endPort = "In"
          },
          {
            startQuest = "17784741923257286507",
            startPort = "Out",
            endQuest = "17776326338845382",
            endPort = "Fail"
          },
          {
            startQuest = "17776370700389786624",
            startPort = "Out",
            endQuest = "177847736745017509648",
            endPort = "Input"
          },
          {
            startQuest = "177847736745017509648",
            startPort = "True",
            endQuest = "177821522146085278864",
            endPort = "In"
          },
          {
            startQuest = "177847736745017509648",
            startPort = "False",
            endQuest = "17784741923257286507",
            endPort = "In"
          },
          {
            startQuest = "17776335936101403325",
            startPort = "PassiveFail",
            endQuest = "17784741923257286507",
            endPort = "In"
          }
        },
        nodeData = {
          ["17776326338835380"] = {
            key = "17776326338835380",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 251.3431013431014, y = 282.1184371184371},
            propsData = {ModeType = 0}
          },
          ["17776326338845381"] = {
            key = "17776326338845381",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1701.25, y = 265.32894736842104},
            propsData = {ModeType = 0}
          },
          ["17776326338845382"] = {
            key = "17776326338845382",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1778.8819875776396, y = 436.8478260869565},
            propsData = {}
          },
          ["17776335936101403325"] = {
            key = "17776335936101403325",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1367.8823529411766, y = 299.25},
            propsData = {SpecialConfigId = 10040203, BlackScreenImmediately = true}
          },
          ["17776356652074198772"] = {
            key = "17776356652074198772",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 548.9394534358839, y = 281.5842105200379},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateChaosPre100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17776356652074198774"] = {
            key = "17776356652074198774",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 914.8976135843667, y = 280.1681353523498},
            propsData = {
              VarName = "FirstStateChaosPre100402",
              VarValue = 1
            }
          },
          ["17776370700389786624"] = {
            key = "17776370700389786624",
            type = "GoToNode",
            name = "前往",
            pos = {x = 528.5346720418871, y = 627.6485294610717},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530011,
              GuideType = "M",
              GuidePointName = "Mechanism_KaojinZhuanlie_2530011"
            }
          },
          ["177821522146085278864"] = {
            key = "177821522146085278864",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1089.9425033171162, y = 531.2148385670057},
            propsData = {
              VarName = "FirstStateChaosPre100402",
              VarValue = 2
            }
          },
          ["17784741923257286507"] = {
            key = "17784741923257286507",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1555.7067669172934, y = 662.4522335249889},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_MTEnd",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177847736745017509648"] = {
            key = "177847736745017509648",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 801.1638838410151, y = 652.0017747774959},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["17776326340725394"] = {
      isStoryNode = true,
      key = "17776326340725394",
      type = "StoryNode",
      name = "前往医务室流程",
      pos = {x = 31.929111887349855, y = 1300.2180257766645},
      propsData = {
        QuestId = 10040202,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040203_01_04",
        QuestDeatil = "Description_10040203_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_REGotoYWS",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17776335823671402954",
            startPort = "Success",
            endQuest = "17776326340725400",
            endPort = "Success"
          },
          {
            startQuest = "17776326340725399",
            startPort = "QuestStart",
            endQuest = "17776356568164198433",
            endPort = "In"
          },
          {
            startQuest = "177847441280611664969",
            startPort = "True",
            endQuest = "17776335823671402954",
            endPort = "In"
          },
          {
            startQuest = "177847441280611664969",
            startPort = "False",
            endQuest = "17776326340725401",
            endPort = "Fail"
          },
          {
            startQuest = "17776356568164198433",
            startPort = "false",
            endQuest = "17776356568164198434",
            endPort = "In"
          },
          {
            startQuest = "17776356568164198434",
            startPort = "Out",
            endQuest = "177847441280611664969",
            endPort = "Input"
          },
          {
            startQuest = "177847459141111667254",
            startPort = "Out",
            endQuest = "17776326340725401",
            endPort = "Fail"
          },
          {
            startQuest = "17776335823671402954",
            startPort = "Fail",
            endQuest = "177847459141111667254",
            endPort = "In"
          },
          {
            startQuest = "17776335823671402954",
            startPort = "PassiveFail",
            endQuest = "177847459141111667254",
            endPort = "In"
          },
          {
            startQuest = "17776356568164198433",
            startPort = "true",
            endQuest = "17776335823671402954",
            endPort = "In"
          }
        },
        nodeData = {
          ["17776326340725399"] = {
            key = "17776326340725399",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 61, y = 237.1304347826087},
            propsData = {ModeType = 0}
          },
          ["17776326340725400"] = {
            key = "17776326340725400",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1633.111111111111, y = 17.555555555555543},
            propsData = {ModeType = 0}
          },
          ["17776326340725401"] = {
            key = "17776326340725401",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2236.2845222410438, y = 690.4992157600855},
            propsData = {}
          },
          ["17776335823671402954"] = {
            key = "17776335823671402954",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1142.3939393939393, y = 232.05050505050502},
            propsData = {SpecialConfigId = 10040202, BlackScreenImmediately = true}
          },
          ["17776356568164198433"] = {
            key = "17776356568164198433",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 388.24497872564336, y = 254.8640491902892},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateGotoYWS100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17776356568164198434"] = {
            key = "17776356568164198434",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 604.0014946285885, y = 575.661516343897},
            propsData = {
              StaticCreatorId = 272480295,
              UnitId = 10096,
              bGuideUIEnable = true,
              GuidePointName = "BP_REGotoYWS",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["177847441280611664969"] = {
            key = "177847441280611664969",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 938.2181818181817, y = 575.1454545454545},
            propsData = {PopupId = 100110}
          },
          ["177847459141111667254"] = {
            key = "177847459141111667254",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2560.543569902824, y = 489.6537752969574},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruEnd",
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
    ["17776326344265420"] = {
      isStoryNode = true,
      key = "17776326344265420",
      type = "StoryNode",
      name = "地下追逐战",
      pos = {x = 1758.4838326250378, y = 1319.67872943759},
      propsData = {
        QuestId = 10040205,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040210_01",
        QuestDeatil = "Description_10040210_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = true,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 106301,
        SubRegionIdList = {106001},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_REZZZ",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17776336407761405193",
            startPort = "Success",
            endQuest = "17776326344265426",
            endPort = "Success"
          },
          {
            startQuest = "17776356899434199834",
            startPort = "true",
            endQuest = "17776356899434199836",
            endPort = "In"
          },
          {
            startQuest = "17776356899434199836",
            startPort = "Out",
            endQuest = "17776336407761405193",
            endPort = "In"
          },
          {
            startQuest = "17776356899434199834",
            startPort = "false",
            endQuest = "17785043951288759860",
            endPort = "In"
          },
          {
            startQuest = "17785043951288759860",
            startPort = "Region_1",
            endQuest = "17785031907865840580",
            endPort = "In"
          },
          {
            startQuest = "17785043951288759860",
            startPort = "Region_2",
            endQuest = "17785044105718760184",
            endPort = "In"
          },
          {
            startQuest = "17785043951288759860",
            startPort = "LastDefaultOut",
            endQuest = "17785031907865840580",
            endPort = "In"
          },
          {
            startQuest = "17785031907865840580",
            startPort = "Out",
            endQuest = "177850448822710220078",
            endPort = "In"
          },
          {
            startQuest = "177850448822710220078",
            startPort = "Out",
            endQuest = "17776336407761405193",
            endPort = "In"
          },
          {
            startQuest = "17785044105718760184",
            startPort = "Out",
            endQuest = "177850448822710220078",
            endPort = "In"
          },
          {
            startQuest = "177881883252549736213",
            startPort = "Out",
            endQuest = "17776326344265427",
            endPort = "Fail"
          },
          {
            startQuest = "177881884173849736448",
            startPort = "Out",
            endQuest = "17776326344265427",
            endPort = "Fail"
          },
          {
            startQuest = "17776336407761405193",
            startPort = "Fail",
            endQuest = "177881884173849736448",
            endPort = "In"
          },
          {
            startQuest = "17776336407761405193",
            startPort = "PassiveFail",
            endQuest = "177881883252549736213",
            endPort = "In"
          },
          {
            startQuest = "17776326344265425",
            startPort = "QuestStart",
            endQuest = "177978411478316956143",
            endPort = "In"
          },
          {
            startQuest = "177978411478316956143",
            startPort = "Out",
            endQuest = "17776356899434199834",
            endPort = "In"
          }
        },
        nodeData = {
          ["17776326344265425"] = {
            key = "17776326344265425",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -81.42857142857142, y = 131.24999999999997},
            propsData = {ModeType = 0}
          },
          ["17776326344265426"] = {
            key = "17776326344265426",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1890.6315789473683, y = 15.353383458646618},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17776326344265427"] = {
            key = "17776326344265427",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2392.7669172932333, y = 543.7443609022557},
            propsData = {}
          },
          ["17776336407761405193"] = {
            key = "17776336407761405193",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1446.6785714285713, y = 303.57142857142856},
            propsData = {SpecialConfigId = 10040205, BlackScreenImmediately = true}
          },
          ["17776356899434199834"] = {
            key = "17776356899434199834",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 564.9592644399289, y = 120.39447284300405},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateDixiaZZZ100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17776356899434199835"] = {
            key = "17776356899434199835",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 549.3873312158768, y = 788.5989827799025},
            propsData = {
              StaticCreatorId = 272480296,
              UnitId = 10097,
              bGuideUIEnable = true,
              GuidePointName = "BP_REZZZ",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["17776356899434199836"] = {
            key = "17776356899434199836",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 861.3661425371297, y = 123.990607687526},
            propsData = {
              VarName = "FirstStateDixiaZZZ100402",
              VarValue = 1
            }
          },
          ["17785031907865840580"] = {
            key = "17785031907865840580",
            type = "GoToNode",
            name = "前往",
            pos = {x = 824.3581379920391, y = 384.03308823529414},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530017,
              GuideType = "P",
              GuidePointName = "BP_REZZZ"
            }
          },
          ["17785043951288759860"] = {
            key = "17785043951288759860",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 417.47259298149413, y = 429.1842994792474},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {106001, 106301}
            }
          },
          ["17785044105718760184"] = {
            key = "17785044105718760184",
            type = "GoToNode",
            name = "前往",
            pos = {x = 825.729391738293, y = 552.7600570550051},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530017,
              GuideType = "P",
              GuidePointName = "Mechanism_ZZZ01_2530017"
            }
          },
          ["177850448822710220078"] = {
            key = "177850448822710220078",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1161.2905383211787, y = 499.67380996875795},
            propsData = {
              VarName = "FirstStateDixiaZZZ100402",
              VarValue = 2
            }
          },
          ["177881883252549736213"] = {
            key = "177881883252549736213",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1908.5043859649124, y = 586.719298245614},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZZZstart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177881884173849736448"] = {
            key = "177881884173849736448",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1892.7149122807018, y = 315.140350877193},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 13,
              IsWhite = false
            }
          },
          ["177978411478316956143"] = {
            key = "177978411478316956143",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 202.81578947368416, y = 112.37499999999997},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0165_story_xier_theme.0165_story_xier_theme'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106301},
              bStoreToServer = true
            }
          }
        },
        commentData = {}
      }
    },
    ["177763795417816773243"] = {
      isStoryNode = true,
      key = "177763795417816773243",
      type = "StoryNode",
      name = "追逐前",
      pos = {x = 1477.3647293341537, y = 1312.3448795466977},
      propsData = {
        QuestId = 10040206,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040210_01",
        QuestDeatil = "Description_10040210_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_Guanlishi_2530014",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177763795417816773248",
            startPort = "QuestStart",
            endQuest = "17797131316471940065",
            endPort = "In"
          },
          {
            startQuest = "17797131316471940065",
            startPort = "Out",
            endQuest = "177763795417816773252",
            endPort = "In"
          },
          {
            startQuest = "177763795417816773252",
            startPort = "Out",
            endQuest = "17800554634351458143",
            endPort = "In"
          },
          {
            startQuest = "17800554634351458143",
            startPort = "Out",
            endQuest = "177763795417816773249",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177763795417816773248"] = {
            key = "177763795417816773248",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -532.7214622684469, y = 336.9647092038397},
            propsData = {ModeType = 0}
          },
          ["177763795417816773249"] = {
            key = "177763795417816773249",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 965.2473748473743, y = 345.6069597069598},
            propsData = {
              ModeType = 1,
              Id = 106301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["177763795417816773250"] = {
            key = "177763795417816773250",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 814.2857142857138, y = 774.2857142857143},
            propsData = {}
          },
          ["177763795417816773251"] = {
            key = "177763795417816773251",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "追逐战特殊任务",
            pos = {x = 1664.1839464882944, y = -87.27257525083627},
            propsData = {SpecialConfigId = 0, BlackScreenImmediately = false}
          },
          ["177763795417816773252"] = {
            key = "177763795417816773252",
            type = "TalkNode",
            name = "希尔妲救场",
            pos = {x = 115.75733160208961, y = 318.18167115142904},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_06.Chapter03_Fix_SEQ_06'",
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
          ["17797131316471940065"] = {
            key = "17797131316471940065",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = -189.0450270743749, y = 312.0659596442205},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0164_cs_xier_show.0164_cs_xier_show'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["17800554634351458143"] = {
            key = "17800554634351458143",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 421.6161029802672, y = 357.33025333425786},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0165_story_xier_theme.0165_story_xier_theme'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          }
        },
        commentData = {}
      }
    },
    ["177763795518616773311"] = {
      isStoryNode = true,
      key = "177763795518616773311",
      type = "StoryNode",
      name = "芙罗拉出场",
      pos = {x = 2061.521146446453, y = 1322.7204451575576},
      propsData = {
        QuestId = 10040207,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040211_01",
        QuestDeatil = "Description_10040210_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_ZZZEnd",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177763795518716773319",
            startPort = "Out",
            endQuest = "177763795518716773322",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773322",
            startPort = "Out",
            endQuest = "177763795518716773320",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773320",
            startPort = "Out",
            endQuest = "177763795518716773323",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773323",
            startPort = "Out",
            endQuest = "177763795518716773321",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773324",
            startPort = "Out",
            endQuest = "177763795518716773319",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773316",
            startPort = "QuestStart",
            endQuest = "177763795518716773328",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773328",
            startPort = "Out",
            endQuest = "177763795518716773324",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773316",
            startPort = "QuestStart",
            endQuest = "177891707027472437951",
            endPort = "Input"
          },
          {
            startQuest = "177763795518716773321",
            startPort = "Out",
            endQuest = "177891710926772438475",
            endPort = "Input"
          },
          {
            startQuest = "177891710926772438475",
            startPort = "Out",
            endQuest = "177763795518716773317",
            endPort = "Success"
          },
          {
            startQuest = "177763795518716773320",
            startPort = "Out",
            endQuest = "177969524549030002874",
            endPort = "In"
          },
          {
            startQuest = "177763795518716773316",
            startPort = "QuestStart",
            endQuest = "177969503433828552394",
            endPort = "In"
          }
        },
        nodeData = {
          ["177763795518716773316"] = {
            key = "177763795518716773316",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -371.5417436499217, y = 265.655974603705},
            propsData = {ModeType = 0}
          },
          ["177763795518716773317"] = {
            key = "177763795518716773317",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2702.319805194805, y = 326.1187562437563},
            propsData = {ModeType = 0}
          },
          ["177763795518716773318"] = {
            key = "177763795518716773318",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1033.8461538461538, y = 662.5274725274725},
            propsData = {}
          },
          ["177763795518716773319"] = {
            key = "177763795518716773319",
            type = "TalkNode",
            name = "芙罗拉出场",
            pos = {x = 1013.4932844932846, y = 265.64073091659304},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042601.10042601'",
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
              HideMechanismsFX = true,
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
          ["177763795518716773320"] = {
            key = "177763795518716773320",
            type = "TalkNode",
            name = "与芙罗拉交谈",
            pos = {x = 1543.2275738966916, y = 317.8220015278839},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042701.10042701'",
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
              HideMechanismsFX = true,
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
          ["177763795518716773321"] = {
            key = "177763795518716773321",
            type = "TalkNode",
            name = "与希尔妲交谈",
            pos = {x = 2066.5307706998888, y = 326.3714520773345},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042801.10042801'",
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
              HideMechanismsFX = true,
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
          ["177763795518716773322"] = {
            key = "177763795518716773322",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家到芙罗拉专列",
            pos = {x = 1313.9028467052663, y = 294.75544527157444},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZLPoint01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177763795518716773323"] = {
            key = "177763795518716773323",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "设置玩家到芙罗拉专列外",
            pos = {x = 1797.8228383458647, y = 340.00140977443607},
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
          ["177763795518716773324"] = {
            key = "177763795518716773324",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 572.6649277446693, y = 284.77543146508685},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_07.Chapter03_Fix_SEQ_07'",
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
          ["177763795518716773328"] = {
            key = "177763795518716773328",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 28.24453415003744, y = 256.2683789684105},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZZZEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177891707027472437951"] = {
            key = "177891707027472437951",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 33.99043062200968, y = 36.33014354066989},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["177891710926772438475"] = {
            key = "177891710926772438475",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2379.0454545454545, y = 307.26076555023917},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["177969503433828552394"] = {
            key = "177969503433828552394",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 224.0464331691347, y = 507.62185451256727},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["177969524549030002874"] = {
            key = "177969524549030002874",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1778.4002034070681, y = 163.53521484871598},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["177763815767418173755"] = {
      isStoryNode = true,
      key = "177763815767418173755",
      type = "StoryNode",
      name = "攀爬完成对话",
      pos = {x = -223.621016942721, y = 1294.8143310016628},
      propsData = {
        QuestId = 10040208,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040201_01",
        QuestDeatil = "Description_10040203_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_JumpInter",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177763815767418173760",
            startPort = "QuestStart",
            endQuest = "177763815767518173767",
            endPort = "In"
          },
          {
            startQuest = "177763815767518173767",
            startPort = "Out",
            endQuest = "177763815767418173763",
            endPort = "In"
          },
          {
            startQuest = "177763815767418173763",
            startPort = "Out",
            endQuest = "17797126232301455802",
            endPort = "In"
          },
          {
            startQuest = "17797126232301455802",
            startPort = "Out",
            endQuest = "177763815767418173761",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177763815767418173760"] = {
            key = "177763815767418173760",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 17.138810977286454, y = 253.71060881042737},
            propsData = {ModeType = 0}
          },
          ["177763815767418173761"] = {
            key = "177763815767418173761",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1716.1177719072457, y = 306.217570954413},
            propsData = {ModeType = 0}
          },
          ["177763815767418173762"] = {
            key = "177763815767418173762",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 971.3186813186813, y = 722.0879120879122},
            propsData = {}
          },
          ["177763815767418173763"] = {
            key = "177763815767418173763",
            type = "TalkNode",
            name = "落下列车对话",
            pos = {x = 1048.9274041321119, y = 278.46769443502654},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041401.10041401'",
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
              HideMechanismsFX = true,
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
          ["177763815767518173767"] = {
            key = "177763815767518173767",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 378.7580376280063, y = 264.24373858855284},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17797126232301455802"] = {
            key = "17797126232301455802",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1336.6315789473686, y = 284.421052631579},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["177763838346820967006"] = {
      isStoryNode = true,
      key = "177763838346820967006",
      type = "StoryNode",
      name = "希尔妲出场",
      pos = {x = 1027.4814257096734, y = 1303.9821000489342},
      propsData = {
        QuestId = 10040213,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040206_01",
        QuestDeatil = "Description_10040207_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_KaojinZhuanlie_2530011",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177763838346920967017",
            startPort = "Out",
            endQuest = "177763838346920967016",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967015",
            startPort = "Out",
            endQuest = "177763838346920967014",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967011",
            startPort = "QuestStart",
            endQuest = "177763838346920967015",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967011",
            startPort = "QuestStart",
            endQuest = "177969493425927101363",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967014",
            startPort = "Out",
            endQuest = "177763838346920967017",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967016",
            startPort = "Out",
            endQuest = "17797128954755811826",
            endPort = "In"
          },
          {
            startQuest = "17797128954755811826",
            startPort = "Out",
            endQuest = "177763838346920967012",
            endPort = "Success"
          },
          {
            startQuest = "177763838346920967017",
            startPort = "Out",
            endQuest = "177969915780753717908",
            endPort = "In"
          },
          {
            startQuest = "177763838346920967015",
            startPort = "Out",
            endQuest = "17797127232322907865",
            endPort = "In"
          }
        },
        nodeData = {
          ["177763838346920967011"] = {
            key = "177763838346920967011",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 478.9113149395406, y = 386.0545388751034},
            propsData = {ModeType = 0}
          },
          ["177763838346920967012"] = {
            key = "177763838346920967012",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2479.38484271689, y = 408.7531807253056},
            propsData = {ModeType = 0}
          },
          ["177763838346920967013"] = {
            key = "177763838346920967013",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1904.0178571428569, y = 825.3571428571429},
            propsData = {}
          },
          ["177763838346920967014"] = {
            key = "177763838346920967014",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1199.2292626728108, y = 388.29953917050693},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042001.10042001'",
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
              HideMechanismsFX = true,
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
          ["177763838346920967015"] = {
            key = "177763838346920967015",
            type = "TalkNode",
            name = "希尔妲出场动画",
            pos = {x = 747.2117821694436, y = 389.6802995391705},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC006/SQ_Ver0104_SC006",
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
          ["177763838346920967016"] = {
            key = "177763838346920967016",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1786.9526647966343, y = 374.5508415147264},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042101.10042101'",
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
          ["177763838346920967017"] = {
            key = "177763838346920967017",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置远离芙罗拉专列",
            pos = {x = 1469.3655913978498, y = 385.8172043010753},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_XierEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177969493425927101363"] = {
            key = "177969493425927101363",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 715.767657542686, y = 191.06680161943328},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0164_cs_xier_show.0164_cs_xier_show'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["177969915780753717908"] = {
            key = "177969915780753717908",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1794.7769607843138, y = 203.96078431372558},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["17797127232322907865"] = {
            key = "17797127232322907865",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1125.5869047619046, y = 165.7672619047619},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0165_story_xier_theme.0165_story_xier_theme'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          },
          ["17797128954755811826"] = {
            key = "17797128954755811826",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2064.8127112135176, y = 383.7350038402458},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["17778012387711868763"] = {
      isStoryNode = true,
      key = "17778012387711868763",
      type = "StoryNode",
      name = "医务室流程",
      pos = {x = 250.93088774792926, y = 1301.4005988022338},
      propsData = {
        QuestId = 10040209,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040203_01_04",
        QuestDeatil = "Description_10040204_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_REGotoYWS",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17778012387711868771",
            startPort = "Success",
            endQuest = "17778012387711868769",
            endPort = "Success"
          },
          {
            startQuest = "17778012387711868772",
            startPort = "true",
            endQuest = "17778012387711868774",
            endPort = "In"
          },
          {
            startQuest = "17778012387711868768",
            startPort = "QuestStart",
            endQuest = "17778012387711868772",
            endPort = "In"
          },
          {
            startQuest = "17778012387711868774",
            startPort = "Out",
            endQuest = "17778012387711868771",
            endPort = "In"
          },
          {
            startQuest = "17778012387711868771",
            startPort = "Fail",
            endQuest = "17778018267781871164",
            endPort = "In"
          },
          {
            startQuest = "17778012387711868772",
            startPort = "false",
            endQuest = "177866621480022925068",
            endPort = "In"
          },
          {
            startQuest = "177866621480022925068",
            startPort = "Out",
            endQuest = "177866622912622925549",
            endPort = "Input"
          },
          {
            startQuest = "177866622912622925549",
            startPort = "True",
            endQuest = "17778012387711868771",
            endPort = "In"
          },
          {
            startQuest = "177866622912622925549",
            startPort = "False",
            endQuest = "17778012387711868770",
            endPort = "Fail"
          },
          {
            startQuest = "17778012387711868771",
            startPort = "PassiveFail",
            endQuest = "177926724668819361185",
            endPort = "In"
          },
          {
            startQuest = "17778018267781871164",
            startPort = "Out",
            endQuest = "177926724668819361185",
            endPort = "In"
          },
          {
            startQuest = "177926724668819361185",
            startPort = "Out",
            endQuest = "17778012387711868770",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17778012387711868768"] = {
            key = "17778012387711868768",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 39.99791970043685, y = 266.8464738922405},
            propsData = {ModeType = 0}
          },
          ["17778012387711868769"] = {
            key = "17778012387711868769",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1543.25, y = -38},
            propsData = {ModeType = 0}
          },
          ["17778012387711868770"] = {
            key = "17778012387711868770",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2388, y = 598},
            propsData = {}
          },
          ["17778012387711868771"] = {
            key = "17778012387711868771",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1077.4318181818182, y = 183.9318181818182},
            propsData = {SpecialConfigId = 10040206, BlackScreenImmediately = true}
          },
          ["17778012387711868772"] = {
            key = "17778012387711868772",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 421.6398195827268, y = 278.2780288033535},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateYWS100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17778012387711868774"] = {
            key = "17778012387711868774",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 784.9824164234267, y = 280.16249316732626},
            propsData = {
              VarName = "FirstStateYWS100402",
              VarValue = 1
            }
          },
          ["17778018267781871164"] = {
            key = "17778018267781871164",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1407.2527856960708, y = 230.64430406549954},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_YWSEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177866621480022925068"] = {
            key = "177866621480022925068",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 684.8421052631585, y = 622.5263157894736},
            propsData = {
              StaticCreatorId = 272480299,
              UnitId = 10096,
              bGuideUIEnable = true,
              GuidePointName = "FromCZtoYWS",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["177866622912622925549"] = {
            key = "177866622912622925549",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 991.1578947368421, y = 616.2105263157895},
            propsData = {PopupId = 100110}
          },
          ["177926724668819361185"] = {
            key = "177926724668819361185",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 1674.25, y = 521.5},
            propsData = {Duration = 0}
          }
        },
        commentData = {}
      }
    },
    ["17784740583465828089"] = {
      isStoryNode = true,
      key = "17784740583465828089",
      type = "StoryNode",
      name = "混乱车站",
      pos = {x = 815.9033609439196, y = 1337.757171461262},
      propsData = {
        QuestId = 10040210,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040205_01",
        QuestDeatil = "Description_10040206_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_KaojinZhuanlie_2530011",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17784740583465828097",
            startPort = "Success",
            endQuest = "17784740583465828095",
            endPort = "Success"
          },
          {
            startQuest = "17784740583465828098",
            startPort = "true",
            endQuest = "17784740583465828099",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828094",
            startPort = "QuestStart",
            endQuest = "17784740583465828098",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828098",
            startPort = "false",
            endQuest = "17784740583465828100",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828101",
            startPort = "Out",
            endQuest = "17784740583465828097",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828100",
            startPort = "Out",
            endQuest = "177847738421817509956",
            endPort = "Input"
          },
          {
            startQuest = "177847738421817509956",
            startPort = "True",
            endQuest = "17784740583465828101",
            endPort = "In"
          },
          {
            startQuest = "177847738421817509956",
            startPort = "False",
            endQuest = "17784742306538745834",
            endPort = "In"
          },
          {
            startQuest = "177866872814727302541",
            startPort = "Out",
            endQuest = "177866873521127302682",
            endPort = "In"
          },
          {
            startQuest = "177866872146927302411",
            startPort = "Out",
            endQuest = "177866872814727302541",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828097",
            startPort = "Fail",
            endQuest = "177866872146927302411",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828097",
            startPort = "PassiveFail",
            endQuest = "177866872146927302411",
            endPort = "In"
          },
          {
            startQuest = "177866873521127302682",
            startPort = "Out",
            endQuest = "177919982128613044296",
            endPort = "In"
          },
          {
            startQuest = "17784742306538745834",
            startPort = "Out",
            endQuest = "177936863678471558006",
            endPort = "In"
          },
          {
            startQuest = "177936863678471558006",
            startPort = "Out",
            endQuest = "17784740583465828096",
            endPort = "Fail"
          },
          {
            startQuest = "17784740583465828094",
            startPort = "QuestStart",
            endQuest = "177937002786774459564",
            endPort = "In"
          },
          {
            startQuest = "17784740583465828098",
            startPort = "true",
            endQuest = "17784740583465828097",
            endPort = "In"
          },
          {
            startQuest = "177919982128613044296",
            startPort = "Out",
            endQuest = "17784742306538745834",
            endPort = "In"
          }
        },
        nodeData = {
          ["17784740583465828094"] = {
            key = "17784740583465828094",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 192.69230769230774, y = 290.7692307692307},
            propsData = {ModeType = 0}
          },
          ["17784740583465828095"] = {
            key = "17784740583465828095",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1849.5454545454545, y = 264.7607655502392},
            propsData = {ModeType = 0}
          },
          ["17784740583465828096"] = {
            key = "17784740583465828096",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3084.988558352403, y = 838.3166215935095},
            propsData = {}
          },
          ["17784740583465828097"] = {
            key = "17784740583465828097",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1204, y = 288},
            propsData = {SpecialConfigId = 10040210, BlackScreenImmediately = true}
          },
          ["17784740583465828098"] = {
            key = "17784740583465828098",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 541.4394534358839, y = 292.29849623432364},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateChaos100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17784740583465828099"] = {
            key = "17784740583465828099",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 938.8976135843667, y = 143.16813535234976},
            propsData = {
              VarName = "FirstStateChaos100402",
              VarValue = 1
            }
          },
          ["17784740583465828100"] = {
            key = "17784740583465828100",
            type = "GoToNode",
            name = "前往",
            pos = {x = 634.3197843324173, y = 569.0000086492382},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530011,
              GuideType = "M",
              GuidePointName = "Mechanism_KaojinZhuanlie_2530011"
            }
          },
          ["17784740583465828101"] = {
            key = "17784740583465828101",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1150, y = 524},
            propsData = {
              VarName = "FirstStateChaos100402",
              VarValue = 2
            }
          },
          ["17784742306538745834"] = {
            key = "17784742306538745834",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1650.2476905382473, y = 716.2108487822112},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_MTEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177847738421817509956"] = {
            key = "177847738421817509956",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 886.1115841073271, y = 640.4441939247095},
            propsData = {PopupId = 100110}
          },
          ["177866872146927302411"] = {
            key = "177866872146927302411",
            type = "SplineMoveEndNode",
            name = "结束沿Spline移动节点",
            pos = {x = 1481.4812030075186, y = 389.19912684938146},
            propsData = {SplineActorIndex = 1004020601, ExitBlendTime = 0}
          },
          ["177866872814727302541"] = {
            key = "177866872814727302541",
            type = "SplineMoveEndNode",
            name = "结束沿Spline移动节点",
            pos = {x = 1774.6556732740962, y = 429.6705399863301},
            propsData = {SplineActorIndex = 10040201, ExitBlendTime = 0}
          },
          ["177866873521127302682"] = {
            key = "177866873521127302682",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 2074.090624287994, y = 438.2772841193901},
            propsData = {Duration = 0}
          },
          ["177919982128613044296"] = {
            key = "177919982128613044296",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2490, y = 422},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "ChaosYTFail",
              UnitId = -1
            }
          },
          ["177936863678471558006"] = {
            key = "177936863678471558006",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2028.424199084668, y = 748.4535796011768},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "CZLightChangeEnd",
              UnitId = -1
            }
          },
          ["177937002786774459564"] = {
            key = "177937002786774459564",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 570.9696969696968, y = 135.28787878787858},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "CZLightChangeEnd",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["1778586529923979350"] = {
      isStoryNode = true,
      key = "1778586529923979350",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 400.21067876911536, y = 1493.601485476654},
      propsData = {
        QuestId = 10040214,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040203_01_04",
        QuestDeatil = "Description_10040204_01",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_YWSEnd",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17785866089802439844",
            startPort = "Out",
            endQuest = "17785866089802439845",
            endPort = "In"
          },
          {
            startQuest = "17785865970492439804",
            startPort = "Out",
            endQuest = "17785866089802439844",
            endPort = "In"
          },
          {
            startQuest = "1778586529923979351",
            startPort = "QuestStart",
            endQuest = "17785865970492439804",
            endPort = "In"
          },
          {
            startQuest = "17785866089802439845",
            startPort = "Out",
            endQuest = "17785867004546821178",
            endPort = "In"
          },
          {
            startQuest = "17785867004546821178",
            startPort = "Out",
            endQuest = "1778586529923979354",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1778586529923979351"] = {
            key = "1778586529923979351",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1778586529923979354"] = {
            key = "1778586529923979354",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2615, y = 551.3333333333334},
            propsData = {ModeType = 0}
          },
          ["1778586529923979357"] = {
            key = "1778586529923979357",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17785865970492439804"] = {
            key = "17785865970492439804",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1216, y = 584},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041601.10041601'",
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
              HideMechanismsFX = true,
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
          ["17785866089802439844"] = {
            key = "17785866089802439844",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1741.9376068376068, y = 530.5264957264958},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_YWSEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17785866089802439845"] = {
            key = "17785866089802439845",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2026.0623931623932, y = 525.4735042735042},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041701.10041701'",
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
              HideMechanismsFX = true,
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
          ["17785867004546821178"] = {
            key = "17785867004546821178",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2338.6666666666665, y = 542.3333333333334},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_YWSEndToZL",
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
    }
  },
  commentData = {}
}
