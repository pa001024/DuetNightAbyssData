return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742447536825",
      startPort = "StoryStart",
      endStory = "1781144742447536827",
      endPort = "In"
    },
    {
      startStory = "1781144742447536827",
      startPort = "Success",
      endStory = "1781144742447536826",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742447536825"] = {
      isStoryNode = true,
      key = "1781144742447536825",
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
    ["1781144742447536826"] = {
      isStoryNode = true,
      key = "1781144742447536826",
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
    ["1781144742447536827"] = {
      isStoryNode = true,
      key = "1781144742447536827",
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
            startQuest = "1781144742447536833",
            startPort = "Out",
            endQuest = "1781144742447536835",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536830",
            startPort = "QuestStart",
            endQuest = "1781144742447536833",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536830",
            startPort = "QuestStart",
            endQuest = "1781144742447536834",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536834",
            startPort = "Out",
            endQuest = "1781144742447536836",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536829",
            startPort = "Out",
            endQuest = "1781144742447536828",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536836",
            startPort = "Out",
            endQuest = "1781144742447536829",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536828",
            startPort = "Out",
            endQuest = "1781144742447536837",
            endPort = "In"
          },
          {
            startQuest = "1781144742447536837",
            startPort = "Out",
            endQuest = "1781144742447536831",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742447536828"] = {
            key = "1781144742447536828",
            type = "TalkNode",
            name = "止流开卦",
            pos = {x = 1770.6363636363637, y = 555.3636363636364},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC007/SQ_Ver0102_SC007",
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
          ["1781144742447536829"] = {
            key = "1781144742447536829",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 1501.212637207993, y = 577.0778014555104},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0125_story_zhiliu_betray.0125_story_zhiliu_betray'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742447536830"] = {
            key = "1781144742447536830",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742447536831"] = {
            key = "1781144742447536831",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2314.9600399600395, y = 571.6533466533468},
            propsData = {ModeType = 0}
          },
          ["1781144742447536832"] = {
            key = "1781144742447536832",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742447536833"] = {
            key = "1781144742447536833",
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
          ["1781144742447536834"] = {
            key = "1781144742447536834",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105602,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742447536835"] = {
            key = "1781144742447536835",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105602,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742447536836"] = {
            key = "1781144742447536836",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020101StartBP_NewTargetPoint",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742447536837"] = {
            key = "1781144742447536837",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2023.6022727272725, y = 570.8484848484848},
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
