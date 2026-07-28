return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742454538055",
      startPort = "StoryStart",
      endStory = "1781144742454538057",
      endPort = "In"
    },
    {
      startStory = "1781144742454538057",
      startPort = "Success",
      endStory = "1781144742454538056",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742454538055"] = {
      isStoryNode = true,
      key = "1781144742454538055",
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
    ["1781144742454538056"] = {
      isStoryNode = true,
      key = "1781144742454538056",
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
    ["1781144742454538057"] = {
      isStoryNode = true,
      key = "1781144742454538057",
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
            startQuest = "1781144742454538063",
            startPort = "Out",
            endQuest = "1781144742454538065",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538060",
            startPort = "QuestStart",
            endQuest = "1781144742454538063",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538060",
            startPort = "QuestStart",
            endQuest = "1781144742454538064",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538064",
            startPort = "Out",
            endQuest = "1781144742454538066",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538058",
            startPort = "Out",
            endQuest = "1781144742454538067",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538067",
            startPort = "Out",
            endQuest = "1781144742454538061",
            endPort = "Success"
          },
          {
            startQuest = "1781144742454538066",
            startPort = "Out",
            endQuest = "178116743011734958207",
            endPort = "In"
          },
          {
            startQuest = "178116743011734958207",
            startPort = "Out",
            endQuest = "1781144742454538058",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742454538058"] = {
            key = "1781144742454538058",
            type = "TalkNode",
            name = "VS双龙（上）激战",
            pos = {x = 1798.157894736842, y = 592.2105263157895},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC016/SQ_Ver0102_SC016",
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
          ["1781144742454538060"] = {
            key = "1781144742454538060",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742454538061"] = {
            key = "1781144742454538061",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2541.505494505494, y = 569.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742454538062"] = {
            key = "1781144742454538062",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742454538063"] = {
            key = "1781144742454538063",
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
          ["1781144742454538064"] = {
            key = "1781144742454538064",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105301,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742454538065"] = {
            key = "1781144742454538065",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105301,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742454538066"] = {
            key = "1781144742454538066",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1375.242212002493, y = 572.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BossStart",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742454538067"] = {
            key = "1781144742454538067",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2168, y = 560},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178116743011734958207"] = {
            key = "178116743011734958207",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1503.620743034056, y = 781.6560887512901},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0147_boss_two_dragon.0147_boss_two_dragon'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105301}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
