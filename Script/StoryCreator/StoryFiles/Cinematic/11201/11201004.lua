return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1782115119554560157",
      startPort = "StoryStart",
      endStory = "1782115119554560159",
      endPort = "In"
    },
    {
      startStory = "1782115119554560159",
      startPort = "Success",
      endStory = "1782115119554560158",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1782115119554560157"] = {
      isStoryNode = true,
      key = "1782115119554560157",
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
    ["1782115119554560158"] = {
      isStoryNode = true,
      key = "1782115119554560158",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2354, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782115119554560159"] = {
      isStoryNode = true,
      key = "1782115119554560159",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1596, y = 298},
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
            startQuest = "1782115119554560163",
            startPort = "Out",
            endQuest = "1782115119554560165",
            endPort = "In"
          },
          {
            startQuest = "1782115119554560160",
            startPort = "QuestStart",
            endQuest = "1782115119554560163",
            endPort = "In"
          },
          {
            startQuest = "1782115119554560167",
            startPort = "Out",
            endQuest = "1782115119554560161",
            endPort = "Success"
          },
          {
            startQuest = "1782115119554560160",
            startPort = "QuestStart",
            endQuest = "1782115119554560164",
            endPort = "In"
          },
          {
            startQuest = "1782115119554560164",
            startPort = "Out",
            endQuest = "1782115119554560166",
            endPort = "In"
          },
          {
            startQuest = "1782115063506587",
            startPort = "Out",
            endQuest = "1782115119554560167",
            endPort = "In"
          },
          {
            startQuest = "1782115119554560166",
            startPort = "Out",
            endQuest = "1782115085426839",
            endPort = "In"
          },
          {
            startQuest = "1782115085426839",
            startPort = "Out",
            endQuest = "1782115063506587",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782115063506587"] = {
            key = "1782115063506587",
            type = "TalkNode",
            name = "SC04【过场】战斗召唤",
            pos = {x = 2065.636363636364, y = 531.4545454545455},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Activity/Activity_Feina/Activity_Feina_SC004/SQ_Activity_Feina_SC004",
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
          ["1782115085426839"] = {
            key = "1782115085426839",
            type = "PlayOrStopBGMNode",
            name = "BGM-Play",
            pos = {x = 1780.1447368421054, y = 533.5885167464115},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "event:/bgm/1_0/0092_feina_activity_cs_02",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["1782115119554560160"] = {
            key = "1782115119554560160",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1782115119554560161"] = {
            key = "1782115119554560161",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2717.894736842105, y = 543.1578947368422},
            propsData = {ModeType = 0}
          },
          ["1782115119554560162"] = {
            key = "1782115119554560162",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2752.6315789473683, y = 816.8421052631579},
            propsData = {}
          },
          ["1782115119554560163"] = {
            key = "1782115119554560163",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1102.7046601440443, y = 310.83896750624024},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1782115119554560164"] = {
            key = "1782115119554560164",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1162.8984780220724, y = 533.7144896449201},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1782115119554560165"] = {
            key = "1782115119554560165",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1678.7205103756837, y = 315.994543947343},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1782115119554560166"] = {
            key = "1782115119554560166",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1517.762925341175, y = 519.7324610651884},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Mechanism_QuestTrigger_1240949",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1782115119554560167"] = {
            key = "1782115119554560167",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2358.469943030559, y = 549.1506709120561},
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
