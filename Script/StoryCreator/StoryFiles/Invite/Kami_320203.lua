return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730377855677116180",
      startPort = "StoryStart",
      endStory = "17730377855677116182",
      endPort = "In"
    },
    {
      startStory = "17730377855677116182",
      startPort = "Success",
      endStory = "17730377855677116181",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730377855677116180"] = {
      isStoryNode = true,
      key = "17730377855677116180",
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
    ["17730377855677116181"] = {
      isStoryNode = true,
      key = "17730377855677116181",
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
    ["17730377855677116182"] = {
      isStoryNode = true,
      key = "17730377855677116182",
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
            startQuest = "17739156167411743597",
            startPort = "Out",
            endQuest = "17739156167411743595",
            endPort = "In"
          },
          {
            startQuest = "17739156167411743598",
            startPort = "Out",
            endQuest = "17739156167411743596",
            endPort = "In"
          },
          {
            startQuest = "17730377855677116183",
            startPort = "QuestStart",
            endQuest = "17739156167411743597",
            endPort = "In"
          },
          {
            startQuest = "17730377855677116183",
            startPort = "QuestStart",
            endQuest = "17739156167411743598",
            endPort = "In"
          },
          {
            startQuest = "17739156167411743596",
            startPort = "Out",
            endQuest = "17730377855677116184",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17730377855677116183"] = {
            key = "17730377855677116183",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730377855677116184"] = {
            key = "17730377855677116184",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1799.75, y = 367.5},
            propsData = {ModeType = 0}
          },
          ["17730377855677116185"] = {
            key = "17730377855677116185",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17739156167411743595"] = {
            key = "17739156167411743595",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1400.0972222222222, y = 183},
            propsData = {
              ModeType = 1,
              Id = 101107,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17739156167411743596"] = {
            key = "17739156167411743596",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1400.8472222222222, y = 370.07142857142856},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80250301.80250301'",
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
              bNpcActionKeepIn = true,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17739156167411743597"] = {
            key = "17739156167411743597",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1081.7916666666665, y = 182.6111111111111},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17739156167411743598"] = {
            key = "17739156167411743598",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1078.1527777777778, y = 369.1388888888889},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101107,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
