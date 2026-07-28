return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811613005453053835",
      startPort = "StoryStart",
      endStory = "17811613010783053869",
      endPort = "In"
    },
    {
      startStory = "17811613010783053869",
      startPort = "Success",
      endStory = "17811613005463053838",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811613005453053835"] = {
      isStoryNode = true,
      key = "17811613005453053835",
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
    ["17811613005463053838"] = {
      isStoryNode = true,
      key = "17811613005463053838",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1584, y = 228},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811613010783053869"] = {
      isStoryNode = true,
      key = "17811613010783053869",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1290, y = 242},
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
            startQuest = "17811613010783053877",
            startPort = "Out",
            endQuest = "17811613010783053879",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053874",
            startPort = "QuestStart",
            endQuest = "17811613010783053877",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053874",
            startPort = "QuestStart",
            endQuest = "17811613010783053878",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053878",
            startPort = "Out",
            endQuest = "17811613010783053880",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053880",
            startPort = "Out",
            endQuest = "17811613010783053881",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053882",
            startPort = "Out",
            endQuest = "17811613010783053875",
            endPort = "Success"
          },
          {
            startQuest = "17811613010783053881",
            startPort = "Out",
            endQuest = "17811613010783053883",
            endPort = "In"
          },
          {
            startQuest = "17811613010783053878",
            startPort = "Out",
            endQuest = "178125295739316442695",
            endPort = "Input"
          },
          {
            startQuest = "17811613010783053883",
            startPort = "Out",
            endQuest = "17828032576963334",
            endPort = "In"
          },
          {
            startQuest = "17828032576963334",
            startPort = "Out",
            endQuest = "17811613010783053882",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811613010783053874"] = {
            key = "17811613010783053874",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17811613010783053875"] = {
            key = "17811613010783053875",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["17811613010783053876"] = {
            key = "17811613010783053876",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811613010783053877"] = {
            key = "17811613010783053877",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1207.6839468053622, y = 303.4843628467721},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811613010783053878"] = {
            key = "17811613010783053878",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106001,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811613010783053879"] = {
            key = "17811613010783053879",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811613010783053880"] = {
            key = "17811613010783053880",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.5125876075938, y = 516.3778564057205},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811613010783053881"] = {
            key = "17811613010783053881",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_XierEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811613010783053882"] = {
            key = "17811613010783053882",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811613010783053883"] = {
            key = "17811613010783053883",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178125295739316442695"] = {
            key = "178125295739316442695",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1097.2833713583714, y = 697.1443603693604},
            propsData = {
              TargetTime = 20,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17828032576963334"] = {
            key = "17828032576963334",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1953.7896668548842, y = 557.4480367245715},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC010/SQ_Ver0104_SC010",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
