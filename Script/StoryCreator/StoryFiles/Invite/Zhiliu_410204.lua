return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177303795255610411863",
      startPort = "StoryStart",
      endStory = "177303795255610411865",
      endPort = "In"
    },
    {
      startStory = "177303795255610411865",
      startPort = "Success",
      endStory = "177303795255610411864",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177303795255610411863"] = {
      isStoryNode = true,
      key = "177303795255610411863",
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
    ["177303795255610411864"] = {
      isStoryNode = true,
      key = "177303795255610411864",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1414, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177303795255610411865"] = {
      isStoryNode = true,
      key = "177303795255610411865",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1130, y = 290},
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
            startQuest = "177314577901219511273",
            startPort = "Out",
            endQuest = "177303795255610411867",
            endPort = "Success"
          },
          {
            startQuest = "177303795255610411866",
            startPort = "QuestStart",
            endQuest = "17744303760552633824",
            endPort = "In"
          },
          {
            startQuest = "17744303760552633824",
            startPort = "Out",
            endQuest = "177314577901219511273",
            endPort = "In"
          }
        },
        nodeData = {
          ["177303795255610411866"] = {
            key = "177303795255610411866",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177303795255610411867"] = {
            key = "177303795255610411867",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1726, y = 296},
            propsData = {ModeType = 0}
          },
          ["177303795255610411868"] = {
            key = "177303795255610411868",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177314577901219511273"] = {
            key = "177314577901219511273",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1398, y = 284},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80230401.80230401'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17744303760552633824"] = {
            key = "17744303760552633824",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1088, y = 302},
            propsData = {
              ModeType = 1,
              Id = 104110,
              StartIndex = 1,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
