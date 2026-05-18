return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177824405018212275116",
      startPort = "StoryStart",
      endStory = "177824401290111462353",
      endPort = "In"
    },
    {
      startStory = "177824401290111462353",
      startPort = "Success",
      endStory = "177824405018212275117",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177824401290111462353"] = {
      isStoryNode = true,
      key = "177824401290111462353",
      type = "StoryNode",
      name = "回复芙罗拉",
      pos = {x = 1048.6857142857145, y = 85.82857142857154},
      propsData = {
        QuestId = 10040312,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040312_01",
        QuestDeatil = "Description_10040312_01",
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
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177824401290111462358",
            startPort = "QuestStart",
            endQuest = "177824401290211462361",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462361",
            startPort = "Out",
            endQuest = "177824401290211462362",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462364",
            startPort = "Out",
            endQuest = "177824401290211462365",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462365",
            startPort = "Out",
            endQuest = "177824401290211462366",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462366",
            startPort = "Out",
            endQuest = "177824401290211462367",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462367",
            startPort = "Out",
            endQuest = "177824401290211462368",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462370",
            startPort = "Out",
            endQuest = "177824402934611462961",
            endPort = "In"
          },
          {
            startQuest = "177824401290111462358",
            startPort = "QuestStart",
            endQuest = "177830494403811451997",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462362",
            startPort = "Out",
            endQuest = "17784881786571467308",
            endPort = "In"
          },
          {
            startQuest = "17784881786571467308",
            startPort = "Out",
            endQuest = "177824401290211462364",
            endPort = "In"
          },
          {
            startQuest = "177824401290211462368",
            startPort = "Out",
            endQuest = "177824401290211462370",
            endPort = "In"
          },
          {
            startQuest = "177824401290111462358",
            startPort = "QuestStart",
            endQuest = "177875054463112642608",
            endPort = "In"
          },
          {
            startQuest = "177875054463112642608",
            startPort = "Out",
            endQuest = "177824401290211462360",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177824401290111462358"] = {
            key = "177824401290111462358",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 490.6896551724138, y = 307.2413793103448},
            propsData = {ModeType = 0}
          },
          ["177824401290211462359"] = {
            key = "177824401290211462359",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4199.1303030303025, y = 457.939393939394},
            propsData = {ModeType = 0}
          },
          ["177824401290211462360"] = {
            key = "177824401290211462360",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1202.5, y = 677.5},
            propsData = {}
          },
          ["177824401290211462361"] = {
            key = "177824401290211462361",
            type = "GoToNode",
            name = "靠近列车",
            pos = {x = 800.9137931034483, y = 291.3275862068965},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 152480278,
              GuideType = "M",
              GuidePointName = "Mechanism_ClosetoTrain_152480278"
            }
          },
          ["177824401290211462362"] = {
            key = "177824401290211462362",
            type = "TalkNode",
            name = "站长又出场",
            pos = {x = 1123.1310344827587, y = 344.3724137931034},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044901.10044901'",
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
          ["177824401290211462364"] = {
            key = "177824401290211462364",
            type = "TalkNode",
            name = "芙罗拉出场后",
            pos = {x = 1780.896551724138, y = 354.79999999999995},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045001.10045001'",
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
          ["177824401290211462365"] = {
            key = "177824401290211462365",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送进车厢",
            pos = {x = 2085.6000000000004, y = 348.75},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZLPoint01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177824401290211462366"] = {
            key = "177824401290211462366",
            type = "TalkNode",
            name = "车厢内对话",
            pos = {x = 2338.4000000000005, y = 336.75000000000006},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045101.10045101'",
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
          ["177824401290211462367"] = {
            key = "177824401290211462367",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送出车厢",
            pos = {x = 2623.95, y = 354.74999999999994},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Teleport_10040312",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177824401290211462368"] = {
            key = "177824401290211462368",
            type = "TalkNode",
            name = "芙罗拉看月亮前",
            pos = {x = 2990.5, y = 388.35},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045201.10045201'",
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
          ["177824401290211462370"] = {
            key = "177824401290211462370",
            type = "AtmosphereNpcHideNode",
            name = "氛围NPC显示/隐藏节点",
            pos = {x = 3566.644736842105, y = 437.50000000000006},
            propsData = {
              IsHide = false,
              AtmosphereTagList = {
                "Story_YT",
                "Story_BHCZ",
                "Story_YT_GBZ"
              }
            }
          },
          ["177824402934611462961"] = {
            key = "177824402934611462961",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3899.767973856209, y = 442.89287697951374},
            propsData = {}
          },
          ["177830494403811451997"] = {
            key = "177830494403811451997",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 806, y = 437.5},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17784881786571467308"] = {
            key = "17784881786571467308",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1461.159442545933, y = 336.19908466819226},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC010/SQ_Ver0104_SC010",
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
              HideMechanismsFX = true,
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
          ["177875054463112642608"] = {
            key = "177875054463112642608",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 828.6741486068108, y = 662.8822239422086},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["177824405018212275116"] = {
      isStoryNode = true,
      key = "177824405018212275116",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 777.1999999999999, y = 87.59999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177824405018212275117"] = {
      isStoryNode = true,
      key = "177824405018212275117",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1331.866851055188, y = 90.86607697013385},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    }
  },
  commentData = {}
}
