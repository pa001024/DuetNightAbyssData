return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874577455715579049",
      startPort = "StoryStart",
      endStory = "177874577620115579090",
      endPort = "In"
    },
    {
      startStory = "177874577620115579090",
      startPort = "Success",
      endStory = "177874577455715579052",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874577455715579049"] = {
      isStoryNode = true,
      key = "177874577455715579049",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 844.2105263157895, y = 189.4736842105263},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874577455715579052"] = {
      isStoryNode = true,
      key = "177874577455715579052",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1671.0526315789473, y = 194.21052631578948},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874577620115579090"] = {
      isStoryNode = true,
      key = "177874577620115579090",
      type = "StoryNode",
      name = "与史蒂芬交谈",
      pos = {x = 1213.0526315789473, y = 179.15789473684222},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040409_01",
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177874577620315579100",
            startPort = "Out",
            endQuest = "177874577620315579099",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579099",
            startPort = "Out",
            endQuest = "177874577620315579101",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579099",
            startPort = "Out",
            endQuest = "177874577620315579102",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579099",
            startPort = "Out",
            endQuest = "177874577620315579103",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579099",
            startPort = "Out",
            endQuest = "177874577620315579104",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579101",
            startPort = "Out",
            endQuest = "177874577620315579105",
            endPort = "Branch_1"
          },
          {
            startQuest = "177874577620315579102",
            startPort = "Out",
            endQuest = "177874577620315579105",
            endPort = "Branch_2"
          },
          {
            startQuest = "177874577620315579103",
            startPort = "Out",
            endQuest = "177874577620315579105",
            endPort = "Branch_3"
          },
          {
            startQuest = "177874577620315579104",
            startPort = "Out",
            endQuest = "177874577620315579105",
            endPort = "Branch_4"
          },
          {
            startQuest = "177874577620315579105",
            startPort = "Out",
            endQuest = "177874577620415579106",
            endPort = "In"
          },
          {
            startQuest = "177874577620215579095",
            startPort = "QuestStart",
            endQuest = "177874577620415579108",
            endPort = "In"
          },
          {
            startQuest = "177874577620415579108",
            startPort = "Out",
            endQuest = "177874577620415579107",
            endPort = "In"
          },
          {
            startQuest = "177874577620215579098",
            startPort = "Out",
            endQuest = "177874577620415579109",
            endPort = "In"
          },
          {
            startQuest = "177874577620215579095",
            startPort = "QuestStart",
            endQuest = "177874577620415579110",
            endPort = "In"
          },
          {
            startQuest = "177874577620315579105",
            startPort = "Out",
            endQuest = "177874577620215579098",
            endPort = "In"
          },
          {
            startQuest = "177874577620215579095",
            startPort = "QuestStart",
            endQuest = "177874608513915580382",
            endPort = "In"
          },
          {
            startQuest = "177874608513915580382",
            startPort = "Out",
            endQuest = "177874577620315579100",
            endPort = "In"
          },
          {
            startQuest = "177874577620415579109",
            startPort = "Out",
            endQuest = "177874615938316553768",
            endPort = "In"
          },
          {
            startQuest = "177874577620215579095",
            startPort = "QuestStart",
            endQuest = "177874616511816553907",
            endPort = "In"
          },
          {
            startQuest = "177874616511816553907",
            startPort = "Out",
            endQuest = "177874577620215579097",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177874577620215579095"] = {
            key = "177874577620215579095",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -144.2828282828284, y = 140.83333333333326},
            propsData = {ModeType = 0}
          },
          ["177874577620215579096"] = {
            key = "177874577620215579096",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2822.2911585365855, y = 252.42581300813006},
            propsData = {ModeType = 0}
          },
          ["177874577620215579097"] = {
            key = "177874577620215579097",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 791.6666666666666, y = 763.3333333333334},
            propsData = {}
          },
          ["177874577620215579098"] = {
            key = "177874577620215579098",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1892.4122740005091, y = 234.56327349121466},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100415,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Shidifen_272640017",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046301.10046301'",
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
          ["177874577620315579099"] = {
            key = "177874577620315579099",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 770.1374835309614, y = 163.3488723552662},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["177874577620315579100"] = {
            key = "177874577620315579100",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 504.07839262187065, y = 163.42314448836188},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640017}
            }
          },
          ["177874577620315579101"] = {
            key = "177874577620315579101",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1194.4934908087082, y = -27.346552481335056},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100466,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ShikeA_272640012",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_37.10049901_37'",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["177874577620315579102"] = {
            key = "177874577620315579102",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1183.8784114436287, y = 160.20344751866503},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100429,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_DukeA_272640009",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_36.10049901_36'",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["177874577620315579103"] = {
            key = "177874577620315579103",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1237.2462858397641, y = 300.8633509003076},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100467,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_ZhufuA_272640018",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_38.10049901_38'",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["177874577620315579104"] = {
            key = "177874577620315579104",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1192.1125384277557, y = 479.23122529644286},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100435,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Yinyou_272640015",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_39.10049901_39'",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["177874577620315579105"] = {
            key = "177874577620315579105",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1528.7248572683354, y = 201.453447518665},
            propsData = {
              InputBranchQuestNumber = 4,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["177874577620415579106"] = {
            key = "177874577620415579106",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1768.3120563508664, y = 508.3637441735588},
            propsData = {
              NewDescription = "Content_10040409_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177874577620415579107"] = {
            key = "177874577620415579107",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 818.35, y = 491.5750000000001},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640051}
            }
          },
          ["177874577620415579108"] = {
            key = "177874577620415579108",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 511.9500000000001, y = 496.3750000000001},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640050}
            }
          },
          ["177874577620415579109"] = {
            key = "177874577620415579109",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2316.1112263187847, y = 271.4026786770044},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640051}
            }
          },
          ["177874577620415579110"] = {
            key = "177874577620415579110",
            type = "ChangeRoleNode",
            name = "切换为主角",
            pos = {x = 536.3221925133689, y = -77.16287878787877},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874608513915580382"] = {
            key = "177874608513915580382",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 254.33492822966517, y = 146.41148325358856},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PTPre01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177874615938316553768"] = {
            key = "177874615938316553768",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2643.57735247209, y = 289.5933014354066},
            propsData = {}
          },
          ["177874616511816553907"] = {
            key = "177874616511816553907",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 368.5773524720896, y = 737.9266347687401},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
