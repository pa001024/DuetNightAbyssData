return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177303847410211233083",
      startPort = "StoryStart",
      endStory = "177303847410211233085",
      endPort = "In"
    },
    {
      startStory = "177303847410211233085",
      startPort = "Success",
      endStory = "177303847410211233084",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177303847410211233083"] = {
      isStoryNode = true,
      key = "177303847410211233083",
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
    ["177303847410211233084"] = {
      isStoryNode = true,
      key = "177303847410211233084",
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
    ["177303847410211233085"] = {
      isStoryNode = true,
      key = "177303847410211233085",
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
            startQuest = "17731443290338469063",
            startPort = "Out",
            endQuest = "177303847410211233087",
            endPort = "Success"
          },
          {
            startQuest = "177303847410211233086",
            startPort = "QuestStart",
            endQuest = "1774600270994355",
            endPort = "In"
          },
          {
            startQuest = "1774600270994355",
            startPort = "Out",
            endQuest = "17731443290338469063",
            endPort = "In"
          }
        },
        nodeData = {
          ["177303847410211233086"] = {
            key = "177303847410211233086",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177303847410211233087"] = {
            key = "177303847410211233087",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1733.5263157894738, y = 293.57894736842104},
            propsData = {ModeType = 0}
          },
          ["177303847410211233088"] = {
            key = "177303847410211233088",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17731443290338469063"] = {
            key = "17731443290338469063",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1405.5, y = 282.5},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80220101.80220101'",
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
              OptionType = "normal",
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
          ["1774600270994355"] = {
            key = "1774600270994355",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1113.9166666666665, y = 297.62061403508767},
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
