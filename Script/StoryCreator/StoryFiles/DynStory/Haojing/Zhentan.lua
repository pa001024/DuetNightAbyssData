return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17599977091141",
      startPort = "StoryStart",
      endStory = "1759997898226326281",
      endPort = "In"
    },
    {
      startStory = "1759997898226326281",
      startPort = "Success",
      endStory = "17599977091145",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17599977091141"] = {
      isStoryNode = true,
      key = "17599977091141",
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
    ["17599977091145"] = {
      isStoryNode = true,
      key = "17599977091145",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1680.5, y = 285.5},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1759997898226326281"] = {
      isStoryNode = true,
      key = "1759997898226326281",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1233.25, y = 284},
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
        bIsDynamicEvent = true,
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
            startQuest = "1759997898226326282",
            startPort = "QuestStart",
            endQuest = "17604122805772292097",
            endPort = "In"
          },
          {
            startQuest = "17604122805772292097",
            startPort = "Out",
            endQuest = "17604122884922292346",
            endPort = "In"
          },
          {
            startQuest = "17604122805772292097",
            startPort = "Out",
            endQuest = "17604125580152292969",
            endPort = "In"
          },
          {
            startQuest = "17604125580152292969",
            startPort = "Option_1",
            endQuest = "17604125782972293481",
            endPort = "In"
          },
          {
            startQuest = "17604125580152292969",
            startPort = "Option_2",
            endQuest = "17604126102152293870",
            endPort = "In"
          },
          {
            startQuest = "17604126827142947919",
            startPort = "Out",
            endQuest = "17604127057182948580",
            endPort = "In"
          },
          {
            startQuest = "17604127057182948580",
            startPort = "Out",
            endQuest = "17604127136882948804",
            endPort = "In"
          },
          {
            startQuest = "17604127136882948804",
            startPort = "Out",
            endQuest = "1759997898226326285",
            endPort = "Success"
          },
          {
            startQuest = "17604125782972293481",
            startPort = "Out",
            endQuest = "17604257463642629",
            endPort = "In"
          },
          {
            startQuest = "17604257463642629",
            startPort = "Out",
            endQuest = "17604126955982948298",
            endPort = "In"
          },
          {
            startQuest = "17604126955982948298",
            startPort = "Out",
            endQuest = "17604126827142947919",
            endPort = "In"
          },
          {
            startQuest = "17604126827142947919",
            startPort = "Out",
            endQuest = "17604258605903647",
            endPort = "In"
          },
          {
            startQuest = "17604282865463276093",
            startPort = "Out",
            endQuest = "17604279169031967675",
            endPort = "In"
          },
          {
            startQuest = "17604279169031967675",
            startPort = "Out",
            endQuest = "17604287360623277166",
            endPort = "In"
          },
          {
            startQuest = "17604287360623277166",
            startPort = "Out",
            endQuest = "17604287665653278051",
            endPort = "In"
          },
          {
            startQuest = "17604287665653278051",
            startPort = "Out",
            endQuest = "1759997898226326285",
            endPort = "Success"
          },
          {
            startQuest = "17604126827142947919",
            startPort = "Out",
            endQuest = "17604282865463276093",
            endPort = "In"
          },
          {
            startQuest = "17604279169031967675",
            startPort = "Out",
            endQuest = "17604127057182948580",
            endPort = "Stop"
          }
        },
        nodeData = {
          ["1759997898226326282"] = {
            key = "1759997898226326282",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1759997898226326285"] = {
            key = "1759997898226326285",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4144.75, y = 324.75},
            propsData = {ModeType = 0}
          },
          ["1759997898226326288"] = {
            key = "1759997898226326288",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3643.0978260869565, y = 1027.2282608695652},
            propsData = {}
          },
          ["17604122805772292097"] = {
            key = "17604122805772292097",
            type = "ChangeStaticCreatorNode",
            name = "生成店长",
            pos = {x = 1141.6666666666667, y = 299.99999999999994},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2010071}
            }
          },
          ["17604122884922292346"] = {
            key = "17604122884922292346",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1633.3333333333335, y = 58.33333333333326},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008001,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17604125580152292969"] = {
            key = "17604125580152292969",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1635.8333333333333, y = 290.1666666666667},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818084,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71008002,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
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
              TalkActors = {},
              OptionType = "branch",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17604125782972293481"] = {
            key = "17604125782972293481",
            type = "ChangeStaticCreatorNode",
            name = "伙计与另一店长",
            pos = {x = 2002.1166666666666, y = 286.5999999999999},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2010072, 2010073}
            }
          },
          ["17604126102152293870"] = {
            key = "17604126102152293870",
            type = "DynamicQuestFailNode",
            name = "动态任务主动失败",
            pos = {x = 2019.4666666666667, y = 633.9999999999999},
            propsData = {UseTalkFadeOut = false, TalkFadeOutTime = 0}
          },
          ["17604126827142947919"] = {
            key = "17604126827142947919",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2859.86231884058, y = 281.9153846153845},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818086,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71008009,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 0.5,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17604126955982948298"] = {
            key = "17604126955982948298",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2552.916666666667, y = 288.1653846153845},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008004,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17604127057182948580"] = {
            key = "17604127057182948580",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3438.6666666666674, y = 286.16538461538454},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818084,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71008014,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17604127136882948804"] = {
            key = "17604127136882948804",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3748.36231884058, y = 290.4697324414715},
            propsData = {
              DialogueId = 71008014,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0
            }
          },
          ["17604257463642629"] = {
            key = "17604257463642629",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2291, y = 292},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2010074,
              GuideType = "M",
              GuidePointName = "Mechanism_Dyn_2010074"
            }
          },
          ["17604258605903647"] = {
            key = "17604258605903647",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3127, y = -98},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008010,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17604279169031967675"] = {
            key = "17604279169031967675",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3280.0652173913045, y = 608.2981366459628},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008011,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17604282865463276093"] = {
            key = "17604282865463276093",
            type = "ListenPlayerFacialActionTagNode",
            name = "监听玩家表情动作标签",
            pos = {x = 2967.6956521739135, y = 596.8260869565217},
            propsData = {
              FacialActionTag = "Hide",
              ListenType = "StaticPoint",
              StaticPointId = 2010074,
              StaticPointListenMinCM = 0,
              StaticPointListenMaxCM = 300
            }
          },
          ["17604287360623277166"] = {
            key = "17604287360623277166",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3572.2670807453414, y = 602.7670807453416},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818084,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              FirstDialogueId = 71008015,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0.5,
              BlendOutTime = 2,
              InType = "BlendIn",
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
              TalkActors = {},
              OptionType = "normal",
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17604287665653278051"] = {
            key = "17604287665653278051",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 3856.8478260869565, y = 597.5496894409938},
            propsData = {
              DialogueId = 71008015,
              UseTalkFadeOut = false,
              TalkFadeOutTime = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
