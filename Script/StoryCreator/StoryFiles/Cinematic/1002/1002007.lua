return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178211148257026720910",
      startPort = "StoryStart",
      endStory = "178211148317126720953",
      endPort = "In"
    },
    {
      startStory = "178211148317126720953",
      startPort = "Success",
      endStory = "178211148257026720913",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178211148257026720910"] = {
      isStoryNode = true,
      key = "178211148257026720910",
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
    ["178211148257026720913"] = {
      isStoryNode = true,
      key = "178211148257026720913",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1934, y = 246},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178211148317126720953"] = {
      isStoryNode = true,
      key = "178211148317126720953",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1431.75, y = 277.25},
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
            startQuest = "178211148317126720961",
            startPort = "Out",
            endQuest = "178211148317126720963",
            endPort = "In"
          },
          {
            startQuest = "178211148317126720958",
            startPort = "QuestStart",
            endQuest = "178211148317126720961",
            endPort = "In"
          },
          {
            startQuest = "178211148317126720958",
            startPort = "QuestStart",
            endQuest = "178211148317126720962",
            endPort = "In"
          },
          {
            startQuest = "178211148317126720966",
            startPort = "Out",
            endQuest = "178211148317126720959",
            endPort = "Success"
          },
          {
            startQuest = "178211148317126720965",
            startPort = "Out",
            endQuest = "178211150676126721571",
            endPort = "In"
          },
          {
            startQuest = "178211150676126721571",
            startPort = "Out",
            endQuest = "178211148317126720966",
            endPort = "In"
          },
          {
            startQuest = "178211148317126720962",
            startPort = "Out",
            endQuest = "178211148317126720965",
            endPort = "In"
          }
        },
        nodeData = {
          ["178211148317126720958"] = {
            key = "178211148317126720958",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["178211148317126720959"] = {
            key = "178211148317126720959",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2497.1428571428564, y = 560.0000000000001},
            propsData = {ModeType = 0}
          },
          ["178211148317126720960"] = {
            key = "178211148317126720960",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178211148317126720961"] = {
            key = "178211148317126720961",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1189.1545350406564, y = 306.5324911890181},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211148317126720962"] = {
            key = "178211148317126720962",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 839.0236293450444, y = 546.8335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101402,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178211148317126720963"] = {
            key = "178211148317126720963",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1528.38161521882, y = 321.9877653748314},
            propsData = {
              ModeType = 1,
              Id = 101402,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178211148317126720965"] = {
            key = "178211148317126720965",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1500.103556540308, y = 534.1728874616209},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "P_StartPoint3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178211148317126720966"] = {
            key = "178211148317126720966",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2207.449229691877, y = 555.7960662525879},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178211150676126721571"] = {
            key = "178211150676126721571",
            type = "TalkNode",
            name = "过场动画 主角救赛琪",
            pos = {x = 1944.197407312178, y = 592.8079322638145},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "Stage_SQ_OBT0101_SC007",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0101/OBT0101_SC007/SQ_OBT0101_SC007",
              BlendInTime = 0,
              InType = "FadeIn",
              OutType = "BlendOut",
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
              bTravelFullLoadWorldComposition = true,
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
