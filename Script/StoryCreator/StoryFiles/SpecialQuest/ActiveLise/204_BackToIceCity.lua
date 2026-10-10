return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17870345791264481313",
      startPort = "StoryStart",
      endStory = "17870345838954481540",
      endPort = "In"
    },
    {
      startStory = "17870345838954481540",
      startPort = "Success",
      endStory = "17870345791264481316",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17870345791264481313"] = {
      isStoryNode = true,
      key = "17870345791264481313",
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
    ["17870345791264481316"] = {
      isStoryNode = true,
      key = "17870345791264481316",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1874, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17870345838954481540"] = {
      isStoryNode = true,
      key = "17870345838954481540",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1320, y = 274},
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
            startQuest = "17870345838954481541",
            startPort = "QuestStart",
            endQuest = "17872279825797897727",
            endPort = "In"
          },
          {
            startQuest = "17870345838954481541",
            startPort = "QuestStart",
            endQuest = "17872279697077897545",
            endPort = "In"
          },
          {
            startQuest = "17872282732757901496",
            startPort = "Out",
            endQuest = "17872279774757897654",
            endPort = "In"
          },
          {
            startQuest = "17872282021667900956",
            startPort = "Out",
            endQuest = "17872282732757901496",
            endPort = "In"
          },
          {
            startQuest = "17872280407927899427",
            startPort = "Out",
            endQuest = "17872285224387903268",
            endPort = "In"
          },
          {
            startQuest = "17872285224387903268",
            startPort = "Out",
            endQuest = "17872282021667900956",
            endPort = "In"
          },
          {
            startQuest = "17872279697077897545",
            startPort = "Out",
            endQuest = "17872280407927899427",
            endPort = "In"
          },
          {
            startQuest = "17872279825797897727",
            startPort = "Out",
            endQuest = "17870345838954481547",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["17870345838954481541"] = {
            key = "17870345838954481541",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 1089.5652173913045, y = 307.82608695652175},
            propsData = {ModeType = 0}
          },
          ["17870345838954481544"] = {
            key = "17870345838954481544",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2725.6060606060605, y = 458.86809269162217},
            propsData = {ModeType = 0}
          },
          ["17870345838954481547"] = {
            key = "17870345838954481547",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1643.287607533132, y = 508.4212973727041},
            propsData = {}
          },
          ["17872279697077897545"] = {
            key = "17872279697077897545",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1358.474308300395, y = 312.5533596837945},
            propsData = {QuestRoleId = 41030101, IsPlayFX = false}
          },
          ["17872279774757897654"] = {
            key = "17872279774757897654",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2730.1942959001785, y = 302.71301247771834},
            propsData = {}
          },
          ["17872279825797897727"] = {
            key = "17872279825797897727",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1364.4505928853753, y = 493.810276679842},
            propsData = {}
          },
          ["17872280407927899427"] = {
            key = "17872280407927899427",
            type = "TalkNode",
            name = "回到冰湖城",
            pos = {x = 1623.7761650114592, y = 302.5981665393431},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070210,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070210.12070210'",
              TalkType = "FixSimpleNew",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
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
          ["17872282021667900956"] = {
            key = "17872282021667900956",
            type = "TalkNode",
            name = "再遇罗德斯奶奶",
            pos = {x = 2184.8367710720654, y = 299.11331805449464},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 12070212,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/ActiveQuest/ActiveLise/120702/12070211.12070211'",
              TalkType = "FixSimpleNew",
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
              bHidePickup = true,
              bHideSkillCreature = true,
              HideMechanismsFX = false,
              ShowSkipButton = true,
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
          ["17872282732757901496"] = {
            key = "17872282732757901496",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "传送到男人家门口",
            pos = {x = 2453.4731347084285, y = 300.47695441813096},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "Target_Madman_1207",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17872285224387903268"] = {
            key = "17872285224387903268",
            type = "TalkNode",
            name = "冰湖城过场动画",
            pos = {x = 1899.3822256175192, y = 300.62846956964603},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/Asset/Cinematics/Story/Ver01/Ver0107/Ver0107_SC002/SQ_Ver0107_SC002.SQ_Ver0107_SC002'",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              bOpenDefaultSkinKawaii = false,
              HideNpcs = false,
              HideMonsters = true,
              bHidePickup = true,
              bHideSkillCreature = true,
              bHideSceneEffects = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              CloseMotionBlur = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {},
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
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
