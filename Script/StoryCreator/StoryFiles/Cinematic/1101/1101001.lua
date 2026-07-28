return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178125420033017484026",
      startPort = "StoryStart",
      endStory = "178125420165517484059",
      endPort = "In"
    },
    {
      startStory = "178125420165517484059",
      startPort = "Success",
      endStory = "178125420033017484029",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178125420033017484026"] = {
      isStoryNode = true,
      key = "178125420033017484026",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 812, y = 208},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125420033017484029"] = {
      isStoryNode = true,
      key = "178125420033017484029",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1598, y = 246},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125420165517484059"] = {
      isStoryNode = true,
      key = "178125420165517484059",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1170, y = 216},
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
            startQuest = "178125420165517484067",
            startPort = "Out",
            endQuest = "178125420165617484069",
            endPort = "In"
          },
          {
            startQuest = "178125420165517484064",
            startPort = "QuestStart",
            endQuest = "178125420165517484067",
            endPort = "In"
          },
          {
            startQuest = "178125420165517484064",
            startPort = "QuestStart",
            endQuest = "178125420165617484068",
            endPort = "In"
          },
          {
            startQuest = "178125420165617484072",
            startPort = "Out",
            endQuest = "178125420165517484065",
            endPort = "Success"
          },
          {
            startQuest = "178125426162018525490",
            startPort = "Out",
            endQuest = "178125420165617484072",
            endPort = "In"
          },
          {
            startQuest = "178125420165617484071",
            startPort = "Out",
            endQuest = "178125426162018525490",
            endPort = "In"
          },
          {
            startQuest = "178125420165617484068",
            startPort = "Out",
            endQuest = "178125420165617484071",
            endPort = "In"
          }
        },
        nodeData = {
          ["178125420165517484064"] = {
            key = "178125420165517484064",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178125420165517484065"] = {
            key = "178125420165517484065",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178125420165517484066"] = {
            key = "178125420165517484066",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178125420165517484067"] = {
            key = "178125420165517484067",
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
          ["178125420165617484068"] = {
            key = "178125420165617484068",
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
          ["178125420165617484069"] = {
            key = "178125420165617484069",
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
          ["178125420165617484071"] = {
            key = "178125420165617484071",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "EX01_FixSimple_02_1",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178125420165617484072"] = {
            key = "178125420165617484072",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2301.5206582633054, y = 554.2246376811594},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178125426162018525490"] = {
            key = "178125426162018525490",
            type = "TalkNode",
            name = "过场-SC001-秽兽战斗",
            pos = {x = 1730.6146889769454, y = 543.6512065724149},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC001/SQ_OBT0102_SC001",
              BlendInTime = 0,
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
