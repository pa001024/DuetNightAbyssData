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
      pos = {x = 1280.4742813863106, y = 330.7330686384505},
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
        SubRegionId = 0,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "177772041576114019398",
            startPort = "Out",
            endQuest = "177772041576114019397",
            endPort = "In"
          },
          {
            startQuest = "177772131390820562141",
            startPort = "false",
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
            endQuest = "177772143498720565847",
            endPort = "Input"
          },
          {
            startQuest = "177772041576114019392",
            startPort = "QuestStart",
            endQuest = "177772142900320565680",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019395",
            startPort = "Out",
            endQuest = "17791991573273865468",
            endPort = "In"
          },
          {
            startQuest = "17791991573273865468",
            startPort = "Out",
            endQuest = "177772041576114019396",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019395",
            startPort = "Out",
            endQuest = "17791992171914830701",
            endPort = "In"
          },
          {
            startQuest = "177772142900320565680",
            startPort = "Out",
            endQuest = "177772131390820562141",
            endPort = "In"
          },
          {
            startQuest = "17791578296201745",
            startPort = "Out",
            endQuest = "177772041576114019398",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019397",
            startPort = "Out",
            endQuest = "17792012485157728844",
            endPort = "In"
          },
          {
            startQuest = "17792012485157728844",
            startPort = "Out",
            endQuest = "177772041576114019395",
            endPort = "In"
          },
          {
            startQuest = "177772041576114019396",
            startPort = "Out",
            endQuest = "177772041576114019393",
            endPort = "Success"
          },
          {
            startQuest = "177772041576114019397",
            startPort = "Out",
            endQuest = "177969792015337745366",
            endPort = "In"
          },
          {
            startQuest = "17791991573273865468",
            startPort = "Out",
            endQuest = "17797190308532425181",
            endPort = "In"
          },
          {
            startQuest = "177772131390820562141",
            startPort = "true",
            endQuest = "17798724048563879013",
            endPort = "In"
          },
          {
            startQuest = "17798724048563879013",
            startPort = "Out",
            endQuest = "17791578296201745",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772041576114019392"] = {
            key = "177772041576114019392",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -895.0962904671344, y = 340.8816893535564},
            propsData = {ModeType = 0}
          },
          ["177772041576114019393"] = {
            key = "177772041576114019393",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2510.3759542534494, y = 423.66761731915994},
            propsData = {ModeType = 0}
          },
          ["177772041576114019394"] = {
            key = "177772041576114019394",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 783.9230769230769, y = 815.1538461538462},
            propsData = {}
          },
          ["177772041576114019395"] = {
            key = "177772041576114019395",
            type = "TalkNode",
            name = "芙罗拉交涉",
            pos = {x = 1181.8028491545733, y = 372.76828893380616},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048301.10048301'",
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
            pos = {x = 1903.595006366631, y = 457.06255460786355},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10048401.10048401'",
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
          ["177772041576114019397"] = {
            key = "177772041576114019397",
            type = "GoToNode",
            name = "前往交涉地点",
            pos = {x = 853.7527706211915, y = 394.7317543567543},
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
            pos = {x = 630.148717948718, y = 407.68717948717955},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640027}
            }
          },
          ["177772131390820562141"] = {
            key = "177772131390820562141",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 36.914493591839005, y = 246.5144717982247},
            propsData = {
              FunctionName = "Equal",
              VarName = "StateHaluo100405",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "0"}
              }
            }
          },
          ["177772135543720563269"] = {
            key = "177772135543720563269",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 190.75172882037842, y = 828.379020293208},
            propsData = {}
          },
          ["177772142900320565680"] = {
            key = "177772142900320565680",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = -177.03012967200652, y = 381.35376484690016},
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
          },
          ["17791578296201745"] = {
            key = "17791578296201745",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 668.0774860263352, y = 83.29061134943504},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_TrailnPaotaiStart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["17791991573273865468"] = {
            key = "17791991573273865468",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1445.020254927914, y = 443.5373364240643},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272640150,
              GuideType = "M",
              GuidePointName = "Mechanism_HaluoTalkStart_272640150"
            }
          },
          ["17791992171914830701"] = {
            key = "17791992171914830701",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 1815.4048703125295, y = 213.24887488560267},
            propsData = {
              NewDescription = "Content_10040501_04",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["17792012485157728844"] = {
            key = "17792012485157728844",
            type = "ChangeStaticCreatorNode",
            name = "删除芙罗拉",
            pos = {x = 1022.925407925408, y = 548.6317016317016},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = true,
              EnableFadeIn = true,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {272640027}
            }
          },
          ["177969792015337745366"] = {
            key = "177969792015337745366",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1077.9783834586465, y = 162.59022556390968},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["17797190308532425181"] = {
            key = "17797190308532425181",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 1856.9478823871273, y = 647.4813286002073},
            propsData = {
              VarName = "StateHaluo100405",
              VarValue = 1
            }
          },
          ["17798724048563879013"] = {
            key = "17798724048563879013",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 274, y = 108},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt01/0008_combat_zhuizhuzhan.0008_combat_zhuizhuzhan'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
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
      pos = {x = 1540.429982526105, y = 335.5911667504056},
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
        SubRegionId = 0,
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
          },
          {
            startQuest = "177772136557720563620",
            startPort = "true",
            endQuest = "177772041576814019431",
            endPort = "In"
          },
          {
            startQuest = "177772041576814019427",
            startPort = "QuestStart",
            endQuest = "17791581295551933173",
            endPort = "In"
          },
          {
            startQuest = "17791581295551933173",
            startPort = "Out",
            endQuest = "177941885944177362854",
            endPort = "In"
          },
          {
            startQuest = "177772136557720563620",
            startPort = "true",
            endQuest = "1779520994099968656",
            endPort = "In"
          },
          {
            startQuest = "177772041576814019432",
            startPort = "Out",
            endQuest = "1779521025845968872",
            endPort = "In"
          },
          {
            startQuest = "1779521025845968872",
            startPort = "Out",
            endQuest = "177772136557720563621",
            endPort = "In"
          },
          {
            startQuest = "17791581295551933173",
            startPort = "Out",
            endQuest = "177970890816373095250",
            endPort = "In"
          },
          {
            startQuest = "17791581295551933173",
            startPort = "Out",
            endQuest = "177772136557720563620",
            endPort = "In"
          }
        },
        nodeData = {
          ["177772041576814019427"] = {
            key = "177772041576814019427",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -506.00061425061426, y = 311.75245700245705},
            propsData = {ModeType = 0}
          },
          ["177772041576814019428"] = {
            key = "177772041576814019428",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2274.4570707070707, y = 354.8124098124098},
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
            pos = {x = 1077.9904306220096, y = 56.21907040328087},
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
            pos = {x = 830.8237925816873, y = -110.68108616529672},
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
            pos = {x = 220.0650462237985, y = 258.3214195225065},
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
            pos = {x = 72.58029927738164, y = 771.4385125743822},
            propsData = {}
          },
          ["177884063404555063216"] = {
            key = "177884063404555063216",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1976.2500000000002, y = 183.5},
            propsData = {WaitTime = 2}
          },
          ["17791581295551933173"] = {
            key = "17791581295551933173",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -141.52340337008542, y = 263.610374751107},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZhujueBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177941885944177362854"] = {
            key = "177941885944177362854",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 415.22727272727275, y = -29.090909090909093},
            propsData = {
              NewDescription = "Content_10040503_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["1779520994099968656"] = {
            key = "1779520994099968656",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 537.9398496240603, y = 449.4924812030075},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/1_4/0168_boss_haluoji.0168_boss_haluoji'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["1779521025845968872"] = {
            key = "1779521025845968872",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1582.169172932331, y = 85.3759398496241},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["177970890816373095250"] = {
            key = "177970890816373095250",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 150.51945080091537, y = -147.771167048055},
            propsData = {QuestRoleId = 11020201, IsPlayFX = false}
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
      pos = {x = 1812.2991104265545, y = 360.3780424726606},
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
          },
          {
            startQuest = "177772041577114019459",
            startPort = "Out",
            endQuest = "17789175392281043",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019461",
            startPort = "Out",
            endQuest = "17791867421937743680",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019461",
            startPort = "Out",
            endQuest = "177969823322739680149",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019459",
            startPort = "Out",
            endQuest = "177969825553939680354",
            endPort = "In"
          },
          {
            startQuest = "177772041577114019462",
            startPort = "Out",
            endQuest = "177969828211040647726",
            endPort = "In"
          },
          {
            startQuest = "177969828211040647726",
            startPort = "Out",
            endQuest = "177772041577114019460",
            endPort = "In"
          },
          {
            startQuest = "177969825553939680354",
            startPort = "Out",
            endQuest = "177772041577114019462",
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
              PauseGameGlobal = false,
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
            pos = {x = 2127.393772428579, y = 333.8107128672544},
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
            pos = {x = 950.6679796903938, y = 314.4307591290351},
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
            pos = {x = 1572.5694264201097, y = 317.72781139539455},
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
          },
          ["17789175392281043"] = {
            key = "17789175392281043",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 1455.34073666608, y = 161.37399665551828},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FeitingDownEnd",
              UnitId = -1
            }
          },
          ["17791867421937743680"] = {
            key = "17791867421937743680",
            type = "SendMessageNode",
            name = "发送消息",
            pos = {x = 864.4608294930874, y = -6.89554531490019},
            propsData = {
              MessageType = "GameMode",
              MessageContent = "FeitingDownStart",
              UnitId = -1
            }
          },
          ["177969823322739680149"] = {
            key = "177969823322739680149",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1157.706416885322, y = 135.67402376910013},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/mute.mute'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          },
          ["177969825553939680354"] = {
            key = "177969825553939680354",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1427.228997530483, y = 526.7578947368422},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["177969828211040647726"] = {
            key = "177969828211040647726",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1789.82254591758, y = 325.5449915110356},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "FMODEvent'/Game/Asset/Audio/FMOD/Events/bgm/cbt03/0080_story_the_abandoned_theme.0080_story_the_abandoned_theme'",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {},
              ClientRelatedRegionId = {106101},
              bStoreToServer = false
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
