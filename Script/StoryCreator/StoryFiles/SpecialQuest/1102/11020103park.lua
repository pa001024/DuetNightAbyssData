return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1780920816025330",
      startPort = "Success",
      endStory = "1780920816025331",
      endPort = "In"
    },
    {
      startStory = "1780920816025331",
      startPort = "Success",
      endStory = "1780920816025332",
      endPort = "In"
    },
    {
      startStory = "1780920816025332",
      startPort = "Success",
      endStory = "1780920816026333",
      endPort = "In"
    },
    {
      startStory = "17809207183421",
      startPort = "StoryStart",
      endStory = "1780920816025330",
      endPort = "In"
    },
    {
      startStory = "1780920816026333",
      startPort = "Success",
      endStory = "1780920816026335",
      endPort = "In"
    },
    {
      startStory = "1780920816026335",
      startPort = "Success",
      endStory = "17809207183425",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17809207183421"] = {
      isStoryNode = true,
      key = "17809207183421",
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
    ["17809207183425"] = {
      isStoryNode = true,
      key = "17809207183425",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1837.6785714285713, y = 499.2857142857143},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1780920816025330"] = {
      isStoryNode = true,
      key = "1780920816025330",
      type = "StoryNode",
      name = "到达乐园",
      pos = {x = 1150.552507307453, y = 258.699336558405},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03a",
        QuestDeatil = "Content_110201_03a",
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
            startQuest = "1780920816035373",
            startPort = "Out",
            endQuest = "1780920816035375",
            endPort = "In"
          },
          {
            startQuest = "1780920816036376",
            startPort = "Out",
            endQuest = "1780920816035374",
            endPort = "In"
          },
          {
            startQuest = "1780920816035375",
            startPort = "Out",
            endQuest = "1780920816036376",
            endPort = "In"
          },
          {
            startQuest = "1780920816035374",
            startPort = "Out",
            endQuest = "1780920816036377",
            endPort = "In"
          },
          {
            startQuest = "1780920816036377",
            startPort = "Out",
            endQuest = "17809915089412056140",
            endPort = "In"
          },
          {
            startQuest = "17809915089412056140",
            startPort = "Out",
            endQuest = "1780920816034371",
            endPort = "Success"
          },
          {
            startQuest = "1780920816034370",
            startPort = "QuestStart",
            endQuest = "17811700175691030170",
            endPort = "In"
          },
          {
            startQuest = "17811700175691030170",
            startPort = "Out",
            endQuest = "17809911866472053604",
            endPort = "In"
          },
          {
            startQuest = "17809911866472053604",
            startPort = "true",
            endQuest = "17812308953507166",
            endPort = "In"
          },
          {
            startQuest = "17812308953507166",
            startPort = "Out",
            endQuest = "1780920816035373",
            endPort = "In"
          },
          {
            startQuest = "17809911866472053604",
            startPort = "false",
            endQuest = "1780920816034371",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780920816034370"] = {
            key = "1780920816034370",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -498.27950310559083, y = 218.80641821946165},
            propsData = {ModeType = 0}
          },
          ["1780920816034371"] = {
            key = "1780920816034371",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2244.4886363636365, y = 415.73863636363615},
            propsData = {ModeType = 0}
          },
          ["1780920816035372"] = {
            key = "1780920816035372",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816035373"] = {
            key = "1780920816035373",
            type = "TalkNode",
            name = "【区介】EX02_SpecialShow_01",
            pos = {x = 583.5511881964965, y = 111.26926531388757},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "LevelSequence'/Game/AssetDesign/Story/DialogueSequence/MainStory/1102/110201/EX02_SpecialShow_01.EX02_SpecialShow_01'",
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
              HideAllBattleEntity = true,
              HideEffectCreature = true,
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
          },
          ["1780920816035374"] = {
            key = "1780920816035374",
            type = "TalkNode",
            name = "【Ex02_FixSimple_05】",
            pos = {x = 1536.4181977738456, y = 216.0799779963058},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020105.11020105'",
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
          ["1780920816035375"] = {
            key = "1780920816035375",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 866.8026405008666, y = 134.77826600681263},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790004}
            }
          },
          ["1780920816036376"] = {
            key = "1780920816036376",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1209.5244621574711, y = 193.08320985523486},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790005,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_gate_142790005"
            }
          },
          ["1780920816036377"] = {
            key = "1780920816036377",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 1882.289205252125, y = 164.58824762544648},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790004}
            }
          },
          ["17809892461822051579"] = {
            key = "17809892461822051579",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1498.487658693036, y = 690.6743147601554},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebieth02",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17809911866472053604"] = {
            key = "17809911866472053604",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 65.9610886447257, y = 217.40080346036956},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["17809915089412056140"] = {
            key = "17809915089412056140",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2123.437658693036, y = 129.86996693406823},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 1
            }
          },
          ["17811700175691030170"] = {
            key = "17811700175691030170",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -216.19910465407725, y = 210.44444444444443},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
          },
          ["17812308953507166"] = {
            key = "17812308953507166",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 312.88888888888874, y = 88.34920634920638},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth01",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["17809883781902047879"] = {
            key = "17809883781902047879",
            name = "伊薇执行引路ai",
            position = {x = 931.5499116574625, y = -84.81185124774991},
            size = {width = 690.0000000000006, height = 199.56521739130454}
          }
        }
      }
    },
    ["1780920816025331"] = {
      isStoryNode = true,
      key = "1780920816025331",
      type = "StoryNode",
      name = "打靶",
      pos = {x = 1483.4838392605238, y = 254.35841178269774},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03b",
        QuestDeatil = "Content_110201_03b",
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
            startQuest = "1780920816042408",
            startPort = "Out",
            endQuest = "1780920816043409",
            endPort = "In"
          },
          {
            startQuest = "17809919312922058396",
            startPort = "true",
            endQuest = "17809914840822055457",
            endPort = "In"
          },
          {
            startQuest = "1780920816042405",
            startPort = "QuestStart",
            endQuest = "17809919312922058396",
            endPort = "In"
          },
          {
            startQuest = "17809919312922058396",
            startPort = "true",
            endQuest = "17809919635672059236",
            endPort = "In"
          },
          {
            startQuest = "17809914840822055457",
            startPort = "Out",
            endQuest = "1780920816042408",
            endPort = "In"
          },
          {
            startQuest = "17809919635672059236",
            startPort = "Out",
            endQuest = "17809929683563081293",
            endPort = "In"
          },
          {
            startQuest = "1780920816043409",
            startPort = "Out",
            endQuest = "1780920816043412",
            endPort = "In"
          },
          {
            startQuest = "1780920816043412",
            startPort = "Out",
            endQuest = "17809937527233084733",
            endPort = "In"
          },
          {
            startQuest = "17809937527233084733",
            startPort = "Out",
            endQuest = "1780920816042406",
            endPort = "Success"
          },
          {
            startQuest = "17809919312922058396",
            startPort = "false",
            endQuest = "1780920816042406",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780920816042405"] = {
            key = "1780920816042405",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 452.2222222222222, y = 270},
            propsData = {ModeType = 0}
          },
          ["1780920816042406"] = {
            key = "1780920816042406",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2211.078431372549, y = 532.7450980392157},
            propsData = {ModeType = 0}
          },
          ["1780920816042407"] = {
            key = "1780920816042407",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2130, y = 765},
            propsData = {}
          },
          ["1780920816042408"] = {
            key = "1780920816042408",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1154.5238095238094, y = 172.75396825396828},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790014,
              GuideType = "M",
              GuidePointName = "ex02_tp_daba"
            }
          },
          ["1780920816043409"] = {
            key = "1780920816043409",
            type = "TalkNode",
            name = "【打靶】",
            pos = {x = 1494.3754209500178, y = 211.82345947063695},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020106.11020106'",
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
          ["1780920816043411"] = {
            key = "1780920816043411",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1497.9470857880867, y = -180.94412932668263},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1780920816043412"] = {
            key = "1780920816043412",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 1826.3180125541423, y = 229.6028405097578},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790009}
            }
          },
          ["17809914840822055457"] = {
            key = "17809914840822055457",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 923.2932181345224, y = 229.53526570048314},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebieth02",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17809919312922058396"] = {
            key = "17809919312922058396",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 668.5457433870477, y = 358.2726394378569},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17809919635672059236"] = {
            key = "17809919635672059236",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 940.0674116829094, y = 95.86143057503509},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790009}
            }
          },
          ["17809929683563081293"] = {
            key = "17809929683563081293",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1185.895789367516, y = -94.62653833561171},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809937527233084733"] = {
            key = "17809937527233084733",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2139.3525154371455, y = 164.99844098614196},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 2
            }
          }
        },
        commentData = {
          ["17809929075323080106"] = {
            key = "17809929075323080106",
            name = "中间小游戏",
            position = {x = 1386.8214439409737, y = 48.6392083528128},
            size = {width = 320.2093596059112, height = 98.76927339901471}
          }
        }
      }
    },
    ["1780920816025332"] = {
      isStoryNode = true,
      key = "1780920816025332",
      type = "StoryNode",
      name = "悬转木马",
      pos = {x = 1788.4741050723185, y = 250.57998782263496},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03c",
        QuestDeatil = "Content_110201_03c",
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
            startQuest = "17809964969204106769",
            startPort = "Out",
            endQuest = "17809965419164107427",
            endPort = "In"
          },
          {
            startQuest = "17809965673334107992",
            startPort = "true",
            endQuest = "17809964969204106769",
            endPort = "In"
          },
          {
            startQuest = "1780920816049440",
            startPort = "QuestStart",
            endQuest = "17809965673334107992",
            endPort = "In"
          },
          {
            startQuest = "1780920816050447",
            startPort = "Out",
            endQuest = "17809965873024108668",
            endPort = "In"
          },
          {
            startQuest = "17809965873024108668",
            startPort = "Out",
            endQuest = "1780920816049441",
            endPort = "Success"
          },
          {
            startQuest = "17809965673334107992",
            startPort = "true",
            endQuest = "17812347739004178439",
            endPort = "In"
          },
          {
            startQuest = "17812347739004178439",
            startPort = "Out",
            endQuest = "1780920816049443",
            endPort = "In"
          },
          {
            startQuest = "17809965673334107992",
            startPort = "false",
            endQuest = "1780920816049441",
            endPort = "Success"
          },
          {
            startQuest = "1780920816049443",
            startPort = "Out",
            endQuest = "1780920816049444",
            endPort = "In"
          },
          {
            startQuest = "1780920816049444",
            startPort = "Out",
            endQuest = "1780920816050447",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816049440"] = {
            key = "1780920816049440",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 224.5798319327731, y = 311.9117647058824},
            propsData = {ModeType = 0}
          },
          ["1780920816049441"] = {
            key = "1780920816049441",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2294.698879551821, y = 558.3963585434174},
            propsData = {ModeType = 0}
          },
          ["1780920816049442"] = {
            key = "1780920816049442",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816049443"] = {
            key = "1780920816049443",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1209.6218487394956, y = 291.46638655462186},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790006,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_cup_142790006"
            }
          },
          ["1780920816049444"] = {
            key = "1780920816049444",
            type = "TalkNode",
            name = "【旋转木马】",
            pos = {x = 1500.7250558194296, y = 275.68394430235867},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020107.11020107'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 1,
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
          ["1780920816050447"] = {
            key = "1780920816050447",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 1768.2558009237712, y = 273.1683947996225},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790010}
            }
          },
          ["17809964969204106769"] = {
            key = "17809964969204106769",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1137.7995016679229, y = 97.0629217273953},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790010}
            }
          },
          ["17809965419164107427"] = {
            key = "17809965419164107427",
            type = "TalkNode",
            name = "开车",
            pos = {x = 1448.8709302393515, y = 87.42006458453821},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101501,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17809965673334107992"] = {
            key = "17809965673334107992",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 536.0590362509867, y = 349.2898124836979},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["17809965873024108668"] = {
            key = "17809965873024108668",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2073.193590337874, y = 376.5579956190209},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 3
            }
          },
          ["17812347739004178439"] = {
            key = "17812347739004178439",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 960.8235294117649, y = 289.41176470588226},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth03",
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
    },
    ["1780920816026333"] = {
      isStoryNode = true,
      key = "1780920816026333",
      type = "StoryNode",
      name = "前往吧台",
      pos = {x = 1127.5934702501509, y = 500.8261663752653},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03d",
        QuestDeatil = "Content_110201_03d",
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
            startQuest = "1780920816057478",
            startPort = "Out",
            endQuest = "1780920816057481",
            endPort = "In"
          },
          {
            startQuest = "1780920816056475",
            startPort = "QuestStart",
            endQuest = "17809973755635132965",
            endPort = "In"
          },
          {
            startQuest = "17809973755635132965",
            startPort = "false",
            endQuest = "1780920816056476",
            endPort = "Success"
          },
          {
            startQuest = "17809973755635132965",
            startPort = "true",
            endQuest = "17810025827805136321",
            endPort = "In"
          },
          {
            startQuest = "17810026587666155539",
            startPort = "Out",
            endQuest = "1780920816056476",
            endPort = "Success"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "17810053683896160800",
            endPort = "In"
          },
          {
            startQuest = "17810071269856164020",
            startPort = "Out",
            endQuest = "1780920816057482",
            endPort = "In"
          },
          {
            startQuest = "1780920816057482",
            startPort = "Out",
            endQuest = "17810087121216168859",
            endPort = "In"
          },
          {
            startQuest = "17810087121216168859",
            startPort = "Out",
            endQuest = "17810026587666155539",
            endPort = "In"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "17811485314391024639",
            endPort = "In"
          },
          {
            startQuest = "17809973755635132965",
            startPort = "true",
            endQuest = "17812349675524179745",
            endPort = "In"
          },
          {
            startQuest = "17812349675524179745",
            startPort = "Out",
            endQuest = "1780920816057478",
            endPort = "In"
          },
          {
            startQuest = "178126636428716681193",
            startPort = "Out",
            endQuest = "17810071269856164020",
            endPort = "In"
          },
          {
            startQuest = "1780920816057481",
            startPort = "Out",
            endQuest = "178126636428716681193",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816056475"] = {
            key = "1780920816056475",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -91.4860681114551, y = 546.6439628482972},
            propsData = {ModeType = 0}
          },
          ["1780920816056476"] = {
            key = "1780920816056476",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2285.441411014166, y = 582.1634299652875},
            propsData = {ModeType = 0}
          },
          ["1780920816056477"] = {
            key = "1780920816056477",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2288.813209494324, y = 786.7440660474716},
            propsData = {}
          },
          ["1780920816057478"] = {
            key = "1780920816057478",
            type = "GoToNode",
            name = "前往",
            pos = {x = 860.1483253588517, y = 340.0574162679426},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790007,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_drink_142790007"
            }
          },
          ["1780920816057481"] = {
            key = "1780920816057481",
            type = "TalkNode",
            name = "饮水机【Ex02_FixSimple_08】",
            pos = {x = 1100.6037798518616, y = 288.67052949742407},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020108.11020108'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 1,
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
          ["1780920816057482"] = {
            key = "1780920816057482",
            type = "TalkNode",
            name = "大锤机【Ex02_FixSimple_09】",
            pos = {x = 1790.1419381982043, y = 298.3878278584162},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020111.11020111'",
              TalkType = "FixSimple",
              TalkStageName = "",
              BlendInTime = 0,
              BlendOutTime = 1,
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
          ["1780920816057483"] = {
            key = "1780920816057483",
            type = "TalkNode",
            name = "【机关-连线】",
            pos = {x = 1889.725400457666, y = -260.4161688806998},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["17809973755635132965"] = {
            key = "17809973755635132965",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 254.21291866028707, y = 565.5837320574162},
            propsData = {
              FunctionName = "Equal",
              VarName = "ex02_11020103",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "3"}
              }
            }
          },
          ["17810025827805136321"] = {
            key = "17810025827805136321",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 828.7583732057413, y = 141.41176973181678},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790011}
            }
          },
          ["17810026587666155539"] = {
            key = "17810026587666155539",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2354.949291678394, y = 311.65999501874194},
            propsData = {
              VarName = "ex02_11020103",
              VarValue = 4
            }
          },
          ["17810053683896160800"] = {
            key = "17810053683896160800",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1356.1717511075087, y = 55.3998759238715},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11101801,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17810071269856164020"] = {
            key = "17810071269856164020",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1567.844545225156, y = 300.97381383236825},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790008,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_dachuiji_142790008"
            }
          },
          ["17810087121216168859"] = {
            key = "17810087121216168859",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 2051.202851432727, y = 304.9574070542925},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790011}
            }
          },
          ["17811485314391024639"] = {
            key = "17811485314391024639",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1323.8253613834795, y = -96.37191602823495},
            propsData = {
              NewDescription = "Description_110201_03e",
              NewDetail = "Content_110201_03e",
              SubTaskTargetIndex = 0
            }
          },
          ["17812349675524179745"] = {
            key = "17812349675524179745",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 630, y = 476.00000000000006},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth04",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178126636428716681193"] = {
            key = "178126636428716681193",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1337.9555555555553, y = 291.9887077294685},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth06",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          }
        },
        commentData = {
          ["17810072155436165386"] = {
            key = "17810072155436165386",
            name = "小游戏接入",
            position = {x = 1566.1717511075087, y = 194.81164062975384},
            size = {width = 397.05882352941177, height = 93.52941176470594}
          }
        }
      }
    },
    ["1780920816026334"] = {
      isStoryNode = true,
      key = "1780920816026334",
      type = "StoryNode",
      name = "伊薇总结",
      pos = {x = 598.4175187608377, y = 771.7452621961635},
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
            startQuest = "1780920816064517",
            startPort = "QuestStart",
            endQuest = "1780920816065520",
            endPort = "In"
          },
          {
            startQuest = "1780920816065520",
            startPort = "Out",
            endQuest = "1780920816065518",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780920816064517"] = {
            key = "1780920816064517",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780920816065518"] = {
            key = "1780920816065518",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1621.1993927125507, y = 288.4827935222672},
            propsData = {ModeType = 0}
          },
          ["1780920816065519"] = {
            key = "1780920816065519",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816065520"] = {
            key = "1780920816065520",
            type = "TalkNode",
            name = "【Ex02_FixSimple_12】：伊薇总结",
            pos = {x = 1165.6196508687497, y = 274.47031568643445},
            propsData = {
              IsNpcNode = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = true,
              AllowSurroundDialogue = false,
              FirstDialogueId = 0,
              FlowAssetPath = "",
              TalkType = "FreeSimple",
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
              TalkActors = {},
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["1780920816065521"] = {
            key = "1780920816065521",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1178.0120384573477, y = 533.9650757328103},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    },
    ["1780920816026335"] = {
      isStoryNode = true,
      key = "1780920816026335",
      type = "StoryNode",
      name = "去过山车",
      pos = {x = 1438.4587553020745, y = 501.3159359668374},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_03f",
        QuestDeatil = "Content_110201_03f",
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
            startQuest = "1780920816070541",
            startPort = "Out",
            endQuest = "1780920816070543",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "178107316455510251602",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "178107335548411271484",
            endPort = "In"
          },
          {
            startQuest = "1780920816069540",
            startPort = "Out",
            endQuest = "1780920816070541",
            endPort = "In"
          },
          {
            startQuest = "1780920816068537",
            startPort = "QuestStart",
            endQuest = "17812351306505221645",
            endPort = "In"
          },
          {
            startQuest = "17812351306505221645",
            startPort = "Out",
            endQuest = "1780920816069540",
            endPort = "In"
          },
          {
            startQuest = "1780920816070543",
            startPort = "Out",
            endQuest = "178126668466819805713",
            endPort = "In"
          }
        },
        nodeData = {
          ["1780920816068537"] = {
            key = "1780920816068537",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 384, y = 324},
            propsData = {ModeType = 0}
          },
          ["1780920816069538"] = {
            key = "1780920816069538",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2528, y = 325.75},
            propsData = {ModeType = 0}
          },
          ["1780920816069539"] = {
            key = "1780920816069539",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816069540"] = {
            key = "1780920816069540",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1144.9285714285713, y = 302.5},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142790013,
              GuideType = "M",
              GuidePointName = "Mechanism_ex02_guoshanche_142790013"
            }
          },
          ["1780920816070541"] = {
            key = "1780920816070541",
            type = "TalkNode",
            name = " 【Ex02_FixSimple_13】",
            pos = {x = 1528.4499999999998, y = 322.7333333333333},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110201/11020113.11020113'",
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
          ["1780920816070543"] = {
            key = "1780920816070543",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇",
            pos = {x = 1984.1525911827648, y = 322.49982138368716},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790012}
            }
          },
          ["1780920816070544"] = {
            key = "1780920816070544",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 2398.835338345865, y = 52.85275689223067},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 0,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "",
              IsUseCount = false
            }
          },
          ["178107316455510251602"] = {
            key = "178107316455510251602",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇",
            pos = {x = 1139.4285714285713, y = 149.71428571428572},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {142790012}
            }
          },
          ["178107335548411271484"] = {
            key = "178107335548411271484",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1145.7142857142858, y = -17.714285714285715},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102001,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["178110071961812294771"] = {
            key = "178110071961812294771",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1513.1209507726535, y = 161.35598354174215},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11102101,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17812351306505221645"] = {
            key = "17812351306505221645",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 848, y = 330.00000000000006},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02_tp_rebirth05",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178126668466819805713"] = {
            key = "178126668466819805713",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2279.3455478847154, y = 354.1015043401985},
            propsData = {}
          }
        },
        commentData = {
          ["178110075167813313345"] = {
            key = "178110075167813313345",
            name = "到达后播开车",
            position = {x = 1469.1209507726535, y = 43.35598354174215},
            size = {width = 636, height = 78}
          }
        }
      }
    },
    ["1780920816026336"] = {
      isStoryNode = true,
      key = "1780920816026336",
      type = "StoryNode",
      name = "去发出声音的地方",
      pos = {x = 1123.55024561736, y = 740.8100985069539},
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
            startQuest = "1780920816075570",
            startPort = "QuestStart",
            endQuest = "1780920816076573",
            endPort = "In"
          },
          {
            startQuest = "1780920816076573",
            startPort = "Out",
            endQuest = "1780920816075571",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1780920816075570"] = {
            key = "1780920816075570",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1780920816075571"] = {
            key = "1780920816075571",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1798, y = 296},
            propsData = {ModeType = 0}
          },
          ["1780920816076572"] = {
            key = "1780920816076572",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1780920816076573"] = {
            key = "1780920816076573",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1240, y = 286},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
