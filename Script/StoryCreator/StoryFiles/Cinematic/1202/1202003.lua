return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742445536245",
      startPort = "StoryStart",
      endStory = "1781144742445536247",
      endPort = "In"
    },
    {
      startStory = "1781144742445536247",
      startPort = "Success",
      endStory = "1781144742445536246",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742445536245"] = {
      isStoryNode = true,
      key = "1781144742445536245",
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
    ["1781144742445536246"] = {
      isStoryNode = true,
      key = "1781144742445536246",
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
    ["1781144742445536247"] = {
      isStoryNode = true,
      key = "1781144742445536247",
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
            startQuest = "1781144742445536253",
            startPort = "Out",
            endQuest = "1781144742445536255",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536250",
            startPort = "QuestStart",
            endQuest = "1781144742445536253",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536250",
            startPort = "QuestStart",
            endQuest = "1781144742445536254",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536254",
            startPort = "Out",
            endQuest = "1781144742445536256",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536248",
            startPort = "Out",
            endQuest = "1781144742445536257",
            endPort = "In"
          },
          {
            startQuest = "1781144742445536257",
            startPort = "Out",
            endQuest = "1781144742445536251",
            endPort = "Success"
          },
          {
            startQuest = "1781144742445536256",
            startPort = "Out",
            endQuest = "17811477305846169575",
            endPort = "In"
          },
          {
            startQuest = "17811477305846169575",
            startPort = "Out",
            endQuest = "1781144742445536248",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742445536248"] = {
            key = "1781144742445536248",
            type = "TalkNode",
            name = "刻舟VS狼灵（下）应天尉登场",
            pos = {x = 1875.7614171977652, y = 567.7391304347826},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC003/Ver0102_SC003",
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
              EndNewTargetPointName = "QuestPoint6",
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
          ["1781144742445536250"] = {
            key = "1781144742445536250",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742445536251"] = {
            key = "1781144742445536251",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2409.9999999999995, y = 562.857142857143},
            propsData = {ModeType = 0}
          },
          ["1781144742445536252"] = {
            key = "1781144742445536252",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742445536253"] = {
            key = "1781144742445536253",
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
          ["1781144742445536254"] = {
            key = "1781144742445536254",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104505,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742445536255"] = {
            key = "1781144742445536255",
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
          ["1781144742445536256"] = {
            key = "1781144742445536256",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
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
          ["1781144742445536257"] = {
            key = "1781144742445536257",
            type = "PlayOrStopBGMNode",
            name = "Mute屏蔽场景音效",
            pos = {x = 2146.4761904761904, y = 556.5595238095239},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["17811477305846169575"] = {
            key = "17811477305846169575",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1588.7038195234063, y = 612.1914504557988},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0101_story_zhuyinzhizai_low.0101_story_zhuyinzhizai_low'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
