return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17799501029021",
      startPort = "StoryStart",
      endStory = "177995157938596",
      endPort = "In"
    },
    {
      startStory = "177995157938596",
      startPort = "Success",
      endStory = "1779951580513194",
      endPort = "In"
    },
    {
      startStory = "1779951580513194",
      startPort = "Success",
      endStory = "17799538187911492",
      endPort = "In"
    },
    {
      startStory = "17799538187911492",
      startPort = "Success",
      endStory = "17799539761472315",
      endPort = "In"
    },
    {
      startStory = "17799539761472315",
      startPort = "Success",
      endStory = "17799540024032786",
      endPort = "In"
    },
    {
      startStory = "17799540137323241",
      startPort = "Success",
      endStory = "17799540611503442",
      endPort = "In"
    },
    {
      startStory = "17799540611503442",
      startPort = "Success",
      endStory = "17799540653743564",
      endPort = "In"
    },
    {
      startStory = "17799540653743564",
      startPort = "Success",
      endStory = "17799540942704110",
      endPort = "In"
    },
    {
      startStory = "17799540024032786",
      startPort = "Success",
      endStory = "17799540137323241",
      endPort = "In"
    },
    {
      startStory = "17799540942704110",
      startPort = "easymode",
      endStory = "17799549883391029",
      endPort = "In"
    },
    {
      startStory = "17799540942704110",
      startPort = "normalmode",
      endStory = "17799549950671210",
      endPort = "In"
    },
    {
      startStory = "17799549883391029",
      startPort = "Success",
      endStory = "17799589190921685",
      endPort = "In"
    },
    {
      startStory = "17799549950671210",
      startPort = "Success",
      endStory = "17799589190921685",
      endPort = "In"
    },
    {
      startStory = "17799589190921685",
      startPort = "Success",
      endStory = "17799592790382441",
      endPort = "In"
    },
    {
      startStory = "17799592790382441",
      startPort = "Success",
      endStory = "17799593975693077",
      endPort = "In"
    },
    {
      startStory = "17799593975693077",
      startPort = "Success",
      endStory = "17799594363223416",
      endPort = "In"
    },
    {
      startStory = "17799594363223416",
      startPort = "help",
      endStory = "17799596152701115",
      endPort = "In"
    },
    {
      startStory = "17799594363223416",
      startPort = "betray",
      endStory = "17799596207651262",
      endPort = "In"
    },
    {
      startStory = "17799596489101701",
      startPort = "Success",
      endStory = "17799501029025",
      endPort = "StoryEnd"
    },
    {
      startStory = "17799596207651262",
      startPort = "Success",
      endStory = "17799501029025",
      endPort = "StoryEnd"
    },
    {
      startStory = "17799596152701115",
      startPort = "Success",
      endStory = "17804773284696058835",
      endPort = "In"
    },
    {
      startStory = "17804773284696058835",
      startPort = "Success",
      endStory = "17804776538776061884",
      endPort = "In"
    },
    {
      startStory = "17804776538776061884",
      startPort = "Success",
      endStory = "17799596489101701",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17799501029021"] = {
      isStoryNode = true,
      key = "17799501029021",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 200404},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17799501029025"] = {
      isStoryNode = true,
      key = "17799501029025",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 3372.442577908906, y = 1233.846256684492},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177995157938596"] = {
      isStoryNode = true,
      key = "177995157938596",
      type = "PreStoryNode",
      name = "任务前置节点",
      pos = {x = 1067.375, y = 361.025},
      propsData = {
        QuestId = 20040400,
        QuestDescriptionComment = "",
        SubRegionId = 106301,
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_200404heshandenanren_332890117",
        bIsPlayBlackScreenOnComplete = false,
        SubRegionIdList = {}
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177995157938597",
            startPort = "QuestStart",
            endQuest = "17799526697681733",
            endPort = "In"
          },
          {
            startQuest = "17799526697681733",
            startPort = "Out",
            endQuest = "1779951579386113",
            endPort = "Input"
          },
          {
            startQuest = "1779951579386113",
            startPort = "CancelOut",
            endQuest = "1779951579386125",
            endPort = "Fail"
          },
          {
            startQuest = "17807363385121523744",
            startPort = "Out",
            endQuest = "17807363385121523745",
            endPort = "In"
          },
          {
            startQuest = "1779951579386113",
            startPort = "ApproveOut",
            endQuest = "17807363385121523744",
            endPort = "In"
          },
          {
            startQuest = "17807363385121523745",
            startPort = "Out",
            endQuest = "1779951579385105",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177995157938597"] = {
            key = "177995157938597",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1779951579385105"] = {
            key = "1779951579385105",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2926.4285714285716, y = 158.57142857142856},
            propsData = {ModeType = 0}
          },
          ["1779951579386113"] = {
            key = "1779951579386113",
            type = "ReceiveSideQuestNode",
            name = "支线任务接取节点",
            pos = {x = 1910.5, y = 292.5},
            propsData = {
              SideQuestChainId = 200404,
              EnableSequence = true,
              SequencePath = "/Game/UI/Sequence/SQ_Task_DepthField.SQ_Task_DepthField",
              PauseMark = "QuestAccept"
            }
          },
          ["1779951579386125"] = {
            key = "1779951579386125",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2654.8387096774195, y = 500.64516129032256},
            propsData = {}
          },
          ["17799526697681733"] = {
            key = "17799526697681733",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1417.9999999999998, y = 290.43478260869557},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700486,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404heshandenanren_332890117",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51206801,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["17807363385121523744"] = {
            key = "17807363385121523744",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2242.1000233426707, y = 165.22152194211014},
            propsData = {WaitTime = 1}
          },
          ["17807363385121523745"] = {
            key = "17807363385121523745",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2631.1000233426707, y = 130.72152194211014},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51206901,
              FlowAssetPath = "",
              TalkType = "Guide",
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
    },
    ["1779951580513194"] = {
      isStoryNode = true,
      key = "1779951580513194",
      type = "StoryNode",
      name = "前往螺丝刀行会、据点门口对话",
      pos = {x = 1366.05, y = 376.1},
      propsData = {
        QuestId = 20040401,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_1",
        QuestDeatil = "Content_200404_1",
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
        SubRegionId = 106301,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_200404judianqian_332890118",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1779951580513195",
            startPort = "QuestStart",
            endQuest = "17802996792441483532",
            endPort = "In"
          },
          {
            startQuest = "17802996792441483532",
            startPort = "Out",
            endQuest = "17803000081561484645",
            endPort = "In"
          },
          {
            startQuest = "17803000081561484645",
            startPort = "Out",
            endQuest = "1779951580513198",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1779951580513195"] = {
            key = "1779951580513195",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1779951580513198"] = {
            key = "1779951580513198",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1864, y = 291},
            propsData = {ModeType = 0}
          },
          ["1779951580513201"] = {
            key = "1779951580513201",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1864, y = 691},
            propsData = {}
          },
          ["17802996792441483532"] = {
            key = "17802996792441483532",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1193, y = 244.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890118,
              GuideType = "M",
              GuidePointName = "Mechanism_200404judianqian_332890118"
            }
          },
          ["17803000081561484645"] = {
            key = "17803000081561484645",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1575.2872089596226, y = 282.98275862068965},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51207001,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51207001.51207001'",
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
    ["17799538187911492"] = {
      isStoryNode = true,
      key = "17799538187911492",
      type = "StoryNode",
      name = "进入行会据点",
      pos = {x = 1629.2830698287216, y = 375.47283706631515},
      propsData = {
        QuestId = 20040402,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_2",
        QuestDeatil = "Content_200404_2",
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
        StoryGuidePointName = "Npc_200404keluoge_332890119",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799538187911493",
            startPort = "QuestStart",
            endQuest = "17804715628875899",
            endPort = "In"
          },
          {
            startQuest = "17804715628875899",
            startPort = "Out",
            endQuest = "17803003214772966199",
            endPort = "In"
          },
          {
            startQuest = "17803003214772966199",
            startPort = "Out",
            endQuest = "17799538187911496",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799538187911493"] = {
            key = "17799538187911493",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799538187911496"] = {
            key = "17799538187911496",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799538187911499"] = {
            key = "17799538187911499",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17803003214772966199"] = {
            key = "17803003214772966199",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1625, y = 255},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700429,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404keluoge_332890119",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51207101,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700428,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["17804715628875899"] = {
            key = "17804715628875899",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1244.4, y = 287.2},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890119}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799539761472315"] = {
      isStoryNode = true,
      key = "17799539761472315",
      type = "StoryNode",
      name = "出门找白",
      pos = {x = 1880.2711650668173, y = 366.47283706631526},
      propsData = {
        QuestId = 20040403,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_3",
        QuestDeatil = "Content_200404_3",
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
        StoryGuidePointName = "Npc_200404chumenzhaobai_332890173",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804712788094162",
            startPort = "Out",
            endQuest = "17804715463865590",
            endPort = "In"
          },
          {
            startQuest = "17804715463865590",
            startPort = "Out",
            endQuest = "17799539761482319",
            endPort = "Success"
          },
          {
            startQuest = "17804715399925407",
            startPort = "Out",
            endQuest = "17804712788094162",
            endPort = "In"
          },
          {
            startQuest = "17799539761472316",
            startPort = "QuestStart",
            endQuest = "17804715399925407",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799539761472316"] = {
            key = "17799539761472316",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799539761482319"] = {
            key = "17799539761482319",
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
          ["17799539761482322"] = {
            key = "17799539761482322",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804712788094162"] = {
            key = "17804712788094162",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1941.5, y = 315},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700449,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404chumenzhaobai_332890173",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51207201,
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
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17804715399925407"] = {
            key = "17804715399925407",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1506.5, y = 304.5},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890173}
            }
          },
          ["17804715463865590"] = {
            key = "17804715463865590",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2403.5, y = 306},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890173}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799540024032786"] = {
      isStoryNode = true,
      key = "17799540024032786",
      type = "StoryNode",
      name = "前往工厂区",
      pos = {x = 2138.6640222096744, y = 369.3299799234581},
      propsData = {
        QuestId = 20040404,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_4",
        QuestDeatil = "Content_200404_4",
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
        StoryGuidePointName = "Mechanism_200404gongchangqu1_332890218",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17803044243051711",
            startPort = "Out",
            endQuest = "17805606375361516373",
            endPort = "In"
          },
          {
            startQuest = "17805606375361516373",
            startPort = "Out",
            endQuest = "17803044888741910",
            endPort = "In"
          },
          {
            startQuest = "17799540024032787",
            startPort = "QuestStart",
            endQuest = "17805609601613029943",
            endPort = "In"
          },
          {
            startQuest = "17803044888741910",
            startPort = "Out",
            endQuest = "17805609840173030352",
            endPort = "In"
          },
          {
            startQuest = "17805609840173030352",
            startPort = "Out",
            endQuest = "17799540024042790",
            endPort = "Success"
          },
          {
            startQuest = "17805606375361516373",
            startPort = "Out",
            endQuest = "178066026611430409366",
            endPort = "In"
          },
          {
            startQuest = "17799540024032787",
            startPort = "QuestStart",
            endQuest = "17834111143631591292",
            endPort = "In"
          },
          {
            startQuest = "17834112244851591836",
            startPort = "Out",
            endQuest = "17803044243051711",
            endPort = "In"
          },
          {
            startQuest = "17834111143631591292",
            startPort = "Out",
            endQuest = "17834112244851591836",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799540024032787"] = {
            key = "17799540024032787",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540024042790"] = {
            key = "17799540024042790",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540024042793"] = {
            key = "17799540024042793",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17803044243051711"] = {
            key = "17803044243051711",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1286, y = 282},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890122,
              GuideType = "M",
              GuidePointName = "Mechanism_200404gongchangqu_332890122"
            }
          },
          ["17803044888741910"] = {
            key = "17803044888741910",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1968.258064516129, y = 347.6774193548387},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700431,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404pibeigongren_332890181",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51207401,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51207401.51207401'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1,
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
              SwitchToMaster = "Player",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17805606375361516373"] = {
            key = "17805606375361516373",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1596.1290322580646, y = 279.258064516129},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51207301,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17805609601613029943"] = {
            key = "17805609601613029943",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1214.5864293659617, y = 136.0896551724136},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890181, 332890192}
            }
          },
          ["17805609840173030352"] = {
            key = "17805609840173030352",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2274.931256952169, y = 423.67586206896533},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890181, 332890192}
            }
          },
          ["178066026611430409366"] = {
            key = "178066026611430409366",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2004.5344827586205, y = 202.54310344827582},
            propsData = {
              NewDescription = "Description_200404_5",
              NewDetail = "Content_200404_5",
              SubTaskTargetIndex = 0
            }
          },
          ["17834111143631591292"] = {
            key = "17834111143631591292",
            type = "GoToNode",
            name = "前往",
            pos = {x = 963.1667493796529, y = 506.69677419354855},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890218,
              GuideType = "M",
              GuidePointName = "Mechanism_200404gongchangqu1_332890218"
            }
          },
          ["17834112244851591836"] = {
            key = "17834112244851591836",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1204.1344913151363, y = 494.1161290322583},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890219,
              GuideType = "M",
              GuidePointName = "Mechanism_200404gongchangqu2_332890219"
            }
          }
        },
        commentData = {}
      }
    },
    ["17799540137323241"] = {
      isStoryNode = true,
      key = "17799540137323241",
      type = "StoryNode",
      name = "前往赌场",
      pos = {x = 1082.825512892904, y = 603.6545140849486},
      propsData = {
        QuestId = 20040405,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_6",
        QuestDeatil = "Content_200404_6",
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
        StoryGuidePointName = "Mechanism_200404jinruduchang_332890121",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799540137323242",
            startPort = "QuestStart",
            endQuest = "17803047692553324",
            endPort = "In"
          },
          {
            startQuest = "17803047692553324",
            startPort = "Out",
            endQuest = "17803047516302753",
            endPort = "In"
          },
          {
            startQuest = "17803047516302753",
            startPort = "Out",
            endQuest = "17799540137323245",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799540137323242"] = {
            key = "17799540137323242",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540137323245"] = {
            key = "17799540137323245",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540137323248"] = {
            key = "17799540137323248",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17803047516302753"] = {
            key = "17803047516302753",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1681.7894736842106, y = 386.28070175438575},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51207601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17803047692553324"] = {
            key = "17803047692553324",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1285.298245614035, y = 387.0409356725143},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    },
    ["17799540611503442"] = {
      isStoryNode = true,
      key = "17799540611503442",
      type = "StoryNode",
      name = "到达赌场",
      pos = {x = 1344.2540843214756, y = 600.7973712278058},
      propsData = {
        QuestId = 20040406,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_6",
        QuestDeatil = "Content_200404_6",
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
        StoryGuidePointName = "Mechanism_200404jinruduchang_332890121",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799540611503443",
            startPort = "QuestStart",
            endQuest = "17803048769054382",
            endPort = "In"
          },
          {
            startQuest = "17803048769054382",
            startPort = "Out",
            endQuest = "17803048919444526",
            endPort = "In"
          },
          {
            startQuest = "17803048919444526",
            startPort = "Out",
            endQuest = "17804718133669442",
            endPort = "In"
          },
          {
            startQuest = "17804718133669442",
            startPort = "Out",
            endQuest = "17799540611503446",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799540611503443"] = {
            key = "17799540611503443",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540611503446"] = {
            key = "17799540611503446",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540611503449"] = {
            key = "17799540611503449",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17803048769054382"] = {
            key = "17803048769054382",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1407.4117647058824, y = 275.64705882352933},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890121,
              GuideType = "M",
              GuidePointName = "Mechanism_200404jinruduchang_332890121"
            }
          },
          ["17803048919444526"] = {
            key = "17803048919444526",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1827.4117647058827, y = 314.470588235294},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51207701,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51207701.51207701'",
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
          ["17804718133669442"] = {
            key = "17804718133669442",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2301.846153846154, y = 311.80769230769226},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "200404heluowen",
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
    ["17799540653743564"] = {
      isStoryNode = true,
      key = "17799540653743564",
      type = "StoryNode",
      name = "离开房间，和罗文对话",
      pos = {x = 1609.9683700357612, y = 602.2259426563772},
      propsData = {
        QuestId = 20040407,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_7",
        QuestDeatil = "Content_200404_7",
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
        StoryGuidePointName = "Npc_200404luowen_332890171",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799540653743565",
            startPort = "QuestStart",
            endQuest = "17804718373359970",
            endPort = "In"
          },
          {
            startQuest = "17804718373359970",
            startPort = "Out",
            endQuest = "178047184382310203",
            endPort = "In"
          },
          {
            startQuest = "178047184382310203",
            startPort = "Out",
            endQuest = "178047184791910344",
            endPort = "In"
          },
          {
            startQuest = "178047184791910344",
            startPort = "Out",
            endQuest = "17799540653743568",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799540653743565"] = {
            key = "17799540653743565",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540653743568"] = {
            key = "17799540653743568",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540653743571"] = {
            key = "17799540653743571",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804718373359970"] = {
            key = "17804718373359970",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1317.3333333333337, y = 263.9999999999998},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890171}
            }
          },
          ["178047184382310203"] = {
            key = "178047184382310203",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1699.0000000000002, y = 255.66666666666652},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700430,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404luowen_332890171",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51207801,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["178047184791910344"] = {
            key = "178047184791910344",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2152.333333333334, y = 273.99999999999983},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890171}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799540942704110"] = {
      isStoryNode = true,
      key = "17799540942704110",
      type = "StoryNode",
      name = "回到赌场",
      pos = {x = 1886.0767444199976, y = 603.6545140849487},
      propsData = {
        QuestId = 20040408,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_8",
        QuestDeatil = "Content_200404_8",
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
        StoryGuidePointName = "Npc_200404duchangqianluowen_332890174",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799540942704111",
            startPort = "QuestStart",
            endQuest = "178047238551613003",
            endPort = "In"
          },
          {
            startQuest = "178047238551613003",
            startPort = "Out",
            endQuest = "17799541764754544",
            endPort = "In"
          },
          {
            startQuest = "17799541764754544",
            startPort = "Option_1",
            endQuest = "17799545185806537",
            endPort = "In"
          },
          {
            startQuest = "17799541764754544",
            startPort = "Option_2",
            endQuest = "17799546057837038",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799540942704111"] = {
            key = "17799540942704111",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540942704114"] = {
            key = "17799540942704114",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799540942704117"] = {
            key = "17799540942704117",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17799541764754544"] = {
            key = "17799541764754544",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1809.8468782249738, y = 346.28328173374587},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700430,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404duchangqianluowen_332890174",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51207901,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
                  TalkActorVisible = true
                }
              },
              OptionType = "branch",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "Player",
              PlayerSwitchEmoIdle = true,
              BranchOptions = {"", ""},
              OverrideFailBlend = false
            }
          },
          ["17799545185806537"] = {
            key = "17799545185806537",
            type = "QuestConditionNode",
            name = "QuestCondition-easy",
            pos = {x = 2223.9680143987416, y = 359.72521991252614},
            propsData = {PortName = "easymode"}
          },
          ["17799546057837038"] = {
            key = "17799546057837038",
            type = "QuestConditionNode",
            name = "QuestCondition-normal",
            pos = {x = 2225.1902366209642, y = 488.7252199125262},
            propsData = {PortName = "normalmode"}
          },
          ["178047238551613003"] = {
            key = "178047238551613003",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1288.4, y = 237.9999999999999},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890174}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799549883391029"] = {
      isStoryNode = true,
      key = "17799549883391029",
      type = "StoryNode",
      name = "简单模式游戏",
      pos = {x = 2234.6110100627343, y = 592.1384025935752},
      propsData = {
        QuestId = 20040409,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_9",
        QuestDeatil = "Content_200404_9",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799549883391030",
            startPort = "QuestStart",
            endQuest = "17804735043043023607",
            endPort = "In"
          },
          {
            startQuest = "17804735043043023607",
            startPort = "Out",
            endQuest = "17804735978393024811",
            endPort = "In"
          },
          {
            startQuest = "17804735978393024811",
            startPort = "Out",
            endQuest = "17804736159833025171",
            endPort = "In"
          },
          {
            startQuest = "17804735978393024811",
            startPort = "Out",
            endQuest = "17804736247503025416",
            endPort = "In"
          },
          {
            startQuest = "17804735978393024811",
            startPort = "Out",
            endQuest = "17804736231173025369",
            endPort = "In"
          },
          {
            startQuest = "17804736231173025369",
            startPort = "Out",
            endQuest = "17804737797753026218",
            endPort = "In"
          },
          {
            startQuest = "17804738120483026884",
            startPort = "Out",
            endQuest = "17804738675223028182",
            endPort = "In"
          },
          {
            startQuest = "17804738120483026884",
            startPort = "Out",
            endQuest = "17804738675223028184",
            endPort = "In"
          },
          {
            startQuest = "17804738120483026884",
            startPort = "Out",
            endQuest = "17804738675223028183",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028186",
            startPort = "Out",
            endQuest = "17804738706543028309",
            endPort = "In"
          },
          {
            startQuest = "17804738706543028313",
            startPort = "Out",
            endQuest = "17804739872483029934",
            endPort = "In"
          },
          {
            startQuest = "17804739872483029934",
            startPort = "Out",
            endQuest = "17804740047553030191",
            endPort = "In"
          },
          {
            startQuest = "17804740047553030191",
            startPort = "Out",
            endQuest = "17799549883391033",
            endPort = "Success"
          },
          {
            startQuest = "17804738706543028313",
            startPort = "Out",
            endQuest = "17804740597103031167",
            endPort = "In"
          },
          {
            startQuest = "17804736231173025369",
            startPort = "Out",
            endQuest = "17804736159833025171",
            endPort = "Stop"
          },
          {
            startQuest = "17804736231173025369",
            startPort = "Out",
            endQuest = "17804736247503025416",
            endPort = "Stop"
          },
          {
            startQuest = "17804738675223028183",
            startPort = "Out",
            endQuest = "17804738675223028182",
            endPort = "Stop"
          },
          {
            startQuest = "17804738675223028183",
            startPort = "Out",
            endQuest = "17804738675223028184",
            endPort = "Stop"
          },
          {
            startQuest = "17804738706543028310",
            startPort = "Out",
            endQuest = "17804738706543028309",
            endPort = "Stop"
          },
          {
            startQuest = "17804738706543028310",
            startPort = "Out",
            endQuest = "17804738706543028311",
            endPort = "Stop"
          },
          {
            startQuest = "17804737797753026218",
            startPort = "Out",
            endQuest = "178064806192210646208",
            endPort = "In"
          },
          {
            startQuest = "178064806192210646208",
            startPort = "Out",
            endQuest = "17804738120483026884",
            endPort = "In"
          },
          {
            startQuest = "178064848740410646944",
            startPort = "Out",
            endQuest = "178064848740410646945",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028183",
            startPort = "Out",
            endQuest = "178064848740410646944",
            endPort = "In"
          },
          {
            startQuest = "178064848740410646945",
            startPort = "Out",
            endQuest = "17804738675223028186",
            endPort = "In"
          },
          {
            startQuest = "178064850573410647517",
            startPort = "Out",
            endQuest = "178064850573410647518",
            endPort = "In"
          },
          {
            startQuest = "17804738706543028310",
            startPort = "Out",
            endQuest = "178064850573410647517",
            endPort = "In"
          },
          {
            startQuest = "178064850573410647518",
            startPort = "Out",
            endQuest = "17804738706543028313",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028186",
            startPort = "Out",
            endQuest = "17804738706543028311",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028186",
            startPort = "Out",
            endQuest = "17804738706543028310",
            endPort = "In"
          },
          {
            startQuest = "17804735978393024811",
            startPort = "Out",
            endQuest = "178066065951030411802",
            endPort = "In"
          },
          {
            startQuest = "17804736231173025369",
            startPort = "Out",
            endQuest = "178066067407030412061",
            endPort = "In"
          },
          {
            startQuest = "17804738120483026884",
            startPort = "Out",
            endQuest = "178066069651030412506",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028186",
            startPort = "Out",
            endQuest = "178066070872130412764",
            endPort = "In"
          },
          {
            startQuest = "17804738675223028183",
            startPort = "Out",
            endQuest = "178066072709730413265",
            endPort = "In"
          },
          {
            startQuest = "17804738706543028310",
            startPort = "Out",
            endQuest = "178066073378330413500",
            endPort = "In"
          },
          {
            startQuest = "17804735043043023607",
            startPort = "Out",
            endQuest = "17807451777694562115",
            endPort = "In"
          },
          {
            startQuest = "17804738706543028313",
            startPort = "Out",
            endQuest = "17807451972854562511",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799549883391030"] = {
            key = "17799549883391030",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799549883391033"] = {
            key = "17799549883391033",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 6042.2807017543855, y = 484.2105263157897},
            propsData = {ModeType = 0}
          },
          ["17799549883391036"] = {
            key = "17799549883391036",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 6024.8405103668265, y = 701.3078149920256},
            propsData = {}
          },
          ["17804735043043023607"] = {
            key = "17804735043043023607",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1094.1052631578948, y = 236.73684210526315},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890177,
              GuideType = "M",
              GuidePointName = "Mechanism_200404duchang_332890177"
            }
          },
          ["17804735978393024811"] = {
            key = "17804735978393024811",
            type = "ChangeStaticCreatorNode",
            name = "生成三个空npc（位于桌上）",
            pos = {x = 1414.4210526315787, y = 78.10526315789468},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890178,
                332890179,
                332890180
              }
            }
          },
          ["17804736159833025171"] = {
            key = "17804736159833025171",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1876.7803992740473, y = 76.5807622504537},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700487,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc1_332890178",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208001,
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
          ["17804736231173025369"] = {
            key = "17804736231173025369",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2117.6696914700547, y = 196.3629764065336},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700489,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc3_332890180",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208201,
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
          ["17804736247503025416"] = {
            key = "17804736247503025416",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1838.6315789473688, y = 240.73684210526315},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700488,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc2_332890179",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208101,
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
          ["17804737797753026218"] = {
            key = "17804737797753026218",
            type = "ListenPlayerSkillAndActionNode",
            name = "监听玩家技能和动作",
            pos = {x = 2376.6112054329374, y = 165.91511035653647},
            propsData = {
              ListenIds = {41009},
              CompareType = 2,
              ListenCount = 1,
              ListenType = 0,
              StaticPointId = 332890177,
              StaticPointListenMinCM = 0,
              StaticPointListenMaxCM = 1000
            }
          },
          ["17804738120483026884"] = {
            key = "17804738120483026884",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2559.157894736842, y = 390.7368421052632},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51208203,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51208403.51208403'",
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
          ["17804738675223028182"] = {
            key = "17804738675223028182",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3085.3678160919535, y = 130.47368421052647},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700487,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc1_332890178",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208001,
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
          ["17804738675223028183"] = {
            key = "17804738675223028183",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3345.912280701754, y = 207.84210526315803},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700488,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc2_332890179",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208301,
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
          ["17804738675223028184"] = {
            key = "17804738675223028184",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3091.7017543859647, y = 291.52631578947387},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700489,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc3_332890180",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208101,
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
          ["17804738675223028186"] = {
            key = "17804738675223028186",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3812.228070175438, y = 441.52631578947387},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51208303,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51208303.51208303'",
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
          ["17804738706543028309"] = {
            key = "17804738706543028309",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 4309.724696356275, y = 180.87854251012138},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700488,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc2_332890179",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208001,
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
          ["17804738706543028310"] = {
            key = "17804738706543028310",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 4604.765182186235, y = 279.01619433198385},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700487,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc1_332890178",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208401,
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
          ["17804738706543028311"] = {
            key = "17804738706543028311",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 4312.4777327935235, y = 330.39271255060726},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700489,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc3_332890180",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208101,
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
          ["17804738706543028313"] = {
            key = "17804738706543028313",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 5034.1578947368425, y = 488.8947368421053},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51208403,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51208203.51208203'",
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
          ["17804739872483029934"] = {
            key = "17804739872483029934",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 5401.964912280701, y = 510.2105263157895},
            propsData = {WaitTime = 2}
          },
          ["17804740047553030191"] = {
            key = "17804740047553030191",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 5743.017543859649, y = 497.5789473684209},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51208501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17804740597103031167"] = {
            key = "17804740597103031167",
            type = "ChangeStaticCreatorNode",
            name = "销毁空npc",
            pos = {x = 5434.248194014448, y = 717.7724458204335},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890178,
                332890179,
                332890180
              }
            }
          },
          ["178064806192210646208"] = {
            key = "178064806192210646208",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2629.24009844536, y = 211.5166669553499},
            propsData = {WaitTime = 2}
          },
          ["178064848740410646944"] = {
            key = "178064848740410646944",
            type = "ListenPlayerSkillAndActionNode",
            name = "监听玩家技能和动作",
            pos = {x = 3604.7205237340204, y = 190.25435019440488},
            propsData = {
              ListenIds = {41009},
              CompareType = 2,
              ListenCount = 1,
              ListenType = 0,
              StaticPointId = 332890177,
              StaticPointListenMinCM = 0,
              StaticPointListenMaxCM = 1000
            }
          },
          ["178064848740410646945"] = {
            key = "178064848740410646945",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 3857.3494167464432, y = 235.8559067932183},
            propsData = {WaitTime = 2}
          },
          ["178064850573410647517"] = {
            key = "178064850573410647517",
            type = "ListenPlayerSkillAndActionNode",
            name = "监听玩家技能和动作",
            pos = {x = 4845.137190400687, y = 207.2735809636357},
            propsData = {
              ListenIds = {41009},
              CompareType = 2,
              ListenCount = 1,
              ListenType = 0,
              StaticPointId = 332890177,
              StaticPointListenMinCM = 0,
              StaticPointListenMaxCM = 1000
            }
          },
          ["178064850573410647518"] = {
            key = "178064850573410647518",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 5070.26608341311, y = 296.62513756244914},
            propsData = {WaitTime = 2}
          },
          ["178066065951030411802"] = {
            key = "178066065951030411802",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1687.7323316507518, y = -165.6713099799956},
            propsData = {
              NewDescription = "Description_200404_10",
              NewDetail = "Content_200404_10",
              SubTaskTargetIndex = 0
            }
          },
          ["178066067407030412061"] = {
            key = "178066067407030412061",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2299.2707931892137, y = 405.4825361738506},
            propsData = {
              NewDescription = "Description_200404_11",
              NewDetail = "Content_200404_11",
              SubTaskTargetIndex = 0
            }
          },
          ["178066069651030412506"] = {
            key = "178066069651030412506",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 3008.8861778045984, y = -121.82515613384169},
            propsData = {
              NewDescription = "Description_200404_12",
              NewDetail = "Content_200404_12",
              SubTaskTargetIndex = 0
            }
          },
          ["178066070872130412764"] = {
            key = "178066070872130412764",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 4231.963100881521, y = -135.67130997999547},
            propsData = {
              NewDescription = "Description_200404_13",
              NewDetail = "Content_200404_13",
              SubTaskTargetIndex = 0
            }
          },
          ["178066072709730413265"] = {
            key = "178066072709730413265",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 3527.347716266137, y = 407.79022848154295},
            propsData = {
              NewDescription = "Description_200404_11",
              NewDetail = "Content_200404_11",
              SubTaskTargetIndex = 0
            }
          },
          ["178066073378330413500"] = {
            key = "178066073378330413500",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 4804.655408573828, y = 450.4825361738507},
            propsData = {
              NewDescription = "Description_200404_11",
              NewDetail = "Content_200404_11",
              SubTaskTargetIndex = 0
            }
          },
          ["17807451777694562115"] = {
            key = "17807451777694562115",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1401.7625192789665, y = -168.58700838635048},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "200404gesture"
            }
          },
          ["17807451972854562511"] = {
            key = "17807451972854562511",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 5540.2000192789665, y = 310.4754916136495},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "200404gesture"
            }
          }
        },
        commentData = {
          ["17804735417713024128"] = {
            key = "17804735417713024128",
            name = "第一轮游戏",
            position = {x = 1766.526315789474, y = -7.15789473684217},
            size = {width = 1109.9999999999998, height = 623.6842105263158}
          },
          ["17804738757153028509"] = {
            key = "17804738757153028509",
            name = "第二轮",
            position = {x = 3050.035087719298, y = 41.438596491228054},
            size = {width = 1035.7894736842106, height = 560.5263157894738}
          },
          ["17804738854963028707"] = {
            key = "17804738854963028707",
            name = "第三轮",
            position = {x = 4282.666666666667, y = 45.12280701754389},
            size = {width = 1020, height = 588.9473684210527}
          },
          ["17815071198266892"] = {
            key = "17815071198266892",
            name = "需要放一个围观的男人，庄家和罗文用seq刷出",
            position = {x = 1182, y = 582.6153846153848},
            size = {width = 509.00000000000017, height = 239.99999999999991}
          }
        }
      }
    },
    ["17799549950671210"] = {
      isStoryNode = true,
      key = "17799549950671210",
      type = "StoryNode",
      name = "标准模式游戏",
      pos = {x = 2236.6799755799752, y = 770.0694370763339},
      propsData = {
        QuestId = 20040410,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_9",
        QuestDeatil = "Content_200404_9",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804741892604539555",
            startPort = "Out",
            endQuest = "17804741378814538648",
            endPort = "In"
          },
          {
            startQuest = "17804741892604539555",
            startPort = "Out",
            endQuest = "17804741607864539000",
            endPort = "In"
          },
          {
            startQuest = "17804741378814538648",
            startPort = "Out",
            endQuest = "17804742271074540041",
            endPort = "Branch_1"
          },
          {
            startQuest = "17804742700314540827",
            startPort = "Out",
            endQuest = "17804742700314540828",
            endPort = "In"
          },
          {
            startQuest = "17804742271074540041",
            startPort = "Out",
            endQuest = "17804742700314540827",
            endPort = "In"
          },
          {
            startQuest = "17804742700314540828",
            startPort = "Out",
            endQuest = "17799549950671214",
            endPort = "Success"
          },
          {
            startQuest = "17804742271074540041",
            startPort = "Out",
            endQuest = "17804742879504541323",
            endPort = "In"
          },
          {
            startQuest = "17799549950671211",
            startPort = "QuestStart",
            endQuest = "17804742950004541528",
            endPort = "In"
          },
          {
            startQuest = "17804742950004541528",
            startPort = "Out",
            endQuest = "17804741892604539555",
            endPort = "In"
          },
          {
            startQuest = "17842709337643839",
            startPort = "Out",
            endQuest = "17842709337643840",
            endPort = "In"
          },
          {
            startQuest = "17804741607864539000",
            startPort = "Out",
            endQuest = "17842709337643839",
            endPort = "In"
          },
          {
            startQuest = "17842709337643840",
            startPort = "Out",
            endQuest = "17804742271074540041",
            endPort = "Branch_2"
          },
          {
            startQuest = "17804741607864539000",
            startPort = "Out",
            endQuest = "17842709337643841",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799549950671211"] = {
            key = "17799549950671211",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799549950671214"] = {
            key = "17799549950671214",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2870.344827586207, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799549950681217"] = {
            key = "17799549950681217",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804741378814538648"] = {
            key = "17804741378814538648",
            type = "TalkNode",
            name = "调查第一张桌子",
            pos = {x = 1579.8487394957983, y = 184.5011459129107},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700487,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc1_332890178",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208601,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51208601.51208601'",
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700437,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700438,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700430,
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
          ["17804741607864539000"] = {
            key = "17804741607864539000",
            type = "TalkNode",
            name = "调查第二张桌子",
            pos = {x = 1404.31274202471, y = 591.9929928084085},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700488,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc2_332890179",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51208701,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51208701.51208701'",
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
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700437,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700439,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700430,
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
          ["17804741892604539555"] = {
            key = "17804741892604539555",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1258.9679144385027, y = 329.4224598930481},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200404_14",
                  TargetBranchQuestKey = "17804741378814538648"
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "Description_200404_15",
                  TargetBranchQuestKey = "17804741607864539000"
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["17804742271074540041"] = {
            key = "17804742271074540041",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1924.4224598930482, y = 326.6951871657754},
            propsData = {
              InputBranchQuestNumber = 2,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["17804742700314540827"] = {
            key = "17804742700314540827",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 2247.877335326146, y = 337.1018857303688},
            propsData = {WaitTime = 2}
          },
          ["17804742700314540828"] = {
            key = "17804742700314540828",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2588.929966905093, y = 324.47030678300024},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51208801,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17804742879504541323"] = {
            key = "17804742879504541323",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2287.6042780748667, y = 555.331550802139},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890178,
                332890179,
                332890189,
                332890190,
                332890191
              }
            }
          },
          ["17804742950004541528"] = {
            key = "17804742950004541528",
            type = "ChangeStaticCreatorNode",
            name = "生成两张桌子上的空npc",
            pos = {x = 1073.0588235294117, y = 178.05882352941165},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890178,
                332890179,
                332890190,
                332890191,
                332890189
              }
            }
          },
          ["17842709337643839"] = {
            key = "17842709337643839",
            type = "ListenPlayerSkillAndActionNode",
            name = "监听玩家技能和动作",
            pos = {x = 1707.2720157732856, y = 598.7975678795206},
            propsData = {
              ListenIds = {41009},
              CompareType = 2,
              ListenCount = 1,
              ListenType = 0,
              StaticPointId = 332890177,
              StaticPointListenMinCM = 0,
              StaticPointListenMaxCM = 1000
            }
          },
          ["17842709337643840"] = {
            key = "17842709337643840",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1983.694012233984, y = 574.0542968921269},
            propsData = {WaitTime = 2}
          },
          ["17842709337643841"] = {
            key = "17842709337643841",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1692.0005690468033, y = 775.2615454209724},
            propsData = {
              NewDescription = "Description_200404_11",
              NewDetail = "Content_200404_9",
              SubTaskTargetIndex = 2
            }
          }
        },
        commentData = {}
      }
    },
    ["17799589190921685"] = {
      isStoryNode = true,
      key = "17799589190921685",
      type = "StoryNode",
      name = "出赌场",
      pos = {x = 2585.2623510589024, y = 676.7361037430005},
      propsData = {
        QuestId = 20040411,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_16",
        QuestDeatil = "Content_200404_16",
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
        StoryGuidePointName = "Npc_200404luowenheliangbei_332890175",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804757854444544079",
            startPort = "Out",
            endQuest = "17799589190921689",
            endPort = "Success"
          },
          {
            startQuest = "17799589190921686",
            startPort = "QuestStart",
            endQuest = "178064937029216727383",
            endPort = "In"
          },
          {
            startQuest = "178064937029216727383",
            startPort = "Out",
            endQuest = "17804757854444544079",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799589190921686"] = {
            key = "17799589190921686",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799589190921689"] = {
            key = "17799589190921689",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799589190921692"] = {
            key = "17799589190921692",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804757854444544079"] = {
            key = "17804757854444544079",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1594.75, y = 311},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51208901,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178064937029216727383"] = {
            key = "178064937029216727383",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1065.7272727272727, y = 218.7272727272727},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890174}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799592790382441"] = {
      isStoryNode = true,
      key = "17799592790382441",
      type = "StoryNode",
      name = "喝两杯",
      pos = {x = 1071.8523893730787, y = 884.8970232832304},
      propsData = {
        QuestId = 20040412,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_16",
        QuestDeatil = "Content_200404_16",
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
        StoryGuidePointName = "Npc_200404luowenheliangbei_332890175",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804765855464545597",
            startPort = "Out",
            endQuest = "17799592790382445",
            endPort = "Success"
          },
          {
            startQuest = "17799592790382442",
            startPort = "QuestStart",
            endQuest = "178064941415716728306",
            endPort = "In"
          },
          {
            startQuest = "178064941415716728306",
            startPort = "Out",
            endQuest = "17804765855464545597",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799592790382442"] = {
            key = "17799592790382442",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799592790382445"] = {
            key = "17799592790382445",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799592790382448"] = {
            key = "17799592790382448",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804765855464545597"] = {
            key = "17804765855464545597",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1726, y = 318},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700430,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404luowenheliangbei_332890175",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51209001,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["178064941415716728306"] = {
            key = "178064941415716728306",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1272.8198051948054, y = 302.85},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890175}
            }
          }
        },
        commentData = {}
      }
    },
    ["17799593975693077"] = {
      isStoryNode = true,
      key = "17799593975693077",
      type = "StoryNode",
      name = "回赌场",
      pos = {x = 1343.9213548903194, y = 881.7935750073683},
      propsData = {
        QuestId = 20040413,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_17",
        QuestDeatil = "Content_200404_17",
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
        StoryGuidePointName = "Mechanism_200404jinruduchang_332890121",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799593975693078",
            startPort = "QuestStart",
            endQuest = "178064958695718248086",
            endPort = "In"
          },
          {
            startQuest = "178064958695718248086",
            startPort = "Out",
            endQuest = "17804768563516053869",
            endPort = "In"
          },
          {
            startQuest = "17804768563516053869",
            startPort = "Out",
            endQuest = "178064947766016729237",
            endPort = "In"
          },
          {
            startQuest = "178064947766016729237",
            startPort = "Out",
            endQuest = "178064997354422807077",
            endPort = "In"
          },
          {
            startQuest = "178064997354422807077",
            startPort = "Out",
            endQuest = "17799593975703081",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799593975693078"] = {
            key = "17799593975693078",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799593975703081"] = {
            key = "17799593975703081",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799593975703084"] = {
            key = "17799593975703084",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804768563516053869"] = {
            key = "17804768563516053869",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1554.139097744361, y = 292.17669172932335},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 51209101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178064947766016729237"] = {
            key = "178064947766016729237",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1920.5714285714284, y = 336.77142857142866},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890175}
            }
          },
          ["178064958695718248086"] = {
            key = "178064958695718248086",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1215.2, y = 274.3714285714286},
            propsData = {WaitTime = 1}
          },
          ["178064997354422807077"] = {
            key = "178064997354422807077",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2203.7028083028076, y = 333.3825396825397},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890176,
                332890178,
                332890179
              }
            }
          }
        },
        commentData = {}
      }
    },
    ["17799594363223416"] = {
      isStoryNode = true,
      key = "17799594363223416",
      type = "StoryNode",
      name = "再回赌场",
      pos = {x = 1672.7213548903194, y = 900.57978190392},
      propsData = {
        QuestId = 20040414,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_17",
        QuestDeatil = "Content_200404_17",
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
        StoryGuidePointName = "Mechanism_200404jinruduchang_332890121",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799594363223417",
            startPort = "QuestStart",
            endQuest = "17804768977736054622",
            endPort = "In"
          },
          {
            startQuest = "17804769256626055012",
            startPort = "Out",
            endQuest = "17804769411196055212",
            endPort = "In"
          },
          {
            startQuest = "17804769411196055212",
            startPort = "Out",
            endQuest = "17799594576023798",
            endPort = "In"
          },
          {
            startQuest = "17804768977736054622",
            startPort = "Out",
            endQuest = "17804769256626055012",
            endPort = "In"
          },
          {
            startQuest = "17804768977736054622",
            startPort = "Out",
            endQuest = "17807336064583926",
            endPort = "In"
          },
          {
            startQuest = "17804769256626055012",
            startPort = "Out",
            endQuest = "17807336387184316",
            endPort = "In"
          },
          {
            startQuest = "17804769411196055212",
            startPort = "Out",
            endQuest = "17807337469604574",
            endPort = "In"
          },
          {
            startQuest = "17799594576023798",
            startPort = "Option_1",
            endQuest = "17799594665463999",
            endPort = "In"
          },
          {
            startQuest = "17799594576023798",
            startPort = "Option_2",
            endQuest = "17799594676984034",
            endPort = "In"
          }
        },
        nodeData = {
          ["17799594363223417"] = {
            key = "17799594363223417",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799594363223420"] = {
            key = "17799594363223420",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799594363223423"] = {
            key = "17799594363223423",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17799594576023798"] = {
            key = "17799594576023798",
            type = "TalkNode",
            name = "和白对话",
            pos = {x = 1784.144927536232, y = 478.1304347826087},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700449,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404baiinduchang_332890176",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51209401,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51209401.51209401'",
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
          ["17799594665463999"] = {
            key = "17799594665463999",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 2131.0833333333335, y = 441.37499999999994},
            propsData = {PortName = "help"}
          },
          ["17799594676984034"] = {
            key = "17799594676984034",
            type = "QuestConditionNode",
            name = "QuestCondition",
            pos = {x = 2136.0833333333335, y = 601.3749999999998},
            propsData = {PortName = "betray"}
          },
          ["17804768977736054622"] = {
            key = "17804768977736054622",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1243.913043478261, y = 303.3913043478261},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890121,
              GuideType = "M",
              GuidePointName = "Mechanism_200404jinruduchang_332890121"
            }
          },
          ["17804769256626055012"] = {
            key = "17804769256626055012",
            type = "TalkNode",
            name = "交互第一张桌子",
            pos = {x = 1524.3478260869565, y = 231.6521739130435},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700488,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc2_332890179",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51209201,
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
          ["17804769411196055212"] = {
            key = "17804769411196055212",
            type = "TalkNode",
            name = "交互第二张桌子",
            pos = {x = 1799.5652173913043, y = 225.1304347826087},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "Description_200404_25",
              NpcId = 700487,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404kongnpc1_332890178",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 51209301,
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
          ["17807336064583926"] = {
            key = "17807336064583926",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1512.9999999999995, y = 36.74999999999991},
            propsData = {
              NewDescription = "Description_200404_18",
              NewDetail = "Content_200404_18",
              SubTaskTargetIndex = 0
            }
          },
          ["17807336387184316"] = {
            key = "17807336387184316",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1841.8888888888887, y = 41.19444444444445},
            propsData = {
              NewDescription = "Description_200404_19",
              NewDetail = "Content_200404_19",
              SubTaskTargetIndex = 0
            }
          },
          ["17807337469604574"] = {
            key = "17807337469604574",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2238.5555555555557, y = 191.19444444444446},
            propsData = {
              NewDescription = "Description_200404_20",
              NewDetail = "Content_200404_20",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["17799596152701115"] = {
      isStoryNode = true,
      key = "17799596152701115",
      type = "StoryNode",
      name = "帮助罗文",
      pos = {x = 2241.219288528808, y = 1039.7522013590124},
      propsData = {
        QuestId = 20040415,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_22",
        QuestDeatil = "Content_200404_22",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804772911406058189",
            startPort = "Out",
            endQuest = "17804772972276058267",
            endPort = "In"
          },
          {
            startQuest = "17799596152701116",
            startPort = "QuestStart",
            endQuest = "17804772911406058189",
            endPort = "In"
          },
          {
            startQuest = "17804772972276058267",
            startPort = "Out",
            endQuest = "17799596152701119",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799596152701116"] = {
            key = "17799596152701116",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596152701119"] = {
            key = "17799596152701119",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596152701122"] = {
            key = "17799596152701122",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804772911406058189"] = {
            key = "17804772911406058189",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1194, y = 284},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890177,
              GuideType = "M",
              GuidePointName = "Mechanism_200404duchang_332890177"
            }
          },
          ["17804772972276058267"] = {
            key = "17804772972276058267",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1528, y = 298},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51209601,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51209601.51209601'",
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
    ["17799596207651262"] = {
      isStoryNode = true,
      key = "17799596207651262",
      type = "StoryNode",
      name = "背叛罗文",
      pos = {x = 2511.8072861521, y = 1407.431325255175},
      propsData = {
        QuestId = 20040417,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_21",
        QuestDeatil = "Content_200404_21",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804788252186065262",
            startPort = "Out",
            endQuest = "17804788252186065263",
            endPort = "In"
          },
          {
            startQuest = "17799596207651263",
            startPort = "QuestStart",
            endQuest = "17804788252186065262",
            endPort = "In"
          },
          {
            startQuest = "17804788252186065263",
            startPort = "Out",
            endQuest = "17799596207651266",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799596207651263"] = {
            key = "17799596207651263",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596207651266"] = {
            key = "17799596207651266",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596207651269"] = {
            key = "17799596207651269",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804788252186065262"] = {
            key = "17804788252186065262",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1167, y = 327},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890177,
              GuideType = "M",
              GuidePointName = "Mechanism_200404duchang_332890177"
            }
          },
          ["17804788252186065263"] = {
            key = "17804788252186065263",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1501, y = 341},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51209501,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51209501.51209501'",
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
    ["17799596489101701"] = {
      isStoryNode = true,
      key = "17799596489101701",
      type = "StoryNode",
      name = "出赌场",
      pos = {x = 2980.3134061758665, y = 1039.7233243536648},
      propsData = {
        QuestId = 20040416,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_24",
        QuestDeatil = "Content_200404_24",
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_200404luowen_332890171",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17799596489101702",
            startPort = "QuestStart",
            endQuest = "17804782431706063545",
            endPort = "In"
          },
          {
            startQuest = "17804782431706063545",
            startPort = "Out",
            endQuest = "17804782483216063600",
            endPort = "In"
          },
          {
            startQuest = "17804782483216063600",
            startPort = "Out",
            endQuest = "17804786014876063857",
            endPort = "In"
          },
          {
            startQuest = "17804786014876063857",
            startPort = "Out",
            endQuest = "17799596489101705",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17799596489101702"] = {
            key = "17799596489101702",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596489101705"] = {
            key = "17799596489101705",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17799596489101708"] = {
            key = "17799596489101708",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804782431706063545"] = {
            key = "17804782431706063545",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1450, y = 204},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890171}
            }
          },
          ["17804782483216063600"] = {
            key = "17804782483216063600",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1866, y = 362},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 700430,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_200404luowen_332890171",
              DelayShowGuideTime = 0,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = true,
              FirstDialogueId = 51209801,
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 700449,
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
          ["17804786014876063857"] = {
            key = "17804786014876063857",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2332, y = 432},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {332890171}
            }
          }
        },
        commentData = {}
      }
    },
    ["17804773284696058835"] = {
      isStoryNode = true,
      key = "17804773284696058835",
      type = "StoryNode",
      name = "战斗",
      pos = {x = 2503.01697056043, y = 1043.654020868805},
      propsData = {
        QuestId = 20040418,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_23",
        QuestDeatil = "Content_200404_23",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804773284696058836",
            startPort = "QuestStart",
            endQuest = "17804774374306060343",
            endPort = "In"
          },
          {
            startQuest = "17804774374306060343",
            startPort = "Out",
            endQuest = "17804775540576060978",
            endPort = "In"
          },
          {
            startQuest = "17804775540576060978",
            startPort = "Out",
            endQuest = "17804773988206059725",
            endPort = "In"
          },
          {
            startQuest = "17804773988206059725",
            startPort = "Out",
            endQuest = "17804773284696058839",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804773284696058836"] = {
            key = "17804773284696058836",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17804773284696058839"] = {
            key = "17804773284696058839",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2606, y = 274},
            propsData = {ModeType = 0}
          },
          ["17804773284696058842"] = {
            key = "17804773284696058842",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804773988206059725"] = {
            key = "17804773988206059725",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1824, y = 156},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 3,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                332890182,
                332890183,
                332890184
              }
            }
          },
          ["17804774374306060343"] = {
            key = "17804774374306060343",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1190, y = 172},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890177,
              GuideType = "M",
              GuidePointName = "Mechanism_200404duchang_332890177"
            }
          },
          ["17804775540576060978"] = {
            key = "17804775540576060978",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1488, y = 164},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                332890182,
                332890183,
                332890184
              }
            }
          }
        },
        commentData = {
          ["17804775730056061541"] = {
            key = "17804775730056061541",
            name = "击杀怪物需要生成销毁静态点吗——不用销毁",
            position = {x = 1448.607142857143, y = 404.5},
            size = {width = 600, height = 400}
          }
        }
      }
    },
    ["17804776538776061884"] = {
      isStoryNode = true,
      key = "17804776538776061884",
      type = "StoryNode",
      name = "战斗后对话",
      pos = {x = 2739.0169705604303, y = 1040.054020868805},
      propsData = {
        QuestId = 20040419,
        QuestDescriptionComment = "",
        QuestDescription = "Description_200404_23",
        QuestDeatil = "Content_200404_23",
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
        StoryGuidePointName = "Mechanism_200404duchang_332890177",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17804776884446062777",
            startPort = "Out",
            endQuest = "17804776884446062778",
            endPort = "In"
          },
          {
            startQuest = "17804776538776061889",
            startPort = "QuestStart",
            endQuest = "17804776884446062777",
            endPort = "In"
          },
          {
            startQuest = "17804776884446062778",
            startPort = "Out",
            endQuest = "17804776538776061890",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17804776538776061889"] = {
            key = "17804776538776061889",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17804776538776061890"] = {
            key = "17804776538776061890",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2606, y = 274},
            propsData = {ModeType = 0}
          },
          ["17804776538776061891"] = {
            key = "17804776538776061891",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17804776884446062777"] = {
            key = "17804776884446062777",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1465, y = 271},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 332890177,
              GuideType = "M",
              GuidePointName = "Mechanism_200404duchang_332890177"
            }
          },
          ["17804776884446062778"] = {
            key = "17804776884446062778",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1799, y = 285},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 51209701,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2004/200404/51209701.51209701'",
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
    }
  },
  commentData = {
    ["178064988883422805381"] = {
      key = "178064988883422805381",
      name = "帮助结局",
      position = {x = 2181.294117647059, y = 935.4199643493765},
      size = {width = 1089.5454545454547, height = 293.1818181818182}
    },
    ["178064990448222805759"] = {
      key = "178064990448222805759",
      name = "背叛结局",
      position = {x = 2389.6898395721923, y = 1311.3825311942962},
      size = {width = 477.2727272727276, height = 301.3636363636364}
    }
  }
}
