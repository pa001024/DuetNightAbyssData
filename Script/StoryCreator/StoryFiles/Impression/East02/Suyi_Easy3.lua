return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17742691623171381722",
      startPort = "StoryStart",
      endStory = "17742691623171381724",
      endPort = "In"
    },
    {
      startStory = "17742691623171381724",
      startPort = "Success",
      endStory = "17742691623171381723",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17742691623171381722"] = {
      isStoryNode = true,
      key = "17742691623171381722",
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
    ["17742691623171381723"] = {
      isStoryNode = true,
      key = "17742691623171381723",
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
    ["17742691623171381724"] = {
      isStoryNode = true,
      key = "17742691623171381724",
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
            startQuest = "17742692730963378400",
            startPort = "Out",
            endQuest = "17742691623171381726",
            endPort = "Success"
          },
          {
            startQuest = "17742691623171381725",
            startPort = "QuestStart",
            endQuest = "17743489170772978287",
            endPort = "In"
          },
          {
            startQuest = "17743489170772978287",
            startPort = "Out",
            endQuest = "17742692730963378400",
            endPort = "In"
          }
        },
        nodeData = {
          ["17742691623171381725"] = {
            key = "17742691623171381725",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17742691623171381726"] = {
            key = "17742691623171381726",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17742691623171381727"] = {
            key = "17742691623171381727",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17742692730963378400"] = {
            key = "17742692730963378400",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1688, y = 258.42857142857144},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "YYG_Easy3",
              UnitId = -1
            }
          },
          ["17743489170772978287"] = {
            key = "17743489170772978287",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1302.5945945945944, y = 224.43243243243234},
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
