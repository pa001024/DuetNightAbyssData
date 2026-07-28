return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17809159420611",
      startPort = "StoryStart",
      endStory = "178091594910085",
      endPort = "In"
    },
    {
      startStory = "178091594910085",
      startPort = "Success",
      endStory = "17809159420625",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17809159420611"] = {
      isStoryNode = true,
      key = "17809159420611",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17809159420625"] = {
      isStoryNode = true,
      key = "17809159420625",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178091594910085"] = {
      isStoryNode = true,
      key = "178091594910085",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1348, y = 350},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110214_3",
        QuestDeatil = "Content_110214_3",
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178091594910086",
            startPort = "QuestStart",
            endQuest = "17809186452371014490",
            endPort = "In"
          },
          {
            startQuest = "17809186452371014490",
            startPort = "Out",
            endQuest = "17809202999701015452",
            endPort = "In"
          },
          {
            startQuest = "17809202999701015452",
            startPort = "Out",
            endQuest = "17809213274861016948",
            endPort = "In"
          },
          {
            startQuest = "17809213274861016948",
            startPort = "Out",
            endQuest = "17809218464671018676",
            endPort = "In"
          },
          {
            startQuest = "17809218464671018676",
            startPort = "Out",
            endQuest = "17809219111391019660",
            endPort = "In"
          },
          {
            startQuest = "17809253182861020697",
            startPort = "Out",
            endQuest = "17809253182861020698",
            endPort = "In"
          },
          {
            startQuest = "17809219111391019660",
            startPort = "Out",
            endQuest = "17809253708611021733",
            endPort = "In"
          },
          {
            startQuest = "17809253708611021733",
            startPort = "Out",
            endQuest = "17809253182861020697",
            endPort = "In"
          },
          {
            startQuest = "17809253182861020698",
            startPort = "Out",
            endQuest = "17809254969741024150",
            endPort = "In"
          },
          {
            startQuest = "17809254969741024150",
            startPort = "Out",
            endQuest = "17809255281591024620",
            endPort = "In"
          },
          {
            startQuest = "17809255395781025094",
            startPort = "Out",
            endQuest = "17809255395781025095",
            endPort = "In"
          },
          {
            startQuest = "17809255395781025095",
            startPort = "Out",
            endQuest = "17809255395781025097",
            endPort = "In"
          },
          {
            startQuest = "17809255281591024620",
            startPort = "Out",
            endQuest = "17809255395781025096",
            endPort = "In"
          },
          {
            startQuest = "17809255395781025096",
            startPort = "Out",
            endQuest = "17809257736041026167",
            endPort = "In"
          },
          {
            startQuest = "17809257736041026167",
            startPort = "Out",
            endQuest = "17809258060201026790",
            endPort = "In"
          },
          {
            startQuest = "178091594910086",
            startPort = "QuestStart",
            endQuest = "17809259517261028650",
            endPort = "In"
          },
          {
            startQuest = "17809259517261028650",
            startPort = "Out",
            endQuest = "1780915949100102",
            endPort = "Fail"
          },
          {
            startQuest = "17809258060201026790",
            startPort = "Out",
            endQuest = "17809259931871029799",
            endPort = "In"
          },
          {
            startQuest = "17809259931871029799",
            startPort = "Out",
            endQuest = "17809255395781025094",
            endPort = "In"
          },
          {
            startQuest = "17809255395781025097",
            startPort = "Out",
            endQuest = "17809258930871028060",
            endPort = "In"
          },
          {
            startQuest = "17809258930871028060",
            startPort = "Out",
            endQuest = "17809261569091031281",
            endPort = "In"
          },
          {
            startQuest = "17809261569091031281",
            startPort = "Out",
            endQuest = "17809262416051032733",
            endPort = "In"
          },
          {
            startQuest = "178091594910086",
            startPort = "QuestStart",
            endQuest = "17809263798713058660",
            endPort = "Input"
          }
        },
        nodeData = {
          ["178091594910086"] = {
            key = "178091594910086",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 802, y = 300},
            propsData = {ModeType = 0}
          },
          ["178091594910094"] = {
            key = "178091594910094",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3110.606055818715, y = 180.3030321479099},
            propsData = {ModeType = 0}
          },
          ["1780915949100102"] = {
            key = "1780915949100102",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1115.3153446728525, y = 1193.6117844276023},
            propsData = {}
          },
          ["17809186452371014490"] = {
            key = "17809186452371014490",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1077.1466310329322, y = 320.87929213956284},
            propsData = {QuestRoleId = 1040101, IsPlayFX = false}
          },
          ["17809202999701015452"] = {
            key = "17809202999701015452",
            type = "ChangeStaticCreatorNode",
            name = "生成/第一个交互点",
            pos = {x = 1445.0909097214376, y = -126.36363194993712},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780021}
            }
          },
          ["17809213274861016948"] = {
            key = "17809213274861016948",
            type = "PickUpNode",
            name = "拾取第一个物品",
            pos = {x = 1461.2808665441542, y = 42.228960085284974},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780021},
              QuestPickupId = -1,
              UnitId = 11021401,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign1102140201",
              IsUseCount = false
            }
          },
          ["17809218464671018676"] = {
            key = "17809218464671018676",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1440.0687456589737, y = 227.07744208471522},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11109201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809219111391019660"] = {
            key = "17809219111391019660",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1452.96800819758, y = 421.71298368517523},
            propsData = {
              NewDescription = "Description_110214_4",
              NewDetail = "Content_110214_4",
              SubTaskTargetIndex = 0
            }
          },
          ["17809253182861020697"] = {
            key = "17809253182861020697",
            type = "ChangeStaticCreatorNode",
            name = "生成/第二个交互点",
            pos = {x = 1870.4390571210834, y = -133.7095655306966},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780022}
            }
          },
          ["17809253182861020698"] = {
            key = "17809253182861020698",
            type = "PickUpNode",
            name = "拾取第二个物品",
            pos = {x = 1876.9515947080467, y = 21.979800856854183},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780022},
              QuestPickupId = -1,
              UnitId = 11021402,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign1102140202",
              IsUseCount = false
            }
          },
          ["17809253708611021733"] = {
            key = "17809253708611021733",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1873.402070772084, y = -316.86194578292304},
            propsData = {
              NewDescription = "Description_110214_5",
              NewDetail = "Content_110214_5",
              SubTaskTargetIndex = 0
            }
          },
          ["17809254969741024150"] = {
            key = "17809254969741024150",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1876.4323737556813, y = 207.3804703793954},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11109301,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809255281591024620"] = {
            key = "17809255281591024620",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1856.7354043622993, y = 424.04713370659664},
            propsData = {
              NewDescription = "Description_110214_4",
              NewDetail = "Content_110214_4",
              SubTaskTargetIndex = 0
            }
          },
          ["17809255395781025094"] = {
            key = "17809255395781025094",
            type = "ChangeStaticCreatorNode",
            name = "生成/第三个交互点",
            pos = {x = 2298.640419015128, y = 315.5084138202078},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780023}
            }
          },
          ["17809255395781025095"] = {
            key = "17809255395781025095",
            type = "PickUpNode",
            name = "拾取第三个物品",
            pos = {x = 2316.3455273296427, y = 484.1010058554299},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780023},
              QuestPickupId = -1,
              UnitId = 11021403,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign1102140203",
              IsUseCount = false
            }
          },
          ["17809255395781025096"] = {
            key = "17809255395781025096",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2284.008125049507, y = -360.8013390450827},
            propsData = {
              NewDescription = "Description_110214_6",
              NewDetail = "Content_110214_6",
              SubTaskTargetIndex = 0
            }
          },
          ["17809255395781025097"] = {
            key = "17809255395781025097",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2315.826306377277, y = 666.4713723943738},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11109401,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809257736041026167"] = {
            key = "17809257736041026167",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2296.129338525188, y = -182.01346070090915},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780024,
              GuideType = "P",
              GuidePointName = "QuestSign1102140203"
            }
          },
          ["17809258060201026790"] = {
            key = "17809258060201026790",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2287.0384295743966, y = 2.835021298521198},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110214/11021402.11021402'",
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
          ["17809258930871028060"] = {
            key = "17809258930871028060",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2693.8869077205977, y = -397.020188354103},
            propsData = {
              NewDescription = "Description_110214_7",
              NewDetail = "Content_110214_7",
              SubTaskTargetIndex = 0
            }
          },
          ["17809259517261028650"] = {
            key = "17809259517261028650",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 458.41438252638056, y = 1125.2346748225461},
            propsData = {}
          },
          ["17809259931871029799"] = {
            key = "17809259931871029799",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2274.1948378538227, y = 171.27808523081194},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780025}
            }
          },
          ["17809261569091031281"] = {
            key = "17809261569091031281",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2693.504711994455, y = -231.76980794760144},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111001,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Eve_312780025",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110214/11021403.11021403'",
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
          ["17809262416051032733"] = {
            key = "17809262416051032733",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2707.1506637232856, y = 19.106043097895203},
            propsData = {}
          },
          ["17809263798713058660"] = {
            key = "17809263798713058660",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1111.9893930299222, y = -174.44234161717418},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = 0
            }
          }
        },
        commentData = {
          ["17810118252341189"] = {
            key = "17810118252341189",
            name = "第一件物品+战斗",
            position = {x = 1421.4061733691346, y = -277.77202631920557},
            size = {width = 291.8433941852351, height = 1299.5816037491084}
          },
          ["17810118421781495"] = {
            key = "17810118421781495",
            name = "第二件物品+战斗",
            position = {x = 1814.9545556231092, y = -397.1268635601651},
            size = {width = 294.2409497128072, height = 1512.1796823106367}
          },
          ["17810118992842779"] = {
            key = "17810118992842779",
            name = "第三件物品",
            position = {x = 2245.6819890080533, y = -447.10931119993035},
            size = {width = 363.5135060178705, height = 1332.4324049576958}
          }
        }
      }
    }
  },
  commentData = {}
}
