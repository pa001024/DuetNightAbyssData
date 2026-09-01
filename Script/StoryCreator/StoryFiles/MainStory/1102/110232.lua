return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17822019566291",
      startPort = "StoryStart",
      endStory = "1782202017679268",
      endPort = "In"
    },
    {
      startStory = "17835153297578754604",
      startPort = "Success",
      endStory = "178352096637031754152",
      endPort = "In"
    },
    {
      startStory = "178352096637031754152",
      startPort = "Success",
      endStory = "17822019566305",
      endPort = "StoryEnd"
    },
    {
      startStory = "17835140737247108229",
      startPort = "Success",
      endStory = "17835150040128753713",
      endPort = "In"
    },
    {
      startStory = "17835150040128753713",
      startPort = "Success",
      endStory = "17835153297578754604",
      endPort = "In"
    },
    {
      startStory = "1782202017679268",
      startPort = "Success",
      endStory = "17835097783087107644",
      endPort = "In"
    },
    {
      startStory = "17835097783087107644",
      startPort = "Success",
      endStory = "17835140737247108229",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17822019566291"] = {
      isStoryNode = true,
      key = "17822019566291",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 802, y = 300},
      propsData = {QuestChainId = 110232},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17822019566305"] = {
      isStoryNode = true,
      key = "17822019566305",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 3038.7096744819187, y = 332.25806411917824},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782202017679268"] = {
      isStoryNode = true,
      key = "1782202017679268",
      type = "StoryNode",
      name = "伊薇被俘",
      pos = {x = 1270, y = 294.6486486765135},
      propsData = {
        QuestId = 11023201,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_1",
        QuestDeatil = "Content_110232_1",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "QuestSign11023201",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17834271234611634068",
            startPort = "Out",
            endQuest = "17834271161591633903",
            endPort = "In"
          },
          {
            startQuest = "17834276115891635063",
            startPort = "Out",
            endQuest = "17834276115891635062",
            endPort = "In"
          },
          {
            startQuest = "17834271161591633903",
            startPort = "Fail",
            endQuest = "17834276115891635063",
            endPort = "Input"
          },
          {
            startQuest = "17834271161591633903",
            startPort = "PassiveFail",
            endQuest = "17834276115891635063",
            endPort = "Input"
          },
          {
            startQuest = "17834276115891635062",
            startPort = "Out",
            endQuest = "1782202017679275",
            endPort = "Fail"
          },
          {
            startQuest = "17834299083614902425",
            startPort = "Out",
            endQuest = "17834271234611634068",
            endPort = "In"
          },
          {
            startQuest = "178352794159838346346",
            startPort = "Out",
            endQuest = "17834299083614902425",
            endPort = "In"
          },
          {
            startQuest = "17851419620673336489",
            startPort = "true",
            endQuest = "17851424480723337362",
            endPort = "In"
          },
          {
            startQuest = "17851424480723337362",
            startPort = "Out",
            endQuest = "178352794159838346346",
            endPort = "In"
          },
          {
            startQuest = "17851419620673336489",
            startPort = "false",
            endQuest = "17834299083614902425",
            endPort = "In"
          },
          {
            startQuest = "17834271161591633903",
            startPort = "Success",
            endQuest = "178748785543735268685",
            endPort = "Input"
          },
          {
            startQuest = "178748785543735268685",
            startPort = "Out",
            endQuest = "1782202017679272",
            endPort = "Success"
          },
          {
            startQuest = "1782202017679269",
            startPort = "QuestStart",
            endQuest = "178748604141528571888",
            endPort = "Input"
          },
          {
            startQuest = "178748604141528571888",
            startPort = "Out",
            endQuest = "17851419620673336489",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782202017679269"] = {
            key = "1782202017679269",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1046.3339838218621, y = 312.2715863435184},
            propsData = {ModeType = 0}
          },
          ["1782202017679272"] = {
            key = "1782202017679272",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107601,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1782202017679275"] = {
            key = "1782202017679275",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834271161591633903"] = {
            key = "17834271161591633903",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1668.2633519764313, y = 347.1428577397145},
            propsData = {SpecialConfigId = 11023201, BlackScreenImmediately = true}
          },
          ["17834271234611634068"] = {
            key = "17834271234611634068",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1246.8571477098528, y = 348.64233756099077},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780404,
              GuideType = "P",
              GuidePointName = "QuestSign11023201"
            }
          },
          ["17834276115891635061"] = {
            key = "17834276115891635061",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2210.345981133078, y = 51.33734267913627},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17834276115891635062"] = {
            key = "17834276115891635062",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2305.0958472645716, y = 531.6616147835894},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17834276115891635063"] = {
            key = "17834276115891635063",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2042.9041251242872, y = 469.9419827011131},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17834299083614902425"] = {
            key = "17834299083614902425",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 948.0548366927187, y = 333.6346654655482},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312780282,
                312780283,
                312780284,
                312780285,
                312780286,
                312780287,
                312780288,
                312780289,
                312780290,
                312780291,
                312780405,
                312780683,
                312780684,
                312780685,
                312780686,
                312780687,
                312780688,
                312780689,
                312780690,
                312780691,
                312780692,
                312780693,
                312780694,
                312780695,
                312780696,
                312780697,
                312780698
              }
            }
          },
          ["178352794159838346346"] = {
            key = "178352794159838346346",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 666.8481598698156, y = 117.6239727747574},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023201_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17842048235361655832"] = {
            key = "17842048235361655832",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 559.4285664980105, y = -209.42856213835648},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "SaveEveDestroy",
              UnitId = -1
            }
          },
          ["17851419620673336489"] = {
            key = "17851419620673336489",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = -131.29726873052408, y = 292.6963918849357},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023201_Eve",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17851424480723337362"] = {
            key = "17851424480723337362",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 218.13129449774598, y = 112.69639242989223},
            propsData = {
              VarName = "ex02_11023201_Eve",
              VarValue = 1
            }
          },
          ["178748604141528571888"] = {
            key = "178748604141528571888",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = -705.3059463656064, y = 347.0068370581031},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["178748785543735268685"] = {
            key = "178748785543735268685",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2078.583480456854, y = 288.0823722233816},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17835097783087107644"] = {
      isStoryNode = true,
      key = "17835097783087107644",
      type = "StoryNode",
      name = "兔妈妈Boss",
      pos = {x = 1194.7099568735218, y = 708.0561580269781},
      propsData = {
        QuestId = 11023202,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_4",
        QuestDeatil = "Content_110232_4",
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
        IsFairyLand = true,
        SubRegionId = 107601,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17835097783087107652",
            startPort = "Fail",
            endQuest = "17835097783087107655",
            endPort = "In"
          },
          {
            startQuest = "17835097783087107655",
            startPort = "Out",
            endQuest = "17835097783087107651",
            endPort = "Fail"
          },
          {
            startQuest = "17835097783087107652",
            startPort = "Success",
            endQuest = "17835097783087107650",
            endPort = "Success"
          },
          {
            startQuest = "17835097783087107652",
            startPort = "PassiveFail",
            endQuest = "17865554020191664",
            endPort = "Input"
          },
          {
            startQuest = "17865554020191664",
            startPort = "Out",
            endQuest = "17835097783087107651",
            endPort = "Fail"
          },
          {
            startQuest = "17835097783087107649",
            startPort = "QuestStart",
            endQuest = "17865577027003346268",
            endPort = "Input"
          },
          {
            startQuest = "17865577027003346268",
            startPort = "Out",
            endQuest = "17835097783087107652",
            endPort = "In"
          }
        },
        nodeData = {
          ["17835097783087107649"] = {
            key = "17835097783087107649",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 328.94738387109135, y = 331.57894599340284},
            propsData = {ModeType = 0}
          },
          ["17835097783087107650"] = {
            key = "17835097783087107650",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2919.35483818041, y = 295.16129046151343},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17835097783087107651"] = {
            key = "17835097783087107651",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2750, y = 754},
            propsData = {}
          },
          ["17835097783087107652"] = {
            key = "17835097783087107652",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1668.2633519764313, y = 347.1428577397145},
            propsData = {SpecialConfigId = 11023202, BlackScreenImmediately = true}
          },
          ["17835097783087107655"] = {
            key = "17835097783087107655",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2294.450686966626, y = 488.62935584578145},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17865554020191664"] = {
            key = "17865554020191664",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2163.9563004294855, y = 710.3315371767976},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["17865577027003346268"] = {
            key = "17865577027003346268",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1006.6392534918886, y = 376.1852002822448},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17835140737247108229"] = {
      isStoryNode = true,
      key = "17835140737247108229",
      type = "StoryNode",
      name = "了解兔妈妈的真相",
      pos = {x = 1814.5064072049597, y = 308.8947623283606},
      propsData = {
        QuestId = 11023203,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_5",
        QuestDeatil = "Content_110232_5",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BossFightTrigger_312790164",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17835147825507111413",
            startPort = "Out",
            endQuest = "17835148262467111891",
            endPort = "In"
          },
          {
            startQuest = "17835148262467111891",
            startPort = "Out",
            endQuest = "17835148518967112305",
            endPort = "In"
          },
          {
            startQuest = "17835148518967112305",
            startPort = "Out",
            endQuest = "17835149056027112768",
            endPort = "In"
          },
          {
            startQuest = "17835149056027112768",
            startPort = "Out",
            endQuest = "17835149542027113650",
            endPort = "In"
          },
          {
            startQuest = "17835149542027113650",
            startPort = "Out",
            endQuest = "17835140737247108235",
            endPort = "Success"
          },
          {
            startQuest = "17835142376407110193",
            startPort = "Out",
            endQuest = "17835147825507111413",
            endPort = "In"
          },
          {
            startQuest = "178514958356710004970",
            startPort = "true",
            endQuest = "178514958356710004971",
            endPort = "In"
          },
          {
            startQuest = "17854862107036626925",
            startPort = "Out",
            endQuest = "17835142376407110193",
            endPort = "In"
          },
          {
            startQuest = "17835140737247108234",
            startPort = "QuestStart",
            endQuest = "178749069690338617625",
            endPort = "Input"
          },
          {
            startQuest = "178749069690338617625",
            startPort = "Out",
            endQuest = "17854862107036626925",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17835140737247108234"] = {
            key = "17835140737247108234",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -583.7723160162172, y = 192.5872696083823},
            propsData = {ModeType = 0}
          },
          ["17835140737247108235"] = {
            key = "17835140737247108235",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3273.684220036642, y = 300},
            propsData = {ModeType = 0}
          },
          ["17835140737247108236"] = {
            key = "17835140737247108236",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17835142376407110193"] = {
            key = "17835142376407110193",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 571.7175246333611, y = 233.388620882337},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023203",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17835147825507111413"] = {
            key = "17835147825507111413",
            type = "TalkNode",
            name = "SQ_Ex02_FixSimple_50_1",
            pos = {x = 1072.702089468586, y = 273.5035973575151},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023118.11023118'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "BlendOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
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
              bLockHighestLOD = true,
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
          ["17835148262467111891"] = {
            key = "17835148262467111891",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1500.7020948396798, y = 283.5035989851193},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023126.11023126'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = false,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = true,
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
          ["17835148518967112305"] = {
            key = "17835148518967112305",
            type = "TalkNode",
            name = "SQ_Ex02_FixSimple_50_2",
            pos = {x = 1793.5592393514153, y = 298.93216695835355},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023119.11023119'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = true,
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
          ["17835149056027112768"] = {
            key = "17835149056027112768",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2128.0292817866625, y = 324.64645239237564},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023127.11023127'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = false,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = true,
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
          ["17835149542027113650"] = {
            key = "17835149542027113650",
            type = "TalkNode",
            name = "SQ_Ex02_FixSimple_50_3",
            pos = {x = 2396.4163756379367, y = 344.64645217439295},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023119_2.11023119_2'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = true,
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
          ["178351657627413681657"] = {
            key = "178351657627413681657",
            type = "GoToNode",
            name = "前往",
            pos = {x = 580.0015223970012, y = -117.28922626758072},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790164,
              GuideType = "M",
              GuidePointName = "Mechanism_BossFightTrigger_312790164"
            }
          },
          ["17839457414002219"] = {
            key = "17839457414002219",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 572, y = -348},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC013/SQ_Ver0105_SC013",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              bHideSceneEffects = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["178514958356710004970"] = {
            key = "178514958356710004970",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = -154.40639144748067, y = -225.96820330657303},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023203_AfterAda",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178514958356710004971"] = {
            key = "178514958356710004971",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 246.08600004836137, y = -265.5426750257936},
            propsData = {
              VarName = "ex02_11023203_AfterAda",
              VarValue = 1
            }
          },
          ["17854862107036626925"] = {
            key = "17854862107036626925",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 222.0975583432191, y = 255.07317030810424},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178749069690338617625"] = {
            key = "178749069690338617625",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = -199.951211524251, y = 192.14633813510457},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17835150040128753713"] = {
      isStoryNode = true,
      key = "17835150040128753713",
      type = "StoryNode",
      name = "富尔维斯Boss",
      pos = {x = 2085.6559771605816, y = 39.467855173686566},
      propsData = {
        QuestId = 11023204,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_6",
        QuestDeatil = "Content_110232_6",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BossFightTrigger_312790164",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17835150040128753724",
            startPort = "Out",
            endQuest = "17835150040128753723",
            endPort = "In"
          },
          {
            startQuest = "17835150040128753721",
            startPort = "Fail",
            endQuest = "17835150040128753724",
            endPort = "Input"
          },
          {
            startQuest = "17835150040128753721",
            startPort = "PassiveFail",
            endQuest = "17835150040128753724",
            endPort = "Input"
          },
          {
            startQuest = "17835150040128753723",
            startPort = "Out",
            endQuest = "17835150040128753720",
            endPort = "Fail"
          },
          {
            startQuest = "178548736341114909335",
            startPort = "true",
            endQuest = "178548736341114909336",
            endPort = "In"
          },
          {
            startQuest = "178548736341114909336",
            startPort = "Out",
            endQuest = "178548736341114909334",
            endPort = "In"
          },
          {
            startQuest = "178548736341114909335",
            startPort = "false",
            endQuest = "178548736341014909333",
            endPort = "In"
          },
          {
            startQuest = "178548736341114909334",
            startPort = "Out",
            endQuest = "17835150040128753721",
            endPort = "In"
          },
          {
            startQuest = "178548736341014909333",
            startPort = "Out",
            endQuest = "17835150040128753721",
            endPort = "In"
          },
          {
            startQuest = "17835150040128753718",
            startPort = "QuestStart",
            endQuest = "17874924213344085",
            endPort = "Input"
          },
          {
            startQuest = "17835150040128753721",
            startPort = "Success",
            endQuest = "17835150040128753719",
            endPort = "Success"
          },
          {
            startQuest = "17874924213344085",
            startPort = "Out",
            endQuest = "178548736341114909335",
            endPort = "In"
          }
        },
        nodeData = {
          ["17835150040128753718"] = {
            key = "17835150040128753718",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 100.742260874283, y = 312.34817720153694},
            propsData = {ModeType = 0}
          },
          ["17835150040128753719"] = {
            key = "17835150040128753719",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2914.516128562533, y = 309.67741931514365},
            propsData = {ModeType = 0}
          },
          ["17835150040128753720"] = {
            key = "17835150040128753720",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17835150040128753721"] = {
            key = "17835150040128753721",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1663.2990974469858, y = 341.1428577397145},
            propsData = {SpecialConfigId = 11023204, BlackScreenImmediately = true}
          },
          ["17835150040128753722"] = {
            key = "17835150040128753722",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2200.345981133078, y = 51.33734267913627},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17835150040128753723"] = {
            key = "17835150040128753723",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2301.0958472645716, y = 529.6616147835894},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17835150040128753724"] = {
            key = "17835150040128753724",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2040.9041251242872, y = 469.9419827011131},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178548736341014909333"] = {
            key = "178548736341014909333",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1094.8936716142348, y = 632.7900658790427},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790164,
              GuideType = "M",
              GuidePointName = "Mechanism_BossFightTrigger_312790164"
            }
          },
          ["178548736341114909334"] = {
            key = "178548736341114909334",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1368.6777435408776, y = 243.2099338484791},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023203",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178548736341114909335"] = {
            key = "178548736341114909335",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = 681.1063283857651, y = 333.20993357600076},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023204_Fuer",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178548736341114909336"] = {
            key = "178548736341114909336",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1030.5348916140351, y = 153.20993412095726},
            propsData = {
              VarName = "ex02_11023204_Fuer",
              VarValue = 1
            }
          },
          ["17874924213344085"] = {
            key = "17874924213344085",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 400.7179567352501, y = 306.51281319776456},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17835153297578754604"] = {
      isStoryNode = true,
      key = "17835153297578754604",
      type = "StoryNode",
      name = "逃离村庄",
      pos = {x = 2353.555262389696, y = 302.67342354668085},
      propsData = {
        QuestId = 11023205,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_7",
        QuestDeatil = "Content_110232_7",
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
        SubRegionId = 107101,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BossFightTrigger_312790164",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178351605779713678589",
            startPort = "Out",
            endQuest = "178351627578413679488",
            endPort = "In"
          },
          {
            startQuest = "178351632339413679919",
            startPort = "Out",
            endQuest = "17835153297578754611",
            endPort = "Fail"
          },
          {
            startQuest = "17851519163583334315",
            startPort = "Out",
            endQuest = "178351627578413679488",
            endPort = "In"
          },
          {
            startQuest = "17851519311163334622",
            startPort = "true",
            endQuest = "17851519311163334623",
            endPort = "In"
          },
          {
            startQuest = "17851519311163334623",
            startPort = "Out",
            endQuest = "17851519163583334315",
            endPort = "In"
          },
          {
            startQuest = "17851519311163334622",
            startPort = "false",
            endQuest = "178351605779713678589",
            endPort = "In"
          },
          {
            startQuest = "178351627578413679488",
            startPort = "Success",
            endQuest = "178548638424611594695",
            endPort = "Input"
          },
          {
            startQuest = "178548638424611594695",
            startPort = "Out",
            endQuest = "17835153297578754610",
            endPort = "Success"
          },
          {
            startQuest = "178351627578413679488",
            startPort = "Fail",
            endQuest = "178548639441511595005",
            endPort = "Input"
          },
          {
            startQuest = "178351627578413679488",
            startPort = "PassiveFail",
            endQuest = "178548639441511595005",
            endPort = "Input"
          },
          {
            startQuest = "178548639441511595005",
            startPort = "Out",
            endQuest = "178351632339413679919",
            endPort = "In"
          },
          {
            startQuest = "17835153297578754609",
            startPort = "QuestStart",
            endQuest = "17866397605732070",
            endPort = "In"
          },
          {
            startQuest = "17835153297578754609",
            startPort = "QuestStart",
            endQuest = "17874928557398377794",
            endPort = "Input"
          },
          {
            startQuest = "17874928557398377794",
            startPort = "Out",
            endQuest = "17851519311163334622",
            endPort = "In"
          }
        },
        nodeData = {
          ["17835153297578754609"] = {
            key = "17835153297578754609",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -671.7438436178913, y = -58.743627504753796},
            propsData = {ModeType = 0}
          },
          ["17835153297578754610"] = {
            key = "17835153297578754610",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2539.0872027431788, y = -255.30892668645245},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17835153297578754611"] = {
            key = "17835153297578754611",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2500.5224662615597, y = 57.001046286548046},
            propsData = {}
          },
          ["178351605779713678589"] = {
            key = "178351605779713678589",
            type = "GoToNode",
            name = "前往",
            pos = {x = 721.6233654185, y = 179.00870543135932},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312790164,
              GuideType = "M",
              GuidePointName = "Mechanism_BossFightTrigger_312790164"
            }
          },
          ["178351627578413679488"] = {
            key = "178351627578413679488",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1246.5542382185547, y = -164.4935929072847},
            propsData = {SpecialConfigId = 11023205, BlackScreenImmediately = false}
          },
          ["178351632339413679919"] = {
            key = "178351632339413679919",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1783.0058490444044, y = 273.4418903814885},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["17851519163583334315"] = {
            key = "17851519163583334315",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 543.4074373451429, y = -192.57142659920427},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023203",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17851519311163334622"] = {
            key = "17851519311163334622",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = -144.16397780996968, y = -102.5714268716826},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023205_AfterFuer",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17851519311163334623"] = {
            key = "17851519311163334623",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 205.2645854183004, y = -282.5714263267261},
            propsData = {
              VarName = "ex02_11023205_AfterFuer",
              VarValue = 1
            }
          },
          ["178548638424611594695"] = {
            key = "178548638424611594695",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1924, y = -282},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178548639441511595005"] = {
            key = "178548639441511595005",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1732, y = -46},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17866397605732070"] = {
            key = "17866397605732070",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -147.14284502405712, y = -518.5714256909428},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Fire_Destroy",
              UnitId = -1
            }
          },
          ["17874928557398377794"] = {
            key = "17874928557398377794",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = -400.7109858462809, y = -52.37779331329324},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["178352096637031754152"] = {
      isStoryNode = true,
      key = "178352096637031754152",
      type = "StoryNode",
      name = "结局",
      pos = {x = 2694.032112349455, y = 332.8982159059599},
      propsData = {
        QuestId = 11023206,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110232_8",
        QuestDeatil = "Content_110232_8",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Weijier_312780410",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178352096637131754165",
            startPort = "Out",
            endQuest = "178352096637131754166",
            endPort = "In"
          },
          {
            startQuest = "17851524447888331544",
            startPort = "true",
            endQuest = "17851524447888331543",
            endPort = "In"
          },
          {
            startQuest = "178352641542933404912",
            startPort = "Out",
            endQuest = "178352614949333404107",
            endPort = "In"
          },
          {
            startQuest = "178352614949333404107",
            startPort = "Out",
            endQuest = "178352096637131754165",
            endPort = "In"
          },
          {
            startQuest = "17851524447888331543",
            startPort = "Out",
            endQuest = "178352641542933404912",
            endPort = "In"
          },
          {
            startQuest = "17851524447888331544",
            startPort = "false",
            endQuest = "178352614949333404107",
            endPort = "In"
          },
          {
            startQuest = "178352951395643287729",
            startPort = "Out",
            endQuest = "178548648289713250858",
            endPort = "Input"
          },
          {
            startQuest = "178352096637131754166",
            startPort = "Fail",
            endQuest = "178548650861013251598",
            endPort = "Input"
          },
          {
            startQuest = "178352096637131754166",
            startPort = "PassiveFail",
            endQuest = "178548650861013251598",
            endPort = "Input"
          },
          {
            startQuest = "178548648289713250858",
            startPort = "Out",
            endQuest = "17856780008193322712",
            endPort = "In"
          },
          {
            startQuest = "17856780008193322712",
            startPort = "Out",
            endQuest = "178352096637031754158",
            endPort = "Success"
          },
          {
            startQuest = "178548650861013251598",
            startPort = "Out",
            endQuest = "17856780105953322901",
            endPort = "In"
          },
          {
            startQuest = "17856780105953322901",
            startPort = "Out",
            endQuest = "178352096637031754159",
            endPort = "Fail"
          },
          {
            startQuest = "178352096637031754157",
            startPort = "QuestStart",
            endQuest = "17872965813686720382",
            endPort = "In"
          },
          {
            startQuest = "178352096637031754157",
            startPort = "QuestStart",
            endQuest = "178749348046315077438",
            endPort = "Input"
          },
          {
            startQuest = "178749348046315077438",
            startPort = "Out",
            endQuest = "17851524447888331544",
            endPort = "In"
          },
          {
            startQuest = "178352951395643287728",
            startPort = "Out",
            endQuest = "178352951395643287729",
            endPort = "In"
          },
          {
            startQuest = "178774954478431316303",
            startPort = "Out",
            endQuest = "178352951395643287728",
            endPort = "In"
          },
          {
            startQuest = "178352096637131754166",
            startPort = "Success",
            endQuest = "178774954478431316303",
            endPort = "Input"
          },
          {
            startQuest = "178352951395643287729",
            startPort = "Out",
            endQuest = "17881705712221684689",
            endPort = "In"
          }
        },
        nodeData = {
          ["178352096637031754157"] = {
            key = "178352096637031754157",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1269.1305219805167, y = -153.84096428297102},
            propsData = {ModeType = 0}
          },
          ["178352096637031754158"] = {
            key = "178352096637031754158",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3626.662949821805, y = -38.7634734370842},
            propsData = {ModeType = 0}
          },
          ["178352096637031754159"] = {
            key = "178352096637031754159",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2500.5224662615597, y = 57.001046286548046},
            propsData = {}
          },
          ["178352096637131754165"] = {
            key = "178352096637131754165",
            type = "GoToNode",
            name = "前往",
            pos = {x = 765.9090788997544, y = -133.8484317426632},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780411,
              GuideType = "N",
              GuidePointName = "Npc_Weijier_312780410"
            }
          },
          ["178352096637131754166"] = {
            key = "178352096637131754166",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1246.5542382185547, y = -164.4935929072847},
            propsData = {SpecialConfigId = 11023206, BlackScreenImmediately = true}
          },
          ["178352614949333404107"] = {
            key = "178352614949333404107",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 431.9392182292963, y = -163.22886328772114},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780410}
            }
          },
          ["178352641542933404912"] = {
            key = "178352641542933404912",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 170.68381488897143, y = -335.7829729250319},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023206_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178352951395643287728"] = {
            key = "178352951395643287728",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2136.7865346631606, y = -356.35003191986044},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TeleportPoint11023206_02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178352951395643287729"] = {
            key = "178352951395643287729",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2636.562183308991, y = -370.62232836579676},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110231/11023125.11023125'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
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
          ["17851524447888331543"] = {
            key = "17851524447888331543",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -173.28570003898795, y = -377.14284565984013},
            propsData = {
              VarName = "ex02_11023206_End",
              VarValue = 1
            }
          },
          ["17851524447888331544"] = {
            key = "17851524447888331544",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量=0",
            pos = {x = -522.7142632672579, y = -197.14284620479668},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11023206_End",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["178548648289713250858"] = {
            key = "178548648289713250858",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2980.545445227645, y = -248.36363734445843},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178548650861013251598"] = {
            key = "178548650861013251598",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1656, y = -64},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17856780008193322712"] = {
            key = "17856780008193322712",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 3297.641011532122, y = -266.33458609245014},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17856780105953322901"] = {
            key = "17856780105953322901",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2128.2307130871172, y = 71.44087662661971},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17872965813686720382"] = {
            key = "17872965813686720382",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -482, y = -596},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Joystick_Lower_11023206",
              UnitId = -1
            }
          },
          ["178749348046315077438"] = {
            key = "178749348046315077438",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = -902.6656826590861, y = -163.5872792861886},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = true
            }
          },
          ["178774954478431316303"] = {
            key = "178774954478431316303",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1763.7724906954243, y = -347.51490174043056},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["17881705712221684689"] = {
            key = "17881705712221684689",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2934.90321395747, y = -447.74193895719054},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
