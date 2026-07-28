return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1780315440318282",
      startPort = "Success",
      endStory = "1780315440318283",
      endPort = "In"
    },
    {
      startStory = "1780315440318283",
      startPort = "Success",
      endStory = "1780315440319284",
      endPort = "In"
    },
    {
      startStory = "1780315440319284",
      startPort = "Success",
      endStory = "1780315440319285",
      endPort = "In"
    },
    {
      startStory = "17803152857331",
      startPort = "StoryStart",
      endStory = "1780315440318282",
      endPort = "In"
    },
    {
      startStory = "1780315440319285",
      startPort = "Success",
      endStory = "178047243378214122412",
      endPort = "In"
    },
    {
      startStory = "178047243378214122412",
      startPort = "Success",
      endStory = "17803152857345",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17803152857331"] = {
      isStoryNode = true,
      key = "17803152857331",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 515, y = 222.69230769230768},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17803152857345"] = {
      isStoryNode = true,
      key = "17803152857345",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2477.142857142857, y = 45.714285714285694},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1780315440318282"] = {
      isStoryNode = true,
      key = "1780315440318282",
      type = "StoryNode",
      name = "山林外围",
      pos = {x = 795.8583954369741, y = -73.32843985502232},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02a",
        QuestDeatil = "Content_110201_02a",
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
            startQuest = "1780315440323310",
            startPort = "Out",
            endQuest = "1780315440323313",
            endPort = "In"
          },
          {
            startQuest = "1780315440322308",
            startPort = "Out",
            endQuest = "1780315440323310",
            endPort = "In"
          },
          {
            startQuest = "1780315440323314",
            startPort = "Out",
            endQuest = "1780315440322308",
            endPort = "In"
          },
          {
            startQuest = "1780315440322305",
            startPort = "QuestStart",
            endQuest = "17803868429052016861",
            endPort = "In"
          },
          {
            startQuest = "17803997129705034775",
            startPort = "true",
            endQuest = "1780315440323314",
            endPort = "In"
          },
          {
            startQuest = "17803997129705034775",
            startPort = "false",
            endQuest = "17804000543885041239",
            endPort = "In"
          },
          {
            startQuest = "17804000543885041239",
            startPort = "Out",
            endQuest = "1780315440322306",
            endPort = "Success"
          },
          {
            startQuest = "1780315440323313",
            startPort = "Out",
            endQuest = "17804005786096045355",
            endPort = "In"
          },
          {
            startQuest = "17804005786096045355",
            startPort = "Out",
            endQuest = "1780315440322306",
            endPort = "Success"
          },
          {
            startQuest = "1780315440322308",
            startPort = "Out",
            endQuest = "17804009481207050409",
            endPort = "In"
          },
          {
            startQuest = "17803868429052016861",
            startPort = "Out",
            endQuest = "17803997129705034775",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780315440322305"] = {
            key = "1780315440322305",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -815.7478991596639, y = 189.95314489432138},
            propsData = {ModeType = 0}
          },
          ["1780315440322306"] = {
            key = "1780315440322306",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1523.5515660809779, y = 473.3227654698241},
            propsData = {ModeType = 0}
          },
          ["1780315440322307"] = {
            key = "1780315440322307",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780315440322308"] = {
            key = "1780315440322308",
            type = "TalkNode",
            name = "【Ex02_FixSimple_01】",
            pos = {x = 369.115887981987, y = -90.58133971291869},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020101.11020101'",
              TalkType = "FixSimple",
              TalkStageName = "Ex02_FixSimple_01",
              BlendInTime = 0,
              BlendOutTime = 0.5,
              InType = "FadeIn",
              OutType = "BlendOut",
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
          ["1780315440323309"] = {
            key = "1780315440323309",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1995.4058441558443, y = 14.519480519480496},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
          ["1780315440323310"] = {
            key = "1780315440323310",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 656.0876438551962, y = 132.05823825131216},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                142780002,
                142780004,
                142780005,
                142780006,
                142780007
              }
            }
          },
          ["1780315440323311"] = {
            key = "1780315440323311",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 943.6078948345883, y = -745.4839753445685},
            propsData = {SpecialConfigId = 0, BlackScreenImmediately = false}
          },
          ["1780315440323312"] = {
            key = "1780315440323312",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1245.9405739421868, y = -674.7383954754922},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1780315440323313"] = {
            key = "1780315440323313",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 950.6170445304224, y = -11.534518470144917},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 5,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                142780002,
                142780004,
                142780005,
                142780006,
                142780007
              }
            }
          },
          ["1780315440323314"] = {
            key = "1780315440323314",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 143.06610166523785, y = 104.17258518471448},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1780315440323315"] = {
            key = "1780315440323315",
            type = "GoToNode",
            name = "前往",
            pos = {x = 679.0263157894736, y = -762.078947368421},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2780007,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox_2780007"
            }
          },
          ["17803868429052016861"] = {
            key = "17803868429052016861",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -477.2870981970434, y = 194.91172048476253},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["17803995769204032223"] = {
            key = "17803995769204032223",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 253.29671427531457, y = -735.9638876532297},
            propsData = {
              FunctionName = "",
              VarName = "",
              Duration = 0,
              VarInfos = {
                {VarName = "", VarValue = ""}
              }
            }
          },
          ["17803997129705034775"] = {
            key = "17803997129705034775",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -170.74250141095996, y = 233.8689296842317},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17804000543885041239"] = {
            key = "17804000543885041239",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 245.34480086364783, y = 346.27995931507496},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17804005786096045355"] = {
            key = "17804005786096045355",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1233.0816429689114, y = 180.01680142033797},
            propsData = {
              VarName = "ex02_11020102",
              VarValue = 1
            }
          },
          ["17804009481207050409"] = {
            key = "17804009481207050409",
            type = "TalkNode",
            name = "开车",
            pos = {x = 643.7483096355782, y = -192.10819857966203},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11100101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {0},
              IsPlayStartSound = true,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {
          ["17803889799552019347"] = {
            key = "17803889799552019347",
            name = "未填",
            position = {x = -552.2156696256145, y = 110.32713401859706},
            size = {width = 322.10526315789457, height = 225.78947368421063}
          }
        }
      }
    },
    ["1780315440318283"] = {
      isStoryNode = true,
      key = "1780315440318283",
      type = "StoryNode",
      name = "遇到猎人",
      pos = {x = 1114.9591039341678, y = -69.10478511204472},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02b",
        QuestDeatil = "Content_110201_02b",
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
            startQuest = "1780315440329353",
            startPort = "QuestStart",
            endQuest = "17804128535979070141",
            endPort = "In"
          },
          {
            startQuest = "1780315440329356",
            startPort = "Out",
            endQuest = "17804133865839076721",
            endPort = "In"
          },
          {
            startQuest = "17804133865839076721",
            startPort = "Out",
            endQuest = "17804129080849071460",
            endPort = "In"
          },
          {
            startQuest = "17804129080849071460",
            startPort = "Out",
            endQuest = "17805732499172033436",
            endPort = "In"
          },
          {
            startQuest = "17805732499172033436",
            startPort = "Out",
            endQuest = "1780315440329354",
            endPort = "Success"
          },
          {
            startQuest = "17804128535979070141",
            startPort = "false",
            endQuest = "17805732499172033436",
            endPort = "In"
          },
          {
            startQuest = "17804128535979070141",
            startPort = "true",
            endQuest = "17808885541472103",
            endPort = "In"
          },
          {
            startQuest = "17808885541472103",
            startPort = "Out",
            endQuest = "1780315440329356",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780315440329353"] = {
            key = "1780315440329353",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 128.3529411764706, y = 452.7352941176471},
            propsData = {ModeType = 0}
          },
          ["1780315440329354"] = {
            key = "1780315440329354",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2191.7902255639096, y = 312.1785425101214},
            propsData = {ModeType = 0}
          },
          ["1780315440329355"] = {
            key = "1780315440329355",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1930.8653846153848, y = 517.9807692307692},
            propsData = {}
          },
          ["1780315440329356"] = {
            key = "1780315440329356",
            type = "TalkNode",
            name = "和伯纳德对话",
            pos = {x = 1120.3782531777013, y = 228.38029632905793},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 11020002,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020102.11020102'",
              TalkType = "FixSimple",
              TalkStageName = "Ex02_FixSimple_02",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          ["17804128535979070141"] = {
            key = "17804128535979070141",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 444.1643546082398, y = 455.8521870286577},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17804129080849071460"] = {
            key = "17804129080849071460",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1698.3039725066812, y = 59.943137254901885},
            propsData = {
              VarName = "ex02_11020102",
              VarValue = 2
            }
          },
          ["17804133865839076721"] = {
            key = "17804133865839076721",
            type = "TalkNode",
            name = "【过场】伊薇出场",
            pos = {x = 1419.5808955836046, y = 148.95082956259412},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0105/Ver0105_SC001/SQ_Ver0105_SC001",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          ["17805732499172033436"] = {
            key = "17805732499172033436",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1952.233908780904, y = 215.2184401220442},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth03",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17808885541472103"] = {
            key = "17808885541472103",
            type = "GoToNode",
            name = "前往",
            pos = {x = 796, y = 281.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "P",
              GuidePointName = "tp_rebieth04"
            }
          }
        },
        commentData = {}
      }
    },
    ["1780315440319284"] = {
      isStoryNode = true,
      key = "1780315440319284",
      type = "StoryNode",
      name = "伊薇登场",
      pos = {x = 1485.8536047751297, y = -70.70086137839971},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02c",
        QuestDeatil = "Content_110201_02c",
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
            startQuest = "178041481421810090715",
            startPort = "Out",
            endQuest = "1780315440331369",
            endPort = "Success"
          },
          {
            startQuest = "1780315440331368",
            startPort = "QuestStart",
            endQuest = "17804134442759078507",
            endPort = "In"
          },
          {
            startQuest = "17804134442759078507",
            startPort = "true",
            endQuest = "17804136627539083334",
            endPort = "In"
          },
          {
            startQuest = "17804136627539083334",
            startPort = "Out",
            endQuest = "17804116130388063523",
            endPort = "In"
          },
          {
            startQuest = "17804136627539083334",
            startPort = "Out",
            endQuest = "1780315440331371",
            endPort = "In"
          },
          {
            startQuest = "1780315440331371",
            startPort = "Out",
            endQuest = "17811837939997207157",
            endPort = "In"
          },
          {
            startQuest = "17811837939997207157",
            startPort = "Out",
            endQuest = "178041481421810090715",
            endPort = "In"
          },
          {
            startQuest = "17804134442759078507",
            startPort = "false",
            endQuest = "17811838262998237108",
            endPort = "In"
          },
          {
            startQuest = "17811838262998237108",
            startPort = "Out",
            endQuest = "1780315440331369",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780315440331368"] = {
            key = "1780315440331368",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 92.40000000000003, y = 264.8},
            propsData = {ModeType = 0}
          },
          ["1780315440331369"] = {
            key = "1780315440331369",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2822.855091533181, y = 366.8600114416476},
            propsData = {ModeType = 0}
          },
          ["1780315440331370"] = {
            key = "1780315440331370",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780315440331371"] = {
            key = "1780315440331371",
            type = "TalkNode",
            name = "过场后和伊薇交谈Ex02_FixSimple_03",
            pos = {x = 1752.688558352403, y = 105.13684210526318},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111004,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ex02a_yiwei01_142780009",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020103.11020103'",
              TalkType = "FixSimple",
              TalkStageName = "Ex02_FixSimple_03",
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
          ["17804116130388063523"] = {
            key = "17804116130388063523",
            type = "TalkNode",
            name = "伊薇和伯纳德气泡",
            pos = {x = 1767.9804945054948, y = -99.7228021978022},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11109901,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17804117995019067648"] = {
            key = "17804117995019067648",
            type = "ChangeNpcDefaultDataNode",
            name = "修改NPC默认动作/表情节点",
            pos = {x = 1243.1804945054946, y = -74.32280219780223},
            propsData = {
              ChangeNpcDefaultDataList = {
                {
                  TargetNpcUnitId = 0,
                  DefaultActionId = 1,
                  DefaultFacialId = 1
                }
              }
            }
          },
          ["17804134442759078507"] = {
            key = "17804134442759078507",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 754.432668418538, y = 243.46850215002388},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17804136627539083334"] = {
            key = "17804136627539083334",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1082.4152771141903, y = 160.23371954132838},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780009, 142780010}
            }
          },
          ["178041481421810090715"] = {
            key = "178041481421810090715",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2538.130494505494, y = 207.54241519350228},
            propsData = {
              VarName = "ex02_11020102",
              VarValue = 3
            }
          },
          ["17811837939997207157"] = {
            key = "17811837939997207157",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2191.8389419841164, y = 128.05032642347547},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780010}
            }
          },
          ["17811838262998237108"] = {
            key = "17811838262998237108",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1619.9639419841164, y = 349.30032642347544},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780009}
            }
          }
        },
        commentData = {
          ["17808892834093041735"] = {
            key = "17808892834093041735",
            name = "气泡or开车",
            position = {x = 1720, y = -167},
            size = {width = 270, height = 213}
          },
          ["17811839663389269799"] = {
            key = "17811839663389269799",
            name = "ai跑远再消失",
            position = {x = 2162.092396862571, y = -32.294870046720916},
            size = {width = 628.125, height = 56.25}
          }
        }
      }
    },
    ["1780315440319285"] = {
      isStoryNode = true,
      key = "1780315440319285",
      type = "StoryNode",
      name = "跟随伊薇一",
      pos = {x = 1814.4944976653476, y = -93.36103853798954},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02d",
        QuestDeatil = "Content_110201_02d",
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
            startQuest = "1780315440334393",
            startPort = "Out",
            endQuest = "1780315440335398",
            endPort = "In"
          },
          {
            startQuest = "1780315440334390",
            startPort = "QuestStart",
            endQuest = "178047163835312109454",
            endPort = "In"
          },
          {
            startQuest = "178047163835312109454",
            startPort = "true",
            endQuest = "1780315440334393",
            endPort = "In"
          },
          {
            startQuest = "178047201576913113941",
            startPort = "Out",
            endQuest = "178047094386012106483",
            endPort = "In"
          },
          {
            startQuest = "178047225312313116084",
            startPort = "Out",
            endQuest = "178047201576913113941",
            endPort = "In"
          },
          {
            startQuest = "178047163835312109454",
            startPort = "false",
            endQuest = "178047315079314125337",
            endPort = "In"
          },
          {
            startQuest = "178047094386012106483",
            startPort = "Out",
            endQuest = "178047317049414125906",
            endPort = "In"
          },
          {
            startQuest = "178047317049414125906",
            startPort = "Out",
            endQuest = "1780315440334391",
            endPort = "Success"
          },
          {
            startQuest = "178047201576913113941",
            startPort = "Out",
            endQuest = "17805566520351015809",
            endPort = "In"
          },
          {
            startQuest = "1780315440335398",
            startPort = "Out",
            endQuest = "17811839411059269186",
            endPort = "In"
          },
          {
            startQuest = "17811839411059269186",
            startPort = "Out",
            endQuest = "178047225312313116084",
            endPort = "In"
          },
          {
            startQuest = "178047315079314125337",
            startPort = "true",
            endQuest = "17811840085869270887",
            endPort = "In"
          },
          {
            startQuest = "17811840085869270887",
            startPort = "Out",
            endQuest = "178047201576913113941",
            endPort = "In"
          },
          {
            startQuest = "178047315079314125337",
            startPort = "false",
            endQuest = "17811841729579273665",
            endPort = "In"
          },
          {
            startQuest = "17811841729579273665",
            startPort = "Out",
            endQuest = "1780315440334391",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780315440334390"] = {
            key = "1780315440334390",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 25.377112135176674, y = 496.75115207373267},
            propsData = {ModeType = 0}
          },
          ["1780315440334391"] = {
            key = "1780315440334391",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2523.551691729323, y = 374.1162280701754},
            propsData = {
              ModeType = 1,
              Id = 107101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1780315440334392"] = {
            key = "1780315440334392",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2233.166666666667, y = 635},
            propsData = {}
          },
          ["1780315440334393"] = {
            key = "1780315440334393",
            type = "GoToNode",
            name = "前往",
            pos = {x = 575.6892171233297, y = 335.4999215099045},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142780011,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02a_talktrigger_142780011"
            }
          },
          ["1780315440334396"] = {
            key = "1780315440334396",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1452.268356374808, y = -325.2722734254992},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2780025,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox_2780025"
            }
          },
          ["1780315440334397"] = {
            key = "1780315440334397",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1720.694546850999, y = -392.80084485407065},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2780027,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox_2780027"
            }
          },
          ["1780315440335398"] = {
            key = "1780315440335398",
            type = "TalkNode",
            name = "悬崖边头晕对话",
            pos = {x = 877.2372046833622, y = 282.9228282545767},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 11020004,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020104.11020104'",
              TalkType = "FixSimple",
              TalkStageName = "Ex02_FixSimple_04",
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
          ["1780315440335399"] = {
            key = "1780315440335399",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2014.5279040734858, y = -432.3487736303246},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2780029,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox_2780029"
            }
          },
          ["1780315440335400"] = {
            key = "1780315440335400",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2241.7476190476186, y = -285.878947368421},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2780028,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox_2780028"
            }
          },
          ["178045757744311096256"] = {
            key = "178045757744311096256",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 827.1666666666666, y = -346.5},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = ""
            }
          },
          ["178045769542011097848"] = {
            key = "178045769542011097848",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1100.3157894736842, y = -311.5350877192983},
            propsData = {
              MessageType = "BehaviorTree",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["178047039361612105557"] = {
            key = "178047039361612105557",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1926.6396398605202, y = -295.9016181758748},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100001,
              GuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
          ["178047094386012106483"] = {
            key = "178047094386012106483",
            type = "FirstObservationCompleteNode",
            name = "首次观察完成",
            pos = {x = 1917.5009042747533, y = 237.66974629668786},
            propsData = {StaticCreatorId = 142780012, ObservationPointName = ""}
          },
          ["178047163835312109454"] = {
            key = "178047163835312109454",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 347.1158303367106, y = 482.1936199193634},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "3"}
              }
            }
          },
          ["178047201576913113941"] = {
            key = "178047201576913113941",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1622.6903009820526, y = 366.3843944609257},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780012}
            }
          },
          ["178047225312313116084"] = {
            key = "178047225312313116084",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1483.6486751784123, y = 87.96527353608417},
            propsData = {
              VarName = "ex02_11020102",
              VarValue = 4
            }
          },
          ["178047315079314125337"] = {
            key = "178047315079314125337",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 953.0597027473349, y = 580.3838199019988},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "4"}
              }
            }
          },
          ["178047317049414125906"] = {
            key = "178047317049414125906",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2262.5333869578612, y = 92.03795524034473},
            propsData = {
              VarName = "ex02_11020102",
              VarValue = 5
            }
          },
          ["17805566520351015809"] = {
            key = "17805566520351015809",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1926.6015012850924, y = 82.57025866290526},
            propsData = {
              NewDescription = "Description_110201_02e",
              NewDetail = "Content_110201_02e",
              SubTaskTargetIndex = 0
            }
          },
          ["17811839411059269186"] = {
            key = "17811839411059269186",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1155.8637218045117, y = 218.55639097744407},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780009}
            }
          },
          ["17811840085869270887"] = {
            key = "17811840085869270887",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1313.0065789473688, y = 455.69924812030126},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth04",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17811841729579273665"] = {
            key = "17811841729579273665",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1884.4351503759406, y = 481.41353383458704},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth5",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["17805564594782356"] = {
            key = "17805564594782356",
            name = "看是否需要加一个头晕的后处理引入",
            position = {x = 663.7211921205726, y = 84.61449863346157},
            size = {width = 488.0769230769231, height = 120.00000000000007}
          },
          ["17805734906332037593"] = {
            key = "17805734906332037593",
            name = "调用伊薇ai",
            position = {x = 790.2052298578612, y = 743.993931481315},
            size = {width = 550.5882352941175, height = 116.47058823529412}
          }
        }
      }
    },
    ["178047243378214122412"] = {
      isStoryNode = true,
      key = "178047243378214122412",
      type = "StoryNode",
      name = "跟随伊薇二",
      pos = {x = 2174.840633315172, y = -141.93716475334125},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_02f",
        QuestDeatil = "Content_110201_02f",
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
            startQuest = "178047243378214122413",
            startPort = "QuestStart",
            endQuest = "17805736136982039176",
            endPort = "In"
          },
          {
            startQuest = "17805736136982039176",
            startPort = "Out",
            endQuest = "17811816181606169370",
            endPort = "In"
          }
        },
        nodeData = {
          ["178047243378214122413"] = {
            key = "178047243378214122413",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178047243378214122416"] = {
            key = "178047243378214122416",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2270, y = 268.8421052631579},
            propsData = {ModeType = 0}
          },
          ["178047243378214122419"] = {
            key = "178047243378214122419",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17805736136982039176"] = {
            key = "17805736136982039176",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1413.9999999999998, y = 93.99999999999986},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 142780013,
              GuideType = "M",
              GuidePointName = "ex02a_emylystart"
            }
          },
          ["17809107872275071139"] = {
            key = "17809107872275071139",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2055.8221415607986, y = -138.54083484573505},
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
          ["17811816181606169370"] = {
            key = "17811816181606169370",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1966.6315789473683, y = 215.47368421052627},
            propsData = {}
          }
        },
        commentData = {
          ["17809931121927103509"] = {
            key = "17809931121927103509",
            name = "快达到目的地时播放开车，触发盒控制",
            position = {x = 1722.5916515426497, y = 80.84891107078047},
            size = {width = 594.8275862068966, height = 65.17241379310346}
          }
        }
      }
    }
  },
  commentData = {}
}
