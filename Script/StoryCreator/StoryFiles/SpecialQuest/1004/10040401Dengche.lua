return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17787286684487792780",
      startPort = "StoryStart",
      endStory = "17787287273567792852",
      endPort = "In"
    },
    {
      startStory = "17787287273567792852",
      startPort = "Success",
      endStory = "17787286684497792783",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17787286684487792780"] = {
      isStoryNode = true,
      key = "17787286684487792780",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1256.818181818182, y = 229.09090909090907},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17787286684497792783"] = {
      isStoryNode = true,
      key = "17787286684497792783",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1875.4545454545455, y = 200.45454545454544},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17787287273567792852"] = {
      isStoryNode = true,
      key = "17787287273567792852",
      type = "StoryNode",
      name = "登车",
      pos = {x = 1528.5454545454547, y = 220},
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
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17787287273577792862",
            startPort = "Out",
            endQuest = "17787287273577792863",
            endPort = "In"
          },
          {
            startQuest = "17787287273577792860",
            startPort = "Out",
            endQuest = "17787287273577792861",
            endPort = "In"
          },
          {
            startQuest = "17787287273577792861",
            startPort = "Out",
            endQuest = "17787287273577792862",
            endPort = "In"
          },
          {
            startQuest = "17787287273567792857",
            startPort = "QuestStart",
            endQuest = "17787287413527793300",
            endPort = "In"
          },
          {
            startQuest = "17787287273577792863",
            startPort = "Out",
            endQuest = "17787287485737793571",
            endPort = "In"
          },
          {
            startQuest = "17787287273567792857",
            startPort = "QuestStart",
            endQuest = "17787287567437793858",
            endPort = "In"
          },
          {
            startQuest = "17787287567437793858",
            startPort = "Out",
            endQuest = "17787287273577792859",
            endPort = "Fail"
          },
          {
            startQuest = "17787287273567792857",
            startPort = "QuestStart",
            endQuest = "177891765370385464896",
            endPort = "Input"
          },
          {
            startQuest = "17787287273567792857",
            startPort = "QuestStart",
            endQuest = "177892203305891260093",
            endPort = "In"
          },
          {
            startQuest = "177892203305891260093",
            startPort = "Out",
            endQuest = "17787287273577792860",
            endPort = "In"
          }
        },
        nodeData = {
          ["17787287273567792857"] = {
            key = "17787287273567792857",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 214.5, y = 273.75},
            propsData = {ModeType = 0}
          },
          ["17787287273577792858"] = {
            key = "17787287273577792858",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2281.38967611336, y = 513.0465587044534},
            propsData = {
              ModeType = 1,
              Id = 106101,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17787287273577792859"] = {
            key = "17787287273577792859",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1410, y = 532.5},
            propsData = {}
          },
          ["17787287273577792860"] = {
            key = "17787287273577792860",
            type = "GoToNode",
            name = "前往列车",
            pos = {x = 1022.0682503770738, y = 256.4807692307692},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480056,
              GuideType = "M",
              GuidePointName = "Mechanism_Dengche_272480056"
            }
          },
          ["17787287273577792861"] = {
            key = "17787287273577792861",
            type = "TalkNode",
            name = "登车前对话",
            pos = {x = 1305.9916536417134, y = 276.0026091081596},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045301.10045301'",
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
          ["17787287273577792862"] = {
            key = "17787287273577792862",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1595.4569222062103, y = 323.58761346735747},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_XierDuice",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17787287273577792863"] = {
            key = "17787287273577792863",
            type = "TalkNode",
            name = "商量对策",
            pos = {x = 1870.904175911529, y = 355.1473344786914},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10045401.10045401'",
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
          ["17787287413527793300"] = {
            key = "17787287413527793300",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1055.95, y = 125.25},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["17787287485737793571"] = {
            key = "17787287485737793571",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2245.985294117647, y = 333.40634674922615},
            propsData = {}
          },
          ["17787287567437793858"] = {
            key = "17787287567437793858",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1022.2352941176468, y = 524.656346749226},
            propsData = {}
          },
          ["177891765370385464896"] = {
            key = "177891765370385464896",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1002.775, y = -53.59999999999997},
            propsData = {
              TargetTime = 8,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["177892203305891260093"] = {
            key = "177892203305891260093",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 722, y = 278},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_YWBack",
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
