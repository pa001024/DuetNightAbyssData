return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17751983302431",
      startPort = "StoryStart",
      endStory = "1775198469899879098",
      endPort = "In"
    },
    {
      startStory = "1775198469899879098",
      startPort = "Success",
      endStory = "1775199040207882591",
      endPort = "In"
    },
    {
      startStory = "1775199040207882591",
      startPort = "Success",
      endStory = "1775199122232883896",
      endPort = "In"
    },
    {
      startStory = "1775199122232883896",
      startPort = "Success",
      endStory = "1775199226078884362",
      endPort = "In"
    },
    {
      startStory = "1775199226078884362",
      startPort = "Success",
      endStory = "1775199255988884722",
      endPort = "In"
    },
    {
      startStory = "1775199401430885368",
      startPort = "Success",
      endStory = "1775199433070885697",
      endPort = "In"
    },
    {
      startStory = "1775199433070885697",
      startPort = "Success",
      endStory = "1775199446836885888",
      endPort = "In"
    },
    {
      startStory = "1775199446836885888",
      startPort = "Success",
      endStory = "1775199477472886042",
      endPort = "In"
    },
    {
      startStory = "1775199477472886042",
      startPort = "Success",
      endStory = "1775199911490886502",
      endPort = "In"
    },
    {
      startStory = "1775199911490886502",
      startPort = "Success",
      endStory = "17751983302435",
      endPort = "StoryEnd"
    },
    {
      startStory = "1775199255988884722",
      startPort = "Success",
      endStory = "1775199401430885368",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17751983302431"] = {
      isStoryNode = true,
      key = "17751983302431",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 298},
      propsData = {QuestChainId = 200402},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17751983302435"] = {
      isStoryNode = true,
      key = "17751983302435",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1800.0714285714287, y = 754.6428571428571},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1775198469899879098"] = {
      isStoryNode = true,
      key = "1775198469899879098",
      type = "PreStoryNode",
      name = "接取任务",
      pos = {x = 1133, y = 279.69565217391306},
      propsData = {
        QuestId = 20040200,
        QuestDescriptionComment = "",
        SubRegionId = 106001,
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_XingShang_322480128",
        bIsPlayBlackScreenOnComplete = false,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775198469899879105",
            startPort = "CancelOut",
            endQuest = "1775198469899879113",
            endPort = "Fail"
          },
          {
            startQuest = "1775198469899879105",
            startPort = "ApproveOut",
            endQuest = "1775198469899879102",
            endPort = "Success"
          },
          {
            startQuest = "1775198469899879099",
            startPort = "QuestStart",
            endQuest = "17756477958802720",
            endPort = "In"
          },
          {
            startQuest = "17756477958802720",
            startPort = "Out",
            endQuest = "1775198775524880142",
            endPort = "In"
          },
          {
            startQuest = "1775198775524880142",
            startPort = "Option_2",
            endQuest = "1775198469899879105",
            endPort = "Input"
          },
          {
            startQuest = "1775198775524880142",
            startPort = "Option_1",
            endQuest = "17786612666842924373",
            endPort = "In"
          },
          {
            startQuest = "1775198775524880142",
            startPort = "Fail",
            endQuest = "17786612666842924373",
            endPort = "In"
          },
          {
            startQuest = "17786612666842924373",
            startPort = "Out",
            endQuest = "1775198469899879113",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1775198469899879099"] = {
            key = "1775198469899879099",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 536, y = 316},
            propsData = {ModeType = 0}
          },
          ["1775198469899879102"] = {
            key = "1775198469899879102",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2094, y = 262},
            propsData = {ModeType = 0}
          },
          ["1775198469899879105"] = {
            key = "1775198469899879105",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1672.5, y = 314.5},
            propsData = {
              SideQuestChainId = 200402,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["1775198469899879113"] = {
            key = "1775198469899879113",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2106, y = 540},
            propsData = {}
          },
          ["1775198775524880142"] = {
            key = "1775198775524880142",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1168, y = 324},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700397,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_XingShang_322480128",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200401,
              FlowAssetPath = "",
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
              SkipToOption = true,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"51200403", "51200406"},
              OverrideFailBlend = false
            }
          },
          ["17756477958802720"] = {
            key = "17756477958802720",
            type = "ChangeStaticCreatorNode",
            name = "生成行商",
            pos = {x = 819.5, y = 364},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480128}
            }
          },
          ["17786612666842924373"] = {
            key = "17786612666842924373",
            type = "TalkNode",
            name = "见你只是个工人，行商没了继续推销的意愿。",
            pos = {x = 1705.875, y = 521.5},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200712,
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
          }
        },
        commentData = {}
      }
    },
    ["1775199040207882591"] = {
      isStoryNode = true,
      key = "1775199040207882591",
      type = "StoryNode",
      name = "买下盒子",
      pos = {x = 1442.696428571429, y = 285.4285714285714},
      propsData = {
        QuestId = 20040201,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_1",
        QuestDeatil = "Content_200402_1",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_XingShang_322480128",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775201316578889730",
            startPort = "Out",
            endQuest = "1775201337739890144",
            endPort = "In"
          },
          {
            startQuest = "1775201337739890144",
            startPort = "Out",
            endQuest = "1775201666181892878",
            endPort = "In"
          },
          {
            startQuest = "1775201666181892878",
            startPort = "Out",
            endQuest = "1775199040207882595",
            endPort = "Success"
          },
          {
            startQuest = "1775201337739890144",
            startPort = "Out",
            endQuest = "17786613590822925799",
            endPort = "In"
          },
          {
            startQuest = "1775201272468889320",
            startPort = "Out",
            endQuest = "17763299375205489346",
            endPort = "In"
          },
          {
            startQuest = "17763299375205489346",
            startPort = "Out",
            endQuest = "1775201316578889730",
            endPort = "In"
          },
          {
            startQuest = "1775199040207882592",
            startPort = "QuestStart",
            endQuest = "17809925984863214",
            endPort = "In"
          },
          {
            startQuest = "17809925984863214",
            startPort = "Out",
            endQuest = "1775201272468889320",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199040207882592"] = {
            key = "1775199040207882592",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775199040207882595"] = {
            key = "1775199040207882595",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2442.9285714285716, y = 292.07142857142856},
            propsData = {ModeType = 0}
          },
          ["1775199040207882598"] = {
            key = "1775199040207882598",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1775201272468889320"] = {
            key = "1775201272468889320",
            type = "TalkNode",
            name = "白大手一挥",
            pos = {x = 1190.9375, y = 298},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200402/20040201.20040201'",
              TalkType = "FixSimple",
              TalkStageName = "TalkStageNew_20040201",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1775201316578889730"] = {
            key = "1775201316578889730",
            type = "ChangeStaticCreatorNode",
            name = "远处生成行商",
            pos = {x = 1487.5677361853834, y = 316.5253759398496},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480404}
            }
          },
          ["1775201337739890144"] = {
            key = "1775201337739890144",
            type = "TalkNode",
            name = "到这里就可以了。",
            pos = {x = 1790.6218487394958, y = 295.66823308270676},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700397,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_XingShang_322480404",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200722,
              FlowAssetPath = "",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1775201666181892878"] = {
            key = "1775201666181892878",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2096.8361344537816, y = 298.59680451127815},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200464,
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
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          },
          ["17763299375205489346"] = {
            key = "17763299375205489346",
            type = "ChangeStaticCreatorNode",
            name = "销毁行商",
            pos = {x = 1513.9480519480521, y = 103.24675324675326},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480128}
            }
          },
          ["17786613590822925799"] = {
            key = "17786613590822925799",
            type = "ChangeStaticCreatorNode",
            name = "远处销毁行商",
            pos = {x = 2084.980558012679, y = 94.8229765590445},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480404}
            }
          },
          ["17809925984863214"] = {
            key = "17809925984863214",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1097.5832748948105, y = 106.10123221799233},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 242480427,
              GuideType = "M",
              GuidePointName = "Mechanism_TalkStageNew_20040201_242480427"
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199122232883896"] = {
      isStoryNode = true,
      key = "1775199122232883896",
      type = "StoryNode",
      name = "拆盒子",
      pos = {x = 1754.1250000000002, y = 282.07142857142867},
      propsData = {
        QuestId = 20040202,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_2",
        QuestDeatil = "Content_200402_2",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_322480129",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775201542836892051",
            startPort = "Out",
            endQuest = "17752030174131774208",
            endPort = "In"
          },
          {
            startQuest = "17752030174131774208",
            startPort = "Out",
            endQuest = "1775199122232883902",
            endPort = "Success"
          },
          {
            startQuest = "1775201542836892051",
            startPort = "Out",
            endQuest = "17752045332391777521",
            endPort = "In"
          },
          {
            startQuest = "1775199122232883901",
            startPort = "QuestStart",
            endQuest = "17787448724692921358",
            endPort = "In"
          },
          {
            startQuest = "17787448724692921358",
            startPort = "Out",
            endQuest = "1775201542836892051",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199122232883901"] = {
            key = "1775199122232883901",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 529, y = 309},
            propsData = {ModeType = 0}
          },
          ["1775199122232883902"] = {
            key = "1775199122232883902",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1986.5555555555559, y = 307.22222222222223},
            propsData = {ModeType = 0}
          },
          ["1775199122232883903"] = {
            key = "1775199122232883903",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1878, y = 626},
            propsData = {}
          },
          ["1775201542836892051"] = {
            key = "1775201542836892051",
            type = "TalkNode",
            name = "咦惹，百花车站的人居然喜欢收藏这种大叔的烟盒画",
            pos = {x = 1296.888888888889, y = 314},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700396,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_322480129",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200465,
              FlowAssetPath = "",
              TalkType = "Impression",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752030174131774208"] = {
            key = "17752030174131774208",
            type = "TalkNode",
            name = "一个衣着得体",
            pos = {x = 1604, y = 317.639705882353},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200487,
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
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          },
          ["17752045332391777521"] = {
            key = "17752045332391777521",
            type = "ChangeStaticCreatorNode",
            name = "销毁小白",
            pos = {x = 1596, y = 153.1952614379084},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480129}
            }
          },
          ["17787448724692921358"] = {
            key = "17787448724692921358",
            type = "ChangeStaticCreatorNode",
            name = "生成小白",
            pos = {x = 950, y = 312},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480129}
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199226078884362"] = {
      isStoryNode = true,
      key = "1775199226078884362",
      type = "StoryNode",
      name = "托兰出场",
      pos = {x = 2094.3392857142862, y = 282.9428571428572},
      propsData = {
        QuestId = 20040203,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_3",
        QuestDeatil = "Content_200402_3",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480130",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775199226078884363",
            startPort = "QuestStart",
            endQuest = "17752033409361775625",
            endPort = "In"
          },
          {
            startQuest = "17752033409361775625",
            startPort = "Out",
            endQuest = "17752033189461774989",
            endPort = "In"
          },
          {
            startQuest = "17752033189461774989",
            startPort = "Out",
            endQuest = "17752052642971779422",
            endPort = "In"
          },
          {
            startQuest = "17752052642971779422",
            startPort = "Out",
            endQuest = "17752053134001780124",
            endPort = "In"
          },
          {
            startQuest = "17752053134001780124",
            startPort = "Out",
            endQuest = "17752054246281781076",
            endPort = "In"
          },
          {
            startQuest = "17752053134001780124",
            startPort = "Out",
            endQuest = "17752056174701782257",
            endPort = "In"
          },
          {
            startQuest = "17752056174701782257",
            startPort = "Out",
            endQuest = "17781347639763348",
            endPort = "In"
          },
          {
            startQuest = "17781347639763348",
            startPort = "Out",
            endQuest = "1775199226078884366",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775199226078884363"] = {
            key = "1775199226078884363",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775199226078884366"] = {
            key = "1775199226078884366",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3032.3608999695957, y = 332.1754332623898},
            propsData = {ModeType = 0}
          },
          ["1775199226078884369"] = {
            key = "1775199226078884369",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1726.923076923077, y = 589.2307692307693},
            propsData = {}
          },
          ["17752033189461774989"] = {
            key = "17752033189461774989",
            type = "TalkNode",
            name = "抱歉，打扰一下。",
            pos = {x = 1417.3706293706293, y = 295.76223776223793},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_CMName_Name_TuoLan01",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480130",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200488,
              FlowAssetPath = "",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700398,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752033409361775625"] = {
            key = "17752033409361775625",
            type = "ChangeStaticCreatorNode",
            name = "生成托兰",
            pos = {x = 1096.1043693148956, y = 301.5178505704825},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480130}
            }
          },
          ["17752052642971779422"] = {
            key = "17752052642971779422",
            type = "TalkNode",
            name = "奥特赛德和白跑着追了上去",
            pos = {x = 1761.5589147694411, y = 315.15421420684623},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200500,
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
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          },
          ["17752053134001780124"] = {
            key = "17752053134001780124",
            type = "TalkNode",
            name = "这……他们这是怎么了？",
            pos = {x = 2102.4680056785323, y = 321.24512329775524},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_CMName_Name_TuoLan01",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480130",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200501,
              FlowAssetPath = "",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752054246281781076"] = {
            key = "17752054246281781076",
            type = "ChangeStaticCreatorNode",
            name = "销毁托兰",
            pos = {x = 2406.5589147694413, y = 182.8814869341189},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480130}
            }
          },
          ["17752056174701782257"] = {
            key = "17752056174701782257",
            type = "TalkNode",
            name = "托兰和你挥手告别",
            pos = {x = 2395.64982386035, y = 320.60875966139156},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200542,
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
          ["17781347639763348"] = {
            key = "17781347639763348",
            type = "TalkNode",
            name = "一段时间后，白和奥特赛德回来了",
            pos = {x = 2704.757033248083, y = 323.5514874141876},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200543,
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
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199255988884722"] = {
      isStoryNode = true,
      key = "1775199255988884722",
      type = "StoryNode",
      name = "与白和奥特赛德讲述见闻",
      pos = {x = 1140.7321428571431, y = 526.5714285714287},
      propsData = {
        QuestId = 20040204,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_4",
        QuestDeatil = "Content_200402_4",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Bai_322480131",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752060277942663916",
            startPort = "Out",
            endQuest = "17752082321302671591",
            endPort = "In"
          },
          {
            startQuest = "1775199255988884723",
            startPort = "QuestStart",
            endQuest = "17752083391072672539",
            endPort = "In"
          },
          {
            startQuest = "17752060277942663916",
            startPort = "Out",
            endQuest = "17752083556142672915",
            endPort = "In"
          },
          {
            startQuest = "17752060277942663916",
            startPort = "Out",
            endQuest = "17752084042232673373",
            endPort = "In"
          },
          {
            startQuest = "17752082321302671591",
            startPort = "Out",
            endQuest = "17752084170772673633",
            endPort = "In"
          },
          {
            startQuest = "17752084170772673633",
            startPort = "Out",
            endQuest = "17752084678032673904",
            endPort = "In"
          },
          {
            startQuest = "17752084678032673904",
            startPort = "Out",
            endQuest = "17752085064402674434",
            endPort = "In"
          },
          {
            startQuest = "17752084170772673633",
            startPort = "Out",
            endQuest = "17752085388442675414",
            endPort = "In"
          },
          {
            startQuest = "17752084170772673633",
            startPort = "Out",
            endQuest = "17757207615421363493",
            endPort = "In"
          },
          {
            startQuest = "17752085064402674434",
            startPort = "Out",
            endQuest = "17757207743541363840",
            endPort = "In"
          },
          {
            startQuest = "17757207743541363840",
            startPort = "Out",
            endQuest = "1775199255988884726",
            endPort = "Success"
          },
          {
            startQuest = "17752082321302671591",
            startPort = "Out",
            endQuest = "17758088504733258",
            endPort = "In"
          },
          {
            startQuest = "17752084678032673904",
            startPort = "Out",
            endQuest = "17758094784139163",
            endPort = "In"
          },
          {
            startQuest = "1775199255988884723",
            startPort = "QuestStart",
            endQuest = "17752060277942663916",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199255988884723"] = {
            key = "1775199255988884723",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1134.6153846153848, y = 296.53846153846155},
            propsData = {ModeType = 0}
          },
          ["1775199255988884726"] = {
            key = "1775199255988884726",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3386.7186442589673, y = 294.17014437175726},
            propsData = {ModeType = 0}
          },
          ["1775199255989884729"] = {
            key = "1775199255989884729",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3377.8947368421054, y = 745.7894736842105},
            propsData = {}
          },
          ["17752060277942663916"] = {
            key = "17752060277942663916",
            type = "TalkNode",
            name = "呜呜……都怪奥特赛德跑得太慢了",
            pos = {x = 1480.25, y = 293.25},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700396,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_322480131",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200544,
              FlowAssetPath = "",
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
                  TalkActorId = 700396,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700395,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752082321302671591"] = {
            key = "17752082321302671591",
            type = "TalkNode",
            name = "几人闲谈的时候",
            pos = {x = 1854, y = 299.5000000000001},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200563,
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
          ["17752083391072672539"] = {
            key = "17752083391072672539",
            type = "ChangeStaticCreatorNode",
            name = "生成白和奥特赛德",
            pos = {x = 1472.8461538461538, y = 152.8653846153846},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480131, 322480307}
            }
          },
          ["17752083556142672915"] = {
            key = "17752083556142672915",
            type = "ChangeStaticCreatorNode",
            name = "销毁白和奥特赛德",
            pos = {x = 1845.25, y = 142},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480131, 322480307}
            }
          },
          ["17752084042232673373"] = {
            key = "17752084042232673373",
            type = "ChangeStaticCreatorNode",
            name = "生成贵族",
            pos = {x = 1856.5, y = 470.7500000000001},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480132}
            }
          },
          ["17752084170772673633"] = {
            key = "17752084170772673633",
            type = "TalkNode",
            name = "请容我自我介绍一下",
            pos = {x = 2138.264705882353, y = 291.9456521739132},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700399,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_GuiZu_322480132",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200564,
              FlowAssetPath = "",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700399,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752084678032673904"] = {
            key = "17752084678032673904",
            type = "TalkNode",
            name = "贵族意犹未尽地离开了",
            pos = {x = 2420.4285714285716, y = 284.5000000000001},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200568,
              FlowAssetPath = "",
              TalkType = "BlackISS",
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
              SwitchToMaster = "Player",
              OverrideFailBlend = false
            }
          },
          ["17752085064402674434"] = {
            key = "17752085064402674434",
            type = "TalkNode",
            name = "呼……吓死我了。",
            pos = {x = 2768.373401534527, y = 279.4456521739132},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700396,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_322480131",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200569,
              FlowAssetPath = "",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752085388442675414"] = {
            key = "17752085388442675414",
            type = "ChangeStaticCreatorNode",
            name = "销毁贵族",
            pos = {x = 2421.2325976230895, y = 488.466468590832},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480132}
            }
          },
          ["17757207615421363493"] = {
            key = "17757207615421363493",
            type = "ChangeStaticCreatorNode",
            name = "生成白",
            pos = {x = 2424.8475524475525, y = 115.83216783216749},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480131}
            }
          },
          ["17757207743541363840"] = {
            key = "17757207743541363840",
            type = "ChangeStaticCreatorNode",
            name = "销毁白",
            pos = {x = 3065.2321678321687, y = 292.37062937062905},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480131}
            }
          },
          ["17758088504733258"] = {
            key = "17758088504733258",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2211.096749226006, y = 622.2996646026832},
            propsData = {
              NewDescription = "Description_200402_4_1",
              NewDetail = "Content_200402_4_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17758094784139163"] = {
            key = "17758094784139163",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2767.9388544891635, y = 597.0365067079465},
            propsData = {
              NewDescription = "Description_200402_4_2",
              NewDetail = "Content_200402_4_2",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199401430885368"] = {
      isStoryNode = true,
      key = "1775199401430885368",
      type = "StoryNode",
      name = "来到沙龙门口",
      pos = {x = 1464.929347826087, y = 539.1428571428572},
      propsData = {
        QuestId = 20040205,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_5",
        QuestDeatil = "Content_200402_5",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480133",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775199401430885373",
            startPort = "QuestStart",
            endQuest = "17752073025732668534",
            endPort = "In"
          },
          {
            startQuest = "17752073025732668534",
            startPort = "Out",
            endQuest = "17752073161012668681",
            endPort = "In"
          },
          {
            startQuest = "17752073161012668681",
            startPort = "Out",
            endQuest = "17752079091002670356",
            endPort = "In"
          },
          {
            startQuest = "17752079091002670356",
            startPort = "Out",
            endQuest = "1775199401430885374",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775199401430885373"] = {
            key = "1775199401430885373",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775199401430885374"] = {
            key = "1775199401430885374",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2224.285714285714, y = 292.85714285714283},
            propsData = {ModeType = 0}
          },
          ["1775199401430885375"] = {
            key = "1775199401430885375",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2337.142857142857, y = 578.5714285714286},
            propsData = {}
          },
          ["17752073025732668534"] = {
            key = "17752073025732668534",
            type = "ChangeStaticCreatorNode",
            name = "生成托兰",
            pos = {x = 1140, y = 304},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480133}
            }
          },
          ["17752073161012668681"] = {
            key = "17752073161012668681",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1490, y = 288},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480133",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200571,
              FlowAssetPath = "",
              TalkType = "Impression",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
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
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752079091002670356"] = {
            key = "17752079091002670356",
            type = "ChangeStaticCreatorNode",
            name = "销毁托兰",
            pos = {x = 1855.8757763975157, y = 295.0965556182946},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480133}
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199433070885697"] = {
      isStoryNode = true,
      key = "1775199433070885697",
      type = "StoryNode",
      name = "进入沙龙",
      pos = {x = 1789.267857142857, y = 542.3571428571429},
      propsData = {
        QuestId = 20040206,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_6",
        QuestDeatil = "Content_200402_6",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480134",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752184943203562417",
            startPort = "Out",
            endQuest = "17752185750473563460",
            endPort = "In"
          },
          {
            startQuest = "17752185750473563460",
            startPort = "Out",
            endQuest = "17752186349403564262",
            endPort = "In"
          },
          {
            startQuest = "17752184842523562189",
            startPort = "Out",
            endQuest = "17752184943203562417",
            endPort = "In"
          },
          {
            startQuest = "1775199433070885702",
            startPort = "QuestStart",
            endQuest = "17752184842523562189",
            endPort = "In"
          },
          {
            startQuest = "1775199433070885702",
            startPort = "QuestStart",
            endQuest = "17755504065647316",
            endPort = "In"
          },
          {
            startQuest = "17752186349403564262",
            startPort = "Out",
            endQuest = "17752186450093564395",
            endPort = "In"
          },
          {
            startQuest = "17752186450093564395",
            startPort = "Out",
            endQuest = "17757216621821366167",
            endPort = "In"
          },
          {
            startQuest = "17757216621821366167",
            startPort = "Out",
            endQuest = "1775199433070885703",
            endPort = "Success"
          },
          {
            startQuest = "17752184943203562417",
            startPort = "Out",
            endQuest = "17758088994484459",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199433070885702"] = {
            key = "1775199433070885702",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1775199433070885703"] = {
            key = "1775199433070885703",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2161.2132867132864, y = 554.4895104895104},
            propsData = {ModeType = 0}
          },
          ["1775199433070885704"] = {
            key = "1775199433070885704",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2609.076923076923, y = 580.4615384615385},
            propsData = {}
          },
          ["17752184842523562189"] = {
            key = "17752184842523562189",
            type = "ChangeStaticCreatorNode",
            name = "生成托兰",
            pos = {x = 1150, y = 306},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480134}
            }
          },
          ["17752184943203562417"] = {
            key = "17752184943203562417",
            type = "TalkNode",
            name = "会长从来没有因为组织的壮大而懈怠",
            pos = {x = 1485.695652173913, y = 288.0033444816054},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480134",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200402/20040213.20040213'",
              TalkType = "FixSimple",
              TalkStageName = "TalkStageNew_20040202",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752185750473563460"] = {
            key = "17752185750473563460",
            type = "ChangeStaticCreatorNode",
            name = "生成奥特赛德和白",
            pos = {x = 1792.6098901098903, y = 292.4320416425679},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480135,
                322480136,
                242480426
              }
            }
          },
          ["17752186349403564262"] = {
            key = "17752186349403564262",
            type = "TalkNode",
            name = "与奥特赛德对话",
            pos = {x = 2088.9385614385615, y = 277.4320416425679},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700451,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_AoTe_322480135",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51200620,
              FlowAssetPath = "",
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
                  TalkActorId = 700451,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752186450093564395"] = {
            key = "17752186450093564395",
            type = "TalkNode",
            name = "与白对话",
            pos = {x = 1480.3546453546458, y = 538.9005731110994},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700453,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_322480136",
              DelayShowGuideTime = 0,
              FirstDialogueId = 51200622,
              FlowAssetPath = "",
              TalkType = "FixSimple",
              TalkStageName = "",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17755504065647316"] = {
            key = "17755504065647316",
            type = "AtmosphereNpcHideNode",
            name = "隐藏休息室内的氛围NPC",
            pos = {x = 1156, y = 108},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {
                "story_200402"
              }
            }
          },
          ["17757216621821366167"] = {
            key = "17757216621821366167",
            type = "ChangeStaticCreatorNode",
            name = "销毁奥特赛德和白",
            pos = {x = 1807.5941457922884, y = 567.6778309409889},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480135,
                322480136,
                242480426
              }
            }
          },
          ["17758088994484459"] = {
            key = "17758088994484459",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1806.4347826086957, y = 136.08695652173915},
            propsData = {
              NewDescription = "Description_200402_6_1",
              NewDetail = "Content_200402_6_1",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199446836885888"] = {
      isStoryNode = true,
      key = "1775199446836885888",
      type = "StoryNode",
      name = "了解摄影流程",
      pos = {x = 2082.9107142857138, y = 541.25},
      propsData = {
        QuestId = 20040207,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_7",
        QuestDeatil = "Content_200402_7",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480134",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775199446836885893",
            startPort = "QuestStart",
            endQuest = "17752191977874448559",
            endPort = "In"
          },
          {
            startQuest = "17752191977874448559",
            startPort = "Out",
            endQuest = "17757217913661367392",
            endPort = "In"
          },
          {
            startQuest = "17757217913661367392",
            startPort = "Out",
            endQuest = "1775199446836885894",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1775199446836885893"] = {
            key = "1775199446836885893",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 936, y = 342},
            propsData = {ModeType = 0}
          },
          ["1775199446836885894"] = {
            key = "1775199446836885894",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2015.5555555555557, y = 346.44444444444446},
            propsData = {ModeType = 0}
          },
          ["1775199446836885895"] = {
            key = "1775199446836885895",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1686, y = 592},
            propsData = {}
          },
          ["17752191977874448559"] = {
            key = "17752191977874448559",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1342, y = 332.69565217391306},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480134",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200624,
              FlowAssetPath = "",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17757217913661367392"] = {
            key = "17757217913661367392",
            type = "ChangeStaticCreatorNode",
            name = "销毁托兰",
            pos = {x = 1688, y = 352},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480134}
            }
          }
        },
        commentData = {}
      }
    },
    ["1775199477472886042"] = {
      isStoryNode = true,
      key = "1775199477472886042",
      type = "StoryNode",
      name = "前往火车并拍照",
      pos = {x = 1148.7678571428569, y = 741.6031746031748},
      propsData = {
        QuestId = 20040208,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_8",
        QuestDeatil = "Content_200402_8",
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
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480137",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1775199477472886047",
            startPort = "QuestStart",
            endQuest = "17752203136074450393",
            endPort = "In"
          },
          {
            startQuest = "17752211589534451131",
            startPort = "Success",
            endQuest = "17752212210284451392",
            endPort = "In"
          },
          {
            startQuest = "17752217909724454761",
            startPort = "Out",
            endQuest = "17752218441024455455",
            endPort = "In"
          },
          {
            startQuest = "17752218441024455455",
            startPort = "Out",
            endQuest = "1775199477472886048",
            endPort = "Success"
          },
          {
            startQuest = "1775199477472886047",
            startPort = "QuestStart",
            endQuest = "17755506255158230",
            endPort = "In"
          },
          {
            startQuest = "17757371464075438073",
            startPort = "Out",
            endQuest = "17757371464075438074",
            endPort = "In"
          },
          {
            startQuest = "17757371464075438074",
            startPort = "Out",
            endQuest = "17757371464075438075",
            endPort = "In"
          },
          {
            startQuest = "17757371464075438075",
            startPort = "Out",
            endQuest = "17757371464075438073",
            endPort = "In"
          },
          {
            startQuest = "17752211349384450874",
            startPort = "Out",
            endQuest = "17757371464075438073",
            endPort = "In"
          },
          {
            startQuest = "17757371464075438073",
            startPort = "Out",
            endQuest = "17752211589534451131",
            endPort = "In"
          },
          {
            startQuest = "17752211589534451131",
            startPort = "Success",
            endQuest = "17757371464075438073",
            endPort = "Stop"
          },
          {
            startQuest = "17752211349384450874",
            startPort = "Out",
            endQuest = "17757375795305440805",
            endPort = "In"
          },
          {
            startQuest = "17752211589534451131",
            startPort = "Success",
            endQuest = "17757380153125443948",
            endPort = "In"
          },
          {
            startQuest = "17752212210284451392",
            startPort = "Out",
            endQuest = "17757384556755445212",
            endPort = "In"
          },
          {
            startQuest = "17752215443724453405",
            startPort = "Out",
            endQuest = "17757384710415445500",
            endPort = "In"
          },
          {
            startQuest = "17752211349384450874",
            startPort = "Out",
            endQuest = "17761475574809579950",
            endPort = "In"
          },
          {
            startQuest = "17752211589534451131",
            startPort = "Success",
            endQuest = "17763296115912747183",
            endPort = "In"
          },
          {
            startQuest = "17752215443724453405",
            startPort = "Out",
            endQuest = "17752214045224453136",
            endPort = "In"
          },
          {
            startQuest = "17752215443724453405",
            startPort = "Out",
            endQuest = "17752212819214452089",
            endPort = "In"
          },
          {
            startQuest = "17752212210284451392",
            startPort = "Out",
            endQuest = "17752215443724453405",
            endPort = "In"
          },
          {
            startQuest = "1775199477472886047",
            startPort = "QuestStart",
            endQuest = "17775396860465318",
            endPort = "In"
          },
          {
            startQuest = "17752212210284451392",
            startPort = "Out",
            endQuest = "17780514565673821",
            endPort = "In"
          },
          {
            startQuest = "1775199477472886047",
            startPort = "QuestStart",
            endQuest = "17752211349384450874",
            endPort = "In"
          },
          {
            startQuest = "17752214045224453136",
            startPort = "Out",
            endQuest = "17786615304682927912",
            endPort = "In"
          },
          {
            startQuest = "17786615304682927912",
            startPort = "Out",
            endQuest = "17786616150122928775",
            endPort = "In"
          },
          {
            startQuest = "17786616150122928775",
            startPort = "Out",
            endQuest = "17752217909724454761",
            endPort = "In"
          },
          {
            startQuest = "17786616150122928775",
            startPort = "Out",
            endQuest = "17757384897845445880",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199477472886047"] = {
            key = "1775199477472886047",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1081.5384615384614, y = 403.84615384615387},
            propsData = {ModeType = 0}
          },
          ["1775199477472886048"] = {
            key = "1775199477472886048",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2889.5833333333335, y = 1153.6666666666665},
            propsData = {ModeType = 0}
          },
          ["1775199477472886049"] = {
            key = "1775199477472886049",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3793.75, y = 715},
            propsData = {}
          },
          ["17752202725474450027"] = {
            key = "17752202725474450027",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送到火车前",
            pos = {x = 750.4749163879599, y = 376.2140468227425},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_NewTargetPoint_20040201",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17752203136074450393"] = {
            key = "17752203136074450393",
            type = "ChangeStaticCreatorNode",
            name = "生成托兰",
            pos = {x = 1365.0459866220735, y = 216.74797570850205},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480137}
            }
          },
          ["17752211349384450874"] = {
            key = "17752211349384450874",
            type = "TalkNode",
            name = "与托兰对话",
            pos = {x = 1501.1441647597253, y = 404.8333333333333},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480137",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200637,
              FlowAssetPath = "",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700395,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752211589534451131"] = {
            key = "17752211589534451131",
            type = "CameraNode",
            name = "相机节点",
            pos = {x = 2243.0269968399257, y = 394.6265664160401},
            propsData = {
              bFadeInOut = false,
              bIsForceOpenCamera = true,
              bGuideUIEnable = true,
              GuideType = "P",
              _GuidePointName = "",
              TargetPointList = {
                "BP_NewTargetPoint_20040202"
              },
              EventId = 0,
              EventParams = {},
              Text_TargetFound = "",
              Text_TargetNotFound = "",
              ForceMaxLodStaticPointList = {},
              bShouldSetCameraParams = true,
              FocalLength = 22,
              LookAtTargetName = "BP_NewTargetPoint_20040202",
              StartPos = "(X=-27790.000000,Y=9020.000000,Z=2400.000000)",
              bLockCameraPos = false,
              bStartHiddenRole = false,
              bLockHiddenRole = true,
              bStartHiddenNPC = false,
              bLockHiddenNPC = false,
              bStartHiddenMonster = false,
              bLockHiddenMonster = false,
              bStartHiddenPet = false,
              bLockHiddenPet = false,
              bLockGamePause = true,
              bForceGamePause = true
            }
          },
          ["17752212210284451392"] = {
            key = "17752212210284451392",
            type = "TalkNode",
            name = "相机被砸了",
            pos = {x = 2579.148550724637, y = 391.0833333333333},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200402/20040216.20040216'",
              TalkType = "FixSimple",
              TalkStageName = "TalkStageNew_20040203",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752212819214452089"] = {
            key = "17752212819214452089",
            type = "ChangeStaticCreatorNode",
            name = "销毁托兰",
            pos = {x = 1500.9518570674172, y = 1021.728407557355},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480137}
            }
          },
          ["17752214045224453136"] = {
            key = "17752214045224453136",
            type = "ChangeStaticCreatorNode",
            name = "休息室门口生成托兰",
            pos = {x = 1502.8991772910533, y = 1155.984335839599},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480133}
            }
          },
          ["17752215443724453405"] = {
            key = "17752215443724453405",
            type = "TalkNode",
            name = "离开场景",
            pos = {x = 1190.5056935817804, y = 1160.1666666666665},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480137",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200669,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752217549304454360"] = {
            key = "17752217549304454360",
            type = "PickUpNode",
            name = "洗照片",
            pos = {x = 2531.291407867495, y = 1396.202380952381},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 20040201,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480133",
              IsUseCount = false
            }
          },
          ["17752217909724454761"] = {
            key = "17752217909724454761",
            type = "TalkNode",
            name = "将照片给托兰",
            pos = {x = 2346.041407867495, y = 1162.1309523809525},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480133",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200715,
              FlowAssetPath = "",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700395,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752218441024455455"] = {
            key = "17752218441024455455",
            type = "ChangeStaticCreatorNode",
            name = "销毁托兰",
            pos = {x = 2633.541407867495, y = 1168.5595238095239},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480133}
            }
          },
          ["17755506255158230"] = {
            key = "17755506255158230",
            type = "AtmosphereNpcHideNode",
            name = "显示沙龙NPC",
            pos = {x = 1353.2307692307693, y = 59.07692307692308},
            propsData = {
              IsHide = false,
              AtmosphereTagList = {
                "story_200402"
              }
            }
          },
          ["17755511812381333831"] = {
            key = "17755511812381333831",
            type = "ChangeStaticCreatorNode",
            name = "生成drop",
            pos = {x = 2550.152387041773, y = 1563.2857142857142},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480139}
            }
          },
          ["17757371464075438073"] = {
            key = "17757371464075438073",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1888.6866466866466, y = 400.52655677655656},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 322480138,
              StateId = 11301281,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["17757371464075438074"] = {
            key = "17757371464075438074",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1753.7703787440632, y = 652.4751213698581},
            propsData = {WaitTime = 1}
          },
          ["17757371464075438075"] = {
            key = "17757371464075438075",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 2010.1100916627233, y = 662.2897146712935},
            propsData = {
              StaticCreatorIdList = {322480138},
              ManualItemIdList = {},
              StateId = 11301280,
              QuestId = 0
            }
          },
          ["17757375795305440805"] = {
            key = "17757375795305440805",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示拍照指引",
            pos = {x = 1778.2309620204358, y = 207.67379988432612},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_Photo_322480138"
            }
          },
          ["17757380153125443948"] = {
            key = "17757380153125443948",
            type = "ShowOrHideTaskIndicatorNode",
            name = "隐藏拍照指引",
            pos = {x = 2528.0085309427413, y = 181.66816078658178},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = true,
              GuideType = "M",
              GuideName = "Mechanism_Photo_322480138"
            }
          },
          ["17757384556755445212"] = {
            key = "17757384556755445212",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2853.8355986119145, y = 119.94635627530351},
            propsData = {
              NewDescription = "Description_200402_8_1",
              NewDetail = "Content_200402_8_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17757384710415445500"] = {
            key = "17757384710415445500",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1499.782377323399, y = 890.7586812052757},
            propsData = {
              NewDescription = "Description_200402_8_2",
              NewDetail = "Content_200402_8_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17757384897845445880"] = {
            key = "17757384897845445880",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2350.505066399029, y = 955.0808100568161},
            propsData = {
              NewDescription = "Description_200402_8_3",
              NewDetail = "Content_200402_8_3",
              SubTaskTargetIndex = 0
            }
          },
          ["17761475574809579950"] = {
            key = "17761475574809579950",
            type = "ChangeStaticCreatorNode",
            name = "生成拍照静态点",
            pos = {x = 1777.0278637770896, y = 39.5789473684211},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480138}
            }
          },
          ["17763296115912747183"] = {
            key = "17763296115912747183",
            type = "ChangeStaticCreatorNode",
            name = "销毁拍照静态点",
            pos = {x = 2526, y = 19.5},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480138}
            }
          },
          ["17775396860465318"] = {
            key = "17775396860465318",
            type = "ChangeStaticCreatorNode",
            name = "生成行商、艾森巴恩和月髓液",
            pos = {x = 1361.135467036665, y = -96.09313121481652},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480305,
                322480304,
                322480306
              }
            }
          },
          ["17780514565673821"] = {
            key = "17780514565673821",
            type = "ChangeStaticCreatorNode",
            name = "销毁行商、艾森巴恩和月髓液",
            pos = {x = 2849.3977879481313, y = 319.7515527950309},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480305,
                322480304,
                322480306
              }
            }
          },
          ["17786615304682927912"] = {
            key = "17786615304682927912",
            type = "TalkNode",
            name = "洗照片吗？没问题，你稍等一下。",
            pos = {x = 1813.0178571428569, y = 1158.5714285714287},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480133",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51200713,
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
          ["17786616150122928775"] = {
            key = "17786616150122928775",
            type = "TalkNode",
            name = "托兰接过胶卷，神色恹恹地走了。",
            pos = {x = 2091.589285714286, y = 1161.7857142857144},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51200714,
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
          }
        },
        commentData = {}
      }
    },
    ["1775199911490886502"] = {
      isStoryNode = true,
      key = "1775199911490886502",
      type = "StoryNode",
      name = "前往沙龙",
      pos = {x = 1491.721525096525, y = 736.1071428571429},
      propsData = {
        QuestId = 20040209,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200402_9",
        QuestDeatil = "Content_200402_9",
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
        IsBacktrack = false,
        SubRegionId = 106001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_TuoLan_322480134",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17752220936094456744",
            startPort = "Out",
            endQuest = "17752221153064457064",
            endPort = "In"
          },
          {
            startQuest = "17752221153064457064",
            startPort = "Out",
            endQuest = "17752221945044457884",
            endPort = "In"
          },
          {
            startQuest = "17752221945044457884",
            startPort = "Out",
            endQuest = "17752222176774458042",
            endPort = "In"
          },
          {
            startQuest = "17752222176774458042",
            startPort = "Out",
            endQuest = "17752222291004458202",
            endPort = "In"
          },
          {
            startQuest = "17752222291004458202",
            startPort = "Out",
            endQuest = "17752222400044458317",
            endPort = "In"
          },
          {
            startQuest = "1775199911490886503",
            startPort = "QuestStart",
            endQuest = "17755511420351333033",
            endPort = "In"
          },
          {
            startQuest = "17755511420351333033",
            startPort = "Out",
            endQuest = "17752220557124456273",
            endPort = "In"
          },
          {
            startQuest = "1775199911490886503",
            startPort = "QuestStart",
            endQuest = "17757361876862729619",
            endPort = "In"
          },
          {
            startQuest = "17752222400044458317",
            startPort = "Out",
            endQuest = "17757362003392729965",
            endPort = "In"
          },
          {
            startQuest = "177574408217815268",
            startPort = "Out",
            endQuest = "1775199911490886506",
            endPort = "Success"
          },
          {
            startQuest = "17752221945044457884",
            startPort = "Out",
            endQuest = "17758092858456338",
            endPort = "In"
          },
          {
            startQuest = "17752222176774458042",
            startPort = "Out",
            endQuest = "17758093298267011",
            endPort = "In"
          },
          {
            startQuest = "17752220557124456273",
            startPort = "Out",
            endQuest = "17752220936094456744",
            endPort = "In"
          },
          {
            startQuest = "17752220557124456273",
            startPort = "Out",
            endQuest = "17758092706996025",
            endPort = "In"
          },
          {
            startQuest = "17757362003392729965",
            startPort = "Out",
            endQuest = "177574408217815268",
            endPort = "In"
          }
        },
        nodeData = {
          ["1775199911490886503"] = {
            key = "1775199911490886503",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 514.3333333333334, y = 283.6666666666667},
            propsData = {ModeType = 0}
          },
          ["1775199911490886506"] = {
            key = "1775199911490886506",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800.102564102564, y = 521.7820512820514},
            propsData = {ModeType = 0}
          },
          ["1775199911490886509"] = {
            key = "1775199911490886509",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2363, y = 797.6666666666666},
            propsData = {}
          },
          ["17752220557124456273"] = {
            key = "17752220557124456273",
            type = "PickUpNode",
            name = "等待一段时间",
            pos = {x = 1150, y = 288},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 20040202,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "BP_NewTargetPoint_20040203",
              IsUseCount = false
            }
          },
          ["17752220936094456744"] = {
            key = "17752220936094456744",
            type = "ChangeStaticCreatorNode",
            name = "生成托兰",
            pos = {x = 1724.0499618611748, y = 291.1397058823529},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = true,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480134}
            }
          },
          ["17752221153064457064"] = {
            key = "17752221153064457064",
            type = "TalkNode",
            name = "与托兰对话",
            pos = {x = 2076.1929824561403, y = 288.8502321981424},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700398,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_TuoLan_322480134",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51200680,
              FlowAssetPath = "",
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
                  TalkActorId = 700398,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700396,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700395,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752221945044457884"] = {
            key = "17752221945044457884",
            type = "ChangeStaticCreatorNode",
            name = "生成墙、奥特赛德、白",
            pos = {x = 1143.0000000000002, y = 571.9730392156864},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480141,
                322480135,
                322480136,
                242480426
              }
            }
          },
          ["17752222176774458042"] = {
            key = "17752222176774458042",
            type = "TalkNode",
            name = "与墙交互",
            pos = {x = 1462.5000000000002, y = 544.9730392156864},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700416,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Wall_322480141",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51200689,
              FlowAssetPath = "",
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
                  TalkActorId = 700416,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752222291004458202"] = {
            key = "17752222291004458202",
            type = "TalkNode",
            name = "与奥特赛德对话",
            pos = {x = 1763.0000000000002, y = 546.4730392156864},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700451,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_AoTe_322480135",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51200694,
              FlowAssetPath = "",
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
                  TalkActorId = 700451,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17752222400044458317"] = {
            key = "17752222400044458317",
            type = "TalkNode",
            name = "与白对话",
            pos = {x = 2046.6363636363637, y = 546.4730392156864},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700453,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Bai_322480136",
              DelayShowGuideTime = 0,
              FirstDialogueId = 51200707,
              FlowAssetPath = "",
              TalkType = "QuestImpression",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "BlendIn",
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17755511420351333033"] = {
            key = "17755511420351333033",
            type = "ChangeStaticCreatorNode",
            name = "生成drop",
            pos = {x = 839.0877192982456, y = 288},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {322480140}
            }
          },
          ["17757361876862729619"] = {
            key = "17757361876862729619",
            type = "AtmosphereNpcHideNode",
            name = "隐藏休息室内的氛围NPC",
            pos = {x = 849.7666543982335, y = 62.114832535885114},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {
                "story_200402"
              }
            }
          },
          ["17757362003392729965"] = {
            key = "17757362003392729965",
            type = "AtmosphereNpcHideNode",
            name = "显示休息室内NPC",
            pos = {x = 2392.458962090541, y = 448.6532940743467},
            propsData = {
              IsHide = false,
              AtmosphereTagList = {
                "story_200402"
              }
            }
          },
          ["177574408217815268"] = {
            key = "177574408217815268",
            type = "ChangeStaticCreatorNode",
            name = "销毁墙、奥特赛德、白和托兰",
            pos = {x = 2418.6363636363635, y = 594.6363636363636},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                322480141,
                322480135,
                322480136,
                322480134,
                242480426
              }
            }
          },
          ["17758092706996025"] = {
            key = "17758092706996025",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1719.3333333333335, y = 134.99999999999986},
            propsData = {
              NewDescription = "Description_200402_9_1",
              NewDetail = "Content_200402_9_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17758092858456338"] = {
            key = "17758092858456338",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1469.3333333333335, y = 806.6666666666667},
            propsData = {
              NewDescription = "Description_200402_9_2",
              NewDetail = "Content_200402_9_2",
              SubTaskTargetIndex = 0
            }
          },
          ["17758093298267011"] = {
            key = "17758093298267011",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1772.6666666666667, y = 805},
            propsData = {
              NewDescription = "Description_200402_9_3",
              NewDetail = "Content_200402_9_3",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
