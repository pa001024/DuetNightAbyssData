return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742439534903",
      startPort = "StoryStart",
      endStory = "1781144742439534905",
      endPort = "In"
    },
    {
      startStory = "1781144742439534905",
      startPort = "Success",
      endStory = "1781144742439534904",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742439534903"] = {
      isStoryNode = true,
      key = "1781144742439534903",
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
    ["1781144742439534904"] = {
      isStoryNode = true,
      key = "1781144742439534904",
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
    ["1781144742439534905"] = {
      isStoryNode = true,
      key = "1781144742439534905",
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
            startQuest = "1781144742439534912",
            startPort = "Out",
            endQuest = "1781144742439534914",
            endPort = "In"
          },
          {
            startQuest = "1781144742439534909",
            startPort = "QuestStart",
            endQuest = "1781144742439534912",
            endPort = "In"
          },
          {
            startQuest = "1781144742439534909",
            startPort = "QuestStart",
            endQuest = "1781144742439534913",
            endPort = "In"
          },
          {
            startQuest = "1781144742439534913",
            startPort = "Out",
            endQuest = "1781144742439534915",
            endPort = "In"
          },
          {
            startQuest = "1781144742439534908",
            startPort = "Out",
            endQuest = "1781144742439534910",
            endPort = "Success"
          },
          {
            startQuest = "1781144742439534906",
            startPort = "Out",
            endQuest = "1781144742439534908",
            endPort = "In"
          },
          {
            startQuest = "1781144742439534915",
            startPort = "Out",
            endQuest = "178118350865817704041",
            endPort = "In"
          },
          {
            startQuest = "178118350865817704041",
            startPort = "Out",
            endQuest = "1781144742439534906",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742439534906"] = {
            key = "1781144742439534906",
            type = "TalkNode",
            name = "黑龙祭坛跑酷",
            pos = {x = 1858.7272727272727, y = 571.2727272727273},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC013/SQ_Ver0101_SC013",
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
          ["1781144742439534908"] = {
            key = "1781144742439534908",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 2156.375939849624, y = 592.6165413533835},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742439534909"] = {
            key = "1781144742439534909",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742439534910"] = {
            key = "1781144742439534910",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["1781144742439534911"] = {
            key = "1781144742439534911",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742439534912"] = {
            key = "1781144742439534912",
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
          ["1781144742439534913"] = {
            key = "1781144742439534913",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 105701,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742439534914"] = {
            key = "1781144742439534914",
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
          ["1781144742439534915"] = {
            key = "1781144742439534915",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
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
          ["178118350865817704041"] = {
            key = "178118350865817704041",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1534, y = 712.25},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0130_cs_heilongjitan_parkour",
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
