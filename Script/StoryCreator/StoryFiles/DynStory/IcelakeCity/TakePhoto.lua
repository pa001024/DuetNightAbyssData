return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1776844180455507553",
      startPort = "StoryStart",
      endStory = "1776844180455507555",
      endPort = "In"
    },
    {
      startStory = "1776844180455507555",
      startPort = "Success",
      endStory = "1776844180455507554",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1776844180455507553"] = {
      isStoryNode = true,
      key = "1776844180455507553",
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
    ["1776844180455507554"] = {
      isStoryNode = true,
      key = "1776844180455507554",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1507.5806451612902, y = 290.9032258064516},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1776844180455507555"] = {
      isStoryNode = true,
      key = "1776844180455507555",
      type = "StoryNode",
      name = "拍照",
      pos = {x = 1153.3101736972706, y = 283.85856079404465},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_TakePhoto_Des",
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
        bIsDynamicEvent = true,
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
            startQuest = "1776844180455507556",
            startPort = "QuestStart",
            endQuest = "1776844180455507559",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507559",
            startPort = "Out",
            endQuest = "1776844180455507560",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507559",
            startPort = "Out",
            endQuest = "1776844180455507561",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507563",
            startPort = "Success",
            endQuest = "1776844180455507564",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507562",
            startPort = "Out",
            endQuest = "1776844180455507557",
            endPort = "Success"
          },
          {
            startQuest = "1776844180455507564",
            startPort = "Out",
            endQuest = "1776844180455507565",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507565",
            startPort = "Out",
            endQuest = "1776844180455507557",
            endPort = "Success"
          },
          {
            startQuest = "1776844180455507567",
            startPort = "Out",
            endQuest = "1776844180455507563",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507566",
            startPort = "Out",
            endQuest = "1776844180455507569",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507569",
            startPort = "Out",
            endQuest = "1776844180455507567",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507567",
            startPort = "Out",
            endQuest = "1776844180455507570",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507563",
            startPort = "Success",
            endQuest = "1776844180455507571",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507571",
            startPort = "Out",
            endQuest = "1776844180455507568",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507570",
            startPort = "Out",
            endQuest = "1776844180455507567",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507561",
            startPort = "Out",
            endQuest = "1776844180455507566",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507561",
            startPort = "Fail",
            endQuest = "1776844180455507562",
            endPort = "In"
          },
          {
            startQuest = "1776844180455507563",
            startPort = "Success",
            endQuest = "1776844180456507572",
            endPort = "In"
          }
        },
        nodeData = {
          ["1776844180455507556"] = {
            key = "1776844180455507556",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1776844180455507557"] = {
            key = "1776844180455507557",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3491.6695652173917, y = 367.66956521739127},
            propsData = {ModeType = 0}
          },
          ["1776844180455507558"] = {
            key = "1776844180455507558",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1776844180455507559"] = {
            key = "1776844180455507559",
            type = "ChangeStaticCreatorNode",
            name = "生成NPC",
            pos = {x = 1208, y = 296.4},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1190959}
            }
          },
          ["1776844180455507560"] = {
            key = "1776844180455507560",
            type = "TalkNode",
            name = "拍照开车",
            pos = {x = 1509.2, y = 83.99999999999993},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71005001,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1776844180455507561"] = {
            key = "1776844180455507561",
            type = "TalkNode",
            name = "交互开车",
            pos = {x = 1590.5233082706764, y = 261.53684210526325},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818041,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_1190959",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71005002,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = true,
              FailOutType = "FadeOut",
              FailOutTime = 2
            }
          },
          ["1776844180455507562"] = {
            key = "1776844180455507562",
            type = "DynamicQuestFailNode",
            name = "动态任务主动失败",
            pos = {x = 2051.5262672811064, y = 711.7640552995392},
            propsData = {UseTalkFadeOut = false, TalkFadeOutTime = 0}
          },
          ["1776844180455507563"] = {
            key = "1776844180455507563",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 2357.26446989196, y = 201.45395249911374},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = false,
              GuideType = "P",
              _GuidePointName = "",
              TargetPointList = {
                "Npc_Dyn_1190959",
                "BP_Dyn_PhotoPoint"
              },
              EventId = 0,
              EventParams = {},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 15,
              LookAtTargetName = "Npc_Dyn_1190959",
              StartPos = "(X=-4526.700195,Y=-3124.115723,Z=-3703.814209)",
              bLockCameraPos = true,
              bStartHiddenRole = true,
              bLockHiddenRole = true,
              bStartHiddenNPC = false,
              bLockHiddenNPC = true,
              bStartHiddenMonster = true,
              bLockHiddenMonster = true,
              bStartHiddenPet = true,
              bLockHiddenPet = true,
              bLockGamePause = true,
              bForceGamePause = false
            }
          },
          ["1776844180455507564"] = {
            key = "1776844180455507564",
            type = "TalkNode",
            name = "完成对话",
            pos = {x = 2593.451696129958, y = 234.62990922121347},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818041,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_1190959",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71005005,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
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
          ["1776844180455507565"] = {
            key = "1776844180455507565",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 2853.83197123243, y = 271.6574043805165},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0,
              UseTalkFadeIn = false,
              TalkFadeInTime = 0
            }
          },
          ["1776844180455507566"] = {
            key = "1776844180455507566",
            type = "ChangeStaticCreatorNode",
            name = "生成照相机机关",
            pos = {x = 2046.3535631035636, y = -136.0480769230769},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1190964}
            }
          },
          ["1776844180455507567"] = {
            key = "1776844180455507567",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2045.476764707299, y = 164.24464759378563},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 1190964,
              StateId = 780421,
              IsGuideEnable = false,
              GuidePointName = "Mechanism_Dyn_1190964"
            }
          },
          ["1776844180455507568"] = {
            key = "1776844180455507568",
            type = "ChangeStaticCreatorNode",
            name = "销毁照相机机关",
            pos = {x = 2942.021167125594, y = 10.929924074892941},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1190964}
            }
          },
          ["1776844180455507569"] = {
            key = "1776844180455507569",
            type = "SwitchMechanismStateNode",
            name = "初始化机关",
            pos = {x = 2055.905959752322, y = 16.75849550346436},
            propsData = {
              StaticCreatorIdList = {1190964},
              ManualItemIdList = {},
              StateId = 780420,
              QuestId = 0
            }
          },
          ["1776844180455507570"] = {
            key = "1776844180455507570",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2071.199581064097, y = 383.64079388353565},
            propsData = {WaitTime = 0.5}
          },
          ["1776844180455507571"] = {
            key = "1776844180455507571",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2656.8253875157097, y = 2.156922915793688},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 1190964,
              StateId = 780420,
              IsGuideEnable = false,
              GuidePointName = "Mechanism_Dyn_1190964"
            }
          },
          ["1776844180456507572"] = {
            key = "1776844180456507572",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2641.6242963692657, y = -157.39966225724754},
            propsData = {
              NewDescription = "DynQuest_TakePhoto_Target1",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
