return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150962150120979917",
      startPort = "StoryStart",
      endStory = "178150962221920979949",
      endPort = "In"
    },
    {
      startStory = "178150962221920979949",
      startPort = "Success",
      endStory = "178150962150120979920",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150962150120979917"] = {
      isStoryNode = true,
      key = "178150962150120979917",
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
    ["178150962150120979920"] = {
      isStoryNode = true,
      key = "178150962150120979920",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1852, y = 266},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150962221920979949"] = {
      isStoryNode = true,
      key = "178150962221920979949",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1468, y = 290},
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
            startQuest = "178150962221920979957",
            startPort = "Out",
            endQuest = "178150962221920979959",
            endPort = "In"
          },
          {
            startQuest = "178150962221920979954",
            startPort = "QuestStart",
            endQuest = "178150962221920979957",
            endPort = "In"
          },
          {
            startQuest = "178150962221920979954",
            startPort = "QuestStart",
            endQuest = "178150962221920979958",
            endPort = "In"
          },
          {
            startQuest = "178150962221920979962",
            startPort = "Out",
            endQuest = "178150962221920979955",
            endPort = "Success"
          },
          {
            startQuest = "178150962221920979961",
            startPort = "Out",
            endQuest = "178150965322420980407",
            endPort = "In"
          },
          {
            startQuest = "178150965322420980407",
            startPort = "Out",
            endQuest = "178150965885520980598",
            endPort = "In"
          },
          {
            startQuest = "178150965885520980598",
            startPort = "Out",
            endQuest = "178150962221920979962",
            endPort = "In"
          },
          {
            startQuest = "178150962221920979958",
            startPort = "Out",
            endQuest = "178150962221920979961",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150962221920979954"] = {
            key = "178150962221920979954",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178150962221920979955"] = {
            key = "178150962221920979955",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178150962221920979956"] = {
            key = "178150962221920979956",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150962221920979957"] = {
            key = "178150962221920979957",
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
          ["178150962221920979958"] = {
            key = "178150962221920979958",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102104,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178150962221920979959"] = {
            key = "178150962221920979959",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178150962221920979961"] = {
            key = "178150962221920979961",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1370.8801430369758, y = 535.4726839919272},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_JailBoss",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178150962221920979962"] = {
            key = "178150962221920979962",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150965322420980407"] = {
            key = "178150965322420980407",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1615.264130637333, y = 567.3715645898784},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0055_combat_boss_haier.0055_combat_boss_haier'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178150965885520980598"] = {
            key = "178150965885520980598",
            type = "TalkNode",
            name = "过场 - SC015 - BOSS战登场",
            pos = {x = 1956.6434409821609, y = 590.3376207589224},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC015/SQ_OBT0102_SC015",
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
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
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
