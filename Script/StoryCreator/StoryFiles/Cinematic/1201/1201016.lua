return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742439535058",
      startPort = "StoryStart",
      endStory = "1781144742439535060",
      endPort = "In"
    },
    {
      startStory = "1781144742439535060",
      startPort = "Success",
      endStory = "1781144742439535059",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742439535058"] = {
      isStoryNode = true,
      key = "1781144742439535058",
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
    ["1781144742439535059"] = {
      isStoryNode = true,
      key = "1781144742439535059",
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
    ["1781144742439535060"] = {
      isStoryNode = true,
      key = "1781144742439535060",
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
            startQuest = "1781144742439535066",
            startPort = "Out",
            endQuest = "1781144742439535068",
            endPort = "In"
          },
          {
            startQuest = "1781144742439535063",
            startPort = "QuestStart",
            endQuest = "1781144742439535066",
            endPort = "In"
          },
          {
            startQuest = "1781144742439535063",
            startPort = "QuestStart",
            endQuest = "1781144742439535067",
            endPort = "In"
          },
          {
            startQuest = "1781144742439535067",
            startPort = "Out",
            endQuest = "1781144742439535069",
            endPort = "In"
          },
          {
            startQuest = "1781144742439535061",
            startPort = "Out",
            endQuest = "1781144742439535070",
            endPort = "In"
          },
          {
            startQuest = "1781144742439535070",
            startPort = "Out",
            endQuest = "1781144742439535064",
            endPort = "Success"
          },
          {
            startQuest = "1781144742439535069",
            startPort = "Out",
            endQuest = "178118356201518745230",
            endPort = "In"
          },
          {
            startQuest = "178118356201518745230",
            startPort = "Out",
            endQuest = "1781144742439535061",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742439535061"] = {
            key = "1781144742439535061",
            type = "TalkNode",
            name = "黑龙Boss战后",
            pos = {x = 1771.2631578947369, y = 585.0526315789473},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC016/SQ_Ver0101_SC016",
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
          ["1781144742439535063"] = {
            key = "1781144742439535063",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742439535064"] = {
            key = "1781144742439535064",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2378.505494505494, y = 590.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742439535065"] = {
            key = "1781144742439535065",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742439535066"] = {
            key = "1781144742439535066",
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
          ["1781144742439535067"] = {
            key = "1781144742439535067",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105701,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742439535068"] = {
            key = "1781144742439535068",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 105701,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742439535069"] = {
            key = "1781144742439535069",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "RegionPoint_Alt_01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1781144742439535070"] = {
            key = "1781144742439535070",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2044, y = 596},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178118356201518745230"] = {
            key = "178118356201518745230",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1398, y = 814},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105701}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
