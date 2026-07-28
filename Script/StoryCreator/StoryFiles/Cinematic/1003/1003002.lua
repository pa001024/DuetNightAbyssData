return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101915531109",
      startPort = "StoryStart",
      endStory = "1781167101915531111",
      endPort = "In"
    },
    {
      startStory = "1781167101915531111",
      startPort = "Success",
      endStory = "1781167101915531110",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101915531109"] = {
      isStoryNode = true,
      key = "1781167101915531109",
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
    ["1781167101915531110"] = {
      isStoryNode = true,
      key = "1781167101915531110",
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
    ["1781167101915531111"] = {
      isStoryNode = true,
      key = "1781167101915531111",
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
            startQuest = "1781167101915531116",
            startPort = "Out",
            endQuest = "1781167101915531118",
            endPort = "In"
          },
          {
            startQuest = "1781167101915531113",
            startPort = "QuestStart",
            endQuest = "1781167101915531116",
            endPort = "In"
          },
          {
            startQuest = "1781167101915531113",
            startPort = "QuestStart",
            endQuest = "1781167101915531117",
            endPort = "In"
          },
          {
            startQuest = "1781167101915531117",
            startPort = "Out",
            endQuest = "1781167101915531119",
            endPort = "In"
          },
          {
            startQuest = "1781167101915531119",
            startPort = "Out",
            endQuest = "17811683654511020909",
            endPort = "In"
          },
          {
            startQuest = "17811683654511020909",
            startPort = "Out",
            endQuest = "17811680034323062155",
            endPort = "In"
          },
          {
            startQuest = "17811680034323062155",
            startPort = "Out",
            endQuest = "17811683752181021185",
            endPort = "In"
          },
          {
            startQuest = "17811683752181021185",
            startPort = "Out",
            endQuest = "1781167101915531114",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101915531113"] = {
            key = "1781167101915531113",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101915531114"] = {
            key = "1781167101915531114",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101915531115"] = {
            key = "1781167101915531115",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101915531116"] = {
            key = "1781167101915531116",
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
          ["1781167101915531117"] = {
            key = "1781167101915531117",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 813.6002527216679, y = 549.2426601050693},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101703,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101915531118"] = {
            key = "1781167101915531118",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101703,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101915531119"] = {
            key = "1781167101915531119",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2sew1passivefailpoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811680034323062155"] = {
            key = "17811680034323062155",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1694.238041125541, y = 568.0555555555555},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC002/SQ_OBT0103_SC002_A",
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
          ["17811683654511020909"] = {
            key = "17811683654511020909",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1552.4831932773113, y = 782.4901960784313},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt03/0074_story_encounter_with_blues",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101701}
            }
          },
          ["17811683752181021185"] = {
            key = "17811683752181021185",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1972.2429335370516, y = 764.7124183006536},
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
