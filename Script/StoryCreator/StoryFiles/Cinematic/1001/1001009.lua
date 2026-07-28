return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178005265926411333377",
      startPort = "StoryStart",
      endStory = "178005265926411333379",
      endPort = "In"
    },
    {
      startStory = "178005265926411333379",
      startPort = "Success",
      endStory = "178005265926411333378",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178005265926411333377"] = {
      isStoryNode = true,
      key = "178005265926411333377",
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
    ["178005265926411333378"] = {
      isStoryNode = true,
      key = "178005265926411333378",
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
    ["178005265926411333379"] = {
      isStoryNode = true,
      key = "178005265926411333379",
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
            startQuest = "178005265926411333383",
            startPort = "Out",
            endQuest = "178005265926411333385",
            endPort = "In"
          },
          {
            startQuest = "178005265926411333380",
            startPort = "QuestStart",
            endQuest = "178005265926411333383",
            endPort = "In"
          },
          {
            startQuest = "178005265926411333380",
            startPort = "QuestStart",
            endQuest = "178005265926411333384",
            endPort = "In"
          },
          {
            startQuest = "178005265926411333384",
            startPort = "Out",
            endQuest = "178005265926411333386",
            endPort = "In"
          },
          {
            startQuest = "178005265926411333386",
            startPort = "Out",
            endQuest = "17800524840179839892",
            endPort = "In"
          },
          {
            startQuest = "17800524840179839892",
            startPort = "Out",
            endQuest = "178005267468611809496",
            endPort = "In"
          },
          {
            startQuest = "178005267468611809496",
            startPort = "Out",
            endQuest = "17800521832826885567",
            endPort = "In"
          },
          {
            startQuest = "17800521832826885567",
            startPort = "Out",
            endQuest = "178056378029411060986",
            endPort = "In"
          },
          {
            startQuest = "178056378029411060986",
            startPort = "Out",
            endQuest = "178005265926411333381",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17800521832826885567"] = {
            key = "17800521832826885567",
            type = "TalkNode",
            name = "过场-100185-跳大盘子-SC09",
            pos = {x = 1987.2731829573936, y = 600.3408521303259},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0100/OBT0100_SC009/SQ_OBT0100_SC009",
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
          ["17800524840179839892"] = {
            key = "17800524840179839892",
            type = "AuConditionNode",
            name = "音频条件节点",
            pos = {x = 1397.2380952380954, y = 594.4285714285714},
            propsData = {ActionType = 1, Condition = "warzone"}
          },
          ["178005265926411333380"] = {
            key = "178005265926411333380",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178005265926411333381"] = {
            key = "178005265926411333381",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2615.6784268363213, y = 604.6923076923078},
            propsData = {ModeType = 0}
          },
          ["178005265926411333382"] = {
            key = "178005265926411333382",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178005265926411333383"] = {
            key = "178005265926411333383",
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
          ["178005265926411333384"] = {
            key = "178005265926411333384",
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
          ["178005265926411333385"] = {
            key = "178005265926411333385",
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
          ["178005265926411333386"] = {
            key = "178005265926411333386",
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
          ["178005267468611809496"] = {
            key = "178005267468611809496",
            type = "PlayOrStopBGMNode",
            name = "bgm - zhuizhuzhan  - start",
            pos = {x = 1704.2857142857142, y = 594.8571428571429},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0008_combat_zhuizhuzhan",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178056378029411060986"] = {
            key = "178056378029411060986",
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
