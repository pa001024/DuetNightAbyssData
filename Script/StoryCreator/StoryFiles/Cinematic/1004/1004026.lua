return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178117006423911280548",
      startPort = "Success",
      endStory = "178117006260711280501",
      endPort = "StoryEnd"
    },
    {
      startStory = "178117006260711280498",
      startPort = "StoryStart",
      endStory = "178117006423911280548",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["178117006260711280498"] = {
      isStoryNode = true,
      key = "178117006260711280498",
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
    ["178117006260711280501"] = {
      isStoryNode = true,
      key = "178117006260711280501",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1696, y = 268},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178117006423911280548"] = {
      isStoryNode = true,
      key = "178117006423911280548",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1306, y = 240},
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
            startQuest = "178117006423911280556",
            startPort = "Out",
            endQuest = "178117006424011280558",
            endPort = "In"
          },
          {
            startQuest = "178117006423911280553",
            startPort = "QuestStart",
            endQuest = "178117006423911280556",
            endPort = "In"
          },
          {
            startQuest = "178117006423911280553",
            startPort = "QuestStart",
            endQuest = "178117006423911280557",
            endPort = "In"
          },
          {
            startQuest = "178117006423911280557",
            startPort = "Out",
            endQuest = "178117006424011280559",
            endPort = "In"
          },
          {
            startQuest = "178117006424011280559",
            startPort = "Out",
            endQuest = "178117006424011280560",
            endPort = "In"
          },
          {
            startQuest = "178117006424011280561",
            startPort = "Out",
            endQuest = "178117006423911280554",
            endPort = "Success"
          },
          {
            startQuest = "178117006424011280560",
            startPort = "Out",
            endQuest = "178117006424011280562",
            endPort = "In"
          },
          {
            startQuest = "178117006424011280562",
            startPort = "Out",
            endQuest = "178117009205312306932",
            endPort = "In"
          },
          {
            startQuest = "178117009205312306932",
            startPort = "Out",
            endQuest = "178117006424011280561",
            endPort = "In"
          }
        },
        nodeData = {
          ["178117006423911280553"] = {
            key = "178117006423911280553",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178117006423911280554"] = {
            key = "178117006423911280554",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178117006423911280555"] = {
            key = "178117006423911280555",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178117006423911280556"] = {
            key = "178117006423911280556",
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
          ["178117006423911280557"] = {
            key = "178117006423911280557",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178117006424011280558"] = {
            key = "178117006424011280558",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 106201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178117006424011280559"] = {
            key = "178117006424011280559",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178117006424011280560"] = {
            key = "178117006424011280560",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_FuluoMTTalk",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178117006424011280561"] = {
            key = "178117006424011280561",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178117006424011280562"] = {
            key = "178117006424011280562",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1654.950291446808, y = 568.7364095127256},
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
          ["178117009205312306932"] = {
            key = "178117009205312306932",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1888.0269415841935, y = 442.0307533564139},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC026/Ver0104_SC026",
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
