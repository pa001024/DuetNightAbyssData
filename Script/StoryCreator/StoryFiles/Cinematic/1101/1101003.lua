return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178125495446122692160",
      startPort = "StoryStart",
      endStory = "178125495574522692187",
      endPort = "In"
    },
    {
      startStory = "178125495574522692187",
      startPort = "Success",
      endStory = "178125495446122692163",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178125495446122692160"] = {
      isStoryNode = true,
      key = "178125495446122692160",
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
    ["178125495446122692163"] = {
      isStoryNode = true,
      key = "178125495446122692163",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178125495574522692187"] = {
      isStoryNode = true,
      key = "178125495574522692187",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1682, y = 372},
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
            startQuest = "178125495574522692195",
            startPort = "Out",
            endQuest = "178125495574522692197",
            endPort = "In"
          },
          {
            startQuest = "178125495574522692192",
            startPort = "QuestStart",
            endQuest = "178125495574522692195",
            endPort = "In"
          },
          {
            startQuest = "178125495574522692192",
            startPort = "QuestStart",
            endQuest = "178125495574522692196",
            endPort = "In"
          },
          {
            startQuest = "178125495574522692200",
            startPort = "Out",
            endQuest = "178125495574522692193",
            endPort = "Success"
          },
          {
            startQuest = "178125502726323734053",
            startPort = "Out",
            endQuest = "178125495574522692200",
            endPort = "In"
          },
          {
            startQuest = "178125495574522692199",
            startPort = "Out",
            endQuest = "178125502726323734053",
            endPort = "In"
          },
          {
            startQuest = "178125495574522692196",
            startPort = "Out",
            endQuest = "178125495574522692199",
            endPort = "In"
          }
        },
        nodeData = {
          ["178125495574522692192"] = {
            key = "178125495574522692192",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178125495574522692193"] = {
            key = "178125495574522692193",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178125495574522692194"] = {
            key = "178125495574522692194",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178125495574522692195"] = {
            key = "178125495574522692195",
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
          ["178125495574522692196"] = {
            key = "178125495574522692196",
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
          ["178125495574522692197"] = {
            key = "178125495574522692197",
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
          ["178125495574522692199"] = {
            key = "178125495574522692199",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1366.742212002493, y = 526.3778564057203},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "pDafu11010301",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["178125495574522692200"] = {
            key = "178125495574522692200",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178125502726323734053"] = {
            key = "178125502726323734053",
            type = "TalkNode",
            name = "过场-SC003-秽兽包围",
            pos = {x = 1973.6682931395626, y = 547.9508962372256},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC003/SQ_OBT0102_SC003",
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
              EndNewTargetPointName = "BP_TargetPoint110104",
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
