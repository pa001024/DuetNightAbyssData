return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742451537435",
      startPort = "StoryStart",
      endStory = "1781144742451537437",
      endPort = "In"
    },
    {
      startStory = "1781144742451537437",
      startPort = "Success",
      endStory = "1781144742451537436",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742451537435"] = {
      isStoryNode = true,
      key = "1781144742451537435",
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
    ["1781144742451537436"] = {
      isStoryNode = true,
      key = "1781144742451537436",
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
    ["1781144742451537437"] = {
      isStoryNode = true,
      key = "1781144742451537437",
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
            startQuest = "1781144742451537441",
            startPort = "Out",
            endQuest = "1781144742451537443",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537438",
            startPort = "QuestStart",
            endQuest = "1781144742451537441",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537438",
            startPort = "QuestStart",
            endQuest = "1781144742451537442",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537442",
            startPort = "Out",
            endQuest = "1781144742451537444",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537444",
            startPort = "Out",
            endQuest = "1781144742451537446",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537446",
            startPort = "Out",
            endQuest = "1781144742451537445",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537445",
            startPort = "Out",
            endQuest = "1781144742451537447",
            endPort = "In"
          },
          {
            startQuest = "1781144742451537447",
            startPort = "Out",
            endQuest = "1781144742451537439",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742451537438"] = {
            key = "1781144742451537438",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742451537439"] = {
            key = "1781144742451537439",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2476.505494505494, y = 575.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742451537440"] = {
            key = "1781144742451537440",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742451537441"] = {
            key = "1781144742451537441",
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
          ["1781144742451537442"] = {
            key = "1781144742451537442",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104503,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742451537443"] = {
            key = "1781144742451537443",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104503,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742451537444"] = {
            key = "1781144742451537444",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020517Center",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742451537445"] = {
            key = "1781144742451537445",
            type = "TalkNode",
            name = "皓京大乱",
            pos = {x = 1798, y = 572},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC012/Ver0102_SC012",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = false,
              ShowWikiButton = false,
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
          ["1781144742451537446"] = {
            key = "1781144742451537446",
            type = "PlayOrStopBGMNode",
            name = "mute",
            pos = {x = 1460.031746031746, y = 570.5714285714286},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0145_cs_two_lonng_bite.0145_cs_two_lonng_bite'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742451537447"] = {
            key = "1781144742451537447",
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
