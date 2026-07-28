return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101916531373",
      startPort = "StoryStart",
      endStory = "1781167101916531375",
      endPort = "In"
    },
    {
      startStory = "1781167101916531375",
      startPort = "Success",
      endStory = "1781167101916531374",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101916531373"] = {
      isStoryNode = true,
      key = "1781167101916531373",
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
    ["1781167101916531374"] = {
      isStoryNode = true,
      key = "1781167101916531374",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1976, y = 342},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781167101916531375"] = {
      isStoryNode = true,
      key = "1781167101916531375",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1266, y = 272},
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
            startQuest = "1781167101916531380",
            startPort = "Out",
            endQuest = "1781167101916531382",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531377",
            startPort = "QuestStart",
            endQuest = "1781167101916531380",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531377",
            startPort = "QuestStart",
            endQuest = "1781167101916531381",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531381",
            startPort = "Out",
            endQuest = "1781167101916531383",
            endPort = "In"
          },
          {
            startQuest = "1781167101916531383",
            startPort = "Out",
            endQuest = "17811685984484081330",
            endPort = "In"
          },
          {
            startQuest = "17811685984484081330",
            startPort = "Out",
            endQuest = "17811686015344081436",
            endPort = "In"
          },
          {
            startQuest = "17811686015344081436",
            startPort = "Out",
            endQuest = "17811686063914081610",
            endPort = "In"
          },
          {
            startQuest = "17811686063914081610",
            startPort = "Out",
            endQuest = "1781167101916531378",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101916531377"] = {
            key = "1781167101916531377",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101916531378"] = {
            key = "1781167101916531378",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101916531379"] = {
            key = "1781167101916531379",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101916531380"] = {
            key = "1781167101916531380",
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
          ["1781167101916531381"] = {
            key = "1781167101916531381",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 103201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101916531382"] = {
            key = "1781167101916531382",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 103201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101916531383"] = {
            key = "1781167101916531383",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "alchSpawnPoint",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811685984484081330"] = {
            key = "17811685984484081330",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1438.3465544871794, y = 613.7024309024312},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0079_story_escape_from_lab_cs",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {103201}
            }
          },
          ["17811686015344081436"] = {
            key = "17811686015344081436",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1651.326923076923, y = 684.525274725275},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC004/SQ_OBT0103_SC004",
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
          },
          ["17811686063914081610"] = {
            key = "17811686063914081610",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1873.9230769230771, y = 580.6791208791211},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
