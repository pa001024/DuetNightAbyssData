return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178116637012220367288",
      startPort = "StoryStart",
      endStory = "178116637087020367326",
      endPort = "In"
    },
    {
      startStory = "178116637087020367326",
      startPort = "Success",
      endStory = "178116637012220367291",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178116637012220367288"] = {
      isStoryNode = true,
      key = "178116637012220367288",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1030, y = 242},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116637012220367291"] = {
      isStoryNode = true,
      key = "178116637012220367291",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2110, y = 296},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178116637087020367326"] = {
      isStoryNode = true,
      key = "178116637087020367326",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1504, y = 256},
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
            startQuest = "178116637087020367334",
            startPort = "Out",
            endQuest = "178116637087020367336",
            endPort = "In"
          },
          {
            startQuest = "178116637087020367331",
            startPort = "QuestStart",
            endQuest = "178116637087020367334",
            endPort = "In"
          },
          {
            startQuest = "178116637087020367331",
            startPort = "QuestStart",
            endQuest = "178116637087020367335",
            endPort = "In"
          },
          {
            startQuest = "178116637087020367335",
            startPort = "Out",
            endQuest = "178116637087420367337",
            endPort = "In"
          },
          {
            startQuest = "178116637087420367337",
            startPort = "Out",
            endQuest = "178116637087420367338",
            endPort = "In"
          },
          {
            startQuest = "178116637087420367339",
            startPort = "Out",
            endQuest = "178116637087020367332",
            endPort = "Success"
          },
          {
            startQuest = "178116637087420367338",
            startPort = "Out",
            endQuest = "178116637087420367340",
            endPort = "In"
          },
          {
            startQuest = "178116637087420367340",
            startPort = "Out",
            endQuest = "178116640309321386391",
            endPort = "In"
          },
          {
            startQuest = "178116640309321386391",
            startPort = "Out",
            endQuest = "178116637087420367339",
            endPort = "In"
          }
        },
        nodeData = {
          ["178116637087020367331"] = {
            key = "178116637087020367331",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178116637087020367332"] = {
            key = "178116637087020367332",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178116637087020367333"] = {
            key = "178116637087020367333",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178116637087020367334"] = {
            key = "178116637087020367334",
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
          ["178116637087020367335"] = {
            key = "178116637087020367335",
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
          ["178116637087020367336"] = {
            key = "178116637087020367336",
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
          ["178116637087420367337"] = {
            key = "178116637087420367337",
            type = "ChangeRoleNode",
            name = "切换角色-女主",
            pos = {x = 1086.102649719395, y = 537.806427834292},
            propsData = {QuestRoleId = 1010101, IsPlayFX = false}
          },
          ["178116637087420367338"] = {
            key = "178116637087420367338",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_GuizuBack",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178116637087420367339"] = {
            key = "178116637087420367339",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2232.7163104372185, y = 567.684265010352},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 1
            }
          },
          ["178116637087420367340"] = {
            key = "178116637087420367340",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1653.3286698251864, y = 569.5472203235364},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 3,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt02/0062_story_kajia_jazz.0062_story_kajia_jazz'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {}
            }
          },
          ["178116640309321386391"] = {
            key = "178116640309321386391",
            type = "TalkNode",
            name = "过场-主角制服卡嘉",
            pos = {x = 1908.7300959909655, y = 440.78571428571433},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC016/SQ_Ver0104_SC016",
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
