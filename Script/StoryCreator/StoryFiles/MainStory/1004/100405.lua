return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17739990170783936999",
      startPort = "Success",
      endStory = "17739990279033937344",
      endPort = "In"
    },
    {
      startStory = "17739990279033937344",
      startPort = "Success",
      endStory = "17685462157372232669",
      endPort = "StoryEnd"
    },
    {
      startStory = "17739990080483936734",
      startPort = "Success",
      endStory = "17739991462943938782",
      endPort = "In"
    },
    {
      startStory = "17739991462943938782",
      startPort = "Success",
      endStory = "17739990170783936999",
      endPort = "In"
    },
    {
      startStory = "17685517578213352620",
      startPort = "Success",
      endStory = "17740021236396558059",
      endPort = "In"
    },
    {
      startStory = "17740021236396558059",
      startPort = "Success",
      endStory = "17740021422786558731",
      endPort = "In"
    },
    {
      startStory = "17740021422786558731",
      startPort = "Success",
      endStory = "17739990080483936734",
      endPort = "In"
    },
    {
      startStory = "17685462157372232666",
      startPort = "StoryStart",
      endStory = "177772100396130765167",
      endPort = "In"
    },
    {
      startStory = "177772101007430765343",
      startPort = "Success",
      endStory = "177772100987730765327",
      endPort = "In"
    },
    {
      startStory = "177772100396130765167",
      startPort = "Success",
      endStory = "177772101007430765343",
      endPort = "In"
    },
    {
      startStory = "177772100987730765327",
      startPort = "Success",
      endStory = "177772101027530765368",
      endPort = "In"
    },
    {
      startStory = "177772101055430765390",
      startPort = "Success",
      endStory = "17685517578213352620",
      endPort = "In"
    },
    {
      startStory = "177772101027530765368",
      startPort = "Success",
      endStory = "177772350985934974117",
      endPort = "In"
    },
    {
      startStory = "177772350985934974117",
      startPort = "Success",
      endStory = "177772101055430765390",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17685462157372232666"] = {
      isStoryNode = true,
      key = "17685462157372232666",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 884.5454545454545, y = 113.18181818181813},
      propsData = {QuestChainId = 100405},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17685462157372232669"] = {
      isStoryNode = true,
      key = "17685462157372232669",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2645.4423648247184, y = 1177.124777183601},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17685517578213352620"] = {
      isStoryNode = true,
      key = "17685517578213352620",
      type = "StoryNode",
      name = "蒙太奇",
      pos = {x = 2220.199706150402, y = 492.58611569029546},
      propsData = {
        QuestId = 10040507,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17685517578223352629",
            startPort = "Out",
            endQuest = "17685517578223352626",
            endPort = "Success"
          },
          {
            startQuest = "17685517578223352625",
            startPort = "QuestStart",
            endQuest = "177486893046513999471",
            endPort = "In"
          },
          {
            startQuest = "177486893046513999471",
            startPort = "Out",
            endQuest = "17685517578223352629",
            endPort = "In"
          }
        },
        nodeData = {
          ["17685517578223352625"] = {
            key = "17685517578223352625",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 154.44444444444443, y = 307.5},
            propsData = {ModeType = 0}
          },
          ["17685517578223352626"] = {
            key = "17685517578223352626",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1219.8225063938623, y = 319.2920716112532},
            propsData = {
              ModeType = 1,
              Id = 101107,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17685517578223352627"] = {
            key = "17685517578223352627",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17685517578223352629"] = {
            key = "17685517578223352629",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 754.839869281046, y = 314.3545751633987},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049001.10049001'",
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
          ["177486893046513999471"] = {
            key = "177486893046513999471",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 482.9540827529956, y = 304.5273033126294},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PTPre01",
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
    ["17739990080483936734"] = {
      isStoryNode = true,
      key = "17739990080483936734",
      type = "StoryNode",
      name = "幻境",
      pos = {x = 1428.0301196439736, y = 757.0274628691811},
      propsData = {
        QuestId = 10040508,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106201,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17739990786883938430",
            startPort = "Out",
            endQuest = "17739990080483936738",
            endPort = "Success"
          },
          {
            startQuest = "17739990080483936735",
            startPort = "QuestStart",
            endQuest = "17772720594141392468",
            endPort = "In"
          },
          {
            startQuest = "17772720594141392468",
            startPort = "Out",
            endQuest = "177855473077213147715",
            endPort = "In"
          },
          {
            startQuest = "177855473077213147715",
            startPort = "Out",
            endQuest = "17739990786883938430",
            endPort = "In"
          }
        },
        nodeData = {
          ["17739990080483936735"] = {
            key = "17739990080483936735",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 566.5625, y = 346.875},
            propsData = {ModeType = 0}
          },
          ["17739990080483936738"] = {
            key = "17739990080483936738",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1888, y = 306},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17739990080483936741"] = {
            key = "17739990080483936741",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739990786883938430"] = {
            key = "17739990786883938430",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1462, y = 336},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049101.10049101'",
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
          ["17772720594141392468"] = {
            key = "17772720594141392468",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 839.3685344827586, y = 362.7413793103448},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_FuluoMTTalk",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177855473077213147715"] = {
            key = "177855473077213147715",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1135, y = 356.8717105263157},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC026/Ver0104_SC026",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          }
        },
        commentData = {}
      }
    },
    ["17739990170783936999"] = {
      isStoryNode = true,
      key = "17739990170783936999",
      type = "StoryNode",
      name = "卡嘉",
      pos = {x = 2040.08297740994, y = 762.5077032170688},
      propsData = {
        QuestId = 10040509,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "106101",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17739992114523939815",
            startPort = "Out",
            endQuest = "17739990170783937005",
            endPort = "Success"
          },
          {
            startQuest = "17739990170783937004",
            startPort = "QuestStart",
            endQuest = "17772726112825555884",
            endPort = "In"
          },
          {
            startQuest = "17772726112825555884",
            startPort = "Out",
            endQuest = "17739992114523939815",
            endPort = "In"
          }
        },
        nodeData = {
          ["17739990170783937004"] = {
            key = "17739990170783937004",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 612.1052631578948, y = 364.7368421052632},
            propsData = {ModeType = 0}
          },
          ["17739990170783937005"] = {
            key = "17739990170783937005",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2008, y = 334},
            propsData = {ModeType = 0}
          },
          ["17739990170783937006"] = {
            key = "17739990170783937006",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739992114523939815"] = {
            key = "17739992114523939815",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1236, y = 320},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049301.10049301'",
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
          ["17772726112825555884"] = {
            key = "17772726112825555884",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 907.0557275541793, y = 376.4210526315789},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_KajiaTalkFinal",
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
    ["17739990279033937344"] = {
      isStoryNode = true,
      key = "17739990279033937344",
      type = "StoryNode",
      name = "莉莉寇",
      pos = {x = 2311.09340717836, y = 780.2482369799809},
      propsData = {
        QuestId = 10040510,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = true,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17739990279033937345",
            startPort = "QuestStart",
            endQuest = "17739990515913937858",
            endPort = "In"
          },
          {
            startQuest = "17739990515913937858",
            startPort = "Out",
            endQuest = "17739990553773937968",
            endPort = "In"
          },
          {
            startQuest = "17739990553773937968",
            startPort = "Out",
            endQuest = "17770229878252285",
            endPort = "In"
          },
          {
            startQuest = "17770229878252285",
            startPort = "Out",
            endQuest = "17739990279033937348",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17739990279033937345"] = {
            key = "17739990279033937345",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17739990279033937348"] = {
            key = "17739990279033937348",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2634, y = 468},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17739990279033937351"] = {
            key = "17739990279033937351",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739990515913937858"] = {
            key = "17739990515913937858",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1450, y = 358},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17739990553773937968"] = {
            key = "17739990553773937968",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1860, y = 390},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049801.10049801'",
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
          ["17770229878252285"] = {
            key = "17770229878252285",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2220, y = 490},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Chapter03Done",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["17739991462943938782"] = {
      isStoryNode = true,
      key = "17739991462943938782",
      type = "StoryNode",
      name = "幻境下",
      pos = {x = 1765.6679633334147, y = 759.5456851528702},
      propsData = {
        QuestId = 10040511,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17739991462953938790",
            startPort = "Out",
            endQuest = "17739991462953938788",
            endPort = "Success"
          },
          {
            startQuest = "17739991462953938787",
            startPort = "QuestStart",
            endQuest = "17772722224284168078",
            endPort = "In"
          },
          {
            startQuest = "17772722224284168078",
            startPort = "Out",
            endQuest = "17739991462953938790",
            endPort = "In"
          },
          {
            startQuest = "17772722224284168078",
            startPort = "Out",
            endQuest = "177859787715936529224",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17739991462953938787"] = {
            key = "17739991462953938787",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17739991462953938788"] = {
            key = "17739991462953938788",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1911.6666666666665, y = 338.3333333333333},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17739991462953938789"] = {
            key = "17739991462953938789",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739991462953938790"] = {
            key = "17739991462953938790",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1467.304347826087, y = 375.63768115942025},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049201.10049201'",
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
          ["17772722224284168078"] = {
            key = "17772722224284168078",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1077.297141074029, y = 319.985011936957},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_TePoint_Teleport_10040312leport_10040311",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["177859787715936529224"] = {
            key = "177859787715936529224",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1380, y = 80},
            propsData = {
              TargetTime = 20,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17740021236396558059"] = {
      isStoryNode = true,
      key = "17740021236396558059",
      type = "StoryNode",
      name = "蒙太奇2",
      pos = {x = 2543.483848020623, y = 501.14337422850025},
      propsData = {
        QuestId = 10040513,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 101107,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17740021236396558060",
            startPort = "QuestStart",
            endQuest = "17740021315026558336",
            endPort = "In"
          },
          {
            startQuest = "17740021315026558336",
            startPort = "Out",
            endQuest = "17740021236396558063",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17740021236396558060"] = {
            key = "17740021236396558060",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17740021236396558063"] = {
            key = "17740021236396558063",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1500.9462915601023, y = 312.89002557544757},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17740021236396558066"] = {
            key = "17740021236396558066",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17740021315026558336"] = {
            key = "17740021315026558336",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1152.0591787439614, y = 320.1642512077295},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049001_2.10049001_2'",
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
          }
        },
        commentData = {}
      }
    },
    ["17740021422786558731"] = {
      isStoryNode = true,
      key = "17740021422786558731",
      type = "StoryNode",
      name = "蒙太奇3",
      pos = {x = 2854.0086278385065, y = 538.3901274752535},
      propsData = {
        QuestId = 10040512,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17740021794786559034",
            startPort = "Out",
            endQuest = "17740021794796559035",
            endPort = "In"
          },
          {
            startQuest = "17740021794796559035",
            startPort = "Out",
            endQuest = "17740021794796559036",
            endPort = "In"
          },
          {
            startQuest = "17740021794796559036",
            startPort = "Out",
            endQuest = "17740021422786558735",
            endPort = "Success"
          },
          {
            startQuest = "17740021422786558732",
            startPort = "QuestStart",
            endQuest = "17748717056102752",
            endPort = "In"
          },
          {
            startQuest = "17748717056102752",
            startPort = "Out",
            endQuest = "17740021794786559034",
            endPort = "In"
          }
        },
        nodeData = {
          ["17740021422786558732"] = {
            key = "17740021422786558732",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 626.3262599469497, y = 470.05305039787805},
            propsData = {ModeType = 0}
          },
          ["17740021422786558735"] = {
            key = "17740021422786558735",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2266, y = 486},
            propsData = {
              ModeType = 1,
              Id = 106201,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17740021422786558738"] = {
            key = "17740021422786558738",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17740021794786559034"] = {
            key = "17740021794786559034",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1152.9832167249708, y = 539.9855072463768},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049001_3.10049001_3'",
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
          ["17740021794796559035"] = {
            key = "17740021794796559035",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1521.8031400966183, y = 544.8743961352657},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049001_4.10049001_4'",
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
          ["17740021794796559036"] = {
            key = "17740021794796559036",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1889.0857487922706, y = 550.0144927536232},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049001_5.10049001_5'",
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
          ["17748717056102752"] = {
            key = "17748717056102752",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 898.142030452385, y = 521.7610235873967},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZLTalk01",
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
    ["177772100396130765167"] = {
      isStoryNode = true,
      key = "177772100396130765167",
      type = "StoryNode",
      name = "炮台特殊任务",
      pos = {x = 1223.8013443456987, y = 79.293403572843},
      propsData = {
        QuestId = 10040501,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040501_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772100396130765168",
            startPort = "QuestStart",
            endQuest = "177772112498630766226",
            endPort = "In"
          },
          {
            startQuest = "177772112498630766226",
            startPort = "Success",
            endQuest = "177772100396130765171",
            endPort = "Success"
          },
          {
            startQuest = "177772112498630766226",
            startPort = "Fail",
            endQuest = "177875894688342880295",
            endPort = "In"
          },
          {
            startQuest = "177772112498630766226",
            startPort = "PassiveFail",
            endQuest = "177875894688342880295",
            endPort = "In"
          },
          {
            startQuest = "177875894688342880295",
            startPort = "Out",
            endQuest = "177772100396130765174",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772100396130765168"] = {
            key = "177772100396130765168",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772100396130765171"] = {
            key = "177772100396130765171",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1977.994884910486, y = 346.42455242966753},
            propsData = {ModeType = 0}
          },
          ["177772100396130765174"] = {
            key = "177772100396130765174",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2023.695652173913, y = 750.7193094629155},
            propsData = {}
          },
          ["177772112498630766226"] = {
            key = "177772112498630766226",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1256.695652173913, y = 344},
            propsData = {SpecialConfigId = 10040501, BlackScreenImmediately = true}
          },
          ["177875894688342880295"] = {
            key = "177875894688342880295",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1595.017344497608, y = 532.5753588516747},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772100987730765327"] = {
      isStoryNode = true,
      key = "177772100987730765327",
      type = "StoryNode",
      name = "卡嘉boss战一阶段特殊任务",
      pos = {x = 1833.9105004225962, y = 59.60457985176116},
      propsData = {
        QuestId = 10040503,
        QuestDescriptionComment = "",
        QuestDescription = "",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772100987730765332",
            startPort = "QuestStart",
            endQuest = "177772115120130767184",
            endPort = "In"
          },
          {
            startQuest = "177772115120130767184",
            startPort = "Success",
            endQuest = "177772100987730765333",
            endPort = "Success"
          },
          {
            startQuest = "177772115120130767184",
            startPort = "Fail",
            endQuest = "177875900071642881242",
            endPort = "In"
          },
          {
            startQuest = "177772115120130767184",
            startPort = "PassiveFail",
            endQuest = "177875900071642881242",
            endPort = "In"
          },
          {
            startQuest = "177875900071642881242",
            startPort = "Out",
            endQuest = "177772100987730765334",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772100987730765332"] = {
            key = "177772100987730765332",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772100987730765333"] = {
            key = "177772100987730765333",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1661.989247311828, y = 100.13978494623656},
            propsData = {ModeType = 0}
          },
          ["177772100987730765334"] = {
            key = "177772100987730765334",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1935.989247311828, y = 454.5215053763441},
            propsData = {}
          },
          ["177772115120130767184"] = {
            key = "177772115120130767184",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1252, y = 268},
            propsData = {SpecialConfigId = 10040503, BlackScreenImmediately = true}
          },
          ["177875900071642881242"] = {
            key = "177875900071642881242",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1588, y = 371.73913043478257},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772101007430765343"] = {
      isStoryNode = true,
      key = "177772101007430765343",
      type = "StoryNode",
      name = "哈洛吉二番战特殊任务",
      pos = {x = 1546.3852478973438, y = 73.94801419519548},
      propsData = {
        QuestId = 10040502,
        QuestDescriptionComment = "",
        QuestDescription = "",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772101007430765348",
            startPort = "QuestStart",
            endQuest = "177772113876130766714",
            endPort = "In"
          },
          {
            startQuest = "177772113876130766714",
            startPort = "Success",
            endQuest = "177772101007430765349",
            endPort = "Success"
          },
          {
            startQuest = "177772113876130766714",
            startPort = "Fail",
            endQuest = "177875899186742880968",
            endPort = "In"
          },
          {
            startQuest = "177772113876130766714",
            startPort = "PassiveFail",
            endQuest = "177875899186742880968",
            endPort = "In"
          },
          {
            startQuest = "177875899186742880968",
            startPort = "Out",
            endQuest = "177772101007430765350",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772101007430765348"] = {
            key = "177772101007430765348",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772101007430765349"] = {
            key = "177772101007430765349",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1748, y = 66},
            propsData = {ModeType = 0}
          },
          ["177772101007430765350"] = {
            key = "177772101007430765350",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1831.7241379310344, y = 362.55172413793105},
            propsData = {}
          },
          ["177772113876130766714"] = {
            key = "177772113876130766714",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1178.7586206896553, y = 228.13793103448276},
            propsData = {SpecialConfigId = 10040502, BlackScreenImmediately = true}
          },
          ["177875899186742880968"] = {
            key = "177875899186742880968",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1492, y = 330},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772101027530765368"] = {
      isStoryNode = true,
      key = "177772101027530765368",
      type = "StoryNode",
      name = "卡嘉boss战二阶段特殊任务",
      pos = {x = 2075.981207493303, y = 53.49346874065019},
      propsData = {
        QuestId = 10040504,
        QuestDescriptionComment = "",
        QuestDescription = "",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772101027530765373",
            startPort = "QuestStart",
            endQuest = "177772116149130767563",
            endPort = "In"
          },
          {
            startQuest = "177772116149130767563",
            startPort = "Success",
            endQuest = "177772101027530765374",
            endPort = "Success"
          },
          {
            startQuest = "177772116149130767563",
            startPort = "Fail",
            endQuest = "177875901518942881747",
            endPort = "In"
          },
          {
            startQuest = "177772116149130767563",
            startPort = "PassiveFail",
            endQuest = "177875901518942881747",
            endPort = "In"
          },
          {
            startQuest = "177875901518942881747",
            startPort = "Out",
            endQuest = "177772101027530765375",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772101027530765373"] = {
            key = "177772101027530765373",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772101027530765374"] = {
            key = "177772101027530765374",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1768.8181818181818, y = 157.9090909090909},
            propsData = {ModeType = 0}
          },
          ["177772101027530765375"] = {
            key = "177772101027530765375",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1873.3636363636365, y = 438.3636363636363},
            propsData = {}
          },
          ["177772116149130767563"] = {
            key = "177772116149130767563",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1142, y = 276},
            propsData = {SpecialConfigId = 10040504, BlackScreenImmediately = true}
          },
          ["177875901518942881747"] = {
            key = "177875901518942881747",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1584, y = 424},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772101055430765390"] = {
      isStoryNode = true,
      key = "177772101055430765390",
      type = "StoryNode",
      name = "列车失控特殊任务",
      pos = {x = 2619.420810900648, y = 81.55840380558517},
      propsData = {
        QuestId = 10040506,
        QuestDescriptionComment = "",
        QuestDescription = "",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772101055430765395",
            startPort = "QuestStart",
            endQuest = "177772117206230767909",
            endPort = "In"
          },
          {
            startQuest = "177772117206230767909",
            startPort = "Success",
            endQuest = "177772101055430765396",
            endPort = "Success"
          },
          {
            startQuest = "177772117206230767909",
            startPort = "Fail",
            endQuest = "177875903024742882166",
            endPort = "In"
          },
          {
            startQuest = "177772117206230767909",
            startPort = "PassiveFail",
            endQuest = "177875903024742882166",
            endPort = "In"
          },
          {
            startQuest = "177875903024742882166",
            startPort = "Out",
            endQuest = "177772101055430765397",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177772101055430765395"] = {
            key = "177772101055430765395",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177772101055430765396"] = {
            key = "177772101055430765396",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1626, y = 204},
            propsData = {ModeType = 0}
          },
          ["177772101055430765397"] = {
            key = "177772101055430765397",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1832, y = 586},
            propsData = {}
          },
          ["177772117206230767909"] = {
            key = "177772117206230767909",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1276, y = 280},
            propsData = {SpecialConfigId = 10040505, BlackScreenImmediately = true}
          },
          ["177875903024742882166"] = {
            key = "177875903024742882166",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1568, y = 382},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772350985934974117"] = {
      isStoryNode = true,
      key = "177772350985934974117",
      type = "StoryNode",
      name = "列车失控前",
      pos = {x = 2322.9424249467756, y = 66.29818329425697},
      propsData = {
        QuestId = 10040514,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040506_01",
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
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772350985934974122",
            startPort = "QuestStart",
            endQuest = "177772350985934974132",
            endPort = "In"
          },
          {
            startQuest = "177772350985934974132",
            startPort = "Out",
            endQuest = "177772350985934974123",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177772350985934974122"] = {
            key = "177772350985934974122",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1023.7513019369823, y = 267.60432355475626},
            propsData = {ModeType = 0}
          },
          ["177772350985934974123"] = {
            key = "177772350985934974123",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 329.74904092071506, y = 331.3789428815005},
            propsData = {ModeType = 0}
          },
          ["177772350985934974124"] = {
            key = "177772350985934974124",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 533.124999999999, y = 752.5},
            propsData = {}
          },
          ["177772350985934974132"] = {
            key = "177772350985934974132",
            type = "TalkNode",
            name = "过场-彻底失控",
            pos = {x = -477.2628212522107, y = 277.78087586382276},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC023/SQ_Ver0104_SC023.SQ_Ver0104_SC023'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
