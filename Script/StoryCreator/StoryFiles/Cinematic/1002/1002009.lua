return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211126753224579031",
      startPort = "StoryStart",
      endStory = "178211126789024579052",
      endPort = "In"
    },
    {
      startStory = "178211126789024579052",
      startPort = "Success",
      endStory = "178211126753224579034",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211126753224579031"] = {
      isStoryNode = true,
      key = "178211126753224579031",
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
    ["178211126753224579034"] = {
      isStoryNode = true,
      key = "178211126753224579034",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211126789024579052"] = {
      isStoryNode = true,
      key = "178211126789024579052",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1546, y = 446},
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
            startQuest = "178211126789024579060",
            startPort = "Out",
            endQuest = "178211126789024579062",
            endPort = "In"
          },
          {
            startQuest = "178211126789024579057",
            startPort = "QuestStart",
            endQuest = "178211126789024579060",
            endPort = "In"
          },
          {
            startQuest = "178211126789024579057",
            startPort = "QuestStart",
            endQuest = "178211126789024579061",
            endPort = "In"
          },
          {
            startQuest = "178211126789024579065",
            startPort = "Out",
            endQuest = "178211126789024579058",
            endPort = "Success"
          },
          {
            startQuest = "178211126789024579064",
            startPort = "Out",
            endQuest = "178211127829124579419",
            endPort = "In"
          },
          {
            startQuest = "178211127829124579419",
            startPort = "Out",
            endQuest = "178211126789024579065",
            endPort = "In"
          },
          {
            startQuest = "178211126789024579061",
            startPort = "Out",
            endQuest = "178211126789024579064",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211126789024579057"] = {
            key = "178211126789024579057",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211126789024579058"] = {
            key = "178211126789024579058",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211126789024579059"] = {
            key = "178211126789024579059",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211126789024579060"] = {
            key = "178211126789024579060",
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
          ["178211126789024579061"] = {
            key = "178211126789024579061",
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
          ["178211126789024579062"] = {
            key = "178211126789024579062",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1538.037485664164, y = 295.44930383636984},
            propsData = {
              ModeType = 1,
              Id = 101103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211126789024579064"] = {
            key = "178211126789024579064",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1502.5993548596357, y = 487.8871731759067},
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
          ["178211126789024579065"] = {
            key = "178211126789024579065",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211127829124579419"] = {
            key = "178211127829124579419",
            type = "TalkNode",
            name = "过场动画 击杀赛琪",
            pos = {x = 1825.3275500624472, y = 487.6123393768703},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC009/SQ_OBT0101_SC009",
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
              FreezeWorldComposition = false,
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
