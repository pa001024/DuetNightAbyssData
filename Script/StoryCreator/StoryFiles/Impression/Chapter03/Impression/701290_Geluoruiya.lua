return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17773829418897004226",
      startPort = "StoryStart",
      endStory = "17773829418897004228",
      endPort = "In"
    },
    {
      startStory = "17773829418897004228",
      startPort = "Success",
      endStory = "17773829418897004227",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17773829418897004226"] = {
      isStoryNode = true,
      key = "17773829418897004226",
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
    ["17773829418897004227"] = {
      isStoryNode = true,
      key = "17773829418897004227",
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
    ["17773829418897004228"] = {
      isStoryNode = true,
      key = "17773829418897004228",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1389.6428571428573, y = 320.5123847926268},
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
            startQuest = "17773829418897004229",
            startPort = "QuestStart",
            endQuest = "17773829418897004232",
            endPort = "In"
          },
          {
            startQuest = "17773829418897004232",
            startPort = "Out",
            endQuest = "17773829418897004230",
            endPort = "Success"
          },
          {
            startQuest = "17773829418897004232",
            startPort = "Fail",
            endQuest = "17773829418897004231",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17773829418897004229"] = {
            key = "17773829418897004229",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 806, y = 316},
            propsData = {ModeType = 0}
          },
          ["17773829418897004230"] = {
            key = "17773829418897004230",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1636, y = 252},
            propsData = {ModeType = 0}
          },
          ["17773829418897004231"] = {
            key = "17773829418897004231",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1648.0000000000002, y = 421.00000000000006},
            propsData = {}
          },
          ["17773829418897004232"] = {
            key = "17773829418897004232",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.2857142857142, y = 313.99999999999994},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51019001,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 701290,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 701291,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                }
              },
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
