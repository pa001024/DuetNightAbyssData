return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17742684436381",
      startPort = "StoryStart",
      endStory = "177426844755467",
      endPort = "In"
    },
    {
      startStory = "177426844755467",
      startPort = "Success",
      endStory = "17742684436395",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17742684436381"] = {
      isStoryNode = true,
      key = "17742684436381",
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
    ["17742684436395"] = {
      isStoryNode = true,
      key = "17742684436395",
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
    ["177426844755467"] = {
      isStoryNode = true,
      key = "177426844755467",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1705.0714285714287, y = 176},
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
        IsBacktrack = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177426844755468",
            startPort = "QuestStart",
            endQuest = "1774269131052844946",
            endPort = "In"
          },
          {
            startQuest = "1774269131052844946",
            startPort = "Out",
            endQuest = "1774269136668845183",
            endPort = "In"
          },
          {
            startQuest = "1774269136668845183",
            startPort = "Out",
            endQuest = "1774774640280978",
            endPort = "In"
          },
          {
            startQuest = "1774774640280978",
            startPort = "Out",
            endQuest = "177426844755576",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177426844755468"] = {
            key = "177426844755468",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177426844755576"] = {
            key = "177426844755576",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177426844755584"] = {
            key = "177426844755584",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774269131052844946"] = {
            key = "1774269131052844946",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1666.6768388093265, y = 325.732735401853},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 12048809,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1774269136668845183"] = {
            key = "1774269136668845183",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2137.144757986923, y = 328.9443624844479},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YYG_Easy1",
              UnitId = -1
            }
          },
          ["1774774640280978"] = {
            key = "1774774640280978",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2498.6784556439725, y = 298.1891265905509},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "TXSB1"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
