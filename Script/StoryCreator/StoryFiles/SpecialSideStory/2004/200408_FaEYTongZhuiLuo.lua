return {
  storyName = "200408_FaEYTongZhuiLuo",
  storyDescription = "",
  lineData = {
    {
      startStory = "17823551146841591909",
      startPort = "StoryStart",
      endStory = "17823551146841591911",
      endPort = "In"
    },
    {
      startStory = "17823551146841591911",
      startPort = "Success",
      endStory = "17823551146841591912",
      endPort = "In"
    },
    {
      startStory = "17823551146841591912",
      startPort = "Success",
      endStory = "17823551146841591913",
      endPort = "In"
    },
    {
      startStory = "17823551146841591915",
      startPort = "Success",
      endStory = "17823551146841591916",
      endPort = "In"
    },
    {
      startStory = "17823551146841591916",
      startPort = "Success",
      endStory = "17823551146841591917",
      endPort = "In"
    },
    {
      startStory = "17823551146841591917",
      startPort = "Success",
      endStory = "17823551146841591918",
      endPort = "In"
    },
    {
      startStory = "17823551146841591923",
      startPort = "Success",
      endStory = "17823551146841591924",
      endPort = "In"
    },
    {
      startStory = "17823551146841591920",
      startPort = "Success",
      endStory = "17823551146841591922",
      endPort = "In"
    },
    {
      startStory = "17823551146841591919",
      startPort = "分支二：如果上文选择了不放过罗连特",
      endStory = "17823551146841591921",
      endPort = "In"
    },
    {
      startStory = "17823551146841591922",
      startPort = "Success",
      endStory = "17823551146841591924",
      endPort = "In"
    },
    {
      startStory = "17823551146841591921",
      startPort = "Success",
      endStory = "17823551146841591923",
      endPort = "In"
    },
    {
      startStory = "17823551146841591926",
      startPort = "Success",
      endStory = "17823551146841591927",
      endPort = "In"
    },
    {
      startStory = "17823551146841591927",
      startPort = "Success",
      endStory = "17823551146841591910",
      endPort = "StoryEnd"
    },
    {
      startStory = "17823551146841591919",
      startPort = "分支一：如果上文选择了放过罗连特，让艾森巴恩做好准备",
      endStory = "17823551146841591920",
      endPort = "In"
    },
    {
      startStory = "17823551146841591918",
      startPort = "Success",
      endStory = "17823551146841591919",
      endPort = "In"
    },
    {
      startStory = "17823551146841591924",
      startPort = "Success",
      endStory = "17823551146841591926",
      endPort = "In"
    },
    {
      startStory = "17823551146841591913",
      startPort = "Success",
      endStory = "17823551146841591915",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17823551146841591909"] = {
      isStoryNode = true,
      key = "17823551146841591909",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200408},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17823551146841591910"] = {
      isStoryNode = true,
      key = "17823551146841591910",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 4722.322393550723, y = 299.1767218849263},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17823551146841591911"] = {
      isStoryNode = true,
      key = "17823551146841591911",
      type = "StoryNode",
      name = "西顿对话开篇",
      pos = {x = 1003.238015138772, y = 92.39697224558455},
      propsData = {
        QuestId = 20040801,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040801",
        QuestDeatil = "Description_20040801",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040801hezi_2480632",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591928",
            startPort = "QuestStart",
            endQuest = "17823551146841591931",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591933",
            startPort = "Out",
            endQuest = "17823551146841591929",
            endPort = "Success"
          },
          {
            startQuest = "17823551146841591931",
            startPort = "Out",
            endQuest = "17823551146841591934",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591934",
            startPort = "Out",
            endQuest = "17823551146841591932",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591932",
            startPort = "Out",
            endQuest = "17823551146841591933",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146841591928"] = {
            key = "17823551146841591928",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591929"] = {
            key = "17823551146841591929",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 106301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17823551146841591930"] = {
            key = "17823551146841591930",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591931"] = {
            key = "17823551146841591931",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1132.389558970441, y = 330.1713580537109},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 2480632,
              GuideType = "M",
              GuidePointName = "Mechanism_20040801hezi_2480632"
            }
          },
          ["17823551146841591932"] = {
            key = "17823551146841591932",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1796.3766916484458, y = 350.4171983526954},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51215001,
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
          ["17823551146841591933"] = {
            key = "17823551146841591933",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2105.170077240766, y = 336.1723282638974},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700580,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040801xidun_2480633",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215002.51215002'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700583,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146841591934"] = {
            key = "17823551146841591934",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1474.0456779558401, y = 381.12815931885643},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {2480633}
            }
          },
          ["17824631070734842686"] = {
            key = "17824631070734842686",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1350.643115345725, y = 156.718951789562},
            propsData = {
              StaticCreatorIdList = {},
              ManualItemIdList = {},
              StateId = 0,
              QuestId = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591912"] = {
      isStoryNode = true,
      key = "17823551146841591912",
      type = "StoryNode",
      name = "前往螺丝刀协会与玛吉对话",
      pos = {x = 1276.7944250871078, y = 88.5017421602788},
      propsData = {
        QuestId = 20040802,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040802",
        QuestDeatil = "Description_20040802",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040802box_242890193",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591938",
            startPort = "Out",
            endQuest = "17823551146841591939",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591939",
            startPort = "Out",
            endQuest = "17823551146841591940",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591935",
            startPort = "QuestStart",
            endQuest = "17834058329854763549",
            endPort = "In"
          },
          {
            startQuest = "17834058329854763549",
            startPort = "Region_1",
            endQuest = "17834058568654764044",
            endPort = "In"
          },
          {
            startQuest = "17834058568654764044",
            startPort = "Out",
            endQuest = "17823551146841591938",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591940",
            startPort = "Out",
            endQuest = "178340788597812700525",
            endPort = "In"
          },
          {
            startQuest = "178340788597812700525",
            startPort = "Out",
            endQuest = "17823551146841591936",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146841591935"] = {
            key = "17823551146841591935",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591936"] = {
            key = "17823551146841591936",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2498.9285714285716, y = 305.35714285714283},
            propsData = {ModeType = 0}
          },
          ["17823551146841591937"] = {
            key = "17823551146841591937",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591938"] = {
            key = "17823551146841591938",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1149.3080427573334, y = 358.58816718552987},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890193,
              GuideType = "M",
              GuidePointName = "Mechanism_20040802box_242890193"
            }
          },
          ["17823551146841591939"] = {
            key = "17823551146841591939",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1402.910543704662, y = 317.0791675644612},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242890194, 242890195}
            }
          },
          ["17823551146841591940"] = {
            key = "17823551146841591940",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1745.5772768344784, y = 320.46929175855365},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700581,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040802maji_242890194",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215035.51215035'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 200002,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 100401,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17834058329854763549"] = {
            key = "17834058329854763549",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1106.13031564713, y = 128.2094781486262},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {106301}
            }
          },
          ["17834058568654764044"] = {
            key = "17834058568654764044",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1380.072844382762, y = 134.93466101174016},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "20040802",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178340788597812700525"] = {
            key = "178340788597812700525",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2044.6001475964802, y = 301.90483641073183},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242890194, 242890195}
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591913"] = {
      isStoryNode = true,
      key = "17823551146841591913",
      type = "StoryNode",
      name = "前往锻铁厂的两处地点去通知工人",
      pos = {x = 1239.142857142857, y = 300.61224489795916},
      propsData = {
        QuestId = 20040803,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040803",
        QuestDeatil = "Description_20040803",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_20040803gongren1_242890198",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591941",
            startPort = "QuestStart",
            endQuest = "17823551146841591945",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591945",
            startPort = "Out",
            endQuest = "17823551146841591947",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591947",
            startPort = "Out",
            endQuest = "17823551146841591944",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591944",
            startPort = "Out",
            endQuest = "17823551146841591946",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591946",
            startPort = "Out",
            endQuest = "17823551146841591942",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146841591941"] = {
            key = "17823551146841591941",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591942"] = {
            key = "17823551146841591942",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591943"] = {
            key = "17823551146841591943",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591944"] = {
            key = "17823551146841591944",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2020.8466441775804, y = 411.61424673021617},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700586,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040803gongren3_242890197",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215084.51215084'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146841591945"] = {
            key = "17823551146841591945",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1238.5039668320426, y = 387.92304408592423},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                242890196,
                242890197,
                242890198
              }
            }
          },
          ["17823551146841591946"] = {
            key = "17823551146841591946",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2432.4589630181604, y = 331.3081826569897},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215090.51215090'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1.5,
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
              CloseMotionBlur = false,
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
          ["17823551146841591947"] = {
            key = "17823551146841591947",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1602.2723455034918, y = 414.44059501062986},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700584,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040803gongren1_242890196",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215078.51215078'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591914"] = {
      isStoryNode = true,
      key = "17823551146841591914",
      type = "StoryNode",
      name = "两处对话结束黑屏进一个站桩对话",
      pos = {x = 1458.3055555555557, y = 465.55555555555543},
      propsData = {
        QuestId = 20040804,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040804",
        QuestDeatil = "Description_20040804",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591948",
            startPort = "QuestStart",
            endQuest = "17823551146841591951",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146841591948"] = {
            key = "17823551146841591948",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591949"] = {
            key = "17823551146841591949",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591950"] = {
            key = "17823551146841591950",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591951"] = {
            key = "17823551146841591951",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1245.9285714285716, y = 379.07142857142856},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591915"] = {
      isStoryNode = true,
      key = "17823551146841591915",
      type = "StoryNode",
      name = "回到一开始与玛吉和罗连特对话的地方",
      pos = {x = 1640.3568249376085, y = 302.82392026578077},
      propsData = {
        QuestId = 20040805,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040805",
        QuestDeatil = "Description_20040805",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040802box_242890193",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591952",
            startPort = "QuestStart",
            endQuest = "17823551146841591955",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591955",
            startPort = "Out",
            endQuest = "17823551146841591956",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591956",
            startPort = "Out",
            endQuest = "17823551146841591953",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146841591952"] = {
            key = "17823551146841591952",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591953"] = {
            key = "17823551146841591953",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591954"] = {
            key = "17823551146841591954",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591955"] = {
            key = "17823551146841591955",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1425.3106060606062, y = 313.8787878787878},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890193,
              GuideType = "M",
              GuidePointName = "Mechanism_20040802box_242890193"
            }
          },
          ["17823551146841591956"] = {
            key = "17823551146841591956",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1954.8766233766237, y = 294.38852813852805},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215094.51215094'",
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
              CloseMotionBlur = false,
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
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591916"] = {
      isStoryNode = true,
      key = "17823551146841591916",
      type = "StoryNode",
      name = "几句开车，引导玩家到附近合适的地方",
      pos = {x = 1897.2093023255813, y = 302.7906976744186},
      propsData = {
        QuestId = 20040806,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040806",
        QuestDeatil = "Description_20040806",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040806box1_242890199",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591957",
            startPort = "QuestStart",
            endQuest = "17823551146841591960",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591960",
            startPort = "Out",
            endQuest = "17823551146841591961",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591963",
            startPort = "Out",
            endQuest = "17823551146841591958",
            endPort = "Success"
          },
          {
            startQuest = "17823551146841591961",
            startPort = "Out",
            endQuest = "17823551146841591963",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146841591957"] = {
            key = "17823551146841591957",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591958"] = {
            key = "17823551146841591958",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591959"] = {
            key = "17823551146841591959",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591960"] = {
            key = "17823551146841591960",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1307.5162907268168, y = 348.10452602093494},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890199,
              GuideType = "M",
              GuidePointName = "Mechanism_20040806box1_242890199"
            }
          },
          ["17823551146841591961"] = {
            key = "17823551146841591961",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1740.28216374269, y = 378.0648434812524},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51215101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17823551146841591962"] = {
            key = "17823551146841591962",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1960.5738304093566, y = 98.34262125903012},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890200,
              GuideType = "M",
              GuidePointName = "Mechanism_20040806box2_242890200"
            }
          },
          ["17823551146841591963"] = {
            key = "17823551146841591963",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2222.9904970760235, y = 365.06484348125235},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51215103,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17823551146841591964"] = {
            key = "17823551146841591964",
            type = "PlatformJudgmentNode",
            name = "PC/手机平台判断(云游戏视为手机)",
            pos = {x = 1958.1054614941402, y = 765.3095764131131},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591917"] = {
      isStoryNode = true,
      key = "17823551146841591917",
      type = "StoryNode",
      name = "走到罗连特附近触发站桩",
      pos = {x = 2120.242914979757, y = 300.7692307692308},
      propsData = {
        QuestId = 20040807,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040807",
        QuestDeatil = "Description_20040807",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040806box3_242890201",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591969",
            startPort = "Out",
            endQuest = "17823551146841591966",
            endPort = "Success"
          },
          {
            startQuest = "17823551146841591965",
            startPort = "QuestStart",
            endQuest = "178340803191612701620",
            endPort = "In"
          },
          {
            startQuest = "178340803191612701620",
            startPort = "Out",
            endQuest = "17823551146841591969",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146841591965"] = {
            key = "17823551146841591965",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591966"] = {
            key = "17823551146841591966",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591967"] = {
            key = "17823551146841591967",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146841591968"] = {
            key = "17823551146841591968",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1172.181818181818, y = 485.0363636363635},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890201,
              GuideType = "M",
              GuidePointName = "Mechanism_20040806box3_242890201"
            }
          },
          ["17823551146841591969"] = {
            key = "17823551146841591969",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1676.0495689655172, y = 323.33380923798836},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215106.51215106'",
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
              HideMechanismsFX = false,
              ShowSkipButton = true,
              ShowAutoPlayButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              SkipToOption = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
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
          ["178340803191612701620"] = {
            key = "178340803191612701620",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1248.1227272727272, y = 198.8493506493507},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890200,
              GuideType = "M",
              GuidePointName = "Mechanism_20040806box2_242890200"
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591918"] = {
      isStoryNode = true,
      key = "17823551146841591918",
      type = "StoryNode",
      name = "与车站警卫战斗，对话",
      pos = {x = 2374.300015890672, y = 291.2208576422782},
      propsData = {
        QuestId = 20040808,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040808",
        QuestDeatil = "Description_20040808",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040808box_242890202",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146841591970",
            startPort = "QuestStart",
            endQuest = "17823551146841591973",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591973",
            startPort = "Out",
            endQuest = "17823551146841591974",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591974",
            startPort = "Success",
            endQuest = "17823551146841591975",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591976",
            startPort = "Out",
            endQuest = "17823551146841591971",
            endPort = "Success"
          },
          {
            startQuest = "17823551146841591977",
            startPort = "Out",
            endQuest = "17823551146841591971",
            endPort = "Success"
          },
          {
            startQuest = "17823551146841591975",
            startPort = "Option_1",
            endQuest = "17823551146841591976",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591975",
            startPort = "Option_2",
            endQuest = "17823551146841591977",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591974",
            startPort = "Fail",
            endQuest = "17836721452641592599",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591974",
            startPort = "PassiveFail",
            endQuest = "17836721452641592599",
            endPort = "In"
          },
          {
            startQuest = "17836721452641592599",
            startPort = "Out",
            endQuest = "17823551146841591972",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17823551146841591970"] = {
            key = "17823551146841591970",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591971"] = {
            key = "17823551146841591971",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3069.760442260442, y = 289.465601965602},
            propsData = {ModeType = 0}
          },
          ["17823551146841591972"] = {
            key = "17823551146841591972",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2550.673076923077, y = 704.0384615384614},
            propsData = {}
          },
          ["17823551146841591973"] = {
            key = "17823551146841591973",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1397.8858581908376, y = 325.46695287931004},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890202,
              GuideType = "M",
              GuidePointName = "Mechanism_20040808box_242890202"
            }
          },
          ["17823551146841591974"] = {
            key = "17823551146841591974",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1786.1622557063654, y = 341.1191267923535},
            propsData = {SpecialConfigId = 20040808, BlackScreenImmediately = false}
          },
          ["17823551146841591975"] = {
            key = "17823551146841591975",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2176.7036084343877, y = 272.6342519739397},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215133.51215133'",
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
              SkipToOption = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17823551146841591976"] = {
            key = "17823551146841591976",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2537.7914233209935, y = 183.72294548395345},
            propsData = {VarName = "FAET", VarValue = 1}
          },
          ["17823551146841591977"] = {
            key = "17823551146841591977",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2530.3533215774346, y = 370.32497095002117},
            propsData = {VarName = "FAET", VarValue = 2}
          },
          ["17836721452641592599"] = {
            key = "17836721452641592599",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2172.837382779199, y = 589.0287723785169},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "20040808",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591919"] = {
      isStoryNode = true,
      key = "17823551146841591919",
      type = "StoryNode",
      name = "前往站厅，站厅中汽笛沙龙组织的戏剧即将开始表演",
      pos = {x = 2671.1240402834246, y = 243.8410373820709},
      propsData = {
        QuestId = 20040809,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040809",
        QuestDeatil = "Description_20040809",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040809hezi_242480634",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851591983",
            startPort = "true",
            endQuest = "17823551146851591981",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591983",
            startPort = "false",
            endQuest = "17823551146851591984",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591984",
            startPort = "true",
            endQuest = "17823551146851591982",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591984",
            startPort = "false",
            endQuest = "17823551146851591981",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591978",
            startPort = "QuestStart",
            endQuest = "17823551146851591985",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591985",
            startPort = "Out",
            endQuest = "17823551146851591986",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591986",
            startPort = "Out",
            endQuest = "17823551146851591983",
            endPort = "In"
          },
          {
            startQuest = "17823551146841591978",
            startPort = "QuestStart",
            endQuest = "17823550797362965",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823550797362965"] = {
            key = "17823550797362965",
            type = "ChangeStaticCreatorNode",
            name = "生成氛围",
            pos = {x = 1115.3684210526317, y = 163.1578947368423},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2480656,
                2480657,
                2480658,
                2480659,
                2480660,
                2480661,
                2480662,
                2480663,
                2480664,
                2480665,
                2480666,
                2480667,
                2480668,
                2480669,
                2480670,
                2480671,
                2480672,
                2480673,
                2480674,
                2480675,
                2480676,
                2480677,
                2480678,
                2480679,
                2480680,
                2480681,
                2480682,
                2480683,
                2480684,
                2480686,
                2480687,
                2480688,
                2480689,
                2480690,
                2480691,
                2480692,
                2480693,
                2480694,
                2480695,
                2480696
              }
            }
          },
          ["17823551146841591978"] = {
            key = "17823551146841591978",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146841591979"] = {
            key = "17823551146841591979",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2873.7837837837837, y = 305.6756756756757},
            propsData = {ModeType = 0}
          },
          ["17823551146851591980"] = {
            key = "17823551146851591980",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851591981"] = {
            key = "17823551146851591981",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 2582.9656019656018, y = 275.1326781326781},
            propsData = {
              PortName = "分支一：如果上文选择了放过罗连特，让艾森巴恩做好准备"
            }
          },
          ["17823551146851591982"] = {
            key = "17823551146851591982",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 2579.269692152045, y = 527.4051976441683},
            propsData = {
              PortName = "分支二：如果上文选择了不放过罗连特"
            }
          },
          ["17823551146851591983"] = {
            key = "17823551146851591983",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1874.5822576224375, y = 324.37770754150085},
            propsData = {
              FunctionName = "Equal",
              VarName = "FAET",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17823551146851591984"] = {
            key = "17823551146851591984",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 2149.475739040763, y = 517.0356767170965},
            propsData = {
              FunctionName = "Equal",
              VarName = "FAET",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17823551146851591985"] = {
            key = "17823551146851591985",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1103.7792663946925, y = 312.7264230288107},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242480634,
              GuideType = "M",
              GuidePointName = "Mechanism_20040809hezi_242480634"
            }
          },
          ["17823551146851591986"] = {
            key = "17823551146851591986",
            type = "TalkNode",
            name = "前往站厅，站厅中汽笛沙龙组织的戏剧即将开始表演",
            pos = {x = 1465.9486212334023, y = 362.22597500013694},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215195.51215195'",
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
              CloseMotionBlur = false,
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
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591920"] = {
      isStoryNode = true,
      key = "17823551146841591920",
      type = "StoryNode",
      name = "任务节点10",
      pos = {x = 2986.9993230707514, y = 132.41262598405464},
      propsData = {
        QuestId = 20040810,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040810",
        QuestDeatil = "Description_20040810",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_20040810bai_242480636",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851591992",
            startPort = "Out",
            endQuest = "17823551146851591993",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591994",
            startPort = "Out",
            endQuest = "17823551146851591995",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591993",
            startPort = "Out",
            endQuest = "17823551146851591994",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591987",
            startPort = "QuestStart",
            endQuest = "17823551146851591996",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591996",
            startPort = "Out",
            endQuest = "17823551146851591990",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591990",
            startPort = "Out",
            endQuest = "17823551146851591997",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591997",
            startPort = "Out",
            endQuest = "17823551146851591992",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591995",
            startPort = "Out",
            endQuest = "17823551146851591998",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591998",
            startPort = "Out",
            endQuest = "17823551146851591991",
            endPort = "In"
          },
          {
            startQuest = "17823551146851591991",
            startPort = "Out",
            endQuest = "178340924919017463270",
            endPort = "In"
          },
          {
            startQuest = "178340924919017463270",
            startPort = "Out",
            endQuest = "17823551146851591988",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146851591987"] = {
            key = "17823551146851591987",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851591988"] = {
            key = "17823551146851591988",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851591989"] = {
            key = "17823551146851591989",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851591990"] = {
            key = "17823551146851591990",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1060.783926218709, y = 304.39393939393943},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700595,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040810bai_242480636",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215215.51215215'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146851591991"] = {
            key = "17823551146851591991",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2527.461667541415, y = 398.69046167359676},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700595,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040810bai_242480636",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215230.51215230'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146851591992"] = {
            key = "17823551146851591992",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1371.2697113373542, y = 331.71899010387887},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {242480637},
              QuestPickupId = -1,
              UnitId = 11301,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Drop_20040810pick1_242480637DDD",
              IsUseCount = false
            }
          },
          ["17823551146851591993"] = {
            key = "17823551146851591993",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1655.06281478563, y = 365.8569211383616},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215220.51215220'",
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
              CloseMotionBlur = false,
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
          ["17823551146851591994"] = {
            key = "17823551146851591994",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1929.7754584637912, y = 394.5925533222697},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {242480638},
              QuestPickupId = -1,
              UnitId = 11302,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "Drop_20040810pick2_242480638DD",
              IsUseCount = false
            }
          },
          ["17823551146851591995"] = {
            key = "17823551146851591995",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2203.568561912067, y = 428.73048435675247},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215226.51215226'",
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
              CloseMotionBlur = false,
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
          ["17823551146851591996"] = {
            key = "17823551146851591996",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 1082.2899270167177, y = 105.14164588608321},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          },
          ["17823551146851591997"] = {
            key = "17823551146851591997",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 1360.7854419750806, y = 196.09792247703479},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          },
          ["17823551146851591998"] = {
            key = "17823551146851591998",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 2357.8262583016117, y = 222.2713918647899},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          },
          ["178340924919017463270"] = {
            key = "178340924919017463270",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 2687.345585048674, y = 66.04436872371667},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591921"] = {
      isStoryNode = true,
      key = "17823551146841591921",
      type = "StoryNode",
      name = "任务节点11",
      pos = {x = 2969.100439882698, y = 348.5454545454545},
      propsData = {
        QuestId = 20040811,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "QuestName_10020503",
        QuestDeatil = "Description_20040811",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_20040811xidun_242480640",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851591999",
            startPort = "QuestStart",
            endQuest = "17823551146851592004",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592004",
            startPort = "Out",
            endQuest = "17839248188231592871",
            endPort = "In"
          },
          {
            startQuest = "17839248188231592871",
            startPort = "Out",
            endQuest = "17823551146851592002",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592003",
            startPort = "Out",
            endQuest = "17839287104974768648",
            endPort = "In"
          },
          {
            startQuest = "17839287104974768648",
            startPort = "Out",
            endQuest = "17823551146851592000",
            endPort = "Success"
          },
          {
            startQuest = "17823551146851592002",
            startPort = "Out",
            endQuest = "17839310783976356543",
            endPort = "In"
          },
          {
            startQuest = "17839310783976356543",
            startPort = "Out",
            endQuest = "17823551146851592003",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146851591999"] = {
            key = "17823551146851591999",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592000"] = {
            key = "17823551146851592000",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592001"] = {
            key = "17823551146851592001",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592002"] = {
            key = "17823551146851592002",
            type = "TalkNode",
            name = "跟奥特赛德说话",
            pos = {x = 1620.7187512098233, y = 333.49028987719856},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700583,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040810aote_242480635",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215233.51215233'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146851592003"] = {
            key = "17823551146851592003",
            type = "TalkNode",
            name = "跟西顿说话",
            pos = {x = 2223.6457720111634, y = 352.037860727401},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700580,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040811xidun_242480640",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215236.51215236'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146851592004"] = {
            key = "17823551146851592004",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1151.0800371687633, y = 326.77897932030896},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480640}
            }
          },
          ["17839248188231592871"] = {
            key = "17839248188231592871",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 1321.5361480147844, y = 141.39506894646559},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          },
          ["17839287104974768648"] = {
            key = "17839287104974768648",
            type = "ChangeStaticCreatorNode",
            name = "奥哥小白",
            pos = {x = 2255.4342943961387, y = 112.92493518217907},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480636, 242480635}
            }
          },
          ["17839310783976356543"] = {
            key = "17839310783976356543",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1903.8764126227402, y = 170.37567409843518},
            propsData = {
              NewDescription = "Content_20040811",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591922"] = {
      isStoryNode = true,
      key = "17823551146841591922",
      type = "StoryNode",
      name = "分支一",
      pos = {x = 3263.303091397849, y = 132.5000000000001},
      propsData = {
        QuestId = 20040812,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040812",
        QuestDeatil = "Description_20040812",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040812hezi_242480639",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592005",
            startPort = "QuestStart",
            endQuest = "17823551146851592008",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592008",
            startPort = "Out",
            endQuest = "17823551146851592009",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592009",
            startPort = "Out",
            endQuest = "17823551146851592010",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592010",
            startPort = "Out",
            endQuest = "17823551146851592006",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146851592005"] = {
            key = "17823551146851592005",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592006"] = {
            key = "17823551146851592006",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592007"] = {
            key = "17823551146851592007",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592008"] = {
            key = "17823551146851592008",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1173.7826381094112, y = 273.49536069066943},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242480639,
              GuideType = "M",
              GuidePointName = "Mechanism_20040812hezi_242480639"
            }
          },
          ["17823551146851592009"] = {
            key = "17823551146851592009",
            type = "TalkNode",
            name = "回舞台",
            pos = {x = 1542.830812157585, y = 322.3842495795583},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215250.51215250'",
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
              CloseMotionBlur = false,
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
          ["17823551146851592010"] = {
            key = "17823551146851592010",
            type = "TalkNode",
            name = "站桩a",
            pos = {x = 1963.3098248706406, y = 349.0509162462249},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215258.51215258'",
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
              CloseMotionBlur = false,
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
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591923"] = {
      isStoryNode = true,
      key = "17823551146841591923",
      type = "StoryNode",
      name = "分支二",
      pos = {x = 3292.3809523809527, y = 352.49999999999994},
      propsData = {
        QuestId = 20040813,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040813",
        QuestDeatil = "Description_20040813",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040812hezi_242480639",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592014",
            startPort = "Out",
            endQuest = "17823551146851592015",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592015",
            startPort = "Out",
            endQuest = "17823551146851592016",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592011",
            startPort = "QuestStart",
            endQuest = "17823551146851592014",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592016",
            startPort = "Out",
            endQuest = "17823551146851592012",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823551146851592011"] = {
            key = "17823551146851592011",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592012"] = {
            key = "17823551146851592012",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592013"] = {
            key = "17823551146851592013",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592014"] = {
            key = "17823551146851592014",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1330.7982026143789, y = 325.5065359477124},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242480639,
              GuideType = "M",
              GuidePointName = "Mechanism_20040812hezi_242480639"
            }
          },
          ["17823551146851592015"] = {
            key = "17823551146851592015",
            type = "TalkNode",
            name = "回舞台",
            pos = {x = 1702.6151064084165, y = 372.93201020245493},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215250.51215250'",
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
              CloseMotionBlur = false,
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
          ["17823551146851592016"] = {
            key = "17823551146851592016",
            type = "TalkNode",
            name = "站桩b",
            pos = {x = 2118.6870915032678, y = 401.0620915032679},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215269.51215269'",
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
              CloseMotionBlur = false,
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
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591924"] = {
      isStoryNode = true,
      key = "17823551146841591924",
      type = "StoryNode",
      name = "战斗",
      pos = {x = 3657.912596807333, y = 305.6756756756757},
      propsData = {
        QuestId = 20040814,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040814",
        QuestDeatil = "Description_20040814",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040814spbox_242480641",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592020",
            startPort = "Out",
            endQuest = "17823551146851592021",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592021",
            startPort = "Success",
            endQuest = "17823551146851592022",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592022",
            startPort = "Out",
            endQuest = "17823551146851592018",
            endPort = "Success"
          },
          {
            startQuest = "17823551146851592017",
            startPort = "QuestStart",
            endQuest = "17823551146851592020",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592017",
            startPort = "QuestStart",
            endQuest = "17823743177573498",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592021",
            startPort = "Fail",
            endQuest = "17836724705013180471",
            endPort = "In"
          },
          {
            startQuest = "17836724705013180471",
            startPort = "Out",
            endQuest = "17823551146851592019",
            endPort = "Fail"
          },
          {
            startQuest = "17823551146851592021",
            startPort = "PassiveFail",
            endQuest = "17836724705013180471",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146851592017"] = {
            key = "17823551146851592017",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592018"] = {
            key = "17823551146851592018",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592019"] = {
            key = "17823551146851592019",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2592.8416149068325, y = 530.1086956521739},
            propsData = {}
          },
          ["17823551146851592020"] = {
            key = "17823551146851592020",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1295.6638184918236, y = 356.98267844687274},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242480641,
              GuideType = "M",
              GuidePointName = "Mechanism_20040814spbox_242480641"
            }
          },
          ["17823551146851592021"] = {
            key = "17823551146851592021",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "突破艾森巴恩卫队包围",
            pos = {x = 1787.1234458210163, y = 397.65038031022675},
            propsData = {SpecialConfigId = 20040814, BlackScreenImmediately = false}
          },
          ["17823551146851592022"] = {
            key = "17823551146851592022",
            type = "TalkNode",
            name = "结束战斗后进站桩",
            pos = {x = 2468.1474497901927, y = 328.0462648604592},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215291.51215291'",
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
              CloseMotionBlur = false,
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
          ["17823743177573498"] = {
            key = "17823743177573498",
            type = "ChangeStaticCreatorNode",
            name = "生成氛围",
            pos = {x = 1303.7390626210959, y = 164.75797571993218},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2480656,
                2480657,
                2480658,
                2480659,
                2480660,
                2480661,
                2480662,
                2480663,
                2480664,
                2480665,
                2480666,
                2480667,
                2480668,
                2480669,
                2480670,
                2480671,
                2480672,
                2480673,
                2480674,
                2480675,
                2480676,
                2480677,
                2480678,
                2480679,
                2480680,
                2480681,
                2480682,
                2480683,
                2480684,
                2480686,
                2480687,
                2480688,
                2480689,
                2480690,
                2480691,
                2480692,
                2480693,
                2480694,
                2480695,
                2480696
              }
            }
          },
          ["17836724705013180471"] = {
            key = "17836724705013180471",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2214.194465935646, y = 550.1119378812874},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "20040814",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591925"] = {
      isStoryNode = true,
      key = "17823551146841591925",
      type = "StoryNode",
      name = "结束战斗后进站桩，具体的位置任务同学确定合适的点位即可",
      pos = {x = 3916.9767441860463, y = 137.83720930232568},
      propsData = {
        QuestId = 20040815,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040815",
        QuestDeatil = "Description_20040815",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592023",
            startPort = "QuestStart",
            endQuest = "17823551146851592028",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146851592023"] = {
            key = "17823551146851592023",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592024"] = {
            key = "17823551146851592024",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592025"] = {
            key = "17823551146851592025",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592026"] = {
            key = "17823551146851592026",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1744.9428565164364, y = 550.5169323710346},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["17823551146851592027"] = {
            key = "17823551146851592027",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1685.77618984977, y = 268.34545801206},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17823551146851592028"] = {
            key = "17823551146851592028",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1194.841707091149, y = 309.0782166327498},
            propsData = {
              FunctionName = "",
              VarName = "",
              Duration = 0,
              VarInfos = {}
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591926"] = {
      isStoryNode = true,
      key = "17823551146841591926",
      type = "StoryNode",
      name = "和白以及奥特赛德对话",
      pos = {x = 4032.1541751835875, y = 354.1280451574569},
      propsData = {
        QuestId = 20040816,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040816",
        QuestDeatil = "Description_20040816",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_20040816aote_242480642",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592029",
            startPort = "QuestStart",
            endQuest = "17823551146851592032",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592032",
            startPort = "Out",
            endQuest = "17823551146851592033",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592033",
            startPort = "Out",
            endQuest = "17823551146851592030",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17823550896883347"] = {
            key = "17823550896883347",
            type = "ChangeStaticCreatorNode",
            name = "生成氛围",
            pos = {x = 2350, y = 756},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                2480656,
                2480657,
                2480658,
                2480659,
                2480660,
                2480661,
                2480662,
                2480663,
                2480664,
                2480665,
                2480666,
                2480667,
                2480668,
                2480669,
                2480670,
                2480671,
                2480672,
                2480673,
                2480674,
                2480675,
                2480676,
                2480677,
                2480678,
                2480679,
                2480680,
                2480681,
                2480682,
                2480683,
                2480684,
                2480686,
                2480687,
                2480688,
                2480689,
                2480690,
                2480691,
                2480692,
                2480693,
                2480694,
                2480695,
                2480696
              }
            }
          },
          ["17823551146851592029"] = {
            key = "17823551146851592029",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592030"] = {
            key = "17823551146851592030",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 106301,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17823551146851592031"] = {
            key = "17823551146851592031",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592032"] = {
            key = "17823551146851592032",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1287.2888655462184, y = 331.79516806722677},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242480642, 242480643}
            }
          },
          ["17823551146851592033"] = {
            key = "17823551146851592033",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1956.233566007048, y = 345.2513892653835},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700595,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040816aote_242480642",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215347.51215347'",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
              OutType = "BlendOut",
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17823551146841591927"] = {
      isStoryNode = true,
      key = "17823551146841591927",
      type = "StoryNode",
      name = "回到螺丝刀协会驻地与玛吉和克罗格对话",
      pos = {x = 4392.494217847752, y = 336.51112994373034},
      propsData = {
        QuestId = 20040817,
        QuestDescriptionComment = "收束线·法厄同的坠落（ai配置）",
        QuestDescription = "Content_20040817",
        QuestDeatil = "Description_20040817",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = true,
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_20040817box_242890204",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17823551146851592037",
            startPort = "Out",
            endQuest = "17823551146851592038",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592038",
            startPort = "Out",
            endQuest = "17823551146851592039",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592039",
            startPort = "Out",
            endQuest = "17823551146851592035",
            endPort = "Success"
          },
          {
            startQuest = "178340985715320637971",
            startPort = "Region_1",
            endQuest = "178340985715320637972",
            endPort = "In"
          },
          {
            startQuest = "17823551146851592034",
            startPort = "QuestStart",
            endQuest = "178340985715320637971",
            endPort = "In"
          },
          {
            startQuest = "178340985715320637972",
            startPort = "Out",
            endQuest = "17823551146851592037",
            endPort = "In"
          }
        },
        nodeData = {
          ["17823551146851592034"] = {
            key = "17823551146851592034",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17823551146851592035"] = {
            key = "17823551146851592035",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2793.0798319327732, y = 296.546218487395},
            propsData = {ModeType = 0}
          },
          ["17823551146851592036"] = {
            key = "17823551146851592036",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17823551146851592037"] = {
            key = "17823551146851592037",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1136.6524562394127, y = 346.0446428571429},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242890204,
              GuideType = "M",
              GuidePointName = "Mechanism_20040817box_242890204"
            }
          },
          ["17823551146851592038"] = {
            key = "17823551146851592038",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1514.2464738302335, y = 415.87839313286906},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {242890206, 242890205}
            }
          },
          ["17823551146851592039"] = {
            key = "17823551146851592039",
            type = "TalkNode",
            name = "回到螺丝刀协会驻地与玛吉和克罗格对话",
            pos = {x = 2007.9350422063021, y = 439.20180583128166},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700581,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_20040817maji_242890206",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200408/51215352.51215352'",
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
              CloseMotionBlur = false,
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
          ["17824583398884839483"] = {
            key = "17824583398884839483",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1881.313090362324, y = 164.43394095138166},
            propsData = {
              MessageType = "GameMode",
              MessageContent = -1,
              UnitId = -1
            }
          },
          ["178340985715320637971"] = {
            key = "178340985715320637971",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = 1090.52046670515, y = 77.50833373420235},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {106301}
            }
          },
          ["178340985715320637972"] = {
            key = "178340985715320637972",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1364.4629954407822, y = 84.23351659731631},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "20040802",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
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
