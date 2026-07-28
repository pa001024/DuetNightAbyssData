return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178125553241026861805",
      startPort = "StoryStart",
      endStory = "178125553315226861837",
      endPort = "In"
    },
    {
      startStory = "178125553315226861837",
      startPort = "Success",
      endStory = "178125553241026861808",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178125553241026861805"] = {
      isStoryNode = true,
      key = "178125553241026861805",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1090, y = 246},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125553241026861808"] = {
      isStoryNode = true,
      key = "178125553241026861808",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1750, y = 252},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125553315226861837"] = {
      isStoryNode = true,
      key = "178125553315226861837",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1416, y = 220},
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
            startQuest = "178125553315226861845",
            startPort = "Out",
            endQuest = "178125553315226861847",
            endPort = "In"
          },
          {
            startQuest = "178125553315226861842",
            startPort = "QuestStart",
            endQuest = "178125553315226861845",
            endPort = "In"
          },
          {
            startQuest = "178125553315226861842",
            startPort = "QuestStart",
            endQuest = "178125553315226861846",
            endPort = "In"
          },
          {
            startQuest = "178125553315226861850",
            startPort = "Out",
            endQuest = "178125553315226861843",
            endPort = "Success"
          },
          {
            startQuest = "178125556108926862251",
            startPort = "Out",
            endQuest = "178125553315226861850",
            endPort = "In"
          },
          {
            startQuest = "178125553315226861849",
            startPort = "Out",
            endQuest = "178125557571726862538",
            endPort = "In"
          },
          {
            startQuest = "178125557571726862538",
            startPort = "Out",
            endQuest = "178125556108926862251",
            endPort = "In"
          },
          {
            startQuest = "178125553315226861846",
            startPort = "Out",
            endQuest = "178125553315226861849",
            endPort = "In"
          }
        },
        nodeData = {
          ["178125553315226861842"] = {
            key = "178125553315226861842",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178125553315226861843"] = {
            key = "178125553315226861843",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178125553315226861844"] = {
            key = "178125553315226861844",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178125553315226861845"] = {
            key = "178125553315226861845",
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
          ["178125553315226861846"] = {
            key = "178125553315226861846",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178125553315226861847"] = {
            key = "178125553315226861847",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178125553315226861849"] = {
            key = "178125553315226861849",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NewTargetPoint23",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178125553315226861850"] = {
            key = "178125553315226861850",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178125556108926862251"] = {
            key = "178125556108926862251",
            type = "TalkNode",
            name = "过场-SC006-卡嘉刺杀",
            pos = {x = 2020.9408730273472, y = 552.6031617019148},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC006/SQ_OBT0102_SC006",
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
          ["178125557571726862538"] = {
            key = "178125557571726862538",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1689.661408788431, y = 528.5359727848808},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {102102}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
