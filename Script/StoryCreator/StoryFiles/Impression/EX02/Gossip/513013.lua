return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17833949071333266954",
      startPort = "StoryStart",
      endStory = "17833949121243267107",
      endPort = "In"
    },
    {
      startStory = "17833949121243267107",
      startPort = "Success",
      endStory = "17833949071333266957",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17833949071333266954"] = {
      isStoryNode = true,
      key = "17833949071333266954",
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
    ["17833949071333266957"] = {
      isStoryNode = true,
      key = "17833949071333266957",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1712, y = 446},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17833949121243267107"] = {
      isStoryNode = true,
      key = "17833949121243267107",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1244, y = 464},
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
            startQuest = "17834050518963268028",
            startPort = "Out",
            endQuest = "17833949121243267111",
            endPort = "Success"
          },
          {
            startQuest = "17833949121243267108",
            startPort = "QuestStart",
            endQuest = "17834050518963268028",
            endPort = "In"
          }
        },
        nodeData = {
          ["17833949121243267108"] = {
            key = "17833949121243267108",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17833949121243267111"] = {
            key = "17833949121243267111",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1754, y = 394},
            propsData = {ModeType = 0}
          },
          ["17833949121243267114"] = {
            key = "17833949121243267114",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834050518963268028"] = {
            key = "17834050518963268028",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1292, y = 382},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301301,
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
