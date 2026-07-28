return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811619224086106044",
      startPort = "StoryStart",
      endStory = "17811619233506106085",
      endPort = "In"
    },
    {
      startStory = "17811619233506106085",
      startPort = "Success",
      endStory = "17811619224086106047",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811619224086106044"] = {
      isStoryNode = true,
      key = "17811619224086106044",
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
    ["17811619224086106047"] = {
      isStoryNode = true,
      key = "17811619224086106047",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1566, y = 246},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811619233506106085"] = {
      isStoryNode = true,
      key = "17811619233506106085",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1220, y = 250},
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
            startQuest = "17811619233506106093",
            startPort = "Out",
            endQuest = "17811619233506106095",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106090",
            startPort = "QuestStart",
            endQuest = "17811619233506106093",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106090",
            startPort = "QuestStart",
            endQuest = "17811619233506106094",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106094",
            startPort = "Out",
            endQuest = "17811619233506106096",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106096",
            startPort = "Out",
            endQuest = "17811619233506106097",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106098",
            startPort = "Out",
            endQuest = "17811619233506106091",
            endPort = "Success"
          },
          {
            startQuest = "17811619233506106097",
            startPort = "Out",
            endQuest = "17811619233506106099",
            endPort = "In"
          },
          {
            startQuest = "17811619233506106099",
            startPort = "Out",
            endQuest = "17811621130008141922",
            endPort = "In"
          },
          {
            startQuest = "17811621181798142029",
            startPort = "Out",
            endQuest = "17811619233506106098",
            endPort = "In"
          },
          {
            startQuest = "17811621130008141922",
            startPort = "Out",
            endQuest = "17811621181798142029",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811619233506106090"] = {
            key = "17811619233506106090",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17811619233506106091"] = {
            key = "17811619233506106091",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17811619233506106092"] = {
            key = "17811619233506106092",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811619233506106093"] = {
            key = "17811619233506106093",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 903.7709033271017, y = 272.1800150206852},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811619233506106094"] = {
            key = "17811619233506106094",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17811619233506106095"] = {
            key = "17811619233506106095",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17811619233506106096"] = {
            key = "17811619233506106096",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811619233506106097"] = {
            key = "17811619233506106097",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PaokuStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811619233506106098"] = {
            key = "17811619233506106098",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2474.0206582633054, y = 545.5103519668737},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811619233506106099"] = {
            key = "17811619233506106099",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0166_story_danger.0166_story_danger'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17811621130008141922"] = {
            key = "17811621130008141922",
            type = "TalkNode",
            name = "过场-爬上列车",
            pos = {x = 1946.037827346461, y = 564.5422565854022},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC012/SQ_Ver0104_SC012",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "BP_PaokuStart",
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
          ["17811621181798142029"] = {
            key = "17811621181798142029",
            type = "TalkNode",
            name = "过场-跳车",
            pos = {x = 2229.030308549468, y = 590.2565422996879},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC112/SQ_Ver0104_SC112",
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
