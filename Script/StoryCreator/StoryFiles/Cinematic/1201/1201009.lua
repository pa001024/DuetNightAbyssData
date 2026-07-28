return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742436534296",
      startPort = "StoryStart",
      endStory = "1781144742436534298",
      endPort = "In"
    },
    {
      startStory = "1781144742436534298",
      startPort = "Success",
      endStory = "1781144742436534297",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742436534296"] = {
      isStoryNode = true,
      key = "1781144742436534296",
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
    ["1781144742436534297"] = {
      isStoryNode = true,
      key = "1781144742436534297",
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
    ["1781144742436534298"] = {
      isStoryNode = true,
      key = "1781144742436534298",
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
            startQuest = "1781144742436534304",
            startPort = "Out",
            endQuest = "1781144742436534306",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534301",
            startPort = "QuestStart",
            endQuest = "1781144742436534304",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534301",
            startPort = "QuestStart",
            endQuest = "1781144742436534305",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534305",
            startPort = "Out",
            endQuest = "1781144742436534307",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534299",
            startPort = "Out",
            endQuest = "1781144742436534309",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534309",
            startPort = "Out",
            endQuest = "1781144742436534302",
            endPort = "Success"
          },
          {
            startQuest = "178118159741511456785",
            startPort = "Out",
            endQuest = "1781144742436534299",
            endPort = "In"
          },
          {
            startQuest = "1781144742436534307",
            startPort = "Out",
            endQuest = "178118159741511456785",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742436534299"] = {
            key = "1781144742436534299",
            type = "TalkNode",
            name = "黑市小弟触发机关",
            pos = {x = 1987.2731829573936, y = 600.3408521303259},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC009/SQ_Ver0101_SC009",
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
          ["1781144742436534301"] = {
            key = "1781144742436534301",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742436534302"] = {
            key = "1781144742436534302",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2615.6784268363213, y = 604.6923076923078},
            propsData = {ModeType = 0}
          },
          ["1781144742436534303"] = {
            key = "1781144742436534303",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742436534304"] = {
            key = "1781144742436534304",
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
          ["1781144742436534305"] = {
            key = "1781144742436534305",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742436534306"] = {
            key = "1781144742436534306",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742436534307"] = {
            key = "1781144742436534307",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1201.8074293937973, y = 640.1822042318073},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_12010502",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742436534309"] = {
            key = "1781144742436534309",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 2282.442505720824, y = 609.0899122807019},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178118159741511456785"] = {
            key = "178118159741511456785",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1692.9731289540987, y = 657.6659038901602},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0118_cs_bad_guy_trigger_gear",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104102}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
