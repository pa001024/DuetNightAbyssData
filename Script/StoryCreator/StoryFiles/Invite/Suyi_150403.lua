return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17730375811354107040",
      startPort = "StoryStart",
      endStory = "17730376312624107231",
      endPort = "In"
    },
    {
      startStory = "17730376312624107231",
      startPort = "Success",
      endStory = "17730375811354107043",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17730375811354107040"] = {
      isStoryNode = true,
      key = "17730375811354107040",
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
    ["17730375811354107043"] = {
      isStoryNode = true,
      key = "17730375811354107043",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1466, y = 310},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17730376312624107231"] = {
      isStoryNode = true,
      key = "17730376312624107231",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1114, y = 296},
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
            startQuest = "17731442857837620252",
            startPort = "Out",
            endQuest = "17730376312624107235",
            endPort = "Success"
          },
          {
            startQuest = "17730376312624107232",
            startPort = "QuestStart",
            endQuest = "17736619379659118586",
            endPort = "In"
          },
          {
            startQuest = "17736619379659118586",
            startPort = "Out",
            endQuest = "17731442857837620252",
            endPort = "In"
          }
        },
        nodeData = {
          ["17730376312624107232"] = {
            key = "17730376312624107232",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17730376312624107235"] = {
            key = "17730376312624107235",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1868.2058823529412, y = 308.1470588235294},
            propsData = {ModeType = 0}
          },
          ["17730376312634107238"] = {
            key = "17730376312634107238",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17731442857837620252"] = {
            key = "17731442857837620252",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1518.669132894819, y = 297.94546973494346},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80240301.80240301'",
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
          ["17736619379659118586"] = {
            key = "17736619379659118586",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1130, y = 304},
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
