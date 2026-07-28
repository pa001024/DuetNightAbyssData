return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17724342457474749946",
      startPort = "StoryStart",
      endStory = "17724342599234750406",
      endPort = "In"
    },
    {
      startStory = "17724342599234750406",
      startPort = "Success",
      endStory = "17724342457474749949",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17724342457474749946"] = {
      isStoryNode = true,
      key = "17724342457474749946",
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
    ["17724342457474749949"] = {
      isStoryNode = true,
      key = "17724342457474749949",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1401.8636363636365, y = 296.54545454545456},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17724342599234750406"] = {
      isStoryNode = true,
      key = "17724342599234750406",
      type = "StoryNode",
      name = "任务节点",
      pos = {x = 1123.3748198093467, y = 271.14938967681957},
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
        IsFairyLand = true,
        SubRegionId = 105901,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "",
        JumpId = 0,
        IsBacktrack = false,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17724344680625541497",
            startPort = "Out",
            endQuest = "17724344680625541498",
            endPort = "In"
          },
          {
            startQuest = "17724342599234750407",
            startPort = "QuestStart",
            endQuest = "17724345157565542573",
            endPort = "In"
          },
          {
            startQuest = "17724345157565542573",
            startPort = "Out",
            endQuest = "17724342599234750413",
            endPort = "Fail"
          },
          {
            startQuest = "17724342599234750407",
            startPort = "QuestStart",
            endQuest = "177243571895212661688",
            endPort = "In"
          },
          {
            startQuest = "177243571895212661688",
            startPort = "Out",
            endQuest = "17724345355635542958",
            endPort = "In"
          },
          {
            startQuest = "177243571895212661688",
            startPort = "Out",
            endQuest = "17724344680625541497",
            endPort = "In"
          },
          {
            startQuest = "177243571895212661688",
            startPort = "Out",
            endQuest = "17727066414131488",
            endPort = "In"
          },
          {
            startQuest = "17727067132822627",
            startPort = "Out",
            endQuest = "17727067132822628",
            endPort = "In"
          },
          {
            startQuest = "17724344680625541498",
            startPort = "Out",
            endQuest = "17727067717123772",
            endPort = "In"
          },
          {
            startQuest = "17727067717123772",
            startPort = "Out",
            endQuest = "17727067132822627",
            endPort = "In"
          },
          {
            startQuest = "17727067717123772",
            startPort = "Out",
            endQuest = "17727066748822141",
            endPort = "In"
          },
          {
            startQuest = "17724345355635542958",
            startPort = "Out",
            endQuest = "177243576210813454455",
            endPort = "In"
          },
          {
            startQuest = "1772518991877563",
            startPort = "Out",
            endQuest = "17743492683362471",
            endPort = "Input"
          },
          {
            startQuest = "177243571895212661688",
            startPort = "Out",
            endQuest = "1774423736524482",
            endPort = "In"
          },
          {
            startQuest = "17727067132822628",
            startPort = "Out",
            endQuest = "1772518991877563",
            endPort = "In"
          },
          {
            startQuest = "1774423867834877113",
            startPort = "Out",
            endQuest = "17724344171765541343",
            endPort = "In"
          },
          {
            startQuest = "17743492683362471",
            startPort = "Out",
            endQuest = "1777361675226928666",
            endPort = "In"
          },
          {
            startQuest = "17743492683362471",
            startPort = "Out",
            endQuest = "17773617782671855344",
            endPort = "In"
          },
          {
            startQuest = "177243576210813454455",
            startPort = "Out",
            endQuest = "17780592214301772",
            endPort = "In"
          },
          {
            startQuest = "17780592214301772",
            startPort = "Out",
            endQuest = "1777360782359998",
            endPort = "In"
          },
          {
            startQuest = "17780592214301772",
            startPort = "Out",
            endQuest = "17773610334681729",
            endPort = "In"
          },
          {
            startQuest = "1777361675226928666",
            startPort = "Out",
            endQuest = "1774423867834877113",
            endPort = "In"
          }
        },
        nodeData = {
          ["17724342599234750407"] = {
            key = "17724342599234750407",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 522.9043478260869, y = 292.8},
            propsData = {
              ModeType = 1,
              Id = 105901,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17724342599234750410"] = {
            key = "17724342599234750410",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2434.9230769230767, y = 487.76923076923083},
            propsData = {ModeType = 0}
          },
          ["17724342599234750413"] = {
            key = "17724342599234750413",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1202.0064837711018, y = 771.0484043692439},
            propsData = {}
          },
          ["17724344171765541343"] = {
            key = "17724344171765541343",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 3684.395294700762, y = 286.05795811115684},
            propsData = {}
          },
          ["17724344680625541497"] = {
            key = "17724344680625541497",
            type = "BossBattleFinishNode",
            name = "BOSS战开始",
            pos = {x = 1159.4670541873907, y = 269.71022742394393},
            propsData = {
              SendMessage = "BossBattle01",
              FinishCondition = ""
            }
          },
          ["17724344680625541498"] = {
            key = "17724344680625541498",
            type = "BossBattleFinishNode",
            name = "BOSS战成功",
            pos = {x = 1440.3954599947403, y = 273.9579804875772},
            propsData = {
              SendMessage = "",
              FinishCondition = "BossJuque_StoryEnd"
            }
          },
          ["17724345157565542573"] = {
            key = "17724345157565542573",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 845.4188092641988, y = 770.6474133063338},
            propsData = {}
          },
          ["17724345355635542958"] = {
            key = "17724345355635542958",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1161.997629244818, y = 76.38042429834023},
            propsData = {
              IsNpcNode = false,
              FirstDialogueId = 12063315,
              FlowAssetPath = "",
              TalkType = "Guide",
              bIsStandalone = false,
              GuideMeshIndexList = {},
              IsPlayStartSound = false,
              GuideTalkStyle = "Normal",
              OverrideFailBlend = false
            }
          },
          ["177243563093111868600"] = {
            key = "177243563093111868600",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 2401.7445917192917, y = -35.23369905956123},
            propsData = {QuestRoleId = 0, IsPlayFX = false}
          },
          ["177243571895212661688"] = {
            key = "177243571895212661688",
            type = "ChangeRoleNode",
            name = "切换主角",
            pos = {x = 842.0334033613441, y = 292.9569327731091},
            propsData = {QuestRoleId = 16010103, IsPlayFX = false}
          },
          ["177243576210813454455"] = {
            key = "177243576210813454455",
            type = "CreatePhantomNode",
            name = "召唤/销毁剧情魅影",
            pos = {x = 1440.3443445940243, y = 92.55886779460923},
            propsData = {
              IsCreate = true,
              IsClearOtherPhantom = true,
              IsSync = false,
              StaticCreatorIdList = {132700009, 132700010}
            }
          },
          ["1772518991877563"] = {
            key = "1772518991877563",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2559.3713773354793, y = 271.19619439485},
            propsData = {
              VarName = "FengxiangBossFinish",
              VarValue = 1
            }
          },
          ["17727066414131488"] = {
            key = "17727066414131488",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1163.6021022825607, y = 449.2019273296363},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_JuqueBossBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17727066748822141"] = {
            key = "17727066748822141",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 2028.05265173311, y = 465.5865427142517},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "QuestPoint_Juque02BossBattle",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = false,
              IsWhite = false
            }
          },
          ["17727067132822627"] = {
            key = "17727067132822627",
            type = "BossBattleFinishNode",
            name = "BOSS战开始",
            pos = {x = 2003.3384931399635, y = 276.02425663183396},
            propsData = {
              SendMessage = "BossBattle02",
              FinishCondition = ""
            }
          },
          ["17727067132822628"] = {
            key = "17727067132822628",
            type = "BossBattleFinishNode",
            name = "BOSS战成功",
            pos = {x = 2290.6954703758847, y = 269.88739431085185},
            propsData = {
              SendMessage = "",
              FinishCondition = "BossJuque02_StoryEnd"
            }
          },
          ["17727067717123772"] = {
            key = "17727067717123772",
            type = "TalkNode",
            name = "对话节点",
            pos = {x = 1719.231267472209, y = 278.348272105169},
            propsData = {
              IsNpcNode = false,
              TalkType = "Cinematic",
              TalkStageName = "",
              ShowFilePath = "/Game/Asset/Cinematics/Story/Ver01/Ver0103/Ver0103_SC004/Ver0103_SC004",
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
          ["17743492683362471"] = {
            key = "17743492683362471",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 2839.696428571429, y = 283.375},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 2,
              IsStandAlone = true
            }
          },
          ["1774423736524482"] = {
            key = "1774423736524482",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 1162.3848039215686, y = 606.3387512899898},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/1_1/0123_boss_juque",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {105901},
              bStoreToServer = true
            }
          },
          ["1774423867834877113"] = {
            key = "1774423867834877113",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 3403.448045028288, y = 282.7228092610043},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          },
          ["1777360782359998"] = {
            key = "1777360782359998",
            type = "SetPhantomStatusNode",
            name = "设置魅影Buff",
            pos = {x = 1998.0460526315792, y = -31.500000000000135},
            propsData = {
              PhantomRoleId = 1504,
              BuffList = {
                {
                  Id = 903,
                  LastTime = -1,
                  Value = -1
                }
              }
            }
          },
          ["17773610334681729"] = {
            key = "17773610334681729",
            type = "SetPhantomStatusNode",
            name = "设置魅影Buff",
            pos = {x = 1994.296052631579, y = 90.99999999999991},
            propsData = {
              PhantomRoleId = 2301,
              BuffList = {
                {
                  Id = 903,
                  LastTime = -1,
                  Value = -1
                }
              }
            }
          },
          ["1777361675226928666"] = {
            key = "1777361675226928666",
            type = "RemovePhantomBuffsNode",
            name = "移除魅影Buff",
            pos = {x = 3124.7505980861247, y = 285.50909090909084},
            propsData = {
              PhantomRoleId = 1504,
              RemoveBuffs = {903}
            }
          },
          ["17773617782671855344"] = {
            key = "17773617782671855344",
            type = "RemovePhantomBuffsNode",
            name = "移除魅影Buff",
            pos = {x = 3125.5960526315794, y = 415.82727272727277},
            propsData = {
              PhantomRoleId = 2301,
              RemoveBuffs = {903}
            }
          },
          ["17780592214301772"] = {
            key = "17780592214301772",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1694.5, y = 73.67857142857122},
            propsData = {WaitTime = 2}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
