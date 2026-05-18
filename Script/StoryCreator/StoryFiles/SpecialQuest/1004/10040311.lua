return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177824373464011317511",
      startPort = "StoryStart",
      endStory = "177824359749910505326",
      endPort = "In"
    },
    {
      startStory = "177824359749910505326",
      startPort = "Success",
      endStory = "177824373464111317512",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177824359749910505326"] = {
      isStoryNode = true,
      key = "177824359749910505326",
      type = "StoryNode",
      name = "回到站长办公室",
      pos = {x = 1042.6857142857145, y = 85.82857142857154},
      propsData = {
        QuestId = 10040311,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040311_01",
        QuestDeatil = "Description_10040311_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177824359749910505335",
            startPort = "Out",
            endQuest = "177824359749910505336",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505336",
            startPort = "Out",
            endQuest = "177824359749910505337",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505337",
            startPort = "Out",
            endQuest = "177824362304710505952",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505331",
            startPort = "QuestStart",
            endQuest = "177830492765510497852",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505331",
            startPort = "QuestStart",
            endQuest = "177824359749910505335",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505331",
            startPort = "QuestStart",
            endQuest = "177875051290111670032",
            endPort = "In"
          },
          {
            startQuest = "177875051290111670032",
            startPort = "Out",
            endQuest = "177824359749910505333",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177824359749910505331"] = {
            key = "177824359749910505331",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1191.875, y = 319.6875},
            propsData = {ModeType = 0}
          },
          ["177824359749910505332"] = {
            key = "177824359749910505332",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2817.8636363636365, y = 356.6818181818182},
            propsData = {ModeType = 0}
          },
          ["177824359749910505333"] = {
            key = "177824359749910505333",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1759.4736842105262, y = 714.2105263157895},
            propsData = {}
          },
          ["177824359749910505335"] = {
            key = "177824359749910505335",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1482, y = 308},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044701.10044701'",
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
          ["177824359749910505336"] = {
            key = "177824359749910505336",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置在车站入口",
            pos = {x = 1808.3636363636363, y = 320.6363636363636},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Point_Teleport_10040311",
              FadeIn = true,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["177824359749910505337"] = {
            key = "177824359749910505337",
            type = "TalkNode",
            name = "奥哥获救对话 ",
            pos = {x = 2092.989063568011, y = 311.0382775119617},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10044801.10044801'",
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
          ["177824362304710505952"] = {
            key = "177824362304710505952",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2444.8406862745096, y = 313.1524767801858},
            propsData = {}
          },
          ["177830492765510497852"] = {
            key = "177830492765510497852",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1488.7401315789473, y = 454.39473684210526},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177875051290111670032"] = {
            key = "177875051290111670032",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1494.4133126934985, y = 712.6772445820434},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["177824373464011317511"] = {
      isStoryNode = true,
      key = "177824373464011317511",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 777.1999999999999, y = 87.59999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177824373464111317512"] = {
      isStoryNode = true,
      key = "177824373464111317512",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1331.866851055188, y = 90.86607697013385},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    }
  },
  commentData = {}
}
