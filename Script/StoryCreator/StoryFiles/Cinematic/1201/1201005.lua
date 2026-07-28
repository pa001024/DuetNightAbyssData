return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781144742434533696",
      startPort = "StoryStart",
      endStory = "1781144742434533698",
      endPort = "In"
    },
    {
      startStory = "1781144742434533698",
      startPort = "Success",
      endStory = "1781144742434533697",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1781144742434533696"] = {
      isStoryNode = true,
      key = "1781144742434533696",
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
    ["1781144742434533697"] = {
      isStoryNode = true,
      key = "1781144742434533697",
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
    ["1781144742434533698"] = {
      isStoryNode = true,
      key = "1781144742434533698",
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
            startQuest = "1781144742434533705",
            startPort = "Out",
            endQuest = "1781144742434533707",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533702",
            startPort = "QuestStart",
            endQuest = "1781144742434533705",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533702",
            startPort = "QuestStart",
            endQuest = "1781144742434533706",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533706",
            startPort = "Out",
            endQuest = "1781144742434533708",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533699",
            startPort = "Out",
            endQuest = "1781144742434533701",
            endPort = "In"
          },
          {
            startQuest = "1781144742434533701",
            startPort = "Out",
            endQuest = "1781144742434533703",
            endPort = "Success"
          },
          {
            startQuest = "1781144742434533708",
            startPort = "Out",
            endQuest = "1781144742434533699",
            endPort = "In"
          }
        },
        nodeData = {
          ["1781144742434533699"] = {
            key = "1781144742434533699",
            type = "TalkNode",
            name = "扶疏登场",
            pos = {x = 1863.7142857142858, y = 568.2857142857143},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0101/Ver0101_SC005/SQ_Ver0101_SC005",
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
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "QuestPoint_Dx",
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
          ["1781144742434533701"] = {
            key = "1781144742434533701",
            type = "PlayOrStopBGMNode",
            name = "BGM - nvshenxiang - start",
            pos = {x = 2156.375939849624, y = 592.6165413533835},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1781144742434533702"] = {
            key = "1781144742434533702",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781144742434533703"] = {
            key = "1781144742434533703",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2408.095238095237, y = 582.6190476190477},
            propsData = {ModeType = 0}
          },
          ["1781144742434533704"] = {
            key = "1781144742434533704",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["1781144742434533705"] = {
            key = "1781144742434533705",
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
          ["1781144742434533706"] = {
            key = "1781144742434533706",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 910.3478529475288, y = 542.6907120531213},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 104109,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1781144742434533707"] = {
            key = "1781144742434533707",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1527.6997970370016, y = 322.6399392878749},
            propsData = {
              ModeType = 1,
              Id = 104109,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1781144742434533708"] = {
            key = "1781144742434533708",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1262.2701623130522, y = 549.7318936728011},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_12010306",
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
