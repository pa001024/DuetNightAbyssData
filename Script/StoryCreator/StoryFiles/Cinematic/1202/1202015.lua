return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742453537900",
      startPort = "StoryStart",
      endStory = "1781144742453537902",
      endPort = "In"
    },
    {
      startStory = "1781144742453537902",
      startPort = "Success",
      endStory = "1781144742453537901",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742453537900"] = {
      isStoryNode = true,
      key = "1781144742453537900",
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
    ["1781144742453537901"] = {
      isStoryNode = true,
      key = "1781144742453537901",
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
    ["1781144742453537902"] = {
      isStoryNode = true,
      key = "1781144742453537902",
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
            startQuest = "1781144742453537908",
            startPort = "Out",
            endQuest = "1781144742453537910",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537905",
            startPort = "QuestStart",
            endQuest = "1781144742453537908",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537905",
            startPort = "QuestStart",
            endQuest = "1781144742453537909",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537909",
            startPort = "Out",
            endQuest = "1781144742453537911",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537911",
            startPort = "Out",
            endQuest = "1781144742453537904",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537904",
            startPort = "Out",
            endQuest = "1781144742453537903",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537903",
            startPort = "Out",
            endQuest = "1781144742453537912",
            endPort = "In"
          },
          {
            startQuest = "1781144742453537912",
            startPort = "Out",
            endQuest = "1781144742453537906",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781144742453537903"] = {
            key = "1781144742453537903",
            type = "TalkNode",
            name = "和鸣之力！主角闪亮登场！音乐",
            pos = {x = 1771.2631578947369, y = 585.0526315789473},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC015/SQ_Ver0102_SC015",
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
          ["1781144742453537904"] = {
            key = "1781144742453537904",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 1501.212637207993, y = 577.0778014555104},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0148_theme_song_hyb_story_cut1.0148_theme_song_hyb_story_cut1'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742453537905"] = {
            key = "1781144742453537905",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742453537906"] = {
            key = "1781144742453537906",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2378.505494505494, y = 590.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742453537907"] = {
            key = "1781144742453537907",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742453537908"] = {
            key = "1781144742453537908",
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
          ["1781144742453537909"] = {
            key = "1781144742453537909",
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
          ["1781144742453537910"] = {
            key = "1781144742453537910",
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
          ["1781144742453537911"] = {
            key = "1781144742453537911",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1209.242212002493, y = 547.3778564057203},
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
          ["1781144742453537912"] = {
            key = "1781144742453537912",
            type = "PlayOrStopBGMNode",
            name = "BGM - shendianyiji - Stop(MUTE)",
            pos = {x = 2044, y = 596},
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
