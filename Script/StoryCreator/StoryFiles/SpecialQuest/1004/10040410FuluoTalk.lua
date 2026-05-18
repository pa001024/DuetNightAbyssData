return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177874634642118498986",
      startPort = "StoryStart",
      endStory = "177874635019518499085",
      endPort = "In"
    },
    {
      startStory = "177874635019518499085",
      startPort = "Success",
      endStory = "177874634642118498989",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177874634642118498986"] = {
      isStoryNode = true,
      key = "177874634642118498986",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 912.1052631578948, y = 225.78947368421052},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874634642118498989"] = {
      isStoryNode = true,
      key = "177874634642118498989",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1595.2631578947367, y = 241.57894736842104},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177874635019518499085"] = {
      isStoryNode = true,
      key = "177874635019518499085",
      type = "StoryNode",
      name = "与芙罗拉交谈",
      pos = {x = 1237.4736842105262, y = 237.78947368421052},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040410_01",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177874635019518499093",
            startPort = "Out",
            endQuest = "177874635019518499094",
            endPort = "In"
          },
          {
            startQuest = "177874635019518499090",
            startPort = "QuestStart",
            endQuest = "177874635019518499095",
            endPort = "In"
          },
          {
            startQuest = "177874635019518499090",
            startPort = "QuestStart",
            endQuest = "177874641059118499697",
            endPort = "In"
          },
          {
            startQuest = "177874635019518499094",
            startPort = "Out",
            endQuest = "177874655649418500076",
            endPort = "In"
          },
          {
            startQuest = "177874635019518499090",
            startPort = "QuestStart",
            endQuest = "177874656795018500356",
            endPort = "In"
          },
          {
            startQuest = "177874656795018500356",
            startPort = "Out",
            endQuest = "177874635019518499092",
            endPort = "Fail"
          },
          {
            startQuest = "177874635019518499090",
            startPort = "QuestStart",
            endQuest = "177875474867534094669",
            endPort = "In"
          },
          {
            startQuest = "177875474867534094669",
            startPort = "true",
            endQuest = "177875477269034095019",
            endPort = "In"
          },
          {
            startQuest = "177875477269034095019",
            startPort = "Out",
            endQuest = "177874635019518499093",
            endPort = "In"
          },
          {
            startQuest = "177875474867534094669",
            startPort = "false",
            endQuest = "177875467101134094297",
            endPort = "In"
          },
          {
            startQuest = "177875467101134094297",
            startPort = "Out",
            endQuest = "177874635019518499093",
            endPort = "In"
          }
        },
        nodeData = {
          ["177874635019518499090"] = {
            key = "177874635019518499090",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 810.9758454106282, y = 298.71497584541066},
            propsData = {ModeType = 0}
          },
          ["177874635019518499091"] = {
            key = "177874635019518499091",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2774.5336306205872, y = 292.62913415087326},
            propsData = {ModeType = 0}
          },
          ["177874635019518499092"] = {
            key = "177874635019518499092",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1897.2727272727273, y = 709.5454545454546},
            propsData = {}
          },
          ["177874635019518499093"] = {
            key = "177874635019518499093",
            type = "ChangeStaticCreatorNode",
            name = "生成芙罗拉",
            pos = {x = 1869.231884057971, y = 335.01562944018195},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640019}
            }
          },
          ["177874635019518499094"] = {
            key = "177874635019518499094",
            type = "TalkNode",
            name = "与芙罗拉交谈",
            pos = {x = 2170.8713795440135, y = 312.1133079764793},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 100404,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Fuluo_272640019",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10046401.10046401'",
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
          ["177874635019518499095"] = {
            key = "177874635019518499095",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 887.2525252525252, y = 749.1212121212122},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "OpenGate02Front",
              UnitId = -1
            }
          },
          ["177874641059118499697"] = {
            key = "177874641059118499697",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 1469.1314935064934, y = 101.93668831168836},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177874655649418500076"] = {
            key = "177874655649418500076",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2489.5199938949936, y = 293.4868048618049},
            propsData = {}
          },
          ["177874656795018500356"] = {
            key = "177874656795018500356",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1495.59613997114, y = 742.1387085137086},
            propsData = {}
          },
          ["177875467101134094297"] = {
            key = "177875467101134094297",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "将玩家设置在车尾车厢",
            pos = {x = 1506.9015382659552, y = 543.6983854563946},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ShidifenRE",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177875474867534094669"] = {
            key = "177875474867534094669",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 1188.012649377066, y = 352.5872743452833},
            propsData = {
              FunctionName = "Equal",
              VarName = "First10040410FuluoTalk",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177875477269034095019"] = {
            key = "177875477269034095019",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1502.756239120656, y = 326.0488128068219},
            propsData = {
              VarName = "First10040410FuluoTalk",
              VarValue = 1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
