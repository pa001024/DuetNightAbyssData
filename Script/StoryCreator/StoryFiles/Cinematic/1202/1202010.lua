return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742450537281",
      startPort = "StoryStart",
      endStory = "1781144742450537283",
      endPort = "In"
    },
    {
      startStory = "1781144742450537283",
      startPort = "Success",
      endStory = "1781144742450537282",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742450537281"] = {
      isStoryNode = true,
      key = "1781144742450537281",
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
    ["1781144742450537282"] = {
      isStoryNode = true,
      key = "1781144742450537282",
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
    ["1781144742450537283"] = {
      isStoryNode = true,
      key = "1781144742450537283",
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
            startQuest = "1781144742450537289",
            startPort = "Out",
            endQuest = "1781144742450537291",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537286",
            startPort = "QuestStart",
            endQuest = "1781144742450537289",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537286",
            startPort = "QuestStart",
            endQuest = "1781144742450537290",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537290",
            startPort = "Out",
            endQuest = "1781144742450537292",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537292",
            startPort = "Out",
            endQuest = "178116557195024680882",
            endPort = "In"
          },
          {
            startQuest = "178116557195024680882",
            startPort = "Out",
            endQuest = "1781144742450537285",
            endPort = "In"
          },
          {
            startQuest = "1781144742450537285",
            startPort = "Out",
            endQuest = "178116557603924680992",
            endPort = "In"
          },
          {
            startQuest = "178116557603924680992",
            startPort = "Out",
            endQuest = "1781144742450537287",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742450537285"] = {
            key = "1781144742450537285",
            type = "TalkNode",
            name = "止流一骑当千+止流掐指心意决，双龙缠斗震天陵。音乐（无主角）",
            pos = {x = 1727.7459165154264, y = 554.6533575317604},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC010/Ver0102_SC010",
              BlendOutTime = 0.5,
              InType = "BlendIn",
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
              EndNewTargetPointName = "QuestPoint10507",
              CameraLookAtTartgetPoint = "QuestPoint10507_Look",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742450537286"] = {
            key = "1781144742450537286",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742450537287"] = {
            key = "1781144742450537287",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742450537288"] = {
            key = "1781144742450537288",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742450537289"] = {
            key = "1781144742450537289",
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
          ["1781144742450537290"] = {
            key = "1781144742450537290",
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
          ["1781144742450537291"] = {
            key = "1781144742450537291",
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
          ["1781144742450537292"] = {
            key = "1781144742450537292",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TRLM_START",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116557195024680882"] = {
            key = "178116557195024680882",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1484.6975422063401, y = 682.5217748268723},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0144_cs_zhiliu_combat_with_bailong.0144_cs_zhiliu_combat_with_bailong'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116557603924680992"] = {
            key = "178116557603924680992",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1990.5596111718576, y = 747.6941886199758},
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
