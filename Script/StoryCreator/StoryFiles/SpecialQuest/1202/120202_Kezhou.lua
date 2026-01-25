return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17621726816933025634",
      startPort = "StoryStart",
      endStory = "17621726816933025636",
      endPort = "In"
    },
    {
      startStory = "17621726816933025636",
      startPort = "Success",
      endStory = "17621726816933025635",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17621726816933025634"] = {
      isStoryNode = true,
      key = "17621726816933025634",
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
    ["17621726816933025635"] = {
      isStoryNode = true,
      key = "17621726816933025635",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17621726816933025636"] = {
      isStoryNode = true,
      key = "17621726816933025636",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1396, y = 298},
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
        bIsShowOnComplete = true,
        bIsPlayBlackScreenOnComplete = false,
        bIsPlayBlackScreenOnFail = false,
        bIsDynamicEvent = false,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17621726816933025641",
            startPort = "Out",
            endQuest = "17621726816933025639",
            endPort = "Fail"
          },
          {
            startQuest = "17621726816933025637",
            startPort = "QuestStart",
            endQuest = "17621726816933025641",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025637",
            startPort = "QuestStart",
            endQuest = "17621726816933025642",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025643",
            startPort = "Out",
            endQuest = "17621726816933025644",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025644",
            startPort = "Out",
            endQuest = "17621726816933025645",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025645",
            startPort = "Out",
            endQuest = "17621726816933025640",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025637",
            startPort = "QuestStart",
            endQuest = "17616366259242009555",
            endPort = "In"
          },
          {
            startQuest = "17616366259242009555",
            startPort = "Out",
            endQuest = "17621726816933025641",
            endPort = "In"
          },
          {
            startQuest = "17621726816933025642",
            startPort = "Out",
            endQuest = "1762154397499652",
            endPort = "In"
          },
          {
            startQuest = "1762154397499652",
            startPort = "Out",
            endQuest = "17621726816933025643",
            endPort = "In"
          }
        },
        nodeData = {
          ["17616366259242009555"] = {
            key = "17616366259242009555",
            type = "MonitorPlayerStatusNode",
            name = "监听玩家状态",
            pos = {x = 1254.6804424517659, y = 812.1465439559764},
            propsData = {
              ListenHPPercent = false,
              ListenESPercent = false,
              ListenSPPercent = false,
              ListenDead = true
            }
          },
          ["1762154397499652"] = {
            key = "1762154397499652",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1479.3485626383078, y = 294.1616507455547},
            propsData = {WaitTime = 10}
          },
          ["17621726816933025637"] = {
            key = "17621726816933025637",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17621726816933025638"] = {
            key = "17621726816933025638",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2277.6470588235306, y = 495.88235294117595},
            propsData = {ModeType = 0}
          },
          ["17621726816933025639"] = {
            key = "17621726816933025639",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1955.909090909091, y = 724.5454545454545},
            propsData = {}
          },
          ["17621726816933025640"] = {
            key = "17621726816933025640",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2252.3441890201393, y = 310.3974316387615},
            propsData = {}
          },
          ["17621726816933025641"] = {
            key = "17621726816933025641",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1662.7111801242233, y = 851.4565217391304},
            propsData = {}
          },
          ["17621726816933025642"] = {
            key = "17621726816933025642",
            type = "ChangeRoleNode",
            name = "切换刻舟",
            pos = {x = 1181.74678313605, y = 293.32853133719186},
            propsData = {QuestRoleId = 24010101, IsPlayFX = false}
          },
          ["17621726816933025643"] = {
            key = "17621726816933025643",
            type = "TalkNode",
            name = "过场动画",
            pos = {x = 1452.5585240449275, y = 443.86603325521173},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC002/SQ_Ver0102_SC002.SQ_Ver0102_SC002'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          ["17621726816933025644"] = {
            key = "17621726816933025644",
            type = "TalkNode",
            name = "【East02_FixSimple_16】刻舟VS应天尉",
            pos = {x = 1717.4220680941824, y = 432.69403602304965},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12048601,
              FlowAssetPath = "",
              TalkType = "FixSimple",
              TalkStageName = "East02_12020201",
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
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17621726816933025645"] = {
            key = "17621726816933025645",
            type = "TalkNode",
            name = "站桩",
            pos = {x = 1982.6247172389462, y = 433.7228350699662},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0102/Ver0102_SC003/Ver0102_SC003.Ver0102_SC003'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = false,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
