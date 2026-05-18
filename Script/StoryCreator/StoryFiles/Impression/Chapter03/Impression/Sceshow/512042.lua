return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17780640442728994426",
      startPort = "StoryStart",
      endStory = "17780640442728994428",
      endPort = "In"
    },
    {
      startStory = "17780640442728994428",
      startPort = "Success",
      endStory = "17780640442728994427",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17780640442728994426"] = {
      isStoryNode = true,
      key = "17780640442728994426",
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
    ["17780640442728994427"] = {
      isStoryNode = true,
      key = "17780640442728994427",
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
    ["17780640442728994428"] = {
      isStoryNode = true,
      key = "17780640442728994428",
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
            startQuest = "17780640442728994433",
            startPort = "Out",
            endQuest = "17780640442728994430",
            endPort = "Success"
          },
          {
            startQuest = "17780640442728994432",
            startPort = "Out",
            endQuest = "17780640442728994430",
            endPort = "Success"
          },
          {
            startQuest = "177806454411511246690",
            startPort = "Branch_1",
            endQuest = "17780640442728994433",
            endPort = "In"
          },
          {
            startQuest = "17780640442728994429",
            startPort = "QuestStart",
            endQuest = "177806454411511246690",
            endPort = "In"
          },
          {
            startQuest = "17780640442728994432",
            startPort = "Fail",
            endQuest = "17780640442728994431",
            endPort = "Fail"
          },
          {
            startQuest = "177806454411511246690",
            startPort = "Branch_2",
            endQuest = "17780640442728994432",
            endPort = "In"
          }
        },
        nodeData = {
          ["17780640442728994429"] = {
            key = "17780640442728994429",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 990.8, y = 280.8},
            propsData = {ModeType = 0}
          },
          ["17780640442728994430"] = {
            key = "17780640442728994430",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2324.7999999999997, y = 278.4},
            propsData = {ModeType = 0}
          },
          ["17780640442728994431"] = {
            key = "17780640442728994431",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2302, y = 472},
            propsData = {}
          },
          ["17780640442728994432"] = {
            key = "17780640442728994432",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1571.6, y = 277.3956521739131},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204201,
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
          ["17780640442728994433"] = {
            key = "17780640442728994433",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1577.3916666666669, y = 53.24999999999996},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51204212,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
          ["177806454411511246690"] = {
            key = "177806454411511246690",
            type = "BranchTriggerNode",
            name = "触发分支节点",
            pos = {x = 1252.3333333333333, y = 244},
            propsData = {
              Branches = {5120422, 512042}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
