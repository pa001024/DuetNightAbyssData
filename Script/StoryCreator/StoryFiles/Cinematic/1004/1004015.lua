return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116608923915272602",
      startPort = "StoryStart",
      endStory = "178116608993315272622",
      endPort = "In"
    },
    {
      startStory = "178116608993315272622",
      startPort = "Success",
      endStory = "178116608924015272605",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116608923915272602"] = {
      isStoryNode = true,
      key = "178116608923915272602",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 896, y = 244},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116608924015272605"] = {
      isStoryNode = true,
      key = "178116608924015272605",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1920, y = 264},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116608993315272622"] = {
      isStoryNode = true,
      key = "178116608993315272622",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1392, y = 246},
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
            startQuest = "178116608993315272630",
            startPort = "Out",
            endQuest = "178116608993315272632",
            endPort = "In"
          },
          {
            startQuest = "178116608993315272627",
            startPort = "QuestStart",
            endQuest = "178116608993315272630",
            endPort = "In"
          },
          {
            startQuest = "178116608993315272627",
            startPort = "QuestStart",
            endQuest = "178116608993315272631",
            endPort = "In"
          },
          {
            startQuest = "178116608993315272631",
            startPort = "Out",
            endQuest = "178116608993415272633",
            endPort = "In"
          },
          {
            startQuest = "178116608993415272633",
            startPort = "Out",
            endQuest = "178116608993415272634",
            endPort = "In"
          },
          {
            startQuest = "178116608993415272635",
            startPort = "Out",
            endQuest = "178116608993315272628",
            endPort = "Success"
          },
          {
            startQuest = "178116608993415272634",
            startPort = "Out",
            endQuest = "178116608993415272636",
            endPort = "In"
          },
          {
            startQuest = "178116608993415272636",
            startPort = "Out",
            endQuest = "178116620498016291643",
            endPort = "In"
          },
          {
            startQuest = "178116620498016291643",
            startPort = "Out",
            endQuest = "178116608993415272635",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116608993315272627"] = {
            key = "178116608993315272627",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116608993315272628"] = {
            key = "178116608993315272628",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116608993315272629"] = {
            key = "178116608993315272629",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116608993315272630"] = {
            key = "178116608993315272630",
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
          ["178116608993315272631"] = {
            key = "178116608993315272631",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 106101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178116608993315272632"] = {
            key = "178116608993315272632",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178116608993415272633"] = {
            key = "178116608993415272633",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116608993415272634"] = {
            key = "178116608993415272634",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZhujueBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116608993415272635"] = {
            key = "178116608993415272635",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2474.0206582633054, y = 545.5103519668737},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116608993415272636"] = {
            key = "178116608993415272636",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1654.211022766363, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0170_story_fuluo_play_piano.0170_story_fuluo_play_piano'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116620498016291643"] = {
            key = "178116620498016291643",
            type = "TalkNode",
            name = "过场-芙罗拉弹钢琴",
            pos = {x = 1955.4982325469555, y = 585.6601222510659},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC015/SQ_Ver0104_SC015",
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
              HideMechanismsFX = false,
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
