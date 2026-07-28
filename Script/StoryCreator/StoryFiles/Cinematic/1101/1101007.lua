return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150594764814159",
      startPort = "StoryStart",
      endStory = "178150594840614190",
      endPort = "In"
    },
    {
      startStory = "178150594840614190",
      startPort = "Success",
      endStory = "178150594764914162",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150594764814159"] = {
      isStoryNode = true,
      key = "178150594764814159",
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
    ["178150594764914162"] = {
      isStoryNode = true,
      key = "178150594764914162",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1668, y = 308},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150594840614190"] = {
      isStoryNode = true,
      key = "178150594840614190",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1272, y = 310},
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
            startQuest = "178150594840614198",
            startPort = "Out",
            endQuest = "178150594840614200",
            endPort = "In"
          },
          {
            startQuest = "178150594840614195",
            startPort = "QuestStart",
            endQuest = "178150594840614198",
            endPort = "In"
          },
          {
            startQuest = "178150594840614195",
            startPort = "QuestStart",
            endQuest = "178150594840614199",
            endPort = "In"
          },
          {
            startQuest = "178150594840614203",
            startPort = "Out",
            endQuest = "178150594840614196",
            endPort = "Success"
          },
          {
            startQuest = "178150594840614202",
            startPort = "Out",
            endQuest = "178150594840614205",
            endPort = "In"
          },
          {
            startQuest = "178150594840614205",
            startPort = "Out",
            endQuest = "178150595619714494",
            endPort = "In"
          },
          {
            startQuest = "178150595619714494",
            startPort = "Out",
            endQuest = "178150594840614203",
            endPort = "In"
          },
          {
            startQuest = "178150594840614199",
            startPort = "Out",
            endQuest = "178150594840614202",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150594840614195"] = {
            key = "178150594840614195",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178150594840614196"] = {
            key = "178150594840614196",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178150594840614197"] = {
            key = "178150594840614197",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150594840614198"] = {
            key = "178150594840614198",
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
          ["178150594840614199"] = {
            key = "178150594840614199",
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
          ["178150594840614200"] = {
            key = "178150594840614200",
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
          ["178150594840614202"] = {
            key = "178150594840614202",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_EX01BOSS02Start",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178150594840614203"] = {
            key = "178150594840614203",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150594840614205"] = {
            key = "178150594840614205",
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
          ["178150595619714494"] = {
            key = "178150595619714494",
            type = "TalkNode",
            name = "过场-SC007-秽兽再临",
            pos = {x = 2001.4561857317685, y = 532.4517267722135},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC007/SQ_OBT0102_SC007",
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
