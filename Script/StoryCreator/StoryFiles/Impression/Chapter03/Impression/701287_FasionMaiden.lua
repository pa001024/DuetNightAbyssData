return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17773824492654237793",
      startPort = "StoryStart",
      endStory = "17773824492654237795",
      endPort = "In"
    },
    {
      startStory = "17773824492654237795",
      startPort = "Success",
      endStory = "17773824492654237794",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17773824492654237793"] = {
      isStoryNode = true,
      key = "17773824492654237793",
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
    ["17773824492654237794"] = {
      isStoryNode = true,
      key = "17773824492654237794",
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
    ["17773824492654237795"] = {
      isStoryNode = true,
      key = "17773824492654237795",
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
            startQuest = "17773824492654237796",
            startPort = "QuestStart",
            endQuest = "17773824492654237799",
            endPort = "In"
          },
          {
            startQuest = "17773824492654237799",
            startPort = "Out",
            endQuest = "17773824492654237797",
            endPort = "Success"
          },
          {
            startQuest = "17773824492654237799",
            startPort = "Fail",
            endQuest = "17773824492654237798",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17773824492654237796"] = {
            key = "17773824492654237796",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["17773824492654237797"] = {
            key = "17773824492654237797",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["17773824492654237798"] = {
            key = "17773824492654237798",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["17773824492654237799"] = {
            key = "17773824492654237799",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.2857142857142, y = 313.99999999999994},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51016000,
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
