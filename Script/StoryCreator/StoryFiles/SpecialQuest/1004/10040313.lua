return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17782426680326535893",
      startPort = "StoryStart",
      endStory = "17782426165635725206",
      endPort = "In"
    },
    {
      startStory = "17782426165635725206",
      startPort = "Success",
      endStory = "17782426680326535894",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17782426165635725206"] = {
      isStoryNode = true,
      key = "17782426165635725206",
      type = "StoryNode",
      name = "炸弹调查后对话",
      pos = {x = 1087.0857142857144, y = 103.82857142857154},
      propsData = {
        QuestId = 10040313,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040313_01",
        QuestDeatil = "Description_10040313_01",
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
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "17782426165635725214",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725214",
            startPort = "Out",
            endQuest = "17782426165635725215",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725215",
            startPort = "Out",
            endQuest = "17782426165635725216",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725216",
            startPort = "Out",
            endQuest = "17782426442745725902",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "177830495976912405977",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "17787402535981243",
            endPort = "In"
          },
          {
            startQuest = "17782426165635725211",
            startPort = "QuestStart",
            endQuest = "177875057838313615049",
            endPort = "In"
          },
          {
            startQuest = "177875057838313615049",
            startPort = "Out",
            endQuest = "17782426165635725213",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17782426165635725211"] = {
            key = "17782426165635725211",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1082, y = 266.40000000000003},
            propsData = {ModeType = 0}
          },
          ["17782426165635725212"] = {
            key = "17782426165635725212",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2560.5538461538467, y = 276.13846153846157},
            propsData = {ModeType = 0}
          },
          ["17782426165635725213"] = {
            key = "17782426165635725213",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1664.5, y = 607},
            propsData = {}
          },
          ["17782426165635725214"] = {
            key = "17782426165635725214",
            type = "TalkNode",
            name = "管理员出场",
            pos = {x = 1385.832258064516, y = 273.5012235817575},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043601.10043601'",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782426165635725215"] = {
            key = "17782426165635725215",
            type = "TalkNode",
            name = "艾森巴恩仓库出场",
            pos = {x = 1699.3771315640881, y = 276.2026538678713},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043701.10043701'",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782426165635725216"] = {
            key = "17782426165635725216",
            type = "TalkNode",
            name = "炸弹调查后对话",
            pos = {x = 2004.3485601355167, y = 271.91693958215706},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10043801.10043801'",
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
              bNpcActionKeepIn = false,
              bNpcActionKeepOut = false,
              bForceWaitNavLoaded = false,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17782426442745725902"] = {
            key = "17782426442745725902",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2278.6174089068827, y = 274.2750709435493},
            propsData = {}
          },
          ["177830495976912405977"] = {
            key = "177830495976912405977",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1384.4137931034484, y = 402.0689655172414},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787402535981243"] = {
            key = "17787402535981243",
            type = "AtmosphereNpcHideNode",
            name = "隐藏氛围",
            pos = {x = 1384.1134212305615, y = 168.36308316430024},
            propsData = {
              IsHide = true,
              AtmosphereTagList = {"Story_YT", "Story_BHCZ"}
            }
          },
          ["177875057838313615049"] = {
            key = "177875057838313615049",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1395.546052631579, y = 587.4078947368422},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["17782426680326535893"] = {
      isStoryNode = true,
      key = "17782426680326535893",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 816.8, y = 98.39999999999998},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17782426680326535894"] = {
      isStoryNode = true,
      key = "17782426680326535894",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1353.4668510551878, y = 102.86607697013386},
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
