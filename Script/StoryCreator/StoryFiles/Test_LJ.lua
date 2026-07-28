return {
  storyName = "Test_LJ",
  storyDescription = "策划测试用 STL（AI 维护）",
  lineData = {
    {
      startStory = "17910000000000001",
      startPort = "StoryStart",
      endStory = "17910000000000002",
      endPort = "In"
    },
    {
      startStory = "17910000000000002",
      startPort = "Success",
      endStory = "17910000000000003",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17910000000000001"] = {
      isStoryNode = true,
      key = "17910000000000001",
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
    ["17910000000000003"] = {
      isStoryNode = true,
      key = "17910000000000003",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17910000000000002"] = {
      isStoryNode = true,
      key = "17910000000000002",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1734, y = 292},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "Test_LJ",
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
            startQuest = "17910000000000011",
            startPort = "QuestStart",
            endQuest = "17910000000000012",
            endPort = "In"
          },
          {
            startQuest = "17910000000000012",
            startPort = "Out",
            endQuest = "17910000000000013",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17910000000000011"] = {
            key = "17910000000000011",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17910000000000013"] = {
            key = "17910000000000013",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17910000000000014"] = {
            key = "17910000000000014",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17910000000000012"] = {
            key = "17910000000000012",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1794, y = 366},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 0,
              FlowAssetPath = "",
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
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = true,
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
              bLockHighestLOD = true,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
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
