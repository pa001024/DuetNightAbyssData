return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730374434482463663",
      startPort = "StoryStart",
      endStory = "17730375165042463777",
      endPort = "In"
    },
    {
      startStory = "17730375165042463777",
      startPort = "Success",
      endStory = "17730374434492463666",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730374434482463663"] = {
      isStoryNode = true,
      key = "17730374434482463663",
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
    ["17730374434492463666"] = {
      isStoryNode = true,
      key = "17730374434492463666",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1402, y = 310},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17730375165042463777"] = {
      isStoryNode = true,
      key = "17730375165042463777",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1110, y = 300},
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
            startQuest = "17731442154395923097",
            startPort = "Out",
            endQuest = "17730375165142463781",
            endPort = "Success"
          },
          {
            startQuest = "17730375165042463778",
            startPort = "QuestStart",
            endQuest = "17736422206191736300",
            endPort = "In"
          },
          {
            startQuest = "17736422206191736300",
            startPort = "Out",
            endQuest = "17731442154395923097",
            endPort = "In"
          }
        },
        nodeData = {
          ["17730375165042463778"] = {
            key = "17730375165042463778",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730375165142463781"] = {
            key = "17730375165142463781",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1800.3707093821508, y = 293.89016018306637},
            propsData = {ModeType = 0}
          },
          ["17730375165142463784"] = {
            key = "17730375165142463784",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17731442154395923097"] = {
            key = "17731442154395923097",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1479.263157894737, y = 285.99999999999994},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80240101.80240101'",
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
          ["17736422206191736300"] = {
            key = "17736422206191736300",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1118.3478260869565, y = 290.69565217391306},
            propsData = {
              ModeType = 1,
              Id = 105201,
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
