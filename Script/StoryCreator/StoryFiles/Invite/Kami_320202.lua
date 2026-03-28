return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730377664096294595",
      startPort = "StoryStart",
      endStory = "17730377664096294597",
      endPort = "In"
    },
    {
      startStory = "17730377664096294597",
      startPort = "Success",
      endStory = "17730377664096294596",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730377664096294595"] = {
      isStoryNode = true,
      key = "17730377664096294595",
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
    ["17730377664096294596"] = {
      isStoryNode = true,
      key = "17730377664096294596",
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
    ["17730377664096294597"] = {
      isStoryNode = true,
      key = "17730377664096294597",
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
            startQuest = "1773915545033871958",
            startPort = "Out",
            endQuest = "1773915545033871956",
            endPort = "In"
          },
          {
            startQuest = "1773915545033871959",
            startPort = "Out",
            endQuest = "1773915545033871957",
            endPort = "In"
          },
          {
            startQuest = "17730377664096294598",
            startPort = "QuestStart",
            endQuest = "1773915545033871958",
            endPort = "In"
          },
          {
            startQuest = "17730377664096294598",
            startPort = "QuestStart",
            endQuest = "1773915545033871959",
            endPort = "In"
          },
          {
            startQuest = "1773915545033871957",
            startPort = "Out",
            endQuest = "17730377664096294599",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17730377664096294598"] = {
            key = "17730377664096294598",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730377664096294599"] = {
            key = "17730377664096294599",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1738.9411764705883, y = 287.4117647058824},
            propsData = {ModeType = 0}
          },
          ["17730377664096294600"] = {
            key = "17730377664096294600",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1773915545033871956"] = {
            key = "1773915545033871956",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1429.0972222222222, y = 174.25},
            propsData = {
              ModeType = 1,
              Id = 101107,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1773915545033871957"] = {
            key = "1773915545033871957",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1426.0972222222222, y = 371.07142857142856},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80250201.80250201'",
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
          ["1773915545033871958"] = {
            key = "1773915545033871958",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1115.7916666666665, y = 168.6111111111111},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1773915545033871959"] = {
            key = "1773915545033871959",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 1110.9027777777778, y = 371.3888888888889},
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
