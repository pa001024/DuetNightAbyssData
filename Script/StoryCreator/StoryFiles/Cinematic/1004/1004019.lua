return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116648968822405343",
      startPort = "StoryStart",
      endStory = "178116649052422405378",
      endPort = "In"
    },
    {
      startStory = "178116649052422405378",
      startPort = "Success",
      endStory = "178116648968822405346",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116648968822405343"] = {
      isStoryNode = true,
      key = "178116648968822405343",
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
    ["178116648968822405346"] = {
      isStoryNode = true,
      key = "178116648968822405346",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1628, y = 260},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116649052422405378"] = {
      isStoryNode = true,
      key = "178116649052422405378",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1218, y = 238},
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
            startQuest = "178116649052522405386",
            startPort = "Out",
            endQuest = "178116649052522405388",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405383",
            startPort = "QuestStart",
            endQuest = "178116649052522405386",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405383",
            startPort = "QuestStart",
            endQuest = "178116649052522405387",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405387",
            startPort = "Out",
            endQuest = "178116649052522405389",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405389",
            startPort = "Out",
            endQuest = "178116649052522405390",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405391",
            startPort = "Out",
            endQuest = "178116649052522405384",
            endPort = "Success"
          },
          {
            startQuest = "178116649052522405390",
            startPort = "Out",
            endQuest = "178116649052522405392",
            endPort = "In"
          },
          {
            startQuest = "178116649052522405392",
            startPort = "Out",
            endQuest = "178116665287123424723",
            endPort = "In"
          },
          {
            startQuest = "178116665287123424723",
            startPort = "Out",
            endQuest = "178116649052522405391",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116649052522405383"] = {
            key = "178116649052522405383",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116649052522405384"] = {
            key = "178116649052522405384",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116649052522405385"] = {
            key = "178116649052522405385",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116649052522405386"] = {
            key = "178116649052522405386",
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
          ["178116649052522405387"] = {
            key = "178116649052522405387",
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
          ["178116649052522405388"] = {
            key = "178116649052522405388",
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
          ["178116649052522405389"] = {
            key = "178116649052522405389",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116649052522405390"] = {
            key = "178116649052522405390",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.8067281315252, y = 526.3778564057203},
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
          ["178116649052522405391"] = {
            key = "178116649052522405391",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116649052522405392"] = {
            key = "178116649052522405392",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
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
          ["178116665287123424723"] = {
            key = "178116665287123424723",
            type = "TalkNode",
            name = "过场-飞艇坠落",
            pos = {x = 1955.710900755782, y = 541.846513467832},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC019/SQ_Ver0104_SC019",
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
