return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1775633123487592921",
      startPort = "StoryStart",
      endStory = "1775633123487592923",
      endPort = "In"
    },
    {
      startStory = "1775633123487592923",
      startPort = "Success",
      endStory = "1775633123487592922",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1775633123487592921"] = {
      isStoryNode = true,
      key = "1775633123487592921",
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
    ["1775633123487592922"] = {
      isStoryNode = true,
      key = "1775633123487592922",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1435.111111111111, y = 298.44444444444446},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775633123487592923"] = {
      isStoryNode = true,
      key = "1775633123487592923",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1102.888888888889, y = 286.44444444444446},
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
            startQuest = "1775633162769893539",
            startPort = "Out",
            endQuest = "1775633162769893538",
            endPort = "In"
          },
          {
            startQuest = "1775633162769893539",
            startPort = "Out",
            endQuest = "1775633162769893540",
            endPort = "In"
          },
          {
            startQuest = "1775633123487592926",
            startPort = "QuestStart",
            endQuest = "1775633162769893539",
            endPort = "In"
          },
          {
            startQuest = "1775633162769893538",
            startPort = "Out",
            endQuest = "17756333734383563908",
            endPort = "In"
          },
          {
            startQuest = "17756333734383563908",
            startPort = "Out",
            endQuest = "1775633123487592927",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775633123487592926"] = {
            key = "1775633123487592926",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 529.6476190476191, y = 207.76825396825393},
            propsData = {ModeType = 0}
          },
          ["1775633123487592927"] = {
            key = "1775633123487592927",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1687.1214285714289, y = 202.12857142857138},
            propsData = {ModeType = 0}
          },
          ["1775633123487592928"] = {
            key = "1775633123487592928",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1608.0000000000002, y = 418.9},
            propsData = {}
          },
          ["1775633162769893538"] = {
            key = "1775633162769893538",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1084.7618891984935, y = 202.58857186874422},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80260301.80260301'",
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
              bLockNpcSpawn = false,
              OptionType = "normal",
              bLockHighestLOD = false,
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
          ["1775633162769893539"] = {
            key = "1775633162769893539",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 806.9167107622661, y = 203.51905446514763},
            propsData = {
              ModeType = 1,
              Id = 101106,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1775633162769893540"] = {
            key = "1775633162769893540",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1082.083289237734, y = 365.4114281312558},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt01/0016_judian",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {}
            }
          },
          ["17756333734383563908"] = {
            key = "17756333734383563908",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1404.1666666666667, y = 209.2916666666666},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
