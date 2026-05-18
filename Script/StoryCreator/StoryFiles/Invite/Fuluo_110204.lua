return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1775633123488593079",
      startPort = "StoryStart",
      endStory = "1775633123488593081",
      endPort = "In"
    },
    {
      startStory = "1775633123488593081",
      startPort = "Success",
      endStory = "1775633123488593080",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["1775633123488593079"] = {
      isStoryNode = true,
      key = "1775633123488593079",
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
    ["1775633123488593080"] = {
      isStoryNode = true,
      key = "1775633123488593080",
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
    ["1775633123488593081"] = {
      isStoryNode = true,
      key = "1775633123488593081",
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
            startQuest = "1775633123488593087",
            startPort = "Out",
            endQuest = "1775633123488593083",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593084",
            startPort = "QuestStart",
            endQuest = "1775633123488593089",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593084",
            startPort = "QuestStart",
            endQuest = "1775633123488593090",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593090",
            startPort = "Out",
            endQuest = "1775633123488593087",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593089",
            startPort = "Out",
            endQuest = "177607127434410496862",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593083",
            startPort = "Out",
            endQuest = "177607133969510497569",
            endPort = "In"
          },
          {
            startQuest = "177607136167710497947",
            startPort = "Out",
            endQuest = "177607136167710497946",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593084",
            startPort = "QuestStart",
            endQuest = "177607136167710497948",
            endPort = "In"
          },
          {
            startQuest = "177607136167710497946",
            startPort = "Out",
            endQuest = "1775633123488593085",
            endPort = "Success"
          },
          {
            startQuest = "177607136167710497948",
            startPort = "Out",
            endQuest = "177607137712010498191",
            endPort = "In"
          },
          {
            startQuest = "177607136167710497948",
            startPort = "Out",
            endQuest = "177607730788911410398",
            endPort = "In"
          },
          {
            startQuest = "177607730788911410398",
            startPort = "Out",
            endQuest = "177607136167710497947",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593090",
            startPort = "Out",
            endQuest = "17784850334961953463",
            endPort = "In"
          },
          {
            startQuest = "1775633123488593090",
            startPort = "Out",
            endQuest = "17785737450511951404",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775633123488593083"] = {
            key = "1775633123488593083",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1404.3270935960595, y = 248.88719211822686},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          },
          ["1775633123488593084"] = {
            key = "1775633123488593084",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 529.6476190476191, y = 207.76825396825393},
            propsData = {ModeType = 0}
          },
          ["1775633123488593085"] = {
            key = "1775633123488593085",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2080.3714285714286, y = 498.5035714285714},
            propsData = {ModeType = 0}
          },
          ["1775633123488593086"] = {
            key = "1775633123488593086",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2230.5, y = 608.275},
            propsData = {}
          },
          ["1775633123488593087"] = {
            key = "1775633123488593087",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1082.500751385047, y = 247.9374510838153},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80260401.80260401'",
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
          },
          ["1775633123488593089"] = {
            key = "1775633123488593089",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 808.3527833087329, y = -85.6229159856162},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 210101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["1775633123488593090"] = {
            key = "1775633123488593090",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 800.2716155592742, y = 250.74650347132197},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101101,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["177607127434410496862"] = {
            key = "177607127434410496862",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1129.9782608695652, y = -71.80978260869567},
            propsData = {
              ModeType = 1,
              Id = 101101,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["177607133969510497569"] = {
            key = "177607133969510497569",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1668.7115384615383, y = 239.9230769230769},
            propsData = {
              ModeType = 1,
              Id = 101104,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["177607136167710497946"] = {
            key = "177607136167710497946",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1732.3854976390824, y = 527.5912498275507},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 1,
              SoundType = 0
            }
          },
          ["177607136167710497947"] = {
            key = "177607136167710497947",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1407.1970864625525, y = 527.1587501724493},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/Invite/80260416.80260416'",
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
          },
          ["177607136167710497948"] = {
            key = "177607136167710497948",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 801.2395023609178, y = 526.2824577323698},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 101104,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["177607137712010498191"] = {
            key = "177607137712010498191",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1087.75, y = 692.375},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/cbt01/0036_story_renweidaozu",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {}
            }
          },
          ["177607730788911410398"] = {
            key = "177607730788911410398",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1084.625, y = 529.25},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 80260415,
              FlowAssetPath = "",
              TalkType = "Black",
              BlendInTime = 0,
              BlendOutTime = 0,
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              ForceAutoPlay = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["17784850334961953463"] = {
            key = "17784850334961953463",
            type = "SendMessageNode",
            name = "发送消息,夜里",
            pos = {x = 1080.4578575846945, y = 95.54582183184158},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "IcelakeCityNight",
              UnitId = -1
            }
          },
          ["17785737450511951404"] = {
            key = "17785737450511951404",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1093.1684782608695, y = 396.92313664596264},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 1,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {}
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
