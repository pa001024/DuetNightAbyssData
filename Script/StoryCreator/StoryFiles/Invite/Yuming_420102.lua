return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177303850051312055204",
      startPort = "StoryStart",
      endStory = "177303850051312055206",
      endPort = "In"
    },
    {
      startStory = "177303850051312055206",
      startPort = "Success",
      endStory = "177303850051312055205",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177303850051312055204"] = {
      isStoryNode = true,
      key = "177303850051312055204",
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
    ["177303850051312055205"] = {
      isStoryNode = true,
      key = "177303850051312055205",
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
    ["177303850051312055206"] = {
      isStoryNode = true,
      key = "177303850051312055206",
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
            startQuest = "177314552230714415278",
            startPort = "Out",
            endQuest = "177303850051312055208",
            endPort = "Success"
          },
          {
            startQuest = "177303850051312055207",
            startPort = "QuestStart",
            endQuest = "1774600374761872472",
            endPort = "In"
          },
          {
            startQuest = "1774600374761872472",
            startPort = "Out",
            endQuest = "177314552230714415278",
            endPort = "In"
          },
          {
            startQuest = "1774600374761872472",
            startPort = "Out",
            endQuest = "17746010029414357403",
            endPort = "Input"
          }
        },
        nodeData = {
          ["177303850051312055207"] = {
            key = "177303850051312055207",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177303850051312055208"] = {
            key = "177303850051312055208",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2092, y = 290},
            propsData = {ModeType = 0}
          },
          ["177303850051312055209"] = {
            key = "177303850051312055209",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["177314552230714415278"] = {
            key = "177314552230714415278",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1506, y = 288},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80220201.80220201'",
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
          ["1774600374761872472"] = {
            key = "1774600374761872472",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1162, y = 302},
            propsData = {
              ModeType = 1,
              Id = 104102,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17746010029414357403"] = {
            key = "17746010029414357403",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1496, y = 72},
            propsData = {
              TargetTime = 18,
              NeedLerp = false,
              LerpTime = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
