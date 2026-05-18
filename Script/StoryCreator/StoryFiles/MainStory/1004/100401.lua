return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17490032984321",
      startPort = "StoryStart",
      endStory = "1749003505043193",
      endPort = "In"
    },
    {
      startStory = "1749003505043193",
      startPort = "Success",
      endStory = "177735135088643042965",
      endPort = "In"
    },
    {
      startStory = "177735135088643042965",
      startPort = "Success",
      endStory = "1777954611255473002",
      endPort = "In"
    },
    {
      startStory = "1777954611255473002",
      startPort = "Success",
      endStory = "17779550387664674845",
      endPort = "In"
    },
    {
      startStory = "17779702103916110644",
      startPort = "Success",
      endStory = "17490032984325",
      endPort = "StoryEnd"
    },
    {
      startStory = "17779557518084677875",
      startPort = "Success",
      endStory = "17779700350826108338",
      endPort = "In"
    },
    {
      startStory = "17779702080536110413",
      startPort = "Success",
      endStory = "17779702093126110505",
      endPort = "In"
    },
    {
      startStory = "17779702093126110505",
      startPort = "Success",
      endStory = "17779702098376110570",
      endPort = "In"
    },
    {
      startStory = "17779702098376110570",
      startPort = "Success",
      endStory = "17779702103916110644",
      endPort = "In"
    },
    {
      startStory = "17779700350826108338",
      startPort = "Success",
      endStory = "17779702080536110413",
      endPort = "In"
    },
    {
      startStory = "17779550387664674845",
      startPort = "Success",
      endStory = "17779557518084677875",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17490032984321"] = {
      isStoryNode = true,
      key = "17490032984321",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 561.2938768710882, y = 33.04258584993214},
      propsData = {QuestChainId = 100401},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17490032984325"] = {
      isStoryNode = true,
      key = "17490032984325",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1736.828999004193, y = 633.6815104869379},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1749003505043193"] = {
      isStoryNode = true,
      key = "1749003505043193",
      type = "StoryNode",
      name = "酒馆集合",
      pos = {x = 822.1166289062564, y = 37.59127791920261},
      propsData = {
        QuestId = 10040101,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040101_01",
        QuestDeatil = "Description_10040101_01",
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
        IsBacktrack = false,
        SubRegionId = 101107,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kamila_1220002",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1749003505043194",
            startPort = "QuestStart",
            endQuest = "1749108843746917339",
            endPort = "In"
          },
          {
            startQuest = "1749108843746917339",
            startPort = "Out",
            endQuest = "1749003505043201",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1749003505043194"] = {
            key = "1749003505043194",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800.9655172413793, y = 266.5},
            propsData = {ModeType = 0}
          },
          ["1749003505043201"] = {
            key = "1749003505043201",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1683.482718894009, y = 266.71082949308754},
            propsData = {ModeType = 0}
          },
          ["1749003505043208"] = {
            key = "1749003505043208",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1749108843746917339"] = {
            key = "1749108843746917339",
            type = "TalkNode",
            name = "第三章初始对话",
            pos = {x = 1121.1883314054369, y = 275.03962824833974},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 200003,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Kamila_1220002",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10040101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040101.10040101'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 2,
              BlendOutTime = 2,
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
              EndNewTargetPointName = "BP_Chapeter03TalkEnd",
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
          }
        },
        commentData = {}
      }
    },
    ["177735135088643042965"] = {
      isStoryNode = true,
      key = "177735135088643042965",
      type = "StoryNode",
      name = "任务前往车站",
      pos = {x = 1098.5891019729452, y = 30.123773373273735},
      propsData = {
        QuestId = 10040116,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040102_01",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
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
        IsBacktrack = false,
        SubRegionId = 101101,
        SubRegionIdList = {106001},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_Chao03QuestDe01",
        JumpId = 0,
        QuestUIId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177743256136615097",
            startPort = "Out",
            endQuest = "177743256136615098",
            endPort = "In"
          },
          {
            startQuest = "177743256136615098",
            startPort = "Out",
            endQuest = "177743256136615099",
            endPort = "In"
          },
          {
            startQuest = "177735136648843043295",
            startPort = "Out",
            endQuest = "177743257224415392",
            endPort = "In"
          },
          {
            startQuest = "177735135088643042966",
            startPort = "QuestStart",
            endQuest = "177743259002215801",
            endPort = "In"
          },
          {
            startQuest = "177743259002215801",
            startPort = "Region_1",
            endQuest = "177735136648843043295",
            endPort = "In"
          },
          {
            startQuest = "177743259002215801",
            startPort = "LastDefaultOut",
            endQuest = "177735136648843043295",
            endPort = "In"
          },
          {
            startQuest = "177743256136615099",
            startPort = "Out",
            endQuest = "177735135088643042969",
            endPort = "Success"
          },
          {
            startQuest = "177743259002215801",
            startPort = "Region_2",
            endQuest = "177797312496510322946",
            endPort = "Input"
          },
          {
            startQuest = "177797312496510322946",
            startPort = "Out",
            endQuest = "177743256136615097",
            endPort = "In"
          }
        },
        nodeData = {
          ["177735135088643042966"] = {
            key = "177735135088643042966",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 409.1343139619001, y = 295.5160356884495},
            propsData = {ModeType = 0}
          },
          ["177735135088643042969"] = {
            key = "177735135088643042969",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2124.9404977962145, y = 564.0777806585428},
            propsData = {ModeType = 0}
          },
          ["177735135088643042972"] = {
            key = "177735135088643042972",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177735136648843043295"] = {
            key = "177735136648843043295",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1315.1176470588234, y = 308},
            propsData = {
              StaticCreatorId = 271192074,
              UnitId = 10092,
              bGuideUIEnable = true,
              GuidePointName = "BP_Chao03QuestDe01",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177743256136615097"] = {
            key = "177743256136615097",
            type = "TalkNode",
            name = "无缝车站全景",
            pos = {x = 1259.4674858379547, y = 574.3487510215492},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/Chapter03_Fix_SEQ_01.Chapter03_Fix_SEQ_01'",
              TalkType = "FixSimple",
              TalkStageName = "Chapter03_Fix_SEQ_01",
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
          ["177743256136615098"] = {
            key = "177743256136615098",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1555.5468579571957, y = 573.5885424863858},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040201.10040201'",
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
          ["177743256136615099"] = {
            key = "177743256136615099",
            type = "TalkNode",
            name = "嘟嘟皎皎出场",
            pos = {x = 1814.9200729130341, y = 554.7258279986502},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10040301.10040301'",
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
          ["177743257224415392"] = {
            key = "177743257224415392",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1662.6896551724142, y = 325.7241379310345},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["177743259002215801"] = {
            key = "177743259002215801",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 751.0284669957992, y = 285.8081555468126},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {101101, 106001}
            }
          },
          ["177797312496510322946"] = {
            key = "177797312496510322946",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1043.64637721625, y = 457.93452464051376},
            propsData = {
              TargetTime = 13,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1777954611255473002"] = {
      isStoryNode = true,
      key = "1777954611255473002",
      type = "StoryNode",
      name = "买票特殊任务",
      pos = {x = 1367.6218247915579, y = 41.011969491685846},
      propsData = {
        QuestId = 10040103,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040103_01",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Dudu_272480277",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1777954620726473235",
            startPort = "Success",
            endQuest = "1777954611255473006",
            endPort = "Success"
          },
          {
            startQuest = "1777954611255473003",
            startPort = "QuestStart",
            endQuest = "1777954634844473549",
            endPort = "In"
          },
          {
            startQuest = "1777954634844473549",
            startPort = "false",
            endQuest = "1777954703533474500",
            endPort = "In"
          },
          {
            startQuest = "1777954703533474500",
            startPort = "Out",
            endQuest = "1777954708543474617",
            endPort = "In"
          },
          {
            startQuest = "1777954620726473235",
            startPort = "Fail",
            endQuest = "1777954611255473009",
            endPort = "Fail"
          },
          {
            startQuest = "1777954620726473235",
            startPort = "PassiveFail",
            endQuest = "1777954611255473009",
            endPort = "Fail"
          },
          {
            startQuest = "1777954708543474617",
            startPort = "Out",
            endQuest = "17779549726283274245",
            endPort = "In"
          },
          {
            startQuest = "17779549726283274245",
            startPort = "Out",
            endQuest = "1777954620726473235",
            endPort = "In"
          },
          {
            startQuest = "1777954634844473549",
            startPort = "true",
            endQuest = "1777954620726473235",
            endPort = "In"
          }
        },
        nodeData = {
          ["1777954611255473003"] = {
            key = "1777954611255473003",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 333.74999999999994, y = 267.5},
            propsData = {ModeType = 0}
          },
          ["1777954611255473006"] = {
            key = "1777954611255473006",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1926, y = 364},
            propsData = {ModeType = 0}
          },
          ["1777954611255473009"] = {
            key = "1777954611255473009",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1916.25, y = 536.25},
            propsData = {}
          },
          ["1777954620726473235"] = {
            key = "1777954620726473235",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1420.1428571428573, y = 277.82142857142856},
            propsData = {SpecialConfigId = 10040103, BlackScreenImmediately = true}
          },
          ["1777954634844473549"] = {
            key = "1777954634844473549",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 667.6992481203008, y = 253.76691729323312},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStatBuyTicket100401",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["1777954703533474500"] = {
            key = "1777954703533474500",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 765.1992481203008, y = 559.1240601503758},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480277}
            }
          },
          ["1777954708543474617"] = {
            key = "1777954708543474617",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1108.7706766917295, y = 542.6954887218045},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_Interactive_BuyTicket",
              NpcId = 100405,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dudu_272480277",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10040323,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 0,
              InType = "BlendIn",
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
          ["17779549726283274245"] = {
            key = "17779549726283274245",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1399.6635338345866, y = 550.0169172932331},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480277}
            }
          }
        },
        commentData = {}
      }
    },
    ["17779550387664674845"] = {
      isStoryNode = true,
      key = "17779550387664674845",
      type = "StoryNode",
      name = "打工特殊任务",
      pos = {x = 690.1612020809348, y = 210.83942675664304},
      propsData = {
        QuestId = 10040104,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040105_01",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779557175624676602",
            startPort = "Success",
            endQuest = "17779550387664674849",
            endPort = "Success"
          },
          {
            startQuest = "17779557175624676602",
            startPort = "Fail",
            endQuest = "17779550387664674852",
            endPort = "Fail"
          },
          {
            startQuest = "17779557175624676602",
            startPort = "PassiveFail",
            endQuest = "17779550387664674852",
            endPort = "Fail"
          },
          {
            startQuest = "177797467419914528946",
            startPort = "true",
            endQuest = "177797467419914528950",
            endPort = "In"
          },
          {
            startQuest = "177797467419914528946",
            startPort = "false",
            endQuest = "177797467419914528947",
            endPort = "In"
          },
          {
            startQuest = "177797467419914528947",
            startPort = "Out",
            endQuest = "177797467419914528948",
            endPort = "Input"
          },
          {
            startQuest = "177797467419914528948",
            startPort = "False",
            endQuest = "177797467419914528949",
            endPort = "In"
          },
          {
            startQuest = "177797467419914528950",
            startPort = "Out",
            endQuest = "17779557175624676602",
            endPort = "In"
          },
          {
            startQuest = "17779550387664674846",
            startPort = "QuestStart",
            endQuest = "177797467419914528946",
            endPort = "In"
          },
          {
            startQuest = "177797467419914528949",
            startPort = "Out",
            endQuest = "17779550387664674852",
            endPort = "Fail"
          },
          {
            startQuest = "177797467419914528948",
            startPort = "True",
            endQuest = "17779557175624676602",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779550387664674846"] = {
            key = "17779550387664674846",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 540.6764705882354, y = 267},
            propsData = {ModeType = 0}
          },
          ["17779550387664674849"] = {
            key = "17779550387664674849",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2015.5, y = 277.5},
            propsData = {ModeType = 0}
          },
          ["17779550387664674852"] = {
            key = "17779550387664674852",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2017, y = 552.625},
            propsData = {}
          },
          ["17779557175624676602"] = {
            key = "17779557175624676602",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1557.1764705882354, y = 282.70588235294116},
            propsData = {SpecialConfigId = 10040104, BlackScreenImmediately = false}
          },
          ["177797467419914528946"] = {
            key = "177797467419914528946",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 955.536328638676, y = 318.27446887030493},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstPartTime100401",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177797467419914528947"] = {
            key = "177797467419914528947",
            type = "GoToNode",
            name = "前往",
            pos = {x = 885.4502900625057, y = 656.1018639345419},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480303,
              GuideType = "M",
              GuidePointName = "Mechanism_BackToPart_272480303"
            }
          },
          ["177797467419914528948"] = {
            key = "177797467419914528948",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1188.4556856787035, y = 658.9858969337063},
            propsData = {PopupId = 100110}
          },
          ["177797467419914528949"] = {
            key = "177797467419914528949",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1508.2834560675253, y = 681.5583484671563},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NoBackToPart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177797467419914528950"] = {
            key = "177797467419914528950",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1288.3940174963645, y = 331.91675563759156},
            propsData = {
              VarName = "FirstPartTime100401",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17779557518084677875"] = {
      isStoryNode = true,
      key = "17779557518084677875",
      type = "StoryNode",
      name = "地下潜入特殊任务01",
      pos = {x = 994.8047462746597, y = 209.3230805009336},
      propsData = {
        QuestId = 10040106,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040107_01",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {106301},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToPart_272480303",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779694210346104216",
            startPort = "Success",
            endQuest = "17779557518084677879",
            endPort = "Success"
          },
          {
            startQuest = "17779694210346104216",
            startPort = "PassiveFail",
            endQuest = "17779557518084677882",
            endPort = "Fail"
          },
          {
            startQuest = "17779694503146104723",
            startPort = "Out",
            endQuest = "17779694210346104216",
            endPort = "In"
          },
          {
            startQuest = "17779694874286105533",
            startPort = "true",
            endQuest = "17779694503146104723",
            endPort = "In"
          },
          {
            startQuest = "17779557518084677876",
            startPort = "QuestStart",
            endQuest = "17779694874286105533",
            endPort = "In"
          },
          {
            startQuest = "17779694874286105533",
            startPort = "false",
            endQuest = "17779696387256106653",
            endPort = "In"
          },
          {
            startQuest = "17779696387256106653",
            startPort = "Out",
            endQuest = "17779697288676107155",
            endPort = "Input"
          },
          {
            startQuest = "17779697288676107155",
            startPort = "True",
            endQuest = "17779694210346104216",
            endPort = "In"
          },
          {
            startQuest = "17779697288676107155",
            startPort = "False",
            endQuest = "17779699670936107818",
            endPort = "In"
          },
          {
            startQuest = "17779699670936107818",
            startPort = "Out",
            endQuest = "17779557518084677882",
            endPort = "Fail"
          },
          {
            startQuest = "17779694210346104216",
            startPort = "Fail",
            endQuest = "17779699670936107818",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779557518084677876"] = {
            key = "17779557518084677876",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -65.98957528957524, y = 417.27181467181464},
            propsData = {ModeType = 0}
          },
          ["17779557518084677879"] = {
            key = "17779557518084677879",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1638.4375, y = 423.74999999999994},
            propsData = {
              ModeType = 1,
              Id = 106301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17779557518084677882"] = {
            key = "17779557518084677882",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1752.7777777777778, y = 691.8055555555555},
            propsData = {}
          },
          ["17779694210346104216"] = {
            key = "17779694210346104216",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1231.3125, y = 434.5},
            propsData = {SpecialConfigId = 10040106, BlackScreenImmediately = true}
          },
          ["17779694503146104723"] = {
            key = "17779694503146104723",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 876.7776833504772, y = 426.4633467883467},
            propsData = {
              VarName = "FirstStateQianru10040101",
              VarValue = 1
            }
          },
          ["17779694874286105533"] = {
            key = "17779694874286105533",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 499.14055260850796, y = 414.4282028782029},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040101",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779696387256106653"] = {
            key = "17779696387256106653",
            type = "GoToNode",
            name = "前往",
            pos = {x = 576.0654199934772, y = 736.9485803985802},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480303,
              GuideType = "M",
              GuidePointName = "Mechanism_BackToPart_272480303"
            }
          },
          ["17779697288676107155"] = {
            key = "17779697288676107155",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 842.3800261359909, y = 758.4416359541357},
            propsData = {PopupId = 100110}
          },
          ["17779699670936107818"] = {
            key = "17779699670936107818",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1171.136785664328, y = 783.5537700272682},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NoBackToPart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17779700350826108338"] = {
      isStoryNode = true,
      key = "17779700350826108338",
      type = "StoryNode",
      name = "地下潜入特殊任务02",
      pos = {x = 743.0107787670702, y = 365.1358715597088},
      propsData = {
        QuestId = 10040107,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106301,
        SubRegionIdList = {106001},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779700560646108692",
            startPort = "Success",
            endQuest = "17779700350826108342",
            endPort = "Success"
          },
          {
            startQuest = "17779700929216109472",
            startPort = "true",
            endQuest = "17779700929216109473",
            endPort = "In"
          },
          {
            startQuest = "17779700929216109472",
            startPort = "false",
            endQuest = "17779700929216109474",
            endPort = "In"
          },
          {
            startQuest = "17779700929216109474",
            startPort = "Out",
            endQuest = "17779700929216109475",
            endPort = "Input"
          },
          {
            startQuest = "17779700350826108339",
            startPort = "QuestStart",
            endQuest = "17779700929216109472",
            endPort = "In"
          },
          {
            startQuest = "17779700929216109473",
            startPort = "Out",
            endQuest = "17779700560646108692",
            endPort = "In"
          },
          {
            startQuest = "17779700929216109475",
            startPort = "False",
            endQuest = "17779700929216109476",
            endPort = "In"
          },
          {
            startQuest = "17779700929216109476",
            startPort = "Out",
            endQuest = "17779700350826108345",
            endPort = "Fail"
          },
          {
            startQuest = "17779700929216109475",
            startPort = "True",
            endQuest = "17779700560646108692",
            endPort = "In"
          },
          {
            startQuest = "17779700560646108692",
            startPort = "Fail",
            endQuest = "17779700929216109476",
            endPort = "In"
          },
          {
            startQuest = "17779700560646108692",
            startPort = "PassiveFail",
            endQuest = "17779700929216109476",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779700350826108339"] = {
            key = "17779700350826108339",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 124.22222222222229, y = 368.44444444444446},
            propsData = {ModeType = 0}
          },
          ["17779700350826108342"] = {
            key = "17779700350826108342",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2206.7572156196943, y = 415.85059422750425},
            propsData = {ModeType = 0}
          },
          ["17779700350826108345"] = {
            key = "17779700350826108345",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2226.470588235294, y = 655.6037151702786},
            propsData = {}
          },
          ["17779700560646108692"] = {
            key = "17779700560646108692",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1487.6, y = 392.25882352941176},
            propsData = {SpecialConfigId = 10040107, BlackScreenImmediately = true}
          },
          ["17779700929216109472"] = {
            key = "17779700929216109472",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 754.9933028262001, y = 353.7517325544997},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779700929216109473"] = {
            key = "17779700929216109473",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1095.5867059696031, y = 348.4118764646435},
            propsData = {
              VarName = "FirstStateQianru10040102",
              VarValue = 1
            }
          },
          ["17779700929216109474"] = {
            key = "17779700929216109474",
            type = "GoToNode",
            name = "前往",
            pos = {x = 628.6106135323269, y = 744.2585534560571},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2520002,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianruStart_2520002"
            }
          },
          ["17779700929216109475"] = {
            key = "17779700929216109475",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 940.2591925904696, y = 741.0445445590373},
            propsData = {PopupId = 100110}
          },
          ["17779700929216109476"] = {
            key = "17779700929216109476",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1853.9328712505865, y = 647.4800172818243},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17779702080536110413"] = {
      isStoryNode = true,
      key = "17779702080536110413",
      type = "StoryNode",
      name = "地下潜入特殊任务04",
      pos = {x = 1106.1051415121676, y = 375.2890578342186},
      propsData = {
        QuestId = 10040109,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "",
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
        SubRegionId = 106301,
        SubRegionIdList = {106001},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779702080536110421",
            startPort = "Success",
            endQuest = "17779702080536110419",
            endPort = "Success"
          },
          {
            startQuest = "17779702080536110422",
            startPort = "true",
            endQuest = "17779702080536110423",
            endPort = "In"
          },
          {
            startQuest = "17779702080536110418",
            startPort = "QuestStart",
            endQuest = "17779702080536110422",
            endPort = "In"
          },
          {
            startQuest = "17779702080536110423",
            startPort = "Out",
            endQuest = "17779702080536110421",
            endPort = "In"
          },
          {
            startQuest = "17779702080536110426",
            startPort = "Out",
            endQuest = "17779702080536110420",
            endPort = "Fail"
          },
          {
            startQuest = "17781562469532227",
            startPort = "Out",
            endQuest = "17781562469532226",
            endPort = "Input"
          },
          {
            startQuest = "17779702080536110422",
            startPort = "false",
            endQuest = "17781562469532227",
            endPort = "In"
          },
          {
            startQuest = "17781562469532226",
            startPort = "True",
            endQuest = "17779702080536110421",
            endPort = "In"
          },
          {
            startQuest = "17781562469532226",
            startPort = "False",
            endQuest = "17779702080536110426",
            endPort = "In"
          },
          {
            startQuest = "17779702080536110421",
            startPort = "Fail",
            endQuest = "17779702080536110426",
            endPort = "In"
          },
          {
            startQuest = "17779702080536110421",
            startPort = "PassiveFail",
            endQuest = "17779702080536110420",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17779702080536110418"] = {
            key = "17779702080536110418",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 382.22222222222223, y = 344.44444444444446},
            propsData = {ModeType = 0}
          },
          ["17779702080536110419"] = {
            key = "17779702080536110419",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1800.967741935484, y = 426.9032258064516},
            propsData = {ModeType = 0}
          },
          ["17779702080536110420"] = {
            key = "17779702080536110420",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1626.4705882352941, y = 698.2352941176471},
            propsData = {}
          },
          ["17779702080536110421"] = {
            key = "17779702080536110421",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1364, y = 428},
            propsData = {SpecialConfigId = 10040109, BlackScreenImmediately = true}
          },
          ["17779702080536110422"] = {
            key = "17779702080536110422",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 739.9933028262001, y = 360.0017325544997},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040104",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779702080536110423"] = {
            key = "17779702080536110423",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1086.886705969603, y = 366.4118764646435},
            propsData = {
              VarName = "FirstStateQianru10040104",
              VarValue = 1
            }
          },
          ["17779702080536110426"] = {
            key = "17779702080536110426",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1322.6971971723428, y = 847.5995219257873},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_QianruShig",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17781562469532226"] = {
            key = "17781562469532226",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 945.8242895290714, y = 878.39299555149},
            propsData = {PopupId = 100110}
          },
          ["17781562469532227"] = {
            key = "17781562469532227",
            type = "GoToNode",
            name = "前往",
            pos = {x = 665.4257104709285, y = 861.6070044485099},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2490002,
              GuideType = "M",
              GuidePointName = "Mechanism_QianruShigu_2490002"
            }
          }
        },
        commentData = {}
      }
    },
    ["17779702093126110505"] = {
      isStoryNode = true,
      key = "17779702093126110505",
      type = "StoryNode",
      name = "地下潜入特殊任务05",
      pos = {x = 729.7213940476652, y = 582.1946950891204},
      propsData = {
        QuestId = 10040110,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "",
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
        SubRegionId = 106301,
        SubRegionIdList = {106001},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779702093136110513",
            startPort = "Success",
            endQuest = "17779702093126110511",
            endPort = "Success"
          },
          {
            startQuest = "17779702093136110514",
            startPort = "true",
            endQuest = "17779702093136110515",
            endPort = "In"
          },
          {
            startQuest = "17779702093136110514",
            startPort = "false",
            endQuest = "17779702093136110516",
            endPort = "In"
          },
          {
            startQuest = "17779702093136110516",
            startPort = "Out",
            endQuest = "17779702093136110517",
            endPort = "Input"
          },
          {
            startQuest = "17779702093136110517",
            startPort = "False",
            endQuest = "17779702093136110518",
            endPort = "In"
          },
          {
            startQuest = "17779702093126110510",
            startPort = "QuestStart",
            endQuest = "17779702093136110514",
            endPort = "In"
          },
          {
            startQuest = "17779702093136110515",
            startPort = "Out",
            endQuest = "17779702093136110513",
            endPort = "In"
          },
          {
            startQuest = "17779702093136110517",
            startPort = "True",
            endQuest = "17779702093136110513",
            endPort = "In"
          },
          {
            startQuest = "17779702093136110518",
            startPort = "Out",
            endQuest = "17779702093136110512",
            endPort = "Fail"
          },
          {
            startQuest = "17779702093136110513",
            startPort = "PassiveFail",
            endQuest = "17779702093136110512",
            endPort = "Fail"
          },
          {
            startQuest = "17779702093136110513",
            startPort = "Fail",
            endQuest = "17779702093136110518",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779702093126110510"] = {
            key = "17779702093126110510",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 382.22222222222223, y = 344.44444444444446},
            propsData = {ModeType = 0}
          },
          ["17779702093126110511"] = {
            key = "17779702093126110511",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1800.967741935484, y = 426.9032258064516},
            propsData = {ModeType = 0}
          },
          ["17779702093136110512"] = {
            key = "17779702093136110512",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1626.4705882352941, y = 698.2352941176471},
            propsData = {}
          },
          ["17779702093136110513"] = {
            key = "17779702093136110513",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1364, y = 428},
            propsData = {SpecialConfigId = 10040110, BlackScreenImmediately = true}
          },
          ["17779702093136110514"] = {
            key = "17779702093136110514",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 765.2790171119144, y = 350.8945896973569},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040105",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779702093136110515"] = {
            key = "17779702093136110515",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1094.386705969603, y = 366.4118764646435},
            propsData = {
              VarName = "FirstStateQianru10040105",
              VarValue = 1
            }
          },
          ["17779702093136110516"] = {
            key = "17779702093136110516",
            type = "GoToNode",
            name = "前往",
            pos = {x = 731.5087680094285, y = 649.2483005510675},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480042,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru06_272480042"
            }
          },
          ["17779702093136110517"] = {
            key = "17779702093136110517",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 998.1983741519422, y = 690.0270703923372},
            propsData = {PopupId = 100110}
          },
          ["17779702093136110518"] = {
            key = "17779702093136110518",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1316.4471971723428, y = 712.5995219257873},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_DixiaQianru06",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17779702098376110570"] = {
      isStoryNode = true,
      key = "17779702098376110570",
      type = "StoryNode",
      name = "地下潜入特殊任务06",
      pos = {x = 1076.7868698486639, y = 599.6129957427153},
      propsData = {
        QuestId = 10040111,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_03",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106301,
        SubRegionIdList = {106001},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779702098376110578",
            startPort = "Success",
            endQuest = "17779702098376110576",
            endPort = "Success"
          },
          {
            startQuest = "17779702098376110579",
            startPort = "true",
            endQuest = "17779702098376110580",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110579",
            startPort = "false",
            endQuest = "17779702098376110581",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110581",
            startPort = "Out",
            endQuest = "17779702098376110582",
            endPort = "Input"
          },
          {
            startQuest = "17779702098376110582",
            startPort = "False",
            endQuest = "17779702098376110583",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110575",
            startPort = "QuestStart",
            endQuest = "17779702098376110579",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110580",
            startPort = "Out",
            endQuest = "17779702098376110578",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110582",
            startPort = "True",
            endQuest = "17779702098376110578",
            endPort = "In"
          },
          {
            startQuest = "17779702098376110583",
            startPort = "Out",
            endQuest = "17779702098376110577",
            endPort = "Fail"
          },
          {
            startQuest = "17779702098376110578",
            startPort = "PassiveFail",
            endQuest = "17779702098376110577",
            endPort = "Fail"
          },
          {
            startQuest = "17779702098376110578",
            startPort = "Fail",
            endQuest = "17779702098376110583",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779702098376110575"] = {
            key = "17779702098376110575",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 251.3568376068376, y = 352.0405982905983},
            propsData = {ModeType = 0}
          },
          ["17779702098376110576"] = {
            key = "17779702098376110576",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1794.3010752688172, y = 435.2365591397849},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 5,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17779702098376110577"] = {
            key = "17779702098376110577",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1812.337254901961, y = 756.4352941176471},
            propsData = {}
          },
          ["17779702098376110578"] = {
            key = "17779702098376110578",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1279.7692307692307, y = 377.2307692307692},
            propsData = {SpecialConfigId = 10040111, BlackScreenImmediately = true}
          },
          ["17779702098376110579"] = {
            key = "17779702098376110579",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 537.9740720569692, y = 355.48250178526894},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040106",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779702098376110580"] = {
            key = "17779702098376110580",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 878.2713213542183, y = 356.8349533877204},
            propsData = {
              VarName = "FirstStateQianru10040106",
              VarValue = 1
            }
          },
          ["17779702098376110581"] = {
            key = "17779702098376110581",
            type = "GoToNode",
            name = "前往",
            pos = {x = 727.7999768006372, y = 689.8939049466719},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2510002,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianruEnd_2510002"
            }
          },
          ["17779702098376110582"] = {
            key = "17779702098376110582",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1028.5280444816126, y = 704.7523451176119},
            propsData = {PopupId = 100110}
          },
          ["17779702098376110583"] = {
            key = "17779702098376110583",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1378.1138638390096, y = 732.5995219257873},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_DixiaQianruEnd",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17779702103916110644"] = {
      isStoryNode = true,
      key = "17779702103916110644",
      type = "StoryNode",
      name = "地下潜入特殊任务07",
      pos = {x = 1411.5996082382524, y = 581.3123421479439},
      propsData = {
        QuestId = 10040112,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BackToDX_272480302",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17779702103916110652",
            startPort = "Success",
            endQuest = "17779702103916110650",
            endPort = "Success"
          },
          {
            startQuest = "17779702103916110653",
            startPort = "true",
            endQuest = "17779702103916110654",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110653",
            startPort = "false",
            endQuest = "17779702103916110655",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110655",
            startPort = "Out",
            endQuest = "17779702103916110656",
            endPort = "Input"
          },
          {
            startQuest = "17779702103916110656",
            startPort = "False",
            endQuest = "17779702103916110657",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110649",
            startPort = "QuestStart",
            endQuest = "17779702103916110653",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110654",
            startPort = "Out",
            endQuest = "17779702103916110652",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110657",
            startPort = "Out",
            endQuest = "17779702103916110651",
            endPort = "Fail"
          },
          {
            startQuest = "17779702103916110652",
            startPort = "PassiveFail",
            endQuest = "17779702103916110651",
            endPort = "Fail"
          },
          {
            startQuest = "17779702103916110652",
            startPort = "Fail",
            endQuest = "17779702103916110657",
            endPort = "In"
          },
          {
            startQuest = "17779702103916110656",
            startPort = "True",
            endQuest = "177876412440145818905",
            endPort = "In"
          },
          {
            startQuest = "177876412440145818905",
            startPort = "Out",
            endQuest = "17779702103916110652",
            endPort = "In"
          }
        },
        nodeData = {
          ["17779702103916110649"] = {
            key = "17779702103916110649",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 382.22222222222223, y = 344.44444444444446},
            propsData = {ModeType = 0}
          },
          ["17779702103916110650"] = {
            key = "17779702103916110650",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1800.967741935484, y = 426.9032258064516},
            propsData = {ModeType = 0}
          },
          ["17779702103916110651"] = {
            key = "17779702103916110651",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1762.1227621483376, y = 721.7135549872123},
            propsData = {}
          },
          ["17779702103916110652"] = {
            key = "17779702103916110652",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1373.5454545454545, y = 381.07210031347967},
            propsData = {SpecialConfigId = 10040112, BlackScreenImmediately = true}
          },
          ["17779702103916110653"] = {
            key = "17779702103916110653",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 672.0465943622503, y = 340.5855883538727},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateQianru10040107",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17779702103916110654"] = {
            key = "17779702103916110654",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1022.7910946843366, y = 314.3115629850197},
            propsData = {
              VarName = "FirstStateQianru10040107",
              VarValue = 1
            }
          },
          ["17779702103916110655"] = {
            key = "17779702103916110655",
            type = "GoToNode",
            name = "前往",
            pos = {x = 653.2058123444039, y = 653.1399261668311},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480208,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianruEleEnd_272480208"
            }
          },
          ["17779702103916110656"] = {
            key = "17779702103916110656",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 921.4988667627796, y = 680.3226368948003},
            propsData = {PopupId = 100110}
          },
          ["17779702103916110657"] = {
            key = "17779702103916110657",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1316.4471971723428, y = 712.5995219257873},
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
          ["177876412440145818905"] = {
            key = "177876412440145818905",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1124.954990061716, y = 490.64166457275013},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PanpaEndTalk",
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
