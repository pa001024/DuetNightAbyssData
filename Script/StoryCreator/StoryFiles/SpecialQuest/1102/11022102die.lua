return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1783433088936102",
      startPort = "Success",
      endStory = "1783433088937103",
      endPort = "In"
    },
    {
      startStory = "1783433088937103",
      startPort = "Success",
      endStory = "1783433088937104",
      endPort = "In"
    },
    {
      startStory = "1783433088937104",
      startPort = "Success",
      endStory = "1783433088937105",
      endPort = "In"
    },
    {
      startStory = "17834330714751",
      startPort = "StoryStart",
      endStory = "1783433088936102",
      endPort = "In"
    },
    {
      startStory = "1783433088937105",
      startPort = "Success",
      endStory = "17834330714765",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17834330714751"] = {
      isStoryNode = true,
      key = "17834330714751",
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
    ["17834330714765"] = {
      isStoryNode = true,
      key = "17834330714765",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2800, y = 300},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1783433088936102"] = {
      isStoryNode = true,
      key = "1783433088936102",
      type = "StoryNode",
      name = "旧村调查",
      pos = {x = 1190.4653322106396, y = 302.22115275692124},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01b",
        QuestDeatil = "Content_110221_01b",
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
            startQuest = "1783433088942129",
            startPort = "true",
            endQuest = "1783433088941128",
            endPort = "In"
          },
          {
            startQuest = "1783433088942133",
            startPort = "Out",
            endQuest = "1783433088942134",
            endPort = "In"
          },
          {
            startQuest = "1783433088943138",
            startPort = "Out",
            endQuest = "1783433088941126",
            endPort = "Success"
          },
          {
            startQuest = "1783433088944142",
            startPort = "Out",
            endQuest = "1783433088942133",
            endPort = "In"
          },
          {
            startQuest = "1783433088942133",
            startPort = "Out",
            endQuest = "1783433088944143",
            endPort = "In"
          },
          {
            startQuest = "1783433088942134",
            startPort = "Out",
            endQuest = "1783433088944144",
            endPort = "In"
          },
          {
            startQuest = "1783433088944144",
            startPort = "Out",
            endQuest = "1783433088943136",
            endPort = "In"
          },
          {
            startQuest = "1783433088943136",
            startPort = "Out",
            endQuest = "1783433088944145",
            endPort = "In"
          },
          {
            startQuest = "1783433088944145",
            startPort = "Out",
            endQuest = "1783433088943138",
            endPort = "In"
          },
          {
            startQuest = "1783433088942129",
            startPort = "false",
            endQuest = "1783433088944146",
            endPort = "In"
          },
          {
            startQuest = "17834381190073279784",
            startPort = "Out",
            endQuest = "17834381190073279783",
            endPort = "In"
          },
          {
            startQuest = "1783433088941125",
            startPort = "QuestStart",
            endQuest = "17834381190073279784",
            endPort = "Input"
          },
          {
            startQuest = "17834381190073279783",
            startPort = "Out",
            endQuest = "1783433088942129",
            endPort = "In"
          },
          {
            startQuest = "1783433088942134",
            startPort = "Out",
            endQuest = "1783433088943137",
            endPort = "In"
          },
          {
            startQuest = "1783433088942133",
            startPort = "Out",
            endQuest = "17834384458024371419",
            endPort = "In"
          },
          {
            startQuest = "1783433088943136",
            startPort = "Out",
            endQuest = "17834384624024371905",
            endPort = "In"
          },
          {
            startQuest = "1783433088941128",
            startPort = "Out",
            endQuest = "17848773183462307",
            endPort = "In"
          },
          {
            startQuest = "1783433088941128",
            startPort = "Out",
            endQuest = "17848815500458149",
            endPort = "In"
          },
          {
            startQuest = "17848815500458149",
            startPort = "Out",
            endQuest = "17848815896758925",
            endPort = "In"
          },
          {
            startQuest = "17848815896758925",
            startPort = "Out",
            endQuest = "17848816496349428",
            endPort = "In"
          },
          {
            startQuest = "17848816496349428",
            startPort = "Fail",
            endQuest = "17848815500458149",
            endPort = "In"
          },
          {
            startQuest = "17848816496349428",
            startPort = "Success",
            endQuest = "1783433088942130",
            endPort = "In"
          },
          {
            startQuest = "17848816496349428",
            startPort = "Success",
            endQuest = "1783433088943135",
            endPort = "In"
          },
          {
            startQuest = "17848816496349428",
            startPort = "Success",
            endQuest = "1783433088944142",
            endPort = "In"
          },
          {
            startQuest = "1783433088944146",
            startPort = "Out",
            endQuest = "17850605052502223177",
            endPort = "In"
          },
          {
            startQuest = "17850605052502223177",
            startPort = "Out",
            endQuest = "1783433088941126",
            endPort = "Success"
          },
          {
            startQuest = "17848816496349428",
            startPort = "Success",
            endQuest = "17871429874553358591",
            endPort = "In"
          }
        },
        nodeData = {
          ["1783433088941125"] = {
            key = "1783433088941125",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -582.7747252747256, y = 252.88063385889475},
            propsData = {ModeType = 0}
          },
          ["1783433088941126"] = {
            key = "1783433088941126",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4098.551692967597, y = 532.9296982575015},
            propsData = {ModeType = 0}
          },
          ["1783433088941127"] = {
            key = "1783433088941127",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1783433088941128"] = {
            key = "1783433088941128",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 509.1538461538462, y = 167.61872909699002},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "21_tp_rebirth01",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["1783433088942129"] = {
            key = "1783433088942129",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 163.45819397993318, y = 262.86872909698997},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11022102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["1783433088942130"] = {
            key = "1783433088942130",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1964.0966190603872, y = -128.8264280756349},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11111601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088942132"] = {
            key = "1783433088942132",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 2225.999313346777, y = 679.9442312167633},
            propsData = {
              StaticCreatorId = 0,
              UnitId = 0,
              bGuideUIEnable = true,
              GuidePointName = "",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = "",
              SoundEventPath = ""
            }
          },
          ["1783433088942133"] = {
            key = "1783433088942133",
            type = "FirstObservationCompleteNode",
            name = "首次观察完成",
            pos = {x = 2644.3986922287654, y = 2.8467156888130525},
            propsData = {
              StaticCreatorId = 142790025,
              ObservationPointName = "Mechanism_feiting_observe_142790025"
            }
          },
          ["1783433088942134"] = {
            key = "1783433088942134",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C6_02】调查飞艇",
            pos = {x = 2930.7437339935973, y = 21.52027039497638},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110221/11022102.11022102'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 0.5,
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
          ["1783433088943135"] = {
            key = "1783433088943135",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1982.5616036414522, y = 17.350955474267103},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_feiting_observe_142790025"
            }
          },
          ["1783433088943136"] = {
            key = "1783433088943136",
            type = "FirstObservationCompleteNode",
            name = "首次观察完成",
            pos = {x = 3371.623184223342, y = 145.1499651467862},
            propsData = {
              StaticCreatorId = 142790026,
              ObservationPointName = "Mechanism_weapon_observe_142790026"
            }
          },
          ["1783433088943137"] = {
            key = "1783433088943137",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3299.6833345992814, y = -72.22973410133406},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_weapon_observe_142790026"
            }
          },
          ["1783433088943138"] = {
            key = "1783433088943138",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 3848.2818083189945, y = 207.64728707038688},
            propsData = {
              VarName = "ex02_11022102",
              VarValue = 1
            }
          },
          ["1783433088944140"] = {
            key = "1783433088944140",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1322.90602006689, y = -344.7098423315814},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790152,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_shanlu03_142790152"
            }
          },
          ["1783433088944141"] = {
            key = "1783433088944141",
            type = "FirstObservationCompleteNode",
            name = "首次观察完成",
            pos = {x = 2703.3543760587245, y = -464.1075098814232},
            propsData = {StaticCreatorId = 0, ObservationPointName = ""}
          },
          ["1783433088944142"] = {
            key = "1783433088944142",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1961.0008046301518, y = 167.293139469226},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790025}
            }
          },
          ["1783433088944143"] = {
            key = "1783433088944143",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2919.125804630152, y = -166.16465273856642},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790025}
            }
          },
          ["1783433088944144"] = {
            key = "1783433088944144",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3143.4562095193805, y = 147.5158989079299},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790026}
            }
          },
          ["1783433088944145"] = {
            key = "1783433088944145",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3614.4562095193805, y = 152.0873274793585},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790026}
            }
          },
          ["1783433088944146"] = {
            key = "1783433088944146",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1940.2020846800256, y = 538.5770038784739},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "21_tp_rebirth02",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17834381190073279783"] = {
            key = "17834381190073279783",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -189.64037777917076, y = 239.07658509700204},
            propsData = {QuestRoleId = 22010101, IsPlayFX = false}
          },
          ["17834381190073279784"] = {
            key = "17834381190073279784",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -247.21031386649338, y = 46.67551557828487},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = true,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17834384458024371419"] = {
            key = "17834384458024371419",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2933.7541413566573, y = -321.0470265854338},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_feiting_observe_142790025"
            }
          },
          ["17834384624024371905"] = {
            key = "17834384624024371905",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 3625.4208080233243, y = -62.38035991876693},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_weapon_observe_142790026"
            }
          },
          ["17848773183462307"] = {
            key = "17848773183462307",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 784.3269230769233, y = -7.032051282051356},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790024}
            }
          },
          ["17848815500458149"] = {
            key = "17848815500458149",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 792.1371863139333, y = 175.01484334192352},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790341}
            }
          },
          ["17848815896758925"] = {
            key = "17848815896758925",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1109.0153081920553, y = 146.85300518008535},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022104,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_observepatten_shanjiao_142790341",
              IsUseCount = false
            }
          },
          ["17848816496349428"] = {
            key = "17848816496349428",
            type = "WaitingObservationFinishNode",
            name = "等待侦察完成",
            pos = {x = 1327.1403081920553, y = 329.35300518008535},
            propsData = {
              SequencePath = "LevelSequence'/Game/AssetDesign/Story/Sequence/1102EX02/SQ_EX02_Observe03.SQ_EX02_Observe03'",
              PauseMark = "Start",
              MoveSpeed = 1,
              bHidePlayer = true,
              Title = ""
            }
          },
          ["17850605052502223177"] = {
            key = "17850605052502223177",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2469.6788088072913, y = 526.461579055619},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790376}
            }
          },
          ["17871429874553358591"] = {
            key = "17871429874553358591",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1957.5194731738854, y = -254.99576159134955},
            propsData = {
              NewDescription = "Description_110221_01h",
              NewDetail = "Content_110221_01h",
              SubTaskTargetIndex = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["1783433088937103"] = {
      isStoryNode = true,
      key = "1783433088937103",
      type = "StoryNode",
      name = "思考模式",
      pos = {x = 1540.6522240627492, y = 308.85320331505886},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01c",
        QuestDeatil = "Content_110221_01c",
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
            startQuest = "1783433088959232",
            startPort = "Out",
            endQuest = "1783433088960235",
            endPort = "In"
          },
          {
            startQuest = "1783433088959233",
            startPort = "Out",
            endQuest = "1783433088960236",
            endPort = "In"
          },
          {
            startQuest = "1783433088959234",
            startPort = "Out",
            endQuest = "1783433088960237",
            endPort = "In"
          },
          {
            startQuest = "1783433088960235",
            startPort = "Out",
            endQuest = "1783433088961245",
            endPort = "Input_1"
          },
          {
            startQuest = "1783433088960236",
            startPort = "Out",
            endQuest = "1783433088961245",
            endPort = "Input_2"
          },
          {
            startQuest = "1783433088960237",
            startPort = "Out",
            endQuest = "1783433088961245",
            endPort = "Input_3"
          },
          {
            startQuest = "178344060942810920873",
            startPort = "Out",
            endQuest = "178344060942810920872",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920872",
            startPort = "Out",
            endQuest = "178344060942810920871",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920871",
            startPort = "Out",
            endQuest = "178344060942810920870",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920870",
            startPort = "Out",
            endQuest = "178344060942810920869",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920869",
            startPort = "Out",
            endQuest = "178344060942810920868",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920868",
            startPort = "Out",
            endQuest = "178344060942810920867",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920865",
            startPort = "Out",
            endQuest = "178344060942810920864",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921247",
            startPort = "Out",
            endQuest = "178344062868510921246",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921246",
            startPort = "Out",
            endQuest = "178344062868510921245",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921245",
            startPort = "Out",
            endQuest = "178344062868510921244",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921244",
            startPort = "Out",
            endQuest = "178344062868510921243",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921243",
            startPort = "Out",
            endQuest = "178344062868510921242",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921242",
            startPort = "Out",
            endQuest = "178344062868510921241",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921241",
            startPort = "Out",
            endQuest = "178344062868510921240",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921239",
            startPort = "Out",
            endQuest = "178344062868510921238",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921240",
            startPort = "Out",
            endQuest = "178344062868510921239",
            endPort = "In"
          },
          {
            startQuest = "1783433088961242",
            startPort = "Out",
            endQuest = "178344062868510921247",
            endPort = "In"
          },
          {
            startQuest = "178344062868510921238",
            startPort = "Out",
            endQuest = "1783433088961244",
            endPort = "In"
          },
          {
            startQuest = "1783433088961242",
            startPort = "Out",
            endQuest = "17835202847962194605",
            endPort = "In"
          },
          {
            startQuest = "1783433088961242",
            startPort = "Out",
            endQuest = "17835203207982195456",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "1783433088959231",
            endPort = "In"
          },
          {
            startQuest = "17849698903064220",
            startPort = "Out",
            endQuest = "17849699036524515",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "17835202262432193357",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "17835202372912193581",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "178344060942810920873",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "1783433088961241",
            endPort = "In"
          },
          {
            startQuest = "17849699036524515",
            startPort = "Out",
            endQuest = "17849858941647984",
            endPort = "In"
          },
          {
            startQuest = "1783433088959231",
            startPort = "Out",
            endQuest = "178498823192311174",
            endPort = "In"
          },
          {
            startQuest = "178498823192311174",
            startPort = "Out",
            endQuest = "178498824166211369",
            endPort = "In"
          },
          {
            startQuest = "178498824166211369",
            startPort = "Out",
            endQuest = "17850535169601121896",
            endPort = "In"
          },
          {
            startQuest = "17850535169601121896",
            startPort = "Fail",
            endQuest = "178498823192311174",
            endPort = "In"
          },
          {
            startQuest = "17850535890212230887",
            startPort = "Out",
            endQuest = "1783433088961242",
            endPort = "In"
          },
          {
            startQuest = "17850535169601121896",
            startPort = "Success",
            endQuest = "17850535890212230887",
            endPort = "In"
          },
          {
            startQuest = "17850535169601121896",
            startPort = "Success",
            endQuest = "17850538418992232848",
            endPort = "In"
          },
          {
            startQuest = "17850538418992232848",
            startPort = "Out",
            endQuest = "1783433088960238",
            endPort = "In"
          },
          {
            startQuest = "1783433088960238",
            startPort = "Out",
            endQuest = "17850542350163342310",
            endPort = "In"
          },
          {
            startQuest = "17850542350163342310",
            startPort = "Out",
            endQuest = "17850542973483343378",
            endPort = "In"
          },
          {
            startQuest = "17850542973483343378",
            startPort = "Out",
            endQuest = "1783433088958228",
            endPort = "Success"
          },
          {
            startQuest = "1783433088958227",
            startPort = "QuestStart",
            endQuest = "17849698903064220",
            endPort = "In"
          },
          {
            startQuest = "17850535169601121896",
            startPort = "Success",
            endQuest = "17871433225744476617",
            endPort = "In"
          },
          {
            startQuest = "17850535169601121896",
            startPort = "Success",
            endQuest = "17876639258551124721",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920867",
            startPort = "Out",
            endQuest = "178344060942810920866",
            endPort = "In"
          },
          {
            startQuest = "178344060942810920866",
            startPort = "Out",
            endQuest = "178344060942810920865",
            endPort = "In"
          },
          {
            startQuest = "178498824166211369",
            startPort = "Out",
            endQuest = "17877274458203937",
            endPort = "In"
          },
          {
            startQuest = "178498824166211369",
            startPort = "Out",
            endQuest = "17850603167962989",
            endPort = "In"
          }
        },
        nodeData = {
          ["1783433088958227"] = {
            key = "1783433088958227",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 355.8333333333333, y = 199.16666666666669},
            propsData = {ModeType = 0}
          },
          ["1783433088958228"] = {
            key = "1783433088958228",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 4368.917765670861, y = 591.2981987053194},
            propsData = {ModeType = 0}
          },
          ["1783433088959229"] = {
            key = "1783433088959229",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3315.4545454545455, y = 686.3636363636364},
            propsData = {}
          },
          ["1783433088959231"] = {
            key = "1783433088959231",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1511.5278637770898, y = 134.63441692466463},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112301,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088959232"] = {
            key = "1783433088959232",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2477.826060705123, y = -1182.385722210665},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790031,
              GuideType = "M",
              GuidePointName = "Mechanism_think03_142790031"
            }
          },
          ["1783433088959233"] = {
            key = "1783433088959233",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2465.0606927397553, y = -983.2982575014612},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790030,
              GuideType = "M",
              GuidePointName = "Mechanism_think02_142790030"
            }
          },
          ["1783433088959234"] = {
            key = "1783433088959234",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2460.517835596898, y = -776.212543215747},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790029,
              GuideType = "M",
              GuidePointName = "Mechanism_think01_142790029"
            }
          },
          ["1783433088960235"] = {
            key = "1783433088960235",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2869.7667464114834, y = -1194.256110632312},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112304,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088960236"] = {
            key = "1783433088960236",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2880.819377990431, y = -966.8876895796803},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112306,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088960237"] = {
            key = "1783433088960237",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 2879.917122351333, y = -755.6846820608832},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112308,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088960238"] = {
            key = "1783433088960238",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3216.4890300617853, y = 132.09144944435002},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112309,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["1783433088960239"] = {
            key = "1783433088960239",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 416.3457792207789, y = -397.3101688043639},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11022102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1783433088960240"] = {
            key = "1783433088960240",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 4442.400370527305, y = 37.28529107631268},
            propsData = {
              VarName = "ex02_11022102",
              VarValue = 2
            }
          },
          ["1783433088961241"] = {
            key = "1783433088961241",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1562.3479293152664, y = -79.2192348157518},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_Start",
              UnitId = -1
            }
          },
          ["1783433088961242"] = {
            key = "1783433088961242",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3594.135917256118, y = -190.6788004049611},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_End",
              UnitId = -1
            }
          },
          ["1783433088961243"] = {
            key = "1783433088961243",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 2391.178244510906, y = -349.9512830822424},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_Toastloop",
              UnitId = -1
            }
          },
          ["1783433088961244"] = {
            key = "1783433088961244",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3887.4358356040234, y = -184.316667697627},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_Toastdestory",
              UnitId = -1
            }
          },
          ["1783433088961245"] = {
            key = "1783433088961245",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 3030.603369824189, y = -1188.0346164155758},
            propsData = {ListenCount = 3, NeedFinishCount = 3}
          },
          ["178344060942810920864"] = {
            key = "178344060942810920864",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 1547.436448206045, y = -1491.1587033689948},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["178344060942810920865"] = {
            key = "178344060942810920865",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1544.3772913312034, y = -1341.1881805177086},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["178344060942810920866"] = {
            key = "178344060942810920866",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1533.9782739639943, y = -1221.5159294513332},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920867"] = {
            key = "178344060942810920867",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1561.7686118118602, y = -1086.369335024088},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920868"] = {
            key = "178344060942810920868",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1550.5574316876366, y = -968.5908671151856},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920869"] = {
            key = "178344060942810920869",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1552.4166449381544, y = -853.8268919599063},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920870"] = {
            key = "178344060942810920870",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1542.626226863983, y = -723.9246299643384},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920871"] = {
            key = "178344060942810920871",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1537.438551793955, y = -602.375026789735},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920872"] = {
            key = "178344060942810920872",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1544.2928935306497, y = -485.7162966310048},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344060942810920873"] = {
            key = "178344060942810920873",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1544.515115752872, y = -372.71629663100515},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = true
            }
          },
          ["178344062868510921238"] = {
            key = "178344062868510921238",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 3806.4995909456584, y = -1430.6163339736843},
            propsData = {
              WeaponTags = {"Melee", "Ranged"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["178344062868510921239"] = {
            key = "178344062868510921239",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 3795.9404340708165, y = -1305.020811122398},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Avoid",
                "BulletJump",
                "Attack",
                "Slide",
                "Skill1",
                "Skill2",
                "Skill3",
                "Fire"
              }
            }
          },
          ["178344062868510921240"] = {
            key = "178344062868510921240",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3792.955632389882, y = -1181.4392463305323},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Task",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921241"] = {
            key = "178344062868510921241",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3785.2067545514733, y = -1060.1476178026903},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921242"] = {
            key = "178344062868510921242",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3773.9955744272497, y = -943.6734977198751},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921243"] = {
            key = "178344062868510921243",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3775.854787677768, y = -828.9095225645958},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921244"] = {
            key = "178344062868510921244",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3766.0643696035963, y = -699.0072605690276},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921245"] = {
            key = "178344062868510921245",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3760.8766945335683, y = -577.4576573944242},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921246"] = {
            key = "178344062868510921246",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3767.7310362702633, y = -460.798927235694},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["178344062868510921247"] = {
            key = "178344062868510921247",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3767.953258492485, y = -349.7989272356945},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "AimIndicator",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17835202262432193357"] = {
            key = "17835202262432193357",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 1250.2538699690406, y = -234.2167182662538},
            propsData = {Rate = 0.25, Mode = "EWT_Normal"}
          },
          ["17835202372912193581"] = {
            key = "17835202372912193581",
            type = "CameraControlNode",
            name = "镜头控制节点",
            pos = {x = 1096.1185316231756, y = -410.83325961963726},
            propsData = {
              Duration = 1,
              CameraName = "StoryCamera03",
              LockRotate = false,
              FocalLength = 0,
              LensAperture = 0,
              FOV = 0,
              PPMaterialPath = ""
            }
          },
          ["17835202847962194605"] = {
            key = "17835202847962194605",
            type = "PlayerSwitchWalkRunNode",
            name = "玩家走跑切换",
            pos = {x = 3526.9791644114403, y = -531.2695501093333},
            propsData = {Rate = 1, Mode = "ToRun"}
          },
          ["17835203207982195456"] = {
            key = "17835203207982195456",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 3481.693450125726, y = -734.5552643950477},
            propsData = {Duration = 1}
          },
          ["17849698903064220"] = {
            key = "17849698903064220",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 966, y = 190},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790372}
            }
          },
          ["17849699036524515"] = {
            key = "17849699036524515",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1244, y = 182},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022106,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_die_think_start_142790372",
              IsUseCount = false
            }
          },
          ["17849858941647984"] = {
            key = "17849858941647984",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1555.6584909347393, y = -201.41573253215165},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_NPCStart",
              UnitId = -1
            }
          },
          ["178498823192311174"] = {
            key = "178498823192311174",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1756.610442105344, y = 112.65632853371778},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790373}
            }
          },
          ["178498824166211369"] = {
            key = "178498824166211369",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 2007.1104421053442, y = 93.15632853371778},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022107,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_Die_think_observe_142790373",
              IsUseCount = false
            }
          },
          ["17850535169601121896"] = {
            key = "17850535169601121896",
            type = "WaitingObservationFinishNode",
            name = "等待侦察完成",
            pos = {x = 2240.9078530277548, y = 98.1796385570276},
            propsData = {
              SequencePath = "LevelSequence'/Game/AssetDesign/Story/Sequence/1102EX02/SQ_EX02_ObserveThink.SQ_EX02_ObserveThink'",
              PauseMark = "Start",
              MoveSpeed = 1,
              bHidePlayer = true,
              Title = ""
            }
          },
          ["17850535890212230887"] = {
            key = "17850535890212230887",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3289.599244969147, y = -187.78464715725832},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "Die_NPCEnd",
              UnitId = -1
            }
          },
          ["17850538418992232848"] = {
            key = "17850538418992232848",
            type = "CameraLookAtNode",
            name = "CameraLookAt",
            pos = {x = 2815.7530911229933, y = 113.5321487918904},
            propsData = {
              TargetType = "Actor",
              PointName = "",
              ActorId = 142790374,
              Duration = 2,
              EasingFunc = 4,
              bDisableUserInput = true
            }
          },
          ["17850542350163342310"] = {
            key = "17850542350163342310",
            type = "GoToNode",
            name = "前往",
            pos = {x = 3554.153482398385, y = 111.2306243359542},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790374,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_fanfangxiang_142790374"
            }
          },
          ["17850542973483343378"] = {
            key = "17850542973483343378",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 3938.2734139374347, y = 89.16408793118246},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112401,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17850603167962989"] = {
            key = "17850603167962989",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2262.4152728076874, y = 702.3649141106571},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790376}
            }
          },
          ["17871433225744476617"] = {
            key = "17871433225744476617",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2756.4660045836517, y = 335.80573103367203},
            propsData = {
              NewDescription = "Description_110221_01i",
              NewDetail = "Content_110221_01i",
              SubTaskTargetIndex = 0
            }
          },
          ["17876639258551124721"] = {
            key = "17876639258551124721",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2774.0617733659533, y = 507.3585090090515},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790376}
            }
          },
          ["17877274458203937"] = {
            key = "17877274458203937",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2295.930622009569, y = 519.8851674641146},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790024}
            }
          }
        },
        commentData = {}
      }
    },
    ["1783433088937104"] = {
      isStoryNode = true,
      key = "1783433088937104",
      type = "StoryNode",
      name = "高处观察",
      pos = {x = 1880.3962105943815, y = 294.3287773820382},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01d",
        QuestDeatil = "Content_110221_01d",
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
            startQuest = "1783433088975327",
            startPort = "QuestStart",
            endQuest = "17850547351224452284",
            endPort = "In"
          },
          {
            startQuest = "17850547351224452284",
            startPort = "Out",
            endQuest = "17850548167614452758",
            endPort = "In"
          },
          {
            startQuest = "17850548167614452758",
            startPort = "Out",
            endQuest = "17850548434484453275",
            endPort = "In"
          },
          {
            startQuest = "17850548434484453275",
            startPort = "Fail",
            endQuest = "17850547351224452284",
            endPort = "In"
          },
          {
            startQuest = "17850548434484453275",
            startPort = "Success",
            endQuest = "1783433088975328",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1783433088975327"] = {
            key = "1783433088975327",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783433088975328"] = {
            key = "1783433088975328",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2201.0769230769233, y = 276.1538461538462},
            propsData = {ModeType = 0}
          },
          ["1783433088976329"] = {
            key = "1783433088976329",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1783433088976330"] = {
            key = "1783433088976330",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1099.7142857142858, y = 667.1428571428571},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11022102",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "3"}
              }
            }
          },
          ["1783433088976331"] = {
            key = "1783433088976331",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1273.484962406015, y = -167.75657894736844},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790032,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_gaodi_142790032"
            }
          },
          ["1783433088976333"] = {
            key = "1783433088976333",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1545.9780219780218, y = 808.7161172161173},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "21_tp_rebirth03",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17850547351224452284"] = {
            key = "17850547351224452284",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1162, y = 299.0526315789474},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790375}
            }
          },
          ["17850548167614452758"] = {
            key = "17850548167614452758",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1446.2105263157894, y = 288},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 11022105,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_Die_observe_gaodi_142790375",
              IsUseCount = false
            }
          },
          ["17850548434484453275"] = {
            key = "17850548434484453275",
            type = "WaitingObservationFinishNode",
            name = "等待侦察完成",
            pos = {x = 1736.7368421052631, y = 276.94736842105266},
            propsData = {
              SequencePath = "LevelSequence'/Game/AssetDesign/Story/Sequence/1102EX02/SQ_EX02_Observe04.SQ_EX02_Observe04'",
              PauseMark = "Start",
              MoveSpeed = 1,
              bHidePlayer = true,
              Title = ""
            }
          }
        },
        commentData = {
          ["17822168769903225"] = {
            key = "17822168769903225",
            name = "观察者模式",
            position = {x = 1682.642857142857, y = -118.79166666666671},
            size = {width = 528.3333333333334, height = 101.66666666666677}
          }
        }
      }
    },
    ["1783433088937105"] = {
      isStoryNode = true,
      key = "1783433088937105",
      type = "StoryNode",
      name = "前往山洞",
      pos = {x = 2247.5346677893604, y = 316.7783654751048},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01e",
        QuestDeatil = "Content_110221_01e",
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
            startQuest = "1783433088981362",
            startPort = "QuestStart",
            endQuest = "1783433088981365",
            endPort = "In"
          },
          {
            startQuest = "1783433088981365",
            startPort = "Out",
            endQuest = "1783433088982371",
            endPort = "In"
          },
          {
            startQuest = "1783433088982371",
            startPort = "Out",
            endQuest = "1783433088982370",
            endPort = "In"
          },
          {
            startQuest = "1783433088981365",
            startPort = "Out",
            endQuest = "1783433088982372",
            endPort = "In"
          },
          {
            startQuest = "1783433088982372",
            startPort = "Out",
            endQuest = "1783433088982366",
            endPort = "In"
          },
          {
            startQuest = "1783433088983373",
            startPort = "Out",
            endQuest = "1783433088982367",
            endPort = "In"
          },
          {
            startQuest = "1783433088982372",
            startPort = "Out",
            endQuest = "1783433088983374",
            endPort = "In"
          },
          {
            startQuest = "1783433088982367",
            startPort = "Out",
            endQuest = "1783433088983375",
            endPort = "In"
          },
          {
            startQuest = "1783433088981362",
            startPort = "QuestStart",
            endQuest = "17850576730676670317",
            endPort = "In"
          },
          {
            startQuest = "1783433088983373",
            startPort = "Out",
            endQuest = "17850603686951112169",
            endPort = "In"
          },
          {
            startQuest = "1783433088982366",
            startPort = "Out",
            endQuest = "17854986779382212547",
            endPort = "In"
          },
          {
            startQuest = "1783433088982370",
            startPort = "Out",
            endQuest = "17850577823306671668",
            endPort = "In"
          },
          {
            startQuest = "17850577823306671668",
            startPort = "Out",
            endQuest = "1783433088983373",
            endPort = "Input_2"
          },
          {
            startQuest = "17854986779382212547",
            startPort = "Out",
            endQuest = "1783433088983373",
            endPort = "Input_1"
          }
        },
        nodeData = {
          ["1783433088981362"] = {
            key = "1783433088981362",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1783433088981363"] = {
            key = "1783433088981363",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3173, y = 260.3333333333333},
            propsData = {ModeType = 0}
          },
          ["1783433088981364"] = {
            key = "1783433088981364",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2745, y = 843.3333333333334},
            propsData = {}
          },
          ["1783433088981365"] = {
            key = "1783433088981365",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1156, y = 296.00000000000006},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790033,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_cave_142790033"
            }
          },
          ["1783433088982366"] = {
            key = "1783433088982366",
            type = "FirstObservationCompleteNode",
            name = "首次观察完成",
            pos = {x = 1679.109907120743, y = 193.64280185758514},
            propsData = {
              StaticCreatorId = 142790034,
              ObservationPointName = "Mechanism_mubei_observe_142790034"
            }
          },
          ["1783433088982367"] = {
            key = "1783433088982367",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C6_05】祷告",
            pos = {x = 2540.766478989607, y = 338.4908294130711},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110221/11022104.11022104'",
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
          ["1783433088982368"] = {
            key = "1783433088982368",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1529.3897566407488, y = -164.42309000084833},
            propsData = {
              AllQuestOptions = {},
              IsSetCountInfo = false,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["1783433088982369"] = {
            key = "1783433088982369",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 2735.3873359278527, y = -123.81469074196451},
            propsData = {PopupId = 0}
          },
          ["1783433088982370"] = {
            key = "1783433088982370",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1699.209762373849, y = 487.02358335678815},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 2000130,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "M",
              GuidePointName = "Drop_read_shibinluyin_142790153",
              IsUseCount = false
            }
          },
          ["1783433088982371"] = {
            key = "1783433088982371",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1453.9156447267899, y = 481.7294657097293},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790153}
            }
          },
          ["1783433088982372"] = {
            key = "1783433088982372",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1430.9744682562016, y = 206.43534806267064},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790034}
            }
          },
          ["1783433088983373"] = {
            key = "1783433088983373",
            type = "WaitQuestFinishedNode",
            name = "等待任务完成",
            pos = {x = 2244.5038800209077, y = 303.49417159208224},
            propsData = {ListenCount = 2, NeedFinishCount = 2}
          },
          ["1783433088983374"] = {
            key = "1783433088983374",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1678.9920121158507, y = 52.6149146261381},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_mubei_observe_142790034"
            }
          },
          ["1783433088983375"] = {
            key = "1783433088983375",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2875.7523504617157, y = 339.81694543846294},
            propsData = {}
          },
          ["17850576730676670317"] = {
            key = "17850576730676670317",
            type = "TalkNode",
            name = "那片灌木后面藏着一条小路，过去看看。",
            pos = {x = 1152.359133126935, y = 63.318885448916525},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11112601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17850577823306671668"] = {
            key = "17850577823306671668",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1968.9191176470588, y = 429.3676470588234},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11124901,
              FlowAssetPath = "",
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
              TalkActors = {},
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
          ["17850603686951112169"] = {
            key = "17850603686951112169",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 2558.6666666666665, y = 143},
            propsData = {
              IsCreate = false,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {142790376}
            }
          },
          ["17854986779382212547"] = {
            key = "17854986779382212547",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 1941, y = 218},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "M",
              GuideName = "Mechanism_mubei_observe_142790034"
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
