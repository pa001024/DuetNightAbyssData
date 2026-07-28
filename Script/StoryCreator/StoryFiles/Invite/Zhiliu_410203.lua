return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730379250669589913",
      startPort = "StoryStart",
      endStory = "17730379250669589915",
      endPort = "In"
    },
    {
      startStory = "17730379250669589915",
      startPort = "Success",
      endStory = "17730379250669589914",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730379250669589913"] = {
      isStoryNode = true,
      key = "17730379250669589913",
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
    ["17730379250669589914"] = {
      isStoryNode = true,
      key = "17730379250669589914",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1414, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17730379250669589915"] = {
      isStoryNode = true,
      key = "17730379250669589915",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1128.5, y = 290},
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
            startQuest = "17744302182131755946",
            startPort = "Region_1",
            endQuest = "17744302020221755617",
            endPort = "In"
          },
          {
            startQuest = "17744302020221755617",
            startPort = "Out",
            endQuest = "17744302544241756854",
            endPort = "In"
          },
          {
            startQuest = "17744302439351756590",
            startPort = "Region_1",
            endQuest = "17744302415741756513",
            endPort = "In"
          },
          {
            startQuest = "17744302415741756513",
            startPort = "Out",
            endQuest = "17730379250669589917",
            endPort = "Success"
          },
          {
            startQuest = "17730379250669589916",
            startPort = "QuestStart",
            endQuest = "17744302182131755946",
            endPort = "In"
          },
          {
            startQuest = "17730379250669589916",
            startPort = "QuestStart",
            endQuest = "17744302439351756590",
            endPort = "In"
          },
          {
            startQuest = "17730379250669589916",
            startPort = "QuestStart",
            endQuest = "17744303200511757603",
            endPort = "In"
          },
          {
            startQuest = "17744303200511757603",
            startPort = "Region_1",
            endQuest = "17744302020221755618",
            endPort = "In"
          }
        },
        nodeData = {
          ["17730379250669589916"] = {
            key = "17730379250669589916",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730379250669589917"] = {
            key = "17730379250669589917",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1842.7692307692305, y = 510.9230769230769},
            propsData = {ModeType = 0}
          },
          ["17730379250669589918"] = {
            key = "17730379250669589918",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17744302020221755617"] = {
            key = "17744302020221755617",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1456.624332570557, y = 289.15217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80230301.80230301'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17744302020221755618"] = {
            key = "17744302020221755618",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1459.3756674294432, y = 102.84782608695656},
            propsData = {
              ModeType = 1,
              Id = 105101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17744302182131755946"] = {
            key = "17744302182131755946",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1116, y = 298},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {105101}
            }
          },
          ["17744302415741756513"] = {
            key = "17744302415741756513",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1444, y = 492},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80230311.80230311'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17744302439351756590"] = {
            key = "17744302439351756590",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1124, y = 494},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {105602}
            }
          },
          ["17744302544241756854"] = {
            key = "17744302544241756854",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1832, y = 314},
            propsData = {
              ModeType = 1,
              Id = 105602,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17744303200511757603"] = {
            key = "17744303200511757603",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1128, y = 94},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {210101}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
