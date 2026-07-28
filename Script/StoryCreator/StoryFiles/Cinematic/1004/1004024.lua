return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811699209857176907",
      startPort = "Success",
      endStory = "17811699202447176879",
      endPort = "StoryEnd"
    },
    {
      startStory = "17811699202447176876",
      startPort = "StoryStart",
      endStory = "17811699209857176907",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17811699202447176876"] = {
      isStoryNode = true,
      key = "17811699202447176876",
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
    ["17811699202447176879"] = {
      isStoryNode = true,
      key = "17811699202447176879",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1698, y = 292},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811699209857176907"] = {
      isStoryNode = true,
      key = "17811699209857176907",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1162, y = 308},
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
            startQuest = "17811699209857176915",
            startPort = "Out",
            endQuest = "17811699209857176917",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176912",
            startPort = "QuestStart",
            endQuest = "17811699209857176915",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176912",
            startPort = "QuestStart",
            endQuest = "17811699209857176916",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176916",
            startPort = "Out",
            endQuest = "17811699209857176918",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176918",
            startPort = "Out",
            endQuest = "17811699209857176919",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176920",
            startPort = "Out",
            endQuest = "17811699209857176913",
            endPort = "Success"
          },
          {
            startQuest = "17811699209857176919",
            startPort = "Out",
            endQuest = "17811699209857176921",
            endPort = "In"
          },
          {
            startQuest = "17811699209857176921",
            startPort = "Out",
            endQuest = "17811699610388202658",
            endPort = "In"
          },
          {
            startQuest = "17811699610388202658",
            startPort = "Out",
            endQuest = "17811699209857176920",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811699209857176912"] = {
            key = "17811699209857176912",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17811699209857176913"] = {
            key = "17811699209857176913",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17811699209857176914"] = {
            key = "17811699209857176914",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811699209857176915"] = {
            key = "17811699209857176915",
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
          ["17811699209857176916"] = {
            key = "17811699209857176916",
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
          ["17811699209857176917"] = {
            key = "17811699209857176917",
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
          ["17811699209857176918"] = {
            key = "17811699209857176918",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811699209857176919"] = {
            key = "17811699209857176919",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_GetTrainHead",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811699209857176920"] = {
            key = "17811699209857176920",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811699209857176921"] = {
            key = "17811699209857176921",
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
          ["17811699610388202658"] = {
            key = "17811699610388202658",
            type = "TalkNode",
            name = "过场-主角试图操作控制台",
            pos = {x = 1902.0115526263444, y = 547.537321039194},
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
