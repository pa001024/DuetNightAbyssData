return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101920532429",
      startPort = "StoryStart",
      endStory = "1781167101920532431",
      endPort = "In"
    },
    {
      startStory = "1781167101920532431",
      startPort = "Success",
      endStory = "1781167101920532430",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101920532429"] = {
      isStoryNode = true,
      key = "1781167101920532429",
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
    ["1781167101920532430"] = {
      isStoryNode = true,
      key = "1781167101920532430",
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
    ["1781167101920532431"] = {
      isStoryNode = true,
      key = "1781167101920532431",
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
            startQuest = "1781167101920532436",
            startPort = "Out",
            endQuest = "1781167101920532438",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532433",
            startPort = "QuestStart",
            endQuest = "1781167101920532436",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532433",
            startPort = "QuestStart",
            endQuest = "1781167101920532437",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532437",
            startPort = "Out",
            endQuest = "1781167101920532439",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532439",
            startPort = "Out",
            endQuest = "17811684670372041171",
            endPort = "In"
          },
          {
            startQuest = "17811684670372041171",
            startPort = "Out",
            endQuest = "1781168300252691",
            endPort = "In"
          },
          {
            startQuest = "1781168300252691",
            startPort = "Out",
            endQuest = "17811684754422041503",
            endPort = "In"
          },
          {
            startQuest = "17811684754422041503",
            startPort = "Out",
            endQuest = "1781167101920532434",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101920532433"] = {
            key = "1781167101920532433",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101920532434"] = {
            key = "1781167101920532434",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101920532435"] = {
            key = "1781167101920532435",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101920532436"] = {
            key = "1781167101920532436",
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
          ["1781167101920532437"] = {
            key = "1781167101920532437",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101702,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101920532438"] = {
            key = "1781167101920532438",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101702,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101920532439"] = {
            key = "1781167101920532439",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2sew1passivefailpoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781168300252691"] = {
            key = "1781168300252691",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1613.5000000000007, y = 564.8888888888889},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC003/SQ_OBT0103_SC003",
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
          },
          ["17811684670372041171"] = {
            key = "17811684670372041171",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1482.3334415584413, y = 713.3714285714286},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101701}
            }
          },
          ["17811684754422041503"] = {
            key = "17811684754422041503",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1914.8678571428575, y = 665.3714285714286},
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
