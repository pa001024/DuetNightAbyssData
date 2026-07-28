return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17752861836621",
      startPort = "StoryStart",
      endStory = "1775291493081250",
      endPort = "In"
    },
    {
      startStory = "17752918023301634",
      startPort = "Success",
      endStory = "17752918368102354",
      endPort = "In"
    },
    {
      startStory = "17752918368102354",
      startPort = "Success",
      endStory = "17752918548852697",
      endPort = "In"
    },
    {
      startStory = "17752918548852697",
      startPort = "Success",
      endStory = "17752918707133052",
      endPort = "In"
    },
    {
      startStory = "17752918707133052",
      startPort = "Success",
      endStory = "17752861836635",
      endPort = "StoryEnd"
    },
    {
      startStory = "1775291493081250",
      startPort = "Success",
      endStory = "17752918023301634",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17752861836621"] = {
      isStoryNode = true,
      key = "17752861836621",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 746.296296549214, y = 288.8888889412167},
      propsData = {QuestChainId = 200401},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17752861836635"] = {
      isStoryNode = true,
      key = "17752861836635",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2301.851854197882, y = 679.6296278417628},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775291493081250"] = {
      isStoryNode = true,
      key = "1775291493081250",
      type = "PreStoryNode",
      name = "任务前置节点",
      pos = {x = 1103.1534393544562, y = 334.34920646202085},
      propsData = {
        QuestId = 20040100,
        QuestDescriptionComment = "在站台旁接任务",
        SubRegionId = 106001,
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        bIsPlayBlackScreenOnComplete = false,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775291493081251",
            startPort = "QuestStart",
            endQuest = "17766889384822882",
            endPort = "In"
          },
          {
            startQuest = "17766889384822882",
            startPort = "Out",
            endQuest = "17766893550623573",
            endPort = "In"
          },
          {
            startQuest = "17766893550623573",
            startPort = "Out",
            endQuest = "17766894368491386323",
            endPort = "In"
          },
          {
            startQuest = "17766894368491386323",
            startPort = "Out",
            endQuest = "177669108795712446926",
            endPort = "In"
          },
          {
            startQuest = "17766894368491386323",
            startPort = "Out",
            endQuest = "17773418152063135",
            endPort = "In"
          },
          {
            startQuest = "17773418152063135",
            startPort = "Out",
            endQuest = "177738206237919462375",
            endPort = "In"
          },
          {
            startQuest = "177738206237919462375",
            startPort = "Out",
            endQuest = "1775291493083259",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775291493081251"] = {
            key = "1775291493081251",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 788.8888889412167, y = 407.4074069015719},
            propsData = {ModeType = 0}
          },
          ["1775291493083259"] = {
            key = "1775291493083259",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2922.449811458875, y = 437.7050867798789},
            propsData = {ModeType = 0}
          },
          ["1775291493083279"] = {
            key = "1775291493083279",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2931.481480862269, y = 655.5555557648668},
            propsData = {}
          },
          ["17766889384822882"] = {
            key = "17766889384822882",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1111.6316353680884, y = 414.5085109850459},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312480198,
                312480197,
                312480196
              }
            }
          },
          ["17766893550623573"] = {
            key = "17766893550623573",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1469.0390410922844, y = 394.13814071060995},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312480199,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_312480199"
            }
          },
          ["17766894368491386323"] = {
            key = "17766894368491386323",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1833.8538541890027, y = 379.3233259655655},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040101.20040101'",
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
          ["177669108795712446926"] = {
            key = "177669108795712446926",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2342.3683183003764, y = 187.28508786690756},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312480198,
                312480197,
                312480196
              }
            }
          },
          ["17773418152063135"] = {
            key = "17773418152063135",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2208.059532080663, y = 397.6206820388803},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040102.20040102'",
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
          ["177738206237919462375"] = {
            key = "177738206237919462375",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2575.3808110416403, y = 425.5945940960255},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200197,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1775291550887945"] = {
      isStoryNode = true,
      key = "1775291550887945",
      type = "StoryNode",
      name = "离开丢人现场",
      pos = {x = 1555.4930092774496, y = 144.91978195799734},
      propsData = {
        QuestId = 20040101,
        QuestDescriptionComment = "离开丢人现场",
        QuestDescription = "Description_200401_1",
        QuestDeatil = "Content_200401_1",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_QuestTrigger_312480200",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775291550887946",
            startPort = "QuestStart",
            endQuest = "17766902905005533832",
            endPort = "In"
          },
          {
            startQuest = "17766902905005533832",
            startPort = "Out",
            endQuest = "17766906935228298673",
            endPort = "In"
          },
          {
            startQuest = "17766906935228298673",
            startPort = "Out",
            endQuest = "1775291550888949",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775291550887946"] = {
            key = "1775291550887946",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775291550888949"] = {
            key = "1775291550888949",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775291550888952"] = {
            key = "1775291550888952",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17766902905005533832"] = {
            key = "17766902905005533832",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1292.8999191615094, y = 296.7430459012672},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312480200,
              GuideType = "M",
              GuidePointName = "Mechanism_QuestTrigger_312480200"
            }
          },
          ["17766906935228298673"] = {
            key = "17766906935228298673",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1671.7002727030517, y = 330.5870606887551},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040102.20040102'",
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
          }
        },
        commentData = {}
      }
    },
    ["17752918023301634"] = {
      isStoryNode = true,
      key = "17752918023301634",
      type = "StoryNode",
      name = "去烟囱取东西",
      pos = {x = 1713.161166262562, y = 397.25743908318674},
      propsData = {
        QuestId = 20040102,
        QuestDescriptionComment = "去烟囱取东西",
        QuestDescription = "Description_200401_2",
        QuestDeatil = "Content_200401_2",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign_20040102",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177669115033413829911",
            startPort = "Out",
            endQuest = "177669177661817980146",
            endPort = "In"
          },
          {
            startQuest = "177669170645617979683",
            startPort = "Out",
            endQuest = "177669115033413829911",
            endPort = "In"
          },
          {
            startQuest = "177669177661817980146",
            startPort = "Out",
            endQuest = "17752918023301640",
            endPort = "Success"
          },
          {
            startQuest = "17767564865072773206",
            startPort = "Out",
            endQuest = "177669170645617979683",
            endPort = "In"
          },
          {
            startQuest = "17770321611101390391",
            startPort = "Out",
            endQuest = "17770159101961586",
            endPort = "In"
          },
          {
            startQuest = "17770324743962778178",
            startPort = "Out",
            endQuest = "17770324793932778382",
            endPort = "In"
          },
          {
            startQuest = "17770321611101390391",
            startPort = "Out",
            endQuest = "17770324743962778178",
            endPort = "Stop"
          },
          {
            startQuest = "17770324743962778178",
            startPort = "Out",
            endQuest = "17770321611101390391",
            endPort = "Stop"
          },
          {
            startQuest = "17752918023301639",
            startPort = "QuestStart",
            endQuest = "17773852012375561849",
            endPort = "In"
          },
          {
            startQuest = "17773852012375561849",
            startPort = "Out",
            endQuest = "17770321611101390391",
            endPort = "In"
          },
          {
            startQuest = "17773852012375561849",
            startPort = "Out",
            endQuest = "17770324743962778178",
            endPort = "In"
          },
          {
            startQuest = "17773852012375561849",
            startPort = "Out",
            endQuest = "17767564865072773206",
            endPort = "In"
          }
        },
        nodeData = {
          ["17752918023301639"] = {
            key = "17752918023301639",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 453.9793378435513, y = 266.3049104994742},
            propsData = {ModeType = 0}
          },
          ["17752918023301640"] = {
            key = "17752918023301640",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3071.6216160207878, y = 370.2702688212984},
            propsData = {ModeType = 0}
          },
          ["17752918023301641"] = {
            key = "17752918023301641",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177669115033413829911"] = {
            key = "177669115033413829911",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 2345.9459377815465, y = 314.1081069099198},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 20040101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign_20040102",
              IsUseCount = false
            }
          },
          ["177669170645617979683"] = {
            key = "177669170645617979683",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1986.7789318639366, y = 322.09465272623896},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200085,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177669177661817980146"] = {
            key = "177669177661817980146",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2692.6386641234226, y = 335.53094588196944},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040104.20040104'",
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
          ["17767564865072773206"] = {
            key = "17767564865072773206",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1547.8393757322651, y = 313.27348683229303},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312480201,
              GuideType = "P",
              GuidePointName = "QuestSign_20040102"
            }
          },
          ["17770159101961586"] = {
            key = "17770159101961586",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2022.6750913641417, y = -283.8399360771669},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200078,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17770321611101390391"] = {
            key = "17770321611101390391",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1531.9273872876545, y = -288.3290550951983},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312890077,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["17770324743962778178"] = {
            key = "17770324743962778178",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1558.1391112559243, y = 19.779043871117807},
            propsData = {
              GuideUIEnable = false,
              StaticCreatorId = 312890076,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["17770324793932778382"] = {
            key = "17770324793932778382",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1964.5528597131251, y = -0.3206235406324822},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200078,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17773852012375561849"] = {
            key = "17773852012375561849",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 916.4359512773312, y = 342.9217291297339},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480211}
            }
          }
        },
        commentData = {}
      }
    },
    ["17752918368102354"] = {
      isStoryNode = true,
      key = "17752918368102354",
      type = "StoryNode",
      name = "归还照片",
      pos = {x = 2320.497354872157, y = 379.21951028484546},
      propsData = {
        QuestId = 20040103,
        QuestDescriptionComment = "还照片",
        QuestDescription = "Description_200401_3",
        QuestDeatil = "Content_200401_3",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Keni_312890085",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17767590209656925548",
            startPort = "Out",
            endQuest = "17767590265416925634",
            endPort = "In"
          },
          {
            startQuest = "17767590265416925634",
            startPort = "Out",
            endQuest = "17767590317586925756",
            endPort = "In"
          },
          {
            startQuest = "17767590317586925756",
            startPort = "Out",
            endQuest = "177676107161113852056",
            endPort = "In"
          },
          {
            startQuest = "177676107161113852056",
            startPort = "Out",
            endQuest = "17768414770022781119",
            endPort = "In"
          },
          {
            startQuest = "17752918368102359",
            startPort = "QuestStart",
            endQuest = "17767590209656925548",
            endPort = "In"
          },
          {
            startQuest = "17768414770022781119",
            startPort = "Out",
            endQuest = "17752918368102360",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17752918368102359"] = {
            key = "17752918368102359",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918368102360"] = {
            key = "17752918368102360",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918368102361"] = {
            key = "17752918368102361",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17767590209656925548"] = {
            key = "17767590209656925548",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1160.574428306554, y = 104.35134038047642},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312890083,
                312890084,
                312890085
              }
            }
          },
          ["17767590265416925634"] = {
            key = "17767590265416925634",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1465.413134232788, y = 107.57714679239433},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312890082,
              GuideType = "N",
              GuidePointName = "Npc_Keni_312890085"
            }
          },
          ["17767590317586925756"] = {
            key = "17767590317586925756",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1849.2840972510091, y = 102.73843717451751},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040105.20040105'",
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
          ["177676107161113852056"] = {
            key = "177676107161113852056",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2207.34860774334, y = 91.44811288698389},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312890083,
                312890084,
                312890085
              }
            }
          },
          ["17768414770022781119"] = {
            key = "17768414770022781119",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2477.2446816035667, y = 94.54498871957179},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200120,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17752918548852697"] = {
      isStoryNode = true,
      key = "17752918548852697",
      type = "StoryNode",
      name = "擦玻璃",
      pos = {x = 1111.038671054691, y = 663.9788327359357},
      propsData = {
        QuestId = 20040104,
        QuestDescriptionComment = "擦玻璃",
        QuestDescription = "Description_200401_4",
        QuestDeatil = "Content_200401_4",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign_20040104",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752918548852702",
            startPort = "QuestStart",
            endQuest = "17768286613292777685",
            endPort = "In"
          },
          {
            startQuest = "17768286613292777685",
            startPort = "Out",
            endQuest = "17768286385842777189",
            endPort = "In"
          },
          {
            startQuest = "17768286385842777189",
            startPort = "Fail",
            endQuest = "17768417722105554306",
            endPort = "In"
          },
          {
            startQuest = "17768286385842777189",
            startPort = "PassiveFail",
            endQuest = "17768417722105554306",
            endPort = "In"
          },
          {
            startQuest = "17768286385842777189",
            startPort = "Success",
            endQuest = "17752918548852703",
            endPort = "Success"
          },
          {
            startQuest = "17768417722105554306",
            startPort = "Out",
            endQuest = "17752918548852704",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17752918548852702"] = {
            key = "17752918548852702",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918548852703"] = {
            key = "17752918548852703",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918548852704"] = {
            key = "17752918548852704",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2568.9189236838074, y = 547.2973004460247},
            propsData = {}
          },
          ["17768286385842777189"] = {
            key = "17768286385842777189",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1473.9999994550433, y = 298.2857098482094},
            propsData = {SpecialConfigId = 20040104, BlackScreenImmediately = false}
          },
          ["17768286613292777685"] = {
            key = "17768286613292777685",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1117.1428577397146, y = 326.28571402621105},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312480270,
              GuideType = "P",
              GuidePointName = "QuestSign_20040104"
            }
          },
          ["17768417722105554306"] = {
            key = "17768417722105554306",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1843.5661318223954, y = 466.5608419501972},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RespawnPoint_20040104",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17752918707133052"] = {
      isStoryNode = true,
      key = "17752918707133052",
      type = "StoryNode",
      name = "最后对话",
      pos = {x = 1536.7407447874248, y = 672.4444411739563},
      propsData = {
        QuestId = 20040105,
        QuestDescriptionComment = "找柯尼对话",
        QuestDescription = "Description_200401_5",
        QuestDeatil = "Content_200401_5",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = true,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Keni_312480257",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752918707143057",
            startPort = "QuestStart",
            endQuest = "177676072786312464655",
            endPort = "In"
          },
          {
            startQuest = "177676072786312464655",
            startPort = "Out",
            endQuest = "177676073493512464720",
            endPort = "In"
          },
          {
            startQuest = "177676073493512464720",
            startPort = "Out",
            endQuest = "17767804424244770",
            endPort = "In"
          },
          {
            startQuest = "17767804424244770",
            startPort = "Out",
            endQuest = "17752918707143058",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17752918707143057"] = {
            key = "17752918707143057",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918707143058"] = {
            key = "17752918707143058",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17752918707143059"] = {
            key = "17752918707143059",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177676072786312464655"] = {
            key = "177676072786312464655",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1218, y = 396},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480257}
            }
          },
          ["177676073493512464720"] = {
            key = "177676073493512464720",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1700.571430777206, y = 392.5714285973789},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700402,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Keni_312480257",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200401/20040107.20040107'",
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
          ["17767804424244770"] = {
            key = "17767804424244770",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2228.909350172988, y = 440.67939203058927},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {312480257}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
