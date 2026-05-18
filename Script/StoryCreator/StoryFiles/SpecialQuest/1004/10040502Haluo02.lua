return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177772041575914019375",
      startPort = "Success",
      endStory = "177772041575914019376",
      endPort = "In"
    },
    {
      startStory = "177772041575914019376",
      startPort = "Success",
      endStory = "177772041575914019377",
      endPort = "In"
    },
    {
      startStory = "177772040782114019343",
      startPort = "StoryStart",
      endStory = "177772041575914019375",
      endPort = "In"
    },
    {
      startStory = "177772041575914019377",
      startPort = "Success",
      endStory = "177772040782114019346",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177772040782114019343"] = {
      isStoryNode = true,
      key = "177772040782114019343",
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
    ["177772040782114019346"] = {
      isStoryNode = true,
      key = "177772040782114019346",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2106.6666666666665, y = 366.6666666666667},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177772041575914019375"] = {
      isStoryNode = true,
      key = "177772041575914019375",
      type = "StoryNode",
      name = "芙罗拉交涉 ",
      pos = {x = 1281.7242813863106, y = 330.7330686384505},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040501_03",
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772041576114019395",
            startPort = "Out",
            endQuest = "177772041576114019396",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019397",
            startPort = "Out",
            endQuest = "177772041576114019395",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019398",
            startPort = "Out",
            endQuest = "177772041576114019397",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019396",
            startPort = "Out",
            endQuest = "177772041576114019399",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019392",
            startPort = "QuestStart",
            endQuest = "177772131390820562141",
            endPort = "In"
          },
          {
            startQuest = "177772131390820562141",
            startPort = "true",
            endQuest = "177772041576114019398",
            endPort = "In"
          },
          {
            startQuest = "177772131390820562141",
            startPort = "false",
            endQuest = "177772041576114019393",
            endPort = "Success"
          },
          {
            startQuest = "177772041576114019399",
            startPort = "Out",
            endQuest = "177772131708420562199",
            endPort = "In"
          },
          {
            startQuest = "177772131708420562199",
            startPort = "Out",
            endQuest = "177772041576114019393",
            endPort = "Success"
          },
          {
            startQuest = "177772041576114019392",
            startPort = "QuestStart",
            endQuest = "177772135543720563269",
            endPort = "In"
          },
          {
            startQuest = "177772135543720563269",
            startPort = "Out",
            endQuest = "177772041576114019394",
            endPort = "Fail"
          },
          {
            startQuest = "177772041576114019392",
            startPort = "QuestStart",
            endQuest = "177772142900320565680",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019392",
            startPort = "QuestStart",
            endQuest = "177772143498720565847",
            endPort = "Input"
          }
        },
        nodeData = {
          ["177772041576114019392"] = {
            key = "177772041576114019392",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -4.734299516908237, y = 303.076259489303},
            propsData = {ModeType = 0}
          },
          ["177772041576114019393"] = {
            key = "177772041576114019393",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1690.3007662835248, y = -2.4827586206896513},
            propsData = {ModeType = 0}
          },
          ["177772041576114019394"] = {
            key = "177772041576114019394",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 792, y = 784},
            propsData = {}
          },
          ["177772041576114019395"] = {
            key = "177772041576114019395",
            type = "TalkNode",
            name = "芙罗拉交涉",
            pos = {x = 1170.3777877295117, y = 328.9845051500224},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048301.10048301'",
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
          ["177772041576114019396"] = {
            key = "177772041576114019396",
            type = "TalkNode",
            name = "卡嘉逃脱",
            pos = {x = 1500.0623376623375, y = 322.1},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048401.10048401'",
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
              EndNewTargetPointName = "BP_ZhujueBattle",
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
          ["177772041576114019397"] = {
            key = "177772041576114019397",
            type = "GoToNode",
            name = "前往交涉地点",
            pos = {x = 847.4590643274853, y = 313.7876984126984},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640028,
              GuideType = "M",
              GuidePointName = "Mechanism_FuluoJiaoshe_272640028"
            }
          },
          ["177772041576114019398"] = {
            key = "177772041576114019398",
            type = "ChangeStaticCreatorNode",
            name = "生成芙罗拉",
            pos = {x = 594.0333333333333, y = 307.8794871794872},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640027}
            }
          },
          ["177772041576114019399"] = {
            key = "177772041576114019399",
            type = "ChangeStaticCreatorNode",
            name = "删除芙罗拉",
            pos = {x = 1798.1999999999998, y = 345.9350427350428},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = false,
              EnableFadeOut = true,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640027}
            }
          },
          ["177772131390820562141"] = {
            key = "177772131390820562141",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 300.2221858995313, y = 313.322164105917},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateHaluo100405",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177772131708420562199"] = {
            key = "177772131708420562199",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2055.2946496676477, y = 282.52506265664164},
            propsData = {
              VarName = "StateHaluo100405",
              VarValue = 1
            }
          },
          ["177772135543720563269"] = {
            key = "177772135543720563269",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 330.36711343576303, y = 669.1482510624388},
            propsData = {}
          },
          ["177772142900320565680"] = {
            key = "177772142900320565680",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 361.4698703279935, y = 111.35376484690015},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177772143498720565847"] = {
            key = "177772143498720565847",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = 384.32701318513637, y = -168.6462351530999},
            propsData = {
              TargetTime = 13,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          }
        },
        commentData = {}
      }
    },
    ["177772041575914019376"] = {
      isStoryNode = true,
      key = "177772041575914019376",
      type = "StoryNode",
      name = "再战哈洛吉",
      pos = {x = 1542.7514110975337, y = 336.66259532183415},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040503_01",
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772041576814019431",
            startPort = "Out",
            endQuest = "177772041576814019432",
            endPort = "In"
          },
          {
            startQuest = "177772041576814019432",
            startPort = "Out",
            endQuest = "177772136557720563621",
            endPort = "In"
          },
          {
            startQuest = "177772041576814019427",
            startPort = "QuestStart",
            endQuest = "177772136557720563620",
            endPort = "In"
          },
          {
            startQuest = "177772136557720563620",
            startPort = "true",
            endQuest = "177772041576814019431",
            endPort = "In"
          },
          {
            startQuest = "177772136557720563620",
            startPort = "true",
            endQuest = "177772041576814019434",
            endPort = "In"
          },
          {
            startQuest = "177772136557720563620",
            startPort = "true",
            endQuest = "177772041576814019430",
            endPort = "In"
          },
          {
            startQuest = "177772136557720563620",
            startPort = "false",
            endQuest = "177772041576814019428",
            endPort = "Success"
          },
          {
            startQuest = "177772041576814019427",
            startPort = "QuestStart",
            endQuest = "177772139961620564815",
            endPort = "In"
          },
          {
            startQuest = "177772139961620564815",
            startPort = "Out",
            endQuest = "177772041576814019429",
            endPort = "Fail"
          },
          {
            startQuest = "177772136557720563621",
            startPort = "Out",
            endQuest = "177884063404555063216",
            endPort = "In"
          },
          {
            startQuest = "177884063404555063216",
            startPort = "Out",
            endQuest = "177772041576814019428",
            endPort = "Success"
          }
        },
        nodeData = {
          ["177772041576814019427"] = {
            key = "177772041576814019427",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 413.81756756756755, y = 298.47972972972974},
            propsData = {ModeType = 0}
          },
          ["177772041576814019428"] = {
            key = "177772041576814019428",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2192.6388888888887, y = 297.53968253968253},
            propsData = {ModeType = 0}
          },
          ["177772041576814019429"] = {
            key = "177772041576814019429",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1453.75, y = 696.25},
            propsData = {}
          },
          ["177772041576814019430"] = {
            key = "177772041576814019430",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1065, y = 520.2142857142857},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = false,
              IsSync = false,
              StaticCreatorIdList = {272640056}
            }
          },
          ["177772041576814019431"] = {
            key = "177772041576814019431",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1079.8398169336383, y = 239.6678021635115},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "ZZZBoss2ndStart",
              UnitId = -1
            }
          },
          ["177772041576814019432"] = {
            key = "177772041576814019432",
            type = "BossBattleFinishNode",
            name = "完成BOSS战阶段",
            pos = {x = 1401.6975244435198, y = 229.75673496983563},
            propsData = {
              SendMessage = "",
              FinishCondition = "ZZZBoss2ndSuccess"
            }
          },
          ["177772041576814019434"] = {
            key = "177772041576814019434",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1051.7328834907782, y = -2.9538134380239818},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "TrainPaotaiDelete",
              UnitId = -1
            }
          },
          ["177772136557720563620"] = {
            key = "177772136557720563620",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 741.2109792381527, y = 347.1675733686604},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateHaluo100405",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["177772136557720563621"] = {
            key = "177772136557720563621",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1716.2834430062694, y = 205.74547191938495},
            propsData = {
              VarName = "StateHaluo100405",
              VarValue = 2
            }
          },
          ["177772139961620564815"] = {
            key = "177772139961620564815",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 895.6237775382513, y = 725.7863386613387},
            propsData = {}
          },
          ["177884063404555063216"] = {
            key = "177884063404555063216",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1976.2500000000002, y = 183.5},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    },
    ["177772041575914019377"] = {
      isStoryNode = true,
      key = "177772041575914019377",
      type = "StoryNode",
      name = "卡嘉击坠飞艇",
      pos = {x = 1810.7201630581335, y = 360.3780424726606},
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
        SubRegionId = 106101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772041577014019456",
            startPort = "QuestStart",
            endQuest = "177772041577114019461",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019461",
            startPort = "Out",
            endQuest = "177772041577114019459",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019459",
            startPort = "Out",
            endQuest = "177772041577114019462",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019462",
            startPort = "Out",
            endQuest = "177772041577114019460",
            endPort = "In"
          },
          {
            startQuest = "177772041577014019456",
            startPort = "QuestStart",
            endQuest = "177772141156820565129",
            endPort = "In"
          },
          {
            startQuest = "177772141156820565129",
            startPort = "Out",
            endQuest = "177772041577114019458",
            endPort = "Fail"
          },
          {
            startQuest = "177772041577114019460",
            startPort = "Out",
            endQuest = "177772141990320565415",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772041577014019456"] = {
            key = "177772041577014019456",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 545.7142857142858, y = 345.71428571428567},
            propsData = {ModeType = 0}
          },
          ["177772041577114019457"] = {
            key = "177772041577114019457",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2360.9655269466307, y = 335.00587167716446},
            propsData = {ModeType = 0}
          },
          ["177772041577114019458"] = {
            key = "177772041577114019458",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2078.421052631579, y = 700},
            propsData = {}
          },
          ["177772041577114019459"] = {
            key = "177772041577114019459",
            type = "TalkNode",
            name = "过场-飞艇坠落",
            pos = {x = 1190.612953221766, y = 318.91774376738874},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0104/Ver0104_SC019/SQ_Ver0104_SC019",
              BlendInTime = 0,
              BlendOutTime = 0,
              InType = "FadeIn",
              OutType = "FadeOut",
              ShowFadeDetail = false,
              ShowSkipButton = true,
              ShowReviewButton = true,
              ShowWikiButton = true,
              PauseGameGlobal = true,
              HideNpcs = true,
              HideMonsters = true,
              HideAllBattleEntity = true,
              HideEffectCreature = true,
              HideMechanismsFX = false,
              DisableNpcOptimization = false,
              DoNotReceiveCharacterShadow = false,
              PauseTimeElapse = false,
              BeginNewTargetPointName = "",
              EndNewTargetPointName = "",
              CameraLookAtTartgetPoint = "",
              RestoreStand = false,
              TalkActors = {
                {
                  TalkActorType = "Player",
                  TalkActorId = 0,
                  TalkActorVisible = false
                }
              },
              bLockHighestLOD = false,
              FreezeWorldComposition = true,
              bTravelFullLoadWorldComposition = false,
              SwitchToMaster = "None",
              OverrideFailBlend = false
            }
          },
          ["177772041577114019460"] = {
            key = "177772041577114019460",
            type = "TalkNode",
            name = "卡嘉击坠飞艇后 ",
            pos = {x = 1694.6969982350304, y = 362.38214143868294},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048601.10048601'",
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
          ["177772041577114019461"] = {
            key = "177772041577114019461",
            type = "TalkNode",
            name = "击败哈洛吉",
            pos = {x = 948.2679796903939, y = 314.4307591290351},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048501.10048501'",
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
          ["177772041577114019462"] = {
            key = "177772041577114019462",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1450.123272573956, y = 308.2662729338561},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ForCamera",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177772141156820565129"] = {
            key = "177772141156820565129",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 1466.3157894736842, y = 669.2631578947368},
            propsData = {}
          },
          ["177772141990320565415"] = {
            key = "177772141990320565415",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2371.0526315789475, y = 203.4736842105262},
            propsData = {}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
