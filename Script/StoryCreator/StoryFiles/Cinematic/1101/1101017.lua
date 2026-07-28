return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150970464022030196",
      startPort = "StoryStart",
      endStory = "178150970525822030230",
      endPort = "In"
    },
    {
      startStory = "178150970525822030230",
      startPort = "Success",
      endStory = "178150970464022030199",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150970464022030196"] = {
      isStoryNode = true,
      key = "178150970464022030196",
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
    ["178150970464022030199"] = {
      isStoryNode = true,
      key = "178150970464022030199",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1850, y = 308},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150970525822030230"] = {
      isStoryNode = true,
      key = "178150970525822030230",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1434, y = 332},
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
            startQuest = "178150970525822030238",
            startPort = "Out",
            endQuest = "178150970525822030240",
            endPort = "In"
          },
          {
            startQuest = "178150970525822030235",
            startPort = "QuestStart",
            endQuest = "178150970525822030238",
            endPort = "In"
          },
          {
            startQuest = "178150970525822030235",
            startPort = "QuestStart",
            endQuest = "178150970525822030239",
            endPort = "In"
          },
          {
            startQuest = "178150970525822030243",
            startPort = "Out",
            endQuest = "178150970525822030236",
            endPort = "Success"
          },
          {
            startQuest = "178150973542822030728",
            startPort = "Out",
            endQuest = "178150970525822030243",
            endPort = "In"
          },
          {
            startQuest = "178150970525822030242",
            startPort = "Out",
            endQuest = "178150973542822030728",
            endPort = "In"
          },
          {
            startQuest = "178150970525822030239",
            startPort = "Out",
            endQuest = "178150970525822030242",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150970525822030235"] = {
            key = "178150970525822030235",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178150970525822030236"] = {
            key = "178150970525822030236",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178150970525822030237"] = {
            key = "178150970525822030237",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150970525822030238"] = {
            key = "178150970525822030238",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 903.7709033271017, y = 272.1800150206852},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178150970525822030239"] = {
            key = "178150970525822030239",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 546.2990864373577},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178150970525822030240"] = {
            key = "178150970525822030240",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1313.4719109800303, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178150970525822030242"] = {
            key = "178150970525822030242",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1370.8801430369758, y = 535.4726839919272},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_JailFin",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178150970525822030243"] = {
            key = "178150970525822030243",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150973542822030728"] = {
            key = "178150973542822030728",
            type = "TalkNode",
            name = "过场 - SC017 - 维吉尔进场",
            pos = {x = 1869.7468892580227, y = 609.9927931727156},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC017/SQ_OBT0102_SC017",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
