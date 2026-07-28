return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177564046524913807384",
      startPort = "StoryStart",
      endStory = "177564046524913807386",
      endPort = "In"
    },
    {
      startStory = "177564046524913807386",
      startPort = "Success",
      endStory = "177564046524913807385",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177564046524913807384"] = {
      isStoryNode = true,
      key = "177564046524913807384",
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
    ["177564046524913807385"] = {
      isStoryNode = true,
      key = "177564046524913807385",
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
    ["177564046524913807386"] = {
      isStoryNode = true,
      key = "177564046524913807386",
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
            startQuest = "177564046524913807387",
            startPort = "QuestStart",
            endQuest = "177564046524913807390",
            endPort = "In"
          },
          {
            startQuest = "177564046524913807390",
            startPort = "Out",
            endQuest = "177564046524913807388",
            endPort = "Success"
          },
          {
            startQuest = "177564046524913807390",
            startPort = "Fail",
            endQuest = "177564046524913807389",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177564046524913807387"] = {
            key = "177564046524913807387",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["177564046524913807388"] = {
            key = "177564046524913807388",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["177564046524913807389"] = {
            key = "177564046524913807389",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["177564046524913807390"] = {
            key = "177564046524913807390",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1184.0857142857142, y = 313.99999999999994},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51178402,
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
