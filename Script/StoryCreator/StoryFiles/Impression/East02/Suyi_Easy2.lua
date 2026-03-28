return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17742691623171381674",
      startPort = "StoryStart",
      endStory = "17742691623171381676",
      endPort = "In"
    },
    {
      startStory = "17742691623171381676",
      startPort = "Success",
      endStory = "17742691623171381675",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17742691623171381674"] = {
      isStoryNode = true,
      key = "17742691623171381674",
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
    ["17742691623171381675"] = {
      isStoryNode = true,
      key = "17742691623171381675",
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
    ["17742691623171381676"] = {
      isStoryNode = true,
      key = "17742691623171381676",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1704, y = 176},
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
            startQuest = "17742691848861689747",
            startPort = "Out",
            endQuest = "17742691623171381678",
            endPort = "Success"
          },
          {
            startQuest = "17742691623171381677",
            startPort = "QuestStart",
            endQuest = "1774348867405347",
            endPort = "In"
          },
          {
            startQuest = "1774348867405347",
            startPort = "Out",
            endQuest = "17742691848861689747",
            endPort = "In"
          }
        },
        nodeData = {
          ["17742691623171381677"] = {
            key = "17742691623171381677",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17742691623171381678"] = {
            key = "17742691623171381678",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17742691623171381679"] = {
            key = "17742691623171381679",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17742691848861689747"] = {
            key = "17742691848861689747",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1716, y = 218.42857142857144},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YYG_Easy2",
              UnitId = -1
            }
          },
          ["1774348867405347"] = {
            key = "1774348867405347",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1374.986111111111, y = 315.78174603174597},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
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
              TalkActors = {},
              OptionType = "normal",
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
