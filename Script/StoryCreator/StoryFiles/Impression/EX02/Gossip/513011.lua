return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17833946389632177995",
      startPort = "StoryStart",
      endStory = "17833946438422178162",
      endPort = "In"
    },
    {
      startStory = "17833946438422178162",
      startPort = "Success",
      endStory = "17833946389632177998",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17833946389632177995"] = {
      isStoryNode = true,
      key = "17833946389632177995",
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
    ["17833946389632177998"] = {
      isStoryNode = true,
      key = "17833946389632177998",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2238, y = 354},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17833946438422178162"] = {
      isStoryNode = true,
      key = "17833946438422178162",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1708, y = 556},
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
            startQuest = "17833946438422178163",
            startPort = "QuestStart",
            endQuest = "17833946603302178675",
            endPort = "In"
          },
          {
            startQuest = "17833946603302178675",
            startPort = "Out",
            endQuest = "17833946438422178166",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17833946438422178163"] = {
            key = "17833946438422178163",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17833946438422178166"] = {
            key = "17833946438422178166",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17833946438422178169"] = {
            key = "17833946438422178169",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17833946603302178675"] = {
            key = "17833946603302178675",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1492.89010989011, y = 421.0329670329671},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
              BlendEaseExp = 2,
              UseProceduralCamera = true,
              ProceduralCameraId = 1,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = true,
              ShowSkipButton = true,
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
              SwitchToMaster = "EXPlayer",
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
