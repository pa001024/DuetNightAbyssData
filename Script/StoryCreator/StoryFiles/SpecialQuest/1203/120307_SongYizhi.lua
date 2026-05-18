return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17647517573931",
      startPort = "StoryStart",
      endStory = "1764751888773695939",
      endPort = "In"
    },
    {
      startStory = "1764751888773695939",
      startPort = "Success",
      endStory = "17647517573945",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17647517573931"] = {
      isStoryNode = true,
      key = "17647517573931",
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
    ["17647517573945"] = {
      isStoryNode = true,
      key = "17647517573945",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1448, y = 290.9655172413793},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1764751888773695939"] = {
      isStoryNode = true,
      key = "1764751888773695939",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1126.9655172413793, y = 283.53694581280786},
      propsData = {
        QuestId = 0,
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
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        IsBacktrack = false,
        SubRegionId = 104504,
        SubRegionIdList = {104503},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_1203060401_132010086",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1764751888773695940",
            startPort = "QuestStart",
            endQuest = "1764751921075696879",
            endPort = "In"
          },
          {
            startQuest = "17647534059451393629",
            startPort = "Out",
            endQuest = "17647535734171394073",
            endPort = "In"
          },
          {
            startQuest = "1764751888773695940",
            startPort = "QuestStart",
            endQuest = "176649422180914859545",
            endPort = "In"
          },
          {
            startQuest = "176649422180914859545",
            startPort = "Out",
            endQuest = "1764751888773695946",
            endPort = "Fail"
          },
          {
            startQuest = "1764751921075696879",
            startPort = "Out",
            endQuest = "17647534059451393629",
            endPort = "In"
          },
          {
            startQuest = "17647535734171394073",
            startPort = "Out",
            endQuest = "17665686141678126697",
            endPort = "In"
          },
          {
            startQuest = "17665686141678126697",
            startPort = "Out",
            endQuest = "176649340228713444054",
            endPort = "In"
          },
          {
            startQuest = "1764751888773695940",
            startPort = "QuestStart",
            endQuest = "17671672417933416",
            endPort = "In"
          },
          {
            startQuest = "1764751888773695940",
            startPort = "QuestStart",
            endQuest = "177010843806912217366",
            endPort = "Input"
          },
          {
            startQuest = "17665686451958127284",
            startPort = "Out",
            endQuest = "176649419213614858941",
            endPort = "In"
          },
          {
            startQuest = "1764751921075696879",
            startPort = "Out",
            endQuest = "1773825335421870096",
            endPort = "In"
          },
          {
            startQuest = "1773825335421870096",
            startPort = "Out",
            endQuest = "1773641520817754",
            endPort = "In"
          },
          {
            startQuest = "1773825335421870096",
            startPort = "Out",
            endQuest = "17647526620171392373",
            endPort = "In"
          },
          {
            startQuest = "176649340228713444054",
            startPort = "Out",
            endQuest = "17743493954892628797",
            endPort = "Input"
          },
          {
            startQuest = "17743493954892628797",
            startPort = "Out",
            endQuest = "1774767434832861",
            endPort = "In"
          },
          {
            startQuest = "1774767434832861",
            startPort = "Out",
            endQuest = "17665686451958127284",
            endPort = "In"
          }
        },
        nodeData = {
          ["1764751888773695940"] = {
            key = "1764751888773695940",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1001.923076923077, y = 294.2307692307692},
            propsData = {ModeType = 0}
          },
          ["1764751888773695943"] = {
            key = "1764751888773695943",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2602.6666666666665, y = 320.19047619047615},
            propsData = {ModeType = 0}
          },
          ["1764751888773695946"] = {
            key = "1764751888773695946",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1481.377450980392, y = 687.4950980392157},
            propsData = {}
          },
          ["1764751921075696879"] = {
            key = "1764751921075696879",
            type = "ChangeRoleNode",
            name = "切换苏乙",
            pos = {x = 1399.2054758522142, y = 296.89698902037424},
            propsData = {QuestRoleId = 15040102, IsPlayFX = false}
          },
          ["17647526620171392373"] = {
            key = "17647526620171392373",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2012.7046818879855, y = -72.51903087837755},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12062820,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17647534059451393629"] = {
            key = "17647534059451393629",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1720.1902224396501, y = 270.74469663314045},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 132010086,
              GuideType = "M",
              GuidePointName = "Mechanism_1203060401_132010086"
            }
          },
          ["17647535734171394073"] = {
            key = "17647535734171394073",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1995.9032627625581, y = 272.86313407433903},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1203/12062901.12062901'",
              TalkType = "FixSimple",
              TalkStageName = "TalkStageNew_12030602",
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
          ["176649340228713444054"] = {
            key = "176649340228713444054",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1599.7864420790322, y = 472.50627405864634},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 250017,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_12030703Xiaoan_132420056",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 12063001,
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
          ["176649419213614858941"] = {
            key = "176649419213614858941",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2633.326965305226, y = 471.82828282828285},
            propsData = {}
          },
          ["176649422180914859545"] = {
            key = "176649422180914859545",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1209.654751131222, y = 671.785294117647},
            propsData = {}
          },
          ["17665686141678126697"] = {
            key = "17665686141678126697",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2243.0785469107554, y = 290.49061784897015},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132420056}
            }
          },
          ["17665686451958127284"] = {
            key = "17665686451958127284",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2379.663505189192, y = 481.8932089776482},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {132420056}
            }
          },
          ["17671672417933416"] = {
            key = "17671672417933416",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1400.9458587896215, y = 109.83972278566587},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "NewTargetPoint_1203070302",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17677746994967363"] = {
            key = "17677746994967363",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2669.8386727688785, y = 671.1777244494637},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 132420061,
              GuideType = "M",
              GuidePointName = "Mechanism_1203070301_132420061"
            }
          },
          ["177010843806912217366"] = {
            key = "177010843806912217366",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1400.711274273394, y = -65.09545170853474},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["1773641520817754"] = {
            key = "1773641520817754",
            type = "ShowGuideMainNode",
            name = "显示图文引导",
            pos = {x = 2007.8086124401914, y = 88.96889952153113},
            propsData = {GuideId = 143}
          },
          ["1773825335421870096"] = {
            key = "1773825335421870096",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1720.8484848484848, y = 83.06060606060585},
            propsData = {WaitTime = 1.5}
          },
          ["17743493954892628797"] = {
            key = "17743493954892628797",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1888.7907894736843, y = 489.653947368421},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          },
          ["1774767434832861"] = {
            key = "1774767434832861",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2120.2045559789367, y = 477.2011953904367},
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
