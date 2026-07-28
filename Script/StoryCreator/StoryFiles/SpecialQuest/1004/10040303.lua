return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782407300872717285",
      startPort = "StoryStart",
      endStory = "17782406896791908005",
      endPort = "In"
    },
    {
      startStory = "17782406896791908005",
      startPort = "Success",
      endStory = "17782407300872717286",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782406896791908005"] = {
      isStoryNode = true,
      key = "17782406896791908005",
      type = "StoryNode",
      name = "回复士兵",
      pos = {x = 1120.1999999999998, y = 98.5166666666666},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040303_01",
        QuestDeatil = "Description_10040303_01",
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
            startQuest = "17782406896791908013",
            startPort = "Out",
            endQuest = "17782406896801908017",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908017",
            startPort = "Out",
            endQuest = "17782406896801908016",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908017",
            startPort = "Out",
            endQuest = "17782406896801908014",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908017",
            startPort = "Out",
            endQuest = "17782406896801908019",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908014",
            startPort = "Out",
            endQuest = "17782406896801908020",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908015",
            startPort = "Out",
            endQuest = "17782407078531908581",
            endPort = "In"
          },
          {
            startQuest = "177829688024327172764",
            startPort = "Out",
            endQuest = "17782406896791908013",
            endPort = "In"
          },
          {
            startQuest = "17782406896801908014",
            startPort = "Out",
            endQuest = "17782406896801908015",
            endPort = "In"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "17783047007071912194",
            endPort = "In"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "1778492996845825",
            endPort = "In"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "1778739867048661",
            endPort = "In"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "17787499767621946884",
            endPort = "In"
          },
          {
            startQuest = "17787499767621946884",
            startPort = "Out",
            endQuest = "17782406896791908012",
            endPort = "Fail"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "177891733028075815695",
            endPort = "Input"
          },
          {
            startQuest = "17782406896791908010",
            startPort = "QuestStart",
            endQuest = "1779420511115680",
            endPort = "In"
          },
          {
            startQuest = "1779420511115680",
            startPort = "Out",
            endQuest = "177829688024327172764",
            endPort = "In"
          }
        },
        nodeData = {
          ["17782406896791908010"] = {
            key = "17782406896791908010",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -10.156856187291025, y = 381.7622551361682},
            propsData = {ModeType = 0}
          },
          ["17782406896791908011"] = {
            key = "17782406896791908011",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2741.7060439560437, y = 395.42032967032964},
            propsData = {ModeType = 0}
          },
          ["17782406896791908012"] = {
            key = "17782406896791908012",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 965.9740259740262, y = 830.2597402597402},
            propsData = {}
          },
          ["17782406896791908013"] = {
            key = "17782406896791908013",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 959.5000000000002, y = 406.10714285714283},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100422,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_BaozhaWeibing_272480170",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043201.10043201'",
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
          ["17782406896801908014"] = {
            key = "17782406896801908014",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1591.35974025974, y = 403.92857142857144},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100402,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_272480171",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10042809,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043301.10043301'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1,
              BlendOutTime = 1,
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
          ["17782406896801908015"] = {
            key = "17782406896801908015",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1880.7064935064932, y = 397.80584415584417},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100422,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_BaozhaWeibing_272480170",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043401.10043401'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
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
          ["17782406896801908016"] = {
            key = "17782406896801908016",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1583.8642857142856, y = 167.48571428571418},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_24.10049901_24'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17782406896801908017"] = {
            key = "17782406896801908017",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1272.9108695652174, y = 409.8645962732919},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480171}
            }
          },
          ["17782406896801908019"] = {
            key = "17782406896801908019",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1580, y = 19.499999999999886},
            propsData = {
              NewDescription = "Content_10040303_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17782406896801908020"] = {
            key = "17782406896801908020",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1862.1102941176468, y = 19.674999999999994},
            propsData = {
              NewDescription = "Content_10040303_03",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17782407078531908581"] = {
            key = "17782407078531908581",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2402, y = 392},
            propsData = {}
          },
          ["177829688024327172764"] = {
            key = "177829688024327172764",
            type = "ChangeStaticCreatorNode",
            name = "爆炸点卫兵",
            pos = {x = 630.6171951618174, y = 399.09970578620465},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480170, 152480365}
            }
          },
          ["17783047007071912194"] = {
            key = "17783047007071912194",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 630.1272938361947, y = 288.4950605122433},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["1778492996845825"] = {
            key = "1778492996845825",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 630.9250000000001, y = 141.56427242833865},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100499400,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1778739867048661"] = {
            key = "1778739867048661",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 625.1592105263156, y = 27.40620300751877},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["17787499767621946884"] = {
            key = "17787499767621946884",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 627.7642016136601, y = 811.7093586238323},
            propsData = {}
          },
          ["177891733028075815695"] = {
            key = "177891733028075815695",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 583.6764705882351, y = -339.1764705882353},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["1779420511115680"] = {
            key = "1779420511115680",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 374.32692307692304, y = 393.0000000000001},
            propsData = {
              VarName = "First10040303",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    },
    ["17782407300872717285"] = {
      isStoryNode = true,
      key = "17782407300872717285",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 816.8, y = 98.39999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782407300872717286"] = {
      isStoryNode = true,
      key = "17782407300872717286",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1459.0668510551877, y = 100.46607697013386},
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
