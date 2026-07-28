return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178125533105425819010",
      startPort = "StoryStart",
      endStory = "178125533181025819033",
      endPort = "In"
    },
    {
      startStory = "178125533181025819033",
      startPort = "Success",
      endStory = "178125533105425819013",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178125533105425819010"] = {
      isStoryNode = true,
      key = "178125533105425819010",
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
    ["178125533105425819013"] = {
      isStoryNode = true,
      key = "178125533105425819013",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1660, y = 268},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125533181025819033"] = {
      isStoryNode = true,
      key = "178125533181025819033",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1136, y = 232},
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
            startQuest = "178125533181125819041",
            startPort = "Out",
            endQuest = "178125533181125819043",
            endPort = "In"
          },
          {
            startQuest = "178125533181125819038",
            startPort = "QuestStart",
            endQuest = "178125533181125819041",
            endPort = "In"
          },
          {
            startQuest = "178125533181125819038",
            startPort = "QuestStart",
            endQuest = "178125533181125819042",
            endPort = "In"
          },
          {
            startQuest = "178125533181125819046",
            startPort = "Out",
            endQuest = "178125533181125819039",
            endPort = "Success"
          },
          {
            startQuest = "178125533181125819045",
            startPort = "Out",
            endQuest = "178125540442825819405",
            endPort = "In"
          },
          {
            startQuest = "178125540442825819405",
            startPort = "Out",
            endQuest = "178125533181125819046",
            endPort = "In"
          },
          {
            startQuest = "178125533181125819042",
            startPort = "Out",
            endQuest = "178125533181125819045",
            endPort = "In"
          }
        },
        nodeData = {
          ["178125533181125819038"] = {
            key = "178125533181125819038",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178125533181125819039"] = {
            key = "178125533181125819039",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178125533181125819040"] = {
            key = "178125533181125819040",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178125533181125819041"] = {
            key = "178125533181125819041",
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
          ["178125533181125819042"] = {
            key = "178125533181125819042",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178125533181125819043"] = {
            key = "178125533181125819043",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178125533181125819045"] = {
            key = "178125533181125819045",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NengyuanTarget4",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178125533181125819046"] = {
            key = "178125533181125819046",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178125540442825819405"] = {
            key = "178125540442825819405",
            type = "TalkNode",
            name = "过场-SC005-爆炸逃生",
            pos = {x = 1736.1307742132065, y = 585.0754631768582},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC005/SQ_OBT0102_SC005",
              BlendInTime = 1,
              BlendOutTime = 1,
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
