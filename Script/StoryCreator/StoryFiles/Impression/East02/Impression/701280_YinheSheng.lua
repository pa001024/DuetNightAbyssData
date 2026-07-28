return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177564090662015578073",
      startPort = "StoryStart",
      endStory = "177564090662015578075",
      endPort = "In"
    },
    {
      startStory = "177564090662015578075",
      startPort = "Success",
      endStory = "177564090662015578074",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177564090662015578073"] = {
      isStoryNode = true,
      key = "177564090662015578073",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1014, y = 322.25},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177564090662015578074"] = {
      isStoryNode = true,
      key = "177564090662015578074",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1795, y = 315},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177564090662015578075"] = {
      isStoryNode = true,
      key = "177564090662015578075",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1389.6428571428573, y = 322.5123847926268},
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
            startQuest = "177564090662015578076",
            startPort = "QuestStart",
            endQuest = "177564090662015578079",
            endPort = "In"
          },
          {
            startQuest = "177564090662015578079",
            startPort = "Out",
            endQuest = "177564090662015578077",
            endPort = "Success"
          },
          {
            startQuest = "177564090662015578079",
            startPort = "Fail",
            endQuest = "177564090662015578078",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177564090662015578076"] = {
            key = "177564090662015578076",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["177564090662015578077"] = {
            key = "177564090662015578077",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["177564090662015578078"] = {
            key = "177564090662015578078",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["177564090662015578079"] = {
            key = "177564090662015578079",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.2857142857142, y = 313.99999999999994},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51178502,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = false,
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
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
