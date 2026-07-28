return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17800511112563459084",
      startPort = "StoryStart",
      endStory = "17800511112563459086",
      endPort = "In"
    },
    {
      startStory = "17800511112563459086",
      startPort = "Success",
      endStory = "17800511112563459085",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17800511112563459084"] = {
      isStoryNode = true,
      key = "17800511112563459084",
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
    ["17800511112563459085"] = {
      isStoryNode = true,
      key = "17800511112563459085",
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
    ["17800511112563459086"] = {
      isStoryNode = true,
      key = "17800511112563459086",
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
            startQuest = "17800511112563459091",
            startPort = "Out",
            endQuest = "17800511112563459093",
            endPort = "In"
          },
          {
            startQuest = "17800511112563459088",
            startPort = "QuestStart",
            endQuest = "17800511112563459091",
            endPort = "In"
          },
          {
            startQuest = "17800511112563459088",
            startPort = "QuestStart",
            endQuest = "17800511112563459092",
            endPort = "In"
          },
          {
            startQuest = "17800511112563459092",
            startPort = "Out",
            endQuest = "17800511112563459094",
            endPort = "In"
          },
          {
            startQuest = "17800511112563459094",
            startPort = "Out",
            endQuest = "17800523035037870189",
            endPort = "In"
          },
          {
            startQuest = "17800523035037870189",
            startPort = "Out",
            endQuest = "17800522619187869994",
            endPort = "In"
          },
          {
            startQuest = "17800522619187869994",
            startPort = "Out",
            endQuest = "178056382009112066363",
            endPort = "In"
          },
          {
            startQuest = "178056382009112066363",
            startPort = "Out",
            endQuest = "17800511112563459089",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17800511112563459088"] = {
            key = "17800511112563459088",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17800511112563459089"] = {
            key = "17800511112563459089",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2476.505494505494, y = 575.835164835165},
            propsData = {ModeType = 0}
          },
          ["17800511112563459090"] = {
            key = "17800511112563459090",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17800511112563459091"] = {
            key = "17800511112563459091",
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
          ["17800511112563459092"] = {
            key = "17800511112563459092",
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
          ["17800511112563459093"] = {
            key = "17800511112563459093",
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
          ["17800511112563459094"] = {
            key = "17800511112563459094",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Quest_TargetPoint_BOSS",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17800522619187869994"] = {
            key = "17800522619187869994",
            type = "TalkNode",
            name = "过场-100120-西比分开两人-SC11",
            pos = {x = 1798, y = 572},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC011/SQ_OBT0100_SC011",
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
          },
          ["17800523035037870189"] = {
            key = "17800523035037870189",
            type = "PlayOrStopBGMNode",
            name = "mute",
            pos = {x = 1461.142857142857, y = 570.5714285714286},
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
          ["178056382009112066363"] = {
            key = "178056382009112066363",
            type = "PlayOrStopBGMNode",
            name = "mute",
            pos = {x = 2120, y = 584},
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
