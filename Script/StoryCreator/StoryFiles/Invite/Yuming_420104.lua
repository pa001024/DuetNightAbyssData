return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177303959304113699872",
      startPort = "StoryStart",
      endStory = "177303959304113699874",
      endPort = "In"
    },
    {
      startStory = "177303959304113699874",
      startPort = "Success",
      endStory = "177303959304113699873",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177303959304113699872"] = {
      isStoryNode = true,
      key = "177303959304113699872",
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
    ["177303959304113699873"] = {
      isStoryNode = true,
      key = "177303959304113699873",
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
    ["177303959304113699874"] = {
      isStoryNode = true,
      key = "177303959304113699874",
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
            startQuest = "177314561134816113651",
            startPort = "Out",
            endQuest = "177303959304113699876",
            endPort = "Success"
          },
          {
            startQuest = "177303959304113699875",
            startPort = "QuestStart",
            endQuest = "17746005728513486024",
            endPort = "In"
          },
          {
            startQuest = "17746005728513486024",
            startPort = "Out",
            endQuest = "177314561134816113651",
            endPort = "In"
          }
        },
        nodeData = {
          ["177303959304113699875"] = {
            key = "177303959304113699875",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177303959304113699876"] = {
            key = "177303959304113699876",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1719.5, y = 296.5},
            propsData = {ModeType = 0}
          },
          ["177303959304113699877"] = {
            key = "177303959304113699877",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177314561134816113651"] = {
            key = "177314561134816113651",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1407.375, y = 277.91666666666663},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80220401.80220401'",
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
          ["17746005728513486024"] = {
            key = "17746005728513486024",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1088, y = 294},
            propsData = {
              ModeType = 1,
              Id = 104505,
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
