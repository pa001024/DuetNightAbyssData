return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17815061775792109681",
      startPort = "Success",
      endStory = "17815061755022109642",
      endPort = "StoryEnd"
    },
    {
      startStory = "17815061755022109639",
      startPort = "StoryStart",
      endStory = "17815061775792109681",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17815061755022109639"] = {
      isStoryNode = true,
      key = "17815061755022109639",
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
    ["17815061755022109642"] = {
      isStoryNode = true,
      key = "17815061755022109642",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1806, y = 350},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815061775792109681"] = {
      isStoryNode = true,
      key = "17815061775792109681",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1486, y = 370},
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
            startQuest = "17815061775792109689",
            startPort = "Out",
            endQuest = "17815061775792109691",
            endPort = "In"
          },
          {
            startQuest = "17815061775792109686",
            startPort = "QuestStart",
            endQuest = "17815061775792109689",
            endPort = "In"
          },
          {
            startQuest = "17815061775792109686",
            startPort = "QuestStart",
            endQuest = "17815061775792109690",
            endPort = "In"
          },
          {
            startQuest = "17815061775792109694",
            startPort = "Out",
            endQuest = "17815061775792109687",
            endPort = "Success"
          },
          {
            startQuest = "17815061775792109693",
            startPort = "Out",
            endQuest = "17815061775792109695",
            endPort = "In"
          },
          {
            startQuest = "17815061775792109695",
            startPort = "Out",
            endQuest = "17815062400723157660",
            endPort = "In"
          },
          {
            startQuest = "17815062400723157660",
            startPort = "Out",
            endQuest = "17815061775792109694",
            endPort = "In"
          },
          {
            startQuest = "17815061775792109690",
            startPort = "Out",
            endQuest = "17815061775792109693",
            endPort = "In"
          }
        },
        nodeData = {
          ["17815061775792109686"] = {
            key = "17815061775792109686",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17815061775792109687"] = {
            key = "17815061775792109687",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17815061775792109688"] = {
            key = "17815061775792109688",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17815061775792109689"] = {
            key = "17815061775792109689",
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
          ["17815061775792109690"] = {
            key = "17815061775792109690",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17815061775792109691"] = {
            key = "17815061775792109691",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17815061775792109693"] = {
            key = "17815061775792109693",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "EX01_FixSimple_19point02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17815061775792109694"] = {
            key = "17815061775792109694",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17815061775792109695"] = {
            key = "17815061775792109695",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1689.661408788431, y = 528.5359727848808},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {102102}
            }
          },
          ["17815062400723157660"] = {
            key = "17815062400723157660",
            type = "TalkNode",
            name = "过场-SC008-富尔维斯登场",
            pos = {x = 1997.9980426380707, y = 573.2940680774391},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC008/SQ_OBT0102_SC008",
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
