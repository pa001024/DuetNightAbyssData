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
        QuestId = 0,
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
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Aisenbaen_152480366",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
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
          },
          {
            startQuest = "177824359749910505331",
            startPort = "QuestStart",
            endQuest = "177891749443882569836",
            endPort = "Input"
          },
          {
            startQuest = "177824359749910505335",
            startPort = "Out",
            endQuest = "17796058642402106",
            endPort = "In"
          },
          {
            startQuest = "17796058642402106",
            startPort = "Out",
            endQuest = "177824359749910505337",
            endPort = "In"
          },
          {
            startQuest = "177824359749910505337",
            startPort = "Out",
            endQuest = "17796058958892536",
            endPort = "In"
          },
          {
            startQuest = "17796058958892536",
            startPort = "Out",
            endQuest = "177824362304710505952",
            endPort = "In"
          },
          {
            startQuest = "17796058642402106",
            startPort = "Out",
            endQuest = "1779606045773970101",
            endPort = "In"
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
            pos = {x = 1765.187969924812, y = 661.3533834586466},
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
            pos = {x = 1766.2899036447423, y = -72.5894428152493},
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
            pos = {x = 2078.7033492822966, y = 311.0382775119617},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "UI_Npc_Name_Aote",
              NpcId = 100401,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Aote_152480421",
              DelayShowGuideTime = 0,
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
            pos = {x = 2569.126400560224, y = 324.58104820875724},
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
            pos = {x = 1495.8418841220698, y = 649.8201017249005},
            propsData = {}
          },
          ["177891749443882569836"] = {
            key = "177891749443882569836",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1490, y = 135.42857142857144},
            propsData = {
              TargetTime = 19,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17796058642402106"] = {
            key = "17796058642402106",
            type = "ChangeStaticCreatorNode",
            name = "生成奥特赛德",
            pos = {x = 1802.7572266443237, y = 312.35714285714283},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480421}
            }
          },
          ["17796058958892536"] = {
            key = "17796058958892536",
            type = "ChangeStaticCreatorNode",
            name = "销毁奥特赛德",
            pos = {x = 2329.9000837871813, y = 322.35714285714283},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {152480421}
            }
          },
          ["1779606045773970101"] = {
            key = "1779606045773970101",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2077.042940930038, y = 170.92857142857142},
            propsData = {
              NewDescription = "Content_10040311_02",
              NewDetail = "Description_10040311_02",
              SubTaskTargetIndex = 0
            }
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
