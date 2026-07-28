return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17815065858027348600",
      startPort = "StoryStart",
      endStory = "17815065864547348624",
      endPort = "In"
    },
    {
      startStory = "17815065864547348624",
      startPort = "Success",
      endStory = "17815065858027348603",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17815065858027348600"] = {
      isStoryNode = true,
      key = "17815065858027348600",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 910, y = 288},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815065858027348603"] = {
      isStoryNode = true,
      key = "17815065858027348603",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1726, y = 268},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815065864547348624"] = {
      isStoryNode = true,
      key = "17815065864547348624",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1304, y = 282},
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
            startQuest = "17815065864557348632",
            startPort = "Out",
            endQuest = "17815065864557348634",
            endPort = "In"
          },
          {
            startQuest = "17815065864547348629",
            startPort = "QuestStart",
            endQuest = "17815065864557348632",
            endPort = "In"
          },
          {
            startQuest = "17815065864547348629",
            startPort = "QuestStart",
            endQuest = "17815065864557348633",
            endPort = "In"
          },
          {
            startQuest = "17815065864557348637",
            startPort = "Out",
            endQuest = "17815065864547348630",
            endPort = "Success"
          },
          {
            startQuest = "17815065864557348636",
            startPort = "Out",
            endQuest = "17815065864557348639",
            endPort = "In"
          },
          {
            startQuest = "17815065864557348639",
            startPort = "Out",
            endQuest = "17815066190448396738",
            endPort = "In"
          },
          {
            startQuest = "17815066190448396738",
            startPort = "Out",
            endQuest = "17815065864557348637",
            endPort = "In"
          },
          {
            startQuest = "17815065864557348633",
            startPort = "Out",
            endQuest = "17815065864557348636",
            endPort = "In"
          }
        },
        nodeData = {
          ["17815065864547348629"] = {
            key = "17815065864547348629",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17815065864547348630"] = {
            key = "17815065864547348630",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17815065864547348631"] = {
            key = "17815065864547348631",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17815065864557348632"] = {
            key = "17815065864557348632",
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
          ["17815065864557348633"] = {
            key = "17815065864557348633",
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
          ["17815065864557348634"] = {
            key = "17815065864557348634",
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
          ["17815065864557348636"] = {
            key = "17815065864557348636",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 525.1278564057203},
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
          ["17815065864557348637"] = {
            key = "17815065864557348637",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17815065864557348639"] = {
            key = "17815065864557348639",
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
          ["17815066190448396738"] = {
            key = "17815066190448396738",
            type = "TalkNode",
            name = "过场-SC009-阿瓦尔死",
            pos = {x = 1975.375, y = 528.375},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC009/SQ_OBT0102_SC009",
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
