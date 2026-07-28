return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742444536087",
      startPort = "StoryStart",
      endStory = "1781144742444536089",
      endPort = "In"
    },
    {
      startStory = "1781144742444536089",
      startPort = "Success",
      endStory = "1781144742444536088",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742444536087"] = {
      isStoryNode = true,
      key = "1781144742444536087",
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
    ["1781144742444536088"] = {
      isStoryNode = true,
      key = "1781144742444536088",
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
    ["1781144742444536089"] = {
      isStoryNode = true,
      key = "1781144742444536089",
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
            startQuest = "1781144742444536093",
            startPort = "Out",
            endQuest = "1781144742444536095",
            endPort = "In"
          },
          {
            startQuest = "1781144742444536090",
            startPort = "QuestStart",
            endQuest = "1781144742444536093",
            endPort = "In"
          },
          {
            startQuest = "1781144742444536090",
            startPort = "QuestStart",
            endQuest = "1781144742444536094",
            endPort = "In"
          },
          {
            startQuest = "1781144742444536094",
            startPort = "Out",
            endQuest = "1781144742444536096",
            endPort = "In"
          },
          {
            startQuest = "1781144742444536096",
            startPort = "Out",
            endQuest = "17811456878102057943",
            endPort = "In"
          },
          {
            startQuest = "17811456878102057943",
            startPort = "Out",
            endQuest = "1781144742444536097",
            endPort = "In"
          },
          {
            startQuest = "1781144742444536097",
            startPort = "Out",
            endQuest = "17811476047205141416",
            endPort = "In"
          },
          {
            startQuest = "17811476047205141416",
            startPort = "Out",
            endQuest = "1781144742444536091",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742444536090"] = {
            key = "1781144742444536090",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742444536091"] = {
            key = "1781144742444536091",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2116.513975155279, y = 555.1475155279504},
            propsData = {ModeType = 0}
          },
          ["1781144742444536092"] = {
            key = "1781144742444536092",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742444536093"] = {
            key = "1781144742444536093",
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
          ["1781144742444536094"] = {
            key = "1781144742444536094",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 911.6522007736158, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104505,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742444536095"] = {
            key = "1781144742444536095",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104505,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742444536096"] = {
            key = "1781144742444536096",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1232.8998474704733, y = 554.9492849771489},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point12020201",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742444536097"] = {
            key = "1781144742444536097",
            type = "TalkNode",
            name = "刻舟VS狼灵（上）",
            pos = {x = 1793.0344827586207, y = 537.0738916256158},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC002/SQ_Ver0102_SC002",
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
          ["1781144742444536101"] = {
            key = "1781144742444536101",
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
          ["17811456878102057943"] = {
            key = "17811456878102057943",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1514.2449132576571, y = 600.6146926536733},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0101_story_zhuyinzhizai_low.0101_story_zhuyinzhizai_low'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["17811476047205141416"] = {
            key = "17811476047205141416",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1934.8484826532494, y = 698.7762703827611},
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
