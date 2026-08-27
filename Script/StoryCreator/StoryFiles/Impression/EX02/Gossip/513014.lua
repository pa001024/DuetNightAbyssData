return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17834063690025444083",
      startPort = "StoryStart",
      endStory = "17834075728535444418",
      endPort = "In"
    },
    {
      startStory = "17834075728535444418",
      startPort = "Success",
      endStory = "17834063690025444086",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17834063690025444083"] = {
      isStoryNode = true,
      key = "17834063690025444083",
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
    ["17834063690025444086"] = {
      isStoryNode = true,
      key = "17834063690025444086",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1656, y = 324},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17834075728535444418"] = {
      isStoryNode = true,
      key = "17834075728535444418",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1320, y = 350},
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
            startQuest = "17834075728535444419",
            startPort = "QuestStart",
            endQuest = "17834076123495445067",
            endPort = "In"
          },
          {
            startQuest = "17834076123495445067",
            startPort = "Out",
            endQuest = "17834075728535444422",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17834075728535444419"] = {
            key = "17834075728535444419",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834075728535444422"] = {
            key = "17834075728535444422",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1782, y = 304},
            propsData = {ModeType = 0}
          },
          ["17834075728535444425"] = {
            key = "17834075728535444425",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17834076123495445067"] = {
            key = "17834076123495445067",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1320, y = 356},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51301401,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
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
