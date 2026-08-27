return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17822919344911",
      startPort = "StoryStart",
      endStory = "1782291940538203",
      endPort = "In"
    },
    {
      startStory = "1782291940538203",
      startPort = "Success",
      endStory = "17822919344925",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17822919344911"] = {
      isStoryNode = true,
      key = "17822919344911",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1571.6666666666667, y = 288.3333333333333},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17822919344925"] = {
      isStoryNode = true,
      key = "17822919344925",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2626.521739130435, y = 273.9130434782609},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1782291940538203"] = {
      isStoryNode = true,
      key = "1782291940538203",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1954.3333333333337, y = 252.49999999999994},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110211_01",
        QuestDeatil = "Content_110211_01",
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
            startQuest = "17822920767321809",
            startPort = "Out",
            endQuest = "17822921502133685",
            endPort = "In"
          },
          {
            startQuest = "1782291976792705",
            startPort = "Out",
            endQuest = "17832440575652729",
            endPort = "In"
          },
          {
            startQuest = "17832440575652729",
            startPort = "Out",
            endQuest = "17832442420843940",
            endPort = "In"
          },
          {
            startQuest = "17832442420843940",
            startPort = "Out",
            endQuest = "17832447398594619",
            endPort = "In"
          },
          {
            startQuest = "1782291940538204",
            startPort = "QuestStart",
            endQuest = "17832452356631091738",
            endPort = "In"
          },
          {
            startQuest = "1782291940538204",
            startPort = "QuestStart",
            endQuest = "17832452190611091558",
            endPort = "Input"
          },
          {
            startQuest = "17832452356631091738",
            startPort = "Out",
            endQuest = "1782291976792705",
            endPort = "In"
          },
          {
            startQuest = "17832440575652729",
            startPort = "Out",
            endQuest = "178663223502522340416",
            endPort = "In"
          },
          {
            startQuest = "17832447398594619",
            startPort = "Out",
            endQuest = "178663226912922340961",
            endPort = "In"
          },
          {
            startQuest = "178663226912922340961",
            startPort = "Out",
            endQuest = "17822920767321809",
            endPort = "In"
          },
          {
            startQuest = "17832440575652729",
            startPort = "Out",
            endQuest = "17866355022711117592",
            endPort = "In"
          },
          {
            startQuest = "17832447398594619",
            startPort = "Out",
            endQuest = "17866355829602232197",
            endPort = "In"
          },
          {
            startQuest = "17832442420843940",
            startPort = "Out",
            endQuest = "1786872443222987",
            endPort = "In"
          }
        },
        nodeData = {
          ["1782291940538204"] = {
            key = "1782291940538204",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 614.2857142857142, y = 297.1428571428571},
            propsData = {ModeType = 0}
          },
          ["1782291940538212"] = {
            key = "1782291940538212",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3161.875, y = 296.25},
            propsData = {ModeType = 0}
          },
          ["1782291940538220"] = {
            key = "1782291940538220",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1782291976792705"] = {
            key = "1782291976792705",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C1_01】玩具兵",
            pos = {x = 1120.857142857143, y = 287.14285714285717},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110211/11021101.11021101'",
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
          ["17822920767321809"] = {
            key = "17822920767321809",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C1_02】打闹",
            pos = {x = 2508.6464109935473, y = 305.2416703523515},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110211/11021102.11021102'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0.5,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              BlendEaseExp = 2,
              UseProceduralCamera = false,
              ProceduralCameraId = 1,
              HideNpcs = true,
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
          ["17822921502133685"] = {
            key = "17822921502133685",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2856.6652186732817, y = 315.9074630264963},
            propsData = {}
          },
          ["17832440575652729"] = {
            key = "17832440575652729",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1422.865337440338, y = 293.15581551605266},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "11_tp_rebirth01",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17832442420843940"] = {
            key = "17832442420843940",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1661.449818093784, y = 308.06445094192964},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                142780371,
                142780372,
                142780373,
                142780374,
                142780375,
                142780376,
                142780553,
                142780554,
                142780555,
                142780556,
                142780557,
                142780558,
                142780559
              }
            }
          },
          ["17832447398594619"] = {
            key = "17832447398594619",
            type = "KillMonsterNode",
            name = "击杀怪物",
            pos = {x = 1914.2926274583326, y = 295.3721432496219},
            propsData = {
              KillMonsterType = "Id",
              MonsterNeedNums = 13,
              IsShow = false,
              GuideType = "P",
              GuideName = "",
              IsShowMonsterGuide = true,
              StaticCreatorIdList = {
                142780371,
                142780372,
                142780373,
                142780374,
                142780375,
                142780376,
                142780553,
                142780554,
                142780555,
                142780556,
                142780557,
                142780558,
                142780559
              }
            }
          },
          ["17832452190611091558"] = {
            key = "17832452190611091558",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 935.5457221896879, y = -46.291193413714886},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17832452356631091738"] = {
            key = "17832452356631091738",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 858.4028650468307, y = 286.56594944342794},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["178663223502522340416"] = {
            key = "178663223502522340416",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1688.5, y = 155.5},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780746}
            }
          },
          ["178663226912922340961"] = {
            key = "178663226912922340961",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2232.25, y = 303.625},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142780746}
            }
          },
          ["17866355022711117592"] = {
            key = "17866355022711117592",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1684.2857142857142, y = -6.785714285714242},
            propsData = {
              NewDescription = "Description_110211_01a",
              NewDetail = "Content_110211_01a",
              SubTaskTargetIndex = 0
            }
          },
          ["17866355829602232197"] = {
            key = "17866355829602232197",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2477.142857142857, y = -6.785714285714212},
            propsData = {
              NewDescription = "Description_110211_01b",
              NewDetail = "Content_110211_01b",
              SubTaskTargetIndex = 0
            }
          },
          ["1786872443222987"] = {
            key = "1786872443222987",
            type = "TalkNode",
            name = "咿呜，这几个核桃小人打人还挺痛的！莫甘娜姐姐，它们是怎么了？",
            pos = {x = 2000.441176470588, y = 61.8602941176468},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11106701,
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
    }
  },
  commentData = {}
}
