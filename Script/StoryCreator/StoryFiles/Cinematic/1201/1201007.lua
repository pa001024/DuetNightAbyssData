return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742435533983",
      startPort = "StoryStart",
      endStory = "1781144742435533985",
      endPort = "In"
    },
    {
      startStory = "1781144742435533985",
      startPort = "Success",
      endStory = "1781144742435533984",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742435533983"] = {
      isStoryNode = true,
      key = "1781144742435533983",
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
    ["1781144742435533984"] = {
      isStoryNode = true,
      key = "1781144742435533984",
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
    ["1781144742435533985"] = {
      isStoryNode = true,
      key = "1781144742435533985",
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
            startQuest = "1781144742435533991",
            startPort = "Out",
            endQuest = "1781144742435533993",
            endPort = "In"
          },
          {
            startQuest = "1781144742435533988",
            startPort = "QuestStart",
            endQuest = "1781144742435533991",
            endPort = "In"
          },
          {
            startQuest = "1781144742435533988",
            startPort = "QuestStart",
            endQuest = "1781144742435533992",
            endPort = "In"
          },
          {
            startQuest = "1781144742435533992",
            startPort = "Out",
            endQuest = "1781144742435533994",
            endPort = "In"
          },
          {
            startQuest = "1781144742435533986",
            startPort = "Out",
            endQuest = "1781144742435533995",
            endPort = "In"
          },
          {
            startQuest = "1781144742435533995",
            startPort = "Out",
            endQuest = "1781144742435533989",
            endPort = "Success"
          },
          {
            startQuest = "1781144742435533994",
            startPort = "Out",
            endQuest = "17811809075277292575",
            endPort = "In"
          },
          {
            startQuest = "17811809075277292575",
            startPort = "Out",
            endQuest = "1781144742435533986",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742435533986"] = {
            key = "1781144742435533986",
            type = "TalkNode",
            name = "白龙横扫黑狼灵",
            pos = {x = 1770.6363636363637, y = 555.3636363636364},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC007/SQ_Ver0101_SC007",
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
          ["1781144742435533988"] = {
            key = "1781144742435533988",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742435533989"] = {
            key = "1781144742435533989",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2314.9600399600395, y = 571.6533466533468},
            propsData = {ModeType = 0}
          },
          ["1781144742435533990"] = {
            key = "1781144742435533990",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742435533991"] = {
            key = "1781144742435533991",
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
          ["1781144742435533992"] = {
            key = "1781144742435533992",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104110,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742435533993"] = {
            key = "1781144742435533993",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104110,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742435533994"] = {
            key = "1781144742435533994",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Spr01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742435533995"] = {
            key = "1781144742435533995",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2023.6022727272725, y = 570.8484848484848},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811809075277292575"] = {
            key = "17811809075277292575",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1493.092391304348, y = 674.0923913043479},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0112_cs_white_loong_kill_black_wolf",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104110}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
