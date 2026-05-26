return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874842533126293755",
      startPort = "StoryStart",
      endStory = "177874842771626293788",
      endPort = "In"
    },
    {
      startStory = "177874842771626293788",
      startPort = "Success",
      endStory = "177874842533226293758",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874842533126293755"] = {
      isStoryNode = true,
      key = "177874842533126293755",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1430, y = 286.95652173913044},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874842533226293758"] = {
      isStoryNode = true,
      key = "177874842533226293758",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2149.1304347826085, y = 253.04347826086956},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874842771626293788"] = {
      isStoryNode = true,
      key = "177874842771626293788",
      type = "StoryNode",
      name = "演奏钢琴",
      pos = {x = 1744, y = 236},
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
            startQuest = "177874842771626293793",
            startPort = "QuestStart",
            endQuest = "177874842771626293796",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293798",
            startPort = "Out",
            endQuest = "177874842771626293799",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293797",
            startPort = "Out",
            endQuest = "177874842771626293801",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293793",
            startPort = "QuestStart",
            endQuest = "177874842771626293802",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293802",
            startPort = "Out",
            endQuest = "177874842771626293797",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293800",
            startPort = "Out",
            endQuest = "177874842771626293798",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293799",
            startPort = "Out",
            endQuest = "177874842771626293803",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293797",
            startPort = "Out",
            endQuest = "177874842771626293804",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293804",
            startPort = "Out",
            endQuest = "177874842771626293800",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293808",
            startPort = "Out",
            endQuest = "177874842771626293807",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293807",
            startPort = "Out",
            endQuest = "177874842771626293805",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293805",
            startPort = "Out",
            endQuest = "177874842771626293806",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293796",
            startPort = "Out",
            endQuest = "177874842771626293808",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293806",
            startPort = "Out",
            endQuest = "177874842771626293809",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293803",
            startPort = "Out",
            endQuest = "177874844073026294223",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293793",
            startPort = "QuestStart",
            endQuest = "177874845067426294502",
            endPort = "In"
          },
          {
            startQuest = "177874845067426294502",
            startPort = "Out",
            endQuest = "177874842771626293795",
            endPort = "Fail"
          },
          {
            startQuest = "177874842771626293802",
            startPort = "Out",
            endQuest = "1779177616458967129",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293802",
            startPort = "Out",
            endQuest = "177936853367868175358",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293800",
            startPort = "Out",
            endQuest = "177936854184268175620",
            endPort = "In"
          },
          {
            startQuest = "177874842771626293800",
            startPort = "Out",
            endQuest = "1779520877667607",
            endPort = "In"
          },
          {
            startQuest = "1779520877667607",
            startPort = "Out",
            endQuest = "1779697034679969208",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874842771626293793"] = {
            key = "177874842771626293793",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 394.04521889400917, y = 347.18173963133637},
            propsData = {ModeType = 0}
          },
          ["177874842771626293794"] = {
            key = "177874842771626293794",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2988.4774436090224, y = 495.6382151029748},
            propsData = {ModeType = 0}
          },
          ["177874842771626293795"] = {
            key = "177874842771626293795",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1819.4736842105262, y = 851.578947368421},
            propsData = {}
          },
          ["177874842771626293796"] = {
            key = "177874842771626293796",
            type = "ChangeRoleNode",
            name = "切换为芙罗拉",
            pos = {x = 751.7619047619048, y = 120.52380952380953},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["177874842771626293797"] = {
            key = "177874842771626293797",
            type = "SplineMoveStartNode",
            name = "开始沿Spline移动节点",
            pos = {x = 1027.4876811594197, y = 394.89523809523814},
            propsData = {
              SplineActorIndex = 10040418,
              WalkType = 0,
              MoveSpeedRate = 0.25,
              IsTriggerable = false,
              UseEndOverlapBox = true,
              CanMoveReverse = false,
              StopAtEndPoint = true
            }
          },
          ["177874842771626293798"] = {
            key = "177874842771626293798",
            type = "TalkNode",
            name = "过场-芙罗拉弹钢琴",
            pos = {x = 1868.1325045352778, y = 403.81978021978034},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC015/SQ_Ver0104_SC015",
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
          ["177874842771626293799"] = {
            key = "177874842771626293799",
            type = "TalkNode",
            name = "演奏结束 对话",
            pos = {x = 2161.5940888352934, y = 400.0564717818334},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047201.10047201'",
              TalkType = "QuestImpression",
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
          ["177874842771626293800"] = {
            key = "177874842771626293800",
            type = "SplineMoveEndNode",
            name = "结束沿Spline移动节点",
            pos = {x = 1590.595238095238, y = 415.8809523809524},
            propsData = {SplineActorIndex = 10040418, ExitBlendTime = 1}
          },
          ["177874842771626293801"] = {
            key = "177874842771626293801",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1286.9134495938838, y = 638.1761745500876},
            propsData = {
              NewDescription = "Content_10040418_02",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177874842771626293802"] = {
            key = "177874842771626293802",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 730.8934565010541, y = 366.2252362450792},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_FuluoPianoStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177874842771626293803"] = {
            key = "177874842771626293803",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2487.3279386148656, y = 423.3287006923466},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {272640054}
            }
          },
          ["177874842771626293804"] = {
            key = "177874842771626293804",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1334.1580998532138, y = 392.4312806758459},
            propsData = {
              StaticCreatorId = 272640077,
              UnitId = 10100,
              bGuideUIEnable = true,
              GuidePointName = "BP_PianoSit",
              LongPressTime = 4,
              MontageName = "Interactive_Bow_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177874842771626293805"] = {
            key = "177874842771626293805",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1582.7753779047598, y = 145.16537911499609},
            propsData = {
              WeaponTags = {"Melee"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["177874842771626293806"] = {
            key = "177874842771626293806",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1843.7836860217635, y = 142.37535150975123},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Attack",
                "Slide",
                "BulletJump",
                "Fire",
                "Skill1",
                "Skill2",
                "Avoid",
                "Skill3"
              }
            }
          },
          ["177874842771626293807"] = {
            key = "177874842771626293807",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1324.7727115903597, y = 140.26071646578072},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["177874842771626293808"] = {
            key = "177874842771626293808",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1014.920307693475, y = 131.7753903631862},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["177874842771626293809"] = {
            key = "177874842771626293809",
            type = "CameraControlNode",
            name = "镜头控制节点",
            pos = {x = 2226.504587665127, y = 111.69718223669588},
            propsData = {
              Duration = 3,
              CameraName = "StoryEast01Nai01",
              LockRotate = false,
              FocalLength = 0,
              LensAperture = 0,
              FOV = 70,
              PPMaterialPath = ""
            }
          },
          ["177874844073026294223"] = {
            key = "177874844073026294223",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2750, y = 449.7894736842105},
            propsData = {}
          },
          ["177874845067426294502"] = {
            key = "177874845067426294502",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 763.5578947368418, y = 845.5368421052631},
            propsData = {}
          },
          ["1779177616458967129"] = {
            key = "1779177616458967129",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1008.6833333333336, y = 629.1166666666668},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_46.10049901_46'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177936853367868175358"] = {
            key = "177936853367868175358",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1072.7058823529412, y = -109.17647058823528},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YWPianoLightStart",
              UnitId = -1
            }
          },
          ["177936854184268175620"] = {
            key = "177936854184268175620",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1879.7850267379679, y = 591.1222065859836},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YWPianoLightClose",
              UnitId = -1
            }
          },
          ["1779520877667607"] = {
            key = "1779520877667607",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1847.392145135566, y = 259.1477272727273},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1779697034679969208"] = {
            key = "1779697034679969208",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2135.508243255921, y = 249.56602863568816},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0170_story_fuluo_play_piano.0170_story_fuluo_play_piano'",
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
    }
  },
  commentData = {}
}
