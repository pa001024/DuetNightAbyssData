return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150954898018881463",
      startPort = "StoryStart",
      endStory = "178150954972018881492",
      endPort = "In"
    },
    {
      startStory = "178150954972018881492",
      startPort = "Success",
      endStory = "178150954898018881466",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150954898018881463"] = {
      isStoryNode = true,
      key = "178150954898018881463",
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
    ["178150954898018881466"] = {
      isStoryNode = true,
      key = "178150954898018881466",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1748, y = 334},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150954972018881492"] = {
      isStoryNode = true,
      key = "178150954972018881492",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1350, y = 302},
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
            startQuest = "178150954972018881500",
            startPort = "Out",
            endQuest = "178150954972018881502",
            endPort = "In"
          },
          {
            startQuest = "178150954972018881497",
            startPort = "QuestStart",
            endQuest = "178150954972018881500",
            endPort = "In"
          },
          {
            startQuest = "178150954972018881497",
            startPort = "QuestStart",
            endQuest = "178150954972018881501",
            endPort = "In"
          },
          {
            startQuest = "178150954972018881505",
            startPort = "Out",
            endQuest = "178150954972018881498",
            endPort = "Success"
          },
          {
            startQuest = "178150954972018881504",
            startPort = "Out",
            endQuest = "178150954972018881506",
            endPort = "In"
          },
          {
            startQuest = "178150954972018881506",
            startPort = "Out",
            endQuest = "178150957295519930630",
            endPort = "In"
          },
          {
            startQuest = "178150957295519930630",
            startPort = "Out",
            endQuest = "178150954972018881505",
            endPort = "In"
          },
          {
            startQuest = "178150954972018881501",
            startPort = "Out",
            endQuest = "178150954972018881504",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150954972018881497"] = {
            key = "178150954972018881497",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178150954972018881498"] = {
            key = "178150954972018881498",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178150954972018881499"] = {
            key = "178150954972018881499",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150954972018881500"] = {
            key = "178150954972018881500",
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
          ["178150954972018881501"] = {
            key = "178150954972018881501",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 821.199819821235, y = 547.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102103,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["178150954972018881502"] = {
            key = "178150954972018881502",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1307.2650144283061, y = 283.50950450526625},
            propsData = {
              ModeType = 1,
              Id = 102103,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["178150954972018881504"] = {
            key = "178150954972018881504",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 525.1278564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_SewwarmRE",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178150954972018881505"] = {
            key = "178150954972018881505",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2272.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150954972018881506"] = {
            key = "178150954972018881506",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1655.365568750246, y = 539.9848014888337},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178150957295519930630"] = {
            key = "178150957295519930630",
            type = "TalkNode",
            name = "过场-SC014-二人幸终",
            pos = {x = 1938.3763214384182, y = 571.7052315963608},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC014/SQ_OBT0102_SC014",
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
