return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177796892407711228078",
      startPort = "StoryStart",
      endStory = "177796894577911228263",
      endPort = "In"
    },
    {
      startStory = "177796894577911228263",
      startPort = "Success",
      endStory = "177816111617563890714",
      endPort = "In"
    },
    {
      startStory = "177816111617563890714",
      startPort = "Success",
      endStory = "177796892407711228081",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177796892407711228078"] = {
      isStoryNode = true,
      key = "177796892407711228078",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1228.3875598086124, y = 170.62679425837322},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177796892407711228081"] = {
      isStoryNode = true,
      key = "177796892407711228081",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2380.4805491990846, y = 172.0366132723112},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177796894577911228263"] = {
      isStoryNode = true,
      key = "177796894577911228263",
      type = "StoryNode",
      name = "潜入特殊任务三阶段",
      pos = {x = 1648.501547987616, y = 165.95459236326104},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_06",
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
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177796894577911228268",
            startPort = "QuestStart",
            endQuest = "177796894577911228271",
            endPort = "In"
          },
          {
            startQuest = "177796894577911228271",
            startPort = "Out",
            endQuest = "177796894577911228272",
            endPort = "In"
          },
          {
            startQuest = "177796894577911228272",
            startPort = "Out",
            endQuest = "177796894577911228273",
            endPort = "In"
          },
          {
            startQuest = "177796894577911228268",
            startPort = "QuestStart",
            endQuest = "177796894577911228274",
            endPort = "In"
          },
          {
            startQuest = "177796894577911228268",
            startPort = "QuestStart",
            endQuest = "177796897296611229165",
            endPort = "In"
          },
          {
            startQuest = "177796897296611229165",
            startPort = "Out",
            endQuest = "177796894577911228270",
            endPort = "Fail"
          },
          {
            startQuest = "177796894577911228273",
            startPort = "Out",
            endQuest = "177796894577911228269",
            endPort = "Success"
          },
          {
            startQuest = "177796894577911228268",
            startPort = "QuestStart",
            endQuest = "17781615584731979",
            endPort = "In"
          },
          {
            startQuest = "177796894577911228271",
            startPort = "Out",
            endQuest = "177816670056077186166",
            endPort = "In"
          }
        },
        nodeData = {
          ["177796894577911228268"] = {
            key = "177796894577911228268",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 674.25, y = 297.0625},
            propsData = {ModeType = 0}
          },
          ["177796894577911228269"] = {
            key = "177796894577911228269",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2542.625, y = 233.8125},
            propsData = {ModeType = 0}
          },
          ["177796894577911228270"] = {
            key = "177796894577911228270",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1811.875, y = 531.5625},
            propsData = {}
          },
          ["177796894577911228271"] = {
            key = "177796894577911228271",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1322, y = 266},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480042,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru06_272480042"
            }
          },
          ["177796894577911228272"] = {
            key = "177796894577911228272",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1632, y = 272},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480043,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru07_272480043"
            }
          },
          ["177796894577911228273"] = {
            key = "177796894577911228273",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1896, y = 224},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480044,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianru08_272480044"
            }
          },
          ["177796894577911228274"] = {
            key = "177796894577911228274",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1258, y = 3.1578947368420955},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_67.10049901_67'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177796897296611229165"] = {
            key = "177796897296611229165",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1284.172932330827, y = 525.593984962406},
            propsData = {}
          },
          ["17781615584731979"] = {
            key = "17781615584731979",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1145.6842105263158, y = 672.1052631578948},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177816670056077186166"] = {
            key = "177816670056077186166",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1618, y = 41.33333333333333},
            propsData = {
              NewDescription = "Content_10040109_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["177816111617563890714"] = {
      isStoryNode = true,
      key = "177816111617563890714",
      type = "StoryNode",
      name = "潜入特殊任务尾声",
      pos = {x = 2112.9122807017548, y = 182.2105263157895},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_01",
        QuestDeatil = "Description_10040109_01",
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
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_DixiaQianruEnd_2510002",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177816111617563890719",
            startPort = "QuestStart",
            endQuest = "177816111617563890723",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890724",
            startPort = "Out",
            endQuest = "177816111617563890722",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890723",
            startPort = "Out",
            endQuest = "177816111617563890727",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890727",
            startPort = "Out",
            endQuest = "177816111617563890724",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890723",
            startPort = "Out",
            endQuest = "177816111617563890729",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890727",
            startPort = "Out",
            endQuest = "177816111617563890725",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890719",
            startPort = "QuestStart",
            endQuest = "177816111617663890731",
            endPort = "In"
          },
          {
            startQuest = "177816111617663890731",
            startPort = "Out",
            endQuest = "177816111617563890721",
            endPort = "Fail"
          },
          {
            startQuest = "177816111617563890719",
            startPort = "QuestStart",
            endQuest = "177816111617663890732",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890722",
            startPort = "Out",
            endQuest = "177816111617663890730",
            endPort = "In"
          },
          {
            startQuest = "177816111617563890723",
            startPort = "Out",
            endQuest = "17785038512389252233",
            endPort = "In"
          }
        },
        nodeData = {
          ["177816111617563890719"] = {
            key = "177816111617563890719",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -550.1251973832618, y = 315.8181818181818},
            propsData = {ModeType = 0}
          },
          ["177816111617563890720"] = {
            key = "177816111617563890720",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1901.3164110083471, y = 329.7187232122715},
            propsData = {ModeType = 0}
          },
          ["177816111617563890721"] = {
            key = "177816111617563890721",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 628.5487179487177, y = 788.3897435897436},
            propsData = {}
          },
          ["177816111617563890722"] = {
            key = "177816111617563890722",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 926.8654683177606, y = 326.1398672634665},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10041201,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041101.10041101'",
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
          ["177816111617563890723"] = {
            key = "177816111617563890723",
            type = "GoToNode",
            name = "前往",
            pos = {x = 201.00654184525177, y = 330.4748477329122},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2510002,
              GuideType = "M",
              GuidePointName = "Mechanism_DixiaQianruEnd_2510002"
            }
          },
          ["177816111617563890724"] = {
            key = "177816111617563890724",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 685.229415745545, y = 328.4220618091586},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 10,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                2510004,
                2510005,
                2510006,
                2510007,
                2510008,
                2510009,
                2510010,
                2510011,
                2510012,
                2510013
              }
            }
          },
          ["177816111617563890725"] = {
            key = "177816111617563890725",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 730.2655986486628, y = 145.85697443729975},
            propsData = {
              NewDescription = "Content_10040109_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177816111617563890727"] = {
            key = "177816111617563890727",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 444.700565995807, y = 350.01411521741653},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2510004,
                2510005,
                2510006,
                2510007,
                2510008,
                2510009,
                2510010,
                2510011,
                2510012,
                2510013
              }
            }
          },
          ["177816111617563890728"] = {
            key = "177816111617563890728",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1757.889951356887, y = -10.751433691756219},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "BP_QianruEleStart"
            }
          },
          ["177816111617563890729"] = {
            key = "177816111617563890729",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 441.6379007465961, y = 14.87725654716504},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_05.10049901_05'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177816111617663890730"] = {
            key = "177816111617663890730",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1320.5026772247363, y = 338.8861990950225},
            propsData = {}
          },
          ["177816111617663890731"] = {
            key = "177816111617663890731",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 185.4827116830316, y = 776.2274578362811},
            propsData = {}
          },
          ["177816111617663890732"] = {
            key = "177816111617663890732",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 178.92886552918534, y = 527.5505347593581},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17785038512389252233"] = {
            key = "17785038512389252233",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 595.4186602870814, y = 552.6842105263158},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "QianruBattleStart",
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
