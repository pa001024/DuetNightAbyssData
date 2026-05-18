return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1775633123486592767",
      startPort = "StoryStart",
      endStory = "1775633123486592769",
      endPort = "In"
    },
    {
      startStory = "1775633123486592769",
      startPort = "Success",
      endStory = "1775633123486592768",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1775633123486592767"] = {
      isStoryNode = true,
      key = "1775633123486592767",
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
    ["1775633123486592768"] = {
      isStoryNode = true,
      key = "1775633123486592768",
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
    ["1775633123486592769"] = {
      isStoryNode = true,
      key = "1775633123486592769",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1102.888888888889, y = 288.44444444444446},
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
            startQuest = "1775633123486592774",
            startPort = "Out",
            endQuest = "1725258819331197321",
            endPort = "In"
          },
          {
            startQuest = "1725258819331197321",
            startPort = "Out",
            endQuest = "1775633123486592772",
            endPort = "Success"
          },
          {
            startQuest = "1775633123486592771",
            startPort = "QuestStart",
            endQuest = "17376224323743736483",
            endPort = "In"
          },
          {
            startQuest = "17376224323743736483",
            startPort = "Out",
            endQuest = "1775633123486592774",
            endPort = "In"
          },
          {
            startQuest = "17376224323743736483",
            startPort = "Out",
            endQuest = "1775633123486592770",
            endPort = "In"
          }
        },
        nodeData = {
          ["1725258819331197321"] = {
            key = "1725258819331197321",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1373.225996417376, y = 206.45772503358737},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          },
          ["17376224323743736483"] = {
            key = "17376224323743736483",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 804.2233766233763, y = 210.51212121212126},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1775633123486592770"] = {
            key = "1775633123486592770",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1092.3416927899686, y = 369.32288401253913},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt01/0017_story_incave",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {}
            }
          },
          ["1775633123486592771"] = {
            key = "1775633123486592771",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 529.6476190476191, y = 207.76825396825393},
            propsData = {ModeType = 0}
          },
          ["1775633123486592772"] = {
            key = "1775633123486592772",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1671.6214285714289, y = 205.49220779220775},
            propsData = {ModeType = 0}
          },
          ["1775633123486592773"] = {
            key = "1775633123486592773",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1608.0000000000002, y = 418.9},
            propsData = {}
          },
          ["1775633123486592774"] = {
            key = "1775633123486592774",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1071.8444034226645, y = 206.4229526512134},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80260201.80260201'",
              TalkType = "FixSimple",
              TalkStageName = "Stage_110101",
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
