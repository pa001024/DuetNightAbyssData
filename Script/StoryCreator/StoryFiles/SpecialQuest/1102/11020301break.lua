return {
  storyName = "Home",
  storyDescription = "",
  lineData = {
    {
      startStory = "1781781035420294",
      startPort = "Success",
      endStory = "1781781035419290",
      endPort = "In"
    },
    {
      startStory = "1781781035419290",
      startPort = "Success",
      endStory = "1781781035419291",
      endPort = "In"
    },
    {
      startStory = "1781781035419291",
      startPort = "Success",
      endStory = "1781781035420292",
      endPort = "In"
    },
    {
      startStory = "1781781035420292",
      startPort = "Success",
      endStory = "1781781035420293",
      endPort = "In"
    },
    {
      startStory = "17817809794271",
      startPort = "StoryStart",
      endStory = "1781781035420294",
      endPort = "In"
    },
    {
      startStory = "1781781035420293",
      startPort = "Success",
      endStory = "17817809794285",
      endPort = "StoryEnd"
    }
  },
  storyNodeData = {
    ["17817809794271"] = {
      isStoryNode = true,
      key = "17817809794271",
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
    ["17817809794285"] = {
      isStoryNode = true,
      key = "17817809794285",
      type = "StoryEndNode",
      name = "StoryEnd",
      pos = {x = 1954.5454545454545, y = 463.6363636363636},
      propsData = {},
      questNodeData = {
        lineData = {},
        nodeData = {},
        commentData = {}
      }
    },
    ["1781781035419289"] = {
      isStoryNode = true,
      key = "1781781035419289",
      type = "StoryNode",
      name = "主线开启",
      pos = {x = 1085.5326332939185, y = -1006.0279378142081},
      propsData = {
        QuestId = 11020101,
        QuestDescriptionComment = "",
        QuestDescription = "Description_110201_01",
        QuestDeatil = "Content_110201_01",
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
        SubRegionId = 210101,
        SubRegionIdList = {},
        StoryGuideType = "Point",
        StoryGuidePointName = "QuestPoint_EX01",
        JumpId = 0,
        IsBacktrack = false
      },
      questNodeData = {
        lineData = {
          {
            startQuest = "1781781035427326",
            startPort = "Out",
            endQuest = "1781781035427329",
            endPort = "In"
          },
          {
            startQuest = "1781781035427328",
            startPort = "True",
            endQuest = "1781781035427327",
            endPort = "In"
          },
          {
            startQuest = "1781781035427330",
            startPort = "Out",
            endQuest = "1781781035427326",
            endPort = "In"
          },
          {
            startQuest = "1781781035427330",
            startPort = "Out",
            endQuest = "1781781035428332",
            endPort = "In"
          },
          {
            startQuest = "1781781035428332",
            startPort = "Out",
            endQuest = "1781781035428333",
            endPort = "In"
          },
          {
            startQuest = "1781781035428334",
            startPort = "false",
            endQuest = "1781781035427330",
            endPort = "In"
          },
          {
            startQuest = "1781781035427328",
            startPort = "False",
            endQuest = "1781781035426325",
            endPort = "Fail"
          },
          {
            startQuest = "1781781035426323",
            startPort = "QuestStart",
            endQuest = "1781781035428334",
            endPort = "In"
          },
          {
            startQuest = "1781781035428334",
            startPort = "true",
            endQuest = "1781781035428336",
            endPort = "In"
          },
          {
            startQuest = "1781781035428336",
            startPort = "Out",
            endQuest = "1781781035427326",
            endPort = "In"
          },
          {
            startQuest = "1781781035427329",
            startPort = "Out",
            endQuest = "1781781035428337",
            endPort = "In"
          },
          {
            startQuest = "1781781035428337",
            startPort = "Out",
            endQuest = "1781781035427328",
            endPort = "Input"
          },
          {
            startQuest = "1781781035429338",
            startPort = "Out",
            endQuest = "1781781035428335",
            endPort = "In"
          },
          {
            startQuest = "1781781035427331",
            startPort = "Out",
            endQuest = "1781781035429338",
            endPort = "In"
          },
          {
            startQuest = "1781781035428332",
            startPort = "Out",
            endQuest = "1781781035429340",
            endPort = "In"
          },
          {
            startQuest = "1781781035429340",
            startPort = "Out",
            endQuest = "1781781035427331",
            endPort = "In"
          },
          {
            startQuest = "1781781035427327",
            startPort = "Out",
            endQuest = "1781781035426324",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035426323"] = {
            key = "1781781035426323",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = -446.9230769230769, y = -328.3186813186813},
            propsData = {ModeType = 0}
          },
          ["1781781035426324"] = {
            key = "1781781035426324",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 3591.0872167048637, y = -438.7058170158016},
            propsData = {
              ModeType = 1,
              Id = 107001,
              StartIndex = 1,
              LoadingId = 0,
              IsWhite = false
            }
          },
          ["1781781035426325"] = {
            key = "1781781035426325",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 3668.3374378459516, y = 140.9306220095694},
            propsData = {}
          },
          ["1781781035427326"] = {
            key = "1781781035427326",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 752.8621800431962, y = -328.91726057758655},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1210081}
            }
          },
          ["1781781035427327"] = {
            key = "1781781035427327",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 3246.390812932347, y = -458.9268481012332},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1210081}
            }
          },
          ["1781781035427328"] = {
            key = "1781781035427328",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 2605.2414361037168, y = -292.73758727906136},
            propsData = {PopupId = 100110}
          },
          ["1781781035427329"] = {
            key = "1781781035427329",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1702.2117140948594, y = -318.6197854802973},
            propsData = {
              bActiveEnable = true,
              StaticCreatorIdList = {},
              QuestPickupId = -1,
              UnitId = 10052,
              UnitCount = 1,
              bGuideUIEnable = false,
              GuideType = "P",
              GuidePointName = "QuestPoint_EX01",
              IsUseCount = false
            }
          },
          ["1781781035427330"] = {
            key = "1781781035427330",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 259.8399872694731, y = 90.61741542976387},
            propsData = {
              StaticCreatorIdList = {},
              ManualItemIdList = {121001},
              StateId = 1500110,
              QuestId = 0
            }
          },
          ["1781781035427331"] = {
            key = "1781781035427331",
            type = "SwitchMechanismStateNode",
            name = "切换机关状态",
            pos = {x = 1579.847968495011, y = 187.18440234919885},
            propsData = {
              StaticCreatorIdList = {},
              ManualItemIdList = {121001},
              StateId = 1500111,
              QuestId = 0
            }
          },
          ["1781781035428332"] = {
            key = "1781781035428332",
            type = "GoToNode",
            name = "前往",
            pos = {x = 823.7715398294757, y = 86.60013978987749},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 1210124,
              GuideType = "M",
              GuidePointName = "Mechanism_Change_1210124"
            }
          },
          ["1781781035428333"] = {
            key = "1781781035428333",
            type = "CameraLookAtNode",
            name = "CameraLookAt",
            pos = {x = 1241.8170580367594, y = -26.493103568071785},
            propsData = {
              TargetType = "Point",
              PointName = "QuestPoint_EX01",
              ActorId = 0,
              Duration = 2,
              EasingFunc = 4,
              bDisableUserInput = true
            }
          },
          ["1781781035428334"] = {
            key = "1781781035428334",
            type = "ExecuteBlueprintFunctionCheckVarNode",
            name = "执行变量检测函数",
            pos = {x = -79.62448100594656, y = -340.07721583628614},
            propsData = {
              FunctionName = "Equal",
              VarName = "Entrance110101",
              Duration = 0,
              VarInfos = {
                {VarName = "Value", VarValue = "1"}
              }
            }
          },
          ["1781781035428335"] = {
            key = "1781781035428335",
            type = "SetVarNode",
            name = "设置变量值",
            pos = {x = 2294.0463508920516, y = 107.59233217091523},
            propsData = {
              VarName = "Entrance110101",
              VarValue = 1
            }
          },
          ["1781781035428336"] = {
            key = "1781781035428336",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 267.979820875719, y = -339.03676470588266},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035428337"] = {
            key = "1781781035428337",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2068.828560371517, y = -312.9963235294122},
            propsData = {
              IsShow = false,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035429338"] = {
            key = "1781781035429338",
            type = "ShowOrHideTaskIndicatorNode",
            name = "显示/隐藏任务指引点节点",
            pos = {x = 2015.4952270381843, y = 91.17034313725443},
            propsData = {
              IsShow = true,
              bOpenRangeEffect = false,
              GuideType = "P",
              GuideName = "QuestPoint_EX01"
            }
          },
          ["1781781035429339"] = {
            key = "1781781035429339",
            type = "CollisionBoxNode",
            name = "进入/离开判定盒节点",
            pos = {x = 1108.2544243625987, y = -910.1246393206114},
            propsData = {StaticCreatorId = 1210124}
          },
          ["1781781035429340"] = {
            key = "1781781035429340",
            type = "WaitOfTimeNode",
            name = "延迟等待",
            pos = {x = 1260.2399670734087, y = 192.0606423333836},
            propsData = {WaitTime = 1}
          },
          ["1781781035429341"] = {
            key = "1781781035429341",
            type = "WaitingMechanismEnterStateNode",
            name = "等待机关进入状态",
            pos = {x = 1621.2939131273545, y = -89.03825876551758},
            propsData = {
              CreateType = "ManualItem",
              CreateId = 121001,
              StateId = 1500112,
              IsGuideEnable = false,
              GuidePointName = ""
            }
          },
          ["1781781035429342"] = {
            key = "1781781035429342",
            type = "WaitingSpecialQuestStartAndFinishNode",
            name = "等待特殊任务开始并完成",
            pos = {x = 3228.660827207299, y = -891.1281809432107},
            propsData = {SpecialConfigId = 11020101, BlackScreenImmediately = false}
          },
          ["1781781035429343"] = {
            key = "1781781035429343",
            type = "SkipRegionNode",
            name = "送回据点",
            pos = {x = 3797.3073934788554, y = -823.9426690866454},
            propsData = {
              ModeType = 1,
              Id = 210101,
              StartIndex = 1,
              IsWhite = true
            }
          },
          ["1781781035430344"] = {
            key = "1781781035430344",
            type = "AsyncSetActorLocationAndRotationNode",
            name = "异步设置玩家位置旋转",
            pos = {x = 3540.820762678762, y = -829.3443602915258},
            propsData = {
              UnitId = 0,
              NewTargetPointName = "ex02a_tp_rebirth01",
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
    ["1781781035419290"] = {
      isStoryNode = true,
      key = "1781781035419290",
      type = "StoryNode",
      name = "采集",
      pos = {x = 1726.0631643570175, y = 250.086442634052},
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
            startQuest = "1781781035443422",
            startPort = "QuestStart",
            endQuest = "1781781035443425",
            endPort = "In"
          },
          {
            startQuest = "1781781035443425",
            startPort = "Out",
            endQuest = "1781781035443426",
            endPort = "In"
          },
          {
            startQuest = "1781781035443426",
            startPort = "Out",
            endQuest = "1781781035443423",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035443422"] = {
            key = "1781781035443422",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781781035443423"] = {
            key = "1781781035443423",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1902, y = 288},
            propsData = {ModeType = 0}
          },
          ["1781781035443424"] = {
            key = "1781781035443424",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781781035443425"] = {
            key = "1781781035443425",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1172, y = 280},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781781035443426"] = {
            key = "1781781035443426",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1562, y = 282},
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
          }
        },
        commentData = {}
      }
    },
    ["1781781035419291"] = {
      isStoryNode = true,
      key = "1781781035419291",
      type = "StoryNode",
      name = "点燃篝火",
      pos = {x = 2025.359011749888, y = 250.9381186582384},
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
            startQuest = "1781781035446440",
            startPort = "QuestStart",
            endQuest = "1781781035446443",
            endPort = "In"
          },
          {
            startQuest = "1781781035446443",
            startPort = "Out",
            endQuest = "1781781035447444",
            endPort = "In"
          },
          {
            startQuest = "1781781035447446",
            startPort = "True",
            endQuest = "1781781035447445",
            endPort = "In"
          },
          {
            startQuest = "1781781035447444",
            startPort = "Out",
            endQuest = "1781781035447446",
            endPort = "Input"
          },
          {
            startQuest = "1781781035447445",
            startPort = "Out",
            endQuest = "1781781035446441",
            endPort = "Success"
          },
          {
            startQuest = "1781781035447446",
            startPort = "False",
            endQuest = "1781781035446442",
            endPort = "Fail"
          }
        },
        nodeData = {
          ["1781781035446440"] = {
            key = "1781781035446440",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781781035446441"] = {
            key = "1781781035446441",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781781035446442"] = {
            key = "1781781035446442",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781781035446443"] = {
            key = "1781781035446443",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1170, y = 280},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781781035447444"] = {
            key = "1781781035447444",
            type = "PickUpNode",
            name = "拾取物品",
            pos = {x = 1516, y = 280},
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
          ["1781781035447445"] = {
            key = "1781781035447445",
            type = "ChangeStaticCreatorNode",
            name = "生成/销毁节点",
            pos = {x = 2342.5101080671266, y = 296.75164288083954},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {1210081}
            }
          },
          ["1781781035447446"] = {
            key = "1781781035447446",
            type = "ShowPopupUINode",
            name = "显示弹窗",
            pos = {x = 1936.4898919328734, y = 261.74835711916046},
            propsData = {PopupId = 100110}
          }
        },
        commentData = {}
      }
    },
    ["1781781035420292"] = {
      isStoryNode = true,
      key = "1781781035420292",
      type = "StoryNode",
      name = "篝火聊天",
      pos = {x = 2315.099719647258, y = 243.98159554383233},
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
            startQuest = "1781781035451469",
            startPort = "QuestStart",
            endQuest = "1781781035451472",
            endPort = "In"
          },
          {
            startQuest = "1781781035451472",
            startPort = "Out",
            endQuest = "1781781035451473",
            endPort = "In"
          },
          {
            startQuest = "1781781035451473",
            startPort = "Out",
            endQuest = "1781781035451470",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035451469"] = {
            key = "1781781035451469",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781781035451470"] = {
            key = "1781781035451470",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1676.764705882353, y = 289.77941176470586},
            propsData = {ModeType = 0}
          },
          ["1781781035451471"] = {
            key = "1781781035451471",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781781035451472"] = {
            key = "1781781035451472",
            type = "TalkNode",
            name = "【Ex02_FixSimple_23】：主角和法露茜交心",
            pos = {x = 1086, y = 294},
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
          ["1781781035451473"] = {
            key = "1781781035451473",
            type = "TalkNode",
            name = "【Ex02_FixSimple_24】：第二天醒来",
            pos = {x = 1369.388888888889, y = 291.5277777777778},
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
          }
        },
        commentData = {}
      }
    },
    ["1781781035420293"] = {
      isStoryNode = true,
      key = "1781781035420293",
      type = "StoryNode",
      name = "前往村庄",
      pos = {x = 1361.6511359541835, y = 422.5550871354751},
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
            startQuest = "1781781035455494",
            startPort = "Out",
            endQuest = "1781781035455495",
            endPort = "In"
          },
          {
            startQuest = "1781781035454491",
            startPort = "QuestStart",
            endQuest = "1781781035455494",
            endPort = "In"
          },
          {
            startQuest = "1781781035454491",
            startPort = "QuestStart",
            endQuest = "1781781035455496",
            endPort = "In"
          },
          {
            startQuest = "1781781035455495",
            startPort = "Out",
            endQuest = "1781781035455497",
            endPort = "In"
          },
          {
            startQuest = "1781781035455497",
            startPort = "Out",
            endQuest = "1781781035455498",
            endPort = "In"
          },
          {
            startQuest = "1781781035455498",
            startPort = "Out",
            endQuest = "1781781035456499",
            endPort = "In"
          },
          {
            startQuest = "1781781035456499",
            startPort = "Out",
            endQuest = "1781781035455492",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035454491"] = {
            key = "1781781035454491",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 818, y = 322},
            propsData = {ModeType = 0}
          },
          ["1781781035455492"] = {
            key = "1781781035455492",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 2798.9285714285716, y = 372.8571428571429},
            propsData = {ModeType = 0}
          },
          ["1781781035455493"] = {
            key = "1781781035455493",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781781035455494"] = {
            key = "1781781035455494",
            type = "GoToNode",
            name = "前往",
            pos = {x = 1227.4208074534158, y = 317.07220496894416},
            propsData = {
              GuideUIEnable = true,
              StaticCreatorId = 0,
              GuideType = "N",
              GuidePointName = ""
            }
          },
          ["1781781035455495"] = {
            key = "1781781035455495",
            type = "TalkNode",
            name = "【Ex02_FixSimple_25】：到回村子的路",
            pos = {x = 1535.2934782608697, y = 336.07065217391306},
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
          ["1781781035455496"] = {
            key = "1781781035455496",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇&法露茜",
            pos = {x = 1204.5, y = 145},
            propsData = {
              ActiveEnable = true,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781781035455497"] = {
            key = "1781781035455497",
            type = "ChangeStaticCreatorNode",
            name = "销毁伊薇&法露茜",
            pos = {x = 1933.076354679803, y = 342.2142857142858},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781781035455498"] = {
            key = "1781781035455498",
            type = "ChangeStaticCreatorNode",
            name = "生成伊薇&法露茜",
            pos = {x = 2220.219211822661, y = 343.28571428571433},
            propsData = {
              ActiveEnable = false,
              EnableBlackScreenSync = false,
              EnableFadeIn = false,
              EnableFadeOut = false,
              NewTargetPointName = "",
              StaticCreatorIdList = {}
            }
          },
          ["1781781035456499"] = {
            key = "1781781035456499",
            type = "GoToNode",
            name = "前往",
            pos = {x = 2501.290640394089, y = 345.4285714285714},
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
    },
    ["1781781035420294"] = {
      isStoryNode = true,
      key = "1781781035420294",
      type = "StoryNode",
      name = "到达湖边树林",
      pos = {x = 1367.0887944565693, y = 244.58727038408801},
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
            startQuest = "1781781035460528",
            startPort = "QuestStart",
            endQuest = "1781781035461531",
            endPort = "In"
          },
          {
            startQuest = "1781781035461531",
            startPort = "Out",
            endQuest = "1781781035461532",
            endPort = "In"
          },
          {
            startQuest = "1781781035461532",
            startPort = "Out",
            endQuest = "1781781035460529",
            endPort = "Success"
          }
        },
        nodeData = {
          ["1781781035460528"] = {
            key = "1781781035460528",
            type = "QuestStartNode",
            name = "QuestStart",
            pos = {x = 800, y = 300},
            propsData = {ModeType = 0}
          },
          ["1781781035460529"] = {
            key = "1781781035460529",
            type = "QuestSuccessNode",
            name = "QuestSuccess",
            pos = {x = 1878.8235294117644, y = 284.11764705882354},
            propsData = {ModeType = 0}
          },
          ["1781781035460530"] = {
            key = "1781781035460530",
            type = "QuestFailNode",
            name = "QuestFail",
            pos = {x = 2800, y = 700},
            propsData = {}
          },
          ["1781781035461531"] = {
            key = "1781781035461531",
            type = "TalkNode",
            name = "【Ex02_FixSimple_21】：主角醒来",
            pos = {x = 1182.1402714932126, y = 284.0904977375565},
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
          ["1781781035461532"] = {
            key = "1781781035461532",
            type = "TalkNode",
            name = "【Ex02_FixSimple_22】：与法露茜交互",
            pos = {x = 1549.2059092867914, y = 286.8073691014867},
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
          }
        },
        commentData = {}
      }
    }
  },
  commentData = {}
}
