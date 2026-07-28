return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782430655667492317",
      startPort = "StoryStart",
      endStory = "17782428113396680838",
      endPort = "In"
    },
    {
      startStory = "17782428113396680838",
      startPort = "Success",
      endStory = "17782430655667492318",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782428113396680838"] = {
      isStoryNode = true,
      key = "17782428113396680838",
      type = "StoryNode",
      name = "调查任务",
      pos = {x = 1055.8857142857146, y = 91.82857142857148},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040307_05",
        QuestDeatil = "Description_10040307_02",
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_BaozhaStart_2530031",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17782428113396680846",
            startPort = "Out",
            endQuest = "17782428113406680848",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680846",
            startPort = "Out",
            endQuest = "17782428113406680849",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680846",
            startPort = "Out",
            endQuest = "17782428113416680850",
            endPort = "In"
          },
          {
            startQuest = "17782428113406680848",
            startPort = "Out",
            endQuest = "17782428113406680847",
            endPort = "Branch_1"
          },
          {
            startQuest = "17782428113406680849",
            startPort = "Out",
            endQuest = "17782428113406680847",
            endPort = "Branch_2"
          },
          {
            startQuest = "17782428113416680850",
            startPort = "Out",
            endQuest = "17782428113406680847",
            endPort = "Branch_3"
          },
          {
            startQuest = "17782428113416680853",
            startPort = "Out",
            endQuest = "17782428113396680846",
            endPort = "In"
          },
          {
            startQuest = "17782428113406680847",
            startPort = "Out",
            endQuest = "17782428113416680851",
            endPort = "In"
          },
          {
            startQuest = "17782428113416680851",
            startPort = "Out",
            endQuest = "17782428113426680854",
            endPort = "In"
          },
          {
            startQuest = "17782428113426680854",
            startPort = "Out",
            endQuest = "17782430410516681777",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "17783048456926682231",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "1778740514345761",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "17787503049716808370",
            endPort = "In"
          },
          {
            startQuest = "17787503049716808370",
            startPort = "Out",
            endQuest = "17782428113396680845",
            endPort = "Fail"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "177891740477778710633",
            endPort = "Input"
          },
          {
            startQuest = "17782428113416680853",
            startPort = "Out",
            endQuest = "17797161269141943893",
            endPort = "In"
          },
          {
            startQuest = "17782428113416680853",
            startPort = "Out",
            endQuest = "17782428113416680852",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "17797161728262911948",
            endPort = "In"
          },
          {
            startQuest = "17782428113416680853",
            startPort = "Out",
            endQuest = "17797162590523880361",
            endPort = "In"
          },
          {
            startQuest = "17782428113396680843",
            startPort = "QuestStart",
            endQuest = "1779421207812963",
            endPort = "In"
          },
          {
            startQuest = "1779421207812963",
            startPort = "Out",
            endQuest = "17797160375921943299",
            endPort = "In"
          },
          {
            startQuest = "17797160375921943299",
            startPort = "Out",
            endQuest = "17782428113416680853",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782428113396680843"] = {
            key = "17782428113396680843",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1041.548051948052, y = 264.5850649350649},
            propsData = {ModeType = 0}
          },
          ["17782428113396680844"] = {
            key = "17782428113396680844",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2671.58014354067, y = 260.3373205741627},
            propsData = {ModeType = 0}
          },
          ["17782428113396680845"] = {
            key = "17782428113396680845",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = -113.24125874125879, y = 746.6468531468532},
            propsData = {}
          },
          ["17782428113396680846"] = {
            key = "17782428113396680846",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 452.92622615075936, y = 227.4888532520113},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040307_02",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040307_03",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Content_10040307_04",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["17782428113406680847"] = {
            key = "17782428113406680847",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1351.4820574162682, y = 224.58151059466866},
            propsData = {
              InputBranchQuestNumber = 3,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17782428113406680848"] = {
            key = "17782428113406680848",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 876.8822550447265, y = 50.89079913221798},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100422,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_CangkuDiaocha_272480173",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10043101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044001.10044001'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100422,
                  TalkActorVisible = true
                }
              },
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
          ["17782428113406680849"] = {
            key = "17782428113406680849",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 870.2814645308923, y = 257.1407991322181},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100421,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_CangkuDiaocha_272480174",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044101.10044101'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100421,
                  TalkActorVisible = true
                }
              },
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
          ["17782428113416680850"] = {
            key = "17782428113416680850",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 870.2326949274242, y = 477.6496924128505},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100443,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_CangkuDiaocha_272480175",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044201.10044201'",
              TalkType = "FreeSimple",
              BlendInTime = 1,
              BlendOutTime = 1,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100001,
                  TalkActorVisible = false
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100443,
                  TalkActorVisible = true
                }
              },
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
          ["17782428113416680851"] = {
            key = "17782428113416680851",
            type = "TalkNode",
            name = "调查完开车",
            pos = {x = 1675.5729665071774, y = 252.0815105946687},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_30.10049901_30'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17782428113416680852"] = {
            key = "17782428113416680852",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 456.88154041647414, y = -233.93034844636676},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                272480173,
                272480174,
                272480175
              }
            }
          },
          ["17782428113416680853"] = {
            key = "17782428113416680853",
            type = "TalkNode",
            name = "广播对话",
            pos = {x = 150.19565217391303, y = 240.32142857142856},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043901.10043901'",
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
          ["17782428113426680854"] = {
            key = "17782428113426680854",
            type = "WaitOfTimeNode",
            name = "等开车播完",
            pos = {x = 1978.5, y = 251.75},
            propsData = {WaitTime = 5}
          },
          ["17782430410516681777"] = {
            key = "17782430410516681777",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2272, y = 258},
            propsData = {}
          },
          ["17783048456926682231"] = {
            key = "17783048456926682231",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -428.63562753036433, y = 406.4898785425102},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1778740514345761"] = {
            key = "1778740514345761",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = -442.24121956474914, y = -113.47287761258349},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["17787503049716808370"] = {
            key = "17787503049716808370",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -419.1973991694574, y = 734.1760904214462},
            propsData = {}
          },
          ["177891740477778710633"] = {
            key = "177891740477778710633",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -425.6153846153847, y = 565.9615384615385},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["1779421207812963"] = {
            key = "1779421207812963",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -435.78691715372713, y = 236.8923076923077},
            propsData = {
              VarName = "First10040307",
              VarValue = 1
            }
          },
          ["17797160375921943299"] = {
            key = "17797160375921943299",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = -131.574679920801, y = 234.6075282338623},
            propsData = {
              StaticCreatorId = 272480422,
              UnitId = 10101,
              bGuideUIEnable = true,
              GuidePointName = "BP_Dengdai_272480422",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["17797161269141943893"] = {
            key = "17797161269141943893",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 452.8560184131232, y = 80.75605712432666},
            propsData = {
              NewDescription = "Content_10040307_01",
              NewDetail = "Description_10040307_01",
              SubTaskTargetIndex = 0
            }
          },
          ["17797161728262911948"] = {
            key = "17797161728262911948",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -438.14609470673184, y = 70.91326103153054},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480423, 272480424}
            }
          },
          ["17797162590523880361"] = {
            key = "17797162590523880361",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 456.8246958224499, y = -81.14911834536497},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480423, 272480424}
            }
          }
        },
        commentData = {}
      }
    },
    ["17782430655667492317"] = {
      isStoryNode = true,
      key = "17782430655667492317",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 710.2181818181818, y = 90.87272727272725},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782430655667492318"] = {
      isStoryNode = true,
      key = "17782430655667492318",
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
