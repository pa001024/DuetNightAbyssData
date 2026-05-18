return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "177763208104067916158",
      startPort = "StoryStart",
      endStory = "177763208602367916190",
      endPort = "In"
    },
    {
      startStory = "177763208602367916190",
      startPort = "Success",
      endStory = "177763208104067916161",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["177763208104067916158"] = {
      isStoryNode = true,
      key = "177763208104067916158",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 1126.7857142857142, y = 258.2142857142857},
      propsData = {QuestChainId = 0},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177763208104067916161"] = {
      isStoryNode = true,
      key = "177763208104067916161",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1913.3311688311687, y = 291.6038961038961},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["177763208602367916190"] = {
      isStoryNode = true,
      key = "177763208602367916190",
      type = "StoryNode",
      name = "追逐战",
      pos = {x = 1462.357841604557, y = 278.7808302109005},
      propsData = {
        QuestId = 0,
        QuestDescriptionComment = "",
        QuestDescription = "Content_10040210_01",
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
            startQuest = "177763208602967916231",
            startPort = "Out",
            endQuest = "177763208603067916232",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916232",
            startPort = "Out",
            endQuest = "177763208603067916235",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916235",
            startPort = "Out",
            endQuest = "177763208603067916233",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916233",
            startPort = "Out",
            endQuest = "177763208603067916237",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916237",
            startPort = "Out",
            endQuest = "177763208603067916236",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916236",
            startPort = "Out",
            endQuest = "177763208603067916234",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916240",
            startPort = "Out",
            endQuest = "177763208602967916231",
            endPort = "In"
          },
          {
            startQuest = "177763208602967916227",
            startPort = "QuestStart",
            endQuest = "177763503297886561220",
            endPort = "In"
          },
          {
            startQuest = "177763503297886561220",
            startPort = "Out",
            endQuest = "177763208602967916229",
            endPort = "Fail"
          },
          {
            startQuest = "177763208602967916227",
            startPort = "QuestStart",
            endQuest = "177763791920797748499",
            endPort = "In"
          },
          {
            startQuest = "177763811398499611970",
            startPort = "true",
            endQuest = "177763808527098680864",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916234",
            startPort = "Out",
            endQuest = "17777194969779353462",
            endPort = "In"
          },
          {
            startQuest = "17777194969779353462",
            startPort = "Out",
            endQuest = "177763794296297749297",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916234",
            startPort = "Out",
            endQuest = "17777195849259354119",
            endPort = "In"
          },
          {
            startQuest = "177763208602967916227",
            startPort = "QuestStart",
            endQuest = "177771975867811220629",
            endPort = "Input"
          },
          {
            startQuest = "177763208602967916227",
            startPort = "QuestStart",
            endQuest = "177763208603067916239",
            endPort = "In"
          },
          {
            startQuest = "177763208603067916239",
            startPort = "Out",
            endQuest = "177763811398499611970",
            endPort = "In"
          },
          {
            startQuest = "177763808527098680864",
            startPort = "Out",
            endQuest = "177763208603067916240",
            endPort = "In"
          },
          {
            startQuest = "177763811398499611970",
            startPort = "false",
            endQuest = "177763208603067916240",
            endPort = "In"
          },
          {
            startQuest = "177763208602967916227",
            startPort = "QuestStart",
            endQuest = "177850473527311198720",
            endPort = "In"
          },
          {
            startQuest = "177850473527311198720",
            startPort = "Out",
            endQuest = "177763208602967916229",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["177763208602967916227"] = {
            key = "177763208602967916227",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -709.0710594805126, y = 249.43944284408258},
            propsData = {ModeType = 0}
          },
          ["177763208602967916228"] = {
            key = "177763208602967916228",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2673.7825332562174, y = 738.2637362637363},
            propsData = {
              ModeType = 1,
              Id = 106001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["177763208602967916229"] = {
            key = "177763208602967916229",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 1500, y = 935},
            propsData = {}
          },
          ["177763208602967916231"] = {
            key = "177763208602967916231",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1334, y = 240},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480163,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ02_272480163"
            }
          },
          ["177763208603067916232"] = {
            key = "177763208603067916232",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1636, y = 212},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480164,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ03_272480164"
            }
          },
          ["177763208603067916233"] = {
            key = "177763208603067916233",
            type = "GoToNode",
            name = "前往",
            pos = {x = 850, y = 594},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480166,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ05_272480166"
            }
          },
          ["177763208603067916234"] = {
            key = "177763208603067916234",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1795.1571906354516, y = 594.6153846153846},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480169,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ08_272480169"
            }
          },
          ["177763208603067916235"] = {
            key = "177763208603067916235",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2022, y = 188},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480165,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ04_272480165"
            }
          },
          ["177763208603067916236"] = {
            key = "177763208603067916236",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1384, y = 578},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480168,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ07_272480168"
            }
          },
          ["177763208603067916237"] = {
            key = "177763208603067916237",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1126.5714285714287, y = 586},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480167,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZ06_272480167"
            }
          },
          ["177763208603067916239"] = {
            key = "177763208603067916239",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = -148.00065908433905, y = 182.25462449868039},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "BP_ZZZstart",
              FadeIn = false,
              FadeOut = true,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["177763208603067916240"] = {
            key = "177763208603067916240",
            type = "GoToNode",
            name = "前往",
            pos = {x = 913.1956088428185, y = 199.61038025247996},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 272480179,
              GuideType = "M",
              GuidePointName = "Mechanism_ZZZStart_272480179"
            }
          },
          ["177763503297886561220"] = {
            key = "177763503297886561220",
            type = "WaitingSpecialQuestFailNode",
            name = "等待特殊任务失败",
            pos = {x = 7.516242652667415, y = 814.4359684377183},
            propsData = {}
          },
          ["177763791920797748499"] = {
            key = "177763791920797748499",
            type = "ChangeRoleNode",
            name = "切换角色",
            pos = {x = 48.11266489041071, y = -151.5757780231463},
            propsData = {QuestRoleId = 16010201, IsPlayFX = false}
          },
          ["177763794296297749297"] = {
            key = "177763794296297749297",
            type = "SpecialQuestSuccessNode",
            name = "成功完成特殊任务",
            pos = {x = 2350.5566770186338, y = 617.6086691086691},
            propsData = {}
          },
          ["177763808527098680864"] = {
            key = "177763808527098680864",
            type = "TalkNode",
            name = "希尔妲救场后站桩",
            pos = {x = 547.7354412368716, y = 48.23587085429202},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 10010101,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1004/10042501.10042501'",
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
          ["177763811398499611970"] = {
            key = "177763811398499611970",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = 169.24667885508842, y = 173.63058769351693},
            propsData = {
              FunctionName = "Equal",
              VarName = "FirstStateDixiaZZZ100402",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["17777194969779353462"] = {
            key = "17777194969779353462",
            type = "PickUpInteractiveNode",
            name = "任务交互",
            pos = {x = 2078.458231382144, y = 615.5298011167577},
            propsData = {
              StaticCreatorId = 272890086,
              UnitId = 10095,
              bGuideUIEnable = true,
              GuidePointName = "BP_ZZZGotoYT",
              LongPressTime = 0,
              MontageName = "",
              bFocusEnable = false,
              SequencePath = ""
            }
          },
          ["17777195849259354119"] = {
            key = "17777195849259354119",
            type = "UpdateTaskBarAndTaskMainNode",
            name = "更新任务目标节点",
            pos = {x = 2091.315374239287, y = 458.38694397390054},
            propsData = {
              NewDescription = "Content_10040211_01",
              NewDetail = "",
              SubTaskTargetIndex = 0
            }
          },
          ["177771975867811220629"] = {
            key = "177771975867811220629",
            type = "SetTimeOfDayNode",
            name = "设置TOD",
            pos = {x = -115.68421052631578, y = -374},
            propsData = {
              TargetTime = 17,
              NeedLerp = false,
              LerpTime = 0,
              StopTimeElapse = false
            }
          },
          ["177850473527311198720"] = {
            key = "177850473527311198720",
            type = "CountdownNode",
            name = "倒计时节点",
            pos = {x = 493.3032036613271, y = 1099.1018306636156},
            propsData = {
              CountdownSeconds = 300,
              OpenUI = true,
              Text = "Quest_Tips_10040402",
              RedCountdownSeconds = 300
            }
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
