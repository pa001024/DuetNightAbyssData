return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17821955830421",
      startPort = "StoryStart",
      endStory = "17832540830311410",
      endPort = "In"
    },
    {
      startStory = "17832540830311410",
      startPort = "Success",
      endStory = "1782195610712265",
      endPort = "In"
    },
    {
      startStory = "1782195610712265",
      startPort = "Success",
      endStory = "17821955830425",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17821955830421"] = {
      isStoryNode = true,
      key = "17821955830421",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 364.2857142857143, y = 308.57142857142856},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17821955830425"] = {
      isStoryNode = true,
      key = "17821955830425",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1664.30303030303, y = 332.27272727272725},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782195610712265"] = {
      isStoryNode = true,
      key = "1782195610712265",
      type = "StoryNode",
      name = "吊桥调查",
      pos = {x = 1154.1761904761906, y = 272.1257703081232},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01g",
        QuestDeatil = "Content_110221_01g",
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
            startQuest = "17821959800092931",
            startPort = "Out",
            endQuest = "17821963586194065",
            endPort = "In"
          },
          {
            startQuest = "17832574663002181940",
            startPort = "Out",
            endQuest = "17821958639931120",
            endPort = "In"
          },
          {
            startQuest = "17821958693481328",
            startPort = "Out",
            endQuest = "17821959800092931",
            endPort = "In"
          },
          {
            startQuest = "17832574663002181940",
            startPort = "Out",
            endQuest = "17821958693481328",
            endPort = "In"
          },
          {
            startQuest = "1782195610712266",
            startPort = "QuestStart",
            endQuest = "17832574663002181940",
            endPort = "In"
          },
          {
            startQuest = "17832574663002181940",
            startPort = "Out",
            endQuest = "17866361185332565",
            endPort = "In"
          },
          {
            startQuest = "178715370905715644869",
            startPort = "Out",
            endQuest = "178487716194615537046",
            endPort = "Input"
          },
          {
            startQuest = "178715473450317878952",
            startPort = "Out",
            endQuest = "178715369832115644503",
            endPort = "In"
          },
          {
            startQuest = "17821959800092931",
            startPort = "Out",
            endQuest = "178715473450317878952",
            endPort = "Input"
          },
          {
            startQuest = "178715473450317878952",
            startPort = "Out",
            endQuest = "17866986392554465832",
            endPort = "In"
          },
          {
            startQuest = "17832574663002181940",
            startPort = "Out",
            endQuest = "17871961582109032",
            endPort = "In"
          },
          {
            startQuest = "17821958693481328",
            startPort = "Out",
            endQuest = "17871964298731126562",
            endPort = "In"
          },
          {
            startQuest = "178487716194615537046",
            startPort = "Out",
            endQuest = "17872245640623582",
            endPort = "In"
          },
          {
            startQuest = "17872245640623582",
            startPort = "Out",
            endQuest = "17821985566312143633",
            endPort = "In"
          },
          {
            startQuest = "17821963586194065",
            startPort = "Out",
            endQuest = "17872246094631121047",
            endPort = "Input"
          },
          {
            startQuest = "17872246094631121047",
            startPort = "Out",
            endQuest = "178715370905715644869",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782195610712266"] = {
            key = "1782195610712266",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 70.85714285714283, y = 271.42857142857144},
            propsData = {ModeType = 0}
          },
          ["1782195610713274"] = {
            key = "1782195610713274",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2487.439422257197, y = 533.8454816709293},
            propsData = {ModeType = 0}
          },
          ["1782195610713282"] = {
            key = "1782195610713282",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17821958639931120"] = {
            key = "17821958639931120",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 951.4366094263793, y = -111.95880526123497},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11111301,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17821958693481328"] = {
            key = "17821958693481328",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1106.2617424878295, y = 177.51422695987915},
            propsData = {
              StaticCreatorId = 142780381,
              UnitId = 11022102,
              bGuideUIEnable = false,
              GuidePointName = "Drop_lakongzhigan_142780381",
              LongPressTime = 3,
              MontageName = "Interactive_01_Montage",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = "event:/sfx/common/story/03/task_searchbox"
            }
          },
          ["17821959800092931"] = {
            key = "17821959800092931",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C6_01】吊桥问题",
            pos = {x = 1419.7194753187316, y = 207.1718426501037},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110221/11022101.11022101'",
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
          ["17821963586194065"] = {
            key = "17821963586194065",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1732.7066776103152, y = 206.17238902009765},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142780196,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_jiucun_142780196"
            }
          },
          ["17821985566312143633"] = {
            key = "17821985566312143633",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3230.431941807463, y = 208.2449560019559},
            propsData = {}
          },
          ["17832574663002181940"] = {
            key = "17832574663002181940",
            type = "GoToNode",
            name = "前往",
            pos = {x = 724.7942367230291, y = 139.96483289672116},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142780195,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_diaoqiaokaiche_142780195"
            }
          },
          ["178487716194615537046"] = {
            key = "178487716194615537046",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2586.404891074693, y = 214.625},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17866361185332565"] = {
            key = "17866361185332565",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1110.4130434782608, y = 46.703661327231146},
            propsData = {
              NewDescription = "Description_110221_01a",
              NewDetail = "Content_110221_01a",
              SubTaskTargetIndex = 0
            }
          },
          ["17866986392554465832"] = {
            key = "17866986392554465832",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1953.254421052125, y = -298.695139705302},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Joystick_Lower",
              UnitId = -1
            }
          },
          ["178715369832115644503"] = {
            key = "178715369832115644503",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1937.0399464133475, y = -170.07861405431746},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780823}
            }
          },
          ["178715370905715644869"] = {
            key = "178715370905715644869",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2263.9658208821284, y = 193.48954547494054},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2780823}
            }
          },
          ["178715473450317878952"] = {
            key = "178715473450317878952",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1680.4285217519503, y = -169.41729884173384},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 0.5,
              IsStandAlone = false
            }
          },
          ["17871961582109032"] = {
            key = "17871961582109032",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1049.714285714286, y = 370.85714285714283},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Drop_lakongzhigan_142780381"
            }
          },
          ["17871964298731126562"] = {
            key = "17871964298731126562",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1388.6153846153845, y = 8.329670329670307},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Drop_lakongzhigan_142780381"
            }
          },
          ["17872245640623582"] = {
            key = "17872245640623582",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2947.3294119190805, y = 197.14630849391688},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Joystick_Lift ",
              UnitId = -1
            }
          },
          ["17872246094631121047"] = {
            key = "17872246094631121047",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1990.0079833476518, y = 200.09273706534546},
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
    ["17832540830311410"] = {
      isStoryNode = true,
      key = "17832540830311410",
      type = "StoryNode",
      name = "艾达歌声",
      pos = {x = 800.2079757199324, y = 284.638961038961},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01f",
        QuestDeatil = "Content_110221_01f",
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
            startQuest = "17832558979764344",
            startPort = "Out",
            endQuest = "17832559364474939",
            endPort = "In"
          },
          {
            startQuest = "17832540830311411",
            startPort = "QuestStart",
            endQuest = "17832560800955620",
            endPort = "Input"
          },
          {
            startQuest = "17832561129216425",
            startPort = "true",
            endQuest = "17832558979764344",
            endPort = "In"
          },
          {
            startQuest = "17832558268973338",
            startPort = "Out",
            endQuest = "17832561435317176",
            endPort = "In"
          },
          {
            startQuest = "17832561435317176",
            startPort = "Out",
            endQuest = "17832573072731094334",
            endPort = "In"
          },
          {
            startQuest = "17832573072731094334",
            startPort = "Out",
            endQuest = "17832540830321414",
            endPort = "Success"
          },
          {
            startQuest = "17832561129216425",
            startPort = "false",
            endQuest = "17832540830321414",
            endPort = "Success"
          },
          {
            startQuest = "17832561129216425",
            startPort = "true",
            endQuest = "17834257992233567",
            endPort = "In"
          },
          {
            startQuest = "17834257992233567",
            startPort = "Out",
            endQuest = "17832558268973338",
            endPort = "In"
          },
          {
            startQuest = "17832560800955620",
            startPort = "Out",
            endQuest = "17832560800955619",
            endPort = "In"
          },
          {
            startQuest = "17832560800955619",
            startPort = "Out",
            endQuest = "178485914051212206417",
            endPort = "In"
          },
          {
            startQuest = "178485914051212206417",
            startPort = "Out",
            endQuest = "17832561129216425",
            endPort = "In"
          },
          {
            startQuest = "17832540830311411",
            startPort = "QuestStart",
            endQuest = "17866986067224465064",
            endPort = "In"
          }
        },
        nodeData = {
          ["17832540830311411"] = {
            key = "17832540830311411",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -591.5561497326204, y = 195.53654188948303},
            propsData = {ModeType = 0}
          },
          ["17832540830321414"] = {
            key = "17832540830321414",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1803.3727272727272, y = 547.4278074866311},
            propsData = {ModeType = 0}
          },
          ["17832540830321417"] = {
            key = "17832540830321417",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1760, y = 721.6666666666666},
            propsData = {}
          },
          ["17832558268973338"] = {
            key = "17832558268973338",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 898.2177448454531, y = 302.9809442363625},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022101,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "",
              IsUseCount = false
            }
          },
          ["17832558979764344"] = {
            key = "17832558979764344",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 893.4383330807477, y = 140.62800305989174},
            propsData = {WaitTime = 20}
          },
          ["17832559364474939"] = {
            key = "17832559364474939",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1200.4971566101594, y = 133.56917953047997},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Drop_aidasing_142780380"
            }
          },
          ["17832560800955619"] = {
            key = "17832560800955619",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -160.8702817632916, y = 368.1480565358279},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["17832560800955620"] = {
            key = "17832560800955620",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -218.44021785061415, y = 175.74698701711077},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17832561129216425"] = {
            key = "17832561129216425",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 551.3527715834216, y = 507.86253323559845},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11022101",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17832561435317176"] = {
            key = "17832561435317176",
            type = "TalkNode",
            name = "和唱歌艾达对话",
            pos = {x = 1181.155980139571, y = 312.7682745531045},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110221/11022105.11022105'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1,
              BlendOutTime = 1,
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
          ["17832573072731094334"] = {
            key = "17832573072731094334",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1526.3514346850257, y = 293.7998390670223},
            propsData = {
              VarName = "ex02_11022101",
              VarValue = 1
            }
          },
          ["17834257992233567"] = {
            key = "17834257992233567",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 883.5045322212673, y = 466.4876933258782},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780380}
            }
          },
          ["178485914051212206417"] = {
            key = "178485914051212206417",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 162.45112781954867, y = 435.99467418546374},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142780560}
            }
          },
          ["17866986067224465064"] = {
            key = "17866986067224465064",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -265.7139256512325, y = 4.717037219746393},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Joystick_Lift",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
