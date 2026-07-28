return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742454538195",
      startPort = "StoryStart",
      endStory = "1781144742454538197",
      endPort = "In"
    },
    {
      startStory = "1781144742454538197",
      startPort = "Success",
      endStory = "1781144742454538196",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742454538195"] = {
      isStoryNode = true,
      key = "1781144742454538195",
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
    ["1781144742454538196"] = {
      isStoryNode = true,
      key = "1781144742454538196",
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
    ["1781144742454538197"] = {
      isStoryNode = true,
      key = "1781144742454538197",
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
            startQuest = "1781144742454538203",
            startPort = "Out",
            endQuest = "1781144742454538205",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538200",
            startPort = "QuestStart",
            endQuest = "1781144742454538203",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538200",
            startPort = "QuestStart",
            endQuest = "1781144742454538204",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538204",
            startPort = "Out",
            endQuest = "1781144742454538206",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538198",
            startPort = "Out",
            endQuest = "1781144742454538199",
            endPort = "In"
          },
          {
            startQuest = "1781144742454538199",
            startPort = "Out",
            endQuest = "1781144742454538201",
            endPort = "Success"
          },
          {
            startQuest = "1781144742454538206",
            startPort = "Out",
            endQuest = "178116749271635986241",
            endPort = "In"
          },
          {
            startQuest = "178116749271635986241",
            startPort = "Out",
            endQuest = "1781144742454538198",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742454538198"] = {
            key = "1781144742454538198",
            type = "TalkNode",
            name = "VS双龙（中）奋起吧！民众们！",
            pos = {x = 1766.7826086956522, y = 565.4782608695652},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC017/Ver0102_SC017",
              InType = "BlendIn",
              OutType = "BlendOut",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["1781144742454538199"] = {
            key = "1781144742454538199",
            type = "PlayOrStopBGMNode",
            name = "bgm - xibi_p1  - end",
            pos = {x = 1760.985294117647, y = 783.0759803921569},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742454538200"] = {
            key = "1781144742454538200",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742454538201"] = {
            key = "1781144742454538201",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2126.505494505494, y = 561.835164835165},
            propsData = {ModeType = 0}
          },
          ["1781144742454538202"] = {
            key = "1781144742454538202",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742454538203"] = {
            key = "1781144742454538203",
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
          ["1781144742454538204"] = {
            key = "1781144742454538204",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 814.5093436307587, y = 548.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104503,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742454538205"] = {
            key = "1781144742454538205",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104503,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742454538206"] = {
            key = "1781144742454538206",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1122.242212002493, y = 548.8778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020602",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116749271635986241"] = {
            key = "178116749271635986241",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1413.5, y = 560.5000000000001},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_3/0148_theme_song_hyb_story_cut2.0148_theme_song_hyb_story_cut2'",
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
