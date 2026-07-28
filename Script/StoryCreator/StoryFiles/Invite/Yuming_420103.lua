return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177303857030812877405",
      startPort = "StoryStart",
      endStory = "177303857030812877407",
      endPort = "In"
    },
    {
      startStory = "177303857030812877407",
      startPort = "Success",
      endStory = "177303857030812877406",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177303857030812877405"] = {
      isStoryNode = true,
      key = "177303857030812877405",
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
    ["177303857030812877406"] = {
      isStoryNode = true,
      key = "177303857030812877406",
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
    ["177303857030812877407"] = {
      isStoryNode = true,
      key = "177303857030812877407",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1130, y = 290},
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
            startQuest = "177314556565015264390",
            startPort = "Out",
            endQuest = "177303857030812877409",
            endPort = "Success"
          },
          {
            startQuest = "177303857030812877408",
            startPort = "QuestStart",
            endQuest = "17746004668751743968",
            endPort = "In"
          },
          {
            startQuest = "17746004668751743968",
            startPort = "Out",
            endQuest = "177314556565015264390",
            endPort = "In"
          },
          {
            startQuest = "17746004668751743968",
            startPort = "Out",
            endQuest = "17746012568836099101",
            endPort = "Input"
          }
        },
        nodeData = {
          ["177303857030812877408"] = {
            key = "177303857030812877408",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177303857030812877409"] = {
            key = "177303857030812877409",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1726, y = 296},
            propsData = {ModeType = 0}
          },
          ["177303857030812877410"] = {
            key = "177303857030812877410",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177314556565015264390"] = {
            key = "177314556565015264390",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1404, y = 288},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80220301.80220301'",
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
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
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
          ["17746004668751743968"] = {
            key = "17746004668751743968",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1084, y = 302},
            propsData = {
              ModeType = 1,
              Id = 104107,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17746012568836099101"] = {
            key = "17746012568836099101",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1410, y = 106},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
