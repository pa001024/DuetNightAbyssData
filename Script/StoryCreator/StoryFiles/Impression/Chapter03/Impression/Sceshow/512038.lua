return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17780596093963375522",
      startPort = "StoryStart",
      endStory = "17780596093963375524",
      endPort = "In"
    },
    {
      startStory = "17780596093963375524",
      startPort = "Success",
      endStory = "17780596093963375523",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17780596093963375522"] = {
      isStoryNode = true,
      key = "17780596093963375522",
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
    ["17780596093963375523"] = {
      isStoryNode = true,
      key = "17780596093963375523",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1912, y = 328},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17780596093963375524"] = {
      isStoryNode = true,
      key = "17780596093963375524",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1542, y = 322},
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
            startQuest = "17780596093963375529",
            startPort = "Out",
            endQuest = "17780596093963375526",
            endPort = "Success"
          },
          {
            startQuest = "17780596093963375525",
            startPort = "QuestStart",
            endQuest = "17780593840771879657",
            endPort = "In"
          },
          {
            startQuest = "17780593840771879657",
            startPort = "Branch_2",
            endQuest = "17780596093963375528",
            endPort = "In"
          },
          {
            startQuest = "17780593840771879657",
            startPort = "Branch_1",
            endQuest = "17780596093963375529",
            endPort = "In"
          },
          {
            startQuest = "17780596093963375528",
            startPort = "Out",
            endQuest = "17780596093963375526",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17780593840771879657"] = {
            key = "17780593840771879657",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1268.191666666667, y = 236.45000000000022},
            propsData = {
              Branches = {5120382, 512038}
            }
          },
          ["17780596093963375525"] = {
            key = "17780596093963375525",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 990.8, y = 280.8},
            propsData = {ModeType = 0}
          },
          ["17780596093963375526"] = {
            key = "17780596093963375526",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["17780596093963375527"] = {
            key = "17780596093963375527",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17780596093963375528"] = {
            key = "17780596093963375528",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1573.6, y = 283.20000000000005},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51203801,
              FlowAssetPath = "",
              TalkType = "Impression",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
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
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17780596093963375529"] = {
            key = "17780596093963375529",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 55.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51203818,
              FlowAssetPath = "",
              TalkType = "Impression",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
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
