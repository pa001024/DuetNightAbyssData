return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811697213163075369",
      startPort = "StoryStart",
      endStory = "17811697218453075396",
      endPort = "In"
    },
    {
      startStory = "17811697218453075396",
      startPort = "Success",
      endStory = "17811697213173075372",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811697213163075369"] = {
      isStoryNode = true,
      key = "17811697213163075369",
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
    ["17811697213173075372"] = {
      isStoryNode = true,
      key = "17811697213173075372",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1642, y = 256},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811697218453075396"] = {
      isStoryNode = true,
      key = "17811697218453075396",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1282, y = 256},
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
            startQuest = "17811697218453075404",
            startPort = "Out",
            endQuest = "17811697218453075406",
            endPort = "In"
          },
          {
            startQuest = "17811697218453075401",
            startPort = "QuestStart",
            endQuest = "17811697218453075404",
            endPort = "In"
          },
          {
            startQuest = "17811697218453075401",
            startPort = "QuestStart",
            endQuest = "17811697218453075405",
            endPort = "In"
          },
          {
            startQuest = "17811697218453075405",
            startPort = "Out",
            endQuest = "17811697218453075407",
            endPort = "In"
          },
          {
            startQuest = "17811697218453075407",
            startPort = "Out",
            endQuest = "17811697218453075408",
            endPort = "In"
          },
          {
            startQuest = "17811697218453075409",
            startPort = "Out",
            endQuest = "17811697218453075402",
            endPort = "Success"
          },
          {
            startQuest = "17811697218453075408",
            startPort = "Out",
            endQuest = "17811697218463075410",
            endPort = "In"
          },
          {
            startQuest = "17811697218463075410",
            startPort = "Out",
            endQuest = "17811697492844100577",
            endPort = "In"
          },
          {
            startQuest = "17811697492844100577",
            startPort = "Out",
            endQuest = "17811697218453075409",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811697218453075401"] = {
            key = "17811697218453075401",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17811697218453075402"] = {
            key = "17811697218453075402",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17811697218453075403"] = {
            key = "17811697218453075403",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811697218453075404"] = {
            key = "17811697218453075404",
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
          ["17811697218453075405"] = {
            key = "17811697218453075405",
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
          ["17811697218453075406"] = {
            key = "17811697218453075406",
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
          ["17811697218453075407"] = {
            key = "17811697218453075407",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811697218453075408"] = {
            key = "17811697218453075408",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_HaluojiEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811697218453075409"] = {
            key = "17811697218453075409",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811697218463075410"] = {
            key = "17811697218463075410",
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
          ["17811697492844100577"] = {
            key = "17811697492844100577",
            type = "TalkNode",
            name = "过场-卡嘉最后一击后跳车",
            pos = {x = 1903.0460353849653, y = 524.7787003495389},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC022/SQ_Ver0104_SC022",
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
