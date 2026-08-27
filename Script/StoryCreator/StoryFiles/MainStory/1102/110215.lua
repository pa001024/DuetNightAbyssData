return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104531328909",
      startPort = "StoryStart",
      endStory = "17697590104531328911",
      endPort = "In"
    },
    {
      startStory = "17697590104531328911",
      startPort = "Success",
      endStory = "17805854289914192",
      endPort = "In"
    },
    {
      startStory = "17805854289914192",
      startPort = "Success",
      endStory = "17697590104531328910",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17697590104531328909"] = {
      isStoryNode = true,
      key = "17697590104531328909",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 814, y = 322},
      propsData = {QuestChainId = 110215},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531328910"] = {
      isStoryNode = true,
      key = "17697590104531328910",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2133.72971983771, y = 353.6756751462436},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531328911"] = {
      isStoryNode = true,
      key = "17697590104531328911",
      type = "StoryNode",
      name = "去摩天轮看看",
      pos = {x = 1107.5503185827074, y = 173.76653549554513},
      propsData = {
        QuestId = 11021501,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110215_1",
        QuestDeatil = "Content_110215_1",
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
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestSign11021501",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17805847702361459",
            startPort = "Out",
            endQuest = "17805853516742655",
            endPort = "In"
          },
          {
            startQuest = "17805853313542344",
            startPort = "Out",
            endQuest = "17805847702361459",
            endPort = "In"
          },
          {
            startQuest = "17805853516742655",
            startPort = "Out",
            endQuest = "17697590104531328913",
            endPort = "Success"
          },
          {
            startQuest = "17697590104531328912",
            startPort = "QuestStart",
            endQuest = "17824611744934882591",
            endPort = "In"
          },
          {
            startQuest = "17824611744934882591",
            startPort = "Out",
            endQuest = "17805853313542344",
            endPort = "In"
          }
        },
        nodeData = {
          ["17697590104531328912"] = {
            key = "17697590104531328912",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 550.9833105781232, y = 219.55473340475754},
            propsData = {ModeType = 0}
          },
          ["17697590104531328913"] = {
            key = "17697590104531328913",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2238.2084944030607, y = 223.7142877161676},
            propsData = {ModeType = 0}
          },
          ["17697590104531328914"] = {
            key = "17697590104531328914",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17805847702361459"] = {
            key = "17805847702361459",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1578.3553393405384, y = 196.6838867472423},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 312780006,
              GuideType = "P",
              GuidePointName = "QuestSign11021501"
            }
          },
          ["17805853313542344"] = {
            key = "17805853313542344",
            type = "ChangeStaticCreatorNode",
            name = "生成睡着卡尔玛",
            pos = {x = 1188.429922532166, y = 191.25195422120942},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780004}
            }
          },
          ["17805853516742655"] = {
            key = "17805853516742655",
            type = "TalkNode",
            name = "开车对话-俯瞰镇子",
            pos = {x = 1864.8183385951013, y = 192.42391352197416},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 11110201,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = true,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["17824611744934882591"] = {
            key = "17824611744934882591",
            type = "SendMessageNode",
            name = "发送消息——重置摩天轮",
            pos = {x = 861.6305535817393, y = 207.84565078963757},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "WheelInit",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    },
    ["17805854289914192"] = {
      isStoryNode = true,
      key = "17805854289914192",
      type = "StoryNode",
      name = "请卡尔玛开启摩天轮",
      pos = {x = 1399.322965485081, y = 165.228416257015},
      propsData = {
        QuestId = 11021502,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110215_2",
        QuestDeatil = "Content_110215_2",
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
        SubRegionId = 107001,
        SubRegionIdList = {},
        StoryGuideType = "Npc",
        StoryGuidePointName = "Npc_Kaerma_312780004",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "178066652740913658434",
            startPort = "Out",
            endQuest = "178066657724413659282",
            endPort = "In"
          },
          {
            startQuest = "178066657724413659282",
            startPort = "Out",
            endQuest = "17807498761499115285",
            endPort = "In"
          },
          {
            startQuest = "17807498761499115285",
            startPort = "Success",
            endQuest = "17808875798821780",
            endPort = "In"
          },
          {
            startQuest = "17808875798821780",
            startPort = "Out",
            endQuest = "1780918893229570",
            endPort = "Input"
          },
          {
            startQuest = "1780918893229570",
            startPort = "Out",
            endQuest = "17805854289914196",
            endPort = "Success"
          },
          {
            startQuest = "17807498761499115285",
            startPort = "Fail",
            endQuest = "17809189449051021",
            endPort = "Input"
          },
          {
            startQuest = "17807498761499115285",
            startPort = "PassiveFail",
            endQuest = "17809189449051021",
            endPort = "Input"
          },
          {
            startQuest = "17809189449051021",
            startPort = "Out",
            endQuest = "17805854289914199",
            endPort = "Fail"
          },
          {
            startQuest = "17805854407754465",
            startPort = "Out",
            endQuest = "178066652740913658434",
            endPort = "In"
          },
          {
            startQuest = "17805854289914193",
            startPort = "QuestStart",
            endQuest = "17805854407754465",
            endPort = "In"
          },
          {
            startQuest = "17807498761499115285",
            startPort = "Success",
            endQuest = "178246730605811388679",
            endPort = "In"
          }
        },
        nodeData = {
          ["17805854289914193"] = {
            key = "17805854289914193",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 689.1891910932869, y = 318.91891859382906},
            propsData = {ModeType = 0}
          },
          ["17805854289914196"] = {
            key = "17805854289914196",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3391.353753005755, y = 390.519129128106},
            propsData = {ModeType = 0}
          },
          ["17805854289914199"] = {
            key = "17805854289914199",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3439.851060406474, y = 768.3121882512937},
            propsData = {}
          },
          ["17805854407754465"] = {
            key = "17805854407754465",
            type = "TalkNode",
            name = "对话节点-找卡尔玛站桩",
            pos = {x = 1154.1304575611898, y = 326.92299773102815},
            propsData = {
              IsNpcNode = true,
              NpcNodeInteractiveName = "",
              NpcId = 111182,
              GuideUIEnable = true,
              GuideType = "N",
              GuidePointName = "Npc_Kaerma_312780004",
              DelayShowGuideTime = 0,
              bUseFlowAssetActors = false,
              IsPlayerTurnToNPC = true,
              IsNPCTurnToPlayer = false,
              AllowSurroundDialogue = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110215/11021501.11021501'",
              TalkType = "FreeSimple",
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
              TalkActors = {
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111001,
                  TalkActorVisible = true
                },
                {
                  TalkActorType = "Npc",
                  TalkActorId = 111110,
                  TalkActorVisible = true
                }
              },
              OptionType = "normal",
              bLockHighestLOD = false,
              FreezeWorldComposition = false,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "EXPlayer",
              PlayerSwitchEmoIdle = true,
              NormalOptions = {},
              OverrideFailBlend = false
            }
          },
          ["178066652740913658434"] = {
            key = "178066652740913658434",
            type = "ChangeStaticCreatorNode",
            name = "销毁睡着卡尔玛",
            pos = {x = 1739.1846634299482, y = 315.03436719693536},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780004}
            }
          },
          ["178066657724413659282"] = {
            key = "178066657724413659282",
            type = "ChangeStaticCreatorNode",
            name = "生成站立卡尔玛",
            pos = {x = 2003.1665058417548, y = 344.7847913018324},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {312780014}
            }
          },
          ["17807498761499115285"] = {
            key = "17807498761499115285",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 2314.105618562817, y = 352.9781866572023},
            propsData = {SpecialConfigId = 11021502, BlackScreenImmediately = false}
          },
          ["17808875798821780"] = {
            key = "17808875798821780",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2649.4074063939925, y = 332.96296320541524},
            propsData = {
              VarName = "ex02_110215",
              VarValue = 1
            }
          },
          ["1780918893229570"] = {
            key = "1780918893229570",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2902.8060730622365, y = 396.81810638915374},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17809189449051021"] = {
            key = "17809189449051021",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 2886.5898571803987, y = 713.0343160849964},
            propsData = {
              TargetTime = 15,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false,
              RevertToDefaultWeather = false,
              ForceWeatherType = -1
            }
          },
          ["17824614695648135036"] = {
            key = "17824614695648135036",
            type = "SendMessageNode",
            name = "发送消息——启动摩天轮",
            pos = {x = 1673.0513082988118, y = 115.17841994743758},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "WheelStart",
              UnitId = -1
            }
          },
          ["178246730605811388679"] = {
            key = "178246730605811388679",
            type = "SendMessageNode",
            name = "发送消息——启动摩天轮",
            pos = {x = 2705.876997197973, y = 87.32334166632612},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "WheelStart",
              UnitId = -1
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
