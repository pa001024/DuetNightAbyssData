return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17815069172329444824",
      startPort = "StoryStart",
      endStory = "17815069179889444850",
      endPort = "In"
    },
    {
      startStory = "17815069179889444850",
      startPort = "Success",
      endStory = "17815069172339444827",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17815069172329444824"] = {
      isStoryNode = true,
      key = "17815069172329444824",
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
    ["17815069172339444827"] = {
      isStoryNode = true,
      key = "17815069172339444827",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1862, y = 292},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17815069179889444850"] = {
      isStoryNode = true,
      key = "17815069179889444850",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1410, y = 322},
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
            startQuest = "17815069179889444858",
            startPort = "Out",
            endQuest = "17815069179889444860",
            endPort = "In"
          },
          {
            startQuest = "17815069179889444855",
            startPort = "QuestStart",
            endQuest = "17815069179889444858",
            endPort = "In"
          },
          {
            startQuest = "17815069179889444855",
            startPort = "QuestStart",
            endQuest = "17815069179889444859",
            endPort = "In"
          },
          {
            startQuest = "17815069179889444863",
            startPort = "Out",
            endQuest = "17815069179889444856",
            endPort = "Success"
          },
          {
            startQuest = "17815069179889444862",
            startPort = "Out",
            endQuest = "1782115111723593",
            endPort = "In"
          },
          {
            startQuest = "1782115111723593",
            startPort = "Out",
            endQuest = "17815069179889444863",
            endPort = "In"
          },
          {
            startQuest = "17815069179889444859",
            startPort = "Out",
            endQuest = "17815069179889444862",
            endPort = "In"
          }
        },
        nodeData = {
          ["17815069179889444855"] = {
            key = "17815069179889444855",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["17815069179889444856"] = {
            key = "17815069179889444856",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["17815069179889444857"] = {
            key = "17815069179889444857",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["17815069179889444858"] = {
            key = "17815069179889444858",
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
          ["17815069179889444859"] = {
            key = "17815069179889444859",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 965.199819821235, y = 531.3335691959784},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 102102,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17815069179889444860"] = {
            key = "17815069179889444860",
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
          ["17815069179889444862"] = {
            key = "17815069179889444862",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 525.1278564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_TaoLiSTART",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17815069179889444863"] = {
            key = "17815069179889444863",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["1782115111723593"] = {
            key = "1782115111723593",
            type = "TalkNode",
            name = "过场-SC011-遇见达芙涅",
            pos = {x = 1781.4757228997323, y = 513.9805491990846},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC011/SQ_OBT0102_SC011",
              BlendInTime = 2,
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
