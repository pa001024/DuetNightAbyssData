return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177875021303231168377",
      startPort = "StoryStart",
      endStory = "177875021439231168409",
      endPort = "In"
    },
    {
      startStory = "177875021439231168409",
      startPort = "Success",
      endStory = "177875021303231168380",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177875021303231168377"] = {
      isStoryNode = true,
      key = "177875021303231168377",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 952, y = 374},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177875021303231168380"] = {
      isStoryNode = true,
      key = "177875021303231168380",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1822, y = 350},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177875021439231168409"] = {
      isStoryNode = true,
      key = "177875021439231168409",
      type = "StoryNode",
      name = "反制卡嘉前",
      pos = {x = 1444, y = 356},
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
            startQuest = "177875021439231168414",
            startPort = "QuestStart",
            endQuest = "177875021439231168419",
            endPort = "In"
          },
          {
            startQuest = "177875021439231168419",
            startPort = "Out",
            endQuest = "177875021439231168417",
            endPort = "In"
          },
          {
            startQuest = "177875021439231168417",
            startPort = "Out",
            endQuest = "177875021439231168420",
            endPort = "In"
          },
          {
            startQuest = "177875021439231168420",
            startPort = "Out",
            endQuest = "177875021439231168418",
            endPort = "In"
          },
          {
            startQuest = "177875021439231168414",
            startPort = "QuestStart",
            endQuest = "177875023103231168840",
            endPort = "In"
          },
          {
            startQuest = "177875021439231168414",
            startPort = "QuestStart",
            endQuest = "177875024211931169091",
            endPort = "In"
          },
          {
            startQuest = "177875024211931169091",
            startPort = "Out",
            endQuest = "177875021439231168416",
            endPort = "Fail"
          },
          {
            startQuest = "177875021439231168418",
            startPort = "Out",
            endQuest = "177875025142231169418",
            endPort = "In"
          }
        },
        nodeData = {
          ["177875021439231168414"] = {
            key = "177875021439231168414",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 578.6206896551723, y = 343.44827586206895},
            propsData = {ModeType = 0}
          },
          ["177875021439231168415"] = {
            key = "177875021439231168415",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2425.8577075098815, y = 303.40711462450594},
            propsData = {ModeType = 0}
          },
          ["177875021439231168416"] = {
            key = "177875021439231168416",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1246.8181818181815, y = 655},
            propsData = {}
          },
          ["177875021439231168417"] = {
            key = "177875021439231168417",
            type = "TalkNode",
            name = "回到平民车厢",
            pos = {x = 1099.655172413793, y = 331.1034482758621},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047701.10047701'",
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
          ["177875021439231168418"] = {
            key = "177875021439231168418",
            type = "TalkNode",
            name = "拆除炸弹后对话",
            pos = {x = 1649.443028485757, y = 375.32833583208395},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10047801.10047801'",
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
          ["177875021439231168419"] = {
            key = "177875021439231168419",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 824.9999999999999, y = 355.4538112522687},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_PingminBack",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177875021439231168420"] = {
            key = "177875021439231168420",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1341.6286987522283, y = 363.13132798573963},
            propsData = {
              StaticCreatorId = 272640047,
              UnitId = 10076,
              bGuideUIEnable = true,
              GuidePointName = "BP_DiaochaZhadan_272640047",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177875023103231168840"] = {
            key = "177875023103231168840",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 843.5067007296109, y = 187.15809229470216},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177875024211931169091"] = {
            key = "177875024211931169091",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 891.9682391911493, y = 591.004246140856},
            propsData = {}
          },
          ["177875025142231169418"] = {
            key = "177875025142231169418",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2008.8913161142266, y = 418.24200837861827},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
