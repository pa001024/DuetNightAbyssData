return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1780920816025330",
      startPort = "Success",
      endStory = "1780920816025331",
      endPort = "In"
    },
    {
      startStory = "1780920816025331",
      startPort = "Success",
      endStory = "1780920816025332",
      endPort = "In"
    },
    {
      startStory = "1780920816025332",
      startPort = "Success",
      endStory = "1780920816026333",
      endPort = "In"
    },
    {
      startStory = "17809207183421",
      startPort = "StoryStart",
      endStory = "1780920816025330",
      endPort = "In"
    },
    {
      startStory = "1780920816026333",
      startPort = "Success",
      endStory = "1780920816026335",
      endPort = "In"
    },
    {
      startStory = "1780920816026335",
      startPort = "Success",
      endStory = "17809207183425",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17809207183421"] = {
      isStoryNode = true,
      key = "17809207183421",
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
    ["17809207183425"] = {
      isStoryNode = true,
      key = "17809207183425",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1837.6785714285713, y = 499.2857142857143},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1780920816025330"] = {
      isStoryNode = true,
      key = "1780920816025330",
      type = "StoryNode",
      name = "到达乐园",
      pos = {x = 1150.552507307453, y = 257.449336558405},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03a",
        QuestDeatil = "Content_110201_03a",
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
            startQuest = "1780920816036376",
            startPort = "Out",
            endQuest = "1780920816035374",
            endPort = "In"
          },
          {
            startQuest = "1780920816036377",
            startPort = "Out",
            endQuest = "17809915089412056140",
            endPort = "In"
          },
          {
            startQuest = "17809915089412056140",
            startPort = "Out",
            endQuest = "1780920816034371",
            endPort = "Success"
          },
          {
            startQuest = "17811700175691030170",
            startPort = "Out",
            endQuest = "17809911866472053604",
            endPort = "In"
          },
          {
            startQuest = "17809911866472053604",
            startPort = "true",
            endQuest = "17812308953507166",
            endPort = "In"
          },
          {
            startQuest = "17809911866472053604",
            startPort = "false",
            endQuest = "1780920816034371",
            endPort = "Success"
          },
          {
            startQuest = "1780920816035373",
            startPort = "Out",
            endQuest = "1780920816036376",
            endPort = "In"
          },
          {
            startQuest = "17812308953507166",
            startPort = "Out",
            endQuest = "17827173667691078753",
            endPort = "In"
          },
          {
            startQuest = "17827173667691078753",
            startPort = "Out",
            endQuest = "1780920816035373",
            endPort = "In"
          },
          {
            startQuest = "178291481094815105531",
            startPort = "Out",
            endQuest = "17811700175691030170",
            endPort = "In"
          },
          {
            startQuest = "17812308953507166",
            startPort = "Out",
            endQuest = "1780920816035375",
            endPort = "In"
          },
          {
            startQuest = "178704365008212288070",
            startPort = "Out",
            endQuest = "1780920816036377",
            endPort = "In"
          },
          {
            startQuest = "1780920816034370",
            startPort = "QuestStart",
            endQuest = "178291481094815105531",
            endPort = "Input"
          },
          {
            startQuest = "17827173667691078753",
            startPort = "Out",
            endQuest = "17879144202635591143",
            endPort = "In"
          },
          {
            startQuest = "1780920816035374",
            startPort = "Out",
            endQuest = "17879150304767825018",
            endPort = "In"
          },
          {
            startQuest = "17879150304767825018",
            startPort = "Out",
            endQuest = "178704365008212288070",
            endPort = "Input"
          }
        },
        nodeData = {
          ["1780920816034370"] = {
            key = "1780920816034370",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1134.8677383997083, y = 216.10053586652046},
            propsData = {ModeType = 0}
          },
          ["1780920816034371"] = {
            key = "1780920816034371",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2244.4886363636365, y = 415.73863636363615},
            propsData = {ModeType = 0}
          },
          ["1780920816035372"] = {
            key = "1780920816035372",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816035373"] = {
            key = "1780920816035373",
            type = "TalkNode",
            name = "【区介】EX02_SpecialShow_01",
            pos = {x = 932.9314000513534, y = -12.603372670525781},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/AssetDesign/Story/DialogueSequence/MainStory/1102/110201/SQ_EX02_SpecialShow_01.SQ_EX02_SpecialShow_01'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = false,
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
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1780920816035374"] = {
            key = "1780920816035374",
            type = "TalkNode",
            name = "【Ex02_FixSimple_05】乐园门口",
            pos = {x = 1558.5234609317404, y = 28.18524115420051},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020105.11020105'",
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
          ["1780920816035375"] = {
            key = "1780920816035375",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 620.3827622047206, y = -326.99658186336984},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790004}
            }
          },
          ["1780920816036376"] = {
            key = "1780920816036376",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1267.94551478905, y = -6.049917079749675},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790005,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_gate_142790005"
            }
          },
          ["1780920816036377"] = {
            key = "1780920816036377",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 2354.858672398251, y = -47.71642710485755},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790004}
            }
          },
          ["17809892461822051579"] = {
            key = "17809892461822051579",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1498.487658693036, y = 690.6743147601554},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebieth02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17809911866472053604"] = {
            key = "17809911866472053604",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 65.9610886447257, y = 217.40080346036956},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17809915089412056140"] = {
            key = "17809915089412056140",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2417.7233729787504, y = 134.1556812197825},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 1
            }
          },
          ["17811700175691030170"] = {
            key = "17811700175691030170",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -216.19910465407725, y = 210.44444444444443},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["17812308953507166"] = {
            key = "17812308953507166",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 272.3006535947711, y = 52.172735760971094},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17827173667691078753"] = {
            key = "17827173667691078753",
            type = "GoToNode",
            name = "前往",
            pos = {x = 595.8342613754033, y = -20.23679889378581},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790117,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_quyu_142790117"
            }
          },
          ["178291481094815105531"] = {
            key = "178291481094815105531",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -534.4583333333335, y = 202.66666666666632},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178704365008212288070"] = {
            key = "178704365008212288070",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2074.3504268984484, y = -52.98932513508821},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["178766538275821231843"] = {
            key = "178766538275821231843",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -846.5380555976536, y = 466.90921333568366},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790445}
            }
          },
          ["17879144202635591143"] = {
            key = "17879144202635591143",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 970.5630252100826, y = -180.29946524064124},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/1_6/0183_scene_park",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107101},
              bStoreToServer = true
            }
          },
          ["17879150304767825018"] = {
            key = "17879150304767825018",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1816.6782697268618, y = -25.305277842361704},
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
    ["1780920816025331"] = {
      isStoryNode = true,
      key = "1780920816025331",
      type = "StoryNode",
      name = "打靶",
      pos = {x = 1483.4838392605238, y = 252.59370590034482},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03b",
        QuestDeatil = "Content_110201_03b",
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
            startQuest = "1780920816042405",
            startPort = "QuestStart",
            endQuest = "17809919312922058396",
            endPort = "In"
          },
          {
            startQuest = "17809914840822055457",
            startPort = "Out",
            endQuest = "1780920816042408",
            endPort = "In"
          },
          {
            startQuest = "17809919635672059236",
            startPort = "Out",
            endQuest = "17809929683563081293",
            endPort = "In"
          },
          {
            startQuest = "1780920816043412",
            startPort = "Out",
            endQuest = "17809937527233084733",
            endPort = "In"
          },
          {
            startQuest = "17809937527233084733",
            startPort = "Out",
            endQuest = "1780920816042406",
            endPort = "Success"
          },
          {
            startQuest = "17809919312922058396",
            startPort = "false",
            endQuest = "1780920816042406",
            endPort = "Success"
          },
          {
            startQuest = "17809914840822055457",
            startPort = "Out",
            endQuest = "17809919635672059236",
            endPort = "In"
          },
          {
            startQuest = "1780920816042408",
            startPort = "Out",
            endQuest = "17860222857142464",
            endPort = "In"
          },
          {
            startQuest = "17860222857142464",
            startPort = "Out",
            endQuest = "17860223825971117359",
            endPort = "In"
          },
          {
            startQuest = "17860043424982168",
            startPort = "Out",
            endQuest = "178704393765413404488",
            endPort = "Input"
          },
          {
            startQuest = "178704393765413404488",
            startPort = "Out",
            endQuest = "1780920816043412",
            endPort = "In"
          },
          {
            startQuest = "17809914840822055457",
            startPort = "Out",
            endQuest = "178704555868916757224",
            endPort = "In"
          },
          {
            startQuest = "178705201224922339032",
            startPort = "Out",
            endQuest = "17860043424982168",
            endPort = "In"
          },
          {
            startQuest = "178705201224922339032",
            startPort = "Out",
            endQuest = "178704979106620105868",
            endPort = "In"
          },
          {
            startQuest = "17860223825971117359",
            startPort = "Out",
            endQuest = "178705201224922339032",
            endPort = "In"
          },
          {
            startQuest = "17860223825971117359",
            startPort = "Out",
            endQuest = "17871411072342702",
            endPort = "In"
          },
          {
            startQuest = "17860223825971117359",
            startPort = "Out",
            endQuest = "178731988468214576654",
            endPort = "In"
          },
          {
            startQuest = "17809919312922058396",
            startPort = "true",
            endQuest = "17893538661691976",
            endPort = "In"
          },
          {
            startQuest = "17893538661691976",
            startPort = "Fail",
            endQuest = "17809914840822055457",
            endPort = "In"
          },
          {
            startQuest = "17893538661691976",
            startPort = "Success",
            endQuest = "17809937527233084733",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816042405"] = {
            key = "1780920816042405",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 98.29914529914521, y = 368.6923076923077},
            propsData = {ModeType = 0}
          },
          ["1780920816042406"] = {
            key = "1780920816042406",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3436.836007130125, y = 635.7754010695187},
            propsData = {ModeType = 0}
          },
          ["1780920816042407"] = {
            key = "1780920816042407",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2130, y = 765},
            propsData = {}
          },
          ["1780920816042408"] = {
            key = "1780920816042408",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1197.1553884711777, y = 212.2276524644946},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142790014,
              GuideType = "P",
              GuidePointName = "ex02_tp_daba"
            }
          },
          ["1780920816043409"] = {
            key = "1780920816043409",
            type = "TalkNode",
            name = "【Ex02_FixSimple_06】打靶",
            pos = {x = 2546.542087616684, y = -344.0098738626964},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020106.11020106'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
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
          ["1780920816043412"] = {
            key = "1780920816043412",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 2737.818012554142, y = 191.8572264746701},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790009, 292790478}
            }
          },
          ["17809914840822055457"] = {
            key = "17809914840822055457",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 923.2932181345224, y = 229.53526570048314},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebieth02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17809919312922058396"] = {
            key = "17809919312922058396",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 324.7179045592088, y = 688.5839947492121},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17809919635672059236"] = {
            key = "17809919635672059236",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1154.7340783495763, y = -256.13856942496494},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790009}
            }
          },
          ["17809929683563081293"] = {
            key = "17809929683563081293",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1459.5799998938319, y = -251.90724008999769},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809937527233084733"] = {
            key = "17809937527233084733",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2901.8525154371455, y = 444.3317743194753},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 2
            }
          },
          ["17860043157161742"] = {
            key = "17860043157161742",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1532.5851664221311, y = 1130.1534027421562},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "QuestShootStart",
              UnitId = -1
            }
          },
          ["17860043424982168"] = {
            key = "17860043424982168",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 2215.047717332547, y = -48.24347940930762},
            propsData = {
              SendMessage = "",
              FinishCondition = "QuestShootEnd"
            }
          },
          ["17860222857142464"] = {
            key = "17860222857142464",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1469.988839887793, y = 159.88620928920756},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292790478}
            }
          },
          ["17860223825971117359"] = {
            key = "17860223825971117359",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1707.7296823379672, y = 90.82385068918236},
            propsData = {
              StaticCreatorIdList = {292790478},
              ManualItemIdList = {},
              StateId = 950001,
              QuestId = 0
            }
          },
          ["178704393765413404488"] = {
            key = "178704393765413404488",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2475.3768115942025, y = 35.00000000000004},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["178704555868916757224"] = {
            key = "178704555868916757224",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1242.434621044814, y = -18.45542077610982},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_daba"
            }
          },
          ["178704979106620105868"] = {
            key = "178704979106620105868",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2220.1700353497677, y = 173.99765393552977},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_daba"
            }
          },
          ["178705201224922339032"] = {
            key = "178705201224922339032",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1958.3723179925673, y = 79.1727289188763},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 292790478,
              StateId = 950002,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17871411072342702"] = {
            key = "17871411072342702",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1952.251406488249, y = -136.76275697986196},
            propsData = {
              NewDescription = "Description_110201_03g",
              NewDetail = "Content_110201_03g",
              SubTaskTargetIndex = 0
            }
          },
          ["178731988468214576654"] = {
            key = "178731988468214576654",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1937.595746716293, y = 314.47583664378305},
            propsData = {GuideId = 162}
          },
          ["17893538661691976"] = {
            key = "17893538661691976",
            type = "ConditionNode",
            name = "条件节点",
            pos = {x = 649.0745920745919, y = 461.7599067599067},
            propsData = {ConditionId = 7086048}
          }
        },
        commentData = {}
      }
    },
    ["1780920816025332"] = {
      isStoryNode = true,
      key = "1780920816025332",
      type = "StoryNode",
      name = "悬转木马",
      pos = {x = 1788.4741050723185, y = 249.15141639406355},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03c",
        QuestDeatil = "Content_110201_03c",
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
            startQuest = "17809964969204106769",
            startPort = "Out",
            endQuest = "17809965419164107427",
            endPort = "In"
          },
          {
            startQuest = "1780920816049440",
            startPort = "QuestStart",
            endQuest = "17809965673334107992",
            endPort = "In"
          },
          {
            startQuest = "1780920816050447",
            startPort = "Out",
            endQuest = "17809965873024108668",
            endPort = "In"
          },
          {
            startQuest = "17809965873024108668",
            startPort = "Out",
            endQuest = "1780920816049441",
            endPort = "Success"
          },
          {
            startQuest = "17809965673334107992",
            startPort = "true",
            endQuest = "17812347739004178439",
            endPort = "In"
          },
          {
            startQuest = "17809965673334107992",
            startPort = "false",
            endQuest = "1780920816049441",
            endPort = "Success"
          },
          {
            startQuest = "1780920816049443",
            startPort = "Out",
            endQuest = "1780920816049444",
            endPort = "In"
          },
          {
            startQuest = "17812347739004178439",
            startPort = "Out",
            endQuest = "17868745995587814066",
            endPort = "In"
          },
          {
            startQuest = "17868745995587814066",
            startPort = "Out",
            endQuest = "1780920816049443",
            endPort = "In"
          },
          {
            startQuest = "17868745995587814066",
            startPort = "Out",
            endQuest = "17809964969204106769",
            endPort = "In"
          },
          {
            startQuest = "1780920816049444",
            startPort = "Out",
            endQuest = "178704414129714521631",
            endPort = "Input"
          },
          {
            startQuest = "178704414129714521631",
            startPort = "Out",
            endQuest = "1780920816050447",
            endPort = "In"
          },
          {
            startQuest = "17868745995587814066",
            startPort = "Out",
            endQuest = "17884364855001128582",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816049440"] = {
            key = "1780920816049440",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 224.5798319327731, y = 311.9117647058824},
            propsData = {ModeType = 0}
          },
          ["1780920816049441"] = {
            key = "1780920816049441",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2294.698879551821, y = 558.3963585434174},
            propsData = {ModeType = 0}
          },
          ["1780920816049442"] = {
            key = "1780920816049442",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816049443"] = {
            key = "1780920816049443",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1529.1218487394956, y = 223.96638655462186},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790006,
              GuideType = "N",
              GuidePointName = "Npc_ex02_eveyinlu03_142790010"
            }
          },
          ["1780920816049444"] = {
            key = "1780920816049444",
            type = "TalkNode",
            name = "【Ex02_FixSimple_07】旋转木马",
            pos = {x = 1787.2250558194296, y = 235.18394430235867},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020107.11020107'",
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
          ["1780920816050447"] = {
            key = "1780920816050447",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 2317.255800923771, y = 252.1683947996225},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790010}
            }
          },
          ["17809964969204106769"] = {
            key = "17809964969204106769",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1439.94235881078, y = 9.793498168498054},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790010}
            }
          },
          ["17809965419164107427"] = {
            key = "17809965419164107427",
            type = "TalkNode",
            name = "开车",
            pos = {x = 1744.3709302393515, y = -9.246602082128462},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809965673334107992"] = {
            key = "17809965673334107992",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 536.0590362509867, y = 349.2898124836979},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17809965873024108668"] = {
            key = "17809965873024108668",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2695.693590337874, y = 358.48656704759236},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 3
            }
          },
          ["17812347739004178439"] = {
            key = "17812347739004178439",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 932.3235294117649, y = 221.91176470588226},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth03",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17868745995587814066"] = {
            key = "17868745995587814066",
            type = "TalkNode",
            name = "【Ex02_FixSimple_06】打靶",
            pos = {x = 1219, y = 231.25},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020106.11020106'",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
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
          ["178704414129714521631"] = {
            key = "178704414129714521631",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2042.5, y = 207.76136363636363},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["17884364855001128582"] = {
            key = "17884364855001128582",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1531.0327000365364, y = 383.05407380343433},
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
    ["1780920816026333"] = {
      isStoryNode = true,
      key = "1780920816026333",
      type = "StoryNode",
      name = "前往吧台",
      pos = {x = 1127.5934702501509, y = 500.8261663752653},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03d",
        QuestDeatil = "Content_110201_03d",
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
            startQuest = "1780920816057478",
            startPort = "Out",
            endQuest = "1780920816057481",
            endPort = "In"
          },
          {
            startQuest = "17809973755635132965",
            startPort = "false",
            endQuest = "1780920816056476",
            endPort = "Success"
          },
          {
            startQuest = "17810026587666155539",
            startPort = "Out",
            endQuest = "1780920816056476",
            endPort = "Success"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "17810053683896160800",
            endPort = "In"
          },
          {
            startQuest = "17810087121216168859",
            startPort = "Out",
            endQuest = "17810026587666155539",
            endPort = "In"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "17811485314391024639",
            endPort = "In"
          },
          {
            startQuest = "17809973755635132965",
            startPort = "true",
            endQuest = "17812349675524179745",
            endPort = "In"
          },
          {
            startQuest = "17812349675524179745",
            startPort = "Out",
            endQuest = "1780920816057478",
            endPort = "In"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "178126636428716681193",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "17853294883514419028",
            endPort = "In"
          },
          {
            startQuest = "17853294883514419028",
            startPort = "Out",
            endQuest = "17853294954764419266",
            endPort = "In"
          },
          {
            startQuest = "17812349675524179745",
            startPort = "Out",
            endQuest = "17810025827805136321",
            endPort = "In"
          },
          {
            startQuest = "178533606327511041897",
            startPort = "Out",
            endQuest = "178533618742011043377",
            endPort = "Input_1"
          },
          {
            startQuest = "178533615585611042853",
            startPort = "Out",
            endQuest = "178533618742011043377",
            endPort = "Input_2"
          },
          {
            startQuest = "178533618742011043377",
            startPort = "Out",
            endQuest = "17853332708466627988",
            endPort = "In"
          },
          {
            startQuest = "178533618742011043377",
            startPort = "Out",
            endQuest = "1780920816057482",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "178533625354711044401",
            endPort = "In"
          },
          {
            startQuest = "178533618742011043377",
            startPort = "Out",
            endQuest = "178533630181912147753",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "178533606327511041897",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "178533615585611042853",
            endPort = "In"
          },
          {
            startQuest = "178533618742011043377",
            startPort = "Out",
            endQuest = "178533615585611042853",
            endPort = "Stop"
          },
          {
            startQuest = "178533618742011043377",
            startPort = "Out",
            endQuest = "178533606327511041897",
            endPort = "Stop"
          },
          {
            startQuest = "1780920816056475",
            startPort = "QuestStart",
            endQuest = "17865226696382490",
            endPort = "In"
          },
          {
            startQuest = "1780920816057482",
            startPort = "Out",
            endQuest = "178704420391015638852",
            endPort = "Input"
          },
          {
            startQuest = "178704420391015638852",
            startPort = "Out",
            endQuest = "17810087121216168859",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "178705730678729039989",
            endPort = "In"
          },
          {
            startQuest = "178705730678729039989",
            startPort = "Out",
            endQuest = "178705735078329040919",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "178731993819615695330",
            endPort = "In"
          },
          {
            startQuest = "17865226696382490",
            startPort = "Out",
            endQuest = "17809973755635132965",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816056475"] = {
            key = "1780920816056475",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -308.409145034532, y = 562.7978090021434},
            propsData = {ModeType = 0}
          },
          ["1780920816056476"] = {
            key = "1780920816056476",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3088.5391553750683, y = 896.9040314690469},
            propsData = {ModeType = 0}
          },
          ["1780920816056477"] = {
            key = "1780920816056477",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3104.438209494324, y = 947.9940660474716},
            propsData = {}
          },
          ["1780920816057478"] = {
            key = "1780920816057478",
            type = "GoToNode",
            name = "前往",
            pos = {x = 860.1483253588517, y = 340.0574162679426},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790007,
              GuideType = "N",
              GuidePointName = "Npc_ex02_eveyinlu04_142790011"
            }
          },
          ["1780920816057481"] = {
            key = "1780920816057481",
            type = "TalkNode",
            name = "【Ex02_FixSimple_08】饮水机",
            pos = {x = 1100.6037798518616, y = 288.67052949742407},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020108.11020108'",
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
          ["1780920816057482"] = {
            key = "1780920816057482",
            type = "TalkNode",
            name = "【Ex02_FixSimple_09】大锤机",
            pos = {x = 2450.5817878222642, y = 354.49685041480717},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111209,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ex02_eveyinlu06_142790435",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 11101901,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17809973755635132965"] = {
            key = "17809973755635132965",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 254.21291866028707, y = 565.5837320574162},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "3"}
              }
            }
          },
          ["17810025827805136321"] = {
            key = "17810025827805136321",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 557.2513447650744, y = -193.44929597593088},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790011}
            }
          },
          ["17810026587666155539"] = {
            key = "17810026587666155539",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 3256.968088670875, y = 334.61112283829084},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 4
            }
          },
          ["17810053683896160800"] = {
            key = "17810053683896160800",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1356.1717511075087, y = 55.3998759238715},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101801,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17810087121216168859"] = {
            key = "17810087121216168859",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 3000.439693537991, y = 335.80327171594666},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790435}
            }
          },
          ["17811485314391024639"] = {
            key = "17811485314391024639",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1323.8253613834795, y = -96.37191602823495},
            propsData = {
              NewDescription = "Description_110201_03e",
              NewDetail = "Content_110201_03e",
              SubTaskTargetIndex = 0
            }
          },
          ["17812349675524179745"] = {
            key = "17812349675524179745",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 579, y = 449.00000000000006},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth04",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178126636428716681193"] = {
            key = "178126636428716681193",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1337.9555555555553, y = 291.9887077294685},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth06",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17853142452613335972"] = {
            key = "17853142452613335972",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 931.7553666775633, y = -393.4087392394029},
            propsData = {WaitTime = 2}
          },
          ["17853288947512210747"] = {
            key = "17853288947512210747",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1183.4447520442943, y = -369.1527228391477},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "jc_rundrink",
              UnitId = 111004
            }
          },
          ["17853294883514419028"] = {
            key = "17853294883514419028",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1847.5222283437383, y = 74.34122943283712},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790011}
            }
          },
          ["17853294954764419266"] = {
            key = "17853294954764419266",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 2098.574859922686, y = 75.92017680125821},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790435}
            }
          },
          ["17853332708466627988"] = {
            key = "17853332708466627988",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2356.5180262260283, y = 203.9398450284411},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "jc_dachuiji02",
              UnitId = 111209
            }
          },
          ["178533606327511041897"] = {
            key = "178533606327511041897",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1825.9527746001022, y = 361.75353524184834},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 162790506,
              StateId = 1701014,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178533615585611042853"] = {
            key = "178533615585611042853",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1827.3813460286735, y = 503.1821066704198},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 162790506,
              StateId = 1701015,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178533618742011043377"] = {
            key = "178533618742011043377",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2081.6670603143875, y = 406.96090851373765},
            propsData = {ListenCount = 2, NeedFinishCount = 1}
          },
          ["178533625354711044401"] = {
            key = "178533625354711044401",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1838.809917457245, y = 215.1957311945634},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_dachuiji"
            }
          },
          ["178533630181912147753"] = {
            key = "178533630181912147753",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2341.4946292366944, y = 519.9452645651568},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_dachuiji"
            }
          },
          ["17865226696382490"] = {
            key = "17865226696382490",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -40.82692307692298, y = 513.4903846153848},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Dachui_interactive",
              UnitId = -1
            }
          },
          ["178704420391015638852"] = {
            key = "178704420391015638852",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2736, y = 326},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["178705730678729039989"] = {
            key = "178705730678729039989",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1834.2869898217725, y = 666.9983682983683},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 142790445,
              StateId = 1701013,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["178705735078329040919"] = {
            key = "178705735078329040919",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2107.186989821773, y = 659.2483682983684},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "Target_dachuiji"
            }
          },
          ["178731993819615695330"] = {
            key = "178731993819615695330",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 1494.0100275608931, y = 623.3133107665149},
            propsData = {GuideId = 161}
          }
        },
        commentData = {}
      }
    },
    ["1780920816026335"] = {
      isStoryNode = true,
      key = "1780920816026335",
      type = "StoryNode",
      name = "去过山车",
      pos = {x = 1438.4587553020745, y = 501.3159359668374},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03f",
        QuestDeatil = "Content_110201_03f",
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
            startQuest = "1780920816070541",
            startPort = "Out",
            endQuest = "1780920816070543",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "178107316455510251602",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "178107335548411271484",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "17812351306505221645",
            endPort = "In"
          },
          {
            startQuest = "17812351306505221645",
            startPort = "Out",
            endQuest = "1780920816069540",
            endPort = "In"
          },
          {
            startQuest = "1780920816070543",
            startPort = "Out",
            endQuest = "178126668466819805713",
            endPort = "In"
          },
          {
            startQuest = "178107316455510251602",
            startPort = "Out",
            endQuest = "17853167607033338691",
            endPort = "In"
          },
          {
            startQuest = "17853167607033338691",
            startPort = "Out",
            endQuest = "17853168160363339510",
            endPort = "In"
          },
          {
            startQuest = "17853168160363339510",
            startPort = "Out",
            endQuest = "17853169484693340048",
            endPort = "In"
          },
          {
            startQuest = "17812351306505221645",
            startPort = "Out",
            endQuest = "17853172153384450170",
            endPort = "In"
          },
          {
            startQuest = "17853172153384450170",
            startPort = "Out",
            endQuest = "178110071961812294771",
            endPort = "In"
          },
          {
            startQuest = "178110071961812294771",
            startPort = "Out",
            endQuest = "1780920816070541",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816068537"] = {
            key = "1780920816068537",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 384, y = 324},
            propsData = {ModeType = 0}
          },
          ["1780920816069538"] = {
            key = "1780920816069538",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2528, y = 325.75},
            propsData = {ModeType = 0}
          },
          ["1780920816069539"] = {
            key = "1780920816069539",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816069540"] = {
            key = "1780920816069540",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1138.9285714285713, y = 323.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790013,
              GuideType = "P",
              GuidePointName = "ex02_tp_guoshanche"
            }
          },
          ["1780920816070541"] = {
            key = "1780920816070541",
            type = "TalkNode",
            name = " 【Ex02_FixSimple_13】过山车",
            pos = {x = 1640.9499999999998, y = 336.2333333333333},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020113.11020113'",
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
          ["1780920816070543"] = {
            key = "1780920816070543",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 1903.795448325622, y = 329.99982138368716},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790436}
            }
          },
          ["178107316455510251602"] = {
            key = "178107316455510251602",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 908.4217064400128, y = -202.74338018960438},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790012}
            }
          },
          ["178107335548411271484"] = {
            key = "178107335548411271484",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 912.2360248447205, y = -7.2795031055900665},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102001,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178110071961812294771"] = {
            key = "178110071961812294771",
            type = "TalkNode",
            name = "锵锵，最后一个项目就是——过山车！",
            pos = {x = 1426.1209507726535, y = 131.35598354174215},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17812351306505221645"] = {
            key = "17812351306505221645",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 830.8571428571429, y = 307.1428571428572},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth05",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178126668466819805713"] = {
            key = "178126668466819805713",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2279.3455478847154, y = 354.1015043401985},
            propsData = {}
          },
          ["17853167607033338691"] = {
            key = "17853167607033338691",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1210.7048054919908, y = -265.3180778032039},
            propsData = {WaitTime = 5}
          },
          ["17853168160363339510"] = {
            key = "17853168160363339510",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1529.1814318404709, y = -260.85583524027504},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790012}
            }
          },
          ["17853169484693340048"] = {
            key = "17853169484693340048",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1802.9539065053946, y = -281.4929715593339},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790436}
            }
          },
          ["17853172153384450170"] = {
            key = "17853172153384450170",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1140.249019287349, y = 159.46690094802193},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142790437,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_guoshancheguide_142790437"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
