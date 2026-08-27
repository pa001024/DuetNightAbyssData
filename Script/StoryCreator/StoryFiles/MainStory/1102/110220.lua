return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17832388876991",
      startPort = "StoryStart",
      endStory = "1783242804230380",
      endPort = "In"
    },
    {
      startStory = "1783242804230380",
      startPort = "Success",
      endStory = "17832442648255967551",
      endPort = "In"
    },
    {
      startStory = "17832442648255967551",
      startPort = "Success",
      endStory = "17832388876995",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17832388876991"] = {
      isStoryNode = true,
      key = "17832388876991",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 800, y = 300},
      propsData = {QuestChainId = 110220},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17832388876995"] = {
      isStoryNode = true,
      key = "17832388876995",
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
    ["1783242804230380"] = {
      isStoryNode = true,
      key = "1783242804230380",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1240, y = 280.5714285973789},
      propsData = {
        QuestId = 11022001,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110220_0",
        QuestDeatil = "Content_110220_0",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "QuestSign11023101_01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17832489860289225498",
            startPort = "Success",
            endQuest = "178325346055117369775",
            endPort = "Input"
          },
          {
            startQuest = "17832489860289225498",
            startPort = "Fail",
            endQuest = "178325347597517370293",
            endPort = "Input"
          },
          {
            startQuest = "17832489860289225498",
            startPort = "PassiveFail",
            endQuest = "178325347597517370293",
            endPort = "Input"
          },
          {
            startQuest = "178325347597517370293",
            startPort = "Out",
            endQuest = "178325072829112483421",
            endPort = "In"
          },
          {
            startQuest = "1783242804230381",
            startPort = "QuestStart",
            endQuest = "17835366141146045195",
            endPort = "In"
          },
          {
            startQuest = "17835366141146045195",
            startPort = "Out",
            endQuest = "17832485835247595676",
            endPort = "In"
          },
          {
            startQuest = "17835366141146045195",
            startPort = "Out",
            endQuest = "178325413261018999599",
            endPort = "In"
          },
          {
            startQuest = "17835381171339341161",
            startPort = "Out",
            endQuest = "17835381171339341162",
            endPort = "In"
          },
          {
            startQuest = "178325072829112483421",
            startPort = "Out",
            endQuest = "1783242804231397",
            endPort = "Fail"
          },
          {
            startQuest = "1783242804230381",
            startPort = "QuestStart",
            endQuest = "17858563195585007663",
            endPort = "In"
          },
          {
            startQuest = "178325346055117369775",
            startPort = "Out",
            endQuest = "17858564492398343510",
            endPort = "In"
          },
          {
            startQuest = "17858564492398343510",
            startPort = "Out",
            endQuest = "1783242804231389",
            endPort = "Success"
          },
          {
            startQuest = "17832485835247595676",
            startPort = "Out",
            endQuest = "17871092025396147500",
            endPort = "In"
          },
          {
            startQuest = "17871092025396147500",
            startPort = "Out",
            endQuest = "17832489860289225498",
            endPort = "In"
          }
        },
        nodeData = {
          ["1783242804230381"] = {
            key = "1783242804230381",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 98, y = 224},
            propsData = {ModeType = 0}
          },
          ["1783242804231389"] = {
            key = "1783242804231389",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3603.3704963524056, y = 363.18496981026226},
            propsData = {
              ModeType = 1,
              Id = 107501,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1783242804231397"] = {
            key = "1783242804231397",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3359.5741839752145, y = 821.9756667057962},
            propsData = {}
          },
          ["17832485835247595676"] = {
            key = "17832485835247595676",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 1109.3555096096316, y = 307.1736879863924},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780379}
            }
          },
          ["17832489602289224789"] = {
            key = "17832489602289224789",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1722.0491499781836, y = -17.631813851866525},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780380,
              GuideType = "N",
              GuidePointName = "Npc_Teleisha_312780379"
            }
          },
          ["17832489860289225498"] = {
            key = "17832489860289225498",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 2372.899957326691, y = 303.24168771437473},
            propsData = {SpecialConfigId = 11022001, BlackScreenImmediately = true}
          },
          ["178325072829112483421"] = {
            key = "178325072829112483421",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2900.0220204135308, y = 729.5257878912064},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              IsWhite = false
            }
          },
          ["178325346055117369775"] = {
            key = "178325346055117369775",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2807.2721542820373, y = 249.20151578675336},
            propsData = {
              TargetTime = 22,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178325347597517370293"] = {
            key = "178325347597517370293",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2636.2173950672877, y = 665.8061558087302},
            propsData = {
              TargetTime = 16,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["178325413261018999599"] = {
            key = "178325413261018999599",
            type = "ChangeStaticCreatorNode",
            name = "生成宴会NPC与桌椅",
            pos = {x = 931.9176944821571, y = -111.80244526637284},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {
                312780383,
                312780384,
                312780385,
                312780386,
                312780387,
                312780388,
                312780389,
                312780390,
                312780391,
                312780392,
                312780393,
                312780395,
                312780396,
                312780397
              }
            }
          },
          ["17835366141146045195"] = {
            key = "17835366141146045195",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 662, y = 302},
            propsData = {
              NewDescription = "Description_110220_1",
              NewDetail = "Content_110220_1",
              SubTaskTargetIndex = 0
            }
          },
          ["17835381171339341161"] = {
            key = "17835381171339341161",
            type = "ChangeStaticCreatorNode",
            name = "生成等待晚宴开始交互点",
            pos = {x = 1376.957501385738, y = -409.15086377305255},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780031}
            }
          },
          ["17835381171339341162"] = {
            key = "17835381171339341162",
            type = "PickUpNode",
            name = "拾取物品，进特殊任务",
            pos = {x = 1705.9959598594724, y = -392.2793809325864},
            propsData = {
              bActiveEnable = false,
              StaticCreatorIdList = {312780031},
              QuestPickupId = -1,
              UnitId = 11023101,
              UnitCount = 1,
              bGuideUIEnable = true,
              GuideType = "P",
              GuidePointName = "QuestSign11023101_01",
              IsUseCount = false
            }
          },
          ["17858563195585007663"] = {
            key = "17858563195585007663",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 680, y = 662},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JhsTPActive_11022001",
              UnitId = -1
            }
          },
          ["17858564492398343510"] = {
            key = "17858564492398343510",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 3126, y = 292},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "JhsTPActive_11022001",
              UnitId = -1
            }
          },
          ["17871092025396147500"] = {
            key = "17871092025396147500",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1641.4743868263408, y = 307.81881506321736},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780821,
              GuideType = "P",
              GuidePointName = "QuestSign11023101_01"
            }
          }
        },
        commentData = {}
      }
    },
    ["17832442648255967551"] = {
      isStoryNode = true,
      key = "17832442648255967551",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1880, y = 304},
      propsData = {
        QuestId = 11022002,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110220_4",
        QuestDeatil = "Content_110220_4",
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
        SubRegionId = 107501,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11022002",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17832442648255967556",
            startPort = "QuestStart",
            endQuest = "178325887374323890681",
            endPort = "In"
          },
          {
            startQuest = "178325887374323890681",
            startPort = "Out",
            endQuest = "178747473039020181440",
            endPort = "In"
          },
          {
            startQuest = "178747473039020181440",
            startPort = "Out",
            endQuest = "17832442648255967557",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17832442648255967556"] = {
            key = "17832442648255967556",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17832442648255967557"] = {
            key = "17832442648255967557",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17832442648255967558"] = {
            key = "17832442648255967558",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178325887374323890681"] = {
            key = "178325887374323890681",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1600, y = 372},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110203/11020306.11020306'",
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
          ["178747473039020181440"] = {
            key = "178747473039020181440",
            type = "OpenSytstemUINode",
            name = "打开界面节点",
            pos = {x = 2092, y = 410},
            propsData = {
              IsAsync = false,
              UIName = "StringBoardMain",
              IsInterfaceJump = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
