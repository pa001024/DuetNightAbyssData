return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17811699992909228361",
      startPort = "StoryStart",
      endStory = "17811699998649228401",
      endPort = "In"
    },
    {
      startStory = "17811699998649228401",
      startPort = "Success",
      endStory = "17811699992909228364",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17811699992909228361"] = {
      isStoryNode = true,
      key = "17811699992909228361",
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
    ["17811699992909228364"] = {
      isStoryNode = true,
      key = "17811699992909228364",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2022, y = 296},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17811699998649228401"] = {
      isStoryNode = true,
      key = "17811699998649228401",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1252, y = 258},
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
            startQuest = "17811699998649228409",
            startPort = "Out",
            endQuest = "17811699998649228411",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228406",
            startPort = "QuestStart",
            endQuest = "17811699998649228409",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228406",
            startPort = "QuestStart",
            endQuest = "17811699998649228410",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228410",
            startPort = "Out",
            endQuest = "17811699998649228412",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228412",
            startPort = "Out",
            endQuest = "17811699998649228413",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228414",
            startPort = "Out",
            endQuest = "17811699998649228407",
            endPort = "Success"
          },
          {
            startQuest = "17811699998649228413",
            startPort = "Out",
            endQuest = "17811699998649228415",
            endPort = "In"
          },
          {
            startQuest = "17811699998649228415",
            startPort = "Out",
            endQuest = "178117002878910254465",
            endPort = "In"
          },
          {
            startQuest = "178117002878910254465",
            startPort = "Out",
            endQuest = "17811699998649228414",
            endPort = "In"
          }
        },
        nodeData = {
          ["17811699998649228406"] = {
            key = "17811699998649228406",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17811699998649228407"] = {
            key = "17811699998649228407",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17811699998649228408"] = {
            key = "17811699998649228408",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17811699998649228409"] = {
            key = "17811699998649228409",
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
          ["17811699998649228410"] = {
            key = "17811699998649228410",
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
          ["17811699998649228411"] = {
            key = "17811699998649228411",
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
          ["17811699998649228412"] = {
            key = "17811699998649228412",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["17811699998649228413"] = {
            key = "17811699998649228413",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_GetTrainHead",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17811699998649228414"] = {
            key = "17811699998649228414",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["17811699998649228415"] = {
            key = "17811699998649228415",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1654.950291446808, y = 568.7364095127256},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0172_story_counter_attack.0172_story_counter_attack'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178117002878910254465"] = {
            key = "178117002878910254465",
            type = "TalkNode",
            name = "过场-签订契约",
            pos = {x = 1921.4150940988511, y = 598.4506481594176},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC025/SQ_Ver0104_SC025",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = false,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = true,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
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
