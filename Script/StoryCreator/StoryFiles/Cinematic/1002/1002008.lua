return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211119807523508769",
      startPort = "StoryStart",
      endStory = "178211119856123508796",
      endPort = "In"
    },
    {
      startStory = "178211119856123508796",
      startPort = "Success",
      endStory = "178211119807523508772",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211119807523508769"] = {
      isStoryNode = true,
      key = "178211119807523508769",
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
    ["178211119807523508772"] = {
      isStoryNode = true,
      key = "178211119807523508772",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1808, y = 286},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211119856123508796"] = {
      isStoryNode = true,
      key = "178211119856123508796",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1346, y = 330},
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
            startQuest = "178211119856123508804",
            startPort = "Out",
            endQuest = "178211119856123508806",
            endPort = "In"
          },
          {
            startQuest = "178211119856123508801",
            startPort = "QuestStart",
            endQuest = "178211119856123508804",
            endPort = "In"
          },
          {
            startQuest = "178211119856123508801",
            startPort = "QuestStart",
            endQuest = "178211119856123508805",
            endPort = "In"
          },
          {
            startQuest = "178211119856123508809",
            startPort = "Out",
            endQuest = "178211119856123508802",
            endPort = "Success"
          },
          {
            startQuest = "178211119856123508808",
            startPort = "Out",
            endQuest = "178211123466623509316",
            endPort = "In"
          },
          {
            startQuest = "178211123466623509316",
            startPort = "Out",
            endQuest = "178211119856123508809",
            endPort = "In"
          },
          {
            startQuest = "178211119856123508805",
            startPort = "Out",
            endQuest = "178211119856123508808",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211119856123508801"] = {
            key = "178211119856123508801",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211119856123508802"] = {
            key = "178211119856123508802",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211119856123508803"] = {
            key = "178211119856123508803",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211119856123508804"] = {
            key = "178211119856123508804",
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
          ["178211119856123508805"] = {
            key = "178211119856123508805",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 815.2236293450444, y = 549.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211119856123508806"] = {
            key = "178211119856123508806",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1538.037485664164, y = 295.44930383636984},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 4,
              IsWhite = false
            }
          },
          ["178211119856123508808"] = {
            key = "178211119856123508808",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1500.88506914535, y = 532.4586017473353},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_IceLake3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211119856123508809"] = {
            key = "178211119856123508809",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211123466623509316"] = {
            key = "178211123466623509316",
            type = "TalkNode",
            name = "过场动画 赛琪苏醒",
            pos = {x = 1858.7561214910183, y = 505.61233937687035},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC008/SQ_OBT0101_SC008",
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
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
