return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874956596429219594",
      startPort = "StoryStart",
      endStory = "177874999062229219670",
      endPort = "In"
    },
    {
      startStory = "177874999062229219670",
      startPort = "Success",
      endStory = "177874956596429219597",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874956596429219594"] = {
      isStoryNode = true,
      key = "177874956596429219594",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1006.0869565217391, y = 284.3478260869565},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874956596429219597"] = {
      isStoryNode = true,
      key = "177874956596429219597",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1883.0434782608695, y = 301.30434782608694},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874999062229219670"] = {
      isStoryNode = true,
      key = "177874999062229219670",
      type = "StoryNode",
      name = "反制卡嘉计划",
      pos = {x = 1490, y = 260},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040421_01",
        QuestDeatil = "",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = false,
        bIsEndQuest = false,
        bIsNotifyGameMode = true,
        bIsStartChapter = false,
        bIsEndChapter = false,
        bIsPlayBlackScreenOnComplete = true,
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
            startQuest = "177874999062329219678",
            startPort = "Out",
            endQuest = "177874999062329219680",
            endPort = "In"
          },
          {
            startQuest = "177874999062329219680",
            startPort = "Out",
            endQuest = "177874999062329219679",
            endPort = "In"
          },
          {
            startQuest = "177874999062329219675",
            startPort = "QuestStart",
            endQuest = "177875000269729220071",
            endPort = "In"
          },
          {
            startQuest = "177874999062329219679",
            startPort = "Out",
            endQuest = "177875005612830194212",
            endPort = "In"
          },
          {
            startQuest = "177874999062329219675",
            startPort = "QuestStart",
            endQuest = "177875006167930194366",
            endPort = "In"
          },
          {
            startQuest = "177875006167930194366",
            startPort = "Out",
            endQuest = "177874999062329219677",
            endPort = "Fail"
          },
          {
            startQuest = "177874999062329219675",
            startPort = "QuestStart",
            endQuest = "17787554406993902026",
            endPort = "In"
          },
          {
            startQuest = "17787554406993902026",
            startPort = "Out",
            endQuest = "177874999062329219678",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874999062329219675"] = {
            key = "177874999062329219675",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 434.79999999999995, y = 419.2},
            propsData = {ModeType = 0}
          },
          ["177874999062329219676"] = {
            key = "177874999062329219676",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2321.6570855614973, y = 406.0437834224599},
            propsData = {ModeType = 0}
          },
          ["177874999062329219677"] = {
            key = "177874999062329219677",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1556, y = 706},
            propsData = {}
          },
          ["177874999062329219678"] = {
            key = "177874999062329219678",
            type = "TalkNode",
            name = "制定计划前",
            pos = {x = 1160, y = 393.1818181818182},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047501.10047501'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 2,
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
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["177874999062329219679"] = {
            key = "177874999062329219679",
            type = "TalkNode",
            name = "制定计划",
            pos = {x = 1783, y = 409},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047601.10047601'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 2,
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
              SwitchToMaster = "None",
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["177874999062329219680"] = {
            key = "177874999062329219680",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1474.7894736842106, y = 422.0625},
            propsData = {
              StaticCreatorId = 272640046,
              UnitId = 10076,
              bGuideUIEnable = true,
              GuidePointName = "BP_Diaocha_272640046",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177875000269729220071"] = {
            key = "177875000269729220071",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1174, y = 172},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177875005612830194212"] = {
            key = "177875005612830194212",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2062, y = 422},
            propsData = {}
          },
          ["177875006167930194366"] = {
            key = "177875006167930194366",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1208, y = 658},
            propsData = {}
          },
          ["17787554406993902026"] = {
            key = "17787554406993902026",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 879.9789473684209, y = 420.4000000000001},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_Kanuo",
              FadeIn = false,
              FadeOut = false,
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
