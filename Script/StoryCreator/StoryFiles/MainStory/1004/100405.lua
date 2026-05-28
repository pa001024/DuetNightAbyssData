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
    },
    {
      startStory = "17685517578213352620",
      startPort = "Success",
      endStory = "17739990080483936734",
      endPort = "In"
    },
    {
      startStory = "177772101055430765390",
      startPort = "Success",
      endStory = "177919557921211107683",
      endPort = "In"
    },
    {
      startStory = "177919557921211107683",
      startPort = "Success",
      endStory = "17685517578213352620",
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
      pos = {x = 2221.167448085886, y = 491.157544261724},
      propsData = {
        QuestId = 10040507,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17685517578223352625",
            startPort = "QuestStart",
            endQuest = "17685517578223352629",
            endPort = "In"
          },
          {
            startQuest = "17685517578223352629",
            startPort = "Out",
            endQuest = "1779001647323103332703",
            endPort = "In"
          },
          {
            startQuest = "1779001654274103332962",
            startPort = "Out",
            endQuest = "1779001654274103332963",
            endPort = "In"
          },
          {
            startQuest = "1779001654274103332963",
            startPort = "Out",
            endQuest = "1779001654274103332964",
            endPort = "In"
          },
          {
            startQuest = "1779001647323103332703",
            startPort = "Out",
            endQuest = "1779001654274103332962",
            endPort = "In"
          },
          {
            startQuest = "1779001654274103332964",
            startPort = "Out",
            endQuest = "17685517578223352626",
            endPort = "Success"
          },
          {
            startQuest = "17685517578223352625",
            startPort = "QuestStart",
            endQuest = "177969886403047908961",
            endPort = "In"
          }
        },
        nodeData = {
          ["17685517578223352625"] = {
            key = "17685517578223352625",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 73.19444444444443, y = 326.25},
            propsData = {ModeType = 0}
          },
          ["17685517578223352626"] = {
            key = "17685517578223352626",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1917.3225063938623, y = 421.2920716112532},
            propsData = {
              ModeType = 1,
              Id = 106201,
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
            pos = {x = 459.33986928104605, y = 338.3545751633987},
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
          ["1779001647323103332703"] = {
            key = "1779001647323103332703",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 760.5, y = 357.50000000000006},
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
          },
          ["1779001654274103332962"] = {
            key = "1779001654274103332962",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 701.4487339663503, y = 491.98550724637676},
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
          ["1779001654274103332963"] = {
            key = "1779001654274103332963",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1070.2686573379979, y = 496.87439613526567},
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
          ["1779001654274103332964"] = {
            key = "1779001654274103332964",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1437.55126603365, y = 502.01449275362324},
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
          ["177969886403047908961"] = {
            key = "177969886403047908961",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 462.75, y = 182.25},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
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
      pos = {x = 1434.0301196439736, y = 752.5274628691811},
      propsData = {
        QuestId = 10040508,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
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
        StoryGuidePointName = "BP_FuluoMTTalk",
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
          },
          {
            startQuest = "17772720594141392468",
            startPort = "Out",
            endQuest = "177969896594449360371",
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
          },
          ["177969896594449360371"] = {
            key = "177969896594449360371",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1166, y = 166},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106201},
              bStoreToServer = false
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
      pos = {x = 2045.887325236027, y = 759.0077032170688},
      propsData = {
        QuestId = 10040509,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
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
          },
          {
            startQuest = "17772726112825555884",
            startPort = "Out",
            endQuest = "177969907659952263446",
            endPort = "In"
          },
          {
            startQuest = "17739992114523939815",
            startPort = "Out",
            endQuest = "177969908456752263581",
            endPort = "In"
          },
          {
            startQuest = "177969908456752263581",
            startPort = "Out",
            endQuest = "17739990170783937005",
            endPort = "Success"
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
            pos = {x = 1909, y = 411},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              LoadingId = 10610102,
              IsWhite = false
            }
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
            pos = {x = 1318.3783783783783, y = 365.6216216216216},
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
            pos = {x = 921.1182275541793, y = 365.1710526315789},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_KajiaTalkFinal",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177969907659952263446"] = {
            key = "177969907659952263446",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1302, y = 648},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0043_story_empire.0043_story_empire'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["177969908456752263581"] = {
            key = "177969908456752263581",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1572, y = 480},
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
    ["17739990279033937344"] = {
      isStoryNode = true,
      key = "17739990279033937344",
      type = "StoryNode",
      name = "莉莉寇",
      pos = {x = 2326.69340717836, y = 766.7482369799809},
      propsData = {
        QuestId = 10040510,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = true,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_TrailnPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177952830219515971835",
            startPort = "Out",
            endQuest = "177952833482215972743",
            endPort = "In"
          },
          {
            startQuest = "177952833482215972743",
            startPort = "Out",
            endQuest = "17739990279033937348",
            endPort = "Success"
          },
          {
            startQuest = "17739990279033937345",
            startPort = "QuestStart",
            endQuest = "17739990553773937968",
            endPort = "In"
          },
          {
            startQuest = "17739990279033937345",
            startPort = "QuestStart",
            endQuest = "17770229878252285",
            endPort = "In"
          },
          {
            startQuest = "17739990279033937345",
            startPort = "QuestStart",
            endQuest = "177969909868552264023",
            endPort = "In"
          },
          {
            startQuest = "17739990553773937968",
            startPort = "Out",
            endQuest = "177969910860052264244",
            endPort = "In"
          },
          {
            startQuest = "177969910860052264244",
            startPort = "Out",
            endQuest = "177952830219515971835",
            endPort = "In"
          }
        },
        nodeData = {
          ["17739990279033937345"] = {
            key = "17739990279033937345",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1437.113442113442, y = 608.583916083916},
            propsData = {ModeType = 0}
          },
          ["17739990279033937348"] = {
            key = "17739990279033937348",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2604.0349650349654, y = 657.3776223776224},
            propsData = {ModeType = 0}
          },
          ["17739990279033937351"] = {
            key = "17739990279033937351",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2851.818181818182, y = 608.6363636363636},
            propsData = {}
          },
          ["17739990553773937968"] = {
            key = "17739990553773937968",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1792.5292929292928, y = 628.1191919191918},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049801.10049801'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
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
            pos = {x = 1804.4462315462315, y = 426.1074592074592},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Chapter03Done",
              UnitId = -1
            }
          },
          ["177952830219515971835"] = {
            key = "177952830219515971835",
            type = "OpenChapterUINode",
            name = "打开章节开始UI",
            pos = {x = 2070.4688995215306, y = 634.995670995671},
            propsData = {ChapterUIId = 100400, UIType = "End"}
          },
          ["177952833482215972743"] = {
            key = "177952833482215972743",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2322.7416267942585, y = 656.8138528138529},
            propsData = {WaitTime = 1}
          },
          ["177969909868552264023"] = {
            key = "177969909868552264023",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1620, y = 786},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {210101},
              bStoreToServer = false
            }
          },
          ["177969910860052264244"] = {
            key = "177969910860052264244",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2294.1935483870966, y = 778.0645161290323},
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
    ["17739991462943938782"] = {
      isStoryNode = true,
      key = "17739991462943938782",
      type = "StoryNode",
      name = "幻境下",
      pos = {x = 1791.1679633334147, y = 750.5456851528702},
      propsData = {
        QuestId = 10040511,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
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
        StoryGuidePointName = "BP_SpecialFail",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
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
          },
          {
            startQuest = "17739991462953938790",
            startPort = "Out",
            endQuest = "177969904848350812026",
            endPort = "In"
          },
          {
            startQuest = "177969904848350812026",
            startPort = "Out",
            endQuest = "17739991462953938788",
            endPort = "Success"
          },
          {
            startQuest = "17739991462953938787",
            startPort = "QuestStart",
            endQuest = "177969904019450811865",
            endPort = "In"
          }
        },
        nodeData = {
          ["17739991462953938787"] = {
            key = "17739991462953938787",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 317},
            propsData = {ModeType = 0}
          },
          ["17739991462953938788"] = {
            key = "17739991462953938788",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2069.6666666666665, y = 334.3333333333333},
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
            pos = {x = 1473.6201372997712, y = 342.4797864225782},
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
            pos = {x = 1079.297141074029, y = 317.985011936957},
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
          },
          ["177969904019450811865"] = {
            key = "177969904019450811865",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1236, y = 504},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106001},
              bStoreToServer = false
            }
          },
          ["177969904848350812026"] = {
            key = "177969904848350812026",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1788, y = 370},
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
    ["177772100396130765167"] = {
      isStoryNode = true,
      key = "177772100396130765167",
      type = "StoryNode",
      name = "炮台特殊任务",
      pos = {x = 1225.3802917141197, y = 79.293403572843},
      propsData = {
        QuestId = 10040501,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040501_01",
        QuestDeatil = "Description_10040501_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = true,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = true,
        IsBacktrack = false,
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "BP_TrainPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772112498630766226",
            startPort = "Success",
            endQuest = "177772100396130765171",
            endPort = "Success"
          },
          {
            startQuest = "177875894688342880295",
            startPort = "Out",
            endQuest = "177772100396130765174",
            endPort = "Fail"
          },
          {
            startQuest = "177952573124911620550",
            startPort = "Out",
            endQuest = "177772100396130765174",
            endPort = "Fail"
          },
          {
            startQuest = "177772112498630766226",
            startPort = "PassiveFail",
            endQuest = "177952573124911620550",
            endPort = "In"
          },
          {
            startQuest = "177772112498630766226",
            startPort = "Fail",
            endQuest = "177875894688342880295",
            endPort = "In"
          },
          {
            startQuest = "177772100396130765168",
            startPort = "QuestStart",
            endQuest = "17797874344247271808",
            endPort = "In"
          },
          {
            startQuest = "17797874344247271808",
            startPort = "Out",
            endQuest = "177772112498630766226",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772100396130765168"] = {
            key = "177772100396130765168",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 360},
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
            pos = {x = 1986.195652173913, y = 626.5526427962488},
            propsData = {}
          },
          ["177772112498630766226"] = {
            key = "177772112498630766226",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1262.5289855072463, y = 358.1666666666667},
            propsData = {SpecialConfigId = 10040501, BlackScreenImmediately = true}
          },
          ["177875894688342880295"] = {
            key = "177875894688342880295",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1622.517344497608, y = 462.57535885167465},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["177952573124911620550"] = {
            key = "177952573124911620550",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1622.0667608992837, y = 627.1708254083825},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_TrainPaotaiStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17797874344247271808"] = {
            key = "17797874344247271808",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 942.8574645303543, y = 202.7135746606335},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0008_combat_zhuizhuzhan.0008_combat_zhuizhuzhan'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
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
      pos = {x = 1847.9105004225962, y = 59.60457985176116},
      propsData = {
        QuestId = 10040503,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040505_01",
        QuestDeatil = "Description_10040505_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
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
      pos = {x = 1544.8063005289227, y = 72.36906682677443},
      propsData = {
        QuestId = 10040502,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040501_03",
        QuestDeatil = "Description_10040503_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
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
        QuestDescription = "Content_10040505_03",
        QuestDeatil = "Description_10040506_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
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
      pos = {x = 2691.587993563187, y = 44.49958027617342},
      propsData = {
        QuestId = 10040506,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040506_01",
        QuestDeatil = "Description_10040506_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
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
      pos = {x = 2321.6924249467756, y = 66.29818329425697},
      propsData = {
        QuestId = 10040514,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040506_01",
        QuestDeatil = "Description_10040506_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772350985934974132",
            startPort = "Out",
            endQuest = "177772350985934974123",
            endPort = "Success"
          },
          {
            startQuest = "177772350985934974122",
            startPort = "QuestStart",
            endQuest = "177936604515058991910",
            endPort = "Input"
          },
          {
            startQuest = "177936604515058991910",
            startPort = "Out",
            endQuest = "177772350985934974132",
            endPort = "In"
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
              PauseGameGlobal = false,
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
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["177936604515058991910"] = {
            key = "177936604515058991910",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = -746.1835655314753, y = 257.6804695562437},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177919557921211107683"] = {
      isStoryNode = true,
      key = "177919557921211107683",
      type = "StoryNode",
      name = "列车失控特殊任后",
      pos = {x = 2693.1557385515134, y = 400.5813304113451},
      propsData = {
        QuestId = 10040512,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040507_01",
        QuestDeatil = "Description_10040507_01",
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
        StoryGuidePointName = "BP_TrailnPaotaiStart",
        JumpId = 0,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177919557921211107688",
            startPort = "QuestStart",
            endQuest = "17795213188823871489",
            endPort = "Input"
          },
          {
            startQuest = "17795213188823871489",
            startPort = "Out",
            endQuest = "177919559781411108256",
            endPort = "In"
          },
          {
            startQuest = "17795213188823871489",
            startPort = "Out",
            endQuest = "177969881698146457301",
            endPort = "In"
          },
          {
            startQuest = "177919559781411108256",
            startPort = "Out",
            endQuest = "177969882188246457520",
            endPort = "In"
          },
          {
            startQuest = "177969882188246457520",
            startPort = "Out",
            endQuest = "177919557921211107689",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177919557921211107688"] = {
            key = "177919557921211107688",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1054.042735042735, y = 336.3162393162393},
            propsData = {ModeType = 0}
          },
          ["177919557921211107689"] = {
            key = "177919557921211107689",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2475.196581196581, y = 374.5897435897436},
            propsData = {ModeType = 0}
          },
          ["177919557921211107690"] = {
            key = "177919557921211107690",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177919559781411108256"] = {
            key = "177919559781411108256",
            type = "TalkNode",
            name = "过场-签订契约",
            pos = {x = 1815.0434782608695, y = 375.91304347826093},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC025/SQ_Ver0104_SC025",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
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
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17795213188823871489"] = {
            key = "17795213188823871489",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1326.196581196581, y = 351.1880341880342},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = false
            }
          },
          ["177969881698146457301"] = {
            key = "177969881698146457301",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1718, y = 138},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0172_story_counter_attack.0172_story_counter_attack'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["177969882188246457520"] = {
            key = "177969882188246457520",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2164, y = 364.8888888888889},
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
