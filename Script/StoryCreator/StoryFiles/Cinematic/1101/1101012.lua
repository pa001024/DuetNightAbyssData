return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "178150941995015734936",
      startPort = "StoryStart",
      endStory = "178150942176715735001",
      endPort = "In"
    },
    {
      startStory = "178150942176715735001",
      startPort = "Success",
      endStory = "178150941995015734939",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["178150941995015734936"] = {
      isStoryNode = true,
      key = "178150941995015734936",
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
    ["178150941995015734939"] = {
      isStoryNode = true,
      key = "178150941995015734939",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1692, y = 302},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["178150942176715735001"] = {
      isStoryNode = true,
      key = "178150942176715735001",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1376, y = 306},
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
            startQuest = "178150942176715735009",
            startPort = "Out",
            endQuest = "178150942176715735011",
            endPort = "In"
          },
          {
            startQuest = "178150942176715735006",
            startPort = "QuestStart",
            endQuest = "178150942176715735009",
            endPort = "In"
          },
          {
            startQuest = "178150942176715735006",
            startPort = "QuestStart",
            endQuest = "178150942176715735010",
            endPort = "In"
          },
          {
            startQuest = "178150942176715735014",
            startPort = "Out",
            endQuest = "178150942176715735007",
            endPort = "Success"
          },
          {
            startQuest = "178150942176715735013",
            startPort = "Out",
            endQuest = "178150942176715735015",
            endPort = "In"
          },
          {
            startQuest = "178150942176715735015",
            startPort = "Out",
            endQuest = "178150942176715735014",
            endPort = "In"
          },
          {
            startQuest = "178150942176715735010",
            startPort = "Out",
            endQuest = "178150942176715735013",
            endPort = "In"
          }
        },
        nodeData = {
          ["178150942176715735006"] = {
            key = "178150942176715735006",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 435.25362318840615, y = 289.6376811594203},
            propsData = {ModeType = 0}
          },
          ["178150942176715735007"] = {
            key = "178150942176715735007",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2698.5714285714275, y = 544.5714285714287},
            propsData = {ModeType = 0}
          },
          ["178150942176715735008"] = {
            key = "178150942176715735008",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2221.428571428571, y = 827.1428571428571},
            propsData = {}
          },
          ["178150942176715735009"] = {
            key = "178150942176715735009",
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
          ["178150942176715735010"] = {
            key = "178150942176715735010",
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
          ["178150942176715735011"] = {
            key = "178150942176715735011",
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
          ["178150942176715735013"] = {
            key = "178150942176715735013",
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
          ["178150942176715735014"] = {
            key = "178150942176715735014",
            type = "PlayOrStopBGMNode",
            name = "BGM节点2",
            pos = {x = 2270.822983844701, y = 554.1316144253454},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 3,
              SoundType = 0
            }
          },
          ["178150942176715735015"] = {
            key = "178150942176715735015",
            type = "TalkNode",
            name = "过场-SC012-紧张逃跑",
            pos = {x = 1845.9107142857142, y = 550.1607142857143},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/OBT01/OBT0102/OBT0102_SC012/SQ_OBT0102_SC012",
              BlendInTime = 1,
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
