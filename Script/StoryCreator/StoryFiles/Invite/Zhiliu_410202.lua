return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730379038638768049",
      startPort = "StoryStart",
      endStory = "17730379038638768051",
      endPort = "In"
    },
    {
      startStory = "17730379038638768051",
      startPort = "Success",
      endStory = "17730379038638768050",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730379038638768049"] = {
      isStoryNode = true,
      key = "17730379038638768049",
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
    ["17730379038638768050"] = {
      isStoryNode = true,
      key = "17730379038638768050",
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
    ["17730379038638768051"] = {
      isStoryNode = true,
      key = "17730379038638768051",
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
            startQuest = "17744294436942756",
            startPort = "Out",
            endQuest = "17744294436942755",
            endPort = "In"
          },
          {
            startQuest = "17730379038638768052",
            startPort = "QuestStart",
            endQuest = "17744294436942756",
            endPort = "In"
          },
          {
            startQuest = "17744294436942755",
            startPort = "Out",
            endQuest = "17730379038638768053",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17730379038638768052"] = {
            key = "17730379038638768052",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730379038638768053"] = {
            key = "17730379038638768053",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1806, y = 310},
            propsData = {ModeType = 0}
          },
          ["17730379038638768054"] = {
            key = "17730379038638768054",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17744294436942755"] = {
            key = "17744294436942755",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1402.4576659038903, y = 298.65217391304344},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80230201.80230201'",
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
          ["17744294436942756"] = {
            key = "17744294436942756",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1089.5423340961097, y = 307.34782608695656},
            propsData = {
              ModeType = 1,
              Id = 104503,
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
