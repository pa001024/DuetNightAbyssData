return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116252417210179726",
      startPort = "StoryStart",
      endStory = "178116252794310179816",
      endPort = "In"
    },
    {
      startStory = "178116252794310179816",
      startPort = "Success",
      endStory = "178116252417210179729",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116252417210179726"] = {
      isStoryNode = true,
      key = "178116252417210179726",
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
    ["178116252417210179729"] = {
      isStoryNode = true,
      key = "178116252417210179729",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1863.5714285714284, y = 317.14285714285717},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116252794310179816"] = {
      isStoryNode = true,
      key = "178116252794310179816",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1366.1428571428569, y = 346.2857142857142},
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
            startQuest = "178116252794310179824",
            startPort = "Out",
            endQuest = "178116252794310179826",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179821",
            startPort = "QuestStart",
            endQuest = "178116252794310179824",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179821",
            startPort = "QuestStart",
            endQuest = "178116252794310179825",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179825",
            startPort = "Out",
            endQuest = "178116252794310179827",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179827",
            startPort = "Out",
            endQuest = "178116252794310179828",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179829",
            startPort = "Out",
            endQuest = "178116252794310179822",
            endPort = "Success"
          },
          {
            startQuest = "178116252794310179828",
            startPort = "Out",
            endQuest = "178116252794310179830",
            endPort = "In"
          },
          {
            startQuest = "178116252794310179830",
            startPort = "Out",
            endQuest = "178116263323711198156",
            endPort = "In"
          },
          {
            startQuest = "178116263323711198156",
            startPort = "Out",
            endQuest = "178116252794310179829",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116252794310179821"] = {
            key = "178116252794310179821",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116252794310179822"] = {
            key = "178116252794310179822",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116252794310179823"] = {
            key = "178116252794310179823",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116252794310179824"] = {
            key = "178116252794310179824",
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
          ["178116252794310179825"] = {
            key = "178116252794310179825",
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
          ["178116252794310179826"] = {
            key = "178116252794310179826",
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
          ["178116252794310179827"] = {
            key = "178116252794310179827",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116252794310179828"] = {
            key = "178116252794310179828",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZhujueBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116252794310179829"] = {
            key = "178116252794310179829",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116252794310179830"] = {
            key = "178116252794310179830",
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
          ["178116263323711198156"] = {
            key = "178116263323711198156",
            type = "TalkNode",
            name = "过场-希尔妲出手相救",
            pos = {x = 1904.3444337835022, y = 581.550585213296},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC013/SQ_Ver0104_SC013",
              BlendInTime = 2,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
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
