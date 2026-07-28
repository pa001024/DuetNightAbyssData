return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17724328722381498253",
      startPort = "StoryStart",
      endStory = "17724328722381498255",
      endPort = "In"
    },
    {
      startStory = "17724328722381498255",
      startPort = "Success",
      endStory = "17724328722381498254",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17724328722381498253"] = {
      isStoryNode = true,
      key = "17724328722381498253",
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
    ["17724328722381498254"] = {
      isStoryNode = true,
      key = "17724328722381498254",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17724328722381498255"] = {
      isStoryNode = true,
      key = "17724328722381498255",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1372, y = 350},
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
            startQuest = "17724328722381498256",
            startPort = "QuestStart",
            endQuest = "17724328722381498261",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498256",
            startPort = "QuestStart",
            endQuest = "1772421449990580",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498261",
            startPort = "Out",
            endQuest = "1772460246018829",
            endPort = "In"
          },
          {
            startQuest = "1772460246018829",
            startPort = "Out",
            endQuest = "17724328722381498259",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498260",
            startPort = "Out",
            endQuest = "17724607552571608931",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498259",
            startPort = "Out",
            endQuest = "1774186924195692",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498259",
            startPort = "Out",
            endQuest = "17724328722381498260",
            endPort = "In"
          },
          {
            startQuest = "1772421449990580",
            startPort = "Out",
            endQuest = "1774186948315843860",
            endPort = "In"
          },
          {
            startQuest = "17724607552571608931",
            startPort = "Out",
            endQuest = "1774186955598844109",
            endPort = "In"
          },
          {
            startQuest = "1774186955598844109",
            startPort = "Out",
            endQuest = "1772421444982495",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498256",
            startPort = "QuestStart",
            endQuest = "17748541039154690782",
            endPort = "In"
          },
          {
            startQuest = "17724328722381498256",
            startPort = "QuestStart",
            endQuest = "17748541039154690781",
            endPort = "In"
          },
          {
            startQuest = "17748541131084691002",
            startPort = "Out",
            endQuest = "17748541131084691003",
            endPort = "Input_1"
          },
          {
            startQuest = "17748541131084691001",
            startPort = "Out",
            endQuest = "17748541131084691003",
            endPort = "Input_2"
          },
          {
            startQuest = "1774186948315843860",
            startPort = "Out",
            endQuest = "17748541131084691002",
            endPort = "In"
          },
          {
            startQuest = "1774186948315843860",
            startPort = "Out",
            endQuest = "17748541131084691001",
            endPort = "In"
          },
          {
            startQuest = "17748541131084691003",
            startPort = "Out",
            endQuest = "17724328722381498258",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1772421444982495"] = {
            key = "1772421444982495",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2564.838979860719, y = 270.1587539563551},
            propsData = {}
          },
          ["1772421449990580"] = {
            key = "1772421449990580",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1446.148503670243, y = 663.0186335403727},
            propsData = {}
          },
          ["17724328722381498256"] = {
            key = "17724328722381498256",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17724328722381498257"] = {
            key = "17724328722381498257",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17724328722381498258"] = {
            key = "17724328722381498258",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2710.6349206349205, y = 805.8730158730159},
            propsData = {}
          },
          ["17724328722381498259"] = {
            key = "17724328722381498259",
            type = "TalkNode",
            name = "【East02_FixSimple_66】苏乙视角，狴犴冲向小孩",
            pos = {x = 1576.5460831832436, y = 267.0918433552763},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1202/12047001.12047001'",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020602",
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
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17724328722381498260"] = {
            key = "17724328722381498260",
            type = "TalkNode",
            name = "苏乙救人",
            pos = {x = 1871.1847121907097, y = 281.7420434103972},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC013/SQ_Ver0102_SC013",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = true,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17724328722381498261"] = {
            key = "17724328722381498261",
            type = "ChangeRoleNode",
            name = "切换苏乙",
            pos = {x = 1073.4829325828177, y = 257.35655848534594},
            propsData = {QuestRoleId = 15040101, IsPlayFX = false}
          },
          ["1772460246018829"] = {
            key = "1772460246018829",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1333.4227954460457, y = 273.46395644893965},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020602",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17724607552571608931"] = {
            key = "17724607552571608931",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2237.2964937985553, y = 273.96032097587545},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020602",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1774186924195692"] = {
            key = "1774186924195692",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1816.374736444807, y = 128.36700869555756},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0129_boss_yuming.0129_boss_yuming'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              bStoreToServer = true
            }
          },
          ["1774186948315843860"] = {
            key = "1774186948315843860",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1699.9747364448071, y = 685.4336753622242},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1774186955598844109"] = {
            key = "1774186955598844109",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2495.0836928758436, y = 136.3956377278156},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["17748541039154690781"] = {
            key = "17748541039154690781",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1124.682833587981, y = -146.01684491978614},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["17748541039154690782"] = {
            key = "17748541039154690782",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1106.1450884899416, y = 9.383155080213847},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningStart",
              UnitId = -1
            }
          },
          ["17748541131084691001"] = {
            key = "17748541131084691001",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2062.054794601534, y = 1007.5306504202543},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["17748541131084691002"] = {
            key = "17748541131084691002",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2063.5694545963174, y = 849.3718645981174},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "LigntningEnd",
              UnitId = -1
            }
          },
          ["17748541131084691003"] = {
            key = "17748541131084691003",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2352.265492599189, y = 1004.1275064627627},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
