return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742452537590",
      startPort = "StoryStart",
      endStory = "1781144742452537592",
      endPort = "In"
    },
    {
      startStory = "1781144742452537592",
      startPort = "Success",
      endStory = "1781144742452537591",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742452537590"] = {
      isStoryNode = true,
      key = "1781144742452537590",
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
    ["1781144742452537591"] = {
      isStoryNode = true,
      key = "1781144742452537591",
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
    ["1781144742452537592"] = {
      isStoryNode = true,
      key = "1781144742452537592",
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
            startQuest = "1781144742452537599",
            startPort = "Out",
            endQuest = "1781144742452537601",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537596",
            startPort = "QuestStart",
            endQuest = "1781144742452537599",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537596",
            startPort = "QuestStart",
            endQuest = "1781144742452537600",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537600",
            startPort = "Out",
            endQuest = "1781144742452537602",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537602",
            startPort = "Out",
            endQuest = "1781144742452537594",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537595",
            startPort = "Out",
            endQuest = "1781144742452537597",
            endPort = "Success"
          },
          {
            startQuest = "1781144742452537594",
            startPort = "Out",
            endQuest = "1781144742452537593",
            endPort = "In"
          },
          {
            startQuest = "1781144742452537593",
            startPort = "Out",
            endQuest = "1781144742452537595",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742452537593"] = {
            key = "1781144742452537593",
            type = "TalkNode",
            name = "苏乙救场",
            pos = {x = 1858.7272727272727, y = 571.2727272727273},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC013/SQ_Ver0102_SC013",
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
          ["1781144742452537594"] = {
            key = "1781144742452537594",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 1552.0902255639098, y = 571.187969924812},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_1/0107_story_zhuyinzhizai_full.0107_story_zhuyinzhizai_full'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1781144742452537595"] = {
            key = "1781144742452537595",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 2156.375939849624, y = 592.6165413533835},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742452537596"] = {
            key = "1781144742452537596",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742452537597"] = {
            key = "1781144742452537597",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["1781144742452537598"] = {
            key = "1781144742452537598",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742452537599"] = {
            key = "1781144742452537599",
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
          ["1781144742452537600"] = {
            key = "1781144742452537600",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104501,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742452537601"] = {
            key = "1781144742452537601",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104501,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742452537602"] = {
            key = "1781144742452537602",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "12020602",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
