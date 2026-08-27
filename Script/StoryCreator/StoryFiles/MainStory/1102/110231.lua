return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104531329083",
      startPort = "StoryStart",
      endStory = "17697590104531329085",
      endPort = "In"
    },
    {
      startStory = "17697590104531329085",
      startPort = "Success",
      endStory = "17814295638251574288",
      endPort = "In"
    },
    {
      startStory = "17814295638251574288",
      startPort = "Success",
      endStory = "178176959338912701073",
      endPort = "In"
    },
    {
      startStory = "178176959338912701073",
      startPort = "Success",
      endStory = "17849827159883329605",
      endPort = "In"
    },
    {
      startStory = "17849827159883329605",
      startPort = "Success",
      endStory = "17697590104531329084",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17697590104531329083"] = {
      isStoryNode = true,
      key = "17697590104531329083",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 809.7142857921367, y = 322},
      propsData = {QuestChainId = 110231},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531329084"] = {
      isStoryNode = true,
      key = "17697590104531329084",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2861.1725311961286, y = 433.3707531415251},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531329085"] = {
      isStoryNode = true,
      key = "17697590104531329085",
      type = "StoryNode",
      name = "返回村庄",
      pos = {x = 1224, y = 316.3230673430581},
      propsData = {
        QuestId = 11023101,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110231_0",
        QuestDeatil = "Content_110231_0",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11023101_01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17810926502391018808",
            startPort = "false",
            endQuest = "17810943848041020713",
            endPort = "In"
          },
          {
            startQuest = "178107559592734585795",
            startPort = "Out",
            endQuest = "178107877761634586280",
            endPort = "In"
          },
          {
            startQuest = "17811443068602042242",
            startPort = "Fail",
            endQuest = "17811443183602042822",
            endPort = "In"
          },
          {
            startQuest = "17811443068602042242",
            startPort = "PassiveFail",
            endQuest = "17811443183602042822",
            endPort = "In"
          },
          {
            startQuest = "17811443068602042242",
            startPort = "Success",
            endQuest = "17811443463982043588",
            endPort = "Input"
          },
          {
            startQuest = "17811443463982043588",
            startPort = "Out",
            endQuest = "17697590104531329087",
            endPort = "Success"
          },
          {
            startQuest = "17811443183602042822",
            startPort = "Out",
            endQuest = "17811443587912043877",
            endPort = "Input"
          },
          {
            startQuest = "178119461371910187997",
            startPort = "Out",
            endQuest = "178119461371910187998",
            endPort = "In"
          },
          {
            startQuest = "178119465308910188819",
            startPort = "true",
            endQuest = "178107559592734585795",
            endPort = "In"
          },
          {
            startQuest = "178119465308910188819",
            startPort = "false",
            endQuest = "178119461371910187997",
            endPort = "In"
          },
          {
            startQuest = "17835137416671807",
            startPort = "Out",
            endQuest = "178126927924727938653",
            endPort = "In"
          },
          {
            startQuest = "17697590104531329086",
            startPort = "QuestStart",
            endQuest = "17835374166961035",
            endPort = "In"
          },
          {
            startQuest = "17835374166961035",
            startPort = "Out",
            endQuest = "17835137416671807",
            endPort = "In"
          },
          {
            startQuest = "17811443587912043877",
            startPort = "Out",
            endQuest = "17697590104531329088",
            endPort = "Fail"
          },
          {
            startQuest = "17697590104531329086",
            startPort = "QuestStart",
            endQuest = "178585651748510012063",
            endPort = "In"
          },
          {
            startQuest = "178126927924727938653",
            startPort = "Out",
            endQuest = "17871092899987823606",
            endPort = "In"
          },
          {
            startQuest = "17871092899987823606",
            startPort = "Out",
            endQuest = "17811443068602042242",
            endPort = "In"
          }
        },
        nodeData = {
          ["17697590104531329086"] = {
            key = "17697590104531329086",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -720.8632380449764, y = 289.16441386570585},
            propsData = {ModeType = 0}
          },
          ["17697590104531329087"] = {
            key = "17697590104531329087",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3435.9666461638435, y = 319.88239826689227},
            propsData = {
              ModeType = 1,
              Id = 107701,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17697590104531329088"] = {
            key = "17697590104531329088",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3792.4444316032004, y = 653.3333349345642},
            propsData = {}
          },
          ["178107559592734585795"] = {
            key = "178107559592734585795",
            type = "ChangeStaticCreatorNode",
            name = "生成等待晚宴开始交互点",
            pos = {x = 1911.1684680672392, y = -1074.5148999213445},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780031}
            }
          },
          ["178107877761634586280"] = {
            key = "178107877761634586280",
            type = "PickUpNode",
            name = "拾取物品，进特殊任务",
            pos = {x = 2241.8198297469326, y = -1059.256320286837},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780031},
              QuestPickupId = -1,
              UnitId = 11023101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11023101_01",
              IsUseCount = false
            }
          },
          ["17810926502391018808"] = {
            key = "17810926502391018808",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "1为再次进行任务，0为首次",
            pos = {x = 749.2584314941537, y = -371.5458386183609},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023101_First",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17810943848041020713"] = {
            key = "17810943848041020713",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1001.2214547035487, y = -339.9686207345602},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023101_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811443068602042242"] = {
            key = "17811443068602042242",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 2265.9697955159645, y = 300.11453041451915},
            propsData = {SpecialConfigId = 11023101, BlackScreenImmediately = true}
          },
          ["17811443183602042822"] = {
            key = "17811443183602042822",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2648.192004112025, y = 595.6700733800042},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023101_03",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811443463982043588"] = {
            key = "17811443463982043588",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2733.747560075738, y = 331.2256406465231},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17811443587912043877"] = {
            key = "17811443587912043877",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2932.6364405189183, y = 631.2256279308659},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178119461371910187997"] = {
            key = "178119461371910187997",
            type = "ChangeStaticCreatorNode",
            name = "生成继续晚宴交互点",
            pos = {x = 1931.8711577781094, y = -637.9008464405433},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780048}
            }
          },
          ["178119461371910187998"] = {
            key = "178119461371910187998",
            type = "PickUpNode",
            name = "拾取物品，进特殊任务",
            pos = {x = 2384.7247883829987, y = -681.6898852168297},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780048},
              QuestPickupId = -1,
              UnitId = 11023103,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11023101_01",
              IsUseCount = false
            }
          },
          ["178119465308910188819"] = {
            key = "178119465308910188819",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0初次晚宴，变量=1继续晚宴",
            pos = {x = 1392.0891434465882, y = -878.2964186298485},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023102_Dinner",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178126927924727938653"] = {
            key = "178126927924727938653",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 643.8094052198002, y = 281.39384168226957},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11114101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17835137416671807"] = {
            key = "17835137416671807",
            type = "ChangeStaticCreatorNode",
            name = "生成座椅",
            pos = {x = 239.00816254836855, y = 303.7828023171928},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312780033,
                312780034,
                312780032,
                312780035,
                312780036,
                312780037,
                312780038,
                312780039,
                312780040,
                312780042,
                312780043,
                312780044,
                312780046
              }
            }
          },
          ["17835374166961035"] = {
            key = "17835374166961035",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = -161.99999938472638, y = 275.09677189123374},
            propsData = {
              NewDescription = "Description_110231_1",
              NewDetail = "Content_110231_1",
              SubTaskTargetIndex = 0
            }
          },
          ["178585651748510012063"] = {
            key = "178585651748510012063",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -36.40847219288648, y = 538.0139339565086},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JhsTPActive_11023101",
              UnitId = -1
            }
          },
          ["17871092899987823606"] = {
            key = "17871092899987823606",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1228, y = 308},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780821,
              GuideType = "P",
              GuidePointName = "QuestSign11023101_01"
            }
          }
        },
        commentData = {}
      }
    },
    ["17814295638251574288"] = {
      isStoryNode = true,
      key = "17814295638251574288",
      type = "StoryNode",
      name = "净化室",
      pos = {x = 1665.6959254816504, y = 329.3871171836861},
      propsData = {
        QuestId = 11023102,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110231_8",
        QuestDeatil = "Content_110231_8",
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
        SubRegionId = 107001,
        SubRegionIdList = {107701, 107001},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11023101_04",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17814295638251574289",
            startPort = "QuestStart",
            endQuest = "17814321337451575522",
            endPort = "In"
          },
          {
            startQuest = "17814295638251574289",
            startPort = "QuestStart",
            endQuest = "17814322068541576363",
            endPort = "In"
          },
          {
            startQuest = "17814322280771576778",
            startPort = "Success",
            endQuest = "17814295638251574292",
            endPort = "Success"
          },
          {
            startQuest = "17814322280771576778",
            startPort = "Fail",
            endQuest = "17814324394361577628",
            endPort = "In"
          },
          {
            startQuest = "17814322280771576778",
            startPort = "PassiveFail",
            endQuest = "17814324394361577628",
            endPort = "In"
          },
          {
            startQuest = "17814324394361577628",
            startPort = "Out",
            endQuest = "17814295638251574295",
            endPort = "Fail"
          },
          {
            startQuest = "17814322068541576363",
            startPort = "Region_1",
            endQuest = "17814322280771576778",
            endPort = "In"
          },
          {
            startQuest = "17814321337451575522",
            startPort = "Region_1",
            endQuest = "17859360148095018098",
            endPort = "In"
          },
          {
            startQuest = "17859360148095018098",
            startPort = "Out",
            endQuest = "17814321555151575909",
            endPort = "In"
          }
        },
        nodeData = {
          ["17814295638251574289"] = {
            key = "17814295638251574289",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17814295638251574292"] = {
            key = "17814295638251574292",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17814295638251574295"] = {
            key = "17814295638251574295",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2782.4324327946756, y = 855.4054022009483},
            propsData = {}
          },
          ["17814321337451575522"] = {
            key = "17814321337451575522",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1122, y = 178},
            propsData = {
              IsWaitingEnterRegion = true,
              RegionIds = {107001}
            }
          },
          ["17814321555151575909"] = {
            key = "17814321555151575909",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1863.0707045099311, y = 192.4444446699297},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestSign11023101_04"
            }
          },
          ["17814322068541576363"] = {
            key = "17814322068541576363",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1128, y = 542},
            propsData = {
              IsWaitingEnterRegion = true,
              RegionIds = {107701}
            }
          },
          ["17814322280771576778"] = {
            key = "17814322280771576778",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1653.8378339646245, y = 568.5405407355945},
            propsData = {SpecialConfigId = 11023102, BlackScreenImmediately = true}
          },
          ["17814324394361577628"] = {
            key = "17814324394361577628",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2121.981982198227, y = 796.8888917459872},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17859360148095018098"] = {
            key = "17859360148095018098",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1489.2727253110831, y = 235.8181759332495},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JhsTPDeactive_11023101",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["178176959338912701073"] = {
      isStoryNode = true,
      key = "178176959338912701073",
      type = "StoryNode",
      name = "逃往吊桥",
      pos = {x = 2013.4756905090187, y = 357.4888358924884},
      propsData = {
        QuestId = 11023103,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110231_14",
        QuestDeatil = "Content_110231_14",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11023103_01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178177248431612705744",
            startPort = "Success",
            endQuest = "178177249935112706302",
            endPort = "Input"
          },
          {
            startQuest = "178177249935112706302",
            startPort = "Out",
            endQuest = "178176959338912701077",
            endPort = "Success"
          },
          {
            startQuest = "178177248431612705744",
            startPort = "Fail",
            endQuest = "178177249935112706303",
            endPort = "Input"
          },
          {
            startQuest = "178177248431612705744",
            startPort = "PassiveFail",
            endQuest = "178177249935112706303",
            endPort = "Input"
          },
          {
            startQuest = "178177249935112706303",
            startPort = "Out",
            endQuest = "17817808302615263",
            endPort = "In"
          },
          {
            startQuest = "17817808302615263",
            startPort = "Out",
            endQuest = "178176959338912701080",
            endPort = "Fail"
          },
          {
            startQuest = "17821102031443204318",
            startPort = "true",
            endQuest = "17821102790743205314",
            endPort = "In"
          },
          {
            startQuest = "17821102790743205314",
            startPort = "Out",
            endQuest = "178177248431612705744",
            endPort = "In"
          },
          {
            startQuest = "17821103030893205694",
            startPort = "Out",
            endQuest = "17821103172573206022",
            endPort = "In"
          },
          {
            startQuest = "17821385014046413618",
            startPort = "Out",
            endQuest = "17821384798676413474",
            endPort = "In"
          },
          {
            startQuest = "17821360540484809807",
            startPort = "Region_1",
            endQuest = "17821385224626414082",
            endPort = "In"
          },
          {
            startQuest = "17821385224626414082",
            startPort = "Out",
            endQuest = "17821385014046413618",
            endPort = "In"
          },
          {
            startQuest = "17821384798676413474",
            startPort = "Out",
            endQuest = "17821385951668016759",
            endPort = "In"
          },
          {
            startQuest = "17821385951668016759",
            startPort = "Out",
            endQuest = "17821360827614810607",
            endPort = "In"
          },
          {
            startQuest = "178176959338912701074",
            startPort = "QuestStart",
            endQuest = "17821102031443204318",
            endPort = "In"
          },
          {
            startQuest = "17821102031443204318",
            startPort = "false",
            endQuest = "17870790174731121432",
            endPort = "In"
          },
          {
            startQuest = "17870790174731121432",
            startPort = "Out",
            endQuest = "178177248431612705744",
            endPort = "In"
          }
        },
        nodeData = {
          ["178176959338912701074"] = {
            key = "178176959338912701074",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 451.96079559453244, y = 284.3137259986268},
            propsData = {ModeType = 0}
          },
          ["178176959338912701077"] = {
            key = "178176959338912701077",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3652.903422900946, y = 611.0944552455536},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 2,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["178176959338912701080"] = {
            key = "178176959338912701080",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3405.5305594429296, y = 1042.5020788619704},
            propsData = {}
          },
          ["178177248431612705744"] = {
            key = "178177248431612705744",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 2431.9915376855583, y = 593.1496957130119},
            propsData = {SpecialConfigId = 11023103, BlackScreenImmediately = true}
          },
          ["178177249935112706302"] = {
            key = "178177249935112706302",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2681.5945859299923, y = 517.7055601557128},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178177249935112706303"] = {
            key = "178177249935112706303",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2762.4776022955193, y = 924.7143431873714},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17817808302615263"] = {
            key = "17817808302615263",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 3035.0591720529414, y = 968.7575799443971},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17821102031443204318"] = {
            key = "17821102031443204318",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = 1322.180560540804, y = 740.9359986912538},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023103_Escape",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17821102790743205314"] = {
            key = "17821102790743205314",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1855.719079602026, y = 574.6492023111691},
            propsData = {
              VarName = "ex02_11023103_Escape",
              VarValue = 1
            }
          },
          ["17821103030893205694"] = {
            key = "17821103030893205694",
            type = "ChangeStaticCreatorNode",
            name = "生成交互点",
            pos = {x = 1571.3428466045866, y = 1202.7048451801347},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780098}
            }
          },
          ["17821103172573206022"] = {
            key = "17821103172573206022",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1983.6322736141772, y = 1125.6435359211498},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780098},
              QuestPickupId = -1,
              UnitId = 11023107,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11023103_01",
              IsUseCount = false
            }
          },
          ["17821360540484809807"] = {
            key = "17821360540484809807",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1052.778617010701, y = 20.073004758628116},
            propsData = {
              IsWaitingEnterRegion = true,
              RegionIds = {210101}
            }
          },
          ["17821360827614810607"] = {
            key = "17821360827614810607",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2594.9246438909095, y = 53.21504412611819},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17821384798676413474"] = {
            key = "17821384798676413474",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2004.177018821443, y = 19.48410144381205},
            propsData = {
              VarName = "ex02_11023103_Escape",
              VarValue = 0
            }
          },
          ["17821385014046413618"] = {
            key = "17821385014046413618",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1731.628008047584, y = 29.782051205379986},
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
          ["17821385224626414082"] = {
            key = "17821385224626414082",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1344.373118638683, y = 22.514737967844695},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["17821385951668016759"] = {
            key = "17821385951668016759",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2244.3730894674695, y = -10.908054433848463},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["17870790174731121432"] = {
            key = "17870790174731121432",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1883.8787919188408, y = 839.8787888362571},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780820,
              GuideType = "P",
              GuidePointName = "QuestSign11023103_01"
            }
          }
        },
        commentData = {}
      }
    },
    ["17849827159883329605"] = {
      isStoryNode = true,
      key = "17849827159883329605",
      type = "StoryNode",
      name = "追击玩具兵",
      pos = {x = 2411.6066844272477, y = 401.64321391010907},
      propsData = {
        QuestId = 11023104,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110231_18",
        QuestDeatil = "Content_110231_18",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign_11023104_01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17849829070753331625",
            startPort = "Out",
            endQuest = "17849829156833331823",
            endPort = "In"
          },
          {
            startQuest = "17849829156833331823",
            startPort = "Fail",
            endQuest = "17849829838393332565",
            endPort = "Input"
          },
          {
            startQuest = "17849829156833331823",
            startPort = "PassiveFail",
            endQuest = "17849829838393332565",
            endPort = "Input"
          },
          {
            startQuest = "17849829838393332565",
            startPort = "Out",
            endQuest = "17849830089433333250",
            endPort = "In"
          },
          {
            startQuest = "17849830089433333250",
            startPort = "Out",
            endQuest = "17849827159883329612",
            endPort = "Fail"
          },
          {
            startQuest = "17849827159883329606",
            startPort = "QuestStart",
            endQuest = "17849850837144998743",
            endPort = "In"
          },
          {
            startQuest = "17849850837144998743",
            startPort = "true",
            endQuest = "17849855122294999765",
            endPort = "In"
          },
          {
            startQuest = "17849855122294999765",
            startPort = "Out",
            endQuest = "17849829156833331823",
            endPort = "In"
          },
          {
            startQuest = "17849850837144998743",
            startPort = "false",
            endQuest = "17849829070753331625",
            endPort = "In"
          },
          {
            startQuest = "17849829156833331823",
            startPort = "Success",
            endQuest = "17867172650091668",
            endPort = "Input"
          },
          {
            startQuest = "17849829156833331823",
            startPort = "Success",
            endQuest = "17849827159883329609",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17849827159883329606"] = {
            key = "17849827159883329606",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 312.162172221371, y = 313.51351323486506},
            propsData = {ModeType = 0}
          },
          ["17849827159883329609"] = {
            key = "17849827159883329609",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2801.3513513234866, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17849827159883329612"] = {
            key = "17849827159883329612",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17849829070753331625"] = {
            key = "17849829070753331625",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1146.8108116188912, y = 792.540530425602},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790371,
              GuideType = "P",
              GuidePointName = "QuestSign_11023104_01"
            }
          },
          ["17849829156833331823"] = {
            key = "17849829156833331823",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1731.0303029835973, y = 374},
            propsData = {SpecialConfigId = 11023104, BlackScreenImmediately = true}
          },
          ["17849829719173332307"] = {
            key = "17849829719173332307",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2460.000000726609, y = 193.42857122096888},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = true,
              ForceWeatherType = -1
            }
          },
          ["17849829838393332565"] = {
            key = "17849829838393332565",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2170, y = 564},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = true,
              ForceWeatherType = -1
            }
          },
          ["17849830089433333250"] = {
            key = "17849830089433333250",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2393.2432433825675, y = 752.4324317636762},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 2,
              IsWhite = false
            }
          },
          ["17849850837144998743"] = {
            key = "17849850837144998743",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = 744.2218400746024, y = 303.7837892731583},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023104_Cave",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17849855122294999765"] = {
            key = "17849855122294999765",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1228.3784004752004, y = 241.62162839277877},
            propsData = {
              VarName = "ex02_11023104_Cave",
              VarValue = 1
            }
          },
          ["17867172650091668"] = {
            key = "17867172650091668",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2188.630779142955, y = 105.65151773528243},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
