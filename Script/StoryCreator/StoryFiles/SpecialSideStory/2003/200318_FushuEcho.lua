return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17702778835501",
      startPort = "StoryStart",
      endStory = "1770278081211383643",
      endPort = "In"
    },
    {
      startStory = "1770279360195395037",
      startPort = "Success",
      endStory = "1770281467597397393",
      endPort = "In"
    },
    {
      startStory = "1770281467597397393",
      startPort = "Success",
      endStory = "1770282184913398056",
      endPort = "In"
    },
    {
      startStory = "1770282184913398056",
      startPort = "Success",
      endStory = "1770282194593398357",
      endPort = "In"
    },
    {
      startStory = "1770282194593398357",
      startPort = "Success",
      endStory = "17702778835515",
      endPort = "StoryEnd"
    },
    {
      startStory = "1770278081211383643",
      startPort = "Success",
      endStory = "1770278590773387494",
      endPort = "In"
    },
    {
      startStory = "1770278590773387494",
      startPort = "Success",
      endStory = "1770279360195395037",
      endPort = "In"
    }
  },
  storyNodeData = {
    ["17702778835501"] = {
      isStoryNode = true,
      key = "17702778835501",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 779.4736842105264, y = 301.57894736842104},
      propsData = {QuestChainId = 200318},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17702778835515"] = {
      isStoryNode = true,
      key = "17702778835515",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2095.436318067897, y = 522.6885395306446},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1770278081211383643"] = {
      isStoryNode = true,
      key = "1770278081211383643",
      type = "StoryNode",
      name = "回忆",
      pos = {x = 1088.3157894736842, y = 287.3508771929824},
      propsData = {
        QuestId = 20031801,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031801",
        QuestDeatil = "Content_20031801",
        TaskRegionReName = "",
        TaskSubRegionReName = "",
        RecommendLevel = -1,
        bIsStartQuest = true,
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
        SubRegionId = 104501,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TriggerBox01_232010266",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1770278081211383644",
            startPort = "QuestStart",
            endQuest = "1770278554756386774",
            endPort = "In"
          },
          {
            startQuest = "177313394785833758135",
            startPort = "Out",
            endQuest = "17726066180633637091",
            endPort = "In"
          },
          {
            startQuest = "1770278554756386774",
            startPort = "Out",
            endQuest = "177375363320510444737",
            endPort = "Input"
          },
          {
            startQuest = "1770278557956386838",
            startPort = "Out",
            endQuest = "177313394785833758135",
            endPort = "In"
          },
          {
            startQuest = "1770278554756386774",
            startPort = "Out",
            endQuest = "1770278557956386838",
            endPort = "In"
          },
          {
            startQuest = "17726066180633637091",
            startPort = "Out",
            endQuest = "177313446494136299267",
            endPort = "In"
          },
          {
            startQuest = "177313446494136299267",
            startPort = "Out",
            endQuest = "17726066180633637092",
            endPort = "In"
          },
          {
            startQuest = "17726066180633637092",
            startPort = "Out",
            endQuest = "177313447285836299487",
            endPort = "In"
          },
          {
            startQuest = "177313447285836299487",
            startPort = "Out",
            endQuest = "1770278081211383647",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1770278081211383644"] = {
            key = "1770278081211383644",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 263.74999999999994, y = 401.0526315789474},
            propsData = {ModeType = 0}
          },
          ["1770278081211383647"] = {
            key = "1770278081211383647",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2766.947368421052, y = 381.8947368421053},
            propsData = {ModeType = 0}
          },
          ["1770278081211383650"] = {
            key = "1770278081211383650",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2560, y = 672},
            propsData = {}
          },
          ["1770278554756386774"] = {
            key = "1770278554756386774",
            type = "GoToNode",
            name = "前往",
            pos = {x = 609.0394736842105, y = 395.2236842105263},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010266,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox01_232010266"
            }
          },
          ["1770278557956386838"] = {
            key = "1770278557956386838",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.3223684210527, y = 401.07236842105266},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180101.2003180101'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 1.5,
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
          ["17726066180633637091"] = {
            key = "17726066180633637091",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1786.7631578947367, y = 375.7105263157895},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "StartPoint_200318fushu1",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17726066180633637092"] = {
            key = "17726066180633637092",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2191.631578947369, y = 372.8947368421052},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180102.2003180102'",
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
          ["177313394785833758135"] = {
            key = "177313394785833758135",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1782.8208787779727, y = 192.72719843085963},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["177313446494136299267"] = {
            key = "177313446494136299267",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1833.9797133644388, y = 595.3747548218372},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0125_story_zhiliu_betray",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104501, 104503},
              bStoreToServer = false
            }
          },
          ["177313447285836299487"] = {
            key = "177313447285836299487",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2446.5652396802275, y = 531.2234390323634},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["177375363320510444737"] = {
            key = "177375363320510444737",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 964.625, y = 227.5},
            propsData = {
              TargetTime = 19.5,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["1770278125263384569"] = {
      isStoryNode = true,
      key = "1770278125263384569",
      type = "StoryNode",
      name = "开场",
      pos = {x = 1445.1250000000005, y = 55.125},
      propsData = {
        QuestId = 20031802,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031802",
        QuestDeatil = "Content_20031802",
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
        lineData = {},
        nodeData = {
          ["1770278125263384574"] = {
            key = "1770278125263384574",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1770278125263384575"] = {
            key = "1770278125263384575",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1920, y = 298},
            propsData = {ModeType = 0}
          },
          ["1770278125263384576"] = {
            key = "1770278125263384576",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["1770278590773387494"] = {
      isStoryNode = true,
      key = "1770278590773387494",
      type = "StoryNode",
      name = "救不救",
      pos = {x = 1451.4009170653906, y = 287.09469696969694},
      propsData = {
        QuestId = 20031803,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031803",
        QuestDeatil = "Content_20031803",
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
        SubRegionId = 104501,
        SubRegionIdList = {104503},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TriggerBox02_232010267",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1770279044511390701",
            startPort = "Out",
            endQuest = "1770279063303391139",
            endPort = "In"
          },
          {
            startQuest = "1773055956712418711",
            startPort = "true",
            endQuest = "1773055956712418710",
            endPort = "In"
          },
          {
            startQuest = "1770278590773387495",
            startPort = "QuestStart",
            endQuest = "1773055956712418711",
            endPort = "In"
          },
          {
            startQuest = "1773055956712418711",
            startPort = "false",
            endQuest = "17726780176893640304",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "1770278699048388321",
            endPort = "In"
          },
          {
            startQuest = "1770278699048388321",
            startPort = "Out",
            endQuest = "1773056041444420700",
            endPort = "In"
          },
          {
            startQuest = "1773057076216426455",
            startPort = "Out",
            endQuest = "1773057076216426454",
            endPort = "In"
          },
          {
            startQuest = "1773057076216426454",
            startPort = "Out",
            endQuest = "1773058139327430806",
            endPort = "In"
          },
          {
            startQuest = "1770278966032389765",
            startPort = "Option_2",
            endQuest = "1773058196525431609",
            endPort = "In"
          },
          {
            startQuest = "1773058196525431609",
            startPort = "Out",
            endQuest = "1770279038342390537",
            endPort = "In"
          },
          {
            startQuest = "1770279038342390537",
            startPort = "Out",
            endQuest = "1770279070734391456",
            endPort = "In"
          },
          {
            startQuest = "1770279138866392190",
            startPort = "Out",
            endQuest = "17731244610328425121",
            endPort = "In"
          },
          {
            startQuest = "17731244610328425121",
            startPort = "Out",
            endQuest = "1773057076216426455",
            endPort = "In"
          },
          {
            startQuest = "1770278966032389765",
            startPort = "Option_1",
            endQuest = "1770279138866392190",
            endPort = "In"
          },
          {
            startQuest = "1773056041444420700",
            startPort = "Out",
            endQuest = "1770278966032389765",
            endPort = "In"
          },
          {
            startQuest = "1770279070734391456",
            startPort = "Out",
            endQuest = "1770279138866392190",
            endPort = "In"
          },
          {
            startQuest = "1773058139327430806",
            startPort = "Out",
            endQuest = "177312829053121092686",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488993",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488994",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488995",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488996",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488992",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488990",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488989",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313353872632488991",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313360624632490547",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313359514232490437",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177312826647321092309",
            endPort = "In"
          },
          {
            startQuest = "177312829053121092686",
            startPort = "Out",
            endQuest = "177313396827633758789",
            endPort = "In"
          },
          {
            startQuest = "1770278685719387942",
            startPort = "Out",
            endQuest = "177313389910433757058",
            endPort = "In"
          },
          {
            startQuest = "1773055956712418710",
            startPort = "Out",
            endQuest = "17726780281113640598",
            endPort = "In"
          },
          {
            startQuest = "17726780176893640304",
            startPort = "Out",
            endQuest = "17726780281113640598",
            endPort = "In"
          },
          {
            startQuest = "17726780281113640598",
            startPort = "Success",
            endQuest = "1770278590773387498",
            endPort = "Success"
          },
          {
            startQuest = "17726780281113640598",
            startPort = "Fail",
            endQuest = "17749670518103846090",
            endPort = "In"
          },
          {
            startQuest = "17726780281113640598",
            startPort = "PassiveFail",
            endQuest = "17749670518103846090",
            endPort = "In"
          },
          {
            startQuest = "17749670518103846090",
            startPort = "Out",
            endQuest = "1770278590773387501",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1770278590773387495"] = {
            key = "1770278590773387495",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 6.9595935540206275, y = 1774.4194989736784},
            propsData = {ModeType = 0}
          },
          ["1770278590773387498"] = {
            key = "1770278590773387498",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1659.6911963165835, y = 1762.2867476950294},
            propsData = {ModeType = 0}
          },
          ["1770278590773387501"] = {
            key = "1770278590773387501",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1674.2097608274084, y = 1952.982223658694},
            propsData = {}
          },
          ["1770278685719387942"] = {
            key = "1770278685719387942",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 35.651078765921056, y = 543.4513623631273},
            propsData = {QuestRoleId = 24010101, IsPlayFX = false}
          },
          ["1770278699048388321"] = {
            key = "1770278699048388321",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1459.049935358759, y = 545.6922807584572},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {232010265}
            }
          },
          ["1770278966032389765"] = {
            key = "1770278966032389765",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1872.6328688014546, y = 568.9024123731518},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180301.2003180301'",
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
              BranchOptions = {"jiu", "bujiu"},
              OverrideFailBlend = false
            }
          },
          ["1770279038342390537"] = {
            key = "1770279038342390537",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2470.4895865228686, y = 992.4356195919661},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010269,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox04_232010269"
            }
          },
          ["1770279044511390701"] = {
            key = "1770279044511390701",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2435.0957895303864, y = 1193.5963338776805},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "N",
              GuideName = ""
            }
          },
          ["1770279063303391139"] = {
            key = "1770279063303391139",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2727.9905263724927, y = 1168.1828000430937},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010268,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox03_232010268"
            }
          },
          ["1770279070734391456"] = {
            key = "1770279070734391456",
            type = "TalkNode",
            name = "对话",
            pos = {x = 2783.747418603068, y = 988.6239027999861},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180302.2003180302'",
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
          ["1770279138866392190"] = {
            key = "1770279138866392190",
            type = "TalkNode",
            name = "对话",
            pos = {x = 3051.899839296748, y = 597.9602367614883},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180303.2003180303'",
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
          ["17726780176893640304"] = {
            key = "17726780176893640304",
            type = "GoToNode",
            name = "前往",
            pos = {x = 603.571814150761, y = 1950.269712743397},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010267,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox02_232010267"
            }
          },
          ["17726780281113640598"] = {
            key = "17726780281113640598",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1050.320585116637, y = 1774.4520632875897},
            propsData = {SpecialConfigId = 20031803, BlackScreenImmediately = true}
          },
          ["1773055956712418710"] = {
            key = "1773055956712418710",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 608.6274192352364, y = 1762.8561590628155},
            propsData = {
              VarName = "WangchuanFushu01",
              VarValue = 1
            }
          },
          ["1773055956712418711"] = {
            key = "1773055956712418711",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量判断",
            pos = {x = 296.83470326558574, y = 1762.59888692319},
            propsData = {
              FunctionName = "Equal",
              VarName = "WangchuanFushu01",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["1773056041444420700"] = {
            key = "1773056041444420700",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1481.314038773404, y = 816.5557828394515},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010268,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox03_232010268"
            }
          },
          ["1773057076216426454"] = {
            key = "1773057076216426454",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3828.6824672761436, y = 598.4136599984123},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010270,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox05_232010270"
            }
          },
          ["1773057076216426455"] = {
            key = "1773057076216426455",
            type = "SimplePostProcessNode",
            name = "开启关闭屏幕后处理",
            pos = {x = 3473.636506786685, y = 592.2131913494143},
            propsData = {
              bEnablePP = true,
              PPEnum = 0,
              PPWeight = 1
            }
          },
          ["1773058139327430806"] = {
            key = "1773058139327430806",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3836.838216865692, y = 824.1032119325461},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010278,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox05_232010278"
            }
          },
          ["1773058196525431609"] = {
            key = "1773058196525431609",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 2179.6719003390826, y = 999.3736731534724},
            propsData = {Rate = 0.25, Mode = "EWT_Normal"}
          },
          ["17731244610328425121"] = {
            key = "17731244610328425121",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 3266.7085042150816, y = 812.7600302174615},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["177312826647321092309"] = {
            key = "177312826647321092309",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 476.5566040479, y = -567.0536344426868},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "PPBlinkLoop",
              UnitId = -1
            }
          },
          ["177312829053121092686"] = {
            key = "177312829053121092686",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 4322.754528930036, y = 613.3624582365638},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "PPBlinkEnd",
              UnitId = -1
            }
          },
          ["177313353872632488989"] = {
            key = "177313353872632488989",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 908.9272784502239, y = -758.1159885125506},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488990"] = {
            key = "177313353872632488990",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 904.5483964626465, y = -631.0662990715571},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488991"] = {
            key = "177313353872632488991",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 905.1384585744474, y = -880.2277897547866},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488992"] = {
            key = "177313353872632488992",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 907.7471542266214, y = -518.6488423863659},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488993"] = {
            key = "177313353872632488993",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 910.4814537435293, y = 144.41472232250695},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488994"] = {
            key = "177313353872632488994",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 909.5925648546406, y = 8.081388989173789},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488995"] = {
            key = "177313353872632488995",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 917.2592315213071, y = -122.58527767749284},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313353872632488996"] = {
            key = "177313353872632488996",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 914.4179616800373, y = -252.85511894733403},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["177313359514232490437"] = {
            key = "177313359514232490437",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 481.6291418042613, y = -247.51848086051248},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["177313360624632490547"] = {
            key = "177313360624632490547",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 477.34342751854706, y = -89.44382942475711},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Jump",
                "Slide",
                "SecondJump",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["177313361312732490648"] = {
            key = "177313361312732490648",
            type = "CameraControlNode",
            name = "镜头控制节点",
            pos = {x = 506.0577132328324, y = 53.937200702560446},
            propsData = {
              Duration = 0,
              CameraName = "StoryCamera03",
              LockRotate = false,
              FocalLength = 0,
              LensAperture = 0,
              FOV = 0,
              PPMaterialPath = ""
            }
          },
          ["177313389910433757058"] = {
            key = "177313389910433757058",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 476.2719989471186, y = -776.2576044922446},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLight",
              UnitId = -1
            }
          },
          ["177313396827633758789"] = {
            key = "177313396827633758789",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 4336.27029012962, y = 822.5284515569691},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JuezhanLightEnd",
              UnitId = -1
            }
          },
          ["17749670518103846090"] = {
            key = "17749670518103846090",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1359.223405470108, y = 1933.9406447133429},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "StartPoint_200318fushuBack",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["177313393521833757807"] = {
            key = "177313393521833757807",
            name = "Input Commment...",
            position = {x = 303.0577132328332, y = -995.5433187779588},
            size = {width = 938.5714285714286, height = 1347.857142857143}
          }
        }
      }
    },
    ["1770279167802392939"] = {
      isStoryNode = true,
      key = "1770279167802392939",
      type = "StoryNode",
      name = "移动",
      pos = {x = 1801.306818181818, y = 53.88576555023917},
      propsData = {
        QuestId = 20031804,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031804",
        QuestDeatil = "Content_20031804",
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
        lineData = {},
        nodeData = {
          ["1770279167802392940"] = {
            key = "1770279167802392940",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1770279167802392943"] = {
            key = "1770279167802392943",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2174, y = 300},
            propsData = {ModeType = 0}
          },
          ["1770279167802392946"] = {
            key = "1770279167802392946",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["1770279360195395037"] = {
      isStoryNode = true,
      key = "1770279360195395037",
      type = "StoryNode",
      name = "泽生阁",
      pos = {x = 1807.7312884483936, y = 283.482826384142},
      propsData = {
        QuestId = 20031805,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031805",
        QuestDeatil = "Content_20031805",
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
        SubRegionId = 104501,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TriggerBox02_232010267",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1770282272222399695",
            startPort = "Out",
            endQuest = "1770282272222399696",
            endPort = "In"
          },
          {
            startQuest = "1770282272222399695",
            startPort = "Out",
            endQuest = "1770281438499396632",
            endPort = "In"
          },
          {
            startQuest = "177312731155418557723",
            startPort = "true",
            endQuest = "177312731155418557722",
            endPort = "In"
          },
          {
            startQuest = "1770281427083396372",
            startPort = "Out",
            endQuest = "177391023098616710805",
            endPort = "Input"
          },
          {
            startQuest = "177391023098616710805",
            startPort = "Out",
            endQuest = "1770281440102396712",
            endPort = "In"
          },
          {
            startQuest = "1770279360195395038",
            startPort = "QuestStart",
            endQuest = "17737297226706683643",
            endPort = "Input"
          },
          {
            startQuest = "17737297226706683643",
            startPort = "Out",
            endQuest = "17748664896837243856",
            endPort = "In"
          },
          {
            startQuest = "1770281440102396712",
            startPort = "Out",
            endQuest = "17749649288452828",
            endPort = "In"
          },
          {
            startQuest = "17749649288452828",
            startPort = "Out",
            endQuest = "1770279360195395041",
            endPort = "Success"
          },
          {
            startQuest = "17748664896837243856",
            startPort = "Out",
            endQuest = "1770281427083396372",
            endPort = "In"
          }
        },
        nodeData = {
          ["1770279360195395038"] = {
            key = "1770279360195395038",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 416.3157894736842, y = 343.36842105263156},
            propsData = {ModeType = 0}
          },
          ["1770279360195395041"] = {
            key = "1770279360195395041",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2300.311004784689, y = 351.76555023923447},
            propsData = {ModeType = 0}
          },
          ["1770279360195395044"] = {
            key = "1770279360195395044",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1770281427083396372"] = {
            key = "1770281427083396372",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1075.6818181818182, y = 356.95454545454544},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180501.2003180501'",
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
          ["1770281434560396538"] = {
            key = "1770281434560396538",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 911.1578947368421, y = -652.6578947368421},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "StartPoint_200318fushu3",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1770281438499396632"] = {
            key = "1770281438499396632",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1485.7894736842106, y = -306.7105263157895},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010275,
              GuideType = "M",
              GuidePointName = "Npc_Gezhu_232010264"
            }
          },
          ["1770281440102396712"] = {
            key = "1770281440102396712",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1688.8947368421054, y = 335.8157894736842},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/SpecialSideStory/2003/200318/2003180502.2003180502'",
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
          ["1770282272222399695"] = {
            key = "1770282272222399695",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1178.4352276178424, y = -277.7206477732794},
            propsData = {QuestRoleId = 24010101, IsPlayFX = false}
          },
          ["1770282272222399696"] = {
            key = "1770282272222399696",
            type = "ActivePlayerSkillsNode",
            name = "失效 子弹跳",
            pos = {x = 1523.880561855842, y = -487.3846153846154},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {"BulletJump"}
            }
          },
          ["177312731155418557722"] = {
            key = "177312731155418557722",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 906.8471299940342, y = -272.76708314904903},
            propsData = {
              VarName = "WangchuanFushu02",
              VarValue = 1
            }
          },
          ["177312731155418557723"] = {
            key = "177312731155418557723",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量判断",
            pos = {x = 619.3621063320758, y = -270.7166629809821},
            propsData = {
              FunctionName = "Equal",
              VarName = "WangchuanFushu02",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17737297226706683643"] = {
            key = "17737297226706683643",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 742, y = 346},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["177391023098616710805"] = {
            key = "177391023098616710805",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 1348, y = 344},
            propsData = {
              TargetTime = 1,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17743360508991269389"] = {
            key = "17743360508991269389",
            type = "SendMessageNode",
            name = "发送消息-雨",
            pos = {x = 1543.5, y = 186},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "RainMid",
              UnitId = -1
            }
          },
          ["17748664896837243856"] = {
            key = "17748664896837243856",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 877.9241058863739, y = 567.3776964134937},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0106_scene_cave_near_sea",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {104501, 104503},
              bStoreToServer = false
            }
          },
          ["17749649288452828"] = {
            key = "17749649288452828",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1998.0426470588238, y = 351.7727272727273},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["1770281467597397393"] = {
      isStoryNode = true,
      key = "1770281467597397393",
      type = "StoryNode",
      name = "移动",
      pos = {x = 1090.3822865730765, y = 529.8075017088175},
      propsData = {
        QuestId = 20031806,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031806",
        QuestDeatil = "Content_20031806",
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
        SubRegionId = 104501,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TriggerBox05_232010278",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1773059078538436853",
            startPort = "true",
            endQuest = "1773059078538436852",
            endPort = "In"
          },
          {
            startQuest = "1773059078538436853",
            startPort = "false",
            endQuest = "1773059078538436851",
            endPort = "In"
          },
          {
            startQuest = "1770281467597397394",
            startPort = "QuestStart",
            endQuest = "1773059078538436853",
            endPort = "In"
          },
          {
            startQuest = "1773059067507436446",
            startPort = "Success",
            endQuest = "1770281467597397397",
            endPort = "Success"
          },
          {
            startQuest = "1773059078538436852",
            startPort = "Out",
            endQuest = "1773059067507436446",
            endPort = "In"
          },
          {
            startQuest = "1773059078538436851",
            startPort = "Out",
            endQuest = "1773059067507436446",
            endPort = "In"
          },
          {
            startQuest = "1773059067507436446",
            startPort = "Fail",
            endQuest = "17744381996842125567",
            endPort = "In"
          },
          {
            startQuest = "1773059067507436446",
            startPort = "PassiveFail",
            endQuest = "17744381996842125567",
            endPort = "In"
          },
          {
            startQuest = "17744381996842125567",
            startPort = "Out",
            endQuest = "1770281467597397400",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1770281467597397394"] = {
            key = "1770281467597397394",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1559.7380952380952, y = 1342.5238095238094},
            propsData = {ModeType = 0}
          },
          ["1770281467597397397"] = {
            key = "1770281467597397397",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 41.557791537668635, y = 1337.6774628879887},
            propsData = {
              ModeType = 1,
              Id = 104301,
              StartIndex = 1,
              LoadingId = 101001,
              IsWhite = false
            }
          },
          ["1770281467597397400"] = {
            key = "1770281467597397400",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 17.43601084158388, y = 1560.7904716542487},
            propsData = {}
          },
          ["1770282262011399291"] = {
            key = "1770282262011399291",
            type = "GoToNode",
            name = "前往",
            pos = {x = 833.8609022556392, y = 1224.894736842105},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010271,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox06_232010271"
            }
          },
          ["1773059067507436446"] = {
            key = "1773059067507436446",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -634.9809405103355, y = 1347.1149111466448},
            propsData = {SpecialConfigId = 20031806, BlackScreenImmediately = true}
          },
          ["1773059078538436851"] = {
            key = "1773059078538436851",
            type = "GoToNode",
            name = "前往",
            pos = {x = -1016.8906185515932, y = 1608.004972839338},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010278,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox05_232010278"
            }
          },
          ["1773059078538436852"] = {
            key = "1773059078538436852",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -1020.957293148221, y = 1333.9542450583472},
            propsData = {
              VarName = "WangchuanFushu03",
              VarValue = 1
            }
          },
          ["1773059078538436853"] = {
            key = "1773059078538436853",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量判断",
            pos = {x = -1299.8946977625603, y = 1335.4542450583472},
            propsData = {
              FunctionName = "Equal",
              VarName = "WangchuanFushu03",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17744381996842125567"] = {
            key = "17744381996842125567",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -306.9766801825629, y = 1553.0801551389786},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "StartPoint_200318fushuBack",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["1770282444340401385"] = {
            key = "1770282444340401385",
            name = "Input Commment...",
            position = {x = 1335.9433198380566, y = 180.26720647773277},
            size = {width = 900, height = 452}
          }
        }
      }
    },
    ["1770282184913398056"] = {
      isStoryNode = true,
      key = "1770282184913398056",
      type = "StoryNode",
      name = "幻境",
      pos = {x = 1459.646781727045, y = 526.8796365914789},
      propsData = {
        QuestId = 20031807,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031807_01",
        QuestDeatil = "Content_20031807_01",
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
            startQuest = "1770283250027409762",
            startPort = "Out",
            endQuest = "1770283250027409763",
            endPort = "In"
          },
          {
            startQuest = "1773059472913443675",
            startPort = "Out",
            endQuest = "1773059472913443677",
            endPort = "In"
          },
          {
            startQuest = "1773059472913443676",
            startPort = "LastDefaultOut",
            endQuest = "1773059472913443675",
            endPort = "In"
          },
          {
            startQuest = "1770282184913398057",
            startPort = "QuestStart",
            endQuest = "1773059472913443676",
            endPort = "In"
          },
          {
            startQuest = "1770283250027409762",
            startPort = "Out",
            endQuest = "1773059557850444969",
            endPort = "In"
          },
          {
            startQuest = "1773059472913443676",
            startPort = "Region_1",
            endQuest = "1773059452018443601",
            endPort = "In"
          },
          {
            startQuest = "1773059452018443601",
            startPort = "Success",
            endQuest = "1770282184913398060",
            endPort = "Success"
          },
          {
            startQuest = "1773059452018443601",
            startPort = "PassiveFail",
            endQuest = "1770282184913398063",
            endPort = "Fail"
          },
          {
            startQuest = "1773059452018443601",
            startPort = "Fail",
            endQuest = "17737462905929190764",
            endPort = "In"
          },
          {
            startQuest = "17737462905929190764",
            startPort = "Out",
            endQuest = "1770282184913398063",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1770282184913398057"] = {
            key = "1770282184913398057",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -994.2857142857144, y = 215.04761904761904},
            propsData = {ModeType = 0}
          },
          ["1770282184913398060"] = {
            key = "1770282184913398060",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 488.65963976683804, y = 208.1232634754307},
            propsData = {
              ModeType = 1,
              Id = 104501,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1770282184913398063"] = {
            key = "1770282184913398063",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 484.5487616099074, y = 609.0331428117809},
            propsData = {}
          },
          ["1770283012939407456"] = {
            key = "1770283012939407456",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3300.0109531851017, y = 607.7982456140347},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1770283250027409760"] = {
            key = "1770283250027409760",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -552.6962852435224, y = -236.26535719182823},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["1770283250027409762"] = {
            key = "1770283250027409762",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -54.84885063762155, y = -223.94796869796923},
            propsData = {QuestRoleId = 24010101, IsPlayFX = false}
          },
          ["1770283250027409763"] = {
            key = "1770283250027409763",
            type = "ActivePlayerSkillsNode",
            name = "失效 子弹跳",
            pos = {x = 390.5501176855911, y = -400.0029137529143},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {"BulletJump"}
            }
          },
          ["1773059452018443601"] = {
            key = "1773059452018443601",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -190.34733893557436, y = 219.0112044817927},
            propsData = {SpecialConfigId = 20031807, BlackScreenImmediately = true}
          },
          ["1773059472913443675"] = {
            key = "1773059472913443675",
            type = "GoToNode",
            name = "前往",
            pos = {x = -286.4804652514513, y = 719.1424331597921},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010271,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox06_232010271"
            }
          },
          ["1773059472913443676"] = {
            key = "1773059472913443676",
            type = "JudgeRegionNode",
            name = "判断位于区域",
            pos = {x = -584.2628719973569, y = 225.06053488695846},
            propsData = {
              IsWaitingEnterRegion = false,
              RegionIds = {104301}
            }
          },
          ["1773059472913443677"] = {
            key = "1773059472913443677",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 4.310491044976743, y = 742.0487088105203},
            propsData = {
              ModeType = 1,
              Id = 104301,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["1773059557850444969"] = {
            key = "1773059557850444969",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 398.83333333333326, y = -225.6666666666667},
            propsData = {WaitTime = 10}
          },
          ["17737462905929190764"] = {
            key = "17737462905929190764",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 189.74561403508758, y = 327.6929824561402},
            propsData = {
              ModeType = 1,
              Id = 104501,
              StartIndex = 3,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["1770282194593398357"] = {
      isStoryNode = true,
      key = "1770282194593398357",
      type = "StoryNode",
      name = "终场",
      pos = {x = 1814.8658293460928, y = 526.8963032581456},
      propsData = {
        QuestId = 20031808,
        QuestDescriptionComment = "",
        QuestDescription = "Description_20031808",
        QuestDeatil = "Content_20031808",
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
        SubRegionId = 104501,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_TriggerBox05_232010278",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1773059612624446662",
            startPort = "true",
            endQuest = "1773059612624446661",
            endPort = "In"
          },
          {
            startQuest = "1773059612624446662",
            startPort = "false",
            endQuest = "1773059612624446660",
            endPort = "In"
          },
          {
            startQuest = "1770282194593398362",
            startPort = "QuestStart",
            endQuest = "1773059612624446662",
            endPort = "In"
          },
          {
            startQuest = "1773059612624446661",
            startPort = "Out",
            endQuest = "1773060070761451259",
            endPort = "In"
          },
          {
            startQuest = "1773059612624446660",
            startPort = "Out",
            endQuest = "1773060070761451259",
            endPort = "In"
          },
          {
            startQuest = "1773060070761451259",
            startPort = "Success",
            endQuest = "1770282194593398363",
            endPort = "Success"
          },
          {
            startQuest = "1773060070761451259",
            startPort = "Fail",
            endQuest = "17749672032326404799",
            endPort = "In"
          },
          {
            startQuest = "1773060070761451259",
            startPort = "PassiveFail",
            endQuest = "17749672032326404799",
            endPort = "In"
          },
          {
            startQuest = "17749672032326404799",
            startPort = "Out",
            endQuest = "1770282194593398364",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1770282194593398362"] = {
            key = "1770282194593398362",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1281.75, y = 333.125},
            propsData = {ModeType = 0}
          },
          ["1770282194593398363"] = {
            key = "1770282194593398363",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 255.26352450439234, y = 328.52766995646226},
            propsData = {ModeType = 0}
          },
          ["1770282194593398364"] = {
            key = "1770282194593398364",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 436.30547223674193, y = 504.6717341482048},
            propsData = {}
          },
          ["1773059612624446660"] = {
            key = "1773059612624446660",
            type = "GoToNode",
            name = "前往",
            pos = {x = -593.7146230962026, y = 511.73072103335267},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 232010278,
              GuideType = "M",
              GuidePointName = "Mechanism_TriggerBox05_232010278"
            }
          },
          ["1773059612624446661"] = {
            key = "1773059612624446661",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = -596.7812976928303, y = 322.3049932523618},
            propsData = {
              VarName = "WangchuanFushu05",
              VarValue = 1
            }
          },
          ["1773059612624446662"] = {
            key = "1773059612624446662",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "变量判断",
            pos = {x = -916.2187023071697, y = 320.8974302271515},
            propsData = {
              FunctionName = "Equal",
              VarName = "WangchuanFushu05",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["1773060070761451259"] = {
            key = "1773060070761451259",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = -171.23051948051932, y = 335.47662337662354},
            propsData = {SpecialConfigId = 20031808, BlackScreenImmediately = true}
          },
          ["17749672032326404799"] = {
            key = "17749672032326404799",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 97.24533758071252, y = 499.8979153816079},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "StartPoint_200318fushuBack",
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
