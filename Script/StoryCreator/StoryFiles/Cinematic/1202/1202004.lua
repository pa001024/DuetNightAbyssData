return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742445536385",
      startPort = "StoryStart",
      endStory = "1781144742445536387",
      endPort = "In"
    },
    {
      startStory = "1781144742445536387",
      startPort = "Success",
      endStory = "1781144742445536386",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742445536385"] = {
      isStoryNode = true,
      key = "1781144742445536385",
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
    ["1781144742445536386"] = {
      isStoryNode = true,
      key = "1781144742445536386",
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
    ["1781144742445536387"] = {
      isStoryNode = true,
      key = "1781144742445536387",
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
            startQuest = "1781144742445536391",
            startPort = "Out",
            endQuest = "1781144742445536393",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536388",
            startPort = "QuestStart",
            endQuest = "1781144742445536391",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536388",
            startPort = "QuestStart",
            endQuest = "1781144742445536392",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536392",
            startPort = "Out",
            endQuest = "1781144742445536394",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536394",
            startPort = "Out",
            endQuest = "17811483349767197956",
            endPort = "In"
          },
          {
            startQuest = "17811483349767197956",
            startPort = "Out",
            endQuest = "1781144742445536395",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536395",
            startPort = "Out",
            endQuest = "17811483520567198275",
            endPort = "In"
          },
          {
            startQuest = "17811483520567198275",
            startPort = "Out",
            endQuest = "1781144742445536389",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742445536388"] = {
            key = "1781144742445536388",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742445536389"] = {
            key = "1781144742445536389",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2293.809523809523, y = 591.5079365079366},
            propsData = {ModeType = 0}
          },
          ["1781144742445536390"] = {
            key = "1781144742445536390",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742445536391"] = {
            key = "1781144742445536391",
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
          ["1781144742445536392"] = {
            key = "1781144742445536392",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104506,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742445536393"] = {
            key = "1781144742445536393",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104506,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742445536394"] = {
            key = "1781144742445536394",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020209teshu_242440006",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742445536395"] = {
            key = "1781144742445536395",
            type = "TalkNode",
            name = "审判刻舟（上）太皓现身",
            pos = {x = 1871.142857142857, y = 567.7142857142857},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC004/Ver0102_SC004",
              InType = "BlendIn",
              OutType = "BlendOut",
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
          ["17811483349767197956"] = {
            key = "17811483349767197956",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1571.8888888888894, y = 587.5555555555557},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0136_cs_bailong_god_appear.0136_cs_bailong_god_appear'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17811483520567198275"] = {
            key = "17811483520567198275",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2115.222222222222, y = 426.44444444444446},
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
