return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177780107979948558059",
      startPort = "Success",
      endStory = "177780107979948558060",
      endPort = "In"
    },
    {
      startStory = "177780107587248558023",
      startPort = "StoryStart",
      endStory = "177780107979948558059",
      endPort = "In"
    },
    {
      startStory = "177780107979948558060",
      startPort = "Success",
      endStory = "177780108290848558197",
      endPort = "In"
    },
    {
      startStory = "177780108290848558197",
      startPort = "Success",
      endStory = "177780107587248558026",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177780107587248558023"] = {
      isStoryNode = true,
      key = "177780107587248558023",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 538.4444444444445, y = 282.66666666666663},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177780107587248558026"] = {
      isStoryNode = true,
      key = "177780107587248558026",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2321.304347826087, y = 266.0869565217391},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177780107979948558059"] = {
      isStoryNode = true,
      key = "177780107979948558059",
      type = "StoryNode",
      name = "拾取止血钳前",
      pos = {x = 849.8894436908798, y = 261.4322218860262},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040203_01_04",
        QuestDeatil = "Description_10040203_01",
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
            startQuest = "177780107980148558073",
            startPort = "Out",
            endQuest = "177780107980148558074",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558073",
            startPort = "Out",
            endQuest = "177780107980148558075",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558078",
            startPort = "Out",
            endQuest = "177780107979948558071",
            endPort = "Success"
          },
          {
            startQuest = "177780107979948558070",
            startPort = "QuestStart",
            endQuest = "177780107980148558080",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558080",
            startPort = "Out",
            endQuest = "177780107979948558072",
            endPort = "Fail"
          },
          {
            startQuest = "177780107980148558074",
            startPort = "Out",
            endQuest = "177780107980148558078",
            endPort = "In"
          },
          {
            startQuest = "17780683283561654",
            startPort = "Out",
            endQuest = "17780683283561655",
            endPort = "In"
          },
          {
            startQuest = "17780683283561655",
            startPort = "Out",
            endQuest = "17780683283561653",
            endPort = "In"
          },
          {
            startQuest = "17780683283561653",
            startPort = "Out",
            endQuest = "17780683283561652",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558079",
            startPort = "Out",
            endQuest = "17780683283561654",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558081",
            startPort = "false",
            endQuest = "177780107979948558071",
            endPort = "Success"
          },
          {
            startQuest = "17780683283561652",
            startPort = "Out",
            endQuest = "177780107980148558082",
            endPort = "In"
          },
          {
            startQuest = "177780107979948558070",
            startPort = "QuestStart",
            endQuest = "177780188640549492977",
            endPort = "In"
          },
          {
            startQuest = "177780188640549492977",
            startPort = "Out",
            endQuest = "177780107980148558079",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558081",
            startPort = "true",
            endQuest = "177780107980148558073",
            endPort = "In"
          },
          {
            startQuest = "177780188640549492977",
            startPort = "Out",
            endQuest = "177780107980148558077",
            endPort = "In"
          },
          {
            startQuest = "177780107980148558077",
            startPort = "Out",
            endQuest = "177780107980148558081",
            endPort = "In"
          }
        },
        nodeData = {
          ["177780107979948558070"] = {
            key = "177780107979948558070",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -1426.5029425627251, y = 231.34998740977005},
            propsData = {ModeType = 0}
          },
          ["177780107979948558071"] = {
            key = "177780107979948558071",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1734.6692508897747, y = 643.0411848293693},
            propsData = {ModeType = 0}
          },
          ["177780107979948558072"] = {
            key = "177780107979948558072",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = -130.40485829959528, y = -311.4574898785427},
            propsData = {}
          },
          ["177780107980148558073"] = {
            key = "177780107980148558073",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 509.3731268731266, y = 264.62237762237766},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10042101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041501.10041501'",
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
          ["177780107980148558074"] = {
            key = "177780107980148558074",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1385.7413823019087, y = 280.21530792740396},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 10077,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "BP_Zhixueqian",
              IsUseCount = false
            }
          },
          ["177780107980148558075"] = {
            key = "177780107980148558075",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1399.686455958902, y = 115.60916076957098},
            propsData = {
              NewDescription = "Content_10040204_01_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177780107980148558077"] = {
            key = "177780107980148558077",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -384.9737033531728, y = 97.17995258195828},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480046, 272480052}
            }
          },
          ["177780107980148558078"] = {
            key = "177780107980148558078",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1889.4601648351645, y = 274.3383699633702},
            propsData = {
              VarName = "StateYWS100402",
              VarValue = 1
            }
          },
          ["177780107980148558079"] = {
            key = "177780107980148558079",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -602.8175614431339, y = -10.64659425242931},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177780107980148558080"] = {
            key = "177780107980148558080",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -542.0462559327441, y = -314.5320833573303},
            propsData = {}
          },
          ["177780107980148558081"] = {
            key = "177780107980148558081",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -20.019392163900363, y = 308.30908393665817},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateYWS100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177780107980148558082"] = {
            key = "177780107980148558082",
            type = "CameraControlNode",
            name = "镜头控制节点",
            pos = {x = 673.4508432785749, y = -101.0686944634314},
            propsData = {
              Duration = 3,
              CameraName = "StoryEast01Nai01",
              LockRotate = false,
              FocalLength = 0,
              LensAperture = 0,
              FOV = 70,
              PPMaterialPath = ""
            }
          },
          ["177780188640549492977"] = {
            key = "177780188640549492977",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -853.0435858481824, y = 336.83529936386594},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_REYWS",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17780683283561652"] = {
            key = "17780683283561652",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 337.801117045044, y = -173.8848811279241},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["17780683283561653"] = {
            key = "17780683283561653",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = -46.65456044646477, y = -141.11702398506694},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "None",
              ShowOrHide = true
            }
          },
          ["17780683283561654"] = {
            key = "17780683283561654",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = -562.8177413409014, y = -136.19155502173817},
            propsData = {
              PlayerId = 0,
              bActiveEnable = false,
              ActiveType = "Lock",
              SkillNameList = {
                "Attack",
                "Jump",
                "Slide",
                "BulletJump",
                "Fire",
                "Skill1",
                "Skill2",
                "Avoid",
                "Skill3"
              }
            }
          },
          ["17780683283561655"] = {
            key = "17780683283561655",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = -344.79869372185385, y = -121.07965025983339},
            propsData = {
              WeaponTags = {"Melee"},
              bForbid = true,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          }
        },
        commentData = {}
      }
    },
    ["177780107979948558060"] = {
      isStoryNode = true,
      key = "177780107979948558060",
      type = "StoryNode",
      name = "拾取止血钳后",
      pos = {x = 1171.4741926727568, y = 266.1132326594284},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040204_01_02",
        QuestDeatil = "Description_10040203_01",
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
            startQuest = "177780107980448558133",
            startPort = "Out",
            endQuest = "177780107980448558132",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558132",
            startPort = "Out",
            endQuest = "177780107980448558134",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558136",
            startPort = "Out",
            endQuest = "177780107980448558130",
            endPort = "Success"
          },
          {
            startQuest = "177780107980448558129",
            startPort = "QuestStart",
            endQuest = "177780107980448558137",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558137",
            startPort = "false",
            endQuest = "177780107980448558130",
            endPort = "Success"
          },
          {
            startQuest = "177780107980448558129",
            startPort = "QuestStart",
            endQuest = "177780107980448558138",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558138",
            startPort = "Out",
            endQuest = "177780107980448558131",
            endPort = "Fail"
          },
          {
            startQuest = "177780107980448558137",
            startPort = "true",
            endQuest = "177780107980448558135",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558137",
            startPort = "true",
            endQuest = "177780107980448558133",
            endPort = "In"
          },
          {
            startQuest = "177780107980448558134",
            startPort = "Out",
            endQuest = "177780107980448558136",
            endPort = "In"
          }
        },
        nodeData = {
          ["177780107980448558129"] = {
            key = "177780107980448558129",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -24.77962240462213, y = 123.14181876681879},
            propsData = {ModeType = 0}
          },
          ["177780107980448558130"] = {
            key = "177780107980448558130",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2803.0564144508517, y = 433.39522209645},
            propsData = {ModeType = 0}
          },
          ["177780107980448558131"] = {
            key = "177780107980448558131",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1109.7596153846152, y = -230.24038461538476},
            propsData = {}
          },
          ["177780107980448558132"] = {
            key = "177780107980448558132",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1845.4745225534698, y = 206.15733389417616},
            propsData = {
              NewDescription = "Content_10040204_01_03",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177780107980448558133"] = {
            key = "177780107980448558133",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1448.6327436962101, y = 170.4676650041436},
            propsData = {
              StaticCreatorId = 272480047,
              UnitId = 10078,
              bGuideUIEnable = true,
              GuidePointName = "BP_Ganguo",
              LongPressTime = 4,
              MontageName = "Interactive_01_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177780107980448558134"] = {
            key = "177780107980448558134",
            type = "SubmitItemNode",
            name = "提交物品",
            pos = {x = 2177.020696314053, y = 250.2342149764818},
            propsData = {
              AssociatedObjectType = "Npc",
              AssociatedObjectId = 100412,
              InteractionId = 100114,
              bGuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Yisheng_272480052",
              SubmitId = 10040231
            }
          },
          ["177780107980448558135"] = {
            key = "177780107980448558135",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1712.9928579673285, y = -93.46802238651404},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_11.10049901_11'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177780107980448558136"] = {
            key = "177780107980448558136",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2462.603021978022, y = 303.2431318681321},
            propsData = {
              VarName = "StateYWS100402",
              VarValue = 2
            }
          },
          ["177780107980448558137"] = {
            key = "177780107980448558137",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 657.8035022757565, y = 164.71710269135895},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateYWS100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["177780107980448558138"] = {
            key = "177780107980448558138",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 543.7761124883086, y = -198.8741886204882},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["177780108290848558197"] = {
      isStoryNode = true,
      key = "177780108290848558197",
      type = "StoryNode",
      name = "拾取止痛药前",
      pos = {x = 1511.3830750718178, y = 239.7584627897652},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040204_01_04",
        QuestDeatil = "Description_10040203_01",
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
            startQuest = "177780108290948558208",
            startPort = "QuestStart",
            endQuest = "177780108290948558218",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558208",
            startPort = "QuestStart",
            endQuest = "177780108290948558219",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558219",
            startPort = "Out",
            endQuest = "177780108290948558210",
            endPort = "Fail"
          },
          {
            startQuest = "177780108290948558218",
            startPort = "true",
            endQuest = "177780108290948558213",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558218",
            startPort = "true",
            endQuest = "177780108290948558214",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558214",
            startPort = "Out",
            endQuest = "177780108290948558215",
            endPort = "In"
          },
          {
            startQuest = "177780108291048558224",
            startPort = "Out",
            endQuest = "177780108291048558225",
            endPort = "In"
          },
          {
            startQuest = "177780108291048558225",
            startPort = "Out",
            endQuest = "177780108290948558217",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558215",
            startPort = "Out",
            endQuest = "177780108291048558226",
            endPort = "In"
          },
          {
            startQuest = "177780108291048558226",
            startPort = "Out",
            endQuest = "177780108290948558220",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558220",
            startPort = "Out",
            endQuest = "17781679684387614397",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558220",
            startPort = "Out",
            endQuest = "17781679951417615067",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558220",
            startPort = "Out",
            endQuest = "17781679956937615087",
            endPort = "In"
          },
          {
            startQuest = "17781679684387614397",
            startPort = "Out",
            endQuest = "177780108291048558224",
            endPort = "Branch_1"
          },
          {
            startQuest = "17781679951417615067",
            startPort = "Out",
            endQuest = "177780108291048558224",
            endPort = "Branch_2"
          },
          {
            startQuest = "17781679956937615087",
            startPort = "Out",
            endQuest = "177780108291048558224",
            endPort = "Branch_3"
          },
          {
            startQuest = "177780108290948558215",
            startPort = "Out",
            endQuest = "177816829143610467336",
            endPort = "In"
          },
          {
            startQuest = "17785866419263264",
            startPort = "Out",
            endQuest = "17785866419263262",
            endPort = "In"
          },
          {
            startQuest = "17785866419263262",
            startPort = "Out",
            endQuest = "17785866419263261",
            endPort = "In"
          },
          {
            startQuest = "17785866419263261",
            startPort = "Out",
            endQuest = "17785866419263265",
            endPort = "In"
          },
          {
            startQuest = "17785866419263265",
            startPort = "Out",
            endQuest = "17785866419263263",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558217",
            startPort = "Out",
            endQuest = "17785866419263264",
            endPort = "In"
          },
          {
            startQuest = "177780108290948558218",
            startPort = "false",
            endQuest = "17785866419263264",
            endPort = "In"
          },
          {
            startQuest = "17785866419263263",
            startPort = "Out",
            endQuest = "17785866521823601",
            endPort = "In"
          }
        },
        nodeData = {
          ["177780108290948558208"] = {
            key = "177780108290948558208",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -550.558843183843, y = 250.26303088803093},
            propsData = {ModeType = 0}
          },
          ["177780108290948558209"] = {
            key = "177780108290948558209",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2664.9611763556136, y = -368.0333493321215},
            propsData = {ModeType = 0}
          },
          ["177780108290948558210"] = {
            key = "177780108290948558210",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 185.38461538461524, y = -254.61538461538476},
            propsData = {}
          },
          ["177780108290948558211"] = {
            key = "177780108290948558211",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 120.2769407142865, y = 807.5054219451226},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480128}
            }
          },
          ["177780108290948558212"] = {
            key = "177780108290948558212",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 316.0918059960637, y = 846.1564671073907},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 10083,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "BP_Baoxiangui",
              IsUseCount = false
            }
          },
          ["177780108290948558213"] = {
            key = "177780108290948558213",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1597.9458910201804, y = -208.21203620303524},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = false,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10049901_12.10049901_12'",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177780108290948558214"] = {
            key = "177780108290948558214",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = -69.78336558749993, y = 461.14998163345035},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272480177}
            }
          },
          ["177780108290948558215"] = {
            key = "177780108290948558215",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 450.44244086411277, y = 464.6983687302246},
            propsData = {
              CreateType = "StaticCreator",
              CreateId = 272480177,
              StateId = 572,
              IsGuideEnable = true,
              GuidePointName = "BP_Baoxiangui"
            }
          },
          ["177780108290948558216"] = {
            key = "177780108290948558216",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 552.5900312244166, y = 1105.8807575779358},
            propsData = {
              NewDescription = "Content_10040204_01_07",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177780108290948558217"] = {
            key = "177780108290948558217",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2448.888736263736, y = 741.8145604395606},
            propsData = {
              VarName = "StateYWS100402",
              VarValue = 3
            }
          },
          ["177780108290948558218"] = {
            key = "177780108290948558218",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 265.13683560908987, y = 178.71710269135895},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateYWS100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "2"}
              }
            }
          },
          ["177780108290948558219"] = {
            key = "177780108290948558219",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = -223.09888751169137, y = -281.3741886204882},
            propsData = {}
          },
          ["177780108290948558220"] = {
            key = "177780108290948558220",
            type = "BranchQuestStartNode",
            name = "子任务开始节点",
            pos = {x = 1149.1868713270155, y = 755.8839501043803},
            propsData = {
              AllQuestOptions = {
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                },
                {
                  IsNeedFinish = true,
                  BranchQuestName = "",
                  TargetBranchQuestKey = ""
                }
              },
              IsSetCountInfo = true,
              IsDifftation = false,
              AllDiffGuideOptions = {}
            }
          },
          ["177780108291048558224"] = {
            key = "177780108291048558224",
            type = "CheckBranchQuestFinishedNode",
            name = "子任务结束节点",
            pos = {x = 1769.4327033934994, y = 896.527541114819},
            propsData = {
              InputBranchQuestNumber = 3,
              BranchQuestFinishOptions = {
                {IsNeedFinish = true},
                {IsNeedFinish = true},
                {IsNeedFinish = true}
              }
            }
          },
          ["177780108291048558225"] = {
            key = "177780108291048558225",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2077.8540468286988, y = 892.5835111968804},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                272480046,
                272480052,
                272480047,
                272480049,
                272480050,
                272480051
              }
            }
          },
          ["177780108291048558226"] = {
            key = "177780108291048558226",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 687.1381437974696, y = 688.8424098336263},
            propsData = {
              NewDescription = "Content_10040204_01_05",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17781679684387614397"] = {
            key = "17781679684387614397",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1528.2734896682261, y = 517.279822344838},
            propsData = {
              StaticCreatorId = 272480049,
              UnitId = 10080,
              bGuideUIEnable = true,
              GuidePointName = "BP_Weiyao01",
              LongPressTime = 4,
              MontageName = "Interactive_OperateNormal_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["17781679951417615067"] = {
            key = "17781679951417615067",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1486.2222076169442, y = 761.9428260078416},
            propsData = {
              StaticCreatorId = 272480050,
              UnitId = 10081,
              bGuideUIEnable = true,
              GuidePointName = "BP_Weiyao02",
              LongPressTime = 4,
              MontageName = "Interactive_OperateNormal_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["17781679956937615087"] = {
            key = "17781679956937615087",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 1487.6068230015594, y = 969.0966721616879},
            propsData = {
              StaticCreatorId = 272480051,
              UnitId = 10082,
              bGuideUIEnable = true,
              GuidePointName = "BP_Weiyao03",
              LongPressTime = 4,
              MontageName = "Interactive_OperateNormal_Montage",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["177816829143610467336"] = {
            key = "177816829143610467336",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 854.3817960833977, y = 464.19919618228965},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 100410601,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17785866419263261"] = {
            key = "17785866419263261",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2816.1103204538535, y = 272.7542866672102},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BloodBar",
              ActionParam = "None",
              ShowOrHide = false
            }
          },
          ["17785866419263262"] = {
            key = "17785866419263262",
            type = "ForbidWeaponByWeaponTagNode",
            name = "禁用/启用武器节点",
            pos = {x = 2517.9661871784647, y = 292.79166039244376},
            propsData = {
              WeaponTags = {"Melee"},
              bForbid = false,
              ForbidTag = "ForbidDefault",
              bHidewhenForbid = true
            }
          },
          ["17785866419263263"] = {
            key = "17785866419263263",
            type = "CameraControlClearNode",
            name = "镜头恢复",
            pos = {x = 3500.224289012012, y = 304.01357047564704},
            propsData = {Duration = 0}
          },
          ["17785866419263264"] = {
            key = "17785866419263264",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 2315.7757109879885, y = 275.27975563053894},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {
                "Attack",
                "Jump",
                "Slide",
                "BulletJump",
                "Fire",
                "Skill1",
                "Skill2",
                "Avoid",
                "Skill3"
              }
            }
          },
          ["17785866419263265"] = {
            key = "17785866419263265",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 3200.5659979453626, y = 239.98642952435296},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "None",
              ShowOrHide = false
            }
          },
          ["17785866521823601"] = {
            key = "17785866521823601",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3908, y = 472},
            propsData = {}
          }
        },
        commentData = {}
      }
    },
    ["177780108290848558198"] = {
      isStoryNode = true,
      key = "177780108290848558198",
      type = "StoryNode",
      name = "医务室后续对话",
      pos = {x = 1872.9212727542692, y = 511.332446301144},
      propsData = {
        QuestId = 10040233,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040203_01",
        QuestDeatil = "Description_10040203_01",
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
            startQuest = "177780108292048558302",
            startPort = "Out",
            endQuest = "177780108292048558303",
            endPort = "In"
          },
          {
            startQuest = "177780108292048558303",
            startPort = "Out",
            endQuest = "177780108292048558304",
            endPort = "In"
          },
          {
            startQuest = "177780108291848558299",
            startPort = "QuestStart",
            endQuest = "177780108292048558306",
            endPort = "In"
          },
          {
            startQuest = "177780108292048558306",
            startPort = "Out",
            endQuest = "177780108292048558301",
            endPort = "Fail"
          },
          {
            startQuest = "177780108291848558299",
            startPort = "QuestStart",
            endQuest = "177780108292048558302",
            endPort = "In"
          }
        },
        nodeData = {
          ["177780108291848558299"] = {
            key = "177780108291848558299",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 220.35714285714278, y = 355.71428571428567},
            propsData = {ModeType = 0}
          },
          ["177780108291848558300"] = {
            key = "177780108291848558300",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["177780108292048558301"] = {
            key = "177780108292048558301",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1981.6477272727273, y = 1032.215909090909},
            propsData = {}
          },
          ["177780108292048558302"] = {
            key = "177780108292048558302",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1005.4135201509521, y = 370.69979243382176},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041601.10041601'",
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
          ["177780108292048558303"] = {
            key = "177780108292048558303",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1336.505508189129, y = 395.4153846153847},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_YWSEnd",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177780108292048558304"] = {
            key = "177780108292048558304",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1620.6302945139153, y = 390.36239316239306},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10041701.10041701'",
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
          ["177780108292048558305"] = {
            key = "177780108292048558305",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3316.127248267728, y = 663.9621664455254},
            propsData = {}
          },
          ["177780108292048558306"] = {
            key = "177780108292048558306",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 983.9129625534422, y = 829.3907378740969},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
