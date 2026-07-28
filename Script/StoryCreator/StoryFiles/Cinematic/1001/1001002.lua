return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17805604524921524088",
      startPort = "StoryStart",
      endStory = "17805604524921524090",
      endPort = "In"
    },
    {
      startStory = "17805604524921524090",
      startPort = "Success",
      endStory = "17805604524921524089",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17805604524921524088"] = {
      isStoryNode = true,
      key = "17805604524921524088",
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
    ["17805604524921524089"] = {
      isStoryNode = true,
      key = "17805604524921524089",
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
    ["17805604524921524090"] = {
      isStoryNode = true,
      key = "17805604524921524090",
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
            startQuest = "17805604524921524094",
            startPort = "Out",
            endQuest = "17805604524921524096",
            endPort = "In"
          },
          {
            startQuest = "17805604524921524091",
            startPort = "QuestStart",
            endQuest = "17805604524921524094",
            endPort = "In"
          },
          {
            startQuest = "17805604524921524091",
            startPort = "QuestStart",
            endQuest = "17805604524921524095",
            endPort = "In"
          },
          {
            startQuest = "17805604524921524097",
            startPort = "Out",
            endQuest = "17805604524931524099",
            endPort = "In"
          },
          {
            startQuest = "17805604524931524099",
            startPort = "Out",
            endQuest = "17805604524931524100",
            endPort = "In"
          },
          {
            startQuest = "17805604524921524097",
            startPort = "Out",
            endQuest = "17805604524921524098",
            endPort = "In"
          },
          {
            startQuest = "17805604524921524095",
            startPort = "Out",
            endQuest = "17805604524921524097",
            endPort = "In"
          },
          {
            startQuest = "17805633374086032384",
            startPort = "Out",
            endQuest = "17805604524921524092",
            endPort = "Success"
          },
          {
            startQuest = "17805604524921524098",
            startPort = "Out",
            endQuest = "17810938602951545967",
            endPort = "In"
          },
          {
            startQuest = "17810938602951545967",
            startPort = "Out",
            endQuest = "17805633374086032384",
            endPort = "In"
          }
        },
        nodeData = {
          ["17805604524921524091"] = {
            key = "17805604524921524091",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17805604524921524092"] = {
            key = "17805604524921524092",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.763975155279, y = 516.3975155279504},
            propsData = {ModeType = 0}
          },
          ["17805604524921524093"] = {
            key = "17805604524921524093",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17805604524921524094"] = {
            key = "17805604524921524094",
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
          ["17805604524921524095"] = {
            key = "17805604524921524095",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 911.6522007736158, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 100104,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17805604524921524096"] = {
            key = "17805604524921524096",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 100104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17805604524921524097"] = {
            key = "17805604524921524097",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1335.3136405739217, y = 524.9492849771489},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestVoidPre",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17805604524921524098"] = {
            key = "17805604524921524098",
            type = "TalkNode",
            name = "过场-100191-和前男主对话-SC02",
            pos = {x = 1732, y = 509.14285714285717},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC002/SQ_OBT0100_SC002",
              BlendInTime = 1,
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
          ["17805604524931524099"] = {
            key = "17805604524931524099",
            type = "PlayOrStopBGMNode",
            name = "bgm - start",
            pos = {x = 1497.7697368421054, y = 734.8314536340852},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0002_story_shahai",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17805604524931524100"] = {
            key = "17805604524931524100",
            type = "PlayOrStopBGMNode",
            name = "noise - state 0 - start",
            pos = {x = 1777.7697368421054, y = 746.2600250626565},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 1,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/cine/OBT0100/SC002.SC002'",
              ParamKey = "state",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17805633373326032380"] = {
            key = "17805633373326032380",
            type = "PlayOrStopBGMNode",
            name = "bgm - start",
            pos = {x = 1848.725504472644, y = 919.4094289577702},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0002_story_shahai",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17805633374086032384"] = {
            key = "17805633374086032384",
            type = "PlayOrStopBGMNode",
            name = "bgm - stop",
            pos = {x = 2253.0733305596004, y = 520.2789941751614},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17810938602951545967"] = {
            key = "17810938602951545967",
            type = "PlayOrStopBGMNode",
            name = "noise - state 0 - stop",
            pos = {x = 2009.5495150386625, y = 521.0091084488714},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
