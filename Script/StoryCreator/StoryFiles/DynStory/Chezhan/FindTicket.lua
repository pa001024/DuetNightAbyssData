return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17587843543131",
      startPort = "StoryStart",
      endStory = "1758784455796166",
      endPort = "In"
    },
    {
      startStory = "1758784455796166",
      startPort = "Success",
      endStory = "17587843543145",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17587843543131"] = {
      isStoryNode = true,
      key = "17587843543131",
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
    ["17587843543145"] = {
      isStoryNode = true,
      key = "17587843543145",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1564, y = 294},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1758784455796166"] = {
      isStoryNode = true,
      key = "1758784455796166",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1074.8, y = 226},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "DynQuest_FindTicket_Des",
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
        bIsDynamicEvent = true,
        ResurgencePoint = "",
        bUseQuestCoordinate = false,
        bDeadTriggerQuestFail = false,
        IsFairyLand = false,
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1758784455796167",
            startPort = "QuestStart",
            endQuest = "1758784621367219",
            endPort = "In"
          },
          {
            startQuest = "1758784621367219",
            startPort = "Out",
            endQuest = "1758784642784477",
            endPort = "In"
          },
          {
            startQuest = "1758784621367219",
            startPort = "Out",
            endQuest = "1758784654973811",
            endPort = "In"
          },
          {
            startQuest = "1758784654973811",
            startPort = "Option_1",
            endQuest = "17587850413491450",
            endPort = "In"
          },
          {
            startQuest = "17587850413491450",
            startPort = "Out",
            endQuest = "17587851390782050",
            endPort = "In"
          },
          {
            startQuest = "17587851390782050",
            startPort = "Out",
            endQuest = "17587851501072400",
            endPort = "In"
          },
          {
            startQuest = "17587850413491450",
            startPort = "Out",
            endQuest = "17587851601462744",
            endPort = "In"
          },
          {
            startQuest = "17587850413491450",
            startPort = "Out",
            endQuest = "17587851626282843",
            endPort = "In"
          },
          {
            startQuest = "17587851601462744",
            startPort = "Out",
            endQuest = "17587851675803046",
            endPort = "In"
          },
          {
            startQuest = "17587851626282843",
            startPort = "Out",
            endQuest = "17587851740993276",
            endPort = "In"
          },
          {
            startQuest = "17587851501072400",
            startPort = "Out",
            endQuest = "17587851858653478",
            endPort = "Input_1"
          },
          {
            startQuest = "17587851675803046",
            startPort = "Out",
            endQuest = "17587851858653478",
            endPort = "Input_2"
          },
          {
            startQuest = "17587851740993276",
            startPort = "Out",
            endQuest = "17587851858653478",
            endPort = "Input_3"
          },
          {
            startQuest = "1758784654973811",
            startPort = "Option_2",
            endQuest = "17587852028174024",
            endPort = "In"
          },
          {
            startQuest = "17587851858653478",
            startPort = "Out",
            endQuest = "17587852155314449",
            endPort = "In"
          },
          {
            startQuest = "17587852155314449",
            startPort = "Out",
            endQuest = "17587852634654824",
            endPort = "In"
          },
          {
            startQuest = "17587853804126452",
            startPort = "Out",
            endQuest = "1758784455796174",
            endPort = "Success"
          },
          {
            startQuest = "17587852155314449",
            startPort = "Out",
            endQuest = "17587898066033277422",
            endPort = "In"
          },
          {
            startQuest = "17587851501072400",
            startPort = "Out",
            endQuest = "17588686251221312423",
            endPort = "In"
          },
          {
            startQuest = "17587851675803046",
            startPort = "Out",
            endQuest = "17588686502501312962",
            endPort = "In"
          },
          {
            startQuest = "17587851740993276",
            startPort = "Out",
            endQuest = "17588686525471313053",
            endPort = "In"
          },
          {
            startQuest = "1761034554074661040",
            startPort = "Out",
            endQuest = "1758784455796174",
            endPort = "Success"
          },
          {
            startQuest = "1775789404497910903",
            startPort = "Out",
            endQuest = "17587853804126452",
            endPort = "In"
          },
          {
            startQuest = "1775789413019911102",
            startPort = "Out",
            endQuest = "1761034554074661040",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_1",
            endQuest = "17757923762108167105",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_1",
            endQuest = "1775789404497910903",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_2",
            endQuest = "1775789413019911102",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_3",
            endQuest = "1775789413019911102",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_2",
            endQuest = "17757923807538167260",
            endPort = "In"
          },
          {
            startQuest = "17587852634654824",
            startPort = "Option_3",
            endQuest = "17757923807538167260",
            endPort = "In"
          }
        },
        nodeData = {
          ["1758784455796167"] = {
            key = "1758784455796167",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1758784455796174"] = {
            key = "1758784455796174",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4768.112280701755, y = 359.90877192982464},
            propsData = {ModeType = 0}
          },
          ["1758784455796181"] = {
            key = "1758784455796181",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 4795.090058479533, y = 835.153216374269},
            propsData = {}
          },
          ["1758784621367219"] = {
            key = "1758784621367219",
            type = "ChangeStaticCreatorNode",
            name = "生成找失物npc",
            pos = {x = 1161.0545454545454, y = 301.39565217391305},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480124}
            }
          },
          ["1758784642784477"] = {
            key = "1758784642784477",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1477.4999999999998, y = 68.5},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008901,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1758784654973811"] = {
            key = "1758784654973811",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1487.1000000000001, y = 295.30000000000007},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818095,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480124",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008902,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17587850413491450"] = {
            key = "17587850413491450",
            type = "ChangeStaticCreatorNode",
            name = "生成搜寻点",
            pos = {x = 1848.3000000000004, y = 291.69999999999993},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                292480125,
                292480126,
                292480127
              }
            }
          },
          ["17587851390782050"] = {
            key = "17587851390782050",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2232.3, y = -5.900000000000031},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 292480125,
              StateId = 780581,
              IsGuideEnable = true,
              GuidePointName = "Mechanism_Dyn_292480125"
            }
          },
          ["17587851501072400"] = {
            key = "17587851501072400",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2542.2, y = 13.299999999999882},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008912,
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["17587851601462744"] = {
            key = "17587851601462744",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2233.1, y = 309.6999999999999},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 292480126,
              StateId = 780581,
              IsGuideEnable = true,
              GuidePointName = "Mechanism_Dyn_292480126"
            }
          },
          ["17587851626282843"] = {
            key = "17587851626282843",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 2232.609090909091, y = 607.4636363636363},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 292480127,
              StateId = 780581,
              IsGuideEnable = true,
              GuidePointName = "Mechanism_Dyn_292480127"
            }
          },
          ["17587851675803046"] = {
            key = "17587851675803046",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2543.6, y = 337.29999999999984},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008912,
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["17587851740993276"] = {
            key = "17587851740993276",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2534.1499999999996, y = 612.1999999999999},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = false,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008912,
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
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
          ["17587851858653478"] = {
            key = "17587851858653478",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2941.8, y = 302.7999999999999},
            propsData = {ListenCount = 3, NeedFinishCount = 3}
          },
          ["17587852028174024"] = {
            key = "17587852028174024",
            type = "DynamicQuestFailNode",
            name = "动态任务主动失败",
            pos = {x = 1856.7547163362945, y = 802.1263157894737},
            propsData = {UseTalkFadeOut = false, TalkFadeOutTime = 0}
          },
          ["17587852155314449"] = {
            key = "17587852155314449",
            type = "ChangeStaticCreatorNode",
            name = "生成失物招领",
            pos = {x = 3177.3241626794247, y = 355.3293322238403},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = true,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480142}
            }
          },
          ["17587852634654824"] = {
            key = "17587852634654824",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3444.8379185491585, y = 326.02452329380645},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818096,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480142",
              DelayShowGuideTime = 2,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008905,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {
                "",
                "",
                ""
              },
              OverrideFailBlend = false
            }
          },
          ["17587853804126452"] = {
            key = "17587853804126452",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 4504.125841254473, y = 318.5998876949394},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = true,
              TalkFadeOutTime = 1,
              UseTalkFadeIn = true,
              TalkFadeInTime = 1
            }
          },
          ["17587898066033277422"] = {
            key = "17587898066033277422",
            type = "TalkNode",
            name = "失物招领开车",
            pos = {x = 3433.9375352907946, y = 108.92409878451107},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008904,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17588686251221312423"] = {
            key = "17588686251221312423",
            type = "ChangeStaticCreatorNode",
            name = "销毁搜寻点",
            pos = {x = 2906.1769865841075, y = -119.7872807017545},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480125}
            }
          },
          ["17588686502501312962"] = {
            key = "17588686502501312962",
            type = "ChangeStaticCreatorNode",
            name = "销毁搜寻点",
            pos = {x = 2912.8103199174407, y = 172.04605263157885},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480126}
            }
          },
          ["17588686525471313053"] = {
            key = "17588686525471313053",
            type = "ChangeStaticCreatorNode",
            name = "销毁搜寻点",
            pos = {x = 2861.343653250774, y = 556.5460526315788},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {292480127}
            }
          },
          ["1761034554074661040"] = {
            key = "1761034554074661040",
            type = "DynamicQuestSuccessNode",
            name = "动态任务主动成功",
            pos = {x = 4501.250592885375, y = 485.5213438735178},
            propsData = {
              DialogueId = 0,
              UseTalkFadeOut = true,
              TalkFadeOutTime = 1,
              UseTalkFadeIn = true,
              TalkFadeInTime = 1
            }
          },
          ["1775789404497910903"] = {
            key = "1775789404497910903",
            type = "TalkNode",
            name = "找到",
            pos = {x = 4036.7611389698404, y = 296.978051237137},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818095,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480124",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008907,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1775789413019911102"] = {
            key = "1775789413019911102",
            type = "TalkNode",
            name = "没找到",
            pos = {x = 4052.5266562112192, y = 498.44233695142265},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 818095,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Dyn_292480124",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 71008910,
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
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              PauseNpcBT = true,
              bLockNpcSpawn = false,
              TalkActors = {},
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17757923762108167105"] = {
            key = "17757923762108167105",
            type = "TalkNode",
            name = "失物招领开车",
            pos = {x = 4075.7559523809527, y = 68.15476190476201},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008913,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17757923807538167260"] = {
            key = "17757923807538167260",
            type = "TalkNode",
            name = "失物招领开车",
            pos = {x = 4074.14880952381, y = 710.8333333333335},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 71008913,
              FlowAssetPath = "",
              TalkType = "UnimportGuide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
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
