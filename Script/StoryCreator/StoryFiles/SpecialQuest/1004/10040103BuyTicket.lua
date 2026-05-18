return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1777954121343934836",
      startPort = "Success",
      endStory = "1777954121343934837",
      endPort = "In"
    },
    {
      startStory = "1777954020873934756",
      startPort = "StoryStart",
      endStory = "1777954121343934836",
      endPort = "In"
    },
    {
      startStory = "1777954121343934837",
      startPort = "Success",
      endStory = "1777954020873934759",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1777954020873934756"] = {
      isStoryNode = true,
      key = "1777954020873934756",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 659.4736842105262, y = 281.05263157894734},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1777954020873934759"] = {
      isStoryNode = true,
      key = "1777954020873934759",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1813.1034482758619, y = 323.7931034482759},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1777954121343934836"] = {
      isStoryNode = true,
      key = "1777954121343934836",
      type = "StoryNode",
      name = "买票",
      pos = {x = 1148.5189054332739, y = 269.90896723184653},
      propsData = {
        QuestId = 10040103,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040103_01",
        QuestDeatil = "Description_10040103_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "Mechanism_Maipiao_2480016",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1777954121348934850",
            startPort = "Out",
            endQuest = "1777954121348934851",
            endPort = "In"
          },
          {
            startQuest = "1777954121348934851",
            startPort = "Out",
            endQuest = "1777954121349934853",
            endPort = "In"
          },
          {
            startQuest = "1777954121349934853",
            startPort = "Out",
            endQuest = "1777954121348934852",
            endPort = "In"
          },
          {
            startQuest = "1777954121350934855",
            startPort = "Out",
            endQuest = "1777954121350934858",
            endPort = "In"
          },
          {
            startQuest = "1777954121350934858",
            startPort = "Out",
            endQuest = "1777954121348934850",
            endPort = "In"
          },
          {
            startQuest = "1777954121351934860",
            startPort = "Out",
            endQuest = "1777954121350934855",
            endPort = "In"
          },
          {
            startQuest = "1777954121347934847",
            startPort = "QuestStart",
            endQuest = "1777954121351934861",
            endPort = "In"
          },
          {
            startQuest = "1777954121347934847",
            startPort = "QuestStart",
            endQuest = "1777954163523936403",
            endPort = "In"
          },
          {
            startQuest = "1777954121347934847",
            startPort = "QuestStart",
            endQuest = "1777954463631936705",
            endPort = "In"
          },
          {
            startQuest = "1777954463631936705",
            startPort = "true",
            endQuest = "1777954121351934860",
            endPort = "In"
          },
          {
            startQuest = "1777954463631936705",
            startPort = "true",
            endQuest = "1777954121350934857",
            endPort = "In"
          },
          {
            startQuest = "1777954121350934856",
            startPort = "Out",
            endQuest = "1777954121349934854",
            endPort = "In"
          },
          {
            startQuest = "1777954121348934852",
            startPort = "Out",
            endQuest = "17779545749241872275",
            endPort = "In"
          },
          {
            startQuest = "1777954463631936705",
            startPort = "false",
            endQuest = "1777954121347934848",
            endPort = "Success"
          },
          {
            startQuest = "1777954121347934847",
            startPort = "QuestStart",
            endQuest = "17779767746262807819",
            endPort = "Input"
          },
          {
            startQuest = "1777954163523936403",
            startPort = "Out",
            endQuest = "1777954121347934849",
            endPort = "Fail"
          },
          {
            startQuest = "1777954121351934860",
            startPort = "Out",
            endQuest = "1777954121350934859",
            endPort = "In"
          },
          {
            startQuest = "17779545749241872275",
            startPort = "Out",
            endQuest = "17784685906481439138",
            endPort = "In"
          },
          {
            startQuest = "17784685906481439138",
            startPort = "Out",
            endQuest = "1777954121347934848",
            endPort = "Success"
          },
          {
            startQuest = "1777954121351934860",
            startPort = "Out",
            endQuest = "1777954121350934856",
            endPort = "In"
          },
          {
            startQuest = "1777954121347934847",
            startPort = "QuestStart",
            endQuest = "17788488152885801242",
            endPort = "In"
          }
        },
        nodeData = {
          ["1777954121347934847"] = {
            key = "1777954121347934847",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -406.9318181818183, y = 319.65909090909093},
            propsData = {ModeType = 0}
          },
          ["1777954121347934848"] = {
            key = "1777954121347934848",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2969.297016579911, y = 278.646592442645},
            propsData = {ModeType = 0}
          },
          ["1777954121347934849"] = {
            key = "1777954121347934849",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 745.7912087912086, y = 819.7252747252747},
            propsData = {}
          },
          ["1777954121348934850"] = {
            key = "1777954121348934850",
            type = "GoToNode",
            name = "前往售票窗",
            pos = {x = 1197.9096701649175, y = 470.58384898459855},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2480016,
              GuideType = "M",
              GuidePointName = "Mechanism_Maipiao_2480016"
            }
          },
          ["1777954121348934851"] = {
            key = "1777954121348934851",
            type = "TalkNode",
            name = "买票",
            pos = {x = 1459.4958712217026, y = 534.9545161827557},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10040301,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040401.10040401'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 2,
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
          ["1777954121348934852"] = {
            key = "1777954121348934852",
            type = "TalkNode",
            name = "获得车票",
            pos = {x = 1976.4714963892507, y = 320.3305279057835},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10040401,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040501.10040501'",
              TalkType = "QuestImpression",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "BP_TalkEnd01",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1777954121349934853"] = {
            key = "1777954121349934853",
            type = "TalkNode",
            name = "过场-站长出场",
            pos = {x = 1761.0045977011496, y = 487.77988505747123},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_02.Chapter03_Fix_SEQ_02'",
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
          ["1777954121349934854"] = {
            key = "1777954121349934854",
            type = "SendMessageNode",
            name = "激活嘟嘟皎皎AI",
            pos = {x = 912.8179723502304, y = -87.39339477726574},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = "BaiLCStartMove",
              UnitId = 100405
            }
          },
          ["1777954121350934855"] = {
            key = "1777954121350934855",
            type = "GoToNode",
            name = "前往",
            pos = {x = 692.2168022949477, y = 426.58825459935576},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 272480276,
              GuideType = "M",
              GuidePointName = ""
            }
          },
          ["1777954121350934856"] = {
            key = "1777954121350934856",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 509.46984480110183, y = -91.32365978058755},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480277}
            }
          },
          ["1777954121350934857"] = {
            key = "1777954121350934857",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 364.90771756978637, y = -431.44827586206907},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Dudu_272480277"
            }
          },
          ["1777954121350934858"] = {
            key = "1777954121350934858",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 948.8724137931034, y = 433.0344827586207},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = "Npc_Dudu_272480277"
            }
          },
          ["1777954121350934859"] = {
            key = "1777954121350934859",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 890.3321098849071, y = 161.90056672068815},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 10049901,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1777954121351934860"] = {
            key = "1777954121351934860",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 420.2440028154421, y = 212.04429368732204},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_BHCZStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1777954121351934861"] = {
            key = "1777954121351934861",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -18.770507916411457, y = -155.8763413717511},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1777954163523936403"] = {
            key = "1777954163523936403",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 153.66061705989097, y = 818.1754385964912},
            propsData = {}
          },
          ["1777954463631936705"] = {
            key = "1777954463631936705",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 57.58393471532504, y = 335.8820672702129},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateBuyTicket100401",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779545749241872275"] = {
            key = "17779545749241872275",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2291.605001446646, y = 334.29820663830776},
            propsData = {
              VarName = "StateBuyTicket100401",
              VarValue = 1
            }
          },
          ["17779767746262807819"] = {
            key = "17779767746262807819",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 80.9248290782815, y = 559.2493324678339},
            propsData = {
              TargetTime = 13,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          },
          ["17784685906481439138"] = {
            key = "17784685906481439138",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2701.9982057416264, y = 412.69318181818187},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480277}
            }
          },
          ["17788488152885801242"] = {
            key = "17788488152885801242",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 53.999999999999886, y = -33.75000000000006},
            propsData = {
              VarName = "FirstStatBuyTicket100401",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["1777954121343934837"] = {
      isStoryNode = true,
      key = "1777954121343934837",
      type = "StoryNode",
      name = "检票",
      pos = {x = 1437.8259221529331, y = 292.29792931987765},
      propsData = {
        QuestId = 10040104,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040104_01",
        QuestDeatil = "Description_10040104_01",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "Mechanism_Jianpiap_2480017",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1777954121358934920",
            startPort = "QuestStart",
            endQuest = "1777954121358934923",
            endPort = "In"
          },
          {
            startQuest = "1777954121358934924",
            startPort = "Out",
            endQuest = "1777954121359934925",
            endPort = "In"
          },
          {
            startQuest = "1777954121359934925",
            startPort = "Out",
            endQuest = "1777954121359934926",
            endPort = "In"
          },
          {
            startQuest = "1777954121359934926",
            startPort = "Out",
            endQuest = "1777954121359934928",
            endPort = "In"
          },
          {
            startQuest = "1777954121358934923",
            startPort = "Out",
            endQuest = "1777954121359934927",
            endPort = "In"
          },
          {
            startQuest = "1777954121359934927",
            startPort = "Out",
            endQuest = "1777954121358934924",
            endPort = "In"
          },
          {
            startQuest = "1777954121359934928",
            startPort = "Out",
            endQuest = "1777954134567935453",
            endPort = "In"
          },
          {
            startQuest = "1777954121358934920",
            startPort = "QuestStart",
            endQuest = "1777954144294935794",
            endPort = "In"
          },
          {
            startQuest = "1777954144294935794",
            startPort = "Out",
            endQuest = "1777954121358934922",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1777954121358934920"] = {
            key = "1777954121358934920",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 517.0425963488844, y = 453.00840336134456},
            propsData = {ModeType = 0}
          },
          ["1777954121358934921"] = {
            key = "1777954121358934921",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2793.0978260869565, y = 471.1709486166009},
            propsData = {ModeType = 0}
          },
          ["1777954121358934922"] = {
            key = "1777954121358934922",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1352.3855799373036, y = 824.4075235109718},
            propsData = {}
          },
          ["1777954121358934923"] = {
            key = "1777954121358934923",
            type = "GoToNode",
            name = "前往检票口",
            pos = {x = 904.6693574399457, y = 460.216577540107},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2480017,
              GuideType = "M",
              GuidePointName = "Mechanism_Jianpiao_2480017"
            }
          },
          ["1777954121358934924"] = {
            key = "1777954121358934924",
            type = "TalkNode",
            name = "开始检票",
            pos = {x = 1438.580557124035, y = 446.12229437229433},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10040501,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040601.10040601'",
              TalkType = "QuestImpression",
              TalkStageName = "",
              BlendInTime = 1,
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
          ["1777954121359934925"] = {
            key = "1777954121359934925",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1671.494938001778, y = 473.3211797780763},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_Jianpiaohou",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1777954121359934926"] = {
            key = "1777954121359934926",
            type = "TalkNode",
            name = "安检站桩",
            pos = {x = 1954.3653846153848, y = 461.4423076923075},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10040502,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040701.10040701'",
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
          ["1777954121359934927"] = {
            key = "1777954121359934927",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 1185, y = 467},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {
                "Story_BHCZ_10040104"
              }
            }
          },
          ["1777954121359934928"] = {
            key = "1777954121359934928",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 2230.614906832299, y = 484.6128364389236},
            propsData = {
              IsHide = false,
              AtmosphereTagList = {
                "Story_BHCZ_10040104"
              }
            }
          },
          ["1777954134567935453"] = {
            key = "1777954134567935453",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2528.4414715719067, y = 456.2173913043478},
            propsData = {}
          },
          ["1777954144294935794"] = {
            key = "1777954144294935794",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 927.0494752623687, y = 816.3988005997002},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
