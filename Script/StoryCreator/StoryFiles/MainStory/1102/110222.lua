return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "17697590104531329025",
      startPort = "StoryStart",
      endStory = "17697590104531329027",
      endPort = "In"
    },
    {
      startStory = "17697590104531329027",
      startPort = "Success",
      endStory = "17822844037672147674",
      endPort = "In"
    },
    {
      startStory = "17822844037672147674",
      startPort = "Success",
      endStory = "178236937773715151991",
      endPort = "In"
    },
    {
      startStory = "17834237844393276585",
      startPort = "Success",
      endStory = "17697590104531329026",
      endPort = "StoryEnd"
    },
    {
      startStory = "178236937773715151991",
      startPort = "Success",
      endStory = "17850663290143334526",
      endPort = "In"
    },
    {
      startStory = "17850663290143334526",
      startPort = "Transport",
      endStory = "17834237844393276585",
      endPort = "In"
    },
    {
      startStory = "17850663290143334526",
      startPort = "Distransport",
      endStory = "17858139677641673754",
      endPort = "In"
    },
    {
      startStory = "17858139677641673754",
      startPort = "Success",
      endStory = "17697590104531329026",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17697590104531329025"] = {
      isStoryNode = true,
      key = "17697590104531329025",
      type = "StoryStartNode",
      name = "StoryStart",
      pos = {x = 814, y = 322},
      propsData = {QuestChainId = 110222},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531329026"] = {
      isStoryNode = true,
      key = "17697590104531329026",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 2967.520630710286, y = 383.55165045682287},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["17697590104531329027"] = {
      isStoryNode = true,
      key = "17697590104531329027",
      type = "StoryNode",
      name = "武器探索",
      pos = {x = 1123.1724137931035, y = 310.7413793103448},
      propsData = {
        QuestId = 11022201,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110222_01",
        QuestDeatil = "Content_110222_01",
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
        SubRegionId = 107201,
        SubRegionIdList = {},
        StoryGuideType = "Mechanism",
        StoryGuidePointName = "Mechanism_goto_avengerstart_142800028",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17822224497751808",
            startPort = "Success",
            endQuest = "17697590104531329029",
            endPort = "Success"
          },
          {
            startQuest = "17697590104531329028",
            startPort = "QuestStart",
            endQuest = "17822234240343447",
            endPort = "In"
          },
          {
            startQuest = "17822234240343447",
            startPort = "Out",
            endQuest = "17822224497751808",
            endPort = "In"
          },
          {
            startQuest = "17822240203701075669",
            startPort = "Out",
            endQuest = "17697590104531329030",
            endPort = "Fail"
          },
          {
            startQuest = "17822224497751808",
            startPort = "Fail",
            endQuest = "17822240203701075669",
            endPort = "In"
          },
          {
            startQuest = "17822224497751808",
            startPort = "PassiveFail",
            endQuest = "17822240203701075669",
            endPort = "In"
          }
        },
        nodeData = {
          ["17697590104531329028"] = {
            key = "17697590104531329028",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 561.4285714285714, y = 278.57142857142856},
            propsData = {ModeType = 0}
          },
          ["17697590104531329029"] = {
            key = "17697590104531329029",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2058.5263157894738, y = 213.05263157894737},
            propsData = {
              ModeType = 1,
              Id = 107401,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17697590104531329030"] = {
            key = "17697590104531329030",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2070.625, y = 589.375},
            propsData = {}
          },
          ["17697590104531329031"] = {
            key = "17697590104531329031",
            type = "GoToNode",
            name = "抵达山脚处",
            pos = {x = 1501.7142857142858, y = -30.28571428571432},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 1930182,
              GuideType = "P",
              GuidePointName = "QuestPoint_12010608"
            }
          },
          ["17822224497751808"] = {
            key = "17822224497751808",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1312.07224025974, y = 227.47213203463215},
            propsData = {SpecialConfigId = 11022201, BlackScreenImmediately = true}
          },
          ["17822234240343447"] = {
            key = "17822234240343447",
            type = "GoToNode",
            name = "前往",
            pos = {x = 933.0603890362514, y = 207.6266041429834},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 142800028,
              GuideType = "M",
              GuidePointName = "Mechanism_goto_avengerstart_142800028"
            }
          },
          ["17822238585231074390"] = {
            key = "17822238585231074390",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 998.4255980072957, y = 439.95359751574335},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 0,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17822240203701075669"] = {
            key = "17822240203701075669",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 1789.679344806057, y = 511.32727845770944},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 3,
              IsWhite = false
            }
          }
        },
        commentData = {}
      }
    },
    ["17822844037672147674"] = {
      isStoryNode = true,
      key = "17822844037672147674",
      type = "StoryNode",
      name = "龙沙要塞",
      pos = {x = 1500.196956745081, y = 291.9029419390261},
      propsData = {
        QuestId = 11022202,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110222_02",
        QuestDeatil = "Content_110222_02",
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
        IsFairyLand = true,
        SubRegionId = 107401,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "22_tp_rebirth01",
        JumpId = 0,
        IsBacktrack = false,
        FairyLandStaticCreatorId = 0,
        FairyLandDeliverIndex = 1
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "17822844037682147675",
            startPort = "QuestStart",
            endQuest = "17822844494092148538",
            endPort = "In"
          },
          {
            startQuest = "17822844494092148538",
            startPort = "Success",
            endQuest = "17822844037682147678",
            endPort = "Success"
          },
          {
            startQuest = "17822850778223221773",
            startPort = "Out",
            endQuest = "17822844037682147681",
            endPort = "Fail"
          },
          {
            startQuest = "17834230151241637387",
            startPort = "Out",
            endQuest = "17834230151241637386",
            endPort = "In"
          },
          {
            startQuest = "17834230151241637386",
            startPort = "Out",
            endQuest = "17834230151241637385",
            endPort = "In"
          },
          {
            startQuest = "17834230151241637385",
            startPort = "Out",
            endQuest = "17834230151241637384",
            endPort = "In"
          },
          {
            startQuest = "17834230151241637384",
            startPort = "Out",
            endQuest = "17834230151241637383",
            endPort = "In"
          },
          {
            startQuest = "17834230151241637383",
            startPort = "Out",
            endQuest = "17834230151241637388",
            endPort = "In"
          },
          {
            startQuest = "17822844494092148538",
            startPort = "Fail",
            endQuest = "17834230151241637387",
            endPort = "In"
          },
          {
            startQuest = "17834230151241637388",
            startPort = "Out",
            endQuest = "17822850778223221773",
            endPort = "In"
          }
        },
        nodeData = {
          ["17822844037682147675"] = {
            key = "17822844037682147675",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17822844037682147678"] = {
            key = "17822844037682147678",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 2,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17822844037682147681"] = {
            key = "17822844037682147681",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17822844494092148538"] = {
            key = "17822844494092148538",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 1678.357142857143, y = 200.99999999999997},
            propsData = {SpecialConfigId = 11022202, BlackScreenImmediately = true}
          },
          ["17822850778223221773"] = {
            key = "17822850778223221773",
            type = "SkipRegionNode",
            name = "跨区域传送设置玩家位置",
            pos = {x = 2335.052466496352, y = 579.140021614093},
            propsData = {
              ModeType = 1,
              Id = 107201,
              StartIndex = 1,
              IsWhite = false
            }
          },
          ["17834230151241637383"] = {
            key = "17834230151241637383",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 1994.5661669191666, y = 588.0068704915345},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "EnergySkill",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17834230151241637384"] = {
            key = "17834230151241637384",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2027.3228160671201, y = 728.1554610314292},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Map",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17834230151241637385"] = {
            key = "17834230151241637385",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2026.891372351923, y = 872.1602871295614},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "GuideBook",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17834230151241637386"] = {
            key = "17834230151241637386",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2069.1395947177925, y = 1000.2483518426262},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "Entrance",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17834230151241637387"] = {
            key = "17834230151241637387",
            type = "ShowOrHideUINode",
            name = "显示或隐藏UI",
            pos = {x = 2012.9170133775642, y = 1133.7019537962283},
            propsData = {
              Function = "HideUIInScreen",
              UIParam = "BattleWheel",
              ActionParam = "SpiralLeap",
              ShowOrHide = false
            }
          },
          ["17834230151241637388"] = {
            key = "17834230151241637388",
            type = "ActivePlayerSkillsNode",
            name = "激活/失效 玩家技能",
            pos = {x = 1991.0528806998811, y = 451.34286413094276},
            propsData = {
              PlayerId = 0,
              bActiveEnable = true,
              ActiveType = "Lock",
              SkillNameList = {"BulletJump", "Slide"}
            }
          }
        },
        commentData = {}
      }
    },
    ["178236937773715151991"] = {
      isStoryNode = true,
      key = "178236937773715151991",
      type = "StoryNode",
      name = "现实法露茜对话",
      pos = {x = 1834.392857142857, y = 281.9258241758241},
      propsData = {
        QuestId = 11022203,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110222_03",
        QuestDeatil = "Content_110222_03",
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
            startQuest = "178236945837715153020",
            startPort = "Out",
            endQuest = "178236949314315153426",
            endPort = "In"
          },
          {
            startQuest = "178236937773715151992",
            startPort = "QuestStart",
            endQuest = "17834235409463272997",
            endPort = "In"
          },
          {
            startQuest = "17834235409463272997",
            startPort = "Out",
            endQuest = "178236945837715153020",
            endPort = "In"
          },
          {
            startQuest = "178236937773715151992",
            startPort = "QuestStart",
            endQuest = "17880600227053352327",
            endPort = "In"
          },
          {
            startQuest = "178236949314315153426",
            startPort = "Out",
            endQuest = "17880600727063352854",
            endPort = "In"
          },
          {
            startQuest = "17880600727063352854",
            startPort = "Out",
            endQuest = "178236937773815151995",
            endPort = "Success"
          }
        },
        nodeData = {
          ["178236937773715151992"] = {
            key = "178236937773715151992",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 538, y = 258},
            propsData = {ModeType = 0}
          },
          ["178236937773815151995"] = {
            key = "178236937773815151995",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2431.4285714285716, y = 310.42857142857144},
            propsData = {ModeType = 0}
          },
          ["178236937773815151998"] = {
            key = "178236937773815151998",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178236945837715153020"] = {
            key = "178236945837715153020",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 1351.8092105263158, y = 331.26315789473676},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "TargetPoint_fanhui",
              FadeIn = false,
              FadeOut = false,
              bResetCamera = true,
              bForceAsyncLoading = true,
              IsWhite = false
            }
          },
          ["178236949314315153426"] = {
            key = "178236949314315153426",
            type = "TalkNode",
            name = "【Ex02_FixSimple_C7_04】法露茜醒来",
            pos = {x = 1713.9144736842106, y = 341.8947368421052},
            propsData = {
              IsNpcNode = false,
              bUseFlowAssetActors = true,
              FirstDialogueId = 0,
              FlowAssetPath = "DialogueAsset'/Game/Dialogue/MainStory/1102/110222/11022204.11022204'",
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
          ["17834235409463272997"] = {
            key = "17834235409463272997",
            type = "GoToRegionNode",
            name = "进入区域",
            pos = {x = 938, y = 278},
            propsData = {
              RegionType = 1,
              IsEnter = "Enter",
              RegionId = 107201,
              bGuideUIEnable = false,
              GuideType = "P",
              GuideName = ""
            }
          },
          ["17880600227053352327"] = {
            key = "17880600227053352327",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 900.3333333333333, y = 72.00000000000004},
            propsData = {
              SoundStateType = 0,
              SoundPriority = 0,
              SoundType = 0,
              SoundPath = "event:/bgm/mute",
              ParamKey = "",
              ParamValue = 0,
              RelatedRegionId = {107201},
              bStoreToServer = true
            }
          },
          ["17880600727063352854"] = {
            key = "17880600727063352854",
            type = "PlayOrStopBGMNode",
            name = "BGM节点",
            pos = {x = 2027, y = 325.33333333333366},
            propsData = {
              SoundStateType = 3,
              SoundPriority = 0,
              SoundType = 0
            }
          }
        },
        commentData = {}
      }
    },
    ["17834237844393276585"] = {
      isStoryNode = true,
      key = "17834237844393276585",
      type = "StoryNode",
      name = "传送",
      pos = {x = 2595.1969142874036, y = 154.19345328584424},
      propsData = {
        QuestId = 11022205,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17834237844393276595",
            startPort = "QuestStart",
            endQuest = "178671670064220074706",
            endPort = "Input"
          },
          {
            startQuest = "178671670064220074706",
            startPort = "Out",
            endQuest = "17834237844393276596",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17834237844393276595"] = {
            key = "17834237844393276595",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17834237844393276596"] = {
            key = "17834237844393276596",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 3,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["17834237844393276597"] = {
            key = "17834237844393276597",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["178671670064220074706"] = {
            key = "178671670064220074706",
            type = "StandAloneBlackScreenNode",
            name = "独立黑屏节点",
            pos = {x = 1668, y = 332},
            propsData = {
              FadeInSeconds = 0,
              FadeOutSeconds = 0,
              DurationSeconds = 1,
              IsStandAlone = true
            }
          }
        },
        commentData = {}
      }
    },
    ["17850663290143334526"] = {
      isStoryNode = true,
      key = "17850663290143334526",
      type = "StoryNode",
      name = "弹窗传送",
      pos = {x = 2170.8660777437667, y = 260.1479331690429},
      propsData = {
        QuestId = 11022204,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17850663330893334649",
            startPort = "True",
            endQuest = "17850663330893334650",
            endPort = "In"
          },
          {
            startQuest = "17850663330893334649",
            startPort = "False",
            endQuest = "17850663330893334651",
            endPort = "In"
          },
          {
            startQuest = "17850663290143334527",
            startPort = "QuestStart",
            endQuest = "17850663330893334649",
            endPort = "Input"
          }
        },
        nodeData = {
          ["17850663290143334527"] = {
            key = "17850663290143334527",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17850663290143334530"] = {
            key = "17850663290143334530",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17850663290143334533"] = {
            key = "17850663290143334533",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17850663330893334649"] = {
            key = "17850663330893334649",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1413.0625, y = 242.875},
            propsData = {PopupId = 100422}
          },
          ["17850663330893334650"] = {
            key = "17850663330893334650",
            type = "QuestConditionNode",
            name = "传送",
            pos = {x = 1774.9375, y = 107},
            propsData = {PortName = "Transport"}
          },
          ["17850663330893334651"] = {
            key = "17850663330893334651",
            type = "QuestConditionNode",
            name = "不传送",
            pos = {x = 1784.9375, y = 317},
            propsData = {
              PortName = "Distransport"
            }
          }
        },
        commentData = {}
      }
    },
    ["17858139677641673754"] = {
      isStoryNode = true,
      key = "17858139677641673754",
      type = "StoryNode",
      name = "传送",
      pos = {x = 2587.847239415174, y = 390.4806306449673},
      propsData = {
        QuestId = 11022206,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110221_01",
        QuestDeatil = "Content_110221_01",
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
            startQuest = "17858139677641673759",
            startPort = "QuestStart",
            endQuest = "17858139677641673762",
            endPort = "In"
          },
          {
            startQuest = "17858139677641673762",
            startPort = "Out",
            endQuest = "17858139677641673760",
            endPort = "Success"
          }
        },
        nodeData = {
          ["17858139677641673759"] = {
            key = "17858139677641673759",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17858139677641673760"] = {
            key = "17858139677641673760",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["17858139677641673761"] = {
            key = "17858139677641673761",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["17858139677641673762"] = {
            key = "17858139677641673762",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1680, y = 284},
            propsData = {WaitTime = 1}
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
