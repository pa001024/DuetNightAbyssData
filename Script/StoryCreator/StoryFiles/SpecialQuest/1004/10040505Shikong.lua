return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772056663716821971",
      startPort = "StoryStart",
      endStory = "177772057065416822022",
      endPort = "In"
    },
    {
      startStory = "177772057065416822022",
      startPort = "Success",
      endStory = "177772056663716821974",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772056663716821971"] = {
      isStoryNode = true,
      key = "177772056663716821971",
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
    ["177772056663716821974"] = {
      isStoryNode = true,
      key = "177772056663716821974",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1813.3333333333333, y = 315},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772057065416822022"] = {
      isStoryNode = true,
      key = "177772057065416822022",
      type = "StoryNode",
      name = "列车失控前",
      pos = {x = 1235.1920385578471, y = 273.82889185977444},
      propsData = {
        QuestId = 0,
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
            startQuest = "177772057065816822053",
            startPort = "Out",
            endQuest = "177772057065716822050",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822054",
            startPort = "Out",
            endQuest = "177772057065816822055",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822056",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822052",
            startPort = "Out",
            endQuest = "177772057065816822053",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822059",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177772057065816822061",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822061",
            startPort = "Out",
            endQuest = "177772057065716822051",
            endPort = "In"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772201386727103320",
            endPort = "In"
          },
          {
            startQuest = "177772201386727103320",
            startPort = "Out",
            endQuest = "177772057065616822049",
            endPort = "Fail"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772203423427103864",
            endPort = "In"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177772057065716822052",
            endPort = "In"
          },
          {
            startQuest = "177772057065616822047",
            startPort = "QuestStart",
            endQuest = "177892138175487880517",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822053",
            startPort = "Out",
            endQuest = "177892140480787880844",
            endPort = "In"
          },
          {
            startQuest = "177772057065816822060",
            startPort = "Out",
            endQuest = "17791956096111776",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822050",
            startPort = "Out",
            endQuest = "177936848699067209375",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822052",
            startPort = "Out",
            endQuest = "17796987621973872995",
            endPort = "In"
          },
          {
            startQuest = "177772057065716822051",
            startPort = "Out",
            endQuest = "17796987939323873385",
            endPort = "In"
          },
          {
            startQuest = "17796987939323873385",
            startPort = "Out",
            endQuest = "177772057065816822060",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772057065616822047"] = {
            key = "177772057065616822047",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1027.0846352703156, y = 269.27099022142295},
            propsData = {ModeType = 0}
          },
          ["177772057065616822048"] = {
            key = "177772057065616822048",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2704.749040920716, y = 269.7122762148338},
            propsData = {ModeType = 0}
          },
          ["177772057065616822049"] = {
            key = "177772057065616822049",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 533.124999999999, y = 752.5},
            propsData = {}
          },
          ["177772057065716822050"] = {
            key = "177772057065716822050",
            type = "TalkNode",
            name = "准备控制列车",
            pos = {x = 604.9132992327368, y = 282.4807400379507},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048801.10048801'",
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
          ["177772057065716822051"] = {
            key = "177772057065716822051",
            type = "TalkNode",
            name = "缔结契约",
            pos = {x = 1450.6935955307795, y = 275.9586225794665},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048901.10048901'",
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
          ["177772057065716822052"] = {
            key = "177772057065716822052",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -157.95059288537544, y = 280.9721407624634},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_GetTrainHead",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772057065816822053"] = {
            key = "177772057065816822053",
            type = "TalkNode",
            name = "过场-主角试图操作控制台",
            pos = {x = 151.961813081729, y = 288.1060181053168},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC024/SQ_Ver0104_SC024",
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
          ["177772057065816822054"] = {
            key = "177772057065816822054",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1146.4307917888566, y = 767.2970674486804},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640049}
            }
          },
          ["177772057065816822055"] = {
            key = "177772057065816822055",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1627.0529116045248, y = 726.1653586556811},
            propsData = {
              StaticCreatorId = 272640049,
              UnitId = 10073,
              bGuideUIEnable = true,
              GuidePointName = "BP_TrainHead_272640049",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177772057065816822056"] = {
            key = "177772057065816822056",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1178.148052234554, y = -71.77263743719539},
            propsData = {
              NewDescription = "Content_10040506_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177772057065816822059"] = {
            key = "177772057065816822059",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1127.5872388481087, y = 518.0208921513268},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640058}
            }
          },
          ["177772057065816822060"] = {
            key = "177772057065816822060",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2097, y = 302.28260869565213},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640058}
            }
          },
          ["177772057065816822061"] = {
            key = "177772057065816822061",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1150.5517771701982, y = 260.5782638414217},
            propsData = {
              StaticCreatorId = 272640061,
              UnitId = 10073,
              bGuideUIEnable = true,
              GuidePointName = "BP_TrainHead_272640049",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177772201386727103320"] = {
            key = "177772201386727103320",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -308.87207749340047, y = 715.4765388654989},
            propsData = {}
          },
          ["177772203423427103864"] = {
            key = "177772203423427103864",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -776.4185522629818, y = -24.610591676373133},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177892138175487880517"] = {
            key = "177892138175487880517",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = -657.6000000000001, y = 166.175},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainGuozaiQian",
              UnitId = -1
            }
          },
          ["177892140480787880844"] = {
            key = "177892140480787880844",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 357.60000000000025, y = -57.02500000000009},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainGuozaiHou",
              UnitId = -1
            }
          },
          ["17791956096111776"] = {
            key = "17791956096111776",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2457.106693611499, y = 297.3829380764163},
            propsData = {}
          },
          ["177936848699067209375"] = {
            key = "177936848699067209375",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 785.3210526315789, y = 3.9789473684211423},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YWTrainAlarmStart",
              UnitId = -1
            }
          },
          ["17796987621973872995"] = {
            key = "17796987621973872995",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 90.11762025384334, y = 75.25973355849514},
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
          },
          ["17796987939323873385"] = {
            key = "17796987939323873385",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1816.026711162934, y = 271.6233699221314},
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
