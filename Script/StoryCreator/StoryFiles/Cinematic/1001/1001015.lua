return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178005296944115274182",
      startPort = "StoryStart",
      endStory = "178005296944115274184",
      endPort = "In"
    },
    {
      startStory = "178005296944115274184",
      startPort = "Success",
      endStory = "178005296944115274183",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178005296944115274182"] = {
      isStoryNode = true,
      key = "178005296944115274182",
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
    ["178005296944115274183"] = {
      isStoryNode = true,
      key = "178005296944115274183",
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
    ["178005296944115274184"] = {
      isStoryNode = true,
      key = "178005296944115274184",
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
            startQuest = "178005296944115274189",
            startPort = "Out",
            endQuest = "178005296944115274191",
            endPort = "In"
          },
          {
            startQuest = "178005296944115274186",
            startPort = "QuestStart",
            endQuest = "178005296944115274189",
            endPort = "In"
          },
          {
            startQuest = "178005296944115274186",
            startPort = "QuestStart",
            endQuest = "178005296944115274190",
            endPort = "In"
          },
          {
            startQuest = "178005296944115274190",
            startPort = "Out",
            endQuest = "178005296944115274192",
            endPort = "In"
          },
          {
            startQuest = "178005296944115274192",
            startPort = "Out",
            endQuest = "178005296944115274185",
            endPort = "In"
          },
          {
            startQuest = "178005296944115274185",
            startPort = "Out",
            endQuest = "178005295882514764788",
            endPort = "In"
          },
          {
            startQuest = "178005295882514764788",
            startPort = "Out",
            endQuest = "178056393994914077089",
            endPort = "In"
          },
          {
            startQuest = "178056393994914077089",
            startPort = "Out",
            endQuest = "178005296944115274187",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178005295882514764788"] = {
            key = "178005295882514764788",
            type = "TalkNode",
            name = "过场-100122-兰迪追人-SC15",
            pos = {x = 1829.157894736842, y = 584.2105263157895},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC015/SQ_OBT0100_SC015",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          },
          ["178005296944115274185"] = {
            key = "178005296944115274185",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 1499.212637207993, y = 577.0778014555104},
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
          ["178005296944115274186"] = {
            key = "178005296944115274186",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178005296944115274187"] = {
            key = "178005296944115274187",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2541.505494505494, y = 569.835164835165},
            propsData = {ModeType = 0}
          },
          ["178005296944115274188"] = {
            key = "178005296944115274188",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178005296944115274189"] = {
            key = "178005296944115274189",
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
          ["178005296944115274190"] = {
            key = "178005296944115274190",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178005296944115274191"] = {
            key = "178005296944115274191",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178005296944115274192"] = {
            key = "178005296944115274192",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint10504",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178056393994914077089"] = {
            key = "178056393994914077089",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2168, y = 560},
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
