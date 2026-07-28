return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742450537138",
      startPort = "StoryStart",
      endStory = "1781144742450537140",
      endPort = "In"
    },
    {
      startStory = "1781144742450537140",
      startPort = "Success",
      endStory = "1781144742450537139",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742450537138"] = {
      isStoryNode = true,
      key = "1781144742450537138",
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
    ["1781144742450537139"] = {
      isStoryNode = true,
      key = "1781144742450537139",
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
    ["1781144742450537140"] = {
      isStoryNode = true,
      key = "1781144742450537140",
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
            startQuest = "1781144742450537146",
            startPort = "Out",
            endQuest = "1781144742450537148",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537143",
            startPort = "QuestStart",
            endQuest = "1781144742450537146",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537143",
            startPort = "QuestStart",
            endQuest = "1781144742450537147",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537147",
            startPort = "Out",
            endQuest = "1781144742450537149",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537150",
            startPort = "Out",
            endQuest = "1781144742450537141",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537141",
            startPort = "Out",
            endQuest = "1781144742450537151",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537151",
            startPort = "Out",
            endQuest = "1781144742450537144",
            endPort = "Success"
          },
          {
            startQuest = "1781144742450537149",
            startPort = "Out",
            endQuest = "1781144742450537150",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742450537141"] = {
            key = "1781144742450537141",
            type = "TalkNode",
            name = "破迷宫炮火破局，主角团英雄归来！",
            pos = {x = 1988.4270291112398, y = 600.3408521303259},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC009/Ver0102_SC009",
              BlendInTime = 0.5,
              InType = "FadeIn",
              OutType = "BlendOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
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
              EndNewTargetPointName = "QuestPoint10507",
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
          ["1781144742450537143"] = {
            key = "1781144742450537143",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742450537144"] = {
            key = "1781144742450537144",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2615.6784268363213, y = 604.6923076923078},
            propsData = {ModeType = 0}
          },
          ["1781144742450537145"] = {
            key = "1781144742450537145",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742450537146"] = {
            key = "1781144742450537146",
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
          ["1781144742450537147"] = {
            key = "1781144742450537147",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742450537148"] = {
            key = "1781144742450537148",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742450537149"] = {
            key = "1781144742450537149",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020402fangshou_Start",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742450537150"] = {
            key = "1781144742450537150",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 1704.2857142857142, y = 594.8571428571429},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0140_cs_suyi_fly_with_player.0140_cs_suyi_fly_with_player'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742450537151"] = {
            key = "1781144742450537151",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 2281.138157894737, y = 609.0899122807019},
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
