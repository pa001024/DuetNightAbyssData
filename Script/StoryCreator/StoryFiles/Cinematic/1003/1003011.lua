return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781167101920532297",
      startPort = "StoryStart",
      endStory = "1781167101920532299",
      endPort = "In"
    },
    {
      startStory = "1781167101920532299",
      startPort = "Success",
      endStory = "1781167101920532298",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781167101920532297"] = {
      isStoryNode = true,
      key = "1781167101920532297",
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
    ["1781167101920532298"] = {
      isStoryNode = true,
      key = "1781167101920532298",
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
    ["1781167101920532299"] = {
      isStoryNode = true,
      key = "1781167101920532299",
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
            startQuest = "1781167101920532304",
            startPort = "Out",
            endQuest = "1781167101920532306",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532301",
            startPort = "QuestStart",
            endQuest = "1781167101920532304",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532301",
            startPort = "QuestStart",
            endQuest = "1781167101920532305",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532305",
            startPort = "Out",
            endQuest = "1781167101920532307",
            endPort = "In"
          },
          {
            startQuest = "178116968635511224085",
            startPort = "Out",
            endQuest = "178116968635511224086",
            endPort = "In"
          },
          {
            startQuest = "178116968635511224086",
            startPort = "Out",
            endQuest = "178116966657711224000",
            endPort = "In"
          },
          {
            startQuest = "1781167101920532307",
            startPort = "Out",
            endQuest = "178116968635511224085",
            endPort = "In"
          },
          {
            startQuest = "178116966657711224000",
            startPort = "Out",
            endQuest = "178116969368011224336",
            endPort = "In"
          },
          {
            startQuest = "178116969368011224336",
            startPort = "Out",
            endQuest = "1781167101920532302",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781167101920532301"] = {
            key = "1781167101920532301",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781167101920532302"] = {
            key = "1781167101920532302",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2159.505494505494, y = 549.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781167101920532303"] = {
            key = "1781167101920532303",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781167101920532304"] = {
            key = "1781167101920532304",
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
          ["1781167101920532305"] = {
            key = "1781167101920532305",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101901,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781167101920532306"] = {
            key = "1781167101920532306",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 101901,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781167101920532307"] = {
            key = "1781167101920532307",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "cp2thea2spspawnpoint5kelaifu",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116966657711224000"] = {
            key = "178116966657711224000",
            type = "TalkNode",
            name = "过场",
            pos = {x = 1771, y = 670.4519230769231},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0103/OBT0103_SC011/SQ_OBT0103_SC011",
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
          ["178116968635511224085"] = {
            key = "178116968635511224085",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1494.9498422419426, y = 610.472877260065},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {101901}
            }
          },
          ["178116968635511224086"] = {
            key = "178116968635511224086",
            type = "AuConditionNode",
            name = "音频条件节点",
            pos = {x = 1650.1270808349811, y = 465.04635350916567},
            propsData = {ActionType = 1, Condition = "party"}
          },
          ["178116969368011224336"] = {
            key = "178116969368011224336",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2042.1538461538462, y = 703.9134615384614},
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
