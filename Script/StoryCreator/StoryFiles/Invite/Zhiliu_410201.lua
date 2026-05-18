return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730378533987946168",
      startPort = "StoryStart",
      endStory = "17730378533987946170",
      endPort = "In"
    },
    {
      startStory = "17730378533987946170",
      startPort = "Success",
      endStory = "17730378533987946169",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730378533987946168"] = {
      isStoryNode = true,
      key = "17730378533987946168",
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
    ["17730378533987946169"] = {
      isStoryNode = true,
      key = "17730378533987946169",
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
    ["17730378533987946170"] = {
      isStoryNode = true,
      key = "17730378533987946170",
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
            startQuest = "1774429993244879512",
            startPort = "Out",
            endQuest = "1774429993244879511",
            endPort = "In"
          },
          {
            startQuest = "17730378533987946171",
            startPort = "QuestStart",
            endQuest = "1774429993244879512",
            endPort = "In"
          },
          {
            startQuest = "1774429993244879511",
            startPort = "Out",
            endQuest = "17730378533987946172",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17730378533987946171"] = {
            key = "17730378533987946171",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730378533987946172"] = {
            key = "17730378533987946172",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1613.8095238095239, y = 309.69523809523815},
            propsData = {ModeType = 0}
          },
          ["17730378533987946173"] = {
            key = "17730378533987946173",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1774429993244879511"] = {
            key = "1774429993244879511",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1327.33266590389, y = 290.19384057971007},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80230101.80230101'",
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
          ["1774429993244879512"] = {
            key = "1774429993244879512",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1066.0840007627762, y = 303.8894927536232},
            propsData = {
              ModeType = 1,
              Id = 105101,
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
