return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177796907643714036331",
      startPort = "StoryStart",
      endStory = "177796908032114036377",
      endPort = "In"
    },
    {
      startStory = "177796908032114036377",
      startPort = "Success",
      endStory = "177796907643714036334",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177796907643714036331"] = {
      isStoryNode = true,
      key = "177796907643714036331",
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
    ["177796907643714036334"] = {
      isStoryNode = true,
      key = "177796907643714036334",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1763.75, y = 270},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177796908032114036377"] = {
      isStoryNode = true,
      key = "177796908032114036377",
      type = "StoryNode",
      name = "攀爬前",
      pos = {x = 1246, y = 242},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040109_04",
        QuestDeatil = "Description_10040109_01",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_DixiaQianruEleEnd_272480208",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177796908032114036385",
            startPort = "Out",
            endQuest = "177796908032114036386",
            endPort = "In"
          },
          {
            startQuest = "177796908032114036388",
            startPort = "Out",
            endQuest = "177796908032114036385",
            endPort = "In"
          },
          {
            startQuest = "177796908032114036382",
            startPort = "QuestStart",
            endQuest = "177796909267414036820",
            endPort = "In"
          },
          {
            startQuest = "177796908032114036382",
            startPort = "QuestStart",
            endQuest = "177796910298514037058",
            endPort = "In"
          },
          {
            startQuest = "177796910298514037058",
            startPort = "Out",
            endQuest = "177796908032114036384",
            endPort = "Fail"
          },
          {
            startQuest = "177796908032114036386",
            startPort = "Out",
            endQuest = "177796911099414037322",
            endPort = "In"
          },
          {
            startQuest = "177796908032114036382",
            startPort = "QuestStart",
            endQuest = "177815760192757725113",
            endPort = "In"
          },
          {
            startQuest = "177815760192757725113",
            startPort = "Out",
            endQuest = "177796908032114036388",
            endPort = "In"
          },
          {
            startQuest = "177796908032114036382",
            startPort = "QuestStart",
            endQuest = "177891678093566645318",
            endPort = "Input"
          },
          {
            startQuest = "177796908032114036382",
            startPort = "QuestStart",
            endQuest = "1779718823633504",
            endPort = "In"
          }
        },
        nodeData = {
          ["177796908032114036382"] = {
            key = "177796908032114036382",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -71.63636363636365, y = 520.8550637958533},
            propsData = {ModeType = 0}
          },
          ["177796908032114036383"] = {
            key = "177796908032114036383",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2158.3931888544894, y = 333.36274509803917},
            propsData = {ModeType = 0}
          },
          ["177796908032114036384"] = {
            key = "177796908032114036384",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 586.200767263427, y = 857.8797953964195},
            propsData = {}
          },
          ["177796908032114036385"] = {
            key = "177796908032114036385",
            type = "GoToNode",
            name = "前往",
            pos = {x = 855.0176102501905, y = 527.1568173389328},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2530036,
              GuideType = "M",
              GuidePointName = "Mechanism_PanpaStart_2530036"
            }
          },
          ["177796908032114036386"] = {
            key = "177796908032114036386",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1198.0195619792396, y = 541.0018853695324},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10041208,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041301.10041301'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1,
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
          ["177796908032114036388"] = {
            key = "177796908032114036388",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 542.4015650156578, y = 561.3479725582698},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10041201,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041201.10041201'",
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
              HideMechanismsFX = true,
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
          ["177796909267414036820"] = {
            key = "177796909267414036820",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 135.65612648221344, y = 77.30830039525688},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177796910298514037058"] = {
            key = "177796910298514037058",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -22.434782608695684, y = 834.0869565217391},
            propsData = {}
          },
          ["177796911099414037322"] = {
            key = "177796911099414037322",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 1548, y = 530},
            propsData = {}
          },
          ["177815760192757725113"] = {
            key = "177815760192757725113",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 252.37719298245602, y = 514.9537480063796},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PanpaEndTalk",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177891678093566645318"] = {
            key = "177891678093566645318",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -210.52183447749826, y = 174.1067887109076},
            propsData = {
              TargetTime = 16,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["1779718823633504"] = {
            key = "1779718823633504",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 295.79166666666646, y = 306.54166666666663},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0162_story_jazz_sneak_into.0162_story_jazz_sneak_into'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {106001},
              bStoreToServer = true
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
