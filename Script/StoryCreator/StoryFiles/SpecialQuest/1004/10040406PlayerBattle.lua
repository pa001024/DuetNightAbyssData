return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874503857713632340",
      startPort = "StoryStart",
      endStory = "177874504266413632388",
      endPort = "In"
    },
    {
      startStory = "177874504266413632388",
      startPort = "Success",
      endStory = "177874503857713632343",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874503857713632340"] = {
      isStoryNode = true,
      key = "177874503857713632340",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1026, y = 314},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874503857713632343"] = {
      isStoryNode = true,
      key = "177874503857713632343",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1884, y = 332},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874504266413632388"] = {
      isStoryNode = true,
      key = "177874504266413632388",
      type = "StoryNode",
      name = "玩家视角",
      pos = {x = 1445.9999999999998, y = 297.0344827586207},
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
        bIsPlayBlackScreenOnComplete = true,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177874504266413632393",
            startPort = "QuestStart",
            endQuest = "177874504266413632396",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632398",
            startPort = "Out",
            endQuest = "177874504266413632399",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632396",
            startPort = "Out",
            endQuest = "177874504266413632397",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632396",
            startPort = "Out",
            endQuest = "177874504266413632398",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632399",
            startPort = "Out",
            endQuest = "177874504266413632400",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632400",
            startPort = "Out",
            endQuest = "177874504266413632401",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632393",
            startPort = "QuestStart",
            endQuest = "177874504266513632402",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632393",
            startPort = "QuestStart",
            endQuest = "177874519235213633191",
            endPort = "In"
          },
          {
            startQuest = "177874519235213633191",
            startPort = "Out",
            endQuest = "177874504266413632395",
            endPort = "Fail"
          },
          {
            startQuest = "177874504266413632400",
            startPort = "Out",
            endQuest = "177969628728015478056",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632401",
            startPort = "Out",
            endQuest = "177969629519415478179",
            endPort = "In"
          },
          {
            startQuest = "177969629519415478179",
            startPort = "Out",
            endQuest = "177874520492713633669",
            endPort = "In"
          },
          {
            startQuest = "177874504266413632399",
            startPort = "Out",
            endQuest = "1780057881864679",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874504266413632393"] = {
            key = "177874504266413632393",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 646.4705882352941, y = 282.35294117647055},
            propsData = {ModeType = 0}
          },
          ["177874504266413632394"] = {
            key = "177874504266413632394",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3200.2150537634407, y = 341.2365591397849},
            propsData = {ModeType = 0}
          },
          ["177874504266413632395"] = {
            key = "177874504266413632395",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1818.3333333333333, y = 663.3333333333334},
            propsData = {}
          },
          ["177874504266413632396"] = {
            key = "177874504266413632396",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置在车顶",
            pos = {x = 1163.076923076923, y = 303.84615384615387},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZhujueBattle",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177874504266413632397"] = {
            key = "177874504266413632397",
            type = "TalkNode",
            name = "开车",
            pos = {x = 1676.6630524688032, y = 127.4663394109397},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_62.10049901_62'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177874504266413632398"] = {
            key = "177874504266413632398",
            type = "SendMessageNode",
            name = "开始刷怪",
            pos = {x = 1711.921116984932, y = 325.0323218156318},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainBattleXierStart",
              UnitId = -1
            }
          },
          ["177874504266413632399"] = {
            key = "177874504266413632399",
            type = "BossBattleFinishNode",
            name = "玩法成功 ",
            pos = {x = 2001.3365759221304, y = 318.0528496748694},
            propsData = {
              SendMessage = "",
              FinishCondition = "TrainBattleXierSuccess"
            }
          },
          ["177874504266413632400"] = {
            key = "177874504266413632400",
            type = "TalkNode",
            name = "过场-希尔妲出手相救",
            pos = {x = 2319.1175979233485, y = 310.4810021675379},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC013/SQ_Ver0104_SC013",
              BlendInTime = 2,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["177874504266413632401"] = {
            key = "177874504266413632401",
            type = "TalkNode",
            name = "希尔妲托付芙罗拉",
            pos = {x = 2594.2348999761343, y = 308.07264439627704},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046001.10046001'",
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
          ["177874504266513632402"] = {
            key = "177874504266513632402",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1238.3333333333333, y = -82.66666666666663},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874519235213633191"] = {
            key = "177874519235213633191",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1140.6666666666665, y = 574.3333333333333},
            propsData = {}
          },
          ["177874520492713633669"] = {
            key = "177874520492713633669",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2965.6666666666665, y = 377.6666666666665},
            propsData = {}
          },
          ["177969628728015478056"] = {
            key = "177969628728015478056",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2558.8367837629685, y = 133.1732366155405},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0165_story_xier_theme.0165_story_xier_theme'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106101},
              bStoreToServer = true
            }
          },
          ["177969629519415478179"] = {
            key = "177969629519415478179",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2888.1678874418985, y = 176.31704932457055},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1780057881864679"] = {
            key = "1780057881864679",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2309.5331807780326, y = 120.1235697940503},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106101},
              bStoreToServer = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
